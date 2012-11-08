Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab2KHKIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 05:08:32 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:13365 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab2KHKHa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 05:07:30 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-57-509b84559293
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] DMA: remove unused support for MEMSET operations
Date: Thu, 08 Nov 2012 10:58:17 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
MIME-version: 1.0
Message-id: <201211081058.17897.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=iso-8859-1
Content-transfer-encoding: 8BIT
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCLMWRmVeSWpSXmKPExsVy+t9jAd3QltkBBh8e2lhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MS//XMxXM/c5YcWFPI1sD48FLjF2MnBwSAiYS345+YIOwxSQu
	3FsPZgsJLGKU6N/n28XIBWQvZZJ4MOMnK0iCTcBKYmL7KrBmEQEFic29z8DiwgKOEtNP72IG
	sVkEVCX+3rzBDmKLCjhIdE6dwAYyiFlgAqPEr7WHWUASvAKCEj8m34OyLSUmdG5nArGZBXQk
	ds6/zQxha0s8eXeBdQIj3ywkLbOQlM1CUraAkXkVo2hqQXJBcVJ6rqFecWJucWleul5yfu4m
	RnBYPZPawbiyweIQowAHoxIPr4bk7AAh1sSy4srcQ4wSHMxKIrzLnIFCvCmJlVWpRfnxRaU5
	qcWHGKU5WJTEeZs9UgKEBNITS1KzU1MLUotgskwcnFINjHaXn2XsmrY45RXTu1/WMUq2xp9+
	GDXP1Ljf4LmPI5h51fq0zY8Pzr/GomB+NPBt+zTey2rl7nHXuoqtTnlf3du36SNHWWPQl7dr
	fonnXG45ds+HYbqvXsjJqYcFJk2YfTZuRej0JSrFbzOZj1z+pbf83IdtuQ1hW2df+cqd9OdX
	7uHXx9bFr5JWYinOSDTUYi4qTgQAHWgzKCcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: [PATCH] DMA: remove unused support for MEMSET operations

