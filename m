Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab1ARXaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 18:30:55 -0500
Received: from fieldses.org ([174.143.236.118]:41583 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752810Ab1ARXay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 18:30:54 -0500
Date: Tue, 18 Jan 2011 18:30:51 -0500
To: Namhyung Kim <namhyung@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] locks: use assign_type()
Message-ID: <20110118233051.GI10903@fieldses.org>
References: <1295246759-5738-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295246759-5738-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks right to me.

I suppose I'll queue this up in the nfsd tree if nobody else takes
it.

--b.

On Mon, Jan 17, 2011 at 03:45:59PM +0900, Namhyung Kim wrote:
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> ---
>  fs/locks.c |   12 +-----------
>  1 files changed, 1 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 0f3998291f78..2c2d3b804d62 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -415,17 +415,7 @@ static int flock64_to_posix_lock(struct file *filp, struct file_lock *fl,
>  	fl->fl_ops = NULL;
>  	fl->fl_lmops = NULL;
>  
> -	switch (l->l_type) {
> -	case F_RDLCK:
> -	case F_WRLCK:
> -	case F_UNLCK:
> -		fl->fl_type = l->l_type;
> -		break;
> -	default:
> -		return -EINVAL;
> -	}
> -
> -	return (0);
> +	return assign_type(fl, l->l_type);
>  }
>  #endif
>  
> -- 
> 1.7.3.4.600.g982838b0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
