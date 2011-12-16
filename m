Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781Ab1LPHr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 02:47:27 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39646 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab1LPHrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 02:47:25 -0500
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] fs: Move attribute flags into non __KERNEL__ space
Date: Fri, 16 Dec 2011 09:47:06 +0200
Message-Id: <1324021626-10059-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attribute flags can be useful in userspace when working with filesystems
such as 9p.

Theres no reason to limit them to kernel space only.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 include/linux/fs.h |   44 ++++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index e0bc4ff..c51d344 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -374,6 +374,28 @@ struct inodes_stat_t {
 #define SYNC_FILE_RANGE_WRITE		2
 #define SYNC_FILE_RANGE_WAIT_AFTER	4
 
+/*
+ * Attribute flags.  These should be or-ed together to figure out what
+ * has been changed!
+ */
+#define ATTR_MODE	(1 << 0)
+#define ATTR_UID	(1 << 1)
+#define ATTR_GID	(1 << 2)
+#define ATTR_SIZE	(1 << 3)
+#define ATTR_ATIME	(1 << 4)
+#define ATTR_MTIME	(1 << 5)
+#define ATTR_CTIME	(1 << 6)
+#define ATTR_ATIME_SET	(1 << 7)
+#define ATTR_MTIME_SET	(1 << 8)
+#define ATTR_FORCE	(1 << 9) /* Not a change, but a change it */
+#define ATTR_ATTR_FLAG	(1 << 10)
+#define ATTR_KILL_SUID	(1 << 11)
+#define ATTR_KILL_SGID	(1 << 12)
+#define ATTR_FILE	(1 << 13)
+#define ATTR_KILL_PRIV	(1 << 14)
+#define ATTR_OPEN	(1 << 15) /* Truncating from open(O_TRUNC) */
+#define ATTR_TIMES_SET	(1 << 16)
+
 #ifdef __KERNEL__
 
 #include <linux/linkage.h>
@@ -429,28 +451,6 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 			bool is_async);
 
 /*
- * Attribute flags.  These should be or-ed together to figure out what
- * has been changed!
- */
-#define ATTR_MODE	(1 << 0)
-#define ATTR_UID	(1 << 1)
-#define ATTR_GID	(1 << 2)
-#define ATTR_SIZE	(1 << 3)
-#define ATTR_ATIME	(1 << 4)
-#define ATTR_MTIME	(1 << 5)
-#define ATTR_CTIME	(1 << 6)
-#define ATTR_ATIME_SET	(1 << 7)
-#define ATTR_MTIME_SET	(1 << 8)
-#define ATTR_FORCE	(1 << 9) /* Not a change, but a change it */
-#define ATTR_ATTR_FLAG	(1 << 10)
-#define ATTR_KILL_SUID	(1 << 11)
-#define ATTR_KILL_SGID	(1 << 12)
-#define ATTR_FILE	(1 << 13)
-#define ATTR_KILL_PRIV	(1 << 14)
-#define ATTR_OPEN	(1 << 15) /* Truncating from open(O_TRUNC) */
-#define ATTR_TIMES_SET	(1 << 16)
-
-/*
  * This is the Inode Attributes structure, used for notify_change().  It
  * uses the above definitions as flags, to know which values have changed.
  * Also, in this manner, a Filesystem can look at only the values it cares
-- 
1.7.8

