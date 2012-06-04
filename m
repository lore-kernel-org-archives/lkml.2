Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab2FDBRg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 21:17:36 -0400
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:4288 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755407Ab2FDBRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 21:17:35 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzz8275bh8275dhz2dh2a8h668h839hd24he5bhf0ah)
From: Richard Zhao <richard.zhao@freescale.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
CC: <vinod.koul@intel.com>, <dan.j.williams@intel.com>, <linuxzsc@gmail.com>,
        <shawn.guo@gmail.com>, <kernel@pengutronix.de>,
        Richard Zhao <richard.zhao@freescale.com>
Subject: [RESEND PATCH] dma: imx-sdma: buf_tail should be initialize in prepare function
Date: Mon, 4 Jun 2012 09:17:24 +0800
Message-ID: <1338772644-3344-1-git-send-email-richard.zhao@freescale.com>
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
Acked-by: Shawn Guo <shawn.guo@linaro.org>
---
 drivers/dma/imx-sdma.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index fb4f499..1dc2a4a 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -815,8 +815,6 @@ static int sdma_request_channel(struct sdma_channel *sdmac)
 
 	init_completion(&sdmac->done);
 
-	sdmac->buf_tail = 0;
-
 	return 0;
 out:
 
@@ -927,6 +925,8 @@ static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
 
 	sdmac->flags = 0;
 
+	sdmac->buf_tail = 0;
+
 	dev_dbg(sdma->dev, "setting up %d entries for channel %d.\n",
 			sg_len, channel);
 
@@ -1027,6 +1027,8 @@ static struct dma_async_tx_descriptor *sdma_prep_dma_cyclic(
 
 	sdmac->status = DMA_IN_PROGRESS;
 
+	sdmac->buf_tail = 0;
+
 	sdmac->flags |= IMX_DMA_SG_LOOP;
 	sdmac->direction = direction;
 	ret = sdma_load_context(sdmac);
-- 
1.7.5.4


