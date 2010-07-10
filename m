Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab0GJWv5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 18:51:57 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:55672 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751415Ab0GJWv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 18:51:56 -0400
Date: Sun, 11 Jul 2010 00:42:27 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drm/savage: fixed brace, macro and spacing coding style
 issues
Message-ID: <20100711004227.7d9bebc0@absol.kitzblitz>
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
Supersedes patch "drm/savage: fixed brace coding style issues".

 drivers/gpu/drm/savage/savage_bci.c   |   48 +++++++--------
 drivers/gpu/drm/savage/savage_drv.h   |  109 +++++++++++++++++----------------
 drivers/gpu/drm/savage/savage_state.c |   63 +++++++++----------
 3 files changed, 109 insertions(+), 111 deletions(-)

diff --git a/drivers/gpu/drm/savage/savage_bci.c b/drivers/gpu/drm/savage/savage_bci.c
index 2d0c9ca..def6dd0 100644
--- a/drivers/gpu/drm/savage/savage_bci.c
+++ b/drivers/gpu/drm/savage/savage_bci.c
@@ -35,7 +35,7 @@
 static int savage_do_cleanup_bci(struct drm_device *dev);
 
 static int
-savage_bci_wait_fifo_shadow(drm_savage_private_t * dev_priv, unsigned int n)
+savage_bci_wait_fifo_shadow(drm_savage_private_t *dev_priv, unsigned int n)
 {
 	uint32_t mask = dev_priv->status_used_mask;
 	uint32_t threshold = dev_priv->bci_threshold_hi;
@@ -64,7 +64,7 @@ savage_bci_wait_fifo_shadow(drm_savage_private_t * dev_priv, unsigned int n)
 }
 
 static int
-savage_bci_wait_fifo_s3d(drm_savage_private_t * dev_priv, unsigned int n)
+savage_bci_wait_fifo_s3d(drm_savage_private_t *dev_priv, unsigned int n)
 {
 	uint32_t maxUsed = dev_priv->cob_size + SAVAGE_BCI_FIFO_SIZE - n;
 	uint32_t status;
@@ -85,7 +85,7 @@ savage_bci_wait_fifo_s3d(drm_savage_private_t * dev_priv, unsigned int n)
 }
 
 static int
