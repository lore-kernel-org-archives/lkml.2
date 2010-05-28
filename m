Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758168Ab0E1Jm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 05:42:58 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57488 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754801Ab0E1Jm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 05:42:56 -0400
To: Changli Gao <xiaosuo@gmail.com>
CC: axboe@kernel.dk, viro@zeniv.linux.org.uk, mszeredi@suse.cz,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xiaosuo@gmail.com
In-reply-to: <1274885083-15735-1-git-send-email-xiaosuo@gmail.com> (message
	from Changli Gao on Wed, 26 May 2010 22:44:43 +0800)
Subject: Re: [PATCH v2 4/4] splice: fix updating sd->pos wrongly
References: <1274885083-15735-1-git-send-email-xiaosuo@gmail.com>
Message-Id: <E1OHw5Q-00020q-Dk@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 28 May 2010 11:42:40 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Changli Gao wrote:
> fix updating sd->pos wrongly.
> 
> In error path, we don't need to updating sd->pos, if the file isn't seekable.

This patch is nonsense.  Why should we handle sd->pos != 0 case
differently?

> 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
> ----
>  fs/splice.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> diff --git a/fs/splice.c b/fs/splice.c
> index 57172ca..c69b241 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -1185,7 +1185,8 @@ ssize_t splice_direct_to_actor(struct file *in, struct splice_desc *sd,
>  		sd->pos = pos;
>  
>  		if (ret < read_len) {
> -			sd->pos = prev_pos + ret;
> +			if (sd->pos)
> +				sd->pos = prev_pos + ret;
>  			goto out_release;
>  		}
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
