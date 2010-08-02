Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab0HBKYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 06:24:19 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:39797 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152Ab0HBKYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 06:24:17 -0400
Date: Mon, 2 Aug 2010 12:13:03 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH] [drm-core-next] drm: Fixed coding style issues
Message-ID: <20100802121303.52d71307@absol.kitzblitz>
In-Reply-To: <1280708213.2393.2.camel@clockmaker-el6>
References: <20100714161131.296330a5@absol.kitzblitz>
 <1280708213.2393.2.camel@clockmaker-el6>
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

Fixed some brace, spacing and whitespace, printk, and
initialisation of statics and globals coding style issues.

Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
---
Against drm-core-next.
Supersedes "drm: fixed brace, spacing and whitespace
            coding style issues"

 drivers/gpu/drm/ati_pcigart.c       |    9 ++--
 drivers/gpu/drm/drm_agpsupport.c    |   15 +++----
 drivers/gpu/drm/drm_auth.c          |    2 +-
 drivers/gpu/drm/drm_bufs.c          |   48 ++++++++-----------
 drivers/gpu/drm/drm_context.c       |   17 +++----
 drivers/gpu/drm/drm_crtc.c          |   53 ++++++++-------------
 drivers/gpu/drm/drm_crtc_helper.c   |    7 +--
 drivers/gpu/drm/drm_dma.c           |    7 +--
 drivers/gpu/drm/drm_dp_i2c_helper.c |    5 +-
 drivers/gpu/drm/drm_drawable.c      |    3 +-
 drivers/gpu/drm/drm_drv.c           |    9 +---
 drivers/gpu/drm/drm_edid.c          |   23 ++++-----
 drivers/gpu/drm/drm_fb_helper.c     |   32 +++++++-------
 drivers/gpu/drm/drm_fops.c          |    8 ++--
 drivers/gpu/drm/drm_hashtab.c       |   13 ++---
 drivers/gpu/drm/drm_ioc32.c         |    1 -
 drivers/gpu/drm/drm_irq.c           |    4 +-
 drivers/gpu/drm/drm_lock.c          |   11 ++---
 drivers/gpu/drm/drm_memory.c        |   12 +++---
 drivers/gpu/drm/drm_mm.c            |   12 ++---
 drivers/gpu/drm/drm_modes.c         |    3 +-
 drivers/gpu/drm/drm_pci.c           |    6 +--
 drivers/gpu/drm/drm_proc.c          |    2 +-
 drivers/gpu/drm/drm_scatter.c       |    4 +-
 drivers/gpu/drm/drm_sman.c          |   34 ++++----------
 drivers/gpu/drm/drm_stub.c          |   24 +++++-----
 drivers/gpu/drm/drm_sysfs.c         |   86 +++++++++++++++++-----------------
 drivers/gpu/drm/drm_vm.c            |    7 +--
 28 files changed, 195 insertions(+), 262 deletions(-)

