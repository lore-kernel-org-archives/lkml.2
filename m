Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab0GNWSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:18:37 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:57087 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757019Ab0GNWSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:18:36 -0400
Date: Thu, 15 Jul 2010 00:14:43 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/i830: fixed brace and spacing coding style issues
Message-ID: <20100715001443.1df2e67a@absol.kitzblitz>
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

Fixed brace and spacing coding style issues.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/gpu/drm/i830/i830_dma.c |   95 ++++++++++++++++++---------------------
 drivers/gpu/drm/i830/i830_drv.h |   48 ++++++++++---------
 drivers/gpu/drm/i830/i830_irq.c |   10 ++--
 3 files changed, 74 insertions(+), 79 deletions(-)

diff --git a/drivers/gpu/drm/i830/i830_dma.c b/drivers/gpu/drm/i830/i830_dma.c
index 65759a9..7ee85ea 100644
--- a/drivers/gpu/drm/i830/i830_dma.c
+++ b/drivers/gpu/drm/i830/i830_dma.c
@@ -62,9 +62,8 @@ static struct drm_buf *i830_freelist_get(struct drm_device * dev)
 		/* In use is already a pointer */
 		used = cmpxchg(buf_priv->in_use, I830_BUF_FREE,
 			       I830_BUF_CLIENT);
-		if (used == I830_BUF_FREE) {
+		if (used == I830_BUF_FREE)
 			return buf;
-		}
 	}
 	return NULL;
 }
@@ -73,7 +72,7 @@ static struct drm_buf *i830_freelist_get(struct drm_device * dev)
  * yet, the hardware updates in use for us once its on the ring buffer.
  */
 
