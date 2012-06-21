Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206Ab2FUJBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 05:01:10 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:39874 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759023Ab2FUJBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 05:01:05 -0400
From: Cong Meng <mc@linux.vnet.ibm.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cong Meng <mc@linux.vnet.ibm.com>
Subject: [PATCH] VFS: Go through the LRU list of inode from head
Date: Thu, 21 Jun 2012 17:00:27 +0800
Message-Id: <1340269227-20310-1-git-send-email-mc@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
x-cbid: 12062109-8372-0000-0000-000002F1EFBF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Go through the LRU list of inode from head.

(I'm not sure whether there is any trick here I doesn't get.  If yes, 
any one could explain it)

Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
---
 fs/inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 775cbab..aac8449 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -704,7 +704,7 @@ void prune_icache_sb(struct super_block *sb, int nr_to_scan)
 		if (list_empty(&sb->s_inode_lru))
 			break;
 
-		inode = list_entry(sb->s_inode_lru.prev, struct inode, i_lru);
+		inode = list_entry(sb->s_inode_lru.next, struct inode, i_lru);
 
 		/*
 		 * we are inverting the sb->s_inode_lru_lock/inode->i_lock here,
-- 
1.7.5.4

