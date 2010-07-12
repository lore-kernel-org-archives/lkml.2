Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0GLLpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 07:45:34 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:54427 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646Ab0GLLpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 07:45:32 -0400
Date: Mon, 12 Jul 2010 13:44:23 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/r128: fixed brace and spacing coding style issues
Message-ID: <20100712134423.5aa21ad2@absol.kitzblitz>
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
 drivers/gpu/drm/r128/r128_cce.c   |   52 +++++++---------
 drivers/gpu/drm/r128/r128_drv.c   |    2 +-
 drivers/gpu/drm/r128/r128_drv.h   |  122 ++++++++++++++++++-------------------
 drivers/gpu/drm/r128/r128_irq.c   |    4 +-
 drivers/gpu/drm/r128/r128_state.c |  121 ++++++++++++++++--------------------
 5 files changed, 139 insertions(+), 162 deletions(-)

diff --git a/drivers/gpu/drm/r128/r128_cce.c b/drivers/gpu/drm/r128/r128_cce.c
index e671d0e..570e190 100644
--- a/drivers/gpu/drm/r128/r128_cce.c
+++ b/drivers/gpu/drm/r128/r128_cce.c
@@ -44,7 +44,7 @@
 
 MODULE_FIRMWARE(FIRMWARE_NAME);
 
-static int R128_READ_PLL(struct drm_device * dev, int addr)
+static int R128_READ_PLL(struct drm_device *dev, int addr)
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
 
@@ -53,7 +53,7 @@ static int R128_READ_PLL(struct drm_device * dev, int addr)
 }
 
 #if R128_FIFO_DEBUG
