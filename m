Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176Ab1G2KuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:50:23 -0400
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:48651 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932167Ab1G2KuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:50:17 -0400
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
Subject: [PATCH 02/18] dmaengine/amba-pl08x: Resolve formatting issues
Date: Fri, 29 Jul 2011 16:19:12 +0530
Message-ID: <1e5012faf0649e7ed0113960a9ac8302e46f1354.1311936524.git.viresh.kumar@st.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <cover.1311936523.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were few formatting related issues in code. This patch fixes them.
Fixes include:
- Remove extra blank lines and spaces
- align code to 80 cols
- Don't mix spaces and tabs (use tabs instead)
- combine several lines to one line

Signed-off-by: Viresh Kumar <viresh.kumar@st.com>
---
 drivers/dma/amba-pl08x.c   |  192 ++++++++++++++++++++++----------------------
 include/linux/amba/pl08x.h |    2 +-
 2 files changed, 97 insertions(+), 97 deletions(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 196a737..1f7c510 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -12,12 +12,12 @@
  *
  * This program is distributed in the hope that it will be useful, but WITHOUT
  * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
  * more details.
  *
  * You should have received a copy of the GNU General Public License along with
  * this program; if not, write to the Free Software Foundation, Inc., 59
- * Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ * Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  *
  * The full GNU General Public License is in this distribution in the file
  * called COPYING.
@@ -56,18 +56,18 @@
  * The PL08x has two flow control settings:
  *  - DMAC flow control: the transfer size defines the number of transfers
  *    which occur for the current LLI entry, and the DMAC raises TC at the
- *    end of every LLI entry.  Observed behaviour shows the DMAC listening
+ *    end of every LLI entry. Observed behaviour shows the DMAC listening
  *    to both the BREQ and SREQ signals (contrary to documented),
- *    transferring data if either is active.  The LBREQ and LSREQ signals
+ *    transferring data if either is active. The LBREQ and LSREQ signals
  *    are ignored.
  *
  *  - Peripheral flow control: the transfer size is ignored (and should be
- *    zero).  The data is transferred from the current LLI entry, until
- *    after the final transfer signalled by LBREQ or LSREQ.  The DMAC
+ *    zero). The data is transferred from the current LLI entry, until
+ *    after the final transfer signalled by LBREQ or LSREQ. The DMAC
  *    will then move to the next LLI entry.
  *
  * Only the former works sanely with scatter lists, so we only implement
- * the DMAC flow control method.  However, peripherals which use the LBREQ
+ * the DMAC flow control method. However, peripherals which use the LBREQ
  * and LSREQ signals (eg, MMCI) are unable to use this mode, which through
  * these hardware restrictions prevents them from using scatter DMA.
  *
