Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab1HAJmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 05:42:09 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:33737 "EHLO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480Ab1HAJj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 05:39:26 -0400
From: Viresh Kumar <viresh.kumar@st.com>
To: <linus.walleij@linaro.org>
Cc: <vinod.koul@intel.com>, <dan.j.williams@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux@arm.linux.org.uk>, <armando.visconti@st.com>,
        <shiraz.hashim@st.com>, <vipin.kumar@st.com>,
        <rajeev-dlh.kumar@st.com>, <deepak.sikri@st.com>,
        <vipulkumar.samar@st.com>, <amit.virdi@st.com>, <viresh.kumar@st.com>,
        <pratyush.anand@st.com>, <bhupesh.sharma@st.com>,
        <viresh.linux@gmail.com>
Subject: [PATCH V2 02/20] dmaengine/amba-pl08x: Resolve formatting issues
Date: Mon, 1 Aug 2011 15:07:12 +0530
Message-ID: <31328fe755a9a5d1d45739e66a58d4e0aef47cb0.1312190881.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1312190881.git.viresh.kumar@st.com>
References: <cover.1312190881.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were few formatting related issues in code. This patch fixes them.
Fixes include:
- Remove extra blank lines
- align code to 80 cols
- combine several lines to one line

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/amba-pl08x.c |   41 ++++++++++++++++-------------------------
 1 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 196a737..4c4a309 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -125,7 +125,8 @@ struct pl08x_lli {
  * @phy_chans: array of data for the physical channels
  * @pool: a pool for the LLI descriptors
  * @pool_ctr: counter of LLIs in the pool
- * @lli_buses: bitmask to or in to LLI pointer selecting AHB port for LLI fetches
+ * @lli_buses: bitmask to or in to LLI pointer selecting AHB port for LLI
+ * fetches
  * @mem_buses: set to indicate memory transfers on AHB2.
  * @lock: a spinlock for this struct
  */
@@ -271,7 +272,6 @@ static void pl08x_resume_phy_chan(struct pl08x_phy_chan *ch)
 	writel(val, ch->base + PL080_CH_CONFIG);
 }
 
-
 /*
  * pl08x_terminate_phy_chan() stops the channel, clears the FIFO and
  * clears any pending interrupt status.  This should not be used for
@@ -546,7 +546,8 @@ static void pl08x_fill_lli_for_desc(struct pl08x_lli_build_data *bd,
 	llis_va[num_llis].cctl = cctl;
 	llis_va[num_llis].src = bd->srcbus.addr;
 	llis_va[num_llis].dst = bd->dstbus.addr;
-	llis_va[num_llis].lli = llis_bus + (num_llis + 1) * sizeof(struct pl08x_lli);
+	llis_va[num_llis].lli = llis_bus + (num_llis + 1) *
+		sizeof(struct pl08x_lli);
 	llis_va[num_llis].lli |= bd->lli_bus;
 
 	if (cctl & PL080_CONTROL_SRC_INCR)
@@ -583,12 +584,10 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 	struct pl08x_lli_build_data bd;
 	int num_llis = 0;
 	u32 cctl;
-	size_t max_bytes_per_lli;
-	size_t total_bytes = 0;
+	size_t max_bytes_per_lli, total_bytes = 0;
 	struct pl08x_lli *llis_va;
 
-	txd->llis_va = dma_pool_alloc(pl08x->pool, GFP_NOWAIT,
-				      &txd->llis_bus);
+	txd->llis_va = dma_pool_alloc(pl08x->pool, GFP_NOWAIT, &txd->llis_bus);
 	if (!txd->llis_va) {
 		dev_err(&pl08x->adev->dev, "%s no memory for llis\n", __func__);
 		return 0;
@@ -779,7 +778,6 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 				total_bytes += lli_len;
 			}
 
-
 			if (odd_bytes) {
 				/*
 				 * Creep past the boundary, maintaining
@@ -916,9 +914,7 @@ static int prep_phy_channel(struct pl08x_dma_chan *plchan,
 	 * need, but for slaves the physical signals may be muxed!
 	 * Can the platform allow us to use this channel?
 	 */
-	if (plchan->slave &&
-	    ch->signal < 0 &&
-	    pl08x->pd->get_signal) {
+	if (plchan->slave && ch->signal < 0 && pl08x->pd->get_signal) {
 		ret = pl08x->pd->get_signal(plchan);
 		if (ret < 0) {
 			dev_dbg(&pl08x->adev->dev,
@@ -1007,10 +1003,8 @@ static struct dma_async_tx_descriptor *pl08x_prep_dma_interrupt(
  * If slaves are relying on interrupts to signal completion this function
  * must not be called with interrupts disabled.
  */
-static enum dma_status
-pl08x_dma_tx_status(struct dma_chan *chan,
-		    dma_cookie_t cookie,
-		    struct dma_tx_state *txstate)
+static enum dma_status pl08x_dma_tx_status(struct dma_chan *chan,
+		dma_cookie_t cookie, struct dma_tx_state *txstate)
 {
 	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
 	dma_cookie_t last_used;
@@ -1588,8 +1582,8 @@ static void pl08x_tasklet(unsigned long data)
 		 */
 		list_for_each_entry(waiting, &pl08x->memcpy.channels,
 				    chan.device_node) {
-		  if (waiting->state == PL08X_CHAN_WAITING &&
-			    waiting->waiting != NULL) {
+			if (waiting->state == PL08X_CHAN_WAITING &&
+				waiting->waiting != NULL) {
 				int ret;
 
 				/* This should REALLY not fail now */
@@ -1684,9 +1678,7 @@ static void pl08x_dma_slave_init(struct pl08x_dma_chan *chan)
  * Make a local wrapper to hold required data
  */
 static int pl08x_dma_init_virtual_channels(struct pl08x_driver_data *pl08x,
-					   struct dma_device *dmadev,
-					   unsigned int channels,
-					   bool slave)
+		struct dma_device *dmadev, unsigned int channels, bool slave)
 {
 	struct pl08x_dma_chan *chan;
 	int i;
@@ -1836,9 +1828,9 @@ static const struct file_operations pl08x_debugfs_operations = {
 static void init_pl08x_debugfs(struct pl08x_driver_data *pl08x)
 {
 	/* Expose a simple debugfs interface to view all clocks */
-	(void) debugfs_create_file(dev_name(&pl08x->adev->dev), S_IFREG | S_IRUGO,
-				   NULL, pl08x,
-				   &pl08x_debugfs_operations);
+	(void) debugfs_create_file(dev_name(&pl08x->adev->dev),
+			S_IFREG | S_IRUGO, NULL, pl08x,
+			&pl08x_debugfs_operations);
 }
 
 #else
@@ -1973,8 +1965,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 
 	/* Register slave channels */
 	ret = pl08x_dma_init_virtual_channels(pl08x, &pl08x->slave,
-					      pl08x->pd->num_slave_channels,
-					      true);
+			pl08x->pd->num_slave_channels, true);
 	if (ret <= 0) {
 		dev_warn(&pl08x->adev->dev,
 			"%s failed to enumerate slave channels - %d\n",
-- 
1.7.2.2

