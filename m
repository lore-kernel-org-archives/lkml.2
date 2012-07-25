Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab2GYLyP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:54:15 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35542 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756639Ab2GYLyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:54:09 -0400
From: Fabio Estevam <festevam@gmail.com>
To: vinod.koul@intel.com
Cc: kernel@pengutronix.de, marex@denx.de, linux-kernel@vger.kernel.org,
        shawn.guo@linaro.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] dma: mxs_dma: Add the missing entries for mx6
Date: Wed, 25 Jul 2012 08:54:02 -0300
Message-Id: <1343217242-32686-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Add the missing entries for mx6.

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
Build tested only, as I currently do not have mx6 board handy.

 drivers/dma/mxs-dma.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index 7f41b25..6e8509b 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -128,6 +128,7 @@ enum mxs_dma_devtype {
 enum mxs_dma_id {
 	IMX23_DMA,
 	IMX28_DMA,
+	IMX6Q_DMA,
 };
 
 struct mxs_dma_engine {
@@ -158,7 +159,10 @@ static struct mxs_dma_type mxs_dma_types[] = {
 	}, {
 		.id = IMX28_DMA,
 		.type = MXS_DMA_APBX,
-	}
+	}, {
+		.id = IMX6Q_DMA,
+		.type = MXS_DMA_APBH,
+	},
 };
 
 static struct platform_device_id mxs_dma_ids[] = {
@@ -175,6 +179,8 @@ static struct platform_device_id mxs_dma_ids[] = {
 		.name = "imx28-dma-apbx",
 		.driver_data = (kernel_ulong_t) &mxs_dma_types[3],
 	}, {
+		.name = "imx6q-dma-apbh",
+		.driver_data = (kernel_ulong_t) &mxs_dma_types[4],
 		/* end of list */
 	}
 };
@@ -184,6 +190,7 @@ static const struct of_device_id mxs_dma_dt_ids[] = {
 	{ .compatible = "fsl,imx23-dma-apbx", .data = &mxs_dma_ids[1], },
 	{ .compatible = "fsl,imx28-dma-apbh", .data = &mxs_dma_ids[2], },
 	{ .compatible = "fsl,imx28-dma-apbx", .data = &mxs_dma_ids[3], },
+	{ .compatible = "fsl,imx6q-dma-apbh", .data = &mxs_dma_ids[4], },
 	{ /* sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, mxs_dma_dt_ids);
-- 
1.7.1

