Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab0F3W7s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 18:59:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38518 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab0F3W7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 18:59:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=AIO09mQAmPmooC3baSdJSJwgw+6LJB87QNKa6JUKWK7CJMcwPMCbkTLpT63WCjERVv
         Lo5A3oWT8ZcSnlWMoQ9WTAKr24jSdbB3Xs9rg5q6dB43fWG/Q/FIWIdWCleM/aepEwOh
         tyaWArdn3nzmSjLxQvBj8EUBJQtEKCkUlgo+o=
Date: Thu, 1 Jul 2010 00:57:54 +0200
From: Dan Carpenter <error27@gmail.com>
To: Peter Pan <wppan@redflag-linux.com>
Cc: jack@suse.cz, hch@lst.de, viro@zeniv.linux.org.uk, npiggin@suse.de,
       jblunck@suse.de, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ext2:delete misused ext2_free_blocks
Message-ID: <20100630225754.GT19184@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Peter Pan <wppan@redflag-linux.com>, jack@suse.cz, hch@lst.de,
	viro@zeniv.linux.org.uk, npiggin@suse.de, jblunck@suse.de,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <1277893287-25916-1-git-send-email-wppan@redflag-linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277893287-25916-1-git-send-email-wppan@redflag-linux.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 06:21:27PM +0800, Peter Pan wrote:
> if ext2_new_blocks returns error, no blocks need to be freed.
> 

Hi Peter,

Your patch isn't right.  The original code is OK as is.

Are you seeing a kernel panic?  Perhaps we can help you fix it.

regards,
dan carpenter

> Signed-off-by: Peter Pan <wppan@redflag-linux.com>
> ---
>  fs/ext2/inode.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
> index 3675088..f858847 100644
> --- a/fs/ext2/inode.c
> +++ b/fs/ext2/inode.c
> @@ -385,6 +385,8 @@ static int ext2_alloc_blocks(struct inode *inode,
>  	ext2_fsblk_t current_block = 0;
>  	int ret = 0;
>  
> +	*err = -ENOSPC;
> +
>  	/*
>  	 * Here we try to allocate the requested multiple blocks at once,
>  	 * on a best-effort basis.
> @@ -421,8 +423,6 @@ static int ext2_alloc_blocks(struct inode *inode,
>  	*err = 0;
>  	return ret;
>  failed_out:
> -	for (i = 0; i <index; i++)
> -		ext2_free_blocks(inode, new_blocks[i], 1);
>  	return ret;
>  }
>  
> -- 
> 1.6.6
