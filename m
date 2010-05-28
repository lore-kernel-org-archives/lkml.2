Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab0E1Jho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 05:37:44 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53465 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab0E1Jhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 05:37:43 -0400
To: Changli Gao <xiaosuo@gmail.com>
CC: axboe@kernel.dk, viro@zeniv.linux.org.uk, mszeredi@suse.cz,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xiaosuo@gmail.com
In-reply-to: <1274885030-15661-1-git-send-email-xiaosuo@gmail.com> (message
	from Changli Gao on Wed, 26 May 2010 22:43:50 +0800)
Subject: Re: [PATCH v2 2/4] splice: direct_splice_actor() should not use pos in sd
References: <1274885030-15661-1-git-send-email-xiaosuo@gmail.com>
Message-Id: <E1OHw0L-0001wD-Ii@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 28 May 2010 11:37:25 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Changli Gao wrote:
> direct_splice_actor() should not use pos in sd
> 
> direct_splice_actor() shouldn't use sd->pos, as sd->pos is for file reading,
> file->f_pos should be used instead.
> 
> Signed-off-by: Changli Gao <xiaosuo@gmail.com>

Acked-by: Miklos Szeredi <mszeredi@suse.cz>


> ----
>  fs/splice.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> diff --git a/fs/splice.c b/fs/splice.c
> index 9e52de5..eb602cb 100644
> --- a/fs/splice.c
> +++ b/fs/splice.c
> @@ -1232,7 +1232,8 @@ static int direct_splice_actor(struct pipe_inode_info *pipe,
>  {
>  	struct file *file = sd->u.file;
>  
> -	return do_splice_from(pipe, file, &sd->pos, sd->total_len, sd->flags);
> +	return do_splice_from(pipe, file, &file->f_pos, sd->total_len,
> +			      sd->flags);
>  }
>  
>  /**
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