-static int i830_freelist_put(struct drm_device * dev, struct drm_buf * buf)
+static int i830_freelist_put(struct drm_device *dev, struct drm_buf *buf)
 {
 	drm_i830_buf_priv_t *buf_priv = buf->dev_private;
 	int used;
@@ -123,7 +122,7 @@ static const struct file_operations i830_buffer_fops = {
 	.fasync = drm_fasync,
 };
 
-static int i830_map_buffer(struct drm_buf * buf, struct drm_file *file_priv)
+static int i830_map_buffer(struct drm_buf *buf, struct drm_file *file_priv)
 {
 	struct drm_device *dev = file_priv->minor->dev;
 	drm_i830_buf_priv_t *buf_priv = buf->dev_private;
@@ -156,7 +155,7 @@ static int i830_map_buffer(struct drm_buf * buf, struct drm_file *file_priv)
 	return retcode;
 }
 
-static int i830_unmap_buffer(struct drm_buf * buf)
+static int i830_unmap_buffer(struct drm_buf *buf)
 {
 	drm_i830_buf_priv_t *buf_priv = buf->dev_private;
 	int retcode = 0;
@@ -176,7 +175,7 @@ static int i830_unmap_buffer(struct drm_buf * buf)
 	return retcode;
 }
 
-static int i830_dma_get_buffer(struct drm_device * dev, drm_i830_dma_t * d,
+static int i830_dma_get_buffer(struct drm_device *dev, drm_i830_dma_t *d,
 			       struct drm_file *file_priv)
 {
 	struct drm_buf *buf;
@@ -206,7 +205,7 @@ static int i830_dma_get_buffer(struct drm_device * dev, drm_i830_dma_t * d,
 	return retcode;
 }
 
-static int i830_dma_cleanup(struct drm_device * dev)
+static int i830_dma_cleanup(struct drm_device *dev)
 {
 	struct drm_device_dma *dma = dev->dma;
 
@@ -222,9 +221,8 @@ static int i830_dma_cleanup(struct drm_device * dev)
 		drm_i830_private_t *dev_priv =
 		    (drm_i830_private_t *) dev->dev_private;
 
-		if (dev_priv->ring.virtual_start) {
+		if (dev_priv->ring.virtual_start)
 			drm_core_ioremapfree(&dev_priv->ring.map, dev);
-		}
 		if (dev_priv->hw_status_page) {
 			pci_free_consistent(dev->pdev, PAGE_SIZE,
 					    dev_priv->hw_status_page,
@@ -246,7 +244,7 @@ static int i830_dma_cleanup(struct drm_device * dev)
 	return 0;
 }
 
-int i830_wait_ring(struct drm_device * dev, int n, const char *caller)
+int i830_wait_ring(struct drm_device *dev, int n, const char *caller)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 	drm_i830_ring_buffer_t *ring = &(dev_priv->ring);
@@ -276,11 +274,11 @@ int i830_wait_ring(struct drm_device * dev, int n, const char *caller)
 		dev_priv->sarea_priv->perf_boxes |= I830_BOX_WAIT;
 	}
 
-      out_wait_ring:
+out_wait_ring:
 	return iters;
 }
 
-static void i830_kernel_lost_context(struct drm_device * dev)
+static void i830_kernel_lost_context(struct drm_device *dev)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 	drm_i830_ring_buffer_t *ring = &(dev_priv->ring);
@@ -295,7 +293,7 @@ static void i830_kernel_lost_context(struct drm_device * dev)
 		dev_priv->sarea_priv->perf_boxes |= I830_BOX_RING_EMPTY;
 }
 
-static int i830_freelist_init(struct drm_device * dev, drm_i830_private_t * dev_priv)
+static int i830_freelist_init(struct drm_device *dev, drm_i830_private_t *dev_priv)
 {
 	struct drm_device_dma *dma = dev->dma;
 	int my_idx = 36;
@@ -329,9 +327,9 @@ static int i830_freelist_init(struct drm_device * dev, drm_i830_private_t * dev_
 	return 0;
 }
 
-static int i830_dma_initialize(struct drm_device * dev,
-			       drm_i830_private_t * dev_priv,
-			       drm_i830_init_t * init)
+static int i830_dma_initialize(struct drm_device *dev,
+			       drm_i830_private_t *dev_priv,
+			       drm_i830_init_t *init)
 {
 	struct drm_map_list *r_list;
 
@@ -482,7 +480,7 @@ static int i830_dma_init(struct drm_device *dev, void *data,
 /* Most efficient way to verify state for the i830 is as it is
  * emitted.  Non-conformant state is silently dropped.
  */
-static void i830EmitContextVerified(struct drm_device * dev, unsigned int *code)
+static void i830EmitContextVerified(struct drm_device *dev, unsigned int *code)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 	int i, j = 0;
@@ -527,7 +525,7 @@ static void i830EmitContextVerified(struct drm_device * dev, unsigned int *code)
 	ADVANCE_LP_RING();
 }
 
-static void i830EmitTexVerified(struct drm_device * dev, unsigned int *code)
+static void i830EmitTexVerified(struct drm_device *dev, unsigned int *code)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 	int i, j = 0;
@@ -561,7 +559,7 @@ static void i830EmitTexVerified(struct drm_device * dev, unsigned int *code)
 		printk("rejected packet %x\n", code[0]);
 }
 
-static void i830EmitTexBlendVerified(struct drm_device * dev,
+static void i830EmitTexBlendVerified(struct drm_device *dev,
 				     unsigned int *code, unsigned int num)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
@@ -586,7 +584,7 @@ static void i830EmitTexBlendVerified(struct drm_device * dev,
 	ADVANCE_LP_RING();
 }
 
-static void i830EmitTexPalette(struct drm_device * dev,
+static void i830EmitTexPalette(struct drm_device *dev,
 			       unsigned int *palette, int number, int is_shared)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
@@ -603,9 +601,8 @@ static void i830EmitTexPalette(struct drm_device * dev,
 	} else {
 		OUT_RING(CMD_OP_MAP_PALETTE_LOAD | MAP_PALETTE_NUM(number));
 	}
-	for (i = 0; i < 256; i++) {
+	for (i = 0; i < 256; i++)
 		OUT_RING(palette[i]);
-	}
 	OUT_RING(0);
 	/* KW:  WHERE IS THE ADVANCE_LP_RING?  This is effectively a noop!
 	 */
@@ -613,7 +610,7 @@ static void i830EmitTexPalette(struct drm_device * dev,
 
 /* Need to do some additional checking when setting the dest buffer.
  */
-static void i830EmitDestVerified(struct drm_device * dev, unsigned int *code)
+static void i830EmitDestVerified(struct drm_device *dev, unsigned int *code)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 	unsigned int tmp;
@@ -674,7 +671,7 @@ static void i830EmitDestVerified(struct drm_device * dev, unsigned int *code)
 	ADVANCE_LP_RING();
 }
 
-static void i830EmitStippleVerified(struct drm_device * dev, unsigned int *code)
+static void i830EmitStippleVerified(struct drm_device *dev, unsigned int *code)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 	RING_LOCALS;
@@ -685,7 +682,7 @@ static void i830EmitStippleVerified(struct drm_device * dev, unsigned int *code)
 	ADVANCE_LP_RING();
 }
 
-static void i830EmitState(struct drm_device * dev)
+static void i830EmitState(struct drm_device *dev)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 	drm_i830_sarea_t *sarea_priv = dev_priv->sarea_priv;
@@ -788,7 +785,7 @@ static void i830EmitState(struct drm_device * dev)
  * Performance monitoring functions
  */
 
-static void i830_fill_box(struct drm_device * dev,
+static void i830_fill_box(struct drm_device *dev,
 			  int x, int y, int w, int h, int r, int g, int b)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
@@ -816,17 +813,16 @@ static void i830_fill_box(struct drm_device * dev,
 	OUT_RING((y << 16) | x);
 	OUT_RING(((y + h) << 16) | (x + w));
 
-	if (dev_priv->current_page == 1) {
+	if (dev_priv->current_page == 1)
 		OUT_RING(dev_priv->front_offset);
-	} else {
+	else
 		OUT_RING(dev_priv->back_offset);
-	}
 
 	OUT_RING(color);
 	ADVANCE_LP_RING();
 }
 
-static void i830_cp_performance_boxes(struct drm_device * dev)
+static void i830_cp_performance_boxes(struct drm_device *dev)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 
@@ -871,7 +867,7 @@ static void i830_cp_performance_boxes(struct drm_device * dev)
 	dev_priv->sarea_priv->perf_boxes = 0;
 }
 
-static void i830_dma_dispatch_clear(struct drm_device * dev, int flags,
+static void i830_dma_dispatch_clear(struct drm_device *dev, int flags,
 				    unsigned int clear_color,
 				    unsigned int clear_zval,
 				    unsigned int clear_depthmask)
@@ -966,7 +962,7 @@ static void i830_dma_dispatch_clear(struct drm_device * dev, int flags,
 	}
 }
 
-static void i830_dma_dispatch_swap(struct drm_device * dev)
+static void i830_dma_dispatch_swap(struct drm_device *dev)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 	drm_i830_sarea_t *sarea_priv = dev_priv->sarea_priv;
@@ -1036,7 +1032,7 @@ static void i830_dma_dispatch_swap(struct drm_device * dev)
 	}
 }
 
-static void i830_dma_dispatch_flip(struct drm_device * dev)
+static void i830_dma_dispatch_flip(struct drm_device *dev)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 	RING_LOCALS;
@@ -1079,8 +1075,8 @@ static void i830_dma_dispatch_flip(struct drm_device * dev)
 	dev_priv->sarea_priv->pf_current_page = dev_priv->current_page;
 }
 
-static void i830_dma_dispatch_vertex(struct drm_device * dev,
-				     struct drm_buf * buf, int discard, int used)
+static void i830_dma_dispatch_vertex(struct drm_device *dev,
+				     struct drm_buf *buf, int discard, int used)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 	drm_i830_buf_priv_t *buf_priv = buf->dev_private;
@@ -1100,9 +1096,8 @@ static void i830_dma_dispatch_vertex(struct drm_device * dev,
 	if (discard) {
 		u = cmpxchg(buf_priv->in_use, I830_BUF_CLIENT,
 			    I830_BUF_HARDWARE);
-		if (u != I830_BUF_CLIENT) {
+		if (u != I830_BUF_CLIENT)
 			DRM_DEBUG("xxxx 2\n");
-		}
 	}
 
 	if (used > 4 * 1023)
@@ -1191,7 +1186,7 @@ static void i830_dma_dispatch_vertex(struct drm_device * dev,
 	}
 }
 
-static void i830_dma_quiescent(struct drm_device * dev)
+static void i830_dma_quiescent(struct drm_device *dev)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 	RING_LOCALS;
@@ -1208,7 +1203,7 @@ static void i830_dma_quiescent(struct drm_device * dev)
 	i830_wait_ring(dev, dev_priv->ring.Size - 8, __func__);
 }
 
