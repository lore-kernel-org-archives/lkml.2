Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab0DBLJf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 07:09:35 -0400
Received: from sh.osrg.net ([192.16.179.4]:48051 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758798Ab0DBLJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 07:09:29 -0400
Date: Fri, 02 Apr 2010 20:09:24 +0900 (JST)
Message-Id: <20100402.200924.67912456.ryusuke@osrg.net>
To: lihong.hi@gmail.com
Cc: konishi.ryusuke@lab.ntt.co.jp, linux-nilfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nilfs2: Remove an uninitialization warning in
 nilfs_btree_propagate_v()
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <20100402104039.GA9652@xhl>
References: <20100402104039.GA9652@xhl>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 02 Apr 2010 20:09:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Apr 2010 18:40:39 +0800, Li Hong <lihong.hi@gmail.com> wrote:
> `make CONFIG_NILFS2_FS=m M=fs/nilfs2/` will give the following warnings:
> 
> fs/nilfs2/btree.c: In function ‘nilfs_btree_propagate’:
> fs/nilfs2/btree.c:1882: warning: ‘maxlevel’ may be used uninitialized in this function
> fs/nilfs2/btree.c:1882: note: ‘maxlevel’ was declared here
> 
> Set maxlevel = 0 to fix it.
> 
> Signed-off-by: Li Hong <lihong.hi@gmail.com>

Applied, thanks.

Ryusuke Konishi

> ---
>  fs/nilfs2/btree.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nilfs2/btree.c b/fs/nilfs2/btree.c
> index 7cdd98b..76c38e3 100644
> --- a/fs/nilfs2/btree.c
> +++ b/fs/nilfs2/btree.c
> @@ -1879,7 +1879,7 @@ static int nilfs_btree_propagate_v(struct nilfs_btree *btree,
>  				   struct nilfs_btree_path *path,
>  				   int level, struct buffer_head *bh)
>  {
> -	int maxlevel, ret;
> +	int maxlevel = 0, ret;
>  	struct nilfs_btree_node *parent;
>  	struct inode *dat = nilfs_bmap_get_dat(&btree->bt_bmap);
>  	__u64 ptr;
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
