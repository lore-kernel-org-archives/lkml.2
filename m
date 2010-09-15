Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab0IOOt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 10:49:27 -0400
Received: from smtp-gw11.han.skanova.net ([81.236.55.20]:34512 "EHLO
	smtp-gw11.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab0IOOt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 10:49:26 -0400
Subject: [PATCH] mfd: timberdale: Use DMA for ks8842
From: Richard =?ISO-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Sep 2010 16:49:24 +0200
Message-ID: <1284562164.23817.8.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch defines platform data for the ks8842 int the timberdale
MFD.
The platform data contains DMA channels to be used by the driver.

Signed-off-by: Richard Röjfors <richard.rojfors@pelagicore.com>
---
diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index ac59950..727f62c 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -43,6 +43,8 @@
 
 #include <linux/timb_dma.h>
 
+#include <linux/ks8842.h>
+
 #include "timberdale.h"
 
 #define DRIVER_NAME "timberdale"
@@ -161,6 +163,12 @@ static const __devinitconst struct resource timberdale_spi_resources[] = {
 	},
 };
 
+static __devinitdata struct ks8842_platform_data
+	timberdale_ks8842_platform_data = {
+	.rx_dma_channel = DMA_ETH_RX,
+	.tx_dma_channel = DMA_ETH_TX
+};
+
 static const __devinitconst struct resource timberdale_eth_resources[] = {
 	{
 		.start	= ETHOFFSET,
@@ -389,6 +397,8 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg0[] = {
 		.name = "ks8842",
 		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
 		.resources = timberdale_eth_resources,
+		.platform_data = &timberdale_ks8842_platform_data,
+		.data_size = sizeof(timberdale_ks8842_platform_data)
 	},
 };
 
@@ -447,6 +457,8 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg1[] = {
 		.name = "ks8842",
 		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
 		.resources = timberdale_eth_resources,
+		.platform_data = &timberdale_ks8842_platform_data,
+		.data_size = sizeof(timberdale_ks8842_platform_data)
 	},
 };
 
@@ -538,6 +550,8 @@ static __devinitdata struct mfd_cell timberdale_cells_bar0_cfg3[] = {
 		.name = "ks8842",
 		.num_resources = ARRAY_SIZE(timberdale_eth_resources),
 		.resources = timberdale_eth_resources,
+		.platform_data = &timberdale_ks8842_platform_data,
+		.data_size = sizeof(timberdale_ks8842_platform_data)
 	},
 };
 

