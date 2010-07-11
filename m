Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab0GLAEl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 20:04:41 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:55556 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755103Ab0GLAEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 20:04:39 -0400
Date: Mon, 12 Jul 2010 01:46:57 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/mga: fixed brace, macro and spacing coding style issues
Message-ID: <20100712014657.3b69ab96@absol.kitzblitz>
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

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/gpu/drm/mga/mga_dma.c   |   99 +++++++++------------
 drivers/gpu/drm/mga/mga_drv.c   |    4 +-
 drivers/gpu/drm/mga/mga_drv.h   |  187 +++++++++++++++++++--------------------
 drivers/gpu/drm/mga/mga_irq.c   |    9 +-
 drivers/gpu/drm/mga/mga_state.c |   47 +++++-----
 drivers/gpu/drm/mga/mga_warp.c  |    4 +-
 6 files changed, 165 insertions(+), 185 deletions(-)

diff --git a/drivers/gpu/drm/mga/mga_dma.c b/drivers/gpu/drm/mga/mga_dma.c
index 3c917fb..a3c2b55 100644
--- a/drivers/gpu/drm/mga/mga_dma.c
+++ b/drivers/gpu/drm/mga/mga_dma.c
@@ -52,7 +52,7 @@ static int mga_do_cleanup_dma(struct drm_device *dev, int full_cleanup);
  * Engine control
  */
 
-int mga_do_wait_for_idle(drm_mga_private_t * dev_priv)
+int mga_do_wait_for_idle(drm_mga_private_t *dev_priv)
 {
 	u32 status = 0;
 	int i;
@@ -74,7 +74,7 @@ int mga_do_wait_for_idle(drm_mga_private_t * dev_priv)
 	return -EBUSY;
 }
 
