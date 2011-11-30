Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757625Ab1K3CR4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 21:17:56 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:55920 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757485Ab1K3CRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 21:17:52 -0500
From: Joe Perches <joe@perches.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 17/28] block_dev: checkpatch wanking
Date: Tue, 29 Nov 2011 18:14:15 -0800
Message-Id: <eb455c85854302582725552ba84b3f6d0eb9e9c2.1322609673.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1322609672.git.joe@perches.com>
References: <cover.1322609672.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few style things.  Now checkpatch clean.

$ ./scripts/checkpatch.pl -f --terse --nosummary fs/block_dev.c | \
  cut -f3- -d":" | sort | uniq -c
      1  ERROR: code indent should use tabs where possible
      1  ERROR: do not use assignment in if condition
      4  ERROR: "foo * bar" should be "foo *bar"
      1  ERROR: space prohibited after that open parenthesis '('
      1  ERROR: space prohibited before that close parenthesis ')'
      1  ERROR: space required after that ',' (ctx:VxV)
      1  ERROR: switch and case should be at the same indent
      4  ERROR: trailing whitespace
      2  WARNING: braces {} are not necessary for single statement blocks
      7  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
      1  WARNING: line over 80 characters
      4  WARNING: please, no space before tabs
      2  WARNING: please, no spaces at the start of a line
      1  WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/block_dev.c |   70 +++++++++++++++++++++++++------------------------------
 1 files changed, 32 insertions(+), 38 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 20aa631..8b9bbf6 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -27,7 +27,7 @@
 #include <linux/namei.h>
 #include <linux/log2.h>
 #include <linux/kmemleak.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include "internal.h"
 
 struct bdev_inode {
@@ -90,7 +90,7 @@ static void kill_bdev(struct block_device *bdev)
 		return;
 	invalidate_bh_lrus();
 	truncate_inode_pages(bdev->bd_inode->i_mapping, 0);
-}	
+}
 
 int set_blocksize(struct block_device *bdev, int size)
 {
@@ -111,7 +111,6 @@ int set_blocksize(struct block_device *bdev, int size)
 	}
 	return 0;
 }
-
 EXPORT_SYMBOL(set_blocksize);
 
 int sb_set_blocksize(struct super_block *sb, int size)
@@ -124,7 +123,6 @@ int sb_set_blocksize(struct super_block *sb, int size)
 	sb->s_blocksize_bits = blksize_bits(size);
 	return sb->s_blocksize;
 }
-
 EXPORT_SYMBOL(sb_set_blocksize);
 
 int sb_min_blocksize(struct super_block *sb, int size)
@@ -134,7 +132,6 @@ int sb_min_blocksize(struct super_block *sb, int size)
 		size = minsize;
 	return sb_set_blocksize(sb, size);
 }
-
 EXPORT_SYMBOL(sb_min_blocksize);
 
 static int
@@ -321,7 +318,7 @@ static int blkdev_writepage(struct page *page, struct writeback_control *wbc)
 	return block_write_full_page(page, blkdev_get_block, wbc);
 }
 
-static int blkdev_readpage(struct file * file, struct page * page)
+static int blkdev_readpage(struct file *file, struct page *page)
 {
 	return block_read_full_page(page, blkdev_get_block);
 }
@@ -363,33 +360,32 @@ static loff_t block_llseek(struct file *file, loff_t offset, int origin)
 
 	retval = -EINVAL;
 	switch (origin) {
-		case SEEK_END:
-			offset += size;
-			break;
-		case SEEK_CUR:
-			offset += file->f_pos;
-		case SEEK_SET:
-			break;
-		default:
-			goto out;
+	case SEEK_END:
+		offset += size;
+		break;
+	case SEEK_CUR:
+		offset += file->f_pos;
+	case SEEK_SET:
+		break;
+	default:
+		goto out;
 	}
 	if (offset >= 0 && offset <= size) {
-		if (offset != file->f_pos) {
+		if (offset != file->f_pos)
 			file->f_pos = offset;
-		}
 		retval = offset;
 	}
 out:
 	mutex_unlock(&bd_inode->i_mutex);
 	return retval;
 }
-	
+
 int blkdev_fsync(struct file *filp, loff_t start, loff_t end, int datasync)
 {
 	struct inode *bd_inode = filp->f_mapping->host;
 	struct block_device *bdev = I_BDEV(bd_inode);
 	int error;
-	
+
 	error = filemap_write_and_wait_range(filp->f_mapping, start, end);
 	if (error)
 		return error;
@@ -412,7 +408,7 @@ EXPORT_SYMBOL(blkdev_fsync);
  */
 
 static  __cacheline_aligned_in_smp DEFINE_SPINLOCK(bdev_lock);
-static struct kmem_cache * bdev_cachep __read_mostly;
+static struct kmem_cache *bdev_cachep __read_mostly;
 
 static struct inode *bdev_alloc_inode(struct super_block *sb)
 {
@@ -468,9 +464,8 @@ static void bdev_evict_inode(struct inode *inode)
 	invalidate_inode_buffers(inode); /* is it needed here? */
 	end_writeback(inode);
 	spin_lock(&bdev_lock);
-	while ( (p = bdev->bd_inodes.next) != &bdev->bd_inodes ) {
+	while ((p = bdev->bd_inodes.next) != &bdev->bd_inodes)
 		__bd_forget(list_entry(p, struct inode, i_devices));
-	}
 	list_del_init(&bdev->bd_list);
 	spin_unlock(&bdev_lock);
 }
@@ -576,7 +571,6 @@ struct block_device *bdget(dev_t dev)
 	}
 	return bdev;
 }