@@ -103,8 +103,8 @@ struct vendor_data {
 
 /*
  * PL08X private data structures
- * An LLI struct - see PL08x TRM.  Note that next uses bit[0] as a bus bit,
- * start & end do not - their bus bit info is in cctl.  Also note that these
+ * An LLI struct - see PL08x TRM. Note that next uses bit[0] as a bus bit,
+ * start & end do not - their bus bit info is in cctl. Also note that these
  * are fixed 32-bit quantities.
  */
 struct pl08x_lli {
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
@@ -189,7 +190,7 @@ static int pl08x_phy_channel_busy(struct pl08x_phy_chan *ch)
 /*
  * Set the initial DMA register values i.e. those for the first LLI
  * The next LLI pointer and the configuration interrupt bit have
- * been set when the LLIs were constructed.  Poke them into the hardware
+ * been set when the LLIs were constructed. Poke them into the hardware
  * and start the transfer.
  */
 static void pl08x_start_txd(struct pl08x_dma_chan *plchan,
@@ -271,10 +272,9 @@ static void pl08x_resume_phy_chan(struct pl08x_phy_chan *ch)
 	writel(val, ch->base + PL080_CH_CONFIG);
 }
 
-
 /*
  * pl08x_terminate_phy_chan() stops the channel, clears the FIFO and
- * clears any pending interrupt status.  This should not be used for
+ * clears any pending interrupt status. This should not be used for
  * an on-going transfer, but as a method of shutting down a channel
  * (eg, when it's no longer used) or terminating a transfer.
  */
@@ -284,7 +284,7 @@ static void pl08x_terminate_phy_chan(struct pl08x_driver_data *pl08x,
 	u32 val = readl(ch->base + PL080_CH_CONFIG);
 
 	val &= ~(PL080_CONFIG_ENABLE | PL080_CONFIG_ERR_IRQ_MASK |
-	         PL080_CONFIG_TC_IRQ_MASK);
+			PL080_CONFIG_TC_IRQ_MASK);
 
 	writel(val, ch->base + PL080_CH_CONFIG);
 
@@ -380,7 +380,7 @@ static u32 pl08x_getbytes_chan(struct pl08x_dma_chan *plchan)
  */
 static struct pl08x_phy_chan *
 pl08x_get_phy_channel(struct pl08x_driver_data *pl08x,
-		      struct pl08x_dma_chan *virt_chan)
+		struct pl08x_dma_chan *virt_chan)
 {
 	struct pl08x_phy_chan *ch = NULL;
 	unsigned long flags;
@@ -445,7 +445,7 @@ static inline unsigned int pl08x_get_bytes_for_cctl(unsigned int coded)
 }
 
 static inline u32 pl08x_cctl_bits(u32 cctl, u8 srcwidth, u8 dstwidth,
-				  size_t tsize)
+		size_t tsize)
 {
 	u32 retbits = cctl;
 
@@ -546,7 +546,8 @@ static void pl08x_fill_lli_for_desc(struct pl08x_lli_build_data *bd,
 	llis_va[num_llis].cctl = cctl;
 	llis_va[num_llis].src = bd->srcbus.addr;
 	llis_va[num_llis].dst = bd->dstbus.addr;
-	llis_va[num_llis].lli = llis_bus + (num_llis + 1) * sizeof(struct pl08x_lli);
+	llis_va[num_llis].lli = llis_bus + (num_llis + 1) *
+		sizeof(struct pl08x_lli);
 	llis_va[num_llis].lli |= bd->lli_bus;
 
 	if (cctl & PL080_CONTROL_SRC_INCR)
@@ -577,18 +578,16 @@ static inline size_t pl08x_pre_boundary(u32 addr, size_t len)
  * Return 0 for error
  */
 static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
-			      struct pl08x_txd *txd)
+		struct pl08x_txd *txd)
 {
 	struct pl08x_bus_data *mbus, *sbus;
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
@@ -607,12 +606,12 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 	/* Find maximum width of the source bus */
 	bd.srcbus.maxwidth =
 		pl08x_get_bytes_for_cctl((cctl & PL080_CONTROL_SWIDTH_MASK) >>
-				       PL080_CONTROL_SWIDTH_SHIFT);
+				PL080_CONTROL_SWIDTH_SHIFT);
 
 	/* Find maximum width of the destination bus */
 	bd.dstbus.maxwidth =
 		pl08x_get_bytes_for_cctl((cctl & PL080_CONTROL_DWIDTH_MASK) >>
-				       PL080_CONTROL_DWIDTH_SHIFT);
+				PL080_CONTROL_DWIDTH_SHIFT);
 
 	/* Set up the bus widths to the maximum */
 	bd.srcbus.buswidth = bd.srcbus.maxwidth;
@@ -634,7 +633,8 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 	 */
 	pl08x_choose_master_bus(&bd, &mbus, &sbus, cctl);
 
