Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab0GNT4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 15:56:55 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:50778 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754094Ab0GNT4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 15:56:53 -0400
Date: Wed, 14 Jul 2010 21:54:13 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/i810: fixed coding style issues
Message-ID: <20100714215413.6caaf5e9@absol.kitzblitz>
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

Fixed brace, macro and spacing coding style issues, and a C99 comment.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
 drivers/gpu/drm/i810/i810_dma.c |   81 ++++++++++++++++++--------------------
 drivers/gpu/drm/i810/i810_drv.h |   64 ++++++++++++++++---------------
 2 files changed, 71 insertions(+), 74 deletions(-)

diff --git a/drivers/gpu/drm/i810/i810_dma.c b/drivers/gpu/drm/i810/i810_dma.c
index 997d917..09c86ed 100644
--- a/drivers/gpu/drm/i810/i810_dma.c
+++ b/drivers/gpu/drm/i810/i810_dma.c
@@ -60,9 +60,8 @@ static struct drm_buf *i810_freelist_get(struct drm_device * dev)
 		/* In use is already a pointer */
 		used = cmpxchg(buf_priv->in_use, I810_BUF_FREE,
 			       I810_BUF_CLIENT);
-		if (used == I810_BUF_FREE) {
+		if (used == I810_BUF_FREE)
 			return buf;
-		}
 	}
 	return NULL;
 }
@@ -71,7 +70,7 @@ static struct drm_buf *i810_freelist_get(struct drm_device * dev)
  * yet, the hardware updates in use for us once its on the ring buffer.
  */
 