-
 EXPORT_SYMBOL(bdget);
 
 /**
@@ -605,9 +599,8 @@ void bdput(struct block_device *bdev)
 {
 	iput(bdev->bd_inode);
 }
-
 EXPORT_SYMBOL(bdput);
- 
+
 static struct block_device *bd_acquire(struct inode *inode)
 {
 	struct block_device *bdev;
@@ -677,18 +670,19 @@ static bool bd_may_claim(struct block_device *bdev, struct block_device *whole,
 			 void *holder)
 {
 	if (bdev->bd_holder == holder)
-		return true;	 /* already a holder */
+		return true;	/* already a holder */
 	else if (bdev->bd_holder != NULL)
-		return false; 	 /* held by someone else */
+		return false;	/* held by someone else */
 	else if (bdev->bd_contains == bdev)
-		return true;  	 /* is a whole device which isn't held */
+		return true;	/* is a whole device which isn't held */
 
 	else if (whole->bd_holder == bd_may_claim)
-		return true; 	 /* is a partition of a device that is being partitioned */
+		return true;	/* is a partition of a device
+				 * that is being partitioned */
 	else if (whole->bd_holder != NULL)
-		return false;	 /* is a partition of a held device */
+		return false;	/* is a partition of a held device */
 	else
-		return true;	 /* is a partition of an un-held device */
+		return true;	/* is a partition of an un-held device */
 }
 
 /**
@@ -1056,7 +1050,6 @@ int check_disk_change(struct block_device *bdev)
 		bdops->revalidate_disk(bdev->bd_disk);
 	return 1;
 }
-
 EXPORT_SYMBOL(check_disk_change);
 
 void bd_set_size(struct block_device *bdev, loff_t size)
@@ -1149,7 +1142,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 			}
 
 			if (!ret && !bdev->bd_openers) {
-				bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
+				bd_set_size(bdev,
+					    (loff_t)get_capacity(disk) << 9);
 				bdi = blk_get_backing_dev_info(bdev);
 				if (bdi == NULL)
 					bdi = &default_backing_dev_info;
@@ -1393,7 +1387,7 @@ struct block_device *blkdev_get_by_dev(dev_t dev, fmode_t mode, void *holder)
 }
 EXPORT_SYMBOL(blkdev_get_by_dev);
 
-static int blkdev_open(struct inode * inode, struct file * filp)
+static int blkdev_open(struct inode *inode, struct file *filp)
 {
 	struct block_device *bdev;
 
@@ -1483,7 +1477,8 @@ int blkdev_put(struct block_device *bdev, fmode_t mode)
 		WARN_ON_ONCE(--bdev->bd_contains->bd_holders < 0);
 
 		/* bd_contains might point to self, check in a separate step */
-		if ((bdev_free = !bdev->bd_holders))
+		bdev_free = !bdev->bd_holders;
+		if (bdev_free)
 			bdev->bd_holder = NULL;
 		if (!bdev->bd_contains->bd_holders)
 			bdev->bd_contains->bd_holder = NULL;
@@ -1513,7 +1508,7 @@ int blkdev_put(struct block_device *bdev, fmode_t mode)
 }
 EXPORT_SYMBOL(blkdev_put);
 
-static int blkdev_close(struct inode * inode, struct file * filp)
+static int blkdev_close(struct inode *inode, struct file *filp)
 {
 	struct block_device *bdev = I_BDEV(filp->f_mapping->host);
 
@@ -1594,7 +1589,7 @@ const struct file_operations def_blk_fops = {
 	.llseek		= block_llseek,
 	.read		= do_sync_read,
 	.write		= do_sync_write,
-  	.aio_read	= generic_file_aio_read,
+	.aio_read	= generic_file_aio_read,
 	.aio_write	= blkdev_aio_write,
 	.mmap		= generic_file_mmap,
 	.fsync		= blkdev_fsync,
@@ -1615,7 +1610,6 @@ int ioctl_by_bdev(struct block_device *bdev, unsigned cmd, unsigned long arg)
 	set_fs(old_fs);
 	return res;
 }
-
 EXPORT_SYMBOL(ioctl_by_bdev);
 
 /**
-- 
1.7.6.405.gc1be0

