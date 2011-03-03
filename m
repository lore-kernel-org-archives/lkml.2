Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab1CCR4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 12:56:34 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:39010 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab1CCRzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 12:55:09 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, leoli@freescale.com,
        dan.j.williams@intel.com, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH v3 5/9] fsldma: minor codingstyle and consistency fixes
Date: Thu,  3 Mar 2011 09:54:57 -0800
Message-Id: <1299174901-16762-6-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1299174901-16762-1-git-send-email-iws@ovro.caltech.edu>
References: <1299174901-16762-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Thu, 03 Mar 2011 09:55:08 -0800 (PST)
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
index 82b8e9f..5da1a4a 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -89,7 +89,7 @@ static void set_desc_cnt(struct fsldma_chan *chan,
 }
 
 static void set_desc_src(struct fsldma_chan *chan,
-				struct fsl_dma_ld_hw *hw, dma_addr_t src)
+			 struct fsl_dma_ld_hw *hw, dma_addr_t src)
 {
 	u64 snoop_bits;
 
@@ -99,7 +99,7 @@ static void set_desc_src(struct fsldma_chan *chan,
 }
 
 static void set_desc_dst(struct fsldma_chan *chan,
-				struct fsl_dma_ld_hw *hw, dma_addr_t dst)
+			 struct fsl_dma_ld_hw *hw, dma_addr_t dst)
 {
 	u64 snoop_bits;
 
@@ -109,7 +109,7 @@ static void set_desc_dst(struct fsldma_chan *chan,
 }
 
 static void set_desc_next(struct fsldma_chan *chan,
-				struct fsl_dma_ld_hw *hw, dma_addr_t next)
+			  struct fsl_dma_ld_hw *hw, dma_addr_t next)
 {
 	u64 snoop_bits;
 
@@ -118,8 +118,7 @@ static void set_desc_next(struct fsldma_chan *chan,
 	hw->next_ln_addr = CPU_TO_DMA(chan, snoop_bits | next, 64);
 }
 
-static void set_ld_eol(struct fsldma_chan *chan,
-			struct fsl_desc_sw *desc)
+static void set_ld_eol(struct fsldma_chan *chan, struct fsl_desc_sw *desc)
 {
 	u64 snoop_bits;
 
@@ -338,8 +337,7 @@ static void fsl_chan_toggle_ext_start(struct fsldma_chan *chan, int enable)
 		chan->feature &= ~FSL_DMA_CHAN_START_EXT;
 }
 
-static void append_ld_queue(struct fsldma_chan *chan,
-			    struct fsl_desc_sw *desc)
+static void append_ld_queue(struct fsldma_chan *chan, struct fsl_desc_sw *desc)
 {
 	struct fsl_desc_sw *tail = to_fsl_desc(chan->ld_pending.prev);
 
@@ -380,8 +378,8 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
 	cookie = chan->common.cookie;
 	list_for_each_entry(child, &desc->tx_list, node) {
 		cookie++;
-		if (cookie < 0)
-			cookie = 1;
+		if (cookie < DMA_MIN_COOKIE)
+			cookie = DMA_MIN_COOKIE;
 
 		child->async_tx.cookie = cookie;
 	}
@@ -402,8 +400,7 @@ static dma_cookie_t fsl_dma_tx_submit(struct dma_async_tx_descriptor *tx)
  *
  * Return - The descriptor allocated. NULL for failed.
  */
-static struct fsl_desc_sw *fsl_dma_alloc_descriptor(
-					struct fsldma_chan *chan)
+static struct fsl_desc_sw *fsl_dma_alloc_descriptor(struct fsldma_chan *chan)
 {
 	struct fsl_desc_sw *desc;
 	dma_addr_t pdesc;
@@ -427,7 +424,6 @@ static struct fsl_desc_sw *fsl_dma_alloc_descriptor(
 	return desc;
 }
 
-
 /**
  * fsl_dma_alloc_chan_resources - Allocate resources for DMA channel.
  * @chan : Freescale DMA channel
@@ -537,14 +533,15 @@ fsl_dma_prep_interrupt(struct dma_chan *dchan, unsigned long flags)
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
@@ -594,7 +591,7 @@ static struct dma_async_tx_descriptor *fsl_dma_prep_memcpy(
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

