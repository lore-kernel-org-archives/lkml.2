Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab1FORXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 13:23:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61830 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab1FORXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 13:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=oH2E+Pr7j4+jTywNEZFTE1sM2Z8b6tBGsNSUpFk0EOt0AKXFrk+o2UCZtK4FJ868/3
         uGqkrbWsf+D4DLxbRWFUISMl15+y3TaBBN83JzmNtmaxsWBtFD1F+HIzYjaZvLbH91IV
         yvpbRPrcHdEjqBJLGd/iMADYSKEvYye6yRms0=
From: dirk.brandewie@gmail.com
To: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/5] spi/dw_spi: expose dw_spi platform data stucture.
Date: Wed, 15 Jun 2011 10:23:05 -0700
Message-Id: <1308158588-17249-3-git-send-email-dirk.brandewie@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1308158588-17249-1-git-send-email-dirk.brandewie@gmail.com>
References: <1308158588-17249-1-git-send-email-dirk.brandewie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.brandewie@gmail.com>

This patch move the definition of the dw_spi_chip structure to
a header file available to the client drivers.

Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/spi/spi-dw.h       |   20 +-------------------
 include/linux/spi/spi-dw.h |   20 ++++++++++++++++++++
 2 files changed, 21 insertions(+), 19 deletions(-)
 create mode 100644 include/linux/spi/spi-dw.h

diff --git a/drivers/spi/spi-dw.h b/drivers/spi/spi-dw.h
index 7a5e78d..97baff6 100644
--- a/drivers/spi/spi-dw.h
+++ b/drivers/spi/spi-dw.h
@@ -3,6 +3,7 @@
 
 #include <linux/io.h>
 #include <linux/scatterlist.h>
+#include <linux/spi/dw_spi.h>
 
 /* Bit fields in CTRLR0 */
 #define SPI_DFS_OFFSET			0
@@ -49,12 +50,6 @@
 /* TX RX interrupt level threshold, max can be 256 */
 #define SPI_INT_THRESHOLD		32
 
-enum dw_ssi_type {
-	SSI_MOTO_SPI = 0,
-	SSI_TI_SSP,
-	SSI_NS_MICROWIRE,
-};
-
 struct dw_spi_reg {
 	u32	ctrl0;
 	u32	ctrl1;
@@ -208,19 +203,6 @@ static inline void spi_umask_intr(struct dw_spi *dws, u32 mask)
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
-
 extern int dw_spi_add_host(struct dw_spi *dws);
 extern void dw_spi_remove_host(struct dw_spi *dws);
 extern int dw_spi_suspend_host(struct dw_spi *dws);
diff --git a/include/linux/spi/spi-dw.h b/include/linux/spi/spi-dw.h
new file mode 100644
index 0000000..75dba03
--- /dev/null
+++ b/include/linux/spi/spi-dw.h
@@ -0,0 +1,20 @@
+#ifndef DW_SPI_H
+#define DW_SPI_H
+
+enum dw_ssi_type {
+	SSI_MOTO_SPI = 0,
+	SSI_TI_SSP,
+	SSI_NS_MICROWIRE,
+};
+
+/*
+ * Each SPI slave device to work with dw_api controller should
+ * has such a structure claiming its working mode (PIO/DMA etc),
+ * which can be save in the "controller_data" member of the
+ * struct spi_device
+ */
+struct dw_spi_chip {
+	u8 type;	/* SPI/SSP/Micrwire */
+	u8 enable_dma;
+};
+#endif /* DW_SPI_H */
-- 
1.7.3.4

