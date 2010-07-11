Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab0GKNvm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 09:51:42 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:52928 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752227Ab0GKNvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 09:51:40 -0400
Date: Sun, 11 Jul 2010 15:32:42 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/via: fixed coding style issues, simplified return
Message-ID: <20100711153242.15f2c5a0@absol.kitzblitz>
Organization: -
X-Face: "fF&[w2"Nws:JNH4'g|:gVhgGKLhj|X}}&w&V?]0=,7n`jy8D6e[Jh=7+ca|4~t5e[ItpL5
 N'y~Mvi-vJm`"1T5fi1^b!&EG]6nW~C!FN},=$G?^U2t~n[3;u\"5-|~H{-5]IQ2
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed brace, macro and spacing coding style issues.
Simplified
 -if (ret) return ret;
 -return 0;
 +return ret;

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/gpu/drm/via/via_dma.c      |  120 ++++++++++++++++--------------------
 drivers/gpu/drm/via/via_dmablit.c  |   71 ++++++++++------------
 drivers/gpu/drm/via/via_dmablit.h  |    8 +-
 drivers/gpu/drm/via/via_drv.h      |   22 +++---
 drivers/gpu/drm/via/via_irq.c      |   13 ++--
 drivers/gpu/drm/via/via_map.c      |    4 +-
 drivers/gpu/drm/via/via_mm.c       |    7 +-
 drivers/gpu/drm/via/via_verifier.c |   47 ++++++--------
 drivers/gpu/drm/via/via_verifier.h |    4 +-
 drivers/gpu/drm/via/via_video.c    |    6 +-
 10 files changed, 136 insertions(+), 166 deletions(-)

diff --git a/drivers/gpu/drm/via/via_dma.c b/drivers/gpu/drm/via/via_dma.c
index bfb92d2..68dda74 100644
--- a/drivers/gpu/drm/via/via_dma.c
+++ b/drivers/gpu/drm/via/via_dma.c
@@ -58,28 +58,29 @@
 	*((uint32_t *)(vb)) = ((nReg) >> 2) | HALCYON_HEADER1;	\
 	*((uint32_t *)(vb) + 1) = (nData);			\
 	vb = ((uint32_t *)vb) + 2;				\
-	dev_priv->dma_low +=8;					\
+	dev_priv->dma_low += 8;					\
 }
 
 #define via_flush_write_combine() DRM_MEMORYBARRIER()
 
-#define VIA_OUT_RING_QW(w1,w2)			\
+#define VIA_OUT_RING_QW(w1, w2)	do {		\
 	*vb++ = (w1);				\
 	*vb++ = (w2);				\
-	dev_priv->dma_low += 8;
+	dev_priv->dma_low += 8;			\
+} while (0)
 
-static void via_cmdbuf_start(drm_via_private_t * dev_priv);
-static void via_cmdbuf_pause(drm_via_private_t * dev_priv);
-static void via_cmdbuf_reset(drm_via_private_t * dev_priv);
-static void via_cmdbuf_rewind(drm_via_private_t * dev_priv);
-static int via_wait_idle(drm_via_private_t * dev_priv);
-static void via_pad_cache(drm_via_private_t * dev_priv, int qwords);
+static void via_cmdbuf_start(drm_via_private_t *dev_priv);
+static void via_cmdbuf_pause(drm_via_private_t *dev_priv);
+static void via_cmdbuf_reset(drm_via_private_t *dev_priv);
+static void via_cmdbuf_rewind(drm_via_private_t *dev_priv);
+static int via_wait_idle(drm_via_private_t *dev_priv);
+static void via_pad_cache(drm_via_private_t *dev_priv, int qwords);
 
 /*
  * Free space in command buffer.
  */
 
