Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab1EZG1D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 02:27:03 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:21921
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751856Ab1EZG1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 02:27:00 -0400
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275dhz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Shawn Guo <shawn.guo@linaro.org>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>, <patches@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH 2/3] dmaengine: mxs-dma: set up max_segment_number
Date: Thu, 26 May 2011 14:31:32 +0800
Message-ID: <1306391493-29425-2-git-send-email-shawn.guo@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306391493-29425-1-git-send-email-shawn.guo@linaro.org>
References: <1306391493-29425-1-git-send-email-shawn.guo@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: sigmatel.com
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