-savage_bci_wait_fifo_s4(drm_savage_private_t * dev_priv, unsigned int n)
+savage_bci_wait_fifo_s4(drm_savage_private_t *dev_priv, unsigned int n)
 {
 	uint32_t maxUsed = dev_priv->cob_size + SAVAGE_BCI_FIFO_SIZE - n;
 	uint32_t status;
@@ -117,7 +117,7 @@ savage_bci_wait_fifo_s4(drm_savage_private_t * dev_priv, unsigned int n)
  * rule. Otherwise there may be glitches every 2^16 events.
  */
 static int
-savage_bci_wait_event_shadow(drm_savage_private_t * dev_priv, uint16_t e)
+savage_bci_wait_event_shadow(drm_savage_private_t *dev_priv, uint16_t e)
 {
 	uint32_t status;
 	int i;
@@ -140,7 +140,7 @@ savage_bci_wait_event_shadow(drm_savage_private_t * dev_priv, uint16_t e)
 }
 
 static int
-savage_bci_wait_event_reg(drm_savage_private_t * dev_priv, uint16_t e)
+savage_bci_wait_event_reg(drm_savage_private_t *dev_priv, uint16_t e)
 {
 	uint32_t status;
 	int i;
@@ -161,7 +161,7 @@ savage_bci_wait_event_reg(drm_savage_private_t * dev_priv, uint16_t e)
 	return -EBUSY;
 }
 
-uint16_t savage_bci_emit_event(drm_savage_private_t * dev_priv,
+uint16_t savage_bci_emit_event(drm_savage_private_t *dev_priv,
 			       unsigned int flags)
 {
 	uint16_t count;
@@ -203,7 +203,7 @@ uint16_t savage_bci_emit_event(drm_savage_private_t * dev_priv,
 /*
  * Freelist management
  */
-static int savage_freelist_init(struct drm_device * dev)
+static int savage_freelist_init(struct drm_device *dev)
 {
 	drm_savage_private_t *dev_priv = dev->dev_private;
 	struct drm_device_dma *dma = dev->dma;
@@ -269,7 +269,7 @@ static struct drm_buf *savage_freelist_get(struct drm_device * dev)
 	return NULL;
 }
 
-void savage_freelist_put(struct drm_device * dev, struct drm_buf * buf)
+void savage_freelist_put(struct drm_device *dev, struct drm_buf *buf)
 {
 	drm_savage_private_t *dev_priv = dev->dev_private;
 	drm_savage_buf_priv_t *entry = buf->dev_private, *prev, *next;
@@ -292,7 +292,7 @@ void savage_freelist_put(struct drm_device * dev, struct drm_buf * buf)
 /*
  * Command DMA
  */
-static int savage_dma_init(drm_savage_private_t * dev_priv)
+static int savage_dma_init(drm_savage_private_t *dev_priv)
 {
 	unsigned int i;
 
@@ -316,7 +316,7 @@ static int savage_dma_init(drm_savage_private_t * dev_priv)
 	return 0;
 }
 
-void savage_dma_reset(drm_savage_private_t * dev_priv)
+void savage_dma_reset(drm_savage_private_t *dev_priv)
 {
 	uint16_t event;
 	unsigned int wrap, i;
@@ -331,7 +331,7 @@ void savage_dma_reset(drm_savage_private_t * dev_priv)
 	dev_priv->first_dma_page = dev_priv->current_dma_page = 0;
 }
 
-void savage_dma_wait(drm_savage_private_t * dev_priv, unsigned int page)
+void savage_dma_wait(drm_savage_private_t *dev_priv, unsigned int page)
 {
 	uint16_t event;
 	unsigned int wrap;
@@ -415,7 +415,7 @@ uint32_t *savage_dma_alloc(drm_savage_private_t * dev_priv, unsigned int n)
 	return dma_ptr;
 }
 
-static void savage_dma_flush(drm_savage_private_t * dev_priv)
+static void savage_dma_flush(drm_savage_private_t *dev_priv)
 {
 	unsigned int first = dev_priv->first_dma_page;
 	unsigned int cur = dev_priv->current_dma_page;
@@ -498,7 +498,7 @@ static void savage_dma_flush(drm_savage_private_t * dev_priv)
 		  dev_priv->dma_pages[cur].flushed);
 }
 
-static void savage_fake_dma_flush(drm_savage_private_t * dev_priv)
+static void savage_fake_dma_flush(drm_savage_private_t *dev_priv)
 {
 	unsigned int i, j;
 	BCI_LOCALS;
@@ -525,9 +525,8 @@ static void savage_fake_dma_flush(drm_savage_private_t * dev_priv)
 		}
 #endif
 		BEGIN_BCI(dev_priv->dma_pages[i].used);
-		for (j = 0; j < dev_priv->dma_pages[i].used; ++j) {
+		for (j = 0; j < dev_priv->dma_pages[i].used; ++j)
 			BCI_WRITE(dma_ptr[j]);
-		}
 		dev_priv->dma_pages[i].used = 0;
 	}
 
@@ -586,7 +585,7 @@ int savage_driver_firstopen(struct drm_device *dev)
 			dev_priv->mtrr[0].size = 0x01000000;
 			dev_priv->mtrr[0].handle =
 			    drm_mtrr_add(dev_priv->mtrr[0].base,
-				         dev_priv->mtrr[0].size, DRM_MTRR_WC);
+					 dev_priv->mtrr[0].size, DRM_MTRR_WC);
 			dev_priv->mtrr[1].base = fb_base + 0x02000000;
 			dev_priv->mtrr[1].size = 0x02000000;
 			dev_priv->mtrr[1].handle =
@@ -675,7 +674,7 @@ int savage_driver_unload(struct drm_device *dev)
 	return 0;
 }
 
-static int savage_do_init_bci(struct drm_device * dev, drm_savage_init_t * init)
+static int savage_do_init_bci(struct drm_device *dev, drm_savage_init_t *init)
 {
 	drm_savage_private_t *dev_priv = dev->dev_private;
 
@@ -855,11 +854,10 @@ static int savage_do_init_bci(struct drm_device * dev, drm_savage_init_t * init)
 	dev_priv->event_wrap = 0;
 	dev_priv->bci_ptr = (volatile uint32_t *)
 	    ((uint8_t *) dev_priv->mmio->handle + SAVAGE_BCI_OFFSET);
-	if (S3_SAVAGE3D_SERIES(dev_priv->chipset)) {
+	if (S3_SAVAGE3D_SERIES(dev_priv->chipset))
 		dev_priv->status_used_mask = SAVAGE_FIFO_USED_MASK_S3D;
-	} else {
+	else
 		dev_priv->status_used_mask = SAVAGE_FIFO_USED_MASK_S4;
-	}
 	if (dev_priv->status != NULL) {
 		dev_priv->status_ptr =
 		    (volatile uint32_t *)dev_priv->status->handle;
@@ -868,11 +866,10 @@ static int savage_do_init_bci(struct drm_device * dev, drm_savage_init_t * init)
 		dev_priv->status_ptr[1023] = dev_priv->event_counter;
 	} else {
 		dev_priv->status_ptr = NULL;
-		if (S3_SAVAGE3D_SERIES(dev_priv->chipset)) {
+		if (S3_SAVAGE3D_SERIES(dev_priv->chipset))
 			dev_priv->wait_fifo = savage_bci_wait_fifo_s3d;
-		} else {
+		else
 			dev_priv->wait_fifo = savage_bci_wait_fifo_s4;
-		}
 		dev_priv->wait_evnt = savage_bci_wait_event_reg;
 	}
 
@@ -897,7 +894,7 @@ static int savage_do_init_bci(struct drm_device * dev, drm_savage_init_t * init)
 	return 0;
 }
 
-static int savage_do_cleanup_bci(struct drm_device * dev)
+static int savage_do_cleanup_bci(struct drm_device *dev)
 {
 	drm_savage_private_t *dev_priv = dev->dev_private;
 
@@ -1040,9 +1037,8 @@ int savage_bci_buffers(struct drm_device *dev, void *data, struct drm_file *file
 
 	d->granted_count = 0;
 
-	if (d->request_count) {
+	if (d->request_count)
 		ret = savage_bci_get_buffers(dev, file_priv, d);
-	}
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/savage/savage_drv.h b/drivers/gpu/drm/savage/savage_drv.h
index df2aac6..ca388ca 100644
--- a/drivers/gpu/drm/savage/savage_drv.h
+++ b/drivers/gpu/drm/savage/savage_drv.h
@@ -107,19 +107,22 @@ enum savage_family {
 extern struct drm_ioctl_desc savage_ioctls[];
 extern int savage_max_ioctl;
 
-#define S3_SAVAGE3D_SERIES(chip)  ((chip>=S3_SAVAGE3D) && (chip<=S3_SAVAGE_MX))
+#define S3_SAVAGE3D_SERIES(chip)	((chip >= S3_SAVAGE3D)		\
+					&& (chip <= S3_SAVAGE_MX))
 
-#define S3_SAVAGE4_SERIES(chip)  ((chip==S3_SAVAGE4)            \
-                                  || (chip==S3_PROSAVAGE)       \
-                                  || (chip==S3_TWISTER)         \
-                                  || (chip==S3_PROSAVAGEDDR))
+#define S3_SAVAGE4_SERIES(chip)		((chip == S3_SAVAGE4)		\
+					|| (chip == S3_PROSAVAGE)	\
+					|| (chip == S3_TWISTER)		\
+					|| (chip == S3_PROSAVAGEDDR))
 
-#define	S3_SAVAGE_MOBILE_SERIES(chip)	((chip==S3_SAVAGE_MX) || (chip==S3_SUPERSAVAGE))
+#define S3_SAVAGE_MOBILE_SERIES(chip)	((chip == S3_SAVAGE_MX)		\
+					|| (chip == S3_SUPERSAVAGE))
 