-	dev_vdbg(&pl08x->adev->dev, "src=0x%08x%s/%u dst=0x%08x%s/%u len=%zu llimax=%zu\n",
+	dev_vdbg(&pl08x->adev->dev, "src=0x%08x%s/%u dst=0x%08x%s/%u len=%zu "
+			"llimax=%zu\n",
 		 bd.srcbus.addr, cctl & PL080_CONTROL_SRC_INCR ? "+" : "",
 		 bd.srcbus.buswidth,
 		 bd.dstbus.addr, cctl & PL080_CONTROL_DST_INCR ? "+" : "",
@@ -713,7 +713,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 
 			/* Find the nearest */
 			lli_len	= min(bd.srcbus.fill_bytes,
-				      bd.dstbus.fill_bytes);
+					bd.dstbus.fill_bytes);
 
 			BUG_ON(lli_len > bd.remainder);
 
@@ -735,16 +735,15 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 			} else {
 				/*
 				 * So now we know how many bytes to transfer
-				 * to get to the nearest boundary.  The next
-				 * LLI will past the boundary.  However, we
+				 * to get to the nearest boundary. The next
+				 * LLI will past the boundary. However, we
 				 * may be working to a boundary on the slave
-				 * bus.  We need to ensure the master stays
+				 * bus. We need to ensure the master stays
 				 * aligned, and that we are working in
 				 * multiples of the bus widths.
 				 */
 				odd_bytes = lli_len % mbus->buswidth;
 				lli_len -= odd_bytes;
-
 			}
 
 			if (lli_len) {
@@ -756,30 +755,32 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 				 */
 				/* FIXME: use round_down()? */
 				tsize = lli_len / min(mbus->buswidth,
-						      sbus->buswidth);
+						sbus->buswidth);
 				lli_len	= tsize * min(mbus->buswidth,
-						      sbus->buswidth);
+						sbus->buswidth);
 
 				if (target_len != lli_len) {
 					dev_vdbg(&pl08x->adev->dev,
-					"%s can't send what we want. Desired 0x%08zx, lli of 0x%08zx bytes in txd of 0x%08zx\n",
-					__func__, target_len, lli_len, txd->len);
+					"%s can't send what we want. Desired "
+					"0x%08zx, lli of 0x%08zx bytes in txd "
+					"of 0x%08zx\n", __func__, target_len,
+					lli_len, txd->len);
 				}
 
 				cctl = pl08x_cctl_bits(cctl,
-						       bd.srcbus.buswidth,
-						       bd.dstbus.buswidth,
-						       tsize);
+						bd.srcbus.buswidth,
+						bd.dstbus.buswidth,
+						tsize);
 
 				dev_vdbg(&pl08x->adev->dev,
-					"%s fill lli with single lli chunk of size 0x%08zx (remainder 0x%08zx)\n",
+					"%s fill lli with single lli chunk of "
+					"size 0x%08zx (remainder 0x%08zx)\n",
 					__func__, lli_len, bd.remainder);
 				pl08x_fill_lli_for_desc(&bd, num_llis++,
 					lli_len, cctl);
 				total_bytes += lli_len;
 			}
 
