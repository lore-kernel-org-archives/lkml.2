Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab0KASsg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:48:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53969 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab0KASl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:41:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Fd6gNjDNwWmT6cM51tjTw7W11mInACIDgj1xEh6L097Ywk9cKzLBDJCPqfA1Jz30HL
         m+yZXPh8Docg5K/Ym4D3G2NRqkCKdmCXRgIxL8efWR+4IqT6iEwKnOMHaotIPiCWRt5r
         90ZrSYV+GZ+w9jUSJzUR26U5UQ1+Ab7Wz9Mn8=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 11/29] Staging: yaffs2: yaffs_linux.h: Add file
Date: Mon,  1 Nov 2010 14:40:59 -0400
Message-Id: <1288636877-7964-12-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding files to yaffs2 directory.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/yaffs2/yaffs_linux.h |   43 ++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/yaffs2/yaffs_linux.h

diff --git a/drivers/staging/yaffs2/yaffs_linux.h b/drivers/staging/yaffs2/yaffs_linux.h
new file mode 100644
index 0000000..a8e3f85
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_linux.h
@@ -0,0 +1,43 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License version 2.1 as
+ * published by the Free Software Foundation.
+ *
+ * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
+ */
+
+#ifndef __YAFFS_LINUX_H__
+#define __YAFFS_LINUX_H__
+
+#include "devextras.h"
+#include "yportenv.h"
+
+struct yaffs_linux_context {
+	struct ylist_head	context_list; /* List of these we have mounted */
+	struct yaffs_dev_s *dev;
+	struct super_block * super;
+	struct task_struct *bg_thread; /* Background thread for this device */
+	int bg_running;
+        struct semaphore gross_lock;     /* Gross locking semaphore */
+	__u8 *spare_buffer;      /* For mtdif2 use. Don't know the size of the buffer
+				 * at compile time so we have to allocate it.
+				 */
+	struct ylist_head search_contexts;
+	void (*put_super_fn)(struct super_block *sb);
+
+	struct task_struct *readdir_process;
+	unsigned mount_id;
+};
+
+#define yaffs_dev_to_lc(dev) ((struct yaffs_linux_context *)((dev)->os_context))
+#define yaffs_dev_to_mtd(dev) ((struct mtd_info *)((dev)->driver_context))
+
+#endif
+
-- 
1.7.3.2.146.gca209

