Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453Ab2JKSLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 14:11:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40553 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623Ab2JKSL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 14:11:29 -0400
Date: Thu, 11 Oct 2012 20:11:26 +0200
From: Jan Kara <jack@suse.cz>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: Re: [PATCH 1/6] udf: fix memory leak while allocating blocks
 during write
Message-ID: <20121011181126.GC18391@quack.suse.cz>
References: <1349795336-6353-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349795336-6353-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 10-10-12 00:08:56, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> Need to brelse the buffer_head stored in cur_epos and next_epos.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
  Thanks. I've merged the patch.

								Honza

> ---
>  fs/udf/inode.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index df88b95..2b77593 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -765,6 +765,8 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
>  				goal, err);
>  		if (!newblocknum) {
>  			brelse(prev_epos.bh);
> +			brelse(cur_epos.bh);
> +			brelse(next_epos.bh);
>  			*err = -ENOSPC;
>  			return 0;
>  		}
> @@ -795,6 +797,8 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
>  	udf_update_extents(inode, laarr, startnum, endnum, &prev_epos);
>  
>  	brelse(prev_epos.bh);
> +	brelse(cur_epos.bh);
> +	brelse(next_epos.bh);
>  
>  	newblock = udf_get_pblock(inode->i_sb, newblocknum,
>  				iinfo->i_location.partitionReferenceNum, 0);
> -- 
> 1.7.9.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
