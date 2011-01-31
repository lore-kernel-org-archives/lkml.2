Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab1AaMA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:00:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53528 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822Ab1AaMAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:00:53 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 4/4] dmaengine i.MX dma: initialize dma capabilities outside channel loop
Date: Mon, 31 Jan 2011 13:00:48 +0100
Message-Id: <1296475248-29095-5-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296475248-29095-1-git-send-email-s.hauer@pengutronix.de>
References: <1296475248-29095-1-git-send-email-s.hauer@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The capabilities are device specific fields, not channel specific fields.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/dma/imx-dma.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 8262708..e18eaab 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -345,6 +345,9 @@ static int __init imxdma_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&imxdma->dma_device.channels);
 
+	dma_cap_set(DMA_SLAVE, imxdma->dma_device.cap_mask);
+	dma_cap_set(DMA_CYCLIC, imxdma->dma_device.cap_mask);
+
 	/* Initialize channel parameters */
 	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
 		struct imxdma_channel *imxdmac = &imxdma->channel[i];
@@ -362,9 +365,6 @@ static int __init imxdma_probe(struct platform_device *pdev)
 		imxdmac->imxdma = imxdma;
 		spin_lock_init(&imxdmac->lock);
 
-		dma_cap_set(DMA_SLAVE, imxdma->dma_device.cap_mask);
-		dma_cap_set(DMA_CYCLIC, imxdma->dma_device.cap_mask);
-
 		imxdmac->chan.device = &imxdma->dma_device;
 		imxdmac->channel = i;
 
-- 
1.7.2.3