diff --git a/drivers/gpu/drm/ati_pcigart.c b/drivers/gpu/drm/ati_pcigart.c
index 17be051..a8df5e9 100644
--- a/drivers/gpu/drm/ati_pcigart.c
+++ b/drivers/gpu/drm/ati_pcigart.c
@@ -141,11 +141,10 @@ int drm_ati_pcigart_init(struct drm_device *dev, struct drm_ati_pcigart_info *ga
 	pages = (entry->pages <= max_real_pages)
 	    ? entry->pages : max_real_pages;
 
-	if (gart_info->gart_table_location == DRM_ATI_GART_MAIN) {
+	if (gart_info->gart_table_location == DRM_ATI_GART_MAIN)
 		memset(pci_gart, 0, max_ati_pages * sizeof(u32));
-	} else {
+	else
 		memset_io((void __iomem *)map->handle, 0, max_ati_pages * sizeof(u32));
-	}
 
 	gart_idx = 0;
 	for (i = 0; i < pages; i++) {
@@ -164,7 +163,7 @@ int drm_ati_pcigart_init(struct drm_device *dev, struct drm_ati_pcigart_info *ga
 		for (j = 0; j < (PAGE_SIZE / ATI_PCIGART_PAGE_SIZE); j++) {
 			u32 val;
 
-			switch(gart_info->gart_reg_if) {
+			switch (gart_info->gart_reg_if) {
 			case DRM_ATI_GART_IGP:
 				val = page_base | 0xc;
 				break;
@@ -193,7 +192,7 @@ int drm_ati_pcigart_init(struct drm_device *dev, struct drm_ati_pcigart_info *ga
 	mb();
 #endif
 
-      done:
+done:
 	gart_info->addr = address;
 	gart_info->bus_addr = bus_address;
 	return ret;
diff --git a/drivers/gpu/drm/drm_agpsupport.c b/drivers/gpu/drm/drm_agpsupport.c
index ba38e01..91ca82d 100644
--- a/drivers/gpu/drm/drm_agpsupport.c
+++ b/drivers/gpu/drm/drm_agpsupport.c
@@ -71,7 +71,6 @@ int drm_agp_info(struct drm_device *dev, struct drm_agp_info *info)
 
 	return 0;
 }
-
 EXPORT_SYMBOL(drm_agp_info);
 
 int drm_agp_info_ioctl(struct drm_device *dev, void *data,
@@ -96,7 +95,7 @@ int drm_agp_info_ioctl(struct drm_device *dev, void *data,
  * Verifies the AGP device hasn't been acquired before and calls
  * \c agp_backend_acquire.
  */
-int drm_agp_acquire(struct drm_device * dev)
+int drm_agp_acquire(struct drm_device *dev)
 {
 	if (!dev->agp)
 		return -ENODEV;
@@ -107,7 +106,6 @@ int drm_agp_acquire(struct drm_device * dev)
 	dev->agp->acquired = 1;
 	return 0;
 }
-
 EXPORT_SYMBOL(drm_agp_acquire);
 
 /**
@@ -136,7 +134,7 @@ int drm_agp_acquire_ioctl(struct drm_device *dev, void *data,
  *
  * Verifies the AGP device has been acquired and calls \c agp_backend_release.
  */
-int drm_agp_release(struct drm_device * dev)
+int drm_agp_release(struct drm_device *dev)
 {
 	if (!dev->agp || !dev->agp->acquired)
 		return -EINVAL;
@@ -162,7 +160,7 @@ int drm_agp_release_ioctl(struct drm_device *dev, void *data,
  * Verifies the AGP device has been acquired but not enabled, and calls
  * \c agp_enable.
  */
-int drm_agp_enable(struct drm_device * dev, struct drm_agp_mode mode)
+int drm_agp_enable(struct drm_device *dev, struct drm_agp_mode mode)
 {
 	if (!dev->agp || !dev->agp->acquired)
 		return -EINVAL;
@@ -172,7 +170,6 @@ int drm_agp_enable(struct drm_device * dev, struct drm_agp_mode mode)
 	dev->agp->enabled = 1;
 	return 0;
 }
-
 EXPORT_SYMBOL(drm_agp_enable);
 
 int drm_agp_enable_ioctl(struct drm_device *dev, void *data,
@@ -431,7 +428,7 @@ DRM_AGP_MEM *drm_agp_allocate_memory(struct agp_bridge_data * bridge,
 }
 
 /** Calls agp_free_memory() */
-int drm_agp_free_memory(DRM_AGP_MEM * handle)
+int drm_agp_free_memory(DRM_AGP_MEM *handle)
 {
 	if (!handle)
 		return 0;
@@ -440,7 +437,7 @@ int drm_agp_free_memory(DRM_AGP_MEM * handle)
 }
 
 /** Calls agp_bind_memory() */
-int drm_agp_bind_memory(DRM_AGP_MEM * handle, off_t start)
+int drm_agp_bind_memory(DRM_AGP_MEM *handle, off_t start)
 {
 	if (!handle)
 		return -EINVAL;
@@ -448,7 +445,7 @@ int drm_agp_bind_memory(DRM_AGP_MEM * handle, off_t start)
 }
 
 /** Calls agp_unbind_memory() */
-int drm_agp_unbind_memory(DRM_AGP_MEM * handle)
+int drm_agp_unbind_memory(DRM_AGP_MEM *handle)
 {
 	if (!handle)
 		return -EINVAL;
diff --git a/drivers/gpu/drm/drm_auth.c b/drivers/gpu/drm/drm_auth.c
index 3f46772..fbd5a64 100644
--- a/drivers/gpu/drm/drm_auth.c
+++ b/drivers/gpu/drm/drm_auth.c
@@ -139,7 +139,7 @@ static int drm_remove_magic(struct drm_master *master, drm_magic_t magic)
  */
 int drm_getmagic(struct drm_device *dev, void *data, struct drm_file *file_priv)
 {
-	static drm_magic_t sequence = 0;
+	static drm_magic_t sequence;
 	static DEFINE_SPINLOCK(lock);
 	struct drm_auth *auth = data;
 
diff --git a/drivers/gpu/drm/drm_bufs.c b/drivers/gpu/drm/drm_bufs.c
index a5c9ce9..97776af 100644
--- a/drivers/gpu/drm/drm_bufs.c
+++ b/drivers/gpu/drm/drm_bufs.c
@@ -128,10 +128,10 @@ static int drm_map_handle(struct drm_device *dev, struct drm_hash_item *hash,
  * type.  Adds the map to the map list drm_device::maplist. Adds MTRR's where
  * applicable and if supported by the kernel.
  */
-static int drm_addmap_core(struct drm_device * dev, resource_size_t offset,
+static int drm_addmap_core(struct drm_device *dev, resource_size_t offset,
 			   unsigned int size, enum drm_map_type type,
 			   enum drm_map_flags flags,
-			   struct drm_map_list ** maplist)
+			   struct drm_map_list **maplist)
 {
 	struct drm_local_map *map;
 	struct drm_map_list *list;
@@ -224,7 +224,7 @@ static int drm_addmap_core(struct drm_device * dev, resource_size_t offset,
 	case _DRM_SHM:
 		list = drm_find_matching_map(dev, map);
 		if (list != NULL) {
-			if(list->map->size != map->size) {
+			if (list->map->size != map->size) {
 				DRM_DEBUG("Matching maps of type %d with "
 					  "mismatched sizes, (%ld vs %ld)\n",
 					  map->type, map->size, list->map->size);
@@ -365,9 +365,9 @@ static int drm_addmap_core(struct drm_device * dev, resource_size_t offset,
 	return 0;
 	}
 
-int drm_addmap(struct drm_device * dev, resource_size_t offset,
+int drm_addmap(struct drm_device *dev, resource_size_t offset,
 	       unsigned int size, enum drm_map_type type,
-	       enum drm_map_flags flags, struct drm_local_map ** map_ptr)
+	       enum drm_map_flags flags, struct drm_local_map **map_ptr)
 {
 	struct drm_map_list *list;
 	int rc;
@@ -377,7 +377,6 @@ int drm_addmap(struct drm_device * dev, resource_size_t offset,
 		*map_ptr = list->map;
 	return rc;
 }
-
 EXPORT_SYMBOL(drm_addmap);
 
 /**
@@ -559,16 +558,15 @@ int drm_rmmap_ioctl(struct drm_device *dev, void *data,
  *
  * Frees any pages and buffers associated with the given entry.
  */
-static void drm_cleanup_buf_error(struct drm_device * dev,
-				  struct drm_buf_entry * entry)
+static void drm_cleanup_buf_error(struct drm_device *dev,
+				  struct drm_buf_entry *entry)
 {
 	int i;
 
 	if (entry->seg_count) {
 		for (i = 0; i < entry->seg_count; i++) {
-			if (entry->seglist[i]) {
+			if (entry->seglist[i])
 				drm_pci_free(dev, entry->seglist[i]);
-			}
 		}
 		kfree(entry->seglist);
 
@@ -576,9 +574,8 @@ static void drm_cleanup_buf_error(struct drm_device * dev,
 	}
 
 	if (entry->buf_count) {
-		for (i = 0; i < entry->buf_count; i++) {
+		for (i = 0; i < entry->buf_count; i++)
 			kfree(entry->buflist[i].dev_private);
-		}
 		kfree(entry->buflist);
 
 		entry->buf_count = 0;
@@ -597,7 +594,7 @@ static void drm_cleanup_buf_error(struct drm_device * dev,
  * reallocates the buffer list of the same size order to accommodate the new
  * buffers.
  */
-int drm_addbufs_agp(struct drm_device * dev, struct drm_buf_desc * request)
+int drm_addbufs_agp(struct drm_device *dev, struct drm_buf_desc *request)
 {
 	struct drm_device_dma *dma = dev->dma;
 	struct drm_buf_entry *entry;
@@ -740,9 +737,8 @@ int drm_addbufs_agp(struct drm_device * dev, struct drm_buf_desc * request)
 	}
 	dma->buflist = temp_buflist;
 
-	for (i = 0; i < entry->buf_count; i++) {
+	for (i = 0; i < entry->buf_count; i++)
 		dma->buflist[i + dma->buf_count] = &entry->buflist[i];
-	}
 
 	dma->buf_count += entry->buf_count;
 	dma->seg_count += entry->seg_count;
@@ -765,7 +761,7 @@ int drm_addbufs_agp(struct drm_device * dev, struct drm_buf_desc * request)
 EXPORT_SYMBOL(drm_addbufs_agp);
 #endif				/* __OS_HAS_AGP */
 
-int drm_addbufs_pci(struct drm_device * dev, struct drm_buf_desc * request)
+int drm_addbufs_pci(struct drm_device *dev, struct drm_buf_desc *request)
 {
 	struct drm_device_dma *dma = dev->dma;
 	int count;
@@ -944,16 +940,14 @@ int drm_addbufs_pci(struct drm_device * dev, struct drm_buf_desc * request)
 	}
 	dma->buflist = temp_buflist;
 
-	for (i = 0; i < entry->buf_count; i++) {
+	for (i = 0; i < entry->buf_count; i++)
 		dma->buflist[i + dma->buf_count] = &entry->buflist[i];
-	}
 
 	/* No allocations failed, so now we can replace the original pagelist
 	 * with the new one.
 	 */
-	if (dma->page_count) {
+	if (dma->page_count)
 		kfree(dma->pagelist);
-	}
 	dma->pagelist = temp_pagelist;
 
 	dma->buf_count += entry->buf_count;
@@ -975,7 +969,7 @@ int drm_addbufs_pci(struct drm_device * dev, struct drm_buf_desc * request)
 }
 EXPORT_SYMBOL(drm_addbufs_pci);
 
-static int drm_addbufs_sg(struct drm_device * dev, struct drm_buf_desc * request)
+static int drm_addbufs_sg(struct drm_device *dev, struct drm_buf_desc *request)
 {
 	struct drm_device_dma *dma = dev->dma;
 	struct drm_buf_entry *entry;
@@ -1113,9 +1107,8 @@ static int drm_addbufs_sg(struct drm_device * dev, struct drm_buf_desc * request
 	}
 	dma->buflist = temp_buflist;
 
-	for (i = 0; i < entry->buf_count; i++) {
+	for (i = 0; i < entry->buf_count; i++)
 		dma->buflist[i + dma->buf_count] = &entry->buflist[i];
-	}
 
 	dma->buf_count += entry->buf_count;
 	dma->seg_count += entry->seg_count;
@@ -1136,7 +1129,7 @@ static int drm_addbufs_sg(struct drm_device * dev, struct drm_buf_desc * request
 	return 0;
 }
 
-static int drm_addbufs_fb(struct drm_device * dev, struct drm_buf_desc * request)
+static int drm_addbufs_fb(struct drm_device *dev, struct drm_buf_desc *request)
 {
 	struct drm_device_dma *dma = dev->dma;
 	struct drm_buf_entry *entry;
@@ -1272,9 +1265,8 @@ static int drm_addbufs_fb(struct drm_device * dev, struct drm_buf_desc * request
 	}
 	dma->buflist = temp_buflist;
 
-	for (i = 0; i < entry->buf_count; i++) {
+	for (i = 0; i < entry->buf_count; i++)
 		dma->buflist[i + dma->buf_count] = &entry->buflist[i];
-	}
 
 	dma->buf_count += entry->buf_count;
 	dma->seg_count += entry->seg_count;
@@ -1525,7 +1517,7 @@ int drm_freebufs(struct drm_device *dev, void *data,
  * drm_mmap_dma().
  */
 int drm_mapbufs(struct drm_device *dev, void *data,
-	        struct drm_file *file_priv)
+		struct drm_file *file_priv)
 {
 	struct drm_device_dma *dma = dev->dma;
 	int retcode = 0;
@@ -1608,7 +1600,7 @@ int drm_mapbufs(struct drm_device *dev, void *data,
 			}
 		}
 	}
-      done:
+done:
 	request->count = dma->buf_count;
 	DRM_DEBUG("%d buffers, retcode = %d\n", request->count, retcode);
 
diff --git a/drivers/gpu/drm/drm_context.c b/drivers/gpu/drm/drm_context.c
index 2607753..ef52ccd 100644
--- a/drivers/gpu/drm/drm_context.c
+++ b/drivers/gpu/drm/drm_context.c
@@ -56,7 +56,7 @@
  * in drm_device::ctx_idr, while holding the drm_device::struct_mutex
  * lock.
  */
-void drm_ctxbitmap_free(struct drm_device * dev, int ctx_handle)
+void drm_ctxbitmap_free(struct drm_device *dev, int ctx_handle)
 {
 	mutex_lock(&dev->struct_mutex);
 	idr_remove(&dev->ctx_idr, ctx_handle);
@@ -72,7 +72,7 @@ void drm_ctxbitmap_free(struct drm_device * dev, int ctx_handle)
  * Allocate a new idr from drm_device::ctx_idr while holding the
  * drm_device::struct_mutex lock.
  */
-static int drm_ctxbitmap_next(struct drm_device * dev)
+static int drm_ctxbitmap_next(struct drm_device *dev)
 {
 	int new_id;
 	int ret;
@@ -100,7 +100,7 @@ again:
  *
  * Initialise the drm_device::ctx_idr
  */
-int drm_ctxbitmap_init(struct drm_device * dev)
+int drm_ctxbitmap_init(struct drm_device *dev)
 {
 	idr_init(&dev->ctx_idr);
 	return 0;
@@ -114,7 +114,7 @@ int drm_ctxbitmap_init(struct drm_device * dev)
  * Free all idr members using drm_ctx_sarea_free helper function
  * while holding the drm_device::struct_mutex lock.
  */
-void drm_ctxbitmap_cleanup(struct drm_device * dev)
+void drm_ctxbitmap_cleanup(struct drm_device *dev)
 {
 	mutex_lock(&dev->struct_mutex);
 	idr_remove_all(&dev->ctx_idr);
@@ -195,11 +195,11 @@ int drm_setsareactx(struct drm_device *dev, void *data,
 		    && r_list->user_token == (unsigned long) request->handle)
 			goto found;
 	}
-      bad:
+bad:
 	mutex_unlock(&dev->struct_mutex);
 	return -EINVAL;
 
-      found:
+found:
 	map = r_list->map;
 	if (!map)
 		goto bad;
@@ -228,7 +228,7 @@ int drm_setsareactx(struct drm_device *dev, void *data,
  *
  * Attempt to set drm_device::context_flag.
  */
-static int drm_context_switch(struct drm_device * dev, int old, int new)
+static int drm_context_switch(struct drm_device *dev, int old, int new)
 {
 	if (test_and_set_bit(0, &dev->context_flag)) {
 		DRM_ERROR("Reentering -- FIXME\n");
@@ -262,9 +262,8 @@ static int drm_context_switch_complete(struct drm_device *dev,
 	dev->last_context = new;	/* PRE/POST: This is the _only_ writer. */
 	dev->last_switch = jiffies;
 
-	if (!_DRM_LOCK_IS_HELD(file_priv->master->lock.hw_lock->lock)) {
+	if (!_DRM_LOCK_IS_HELD(file_priv->master->lock.hw_lock->lock))
 		DRM_ERROR("Lock isn't held after context switch\n");
-	}
 
 	/* If a context switch is ever initiated
 	   when the kernel holds the lock, release
diff --git a/drivers/gpu/drm/drm_crtc.c b/drivers/gpu/drm/drm_crtc.c
index 4c68f76..bd2fdf1 100644
--- a/drivers/gpu/drm/drm_crtc.c
+++ b/drivers/gpu/drm/drm_crtc.c
@@ -56,8 +56,8 @@ struct drm_prop_enum_list {
 /*
  * Global properties
  */
-static struct drm_prop_enum_list drm_dpms_enum_list[] =
-{	{ DRM_MODE_DPMS_ON, "On" },
+static struct drm_prop_enum_list drm_dpms_enum_list[] = {
+	{ DRM_MODE_DPMS_ON, "On" },
 	{ DRM_MODE_DPMS_STANDBY, "Standby" },
 	{ DRM_MODE_DPMS_SUSPEND, "Suspend" },
 	{ DRM_MODE_DPMS_OFF, "Off" }
@@ -68,16 +68,14 @@ DRM_ENUM_NAME_FN(drm_get_dpms_name, drm_dpms_enum_list)
 /*
  * Optional properties
  */
-static struct drm_prop_enum_list drm_scaling_mode_enum_list[] =
-{
+static struct drm_prop_enum_list drm_scaling_mode_enum_list[] = {
 	{ DRM_MODE_SCALE_NONE, "None" },
 	{ DRM_MODE_SCALE_FULLSCREEN, "Full" },
 	{ DRM_MODE_SCALE_CENTER, "Center" },
 	{ DRM_MODE_SCALE_ASPECT, "Full aspect" },
 };
 
-static struct drm_prop_enum_list drm_dithering_mode_enum_list[] =
-{
+static struct drm_prop_enum_list drm_dithering_mode_enum_list[] = {
 	{ DRM_MODE_DITHERING_OFF, "Off" },
 	{ DRM_MODE_DITHERING_ON, "On" },
 	{ DRM_MODE_DITHERING_AUTO, "Automatic" },
@@ -86,8 +84,7 @@ static struct drm_prop_enum_list drm_dithering_mode_enum_list[] =
 /*
  * Non-global properties, but "required" for certain connectors.
  */
-static struct drm_prop_enum_list drm_dvi_i_select_enum_list[] =
-{
+static struct drm_prop_enum_list drm_dvi_i_select_enum_list[] = {
 	{ DRM_MODE_SUBCONNECTOR_Automatic, "Automatic" }, /* DVI-I and TV-out */
 	{ DRM_MODE_SUBCONNECTOR_DVID,      "DVI-D"     }, /* DVI-I  */
 	{ DRM_MODE_SUBCONNECTOR_DVIA,      "DVI-A"     }, /* DVI-I  */
@@ -95,8 +92,7 @@ static struct drm_prop_enum_list drm_dvi_i_select_enum_list[] =
 
 DRM_ENUM_NAME_FN(drm_get_dvi_i_select_name, drm_dvi_i_select_enum_list)
 
-static struct drm_prop_enum_list drm_dvi_i_subconnector_enum_list[] =
-{
+static struct drm_prop_enum_list drm_dvi_i_subconnector_enum_list[] = {
 	{ DRM_MODE_SUBCONNECTOR_Unknown,   "Unknown"   }, /* DVI-I and TV-out */
 	{ DRM_MODE_SUBCONNECTOR_DVID,      "DVI-D"     }, /* DVI-I  */
 	{ DRM_MODE_SUBCONNECTOR_DVIA,      "DVI-A"     }, /* DVI-I  */
@@ -105,8 +101,7 @@ static struct drm_prop_enum_list drm_dvi_i_subconnector_enum_list[] =
 DRM_ENUM_NAME_FN(drm_get_dvi_i_subconnector_name,
 		 drm_dvi_i_subconnector_enum_list)
 
-static struct drm_prop_enum_list drm_tv_select_enum_list[] =
-{
+static struct drm_prop_enum_list drm_tv_select_enum_list[] = {
 	{ DRM_MODE_SUBCONNECTOR_Automatic, "Automatic" }, /* DVI-I and TV-out */
 	{ DRM_MODE_SUBCONNECTOR_Composite, "Composite" }, /* TV-out */
 	{ DRM_MODE_SUBCONNECTOR_SVIDEO,    "SVIDEO"    }, /* TV-out */
@@ -116,8 +111,7 @@ static struct drm_prop_enum_list drm_tv_select_enum_list[] =
 
 DRM_ENUM_NAME_FN(drm_get_tv_select_name, drm_tv_select_enum_list)
 
-static struct drm_prop_enum_list drm_tv_subconnector_enum_list[] =
-{
+static struct drm_prop_enum_list drm_tv_subconnector_enum_list[] = {
 	{ DRM_MODE_SUBCONNECTOR_Unknown,   "Unknown"   }, /* DVI-I and TV-out */
 	{ DRM_MODE_SUBCONNECTOR_Composite, "Composite" }, /* TV-out */
 	{ DRM_MODE_SUBCONNECTOR_SVIDEO,    "SVIDEO"    }, /* TV-out */
@@ -146,8 +140,8 @@ struct drm_conn_prop_enum_list {
 /*
  * Connector and encoder types.
  */
-static struct drm_conn_prop_enum_list drm_connector_enum_list[] =
-{	{ DRM_MODE_CONNECTOR_Unknown, "Unknown", 0 },
+static struct drm_conn_prop_enum_list drm_connector_enum_list[] = {
+	{ DRM_MODE_CONNECTOR_Unknown, "Unknown", 0 },
 	{ DRM_MODE_CONNECTOR_VGA, "VGA", 0 },
 	{ DRM_MODE_CONNECTOR_DVII, "DVI-I", 0 },
 	{ DRM_MODE_CONNECTOR_DVID, "DVI-D", 0 },
@@ -164,8 +158,8 @@ static struct drm_conn_prop_enum_list drm_connector_enum_list[] =
 	{ DRM_MODE_CONNECTOR_eDP, "Embedded DisplayPort", 0 },
 };
 
-static struct drm_prop_enum_list drm_encoder_enum_list[] =
-{	{ DRM_MODE_ENCODER_NONE, "None" },
+static struct drm_prop_enum_list drm_encoder_enum_list[] = {
+	{ DRM_MODE_ENCODER_NONE, "None" },
 	{ DRM_MODE_ENCODER_DAC, "DAC" },
 	{ DRM_MODE_ENCODER_TMDS, "TMDS" },
 	{ DRM_MODE_ENCODER_LVDS, "LVDS" },
@@ -294,9 +288,8 @@ int drm_framebuffer_init(struct drm_device *dev, struct drm_framebuffer *fb,
 	int ret;
 
 	ret = drm_mode_object_get(dev, &fb->base, DRM_MODE_OBJECT_FB);
-	if (ret) {
+	if (ret)
 		return ret;
-	}
 
 	fb->dev = dev;
 	fb->funcs = funcs;
@@ -1327,15 +1320,13 @@ int drm_mode_getconnector(struct drm_device *dev, void *data,
 	connector = obj_to_connector(obj);
 
 	for (i = 0; i < DRM_CONNECTOR_MAX_PROPERTY; i++) {
-		if (connector->property_ids[i] != 0) {
+		if (connector->property_ids[i] != 0)
 			props_count++;
-		}
 	}
 
 	for (i = 0; i < DRM_CONNECTOR_MAX_ENCODER; i++) {
-		if (connector->encoder_ids[i] != 0) {
+		if (connector->encoder_ids[i] != 0)
 			encoders_count++;
-		}
 	}
 
 	if (out_resp->count_modes == 0) {
@@ -2342,7 +2333,7 @@ int drm_mode_getblob_ioctl(struct drm_device *dev,
 
 	if (out_resp->length == blob->length) {
 		blob_ptr = (void *)(unsigned long)out_resp->data;
-		if (copy_to_user(blob_ptr, blob->data, blob->length)){
+		if (copy_to_user(blob_ptr, blob->data, blob->length)) {
 			ret = -EFAULT;
 			goto done;
 		}
@@ -2395,9 +2386,8 @@ int drm_mode_connector_property_set_ioctl(struct drm_device *dev,
 	mutex_lock(&dev->mode_config.mutex);
 
 	obj = drm_mode_object_find(dev, out_resp->connector_id, DRM_MODE_OBJECT_CONNECTOR);
-	if (!obj) {
+	if (!obj)
 		goto out;
-	}
 	connector = obj_to_connector(obj);
 
 	for (i = 0; i < DRM_CONNECTOR_MAX_PROPERTY; i++) {
@@ -2405,14 +2395,12 @@ int drm_mode_connector_property_set_ioctl(struct drm_device *dev,
 			break;
 	}
 
-	if (i == DRM_CONNECTOR_MAX_PROPERTY) {
+	if (i == DRM_CONNECTOR_MAX_PROPERTY)
 		goto out;
-	}
 
 	obj = drm_mode_object_find(dev, out_resp->prop_id, DRM_MODE_OBJECT_PROPERTY);
-	if (!obj) {
+	if (!obj)
 		goto out;
-	}
 	property = obj_to_property(obj);
 
 	if (property->flags & DRM_MODE_PROP_IMMUTABLE)
@@ -2432,9 +2420,8 @@ int drm_mode_connector_property_set_ioctl(struct drm_device *dev,
 				break;
 			}
 		}
-		if (!found) {
+		if (!found)
 			goto out;
-		}
 	}
 
 	/* Do DPMS ourselves */
diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index 11fe9c8..a311a2a 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -372,9 +372,8 @@ bool drm_crtc_helper_set_mode(struct drm_crtc *crtc,
 		}
 	}
 
-	if (!(ret = crtc_funcs->mode_fixup(crtc, mode, adjusted_mode))) {
+	if (!(ret = crtc_funcs->mode_fixup(crtc, mode, adjusted_mode)))
 		goto done;
-	}
 	DRM_DEBUG_KMS("[CRTC:%d]\n", crtc->base.id);
 
 	/* Prepare the encoders and CRTCs before setting the mode. */
@@ -396,7 +395,7 @@ bool drm_crtc_helper_set_mode(struct drm_crtc *crtc,
 	 */
 	ret = !crtc_funcs->mode_set(crtc, mode, adjusted_mode, x, y, old_fb);
 	if (!ret)
-	    goto done;
+		goto done;
 
 	list_for_each_entry(encoder, &dev->mode_config.encoder_list, head) {
 
@@ -810,7 +809,7 @@ int drm_helper_resume_force_mode(struct drm_device *dev)
 		if (drm_helper_choose_crtc_dpms(crtc)) {
 			list_for_each_entry(encoder, &dev->mode_config.encoder_list, head) {
 
-				if(encoder->crtc != crtc)
+				if (encoder->crtc != crtc)
 					continue;
 
 				encoder_funcs = encoder->helper_private;
diff --git a/drivers/gpu/drm/drm_dma.c b/drivers/gpu/drm/drm_dma.c
index 252cbd7..71cf339 100644
--- a/drivers/gpu/drm/drm_dma.c
+++ b/drivers/gpu/drm/drm_dma.c
@@ -82,16 +82,14 @@ void drm_dma_takedown(struct drm_device *dev)
 				  dma->bufs[i].buf_count,
 				  dma->bufs[i].seg_count);
 			for (j = 0; j < dma->bufs[i].seg_count; j++) {
-				if (dma->bufs[i].seglist[j]) {
+				if (dma->bufs[i].seglist[j])
 					drm_pci_free(dev, dma->bufs[i].seglist[j]);
-				}
 			}
 			kfree(dma->bufs[i].seglist);
 		}
 		if (dma->bufs[i].buf_count) {
-			for (j = 0; j < dma->bufs[i].buf_count; j++) {
+			for (j = 0; j < dma->bufs[i].buf_count; j++)
 				kfree(dma->bufs[i].buflist[j].dev_private);
-			}
 			kfree(dma->bufs[i].buflist);
 		}
 	}
@@ -157,5 +155,4 @@ void drm_core_reclaim_buffers(struct drm_device *dev,
 		}
 	}
 }
-
 EXPORT_SYMBOL(drm_core_reclaim_buffers);
diff --git a/drivers/gpu/drm/drm_dp_i2c_helper.c b/drivers/gpu/drm/drm_dp_i2c_helper.c
index f7eba0a..cf1e528 100644
--- a/drivers/gpu/drm/drm_dp_i2c_helper.c
+++ b/drivers/gpu/drm/drm_dp_i2c_helper.c
@@ -37,7 +37,7 @@ i2c_algo_dp_aux_transaction(struct i2c_adapter *adapter, int mode,
 {
 	struct i2c_algo_dp_aux_data *algo_data = adapter->algo_data;
 	int ret;
-	
+
 	ret = (*algo_data->aux_ch)(adapter, mode,
 				   write_byte, read_byte);
 	return ret;
@@ -182,7 +182,6 @@ i2c_dp_aux_reset_bus(struct i2c_adapter *adapter)
 {
 	(void) i2c_algo_dp_aux_address(adapter, 0, false);
 	(void) i2c_algo_dp_aux_stop(adapter, false);
-					   
 }
 
 static int
@@ -198,7 +197,7 @@ int
 i2c_dp_aux_add_bus(struct i2c_adapter *adapter)
 {
 	int error;
-	
+
 	error = i2c_dp_aux_prepare_bus(adapter);
 	if (error)
 		return error;
diff --git a/drivers/gpu/drm/drm_drawable.c b/drivers/gpu/drm/drm_drawable.c
index c53c976..2e538a6 100644
--- a/drivers/gpu/drm/drm_drawable.c
+++ b/drivers/gpu/drm/drm_drawable.c
@@ -144,9 +144,8 @@ int drm_update_drawable_info(struct drm_device *dev, void *data, struct drm_file
 
 		spin_lock_irqsave(&dev->drw_lock, irqflags);
 
-		if (rects != info->rects) {
+		if (rects != info->rects)
 			kfree(info->rects);
-		}
 
 		info->rects = rects;
 		info->num_rects = update->num;
diff --git a/drivers/gpu/drm/drm_drv.c b/drivers/gpu/drm/drm_drv.c
index b5a5168..1aedd9e 100644
--- a/drivers/gpu/drm/drm_drv.c
+++ b/drivers/gpu/drm/drm_drv.c
@@ -150,7 +150,7 @@ static struct drm_ioctl_desc drm_ioctls[] = {
 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_DIRTYFB, drm_mode_dirtyfb_ioctl, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED)
 };
 
-#define DRM_CORE_IOCTL_COUNT	ARRAY_SIZE( drm_ioctls )
+#define DRM_CORE_IOCTL_COUNT	ARRAY_SIZE(drm_ioctls)
 
 /**
  * Take down the DRM device.
@@ -161,7 +161,7 @@ static struct drm_ioctl_desc drm_ioctls[] = {
  *
  * \sa drm_device
  */
-int drm_lastclose(struct drm_device * dev)
+int drm_lastclose(struct drm_device *dev)
 {
 	struct drm_vma_entry *vma, *vma_temp;
 	int i;
@@ -258,7 +258,6 @@ int drm_init(struct drm_driver *driver)
 	else
 		return drm_pci_init(driver);
 }
-
 EXPORT_SYMBOL(drm_init);
 
 void drm_exit(struct drm_driver *driver)
@@ -275,7 +274,6 @@ void drm_exit(struct drm_driver *driver)
 
 	DRM_INFO("Module unloaded\n");
 }
-
 EXPORT_SYMBOL(drm_exit);
 
 /** File operations structure */
@@ -492,7 +490,7 @@ long drm_ioctl(struct file *filp,
 		}
 	}
 
-      err_i1:
+err_i1:
 	if (kdata != stack_kdata)
 		kfree(kdata);
 	atomic_dec(&dev->ioctl_count);
@@ -500,7 +498,6 @@ long drm_ioctl(struct file *filp,
 		DRM_DEBUG("ret = %x\n", retcode);
 	return retcode;
 }
-
 EXPORT_SYMBOL(drm_ioctl);
 
 struct drm_local_map *drm_getsarea(struct drm_device *dev)
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index ea1d572..3d99fda 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -175,7 +175,7 @@ bad:
 	if (raw_edid) {
 		DRM_ERROR("Raw EDID:\n");
 		print_hex_dump_bytes(KERN_ERR, DUMP_PREFIX_NONE, raw_edid, EDID_LENGTH);
-		printk("\n");
+		DRM_ERROR("\n");
 	}
 	return 0;
 }
@@ -373,7 +373,7 @@ static u32 edid_get_quirks(struct edid *edid)
 }
 
 #define MODE_SIZE(m) ((m)->hdisplay * (m)->vdisplay)
-#define MODE_REFRESH_DIFF(m,r) (abs((m)->vrefresh - target_refresh))
+#define MODE_REFRESH_DIFF(m, r) (abs((m)->vrefresh - target_refresh))
 
 
 /**
@@ -983,9 +983,8 @@ static struct drm_display_mode *drm_mode_detailed(struct drm_device *dev,
 		printk(KERN_WARNING "stereo mode not supported\n");
 		return NULL;
 	}
-	if (!(pt->misc & DRM_EDID_PT_SEPARATE_SYNC)) {
+	if (!(pt->misc & DRM_EDID_PT_SEPARATE_SYNC))
 		printk(KERN_WARNING "composite sync not supported\n");
-	}
 
 	/* it is incorrect if hsync/vsync width is zero */
 	if (!hsync_pulse_width || !vsync_pulse_width) {
@@ -1024,9 +1023,8 @@ static struct drm_display_mode *drm_mode_detailed(struct drm_device *dev,
 
 	drm_mode_set_name(mode);
 
-	if (quirks & EDID_QUIRK_DETAILED_SYNC_PP) {
+	if (quirks & EDID_QUIRK_DETAILED_SYNC_PP)
 		pt->misc |= DRM_EDID_PT_HSYNC_POSITIVE | DRM_EDID_PT_VSYNC_POSITIVE;
-	}
 
 	mode->flags |= (pt->misc & DRM_EDID_PT_HSYNC_POSITIVE) ?
 		DRM_MODE_FLAG_PHSYNC : DRM_MODE_FLAG_NHSYNC;
@@ -1089,7 +1087,7 @@ static struct drm_display_mode edid_est_modes[] = {
 	{ DRM_MODE("1024x768", DRM_MODE_TYPE_DRIVER, 65000, 1024, 1048,
 		   1184, 1344, 0,  768, 771, 777, 806, 0,
 		   DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_NVSYNC) }, /* 1024x768@60Hz */
-	{ DRM_MODE("1024x768", DRM_MODE_TYPE_DRIVER,44900, 1024, 1032,
+	{ DRM_MODE("1024x768", DRM_MODE_TYPE_DRIVER, 44900, 1024, 1032,
 		   1208, 1264, 0, 768, 768, 776, 817, 0,
 		   DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_PVSYNC | DRM_MODE_FLAG_INTERLACE) }, /* 1024x768@43Hz */
 	{ DRM_MODE("832x624", DRM_MODE_TYPE_DRIVER, 57284, 832, 864,
@@ -1176,10 +1174,10 @@ mode_in_hsync_range(struct drm_display_mode *mode, struct edid *edid, u8 *t)
 
 	hmin = t[7];
 	if (edid->revision >= 4)
-	    hmin += ((t[4] & 0x04) ? 255 : 0);
+		hmin += ((t[4] & 0x04) ? 255 : 0);
 	hmax = t[8];
 	if (edid->revision >= 4)
-	    hmax += ((t[4] & 0x08) ? 255 : 0);
+		hmax += ((t[4] & 0x08) ? 255 : 0);
 	hsync = drm_mode_hsync(mode);
 
 	return (hsync <= hmax && hsync >= hmin);
@@ -1192,10 +1190,10 @@ mode_in_vsync_range(struct drm_display_mode *mode, struct edid *edid, u8 *t)
 
 	vmin = t[5];
 	if (edid->revision >= 4)
-	    vmin += ((t[4] & 0x01) ? 255 : 0);
+		vmin += ((t[4] & 0x01) ? 255 : 0);
 	vmax = t[6];
 	if (edid->revision >= 4)
-	    vmax += ((t[4] & 0x02) ? 255 : 0);
+		vmax += ((t[4] & 0x02) ? 255 : 0);
 	vsync = drm_mode_vrefresh(mode);
 
 	return (vsync <= vmax && vsync >= vmin);
@@ -1622,9 +1620,8 @@ int drm_add_edid_modes(struct drm_connector *connector, struct edid *edid)
 	int num_modes = 0;
 	u32 quirks;
 
-	if (edid == NULL) {
+	if (edid == NULL)
 		return 0;
-	}
 	if (!drm_edid_is_valid(edid)) {
 		dev_warn(connector->dev->dev, "%s: EDID invalid.\n",
 			 drm_get_connector_name(connector));
diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 7196620..e8570ea 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -189,10 +189,16 @@ done:
 	if (force) {
 		const char *s;
 		switch (force) {
-		case DRM_FORCE_OFF: s = "OFF"; break;
-		case DRM_FORCE_ON_DIGITAL: s = "ON - dig"; break;
+		case DRM_FORCE_OFF:
+			s = "OFF";
+			break;
+		case DRM_FORCE_ON_DIGITAL:
+			s = "ON - dig";
+			break;
 		default:
-		case DRM_FORCE_ON: s = "ON"; break;
+		case DRM_FORCE_ON:
+			s = "ON";
+			break;
 		}
 
 		DRM_INFO("forcing %s connector %s\n",
@@ -776,9 +782,8 @@ int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper,
 
 	/* if driver picks 8 or 16 by default use that
 	   for both depth/bpp */
-	if (preferred_bpp != sizes.surface_bpp) {
+	if (preferred_bpp != sizes.surface_bpp)
 		sizes.surface_depth = sizes.surface_bpp = preferred_bpp;
-	}
 	/* first up get a count of crtcs now in use and new min/maxes width/heights */
 	for (i = 0; i < fb_helper->connector_count; i++) {
 		struct drm_fb_helper_connector *fb_helper_conn = fb_helper->connector_info[i];
@@ -846,15 +851,13 @@ int drm_fb_helper_single_fb_probe(struct drm_fb_helper *fb_helper,
 	info = fb_helper->fbdev;
 
 	/* set the fb pointer */
-	for (i = 0; i < fb_helper->crtc_count; i++) {
+	for (i = 0; i < fb_helper->crtc_count; i++)
 		fb_helper->crtc_info[i].mode_set.fb = fb_helper->fb;
-	}
 
 	if (new_fb) {
 		info->var.pixclock = 0;
-		if (register_framebuffer(info) < 0) {
+		if (register_framebuffer(info) < 0)
 			return -EINVAL;
-		}
 
 		printk(KERN_INFO "fb%d: %s frame buffer device\n", info->node,
 		       info->fix.id);
@@ -1062,11 +1065,10 @@ static bool drm_connector_enabled(struct drm_connector *connector, bool strict)
 {
 	bool enable;
 
-	if (strict) {
+	if (strict)
 		enable = connector->status == connector_status_connected;
-	} else {
+	else
 		enable = connector->status != connector_status_disconnected;
-	}
 	return enable;
 }
 
@@ -1251,9 +1253,8 @@ static int drm_pick_crtcs(struct drm_fb_helper *fb_helper,
 	for (c = 0; c < fb_helper->crtc_count; c++) {
 		crtc = &fb_helper->crtc_info[c];
 
-		if ((encoder->possible_crtcs & (1 << c)) == 0) {
+		if ((encoder->possible_crtcs & (1 << c)) == 0)
 			continue;
-		}
 
 		for (o = 0; o < n; o++)
 			if (best_crtcs[o] == crtc)
@@ -1385,9 +1386,8 @@ bool drm_fb_helper_initial_config(struct drm_fb_helper *fb_helper, int bpp_sel)
 	/*
 	 * we shouldn't end up with no modes here.
 	 */
-	if (count == 0) {
+	if (count == 0)
 		printk(KERN_INFO "No connectors reported connected with modes\n");
-	}
 	drm_setup_crtcs(fb_helper);
 
 	return drm_fb_helper_single_fb_probe(fb_helper, bpp_sel);
diff --git a/drivers/gpu/drm/drm_fops.c b/drivers/gpu/drm/drm_fops.c
index e7aace2..3c195b3 100644
--- a/drivers/gpu/drm/drm_fops.c
+++ b/drivers/gpu/drm/drm_fops.c
@@ -40,9 +40,9 @@
 #include <linux/smp_lock.h>
 
 static int drm_open_helper(struct inode *inode, struct file *filp,
-			   struct drm_device * dev);
+			   struct drm_device *dev);
 
-static int drm_setup(struct drm_device * dev)
+static int drm_setup(struct drm_device *dev)
 {
 	int i;
 	int ret;
@@ -230,7 +230,7 @@ static int drm_cpu_valid(void)
  * filp and add it into the double linked list in \p dev.
  */
 static int drm_open_helper(struct inode *inode, struct file *filp,
-			   struct drm_device * dev)
+			   struct drm_device *dev)
 {
 	int minor_id = iminor(inode);
 	struct drm_file *priv;
@@ -344,7 +344,7 @@ static int drm_open_helper(struct inode *inode, struct file *filp,
 #endif
 
 	return 0;
-      out_free:
+out_free:
 	kfree(priv);
 	filp->private_data = NULL;
 	return ret;
diff --git a/drivers/gpu/drm/drm_hashtab.c b/drivers/gpu/drm/drm_hashtab.c
index a93d7b4..4d14a28 100644
--- a/drivers/gpu/drm/drm_hashtab.c
+++ b/drivers/gpu/drm/drm_hashtab.c
@@ -46,9 +46,8 @@ int drm_ht_create(struct drm_open_hash *ht, unsigned int order)
 	ht->fill = 0;
 	ht->table = NULL;
 	ht->use_vmalloc = ((ht->size * sizeof(*ht->table)) > PAGE_SIZE);
-	if (!ht->use_vmalloc) {
+	if (!ht->use_vmalloc)
 		ht->table = kcalloc(ht->size, sizeof(*ht->table), GFP_KERNEL);
-	}
 	if (!ht->table) {
 		ht->use_vmalloc = 1;
 		ht->table = vmalloc(ht->size*sizeof(*ht->table));
@@ -57,9 +56,8 @@ int drm_ht_create(struct drm_open_hash *ht, unsigned int order)
 		DRM_ERROR("Out of memory for hash table\n");
 		return -ENOMEM;
 	}
-	for (i=0; i< ht->size; ++i) {
+	for (i = 0; i < ht->size; ++i)
 		INIT_HLIST_HEAD(&ht->table[i]);
-	}
 	return 0;
 }
 EXPORT_SYMBOL(drm_ht_create);
@@ -121,11 +119,10 @@ int drm_ht_insert_item(struct drm_open_hash *ht, struct drm_hash_item *item)
 			break;
 		parent = list;
 	}
-	if (parent) {
+	if (parent)
 		hlist_add_after(parent, &item->head);
-	} else {
+	else
 		hlist_add_head(&item->head, h_list);
-	}
 	return 0;
 }
 EXPORT_SYMBOL(drm_ht_insert_item);
@@ -149,7 +146,7 @@ int drm_ht_just_insert_please(struct drm_open_hash *ht, struct drm_hash_item *it
 		ret = drm_ht_insert_item(ht, item);
 		if (ret)
 			unshifted_key = (unshifted_key + 1) & mask;
-	} while(ret && (unshifted_key != first));
+	} while (ret && (unshifted_key != first));
 
 	if (ret) {
 		DRM_ERROR("Available key bit space exhausted\n");
diff --git a/drivers/gpu/drm/drm_ioc32.c b/drivers/gpu/drm/drm_ioc32.c
index d61d185..f2fbd37 100644
--- a/drivers/gpu/drm/drm_ioc32.c
+++ b/drivers/gpu/drm/drm_ioc32.c
@@ -1078,5 +1078,4 @@ long drm_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 	return ret;
 }
-
 EXPORT_SYMBOL(drm_compat_ioctl);
diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index 9d3a503..b199388 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -279,7 +279,7 @@ EXPORT_SYMBOL(drm_irq_install);
  *
  * Calls the driver's \c drm_driver_irq_uninstall() function, and stops the irq.
  */
-int drm_irq_uninstall(struct drm_device * dev)
+int drm_irq_uninstall(struct drm_device *dev)
 {
 	unsigned long irqflags;
 	int irq_enabled, i;
@@ -467,7 +467,7 @@ EXPORT_SYMBOL(drm_vblank_get);
  */
 void drm_vblank_put(struct drm_device *dev, int crtc)
 {
-	BUG_ON (atomic_read (&dev->vblank_refcount[crtc]) == 0);
+	BUG_ON(atomic_read(&dev->vblank_refcount[crtc]) == 0);
 
 	/* Last user schedules interrupt disable */
 	if (atomic_dec_and_test(&dev->vblank_refcount[crtc]))
diff --git a/drivers/gpu/drm/drm_lock.c b/drivers/gpu/drm/drm_lock.c
index e2f70a5..3c82604 100644
--- a/drivers/gpu/drm/drm_lock.c
+++ b/drivers/gpu/drm/drm_lock.c
@@ -106,11 +106,12 @@ int drm_lock(struct drm_device *dev, void *data, struct drm_file *file_priv)
 
 	DRM_DEBUG("%d %s\n", lock->context,
 		  ret ? "interrupted" : "has lock");
-	if (ret) return ret;
+	if (ret)
+		return ret;
 
-	/* don't set the block all signals on the master process for now 
+	/* don't set the block all signals on the master process for now
 	 * really probably not the correct answer but lets us debug xkb
- 	 * xserver for now */
+	 * xserver for now */
 	if (!file_priv->is_master) {
 		sigemptyset(&dev->sigmask);
 		sigaddset(&dev->sigmask, SIGSTOP);
@@ -125,8 +126,7 @@ int drm_lock(struct drm_device *dev, void *data, struct drm_file *file_priv)
 	if (dev->driver->dma_ready && (lock->flags & _DRM_LOCK_READY))
 		dev->driver->dma_ready(dev);
 
-	if (dev->driver->dma_quiescent && (lock->flags & _DRM_LOCK_QUIESCENT))
-	{
+	if (dev->driver->dma_quiescent && (lock->flags & _DRM_LOCK_QUIESCENT)) {
 		if (dev->driver->dma_quiescent(dev)) {
 			DRM_DEBUG("%d waiting for DMA quiescent\n",
 				  lock->context);
@@ -388,5 +388,4 @@ int drm_i_have_hw_lock(struct drm_device *dev, struct drm_file *file_priv)
 		_DRM_LOCK_IS_HELD(master->lock.hw_lock->lock) &&
 		master->lock.file_priv == file_priv);
 }
-
 EXPORT_SYMBOL(drm_i_have_hw_lock);
diff --git a/drivers/gpu/drm/drm_memory.c b/drivers/gpu/drm/drm_memory.c
index 7732268..a467495 100644
--- a/drivers/gpu/drm/drm_memory.c
+++ b/drivers/gpu/drm/drm_memory.c
@@ -57,7 +57,7 @@ int drm_mem_info(char *buf, char **start, off_t offset,
 
 #if __OS_HAS_AGP
 static void *agp_remap(unsigned long offset, unsigned long size,
-		       struct drm_device * dev)
+		       struct drm_device *dev)
 {
 	unsigned long i, num_pages =
 	    PAGE_ALIGN(size) / PAGE_SIZE;
@@ -100,26 +100,26 @@ static void *agp_remap(unsigned long offset, unsigned long size,
 }
 
 /** Wrapper around agp_allocate_memory() */
-DRM_AGP_MEM *drm_alloc_agp(struct drm_device * dev, int pages, u32 type)
+DRM_AGP_MEM *drm_alloc_agp(struct drm_device *dev, int pages, u32 type)
 {
 	return drm_agp_allocate_memory(dev->agp->bridge, pages, type);
 }
 
 /** Wrapper around agp_free_memory() */
-int drm_free_agp(DRM_AGP_MEM * handle, int pages)
+int drm_free_agp(DRM_AGP_MEM *handle, int pages)
 {
 	return drm_agp_free_memory(handle) ? 0 : -EINVAL;
 }
 EXPORT_SYMBOL(drm_free_agp);
 
 /** Wrapper around agp_bind_memory() */
-int drm_bind_agp(DRM_AGP_MEM * handle, unsigned int start)
+int drm_bind_agp(DRM_AGP_MEM *handle, unsigned int start)
 {
 	return drm_agp_bind_memory(handle, start);
 }
 
 /** Wrapper around agp_unbind_memory() */
-int drm_unbind_agp(DRM_AGP_MEM * handle)
+int drm_unbind_agp(DRM_AGP_MEM *handle)
 {
 	return drm_agp_unbind_memory(handle);
 }
@@ -127,7 +127,7 @@ EXPORT_SYMBOL(drm_unbind_agp);
 
 #else  /*  __OS_HAS_AGP  */
 static inline void *agp_remap(unsigned long offset, unsigned long size,
-			      struct drm_device * dev)
+			      struct drm_device *dev)
 {
 	return NULL;
 }
diff --git a/drivers/gpu/drm/drm_mm.c b/drivers/gpu/drm/drm_mm.c
index da99edc..7655768 100644
--- a/drivers/gpu/drm/drm_mm.c
+++ b/drivers/gpu/drm/drm_mm.c
@@ -282,7 +282,6 @@ void drm_mm_put_block(struct drm_mm_node *cur)
 		spin_unlock(&mm->unused_lock);
 	}
 }
-
 EXPORT_SYMBOL(drm_mm_put_block);
 
 static int check_free_mm_node(struct drm_mm_node *entry, unsigned long size,
@@ -299,9 +298,8 @@ static int check_free_mm_node(struct drm_mm_node *entry, unsigned long size,
 			wasted = alignment - tmp;
 	}
 
-	if (entry->size >= size + wasted) {
+	if (entry->size >= size + wasted)
 		return 1;
-	}
 
 	return 0;
 }
@@ -516,7 +514,7 @@ int drm_mm_scan_remove_block(struct drm_mm_node *node)
 	 * stored. */
 	if (node->start >= mm->scan_hit_start &&
 	    node->start + node->size
-	    		<= mm->scan_hit_start + mm->scan_hit_size) {
+			<= mm->scan_hit_start + mm->scan_hit_size) {
 		return 1;
 	}
 
@@ -524,7 +522,7 @@ int drm_mm_scan_remove_block(struct drm_mm_node *node)
 }
 EXPORT_SYMBOL(drm_mm_scan_remove_block);
 
-int drm_mm_clean(struct drm_mm * mm)
+int drm_mm_clean(struct drm_mm *mm)
 {
 	struct list_head *head = &mm->node_list;
 
@@ -532,7 +530,7 @@ int drm_mm_clean(struct drm_mm * mm)
 }
 EXPORT_SYMBOL(drm_mm_clean);
 
-int drm_mm_init(struct drm_mm * mm, unsigned long start, unsigned long size)
+int drm_mm_init(struct drm_mm *mm, unsigned long start, unsigned long size)
 {
 	INIT_LIST_HEAD(&mm->node_list);
 	INIT_LIST_HEAD(&mm->free_stack);
@@ -545,7 +543,7 @@ int drm_mm_init(struct drm_mm * mm, unsigned long start, unsigned long size)
 }
 EXPORT_SYMBOL(drm_mm_init);
 
-void drm_mm_takedown(struct drm_mm * mm)
+void drm_mm_takedown(struct drm_mm *mm)
 {
 	struct list_head *bnode = mm->free_stack.next;
 	struct drm_mm_node *entry;
diff --git a/drivers/gpu/drm/drm_modes.c b/drivers/gpu/drm/drm_modes.c
index f1f473e..7b0ca9a 100644
--- a/drivers/gpu/drm/drm_modes.c
+++ b/drivers/gpu/drm/drm_modes.c
@@ -965,9 +965,8 @@ void drm_mode_connector_list_update(struct drm_connector *connector)
 			}
 		}
 
-		if (!found_it) {
+		if (!found_it)
 			list_move_tail(&pmode->head, &connector->modes);
-		}
 	}
 }
 EXPORT_SYMBOL(drm_mode_connector_list_update);
diff --git a/drivers/gpu/drm/drm_pci.c b/drivers/gpu/drm/drm_pci.c
index e20f78b..8cb5de5 100644
--- a/drivers/gpu/drm/drm_pci.c
+++ b/drivers/gpu/drm/drm_pci.c
@@ -86,7 +86,6 @@ drm_dma_handle_t *drm_pci_alloc(struct drm_device * dev, size_t size, size_t ali
 
 	return dmah;
 }
-
 EXPORT_SYMBOL(drm_pci_alloc);
 
 /**
@@ -94,7 +93,7 @@ EXPORT_SYMBOL(drm_pci_alloc);
  *
  * This function is for internal use in the Linux-specific DRM core code.
  */
-void __drm_pci_free(struct drm_device * dev, drm_dma_handle_t * dmah)
+void __drm_pci_free(struct drm_device *dev, drm_dma_handle_t *dmah)
 {
 #if 1
 	unsigned long addr;
@@ -116,12 +115,11 @@ void __drm_pci_free(struct drm_device * dev, drm_dma_handle_t * dmah)
 /**
  * \brief Free a PCI consistent memory block
  */
-void drm_pci_free(struct drm_device * dev, drm_dma_handle_t * dmah)
+void drm_pci_free(struct drm_device *dev, drm_dma_handle_t *dmah)
 {
 	__drm_pci_free(dev, dmah);
 	kfree(dmah);
 }
-
 EXPORT_SYMBOL(drm_pci_free);
 
 #ifdef CONFIG_PCI
diff --git a/drivers/gpu/drm/drm_proc.c b/drivers/gpu/drm/drm_proc.c
index a9ba6b6..9c2b5fb 100644
--- a/drivers/gpu/drm/drm_proc.c
+++ b/drivers/gpu/drm/drm_proc.c
@@ -64,7 +64,7 @@ static struct drm_info_list drm_proc_list[] = {
 
 static int drm_proc_open(struct inode *inode, struct file *file)
 {
-	struct drm_info_node* node = PDE(inode)->data;
+	struct drm_info_node *node = PDE(inode)->data;
 
 	return single_open(file, node->info_ent->show, node);
 }
diff --git a/drivers/gpu/drm/drm_scatter.c b/drivers/gpu/drm/drm_scatter.c
index 9034c4c..2999be6 100644
--- a/drivers/gpu/drm/drm_scatter.c
+++ b/drivers/gpu/drm/drm_scatter.c
@@ -46,7 +46,7 @@ static inline void *drm_vmalloc_dma(unsigned long size)
 #endif
 }
 
-void drm_sg_cleanup(struct drm_sg_mem * entry)
+void drm_sg_cleanup(struct drm_sg_mem *entry)
 {
 	struct page *page;
 	int i;
@@ -180,7 +180,7 @@ int drm_sg_alloc(struct drm_device *dev, struct drm_scatter_gather * request)
 
 	return 0;
 
-      failed:
+failed:
 	drm_sg_cleanup(entry);
 	return -ENOMEM;
 }
diff --git a/drivers/gpu/drm/drm_sman.c b/drivers/gpu/drm/drm_sman.c
index 463aed9..8602240 100644
--- a/drivers/gpu/drm/drm_sman.c
+++ b/drivers/gpu/drm/drm_sman.c
@@ -44,17 +44,16 @@ struct drm_owner_item {
 	struct list_head mem_blocks;
 };
 
-void drm_sman_takedown(struct drm_sman * sman)
+void drm_sman_takedown(struct drm_sman *sman)
 {
 	drm_ht_remove(&sman->user_hash_tab);
 	drm_ht_remove(&sman->owner_hash_tab);
 	kfree(sman->mm);
 }
-
 EXPORT_SYMBOL(drm_sman_takedown);
 
 int
-drm_sman_init(struct drm_sman * sman, unsigned int num_managers,
+drm_sman_init(struct drm_sman *sman, unsigned int num_managers,
 	      unsigned int user_order, unsigned int owner_order)
 {
 	int ret = 0;
@@ -81,7 +80,6 @@ out1:
 out:
 	return ret;
 }
-
 EXPORT_SYMBOL(drm_sman_init);
 
 static void *drm_sman_mm_allocate(void *private, unsigned long size,
@@ -91,9 +89,8 @@ static void *drm_sman_mm_allocate(void *private, unsigned long size,
 	struct drm_mm_node *tmp;
 
 	tmp = drm_mm_search_free(mm, size, alignment, 1);
-	if (!tmp) {
+	if (!tmp)
 		return NULL;
-	}
 	tmp = drm_mm_get_block(tmp, size, alignment);
 	return tmp;
 }
@@ -119,7 +116,7 @@ static unsigned long drm_sman_mm_offset(void *private, void *ref)
 }
 
 int
-drm_sman_set_range(struct drm_sman * sman, unsigned int manager,
+drm_sman_set_range(struct drm_sman *sman, unsigned int manager,
 		   unsigned long start, unsigned long size)
 {
 	struct drm_sman_mm *sman_mm;
@@ -130,9 +127,8 @@ drm_sman_set_range(struct drm_sman * sman, unsigned int manager,
 
 	sman_mm = &sman->mm[manager];
 	mm = kzalloc(sizeof(*mm), GFP_KERNEL);
-	if (!mm) {
+	if (!mm)
 		return -ENOMEM;
-	}
 	sman_mm->private = mm;
 	ret = drm_mm_init(mm, start, size);
 
@@ -148,12 +144,11 @@ drm_sman_set_range(struct drm_sman * sman, unsigned int manager,
 
 	return 0;
 }
-
 EXPORT_SYMBOL(drm_sman_set_range);
 
 int
-drm_sman_set_manager(struct drm_sman * sman, unsigned int manager,
-		     struct drm_sman_mm * allocator)
+drm_sman_set_manager(struct drm_sman *sman, unsigned int manager,
+		     struct drm_sman_mm *allocator)
 {
 	BUG_ON(manager >= sman->num_managers);
 	sman->mm[manager] = *allocator;
@@ -207,9 +202,8 @@ struct drm_memblock_item *drm_sman_alloc(struct drm_sman *sman, unsigned int man
 	sman_mm = &sman->mm[manager];
 	tmp = sman_mm->allocate(sman_mm->private, size, alignment);
 
-	if (!tmp) {
+	if (!tmp)
 		return NULL;
-	}
 
 	memblock = kzalloc(sizeof(*memblock), GFP_KERNEL);
 
@@ -242,7 +236,6 @@ out:
 
 	return NULL;
 }
-
 EXPORT_SYMBOL(drm_sman_alloc);
 
 static void drm_sman_free(struct drm_memblock_item *item)
@@ -268,7 +261,6 @@ int drm_sman_free_key(struct drm_sman *sman, unsigned int key)
 	drm_sman_free(memblock_item);
 	return 0;
 }
-
 EXPORT_SYMBOL(drm_sman_free_key);
 
 static void drm_sman_remove_owner(struct drm_sman *sman,
@@ -285,9 +277,8 @@ int drm_sman_owner_clean(struct drm_sman *sman, unsigned long owner)
 	struct drm_hash_item *hash_item;
 	struct drm_owner_item *owner_item;
 
-	if (drm_ht_find_item(&sman->owner_hash_tab, owner, &hash_item)) {
+	if (drm_ht_find_item(&sman->owner_hash_tab, owner, &hash_item))
 		return -1;
-	}
 
 	owner_item = drm_hash_entry(hash_item, struct drm_owner_item, owner_hash);
 	if (owner_item->mem_blocks.next == &owner_item->mem_blocks) {
@@ -297,7 +288,6 @@ int drm_sman_owner_clean(struct drm_sman *sman, unsigned long owner)
 
 	return 0;
 }
-
 EXPORT_SYMBOL(drm_sman_owner_clean);
 
 static void drm_sman_do_owner_cleanup(struct drm_sman *sman,
@@ -318,15 +308,12 @@ void drm_sman_owner_cleanup(struct drm_sman *sman, unsigned long owner)
 	struct drm_hash_item *hash_item;
 	struct drm_owner_item *owner_item;
 
-	if (drm_ht_find_item(&sman->owner_hash_tab, owner, &hash_item)) {
-
+	if (drm_ht_find_item(&sman->owner_hash_tab, owner, &hash_item))
 		return;
-	}
 
 	owner_item = drm_hash_entry(hash_item, struct drm_owner_item, owner_hash);
 	drm_sman_do_owner_cleanup(sman, owner_item);
 }
-
 EXPORT_SYMBOL(drm_sman_owner_cleanup);
 
 void drm_sman_cleanup(struct drm_sman *sman)
@@ -348,5 +335,4 @@ void drm_sman_cleanup(struct drm_sman *sman)
 		}
 	}
 }
-
 EXPORT_SYMBOL(drm_sman_cleanup);
diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index d1ad574..7f18b40 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -37,7 +37,7 @@
 #include "drmP.h"
 #include "drm_core.h"
 
-unsigned int drm_debug = 0;	/* 1 to enable debug output */
+unsigned int drm_debug;		/* = 1 to enable debug output */
 EXPORT_SYMBOL(drm_debug);
 
 MODULE_AUTHOR(CORE_AUTHOR);
@@ -75,12 +75,12 @@ static int drm_minor_get_id(struct drm_device *dev, int type)
 	int base = 0, limit = 63;
 
 	if (type == DRM_MINOR_CONTROL) {
-                base += 64;
-                limit = base + 127;
-        } else if (type == DRM_MINOR_RENDER) {
-                base += 128;
-                limit = base + 255;
-        }
+		base += 64;
+		limit = base + 127;
+	} else if (type == DRM_MINOR_RENDER) {
+		base += 128;
+		limit = base + 255;
+	}
 
 again:
 	if (idr_pre_get(&drm_minors_idr, GFP_KERNEL) == 0) {
@@ -91,11 +91,10 @@ again:
 	ret = idr_get_new_above(&drm_minors_idr, NULL,
 				base, &new_id);
 	mutex_unlock(&dev->struct_mutex);
-	if (ret == -EAGAIN) {
+	if (ret == -EAGAIN)
 		goto again;
-	} else if (ret) {
+	else if (ret)
 		return ret;
-	}
 
 	if (new_id >= limit) {
 		idr_remove(&drm_minors_idr, new_id);
@@ -248,9 +247,8 @@ int drm_fill_in_dev(struct drm_device *dev,
 
 	idr_init(&dev->drw_idr);
 
-	if (drm_ht_create(&dev->map_hash, 12)) {
+	if (drm_ht_create(&dev->map_hash, 12))
 		return -ENOMEM;
-	}
 
 	/* the DRM has 6 basic counters */
 	dev->counters = 6;
@@ -299,7 +297,7 @@ int drm_fill_in_dev(struct drm_device *dev,
 
 	return 0;
 
-      error_out_unreg:
+error_out_unreg:
 	drm_lastclose(dev);
 	return retcode;
 }
diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index 86118a7..18587f4 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -248,19 +248,19 @@ static ssize_t subconnector_show(struct device *device,
 	int ret;
 
 	switch (connector->connector_type) {
-		case DRM_MODE_CONNECTOR_DVII:
-			prop = dev->mode_config.dvi_i_subconnector_property;
-			break;
-		case DRM_MODE_CONNECTOR_Composite:
-		case DRM_MODE_CONNECTOR_SVIDEO:
-		case DRM_MODE_CONNECTOR_Component:
-		case DRM_MODE_CONNECTOR_TV:
-			prop = dev->mode_config.tv_subconnector_property;
-			is_tv = 1;
-			break;
-		default:
-			DRM_ERROR("Wrong connector type for this property\n");
-			return 0;
+	case DRM_MODE_CONNECTOR_DVII:
+		prop = dev->mode_config.dvi_i_subconnector_property;
+		break;
+	case DRM_MODE_CONNECTOR_Composite:
+	case DRM_MODE_CONNECTOR_SVIDEO:
+	case DRM_MODE_CONNECTOR_Component:
+	case DRM_MODE_CONNECTOR_TV:
+		prop = dev->mode_config.tv_subconnector_property;
+		is_tv = 1;
+		break;
+	default:
+		DRM_ERROR("Wrong connector type for this property\n");
+		return 0;
 	}
 
 	if (!prop) {
@@ -289,19 +289,19 @@ static ssize_t select_subconnector_show(struct device *device,
 	int ret;
 
 	switch (connector->connector_type) {
-		case DRM_MODE_CONNECTOR_DVII:
-			prop = dev->mode_config.dvi_i_select_subconnector_property;
-			break;
-		case DRM_MODE_CONNECTOR_Composite:
-		case DRM_MODE_CONNECTOR_SVIDEO:
-		case DRM_MODE_CONNECTOR_Component:
-		case DRM_MODE_CONNECTOR_TV:
-			prop = dev->mode_config.tv_select_subconnector_property;
-			is_tv = 1;
-			break;
-		default:
-			DRM_ERROR("Wrong connector type for this property\n");
-			return 0;
+	case DRM_MODE_CONNECTOR_DVII:
+		prop = dev->mode_config.dvi_i_select_subconnector_property;
+		break;
+	case DRM_MODE_CONNECTOR_Composite:
+	case DRM_MODE_CONNECTOR_SVIDEO:
+	case DRM_MODE_CONNECTOR_Component:
+	case DRM_MODE_CONNECTOR_TV:
+		prop = dev->mode_config.tv_select_subconnector_property;
+		is_tv = 1;
+		break;
+	default:
+		DRM_ERROR("Wrong connector type for this property\n");
+		return 0;
 	}
 
 	if (!prop) {
@@ -393,19 +393,19 @@ int drm_sysfs_connector_add(struct drm_connector *connector)
 	 * optionals per connector type.
 	 */
 	switch (connector->connector_type) {
-		case DRM_MODE_CONNECTOR_DVII:
-		case DRM_MODE_CONNECTOR_Composite:
-		case DRM_MODE_CONNECTOR_SVIDEO:
-		case DRM_MODE_CONNECTOR_Component:
-		case DRM_MODE_CONNECTOR_TV:
-			for (opt_cnt = 0; opt_cnt < ARRAY_SIZE(connector_attrs_opt1); opt_cnt++) {
-				ret = device_create_file(&connector->kdev, &connector_attrs_opt1[opt_cnt]);
-				if (ret)
-					goto err_out_files;
-			}
-			break;
-		default:
-			break;
+	case DRM_MODE_CONNECTOR_DVII:
+	case DRM_MODE_CONNECTOR_Composite:
+	case DRM_MODE_CONNECTOR_SVIDEO:
+	case DRM_MODE_CONNECTOR_Component:
+	case DRM_MODE_CONNECTOR_TV:
+		for (opt_cnt = 0; opt_cnt < ARRAY_SIZE(connector_attrs_opt1); opt_cnt++) {
+			ret = device_create_file(&connector->kdev, &connector_attrs_opt1[opt_cnt]);
+			if (ret)
+				goto err_out_files;
+		}
+		break;
+	default:
+		break;
 	}
 
 	ret = sysfs_create_bin_file(&connector->kdev.kobj, &edid_attr);
@@ -497,10 +497,10 @@ int drm_sysfs_device_add(struct drm_minor *minor)
 	minor->kdev.type = &drm_sysfs_device_minor;
 	if (minor->type == DRM_MINOR_CONTROL)
 		minor_str = "controlD%d";
-        else if (minor->type == DRM_MINOR_RENDER)
-                minor_str = "renderD%d";
-        else
-                minor_str = "card%d";
+	else if (minor->type == DRM_MINOR_RENDER)
+		minor_str = "renderD%d";
+	else
+		minor_str = "card%d";
 
 	dev_set_name(&minor->kdev, minor_str, minor->index);
 
diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index 3778360..46a9406 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -485,9 +485,8 @@ static int drm_mmap_dma(struct file *filp, struct vm_area_struct *vma)
 		  vma->vm_start, vma->vm_end, vma->vm_pgoff);
 
 	/* Length must match exact page count */
-	if (!dma || (length >> PAGE_SHIFT) != dma->page_count) {
+	if (!dma || (length >> PAGE_SHIFT) != dma->page_count)
 		return -EINVAL;
-	}
 
 	if (!capable(CAP_SYS_ADMIN) &&
 	    (dma->flags & _DRM_DMA_USE_PCI_RO)) {
@@ -515,11 +514,10 @@ static int drm_mmap_dma(struct file *filp, struct vm_area_struct *vma)
 	return 0;
 }
 
-resource_size_t drm_core_get_map_ofs(struct drm_local_map * map)
+resource_size_t drm_core_get_map_ofs(struct drm_local_map *map)
 {
 	return map->offset;
 }
-
 EXPORT_SYMBOL(drm_core_get_map_ofs);
 
 resource_size_t drm_core_get_reg_ofs(struct drm_device *dev)
@@ -530,7 +528,6 @@ resource_size_t drm_core_get_reg_ofs(struct drm_device *dev)
 	return 0;
 #endif
 }
-
 EXPORT_SYMBOL(drm_core_get_reg_ofs);
 
 /**
-- 
1.7.1
