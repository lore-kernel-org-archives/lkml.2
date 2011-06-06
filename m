Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab1FFHWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 03:22:42 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37865 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab1FFHWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 03:22:40 -0400
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, cjb@laptop.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH v2 2/3] dmaengine: mxs-dma: set up max_segment_number
Date: Mon,  6 Jun 2011 15:30:13 +0800
Message-Id: <1307345414-26872-2-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307345414-26872-1-git-send-email-shawn.guo@linaro.org>
References: <1307345414-26872-1-git-send-email-shawn.guo@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It calls dmaengine API dma_set_max_seg_number to set
device_dma_parameters max_segment_number.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/dma/mxs-dma.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index 88aad4f..875d8f6 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -670,6 +670,7 @@ static int __init mxs_dma_probe(struct platform_device *pdev)
 	/* mxs_dma gets 65535 bytes maximum sg size */
 	mxs_dma->dma_device.dev->dma_parms = &mxs_dma->dma_parms;
 	dma_set_max_seg_size(mxs_dma->dma_device.dev, MAX_XFER_BYTES);
+	dma_set_max_seg_number(mxs_dma->dma_device.dev, NUM_CCW);
 
 	mxs_dma->dma_device.device_alloc_chan_resources = mxs_dma_alloc_chan_resources;
 	mxs_dma->dma_device.device_free_chan_resources = mxs_dma_free_chan_resources;
-- 
1.7.4.1

