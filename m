Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3AFWnf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 17:43:35 -0500
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:34634 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753166Ab3AFWnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 17:43:32 -0500
From: Linus Walleij <linus.walleij@stericsson.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: <linux-kernel@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 1/8] dma: coh901318: create a proper platform data file
Date: Sun, 6 Jan 2013 23:43:15 +0100
Message-ID: <1357512195-5602-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This extracts the platform data that we will keep generic
from the U300 platform and associates it with the COH901318
driver in <linux/platform_data/dma-coh901318.h>.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-u300/core.c                   |  2 +-
 arch/arm/mach-u300/dma_channels.h           | 60 ------------------------
 arch/arm/mach-u300/include/mach/coh901318.h | 16 -------
 arch/arm/mach-u300/spi.c                    |  2 +-
 drivers/dma/coh901318.c                     |  1 +
 include/linux/platform_data/dma-coh901318.h | 72 +++++++++++++++++++++++++++++
 6 files changed, 75 insertions(+), 78 deletions(-)
 delete mode 100644 arch/arm/mach-u300/dma_channels.h
 create mode 100644 include/linux/platform_data/dma-coh901318.h

diff --git a/arch/arm/mach-u300/core.c b/arch/arm/mach-u300/core.c
index 4ce77cd..0951b51 100644
--- a/arch/arm/mach-u300/core.c
+++ b/arch/arm/mach-u300/core.c
@@ -31,6 +31,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/platform_data/clk-u300.h>
 #include <linux/platform_data/pinctrl-coh901.h>
+#include <linux/platform_data/dma-coh901318.h>
 
 #include <asm/types.h>
 #include <asm/setup.h>
@@ -49,7 +50,6 @@
 #include "spi.h"
 #include "i2c.h"
 #include "u300-gpio.h"
-#include "dma_channels.h"
 
 /*
  * Static I/O mappings that are needed for booting the U300 platforms. The
diff --git a/arch/arm/mach-u300/dma_channels.h b/arch/arm/mach-u300/dma_channels.h
deleted file mode 100644
index 4e8a88f..0000000
--- a/arch/arm/mach-u300/dma_channels.h
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- *
- * arch/arm/mach-u300/include/mach/dma_channels.h
- *
- *
- * Copyright (C) 2007-2012 ST-Ericsson
- * License terms: GNU General Public License (GPL) version 2
- * Map file for the U300 dma driver.
- * Author: Per Friden <per.friden@stericsson.com>
- */
-
-#ifndef DMA_CHANNELS_H
-#define DMA_CHANNELS_H
-
-#define U300_DMA_MSL_TX_0             0
-#define U300_DMA_MSL_TX_1             1
-#define U300_DMA_MSL_TX_2             2
-#define U300_DMA_MSL_TX_3             3
-#define U300_DMA_MSL_TX_4             4
-#define U300_DMA_MSL_TX_5             5
-#define U300_DMA_MSL_TX_6             6
-#define U300_DMA_MSL_RX_0             7
-#define U300_DMA_MSL_RX_1             8
-#define U300_DMA_MSL_RX_2             9
-#define U300_DMA_MSL_RX_3             10
-#define U300_DMA_MSL_RX_4             11
-#define U300_DMA_MSL_RX_5             12
-#define U300_DMA_MSL_RX_6             13
-#define U300_DMA_MMCSD_RX_TX          14
-#define U300_DMA_MSPRO_TX             15
-#define U300_DMA_MSPRO_RX             16
-#define U300_DMA_UART0_TX             17
-#define U300_DMA_UART0_RX             18
-#define U300_DMA_APEX_TX              19
-#define U300_DMA_APEX_RX              20
-#define U300_DMA_PCM_I2S0_TX          21
-#define U300_DMA_PCM_I2S0_RX          22
-#define U300_DMA_PCM_I2S1_TX          23
-#define U300_DMA_PCM_I2S1_RX          24
-#define U300_DMA_XGAM_CDI             25
-#define U300_DMA_XGAM_PDI             26
-#define U300_DMA_SPI_TX               27
-#define U300_DMA_SPI_RX               28
-#define U300_DMA_GENERAL_PURPOSE_0    29
-#define U300_DMA_GENERAL_PURPOSE_1    30
-#define U300_DMA_GENERAL_PURPOSE_2    31
-#define U300_DMA_GENERAL_PURPOSE_3    32
-#define U300_DMA_GENERAL_PURPOSE_4    33
-#define U300_DMA_GENERAL_PURPOSE_5    34
-#define U300_DMA_GENERAL_PURPOSE_6    35
-#define U300_DMA_GENERAL_PURPOSE_7    36
-#define U300_DMA_GENERAL_PURPOSE_8    37
-#define U300_DMA_UART1_TX             38
-#define U300_DMA_UART1_RX             39
-
-#define U300_DMA_DEVICE_CHANNELS      32
-#define U300_DMA_CHANNELS             40
-
-
-#endif /* DMA_CHANNELS_H */
diff --git a/arch/arm/mach-u300/include/mach/coh901318.h b/arch/arm/mach-u300/include/mach/coh901318.h
index 7c3b2b2..fc47d30 100644
--- a/arch/arm/mach-u300/include/mach/coh901318.h
+++ b/arch/arm/mach-u300/include/mach/coh901318.h
@@ -102,22 +102,6 @@ struct coh901318_platform {
 	const int max_channels;
 };
 
