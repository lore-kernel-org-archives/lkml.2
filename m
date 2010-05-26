Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab0EZKZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:25:26 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34654 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727Ab0EZKZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:25:24 -0400
To: Changli Gao <xiaosuo@gmail.com>
CC: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, xiaosuo@gmail.com
In-reply-to: <1274867715-2936-1-git-send-email-xiaosuo@gmail.com> (message
	from Changli Gao on Wed, 26 May 2010 17:55:15 +0800)
Subject: Re: [PATCH 1/3] splice: check f_mode for seekable file
References: <1274867715-2936-1-git-send-email-xiaosuo@gmail.com>
Message-Id: <E1OHDnb-0000FY-Gs@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 26 May 2010 12:25:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Changli Gao wrote:
> check f_mode for seekable file
> 
> As a seekable file is allowed without a llseek function, so the old way isn't
> work any more.
> 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>

Looks good.

Acked-by: Miklos Szeredi <mszeredi@suse.cz>

BTW, you should send splice patches to Jens Axboe, he's the maintainer
of the splice code.

Miklos

> ----
>  fs/splice.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> diff --git a/fs/splice.c b/fs/splice.c
> index 9313b61..9e52de5 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -1321,8 +1321,7 @@ static long do_splice(struct file *in, loff_t __user *off_in,
>  		if (off_in)
>  			return -ESPIPE;
>  		if (off_out) {
> -			if (!out->f_op || !out->f_op->llseek ||
> -			    out->f_op->llseek == no_llseek)
> +			if (!(out->f_mode & FMODE_PWRITE))
>  				return -EINVAL;
>  			if (copy_from_user(&offset, off_out, sizeof(loff_t)))
>  				return -EFAULT;
> @@ -1342,8 +1341,7 @@ static long do_splice(struct file *in, loff_t __user *off_in,
>  		if (off_out)
>  			return -ESPIPE;
>  		if (off_in) {
> -			if (!in->f_op || !in->f_op->llseek ||
> -			    in->f_op->llseek == no_llseek)
> +			if (!(in->f_mode & FMODE_PREAD))
>  				return -EINVAL;
>  			if (copy_from_user(&offset, off_in, sizeof(loff_t)))
>  				return -EFAULT;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
