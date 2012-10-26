Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965880Ab2JZSMm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 14:12:42 -0400
Received: from mail.kernel.org ([198.145.19.201]:34207 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965748Ab2JZSMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 14:12:40 -0400
Date: Fri, 26 Oct 2012 11:12:38 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yan Hong <clouds.yan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] debugfs: break long lines
Message-ID: <20121026181238.GB25530@kroah.com>
References: <1351274144-31591-1-git-send-email-clouds.yan@gmail.com>
 <1351274144-31591-3-git-send-email-clouds.yan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351274144-31591-3-git-send-email-clouds.yan@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 01:55:44AM +0800, Yan Hong wrote:
> 
> Signed-off-by: Yan Hong <clouds.yan@gmail.com>
> ---
>  fs/debugfs/file.c  |   42 ++++++++++++++++++++++++++++--------------
>  fs/debugfs/inode.c |   10 ++++++----
>  2 files changed, 34 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
> index 3915cc9..b37eee1 100644
> --- a/fs/debugfs/file.c
> +++ b/fs/debugfs/file.c
> @@ -95,10 +95,12 @@ struct dentry *debugfs_create_u8(const char *name, umode_t mode,
>  {
>  	/* if there are no write bits set, make read only */
>  	if (!(mode & S_IWUGO))
> -		return debugfs_create_file(name, mode, parent, value, &fops_u8_ro);
> +		return debugfs_create_file(name, mode, parent, value,
> +								&fops_u8_ro);

If you are going to do this (and hint, I really don't want you to), at
least make it look pretty:
		return debugfs_create_file(name, mode, parent, value,
					   &fops_u8_ro);

Other than that, I don't want to take this patch, sorry, it looks good
enough as-is.

thanks,

greg k-h
