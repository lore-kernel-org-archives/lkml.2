Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab1AaL7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 06:59:44 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53497 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596Ab1AaL7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 06:59:43 -0500
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH 3/5] dmaengine i.MX SDMA: do not initialize chan_id field
Date: Mon, 31 Jan 2011 12:59:30 +0100
Message-Id: <1296475172-23900-4-git-send-email-s.hauer@pengutronix.de>
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

This is bogus as the dmaengine core will overwrite this field.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/dma/imx-sdma.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 8707723..3e848ee 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -1307,7 +1307,6 @@ static int __init sdma_probe(struct platform_device *pdev)
 		dma_cap_set(DMA_CYCLIC, sdma->dma_device.cap_mask);
 
 		sdmac->chan.device = &sdma->dma_device;
-		sdmac->chan.chan_id = i;
 		sdmac->channel = i;
 
 		/* Add the channel to the DMAC list */
-- 
1.7.2.3

