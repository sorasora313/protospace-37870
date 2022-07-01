class PrototypesController < ApplicationController
 
  before_action :authenticate_user!, only: [:new,:edit,:destroy]#ログインしてないと使えないやつ
  before_action :move_to_index, except: [:index, :show]#ログインしてなくてもOK
  def index
    @prototype = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.new(prototype_params)
    
    if @prototype.save
      redirect_to root_path (@prototype)
    else
      render :new
      @prototype = Prototype.includes(:user)
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end


  def edit
    @prototype = Prototype.find(params[:id])
    
    unless @prototype.user_id == current_user.id
      redirect_to action: :show
    end

  end

  def update
    @prototype = Prototype.find(params[:id])
    @prototype.update(prototype_params)
    if @prototype.save
      redirect_to root_path(@prototype)
    else
      render :edit
    end
  end

   def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
   end

   private
   def prototype_params
    params[:prototype].permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
   end
   
   def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end

  def move_to_edit
    unless user_signed_in?
      redirect_to action: :index
    end
  end

  def move_to_update
    unless user_signed_in?
      redirect_to action: :index
    end
  end

  def move_to_destroy
    unless user_signed_in?
      redirect_to action: :index
    end
  end

end