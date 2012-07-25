Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030209Ab2GYPLK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:11:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:34627 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933521Ab2GYPLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:11:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="171267734"
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH 12/16] ntfs: nuke write_super from comments
Date: Wed, 25 Jul 2012 18:12:10 +0300
Message-Id: <1343229134-29487-13-git-send-email-artem.bityutskiy@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
References: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The '->write_super' superblock method is gone, and this patch removes all the
references to 'write_super' from ntfs.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---

I expect this patch to be merged via Al Viro's VFS tree.

 fs/ntfs/super.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index b341492..2bc149d 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -2660,31 +2660,14 @@ static const struct super_operations ntfs_sops = {
 	.alloc_inode	= ntfs_alloc_big_inode,	  /* VFS: Allocate new inode. */
 	.destroy_inode	= ntfs_destroy_big_inode, /* VFS: Deallocate inode. */
 #ifdef NTFS_RW
-	//.dirty_inode	= NULL,			/* VFS: Called from
-	//					   __mark_inode_dirty(). */
 	.write_inode	= ntfs_write_inode,	/* VFS: Write dirty inode to
 						   disk. */
-	//.drop_inode	= NULL,			/* VFS: Called just after the
-	//					   inode reference count has
-	//					   been decreased to zero.
-	//					   NOTE: The inode lock is
-	//					   held. See fs/inode.c::
-	//					   generic_drop_inode(). */
-	//.delete_inode	= NULL,			/* VFS: Delete inode from disk.
-	//					   Called when i_count becomes
-	//					   0 and i_nlink is also 0. */
-	//.write_super	= NULL,			/* Flush dirty super block to
-	//					   disk. */
-	//.sync_fs	= NULL,			/* ? */
-	//.write_super_lockfs	= NULL,		/* ? */
-	//.unlockfs	= NULL,			/* ? */
 #endif /* NTFS_RW */
 	.put_super	= ntfs_put_super,	/* Syscall: umount. */
 	.statfs		= ntfs_statfs,		/* Syscall: statfs */
 	.remount_fs	= ntfs_remount,		/* Syscall: mount -o remount. */
 	.evict_inode	= ntfs_evict_big_inode,	/* VFS: Called when an inode is
 						   removed from memory. */
-	//.umount_begin	= NULL,			/* Forced umount. */
 	.show_options	= ntfs_show_options,	/* Show mount options in
 						   proc. */
 };
-- 
1.7.10

