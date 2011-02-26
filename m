Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122Ab1BZAYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 19:24:43 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:57734 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933039Ab1BZAXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 19:23:35 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, leoli@freescale.com,
        dan.j.williams@intel.com, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH 4/8] fsldma: minor codingstyle and consistency fixes
Date: Fri, 25 Feb 2011 16:23:21 -0800
Message-Id: <1298679805-14108-5-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1298679805-14108-1-git-send-email-iws@ovro.caltech.edu>
References: <1298679805-14108-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Fri, 25 Feb 2011 16:23:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes some minor violations of the coding style. It also changes
the style of the device_prep_dma_*() function definitions so they are
identical.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/fsldma.c |   29 +++++++++++++----------------
 drivers/dma/fsldma.h |    4 ++--
 2 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 851993c..06421c0 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -84,7 +84,7 @@ static void set_desc_cnt(struct fsldma_chan *chan,
 }
 
 static void set_desc_src(struct fsldma_chan *chan,
-				struct fsl_dma_ld_hw *hw, dma_addr_t src)
+			 struct fsl_dma_ld_hw *hw, dma_addr_t src)
 {
 	u64 snoop_bits;
 
@@ -94,7 +94,7 @@ static void set_desc_src(struct fsldma_chan *chan,
 }
 
 static void set_desc_dst(struct fsldma_chan *chan,
-				struct fsl_dma_ld_hw *hw, dma_addr_t dst)
+			 struct fsl_dma_ld_hw *hw, dma_addr_t dst)
 {
 	u64 snoop_bits;
 
@@ -104,7 +104,7 @@ static void set_desc_dst(struct fsldma_chan *chan,
 }
 
 static void set_desc_next(struct fsldma_chan *chan,
-				struct fsl_dma_ld_hw *hw, dma_addr_t next)
+			  struct fsl_dma_ld_hw *hw, dma_addr_t next)
 {
 	u64 snoop_bits;
 
@@ -113,8 +113,7 @@ static void set_desc_next(struct fsldma_chan *chan,
 	hw->next_ln_addr = CPU_TO_DMA(chan, snoop_bits | next, 64);
 }
 
-static void set_ld_eol(struct fsldma_chan *chan,
-			struct fsl_desc_sw *desc)
+static void set_ld_eol(struct fsldma_chan *chan, struct fsl_desc_sw *desc)
 {
 	u64 snoop_bits;
 
@@ -333,8 +332,7 @@ static void fsl_chan_toggle_ext_start(struct fsldma_chan *chan, int enable)
 		chan->feature &= ~FSL_DMA_CHAN_START_EXT;
 }
 
-static void append_ld_queue(struct fsldma_chan *chan,
-			    struct fsl_desc_sw *desc)
+static void append_ld_queue(struct fsldma_chan *chan, struct fsl_desc_sw *desc)
 {
 	struct fsl_desc_sw *tail = to_fsl_desc(chan->ld_pending.prev);
 
@@ -375,8 +373,8 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	cookie = chan->common.cookie;
 	list_for_each_entry(child, &desc->tx_list, node) {
 		cookie++;
-		if (cookie < 0)
-			cookie = 1;
+		if (cookie < DMA_MIN_COOKIE)
+			cookie = DMA_MIN_COOKIE;
 
 		child->async_tx.cookie = cookie;
 	}
@@ -397,8 +395,7 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
  *
  * Return - The descriptor allocated. NULL for failed.
  */
-static struct fsl_desc_sw *fsl_dma_alloc_descriptor(
-					struct fsldma_chan *chan)
+static struct fsl_desc_sw *fsl_dma_alloc_descriptor(struct fsldma_chan *chan)
 {
 	const char *name = chan->name;
 	struct fsl_desc_sw *desc;
@@ -423,7 +420,6 @@ static struct fsl_desc_sw *fsl_dma_alloc_descriptor(
 	return desc;
 }
 
-
 /**
  * fsl_dma_alloc_chan_resources - Allocate resources for DMA channel.
  * @chan : Freescale DMA channel
@@ -534,14 +530,15 @@ fsl_dma_prep_interrupt(struct dma_chan *dchan, unsigned long flags)
 	/* Insert the link descriptor to the LD ring */
 	list_add_tail(&new->node, &new->tx_list);
 
-	/* Set End-of-link to the last link descriptor of new list*/
+	/* Set End-of-link to the last link descriptor of new list */
 	set_ld_eol(chan, new);
 
 	return &new->async_tx;
 }
 
-static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
-	struct dma_chan *dchan, dma_addr_t dma_dst, dma_addr_t dma_src,
+static struct dma_async_tx_descriptor *
+fsl_dma_prep_memcpy(struct dma_chan *dchan,
+	dma_addr_t dma_dst, dma_addr_t dma_src,
 	size_t len, unsigned long flags)
 {
 	struct fsldma_chan *chan;
@@ -591,7 +588,7 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
 	new->async_tx.flags = flags; /* client is in control of this ack */
 	new->async_tx.cookie = -EBUSY;
 
-	/* Set End-of-link to the last link descriptor of new list*/
+	/* Set End-of-link to the last link descriptor of new list */
 	set_ld_eol(chan, new);
 
 	return &first->async_tx;
diff --git a/drivers/dma/fsldma.h b/drivers/dma/fsldma.h
index 113e713..49189da 100644
--- a/drivers/dma/fsldma.h
+++ b/drivers/dma/fsldma.h
@@ -102,8 +102,8 @@ struct fsl_desc_sw {
 } __attribute__((aligned(32)));
 
 struct fsldma_chan_regs {
-	u32 mr;	/* 0x00 - Mode Register */
-	u32 sr;	/* 0x04 - Status Register */
+	u32 mr;		/* 0x00 - Mode Register */
+	u32 sr;		/* 0x04 - Status Register */
 	u64 cdar;	/* 0x08 - Current descriptor address register */
 	u64 sar;	/* 0x10 - Source Address Register */
 	u64 dar;	/* 0x18 - Destination Address Register */
-- 
1.7.3.4