There have never been any real users of MEMSET operations
since they have been introduced in January 2007 (commit
7405f74badf46b5d023c5d2b670b4471525f6c91 "dmaengine: refactor
dmaengine around dma_async_tx_descriptor").  Therefore remove
support for them for now, it can be always brought back when
needed.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 Documentation/crypto/async-tx-api.txt |    1 
 arch/arm/mach-iop13xx/setup.c         |    3 -
 arch/arm/plat-iop/adma.c              |    2 
 arch/arm/plat-orion/common.c          |    5 -
 crypto/async_tx/Kconfig               |    4 -
 crypto/async_tx/Makefile              |    1 
 crypto/async_tx/async_memset.c        |   88 -------------------------------
 drivers/dma/dmaengine.c               |    7 --
 drivers/dma/ioat/dma.c                |    1 
 drivers/dma/ioat/dma_v3.c             |   94 ----------------------------------
 drivers/dma/iop-adma.c                |   66 -----------------------
 drivers/dma/mv_xor.c                  |   60 +--------------------
 drivers/dma/mv_xor.h                  |    1 
 drivers/dma/ppc4xx/adma.c             |   47 -----------------
 include/linux/async_tx.h              |    4 -
 include/linux/dmaengine.h             |    5 -
 16 files changed, 4 insertions(+), 385 deletions(-)

Index: b/Documentation/crypto/async-tx-api.txt
===================================================================
--- a/Documentation/crypto/async-tx-api.txt	2012-11-07 15:00:06.208876620 +0100
+++ b/Documentation/crypto/async-tx-api.txt	2012-11-07 15:00:15.864876621 +0100
@@ -222,5 +222,4 @@ drivers/dma/: location for offload engin
 include/linux/async_tx.h: core header file for the async_tx api
 crypto/async_tx/async_tx.c: async_tx interface to dmaengine and common code
 crypto/async_tx/async_memcpy.c: copy offload
-crypto/async_tx/async_memset.c: memory fill offload
 crypto/async_tx/async_xor.c: xor and xor zero sum offload
Index: b/arch/arm/mach-iop13xx/setup.c
===================================================================
--- a/arch/arm/mach-iop13xx/setup.c	2012-11-07 15:15:11.000876512 +0100
+++ b/arch/arm/mach-iop13xx/setup.c	2012-11-07 15:15:21.068876510 +0100
@@ -469,7 +469,6 @@ void __init iop13xx_platform_init(void)
 			dma_cap_set(DMA_MEMCPY, plat_data->cap_mask);
 			dma_cap_set(DMA_XOR, plat_data->cap_mask);
 			dma_cap_set(DMA_XOR_VAL, plat_data->cap_mask);
-			dma_cap_set(DMA_MEMSET, plat_data->cap_mask);
 			dma_cap_set(DMA_INTERRUPT, plat_data->cap_mask);
 			break;
 		case IOP13XX_INIT_ADMA_1:
@@ -479,7 +478,6 @@ void __init iop13xx_platform_init(void)
 			dma_cap_set(DMA_MEMCPY, plat_data->cap_mask);
 			dma_cap_set(DMA_XOR, plat_data->cap_mask);
 			dma_cap_set(DMA_XOR_VAL, plat_data->cap_mask);
-			dma_cap_set(DMA_MEMSET, plat_data->cap_mask);
 			dma_cap_set(DMA_INTERRUPT, plat_data->cap_mask);
 			break;
 		case IOP13XX_INIT_ADMA_2:
@@ -489,7 +487,6 @@ void __init iop13xx_platform_init(void)
 			dma_cap_set(DMA_MEMCPY, plat_data->cap_mask);
 			dma_cap_set(DMA_XOR, plat_data->cap_mask);
 			dma_cap_set(DMA_XOR_VAL, plat_data->cap_mask);
-			dma_cap_set(DMA_MEMSET, plat_data->cap_mask);
 			dma_cap_set(DMA_INTERRUPT, plat_data->cap_mask);
 			dma_cap_set(DMA_PQ, plat_data->cap_mask);
 			dma_cap_set(DMA_PQ_VAL, plat_data->cap_mask);
Index: b/arch/arm/plat-iop/adma.c
===================================================================
--- a/arch/arm/plat-iop/adma.c	2012-11-07 15:15:28.968876510 +0100
+++ b/arch/arm/plat-iop/adma.c	2012-11-07 15:15:44.540876510 +0100
@@ -192,12 +192,10 @@ static int __init iop3xx_adma_cap_init(v
 
 	#ifdef CONFIG_ARCH_IOP32X /* the 32x AAU does not perform zero sum */
 	dma_cap_set(DMA_XOR, iop3xx_aau_data.cap_mask);
-	dma_cap_set(DMA_MEMSET, iop3xx_aau_data.cap_mask);
 	dma_cap_set(DMA_INTERRUPT, iop3xx_aau_data.cap_mask);
 	#else
 	dma_cap_set(DMA_XOR, iop3xx_aau_data.cap_mask);
 	dma_cap_set(DMA_XOR_VAL, iop3xx_aau_data.cap_mask);
-	dma_cap_set(DMA_MEMSET, iop3xx_aau_data.cap_mask);
 	dma_cap_set(DMA_INTERRUPT, iop3xx_aau_data.cap_mask);
 	#endif
 
Index: b/arch/arm/plat-orion/common.c
===================================================================
--- a/arch/arm/plat-orion/common.c	2012-11-07 15:15:50.744876507 +0100
+++ b/arch/arm/plat-orion/common.c	2012-11-07 15:16:12.116876505 +0100
@@ -612,16 +612,11 @@ void __init orion_xor_init_channels(
 	struct mv_xor_platform_data *orion_xor1_data,
 	struct platform_device *orion_xor1_channel)
 {
-	/*
-	 * two engines can't do memset simultaneously, this limitation
-	 * satisfied by removing memset support from one of the engines.
-	 */
 	dma_cap_set(DMA_MEMCPY, orion_xor0_data->cap_mask);
 	dma_cap_set(DMA_XOR, orion_xor0_data->cap_mask);
 	platform_device_register(orion_xor0_channel);
 
 	dma_cap_set(DMA_MEMCPY, orion_xor1_data->cap_mask);
-	dma_cap_set(DMA_MEMSET, orion_xor1_data->cap_mask);
 	dma_cap_set(DMA_XOR, orion_xor1_data->cap_mask);
 	platform_device_register(orion_xor1_channel);
 }
Index: b/crypto/async_tx/Kconfig
===================================================================
--- a/crypto/async_tx/Kconfig	2012-11-07 15:04:48.884876588 +0100
+++ b/crypto/async_tx/Kconfig	2012-11-07 15:04:53.168876586 +0100
@@ -10,10 +10,6 @@ config ASYNC_XOR
 	select ASYNC_CORE
 	select XOR_BLOCKS
 
-config ASYNC_MEMSET
-	tristate
-	select ASYNC_CORE
-
 config ASYNC_PQ
 	tristate
 	select ASYNC_CORE
Index: b/crypto/async_tx/Makefile
===================================================================
--- a/crypto/async_tx/Makefile	2012-11-07 15:00:23.432876618 +0100
+++ b/crypto/async_tx/Makefile	2012-11-07 15:00:27.368876619 +0100
@@ -1,6 +1,5 @@
 obj-$(CONFIG_ASYNC_CORE) += async_tx.o
 obj-$(CONFIG_ASYNC_MEMCPY) += async_memcpy.o
-obj-$(CONFIG_ASYNC_MEMSET) += async_memset.o
 obj-$(CONFIG_ASYNC_XOR) += async_xor.o
 obj-$(CONFIG_ASYNC_PQ) += async_pq.o
 obj-$(CONFIG_ASYNC_RAID6_RECOV) += async_raid6_recov.o
Index: b/crypto/async_tx/async_memset.c
===================================================================
--- a/crypto/async_tx/async_memset.c	2012-11-07 15:00:33.272876618 +0100
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,88 +0,0 @@
-/*
- * memory fill offload engine support
- *
- * Copyright © 2006, Intel Corporation.
- *
- *      Dan Williams <dan.j.williams@intel.com>
- *
- *      with architecture considerations by:
- *      Neil Brown <neilb@suse.de>
- *      Jeff Garzik <jeff@garzik.org>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- *
- */
-#include <linux/kernel.h>
-#include <linux/interrupt.h>
-#include <linux/mm.h>
-#include <linux/dma-mapping.h>
-#include <linux/async_tx.h>
-
-/**
- * async_memset - attempt to fill memory with a dma engine.
- * @dest: destination page
- * @val: fill value
- * @offset: offset in pages to start transaction
- * @len: length in bytes
- *
- * honored flags: ASYNC_TX_ACK
- */
-struct dma_async_tx_descriptor *
-async_memset(struct page *dest, int val, unsigned int offset, size_t len,
-	     struct async_submit_ctl *submit)
-{
-	struct dma_chan *chan = async_tx_find_channel(submit, DMA_MEMSET,
-						      &dest, 1, NULL, 0, len);
-	struct dma_device *device = chan ? chan->device : NULL;
-	struct dma_async_tx_descriptor *tx = NULL;
-
-	if (device && is_dma_fill_aligned(device, offset, 0, len)) {
-		dma_addr_t dma_dest;
-		unsigned long dma_prep_flags = 0;
-
-		if (submit->cb_fn)
-			dma_prep_flags |= DMA_PREP_INTERRUPT;
-		if (submit->flags & ASYNC_TX_FENCE)
-			dma_prep_flags |= DMA_PREP_FENCE;
-		dma_dest = dma_map_page(device->dev, dest, offset, len,
-					DMA_FROM_DEVICE);
-
-		tx = device->device_prep_dma_memset(chan, dma_dest, val, len,
-						    dma_prep_flags);
-	}
-
-	if (tx) {
-		pr_debug("%s: (async) len: %zu\n", __func__, len);
-		async_tx_submit(chan, tx, submit);
-	} else { /* run the memset synchronously */
-		void *dest_buf;
-		pr_debug("%s: (sync) len: %zu\n", __func__, len);
-
-		dest_buf = page_address(dest) + offset;
-
-		/* wait for any prerequisite operations */
-		async_tx_quiesce(&submit->depend_tx);
-
-		memset(dest_buf, val, len);
-
-		async_tx_sync_epilog(submit);
-	}
-
-	return tx;
-}
-EXPORT_SYMBOL_GPL(async_memset);
-
-MODULE_AUTHOR("Intel Corporation");
-MODULE_DESCRIPTION("asynchronous memset api");
-MODULE_LICENSE("GPL");
Index: b/drivers/dma/dmaengine.c
===================================================================
--- a/drivers/dma/dmaengine.c	2012-11-07 15:04:57.948876585 +0100
+++ b/drivers/dma/dmaengine.c	2012-11-07 15:06:04.348876578 +0100
@@ -635,11 +635,6 @@ static bool device_has_all_tx_types(stru
 		return false;
 	#endif
 
-	#if defined(CONFIG_ASYNC_MEMSET) || defined(CONFIG_ASYNC_MEMSET_MODULE)
-	if (!dma_has_cap(DMA_MEMSET, device->cap_mask))
-		return false;
-	#endif
-
 	#if defined(CONFIG_ASYNC_XOR) || defined(CONFIG_ASYNC_XOR_MODULE)
 	if (!dma_has_cap(DMA_XOR, device->cap_mask))
 		return false;
@@ -705,8 +700,6 @@ int dma_async_device_register(struct dma
 		!device->device_prep_dma_pq);
 	BUG_ON(dma_has_cap(DMA_PQ_VAL, device->cap_mask) &&
 		!device->device_prep_dma_pq_val);
-	BUG_ON(dma_has_cap(DMA_MEMSET, device->cap_mask) &&
-		!device->device_prep_dma_memset);
 	BUG_ON(dma_has_cap(DMA_INTERRUPT, device->cap_mask) &&
 		!device->device_prep_dma_interrupt);
 	BUG_ON(dma_has_cap(DMA_SG, device->cap_mask) &&
Index: b/drivers/dma/ioat/dma.c
===================================================================
--- a/drivers/dma/ioat/dma.c	2012-11-07 15:16:19.904876505 +0100
+++ b/drivers/dma/ioat/dma.c	2012-11-07 15:16:34.236876504 +0100
@@ -1101,7 +1101,6 @@ static ssize_t cap_show(struct dma_chan 
 		       dma_has_cap(DMA_PQ_VAL, dma->cap_mask) ? " pq_val" : "",
 		       dma_has_cap(DMA_XOR, dma->cap_mask) ? " xor" : "",
 		       dma_has_cap(DMA_XOR_VAL, dma->cap_mask) ? " xor_val" : "",
-		       dma_has_cap(DMA_MEMSET, dma->cap_mask)  ? " fill" : "",
 		       dma_has_cap(DMA_INTERRUPT, dma->cap_mask) ? " intr" : "");
 
 }
Index: b/drivers/dma/ioat/dma_v3.c
===================================================================
--- a/drivers/dma/ioat/dma_v3.c	2012-11-07 15:06:10.004876577 +0100
+++ b/drivers/dma/ioat/dma_v3.c	2012-11-07 15:17:29.676876495 +0100
@@ -423,51 +423,6 @@ ioat3_tx_status(struct dma_chan *c, dma_
 }
 
 static struct dma_async_tx_descriptor *
-ioat3_prep_memset_lock(struct dma_chan *c, dma_addr_t dest, int value,
-		       size_t len, unsigned long flags)
-{
-	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
-	struct ioat_ring_ent *desc;
-	size_t total_len = len;
-	struct ioat_fill_descriptor *fill;
-	u64 src_data = (0x0101010101010101ULL) * (value & 0xff);
-	int num_descs, idx, i;
-
-	num_descs = ioat2_xferlen_to_descs(ioat, len);
-	if (likely(num_descs) && ioat2_check_space_lock(ioat, num_descs) == 0)
-		idx = ioat->head;
-	else
-		return NULL;
-	i = 0;
-	do {
-		size_t xfer_size = min_t(size_t, len, 1 << ioat->xfercap_log);
-
-		desc = ioat2_get_ring_ent(ioat, idx + i);
-		fill = desc->fill;
-
-		fill->size = xfer_size;
-		fill->src_data = src_data;
-		fill->dst_addr = dest;
-		fill->ctl = 0;
-		fill->ctl_f.op = IOAT_OP_FILL;
-
-		len -= xfer_size;
-		dest += xfer_size;
-		dump_desc_dbg(ioat, desc);
-	} while (++i < num_descs);
-
-	desc->txd.flags = flags;
-	desc->len = total_len;
-	fill->ctl_f.int_en = !!(flags & DMA_PREP_INTERRUPT);
-	fill->ctl_f.fence = !!(flags & DMA_PREP_FENCE);
-	fill->ctl_f.compl_write = 1;
-	dump_desc_dbg(ioat, desc);
-
-	/* we leave the channel locked to ensure in order submission */
-	return &desc->txd;
-}
-
-static struct dma_async_tx_descriptor *
 __ioat3_prep_xor_lock(struct dma_chan *c, enum sum_check_flags *result,
 		      dma_addr_t dest, dma_addr_t *src, unsigned int src_cnt,
 		      size_t len, unsigned long flags)
@@ -1002,50 +957,6 @@ static int __devinit ioat_xor_val_self_t
 		goto free_resources;
 	}
 
-	/* skip memset if the capability is not present */
-	if (!dma_has_cap(DMA_MEMSET, dma_chan->device->cap_mask))
-		goto free_resources;
-
-	/* test memset */
-	dma_addr = dma_map_page(dev, dest, 0,
-			PAGE_SIZE, DMA_FROM_DEVICE);
-	tx = dma->device_prep_dma_memset(dma_chan, dma_addr, 0, PAGE_SIZE,
-					 DMA_PREP_INTERRUPT);
-	if (!tx) {
-		dev_err(dev, "Self-test memset prep failed\n");
-		err = -ENODEV;
-		goto free_resources;
-	}
-
-	async_tx_ack(tx);
-	init_completion(&cmp);
-	tx->callback = ioat3_dma_test_callback;
-	tx->callback_param = &cmp;
-	cookie = tx->tx_submit(tx);
-	if (cookie < 0) {
-		dev_err(dev, "Self-test memset setup failed\n");
-		err = -ENODEV;
-		goto free_resources;
-	}
-	dma->device_issue_pending(dma_chan);
-
-	tmo = wait_for_completion_timeout(&cmp, msecs_to_jiffies(3000));
-
-	if (dma->device_tx_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
-		dev_err(dev, "Self-test memset timed out\n");
-		err = -ENODEV;
-		goto free_resources;
-	}
-
-	for (i = 0; i < PAGE_SIZE/sizeof(u32); i++) {
-		u32 *ptr = page_address(dest);
-		if (ptr[i]) {
-			dev_err(dev, "Self-test memset failed compare\n");
-			err = -ENODEV;
-			goto free_resources;
-		}
-	}
-
 	/* test for non-zero parity sum */
 	xor_val_result = 0;
 	for (i = 0; i < IOAT_NUM_SRC_TEST + 1; i++)
@@ -1252,11 +1163,6 @@ int __devinit ioat3_dma_probe(struct ioa
 			dma->device_prep_dma_xor_val = ioat3_prep_pqxor_val;
 		}
 	}
-	if (is_raid_device && (cap & IOAT_CAP_FILL_BLOCK)) {
-		dma_cap_set(DMA_MEMSET, dma->cap_mask);
-		dma->device_prep_dma_memset = ioat3_prep_memset_lock;
-	}
-
 
 	if (is_raid_device) {
 		dma->device_tx_status = ioat3_tx_status;
Index: b/drivers/dma/iop-adma.c
===================================================================
--- a/drivers/dma/iop-adma.c	2012-11-07 15:08:05.404876562 +0100
+++ b/drivers/dma/iop-adma.c	2012-11-07 15:18:54.596876485 +0100
@@ -633,39 +633,6 @@ iop_adma_prep_dma_memcpy(struct dma_chan
 }
 
 static struct dma_async_tx_descriptor *
-iop_adma_prep_dma_memset(struct dma_chan *chan, dma_addr_t dma_dest,
-			 int value, size_t len, unsigned long flags)
-{
-	struct iop_adma_chan *iop_chan = to_iop_adma_chan(chan);
-	struct iop_adma_desc_slot *sw_desc, *grp_start;
-	int slot_cnt, slots_per_op;
-
-	if (unlikely(!len))
-		return NULL;
-	BUG_ON(len > IOP_ADMA_MAX_BYTE_COUNT);
-
-	dev_dbg(iop_chan->device->common.dev, "%s len: %u\n",
-		__func__, len);
-
-	spin_lock_bh(&iop_chan->lock);
-	slot_cnt = iop_chan_memset_slot_count(len, &slots_per_op);
-	sw_desc = iop_adma_alloc_slots(iop_chan, slot_cnt, slots_per_op);
-	if (sw_desc) {
-		grp_start = sw_desc->group_head;
-		iop_desc_init_memset(grp_start, flags);
-		iop_desc_set_byte_count(grp_start, iop_chan, len);
-		iop_desc_set_block_fill_val(grp_start, value);
-		iop_desc_set_dest_addr(grp_start, iop_chan, dma_dest);
-		sw_desc->unmap_src_cnt = 1;
-		sw_desc->unmap_len = len;
-		sw_desc->async_tx.flags = flags;
-	}
-	spin_unlock_bh(&iop_chan->lock);
-
-	return sw_desc ? &sw_desc->async_tx : NULL;
-}
-
-static struct dma_async_tx_descriptor *
 iop_adma_prep_dma_xor(struct dma_chan *chan, dma_addr_t dma_dest,
 		      dma_addr_t *dma_src, unsigned int src_cnt, size_t len,
 		      unsigned long flags)
@@ -1176,33 +1143,6 @@ iop_adma_xor_val_self_test(struct iop_ad
 		goto free_resources;
 	}
 
-	/* test memset */
-	dma_addr = dma_map_page(dma_chan->device->dev, dest, 0,
-			PAGE_SIZE, DMA_FROM_DEVICE);
-	tx = iop_adma_prep_dma_memset(dma_chan, dma_addr, 0, PAGE_SIZE,
-				      DMA_PREP_INTERRUPT | DMA_CTRL_ACK);
-
-	cookie = iop_adma_tx_submit(tx);
-	iop_adma_issue_pending(dma_chan);
-	msleep(8);
-
-	if (iop_adma_status(dma_chan, cookie, NULL) != DMA_SUCCESS) {
-		dev_printk(KERN_ERR, dma_chan->device->dev,
-			"Self-test memset timed out, disabling\n");
-		err = -ENODEV;
-		goto free_resources;
-	}
-
-	for (i = 0; i < PAGE_SIZE/sizeof(u32); i++) {
-		u32 *ptr = page_address(dest);
-		if (ptr[i]) {
-			dev_printk(KERN_ERR, dma_chan->device->dev,
-				"Self-test memset failed compare, disabling\n");
-			err = -ENODEV;
-			goto free_resources;
-		}
-	}
-
 	/* test for non-zero parity sum */
 	zero_sum_result = 0;
 	for (i = 0; i < IOP_ADMA_NUM_SRC_TEST + 1; i++)
@@ -1487,8 +1427,6 @@ static int __devinit iop_adma_probe(stru
 	/* set prep routines based on capability */
 	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask))
 		dma_dev->device_prep_dma_memcpy = iop_adma_prep_dma_memcpy;
-	if (dma_has_cap(DMA_MEMSET, dma_dev->cap_mask))
-		dma_dev->device_prep_dma_memset = iop_adma_prep_dma_memset;
 	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
 		dma_dev->max_xor = iop_adma_get_max_xor();
 		dma_dev->device_prep_dma_xor = iop_adma_prep_dma_xor;
@@ -1556,8 +1494,7 @@ static int __devinit iop_adma_probe(stru
 			goto err_free_iop_chan;
 	}
 
-	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask) ||
-	    dma_has_cap(DMA_MEMSET, dma_dev->cap_mask)) {
+	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
 		ret = iop_adma_xor_val_self_test(adev);
 		dev_dbg(&pdev->dev, "xor self test returned %d\n", ret);
 		if (ret)
@@ -1585,7 +1522,6 @@ static int __devinit iop_adma_probe(stru
 	  dma_has_cap(DMA_PQ_VAL, dma_dev->cap_mask) ? "pq_val " : "",
 	  dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
 	  dma_has_cap(DMA_XOR_VAL, dma_dev->cap_mask) ? "xor_val " : "",
-	  dma_has_cap(DMA_MEMSET, dma_dev->cap_mask)  ? "fill " : "",
 	  dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "cpy " : "",
 	  dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask) ? "intr " : "");
 
