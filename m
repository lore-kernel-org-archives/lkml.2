Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823Ab1FWCAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 22:00:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60829 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758782Ab1FWCAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 22:00:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YzuoC8qBDiAWaMsDIve7egXBb3qBjG60G6v52qzQjAh0yDPzuxBNF7rgEur8OugSU/
         i3QKuhgye/Yudot1n98y9kQotj/9UfsjdOQp38hZQPwYHCL6TjtmxyNAV5PevJlMVUE3
         TA+neKtN1ycgBG+Dff4nu/+K5lIz9d7Qsxrks=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: [PATCH 01/11] spi-dw: expose platform data stucture.
Date: Wed, 22 Jun 2011 19:00:03 -0700
Message-Id: <1308794413-11069-2-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

Expose the platform data structure for use by client drivers. ATM
there are not any in-tree drivers using the driver (that I can
find). This patch exposes the platform data needed for client drivers.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
---
 drivers/spi/spi-dw.c       |    3 ---
 drivers/spi/spi-dw.h       |   18 +-----------------
 include/linux/spi/spi-dw.h |   42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+), 20 deletions(-)
 create mode 100644 include/linux/spi/spi-dw.h

diff --git a/drivers/spi/spi-dw.c b/drivers/spi/spi-dw.c
index ece5f69..61f7ed8 100644
--- a/drivers/spi/spi-dw.c
+++ b/drivers/spi/spi-dw.c
@@ -38,9 +38,6 @@
 #define QUEUE_RUNNING	0
 #define QUEUE_STOPPED	1
 
-#define MRST_SPI_DEASSERT	0
-#define MRST_SPI_ASSERT		1
-
 /* Slave spi_dev related */
 struct chip_data {
 	u16 cr0;
diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
index 7a5e78d..92bee30 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -3,6 +3,7 @@
 
 #include <linux/io.h>
 #include <linux/scatterlist.h>
+#include <linux/spi/spi-dw.h>
 
 /* Bit fields in CTRLR0 */
 #define SPI_DFS_OFFSET			0
@@ -49,11 +50,6 @@
 /* TX RX interrupt level threshold, max can be 256 */
 #define SPI_INT_THRESHOLD		32
 
-enum dw_ssi_type {
-	SSI_MOTO_SPI = 0,
-	SSI_TI_SSP,
-	SSI_NS_MICROWIRE,
-};
 
 struct dw_spi_reg {
 	u32	ctrl0;
@@ -208,18 +204,6 @@ static inline void spi_umask_intr(struct dw_spi *dws, u32 mask)
 	dw_writel(dws, imr, new_mask);
 }
 
-/*
- * Each SPI slave device to work with dw_api controller should
- * has such a structure claiming its working mode (PIO/DMA etc),
- * which can be save in the "controller_data" member of the
- * struct spi_device
- */
-struct dw_spi_chip {
-	u8 poll_mode;	/* 0 for contoller polling mode */
-	u8 type;	/* SPI/SSP/Micrwire */
-	u8 enable_dma;
-	void (*cs_control)(u32 command);
-};
 
 extern int dw_spi_add_host(struct dw_spi *dws);
 extern void dw_spi_remove_host(struct dw_spi *dws);
diff --git a/include/linux/spi/spi-dw.h b/include/linux/spi/spi-dw.h
new file mode 100644
index 0000000..787b154
--- /dev/null
+++ b/include/linux/spi/spi-dw.h
@@ -0,0 +1,42 @@
+/*
+ *
+ * Copyright (c) 2009, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef _SPI_DW_H_
+#define _SPI_DW_H_
+enum spi_dw_ssi_type {
+	SSI_MOTO_SPI = 0,
+	SSI_TI_SSP,
+	SSI_NS_MICROWIRE,
+};
+
+#define MRST_SPI_DEASSERT	0
+#define MRST_SPI_ASSERT		1
+
+/*
+ * Each SPI slave device to work with dw_api controller should
+ * has such a structure claiming its working mode (PIO/DMA etc),
+ * which can be save in the "controller_data" member of the
+ * struct spi_device
+ */
+struct spi_dw_chip {
+	u8 poll_mode;	/* 0 for contoller polling mode */
+	u8 type;	/* SPI/SSP/Micrwire */
+	u8 enable_dma;
+	void (*cs_control)(u32 command);
+};
+#endif
-- 
1.7.3.4

