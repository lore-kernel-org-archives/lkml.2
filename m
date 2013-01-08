Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924Ab3AHB4B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 20:56:01 -0500
Received: from mail-ye0-f170.google.com ([209.85.213.170]:55455 "EHLO
	mail-ye0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab3AHBz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 20:55:59 -0500
From: Fabio Estevam <festevam@gmail.com>
To: vinod.koul@intel.com
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: [PATCH] dma: mxs-dma: Fix build warnings with W=1
Date: Mon,  7 Jan 2013 23:48:39 -0200
Message-Id: <1357609719-10493-1-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

Fix the following warnings when building with W=1 option:

drivers/dma/mxs-dma.c: In function 'mxs_dma_alloc_chan_resources':
drivers/dma/mxs-dma.c:368:25: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
drivers/dma/mxs-dma.c: In function 'mxs_dma_prep_slave_sg':
drivers/dma/mxs-dma.c:481:17: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
drivers/dma/mxs-dma.c:494:3: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
drivers/dma/mxs-dma.c:515:14: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]
drivers/dma/mxs-dma.c: In function 'mxs_dma_prep_dma_cyclic':
drivers/dma/mxs-dma.c:563:13: warning: comparison between signed and unsigned integer expressions [-Wsign-compare]

Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/dma/mxs-dma.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index 9f02e79..8f6d30d 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -109,7 +109,7 @@ struct mxs_dma_chan {
 	struct dma_chan			chan;
 	struct dma_async_tx_descriptor	desc;
 	struct tasklet_struct		tasklet;
-	int				chan_irq;
+	unsigned int			chan_irq;
 	struct mxs_dma_ccw		*ccw;
 	dma_addr_t			ccw_phys;
 	int				desc_count;
@@ -441,7 +441,7 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_slave_sg(
 	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
 	struct mxs_dma_ccw *ccw;
 	struct scatterlist *sg;
-	int i, j;
+	u32 i, j;
 	u32 *pio;
 	bool append = flags & DMA_PREP_INTERRUPT;
 	int idx = append ? mxs_chan->desc_count : 0;
@@ -537,8 +537,8 @@ static struct dma_async_tx_descriptor *mxs_dma_prep_dma_cyclic(
 {
 	struct mxs_dma_chan *mxs_chan = to_mxs_dma_chan(chan);
 	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
-	int num_periods = buf_len / period_len;
-	int i = 0, buf = 0;
+	u32 num_periods = buf_len / period_len;
+	u32 i = 0, buf = 0;
 
 	if (mxs_chan->status == DMA_IN_PROGRESS)
 		return NULL;
-- 
1.7.9.5

