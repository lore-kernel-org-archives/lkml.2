Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab2EOBO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:14:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:17584 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758215Ab2EOBO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:14:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="140647372"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH] block: use I_BDEV to get _bdev_ from _inode_
Date: Tue, 15 May 2012 09:14:43 +0800
Message-Id: <1337044483-4376-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use defined I_BDEV function to get _bdev_ from _inode_.

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 fs/block_dev.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index e08f6a20..acc1e30 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -483,7 +483,7 @@ static inline void __bd_forget(struct inode *inode)
 
 static void bdev_evict_inode(struct inode *inode)
 {
-	struct block_device *bdev = &BDEV_I(inode)->bdev;
+	struct block_device *bdev = I_BDEV(inode);
 	struct list_head *p;
 	truncate_inode_pages(&inode->i_data, 0);
 	invalidate_inode_buffers(inode); /* is it needed here? */
@@ -548,12 +548,12 @@ static inline unsigned long hash(dev_t dev)
 
 static int bdev_test(struct inode *inode, void *data)
 {
-	return BDEV_I(inode)->bdev.bd_dev == *(dev_t *)data;
+	return I_BDEV(inode)->bd_dev == *(dev_t *)data;
 }
 
 static int bdev_set(struct inode *inode, void *data)
 {
-	BDEV_I(inode)->bdev.bd_dev = *(dev_t *)data;
+	I_BDEV(inode)->bd_dev = *(dev_t *)data;
 	return 0;
 }
 
@@ -570,7 +570,7 @@ struct block_device *bdget(dev_t dev)
 	if (!inode)
 		return NULL;
 
-	bdev = &BDEV_I(inode)->bdev;
+	bdev = I_BDEV(inode);
 
 	if (inode->i_state & I_NEW) {
 		bdev->bd_contains = NULL;
@@ -1600,7 +1600,7 @@ EXPORT_SYMBOL_GPL(blkdev_aio_write);
  */
 static int blkdev_releasepage(struct page *page, gfp_t wait)
 {
-	struct super_block *super = BDEV_I(page->mapping->host)->bdev.bd_super;
+	struct super_block *super = I_BDEV(page->mapping->host)->bd_super;
 
 	if (super && super->s_op->bdev_try_to_free_page)
 		return super->s_op->bdev_try_to_free_page(super, page, wait);
-- 
1.7.7.6

