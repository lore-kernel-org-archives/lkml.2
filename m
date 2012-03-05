Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab2CEQRL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:17:11 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:47015 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab2CEQRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:17:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of javier.martin@vista-silicon.com designates 10.180.83.97 as permitted sender) smtp.mail=javier.martin@vista-silicon.com
MIME-Version: 1.0
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux@arm.linux.org.uk, kernel@pengutronix.de,
        Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 11/14] dmaengine: imx-dma: remove unused arg of imxdma_sg_next.
Date: Mon,  5 Mar 2012 17:16:33 +0100
Message-Id: <1330964196-32623-12-git-send-email-javier.martin@vista-silicon.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1330964196-32623-1-git-send-email-javier.martin@vista-silicon.com>
References: <1330964196-32623-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 drivers/dma/imx-dma.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
index 2f72447..d65eec6 100644
--- a/drivers/dma/imx-dma.c
+++ b/drivers/dma/imx-dma.c
@@ -206,9 +206,10 @@ static int imxdma_hw_chain(struct imxdma_channel *imxdmac)
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
@@ -251,7 +252,7 @@ static void imxdma_enable_hw(struct imxdma_desc *d)
 		d->sg = sg_next(d->sg);
 		if (d->sg) {
 			u32 tmp;
-			imxdma_sg_next(d, d->sg);
+			imxdma_sg_next(d);
 			tmp = imx_dmav1_readl(DMA_CCR(channel));
 			imx_dmav1_writel(tmp | CCR_RPT | CCR_ACRPT,
 				DMA_CCR(channel));
@@ -365,7 +366,7 @@ static void dma_irq_handle_channel(struct imxdma_channel *imxdmac)
 		desc->sg = sg_next(desc->sg);
 
 		if (desc->sg) {
-			imxdma_sg_next(desc, desc->sg);
+			imxdma_sg_next(desc);
 
 			tmp = imx_dmav1_readl(DMA_CCR(chno));
 
@@ -475,7 +476,7 @@ static int imxdma_xfer_desc(struct imxdma_desc *d)
 			return -EINVAL;
 		}
 
-		imxdma_sg_next(d, d->sg);
+		imxdma_sg_next(d);
 
 		break;
 	default:
-- 
1.7.0.4

