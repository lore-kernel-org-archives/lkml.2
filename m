Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758835Ab2EJKSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 06:18:50 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:51513 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758780Ab2EJKSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 06:18:47 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <vinod.koul@linux.intel.com>
CC: <linux-arm-kernel@lists.infradead.org>, <plagnioj@jcrosoft.com>,
        <linux-kernel@vger.kernel.org>, <ludovic.desroches@atmel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/3] dmaengine: at_hdmac: remove ATC_DEFAULT_CTRLA constant
Date: Thu, 10 May 2012 12:17:40 +0200
Message-ID: <e1d2292c3746bef603480f17cdb7cdf6a557032c.1336644470.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1336644470.git.nicolas.ferre@atmel.com>
References: <cover.1336644470.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.159.245.203]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not needed constant that was set to 0.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index 445fdf8..b3f7cbd 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -39,7 +39,6 @@
  */
 
 #define	ATC_DEFAULT_CFG		(ATC_FIFOCFG_HALFFIFO)
-#define	ATC_DEFAULT_CTRLA	(0)
 #define	ATC_DEFAULT_CTRLB	(ATC_SIF(AT_DMA_MEM_IF) \
 				|ATC_DIF(AT_DMA_MEM_IF))
 
@@ -572,7 +571,6 @@ atc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 		return NULL;
 	}
 
-	ctrla =   ATC_DEFAULT_CTRLA;
 	ctrlb =   ATC_DEFAULT_CTRLB | ATC_IEN
 		| ATC_SRC_ADDR_MODE_INCR
 		| ATC_DST_ADDR_MODE_INCR
@@ -583,13 +581,13 @@ atc_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dest, dma_addr_t src,
 	 * of the most common optimization.
 	 */
 	if (!((src | dest  | len) & 3)) {
-		ctrla |= ATC_SRC_WIDTH_WORD | ATC_DST_WIDTH_WORD;
+		ctrla = ATC_SRC_WIDTH_WORD | ATC_DST_WIDTH_WORD;
 		src_width = dst_width = 2;
 	} else if (!((src | dest | len) & 1)) {
-		ctrla |= ATC_SRC_WIDTH_HALFWORD | ATC_DST_WIDTH_HALFWORD;
+		ctrla = ATC_SRC_WIDTH_HALFWORD | ATC_DST_WIDTH_HALFWORD;
 		src_width = dst_width = 1;
 	} else {
-		ctrla |= ATC_SRC_WIDTH_BYTE | ATC_DST_WIDTH_BYTE;
+		ctrla = ATC_SRC_WIDTH_BYTE | ATC_DST_WIDTH_BYTE;
 		src_width = dst_width = 0;
 	}
 
@@ -666,7 +664,7 @@ atc_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
 		return NULL;
 	}
 
-	ctrla = ATC_DEFAULT_CTRLA | atslave->ctrla;
+	ctrla = atslave->ctrla;
 	ctrlb = ATC_IEN;
 
 	switch (direction) {
@@ -799,7 +797,7 @@ atc_dma_cyclic_fill_desc(struct dma_chan *chan, struct at_desc *desc,
 	u32			ctrla;
 
 	/* prepare common CRTLA value */
-	ctrla =   ATC_DEFAULT_CTRLA | atslave->ctrla
+	ctrla = atslave->ctrla
 		| ATC_DST_WIDTH(reg_width)
 		| ATC_SRC_WIDTH(reg_width)
 		| period_len >> reg_width;
-- 
1.7.10