-static int i830_flush_queue(struct drm_device * dev)
+static int i830_flush_queue(struct drm_device *dev)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 	struct drm_device_dma *dma = dev->dma;
@@ -1241,7 +1236,7 @@ static int i830_flush_queue(struct drm_device * dev)
 }
 
 /* Must be called with the lock held */
-static void i830_reclaim_buffers(struct drm_device * dev, struct drm_file *file_priv)
+static void i830_reclaim_buffers(struct drm_device *dev, struct drm_file *file_priv)
 {
 	struct drm_device_dma *dma = dev->dma;
 	int i;
@@ -1316,9 +1311,8 @@ static int i830_clear_bufs(struct drm_device *dev, void *data,
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
 	/* GH: Someone's doing nasty things... */
-	if (!dev->dev_private) {
+	if (!dev->dev_private)
 		return -EINVAL;
-	}
 
 	i830_dma_dispatch_clear(dev, clear->flags,
 				clear->clear_color,
@@ -1339,7 +1333,7 @@ static int i830_swap_bufs(struct drm_device *dev, void *data,
 
 /* Not sure why this isn't set all the time:
  */
-static void i830_do_init_pageflip(struct drm_device * dev)
+static void i830_do_init_pageflip(struct drm_device *dev)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 
@@ -1349,7 +1343,7 @@ static void i830_do_init_pageflip(struct drm_device * dev)
 	dev_priv->sarea_priv->pf_current_page = dev_priv->current_page;
 }
 
-static int i830_do_cleanup_pageflip(struct drm_device * dev)
+static int i830_do_cleanup_pageflip(struct drm_device *dev)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 
@@ -1490,27 +1484,26 @@ int i830_driver_load(struct drm_device *dev, unsigned long flags)
 	return 0;
 }
 
-void i830_driver_lastclose(struct drm_device * dev)
+void i830_driver_lastclose(struct drm_device *dev)
 {
 	i830_dma_cleanup(dev);
 }
 
-void i830_driver_preclose(struct drm_device * dev, struct drm_file *file_priv)
+void i830_driver_preclose(struct drm_device *dev, struct drm_file *file_priv)
 {
 	if (dev->dev_private) {
 		drm_i830_private_t *dev_priv = dev->dev_private;
-		if (dev_priv->page_flipping) {
+		if (dev_priv->page_flipping)
 			i830_do_cleanup_pageflip(dev);
-		}
 	}
 }
 
-void i830_driver_reclaim_buffers_locked(struct drm_device * dev, struct drm_file *file_priv)
+void i830_driver_reclaim_buffers_locked(struct drm_device *dev, struct drm_file *file_priv)
 {
 	i830_reclaim_buffers(dev, file_priv);
 }
 
-int i830_driver_dma_quiescent(struct drm_device * dev)
+int i830_driver_dma_quiescent(struct drm_device *dev)
 {
 	i830_dma_quiescent(dev);
 	return 0;
@@ -1546,7 +1539,7 @@ int i830_max_ioctl = DRM_ARRAY_SIZE(i830_ioctls);
  * \returns
  * A value of 1 is always retured to indictate every i8xx is AGP.
  */
-int i830_driver_device_is_agp(struct drm_device * dev)
+int i830_driver_device_is_agp(struct drm_device *dev)
 {
 	return 1;
 }
diff --git a/drivers/gpu/drm/i830/i830_drv.h b/drivers/gpu/drm/i830/i830_drv.h
index da82afe..ecfd25a 100644
--- a/drivers/gpu/drm/i830/i830_drv.h
+++ b/drivers/gpu/drm/i830/i830_drv.h
@@ -132,33 +132,33 @@ extern int i830_irq_wait(struct drm_device *dev, void *data,
 			 struct drm_file *file_priv);
 
 extern irqreturn_t i830_driver_irq_handler(DRM_IRQ_ARGS);
-extern void i830_driver_irq_preinstall(struct drm_device * dev);
-extern void i830_driver_irq_postinstall(struct drm_device * dev);
-extern void i830_driver_irq_uninstall(struct drm_device * dev);
+extern void i830_driver_irq_preinstall(struct drm_device *dev);
+extern void i830_driver_irq_postinstall(struct drm_device *dev);
+extern void i830_driver_irq_uninstall(struct drm_device *dev);
 extern int i830_driver_load(struct drm_device *, unsigned long flags);
-extern void i830_driver_preclose(struct drm_device * dev,
+extern void i830_driver_preclose(struct drm_device *dev,
 				 struct drm_file *file_priv);
-extern void i830_driver_lastclose(struct drm_device * dev);
-extern void i830_driver_reclaim_buffers_locked(struct drm_device * dev,
+extern void i830_driver_lastclose(struct drm_device *dev);
+extern void i830_driver_reclaim_buffers_locked(struct drm_device *dev,
 					       struct drm_file *file_priv);
-extern int i830_driver_dma_quiescent(struct drm_device * dev);
-extern int i830_driver_device_is_agp(struct drm_device * dev);
+extern int i830_driver_dma_quiescent(struct drm_device *dev);
+extern int i830_driver_device_is_agp(struct drm_device *dev);
 
-#define I830_READ(reg)          DRM_READ32(dev_priv->mmio_map, reg)
-#define I830_WRITE(reg,val)     DRM_WRITE32(dev_priv->mmio_map, reg, val)
-#define I830_READ16(reg)        DRM_READ16(dev_priv->mmio_map, reg)
-#define I830_WRITE16(reg,val)   DRM_WRITE16(dev_priv->mmio_map, reg, val)
+#define I830_READ(reg)		DRM_READ32(dev_priv->mmio_map, reg)
+#define I830_WRITE(reg, val)	DRM_WRITE32(dev_priv->mmio_map, reg, val)
+#define I830_READ16(reg)	DRM_READ16(dev_priv->mmio_map, reg)
+#define I830_WRITE16(reg, val)	DRM_WRITE16(dev_priv->mmio_map, reg, val)
 
 #define I830_VERBOSE 0
 
 #define RING_LOCALS	unsigned int outring, ringmask, outcount; \
-                        volatile char *virt;
+			volatile char *virt;
 
 #define BEGIN_LP_RING(n) do {				\
 	if (I830_VERBOSE)				\
 		printk("BEGIN_LP_RING(%d)\n", (n));	\
 	if (dev_priv->ring.space < n*4)			\
-		i830_wait_ring(dev, n*4, __func__);		\
+		i830_wait_ring(dev, n*4, __func__);	\
 	outcount = 0;					\
 	outring = dev_priv->ring.tail;			\
 	ringmask = dev_priv->ring.tail_mask;		\
@@ -166,21 +166,23 @@ extern int i830_driver_device_is_agp(struct drm_device * dev);
 } while (0)
 
 #define OUT_RING(n) do {					\
-	if (I830_VERBOSE) printk("   OUT_RING %x\n", (int)(n));	\
+	if (I830_VERBOSE)					\
+		printk("   OUT_RING %x\n", (int)(n));		\
 	*(volatile unsigned int *)(virt + outring) = n;		\
-        outcount++;						\
+	outcount++;						\
 	outring += 4;						\
 	outring &= ringmask;					\
 } while (0)
 
-#define ADVANCE_LP_RING() do {						\
-	if (I830_VERBOSE) printk("ADVANCE_LP_RING %x\n", outring);	\
-	dev_priv->ring.tail = outring;					\
-	dev_priv->ring.space -= outcount * 4;				\
-	I830_WRITE(LP_RING + RING_TAIL, outring);			\
-} while(0)
+#define ADVANCE_LP_RING() do {					\
+	if (I830_VERBOSE)					\
+		printk("ADVANCE_LP_RING %x\n", outring);	\
+	dev_priv->ring.tail = outring;				\
+	dev_priv->ring.space -= outcount * 4;			\
+	I830_WRITE(LP_RING + RING_TAIL, outring);		\
+} while (0)
 
-extern int i830_wait_ring(struct drm_device * dev, int n, const char *caller);
+extern int i830_wait_ring(struct drm_device *dev, int n, const char *caller);
 
 #define GFX_OP_USER_INTERRUPT		((0<<29)|(2<<23))
 #define GFX_OP_BREAKPOINT_INTERRUPT	((0<<29)|(1<<23))
diff --git a/drivers/gpu/drm/i830/i830_irq.c b/drivers/gpu/drm/i830/i830_irq.c
index 91ec2bb..d1a6b95 100644
--- a/drivers/gpu/drm/i830/i830_irq.c
+++ b/drivers/gpu/drm/i830/i830_irq.c
@@ -53,7 +53,7 @@ irqreturn_t i830_driver_irq_handler(DRM_IRQ_ARGS)
 	return IRQ_HANDLED;
 }
 
