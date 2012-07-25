Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540Ab2GYPLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:11:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:44939 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933219Ab2GYPLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:11:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="171267679"
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH 10/16] vfs: nuke pdflush from comments
Date: Wed, 25 Jul 2012 18:12:08 +0300
Message-Id: <1343229134-29487-11-git-send-email-artem.bityutskiy@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
References: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The pdflush thread is long gone, so this patch removes references to pdflush
from vfs comments.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---

I expect this patch to be merged via Al Viro's VFS tree.

 fs/bio.c                  |    2 +-
 fs/sync.c                 |    4 ++--
 include/linux/writeback.h |    8 +++-----
 3 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/bio.c b/fs/bio.c
index 73922ab..5eaa70c 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1312,7 +1312,7 @@ EXPORT_SYMBOL(bio_copy_kern);
  * Note that this code is very hard to test under normal circumstances because
  * direct-io pins the pages with get_user_pages().  This makes
  * is_page_cache_freeable return false, and the VM will not clean the pages.
- * But other code (eg, pdflush) could clean the pages if they are mapped
+ * But other code (eg, flusher threads) could clean the pages if they are mapped
  * pagecache.
  *
  * Simply disabling the call to bio_set_pages_dirty() is a good way to test the
diff --git a/fs/sync.c b/fs/sync.c
index 11e3d1c..c6988a5 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -92,8 +92,8 @@ static void sync_filesystems(int wait)
 }
 
 /*
- * sync everything.  Start out by waking pdflush, because that writes back
- * all queues in parallel.
+ * sync everything.  Start out by waking the flusher threads, because that
+ * writes back all queues in parallel.
  */
 SYSCALL_DEFINE0(sync)
 {
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 6d0a0fc..0faa032 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -104,6 +104,9 @@ static inline void wait_on_inode(struct inode *inode)
 	wait_on_bit(&inode->i_state, __I_NEW, inode_wait, TASK_UNINTERRUPTIBLE);
 }
 
+extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
+				   read-only. */
+
 
 /*
  * mm/page-writeback.c
@@ -189,9 +192,4 @@ void tag_pages_for_writeback(struct address_space *mapping,
 
 void account_page_redirty(struct page *page);
 
-/* pdflush.c */
-extern int nr_pdflush_threads;	/* Global so it can be exported to sysctl
-				   read-only. */
-
-
 #endif		/* WRITEBACK_H */
-- 
1.7.10

