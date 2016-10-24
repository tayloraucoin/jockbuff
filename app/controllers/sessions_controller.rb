require 'byebug'

class SessionsController < ApplicationController

  def new
    redirect_to '/auth/yahoo'
  end

  def create
    auth = request.env["omniauth.auth"]
    puts "\n\n\n\nAUTH: #{auth}\n\n\n"
    user = User.where(:provider => auth['provider'],
                      :image => auth['info']['urls']['image'],
                      :uid => auth['uid'].to_s).first || User.create_with_omniauth(auth)
    # reset_session
    user.update(token: auth['credentials']['token'])
    session[:user_id] = user.id
    null = nil
    @league = League.new()
    redirect_to '/users/:user_id/leagues', :notice => 'Signed in!'
  end


  def destroy
  if current_user
    session.delete(:user_id)
    flash[:success] = 'See you!'
  end
  redirect_to root_path
end

end