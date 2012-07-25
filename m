Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594Ab2GYPMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:12:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:34632 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933524Ab2GYPLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:11:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="171267770"
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Subject: [PATCH 13/16] nilfs2: nuke write_super from comments
Date: Wed, 25 Jul 2012 18:12:11 +0300
Message-Id: <1343229134-29487-14-git-send-email-artem.bityutskiy@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
References: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The '->write_super' superblock method is gone, and this patch removes all the
references to 'write_super' from ntfs.

Cc: KONISHI Ryusuke <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---

I expect this patch to be merged via Al Viro's VFS tree.

 fs/nilfs2/super.c     |    7 -------
 fs/nilfs2/the_nilfs.h |    2 --
 2 files changed, 9 deletions(-)

diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 1099a76..19ffcc6 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -676,20 +676,13 @@ static const struct super_operations nilfs_sops = {
 	.alloc_inode    = nilfs_alloc_inode,
 	.destroy_inode  = nilfs_destroy_inode,
 	.dirty_inode    = nilfs_dirty_inode,
-	/* .write_inode    = nilfs_write_inode, */
-	/* .put_inode      = nilfs_put_inode, */
-	/* .drop_inode	  = nilfs_drop_inode, */
 	.evict_inode    = nilfs_evict_inode,
 	.put_super      = nilfs_put_super,
-	/* .write_super    = nilfs_write_super, */
 	.sync_fs        = nilfs_sync_fs,
 	.freeze_fs	= nilfs_freeze,
 	.unfreeze_fs	= nilfs_unfreeze,
-	/* .write_super_lockfs */
-	/* .unlockfs */
 	.statfs         = nilfs_statfs,
 	.remount_fs     = nilfs_remount,
-	/* .umount_begin */
 	.show_options = nilfs_show_options
 };
 
diff --git a/fs/nilfs2/the_nilfs.h b/fs/nilfs2/the_nilfs.h
index 9992b11..0722043 100644
--- a/fs/nilfs2/the_nilfs.h
+++ b/fs/nilfs2/the_nilfs.h
@@ -104,8 +104,6 @@ struct the_nilfs {
 	 * used for
 	 * - loading the latest checkpoint exclusively.
 	 * - allocating a new full segment.
-	 * - protecting s_dirt in the super_block struct
-	 *   (see nilfs_write_super) and the following fields.
 	 */
 	struct buffer_head     *ns_sbh[2];
 	struct nilfs_super_block *ns_sbp[2];
-- 
1.7.10