-static int mga_do_dma_reset(drm_mga_private_t * dev_priv)
+static int mga_do_dma_reset(drm_mga_private_t *dev_priv)
 {
 	drm_mga_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_mga_primary_buffer_t *primary = &dev_priv->prim;
@@ -102,7 +102,7 @@ static int mga_do_dma_reset(drm_mga_private_t * dev_priv)
  * Primary DMA stream
  */
 
-void mga_do_dma_flush(drm_mga_private_t * dev_priv)
+void mga_do_dma_flush(drm_mga_private_t *dev_priv)
 {
 	drm_mga_primary_buffer_t *primary = &dev_priv->prim;
 	u32 head, tail;
@@ -142,11 +142,10 @@ void mga_do_dma_flush(drm_mga_private_t * dev_priv)
 
 	head = MGA_READ(MGA_PRIMADDRESS);
 
-	if (head <= tail) {
+	if (head <= tail)
 		primary->space = primary->size - primary->tail;
-	} else {
+	else
 		primary->space = head - tail;
-	}
 
 	DRM_DEBUG("   head = 0x%06lx\n", (unsigned long)(head - dev_priv->primary->offset));
 	DRM_DEBUG("   tail = 0x%06lx\n", (unsigned long)(tail - dev_priv->primary->offset));
@@ -158,7 +157,7 @@ void mga_do_dma_flush(drm_mga_private_t * dev_priv)
 	DRM_DEBUG("done.\n");
 }
 
-void mga_do_dma_wrap_start(drm_mga_private_t * dev_priv)
+void mga_do_dma_wrap_start(drm_mga_private_t *dev_priv)
 {
 	drm_mga_primary_buffer_t *primary = &dev_priv->prim;
 	u32 head, tail;
@@ -181,11 +180,10 @@ void mga_do_dma_wrap_start(drm_mga_private_t * dev_priv)
 
 	head = MGA_READ(MGA_PRIMADDRESS);
 
-	if (head == dev_priv->primary->offset) {
+	if (head == dev_priv->primary->offset)
 		primary->space = primary->size;
-	} else {
+	else
 		primary->space = head - dev_priv->primary->offset;
-	}
 
 	DRM_DEBUG("   head = 0x%06lx\n", (unsigned long)(head - dev_priv->primary->offset));
 	DRM_DEBUG("   tail = 0x%06x\n", primary->tail);
@@ -199,7 +197,7 @@ void mga_do_dma_wrap_start(drm_mga_private_t * dev_priv)
 	DRM_DEBUG("done.\n");
 }
 
-void mga_do_dma_wrap_end(drm_mga_private_t * dev_priv)
+void mga_do_dma_wrap_end(drm_mga_private_t *dev_priv)
 {
 	drm_mga_primary_buffer_t *primary = &dev_priv->prim;
 	drm_mga_sarea_t *sarea_priv = dev_priv->sarea_priv;
@@ -220,11 +218,11 @@ void mga_do_dma_wrap_end(drm_mga_private_t * dev_priv)
  * Freelist management
  */
 
-#define MGA_BUFFER_USED		~0
+#define MGA_BUFFER_USED		(~0)
 #define MGA_BUFFER_FREE		0
 
 #if MGA_FREELIST_DEBUG
-static void mga_freelist_print(struct drm_device * dev)
+static void mga_freelist_print(struct drm_device *dev)
 {
 	drm_mga_private_t *dev_priv = dev->dev_private;
 	drm_mga_freelist_t *entry;
@@ -245,7 +243,7 @@ static void mga_freelist_print(struct drm_device * dev)
 }
 #endif
 
-static int mga_freelist_init(struct drm_device * dev, drm_mga_private_t * dev_priv)
+static int mga_freelist_init(struct drm_device *dev, drm_mga_private_t *dev_priv)
 {
 	struct drm_device_dma *dma = dev->dma;
 	struct drm_buf *buf;
@@ -288,7 +286,7 @@ static int mga_freelist_init(struct drm_device * dev, drm_mga_private_t * dev_pr
 	return 0;
 }
 
-static void mga_freelist_cleanup(struct drm_device * dev)
+static void mga_freelist_cleanup(struct drm_device *dev)
 {
 	drm_mga_private_t *dev_priv = dev->dev_private;
 	drm_mga_freelist_t *entry;
@@ -308,7 +306,7 @@ static void mga_freelist_cleanup(struct drm_device * dev)
 #if 0
 /* FIXME: Still needed?
  */
-static void mga_freelist_reset(struct drm_device * dev)
+static void mga_freelist_reset(struct drm_device *dev)
 {
 	struct drm_device_dma *dma = dev->dma;
 	struct drm_buf *buf;
@@ -356,7 +354,7 @@ static struct drm_buf *mga_freelist_get(struct drm_device * dev)
 	return NULL;
 }
 
-int mga_freelist_put(struct drm_device * dev, struct drm_buf * buf)
+int mga_freelist_put(struct drm_device *dev, struct drm_buf *buf)
 {
 	drm_mga_private_t *dev_priv = dev->dev_private;
 	drm_mga_buf_priv_t *buf_priv = buf->dev_private;
@@ -391,7 +389,7 @@ int mga_freelist_put(struct drm_device * dev, struct drm_buf * buf)
  * DMA initialization, cleanup
  */
 
-int mga_driver_load(struct drm_device * dev, unsigned long flags)
+int mga_driver_load(struct drm_device *dev, unsigned long flags)
 {
 	drm_mga_private_t *dev_priv;
 	int ret;
@@ -439,8 +437,8 @@ int mga_driver_load(struct drm_device * dev, unsigned long flags)
  *
  * \sa mga_do_dma_bootstrap, mga_do_pci_dma_bootstrap
  */
-static int mga_do_agp_dma_bootstrap(struct drm_device * dev,
-				    drm_mga_dma_bootstrap_t * dma_bs)
+static int mga_do_agp_dma_bootstrap(struct drm_device *dev,
+				    drm_mga_dma_bootstrap_t *dma_bs)
 {
 	drm_mga_private_t *const dev_priv =
 	    (drm_mga_private_t *) dev->dev_private;
@@ -481,11 +479,10 @@ static int mga_do_agp_dma_bootstrap(struct drm_device * dev,
 	 */
 
 	if (dev_priv->chipset == MGA_CARD_TYPE_G200) {
-		if (mode.mode & 0x02) {
+		if (mode.mode & 0x02)
 			MGA_WRITE(MGA_AGP_PLL, MGA_AGP2XPLL_ENABLE);
-		} else {
+		else
 			MGA_WRITE(MGA_AGP_PLL, MGA_AGP2XPLL_DISABLE);
-		}
 	}
 
 	/* Allocate and bind AGP memory. */
@@ -593,8 +590,8 @@ static int mga_do_agp_dma_bootstrap(struct drm_device * dev,
 	return 0;
 }
 #else
-static int mga_do_agp_dma_bootstrap(struct drm_device * dev,
-				    drm_mga_dma_bootstrap_t * dma_bs)
+static int mga_do_agp_dma_bootstrap(struct drm_device *dev,
+				    drm_mga_dma_bootstrap_t *dma_bs)
 {
 	return -EINVAL;
 }
@@ -614,8 +611,8 @@ static int mga_do_agp_dma_bootstrap(struct drm_device * dev,
  *
  * \sa mga_do_dma_bootstrap, mga_do_agp_dma_bootstrap
  */
-static int mga_do_pci_dma_bootstrap(struct drm_device * dev,
-				    drm_mga_dma_bootstrap_t * dma_bs)
+static int mga_do_pci_dma_bootstrap(struct drm_device *dev,
+				    drm_mga_dma_bootstrap_t *dma_bs)
 {
 	drm_mga_private_t *const dev_priv =
 	    (drm_mga_private_t *) dev->dev_private;
@@ -678,9 +675,8 @@ static int mga_do_pci_dma_bootstrap(struct drm_device * dev,
 		req.size = dma_bs->secondary_bin_size;
 
 		err = drm_addbufs_pci(dev, &req);
-		if (!err) {
+		if (!err)
 			break;
-		}
 	}
 
 	if (bin_count == 0) {
@@ -704,8 +700,8 @@ static int mga_do_pci_dma_bootstrap(struct drm_device * dev,
 	return 0;
 }
 
-static int mga_do_dma_bootstrap(struct drm_device * dev,
-				drm_mga_dma_bootstrap_t * dma_bs)
+static int mga_do_dma_bootstrap(struct drm_device *dev,
+				drm_mga_dma_bootstrap_t *dma_bs)
 {
 	const int is_agp = (dma_bs->agp_mode != 0) && drm_device_is_agp(dev);
 	int err;
@@ -737,17 +733,15 @@ static int mga_do_dma_bootstrap(struct drm_device * dev,
 	 * carve off portions of it for internal uses.  The remaining memory
 	 * is returned to user-mode to be used for AGP textures.
 	 */
-	if (is_agp) {
+	if (is_agp)
 		err = mga_do_agp_dma_bootstrap(dev, dma_bs);
-	}
 
 	/* If we attempted to initialize the card for AGP DMA but failed,
 	 * clean-up any mess that may have been created.
 	 */
 
-	if (err) {
+	if (err)
 		mga_do_cleanup_dma(dev, MINIMAL_CLEANUP);
-	}
 
 	/* Not only do we want to try and initialized PCI cards for PCI DMA,
 	 * but we also try to initialized AGP cards that could not be
@@ -757,9 +751,8 @@ static int mga_do_dma_bootstrap(struct drm_device * dev,
 	 * AGP memory, etc.
 	 */
 
-	if (!is_agp || err) {
+	if (!is_agp || err)
 		err = mga_do_pci_dma_bootstrap(dev, dma_bs);
-	}
 
 	return err;
 }
@@ -792,7 +785,7 @@ int mga_dma_bootstrap(struct drm_device *dev, void *data,
 	return err;
 }
 
-static int mga_do_init_dma(struct drm_device * dev, drm_mga_init_t * init)
+static int mga_do_init_dma(struct drm_device *dev, drm_mga_init_t *init)
 {
 	drm_mga_private_t *dev_priv;
 	int ret;
@@ -800,11 +793,10 @@ static int mga_do_init_dma(struct drm_device * dev, drm_mga_init_t * init)
 
 	dev_priv = dev->dev_private;
 
-	if (init->sgram) {
+	if (init->sgram)
 		dev_priv->clear_cmd = MGA_DWGCTL_CLEAR | MGA_ATYPE_BLK;
-	} else {
+	else
 		dev_priv->clear_cmd = MGA_DWGCTL_CLEAR | MGA_ATYPE_RSTR;
-	}
 	dev_priv->maccess = init->maccess;
 
 	dev_priv->fb_cpp = init->fb_cpp;
@@ -975,9 +967,8 @@ static int mga_do_cleanup_dma(struct drm_device *dev, int full_cleanup)
 				dev_priv->agp_handle = 0;
 			}
 
-			if ((dev->agp != NULL) && dev->agp->acquired) {
+			if ((dev->agp != NULL) && dev->agp->acquired)
 				err = drm_agp_release(dev);
-			}
 #endif
 		}
 
@@ -998,9 +989,8 @@ static int mga_do_cleanup_dma(struct drm_device *dev, int full_cleanup)
 		memset(dev_priv->warp_pipe_phys, 0,
 		       sizeof(dev_priv->warp_pipe_phys));
 
-		if (dev_priv->head != NULL) {
+		if (dev_priv->head != NULL)
 			mga_freelist_cleanup(dev);
-		}
 	}
 
 	return err;
@@ -1017,9 +1007,8 @@ int mga_dma_init(struct drm_device *dev, void *data,
 	switch (init->func) {
 	case MGA_INIT_DMA:
 		err = mga_do_init_dma(dev, init);
-		if (err) {
+		if (err)
 			(void)mga_do_cleanup_dma(dev, FULL_CLEANUP);
-		}
 		return err;
 	case MGA_CLEANUP_DMA:
 		return mga_do_cleanup_dma(dev, FULL_CLEANUP);
@@ -1047,9 +1036,8 @@ int mga_dma_flush(struct drm_device *dev, void *data,
 
 	WRAP_WAIT_WITH_RETURN(dev_priv);
 
-	if (lock->flags & (_DRM_LOCK_FLUSH | _DRM_LOCK_FLUSH_ALL)) {
+	if (lock->flags & (_DRM_LOCK_FLUSH | _DRM_LOCK_FLUSH_ALL))
 		mga_do_dma_flush(dev_priv);
-	}
 
 	if (lock->flags & _DRM_LOCK_QUIESCENT) {
 #if MGA_DMA_DEBUG
@@ -1079,8 +1067,8 @@ int mga_dma_reset(struct drm_device *dev, void *data,
  * DMA buffer management
  */
 
-static int mga_dma_get_buffers(struct drm_device * dev,
-			       struct drm_file *file_priv, struct drm_dma * d)
+static int mga_dma_get_buffers(struct drm_device *dev,
+			       struct drm_file *file_priv, struct drm_dma *d)
 {
 	struct drm_buf *buf;
 	int i;
@@ -1134,9 +1122,8 @@ int mga_dma_buffers(struct drm_device *dev, void *data,
 
 	d->granted_count = 0;
 
-	if (d->request_count) {
+	if (d->request_count)
 		ret = mga_dma_get_buffers(dev, file_priv, d);
-	}
 
 	return ret;
 }
@@ -1144,7 +1131,7 @@ int mga_dma_buffers(struct drm_device *dev, void *data,
 /**
  * Called just before the module is unloaded.
  */
-int mga_driver_unload(struct drm_device * dev)
+int mga_driver_unload(struct drm_device *dev)
 {
 	kfree(dev->dev_private);
 	dev->dev_private = NULL;
@@ -1155,12 +1142,12 @@ int mga_driver_unload(struct drm_device * dev)
 /**
  * Called when the last opener of the device is closed.
  */
-void mga_driver_lastclose(struct drm_device * dev)
+void mga_driver_lastclose(struct drm_device *dev)
 {
 	mga_do_cleanup_dma(dev, FULL_CLEANUP);
 }
 
-int mga_driver_dma_quiescent(struct drm_device * dev)
+int mga_driver_dma_quiescent(struct drm_device *dev)
 {
 	drm_mga_private_t *dev_priv = dev->dev_private;
 	return mga_do_wait_for_idle(dev_priv);
diff --git a/drivers/gpu/drm/mga/mga_drv.c b/drivers/gpu/drm/mga/mga_drv.c
index ddfe161..26d0d8c 100644
--- a/drivers/gpu/drm/mga/mga_drv.c
+++ b/drivers/gpu/drm/mga/mga_drv.c
@@ -36,7 +36,7 @@
 
 #include "drm_pciids.h"
 
-static int mga_driver_device_is_agp(struct drm_device * dev);
+static int mga_driver_device_is_agp(struct drm_device *dev);
 
 static struct pci_device_id pciidlist[] = {
 	mga_PCI_IDS
@@ -119,7 +119,7 @@ MODULE_LICENSE("GPL and additional rights");
  * \returns
  * If the device is a PCI G450, zero is returned.  Otherwise 2 is returned.
  */
-static int mga_driver_device_is_agp(struct drm_device * dev)
+static int mga_driver_device_is_agp(struct drm_device *dev)
 {
 	const struct pci_dev *const pdev = dev->pdev;
 
diff --git a/drivers/gpu/drm/mga/mga_drv.h b/drivers/gpu/drm/mga/mga_drv.h
index be6c6b9..1084fa4 100644
--- a/drivers/gpu/drm/mga/mga_drv.h
+++ b/drivers/gpu/drm/mga/mga_drv.h
@@ -164,59 +164,59 @@ extern int mga_dma_reset(struct drm_device *dev, void *data,
 extern int mga_dma_buffers(struct drm_device *dev, void *data,
 			   struct drm_file *file_priv);
 extern int mga_driver_load(struct drm_device *dev, unsigned long flags);
-extern int mga_driver_unload(struct drm_device * dev);
-extern void mga_driver_lastclose(struct drm_device * dev);
-extern int mga_driver_dma_quiescent(struct drm_device * dev);
+extern int mga_driver_unload(struct drm_device *dev);
+extern void mga_driver_lastclose(struct drm_device *dev);
+extern int mga_driver_dma_quiescent(struct drm_device *dev);
 
-extern int mga_do_wait_for_idle(drm_mga_private_t * dev_priv);
+extern int mga_do_wait_for_idle(drm_mga_private_t *dev_priv);
 
-extern void mga_do_dma_flush(drm_mga_private_t * dev_priv);
-extern void mga_do_dma_wrap_start(drm_mga_private_t * dev_priv);
-extern void mga_do_dma_wrap_end(drm_mga_private_t * dev_priv);
+extern void mga_do_dma_flush(drm_mga_private_t *dev_priv);
+extern void mga_do_dma_wrap_start(drm_mga_private_t *dev_priv);
+extern void mga_do_dma_wrap_end(drm_mga_private_t *dev_priv);
 
-extern int mga_freelist_put(struct drm_device * dev, struct drm_buf * buf);
+extern int mga_freelist_put(struct drm_device *dev, struct drm_buf *buf);
 
 				/* mga_warp.c */
-extern int mga_warp_install_microcode(drm_mga_private_t * dev_priv);
-extern int mga_warp_init(drm_mga_private_t * dev_priv);
+extern int mga_warp_install_microcode(drm_mga_private_t *dev_priv);
+extern int mga_warp_init(drm_mga_private_t *dev_priv);
 
 				/* mga_irq.c */
 extern int mga_enable_vblank(struct drm_device *dev, int crtc);
 extern void mga_disable_vblank(struct drm_device *dev, int crtc);
 extern u32 mga_get_vblank_counter(struct drm_device *dev, int crtc);
-extern int mga_driver_fence_wait(struct drm_device * dev, unsigned int *sequence);
-extern int mga_driver_vblank_wait(struct drm_device * dev, unsigned int *sequence);
+extern int mga_driver_fence_wait(struct drm_device *dev, unsigned int *sequence);
+extern int mga_driver_vblank_wait(struct drm_device *dev, unsigned int *sequence);
 extern irqreturn_t mga_driver_irq_handler(DRM_IRQ_ARGS);
-extern void mga_driver_irq_preinstall(struct drm_device * dev);
+extern void mga_driver_irq_preinstall(struct drm_device *dev);
 extern int mga_driver_irq_postinstall(struct drm_device *dev);
-extern void mga_driver_irq_uninstall(struct drm_device * dev);
+extern void mga_driver_irq_uninstall(struct drm_device *dev);
 extern long mga_compat_ioctl(struct file *filp, unsigned int cmd,
 			     unsigned long arg);
 
 #define mga_flush_write_combine()	DRM_WRITEMEMORYBARRIER()
 
 #if defined(__linux__) && defined(__alpha__)
-#define MGA_BASE( reg )		((unsigned long)(dev_priv->mmio->handle))
-#define MGA_ADDR( reg )		(MGA_BASE(reg) + reg)
+#define MGA_BASE(reg)		((unsigned long)(dev_priv->mmio->handle))
+#define MGA_ADDR(reg)		(MGA_BASE(reg) + reg)
 
-#define MGA_DEREF( reg )	*(volatile u32 *)MGA_ADDR( reg )
-#define MGA_DEREF8( reg )	*(volatile u8 *)MGA_ADDR( reg )
+#define MGA_DEREF(reg)		(*(volatile u32 *)MGA_ADDR(reg))
+#define MGA_DEREF8(reg)		(*(volatile u8 *)MGA_ADDR(reg))
 
-#define MGA_READ( reg )		(_MGA_READ((u32 *)MGA_ADDR(reg)))
-#define MGA_READ8( reg )	(_MGA_READ((u8 *)MGA_ADDR(reg)))
-#define MGA_WRITE( reg, val )	do { DRM_WRITEMEMORYBARRIER(); MGA_DEREF( reg ) = val; } while (0)
-#define MGA_WRITE8( reg, val )  do { DRM_WRITEMEMORYBARRIER(); MGA_DEREF8( reg ) = val; } while (0)
+#define MGA_READ(reg)		(_MGA_READ((u32 *)MGA_ADDR(reg)))
+#define MGA_READ8(reg)		(_MGA_READ((u8 *)MGA_ADDR(reg)))
+#define MGA_WRITE(reg, val)	do { DRM_WRITEMEMORYBARRIER(); MGA_DEREF(reg) = val; } while (0)
+#define MGA_WRITE8(reg, val)	do { DRM_WRITEMEMORYBARRIER(); MGA_DEREF8(reg) = val; } while (0)
 
-static inline u32 _MGA_READ(u32 * addr)
+static inline u32 _MGA_READ(u32 *addr)
 {
 	DRM_MEMORYBARRIER();
 	return *(volatile u32 *)addr;
 }
 #else
-#define MGA_READ8( reg )	DRM_READ8(dev_priv->mmio, (reg))
-#define MGA_READ( reg )		DRM_READ32(dev_priv->mmio, (reg))
-#define MGA_WRITE8( reg, val )  DRM_WRITE8(dev_priv->mmio, (reg), (val))
-#define MGA_WRITE( reg, val )	DRM_WRITE32(dev_priv->mmio, (reg), (val))
+#define MGA_READ8(reg)		DRM_READ8(dev_priv->mmio, (reg))
+#define MGA_READ(reg)		DRM_READ32(dev_priv->mmio, (reg))
+#define MGA_WRITE8(reg, val)	DRM_WRITE8(dev_priv->mmio, (reg), (val))
+#define MGA_WRITE(reg, val)	DRM_WRITE32(dev_priv->mmio, (reg), (val))
 #endif
 
 #define DWGREG0		0x1c00
@@ -233,40 +233,39 @@ static inline u32 _MGA_READ(u32 * addr)
  * Helper macross...
  */
 
-#define MGA_EMIT_STATE( dev_priv, dirty )				\
+#define MGA_EMIT_STATE(dev_priv, dirty)					\
 do {									\
-	if ( (dirty) & ~MGA_UPLOAD_CLIPRECTS ) {			\
-		if ( dev_priv->chipset >= MGA_CARD_TYPE_G400 ) {	\
-			mga_g400_emit_state( dev_priv );		\
-		} else {						\
-			mga_g200_emit_state( dev_priv );		\
-		}							\
+	if ((dirty) & ~MGA_UPLOAD_CLIPRECTS) {				\
+		if (dev_priv->chipset >= MGA_CARD_TYPE_G400)		\
+			mga_g400_emit_state(dev_priv);			\
+		else							\
+			mga_g200_emit_state(dev_priv);			\
 	}								\
 } while (0)
 
-#define WRAP_TEST_WITH_RETURN( dev_priv )				\
+#define WRAP_TEST_WITH_RETURN(dev_priv)					\
 do {									\
-	if ( test_bit( 0, &dev_priv->prim.wrapped ) ) {			\
-		if ( mga_is_idle( dev_priv ) ) {			\
-			mga_do_dma_wrap_end( dev_priv );		\
-		} else if ( dev_priv->prim.space <			\
-			    dev_priv->prim.high_mark ) {		\
-			if ( MGA_DMA_DEBUG )				\
-				DRM_INFO( "wrap...\n");		\
-			return -EBUSY;			\
+	if (test_bit(0, &dev_priv->prim.wrapped)) {			\
+		if (mga_is_idle(dev_priv)) {				\
+			mga_do_dma_wrap_end(dev_priv);			\
+		} else if (dev_priv->prim.space <			\
+			   dev_priv->prim.high_mark) {			\
+			if (MGA_DMA_DEBUG)				\
+				DRM_INFO("wrap...\n");			\
+			return -EBUSY;					\
 		}							\
 	}								\
 } while (0)
 
-#define WRAP_WAIT_WITH_RETURN( dev_priv )				\
+#define WRAP_WAIT_WITH_RETURN(dev_priv)					\
 do {									\
-	if ( test_bit( 0, &dev_priv->prim.wrapped ) ) {			\
-		if ( mga_do_wait_for_idle( dev_priv ) < 0 ) {		\
-			if ( MGA_DMA_DEBUG )				\
-				DRM_INFO( "wrap...\n");		\
-			return -EBUSY;			\
+	if (test_bit(0, &dev_priv->prim.wrapped)) {			\
+		if (mga_do_wait_for_idle(dev_priv) < 0) {		\
+			if (MGA_DMA_DEBUG)				\
+				DRM_INFO("wrap...\n");			\
+			return -EBUSY;					\
 		}							\
-		mga_do_dma_wrap_end( dev_priv );			\
+		mga_do_dma_wrap_end(dev_priv);				\
 	}								\
 } while (0)
 
@@ -280,12 +279,12 @@ do {									\
 
 #define DMA_BLOCK_SIZE	(5 * sizeof(u32))
 
-#define BEGIN_DMA( n )							\
+#define BEGIN_DMA(n)							\
 do {									\
-	if ( MGA_VERBOSE ) {						\
-		DRM_INFO( "BEGIN_DMA( %d )\n", (n) );		\
-		DRM_INFO( "   space=0x%x req=0x%Zx\n",			\
-			  dev_priv->prim.space, (n) * DMA_BLOCK_SIZE );	\
+	if (MGA_VERBOSE) {						\
+		DRM_INFO("BEGIN_DMA(%d)\n", (n));			\
+		DRM_INFO("   space=0x%x req=0x%Zx\n",			\
+			 dev_priv->prim.space, (n) * DMA_BLOCK_SIZE);	\
 	}								\
 	prim = dev_priv->prim.start;					\
 	write = dev_priv->prim.tail;					\
@@ -293,9 +292,9 @@ do {									\
 
 #define BEGIN_DMA_WRAP()						\
 do {									\
-	if ( MGA_VERBOSE ) {						\
-		DRM_INFO( "BEGIN_DMA()\n" );				\
-		DRM_INFO( "   space=0x%x\n", dev_priv->prim.space );	\
+	if (MGA_VERBOSE) {						\
+		DRM_INFO("BEGIN_DMA()\n");				\
+		DRM_INFO("   space=0x%x\n", dev_priv->prim.space);	\
 	}								\
 	prim = dev_priv->prim.start;					\
 	write = dev_priv->prim.tail;					\
@@ -304,72 +303,68 @@ do {									\
 #define ADVANCE_DMA()							\
 do {									\
 	dev_priv->prim.tail = write;					\
-	if ( MGA_VERBOSE ) {						\
-		DRM_INFO( "ADVANCE_DMA() tail=0x%05x sp=0x%x\n",	\
-			  write, dev_priv->prim.space );		\
-	}								\
+	if (MGA_VERBOSE)						\
+		DRM_INFO("ADVANCE_DMA() tail=0x%05x sp=0x%x\n",		\
+			 write, dev_priv->prim.space);			\
 } while (0)
 
 #define FLUSH_DMA()							\
 do {									\
-	if ( 0 ) {							\
-		DRM_INFO( "\n" );					\
-		DRM_INFO( "   tail=0x%06x head=0x%06lx\n",		\
-			  dev_priv->prim.tail,				\
-			  (unsigned long)(MGA_READ(MGA_PRIMADDRESS) -	\
-					  dev_priv->primary->offset));	\
+	if (0) {							\
+		DRM_INFO("\n");						\
+		DRM_INFO("   tail=0x%06x head=0x%06lx\n",		\
+			 dev_priv->prim.tail,				\
+			 (unsigned long)(MGA_READ(MGA_PRIMADDRESS) -	\
+					 dev_priv->primary->offset));	\
 	}								\
-	if ( !test_bit( 0, &dev_priv->prim.wrapped ) ) {		\
-		if ( dev_priv->prim.space <				\
-		     dev_priv->prim.high_mark ) {			\
-			mga_do_dma_wrap_start( dev_priv );		\
-		} else {						\
-			mga_do_dma_flush( dev_priv );			\
-		}							\
+	if (!test_bit(0, &dev_priv->prim.wrapped)) {			\
+		if (dev_priv->prim.space < dev_priv->prim.high_mark)	\
+			mga_do_dma_wrap_start(dev_priv);		\
+		else							\
+			mga_do_dma_flush(dev_priv);			\
 	}								\
 } while (0)
 
 /* Never use this, always use DMA_BLOCK(...) for primary DMA output.
  */
-#define DMA_WRITE( offset, val )					\
+#define DMA_WRITE(offset, val)						\
 do {									\
-	if ( MGA_VERBOSE ) {						\
-		DRM_INFO( "   DMA_WRITE( 0x%08x ) at 0x%04Zx\n",	\
-			  (u32)(val), write + (offset) * sizeof(u32) );	\
-	}								\
+	if (MGA_VERBOSE)						\
+		DRM_INFO("   DMA_WRITE( 0x%08x ) at 0x%04Zx\n",		\
+			 (u32)(val), write + (offset) * sizeof(u32));	\
 	*(volatile u32 *)(prim + write + (offset) * sizeof(u32)) = val;	\
 } while (0)
 
-#define DMA_BLOCK( reg0, val0, reg1, val1, reg2, val2, reg3, val3 )	\
+#define DMA_BLOCK(reg0, val0, reg1, val1, reg2, val2, reg3, val3)	\
 do {									\
-	DMA_WRITE( 0, ((DMAREG( reg0 ) << 0) |				\
-		       (DMAREG( reg1 ) << 8) |				\
-		       (DMAREG( reg2 ) << 16) |				\
-		       (DMAREG( reg3 ) << 24)) );			\
-	DMA_WRITE( 1, val0 );						\
-	DMA_WRITE( 2, val1 );						\
-	DMA_WRITE( 3, val2 );						\
-	DMA_WRITE( 4, val3 );						\
+	DMA_WRITE(0, ((DMAREG(reg0) << 0) |				\
+		      (DMAREG(reg1) << 8) |				\
+		      (DMAREG(reg2) << 16) |				\
+		      (DMAREG(reg3) << 24)));				\
+	DMA_WRITE(1, val0);						\
+	DMA_WRITE(2, val1);						\
+	DMA_WRITE(3, val2);						\
+	DMA_WRITE(4, val3);						\
 	write += DMA_BLOCK_SIZE;					\
 } while (0)
 
 /* Buffer aging via primary DMA stream head pointer.
  */
 
-#define SET_AGE( age, h, w )						\
+#define SET_AGE(age, h, w)						\
 do {									\
 	(age)->head = h;						\
 	(age)->wrap = w;						\
 } while (0)
 
-#define TEST_AGE( age, h, w )		( (age)->wrap < w ||		\
-					  ( (age)->wrap == w &&		\
-					    (age)->head < h ) )
+#define TEST_AGE(age, h, w)		((age)->wrap < w ||		\
+					 ((age)->wrap == w &&		\
+					  (age)->head < h))
 
-#define AGE_BUFFER( buf_priv )						\
+#define AGE_BUFFER(buf_priv)						\
 do {									\
 	drm_mga_freelist_t *entry = (buf_priv)->list_entry;		\
-	if ( (buf_priv)->dispatched ) {					\
+	if ((buf_priv)->dispatched) {					\
 		entry->age.head = (dev_priv->prim.tail +		\
 				   dev_priv->primary->offset);		\
 		entry->age.wrap = dev_priv->sarea_priv->last_wrap;	\
@@ -681,7 +676,7 @@ do {									\
 
 /* Simple idle test.
  */
-static __inline__ int mga_is_idle(drm_mga_private_t * dev_priv)
+static __inline__ int mga_is_idle(drm_mga_private_t *dev_priv)
 {
 	u32 status = MGA_READ(MGA_STATUS) & MGA_ENGINE_IDLE_MASK;
 	return (status == MGA_ENDPRDMASTS);
diff --git a/drivers/gpu/drm/mga/mga_irq.c b/drivers/gpu/drm/mga/mga_irq.c
index daa6041..2581202 100644
--- a/drivers/gpu/drm/mga/mga_irq.c
+++ b/drivers/gpu/drm/mga/mga_irq.c
@@ -76,9 +76,8 @@ irqreturn_t mga_driver_irq_handler(DRM_IRQ_ARGS)
 		/* In addition to clearing the interrupt-pending bit, we
 		 * have to write to MGA_PRIMEND to re-start the DMA operation.
 		 */
-		if ((prim_start & ~0x03) != (prim_end & ~0x03)) {
+		if ((prim_start & ~0x03) != (prim_end & ~0x03))
 			MGA_WRITE(MGA_PRIMEND, prim_end);
-		}
 
 		atomic_inc(&dev_priv->last_fence_retired);
 		DRM_WAKEUP(&dev_priv->fence_queue);
@@ -120,7 +119,7 @@ void mga_disable_vblank(struct drm_device *dev, int crtc)
 	/* MGA_WRITE(MGA_IEN, MGA_VLINEIEN | MGA_SOFTRAPEN); */
 }
 
-int mga_driver_fence_wait(struct drm_device * dev, unsigned int *sequence)
+int mga_driver_fence_wait(struct drm_device *dev, unsigned int *sequence)
 {
 	drm_mga_private_t *dev_priv = (drm_mga_private_t *) dev->dev_private;
 	unsigned int cur_fence;
@@ -139,7 +138,7 @@ int mga_driver_fence_wait(struct drm_device * dev, unsigned int *sequence)
 	return ret;
 }
 
-void mga_driver_irq_preinstall(struct drm_device * dev)
+void mga_driver_irq_preinstall(struct drm_device *dev)
 {
 	drm_mga_private_t *dev_priv = (drm_mga_private_t *) dev->dev_private;
 
@@ -162,7 +161,7 @@ int mga_driver_irq_postinstall(struct drm_device *dev)
 	return 0;
 }
 
-void mga_driver_irq_uninstall(struct drm_device * dev)
+void mga_driver_irq_uninstall(struct drm_device *dev)
 {
 	drm_mga_private_t *dev_priv = (drm_mga_private_t *) dev->dev_private;
 	if (!dev_priv)
diff --git a/drivers/gpu/drm/mga/mga_state.c b/drivers/gpu/drm/mga/mga_state.c
index a53b848..fff8204 100644
--- a/drivers/gpu/drm/mga/mga_state.c
+++ b/drivers/gpu/drm/mga/mga_state.c
@@ -41,8 +41,8 @@
  * DMA hardware state programming functions
  */
 
-static void mga_emit_clip_rect(drm_mga_private_t * dev_priv,
-			       struct drm_clip_rect * box)
+static void mga_emit_clip_rect(drm_mga_private_t *dev_priv,
+			       struct drm_clip_rect *box)
 {
 	drm_mga_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_mga_context_regs_t *ctx = &sarea_priv->context_state;
@@ -66,7 +66,7 @@ static void mga_emit_clip_rect(drm_mga_private_t * dev_priv,
 	ADVANCE_DMA();
 }
 
-static __inline__ void mga_g200_emit_context(drm_mga_private_t * dev_priv)
+static __inline__ void mga_g200_emit_context(drm_mga_private_t *dev_priv)
 {
 	drm_mga_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_mga_context_regs_t *ctx = &sarea_priv->context_state;
@@ -89,7 +89,7 @@ static __inline__ void mga_g200_emit_context(drm_mga_private_t * dev_priv)
 	ADVANCE_DMA();
 }
 
-static __inline__ void mga_g400_emit_context(drm_mga_private_t * dev_priv)
+static __inline__ void mga_g400_emit_context(drm_mga_private_t *dev_priv)
 {
 	drm_mga_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_mga_context_regs_t *ctx = &sarea_priv->context_state;
@@ -116,7 +116,7 @@ static __inline__ void mga_g400_emit_context(drm_mga_private_t * dev_priv)
 	ADVANCE_DMA();
 }
 
-static __inline__ void mga_g200_emit_tex0(drm_mga_private_t * dev_priv)
+static __inline__ void mga_g200_emit_tex0(drm_mga_private_t *dev_priv)
 {
 	drm_mga_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_mga_texture_regs_t *tex = &sarea_priv->tex_state[0];
@@ -144,7 +144,7 @@ static __inline__ void mga_g200_emit_tex0(drm_mga_private_t * dev_priv)
 	ADVANCE_DMA();
 }
 
-static __inline__ void mga_g400_emit_tex0(drm_mga_private_t * dev_priv)
+static __inline__ void mga_g400_emit_tex0(drm_mga_private_t *dev_priv)
 {
 	drm_mga_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_mga_texture_regs_t *tex = &sarea_priv->tex_state[0];
@@ -184,7 +184,7 @@ static __inline__ void mga_g400_emit_tex0(drm_mga_private_t * dev_priv)
 	ADVANCE_DMA();
 }
 
-static __inline__ void mga_g400_emit_tex1(drm_mga_private_t * dev_priv)
+static __inline__ void mga_g400_emit_tex1(drm_mga_private_t *dev_priv)
 {
 	drm_mga_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_mga_texture_regs_t *tex = &sarea_priv->tex_state[1];
@@ -223,7 +223,7 @@ static __inline__ void mga_g400_emit_tex1(drm_mga_private_t * dev_priv)
 	ADVANCE_DMA();
 }
 
-static __inline__ void mga_g200_emit_pipe(drm_mga_private_t * dev_priv)
+static __inline__ void mga_g200_emit_pipe(drm_mga_private_t *dev_priv)
 {
 	drm_mga_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	unsigned int pipe = sarea_priv->warp_pipe;
@@ -250,7 +250,7 @@ static __inline__ void mga_g200_emit_pipe(drm_mga_private_t * dev_priv)
 	ADVANCE_DMA();
 }
 
-static __inline__ void mga_g400_emit_pipe(drm_mga_private_t * dev_priv)
+static __inline__ void mga_g400_emit_pipe(drm_mga_private_t *dev_priv)
 {
 	drm_mga_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	unsigned int pipe = sarea_priv->warp_pipe;
@@ -327,7 +327,7 @@ static __inline__ void mga_g400_emit_pipe(drm_mga_private_t * dev_priv)
 	ADVANCE_DMA();
 }
 
-static void mga_g200_emit_state(drm_mga_private_t * dev_priv)
+static void mga_g200_emit_state(drm_mga_private_t *dev_priv)
 {
 	drm_mga_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	unsigned int dirty = sarea_priv->dirty;
@@ -348,7 +348,7 @@ static void mga_g200_emit_state(drm_mga_private_t * dev_priv)
 	}
 }
 
-static void mga_g400_emit_state(drm_mga_private_t * dev_priv)
+static void mga_g400_emit_state(drm_mga_private_t *dev_priv)
 {
 	drm_mga_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	unsigned int dirty = sarea_priv->dirty;
@@ -381,7 +381,7 @@ static void mga_g400_emit_state(drm_mga_private_t * dev_priv)
 
 /* Disallow all write destinations except the front and backbuffer.
  */
-static int mga_verify_context(drm_mga_private_t * dev_priv)
+static int mga_verify_context(drm_mga_private_t *dev_priv)
 {
 	drm_mga_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_mga_context_regs_t *ctx = &sarea_priv->context_state;
@@ -400,7 +400,7 @@ static int mga_verify_context(drm_mga_private_t * dev_priv)
 
 /* Disallow texture reads from PCI space.
  */
-static int mga_verify_tex(drm_mga_private_t * dev_priv, int unit)
+static int mga_verify_tex(drm_mga_private_t *dev_priv, int unit)
 {
 	drm_mga_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_mga_texture_regs_t *tex = &sarea_priv->tex_state[unit];
@@ -417,7 +417,7 @@ static int mga_verify_tex(drm_mga_private_t * dev_priv, int unit)
 	return 0;
 }
 
-static int mga_verify_state(drm_mga_private_t * dev_priv)
+static int mga_verify_state(drm_mga_private_t *dev_priv)
 {
 	drm_mga_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	unsigned int dirty = sarea_priv->dirty;
@@ -446,7 +446,7 @@ static int mga_verify_state(drm_mga_private_t * dev_priv)
 	return (ret == 0);
 }
 
-static int mga_verify_iload(drm_mga_private_t * dev_priv,
+static int mga_verify_iload(drm_mga_private_t *dev_priv,
 			    unsigned int dstorg, unsigned int length)
 {
 	if (dstorg < dev_priv->texture_offset ||
@@ -465,7 +465,7 @@ static int mga_verify_iload(drm_mga_private_t * dev_priv,
 	return 0;
 }
 
-static int mga_verify_blit(drm_mga_private_t * dev_priv,
+static int mga_verify_blit(drm_mga_private_t *dev_priv,
 			   unsigned int srcorg, unsigned int dstorg)
 {
 	if ((srcorg & 0x3) == (MGA_SRCACC_PCI | MGA_SRCMAP_SYSMEM) ||
@@ -480,7 +480,7 @@ static int mga_verify_blit(drm_mga_private_t * dev_priv,
  *
  */
 
-static void mga_dma_dispatch_clear(struct drm_device * dev, drm_mga_clear_t * clear)
+static void mga_dma_dispatch_clear(struct drm_device *dev, drm_mga_clear_t *clear)
 {
 	drm_mga_private_t *dev_priv = dev->dev_private;
 	drm_mga_sarea_t *sarea_priv = dev_priv->sarea_priv;
@@ -568,7 +568,7 @@ static void mga_dma_dispatch_clear(struct drm_device * dev, drm_mga_clear_t * cl
 	FLUSH_DMA();
 }
 
-static void mga_dma_dispatch_swap(struct drm_device * dev)
+static void mga_dma_dispatch_swap(struct drm_device *dev)
 {
 	drm_mga_private_t *dev_priv = dev->dev_private;
 	drm_mga_sarea_t *sarea_priv = dev_priv->sarea_priv;
@@ -622,7 +622,7 @@ static void mga_dma_dispatch_swap(struct drm_device * dev)
 	DRM_DEBUG("... done.\n");
 }
 
-static void mga_dma_dispatch_vertex(struct drm_device * dev, struct drm_buf * buf)
+static void mga_dma_dispatch_vertex(struct drm_device *dev, struct drm_buf *buf)
 {
 	drm_mga_private_t *dev_priv = dev->dev_private;
 	drm_mga_buf_priv_t *buf_priv = buf->dev_private;
@@ -669,7 +669,7 @@ static void mga_dma_dispatch_vertex(struct drm_device * dev, struct drm_buf * bu
 	FLUSH_DMA();
 }
 
-static void mga_dma_dispatch_indices(struct drm_device * dev, struct drm_buf * buf,
+static void mga_dma_dispatch_indices(struct drm_device *dev, struct drm_buf *buf,
 				     unsigned int start, unsigned int end)
 {
 	drm_mga_private_t *dev_priv = dev->dev_private;
@@ -718,7 +718,7 @@ static void mga_dma_dispatch_indices(struct drm_device * dev, struct drm_buf * b
 /* This copies a 64 byte aligned agp region to the frambuffer with a
  * standard blit, the ioctl needs to do checking.
  */
-static void mga_dma_dispatch_iload(struct drm_device * dev, struct drm_buf * buf,
+static void mga_dma_dispatch_iload(struct drm_device *dev, struct drm_buf *buf,
 				   unsigned int dstorg, unsigned int length)
 {
 	drm_mga_private_t *dev_priv = dev->dev_private;
@@ -766,7 +766,7 @@ static void mga_dma_dispatch_iload(struct drm_device * dev, struct drm_buf * buf
 	FLUSH_DMA();
 }
 
-static void mga_dma_dispatch_blit(struct drm_device * dev, drm_mga_blit_t * blit)
+static void mga_dma_dispatch_blit(struct drm_device *dev, drm_mga_blit_t *blit)
 {
 	drm_mga_private_t *dev_priv = dev->dev_private;
 	drm_mga_sarea_t *sarea_priv = dev_priv->sarea_priv;
@@ -801,9 +801,8 @@ static void mga_dma_dispatch_blit(struct drm_device * dev, drm_mga_blit_t * blit
 		int w = pbox[i].x2 - pbox[i].x1 - 1;
 		int start;
 
-		if (blit->ydir == -1) {
+		if (blit->ydir == -1)
 			srcy = blit->height - srcy - 1;
-		}
 
 		start = srcy * blit->src_pitch + srcx;
 
diff --git a/drivers/gpu/drm/mga/mga_warp.c b/drivers/gpu/drm/mga/mga_warp.c
index 9aad484..f172bd5 100644
--- a/drivers/gpu/drm/mga/mga_warp.c
+++ b/drivers/gpu/drm/mga/mga_warp.c
@@ -46,7 +46,7 @@ MODULE_FIRMWARE(FIRMWARE_G400);
 
 #define WARP_UCODE_SIZE(size)		ALIGN(size, MGA_WARP_CODE_ALIGN)
 
-int mga_warp_install_microcode(drm_mga_private_t * dev_priv)
+int mga_warp_install_microcode(drm_mga_private_t *dev_priv)
 {
 	unsigned char *vcbase = dev_priv->warp->handle;
 	unsigned long pcbase = dev_priv->warp->offset;
@@ -133,7 +133,7 @@ out:
 
 #define WMISC_EXPECTED		(MGA_WUCODECACHE_ENABLE | MGA_WMASTER_ENABLE)
 
-int mga_warp_init(drm_mga_private_t * dev_priv)
+int mga_warp_init(drm_mga_private_t *dev_priv)
 {
 	u32 wmisc;
 
-- 
1.7.1