-static void r128_status(drm_r128_private_t * dev_priv)
+static void r128_status(drm_r128_private_t *dev_priv)
 {
 	printk("GUI_STAT           = 0x%08x\n",
 	       (unsigned int)R128_READ(R128_GUI_STAT));
@@ -74,7 +74,7 @@ static void r128_status(drm_r128_private_t * dev_priv)
  * Engine, FIFO control
  */
 
-static int r128_do_pixcache_flush(drm_r128_private_t * dev_priv)
+static int r128_do_pixcache_flush(drm_r128_private_t *dev_priv)
 {
 	u32 tmp;
 	int i;
@@ -83,9 +83,8 @@ static int r128_do_pixcache_flush(drm_r128_private_t * dev_priv)
 	R128_WRITE(R128_PC_NGUI_CTLSTAT, tmp);
 
 	for (i = 0; i < dev_priv->usec_timeout; i++) {
-		if (!(R128_READ(R128_PC_NGUI_CTLSTAT) & R128_PC_BUSY)) {
+		if (!(R128_READ(R128_PC_NGUI_CTLSTAT) & R128_PC_BUSY))
 			return 0;
-		}
 		DRM_UDELAY(1);
 	}
 
@@ -95,7 +94,7 @@ static int r128_do_pixcache_flush(drm_r128_private_t * dev_priv)
 	return -EBUSY;
 }
 
-static int r128_do_wait_for_fifo(drm_r128_private_t * dev_priv, int entries)
+static int r128_do_wait_for_fifo(drm_r128_private_t *dev_priv, int entries)
 {
 	int i;
 
@@ -112,7 +111,7 @@ static int r128_do_wait_for_fifo(drm_r128_private_t * dev_priv, int entries)
 	return -EBUSY;
 }
 
-static int r128_do_wait_for_idle(drm_r128_private_t * dev_priv)
+static int r128_do_wait_for_idle(drm_r128_private_t *dev_priv)
 {
 	int i, ret;
 
@@ -189,7 +188,7 @@ out_release:
  * prior to a wait for idle, as it informs the engine that the command
  * stream is ending.
  */
-static void r128_do_cce_flush(drm_r128_private_t * dev_priv)
+static void r128_do_cce_flush(drm_r128_private_t *dev_priv)
 {
 	u32 tmp;
 
@@ -199,7 +198,7 @@ static void r128_do_cce_flush(drm_r128_private_t * dev_priv)
 
 /* Wait for the CCE to go idle.
  */
-int r128_do_cce_idle(drm_r128_private_t * dev_priv)
+int r128_do_cce_idle(drm_r128_private_t *dev_priv)
 {
 	int i;
 
@@ -225,7 +224,7 @@ int r128_do_cce_idle(drm_r128_private_t * dev_priv)
 
 /* Start the Concurrent Command Engine.
  */
-static void r128_do_cce_start(drm_r128_private_t * dev_priv)
+static void r128_do_cce_start(drm_r128_private_t *dev_priv)
 {
 	r128_do_wait_for_idle(dev_priv);
 
@@ -242,7 +241,7 @@ static void r128_do_cce_start(drm_r128_private_t * dev_priv)
  * commands, so you must wait for the CCE command stream to complete
  * before calling this routine.
  */
-static void r128_do_cce_reset(drm_r128_private_t * dev_priv)
+static void r128_do_cce_reset(drm_r128_private_t *dev_priv)
 {
 	R128_WRITE(R128_PM4_BUFFER_DL_WPTR, 0);
 	R128_WRITE(R128_PM4_BUFFER_DL_RPTR, 0);
@@ -253,7 +252,7 @@ static void r128_do_cce_reset(drm_r128_private_t * dev_priv)
  * commands, so you must flush the command stream and wait for the CCE
  * to go idle before calling this routine.
  */
-static void r128_do_cce_stop(drm_r128_private_t * dev_priv)
+static void r128_do_cce_stop(drm_r128_private_t *dev_priv)
 {
 	R128_WRITE(R128_PM4_MICRO_CNTL, 0);
 	R128_WRITE(R128_PM4_BUFFER_CNTL,
@@ -264,7 +263,7 @@ static void r128_do_cce_stop(drm_r128_private_t * dev_priv)
 
 /* Reset the engine.  This will stop the CCE if it is running.
  */
-static int r128_do_engine_reset(struct drm_device * dev)
+static int r128_do_engine_reset(struct drm_device *dev)
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
 	u32 clock_cntl_index, mclk_cntl, gen_reset_cntl;
@@ -301,8 +300,8 @@ static int r128_do_engine_reset(struct drm_device * dev)
 	return 0;
 }
 
-static void r128_cce_init_ring_buffer(struct drm_device * dev,
-				      drm_r128_private_t * dev_priv)
+static void r128_cce_init_ring_buffer(struct drm_device *dev,
+				      drm_r128_private_t *dev_priv)
 {
 	u32 ring_start;
 	u32 tmp;
@@ -340,7 +339,7 @@ static void r128_cce_init_ring_buffer(struct drm_device * dev,
 	R128_WRITE(R128_BUS_CNTL, tmp);
 }
 
-static int r128_do_init_cce(struct drm_device * dev, drm_r128_init_t * init)
+static int r128_do_init_cce(struct drm_device *dev, drm_r128_init_t *init)
 {
 	drm_r128_private_t *dev_priv;
 	int rc;
@@ -588,7 +587,7 @@ static int r128_do_init_cce(struct drm_device * dev, drm_r128_init_t * init)
 	return rc;
 }
 
-int r128_do_cleanup_cce(struct drm_device * dev)
+int r128_do_cleanup_cce(struct drm_device *dev)
 {
 
 	/* Make sure interrupts are disabled here because the uninstall ioctl
@@ -682,9 +681,8 @@ int r128_cce_stop(struct drm_device *dev, void *data, struct drm_file *file_priv
 	/* Flush any pending CCE commands.  This ensures any outstanding
 	 * commands are exectuted by the engine before we turn it off.
 	 */
-	if (stop->flush) {
+	if (stop->flush)
 		r128_do_cce_flush(dev_priv);
-	}
 
 	/* If we fail to make the engine go idle, we return an error
 	 * code so that the DRM ioctl wrapper can try again.
@@ -735,9 +733,8 @@ int r128_cce_idle(struct drm_device *dev, void *data, struct drm_file *file_priv
 
 	DEV_INIT_TEST_WITH_RETURN(dev_priv);
 
-	if (dev_priv->cce_running) {
+	if (dev_priv->cce_running)
 		r128_do_cce_flush(dev_priv);
-	}
 
 	return r128_do_cce_idle(dev_priv);
 }
@@ -765,7 +762,7 @@ int r128_fullscreen(struct drm_device *dev, void *data, struct drm_file *file_pr
 #define R128_BUFFER_FREE	0
 
 #if 0
-static int r128_freelist_init(struct drm_device * dev)
+static int r128_freelist_init(struct drm_device *dev)
 {
 	struct drm_device_dma *dma = dev->dma;
 	drm_r128_private_t *dev_priv = dev->dev_private;
@@ -848,7 +845,7 @@ static struct drm_buf *r128_freelist_get(struct drm_device * dev)
 	return NULL;
 }
 
-void r128_freelist_reset(struct drm_device * dev)
+void r128_freelist_reset(struct drm_device *dev)
 {
 	struct drm_device_dma *dma = dev->dma;
 	int i;
@@ -864,7 +861,7 @@ void r128_freelist_reset(struct drm_device * dev)
  * CCE command submission
  */
 
-int r128_wait_ring(drm_r128_private_t * dev_priv, int n)
+int r128_wait_ring(drm_r128_private_t *dev_priv, int n)
 {
 	drm_r128_ring_buffer_t *ring = &dev_priv->ring;
 	int i;
@@ -881,9 +878,9 @@ int r128_wait_ring(drm_r128_private_t * dev_priv, int n)
 	return -EBUSY;
 }
 
-static int r128_cce_get_buffers(struct drm_device * dev,
+static int r128_cce_get_buffers(struct drm_device *dev,
 				struct drm_file *file_priv,
-				struct drm_dma * d)
+				struct drm_dma *d)
 {
 	int i;
 	struct drm_buf *buf;
@@ -933,9 +930,8 @@ int r128_cce_buffers(struct drm_device *dev, void *data, struct drm_file *file_p
 
 	d->granted_count = 0;
 
-	if (d->request_count) {
+	if (d->request_count)
 		ret = r128_cce_get_buffers(dev, file_priv, d);
-	}
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/r128/r128_drv.c b/drivers/gpu/drm/r128/r128_drv.c
index b806fdc..1e2971f 100644
--- a/drivers/gpu/drm/r128/r128_drv.c
+++ b/drivers/gpu/drm/r128/r128_drv.c
@@ -85,7 +85,7 @@ static struct drm_driver driver = {
 	.patchlevel = DRIVER_PATCHLEVEL,
 };
 
-int r128_driver_load(struct drm_device * dev, unsigned long flags)
+int r128_driver_load(struct drm_device *dev, unsigned long flags)
 {
 	return drm_vblank_init(dev, 1);
 }
diff --git a/drivers/gpu/drm/r128/r128_drv.h b/drivers/gpu/drm/r128/r128_drv.h
index 3c60829..930c71b 100644
--- a/drivers/gpu/drm/r128/r128_drv.h
+++ b/drivers/gpu/drm/r128/r128_drv.h
@@ -53,7 +53,7 @@
 #define DRIVER_MINOR		5
 #define DRIVER_PATCHLEVEL	0
 
-#define GET_RING_HEAD(dev_priv)		R128_READ( R128_PM4_BUFFER_DL_RPTR )
+#define GET_RING_HEAD(dev_priv)		R128_READ(R128_PM4_BUFFER_DL_RPTR)
 
 typedef struct drm_r128_freelist {
 	unsigned int age;
@@ -144,23 +144,23 @@ extern int r128_engine_reset(struct drm_device *dev, void *data, struct drm_file
 extern int r128_fullscreen(struct drm_device *dev, void *data, struct drm_file *file_priv);
 extern int r128_cce_buffers(struct drm_device *dev, void *data, struct drm_file *file_priv);
 
-extern void r128_freelist_reset(struct drm_device * dev);
+extern void r128_freelist_reset(struct drm_device *dev);
 
-extern int r128_wait_ring(drm_r128_private_t * dev_priv, int n);
+extern int r128_wait_ring(drm_r128_private_t *dev_priv, int n);
 
-extern int r128_do_cce_idle(drm_r128_private_t * dev_priv);
-extern int r128_do_cleanup_cce(struct drm_device * dev);
+extern int r128_do_cce_idle(drm_r128_private_t *dev_priv);
+extern int r128_do_cleanup_cce(struct drm_device *dev);
 
 extern int r128_enable_vblank(struct drm_device *dev, int crtc);
 extern void r128_disable_vblank(struct drm_device *dev, int crtc);
 extern u32 r128_get_vblank_counter(struct drm_device *dev, int crtc);
 extern irqreturn_t r128_driver_irq_handler(DRM_IRQ_ARGS);
-extern void r128_driver_irq_preinstall(struct drm_device * dev);
+extern void r128_driver_irq_preinstall(struct drm_device *dev);
 extern int r128_driver_irq_postinstall(struct drm_device *dev);
-extern void r128_driver_irq_uninstall(struct drm_device * dev);
-extern void r128_driver_lastclose(struct drm_device * dev);
-extern int r128_driver_load(struct drm_device * dev, unsigned long flags);
-extern void r128_driver_preclose(struct drm_device * dev,
+extern void r128_driver_irq_uninstall(struct drm_device *dev);
+extern void r128_driver_lastclose(struct drm_device *dev);
+extern int r128_driver_load(struct drm_device *dev, unsigned long flags);
+extern void r128_driver_preclose(struct drm_device *dev,
 				 struct drm_file *file_priv);
 
 extern long r128_compat_ioctl(struct file *filp, unsigned int cmd,
@@ -390,27 +390,27 @@ extern long r128_compat_ioctl(struct file *filp, unsigned int cmd,
 
 #define R128_PCIGART_TABLE_SIZE         32768
 
-#define R128_READ(reg)		DRM_READ32(  dev_priv->mmio, (reg) )
-#define R128_WRITE(reg,val)	DRM_WRITE32( dev_priv->mmio, (reg), (val) )
-#define R128_READ8(reg)		DRM_READ8(   dev_priv->mmio, (reg) )
-#define R128_WRITE8(reg,val)	DRM_WRITE8(  dev_priv->mmio, (reg), (val) )
+#define R128_READ(reg)		DRM_READ32(dev_priv->mmio, (reg))
+#define R128_WRITE(reg, val)	DRM_WRITE32(dev_priv->mmio, (reg), (val))
+#define R128_READ8(reg)		DRM_READ8(dev_priv->mmio, (reg))
+#define R128_WRITE8(reg, val)	DRM_WRITE8(dev_priv->mmio, (reg), (val))
 
-#define R128_WRITE_PLL(addr,val)					\
+#define R128_WRITE_PLL(addr, val)					\
 do {									\
 	R128_WRITE8(R128_CLOCK_CNTL_INDEX,				\
 		    ((addr) & 0x1f) | R128_PLL_WR_EN);			\
 	R128_WRITE(R128_CLOCK_CNTL_DATA, (val));			\
 } while (0)
 
-#define CCE_PACKET0( reg, n )		(R128_CCE_PACKET0 |		\
+#define CCE_PACKET0(reg, n)		(R128_CCE_PACKET0 |		\
 					 ((n) << 16) | ((reg) >> 2))
-#define CCE_PACKET1( reg0, reg1 )	(R128_CCE_PACKET1 |		\
+#define CCE_PACKET1(reg0, reg1)		(R128_CCE_PACKET1 |		\
 					 (((reg1) >> 2) << 11) | ((reg0) >> 2))
 #define CCE_PACKET2()			(R128_CCE_PACKET2)
-#define CCE_PACKET3( pkt, n )		(R128_CCE_PACKET3 |		\
+#define CCE_PACKET3(pkt, n)		(R128_CCE_PACKET3 |		\
 					 (pkt) | ((n) << 16))
 
-static __inline__ void r128_update_ring_snapshot(drm_r128_private_t * dev_priv)
+static __inline__ void r128_update_ring_snapshot(drm_r128_private_t *dev_priv)
 {
 	drm_r128_ring_buffer_t *ring = &dev_priv->ring;
 	ring->space = (GET_RING_HEAD(dev_priv) - ring->tail) * sizeof(u32);
@@ -430,37 +430,38 @@ do {									\
 	}								\
 } while (0)
 
-#define RING_SPACE_TEST_WITH_RETURN( dev_priv )				\
+#define RING_SPACE_TEST_WITH_RETURN(dev_priv)				\
 do {									\
 	drm_r128_ring_buffer_t *ring = &dev_priv->ring; int i;		\
-	if ( ring->space < ring->high_mark ) {				\
-		for ( i = 0 ; i < dev_priv->usec_timeout ; i++ ) {	\
-			r128_update_ring_snapshot( dev_priv );		\
-			if ( ring->space >= ring->high_mark )		\
+	if (ring->space < ring->high_mark) {				\
+		for (i = 0 ; i < dev_priv->usec_timeout ; i++) {	\
+			r128_update_ring_snapshot(dev_priv);		\
+			if (ring->space >= ring->high_mark)		\
 				goto __ring_space_done;			\
-			DRM_UDELAY(1);				\
+			DRM_UDELAY(1);					\
 		}							\
-		DRM_ERROR( "ring space check failed!\n" );		\
-		return -EBUSY;				\
+		DRM_ERROR("ring space check failed!\n");		\
+		return -EBUSY;						\
 	}								\
  __ring_space_done:							\
 	;								\
 } while (0)
 
-#define VB_AGE_TEST_WITH_RETURN( dev_priv )				\
+#define VB_AGE_TEST_WITH_RETURN(dev_priv)				\
 do {									\
 	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;		\
-	if ( sarea_priv->last_dispatch >= R128_MAX_VB_AGE ) {		\
-		int __ret = r128_do_cce_idle( dev_priv );		\
-		if ( __ret ) return __ret;				\
+	if (sarea_priv->last_dispatch >= R128_MAX_VB_AGE) {		\
+		int __ret = r128_do_cce_idle(dev_priv);			\
+		if (__ret)						\
+			return __ret;					\
 		sarea_priv->last_dispatch = 0;				\
-		r128_freelist_reset( dev );				\
+		r128_freelist_reset(dev);				\
 	}								\
 } while (0)
 
 #define R128_WAIT_UNTIL_PAGE_FLIPPED() do {				\
-	OUT_RING( CCE_PACKET0( R128_WAIT_UNTIL, 0 ) );			\
-	OUT_RING( R128_EVENT_CRTC_OFFSET );				\
+	OUT_RING(CCE_PACKET0(R128_WAIT_UNTIL, 0));			\
+	OUT_RING(R128_EVENT_CRTC_OFFSET);				\
 } while (0)
 
 /* ================================================================
@@ -472,13 +473,12 @@ do {									\
 #define RING_LOCALS							\
 	int write, _nr; unsigned int tail_mask; volatile u32 *ring;
 
-#define BEGIN_RING( n ) do {						\
-	if ( R128_VERBOSE ) {						\
-		DRM_INFO( "BEGIN_RING( %d )\n", (n));			\
-	}								\
-	if ( dev_priv->ring.space <= (n) * sizeof(u32) ) {		\
+#define BEGIN_RING(n) do {						\
+	if (R128_VERBOSE)						\
+		DRM_INFO("BEGIN_RING(%d)\n", (n));			\
+	if (dev_priv->ring.space <= (n) * sizeof(u32)) {		\
 		COMMIT_RING();						\
-		r128_wait_ring( dev_priv, (n) * sizeof(u32) );		\
+		r128_wait_ring(dev_priv, (n) * sizeof(u32));		\
 	}								\
 	_nr = n; dev_priv->ring.space -= (n) * sizeof(u32);		\
 	ring = dev_priv->ring.start;					\
@@ -494,40 +494,36 @@ do {									\
 #define R128_BROKEN_CCE	1
 
 #define ADVANCE_RING() do {						\
-	if ( R128_VERBOSE ) {						\
-		DRM_INFO( "ADVANCE_RING() wr=0x%06x tail=0x%06x\n",	\
-			  write, dev_priv->ring.tail );			\
-	}								\
-	if ( R128_BROKEN_CCE && write < 32 ) {				\
-		memcpy( dev_priv->ring.end,				\
-			dev_priv->ring.start,				\
-			write * sizeof(u32) );				\
-	}								\
-	if (((dev_priv->ring.tail + _nr) & tail_mask) != write) {	\
+	if (R128_VERBOSE)						\
+		DRM_INFO("ADVANCE_RING() wr=0x%06x tail=0x%06x\n",	\
+			 write, dev_priv->ring.tail);			\
+	if (R128_BROKEN_CCE && write < 32)				\
+		memcpy(dev_priv->ring.end,				\
+		       dev_priv->ring.start,				\
+		       write * sizeof(u32));				\
+	if (((dev_priv->ring.tail + _nr) & tail_mask) != write)		\
 		DRM_ERROR(						\
 			"ADVANCE_RING(): mismatch: nr: %x write: %x line: %d\n",	\
 			((dev_priv->ring.tail + _nr) & tail_mask),	\
 			write, __LINE__);				\
-	} else								\
+	else								\
 		dev_priv->ring.tail = write;				\
 } while (0)
 
 #define COMMIT_RING() do {						\
-	if ( R128_VERBOSE ) {						\
-		DRM_INFO( "COMMIT_RING() tail=0x%06x\n",		\
-			dev_priv->ring.tail );				\
-	}								\
+	if (R128_VERBOSE)						\
+		DRM_INFO("COMMIT_RING() tail=0x%06x\n",			\
+			 dev_priv->ring.tail);				\
 	DRM_MEMORYBARRIER();						\
-	R128_WRITE( R128_PM4_BUFFER_DL_WPTR, dev_priv->ring.tail );	\
-	R128_READ( R128_PM4_BUFFER_DL_WPTR );				\
+	R128_WRITE(R128_PM4_BUFFER_DL_WPTR, dev_priv->ring.tail);	\
+	R128_READ(R128_PM4_BUFFER_DL_WPTR);				\
 } while (0)
 
-#define OUT_RING( x ) do {						\
-	if ( R128_VERBOSE ) {						\
-		DRM_INFO( "   OUT_RING( 0x%08x ) at 0x%x\n",		\
-			   (unsigned int)(x), write );			\
-	}								\
-	ring[write++] = cpu_to_le32( x );				\
+#define OUT_RING(x) do {						\
+	if (R128_VERBOSE)						\
+		DRM_INFO("   OUT_RING( 0x%08x ) at 0x%x\n",		\
+			 (unsigned int)(x), write);			\
+	ring[write++] = cpu_to_le32(x);					\
 	write &= tail_mask;						\
 } while (0)
 
diff --git a/drivers/gpu/drm/r128/r128_irq.c b/drivers/gpu/drm/r128/r128_irq.c
index 69810fb..429d5a0 100644
--- a/drivers/gpu/drm/r128/r128_irq.c
+++ b/drivers/gpu/drm/r128/r128_irq.c
@@ -90,7 +90,7 @@ void r128_disable_vblank(struct drm_device *dev, int crtc)
 	 */
 }
 
-void r128_driver_irq_preinstall(struct drm_device * dev)
+void r128_driver_irq_preinstall(struct drm_device *dev)
 {
 	drm_r128_private_t *dev_priv = (drm_r128_private_t *) dev->dev_private;
 
@@ -105,7 +105,7 @@ int r128_driver_irq_postinstall(struct drm_device *dev)
 	return 0;
 }
 
-void r128_driver_irq_uninstall(struct drm_device * dev)
+void r128_driver_irq_uninstall(struct drm_device *dev)
 {
 	drm_r128_private_t *dev_priv = (drm_r128_private_t *) dev->dev_private;
 	if (!dev_priv)
diff --git a/drivers/gpu/drm/r128/r128_state.c b/drivers/gpu/drm/r128/r128_state.c
index af2665c..077af1f 100644
--- a/drivers/gpu/drm/r128/r128_state.c
+++ b/drivers/gpu/drm/r128/r128_state.c
@@ -37,8 +37,8 @@
  * CCE hardware state programming functions
  */
 
-static void r128_emit_clip_rects(drm_r128_private_t * dev_priv,
-				 struct drm_clip_rect * boxes, int count)
+static void r128_emit_clip_rects(drm_r128_private_t *dev_priv,
+				 struct drm_clip_rect *boxes, int count)
 {
 	u32 aux_sc_cntl = 0x00000000;
 	RING_LOCALS;
@@ -80,7 +80,7 @@ static void r128_emit_clip_rects(drm_r128_private_t * dev_priv,
 	ADVANCE_RING();
 }
 
-static __inline__ void r128_emit_core(drm_r128_private_t * dev_priv)
+static __inline__ void r128_emit_core(drm_r128_private_t *dev_priv)
 {
 	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_r128_context_regs_t *ctx = &sarea_priv->context_state;
@@ -95,7 +95,7 @@ static __inline__ void r128_emit_core(drm_r128_private_t * dev_priv)
 	ADVANCE_RING();
 }
 
-static __inline__ void r128_emit_context(drm_r128_private_t * dev_priv)
+static __inline__ void r128_emit_context(drm_r128_private_t *dev_priv)
 {
 	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_r128_context_regs_t *ctx = &sarea_priv->context_state;
@@ -121,7 +121,7 @@ static __inline__ void r128_emit_context(drm_r128_private_t * dev_priv)
 	ADVANCE_RING();
 }
 
-static __inline__ void r128_emit_setup(drm_r128_private_t * dev_priv)
+static __inline__ void r128_emit_setup(drm_r128_private_t *dev_priv)
 {
 	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_r128_context_regs_t *ctx = &sarea_priv->context_state;
@@ -137,7 +137,7 @@ static __inline__ void r128_emit_setup(drm_r128_private_t * dev_priv)
 	ADVANCE_RING();
 }
 
-static __inline__ void r128_emit_masks(drm_r128_private_t * dev_priv)
+static __inline__ void r128_emit_masks(drm_r128_private_t *dev_priv)
 {
 	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_r128_context_regs_t *ctx = &sarea_priv->context_state;
@@ -156,7 +156,7 @@ static __inline__ void r128_emit_masks(drm_r128_private_t * dev_priv)
 	ADVANCE_RING();
 }
 
-static __inline__ void r128_emit_window(drm_r128_private_t * dev_priv)
+static __inline__ void r128_emit_window(drm_r128_private_t *dev_priv)
 {
 	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_r128_context_regs_t *ctx = &sarea_priv->context_state;
@@ -171,7 +171,7 @@ static __inline__ void r128_emit_window(drm_r128_private_t * dev_priv)
 	ADVANCE_RING();
 }
 
-static __inline__ void r128_emit_tex0(drm_r128_private_t * dev_priv)
+static __inline__ void r128_emit_tex0(drm_r128_private_t *dev_priv)
 {
 	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_r128_context_regs_t *ctx = &sarea_priv->context_state;
@@ -187,9 +187,8 @@ static __inline__ void r128_emit_tex0(drm_r128_private_t * dev_priv)
 	OUT_RING(tex->tex_cntl);
 	OUT_RING(tex->tex_combine_cntl);
 	OUT_RING(ctx->tex_size_pitch_c);
-	for (i = 0; i < R128_MAX_TEXTURE_LEVELS; i++) {
+	for (i = 0; i < R128_MAX_TEXTURE_LEVELS; i++)
 		OUT_RING(tex->tex_offset[i]);
-	}
 
 	OUT_RING(CCE_PACKET0(R128_CONSTANT_COLOR_C, 1));
 	OUT_RING(ctx->constant_color_c);
@@ -198,7 +197,7 @@ static __inline__ void r128_emit_tex0(drm_r128_private_t * dev_priv)
 	ADVANCE_RING();
 }
 
-static __inline__ void r128_emit_tex1(drm_r128_private_t * dev_priv)
+static __inline__ void r128_emit_tex1(drm_r128_private_t *dev_priv)
 {
 	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	drm_r128_texture_regs_t *tex = &sarea_priv->tex_state[1];
@@ -211,9 +210,8 @@ static __inline__ void r128_emit_tex1(drm_r128_private_t * dev_priv)
 	OUT_RING(CCE_PACKET0(R128_SEC_TEX_CNTL_C, 1 + R128_MAX_TEXTURE_LEVELS));
 	OUT_RING(tex->tex_cntl);
 	OUT_RING(tex->tex_combine_cntl);
-	for (i = 0; i < R128_MAX_TEXTURE_LEVELS; i++) {
+	for (i = 0; i < R128_MAX_TEXTURE_LEVELS; i++)
 		OUT_RING(tex->tex_offset[i]);
-	}
 
 	OUT_RING(CCE_PACKET0(R128_SEC_TEXTURE_BORDER_COLOR_C, 0));
 	OUT_RING(tex->tex_border_color);
@@ -221,7 +219,7 @@ static __inline__ void r128_emit_tex1(drm_r128_private_t * dev_priv)
 	ADVANCE_RING();
 }
 
-static void r128_emit_state(drm_r128_private_t * dev_priv)
+static void r128_emit_state(drm_r128_private_t *dev_priv)
 {
 	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
 	unsigned int dirty = sarea_priv->dirty;
@@ -274,7 +272,7 @@ static void r128_emit_state(drm_r128_private_t * dev_priv)
  * Performance monitoring functions
  */
 
-static void r128_clear_box(drm_r128_private_t * dev_priv,
+static void r128_clear_box(drm_r128_private_t *dev_priv,
 			   int x, int y, int w, int h, int r, int g, int b)
 {
 	u32 pitch, offset;
@@ -321,13 +319,12 @@ static void r128_clear_box(drm_r128_private_t * dev_priv,
 	ADVANCE_RING();
 }
 
-static void r128_cce_performance_boxes(drm_r128_private_t * dev_priv)
+static void r128_cce_performance_boxes(drm_r128_private_t *dev_priv)
 {
-	if (atomic_read(&dev_priv->idle_count) == 0) {
+	if (atomic_read(&dev_priv->idle_count) == 0)
 		r128_clear_box(dev_priv, 64, 4, 8, 8, 0, 255, 0);
-	} else {
+	else
 		atomic_set(&dev_priv->idle_count, 0);
-	}
 }
 
 #endif
@@ -352,8 +349,8 @@ static void r128_print_dirty(const char *msg, unsigned int flags)
 		 (flags & R128_REQUIRE_QUIESCENCE) ? "quiescence, " : "");
 }
 
-static void r128_cce_dispatch_clear(struct drm_device * dev,
-				    drm_r128_clear_t * clear)
+static void r128_cce_dispatch_clear(struct drm_device *dev,
+				    drm_r128_clear_t *clear)
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
 	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
@@ -458,7 +455,7 @@ static void r128_cce_dispatch_clear(struct drm_device * dev,
 	}
 }
 
-static void r128_cce_dispatch_swap(struct drm_device * dev)
+static void r128_cce_dispatch_swap(struct drm_device *dev)
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
 	drm_r128_sarea_t *sarea_priv = dev_priv->sarea_priv;
@@ -524,7 +521,7 @@ static void r128_cce_dispatch_swap(struct drm_device * dev)
 	ADVANCE_RING();
 }
 
-static void r128_cce_dispatch_flip(struct drm_device * dev)
+static void r128_cce_dispatch_flip(struct drm_device *dev)
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
 	RING_LOCALS;
@@ -542,11 +539,10 @@ static void r128_cce_dispatch_flip(struct drm_device * dev)
 	R128_WAIT_UNTIL_PAGE_FLIPPED();
 	OUT_RING(CCE_PACKET0(R128_CRTC_OFFSET, 0));
 
-	if (dev_priv->current_page == 0) {
+	if (dev_priv->current_page == 0)
 		OUT_RING(dev_priv->back_offset);
-	} else {
+	else
 		OUT_RING(dev_priv->front_offset);
-	}
 
 	ADVANCE_RING();
 
@@ -566,7 +562,7 @@ static void r128_cce_dispatch_flip(struct drm_device * dev)
 	ADVANCE_RING();
 }
 
-static void r128_cce_dispatch_vertex(struct drm_device * dev, struct drm_buf * buf)
+static void r128_cce_dispatch_vertex(struct drm_device *dev, struct drm_buf *buf)
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
 	drm_r128_buf_priv_t *buf_priv = buf->dev_private;
@@ -585,9 +581,8 @@ static void r128_cce_dispatch_vertex(struct drm_device * dev, struct drm_buf * b
 	if (buf->used) {
 		buf_priv->dispatched = 1;
 
-		if (sarea_priv->dirty & ~R128_UPLOAD_CLIPRECTS) {
+		if (sarea_priv->dirty & ~R128_UPLOAD_CLIPRECTS)
 			r128_emit_state(dev_priv);
-		}
 
 		do {
 			/* Emit the next set of up to three cliprects */
@@ -636,8 +631,8 @@ static void r128_cce_dispatch_vertex(struct drm_device * dev, struct drm_buf * b
 	sarea_priv->nbox = 0;
 }
 
-static void r128_cce_dispatch_indirect(struct drm_device * dev,
-				       struct drm_buf * buf, int start, int end)
+static void r128_cce_dispatch_indirect(struct drm_device *dev,
+				       struct drm_buf *buf, int start, int end)
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
 	drm_r128_buf_priv_t *buf_priv = buf->dev_private;
@@ -691,8 +686,8 @@ static void r128_cce_dispatch_indirect(struct drm_device * dev,
 	dev_priv->sarea_priv->last_dispatch++;
 }
 
-static void r128_cce_dispatch_indices(struct drm_device * dev,
-				      struct drm_buf * buf,
+static void r128_cce_dispatch_indices(struct drm_device *dev,
+				      struct drm_buf *buf,
 				      int start, int end, int count)
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
@@ -713,9 +708,8 @@ static void r128_cce_dispatch_indices(struct drm_device * dev,
 	if (start != end) {
 		buf_priv->dispatched = 1;
 
-		if (sarea_priv->dirty & ~R128_UPLOAD_CLIPRECTS) {
+		if (sarea_priv->dirty & ~R128_UPLOAD_CLIPRECTS)
 			r128_emit_state(dev_priv);
-		}
 
 		dwords = (end - start + 3) / sizeof(u32);
 
@@ -775,9 +769,9 @@ static void r128_cce_dispatch_indices(struct drm_device * dev,
 	sarea_priv->nbox = 0;
 }
 
-static int r128_cce_dispatch_blit(struct drm_device * dev,
+static int r128_cce_dispatch_blit(struct drm_device *dev,
 				  struct drm_file *file_priv,
-				  drm_r128_blit_t * blit)
+				  drm_r128_blit_t *blit)
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
 	struct drm_device_dma *dma = dev->dma;
@@ -887,8 +881,8 @@ static int r128_cce_dispatch_blit(struct drm_device * dev,
  * have hardware stencil support.
  */
 
-static int r128_cce_dispatch_write_span(struct drm_device * dev,
-					drm_r128_depth_t * depth)
+static int r128_cce_dispatch_write_span(struct drm_device *dev,
+					drm_r128_depth_t *depth)
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
 	int count, x, y;
@@ -902,12 +896,10 @@ static int r128_cce_dispatch_write_span(struct drm_device * dev,
 	if (count > 4096 || count <= 0)
 		return -EMSGSIZE;
 
-	if (DRM_COPY_FROM_USER(&x, depth->x, sizeof(x))) {
+	if (DRM_COPY_FROM_USER(&x, depth->x, sizeof(x)))
 		return -EFAULT;
-	}
-	if (DRM_COPY_FROM_USER(&y, depth->y, sizeof(y))) {
+	if (DRM_COPY_FROM_USER(&y, depth->y, sizeof(y)))
 		return -EFAULT;
-	}
 
 	buffer_size = depth->n * sizeof(u32);
 	buffer = kmalloc(buffer_size, GFP_KERNEL);
@@ -983,8 +975,8 @@ static int r128_cce_dispatch_write_span(struct drm_device * dev,
 	return 0;
 }
 
-static int r128_cce_dispatch_write_pixels(struct drm_device * dev,
-					  drm_r128_depth_t * depth)
+static int r128_cce_dispatch_write_pixels(struct drm_device *dev,
+					  drm_r128_depth_t *depth)
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
 	int count, *x, *y;
@@ -1001,9 +993,8 @@ static int r128_cce_dispatch_write_pixels(struct drm_device * dev,
 	xbuf_size = count * sizeof(*x);
 	ybuf_size = count * sizeof(*y);
 	x = kmalloc(xbuf_size, GFP_KERNEL);
-	if (x == NULL) {
+	if (x == NULL)
 		return -ENOMEM;
-	}
 	y = kmalloc(ybuf_size, GFP_KERNEL);
 	if (y == NULL) {
 		kfree(x);
@@ -1105,8 +1096,8 @@ static int r128_cce_dispatch_write_pixels(struct drm_device * dev,
 	return 0;
 }
 
-static int r128_cce_dispatch_read_span(struct drm_device * dev,
-				       drm_r128_depth_t * depth)
+static int r128_cce_dispatch_read_span(struct drm_device *dev,
+				       drm_r128_depth_t *depth)
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
 	int count, x, y;
@@ -1117,12 +1108,10 @@ static int r128_cce_dispatch_read_span(struct drm_device * dev,
 	if (count > 4096 || count <= 0)
 		return -EMSGSIZE;
 
-	if (DRM_COPY_FROM_USER(&x, depth->x, sizeof(x))) {
+	if (DRM_COPY_FROM_USER(&x, depth->x, sizeof(x)))
 		return -EFAULT;
-	}
-	if (DRM_COPY_FROM_USER(&y, depth->y, sizeof(y))) {
+	if (DRM_COPY_FROM_USER(&y, depth->y, sizeof(y)))
 		return -EFAULT;
-	}
 
 	BEGIN_RING(7);
 
@@ -1148,8 +1137,8 @@ static int r128_cce_dispatch_read_span(struct drm_device * dev,
 	return 0;
 }
 
-static int r128_cce_dispatch_read_pixels(struct drm_device * dev,
-					 drm_r128_depth_t * depth)
+static int r128_cce_dispatch_read_pixels(struct drm_device *dev,
+					 drm_r128_depth_t *depth)
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
 	int count, *x, *y;
@@ -1161,16 +1150,14 @@ static int r128_cce_dispatch_read_pixels(struct drm_device * dev,
 	if (count > 4096 || count <= 0)
 		return -EMSGSIZE;
 
-	if (count > dev_priv->depth_pitch) {
+	if (count > dev_priv->depth_pitch)
 		count = dev_priv->depth_pitch;
-	}
 
 	xbuf_size = count * sizeof(*x);
 	ybuf_size = count * sizeof(*y);
 	x = kmalloc(xbuf_size, GFP_KERNEL);
-	if (x == NULL) {
+	if (x == NULL)
 		return -ENOMEM;
-	}
 	y = kmalloc(ybuf_size, GFP_KERNEL);
 	if (y == NULL) {
 		kfree(x);
@@ -1220,7 +1207,7 @@ static int r128_cce_dispatch_read_pixels(struct drm_device * dev,
  * Polygon stipple
  */
 
-static void r128_cce_dispatch_stipple(struct drm_device * dev, u32 * stipple)
+static void r128_cce_dispatch_stipple(struct drm_device *dev, u32 *stipple)
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
 	int i;
@@ -1230,9 +1217,8 @@ static void r128_cce_dispatch_stipple(struct drm_device * dev, u32 * stipple)
 	BEGIN_RING(33);
 
 	OUT_RING(CCE_PACKET0(R128_BRUSH_DATA0, 31));
-	for (i = 0; i < 32; i++) {
+	for (i = 0; i < 32; i++)
 		OUT_RING(stipple[i]);
-	}
 
 	ADVANCE_RING();
 }
@@ -1269,7 +1255,7 @@ static int r128_cce_clear(struct drm_device *dev, void *data, struct drm_file *f
 	return 0;
 }
 
-static int r128_do_init_pageflip(struct drm_device * dev)
+static int r128_do_init_pageflip(struct drm_device *dev)
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
 	DRM_DEBUG("\n");
@@ -1288,7 +1274,7 @@ static int r128_do_init_pageflip(struct drm_device * dev)
 	return 0;
 }
 
-static int r128_do_cleanup_pageflip(struct drm_device * dev)
+static int r128_do_cleanup_pageflip(struct drm_device *dev)
 {
 	drm_r128_private_t *dev_priv = dev->dev_private;
 	DRM_DEBUG("\n");
@@ -1645,17 +1631,16 @@ static int r128_getparam(struct drm_device *dev, void *data, struct drm_file *fi
 	return 0;
 }
 
-void r128_driver_preclose(struct drm_device * dev, struct drm_file *file_priv)
+void r128_driver_preclose(struct drm_device *dev, struct drm_file *file_priv)
 {
 	if (dev->dev_private) {
 		drm_r128_private_t *dev_priv = dev->dev_private;
-		if (dev_priv->page_flipping) {
+		if (dev_priv->page_flipping)
 			r128_do_cleanup_pageflip(dev);
-		}
 	}
 }
 
-void r128_driver_lastclose(struct drm_device * dev)
+void r128_driver_lastclose(struct drm_device *dev)
 {
 	r128_do_cleanup_cce(dev);
 }
-- 
1.7.1
