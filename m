Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab0DVLTL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 07:19:11 -0400
Received: from tundra.namei.org ([65.99.196.166]:60608 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab0DVLTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 07:19:09 -0400
Date: Thu, 22 Apr 2010 21:18:55 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Dan Carpenter <error27@gmail.com>
cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [patch] security: testing the wrong variable in
 create_by_name()
In-Reply-To: <20100422100506.GU29647@bicker>
Message-ID: <alpine.LRH.2.00.1004222118280.14395@tundra.namei.org>
References: <20100422100506.GU29647@bicker>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010, Dan Carpenter wrote:

> There is a typo here.  We should be testing "*dentry" instead of
> "dentry".  If "*dentry" is an ERR_PTR, it gets dereferenced in either
> mkdir() or create() which would cause an OOPs.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Looks correct -- queued for Linus.


> 
> diff --git a/security/inode.c b/security/inode.c
> index c3a7938..1c812e8 100644
> --- a/security/inode.c
> +++ b/security/inode.c
> @@ -161,13 +161,13 @@ static int create_by_name(const char *name, mode_t mode,
>  
>  	mutex_lock(&parent->d_inode->i_mutex);
>  	*dentry = lookup_one_len(name, parent, strlen(name));
> -	if (!IS_ERR(dentry)) {
> +	if (!IS_ERR(*dentry)) {
>  		if ((mode & S_IFMT) == S_IFDIR)
>  			error = mkdir(parent->d_inode, *dentry, mode);
>  		else
>  			error = create(parent->d_inode, *dentry, mode);
>  	} else
> -		error = PTR_ERR(dentry);
> +		error = PTR_ERR(*dentry);
>  	mutex_unlock(&parent->d_inode->i_mutex);
>  
>  	return error;
> 

-- 
James Morris
<jmorris@namei.org>
