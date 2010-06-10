Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923Ab0FJLLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 07:11:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39183 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758896Ab0FJLLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 07:11:00 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20100610110.764742110@firstfloor.org>
In-Reply-To: <20100610110.764742110@firstfloor.org>
To: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [23/23] FS: Fix unused but set warnings 
Message-Id: <20100610111059.66AF4B1A2B@basil.firstfloor.org>
Date: Thu, 10 Jun 2010 13:10:59 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No real bugs I believe, just some dead code, and some
shut up code.

Cc: viro@zeniv.linux.org.uk

Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35-rc2-gcc/fs/splice.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/splice.c
+++ linux-2.6.35-rc2-gcc/fs/splice.c
@@ -597,7 +597,6 @@ ssize_t default_file_splice_read(struct
 	struct page *pages[PIPE_DEF_BUFFERS];
 	struct partial_page partial[PIPE_DEF_BUFFERS];
 	struct iovec *vec, __vec[PIPE_DEF_BUFFERS];
-	pgoff_t index;
 	ssize_t res;
 	size_t this_len;
 	int error;
@@ -621,7 +620,6 @@ ssize_t default_file_splice_read(struct
 			goto shrink_ret;
 	}
 
-	index = *ppos >> PAGE_CACHE_SHIFT;
 	offset = *ppos & ~PAGE_CACHE_MASK;
 	nr_pages = (len + offset + PAGE_CACHE_SIZE - 1) >> PAGE_CACHE_SHIFT;
 
Index: linux-2.6.35-rc2-gcc/include/linux/audit.h
===================================================================
--- linux-2.6.35-rc2-gcc.orig/include/linux/audit.h
+++ linux-2.6.35-rc2-gcc/include/linux/audit.h
@@ -544,7 +544,7 @@ extern int audit_signals;
 #define audit_putname(n) do { ; } while (0)
 #define __audit_inode(n,d) do { ; } while (0)
 #define __audit_inode_child(i,p) do { ; } while (0)
-#define audit_inode(n,d) do { ; } while (0)
+#define audit_inode(n,d) do { (void)(d); } while (0)
 #define audit_inode_child(i,p) do { ; } while (0)
 #define audit_core_dumps(i) do { ; } while (0)
 #define auditsc_get_stamp(c,t,s) (0)
Index: linux-2.6.35-rc2-gcc/fs/notify/inotify/inotify.c
===================================================================
--- linux-2.6.35-rc2-gcc.orig/fs/notify/inotify/inotify.c
+++ linux-2.6.35-rc2-gcc/fs/notify/inotify/inotify.c
@@ -570,7 +570,6 @@ void inotify_destroy(struct inotify_hand
 	while (1) {
 		struct inotify_watch *watch;
 		struct list_head *watches;
-		struct super_block *sb;
 		struct inode *inode;
 
 		mutex_lock(&ih->mutex);
@@ -580,7 +579,6 @@ void inotify_destroy(struct inotify_hand
 			break;
 		}
 		watch = list_first_entry(watches, struct inotify_watch, h_list);
-		sb = watch->inode->i_sb;
 		if (!pin_to_kill(ih, watch))
 			continue;
 
@@ -797,7 +795,6 @@ void inotify_evict_watch(struct inotify_
 int inotify_rm_wd(struct inotify_handle *ih, u32 wd)
 {
 	struct inotify_watch *watch;
-	struct super_block *sb;
 	struct inode *inode;
 
 	mutex_lock(&ih->mutex);
@@ -806,7 +803,6 @@ int inotify_rm_wd(struct inotify_handle
 		mutex_unlock(&ih->mutex);
 		return -EINVAL;
 	}
-	sb = watch->inode->i_sb;
 	if (!pin_to_kill(ih, watch))
 		return 0;
 
