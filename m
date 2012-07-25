Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237Ab2GYPL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:11:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:34643 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933520Ab2GYPLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:11:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="171267839"
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [PATCH 16/16] UBIFS: nuke pdflush from comments
Date: Wed, 25 Jul 2012 18:12:14 +0300
Message-Id: <1343229134-29487-17-git-send-email-artem.bityutskiy@linux.intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
References: <1343229134-29487-1-git-send-email-artem.bityutskiy@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

The pdflush thread is long gone, so this patch removes references to pdflush
from UBIFS comments.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---

I expect this patch to be merged via Al Viro's VFS tree.

 fs/ubifs/file.c  |   10 +++++-----
 fs/ubifs/super.c |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 35389ca..7bd6e72 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -37,11 +37,11 @@
  *
  * A thing to keep in mind: inode @i_mutex is locked in most VFS operations we
  * implement. However, this is not true for 'ubifs_writepage()', which may be
- * called with @i_mutex unlocked. For example, when pdflush is doing background
- * write-back, it calls 'ubifs_writepage()' with unlocked @i_mutex. At "normal"
- * work-paths the @i_mutex is locked in 'ubifs_writepage()', e.g. in the
- * "sys_write -> alloc_pages -> direct reclaim path". So, in 'ubifs_writepage()'
- * we are only guaranteed that the page is locked.
+ * called with @i_mutex unlocked. For example, when flusher thread is doing
+ * background write-back, it calls 'ubifs_writepage()' with unlocked @i_mutex.
+ * At "normal" work-paths the @i_mutex is locked in 'ubifs_writepage()', e.g.
+ * in the "sys_write -> alloc_pages -> direct reclaim path". So, in
+ * 'ubifs_writepage()' we are only guaranteed that the page is locked.
  *
  * Similarly, @i_mutex is not always locked in 'ubifs_readpage()', e.g., the
  * read-ahead path does not lock it ("sys_read -> generic_file_aio_read ->
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index 5862dd9..e924dbf 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -303,7 +303,7 @@ static int ubifs_write_inode(struct inode *inode, struct writeback_control *wbc)
 	mutex_lock(&ui->ui_mutex);
 	/*
 	 * Due to races between write-back forced by budgeting
-	 * (see 'sync_some_inodes()') and pdflush write-back, the inode may
+	 * (see 'sync_some_inodes()') and background write-back, the inode may
 	 * have already been synchronized, do not do this again. This might
 	 * also happen if it was synchronized in an VFS operation, e.g.
 	 * 'ubifs_link()'.
-- 
1.7.10

