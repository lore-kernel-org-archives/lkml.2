Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220Ab2FUJs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:48:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51545 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab2FUJsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:48:24 -0400
Date: Thu, 21 Jun 2012 17:47:55 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: Cong Meng <mc@linux.vnet.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwp.linux@gmail.com>
Subject: Re: [PATCH] VFS: Go through the LRU list of inode from head
Message-ID: <20120621094755.GD2439@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1340269227-20310-1-git-send-email-mc@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340269227-20310-1-git-send-email-mc@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 05:00:27PM +0800, Cong Meng wrote:
>Go through the LRU list of inode from head.

IIRC, prune_icache_sb is called(as a shrinker in shrink_slab) in page reclaim 
path, it is used to free icache. Tail entry in LRU(Least Recently Used) list 
is the least recently used inode object. When the inode cache has to shrink, 
the kernel removes entries from the tail.
>
>(I'm not sure whether there is any trick here I doesn't get.  If yes, 
>any one could explain it)
>
>Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
>---
> fs/inode.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/fs/inode.c b/fs/inode.c
>index 775cbab..aac8449 100644
>--- a/fs/inode.c
>+++ b/fs/inode.c
>@@ -704,7 +704,7 @@ void prune_icache_sb(struct super_block *sb, int nr_to_scan)
> 		if (list_empty(&sb->s_inode_lru))
> 			break;
> 
>-		inode = list_entry(sb->s_inode_lru.prev, struct inode, i_lru);
>+		inode = list_entry(sb->s_inode_lru.next, struct inode, i_lru);
> 
> 		/*
> 		 * we are inverting the sb->s_inode_lru_lock/inode->i_lock here,
>-- 
>1.7.5.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