-static uint32_t via_cmdbuf_space(drm_via_private_t * dev_priv)
+static uint32_t via_cmdbuf_space(drm_via_private_t *dev_priv)
 {
 	uint32_t agp_base = dev_priv->dma_offset + (uint32_t) dev_priv->agpAddr;
 	uint32_t hw_addr = *(dev_priv->hw_addr_ptr) - agp_base;
@@ -93,7 +94,7 @@ static uint32_t via_cmdbuf_space(drm_via_private_t * dev_priv)
  * How much does the command regulator lag behind?
  */
 
-static uint32_t via_cmdbuf_lag(drm_via_private_t * dev_priv)
+static uint32_t via_cmdbuf_lag(drm_via_private_t *dev_priv)
 {
 	uint32_t agp_base = dev_priv->dma_offset + (uint32_t) dev_priv->agpAddr;
 	uint32_t hw_addr = *(dev_priv->hw_addr_ptr) - agp_base;
@@ -108,7 +109,7 @@ static uint32_t via_cmdbuf_lag(drm_via_private_t * dev_priv)
  */
 
 static inline int
-via_cmdbuf_wait(drm_via_private_t * dev_priv, unsigned int size)
+via_cmdbuf_wait(drm_via_private_t *dev_priv, unsigned int size)
 {
 	uint32_t agp_base = dev_priv->dma_offset + (uint32_t) dev_priv->agpAddr;
 	uint32_t cur_addr, hw_addr, next_addr;
@@ -146,14 +147,13 @@ static inline uint32_t *via_check_dma(drm_via_private_t * dev_priv,
 	    dev_priv->dma_high) {
 		via_cmdbuf_rewind(dev_priv);
 	}
-	if (via_cmdbuf_wait(dev_priv, size) != 0) {
+	if (via_cmdbuf_wait(dev_priv, size) != 0)
 		return NULL;
-	}
 
 	return (uint32_t *) (dev_priv->dma_ptr + dev_priv->dma_low);
 }
 
-int via_dma_cleanup(struct drm_device * dev)
+int via_dma_cleanup(struct drm_device *dev)
 {
 	if (dev->dev_private) {
 		drm_via_private_t *dev_priv =
@@ -171,9 +171,9 @@ int via_dma_cleanup(struct drm_device * dev)
 	return 0;
 }
 
-static int via_initialize(struct drm_device * dev,
-			  drm_via_private_t * dev_priv,
-			  drm_via_dma_init_t * init)
+static int via_initialize(struct drm_device *dev,
+			  drm_via_private_t *dev_priv,
+			  drm_via_dma_init_t *init)
 {
 	if (!dev_priv || !dev_priv->mmio) {
 		DRM_ERROR("via_dma_init called before via_map_init\n");
@@ -258,7 +258,7 @@ static int via_dma_init(struct drm_device *dev, void *data, struct drm_file *fil
 	return retcode;
 }
 
-static int via_dispatch_cmdbuffer(struct drm_device * dev, drm_via_cmdbuffer_t * cmd)
+static int via_dispatch_cmdbuffer(struct drm_device *dev, drm_via_cmdbuffer_t *cmd)
 {
 	drm_via_private_t *dev_priv;
 	uint32_t *vb;
@@ -271,9 +271,8 @@ static int via_dispatch_cmdbuffer(struct drm_device * dev, drm_via_cmdbuffer_t *
 		return -EFAULT;
 	}
 
-	if (cmd->size > VIA_PCI_BUF_SIZE) {
+	if (cmd->size > VIA_PCI_BUF_SIZE)
 		return -ENOMEM;
-	}
 
 	if (DRM_COPY_FROM_USER(dev_priv->pci_buf, cmd->buf, cmd->size))
 		return -EFAULT;
@@ -291,9 +290,8 @@ static int via_dispatch_cmdbuffer(struct drm_device * dev, drm_via_cmdbuffer_t *
 	}
 
 	vb = via_check_dma(dev_priv, (cmd->size < 0x100) ? 0x102 : cmd->size);
-	if (vb == NULL) {
+	if (vb == NULL)
 		return -EAGAIN;
-	}
 
 	memcpy(vb, dev_priv->pci_buf, cmd->size);
 
@@ -311,13 +309,12 @@ static int via_dispatch_cmdbuffer(struct drm_device * dev, drm_via_cmdbuffer_t *
 	return 0;
 }
 
-int via_driver_dma_quiescent(struct drm_device * dev)
+int via_driver_dma_quiescent(struct drm_device *dev)
 {
 	drm_via_private_t *dev_priv = dev->dev_private;
 
-	if (!via_wait_idle(dev_priv)) {
+	if (!via_wait_idle(dev_priv))
 		return -EBUSY;
-	}
 	return 0;
 }
 
@@ -339,22 +336,17 @@ static int via_cmdbuffer(struct drm_device *dev, void *data, struct drm_file *fi
 	DRM_DEBUG("buf %p size %lu\n", cmdbuf->buf, cmdbuf->size);
 
 	ret = via_dispatch_cmdbuffer(dev, cmdbuf);
-	if (ret) {
-		return ret;
-	}
-
-	return 0;
+	return ret;
 }
 
-static int via_dispatch_pci_cmdbuffer(struct drm_device * dev,
-				      drm_via_cmdbuffer_t * cmd)
+static int via_dispatch_pci_cmdbuffer(struct drm_device *dev,
+				      drm_via_cmdbuffer_t *cmd)
 {
 	drm_via_private_t *dev_priv = dev->dev_private;
 	int ret;
 
-	if (cmd->size > VIA_PCI_BUF_SIZE) {
+	if (cmd->size > VIA_PCI_BUF_SIZE)
 		return -ENOMEM;
-	}
 	if (DRM_COPY_FROM_USER(dev_priv->pci_buf, cmd->buf, cmd->size))
 		return -EFAULT;
 
@@ -380,19 +372,14 @@ static int via_pci_cmdbuffer(struct drm_device *dev, void *data, struct drm_file
 	DRM_DEBUG("buf %p size %lu\n", cmdbuf->buf, cmdbuf->size);
 
 	ret = via_dispatch_pci_cmdbuffer(dev, cmdbuf);
-	if (ret) {
-		return ret;
-	}
-
-	return 0;
+	return ret;
 }
 
-static inline uint32_t *via_align_buffer(drm_via_private_t * dev_priv,
+static inline uint32_t *via_align_buffer(drm_via_private_t *dev_priv,
 					 uint32_t * vb, int qw_count)
 {
-	for (; qw_count > 0; --qw_count) {
+	for (; qw_count > 0; --qw_count)
 		VIA_OUT_RING_QW(HC_DUMMY, HC_DUMMY);
-	}
 	return vb;
 }
 
@@ -401,7 +388,7 @@ static inline uint32_t *via_align_buffer(drm_via_private_t * dev_priv,
  *
  * Returns virtual pointer to ring buffer.
  */
-static inline uint32_t *via_get_dma(drm_via_private_t * dev_priv)
+static inline uint32_t *via_get_dma(drm_via_private_t *dev_priv)
 {
 	return (uint32_t *) (dev_priv->dma_ptr + dev_priv->dma_low);
 }
@@ -411,18 +398,18 @@ static inline uint32_t *via_get_dma(drm_via_private_t * dev_priv)
  * modifying the pause address stored in the buffer itself. If
  * the regulator has already paused, restart it.
  */
-static int via_hook_segment(drm_via_private_t * dev_priv,
+static int via_hook_segment(drm_via_private_t *dev_priv,
 			    uint32_t pause_addr_hi, uint32_t pause_addr_lo,
 			    int no_pci_fire)
 {
 	int paused, count;
 	volatile uint32_t *paused_at = dev_priv->last_pause_ptr;
-	uint32_t reader,ptr;
+	uint32_t reader, ptr;
 	uint32_t diff;
 
 	paused = 0;
 	via_flush_write_combine();
-	(void) *(volatile uint32_t *)(via_get_dma(dev_priv) -1);
+	(void) *(volatile uint32_t *)(via_get_dma(dev_priv) - 1);
 
 	*paused_at = pause_addr_lo;
 	via_flush_write_combine();
@@ -435,7 +422,7 @@ static int via_hook_segment(drm_via_private_t * dev_priv,
 	dev_priv->last_pause_ptr = via_get_dma(dev_priv) - 1;
 
 	/*
-	 * If there is a possibility that the command reader will 
+	 * If there is a possibility that the command reader will
 	 * miss the new pause address and pause on the old one,
 	 * In that case we need to program the new start address
 	 * using PCI.
@@ -443,9 +430,9 @@ static int via_hook_segment(drm_via_private_t * dev_priv,
 
 	diff = (uint32_t) (ptr - reader) - dev_priv->dma_diff;
 	count = 10000000;
-	while(diff == 0 && count--) {
+	while (diff == 0 && count--) {
 		paused = (VIA_READ(0x41c) & 0x80000000);
-		if (paused) 
+		if (paused)
 			break;
 		reader = *(dev_priv->hw_addr_ptr);
 		diff = (uint32_t) (ptr - reader) - dev_priv->dma_diff;
@@ -477,7 +464,7 @@ static int via_hook_segment(drm_via_private_t * dev_priv,
 	return paused;
 }
 
-static int via_wait_idle(drm_via_private_t * dev_priv)
+static int via_wait_idle(drm_via_private_t *dev_priv)
 {
 	int count = 10000000;
 
@@ -491,9 +478,9 @@ static int via_wait_idle(drm_via_private_t * dev_priv)
 	return count;
 }
 
-static uint32_t *via_align_cmd(drm_via_private_t * dev_priv, uint32_t cmd_type,
-			       uint32_t addr, uint32_t * cmd_addr_hi,
-			       uint32_t * cmd_addr_lo, int skip_wait)
+static uint32_t *via_align_cmd(drm_via_private_t *dev_priv, uint32_t cmd_type,
+			       uint32_t addr, uint32_t *cmd_addr_hi,
+			       uint32_t *cmd_addr_lo, int skip_wait)
 {
 	uint32_t agp_base;
 	uint32_t cmd_addr, addr_lo, addr_hi;
@@ -521,7 +508,7 @@ static uint32_t *via_align_cmd(drm_via_private_t * dev_priv, uint32_t cmd_type,
 	return vb;
 }
 
-static void via_cmdbuf_start(drm_via_private_t * dev_priv)
+static void via_cmdbuf_start(drm_via_private_t *dev_priv)
 {
 	uint32_t pause_addr_lo, pause_addr_hi;
 	uint32_t start_addr, start_addr_lo;
@@ -580,7 +567,7 @@ static void via_cmdbuf_start(drm_via_private_t * dev_priv)
 	dev_priv->dma_diff = ptr - reader;
 }
 
-static void via_pad_cache(drm_via_private_t * dev_priv, int qwords)
+static void via_pad_cache(drm_via_private_t *dev_priv, int qwords)
 {
 	uint32_t *vb;
 
@@ -590,7 +577,7 @@ static void via_pad_cache(drm_via_private_t * dev_priv, int qwords)
 	via_align_buffer(dev_priv, vb, qwords);
 }
 
-static inline void via_dummy_bitblt(drm_via_private_t * dev_priv)
+static inline void via_dummy_bitblt(drm_via_private_t *dev_priv)
 {
 	uint32_t *vb = via_get_dma(dev_priv);
 	SetReg2DAGP(0x0C, (0 | (0 << 16)));
@@ -598,7 +585,7 @@ static inline void via_dummy_bitblt(drm_via_private_t * dev_priv)
 	SetReg2DAGP(0x0, 0x1 | 0x2000 | 0xAA000000);
 }
 
-static void via_cmdbuf_jump(drm_via_private_t * dev_priv)
+static void via_cmdbuf_jump(drm_via_private_t *dev_priv)
 {
 	uint32_t agp_base;
 	uint32_t pause_addr_lo, pause_addr_hi;
@@ -617,9 +604,8 @@ static void via_cmdbuf_jump(drm_via_private_t * dev_priv)
 	 */
 
 	dev_priv->dma_low = 0;
-	if (via_cmdbuf_wait(dev_priv, CMDBUF_ALIGNMENT_SIZE) != 0) {
+	if (via_cmdbuf_wait(dev_priv, CMDBUF_ALIGNMENT_SIZE) != 0)
 		DRM_ERROR("via_cmdbuf_jump failed\n");
-	}
 
 	via_dummy_bitblt(dev_priv);
 	via_dummy_bitblt(dev_priv);
@@ -657,12 +643,12 @@ static void via_cmdbuf_jump(drm_via_private_t * dev_priv)
 }
 
 
-static void via_cmdbuf_rewind(drm_via_private_t * dev_priv)
+static void via_cmdbuf_rewind(drm_via_private_t *dev_priv)
 {
 	via_cmdbuf_jump(dev_priv);
 }
 
-static void via_cmdbuf_flush(drm_via_private_t * dev_priv, uint32_t cmd_type)
+static void via_cmdbuf_flush(drm_via_private_t *dev_priv, uint32_t cmd_type)
 {
 	uint32_t pause_addr_lo, pause_addr_hi;
 
@@ -670,12 +656,12 @@ static void via_cmdbuf_flush(drm_via_private_t * dev_priv, uint32_t cmd_type)
 	via_hook_segment(dev_priv, pause_addr_hi, pause_addr_lo, 0);
 }
 
-static void via_cmdbuf_pause(drm_via_private_t * dev_priv)
+static void via_cmdbuf_pause(drm_via_private_t *dev_priv)
 {
 	via_cmdbuf_flush(dev_priv, HC_HAGPBpID_PAUSE);
 }
 
-static void via_cmdbuf_reset(drm_via_private_t * dev_priv)
+static void via_cmdbuf_reset(drm_via_private_t *dev_priv)
 {
 	via_cmdbuf_flush(dev_priv, HC_HAGPBpID_STOP);
 	via_wait_idle(dev_priv);
@@ -708,9 +694,8 @@ static int via_cmdbuf_size(struct drm_device *dev, void *data, struct drm_file *
 	case VIA_CMDBUF_SPACE:
 		while (((tmp_size = via_cmdbuf_space(dev_priv)) < d_siz->size)
 		       && --count) {
-			if (!d_siz->wait) {
+			if (!d_siz->wait)
 				break;
-			}
 		}
 		if (!count) {
 			DRM_ERROR("VIA_CMDBUF_SPACE timed out.\n");
@@ -720,9 +705,8 @@ static int via_cmdbuf_size(struct drm_device *dev, void *data, struct drm_file *
 	case VIA_CMDBUF_LAG:
 		while (((tmp_size = via_cmdbuf_lag(dev_priv)) > d_siz->size)
 		       && --count) {
-			if (!d_siz->wait) {
+			if (!d_siz->wait)
 				break;
-			}
 		}
 		if (!count) {
 			DRM_ERROR("VIA_CMDBUF_LAG timed out.\n");
diff --git a/drivers/gpu/drm/via/via_dmablit.c b/drivers/gpu/drm/via/via_dmablit.c
index 4c54f04..9b5b4d9 100644
--- a/drivers/gpu/drm/via/via_dmablit.c
+++ b/drivers/gpu/drm/via/via_dmablit.c
@@ -70,7 +70,7 @@ via_unmap_blit_from_device(struct pci_dev *pdev, drm_via_sg_info_t *vsg)
 		descriptor_this_page;
 	dma_addr_t next = vsg->chain_start;
 
-	while(num_desc--) {
+	while (num_desc--) {
 		if (descriptor_this_page-- == 0) {
 			cur_descriptor_page--;
 			descriptor_this_page = vsg->descriptors_per_page - 1;
@@ -174,19 +174,19 @@ via_free_sg_info(struct pci_dev *pdev, drm_via_sg_info_t *vsg)
 	struct page *page;
 	int i;
 
-	switch(vsg->state) {
+	switch (vsg->state) {
 	case dr_via_device_mapped:
 		via_unmap_blit_from_device(pdev, vsg);
 	case dr_via_desc_pages_alloc:
-		for (i=0; i<vsg->num_desc_pages; ++i) {
+		for (i = 0; i < vsg->num_desc_pages; ++i) {
 			if (vsg->desc_pages[i] != NULL)
-			  free_page((unsigned long)vsg->desc_pages[i]);
+				free_page((unsigned long)vsg->desc_pages[i]);
 		}
 		kfree(vsg->desc_pages);
 	case dr_via_pages_locked:
-		for (i=0; i<vsg->num_pages; ++i) {
-			if ( NULL != (page = vsg->pages[i])) {
-				if (! PageReserved(page) && (DMA_FROM_DEVICE == vsg->direction))
+		for (i = 0; i < vsg->num_pages; ++i) {
+			if (NULL != (page = vsg->pages[i])) {
+				if (!PageReserved(page) && (DMA_FROM_DEVICE == vsg->direction))
 					SetPageDirty(page);
 				page_cache_release(page);
 			}
@@ -232,7 +232,7 @@ via_lock_all_dma_pages(drm_via_sg_info_t *vsg,  drm_via_dmablit_t *xfer)
 {
 	int ret;
 	unsigned long first_pfn = VIA_PFN(xfer->mem_addr);
-	vsg->num_pages = VIA_PFN(xfer->mem_addr + (xfer->num_lines * xfer->mem_stride -1)) -
+	vsg->num_pages = VIA_PFN(xfer->mem_addr + (xfer->num_lines * xfer->mem_stride - 1)) -
 		first_pfn + 1;
 
 	if (NULL == (vsg->pages = vmalloc(sizeof(struct page *) * vsg->num_pages)))
@@ -268,7 +268,7 @@ via_alloc_desc_pages(drm_via_sg_info_t *vsg)
 {
 	int i;
 
-	vsg->descriptors_per_page = PAGE_SIZE / sizeof( drm_via_descriptor_t);
+	vsg->descriptors_per_page = PAGE_SIZE / sizeof(drm_via_descriptor_t);
 	vsg->num_desc_pages = (vsg->num_desc + vsg->descriptors_per_page - 1) /
 		vsg->descriptors_per_page;
 
@@ -276,7 +276,7 @@ via_alloc_desc_pages(drm_via_sg_info_t *vsg)
 		return -ENOMEM;
 
 	vsg->state = dr_via_desc_pages_alloc;
-	for (i=0; i<vsg->num_desc_pages; ++i) {
+	for (i = 0; i < vsg->num_desc_pages; ++i) {
 		if (NULL == (vsg->desc_pages[i] =
 			     (drm_via_descriptor_t *) __get_free_page(GFP_KERNEL)))
 			return -ENOMEM;
@@ -318,21 +318,20 @@ via_dmablit_handler(struct drm_device *dev, int engine, int from_irq)
 	drm_via_blitq_t *blitq = dev_priv->blit_queues + engine;
 	int cur;
 	int done_transfer;
-	unsigned long irqsave=0;
+	unsigned long irqsave = 0;
 	uint32_t status = 0;
 
 	DRM_DEBUG("DMA blit handler called. engine = %d, from_irq = %d, blitq = 0x%lx\n",
 		  engine, from_irq, (unsigned long) blitq);
 
-	if (from_irq) {
+	if (from_irq)
 		spin_lock(&blitq->blit_lock);
-	} else {
+	else
 		spin_lock_irqsave(&blitq->blit_lock, irqsave);
-	}
 
 	done_transfer = blitq->is_active &&
-	  (( status = VIA_READ(VIA_PCI_DMA_CSR0 + engine*0x04)) & VIA_DMA_CSR_TD);
-	done_transfer = done_transfer || ( blitq->aborting && !(status & VIA_DMA_CSR_DE));
+	  ((status = VIA_READ(VIA_PCI_DMA_CSR0 + engine*0x04)) & VIA_DMA_CSR_TD);
+	done_transfer = done_transfer || (blitq->aborting && !(status & VIA_DMA_CSR_DE));
 
 	cur = blitq->cur;
 	if (done_transfer) {
@@ -377,18 +376,16 @@ via_dmablit_handler(struct drm_device *dev, int engine, int from_irq)
 			if (!timer_pending(&blitq->poll_timer))
 				mod_timer(&blitq->poll_timer, jiffies + 1);
 		} else {
-			if (timer_pending(&blitq->poll_timer)) {
+			if (timer_pending(&blitq->poll_timer))
 				del_timer(&blitq->poll_timer);
-			}
 			via_dmablit_engine_off(dev, engine);
 		}
 	}
 
-	if (from_irq) {
+	if (from_irq)
 		spin_unlock(&blitq->blit_lock);
-	} else {
+	else
 		spin_unlock_irqrestore(&blitq->blit_lock, irqsave);
-	}
 }
 
 
@@ -414,10 +411,9 @@ via_dmablit_active(drm_via_blitq_t *blitq, int engine, uint32_t handle, wait_que
 		((blitq->cur_blit_handle - handle) <= (1 << 23));
 
 	if (queue && active) {
-		slot = handle - blitq->done_blit_handle + blitq->cur -1;
-		if (slot >= VIA_NUM_BLIT_SLOTS) {
+		slot = handle - blitq->done_blit_handle + blitq->cur - 1;
+		if (slot >= VIA_NUM_BLIT_SLOTS)
 			slot -= VIA_NUM_BLIT_SLOTS;
-		}
 		*queue = blitq->blit_queue + slot;
 	}
 
@@ -506,12 +502,12 @@ via_dmablit_workqueue(struct work_struct *work)
 	int cur_released;
 
 
-	DRM_DEBUG("Workqueue task called for blit engine %ld\n",(unsigned long)
+	DRM_DEBUG("Workqueue task called for blit engine %ld\n", (unsigned long)
 		  (blitq - ((drm_via_private_t *)dev->dev_private)->blit_queues));
 
 	spin_lock_irqsave(&blitq->blit_lock, irqsave);
 
-	while(blitq->serviced != blitq->cur) {
+	while (blitq->serviced != blitq->cur) {
 
 		cur_released = blitq->serviced++;
 
@@ -545,13 +541,13 @@ via_dmablit_workqueue(struct work_struct *work)
 void
 via_init_dmablit(struct drm_device *dev)
 {
-	int i,j;
+	int i, j;
 	drm_via_private_t *dev_priv = (drm_via_private_t *)dev->dev_private;
 	drm_via_blitq_t *blitq;
 
 	pci_set_master(dev->pdev);
 
-	for (i=0; i< VIA_NUM_BLIT_ENGINES; ++i) {
+	for (i = 0; i < VIA_NUM_BLIT_ENGINES; ++i) {
 		blitq = dev_priv->blit_queues + i;
 		blitq->dev = dev;
 		blitq->cur_blit_handle = 0;
@@ -564,9 +560,8 @@ via_init_dmablit(struct drm_device *dev)
 		blitq->is_active = 0;
 		blitq->aborting = 0;
 		spin_lock_init(&blitq->blit_lock);
-		for (j=0; j<VIA_NUM_BLIT_SLOTS; ++j) {
+		for (j = 0; j < VIA_NUM_BLIT_SLOTS; ++j)
 			DRM_INIT_WAITQUEUE(blitq->blit_queue + j);
-		}
 		DRM_INIT_WAITQUEUE(&blitq->busy_queue);
 		INIT_WORK(&blitq->wq, via_dmablit_workqueue);
 		setup_timer(&blitq->poll_timer, via_dmablit_timer,
@@ -685,18 +680,17 @@ via_build_sg_info(struct drm_device *dev, drm_via_sg_info_t *vsg, drm_via_dmabli
 static int
 via_dmablit_grab_slot(drm_via_blitq_t *blitq, int engine)
 {
-	int ret=0;
+	int ret = 0;
 	unsigned long irqsave;
 
 	DRM_DEBUG("Num free is %d\n", blitq->num_free);
 	spin_lock_irqsave(&blitq->blit_lock, irqsave);
-	while(blitq->num_free == 0) {
+	while (blitq->num_free == 0) {
 		spin_unlock_irqrestore(&blitq->blit_lock, irqsave);
 
 		DRM_WAIT_ON(ret, blitq->busy_queue, DRM_HZ, blitq->num_free > 0);
-		if (ret) {
+		if (ret)
 			return (-EINTR == ret) ? -EAGAIN : ret;
-		}
 
 		spin_lock_irqsave(&blitq->blit_lock, irqsave);
 	}
@@ -719,7 +713,7 @@ via_dmablit_release_slot(drm_via_blitq_t *blitq)
 	spin_lock_irqsave(&blitq->blit_lock, irqsave);
 	blitq->num_free++;
 	spin_unlock_irqrestore(&blitq->blit_lock, irqsave);
-	DRM_WAKEUP( &blitq->busy_queue );
+	DRM_WAKEUP(&blitq->busy_queue);
 }
 
 /*
@@ -744,9 +738,8 @@ via_dmablit(struct drm_device *dev, drm_via_dmablit_t *xfer)
 
 	engine = (xfer->to_fb) ? 0 : 1;
 	blitq = dev_priv->blit_queues + engine;
-	if (0 != (ret = via_dmablit_grab_slot(blitq, engine))) {
+	if (0 != (ret = via_dmablit_grab_slot(blitq, engine)))
 		return ret;
-	}
 	if (NULL == (vsg = kmalloc(sizeof(*vsg), GFP_KERNEL))) {
 		via_dmablit_release_slot(blitq);
 		return -ENOMEM;
@@ -780,7 +773,7 @@ via_dmablit(struct drm_device *dev, drm_via_dmablit_t *xfer)
  */
 
 int
-via_dma_blit_sync( struct drm_device *dev, void *data, struct drm_file *file_priv )
+via_dma_blit_sync(struct drm_device *dev, void *data, struct drm_file *file_priv)
 {
 	drm_via_blitsync_t *sync = data;
 	int err;
@@ -804,7 +797,7 @@ via_dma_blit_sync( struct drm_device *dev, void *data, struct drm_file *file_pri
  */
 
 int
-via_dma_blit( struct drm_device *dev, void *data, struct drm_file *file_priv )
+via_dma_blit(struct drm_device *dev, void *data, struct drm_file *file_priv)
 {
 	drm_via_dmablit_t *xfer = data;
 	int err;
diff --git a/drivers/gpu/drm/via/via_dmablit.h b/drivers/gpu/drm/via/via_dmablit.h
index 7408a54..9b662a3 100644
--- a/drivers/gpu/drm/via/via_dmablit.h
+++ b/drivers/gpu/drm/via/via_dmablit.h
@@ -45,12 +45,12 @@ typedef struct _drm_via_sg_info {
 	int num_desc;
 	enum dma_data_direction direction;
 	unsigned char *bounce_buffer;
-        dma_addr_t chain_start;
+	dma_addr_t chain_start;
 	uint32_t free_on_sequence;
-        unsigned int descriptors_per_page;
+	unsigned int descriptors_per_page;
 	int aborted;
 	enum {
-	        dr_via_device_mapped,
+		dr_via_device_mapped,
 		dr_via_desc_pages_alloc,
 		dr_via_pages_locked,
 		dr_via_pages_alloc,
@@ -68,7 +68,7 @@ typedef struct _drm_via_blitq {
 	unsigned num_free;
 	unsigned num_outstanding;
 	unsigned long end;
-        int aborting;
+	int aborting;
 	int is_active;
 	drm_via_sg_info_t *blits[VIA_NUM_BLIT_SLOTS];
 	spinlock_t blit_lock;
diff --git a/drivers/gpu/drm/via/via_drv.h b/drivers/gpu/drm/via/via_drv.h
index cafcb84..9cf87d9 100644
--- a/drivers/gpu/drm/via/via_drv.h
+++ b/drivers/gpu/drm/via/via_drv.h
@@ -107,9 +107,9 @@ enum via_family {
 #define VIA_BASE ((dev_priv->mmio))
 
 #define VIA_READ(reg)		DRM_READ32(VIA_BASE, reg)
-#define VIA_WRITE(reg,val)	DRM_WRITE32(VIA_BASE, reg, val)
+#define VIA_WRITE(reg, val)	DRM_WRITE32(VIA_BASE, reg, val)
 #define VIA_READ8(reg)		DRM_READ8(VIA_BASE, reg)
-#define VIA_WRITE8(reg,val)	DRM_WRITE8(VIA_BASE, reg, val)
+#define VIA_WRITE8(reg, val)	DRM_WRITE8(VIA_BASE, reg, val)
 
 extern struct drm_ioctl_desc via_ioctls[];
 extern int via_max_ioctl;
@@ -121,28 +121,28 @@ extern int via_agp_init(struct drm_device *dev, void *data, struct drm_file *fil
 extern int via_map_init(struct drm_device *dev, void *data, struct drm_file *file_priv);
 extern int via_decoder_futex(struct drm_device *dev, void *data, struct drm_file *file_priv);
 extern int via_wait_irq(struct drm_device *dev, void *data, struct drm_file *file_priv);
-extern int via_dma_blit_sync( struct drm_device *dev, void *data, struct drm_file *file_priv );
-extern int via_dma_blit( struct drm_device *dev, void *data, struct drm_file *file_priv );
+extern int via_dma_blit_sync(struct drm_device *dev, void *data, struct drm_file *file_priv);
+extern int via_dma_blit(struct drm_device *dev, void *data, struct drm_file *file_priv);
 
 extern int via_driver_load(struct drm_device *dev, unsigned long chipset);
 extern int via_driver_unload(struct drm_device *dev);
 
-extern int via_init_context(struct drm_device * dev, int context);
-extern int via_final_context(struct drm_device * dev, int context);
+extern int via_init_context(struct drm_device *dev, int context);
+extern int via_final_context(struct drm_device *dev, int context);
 
-extern int via_do_cleanup_map(struct drm_device * dev);
+extern int via_do_cleanup_map(struct drm_device *dev);
 extern u32 via_get_vblank_counter(struct drm_device *dev, int crtc);
 extern int via_enable_vblank(struct drm_device *dev, int crtc);
 extern void via_disable_vblank(struct drm_device *dev, int crtc);
 
 extern irqreturn_t via_driver_irq_handler(DRM_IRQ_ARGS);
-extern void via_driver_irq_preinstall(struct drm_device * dev);
+extern void via_driver_irq_preinstall(struct drm_device *dev);
 extern int via_driver_irq_postinstall(struct drm_device *dev);
-extern void via_driver_irq_uninstall(struct drm_device * dev);
+extern void via_driver_irq_uninstall(struct drm_device *dev);
 
-extern int via_dma_cleanup(struct drm_device * dev);
+extern int via_dma_cleanup(struct drm_device *dev);
 extern void via_init_command_verifier(void);
-extern int via_driver_dma_quiescent(struct drm_device * dev);
+extern int via_driver_dma_quiescent(struct drm_device *dev);
 extern void via_init_futex(drm_via_private_t *dev_priv);
 extern void via_cleanup_futex(drm_via_private_t *dev_priv);
 extern void via_release_futex(drm_via_private_t *dev_priv, int context);
diff --git a/drivers/gpu/drm/via/via_irq.c b/drivers/gpu/drm/via/via_irq.c
index 34079f2..d391f48 100644
--- a/drivers/gpu/drm/via/via_irq.c
+++ b/drivers/gpu/drm/via/via_irq.c
@@ -141,11 +141,10 @@ irqreturn_t via_driver_irq_handler(DRM_IRQ_ARGS)
 			atomic_inc(&cur_irq->irq_received);
 			DRM_WAKEUP(&cur_irq->irq_queue);
 			handled = 1;
-			if (dev_priv->irq_map[drm_via_irq_dma0_td] == i) {
+			if (dev_priv->irq_map[drm_via_irq_dma0_td] == i)
 				via_dmablit_handler(dev, 0, 1);
-			} else if (dev_priv->irq_map[drm_via_irq_dma1_td] == i) {
+			else if (dev_priv->irq_map[drm_via_irq_dma1_td] == i)
 				via_dmablit_handler(dev, 1, 1);
-			}
 		}
 		cur_irq++;
 	}
@@ -160,7 +159,7 @@ irqreturn_t via_driver_irq_handler(DRM_IRQ_ARGS)
 		return IRQ_NONE;
 }
 
-static __inline__ void viadrv_acknowledge_irqs(drm_via_private_t * dev_priv)
+static __inline__ void viadrv_acknowledge_irqs(drm_via_private_t *dev_priv)
 {
 	u32 status;
 
@@ -207,7 +206,7 @@ void via_disable_vblank(struct drm_device *dev, int crtc)
 }
 
 static int
-via_driver_irq_wait(struct drm_device * dev, unsigned int irq, int force_sequence,
+via_driver_irq_wait(struct drm_device *dev, unsigned int irq, int force_sequence,
 		    unsigned int *sequence)
 {
 	drm_via_private_t *dev_priv = (drm_via_private_t *) dev->dev_private;
@@ -260,7 +259,7 @@ via_driver_irq_wait(struct drm_device * dev, unsigned int irq, int force_sequenc
  * drm_dma.h hooks
  */
 
-void via_driver_irq_preinstall(struct drm_device * dev)
+void via_driver_irq_preinstall(struct drm_device *dev)
 {
 	drm_via_private_t *dev_priv = (drm_via_private_t *) dev->dev_private;
 	u32 status;
@@ -329,7 +328,7 @@ int via_driver_irq_postinstall(struct drm_device *dev)
 	return 0;
 }
 
-void via_driver_irq_uninstall(struct drm_device * dev)
+void via_driver_irq_uninstall(struct drm_device *dev)
 {
 	drm_via_private_t *dev_priv = (drm_via_private_t *) dev->dev_private;
 	u32 status;
diff --git a/drivers/gpu/drm/via/via_map.c b/drivers/gpu/drm/via/via_map.c
index 6e6f915..6cca9a7 100644
--- a/drivers/gpu/drm/via/via_map.c
+++ b/drivers/gpu/drm/via/via_map.c
@@ -25,7 +25,7 @@
 #include "via_drm.h"
 #include "via_drv.h"
 
-static int via_do_init_map(struct drm_device * dev, drm_via_init_t * init)
+static int via_do_init_map(struct drm_device *dev, drm_via_init_t *init)
 {
 	drm_via_private_t *dev_priv = dev->dev_private;
 
@@ -68,7 +68,7 @@ static int via_do_init_map(struct drm_device * dev, drm_via_init_t * init)
 	return 0;
 }
 
-int via_do_cleanup_map(struct drm_device * dev)
+int via_do_cleanup_map(struct drm_device *dev)
 {
 	via_dma_cleanup(dev);
 
diff --git a/drivers/gpu/drm/via/via_mm.c b/drivers/gpu/drm/via/via_mm.c
index f694cb5..6cc2dad 100644
--- a/drivers/gpu/drm/via/via_mm.c
+++ b/drivers/gpu/drm/via/via_mm.c
@@ -31,7 +31,7 @@
 #include "drm_sman.h"
 
 #define VIA_MM_ALIGN_SHIFT 4
-#define VIA_MM_ALIGN_MASK ( (1 << VIA_MM_ALIGN_SHIFT) - 1)
+#define VIA_MM_ALIGN_MASK ((1 << VIA_MM_ALIGN_SHIFT) - 1)
 
 int via_agp_init(struct drm_device *dev, void *data, struct drm_file *file_priv)
 {
@@ -172,7 +172,7 @@ int via_mem_free(struct drm_device *dev, void *data, struct drm_file *file_priv)
 }
 
 
-void via_reclaim_buffers_locked(struct drm_device * dev,
+void via_reclaim_buffers_locked(struct drm_device *dev,
 				struct drm_file *file_priv)
 {
 	drm_via_private_t *dev_priv = dev->dev_private;
@@ -183,9 +183,8 @@ void via_reclaim_buffers_locked(struct drm_device * dev,
 		return;
 	}
 
-	if (dev->driver->dma_quiescent) {
+	if (dev->driver->dma_quiescent)
 		dev->driver->dma_quiescent(dev);
-	}
 
 	drm_sman_owner_cleanup(&dev_priv->sman, (unsigned long)file_priv);
 	mutex_unlock(&dev->struct_mutex);
diff --git a/drivers/gpu/drm/via/via_verifier.c b/drivers/gpu/drm/via/via_verifier.c
index 46a5791..48957b8 100644
--- a/drivers/gpu/drm/via/via_verifier.c
+++ b/drivers/gpu/drm/via/via_verifier.c
@@ -235,7 +235,7 @@ static hazard_t table2[256];
 static hazard_t table3[256];
 
 static __inline__ int
-eat_words(const uint32_t ** buf, const uint32_t * buf_end, unsigned num_words)
+eat_words(const uint32_t **buf, const uint32_t *buf_end, unsigned num_words)
 {
 	if ((buf_end - *buf) >= num_words) {
 		*buf += num_words;
@@ -252,7 +252,7 @@ eat_words(const uint32_t ** buf, const uint32_t * buf_end, unsigned num_words)
 static __inline__ drm_local_map_t *via_drm_lookup_agp_map(drm_via_state_t *seq,
 						    unsigned long offset,
 						    unsigned long size,
-						    struct drm_device * dev)
+						    struct drm_device *dev)
 {
 	struct drm_map_list *r_list;
 	drm_local_map_t *map = seq->map_cache;
@@ -344,7 +344,7 @@ static __inline__ int finish_current_sequence(drm_via_state_t * cur_seq)
 }
 
 static __inline__ int
-investigate_hazard(uint32_t cmd, hazard_t hz, drm_via_state_t * cur_seq)
+investigate_hazard(uint32_t cmd, hazard_t hz, drm_via_state_t *cur_seq)
 {
 	register uint32_t tmp, *tmp_addr;
 
@@ -518,7 +518,7 @@ investigate_hazard(uint32_t cmd, hazard_t hz, drm_via_state_t * cur_seq)
 
 static __inline__ int
 via_check_prim_list(uint32_t const **buffer, const uint32_t * buf_end,
-		    drm_via_state_t * cur_seq)
+		    drm_via_state_t *cur_seq)
 {
 	drm_via_private_t *dev_priv =
 	    (drm_via_private_t *) cur_seq->dev->dev_private;
@@ -621,8 +621,8 @@ via_check_prim_list(uint32_t const **buffer, const uint32_t * buf_end,
 }
 
 static __inline__ verifier_state_t
-via_check_header2(uint32_t const **buffer, const uint32_t * buf_end,
-		  drm_via_state_t * hc_state)
+via_check_header2(uint32_t const **buffer, const uint32_t *buf_end,
+		  drm_via_state_t *hc_state)
 {
 	uint32_t cmd;
 	int hz_mode;
@@ -706,16 +706,15 @@ via_check_header2(uint32_t const **buffer, const uint32_t * buf_end,
 			return state_error;
 		}
 	}
-	if (hc_state->unfinished && finish_current_sequence(hc_state)) {
+	if (hc_state->unfinished && finish_current_sequence(hc_state))
 		return state_error;
-	}
 	*buffer = buf;
 	return state_command;
 }
 
 static __inline__ verifier_state_t
-via_parse_header2(drm_via_private_t * dev_priv, uint32_t const **buffer,
-		  const uint32_t * buf_end, int *fire_count)
+via_parse_header2(drm_via_private_t *dev_priv, uint32_t const **buffer,
+		  const uint32_t *buf_end, int *fire_count)
 {
 	uint32_t cmd;
 	const uint32_t *buf = *buffer;
@@ -833,8 +832,8 @@ via_check_header1(uint32_t const **buffer, const uint32_t * buf_end)
 }
 
 static __inline__ verifier_state_t
-via_parse_header1(drm_via_private_t * dev_priv, uint32_t const **buffer,
-		  const uint32_t * buf_end)
+via_parse_header1(drm_via_private_t *dev_priv, uint32_t const **buffer,
+		  const uint32_t *buf_end)
 {
 	register uint32_t cmd;
 	const uint32_t *buf = *buffer;
@@ -851,7 +850,7 @@ via_parse_header1(drm_via_private_t * dev_priv, uint32_t const **buffer,
 }
 
 static __inline__ verifier_state_t
-via_check_vheader5(uint32_t const **buffer, const uint32_t * buf_end)
+via_check_vheader5(uint32_t const **buffer, const uint32_t *buf_end)
 {
 	uint32_t data;
 	const uint32_t *buf = *buffer;
@@ -884,8 +883,8 @@ via_check_vheader5(uint32_t const **buffer, const uint32_t * buf_end)
 }
 
 static __inline__ verifier_state_t
-via_parse_vheader5(drm_via_private_t * dev_priv, uint32_t const **buffer,
-		   const uint32_t * buf_end)
+via_parse_vheader5(drm_via_private_t *dev_priv, uint32_t const **buffer,
+		   const uint32_t *buf_end)
 {
 	uint32_t addr, count, i;
 	const uint32_t *buf = *buffer;
@@ -893,9 +892,8 @@ via_parse_vheader5(drm_via_private_t * dev_priv, uint32_t const **buffer,
 	addr = *buf++ & ~VIA_VIDEOMASK;
 	i = count = *buf;
 	buf += 3;
-	while (i--) {
+	while (i--)
 		VIA_WRITE(addr, *buf++);
-	}
 	if (count & 3)
 		buf += 4 - (count & 3);
 	*buffer = buf;
@@ -940,8 +938,8 @@ via_check_vheader6(uint32_t const **buffer, const uint32_t * buf_end)
 }
 
 static __inline__ verifier_state_t
-via_parse_vheader6(drm_via_private_t * dev_priv, uint32_t const **buffer,
-		   const uint32_t * buf_end)
+via_parse_vheader6(drm_via_private_t *dev_priv, uint32_t const **buffer,
+		   const uint32_t *buf_end)
 {
 
 	uint32_t addr, count, i;
@@ -1037,7 +1035,7 @@ via_verify_command_stream(const uint32_t * buf, unsigned int size,
 }
 
 int
-via_parse_command_stream(struct drm_device * dev, const uint32_t * buf,
+via_parse_command_stream(struct drm_device *dev, const uint32_t *buf,
 			 unsigned int size)
 {
 
@@ -1085,9 +1083,8 @@ via_parse_command_stream(struct drm_device * dev, const uint32_t * buf,
 			return -EINVAL;
 		}
 	}
-	if (state == state_error) {
+	if (state == state_error)
 		return -EINVAL;
-	}
 	return 0;
 }
 
@@ -1096,13 +1093,11 @@ setup_hazard_table(hz_init_t init_table[], hazard_t table[], int size)
 {
 	int i;
 
-	for (i = 0; i < 256; ++i) {
+	for (i = 0; i < 256; ++i)
 		table[i] = forbidden_command;
-	}
 
-	for (i = 0; i < size; ++i) {
+	for (i = 0; i < size; ++i)
 		table[init_table[i].code] = init_table[i].hz;
-	}
 }
 
 void via_init_command_verifier(void)
diff --git a/drivers/gpu/drm/via/via_verifier.h b/drivers/gpu/drm/via/via_verifier.h
index d6f8214..26b6d36 100644
--- a/drivers/gpu/drm/via/via_verifier.h
+++ b/drivers/gpu/drm/via/via_verifier.h
@@ -54,8 +54,8 @@ typedef struct {
 	const uint32_t *buf_start;
 } drm_via_state_t;
 
-extern int via_verify_command_stream(const uint32_t * buf, unsigned int size,
-				     struct drm_device * dev, int agp);
+extern int via_verify_command_stream(const uint32_t *buf, unsigned int size,
+				     struct drm_device *dev, int agp);
 extern int via_parse_command_stream(struct drm_device *dev, const uint32_t *buf,
 				    unsigned int size);
 
diff --git a/drivers/gpu/drm/via/via_video.c b/drivers/gpu/drm/via/via_video.c
index 6efac81..675d311 100644
--- a/drivers/gpu/drm/via/via_video.c
+++ b/drivers/gpu/drm/via/via_video.c
@@ -29,7 +29,7 @@
 #include "via_drm.h"
 #include "via_drv.h"
 
-void via_init_futex(drm_via_private_t * dev_priv)
+void via_init_futex(drm_via_private_t *dev_priv)
 {
 	unsigned int i;
 
@@ -41,11 +41,11 @@ void via_init_futex(drm_via_private_t * dev_priv)
 	}
 }
 
-void via_cleanup_futex(drm_via_private_t * dev_priv)
+void via_cleanup_futex(drm_via_private_t *dev_priv)
 {
 }
 
-void via_release_futex(drm_via_private_t * dev_priv, int context)
+void via_release_futex(drm_via_private_t *dev_priv, int context)
 {
 	unsigned int i;
 	volatile int *lock;
-- 
1.7.1
