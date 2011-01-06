Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1AFQyW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 11:54:22 -0500
Received: from cantor.suse.de ([195.135.220.2]:47280 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867Ab1AFQyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 11:54:21 -0500
Date: Thu, 6 Jan 2011 17:54:12 +0100
From: Jan Kara <jack@suse.cz>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Ben Fennema <bfennema@falcon.csc.calpoly.edu>
Subject: Re: [PATCH] UDF: Close small mem leak in udf_find_entry()
Message-ID: <20110106165412.GO4641@quack.suse.cz>
References: <alpine.LNX.2.00.1012122313290.9206@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1012122313290.9206@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Sun 12-12-10 23:18:15, Jesper Juhl wrote:
> There's a small memory leak in fs/udf/namei.c::udf_find_entry().
> 
> We dynamically allocate memory for 'fname' with kmalloc() and in most 
> situations we free it before we leave the function, but there is one 
> situation where we do not (but should). This patch closes the leak by 
> jumping to the 'out_ok' label which does the correct cleanup rather than 
> doing half the cleanup and returning directly.
   Thanks. Merged.

								Honza
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  namei.c |    6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
>  compile tested only
> 
> diff --git a/fs/udf/namei.c b/fs/udf/namei.c
> index 6d8dc02..899ef91 100644
> --- a/fs/udf/namei.c
> +++ b/fs/udf/namei.c
> @@ -228,10 +228,8 @@ static struct fileIdentDesc *udf_find_entry(struct inode *dir,
>  		}
>  
>  		if ((cfi->fileCharacteristics & FID_FILE_CHAR_PARENT) &&
> -		    isdotdot) {
> -			brelse(epos.bh);
> -			return fi;
> -		}
> +		    isdotdot)
> +			goto out_ok;
>  
>  		if (!lfi)
>  			continue;
> 
> 
> 
> -- 
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