-#define S3_SAVAGE_SERIES(chip)    ((chip>=S3_SAVAGE3D) && (chip<=S3_SAVAGE2000))
+#define S3_SAVAGE_SERIES(chip)		((chip >= S3_SAVAGE3D)		\
+					&& (chip <= S3_SAVAGE2000))
 
-#define S3_MOBILE_TWISTER_SERIES(chip)   ((chip==S3_TWISTER)    \
-                                          ||(chip==S3_PROSAVAGEDDR))
+#define S3_MOBILE_TWISTER_SERIES(chip)	((chip == S3_TWISTER)		\
+					|| (chip == S3_PROSAVAGEDDR))
 
 /* flags */
 #define SAVAGE_IS_AGP 1
@@ -187,13 +190,13 @@ typedef struct drm_savage_private {
 	unsigned int waiting;
 
 	/* config/hardware-dependent function pointers */
-	int (*wait_fifo) (struct drm_savage_private * dev_priv, unsigned int n);
-	int (*wait_evnt) (struct drm_savage_private * dev_priv, uint16_t e);
+	int (*wait_fifo) (struct drm_savage_private *dev_priv, unsigned int n);
+	int (*wait_evnt) (struct drm_savage_private *dev_priv, uint16_t e);
 	/* Err, there is a macro wait_event in include/linux/wait.h.
 	 * Avoid unwanted macro expansion. */
-	void (*emit_clip_rect) (struct drm_savage_private * dev_priv,
-				const struct drm_clip_rect * pbox);
-	void (*dma_flush) (struct drm_savage_private * dev_priv);
+	void (*emit_clip_rect) (struct drm_savage_private *dev_priv,
+				const struct drm_clip_rect *pbox);
+	void (*dma_flush) (struct drm_savage_private *dev_priv);
 } drm_savage_private_t;
 
 /* ioctls */
