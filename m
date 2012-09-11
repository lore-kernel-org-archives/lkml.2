Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab2IKO3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 10:29:25 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:50320 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756070Ab2IKO3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 10:29:22 -0400
From: zwu.kernel@gmail.com
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
        viro@zeniv.linux.org.uk, hch@lst.de, chris.mason@fusionio.com,
        cmm@us.ibm.com, linuxram@us.ibm.com, aneesh.kumar@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: [RFC 01/11] vfs: introduce one structure hot_info
Date: Tue, 11 Sep 2012 22:27:15 +0800
Message-Id: <1347373645-2119-2-git-send-email-zwu.kernel@gmail.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1347373645-2119-1-git-send-email-zwu.kernel@gmail.com>
References: <1347373645-2119-1-git-send-email-zwu.kernel@gmail.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091114-7182-0000-0000-00000292B6C0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

   One root structure hot_info is defined, is hooked
up in super_block, and will be used to hold rb trees
root, hash list root and some other information, etc.

Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
---
 include/linux/fs.h        |    4 ++++
 include/linux/hot_track.h |   26 ++++++++++++++++++++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/hot_track.h

diff --git a/include/linux/fs.h b/include/linux/fs.h
index aa11047..6229895 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -415,6 +415,7 @@ struct inodes_stat_t {
 #include <linux/migrate_mode.h>
 #include <linux/uidgid.h>
 #include <linux/lockdep.h>
+#include <linux/hot_track.h>
 
 #include <asm/byteorder.h>
 
@@ -1578,6 +1579,9 @@ struct super_block {
 
 	/* Being remounted read-only */
 	int s_readonly_remount;
+
+	/* Hot data tracking info*/
+	struct hot_info s_hotinfo;
 };
 
 /* superblock cache pruning functions */
diff --git a/include/linux/hot_track.h b/include/linux/hot_track.h
new file mode 100644
index 0000000..5716b93
--- /dev/null
+++ b/include/linux/hot_track.h
@@ -0,0 +1,26 @@
+/*
+ *  include/linux/hot_track.h
+ *
+ * This file has definitions for VFS hot data tracking
+ * structures etc.
+ *
+ * Copyright (C) 2012 IBM Corp. All rights reserved.
+ * Written by Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
+ *            Ben Chociej <bchociej@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ */
+
+#ifndef _LINUX_HOTTRACK_H
+#define _LINUX_HOTTRACK_H
+
+#include <linux/types.h>
+#include <linux/rbtree.h>
+#include <linux/kref.h>
+
+struct hot_info {
+};
+
+#endif  /* _LINUX_HOTTRACK_H */
-- 
1.7.6.5

