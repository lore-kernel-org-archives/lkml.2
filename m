Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab2KEKC0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:02:26 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:46956 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab2KEKCV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:02:21 -0500
X-AuditID: cbfee61b-b7f616d00000319b-2f-50978eac3477
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: djbw@fb.com, dwmw2@infradead.org, hskinnemoen@gmail.com,
        iws@ovro.caltech.edu, vinod.koul@intel.com, vipin.kumar@st.com,
        t.figa@samsung.com, kyungmin.park@samsung.com,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH 20/20] DMA: remove DMA unmap flags
Date: Mon, 05 Nov 2012 11:00:31 +0100
Message-id: <1352109631-3385-21-git-send-email-b.zolnierkie@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
References: <1352109631-3385-1-git-send-email-b.zolnierkie@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t9jAd01fdMDDE6clrK4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZn7tesBWcbGasmP3nIEsD49KcLkZODgkBE4nV9/+zQdhiEhfu
	rQeyuTiEBBYxSixtvcsC4axmktg8fwIjSBWbgJXExPZVYLaIgILE5t5nrCBFzALPGCVm3O5m
	BkkICxhJTO68BlbEIqAqMfXHbyCbg4NXwENi+hRBiG3yEk/v94Ft5gQKNzZMYQWxhQTcJS53
	HmeewMi7gJFhFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkaw159J72Bc1WBxiFGAg1GJh/eT
	xPQAIdbEsuLK3EOMEhzMSiK8HAxAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzNHikBQgLpiSWp
	2ampBalFMFkmDk6pBsYQqWvzPCxVdhZYzdzz6sKP6Y/iIpXzwz5zLjqZM5/z3isWpwdC7iez
	RJTefkh1M4trnO6rLRO/U0pKQ1jdoPbu5DlBO77OTN1Vs9eii5tbljsmwaCQpe3Ez3W26h15
	HFHMZ6cXzXV6nZ7eKfneLEb4yeTpSkdv/04uO5fDs2WL/foGd80GLiWW4oxEQy3mouJEAErO
	tgb2AQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove no longer needed DMA unmap flags:
- DMA_COMPL_SKIP_SRC_UNMAP
- DMA_COMPL_SKIP_DEST_UNMAP
- DMA_COMPL_SRC_UNMAP_SINGLE
- DMA_COMPL_DEST_UNMAP_SINGLE

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 crypto/async_tx/async_memcpy.c           |  3 +--
 crypto/async_tx/async_memset.c           |  3 +--
 crypto/async_tx/async_pq.c               |  3 +--
 crypto/async_tx/async_raid6_recov.c      |  8 ++------
 crypto/async_tx/async_xor.c              |  6 ++----
 drivers/ata/pata_arasan_cf.c             |  3 +--
 drivers/dma/dmaengine.c                  |  9 +++------
 drivers/dma/dmatest.c                    |  3 +--
 drivers/dma/ioat/dma.c                   |  3 +--
 drivers/dma/ioat/dma_v3.c                | 16 ++++------------
 drivers/media/platform/m2m-deinterlace.c |  3 +--
 drivers/media/platform/timblogiw.c       |  2 +-
 drivers/misc/carma/carma-fpga.c          |  3 +--
 drivers/mtd/nand/atmel_nand.c            |  3 +--
 drivers/mtd/nand/fsmc_nand.c             |  2 --
 drivers/net/ethernet/micrel/ks8842.c     |  6 ++----
 drivers/spi/spi-dw-mid.c                 |  4 ++--
 include/linux/dmaengine.h                | 18 ++++--------------
 18 files changed, 29 insertions(+), 69 deletions(-)

