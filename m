Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2EUMbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 08:31:45 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:37847
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754431Ab2EUMbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 08:31:44 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bhz2dh2a8h668h839hd24he5bhf0ah)
From: Richard Zhao <richard.zhao@freescale.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <vinod.koul@intel.com>, <dan.j.williams@intel.com>, <linuxzsc@gmail.com>,
        <shawn.guo@gmail.com>, <kernel@pengutronix.de>,
        Richard Zhao <richard.zhao@freescale.com>
Subject: [PATCH 1/1] dma: imx-sdma: buf_tail should be initialize in prepare function
Date: Mon, 21 May 2012 20:31:34 +0800
Message-ID: <1337603494-27464-1-git-send-email-richard.zhao@freescale.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fix audio underrun issue. When SNDRV_PCM_TRIGGER_STOP
and SNDRV_PCM_TRIGGER_START, it calls prepare again. buf_tail
should be reset to zero.
So move buf_tail initialization into prepare function.

Signed-off-by: Richard Zhao <richard.zhao@freescale.com>
---
 drivers/dma/imx-sdma.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index a472a29..def08f7 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -814,8 +814,6 @@ static int sdma_request_channel(struct sdma_channel *sdmac)
 
 	init_completion(&sdmac->done);
 
-	sdmac->buf_tail = 0;
-
 	return 0;
 out:
 
@@ -924,6 +922,8 @@ static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
 
 	sdmac->flags = 0;
 
+	sdmac->buf_tail = 0;
+
 	dev_dbg(sdma->dev, "setting up %d entries for channel %d.\n",
 			sg_len, channel);
 
@@ -1024,6 +1024,8 @@ static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
 
 	sdmac->status = DMA_IN_PROGRESS;
 
+	sdmac->buf_tail = 0;
+
 	sdmac->flags |= IMX_DMA_SG_LOOP;
 	sdmac->direction = direction;
 	ret = sdma_load_context(sdmac);
-- 
1.7.5.4