@@ -201,12 +204,12 @@ extern int savage_bci_cmdbuf(struct drm_device *dev, void *data, struct drm_file
 extern int savage_bci_buffers(struct drm_device *dev, void *data, struct drm_file *file_priv);
 
 /* BCI functions */
-extern uint16_t savage_bci_emit_event(drm_savage_private_t * dev_priv,
+extern uint16_t savage_bci_emit_event(drm_savage_private_t *dev_priv,
 				      unsigned int flags);
-extern void savage_freelist_put(struct drm_device * dev, struct drm_buf * buf);
-extern void savage_dma_reset(drm_savage_private_t * dev_priv);
-extern void savage_dma_wait(drm_savage_private_t * dev_priv, unsigned int page);
-extern uint32_t *savage_dma_alloc(drm_savage_private_t * dev_priv,
+extern void savage_freelist_put(struct drm_device *dev, struct drm_buf *buf);
+extern void savage_dma_reset(drm_savage_private_t *dev_priv);
+extern void savage_dma_wait(drm_savage_private_t *dev_priv, unsigned int page);
+extern uint32_t *savage_dma_alloc(drm_savage_private_t *dev_priv,
 				  unsigned int n);
 extern int savage_driver_load(struct drm_device *dev, unsigned long chipset);
 extern int savage_driver_firstopen(struct drm_device *dev);
@@ -216,10 +219,10 @@ extern void savage_reclaim_buffers(struct drm_device *dev,
 				   struct drm_file *file_priv);
 
 /* state functions */
-extern void savage_emit_clip_rect_s3d(drm_savage_private_t * dev_priv,
-				      const struct drm_clip_rect * pbox);
-extern void savage_emit_clip_rect_s4(drm_savage_private_t * dev_priv,
-				     const struct drm_clip_rect * pbox);
+extern void savage_emit_clip_rect_s3d(drm_savage_private_t *dev_priv,
+				      const struct drm_clip_rect *pbox);
+extern void savage_emit_clip_rect_s4(drm_savage_private_t *dev_priv,
+				     const struct drm_clip_rect *pbox);
 
 #define SAVAGE_FB_SIZE_S3	0x01000000	/*  16MB */
 #define SAVAGE_FB_SIZE_S4	0x02000000	/*  32MB */
@@ -237,7 +240,7 @@ extern void savage_emit_clip_rect_s4(drm_savage_private_t * dev_priv,
  */
 #define SAVAGE_STATUS_WORD0		0x48C00
 #define SAVAGE_STATUS_WORD1		0x48C04
-#define SAVAGE_ALT_STATUS_WORD0 	0x48C60
+#define SAVAGE_ALT_STATUS_WORD0		0x48C60
 
 #define SAVAGE_FIFO_USED_MASK_S3D	0x0001ffff
 #define SAVAGE_FIFO_USED_MASK_S4	0x001fffff
@@ -455,29 +458,29 @@ extern void savage_emit_clip_rect_s4(drm_savage_private_t * dev_priv,
 /*
  * common commands
  */
-#define BCI_SET_REGISTERS( first, n )			\
+#define BCI_SET_REGISTERS(first, n)			\
 	BCI_WRITE(BCI_CMD_SET_REGISTER |		\
 		  ((uint32_t)(n) & 0xff) << 16 |	\
 		  ((uint32_t)(first) & 0xffff))
-#define DMA_SET_REGISTERS( first, n )			\
+#define DMA_SET_REGISTERS(first, n)			\
 	DMA_WRITE(BCI_CMD_SET_REGISTER |		\
 		  ((uint32_t)(n) & 0xff) << 16 |	\
 		  ((uint32_t)(first) & 0xffff))
 
-#define BCI_DRAW_PRIMITIVE(n, type, skip)         \
-        BCI_WRITE(BCI_CMD_DRAW_PRIM | (type) | (skip) | \
+#define BCI_DRAW_PRIMITIVE(n, type, skip)		\
+	BCI_WRITE(BCI_CMD_DRAW_PRIM | (type) | (skip) |	\
 		  ((n) << 16))
-#define DMA_DRAW_PRIMITIVE(n, type, skip)         \
-        DMA_WRITE(BCI_CMD_DRAW_PRIM | (type) | (skip) | \
+#define DMA_DRAW_PRIMITIVE(n, type, skip)		\
+	DMA_WRITE(BCI_CMD_DRAW_PRIM | (type) | (skip) |	\
 		  ((n) << 16))
 
-#define BCI_DRAW_INDICES_S3D(n, type, i0)         \
-        BCI_WRITE(BCI_CMD_DRAW_INDEXED_PRIM | (type) |  \
+#define BCI_DRAW_INDICES_S3D(n, type, i0)		\
+	BCI_WRITE(BCI_CMD_DRAW_INDEXED_PRIM | (type) |	\
 		  ((n) << 16) | (i0))
 
-#define BCI_DRAW_INDICES_S4(n, type, skip)        \
-        BCI_WRITE(BCI_CMD_DRAW_INDEXED_PRIM | (type) |  \
-                  (skip) | ((n) << 16))
+#define BCI_DRAW_INDICES_S4(n, type, skip)		\
+	BCI_WRITE(BCI_CMD_DRAW_INDEXED_PRIM | (type) |	\
+		  (skip) | ((n) << 16))
 
 #define BCI_DMA(n)	\
 	BCI_WRITE(BCI_CMD_DMA | (((n) >> 1) - 1))
@@ -485,8 +488,8 @@ extern void savage_emit_clip_rect_s4(drm_savage_private_t * dev_priv,
 /*
  * access to MMIO
  */
-#define SAVAGE_READ(reg)	DRM_READ32(  dev_priv->mmio, (reg) )
-#define SAVAGE_WRITE(reg)	DRM_WRITE32( dev_priv->mmio, (reg) )
+#define SAVAGE_READ(reg)	DRM_READ32(dev_priv->mmio, (reg))
+#define SAVAGE_WRITE(reg)	DRM_WRITE32(dev_priv->mmio, (reg))
 
 /*
  * access to the burst command interface (BCI)
@@ -495,12 +498,12 @@ extern void savage_emit_clip_rect_s4(drm_savage_private_t * dev_priv,
 
 #define BCI_LOCALS    volatile uint32_t *bci_ptr;
 
-#define BEGIN_BCI( n ) do {			\
+#define BEGIN_BCI(n) do {			\
 	dev_priv->wait_fifo(dev_priv, (n));	\
 	bci_ptr = dev_priv->bci_ptr;		\
-} while(0)
+} while (0)
 
-#define BCI_WRITE( val ) *bci_ptr++ = (uint32_t)(val)
+#define BCI_WRITE(val) (*bci_ptr++ = (uint32_t)(val))
 
 /*
  * command DMA support
@@ -509,7 +512,7 @@ extern void savage_emit_clip_rect_s4(drm_savage_private_t * dev_priv,
 
 #define DMA_LOCALS   uint32_t *dma_ptr;
 
-#define BEGIN_DMA( n ) do {						\
+#define BEGIN_DMA(n) do {						\
 	unsigned int cur = dev_priv->current_dma_page;			\
 	unsigned int rest = SAVAGE_DMA_PAGE_SIZE -			\
 		dev_priv->dma_pages[cur].used;				\
@@ -523,14 +526,14 @@ extern void savage_emit_clip_rect_s4(drm_savage_private_t * dev_priv,
 			savage_dma_wait(dev_priv, cur);			\
 		dev_priv->dma_pages[cur].used += (n);			\
 	}								\
-} while(0)
+} while (0)
 
-#define DMA_WRITE( val ) *dma_ptr++ = (uint32_t)(val)
+#define DMA_WRITE(val) (*dma_ptr++ = (uint32_t)(val))
 
 #define DMA_COPY(src, n) do {					\
 	memcpy(dma_ptr, (src), (n)*4);				\
 	dma_ptr += n;						\
-} while(0)
+} while (0)
 
 #if SAVAGE_DMA_DEBUG
 #define DMA_COMMIT() do {						\
@@ -543,17 +546,17 @@ extern void savage_emit_clip_rect_s4(drm_savage_private_t * dev_priv,
 			  "%p != %p\n", expected, dma_ptr);		\
 		savage_dma_reset(dev_priv);				\
 	}								\
-} while(0)
+} while (0)
 #else
-#define DMA_COMMIT() do {/* nothing */} while(0)
+#define DMA_COMMIT() do {/* nothing */} while (0)
 #endif
 
-#define DMA_FLUSH() dev_priv->dma_flush(dev_priv)
+#define DMA_FLUSH() (dev_priv->dma_flush(dev_priv))
 
 /* Buffer aging via event tag
  */
 
-#define UPDATE_EVENT_COUNTER( ) do {			\
+#define UPDATE_EVENT_COUNTER() do {			\
 	if (dev_priv->status_ptr) {			\
 		uint16_t count;				\
 		/* coordinate with Xserver */		\
@@ -562,14 +565,14 @@ extern void savage_emit_clip_rect_s4(drm_savage_private_t * dev_priv,
 			dev_priv->event_wrap++;		\
 		dev_priv->event_counter = count;	\
 	}						\
-} while(0)
+} while (0)
 
-#define SET_AGE( age, e, w ) do {	\
+#define SET_AGE(age, e, w) do {		\
 	(age)->event = e;		\
 	(age)->wrap = w;		\
-} while(0)
+} while (0)
 
-#define TEST_AGE( age, e, w )				\
-	( (age)->wrap < (w) || ( (age)->wrap == (w) && (age)->event <= (e) ) )
+#define TEST_AGE(age, e, w)				\
+	((age)->wrap < (w) || ((age)->wrap == (w) && (age)->event <= (e)))
 
 #endif				/* __SAVAGE_DRV_H__ */
diff --git a/drivers/gpu/drm/savage/savage_state.c b/drivers/gpu/drm/savage/savage_state.c
index 8a3e315..bd14dcb 100644
--- a/drivers/gpu/drm/savage/savage_state.c
+++ b/drivers/gpu/drm/savage/savage_state.c
@@ -26,8 +26,8 @@
 #include "savage_drm.h"
 #include "savage_drv.h"
 
-void savage_emit_clip_rect_s3d(drm_savage_private_t * dev_priv,
-			       const struct drm_clip_rect * pbox)
+void savage_emit_clip_rect_s3d(drm_savage_private_t *dev_priv,
+			       const struct drm_clip_rect *pbox)
 {
 	uint32_t scstart = dev_priv->state.s3d.new_scstart;
 	uint32_t scend = dev_priv->state.s3d.new_scend;
@@ -52,8 +52,8 @@ void savage_emit_clip_rect_s3d(drm_savage_private_t * dev_priv,
 	}
 }
 
-void savage_emit_clip_rect_s4(drm_savage_private_t * dev_priv,
-			      const struct drm_clip_rect * pbox)
+void savage_emit_clip_rect_s4(drm_savage_private_t *dev_priv,
+			      const struct drm_clip_rect *pbox)
 {
 	uint32_t drawctrl0 = dev_priv->state.s4.new_drawctrl0;
 	uint32_t drawctrl1 = dev_priv->state.s4.new_drawctrl1;
@@ -78,7 +78,7 @@ void savage_emit_clip_rect_s4(drm_savage_private_t * dev_priv,
 	}
 }
 
-static int savage_verify_texaddr(drm_savage_private_t * dev_priv, int unit,
+static int savage_verify_texaddr(drm_savage_private_t *dev_priv, int unit,
 				 uint32_t addr)
 {
 	if ((addr & 6) != 2) {	/* reserved bits */
@@ -113,11 +113,11 @@ static int savage_verify_texaddr(drm_savage_private_t * dev_priv, int unit,
 	return 0;
 }
 
-#define SAVE_STATE(reg,where)			\
-	if(start <= reg && start+count > reg)	\
+#define SAVE_STATE(reg, where)			\
+	if (start <= reg && start+count > reg)	\
 		dev_priv->state.where = regs[reg - start]
-#define SAVE_STATE_MASK(reg,where,mask) do {			\
-	if(start <= reg && start+count > reg) {			\
+#define SAVE_STATE_MASK(reg, where, mask) do {			\
+	if (start <= reg && start+count > reg) {		\
 		uint32_t tmp;					\
 		tmp = regs[reg - start];			\
 		dev_priv->state.where = (tmp & (mask)) |	\
@@ -125,7 +125,7 @@ static int savage_verify_texaddr(drm_savage_private_t * dev_priv, int unit,
 	}							\
 } while (0)
 
-static int savage_verify_state_s3d(drm_savage_private_t * dev_priv,
+static int savage_verify_state_s3d(drm_savage_private_t *dev_priv,
 				   unsigned int start, unsigned int count,
 				   const uint32_t *regs)
 {
@@ -155,7 +155,7 @@ static int savage_verify_state_s3d(drm_savage_private_t * dev_priv,
 	return 0;
 }
 
-static int savage_verify_state_s4(drm_savage_private_t * dev_priv,
+static int savage_verify_state_s4(drm_savage_private_t *dev_priv,
 				  unsigned int start, unsigned int count,
 				  const uint32_t *regs)
 {
@@ -194,8 +194,8 @@ static int savage_verify_state_s4(drm_savage_private_t * dev_priv,
 #undef SAVE_STATE
 #undef SAVE_STATE_MASK
 
-static int savage_dispatch_state(drm_savage_private_t * dev_priv,
-				 const drm_savage_cmd_header_t * cmd_header,
+static int savage_dispatch_state(drm_savage_private_t *dev_priv,
+				 const drm_savage_cmd_header_t *cmd_header,
 				 const uint32_t *regs)
 {
 	unsigned int count = cmd_header->state.count;
@@ -275,9 +275,9 @@ static int savage_dispatch_state(drm_savage_private_t * dev_priv,
 	return 0;
 }
 
-static int savage_dispatch_dma_prim(drm_savage_private_t * dev_priv,
-				    const drm_savage_cmd_header_t * cmd_header,
-				    const struct drm_buf * dmabuf)
+static int savage_dispatch_dma_prim(drm_savage_private_t *dev_priv,
+				    const drm_savage_cmd_header_t *cmd_header,
+				    const struct drm_buf *dmabuf)
 {
 	unsigned char reorder = 0;
 	unsigned int prim = cmd_header->prim.prim;
@@ -415,8 +415,8 @@ static int savage_dispatch_dma_prim(drm_savage_private_t * dev_priv,
 	return 0;
 }
 
-static int savage_dispatch_vb_prim(drm_savage_private_t * dev_priv,
-				   const drm_savage_cmd_header_t * cmd_header,
+static int savage_dispatch_vb_prim(drm_savage_private_t *dev_priv,
+				   const drm_savage_cmd_header_t *cmd_header,
 				   const uint32_t *vtxbuf, unsigned int vb_size,
 				   unsigned int vb_stride)
 {
@@ -516,7 +516,7 @@ static int savage_dispatch_vb_prim(drm_savage_private_t * dev_priv,
 					 vtx_size * count);
 			} else {
 				for (i = start; i < start + count; ++i) {
-					DMA_COPY(&vtxbuf [vb_stride * i],
+					DMA_COPY(&vtxbuf[vb_stride * i],
 						 vtx_size);
 				}
 			}
@@ -533,10 +533,10 @@ static int savage_dispatch_vb_prim(drm_savage_private_t * dev_priv,
 	return 0;
 }
 
-static int savage_dispatch_dma_idx(drm_savage_private_t * dev_priv,
-				   const drm_savage_cmd_header_t * cmd_header,
+static int savage_dispatch_dma_idx(drm_savage_private_t *dev_priv,
+				   const drm_savage_cmd_header_t *cmd_header,
 				   const uint16_t *idx,
-				   const struct drm_buf * dmabuf)
+				   const struct drm_buf *dmabuf)
 {
 	unsigned char reorder = 0;
 	unsigned int prim = cmd_header->idx.prim;
@@ -674,8 +674,8 @@ static int savage_dispatch_dma_idx(drm_savage_private_t * dev_priv,
 	return 0;
 }
 
-static int savage_dispatch_vb_idx(drm_savage_private_t * dev_priv,
-				  const drm_savage_cmd_header_t * cmd_header,
+static int savage_dispatch_vb_idx(drm_savage_private_t *dev_priv,
+				  const drm_savage_cmd_header_t *cmd_header,
 				  const uint16_t *idx,
 				  const uint32_t *vtxbuf,
 				  unsigned int vb_size, unsigned int vb_stride)
@@ -788,8 +788,8 @@ static int savage_dispatch_vb_idx(drm_savage_private_t * dev_priv,
 	return 0;
 }
 
-static int savage_dispatch_clear(drm_savage_private_t * dev_priv,
-				 const drm_savage_cmd_header_t * cmd_header,
+static int savage_dispatch_clear(drm_savage_private_t *dev_priv,
+				 const drm_savage_cmd_header_t *cmd_header,
 				 const drm_savage_cmd_header_t *data,
 				 unsigned int nbox,
 				 const struct drm_clip_rect *boxes)
@@ -860,7 +860,7 @@ static int savage_dispatch_clear(drm_savage_private_t * dev_priv,
 	return 0;
 }
 
-static int savage_dispatch_swap(drm_savage_private_t * dev_priv,
+static int savage_dispatch_swap(drm_savage_private_t *dev_priv,
 				unsigned int nbox, const struct drm_clip_rect *boxes)
 {
 	unsigned int swap_cmd;
@@ -889,10 +889,10 @@ static int savage_dispatch_swap(drm_savage_private_t * dev_priv,
 	return 0;
 }
 
-static int savage_dispatch_draw(drm_savage_private_t * dev_priv,
+static int savage_dispatch_draw(drm_savage_private_t *dev_priv,
 				const drm_savage_cmd_header_t *start,
 				const drm_savage_cmd_header_t *end,
-				const struct drm_buf * dmabuf,
+				const struct drm_buf *dmabuf,
 				const unsigned int *vtxbuf,
 				unsigned int vb_size, unsigned int vb_stride,
 				unsigned int nbox,
@@ -993,8 +993,7 @@ int savage_bci_cmdbuf(struct drm_device *dev, void *data, struct drm_file *file_
 			return -ENOMEM;
 
 		if (DRM_COPY_FROM_USER(kcmd_addr, cmdbuf->cmd_addr,
-				       cmdbuf->size * 8))
-		{
+				       cmdbuf->size * 8)) {
 			kfree(kcmd_addr);
 			return -EFAULT;
 		}
@@ -1132,7 +1131,7 @@ int savage_bci_cmdbuf(struct drm_device *dev, void *data, struct drm_file *file_
 	}
 
 	if (first_draw_cmd) {
-		ret = savage_dispatch_draw (
+		ret = savage_dispatch_draw(
 			dev_priv, first_draw_cmd, cmdbuf->cmd_addr, dmabuf,
 			cmdbuf->vb_addr, cmdbuf->vb_size, cmdbuf->vb_stride,
 			cmdbuf->nbox, cmdbuf->box_addr);
-- 
1.7.1
