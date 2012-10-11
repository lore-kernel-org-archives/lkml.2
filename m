Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338Ab2JKSLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 14:11:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40567 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759116Ab2JKSLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 14:11:52 -0400
Date: Thu, 11 Oct 2012 20:11:50 +0200
From: Jan Kara <jack@suse.cz>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jack@suse.cz, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>
Subject: Re: [PATCH 4/6] udf: remove un-needed variable from inode_getblk
Message-ID: <20121011181150.GE18391@quack.suse.cz>
References: <1349795384-6461-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349795384-6461-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 10-10-12 00:09:44, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> The variable last_block is not needed.
> 
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
  Thanks. I've merged the patch.

						Honza
> ---
>  fs/udf/inode.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> index 76a1f57..6fd9dc5 100644
> --- a/fs/udf/inode.c
> +++ b/fs/udf/inode.c
> @@ -587,7 +587,6 @@ out:
>  static sector_t inode_getblk(struct inode *inode, sector_t block,
>  			     int *err, int *new)
>  {
> -	static sector_t last_block;
>  	struct kernel_long_ad laarr[EXTENT_MERGE_SIZE];
>  	struct extent_position prev_epos, cur_epos, next_epos;
>  	int count = 0, startnum = 0, endnum = 0;
> @@ -677,7 +676,6 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
>  		return newblock;
>  	}
>  
> -	last_block = block;
>  	/* Are we beyond EOF? */
>  	if (etype == -1) {
>  		int ret;
> @@ -719,7 +717,6 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
>  			memset(&laarr[c].extLocation, 0x00,
>  				sizeof(struct kernel_lb_addr));
>  			count++;
> -			endnum++;
>  		}
>  		endnum = c + 1;
>  		lastblock = 1;
> -- 
> 1.7.9.5
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