-#ifdef CONFIG_COH901318
-/**
- * coh901318_filter_id() - DMA channel filter function
- * @chan: dma channel handle
- * @chan_id: id of dma channel to be filter out
- *
- * In dma_request_channel() it specifies what channel id to be requested
- */
-bool coh901318_filter_id(struct dma_chan *chan, void *chan_id);
-#else
-static inline bool coh901318_filter_id(struct dma_chan *chan, void *chan_id)
-{
-	return false;
-}
-#endif
-
 /*
  * DMA Controller - this access the static mappings of the coh901318 dma.
  *
diff --git a/arch/arm/mach-u300/spi.c b/arch/arm/mach-u300/spi.c
index 02e6659..b34567f 100644
--- a/arch/arm/mach-u300/spi.c
+++ b/arch/arm/mach-u300/spi.c
@@ -10,9 +10,9 @@
 #include <linux/amba/bus.h>
 #include <linux/spi/spi.h>
 #include <linux/amba/pl022.h>
+#include <linux/platform_data/dma-coh901318.h>
 #include <linux/err.h>
 #include <mach/coh901318.h>
-#include "dma_channels.h"
 
 /*
  * The following is for the actual devices on the SSP/SPI bus
diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index aa384e5..5fdd38b 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -21,6 +21,7 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 #include <linux/debugfs.h>
+#include <linux/platform_data/dma-coh901318.h>
 #include <mach/coh901318.h>
 
 #include "coh901318_lli.h"
diff --git a/include/linux/platform_data/dma-coh901318.h b/include/linux/platform_data/dma-coh901318.h
new file mode 100644
index 0000000..c4cb959
--- /dev/null
+++ b/include/linux/platform_data/dma-coh901318.h
@@ -0,0 +1,72 @@
+/*
+ * Platform data for the COH901318 DMA controller
+ * Copyright (C) 2007-2013 ST-Ericsson
+ * License terms: GNU General Public License (GPL) version 2
+ */
+
+#ifndef PLAT_COH901318_H
+#define PLAT_COH901318_H
+
+#ifdef CONFIG_COH901318
+
+/* We only support the U300 DMA channels */
+#define U300_DMA_MSL_TX_0		0
+#define U300_DMA_MSL_TX_1		1
+#define U300_DMA_MSL_TX_2		2
+#define U300_DMA_MSL_TX_3		3
+#define U300_DMA_MSL_TX_4		4
+#define U300_DMA_MSL_TX_5		5
+#define U300_DMA_MSL_TX_6		6
+#define U300_DMA_MSL_RX_0		7
+#define U300_DMA_MSL_RX_1		8
+#define U300_DMA_MSL_RX_2		9
+#define U300_DMA_MSL_RX_3		10
+#define U300_DMA_MSL_RX_4		11
+#define U300_DMA_MSL_RX_5		12
+#define U300_DMA_MSL_RX_6		13
+#define U300_DMA_MMCSD_RX_TX		14
+#define U300_DMA_MSPRO_TX		15
+#define U300_DMA_MSPRO_RX		16
+#define U300_DMA_UART0_TX		17
+#define U300_DMA_UART0_RX		18
+#define U300_DMA_APEX_TX		19
+#define U300_DMA_APEX_RX		20
+#define U300_DMA_PCM_I2S0_TX		21
+#define U300_DMA_PCM_I2S0_RX		22
+#define U300_DMA_PCM_I2S1_TX		23
+#define U300_DMA_PCM_I2S1_RX		24
+#define U300_DMA_XGAM_CDI		25
+#define U300_DMA_XGAM_PDI		26
+#define U300_DMA_SPI_TX			27
+#define U300_DMA_SPI_RX			28
+#define U300_DMA_GENERAL_PURPOSE_0	29
+#define U300_DMA_GENERAL_PURPOSE_1	30
+#define U300_DMA_GENERAL_PURPOSE_2	31
+#define U300_DMA_GENERAL_PURPOSE_3	32
+#define U300_DMA_GENERAL_PURPOSE_4	33
+#define U300_DMA_GENERAL_PURPOSE_5	34
+#define U300_DMA_GENERAL_PURPOSE_6	35
+#define U300_DMA_GENERAL_PURPOSE_7	36
+#define U300_DMA_GENERAL_PURPOSE_8	37
+#define U300_DMA_UART1_TX		38
+#define U300_DMA_UART1_RX		39
+
+#define U300_DMA_DEVICE_CHANNELS	32
+#define U300_DMA_CHANNELS		40
+
+/**
+ * coh901318_filter_id() - DMA channel filter function
+ * @chan: dma channel handle
+ * @chan_id: id of dma channel to be filter out
+ *
+ * In dma_request_channel() it specifies what channel id to be requested
+ */
+bool coh901318_filter_id(struct dma_chan *chan, void *chan_id);
+#else
+static inline bool coh901318_filter_id(struct dma_chan *chan, void *chan_id)
+{
+	return false;
+}
+#endif
+
+#endif /* PLAT_COH901318_H */
-- 
1.7.11.3

