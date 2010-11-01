Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab0KASr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:47:58 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45912 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118Ab0KASmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:42:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VJZxWOn4zeB97OW1xivxOUD5FxZH9RmsjpXJ4bIcuh+S3ezq4h66aOSw6SN+YR1Ypk
         8N+yYnWSoNCS/E9ThiilR+sU6D03AQMDVI8Bvu0hc9voVYT2hMi9R+lf1tvrdSze/WQ3
         WjyuxE2mjHHw/5BoO9UxUtEIEy1b2fP/Uk+VQ=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 13/29] Staging: yaffs2: yaffs_mtdif: Add files
Date: Mon,  1 Nov 2010 14:41:01 -0400
Message-Id: <1288636877-7964-14-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding files to yaffs2 directory.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/yaffs2/yaffs_mtdif.c |   56 ++++++++++++++++++++++++++++++++++
 drivers/staging/yaffs2/yaffs_mtdif.h |   27 ++++++++++++++++
 2 files changed, 83 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/yaffs2/yaffs_mtdif.c
 create mode 100644 drivers/staging/yaffs2/yaffs_mtdif.h

diff --git a/drivers/staging/yaffs2/yaffs_mtdif.c b/drivers/staging/yaffs2/yaffs_mtdif.c
new file mode 100644
index 0000000..4fd8994
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_mtdif.c
@@ -0,0 +1,56 @@
+/*
+ * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "yportenv.h"
+
+
+#include "yaffs_mtdif.h"
+
+#include "linux/mtd/mtd.h"
+#include "linux/types.h"
+#include "linux/time.h"
+#include "linux/mtd/nand.h"
+
+#include "yaffs_linux.h"
+
+int nandmtd_erase_block(yaffs_dev_t *dev, int block_no)
+{
+	struct mtd_info *mtd = yaffs_dev_to_mtd(dev);
+	__u32 addr =
+	    ((loff_t) block_no) * dev->param.total_bytes_per_chunk
+		* dev->param.chunks_per_block;
+	struct erase_info ei;
+	
+	int retval = 0;
+
+	ei.mtd = mtd;
+	ei.addr = addr;
+	ei.len = dev->param.total_bytes_per_chunk * dev->param.chunks_per_block;
+	ei.time = 1000;
+	ei.retries = 2;
+	ei.callback = NULL;
+	ei.priv = (u_long) dev;
+
+	retval = mtd->erase(mtd, &ei);
+
+	if (retval == 0)
+		return YAFFS_OK;
+	else
+		return YAFFS_FAIL;
+}
+
+int nandmtd_initialise(yaffs_dev_t *dev)
+{
+	return YAFFS_OK;
+}
+
diff --git a/drivers/staging/yaffs2/yaffs_mtdif.h b/drivers/staging/yaffs2/yaffs_mtdif.h
new file mode 100644
index 0000000..919d354
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_mtdif.h
@@ -0,0 +1,27 @@
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
+#ifndef __YAFFS_MTDIF_H__
+#define __YAFFS_MTDIF_H__
+
+#include "yaffs_guts.h"
+
+#if (MTD_VERSION_CODE < MTD_VERSION(2, 6, 18))
+extern struct nand_oobinfo yaffs_oobinfo;
+extern struct nand_oobinfo yaffs_noeccinfo;
+#endif
+int nandmtd_erase_block(yaffs_dev_t *dev, int block_no);
+int nandmtd_initialise(yaffs_dev_t *dev);
+#endif
-- 
1.7.3.2.146.gca209

