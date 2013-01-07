Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3AGLZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 06:25:14 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:63354 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832Ab3AGLZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 06:25:08 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>, Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 12/16] dmaengine: ste_dma40: minor cosmetic fixes
Date: Mon,  7 Jan 2013 12:21:54 +0100
Message-Id: <1357557718-15676-13-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
References: <1357557718-15676-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains various non functional cosmetic fixes.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/dma/ste_dma40.c    | 33 ++++++++++++---------------------
 drivers/dma/ste_dma40_ll.c |  2 +-
 2 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index ff21dcb..623779e 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1609,13 +1609,11 @@ static void dma_tasklet(unsigned long data)
 		if (async_tx_test_ack(&d40d->txd)) {
 			d40_desc_remove(d40d);
 			d40_desc_free(d40c, d40d);
-		} else {
-			if (!d40d->is_in_client_list) {
-				d40_desc_remove(d40d);
-				d40_lcla_free_all(d40c, d40d);
-				list_add_tail(&d40d->node, &d40c->client);
-				d40d->is_in_client_list = true;
-			}
+		} else if (!d40d->is_in_client_list) {
+			d40_desc_remove(d40d);
+			d40_lcla_free_all(d40c, d40d);
+			list_add_tail(&d40d->node, &d40c->client);
+			d40d->is_in_client_list = true;
 		}
 	}
 
@@ -2123,7 +2121,6 @@ _exit:
 
 }
 
-
 static u32 stedma40_residue(struct dma_chan *chan)
 {
 	struct d40_chan *d40c =
@@ -2199,7 +2196,6 @@ d40_prep_sg_phy(struct d40_chan *chan, struct d40_desc *desc,
 	return ret < 0 ? ret : 0;
 }
 
-
 static struct d40_desc *
 d40_prep_desc(struct d40_chan *chan, struct scatterlist *sg,
 	      unsigned int sg_len, unsigned long dma_flags)
@@ -2225,7 +2221,6 @@ d40_prep_desc(struct d40_chan *chan, struct scatterlist *sg,
 		goto err;
 	}
 
-
 	desc->lli_current = 0;
 	desc->txd.flags = dma_flags;
 	desc->txd.tx_submit = d40_tx_submit;
@@ -2274,7 +2269,6 @@ d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
 		return NULL;
 	}
 
-
 	spin_lock_irqsave(&chan->lock, flags);
 
 	desc = d40_prep_desc(chan, sg_src, sg_len, dma_flags);
@@ -2432,11 +2426,11 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 
 		if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM)
 			d40c->lcpa = d40c->base->lcpa_base +
-			  d40c->dma_cfg.src_dev_type * D40_LCPA_CHAN_SIZE;
+				d40c->dma_cfg.src_dev_type * D40_LCPA_CHAN_SIZE;
 		else
 			d40c->lcpa = d40c->base->lcpa_base +
-			  d40c->dma_cfg.dst_dev_type *
-			  D40_LCPA_CHAN_SIZE + D40_LCPA_CHAN_DST_DELTA;
+				d40c->dma_cfg.dst_dev_type *
+				D40_LCPA_CHAN_SIZE + D40_LCPA_CHAN_DST_DELTA;
 	}
 
 	dev_dbg(chan2dev(d40c), "allocated %s channel (phy %d%s)\n",
@@ -2471,7 +2465,6 @@ static void d40_free_chan_resources(struct dma_chan *chan)
 		return;
 	}
 
-
 	spin_lock_irqsave(&d40c->lock, flags);
 
 	err = d40_free_dma(d40c);
@@ -2514,12 +2507,10 @@ d40_prep_memcpy_sg(struct dma_chan *chan,
 	return d40_prep_sg(chan, src_sg, dst_sg, src_nents, DMA_NONE, dma_flags);
 }
 
-static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
-							 struct scatterlist *sgl,
-							 unsigned int sg_len,
-							 enum dma_transfer_direction direction,
-							 unsigned long dma_flags,
-							 void *context)
+static struct dma_async_tx_descriptor *
+d40_prep_slave_sg(struct dma_chan *chan, struct scatterlist *sgl,
+		  unsigned int sg_len, enum dma_transfer_direction direction,
+		  unsigned long dma_flags, void *context)
 {
 	if (direction != DMA_DEV_TO_MEM && direction != DMA_MEM_TO_DEV)
 		return NULL;
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 1cfe7ab..7180e0d 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -251,7 +251,7 @@ d40_phy_buf_to_lli(struct d40_phy_lli *lli, dma_addr_t addr, u32 size,
 
 	return lli;
 
- err:
+err:
 	return NULL;
 }
 
-- 
1.7.12.1

