Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab1AaL7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:59:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53496 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755722Ab1AaL7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:59:42 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 1/5] dmaengine i.MX sdma: set maximum segment size for our device
Date: Mon, 31 Jan 2011 12:59:28 +0100
Message-Id: <1296475172-23900-2-git-send-email-s.hauer@pengutronix.de>
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

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/dma/imx-sdma.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index d5a5d4d..c503050 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -301,6 +301,7 @@ struct sdma_firmware_header {
 
 struct sdma_engine {
 	struct device			*dev;
+	struct device_dma_parameters	dma_parms;
 	struct sdma_channel		channel[MAX_DMA_CHANNELS];
 	struct sdma_channel_control	*channel_control;
 	void __iomem			*regs;
@@ -1317,6 +1318,8 @@ static int __init sdma_probe(struct platform_device *pdev)
 	sdma->dma_device.device_prep_dma_cyclic = sdma_prep_dma_cyclic;
 	sdma->dma_device.device_control = sdma_control;
 	sdma->dma_device.device_issue_pending = sdma_issue_pending;
+	sdma->dma_device.dev->dma_parms = &sdma->dma_parms;
+	dma_set_max_seg_size(sdma->dma_device.dev, 65535);
 
 	ret = dma_async_device_register(&sdma->dma_device);
 	if (ret) {
-- 
1.7.2.3