diff --git a/crypto/async_tx/async_memcpy.c b/crypto/async_tx/async_memcpy.c
index cb0628e..ff5e803 100644
--- a/crypto/async_tx/async_memcpy.c
+++ b/crypto/async_tx/async_memcpy.c
@@ -65,8 +65,7 @@ async_memcpy(struct page *dest, struct page *src, unsigned int dest_offset,
 	dma_addr_t dma_dest, dma_src;
 
 	if (device && is_dma_copy_aligned(device, src_offset, dest_offset, len)) {
-		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-					       DMA_COMPL_SKIP_DEST_UNMAP;
+		unsigned long dma_prep_flags = 0;
 
 		if (submit->cb_fn)
 			dma_prep_flags |= DMA_PREP_INTERRUPT;
diff --git a/crypto/async_tx/async_memset.c b/crypto/async_tx/async_memset.c
index cf30bf1..7775852 100644
--- a/crypto/async_tx/async_memset.c
+++ b/crypto/async_tx/async_memset.c
@@ -61,8 +61,7 @@ async_memset(struct page *dest, int val, unsigned int offset, size_t len,
 	dma_addr_t dma_dest;
 
 	if (device && is_dma_fill_aligned(device, offset, 0, len)) {
-		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-					       DMA_COMPL_SKIP_DEST_UNMAP;
+		unsigned long dma_prep_flags = 0;
 
 		if (submit->cb_fn)
 			dma_prep_flags |= DMA_PREP_INTERRUPT;
diff --git a/crypto/async_tx/async_pq.c b/crypto/async_tx/async_pq.c
index 9e5500e..0963de5 100644
--- a/crypto/async_tx/async_pq.c
+++ b/crypto/async_tx/async_pq.c
@@ -94,8 +94,7 @@ do_async_gen_syndrome(struct dma_chan *chan, struct page **blocks,
 
 	while (src_cnt > 0) {
 		submit->flags = flags_orig;
-		dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-			    DMA_COMPL_SKIP_DEST_UNMAP;
+		dma_flags = 0;
 		pq_src_cnt = min(src_cnt, dma_maxpq(dma, dma_flags));
 		/* if we are submitting additional pqs, leave the chain open,
 		 * clear the callback parameters, and leave the destination
diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index 3db97aa..b0fceb1 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -57,9 +57,7 @@ async_sum_product(struct page *dest, struct page **srcs, unsigned char *coef,
 		dma_addr_t dma_src[2];
 		struct device *dev = dma->dev;
 		struct dma_async_tx_descriptor *tx;
-		enum dma_ctrl_flags dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-						DMA_COMPL_SKIP_DEST_UNMAP |
-						DMA_PREP_PQ_DISABLE_P;
+		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
@@ -133,9 +131,7 @@ async_mult(struct page *dest, struct page *src, u8 coef, size_t len,
 		dma_addr_t dma_src[1];
 		struct device *dev = dma->dev;
 		struct dma_async_tx_descriptor *tx;
-		enum dma_ctrl_flags dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-						DMA_COMPL_SKIP_DEST_UNMAP |
-						DMA_PREP_PQ_DISABLE_P;
+		enum dma_ctrl_flags dma_flags = DMA_PREP_PQ_DISABLE_P;
 
 		if (submit->flags & ASYNC_TX_FENCE)
 			dma_flags |= DMA_PREP_FENCE;
diff --git a/crypto/async_tx/async_xor.c b/crypto/async_tx/async_xor.c
index d44da16..e632913 100644
--- a/crypto/async_tx/async_xor.c
+++ b/crypto/async_tx/async_xor.c
@@ -78,8 +78,7 @@ do_async_xor(struct dma_chan *chan, struct page *dest, struct page **src_list,
 
 	while (src_cnt) {
 		submit->flags = flags_orig;
-		dma_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-			    DMA_COMPL_SKIP_DEST_UNMAP;
+		dma_flags = 0;
 		xor_src_cnt = min(src_cnt, (int)dma->max_xor);
 		/* if we are submitting additional xors, leave the chain open
 		 * and clear the callback parameters
@@ -333,8 +332,7 @@ async_xor_val(struct page *dest, struct page **src_list, unsigned int offset,
 
 	if (dma_src && device && src_cnt <= device->max_xor &&
 	    is_dma_xor_aligned(device, offset, 0, len)) {
-		unsigned long dma_prep_flags = DMA_COMPL_SKIP_SRC_UNMAP |
-					       DMA_COMPL_SKIP_DEST_UNMAP;
+		unsigned long dma_prep_flags = 0;
 		int i;
 
 		pr_debug("%s: (async) len: %zu\n", __func__, len);
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index 26201eb..9a6d38d 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -393,8 +393,7 @@ dma_xfer(struct arasan_cf_dev *acdev, dma_addr_t src, dma_addr_t dest, u32 len)
 	struct dma_async_tx_descriptor *tx;
 	struct dma_chan *chan = acdev->dma_chan;
 	dma_cookie_t cookie;
-	unsigned long flags = DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP |
-		DMA_COMPL_SKIP_DEST_UNMAP;
+	unsigned long flags = DMA_PREP_INTERRUPT;
 	int ret = 0;
 
 	tx = chan->device->device_prep_dma_memcpy(chan, dest, src, len, flags);
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 5573e86..b137121 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -888,8 +888,7 @@ dma_async_memcpy_buf_to_buf(struct dma_chan *chan, void *dest,
 
 	dma_src = dma_map_single(dev->dev, src, len, DMA_TO_DEVICE);
 	dma_dest = dma_map_single(dev->dev, dest, len, DMA_FROM_DEVICE);
-	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_SRC_UNMAP |
-		DMA_COMPL_SKIP_DEST_UNMAP;
+	flags = DMA_CTRL_ACK;
 	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, flags);
 
 	if (!tx) {
@@ -950,8 +949,7 @@ dma_async_memcpy_buf_to_pg(struct dma_chan *chan, struct page *page,
 
 	dma_src = dma_map_single(dev->dev, kdata, len, DMA_TO_DEVICE);
 	dma_dest = dma_map_page(dev->dev, page, offset, len, DMA_FROM_DEVICE);
-	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_SRC_UNMAP |
-		DMA_COMPL_SKIP_DEST_UNMAP;
+	flags = DMA_CTRL_ACK;
 	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, flags);
 
 	if (!tx) {
@@ -1015,8 +1013,7 @@ dma_async_memcpy_pg_to_pg(struct dma_chan *chan, struct page *dest_pg,
 	dma_src = dma_map_page(dev->dev, src_pg, src_off, len, DMA_TO_DEVICE);
 	dma_dest = dma_map_page(dev->dev, dest_pg, dest_off, len,
 				DMA_FROM_DEVICE);
-	flags = DMA_CTRL_ACK | DMA_COMPL_SKIP_SRC_UNMAP |
-		DMA_COMPL_SKIP_DEST_UNMAP;
+	flags = DMA_CTRL_ACK;
 	tx = dev->device_prep_dma_memcpy(chan, dma_dest, dma_src, len, flags);
 
 	if (!tx) {
diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 3b36890..df78702 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -305,8 +305,7 @@ static int dmatest_func(void *data)
 	set_user_nice(current, 10);
 
 	/* src and dst buffers are freed by ourselves below */
-	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT |
-		DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
+	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 
 	while (!kthread_should_stop()
 	       && !(iterations && total_tests >= iterations)) {
diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
index 0851ded..cc18aaa 100644
--- a/drivers/dma/ioat/dma.c
+++ b/drivers/dma/ioat/dma.c
@@ -817,8 +817,7 @@ int __devinit ioat_dma_self_test(struct ioatdma_device *device)
 
 	dma_src = dma_map_single(dev, src, IOAT_TEST_SIZE, DMA_TO_DEVICE);
 	dma_dest = dma_map_single(dev, dest, IOAT_TEST_SIZE, DMA_FROM_DEVICE);
-	flags = DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP |
-		DMA_PREP_INTERRUPT;
+	flags = DMA_PREP_INTERRUPT;
 	tx = device->common.device_prep_dma_memcpy(dma_chan, dma_dest, dma_src,
 						   IOAT_TEST_SIZE, flags);
 	if (!tx) {
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 5027c0b..64b3744 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -798,9 +798,7 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 					   DMA_TO_DEVICE);
 	tx = dma->device_prep_dma_xor(dma_chan, dest_dma, dma_srcs,
 				      IOAT_NUM_SRC_TEST, PAGE_SIZE,
-				      DMA_PREP_INTERRUPT |
-				      DMA_COMPL_SKIP_SRC_UNMAP |
-				      DMA_COMPL_SKIP_DEST_UNMAP);
+				      DMA_PREP_INTERRUPT);
 
 	if (!tx) {
 		dev_err(dev, "Self-test xor prep failed\n");
@@ -861,9 +859,7 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 					   DMA_TO_DEVICE);
 	tx = dma->device_prep_dma_xor_val(dma_chan, dma_srcs,
 					  IOAT_NUM_SRC_TEST + 1, PAGE_SIZE,
-					  &xor_val_result, DMA_PREP_INTERRUPT |
-					  DMA_COMPL_SKIP_SRC_UNMAP |
-					  DMA_COMPL_SKIP_DEST_UNMAP);
+					  &xor_val_result, DMA_PREP_INTERRUPT);
 	if (!tx) {
 		dev_err(dev, "Self-test zero prep failed\n");
 		err = -ENODEV;
@@ -909,9 +905,7 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 	dma_addr = dma_map_page(dev, dest, 0,
 			PAGE_SIZE, DMA_FROM_DEVICE);
 	tx = dma->device_prep_dma_memset(dma_chan, dma_addr, 0, PAGE_SIZE,
-					 DMA_PREP_INTERRUPT |
-					 DMA_COMPL_SKIP_SRC_UNMAP |
-					 DMA_COMPL_SKIP_DEST_UNMAP);
+					 DMA_PREP_INTERRUPT);
 	if (!tx) {
 		dev_err(dev, "Self-test memset prep failed\n");
 		err = -ENODEV;
@@ -958,9 +952,7 @@ static int __devinit ioat_xor_val_self_test(struct ioatdma_device *device)
 					   DMA_TO_DEVICE);
 	tx = dma->device_prep_dma_xor_val(dma_chan, dma_srcs,
 					  IOAT_NUM_SRC_TEST + 1, PAGE_SIZE,
-					  &xor_val_result, DMA_PREP_INTERRUPT |
-					  DMA_COMPL_SKIP_SRC_UNMAP |
-					  DMA_COMPL_SKIP_DEST_UNMAP);
+					  &xor_val_result, DMA_PREP_INTERRUPT);
 	if (!tx) {
 		dev_err(dev, "Self-test 2nd zero prep failed\n");
 		err = -ENODEV;
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 45164c4..8c63b93 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -344,8 +344,7 @@ static void deinterlace_issue_dma(struct deinterlace_ctx *ctx, int op,
 	ctx->xt->dir = DMA_MEM_TO_MEM;
 	ctx->xt->src_sgl = false;
 	ctx->xt->dst_sgl = true;
-	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT |
-		DMA_COMPL_SKIP_DEST_UNMAP | DMA_COMPL_SKIP_SRC_UNMAP;
+	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 
 	tx = dmadev->device_prep_interleaved_dma(chan, ctx->xt, flags);
 	if (tx == NULL) {
diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
index 02194c0..8ae630c 100644
--- a/drivers/media/platform/timblogiw.c
+++ b/drivers/media/platform/timblogiw.c
@@ -566,7 +566,7 @@ static void buffer_queue(struct videobuf_queue *vq, struct videobuf_buffer *vb)
 
 	desc = dmaengine_prep_slave_sg(fh->chan,
 		buf->sg, sg_elems, DMA_DEV_TO_MEM,
-		DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
+		DMA_PREP_INTERRUPT);
 	if (!desc) {
 		spin_lock_irq(&fh->queue_lock);
 		list_del_init(&vb->queue);
diff --git a/drivers/misc/carma/carma-fpga.c b/drivers/misc/carma/carma-fpga.c
index 6b43f8c..ae4289b 100644
--- a/drivers/misc/carma/carma-fpga.c
+++ b/drivers/misc/carma/carma-fpga.c
@@ -631,8 +631,7 @@ static int data_submit_dma(struct fpga_device *priv, struct data_buf *buf)
 	struct dma_async_tx_descriptor *tx;
 	dma_cookie_t cookie;
 	dma_addr_t dst, src;
-	unsigned long dma_flags = DMA_COMPL_SKIP_DEST_UNMAP |
-				  DMA_COMPL_SKIP_SRC_UNMAP;
+	unsigned long dma_flags = 0;
 
 	dst_sg = buf->vb.sglist;
 	dst_nents = buf->vb.sglen;
diff --git a/drivers/mtd/nand/atmel_nand.c b/drivers/mtd/nand/atmel_nand.c
index 9144557..5e1f88f 100644
--- a/drivers/mtd/nand/atmel_nand.c
+++ b/drivers/mtd/nand/atmel_nand.c
@@ -238,8 +238,7 @@ static int atmel_nand_dma_op(struct mtd_info *mtd, void *buf, int len,
 
 	dma_dev = host->dma_chan->device;
 
-	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP |
-		DMA_COMPL_SKIP_DEST_UNMAP;
+	flags = DMA_CTRL_ACK | DMA_PREP_INTERRUPT;
 
 	phys_addr = dma_map_single(dma_dev->dev, p, len, dir);
 	if (dma_mapping_error(dma_dev->dev, phys_addr)) {
diff --git a/drivers/mtd/nand/fsmc_nand.c b/drivers/mtd/nand/fsmc_nand.c
index 679ede8..fdb98f0 100644
--- a/drivers/mtd/nand/fsmc_nand.c
+++ b/drivers/mtd/nand/fsmc_nand.c
@@ -569,8 +569,6 @@ static int dma_xfer(struct fsmc_nand_data *host, void *buffer, int len,
 	dma_dev = chan->device;
 	dma_addr = dma_map_single(dma_dev->dev, buffer, len, direction);
 
-	flags |= DMA_COMPL_SKIP_SRC_UNMAP | DMA_COMPL_SKIP_DEST_UNMAP;
-
 	if (direction == DMA_TO_DEVICE) {
 		dma_src = dma_addr;
 		dma_dst = host->data_pa;
diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
index 24fb049..f657760 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -459,8 +459,7 @@ static int ks8842_tx_frame_dma(struct sk_buff *skb, struct net_device *netdev)
 		sg_dma_len(&ctl->sg) += 4 - sg_dma_len(&ctl->sg) % 4;
 
 	ctl->adesc = dmaengine_prep_slave_sg(ctl->chan,
-		&ctl->sg, 1, DMA_MEM_TO_DEV,
-		DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
+		&ctl->sg, 1, DMA_MEM_TO_DEV, DMA_PREP_INTERRUPT);
 	if (!ctl->adesc)
 		return NETDEV_TX_BUSY;
 
@@ -571,8 +570,7 @@ static int __ks8842_start_new_rx_dma(struct net_device *netdev)
 		sg_dma_len(sg) = DMA_BUFFER_SIZE;
 
 		ctl->adesc = dmaengine_prep_slave_sg(ctl->chan,
-			sg, 1, DMA_DEV_TO_MEM,
-			DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_SRC_UNMAP);
+			sg, 1, DMA_DEV_TO_MEM, DMA_PREP_INTERRUPT);
 
 		if (!ctl->adesc)
 			goto out;
diff --git a/drivers/spi/spi-dw-mid.c b/drivers/spi/spi-dw-mid.c
index b9f0192..6d207af 100644
--- a/drivers/spi/spi-dw-mid.c
+++ b/drivers/spi/spi-dw-mid.c
@@ -150,7 +150,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 				&dws->tx_sgl,
 				1,
 				DMA_MEM_TO_DEV,
-				DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_DEST_UNMAP);
+				DMA_PREP_INTERRUPT);
 	txdesc->callback = dw_spi_dma_done;
 	txdesc->callback_param = dws;
 
@@ -173,7 +173,7 @@ static int mid_spi_dma_transfer(struct dw_spi *dws, int cs_change)
 				&dws->rx_sgl,
 				1,
 				DMA_DEV_TO_MEM,
-				DMA_PREP_INTERRUPT | DMA_COMPL_SKIP_DEST_UNMAP);
+				DMA_PREP_INTERRUPT);
 	rxdesc->callback = dw_spi_dma_done;
 	rxdesc->callback_param = dws;
 
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index af3b941..b1269ed 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -169,12 +169,6 @@ struct dma_interleaved_template {
  * @DMA_CTRL_ACK - if clear, the descriptor cannot be reused until the client
  *  acknowledges receipt, i.e. has has a chance to establish any dependency
  *  chains
- * @DMA_COMPL_SKIP_SRC_UNMAP - set to disable dma-unmapping the source buffer(s)
- * @DMA_COMPL_SKIP_DEST_UNMAP - set to disable dma-unmapping the destination(s)
- * @DMA_COMPL_SRC_UNMAP_SINGLE - set to do the source dma-unmapping as single
- * 	(if not set, do the source dma-unmapping as page)
- * @DMA_COMPL_DEST_UNMAP_SINGLE - set to do the destination dma-unmapping as single
- * 	(if not set, do the destination dma-unmapping as page)
  * @DMA_PREP_PQ_DISABLE_P - prevent generation of P while generating Q
  * @DMA_PREP_PQ_DISABLE_Q - prevent generation of Q while generating P
  * @DMA_PREP_CONTINUE - indicate to a driver that it is reusing buffers as
@@ -186,14 +180,10 @@ struct dma_interleaved_template {
 enum dma_ctrl_flags {
 	DMA_PREP_INTERRUPT = (1 << 0),
 	DMA_CTRL_ACK = (1 << 1),
-	DMA_COMPL_SKIP_SRC_UNMAP = (1 << 2),
-	DMA_COMPL_SKIP_DEST_UNMAP = (1 << 3),
-	DMA_COMPL_SRC_UNMAP_SINGLE = (1 << 4),
-	DMA_COMPL_DEST_UNMAP_SINGLE = (1 << 5),
-	DMA_PREP_PQ_DISABLE_P = (1 << 6),
-	DMA_PREP_PQ_DISABLE_Q = (1 << 7),
-	DMA_PREP_CONTINUE = (1 << 8),
-	DMA_PREP_FENCE = (1 << 9),
+	DMA_PREP_PQ_DISABLE_P = (1 << 2),
+	DMA_PREP_PQ_DISABLE_Q = (1 << 3),
+	DMA_PREP_CONTINUE = (1 << 4),
+	DMA_PREP_FENCE = (1 << 5),
 };
 
 /**
-- 
1.8.0

