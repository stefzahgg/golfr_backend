module Api
  # Controller that handles authorization and user data fetching
  class UsersController < ApplicationController
    include Devise::Controllers::Helpers

    def login
      user = User.find_by('lower(email) = ?', params[:email])

      if user.blank? || !user.valid_password?(params[:password])
        render json: {
          errors: [
            'Invalid email/password combination'
          ]
        }, status: :unauthorized
        return
      end

      sign_in(:user, user)

      render json: {
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          token: current_token
        }
      }.to_json
    end

    def show
      current_user = User.find_by(id: params[:id])

      if current_user == nil
        render json: {
          errors: [
            'User not found'
          ]
        }, status: :not_found
        return
      end

      render json: {
        user: {
          id: current_user.id,
          email: current_user.email,
          name: current_user.name,
          scores: current_user.scores.map(&:serialize)
        }
      }.to_json
    end
  end
end