-
 			if (odd_bytes) {
 				/*
 				 * Creep past the boundary, maintaining
@@ -790,7 +791,8 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 						&& (bd.remainder); j++) {
 					cctl = pl08x_cctl_bits(cctl, 1, 1, 1);
 					dev_vdbg(&pl08x->adev->dev,
-						"%s align with boundary, single byte (remain 0x%08zx)\n",
+						"%s align with boundary, single"
+						" byte (remain 0x%08zx)\n",
 						__func__, bd.remainder);
 					pl08x_fill_lli_for_desc(&bd,
 						num_llis++, 1, cctl);
@@ -805,16 +807,17 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 		while (bd.remainder) {
 			cctl = pl08x_cctl_bits(cctl, 1, 1, 1);
 			dev_vdbg(&pl08x->adev->dev,
-				"%s align with boundary, single odd byte (remain %zu)\n",
-				__func__, bd.remainder);
+				"%s align with boundary, single odd byte "
+				"(remain %zu)\n", __func__, bd.remainder);
 			pl08x_fill_lli_for_desc(&bd, num_llis++, 1, cctl);
 			total_bytes++;
 		}
 	}
 	if (total_bytes != txd->len) {
 		dev_err(&pl08x->adev->dev,
-			"%s size of encoded lli:s don't match total txd, transferred 0x%08zx from size 0x%08zx\n",
-			__func__, total_bytes, txd->len);
+			"%s size of encoded lli:s don't match total txd, "
+			"transferred 0x%08zx from size 0x%08zx\n", __func__,
+			total_bytes, txd->len);
 		return 0;
 	}
 
@@ -853,7 +856,7 @@ static int pl08x_fill_llis_for_desc(struct pl08x_driver_data *pl08x,
 
 /* You should call this with the struct pl08x lock held */
 static void pl08x_free_txd(struct pl08x_driver_data *pl08x,
-			   struct pl08x_txd *txd)
+		struct pl08x_txd *txd)
 {
 	/* Free the LLI */
 	dma_pool_free(pl08x->pool, txd->llis_va, txd->llis_bus);
@@ -894,7 +897,7 @@ static void pl08x_free_chan_resources(struct dma_chan *chan)
  * This should be called with the channel plchan->lock held
  */
 static int prep_phy_channel(struct pl08x_dma_chan *plchan,
-			    struct pl08x_txd *txd)
+		struct pl08x_txd *txd)
 {
 	struct pl08x_driver_data *pl08x = plchan->host;
 	struct pl08x_phy_chan *ch;
@@ -907,7 +910,8 @@ static int prep_phy_channel(struct pl08x_dma_chan *plchan,
 	ch = pl08x_get_phy_channel(pl08x, plchan);
 	if (!ch) {
 		/* No physical channel available, cope with it */
-		dev_dbg(&pl08x->adev->dev, "no physical channel available for xfer on %s\n", plchan->name);
+		dev_dbg(&pl08x->adev->dev, "no physical channel available for "
+				"xfer on %s\n", plchan->name);
 		return -EBUSY;
 	}
 
@@ -916,13 +920,12 @@ static int prep_phy_channel(struct pl08x_dma_chan *plchan,
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
-				"unable to use physical channel %d for transfer on %s due to platform restrictions\n",
+				"unable to use physical channel %d for transfer"
+				" on %s due to platform restrictions\n",
 				ch->id, plchan->name);
 			/* Release physical channel & return */
 			pl08x_put_phy_channel(pl08x, ch);
@@ -937,7 +940,8 @@ static int prep_phy_channel(struct pl08x_dma_chan *plchan,
 			txd->ccfg |= ch->signal << PL080_CONFIG_SRC_SEL_SHIFT;
 	}
 
-	dev_dbg(&pl08x->adev->dev, "allocated physical channel %d and signal %d for xfer on %s\n",
+	dev_dbg(&pl08x->adev->dev, "allocated physical channel %d and signal %d"
+			" for xfer on %s\n",
 		 ch->id,
 		 ch->signal,
 		 plchan->name);
@@ -1007,10 +1011,8 @@ static struct dma_async_tx_descriptor *pl08x_prep_dma_interrupt(
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
@@ -1089,7 +1091,7 @@ static const struct burst_table burst_sizes[] = {
 
 /*
  * Given the source and destination available bus masks, select which
- * will be routed to each port.  We try to have source and destination
+ * will be routed to each port. We try to have source and destination
  * on separate ports, but always respect the allowable settings.
  */
 static u32 pl08x_select_bus(u8 src, u8 dst)
@@ -1107,8 +1109,8 @@ static u32 pl08x_select_bus(u8 src, u8 dst)
 static u32 pl08x_cctl(u32 cctl)
 {
 	cctl &= ~(PL080_CONTROL_SRC_AHB2 | PL080_CONTROL_DST_AHB2 |
-		  PL080_CONTROL_SRC_INCR | PL080_CONTROL_DST_INCR |
-		  PL080_CONTROL_PROT_MASK);
+			PL080_CONTROL_SRC_INCR | PL080_CONTROL_DST_INCR |
+			PL080_CONTROL_PROT_MASK);
 
 	/* Access the cell in privileged mode, non-bufferable, non-cacheable */
 	return cctl | PL080_CONTROL_PROT_SYS;
@@ -1140,7 +1142,7 @@ static u32 pl08x_burst(u32 maxburst)
 }
 
 static int dma_set_runtime_config(struct dma_chan *chan,
-				  struct dma_slave_config *config)
+		struct dma_slave_config *config)
 {
 	struct pl08x_dma_chan *plchan = to_pl08x_chan(chan);
 	struct pl08x_driver_data *pl08x = plchan->host;
@@ -1177,7 +1179,7 @@ static int dma_set_runtime_config(struct dma_chan *chan,
 
 	/*
 	 * If this channel will only request single transfers, set this
-	 * down to ONE element.  Also select one element if no maxburst
+	 * down to ONE element. Also select one element if no maxburst
 	 * is specified.
 	 */
 	if (plchan->cd->single)
@@ -1270,7 +1272,7 @@ static int pl08x_prep_channel_resources(struct pl08x_dma_chan *plchan,
 		 * memcpy transfers can be sorted out at submission time.
 		 *
 		 * Slave transfers may have been denied due to platform
-		 * channel muxing restrictions.  Since there is no guarantee
+		 * channel muxing restrictions. Since there is no guarantee
 		 * that this will ever be resolved, and the signal must be
 		 * acquired AFTER acquiring the physical channel, we will let
 		 * them be NACK:ed with -EBUSY here. The drivers can retry
@@ -1310,7 +1312,7 @@ static struct pl08x_txd *pl08x_get_txd(struct pl08x_dma_chan *plchan,
 
 		/* Always enable error and terminal interrupts */
 		txd->ccfg = PL080_CONFIG_ERR_IRQ_MASK |
-			    PL080_CONFIG_TC_IRQ_MASK;
+			PL080_CONFIG_TC_IRQ_MASK;
 	}
 	return txd;
 }
@@ -1349,7 +1351,7 @@ static struct dma_async_tx_descriptor *pl08x_prep_dma_memcpy(
 
 	if (pl08x->vd->dualmaster)
 		txd->cctl |= pl08x_select_bus(pl08x->mem_buses,
-					      pl08x->mem_buses);
+				pl08x->mem_buses);
 
 	ret = pl08x_prep_channel_resources(plchan, txd);
 	if (ret)
@@ -1377,8 +1379,8 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 		BUG();
 	}
 
-	dev_dbg(&pl08x->adev->dev, "%s prepare transaction of %d bytes from %s\n",
-		__func__, sgl->length, plchan->name);
+	dev_dbg(&pl08x->adev->dev, "%s prepare transaction of %d bytes from"
+			" %s\n", __func__, sgl->length, plchan->name);
 
 	txd = pl08x_get_txd(plchan, flags);
 	if (!txd) {
@@ -1400,12 +1402,14 @@ static struct dma_async_tx_descriptor *pl08x_prep_slave_sg(
 	txd->len = sgl->length;
 
 	if (direction == DMA_TO_DEVICE) {
-		txd->ccfg |= PL080_FLOW_MEM2PER << PL080_CONFIG_FLOW_CONTROL_SHIFT;
+		txd->ccfg |= PL080_FLOW_MEM2PER <<
+			PL080_CONFIG_FLOW_CONTROL_SHIFT;
 		txd->cctl = plchan->dst_cctl;
 		txd->src_addr = sgl->dma_address;
 		txd->dst_addr = plchan->dst_addr;
 	} else if (direction == DMA_FROM_DEVICE) {
-		txd->ccfg |= PL080_FLOW_PER2MEM << PL080_CONFIG_FLOW_CONTROL_SHIFT;
+		txd->ccfg |= PL080_FLOW_PER2MEM <<
+			PL080_CONFIG_FLOW_CONTROL_SHIFT;
 		txd->cctl = plchan->src_cctl;
 		txd->src_addr = plchan->src_addr;
 		txd->dst_addr = sgl->dma_address;
@@ -1433,7 +1437,7 @@ static int pl08x_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	/* Controls applicable to inactive channels */
 	if (cmd == DMA_SLAVE_CONFIG) {
 		return dma_set_runtime_config(chan,
-					      (struct dma_slave_config *)arg);
+				(struct dma_slave_config *)arg);
 	}
 
 	/*
@@ -1567,7 +1571,7 @@ static void pl08x_tasklet(unsigned long data)
 	} else if (plchan->phychan_hold) {
 		/*
 		 * This channel is still in use - we have a new txd being
-		 * prepared and will soon be queued.  Don't give up the
+		 * prepared and will soon be queued. Don't give up the
 		 * physical channel.
 		 */
 	} else {
@@ -1587,14 +1591,14 @@ static void pl08x_tasklet(unsigned long data)
 		 * up while we were choking the physical channels with data.
 		 */
 		list_for_each_entry(waiting, &pl08x->memcpy.channels,
-				    chan.device_node) {
-		  if (waiting->state == PL08X_CHAN_WAITING &&
-			    waiting->waiting != NULL) {
+				chan.device_node) {
+			if (waiting->state == PL08X_CHAN_WAITING &&
+					waiting->waiting != NULL) {
 				int ret;
 
 				/* This should REALLY not fail now */
 				ret = prep_phy_channel(waiting,
-						       waiting->waiting);
+						waiting->waiting);
 				BUG_ON(ret);
 				waiting->phychan_hold--;
 				waiting->state = PL08X_CHAN_RUNNING;
@@ -1684,9 +1688,7 @@ static void pl08x_dma_slave_init(struct pl08x_dma_chan *chan)
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
@@ -1738,7 +1740,7 @@ static int pl08x_dma_init_virtual_channels(struct pl08x_driver_data *pl08x,
 		spin_lock_init(&chan->lock);
 		INIT_LIST_HEAD(&chan->pend_list);
 		tasklet_init(&chan->tasklet, pl08x_tasklet,
-			     (unsigned long) chan);
+				(unsigned long) chan);
 
 		list_add_tail(&chan->chan.device_node, &dmadev->channels);
 	}
@@ -1797,7 +1799,7 @@ static int pl08x_debugfs_show(struct seq_file *s, void *data)
 		virt_chan = ch->serving;
 
 		seq_printf(s, "%d\t\t%s\n",
-			   ch->id, virt_chan ? virt_chan->name : "(none)");
+				ch->id, virt_chan ? virt_chan->name : "(none)");
 
 		spin_unlock_irqrestore(&ch->lock, flags);
 	}
@@ -1807,7 +1809,7 @@ static int pl08x_debugfs_show(struct seq_file *s, void *data)
 	seq_printf(s, "--------\t------\n");
 	list_for_each_entry(chan, &pl08x->memcpy.channels, chan.device_node) {
 		seq_printf(s, "%s\t\t%s\n", chan->name,
-			   pl08x_state_str(chan->state));
+				pl08x_state_str(chan->state));
 	}
 
 	seq_printf(s, "\nPL08x virtual slave channels:\n");
@@ -1815,7 +1817,7 @@ static int pl08x_debugfs_show(struct seq_file *s, void *data)
 	seq_printf(s, "--------\t------\n");
 	list_for_each_entry(chan, &pl08x->slave.channels, chan.device_node) {
 		seq_printf(s, "%s\t\t%s\n", chan->name,
-			   pl08x_state_str(chan->state));
+				pl08x_state_str(chan->state));
 	}
 
 	return 0;
@@ -1836,9 +1838,9 @@ static const struct file_operations pl08x_debugfs_operations = {
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
@@ -1898,7 +1900,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 	pl08x->adev = adev;
 	pl08x->vd = vd;
 
-	/* By default, AHB1 only.  If dualmaster, from platform */
+	/* By default, AHB1 only. If dualmaster, from platform */
 	pl08x->lli_buses = PL08X_AHB1;
 	pl08x->mem_buses = PL08X_AHB1;
 	if (pl08x->vd->dualmaster) {
@@ -1930,7 +1932,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 	writel(0x000000FF, pl08x->base + PL080_TC_CLEAR);
 
 	ret = request_irq(adev->irq[0], pl08x_irq, IRQF_DISABLED,
-			  DRIVER_NAME, pl08x);
+			DRIVER_NAME, pl08x);
 	if (ret) {
 		dev_err(&adev->dev, "%s failed to request interrupt %d\n",
 			__func__, adev->irq[0]);
@@ -1938,8 +1940,8 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 	}
 
 	/* Initialize physical channels */
-	pl08x->phy_chans = kmalloc((vd->channels * sizeof(struct pl08x_phy_chan)),
-			GFP_KERNEL);
+	pl08x->phy_chans = kmalloc((vd->channels *
+				sizeof(struct pl08x_phy_chan)), GFP_KERNEL);
 	if (!pl08x->phy_chans) {
 		dev_err(&adev->dev, "%s failed to allocate "
 			"physical channel holders\n",
@@ -1962,7 +1964,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 
 	/* Register as many memcpy channels as there are physical channels */
 	ret = pl08x_dma_init_virtual_channels(pl08x, &pl08x->memcpy,
-					      pl08x->vd->channels, false);
+			pl08x->vd->channels, false);
 	if (ret <= 0) {
 		dev_warn(&pl08x->adev->dev,
 			 "%s failed to enumerate memcpy channels - %d\n",
@@ -1973,8 +1975,7 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 
 	/* Register slave channels */
 	ret = pl08x_dma_init_virtual_channels(pl08x, &pl08x->slave,
-					      pl08x->pd->num_slave_channels,
-					      true);
+			pl08x->pd->num_slave_channels, true);
 	if (ret <= 0) {
 		dev_warn(&pl08x->adev->dev,
 			"%s failed to enumerate slave channels - %d\n",
@@ -1985,9 +1986,8 @@ static int pl08x_probe(struct amba_device *adev, const struct amba_id *id)
 
 	ret = dma_async_device_register(&pl08x->memcpy);
 	if (ret) {
-		dev_warn(&pl08x->adev->dev,
-			"%s failed to register memcpy as an async device - %d\n",
-			__func__, ret);
+		dev_warn(&pl08x->adev->dev, "%s failed to register memcpy as an"
+				" async device - %d\n", __func__, ret);
 		goto out_no_memcpy_reg;
 	}
 
@@ -2073,8 +2073,8 @@ static int __init pl08x_init(void)
 	retval = amba_driver_register(&pl08x_amba_driver);
 	if (retval)
 		printk(KERN_WARNING DRIVER_NAME
-		       "failed to register as an AMBA device (%d)\n",
-		       retval);
+			"failed to register as an AMBA device (%d)\n",
+			retval);
 	return retval;
 }
 subsys_initcall(pl08x_init);
diff --git a/include/linux/amba/pl08x.h b/include/linux/amba/pl08x.h
index e6e28f3..3e25825 100644
--- a/include/linux/amba/pl08x.h
+++ b/include/linux/amba/pl08x.h
@@ -121,7 +121,7 @@ struct pl08x_txd {
 	u32 cctl;
 	/*
 	 * Settings to be put into the physical channel when we
-	 * trigger this txd.  Other registers are in llis_va[0].
+	 * trigger this txd. Other registers are in llis_va[0].
 	 */
 	u32 ccfg;
 };
-- 
1.7.2.2