Index: b/drivers/dma/mv_xor.c
===================================================================
--- a/drivers/dma/mv_xor.c	2012-11-07 15:09:49.588876550 +0100
+++ b/drivers/dma/mv_xor.c	2012-11-07 15:20:42.088876472 +0100
@@ -183,8 +183,6 @@ static int mv_can_chain(struct mv_xor_de
 
 	if (chain_old_tail->type != desc->type)
 		return 0;
-	if (desc->type == DMA_MEMSET)
-		return 0;
 
 	return 1;
 }
@@ -202,9 +200,6 @@ static void mv_set_mode(struct mv_xor_ch
 	case DMA_MEMCPY:
 		op_mode = XOR_OPERATION_MODE_MEMCPY;
 		break;
-	case DMA_MEMSET:
-		op_mode = XOR_OPERATION_MODE_MEMSET;
-		break;
 	default:
 		dev_printk(KERN_ERR, chan->device->common.dev,
 			   "error: unsupported operation %d.\n",
@@ -271,18 +266,9 @@ static void mv_xor_start_new_chain(struc
 	if (sw_desc->type != mv_chan->current_type)
 		mv_set_mode(mv_chan, sw_desc->type);
 
-	if (sw_desc->type == DMA_MEMSET) {
-		/* for memset requests we need to program the engine, no
-		 * descriptors used.
-		 */
-		struct mv_xor_desc *hw_desc = sw_desc->hw_desc;
-		mv_chan_set_dest_pointer(mv_chan, hw_desc->phy_dest_addr);
-		mv_chan_set_block_size(mv_chan, sw_desc->unmap_len);
-		mv_chan_set_value(mv_chan, sw_desc->value);
-	} else {
-		/* set the hardware chain */
-		mv_chan_set_next_descriptor(mv_chan, sw_desc->async_tx.phys);
-	}
+	/* set the hardware chain */
+	mv_chan_set_next_descriptor(mv_chan, sw_desc->async_tx.phys);
+
 	mv_chan->pending += sw_desc->slot_cnt;
 	mv_xor_issue_pending(&mv_chan->common);
 }
@@ -688,43 +674,6 @@ mv_xor_prep_dma_memcpy(struct dma_chan *
 }
 
 static struct dma_async_tx_descriptor *
-mv_xor_prep_dma_memset(struct dma_chan *chan, dma_addr_t dest, int value,
-		       size_t len, unsigned long flags)
-{
-	struct mv_xor_chan *mv_chan = to_mv_xor_chan(chan);
-	struct mv_xor_desc_slot *sw_desc, *grp_start;
-	int slot_cnt;
-
-	dev_dbg(mv_chan->device->common.dev,
-		"%s dest: %x len: %u flags: %ld\n",
-		__func__, dest, len, flags);
-	if (unlikely(len < MV_XOR_MIN_BYTE_COUNT))
-		return NULL;
-
-	BUG_ON(len > MV_XOR_MAX_BYTE_COUNT);
-
-	spin_lock_bh(&mv_chan->lock);
-	slot_cnt = mv_chan_memset_slot_count(len);
-	sw_desc = mv_xor_alloc_slots(mv_chan, slot_cnt, 1);
-	if (sw_desc) {
-		sw_desc->type = DMA_MEMSET;
-		sw_desc->async_tx.flags = flags;
-		grp_start = sw_desc->group_head;
-		mv_desc_init(grp_start, flags);
-		mv_desc_set_byte_count(grp_start, len);
-		mv_desc_set_dest_addr(sw_desc->group_head, dest);
-		mv_desc_set_block_fill_val(grp_start, value);
-		sw_desc->unmap_src_cnt = 1;
-		sw_desc->unmap_len = len;
-	}
-	spin_unlock_bh(&mv_chan->lock);
-	dev_dbg(mv_chan->device->common.dev,
-		"%s sw_desc %p async_tx %p \n",
-		__func__, sw_desc, &sw_desc->async_tx);
-	return sw_desc ? &sw_desc->async_tx : NULL;
-}
-
-static struct dma_async_tx_descriptor *
 mv_xor_prep_dma_xor(struct dma_chan *chan, dma_addr_t dest, dma_addr_t *src,
 		    unsigned int src_cnt, size_t len, unsigned long flags)
 {
@@ -1148,8 +1097,6 @@ static int __devinit mv_xor_probe(struct
 	/* set prep routines based on capability */
 	if (dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask))
 		dma_dev->device_prep_dma_memcpy = mv_xor_prep_dma_memcpy;
-	if (dma_has_cap(DMA_MEMSET, dma_dev->cap_mask))
-		dma_dev->device_prep_dma_memset = mv_xor_prep_dma_memset;
 	if (dma_has_cap(DMA_XOR, dma_dev->cap_mask)) {
 		dma_dev->max_xor = 8;
 		dma_dev->device_prep_dma_xor = mv_xor_prep_dma_xor;
@@ -1215,7 +1162,6 @@ static int __devinit mv_xor_probe(struct
 	dev_printk(KERN_INFO, &pdev->dev, "Marvell XOR: "
 	  "( %s%s%s%s)\n",
 	  dma_has_cap(DMA_XOR, dma_dev->cap_mask) ? "xor " : "",
-	  dma_has_cap(DMA_MEMSET, dma_dev->cap_mask)  ? "fill " : "",
 	  dma_has_cap(DMA_MEMCPY, dma_dev->cap_mask) ? "cpy " : "",
 	  dma_has_cap(DMA_INTERRUPT, dma_dev->cap_mask) ? "intr " : "");
 
Index: b/drivers/dma/mv_xor.h
===================================================================
--- a/drivers/dma/mv_xor.h	2012-11-07 15:20:15.876876475 +0100
+++ b/drivers/dma/mv_xor.h	2012-11-07 15:20:23.604876474 +0100
@@ -29,7 +29,6 @@
 
 #define XOR_OPERATION_MODE_XOR		0
 #define XOR_OPERATION_MODE_MEMCPY	2
-#define XOR_OPERATION_MODE_MEMSET	4
 
 #define XOR_CURR_DESC(chan)	(chan->mmr_base + 0x210 + (chan->idx * 4))
 #define XOR_NEXT_DESC(chan)	(chan->mmr_base + 0x200 + (chan->idx * 4))
Index: b/drivers/dma/ppc4xx/adma.c
===================================================================
--- a/drivers/dma/ppc4xx/adma.c	2012-11-07 15:10:14.152876549 +0100
+++ b/drivers/dma/ppc4xx/adma.c	2012-11-07 15:21:12.164876469 +0100
@@ -2323,47 +2323,6 @@ static struct dma_async_tx_descriptor *p
 }
 
 /**
- * ppc440spe_adma_prep_dma_memset - prepare CDB for a MEMSET operation
- */
-static struct dma_async_tx_descriptor *ppc440spe_adma_prep_dma_memset(
-		struct dma_chan *chan, dma_addr_t dma_dest, int value,
-		size_t len, unsigned long flags)
-{
-	struct ppc440spe_adma_chan *ppc440spe_chan;
-	struct ppc440spe_adma_desc_slot *sw_desc, *group_start;
-	int slot_cnt, slots_per_op;
-
-	ppc440spe_chan = to_ppc440spe_adma_chan(chan);
-
-	if (unlikely(!len))
-		return NULL;
-
-	BUG_ON(len > PPC440SPE_ADMA_DMA_MAX_BYTE_COUNT);
-
-	spin_lock_bh(&ppc440spe_chan->lock);
-
-	dev_dbg(ppc440spe_chan->device->common.dev,
-		"ppc440spe adma%d: %s cal: %u len: %u int_en %d\n",
-		ppc440spe_chan->device->id, __func__, value, len,
-		flags & DMA_PREP_INTERRUPT ? 1 : 0);
-
-	slot_cnt = slots_per_op = 1;
-	sw_desc = ppc440spe_adma_alloc_slots(ppc440spe_chan, slot_cnt,
-		slots_per_op);
-	if (sw_desc) {
-		group_start = sw_desc->group_head;
-		ppc440spe_desc_init_memset(group_start, value, flags);
-		ppc440spe_adma_set_dest(group_start, dma_dest, 0);
-		ppc440spe_desc_set_byte_count(group_start, ppc440spe_chan, len);
-		sw_desc->unmap_len = len;
-		sw_desc->async_tx.flags = flags;
-	}
-	spin_unlock_bh(&ppc440spe_chan->lock);
-
-	return sw_desc ? &sw_desc->async_tx : NULL;
-}
-
-/**
  * ppc440spe_adma_prep_dma_xor - prepare CDB for a XOR operation
  */
 static struct dma_async_tx_descriptor *ppc440spe_adma_prep_dma_xor(
@@ -4125,7 +4084,6 @@ static void ppc440spe_adma_init_capabili
 	case PPC440SPE_DMA1_ID:
 		dma_cap_set(DMA_MEMCPY, adev->common.cap_mask);
 		dma_cap_set(DMA_INTERRUPT, adev->common.cap_mask);
-		dma_cap_set(DMA_MEMSET, adev->common.cap_mask);
 		dma_cap_set(DMA_PQ, adev->common.cap_mask);
 		dma_cap_set(DMA_PQ_VAL, adev->common.cap_mask);
 		dma_cap_set(DMA_XOR_VAL, adev->common.cap_mask);
@@ -4151,10 +4109,6 @@ static void ppc440spe_adma_init_capabili
 		adev->common.device_prep_dma_memcpy =
 			ppc440spe_adma_prep_dma_memcpy;
 	}
-	if (dma_has_cap(DMA_MEMSET, adev->common.cap_mask)) {
-		adev->common.device_prep_dma_memset =
-			ppc440spe_adma_prep_dma_memset;
-	}
 	if (dma_has_cap(DMA_XOR, adev->common.cap_mask)) {
 		adev->common.max_xor = XOR_MAX_OPS;
 		adev->common.device_prep_dma_xor =
@@ -4217,7 +4171,6 @@ static void ppc440spe_adma_init_capabili
 	  dma_has_cap(DMA_XOR, adev->common.cap_mask) ? "xor " : "",
 	  dma_has_cap(DMA_XOR_VAL, adev->common.cap_mask) ? "xor_val " : "",
 	  dma_has_cap(DMA_MEMCPY, adev->common.cap_mask) ? "memcpy " : "",
-	  dma_has_cap(DMA_MEMSET, adev->common.cap_mask)  ? "memset " : "",
 	  dma_has_cap(DMA_INTERRUPT, adev->common.cap_mask) ? "intr " : "");
 }
 
Index: b/include/linux/async_tx.h
===================================================================
--- a/include/linux/async_tx.h	2012-11-07 15:00:42.296876616 +0100
+++ b/include/linux/async_tx.h	2012-11-07 15:04:33.728876590 +0100
@@ -182,10 +182,6 @@ async_memcpy(struct page *dest, struct p
 	     unsigned int src_offset, size_t len,
 	     struct async_submit_ctl *submit);
 
-struct dma_async_tx_descriptor *
-async_memset(struct page *dest, int val, unsigned int offset,
-	     size_t len, struct async_submit_ctl *submit);
-
 struct dma_async_tx_descriptor *async_trigger_callback(struct async_submit_ctl *submit);
 
 struct dma_async_tx_descriptor *
Index: b/include/linux/dmaengine.h
===================================================================
--- a/include/linux/dmaengine.h	2012-11-07 15:10:37.712876547 +0100
+++ b/include/linux/dmaengine.h	2012-11-07 15:21:26.292876467 +0100
@@ -66,7 +66,6 @@ enum dma_transaction_type {
 	DMA_PQ,
 	DMA_XOR_VAL,
 	DMA_PQ_VAL,
-	DMA_MEMSET,
 	DMA_INTERRUPT,
 	DMA_SG,
 	DMA_PRIVATE,
@@ -520,7 +519,6 @@ struct dma_tx_state {
  * @device_prep_dma_xor_val: prepares a xor validation operation
  * @device_prep_dma_pq: prepares a pq operation
  * @device_prep_dma_pq_val: prepares a pqzero_sum operation
- * @device_prep_dma_memset: prepares a memset operation
  * @device_prep_dma_interrupt: prepares an end of chain interrupt operation
  * @device_prep_slave_sg: prepares a slave dma operation
  * @device_prep_dma_cyclic: prepare a cyclic dma operation suitable for audio.
@@ -573,9 +571,6 @@ struct dma_device {
 		struct dma_chan *chan, dma_addr_t *pq, dma_addr_t *src,
 		unsigned int src_cnt, const unsigned char *scf, size_t len,
 		enum sum_check_flags *pqres, unsigned long flags);
-	struct dma_async_tx_descriptor *(*device_prep_dma_memset)(
-		struct dma_chan *chan, dma_addr_t dest, int value, size_t len,
-		unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_interrupt)(
 		struct dma_chan *chan, unsigned long flags);
 	struct dma_async_tx_descriptor *(*device_prep_dma_sg)(