-static int i810_freelist_put(struct drm_device * dev, struct drm_buf * buf)
+static int i810_freelist_put(struct drm_device *dev, struct drm_buf *buf)
 {
 	drm_i810_buf_priv_t *buf_priv = buf->dev_private;
 	int used;
@@ -121,7 +120,7 @@ static const struct file_operations i810_buffer_fops = {
 	.fasync = drm_fasync,
 };
 
-static int i810_map_buffer(struct drm_buf * buf, struct drm_file *file_priv)
+static int i810_map_buffer(struct drm_buf *buf, struct drm_file *file_priv)
 {
 	struct drm_device *dev = file_priv->minor->dev;
 	drm_i810_buf_priv_t *buf_priv = buf->dev_private;
@@ -152,7 +151,7 @@ static int i810_map_buffer(struct drm_buf * buf, struct drm_file *file_priv)
 	return retcode;
 }
 
-static int i810_unmap_buffer(struct drm_buf * buf)
+static int i810_unmap_buffer(struct drm_buf *buf)
 {
 	drm_i810_buf_priv_t *buf_priv = buf->dev_private;
 	int retcode = 0;
@@ -172,7 +171,7 @@ static int i810_unmap_buffer(struct drm_buf * buf)
 	return retcode;
 }
 
-static int i810_dma_get_buffer(struct drm_device * dev, drm_i810_dma_t * d,
+static int i810_dma_get_buffer(struct drm_device *dev, drm_i810_dma_t *d,
 			       struct drm_file *file_priv)
 {
 	struct drm_buf *buf;
@@ -202,7 +201,7 @@ static int i810_dma_get_buffer(struct drm_device * dev, drm_i810_dma_t * d,
 	return retcode;
 }
 
-static int i810_dma_cleanup(struct drm_device * dev)
+static int i810_dma_cleanup(struct drm_device *dev)
 {
 	struct drm_device_dma *dma = dev->dma;
 
@@ -218,9 +217,8 @@ static int i810_dma_cleanup(struct drm_device * dev)
 		drm_i810_private_t *dev_priv =
 		    (drm_i810_private_t *) dev->dev_private;
 
-		if (dev_priv->ring.virtual_start) {
+		if (dev_priv->ring.virtual_start)
 			drm_core_ioremapfree(&dev_priv->ring.map, dev);
-		}
 		if (dev_priv->hw_status_page) {
 			pci_free_consistent(dev->pdev, PAGE_SIZE,
 					    dev_priv->hw_status_page,
@@ -242,7 +240,7 @@ static int i810_dma_cleanup(struct drm_device * dev)
 	return 0;
 }
 
-static int i810_wait_ring(struct drm_device * dev, int n)
+static int i810_wait_ring(struct drm_device *dev, int n)
 {
 	drm_i810_private_t *dev_priv = dev->dev_private;
 	drm_i810_ring_buffer_t *ring = &(dev_priv->ring);
@@ -271,11 +269,11 @@ static int i810_wait_ring(struct drm_device * dev, int n)
 		udelay(1);
 	}
 
-      out_wait_ring:
+out_wait_ring:
 	return iters;
 }
 
-static void i810_kernel_lost_context(struct drm_device * dev)
+static void i810_kernel_lost_context(struct drm_device *dev)
 {
 	drm_i810_private_t *dev_priv = dev->dev_private;
 	drm_i810_ring_buffer_t *ring = &(dev_priv->ring);
@@ -287,7 +285,7 @@ static void i810_kernel_lost_context(struct drm_device * dev)
 		ring->space += ring->Size;
 }
 
-static int i810_freelist_init(struct drm_device * dev, drm_i810_private_t * dev_priv)
+static int i810_freelist_init(struct drm_device *dev, drm_i810_private_t *dev_priv)
 {
 	struct drm_device_dma *dma = dev->dma;
 	int my_idx = 24;
@@ -322,9 +320,9 @@ static int i810_freelist_init(struct drm_device * dev, drm_i810_private_t * dev_
 	return 0;
 }
 
-static int i810_dma_initialize(struct drm_device * dev,
-			       drm_i810_private_t * dev_priv,
-			       drm_i810_init_t * init)
+static int i810_dma_initialize(struct drm_device *dev,
+			       drm_i810_private_t *dev_priv,
+			       drm_i810_init_t *init)
 {
 	struct drm_map_list *r_list;
 	memset(dev_priv, 0, sizeof(drm_i810_private_t));
@@ -462,7 +460,7 @@ static int i810_dma_init(struct drm_device *dev, void *data,
  * Use 'volatile' & local var tmp to force the emitted values to be
  * identical to the verified ones.
  */
-static void i810EmitContextVerified(struct drm_device * dev,
+static void i810EmitContextVerified(struct drm_device *dev,
 				    volatile unsigned int *code)
 {
 	drm_i810_private_t *dev_priv = dev->dev_private;
@@ -495,7 +493,7 @@ static void i810EmitContextVerified(struct drm_device * dev,
 	ADVANCE_LP_RING();
 }
 
-static void i810EmitTexVerified(struct drm_device * dev, volatile unsigned int *code)
+static void i810EmitTexVerified(struct drm_device *dev, volatile unsigned int *code)
 {
 	drm_i810_private_t *dev_priv = dev->dev_private;
 	int i, j = 0;
@@ -528,7 +526,7 @@ static void i810EmitTexVerified(struct drm_device * dev, volatile unsigned int *
 
 /* Need to do some additional checking when setting the dest buffer.
  */
-static void i810EmitDestVerified(struct drm_device * dev,
+static void i810EmitDestVerified(struct drm_device *dev,
 				 volatile unsigned int *code)
 {
 	drm_i810_private_t *dev_priv = dev->dev_private;
@@ -563,7 +561,7 @@ static void i810EmitDestVerified(struct drm_device * dev,
 	ADVANCE_LP_RING();
 }
 
-static void i810EmitState(struct drm_device * dev)
+static void i810EmitState(struct drm_device *dev)
 {
 	drm_i810_private_t *dev_priv = dev->dev_private;
 	drm_i810_sarea_t *sarea_priv = dev_priv->sarea_priv;
@@ -594,7 +592,7 @@ static void i810EmitState(struct drm_device * dev)
 
 /* need to verify
  */
-static void i810_dma_dispatch_clear(struct drm_device * dev, int flags,
+static void i810_dma_dispatch_clear(struct drm_device *dev, int flags,
 				    unsigned int clear_color,
 				    unsigned int clear_zval)
 {
@@ -669,7 +667,7 @@ static void i810_dma_dispatch_clear(struct drm_device * dev, int flags,
 	}
 }
 
-static void i810_dma_dispatch_swap(struct drm_device * dev)
+static void i810_dma_dispatch_swap(struct drm_device *dev)
 {
 	drm_i810_private_t *dev_priv = dev->dev_private;
 	drm_i810_sarea_t *sarea_priv = dev_priv->sarea_priv;
@@ -715,8 +713,8 @@ static void i810_dma_dispatch_swap(struct drm_device * dev)
 	}
 }
 
-static void i810_dma_dispatch_vertex(struct drm_device * dev,
-				     struct drm_buf * buf, int discard, int used)
+static void i810_dma_dispatch_vertex(struct drm_device *dev,
+				     struct drm_buf *buf, int discard, int used)
 {
 	drm_i810_private_t *dev_priv = dev->dev_private;
 	drm_i810_buf_priv_t *buf_priv = buf->dev_private;
@@ -795,7 +793,7 @@ static void i810_dma_dispatch_vertex(struct drm_device * dev,
 	}
 }
 
-static void i810_dma_dispatch_flip(struct drm_device * dev)
+static void i810_dma_dispatch_flip(struct drm_device *dev)
 {
 	drm_i810_private_t *dev_priv = dev->dev_private;
 	int pitch = dev_priv->pitch;
@@ -841,7 +839,7 @@ static void i810_dma_dispatch_flip(struct drm_device * dev)
 
 }
 
-static void i810_dma_quiescent(struct drm_device * dev)
+static void i810_dma_quiescent(struct drm_device *dev)
 {
 	drm_i810_private_t *dev_priv = dev->dev_private;
 	RING_LOCALS;
@@ -858,7 +856,7 @@ static void i810_dma_quiescent(struct drm_device * dev)
 	i810_wait_ring(dev, dev_priv->ring.Size - 8);
 }
 
-static int i810_flush_queue(struct drm_device * dev)
+static int i810_flush_queue(struct drm_device *dev)
 {
 	drm_i810_private_t *dev_priv = dev->dev_private;
 	struct drm_device_dma *dma = dev->dma;
@@ -891,7 +889,7 @@ static int i810_flush_queue(struct drm_device * dev)
 }
 
 /* Must be called with the lock held */
-static void i810_reclaim_buffers(struct drm_device * dev,
+static void i810_reclaim_buffers(struct drm_device *dev,
 				 struct drm_file *file_priv)
 {
 	struct drm_device_dma *dma = dev->dma;
@@ -969,9 +967,8 @@ static int i810_clear_bufs(struct drm_device *dev, void *data,
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
 	/* GH: Someone's doing nasty things... */
-	if (!dev->dev_private) {
+	if (!dev->dev_private)
 		return -EINVAL;
-	}
 
 	i810_dma_dispatch_clear(dev, clear->flags,
 				clear->clear_color, clear->clear_depth);
@@ -1039,7 +1036,7 @@ static int i810_docopy(struct drm_device *dev, void *data,
 	return 0;
 }
 
-static void i810_dma_dispatch_mc(struct drm_device * dev, struct drm_buf * buf, int used,
+static void i810_dma_dispatch_mc(struct drm_device *dev, struct drm_buf *buf, int used,
 				 unsigned int last_render)
 {
 	drm_i810_private_t *dev_priv = dev->dev_private;
@@ -1053,9 +1050,8 @@ static void i810_dma_dispatch_mc(struct drm_device * dev, struct drm_buf * buf,
 	i810_kernel_lost_context(dev);
 
 	u = cmpxchg(buf_priv->in_use, I810_BUF_CLIENT, I810_BUF_HARDWARE);
-	if (u != I810_BUF_CLIENT) {
+	if (u != I810_BUF_CLIENT)
 		DRM_DEBUG("MC found buffer that isn't mine!\n");
-	}
 
 	if (used > 4 * 1024)
 		used = 0;
@@ -1160,7 +1156,7 @@ static int i810_ov0_flip(struct drm_device *dev, void *data,
 
 	LOCK_TEST_WITH_RETURN(dev, file_priv);
 
-	//Tell the overlay to update
+	/* Tell the overlay to update */
 	I810_WRITE(0x30000, dev_priv->overlay_physical | 0x80000000);
 
 	return 0;
@@ -1168,7 +1164,7 @@ static int i810_ov0_flip(struct drm_device *dev, void *data,
 
 /* Not sure why this isn't set all the time:
  */
-static void i810_do_init_pageflip(struct drm_device * dev)
+static void i810_do_init_pageflip(struct drm_device *dev)
 {
 	drm_i810_private_t *dev_priv = dev->dev_private;
 
@@ -1178,7 +1174,7 @@ static void i810_do_init_pageflip(struct drm_device * dev)
 	dev_priv->sarea_priv->pf_current_page = dev_priv->current_page;
 }
 
-static int i810_do_cleanup_pageflip(struct drm_device * dev)
+static int i810_do_cleanup_pageflip(struct drm_device *dev)
 {
 	drm_i810_private_t *dev_priv = dev->dev_private;
 
@@ -1218,28 +1214,27 @@ int i810_driver_load(struct drm_device *dev, unsigned long flags)
 	return 0;
 }
 
-void i810_driver_lastclose(struct drm_device * dev)
+void i810_driver_lastclose(struct drm_device *dev)
 {
 	i810_dma_cleanup(dev);
 }
 
-void i810_driver_preclose(struct drm_device * dev, struct drm_file *file_priv)
+void i810_driver_preclose(struct drm_device *dev, struct drm_file *file_priv)
 {
 	if (dev->dev_private) {
 		drm_i810_private_t *dev_priv = dev->dev_private;
-		if (dev_priv->page_flipping) {
+		if (dev_priv->page_flipping)
 			i810_do_cleanup_pageflip(dev);
-		}
 	}
 }
 
-void i810_driver_reclaim_buffers_locked(struct drm_device * dev,
+void i810_driver_reclaim_buffers_locked(struct drm_device *dev,
 					struct drm_file *file_priv)
 {
 	i810_reclaim_buffers(dev, file_priv);
 }
 
-int i810_driver_dma_quiescent(struct drm_device * dev)
+int i810_driver_dma_quiescent(struct drm_device *dev)
 {
 	i810_dma_quiescent(dev);
 	return 0;
@@ -1276,7 +1271,7 @@ int i810_max_ioctl = DRM_ARRAY_SIZE(i810_ioctls);
  * \returns
  * A value of 1 is always retured to indictate every i810 is AGP.
  */
-int i810_driver_device_is_agp(struct drm_device * dev)
+int i810_driver_device_is_agp(struct drm_device *dev)
 {
 	return 1;
 }
diff --git a/drivers/gpu/drm/i810/i810_drv.h b/drivers/gpu/drm/i810/i810_drv.h
index 21e2691..0743fe9 100644
--- a/drivers/gpu/drm/i810/i810_drv.h
+++ b/drivers/gpu/drm/i810/i810_drv.h
@@ -115,16 +115,16 @@ typedef struct drm_i810_private {
 } drm_i810_private_t;
 
 				/* i810_dma.c */
-extern int i810_driver_dma_quiescent(struct drm_device * dev);
-extern void i810_driver_reclaim_buffers_locked(struct drm_device * dev,
+extern int i810_driver_dma_quiescent(struct drm_device *dev);
+extern void i810_driver_reclaim_buffers_locked(struct drm_device *dev,
 					       struct drm_file *file_priv);
 extern int i810_driver_load(struct drm_device *, unsigned long flags);
-extern void i810_driver_lastclose(struct drm_device * dev);
-extern void i810_driver_preclose(struct drm_device * dev,
+extern void i810_driver_lastclose(struct drm_device *dev);
+extern void i810_driver_preclose(struct drm_device *dev,
 				 struct drm_file *file_priv);
-extern void i810_driver_reclaim_buffers_locked(struct drm_device * dev,
+extern void i810_driver_reclaim_buffers_locked(struct drm_device *dev,
 					       struct drm_file *file_priv);
-extern int i810_driver_device_is_agp(struct drm_device * dev);
+extern int i810_driver_device_is_agp(struct drm_device *dev);
 
 extern struct drm_ioctl_desc i810_ioctls[];
 extern int i810_max_ioctl;
@@ -132,39 +132,41 @@ extern int i810_max_ioctl;
 #define I810_BASE(reg)		((unsigned long) \
 				dev_priv->mmio_map->handle)
 #define I810_ADDR(reg)		(I810_BASE(reg) + reg)
-#define I810_DEREF(reg)		*(__volatile__ int *)I810_ADDR(reg)
+#define I810_DEREF(reg)		(*(__volatile__ int *)I810_ADDR(reg))
 #define I810_READ(reg)		I810_DEREF(reg)
-#define I810_WRITE(reg,val)	do { I810_DEREF(reg) = val; } while (0)
-#define I810_DEREF16(reg)	*(__volatile__ u16 *)I810_ADDR(reg)
+#define I810_WRITE(reg, val)	do { I810_DEREF(reg) = val; } while (0)
+#define I810_DEREF16(reg)	(*(__volatile__ u16 *)I810_ADDR(reg))
 #define I810_READ16(reg)	I810_DEREF16(reg)
-#define I810_WRITE16(reg,val)	do { I810_DEREF16(reg) = val; } while (0)
+#define I810_WRITE16(reg, val)	do { I810_DEREF16(reg) = val; } while (0)
 
 #define I810_VERBOSE 0
 #define RING_LOCALS	unsigned int outring, ringmask; \
-                        volatile char *virt;
-
-#define BEGIN_LP_RING(n) do {						\
-	if (I810_VERBOSE)                                               \
-		DRM_DEBUG("BEGIN_LP_RING(%d)\n", n);			\
-	if (dev_priv->ring.space < n*4)					\
-		i810_wait_ring(dev, n*4);				\
-	dev_priv->ring.space -= n*4;					\
-	outring = dev_priv->ring.tail;					\
-	ringmask = dev_priv->ring.tail_mask;				\
-	virt = dev_priv->ring.virtual_start;				\
+			volatile char *virt;
+
+#define BEGIN_LP_RING(n) do {					\
+	if (I810_VERBOSE)					\
+		DRM_DEBUG("BEGIN_LP_RING(%d)\n", n);		\
+	if (dev_priv->ring.space < n*4)				\
+		i810_wait_ring(dev, n*4);			\
+	dev_priv->ring.space -= n*4;				\
+	outring = dev_priv->ring.tail;				\
+	ringmask = dev_priv->ring.tail_mask;			\
+	virt = dev_priv->ring.virtual_start;			\
 } while (0)
 
-#define ADVANCE_LP_RING() do {				        \
-	if (I810_VERBOSE) DRM_DEBUG("ADVANCE_LP_RING\n");	\
+#define ADVANCE_LP_RING() do {					\
+	if (I810_VERBOSE)					\
+		DRM_DEBUG("ADVANCE_LP_RING\n");			\
 	dev_priv->ring.tail = outring;				\
-	I810_WRITE(LP_RING + RING_TAIL, outring);	        \
-} while(0)
-
-#define OUT_RING(n) do {				                \
-	if (I810_VERBOSE) DRM_DEBUG("   OUT_RING %x\n", (int)(n));	\
-	*(volatile unsigned int *)(virt + outring) = n;	                \
-	outring += 4;					                \
-	outring &= ringmask;			                        \
+	I810_WRITE(LP_RING + RING_TAIL, outring);		\
+} while (0)
+
+#define OUT_RING(n) do {					\
+	if (I810_VERBOSE)					\
+		DRM_DEBUG("   OUT_RING %x\n", (int)(n));	\
+	*(volatile unsigned int *)(virt + outring) = n;		\
+	outring += 4;						\
+	outring &= ringmask;					\
 } while (0)
 
 #define GFX_OP_USER_INTERRUPT		((0<<29)|(2<<23))
-- 
1.7.1
