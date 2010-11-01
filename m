Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab0KASmD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:42:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53969 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905Ab0KASlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:41:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=j/snSZhltFKoeJiXkpNRckjeni3PD3kz8cK5bSqgjn79KWyk+z2jG6FUE5q0b+nfpF
         R4ZCEsD+CvT5z9AKuCR2erRAEiCfbIu3BUTpSweRQSHwdOB10sqQ30yyMhAJYQ9MOy6j
         h0UQyzWbhJZnvYvKrtwSUPDcSUTgm5yjqVdcE=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 09/29] Staging: yaffs2: yaffs_getblockinfo.h: Add file
Date: Mon,  1 Nov 2010 14:40:57 -0400
Message-Id: <1288636877-7964-10-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding files to yaffs2 directory.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/yaffs2/yaffs_getblockinfo.h |   35 +++++++++++++++++++++++++++
 1 files changed, 35 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/yaffs2/yaffs_getblockinfo.h

diff --git a/drivers/staging/yaffs2/yaffs_getblockinfo.h b/drivers/staging/yaffs2/yaffs_getblockinfo.h
new file mode 100644
index 0000000..1c43b6c
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_getblockinfo.h
@@ -0,0 +1,35 @@
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
+#ifndef __YAFFS_GETBLOCKINFO_H__
+#define __YAFFS_GETBLOCKINFO_H__
+
+#include "yaffs_guts.h"
+#include "yaffs_trace.h"
+
+/* Function to manipulate block info */
+static Y_INLINE yaffs_block_info_t *yaffs_get_block_info(yaffs_dev_t * dev, int blk)
+{
+	if (blk < dev->internal_start_block || blk > dev->internal_end_block) {
+		T(YAFFS_TRACE_ERROR,
+		  (TSTR
+		   ("**>> yaffs: get_block_info block %d is not valid" TENDSTR),
+		   blk));
+		YBUG();
+	}
+	return &dev->block_info[blk - dev->internal_start_block];
+}
+
+#endif
-- 
1.7.3.2.146.gca209

