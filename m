Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075Ab2JKRyM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 13:54:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39999 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754597Ab2JKRyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 13:54:11 -0400
Date: Thu, 11 Oct 2012 19:54:08 +0200
From: Jan Kara <jack@suse.cz>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: Re: [PATCH 3/6] udf: update inode's iblock count when allocating
 new block
Message-ID: <20121011175408.GB18391@quack.suse.cz>
References: <1349795368-6425-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349795368-6425-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 10-10-12 00:09:28, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Currently, du will show wrong block count. This patch fix it.
  This should be fixed by commit fd4287dbc07763595c1e74edbb6520092290185c.
Have you tested with newish kernel? If recent kernel still has an issue,
can you provide a test case? Thanks!

								Honza

> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
> ---
>  fs/udf/inode.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index 8266f2e..76a1f57 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -775,6 +775,8 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
>  		if (isBeyondEOF)
>  			iinfo->i_lenExtents += inode->i_sb->s_blocksize;
>  	}
> +	/* update inode's iblocks */
> +	inode->i_blocks += (1 << (inode->i_sb->s_blocksize_bits - 9));
>  
>  	/* if the extent the requsted block is located in contains multiple
>  	 * blocks, split the extent into at most three extents. blocks prior
> -- 
> 1.7.9.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
