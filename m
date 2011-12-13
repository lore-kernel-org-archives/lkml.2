Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab1LMPkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 10:40:39 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43726 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755043Ab1LMPkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 10:40:35 -0500
From: Shawn Guo <shawn.guo@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>, Chris Ball <cjb@laptop.org>,
        Artem Bityutskiy <artem.bityutskiy@intel.com>
Cc: Huang Shijie <b32955@freescale.com>, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 3/4] mtd: fix compile error for gpmi-nand
Date: Tue, 13 Dec 2011 23:48:05 +0800
Message-Id: <1323791286-29574-4-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
References: <1323791286-29574-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Shijie <b32955@freescale.com>

The driver gpmi-nand should compile at least.  This patch adds the
missing gpmi-nand.h to fix the compile error below.

  CC      drivers/mtd/nand/gpmi-nand/gpmi-nand.o
  CC      drivers/mtd/nand/gpmi-nand/gpmi-lib.o
drivers/mtd/nand/gpmi-nand/gpmi-nand.c:25:33: fatal error: linux/mtd/gpmi-nand.h: No such file or directory
drivers/mtd/nand/gpmi-nand/gpmi-lib.c:21:33: fatal error: linux/mtd/gpmi-nand.h: No such file or directory

This header is grabbed from patch below, which has not been postponed
for merging.

  [PATCH v8 1/4] ARM: mxs: add GPMI-NAND support for imx23/imx28
  http://permalink.gmane.org/gmane.linux.drivers.mtd/37338

Signed-off-by: Huang Shijie <b32955@freescale.com>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 include/linux/mtd/gpmi-nand.h |   68 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 68 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/mtd/gpmi-nand.h

diff --git a/include/linux/mtd/gpmi-nand.h b/include/linux/mtd/gpmi-nand.h
new file mode 100644
index 0000000..69b6dbf
--- /dev/null
+++ b/include/linux/mtd/gpmi-nand.h
@@ -0,0 +1,68 @@
+/*
+ * Copyright (C) 2011 Freescale Semiconductor, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#ifndef __MACH_MXS_GPMI_NAND_H__
+#define __MACH_MXS_GPMI_NAND_H__
+
+/* The size of the resources is fixed. */
+#define GPMI_NAND_RES_SIZE	6
+
+/* Resource names for the GPMI NAND driver. */
+#define GPMI_NAND_GPMI_REGS_ADDR_RES_NAME  "GPMI NAND GPMI Registers"
+#define GPMI_NAND_GPMI_INTERRUPT_RES_NAME  "GPMI NAND GPMI Interrupt"
+#define GPMI_NAND_BCH_REGS_ADDR_RES_NAME   "GPMI NAND BCH Registers"
+#define GPMI_NAND_BCH_INTERRUPT_RES_NAME   "GPMI NAND BCH Interrupt"
+#define GPMI_NAND_DMA_CHANNELS_RES_NAME    "GPMI NAND DMA Channels"
+#define GPMI_NAND_DMA_INTERRUPT_RES_NAME   "GPMI NAND DMA Interrupt"
+
+/**
+ * struct gpmi_nand_platform_data - GPMI NAND driver platform data.
+ *
+ * This structure communicates platform-specific information to the GPMI NAND
+ * driver that can't be expressed as resources.
+ *
+ * @platform_init:           A pointer to a function the driver will call to
+ *                           initialize the platform (e.g., set up the pin mux).
+ * @min_prop_delay_in_ns:    Minimum propagation delay of GPMI signals to and
+ *                           from the NAND Flash device, in nanoseconds.
+ * @max_prop_delay_in_ns:    Maximum propagation delay of GPMI signals to and
+ *                           from the NAND Flash device, in nanoseconds.
+ * @max_chip_count:          The maximum number of chips for which the driver
+ *                           should configure the hardware. This value most
+ *                           likely reflects the number of pins that are
+ *                           connected to a NAND Flash device. If this is
+ *                           greater than the SoC hardware can support, the
+ *                           driver will print a message and fail to initialize.
+ * @partitions:              An optional pointer to an array of partition
+ *                           descriptions.
+ * @partition_count:         The number of elements in the partitions array.
+ */
+struct gpmi_nand_platform_data {
+	/* SoC hardware information. */
+	int		(*platform_init)(void);
+
+	/* NAND Flash information. */
+	unsigned int	min_prop_delay_in_ns;
+	unsigned int	max_prop_delay_in_ns;
+	unsigned int	max_chip_count;
+
+	/* Medium information. */
+	struct		mtd_partition *partitions;
+	unsigned	partition_count;
+};
+#endif
-- 
1.7.4.1

