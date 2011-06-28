Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab1F1WFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:05:35 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35056 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab1F1WFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:05:32 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 09/29] gma500: polish for completion of this phase
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:05:07 +0100
Message-ID: <20110628220506.898.4991.stgit@bob.linux.org.uk>
In-Reply-To: <20110628220151.898.15775.stgit@bob.linux.org.uk>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Give the driver its own proper DRM name, clean up copyright headers and so
forth

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mrst_crtc.c     |    4 +
 drivers/staging/gma500/mrst_lvds.c     |    2 -
 drivers/staging/gma500/psb_2d.c        |    7 --
 drivers/staging/gma500/psb_bl.c        |    4 +
 drivers/staging/gma500/psb_drm.h       |   90 +-------------------------------
 drivers/staging/gma500/psb_drv.c       |    4 +
 drivers/staging/gma500/psb_drv.h       |   85 +++++++++++++++---------------
 drivers/staging/gma500/psb_fb.c        |    3 -
 drivers/staging/gma500/psb_fb.h        |    3 -
 drivers/staging/gma500/psb_gtt.h       |    7 +-
 drivers/staging/gma500/psb_intel_drv.h |   19 +------
 drivers/staging/gma500/psb_irq.h       |    8 +--
 drivers/staging/gma500/psb_powermgmt.c |    4 +
 drivers/staging/gma500/psb_powermgmt.h |    2 -
 drivers/staging/gma500/psb_reg.h       |    2 -
 15 files changed, 67 insertions(+), 177 deletions(-)