-static int i830_emit_irq(struct drm_device * dev)
+static int i830_emit_irq(struct drm_device *dev)
 {
 	drm_i830_private_t *dev_priv = dev->dev_private;
 	RING_LOCALS;
@@ -70,7 +70,7 @@ static int i830_emit_irq(struct drm_device * dev)
 	return atomic_read(&dev_priv->irq_emitted);
 }
 
-static int i830_wait_irq(struct drm_device * dev, int irq_nr)
+static int i830_wait_irq(struct drm_device *dev, int irq_nr)
 {
 	drm_i830_private_t *dev_priv = (drm_i830_private_t *) dev->dev_private;
 	DECLARE_WAITQUEUE(entry, current);
@@ -156,7 +156,7 @@ int i830_irq_wait(struct drm_device *dev, void *data,
 
 /* drm_dma.h hooks
 */
-void i830_driver_irq_preinstall(struct drm_device * dev)
+void i830_driver_irq_preinstall(struct drm_device *dev)
 {
 	drm_i830_private_t *dev_priv = (drm_i830_private_t *) dev->dev_private;
 
@@ -168,14 +168,14 @@ void i830_driver_irq_preinstall(struct drm_device * dev)
 	init_waitqueue_head(&dev_priv->irq_queue);
 }
 
-void i830_driver_irq_postinstall(struct drm_device * dev)
+void i830_driver_irq_postinstall(struct drm_device *dev)
 {
 	drm_i830_private_t *dev_priv = (drm_i830_private_t *) dev->dev_private;
 
 	I830_WRITE16(I830REG_INT_ENABLE_R, 0x2);
 }
 
-void i830_driver_irq_uninstall(struct drm_device * dev)
+void i830_driver_irq_uninstall(struct drm_device *dev)
 {
 	drm_i830_private_t *dev_priv = (drm_i830_private_t *) dev->dev_private;
 	if (!dev_priv)
-- 
1.7.1
