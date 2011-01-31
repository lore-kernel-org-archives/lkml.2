Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab1AaL7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:59:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53492 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab1AaL7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:59:39 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 4/5] dmaengine i.MX SDMA: initialize dma capabilities outside channel loop
Date: Mon, 31 Jan 2011 12:59:31 +0100
Message-Id: <1296475172-23900-5-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1296475172-23900-1-git-send-email-s.hauer@pengutronix.de>
References: <1296475172-23900-1-git-send-email-s.hauer@pengutronix.de>
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
 drivers/dma/imx-sdma.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 3e848ee..eb25068 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1295,6 +1295,9 @@ static int __init sdma_probe(struct platform_device *pdev)
 
 	sdma->version = pdata->sdma_version;
 
+	dma_cap_set(DMA_SLAVE, sdma->dma_device.cap_mask);
+	dma_cap_set(DMA_CYCLIC, sdma->dma_device.cap_mask);
+
 	INIT_LIST_HEAD(&sdma->dma_device.channels);
 	/* Initialize channel parameters */
 	for (i = 0; i < MAX_DMA_CHANNELS; i++) {
@@ -1303,9 +1306,6 @@ static int __init sdma_probe(struct platform_device *pdev)
 		sdmac->sdma = sdma;
 		spin_lock_init(&sdmac->lock);
 
-		dma_cap_set(DMA_SLAVE, sdma->dma_device.cap_mask);
-		dma_cap_set(DMA_CYCLIC, sdma->dma_device.cap_mask);
-
 		sdmac->chan.device = &sdma->dma_device;
 		sdmac->channel = i;
 
-- 
1.7.2.3