diff --git a/drivers/staging/gma500/mrst_crtc.c b/drivers/staging/gma500/mrst_crtc.c
index e4a0c03..fd97c80 100644
--- a/drivers/staging/gma500/mrst_crtc.c
+++ b/drivers/staging/gma500/mrst_crtc.c
@@ -86,7 +86,7 @@ static const struct mrst_limit_t *mrst_limit(struct drm_crtc *crtc)
 {
 	const struct mrst_limit_t *limit = NULL;
 	struct drm_device *dev = crtc->dev;
-	DRM_DRIVER_PRIVATE_T *dev_priv = dev->dev_private;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 
 	if (psb_intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS)
 	    || psb_intel_pipe_has_type(crtc, INTEL_OUTPUT_MIPI)) {
@@ -296,7 +296,7 @@ static int mrst_crtc_mode_set(struct drm_crtc *crtc,
 {
 	struct drm_device *dev = crtc->dev;
 	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
-	DRM_DRIVER_PRIVATE_T *dev_priv = dev->dev_private;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	int pipe = psb_intel_crtc->pipe;
 	int fp_reg = (pipe == 0) ? MRST_FPA0 : FPB0;
 	int dpll_reg = (pipe == 0) ? MRST_DPLL_A : DPLL_B;
diff --git a/drivers/staging/gma500/mrst_lvds.c b/drivers/staging/gma500/mrst_lvds.c
index 7cbcdb8..e07cead 100644
--- a/drivers/staging/gma500/mrst_lvds.c
+++ b/drivers/staging/gma500/mrst_lvds.c
@@ -46,7 +46,7 @@ static void mrst_lvds_set_power(struct drm_device *dev,
 				struct psb_intel_output *output, bool on)
 {
 	u32 pp_status;
-	DRM_DRIVER_PRIVATE_T *dev_priv = dev->dev_private;
+	struct drm_psb_private *dev_priv = dev->dev_private;
 	PSB_DEBUG_ENTRY("\n");
 
 	if (!gma_power_begin(dev, true))
diff --git a/drivers/staging/gma500/psb_2d.c b/drivers/staging/gma500/psb_2d.c
index 060eeaf..c3d7085 100644
--- a/drivers/staging/gma500/psb_2d.c
+++ b/drivers/staging/gma500/psb_2d.c
@@ -1,5 +1,5 @@
 /**************************************************************************
- * Copyright (c) 2007, Intel Corporation.
+ * Copyright (c) 2007-2011, Intel Corporation.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
@@ -396,8 +396,3 @@ int psbfb_sync(struct fb_info *info)
 out:
 	return (busy) ? -EBUSY : 0;
 }
-
-/*
-	info->fix.accel = FB_ACCEL_I830;
-	info->flags = FBINFO_DEFAULT;
-*/
diff --git a/drivers/staging/gma500/psb_bl.c b/drivers/staging/gma500/psb_bl.c
index 5dffc71..2f9674d 100644
--- a/drivers/staging/gma500/psb_bl.c
+++ b/drivers/staging/gma500/psb_bl.c
@@ -1,7 +1,7 @@
 /*
- *  psb backlight interface
+ * GMA500 Backlight Interface
  *
- * Copyright (c) 2009, Intel Corporation.
+ * Copyright (c) 2009-2011, Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
diff --git a/drivers/staging/gma500/psb_drm.h b/drivers/staging/gma500/psb_drm.h
index 49ffdd5..b005293 100644
--- a/drivers/staging/gma500/psb_drm.h
+++ b/drivers/staging/gma500/psb_drm.h
@@ -1,5 +1,5 @@
 /**************************************************************************
- * Copyright (c) 2007, Intel Corporation.
+ * Copyright (c) 2007-2011, Intel Corporation.
  * All Rights Reserved.
  * Copyright (c) 2008, Tungsten Graphics Inc.  Cedar Park, TX., USA.
  * All Rights Reserved.
@@ -22,84 +22,8 @@
 #ifndef _PSB_DRM_H_
 #define _PSB_DRM_H_
 
-#if defined(__linux__) && !defined(__KERNEL__)
-#include<stdint.h>
-#include <linux/types.h>
-#include "drm_mode.h"
-#endif
-
-#define DRM_PSB_SAREA_MAJOR 0
-#define DRM_PSB_SAREA_MINOR 2
-#define PSB_FIXED_SHIFT 16
-
 #define PSB_NUM_PIPE 3
 
-/*
- * Public memory types.
- */
-
-typedef s32 psb_fixed;
-typedef u32 psb_ufixed;
-
-static inline s32 psb_int_to_fixed(int a)
-{
-	return a * (1 << PSB_FIXED_SHIFT);
-}
-
-static inline u32 psb_unsigned_to_ufixed(unsigned int a)
-{
-	return a << PSB_FIXED_SHIFT;
-}
-
-/*Status of the command sent to the gfx device.*/
-typedef enum {
-	DRM_CMD_SUCCESS,
-	DRM_CMD_FAILED,
-	DRM_CMD_HANG
-} drm_cmd_status_t;
-
-struct drm_psb_scanout {
-	u32 buffer_id;	/* DRM buffer object ID */
-	u32 rotation;	/* Rotation as in RR_rotation definitions */
-	u32 stride;	/* Buffer stride in bytes */
-	u32 depth;		/* Buffer depth in bits (NOT) bpp */
-	u32 width;		/* Buffer width in pixels */
-	u32 height;	/* Buffer height in lines */
-	s32 transform[3][3];	/* Buffer composite transform */
-	/* (scaling, rot, reflect) */
-};
-
-#define DRM_PSB_SAREA_OWNERS 16
-#define DRM_PSB_SAREA_OWNER_2D 0
-#define DRM_PSB_SAREA_OWNER_3D 1
-
-#define DRM_PSB_SAREA_SCANOUTS 3
-
-struct drm_psb_sarea {
-	/* Track changes of this data structure */
-
-	u32 major;
-	u32 minor;
-
-	/* Last context to touch part of hw */
-	u32 ctx_owners[DRM_PSB_SAREA_OWNERS];
-
-	/* Definition of front- and rotated buffers */
-	u32 num_scanouts;
-	struct drm_psb_scanout scanouts[DRM_PSB_SAREA_SCANOUTS];
-
-	int planeA_x;
-	int planeA_y;
-	int planeA_w;
-	int planeA_h;
-	int planeB_x;
-	int planeB_y;
-	int planeB_w;
-	int planeB_h;
-	/* Number of active scanouts */
-	u32 num_active_scanouts;
-};
-
 #define PSB_GPU_ACCESS_READ         (1ULL << 32)
 #define PSB_GPU_ACCESS_WRITE        (1ULL << 33)
 #define PSB_GPU_ACCESS_MASK         (PSB_GPU_ACCESS_READ | PSB_GPU_ACCESS_WRITE)
@@ -223,20 +147,14 @@ struct drm_psb_register_rw_arg {
 
 #define DRM_PSB_KMS_OFF		0x00
 #define DRM_PSB_KMS_ON		0x01
-#define DRM_PSB_VT_LEAVE        0x02
-#define DRM_PSB_VT_ENTER        0x03
-#define DRM_PSB_EXTENSION       0x06
 #define DRM_PSB_SIZES           0x07
 #define DRM_PSB_FUSE_REG	0x08
-#define DRM_PSB_VBT		0x09
 #define DRM_PSB_DC_STATE	0x0A
 #define DRM_PSB_ADB		0x0B
 #define DRM_PSB_MODE_OPERATION	0x0C
 #define DRM_PSB_STOLEN_MEMORY	0x0D
 #define DRM_PSB_REGISTER_RW	0x0E
-#define DRM_PSB_GTT_MAP         0x0F
-#define DRM_PSB_GTT_UNMAP       0x10
-#define DRM_PSB_GETPAGEADDRS	0x11
+
 /**
  * NOTE: Add new commands here, but increment
  * the values below and increment their
@@ -249,10 +167,6 @@ struct drm_psb_register_rw_arg {
 #define DRM_PVR_RESERVED4	0x15
 #define DRM_PVR_RESERVED5	0x16
 
-#define DRM_PSB_HIST_ENABLE	0x17
-#define DRM_PSB_HIST_STATUS	0x18
-#define DRM_PSB_UPDATE_GUARD	0x19
-#define DRM_PSB_INIT_COMM	0x1A
 #define DRM_PSB_DPST		0x1B
 #define DRM_PSB_GAMMA		0x1C
 #define DRM_PSB_DPST_BL		0x1D
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index aa87b1b..9bd0a5d 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -1,5 +1,5 @@
 /**************************************************************************
- * Copyright (c) 2007, Intel Corporation.
+ * Copyright (c) 2007-2011, Intel Corporation.
  * All Rights Reserved.
  * Copyright (c) 2008, Tungsten Graphics, Inc. Cedar Park, TX., USA.
  * All Rights Reserved.
@@ -1462,6 +1462,6 @@ static void __exit psb_exit(void)
 late_initcall(psb_init);
 module_exit(psb_exit);
 
-MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_AUTHOR("Alan Cox <alan@linux.intel.com> and others");
 MODULE_DESCRIPTION(DRIVER_DESC);
 MODULE_LICENSE("GPL");
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index e19a454..c0468ee 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -1,5 +1,5 @@
 /**************************************************************************
- * Copyright (c) 2007-2008, Intel Corporation.
+ * Copyright (c) 2007-2011, Intel Corporation.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
@@ -32,40 +32,32 @@
 #include "psb_powermgmt.h"
 #include "mrst.h"
 
-/*Append new drm mode definition here, align with libdrm definition*/
+/* Append new drm mode definition here, align with libdrm definition */
 #define DRM_MODE_SCALE_NO_SCALE   2
 
 enum {
-	CHIP_PSB_8108 = 0,
-	CHIP_PSB_8109 = 1,
-	CHIP_MRST_4100 = 2,
+	CHIP_PSB_8108 = 0,		/* Poulsbo */
+	CHIP_PSB_8109 = 1,		/* Poulsbo */
+	CHIP_MRST_4100 = 2,		/* Moorestown/Oaktrail */
 };
 
 #define IS_MRST(dev) (((dev)->pci_device & 0xfffc) == 0x4100)
 
 /*
- *Hardware bugfixes
+ * Driver definitions
  */
 
-#define DRIVER_NAME "pvrsrvkm"
-#define DRIVER_DESC "drm driver for the Intel GMA500"
-#define DRIVER_AUTHOR "Intel Corporation"
+#define DRIVER_NAME "gma500"
+#define DRIVER_DESC "DRM driver for the Intel GMA500"
 
-#define PSB_DRM_DRIVER_DATE "2009-03-10"
-#define PSB_DRM_DRIVER_MAJOR 8
-#define PSB_DRM_DRIVER_MINOR 1
+#define PSB_DRM_DRIVER_DATE "2011-06-06"
+#define PSB_DRM_DRIVER_MAJOR 1
+#define PSB_DRM_DRIVER_MINOR 0
 #define PSB_DRM_DRIVER_PATCHLEVEL 0
 
 /*
- *TTM driver private offsets.
+ *	Hardware offsets
  */
-
-#define DRM_PSB_FILE_PAGE_OFFSET (0x100000000ULL >> PAGE_SHIFT)
-
-#define PSB_OBJECT_HASH_ORDER 13
-#define PSB_FILE_OBJECT_HASH_ORDER 12
-#define PSB_BO_HASH_ORDER 12
-
 #define PSB_VDC_OFFSET		 0x00000000
 #define PSB_VDC_SIZE		 0x000080000
 #define MRST_MMIO_SIZE		 0x0000C0000
@@ -73,42 +65,52 @@ enum {
 #define PSB_SGX_SIZE		 0x8000
 #define PSB_SGX_OFFSET		 0x00040000
 #define MRST_SGX_OFFSET		 0x00080000
+/*
+ *	PCI resource identifiers
+ */
 #define PSB_MMIO_RESOURCE	 0
 #define PSB_GATT_RESOURCE	 2
 #define PSB_GTT_RESOURCE	 3
+/*
+ *	PCI configuration
+ */
 #define PSB_GMCH_CTRL		 0x52
 #define PSB_BSM			 0x5C
 #define _PSB_GMCH_ENABLED	 0x4
 #define PSB_PGETBL_CTL		 0x2020
 #define _PSB_PGETBL_ENABLED	 0x00000001
 #define PSB_SGX_2D_SLAVE_PORT	 0x4000
+
+/* To get rid of */
 #define PSB_TT_PRIV0_LIMIT	 (256*1024*1024)
 #define PSB_TT_PRIV0_PLIMIT	 (PSB_TT_PRIV0_LIMIT >> PAGE_SHIFT)
-#define PSB_NUM_VALIDATE_BUFFERS 2048
 
 /*
- *Flags for external memory type field.
+ *	SGX side MMU definitions (these can probably go)
  */
 
+/*
+ *	Flags for external memory type field.
+ */
 #define PSB_MMU_CACHED_MEMORY	  0x0001	/* Bind to MMU only */
 #define PSB_MMU_RO_MEMORY	  0x0002	/* MMU RO memory */
 #define PSB_MMU_WO_MEMORY	  0x0004	/* MMU WO memory */
-
 /*
- *PTE's and PDE's
+ *	PTE's and PDE's
  */
-
 #define PSB_PDE_MASK		  0x003FFFFF
 #define PSB_PDE_SHIFT		  22
 #define PSB_PTE_SHIFT		  12
-
+/*
+ *	Cache control
+ */
 #define PSB_PTE_VALID		  0x0001	/* PTE / PDE valid */
 #define PSB_PTE_WO		  0x0002	/* Write only */
 #define PSB_PTE_RO		  0x0004	/* Read only */
 #define PSB_PTE_CACHED		  0x0008	/* CPU cache coherent */
 
 /*
- *VDC registers and bits
+ *	VDC registers and bits
  */
 #define PSB_MSVDX_CLOCKGATING	  0x2064
 #define PSB_TOPAZ_CLOCKGATING	  0x2068
@@ -278,7 +280,7 @@ struct drm_psb_private {
 	int display_count;
 
 	/*
-	 *Modesetting
+	 * Modesetting
 	 */
 	struct psb_intel_mode_device mode_dev;
 
@@ -287,12 +289,8 @@ struct drm_psb_private {
 	uint32_t num_pipe;
 
 	/*
-	 *Memory managers
+	 * OSPM info (Power management base) (can go ?)
 	 */
-
-	/*
-	*OSPM info
-	*/
 	uint32_t ospm_base;
 
 	/*
@@ -304,11 +302,11 @@ struct drm_psb_private {
 	u32 fuse_reg_value;
 	u32 video_device_fuse;
 
-	/* pci revision id for B0:D2:F0 */
+	/* PCI revision ID for B0:D2:F0 */
 	uint8_t platform_rev_id;
 
 	/*
-	 *LVDS info
+	 * LVDS info
 	 */
 	int backlight_duty_cycle;	/* restore backlight to this value */
 	bool panel_wants_dither;
@@ -316,10 +314,10 @@ struct drm_psb_private {
 	struct drm_display_mode *lfp_lvds_vbt_mode;
 	struct drm_display_mode *sdvo_lvds_vbt_mode;
 
-	struct bdb_lvds_backlight *lvds_bl; /*LVDS backlight info from VBT*/
+	struct bdb_lvds_backlight *lvds_bl; /* LVDS backlight info from VBT */
 	struct psb_intel_i2c_chan *lvds_i2c_bus;
 
-	/* Feature bits from the VBIOS*/
+	/* Feature bits from the VBIOS */
 	unsigned int int_tv_support:1;
 	unsigned int lvds_dither:1;
 	unsigned int lvds_vbt:1;
@@ -332,7 +330,7 @@ struct drm_psb_private {
 	unsigned int core_freq;
 	uint32_t iLVDS_enable;
 
-	/*runtime PM state*/
+	/* Runtime PM state */
 	int rpm_enabled;
 
 	/* Moorestown specific */
@@ -350,7 +348,7 @@ struct drm_psb_private {
 	uint32_t dspcntr2;
 
 	/*
-	 *Register state
+	 * Register state
 	 */
 	uint32_t saveDSPACNTR;
 	uint32_t saveDSPBCNTR;
@@ -468,7 +466,7 @@ struct drm_psb_private {
 	u32 lid_last_state;
 
 	/*
-	 *Watchdog
+	 * Watchdog
 	 */
 
 	uint32_t apm_reg;
@@ -497,7 +495,7 @@ static inline struct drm_psb_private *psb_priv(struct drm_device *dev)
 }
 
 /*
- *MMU stuff.
+ * MMU stuff.
  */
 
 extern struct psb_mmu_driver *psb_mmu_driver_init(uint8_t __iomem * registers,
@@ -525,7 +523,7 @@ extern int psb_mmu_virtual_to_pfn(struct psb_mmu_pd *pd, uint32_t virtual,
 				  unsigned long *pfn);
 
 /*
- *Enable / disable MMU for different requestors.
+ * Enable / disable MMU for different requestors.
  */
 
 
@@ -598,7 +596,7 @@ extern int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
 	 	  	   unsigned size);
 
 /*
- *psb_reset.c
+ * psb_reset.c
  */
 
 extern void psb_lid_timer_init(struct drm_psb_private *dev_priv);
@@ -710,7 +708,6 @@ extern int drm_idle_check_interval;
 /*
  *Utilities
  */
-#define DRM_DRIVER_PRIVATE_T struct drm_psb_private
 
 static inline u32 MRST_MSG_READ32(uint port, uint offset)
 {
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 156f8ad..0a77abf 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -1,5 +1,5 @@
 /**************************************************************************
- * Copyright (c) 2007, Intel Corporation.
+ * Copyright (c) 2007-2011, Intel Corporation.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
@@ -56,7 +56,6 @@ void *psbfb_vdc_reg(struct drm_device *dev)
 	dev_priv = (struct drm_psb_private *) dev->dev_private;
 	return dev_priv->vdc_reg;
 }
-/*EXPORT_SYMBOL(psbfb_vdc_reg); */
 
 static int psbfb_setcolreg(unsigned regno, unsigned red, unsigned green,
 			   unsigned blue, unsigned transp,
diff --git a/drivers/staging/gma500/psb_fb.h b/drivers/staging/gma500/psb_fb.h
index fd7e51a..ed6e856 100644
--- a/drivers/staging/gma500/psb_fb.h
+++ b/drivers/staging/gma500/psb_fb.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2008, Intel Corporation
+ * Copyright (c) 2008-2011, Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -41,7 +41,6 @@ struct psb_fbdev {
 	struct psb_framebuffer pfb;
 };
 
-
 #define to_psb_fb(x) container_of(x, struct psb_framebuffer, base)
 
 extern int psb_intel_connector_clones(struct drm_device *dev, int type_mask);
diff --git a/drivers/staging/gma500/psb_gtt.h b/drivers/staging/gma500/psb_gtt.h
index 37287eb..7e1f21e 100644
--- a/drivers/staging/gma500/psb_gtt.h
+++ b/drivers/staging/gma500/psb_gtt.h
@@ -22,6 +22,7 @@
 
 #include <drm/drmP.h>
 
+/* This wants cleaning up with respect to the psb_dev and un-needed stuff */
 struct psb_gtt {
 	struct drm_device *dev;
 	uint32_t gatt_start;
@@ -41,9 +42,9 @@ extern void psb_gtt_takedown(struct drm_device *dev);
 
 /* Each gtt_range describes an allocation in the GTT area */
 struct gtt_range {
-	struct resource resource;
-	u32 offset;
-	struct kref kref;
+	struct resource resource;	/* Resource for our allocation */
+	u32 offset;			/* GTT offset of our object */
+	struct kref kref;		/* Can probably go FIXME - GEM kref will do */
 	struct drm_gem_object gem;	/* GEM high level stuff */
 	int in_gart;			/* Currently in the GART (ref ct) */
 	bool stolen;			/* Backed from stolen RAM */
diff --git a/drivers/staging/gma500/psb_intel_drv.h b/drivers/staging/gma500/psb_intel_drv.h
index 6006ddd..75a95f7 100644
--- a/drivers/staging/gma500/psb_intel_drv.h
+++ b/drivers/staging/gma500/psb_intel_drv.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2009, Intel Corporation.
+ * Copyright (c) 2009-2011, Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -26,11 +26,6 @@
 #include <linux/gpio.h>
 
 /*
- * MOORESTOWN defines
- */
-#define DELAY_TIME1 2000 /* 1000 = 1ms */
-
-/*
  * Display related stuff
  */
 
@@ -61,16 +56,10 @@
 #define INTEL_DVO_CHIP_TMDS 2
 #define INTEL_DVO_CHIP_TVOUT 4
 
-enum mipi_panel_type {
-	NSC_800X480 = 1,
-	LGE_480X1024 = 2,
-	TPO_864X480 = 3
-};
-
-/**
+/*
  * Hold information useally put on the device driver privates here,
  * since it needs to be shared across multiple of devices drivers privates.
-*/
+ */
 struct psb_intel_mode_device {
 
 	/*
@@ -79,7 +68,7 @@ struct psb_intel_mode_device {
 	 size_t(*bo_offset) (struct drm_device *dev, void *bo);
 
 	/*
-	 * Cursor
+	 * Cursor (Can go ?)
 	 */
 	int cursor_needs_physical;
 
diff --git a/drivers/staging/gma500/psb_irq.h b/drivers/staging/gma500/psb_irq.h
index 3e56f33..216fda3 100644
--- a/drivers/staging/gma500/psb_irq.h
+++ b/drivers/staging/gma500/psb_irq.h
@@ -1,5 +1,5 @@
 /**************************************************************************
- * Copyright (c) 2009, Intel Corporation.
+ * Copyright (c) 2009-2011, Intel Corporation.
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify it
@@ -34,10 +34,6 @@ int  psb_irq_postinstall(struct drm_device *dev);
 void psb_irq_uninstall(struct drm_device *dev);
 irqreturn_t psb_irq_handler(DRM_IRQ_ARGS);
 
-void psb_irq_preinstall_islands(struct drm_device *dev, int hw_islands);
-int  psb_irq_postinstall_islands(struct drm_device *dev, int hw_islands);
-void psb_irq_uninstall_islands(struct drm_device *dev, int hw_islands);
-
 int psb_irq_enable_dpst(struct drm_device *dev);
 int psb_irq_disable_dpst(struct drm_device *dev);
 void psb_irq_turn_on_dpst(struct drm_device *dev);
@@ -46,4 +42,4 @@ int  psb_enable_vblank(struct drm_device *dev, int pipe);
 void psb_disable_vblank(struct drm_device *dev, int pipe);
 u32  psb_get_vblank_counter(struct drm_device *dev, int pipe);
 
-#endif //_SYSIRQ_H_
+#endif /* _SYSIRQ_H_ */
diff --git a/drivers/staging/gma500/psb_powermgmt.c b/drivers/staging/gma500/psb_powermgmt.c
index 1495415..50f2234 100644
--- a/drivers/staging/gma500/psb_powermgmt.c
+++ b/drivers/staging/gma500/psb_powermgmt.c
@@ -1,7 +1,7 @@
 /**************************************************************************
- * Copyright (c) 2009, Intel Corporation.
+ * Copyright (c) 2009-2011, Intel Corporation.
  * All Rights Reserved.
-
+ *
  * Permission is hereby granted, free of charge, to any person obtaining a
  * copy of this software and associated documentation files (the "Software"),
  * to deal in the Software without restriction, including without limitation
diff --git a/drivers/staging/gma500/psb_powermgmt.h b/drivers/staging/gma500/psb_powermgmt.h
index e005229..333b28d 100644
--- a/drivers/staging/gma500/psb_powermgmt.h
+++ b/drivers/staging/gma500/psb_powermgmt.h
@@ -1,5 +1,5 @@
 /**************************************************************************
- * Copyright (c) 2009, Intel Corporation.
+ * Copyright (c) 2009-2011, Intel Corporation.
  * All Rights Reserved.
 
  * Permission is hereby granted, free of charge, to any person obtaining a
diff --git a/drivers/staging/gma500/psb_reg.h b/drivers/staging/gma500/psb_reg.h
index 9ad4989..529fda8 100644
--- a/drivers/staging/gma500/psb_reg.h
+++ b/drivers/staging/gma500/psb_reg.h
@@ -573,7 +573,7 @@
 #define MDFLD_PWRGT_DISPLAY_C_CNTR  0x00030000
 #define MDFLD_PWRGT_DISP_MIPI_CNTR  0x000c0000
 #define MDFLD_PWRGT_DISPLAY_CNTR    (MDFLD_PWRGT_DISPLAY_A_CNTR | MDFLD_PWRGT_DISPLAY_B_CNTR | MDFLD_PWRGT_DISPLAY_C_CNTR | MDFLD_PWRGT_DISP_MIPI_CNTR)// 0x000fc00c
-// Display SSS register bits are different in A0 vs. B0
+/* Display SSS register bits are different in A0 vs. B0 */
 #define PSB_PWRGT_GFX_MASK	    0x3
 #define MDFLD_PWRGT_DISPLAY_A_STS  		0x000000c0
 #define MDFLD_PWRGT_DISPLAY_B_STS  		0x00000300

