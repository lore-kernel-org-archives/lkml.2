Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab2C1MMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:12:55 -0400
Received: from mga03.intel.com ([143.182.124.21]:59578 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab2C1MMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:12:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="124273268"
Date: Wed, 28 Mar 2012 20:07:48 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] trivial writeback fixes for 3.4
Message-ID: <20120328120748.GA17959@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull 2 trivial writeback fixes.

They've been tested in linux-next for 20 days actually.

Thanks,
Fengguang

The following changes since commit 9f8050c4f99789d03ca96d4e625bd6637241828f:

  Merge tag 'fixes-urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc (2012-03-08 17:32:42 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/wfg/linux.git tags/writeback-fixes

for you to fetch changes up to 697e6fed9fc620eb6c79ebcfe6865b66773c0221:

  writeback: Remove outdated comment (2012-03-21 15:27:08 +0800)

----------------------------------------------------------------
trivial writeback fixes

----------------------------------------------------------------
Jan Kara (2):
      fs: Remove bogus wait in write_inode_now()
      writeback: Remove outdated comment

 fs/fs-writeback.c |   22 ++--------------------
 1 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 5b4a936..be84e28 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -256,7 +256,8 @@ static bool inode_dirtied_after(struct inode *inode, unsigned long t)
 }
 
 /*
- * Move expired dirty inodes from @delaying_queue to @dispatch_queue.
+ * Move expired (dirtied after work->older_than_this) dirty inodes from
+ * @delaying_queue to @dispatch_queue.
  */
 static int move_expired_inodes(struct list_head *delaying_queue,
 			       struct list_head *dispatch_queue,
@@ -1148,23 +1149,6 @@ out_unlock_inode:
 }
 EXPORT_SYMBOL(__mark_inode_dirty);
 
-/*
- * Write out a superblock's list of dirty inodes.  A wait will be performed
- * upon no inodes, all inodes or the final one, depending upon sync_mode.
- *
- * If older_than_this is non-NULL, then only write out inodes which
- * had their first dirtying at a time earlier than *older_than_this.
- *
- * If `bdi' is non-zero then we're being asked to writeback a specific queue.
- * This function assumes that the blockdev superblock's inodes are backed by
- * a variety of queues, so all inodes are searched.  For other superblocks,
- * assume that all inodes are backed by the same queue.
- *
- * The inodes to be written are parked on bdi->b_io.  They are moved back onto
- * bdi->b_dirty as they are selected for writing.  This way, none can be missed
- * on the writer throttling path, and we get decent balancing between many
- * throttled threads: we don't want them all piling up on inode_sync_wait.
- */
 static void wait_sb_inodes(struct super_block *sb)
 {
 	struct inode *inode, *old_inode = NULL;
@@ -1364,8 +1348,6 @@ int write_inode_now(struct inode *inode, int sync)
 	ret = writeback_single_inode(inode, wb, &wbc);
 	spin_unlock(&inode->i_lock);
 	spin_unlock(&wb->list_lock);
-	if (sync)
-		inode_sync_wait(inode);
 	return ret;
 }
 EXPORT_SYMBOL(write_inode_now);
