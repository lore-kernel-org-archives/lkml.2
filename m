Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757863Ab2CIPVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 10:21:34 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:40204 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805Ab2CIPVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 10:21:31 -0500
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH v3 11/13] dmaengine: imx-dma: remove unused arg of imxdma_sg_next.
Date: Fri,  9 Mar 2012 16:20:47 +0100
Message-Id: <1331306449-28591-12-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1331306449-28591-1-git-send-email-javier.martin@vista-silicon.com>
References: <1331306449-28591-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since this function is always used with 'desc' as first argument
and 'desc->sg' as second argument, the latter is clearly redundant
and can be removed.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 0b831a7..7b67371 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -204,9 +204,10 @@ static int imxdma_hw_chain(struct imxdma_channel *imxdmac)
 /*
  * imxdma_sg_next - prepare next chunk for scatter-gather DMA emulation
  */
-static inline int imxdma_sg_next(struct imxdma_desc *d, struct scatterlist *sg)
+static inline int imxdma_sg_next(struct imxdma_desc *d)
 {
 	struct imxdma_channel *imxdmac = to_imxdma_chan(d->desc.chan);
+	struct scatterlist *sg = d->sg;
 	unsigned long now;
 
 	now = min(d->len, sg->length);
@@ -249,7 +250,7 @@ static void imxdma_enable_hw(struct imxdma_desc *d)
 		d->sg = sg_next(d->sg);
 		if (d->sg) {
 			u32 tmp;
-			imxdma_sg_next(d, d->sg);
+			imxdma_sg_next(d);
 			tmp = imx_dmav1_readl(DMA_CCR(channel));
 			imx_dmav1_writel(tmp | CCR_RPT | CCR_ACRPT,
 				DMA_CCR(channel));
@@ -363,7 +364,7 @@ static void dma_irq_handle_channel(struct imxdma_channel *imxdmac)
 		desc->sg = sg_next(desc->sg);
 
 		if (desc->sg) {
-			imxdma_sg_next(desc, desc->sg);
+			imxdma_sg_next(desc);
 
 			tmp = imx_dmav1_readl(DMA_CCR(chno));
 
@@ -473,7 +474,7 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 			return -EINVAL;
 		}
 
-		imxdma_sg_next(d, d->sg);
+		imxdma_sg_next(d);
 
 		break;
 	default:
-- 
1.7.0.4

