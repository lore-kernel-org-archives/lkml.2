Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1HDKkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 06:40:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34536 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753640Ab1HDKkJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 06:40:09 -0400
Date: Thu, 4 Aug 2011 12:40:03 +0200
From: Jan Kara <jack@suse.cz>
To: Julia Lawall <julia@diku.dk>
Cc: Jan Kara <jack@suse.cz>, kernel-janitors@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] fs/ext3/balloc.c: delete useless initialization
Message-ID: <20110804104003.GH17196@quack.suse.cz>
References: <1312453774-23333-1-git-send-email-julia@diku.dk>
 <1312453774-23333-2-git-send-email-julia@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312453774-23333-2-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-08-11 12:29:31, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Delete nontrivial initialization that is immediately overwritten by the
> result of an allocation function.
  Thanks. Merged.

								Honza

> 
> The semantic match that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> type T;
> identifier i;
> expression e;
> @@
> 
> (
> T i = \(0\|NULL\|ERR_PTR(...)\);
> |
> -T i = e;
> +T i;
> )
> ... when != i
> i = \(kzalloc\|kcalloc\|kmalloc\)(...);
> 
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  fs/ext3/balloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -u -p a/fs/ext3/balloc.c b/fs/ext3/balloc.c
> --- a/fs/ext3/balloc.c
> +++ b/fs/ext3/balloc.c
> @@ -427,7 +427,7 @@ static inline int rsv_is_empty(struct ex
>  void ext3_init_block_alloc_info(struct inode *inode)
>  {
>  	struct ext3_inode_info *ei = EXT3_I(inode);
> -	struct ext3_block_alloc_info *block_i = ei->i_block_alloc_info;
> +	struct ext3_block_alloc_info *block_i;
>  	struct super_block *sb = inode->i_sb;
>  
>  	block_i = kmalloc(sizeof(*block_i), GFP_NOFS);
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
