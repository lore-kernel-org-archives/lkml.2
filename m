Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab1AaMA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 07:00:57 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53526 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab1AaMAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 07:00:53 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/4] dmaengine i.MX dma: set maximum segment size for our device
Date: Mon, 31 Jan 2011 13:00:45 +0100
Message-Id: <1296475248-29095-2-git-send-email-s.hauer@pengutronix.de>
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

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/dma/imx-dma.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index e53d438..a46e1d9 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -49,6 +49,7 @@ struct imxdma_channel {
 
 struct imxdma_engine {
 	struct device			*dev;
+	struct device_dma_parameters	dma_parms;
 	struct dma_device		dma_device;
 	struct imxdma_channel		channel[MAX_DMA_CHANNELS];
 };
@@ -370,6 +371,9 @@ static int __init imxdma_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, imxdma);
 
+	imxdma->dma_device.dev->dma_parms = &imxdma->dma_parms;
+	dma_set_max_seg_size(imxdma->dma_device.dev, 0xffffff);
+
 	ret = dma_async_device_register(&imxdma->dma_device);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to register\n");
-- 
1.7.2.3

