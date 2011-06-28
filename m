Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751379Ab1F1WHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:07:32 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40988 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199Ab1F1WHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:07:18 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 16/29] gma500: CodingStyle pass
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:06:51 +0100
Message-ID: <20110628220649.898.23169.stgit@bob.linux.org.uk>
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

Start the style cleanup

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/mrst.h                |   38 -
 drivers/staging/gma500/mrst_lvds.c           |    8 
 drivers/staging/gma500/psb_2d.c              |   23 -
 drivers/staging/gma500/psb_drm.h             |    8 
 drivers/staging/gma500/psb_drv.c             |   25 -
 drivers/staging/gma500/psb_drv.h             |   63 +-
 drivers/staging/gma500/psb_fb.c              |  145 ++--
 drivers/staging/gma500/psb_gem.c             |   19 
 drivers/staging/gma500/psb_gtt.c             |   35 -
 drivers/staging/gma500/psb_intel_display.c   |   12 
 drivers/staging/gma500/psb_intel_opregion.c  |    8 
 drivers/staging/gma500/psb_intel_reg.h       | 1055 +++++++++++++-------------
 drivers/staging/gma500/psb_intel_sdvo.c      |    3 
 drivers/staging/gma500/psb_intel_sdvo_regs.h |   14 
 drivers/staging/gma500/psb_reg.h             |  840 ++++++++++-----------
 15 files changed, 1156 insertions(+), 1140 deletions(-)


diff --git a/drivers/staging/gma500/mrst.h b/drivers/staging/gma500/mrst.h
index 5e4aaeb..7bacb9a 100644
--- a/drivers/staging/gma500/mrst.h
+++ b/drivers/staging/gma500/mrst.h
@@ -25,7 +25,7 @@ struct mrst_vbt {
 	u8 size;
 	u8 checksum;
 	void *mrst_gct;
-} __attribute__ ((packed));
+} __packed;
 
 struct mrst_timing_info {
 	u16 pixel_clock;
@@ -58,7 +58,7 @@ struct mrst_timing_info {
 	u8 stereo:1;
 	u8 unknown6:1;
 	u8 interlaced:1;
-} __attribute__((packed));
+} __packed;
 
 struct gct_r10_timing_info {
 	u16 pixel_clock;
@@ -82,7 +82,7 @@ struct gct_r10_timing_info {
 	u16 vsync_pulse_width_hi:2;
 	u16 vsync_positive:1;
 	u16 rsvd_2:3;
-} __attribute__((packed));
+} __packed;
 
 struct mrst_panel_descriptor_v1 {
 	u32 Panel_Port_Control; /* 1 dword, Register 0x61180 if LVDS */
@@ -111,7 +111,7 @@ struct mrst_panel_descriptor_v1 {
 			/* Bit 6, Reserved, 2 bits, 00b */
 			/* Bit 8, Minimum Supported Frame Rate, 6 bits, 0 - 63Hz */
 			/* Bit 14, Reserved, 2 bits, 00b */
-} __attribute__ ((packed));
+} __packed;
 
 struct mrst_panel_descriptor_v2 {
 	u32 Panel_Port_Control; /* 1 dword, Register 0x61180 if LVDS */
@@ -141,10 +141,10 @@ struct mrst_panel_descriptor_v2 {
 			/* Bit 6, Reserved, 2 bits, 00b */
 			/* Bit 8, Minimum Supported Frame Rate, 6 bits, 0 - 63Hz */
 			/* Bit 14, Reserved, 2 bits, 00b */
-} __attribute__ ((packed));
+} __packed;
 
 union mrst_panel_rx {
-	struct{
+	struct {
 		u16 NumberOfLanes:2; /*Num of Lanes, 2 bits,0 = 1 lane,*/
 			/* 1 = 2 lanes, 2 = 3 lanes, 3 = 4 lanes. */
 		u16 MaxLaneFreq:3; /* 0: 100MHz, 1: 200MHz, 2: 300MHz, */
@@ -159,10 +159,10 @@ union mrst_panel_rx {
 		u16 Rsvd:5;/*5 bits,00000b */
 	} panelrx;
 	u16 panel_receiver;
-} __attribute__ ((packed));
+} __packed;
 
 struct mrst_gct_v1 {
-	union{ /*8 bits,Defined as follows: */
+	union { /*8 bits,Defined as follows: */
 		struct {
 			u8 PanelType:4; /*4 bits, Bit field for panels*/
 					/* 0 - 3: 0 = LVDS, 1 = MIPI*/
@@ -176,10 +176,10 @@ struct mrst_gct_v1 {
 	};
 	struct mrst_panel_descriptor_v1 panel[4];/*panel descrs,38 bytes each*/
 	union mrst_panel_rx panelrx[4]; /* panel receivers*/
-} __attribute__ ((packed));
+} __packed;
 
 struct mrst_gct_v2 {
-	union{ /*8 bits,Defined as follows: */
+	union { /*8 bits,Defined as follows: */
 		struct {
 			u8 PanelType:4; /*4 bits, Bit field for panels*/
 					/* 0 - 3: 0 = LVDS, 1 = MIPI*/
@@ -193,7 +193,7 @@ struct mrst_gct_v2 {
 	};
 	struct mrst_panel_descriptor_v2 panel[4];/*panel descrs,38 bytes each*/
 	union mrst_panel_rx panelrx[4]; /* panel receivers*/
-} __attribute__ ((packed));
+} __packed;
 
 struct mrst_gct_data {
 	u8 bpi; /* boot panel index, number of panel used during boot */
@@ -205,13 +205,13 @@ struct mrst_gct_data {
 	u32 PP_Cycle_Delay;
 	u16 Panel_Backlight_Inverter_Descriptor;
 	u16 Panel_MIPI_Display_Descriptor;
-} __attribute__ ((packed));
+} __packed;
 
-#define MODE_SETTING_IN_CRTC 	0x1
-#define MODE_SETTING_IN_ENCODER 0x2
-#define MODE_SETTING_ON_GOING 	0x3
-#define MODE_SETTING_IN_DSR 	0x4
-#define MODE_SETTING_ENCODER_DONE 0x8
-#define GCT_R10_HEADER_SIZE	16
-#define GCT_R10_DISPLAY_DESC_SIZE	28
+#define MODE_SETTING_IN_CRTC		0x1
+#define MODE_SETTING_IN_ENCODER		0x2
+#define MODE_SETTING_ON_GOING		0x3
+#define MODE_SETTING_IN_DSR		0x4
+#define MODE_SETTING_ENCODER_DONE	0x8
 
+#define GCT_R10_HEADER_SIZE		16
+#define GCT_R10_DISPLAY_DESC_SIZE	28
diff --git a/drivers/staging/gma500/mrst_lvds.c b/drivers/staging/gma500/mrst_lvds.c
index 07e74f9..1687b1c 100644
--- a/drivers/staging/gma500/mrst_lvds.c
+++ b/drivers/staging/gma500/mrst_lvds.c
@@ -298,10 +298,10 @@ void mrst_lvds_init(struct drm_device *dev,
 	 /* This ifdef can go once the cpu ident stuff is cleaned up in arch */
 #if defined(CONFIG_X86_INTEL_MID)
 	if (mrst_identify_cpu())
-        	i2c_adap = i2c_get_adapter(2);
-        else	/* Oaktrail uses I2C 1 */
-#endif        
-        	i2c_adap = i2c_get_adapter(1);
+		i2c_adap = i2c_get_adapter(2);
+	else	/* Oaktrail uses I2C 1 */
+#endif
+		i2c_adap = i2c_get_adapter(1);
 
 	if (i2c_adap == NULL)
 		printk(KERN_ALERT "No ddc adapter available!\n");
diff --git a/drivers/staging/gma500/psb_2d.c b/drivers/staging/gma500/psb_2d.c
index 494bad5..dea4bc1 100644
--- a/drivers/staging/gma500/psb_2d.c
+++ b/drivers/staging/gma500/psb_2d.c
@@ -43,11 +43,11 @@
 
 void psb_spank(struct drm_psb_private *dev_priv)
 {
-        PSB_WSGX32(_PSB_CS_RESET_BIF_RESET | _PSB_CS_RESET_DPM_RESET |
+	PSB_WSGX32(_PSB_CS_RESET_BIF_RESET | _PSB_CS_RESET_DPM_RESET |
 		_PSB_CS_RESET_TA_RESET | _PSB_CS_RESET_USE_RESET |
 		_PSB_CS_RESET_ISP_RESET | _PSB_CS_RESET_TSP_RESET |
 		_PSB_CS_RESET_TWOD_RESET, PSB_CR_SOFT_RESET);
-	(void) PSB_RSGX32(PSB_CR_SOFT_RESET);
+	PSB_RSGX32(PSB_CR_SOFT_RESET);
 
 	msleep(1);
 
@@ -71,7 +71,7 @@ static int psb_2d_wait_available(struct drm_psb_private *dev_priv,
 	uint32_t avail = PSB_RSGX32(PSB_CR_2D_SOCIF);
 	unsigned long t = jiffies + HZ;
 
-	while(avail < size) {
+	while (avail < size) {
 		avail = PSB_RSGX32(PSB_CR_2D_SOCIF);
 		if (time_after(jiffies, t)) {
 			psb_spank(dev_priv);
@@ -85,7 +85,7 @@ static int psb_2d_wait_available(struct drm_psb_private *dev_priv,
    it with console use */
 
 int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
-	 	  	   unsigned size)
+								unsigned size)
 {
 	int ret = 0;
 	int i;
@@ -99,9 +99,10 @@ int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
 			return ret;
 
 		submit_size <<= 2;
-		for (i = 0; i < submit_size; i += 4) {
+
+		for (i = 0; i < submit_size; i += 4)
 			PSB_WSGX32(*cmdbuf++, PSB_SGX_2D_SLAVE_PORT + i);
-		}
+
 		(void)PSB_RSGX32(PSB_SGX_2D_SLAVE_PORT + i - 4);
 	}
 	return 0;
@@ -209,10 +210,10 @@ static u32 psb_accel_2d_copy_direction(int xdir, int ydir)
 {
 	if (xdir < 0)
 		return (ydir < 0) ? PSB_2D_COPYORDER_BR2TL :
-                			PSB_2D_COPYORDER_TR2BL;
+						PSB_2D_COPYORDER_TR2BL;
 	else
 		return (ydir < 0) ? PSB_2D_COPYORDER_BL2TR :
-                			PSB_2D_COPYORDER_TL2BR;
+						PSB_2D_COPYORDER_TL2BR;
 }
 
 /*
@@ -350,9 +351,9 @@ void psbfb_copyarea(struct fb_info *info,
 	if (unlikely(info->state != FBINFO_STATE_RUNNING))
 		return;
 
-        /* Avoid the 8 pixel erratum */
+	/* Avoid the 8 pixel erratum */
 	if (region->width == 8 || region->height == 8 ||
-	        (info->flags & FBINFO_HWACCEL_DISABLED))
+		(info->flags & FBINFO_HWACCEL_DISABLED))
 		return cfb_copyarea(info, region);
 
 	psbfb_copyarea_accel(info, region);
@@ -360,7 +361,7 @@ void psbfb_copyarea(struct fb_info *info,
 
 void psbfb_imageblit(struct fb_info *info, const struct fb_image *image)
 {
-        /* For now */
+	/* For now */
 	cfb_imageblit(info, image);
 }
 
diff --git a/drivers/staging/gma500/psb_drm.h b/drivers/staging/gma500/psb_drm.h
index b005293..8c259b8 100644
--- a/drivers/staging/gma500/psb_drm.h
+++ b/drivers/staging/gma500/psb_drm.h
@@ -118,10 +118,10 @@ struct drm_psb_register_rw_arg {
 		u32 OGAMC3;
 		u32 OGAMC4;
 		u32 OGAMC5;
-        	u32 IEP_ENABLED;
-        	u32 IEP_BLE_MINMAX;
-        	u32 IEP_BSSCC_CONTROL;
-                u32 b_wait_vblank;
+		u32 IEP_ENABLED;
+		u32 IEP_BLE_MINMAX;
+		u32 IEP_BSSCC_CONTROL;
+		u32 b_wait_vblank;
 	} overlay;
 
 	u32 sprite_enable_mask;
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 6ea06dd..3c2363a 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -47,7 +47,7 @@ module_param_named(no_fb, drm_psb_no_fb, int, 0600);
 module_param_named(trap_pagefaults, drm_psb_trap_pagefaults, int, 0600);
 
 
-static struct pci_device_id pciidlist[] = {
+static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
 	{ 0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8108 },
 	{ 0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8109 },
 	{ 0x8086, 0x4100, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MRST_4100},
@@ -185,8 +185,7 @@ void mrst_get_fuse_settings(struct drm_device *dev)
 	 if (dev_priv->iLVDS_enable) {
 		dev_priv->is_lvds_on = true;
 		dev_priv->is_mipi_on = false;
-	}
-	else {
+	} else {
 		dev_priv->is_mipi_on = true;
 		dev_priv->is_lvds_on = false;
 	}
@@ -196,7 +195,7 @@ void mrst_get_fuse_settings(struct drm_device *dev)
 	pci_write_config_dword(pci_root, 0xD0, FB_REG09);
 	pci_read_config_dword(pci_root, 0xD4, &fuse_value);
 
-	DRM_INFO("SKU values is 0x%x. \n", fuse_value);
+	DRM_INFO("SKU values is 0x%x.\n", fuse_value);
 	fuse_value_tmp = (fuse_value & FB_SKU_MASK) >> FB_SKU_SHIFT;
 
 	dev_priv->fuse_reg_value = fuse_value;
@@ -220,7 +219,7 @@ void mrst_get_fuse_settings(struct drm_device *dev)
 	pci_dev_put(pci_root);
 }
 
-void mid_get_pci_revID (struct drm_psb_private *dev_priv)
+void mid_get_pci_revID(struct drm_psb_private *dev_priv)
 {
 	uint32_t platform_rev_id = 0;
 	struct pci_dev *pci_gfx_root = pci_get_bus_and_slot(0, PCI_DEVFN(2, 0));
@@ -230,7 +229,7 @@ void mid_get_pci_revID (struct drm_psb_private *dev_priv)
 	dev_priv->platform_rev_id = (uint8_t) platform_rev_id;
 	pci_dev_put(pci_gfx_root);
 	dev_info(dev_priv->dev->dev, "platform_rev_id is %x\n",
-							dev_priv->platform_rev_id);
+					dev_priv->platform_rev_id);
 }
 
 void mrst_get_vbt_data(struct drm_psb_private *dev_priv)
@@ -285,7 +284,7 @@ void mrst_get_vbt_data(struct drm_psb_private *dev_priv)
 		dev_priv->gct_data.Panel_Port_Control =
 		  ((struct mrst_gct_v1 *)pGCT)->panel[bpi].Panel_Port_Control;
 		dev_priv->gct_data.Panel_MIPI_Display_Descriptor =
-		  ((struct mrst_gct_v1 *)pGCT)->panel[bpi].Panel_MIPI_Display_Descriptor;
+			((struct mrst_gct_v1 *)pGCT)->panel[bpi].Panel_MIPI_Display_Descriptor;
 		break;
 	case 1:
 		vbt->mrst_gct = NULL;
@@ -303,7 +302,7 @@ void mrst_get_vbt_data(struct drm_psb_private *dev_priv)
 		dev_priv->gct_data.Panel_Port_Control =
 		  ((struct mrst_gct_v2 *)pGCT)->panel[bpi].Panel_Port_Control;
 		dev_priv->gct_data.Panel_MIPI_Display_Descriptor =
-		  ((struct mrst_gct_v2 *)pGCT)->panel[bpi].Panel_MIPI_Display_Descriptor;
+			((struct mrst_gct_v2 *)pGCT)->panel[bpi].Panel_MIPI_Display_Descriptor;
 		break;
 	case 0x10:
 		/*header definition changed from rev 01 (v2) to rev 10h. */
@@ -449,13 +448,12 @@ static int psb_do_init(struct drm_device *dev)
 	PSB_WSGX32(0x00000000, PSB_CR_BIF_BANK0);
 	PSB_WSGX32(0x00000000, PSB_CR_BIF_BANK1);
 	PSB_RSGX32(PSB_CR_BIF_BANK1);
-        PSB_WSGX32(PSB_RSGX32(PSB_CR_BIF_CTRL) | _PSB_MMU_ER_MASK,
+	PSB_WSGX32(PSB_RSGX32(PSB_CR_BIF_CTRL) | _PSB_MMU_ER_MASK,
 							PSB_CR_BIF_CTRL);
 	psb_spank(dev_priv);
 
 	/* mmu_gatt ?? */
-      	PSB_WSGX32(pg->gatt_start, PSB_CR_BIF_TWOD_REQ_BASE);
-
+	PSB_WSGX32(pg->gatt_start, PSB_CR_BIF_TWOD_REQ_BASE);
 	return 0;
 out_err:
 	psb_do_takedown(dev);
@@ -1335,7 +1333,6 @@ static long psb_unlocked_ioctl(struct file *filp, unsigned int cmd,
 		dev_priv->rpm_enabled = 1;
 	}
 	return drm_ioctl(filp, cmd, arg);
-	
 	/* FIXME: do we need to wrap the other side of this */
 }
 
@@ -1367,7 +1364,7 @@ static struct vm_operations_struct psb_gem_vm_ops = {
 
 static struct drm_driver driver = {
 	.driver_features = DRIVER_HAVE_IRQ | DRIVER_IRQ_SHARED | \
-			   DRIVER_IRQ_VBL | DRIVER_MODESET| DRIVER_GEM ,
+			   DRIVER_IRQ_VBL | DRIVER_MODESET | DRIVER_GEM ,
 	.load = psb_driver_load,
 	.unload = psb_driver_unload,
 
@@ -1428,7 +1425,7 @@ static int psb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	/* MLD Added this from Inaky's patch */
 	if (pci_enable_msi(pdev))
-                dev_warn(&pdev->dev, "Enable MSI failed!\n");
+		dev_warn(&pdev->dev, "Enable MSI failed!\n");
 	return drm_get_pci_dev(pdev, ent, &driver);
 }
 
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 45752aa..1114021 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -25,6 +25,7 @@
 
 #include <drm/drmP.h>
 #include "drm_global.h"
+#include "gem_glue.h"
 #include "psb_drm.h"
 #include "psb_reg.h"
 #include "psb_intel_drv.h"
@@ -132,8 +133,12 @@ enum {
 #define _LNC_IRQ_TOPAZ_FLAG	  (1<<20)
 
 /* This flag includes all the display IRQ bits excepts the vblank irqs. */
-#define _MDFLD_DISP_ALL_IRQ_FLAG (_MDFLD_PIPEC_EVENT_FLAG | _MDFLD_PIPEB_EVENT_FLAG | \
-        _PSB_PIPEA_EVENT_FLAG | _PSB_VSYNC_PIPEA_FLAG | _MDFLD_MIPIA_FLAG | _MDFLD_MIPIC_FLAG)
+#define _MDFLD_DISP_ALL_IRQ_FLAG (_MDFLD_PIPEC_EVENT_FLAG | \
+				  _MDFLD_PIPEB_EVENT_FLAG | \
+				  _PSB_PIPEA_EVENT_FLAG | \
+				  _PSB_VSYNC_PIPEA_FLAG | \
+				  _MDFLD_MIPIA_FLAG | \
+				  _MDFLD_MIPIC_FLAG)
 #define PSB_INT_IDENTITY_R	  0x20A4
 #define PSB_INT_MASK_R		  0x20A8
 #define PSB_INT_ENABLE_R	  0x20A0
@@ -273,7 +278,7 @@ struct drm_psb_private {
 
 	/*
 	 * Power
-         */
+	 */
 
 	bool suspended;
 	bool display_power;
@@ -480,7 +485,7 @@ struct drm_psb_private {
 	uint32_t blc_adj1;
 	uint32_t blc_adj2;
 
-	void * fbdev;
+	void *fbdev;
 };
 
 
@@ -550,7 +555,7 @@ extern void psb_irq_turn_on_dpst(struct drm_device *dev);
 extern void psb_irq_turn_off_dpst(struct drm_device *dev);
 
 extern void psb_irq_uninstall_islands(struct drm_device *dev, int hw_islands);
-extern int psb_vblank_wait2(struct drm_device *dev,unsigned int *sequence);
+extern int psb_vblank_wait2(struct drm_device *dev, unsigned int *sequence);
 extern int psb_vblank_wait(struct drm_device *dev, unsigned int *sequence);
 extern int psb_enable_vblank(struct drm_device *dev, int crtc);
 extern void psb_disable_vblank(struct drm_device *dev, int crtc);
@@ -593,7 +598,7 @@ extern int psbfb_sync(struct fb_info *info);
 extern void psb_spank(struct drm_psb_private *dev_priv);
 
 extern int psbfb_2d_submit(struct drm_psb_private *dev_priv, uint32_t *cmdbuf,
-	 	  	   unsigned size);
+					unsigned size);
 
 /*
  * psb_reset.c
@@ -606,14 +611,14 @@ extern void psb_print_pagefault(struct drm_psb_private *dev_priv);
 /* modesetting */
 extern void psb_modeset_init(struct drm_device *dev);
 extern void psb_modeset_cleanup(struct drm_device *dev);
-extern int psb_fbdev_init(struct drm_device * dev);
+extern int psb_fbdev_init(struct drm_device *dev);
 
 /* psb_bl.c */
 int psb_backlight_init(struct drm_device *dev);
 void psb_backlight_exit(void);
 int psb_set_brightness(struct backlight_device *bd);
 int psb_get_brightness(struct backlight_device *bd);
-struct backlight_device * psb_get_backlight_device(void);
+struct backlight_device *psb_get_backlight_device(void);
 
 /* mrst_crtc.c */
 extern const struct drm_crtc_helper_funcs mrst_helper_funcs;
@@ -662,7 +667,6 @@ extern int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf);
 extern int drm_psb_no_fb;
 extern int drm_idle_check_interval;
 
-
 /*
  *	Utilities
  */
@@ -671,36 +675,36 @@ static inline u32 MRST_MSG_READ32(uint port, uint offset)
 {
 	int mcr = (0xD0<<24) | (port << 16) | (offset << 8);
 	uint32_t ret_val = 0;
-	struct pci_dev *pci_root = pci_get_bus_and_slot (0, 0);
-	pci_write_config_dword (pci_root, 0xD0, mcr);
-	pci_read_config_dword (pci_root, 0xD4, &ret_val);
+	struct pci_dev *pci_root = pci_get_bus_and_slot(0, 0);
+	pci_write_config_dword(pci_root, 0xD0, mcr);
+	pci_read_config_dword(pci_root, 0xD4, &ret_val);
 	pci_dev_put(pci_root);
 	return ret_val;
 }
 static inline void MRST_MSG_WRITE32(uint port, uint offset, u32 value)
 {
 	int mcr = (0xE0<<24) | (port << 16) | (offset << 8) | 0xF0;
-	struct pci_dev *pci_root = pci_get_bus_and_slot (0, 0);
-	pci_write_config_dword (pci_root, 0xD4, value);
-	pci_write_config_dword (pci_root, 0xD0, mcr);
+	struct pci_dev *pci_root = pci_get_bus_and_slot(0, 0);
+	pci_write_config_dword(pci_root, 0xD4, value);
+	pci_write_config_dword(pci_root, 0xD0, mcr);
 	pci_dev_put(pci_root);
 }
 static inline u32 MDFLD_MSG_READ32(uint port, uint offset)
 {
 	int mcr = (0x10<<24) | (port << 16) | (offset << 8);
 	uint32_t ret_val = 0;
-	struct pci_dev *pci_root = pci_get_bus_and_slot (0, 0);
-	pci_write_config_dword (pci_root, 0xD0, mcr);
-	pci_read_config_dword (pci_root, 0xD4, &ret_val);
+	struct pci_dev *pci_root = pci_get_bus_and_slot(0, 0);
+	pci_write_config_dword(pci_root, 0xD0, mcr);
+	pci_read_config_dword(pci_root, 0xD4, &ret_val);
 	pci_dev_put(pci_root);
 	return ret_val;
 }
 static inline void MDFLD_MSG_WRITE32(uint port, uint offset, u32 value)
 {
 	int mcr = (0x11<<24) | (port << 16) | (offset << 8) | 0xF0;
-	struct pci_dev *pci_root = pci_get_bus_and_slot (0, 0);
-	pci_write_config_dword (pci_root, 0xD4, value);
-	pci_write_config_dword (pci_root, 0xD0, mcr);
+	struct pci_dev *pci_root = pci_get_bus_and_slot(0, 0);
+	pci_write_config_dword(pci_root, 0xD4, value);
+	pci_write_config_dword(pci_root, 0xD0, mcr);
 	pci_dev_put(pci_root);
 }
 
@@ -744,14 +748,15 @@ static inline void REGISTER_WRITE8(struct drm_device *dev,
 
 /* #define TRAP_SGX_PM_FAULT 1 */
 #ifdef TRAP_SGX_PM_FAULT
-#define PSB_RSGX32(_offs)					\
-({								\
-    if (inl(dev_priv->apm_base + PSB_APM_STS) & 0x3) {		\
-	printk(KERN_ERR "access sgx when it's off!! (READ) %s, %d\n", \
-	       __FILE__, __LINE__);				\
-	mdelay(1000);						\
-    }								\
-    ioread32(dev_priv->sgx_reg + (_offs));			\
+#define PSB_RSGX32(_offs)						\
+({									\
+	if (inl(dev_priv->apm_base + PSB_APM_STS) & 0x3) {		\
+		printk(KERN_ERR						\
+			"access sgx when it's off!! (READ) %s, %d\n",	\
+	       __FILE__, __LINE__);					\
+		melay(1000);						\
+	}								\
+	ioread32(dev_priv->sgx_reg + (_offs));				\
 })
 #else
 #define PSB_RSGX32(_offs)		ioread32(dev_priv->sgx_reg + (_offs))
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index 400dbee..f1a7e8d 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -244,9 +244,11 @@ static int psbfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 
 	fb_screen_base = (char *)info->screen_base;
 
-        /* If this is a GEM object then info->screen_base is the virtual
-           kernel remapping of the object. FIXME: Review if this is
-           suitable for our mmap work */
+	/*
+	 * If this is a GEM object then info->screen_base is the virtual
+	 * kernel remapping of the object. FIXME: Review if this is
+	 * suitable for our mmap work
+	 */
 	vma->vm_ops = &psbfb_vm_ops;
 	vma->vm_private_data = (void *)psbfb;
 	vma->vm_flags |= VM_RESERVED | VM_IO |
@@ -254,7 +256,8 @@ static int psbfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 	return 0;
 }
 
-static int psbfb_ioctl(struct fb_info *info, unsigned int cmd, unsigned long arg)
+static int psbfb_ioctl(struct fb_info *info, unsigned int cmd,
+						unsigned long arg)
 {
 	struct psb_fbdev *fbdev = info->par;
 	struct psb_framebuffer *psbfb = &fbdev->pfb;
@@ -305,33 +308,33 @@ static struct fb_ops psbfb_ops = {
  *	0 on success or an error code if we fail.
  */
 static int psb_framebuffer_init(struct drm_device *dev,
-                                struct psb_framebuffer *fb,
-                                struct drm_mode_fb_cmd *mode_cmd,
-                                struct gtt_range *gt)
+					struct psb_framebuffer *fb,
+					struct drm_mode_fb_cmd *mode_cmd,
+					struct gtt_range *gt)
 {
-        int ret;
-
-        if (mode_cmd->pitch & 63)
-                return -EINVAL;
-        switch (mode_cmd->bpp) {
-        case 8:
-        case 16:
-        case 24:
-        case 32:
-                break;
-        default:
-                return -EINVAL;
-        }
-        ret = drm_framebuffer_init(dev, &fb->base, &psb_fb_funcs);
-        if (ret) {
-                dev_err(dev->dev, "framebuffer init failed: %d\n", ret);
-                return ret;
-        }
-        drm_helper_mode_fill_fb_struct(&fb->base, mode_cmd);
-        fb->gtt = gt;
-        return 0;
+	int ret;
+
+	if (mode_cmd->pitch & 63)
+		return -EINVAL;
+	switch (mode_cmd->bpp) {
+	case 8:
+	case 16:
+	case 24:
+	case 32:
+		break;
+	default:
+		return -EINVAL;
+	}
+	ret = drm_framebuffer_init(dev, &fb->base, &psb_fb_funcs);
+	if (ret) {
+		dev_err(dev->dev, "framebuffer init failed: %d\n", ret);
+		return ret;
+	}
+	drm_helper_mode_fill_fb_struct(&fb->base, mode_cmd);
+	fb->gtt = gt;
+	return 0;
 }
-                
+
 /**
  *	psb_framebuffer_create	-	create a framebuffer backed by gt
  *	@dev: our DRM device
@@ -357,10 +360,10 @@ static struct drm_framebuffer *psb_framebuffer_create
 
 	ret = psb_framebuffer_init(dev, fb, mode_cmd, gt);
 	if (ret) {
-	        kfree(fb);
-	        return ERR_PTR(ret);
-        }
-        return &fb->base;
+		kfree(fb);
+		return ERR_PTR(ret);
+	}
+	return &fb->base;
 }
 
 /**
@@ -373,7 +376,7 @@ static struct drm_framebuffer *psb_framebuffer_create
  *	stolen memory or the system has no stolen memory we allocate a range
  *	and back it with a GEM object.
  *
- *	In this case the GEM object has no handle. 
+ *	In this case the GEM object has no handle.
  *
  *	FIXME: console speed up - allocate twice the space if room and use
  *	hardware scrolling for acceleration.
@@ -384,10 +387,11 @@ static struct gtt_range *psbfb_alloc(struct drm_device *dev, int aligned_size)
 	/* Begin by trying to use stolen memory backing */
 	backing = psb_gtt_alloc_range(dev, aligned_size, "fb", 1);
 	if (backing) {
-	        if (drm_gem_private_object_init(dev, &backing->gem, aligned_size) == 0)
-        		return backing;
-                psb_gtt_free_range(dev, backing);
-        }
+		if (drm_gem_private_object_init(dev,
+					&backing->gem, aligned_size) == 0)
+			return backing;
+		psb_gtt_free_range(dev, backing);
+	}
 	/* Next try using GEM host memory */
 	backing = psb_gtt_alloc_range(dev, aligned_size, "fb(gem)", 0);
 	if (backing == NULL)
@@ -400,7 +404,7 @@ static struct gtt_range *psbfb_alloc(struct drm_device *dev, int aligned_size)
 	}
 	return backing;
 }
-	
+
 /**
  *	psbfb_create		-	create a framebuffer
  *	@fbdev: the framebuffer device
@@ -428,7 +432,7 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 
 	/* No 24bit packed */
 	if (mode_cmd.bpp == 24)
-        	mode_cmd.bpp = 32;
+		mode_cmd.bpp = 32;
 
 	/* HW requires pitch to be 64 byte aligned */
 	mode_cmd.pitch =  ALIGN(mode_cmd.width * ((mode_cmd.bpp + 7) / 8), 64);
@@ -440,7 +444,7 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	/* Allocate the framebuffer in the GTT with stolen page backing */
 	backing = psbfb_alloc(dev, size);
 	if (backing == NULL)
-	        return -ENOMEM;
+		return -ENOMEM;
 
 	mutex_lock(&dev->struct_mutex);
 
@@ -455,7 +459,7 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	if (ret)
 		goto out_unref;
 
-        fb = &psbfb->base;
+	fb = &psbfb->base;
 	psbfb->fbdev = info;
 
 	fbdev->psb_fb_helper.fb = fb;
@@ -523,13 +527,13 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	mutex_unlock(&dev->struct_mutex);
 	return 0;
 out_unref:
-        if (backing->stolen)
-                psb_gtt_free_range(dev, backing);
-        else {
-                if (psbfb->vm_map)
-                        vm_unmap_ram(info->screen_base, backing->npage);
-                drm_gem_object_unreference(&backing->gem);
-        }
+	if (backing->stolen)
+		psb_gtt_free_range(dev, backing);
+	else {
+		if (psbfb->vm_map)
+			vm_unmap_ram(info->screen_base, backing->npage);
+		drm_gem_object_unreference(&backing->gem);
+	}
 out_err1:
 	mutex_unlock(&dev->struct_mutex);
 	psb_gtt_free_range(dev, backing);
@@ -548,17 +552,19 @@ static struct drm_framebuffer *psb_user_framebuffer_create
 			(struct drm_device *dev, struct drm_file *filp,
 			 struct drm_mode_fb_cmd *cmd)
 {
-        struct gtt_range *r;
-        struct drm_gem_object *obj;
+	struct gtt_range *r;
+	struct drm_gem_object *obj;
 
-        /* Find the GEM object and thus the gtt range object that is
-           to back this space */
+	/*
+	 *	Find the GEM object and thus the gtt range object that is
+	 *	to back this space
+	 */
 	obj = drm_gem_object_lookup(dev, filp, cmd->handle);
 	if (obj == NULL)
-	        return ERR_PTR(-ENOENT);
+		return ERR_PTR(-ENOENT);
 
-        /* Let the core code do all the work */
-        r = container_of(obj, struct gtt_range, gem);
+	/* Let the core code do all the work */
+	r = container_of(obj, struct gtt_range, gem);
 	return psb_framebuffer_create(dev, cmd, r);
 }
 
@@ -610,12 +616,12 @@ int psb_fbdev_destroy(struct drm_device *dev, struct psb_fbdev *fbdev)
 		}
 		unregister_framebuffer(info);
 		if (info->cmap.len)
-		        fb_dealloc_cmap(&info->cmap);
+			fb_dealloc_cmap(&info->cmap);
 		framebuffer_release(info);
 	}
 	drm_fb_helper_fini(&fbdev->psb_fb_helper);
 	drm_framebuffer_cleanup(&psbfb->base);
-	
+
 	if (psbfb->gtt) {
 		/* FIXME: this is a bit more inside knowledge than I'd like
 		   but I don't see how to make a fake GEM object of the
@@ -624,7 +630,7 @@ int psb_fbdev_destroy(struct drm_device *dev, struct psb_fbdev *fbdev)
 			psb_gtt_free_range(dev, psbfb->gtt);
 		else
 			drm_gem_object_unreference(&psbfb->gtt->gem);
-        }
+	}
 	return 0;
 }
 
@@ -686,9 +692,9 @@ static int psb_user_framebuffer_create_handle(struct drm_framebuffer *fb,
 					      struct drm_file *file_priv,
 					      unsigned int *handle)
 {
-        struct psb_framebuffer *psbfb = to_psb_fb(fb);
-        struct gtt_range *r = psbfb->gtt;
-        return drm_gem_handle_create(file_priv, &r->gem, handle);
+	struct psb_framebuffer *psbfb = to_psb_fb(fb);
+	struct gtt_range *r = psbfb->gtt;
+	return drm_gem_handle_create(file_priv, &r->gem, handle);
 }
 
 /**
@@ -717,16 +723,17 @@ static void psb_user_framebuffer_destroy(struct drm_framebuffer *fb)
 			reset = 1;
 
 	if (reset)
-		/* 
-		 * Now force a sane response before we permit the DRM crc layer to
-		 * do stupid things like blank the display. Instead we reset this
-		 * framebuffer as if the user had forced a reset. We must do this
-		 * before the cleanup so that the DRM layer doesn't get a chance
-		 * to stick its oar in where it isn't wanted.
+		/*
+		 * Now force a sane response before we permit the DRM CRTC
+		 * layer to do stupid things like blank the display. Instead
+		 * we reset this framebuffer as if the user had forced a reset.
+		 * We must do this before the cleanup so that the DRM layer
+		 * doesn't get a chance to stick its oar in where it isn't
+		 * wanted.
 		 */
 		drm_fb_helper_restore_fbdev_mode(&fbdev->psb_fb_helper);
 
-        /* Let DRM do its clean up */
+	/* Let DRM do its clean up */
 	drm_framebuffer_cleanup(fb);
 	/*  We are no longer using the resource in GEM */
 	drm_gem_object_unreference_unlocked(&r->gem);
diff --git a/drivers/staging/gma500/psb_gem.c b/drivers/staging/gma500/psb_gem.c
index 4aec38c..3f658e4 100644
--- a/drivers/staging/gma500/psb_gem.c
+++ b/drivers/staging/gma500/psb_gem.c
@@ -82,12 +82,13 @@ static int psb_gem_create_mmap_offset(struct drm_gem_object *obj)
 	map = list->map;
 	map->type = _DRM_GEM;
 	map->size = obj->size;
-	map->handle =obj;
+	map->handle = obj;
 
 	list->file_offset_node = drm_mm_search_free(&mm->offset_manager,
 					obj->size / PAGE_SIZE, 0, 0);
 	if (!list->file_offset_node) {
-		dev_err(dev->dev, "failed to allocate offset for bo %d\n", obj->name);
+		dev_err(dev->dev, "failed to allocate offset for bo %d\n",
+								obj->name);
 		ret = -ENOSPC;
 		goto free_it;
 	}
@@ -130,7 +131,7 @@ int psb_gem_dumb_map_gtt(struct drm_file *file, struct drm_device *dev,
 
 	if (!(dev->driver->driver_features & DRIVER_GEM))
 		return -ENODEV;
-		
+
 	mutex_lock(&dev->struct_mutex);
 
 	/* GEM does all our handle to object mapping */
@@ -140,7 +141,7 @@ int psb_gem_dumb_map_gtt(struct drm_file *file, struct drm_device *dev,
 		goto unlock;
 	}
 	/* What validation is needed here ? */
-	
+
 	/* Make it mmapable */
 	if (!obj->map_list.map) {
 		ret = psb_gem_create_mmap_offset(obj);
@@ -176,7 +177,7 @@ static int psb_gem_create(struct drm_file *file,
 
 	size = roundup(size, PAGE_SIZE);
 
-	/* Allocate our object - for now a direct gtt range which is not 
+	/* Allocate our object - for now a direct gtt range which is not
 	   stolen memory backed */
 	r = psb_gtt_alloc_range(dev, size, "gem", 0);
 	if (r == NULL) {
@@ -285,9 +286,9 @@ int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	if (r->mmapping == 0) {
 		ret = psb_gtt_pin(r);
 		if (ret < 0) {
-		        dev_err(dev->dev, "gma500: pin failed: %d\n", ret);
-		        goto fail;
-                }
+			dev_err(dev->dev, "gma500: pin failed: %d\n", ret);
+			goto fail;
+		}
 		r->mmapping = 1;
 	}
 
@@ -304,7 +305,7 @@ int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	ret = vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
 
 fail:
-        mutex_unlock(&dev->struct_mutex);
+	mutex_unlock(&dev->struct_mutex);
 	switch (ret) {
 	case 0:
 	case -ERESTARTSYS:
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
index 9da1375..6cfa59b 100644
--- a/drivers/staging/gma500/psb_gtt.c
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -52,7 +52,7 @@ static inline uint32_t psb_gtt_mask_pte(uint32_t pfn, int type)
  *	psb_gtt_entry		-	find the GTT entries for a gtt_range
  *	@dev: our DRM device
  *	@r: our GTT range
- * 
+ *
  *	Given a gtt_range object return the GTT offset of the page table
  *	entries for this gtt_range
  */
@@ -102,7 +102,6 @@ static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
 	}
 	/* Make sure all the entries are set before we return */
 	ioread32(gtt_slot - 1);
-	
 	return 0;
 }
 
@@ -257,7 +256,7 @@ void psb_gtt_unpin(struct gtt_range *gt)
 	}
 	mutex_unlock(&dev_priv->gtt_mutex);
 }
-	
+
 /*
  *	GTT resource allocator - allocate and manage GTT address space
  */
@@ -289,11 +288,11 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
 		/* The start of the GTT is the stolen pages */
 		start = r->start;
 		end = r->start + dev_priv->pg->stolen_size - 1;
-        } else {
-        	/* The rest we will use for GEM backed objects */
-        	start = r->start + dev_priv->pg->stolen_size;
-        	end = r->end;
-        }
+	} else {
+		/* The rest we will use for GEM backed objects */
+		start = r->start + dev_priv->pg->stolen_size;
+		end = r->end;
+	}
 
 	gt = kzalloc(sizeof(struct gtt_range), GFP_KERNEL);
 	if (gt == NULL)
@@ -318,8 +317,8 @@ struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
  *	@dev: our DRM device
  *	@gt: a mapping created with psb_gtt_alloc_range
  *
- *	Release a resource that was allocated with psb_gtt_alloc_range. If the object
- *	has been pinned by mmap users we clean this up here currently.
+ *	Release a resource that was allocated with psb_gtt_alloc_range. If the
+ *	object has been pinned by mmap users we clean this up here currently.
  */
 void psb_gtt_free_range(struct drm_device *dev, struct gtt_range *gt)
 {
@@ -386,7 +385,7 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 	if (pg == NULL)
 		return -ENOMEM;
 
-        /* Enable the GTT */
+	/* Enable the GTT */
 	pci_read_config_word(dev->pdev, PSB_GMCH_CTRL, &dev_priv->gmch_ctrl);
 	pci_write_config_word(dev->pdev, PSB_GMCH_CTRL,
 			      dev_priv->gmch_ctrl | _PSB_GMCH_ENABLED);
@@ -402,18 +401,21 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 	pg->gtt_phys_start = dev_priv->pge_ctl & PAGE_MASK;
 
 	pg->gatt_start = pci_resource_start(dev->pdev, PSB_GATT_RESOURCE);
-	/* 
+	/*
 	 *	FIXME: video mmu has hw bug to access 0x0D0000000,
 	 *	then make gatt start at 0x0e000,0000
 	 */
 	pg->mmu_gatt_start = 0xE0000000;
 
 	pg->gtt_start = pci_resource_start(dev->pdev, PSB_GTT_RESOURCE);
-	gtt_pages = pci_resource_len(dev->pdev, PSB_GTT_RESOURCE) >> PAGE_SHIFT;
-	pg->gatt_pages = pci_resource_len(dev->pdev, PSB_GATT_RESOURCE) >> PAGE_SHIFT;
+	gtt_pages = pci_resource_len(dev->pdev, PSB_GTT_RESOURCE)
+								>> PAGE_SHIFT;
+	pg->gatt_pages = pci_resource_len(dev->pdev, PSB_GATT_RESOURCE)
+								>> PAGE_SHIFT;
 
 	pci_read_config_dword(dev->pdev, PSB_BSM, &dev_priv->stolen_base);
-	vram_stolen_size = pg->gtt_phys_start - dev_priv->stolen_base - PAGE_SIZE;
+	vram_stolen_size = pg->gtt_phys_start - dev_priv->stolen_base
+								- PAGE_SIZE;
 
 	stolen_size = vram_stolen_size;
 
@@ -439,7 +441,8 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 	/*
 	 *	Map the GTT and the stolen memory area
 	 */
-	dev_priv->gtt_map = ioremap_nocache(pg->gtt_phys_start, gtt_pages << PAGE_SHIFT);
+	dev_priv->gtt_map = ioremap_nocache(pg->gtt_phys_start,
+						gtt_pages << PAGE_SHIFT);
 	if (!dev_priv->gtt_map) {
 		dev_err(dev->dev, "Failure to map gtt.\n");
 		ret = -ENOMEM;
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index be7e1f9..1bb2144 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -388,7 +388,7 @@ int psb_intel_pipe_set_base(struct drm_crtc *crtc,
 		dspcntr |= DISPPLANE_32BPP_NO_ALPHA;
 		break;
 	default:
-                dev_err(dev->dev, "Unknown color depth\n");
+		dev_err(dev->dev, "Unknown color depth\n");
 		ret = -EINVAL;
 		psb_gtt_unpin(psbfb->gtt);
 		goto psb_intel_pipe_set_base_exit;
@@ -611,9 +611,9 @@ static int psb_intel_crtc_mode_set(struct drm_crtc *crtc,
 
 	/* No scan out no play */
 	if (crtc->fb == NULL) {
-	        crtc_funcs->mode_set_base(crtc, x, y, old_fb);
-                return 0;
-        }
+		crtc_funcs->mode_set_base(crtc, x, y, old_fb);
+		return 0;
+	}
 
 	list_for_each_entry(connector, &mode_config->connector_list, head) {
 		struct psb_intel_output *psb_intel_output =
@@ -728,8 +728,8 @@ static int psb_intel_crtc_mode_set(struct drm_crtc *crtc,
 		u32 lvds = REG_READ(LVDS);
 
 		lvds &= ~LVDS_PIPEB_SELECT;
-                if (pipe == 1)
-                        lvds |= LVDS_PIPEB_SELECT;
+		if (pipe == 1)
+			lvds |= LVDS_PIPEB_SELECT;
 
 		lvds |= LVDS_PORT_EN | LVDS_A0A2_CLKA_POWER_UP;
 		/* Set the B0-B3 data pairs corresponding to
diff --git a/drivers/staging/gma500/psb_intel_opregion.c b/drivers/staging/gma500/psb_intel_opregion.c
index 51cf1d6..97a8b00 100644
--- a/drivers/staging/gma500/psb_intel_opregion.c
+++ b/drivers/staging/gma500/psb_intel_opregion.c
@@ -33,19 +33,19 @@ struct opregion_header {
 	u8 driver_ver[16];
 	u32 mboxes;
 	u8 reserved[164];
-} __attribute__((packed));
+} __packed;
 
 struct opregion_apci {
 	/*FIXME: add it later*/
-} __attribute__((packed));
+} __packed;
 
 struct opregion_swsci {
 	/*FIXME: add it later*/
-} __attribute__((packed));
+} __packed;
 
 struct opregion_acpi {
 	/*FIXME: add it later*/
-} __attribute__((packed));
+} __packed;
 
 int psb_intel_opregion_init(struct drm_device *dev)
 {
diff --git a/drivers/staging/gma500/psb_intel_reg.h b/drivers/staging/gma500/psb_intel_reg.h
index 1c28314..c9630a2 100644
--- a/drivers/staging/gma500/psb_intel_reg.h
+++ b/drivers/staging/gma500/psb_intel_reg.h
@@ -28,8 +28,8 @@
  *
  * The actual value is this field multiplied by two.
  */
-#define BACKLIGHT_MODULATION_FREQ_MASK		(0x7fff << 17)
-#define BLM_LEGACY_MODE				(1 << 16)
+#define BACKLIGHT_MODULATION_FREQ_MASK	(0x7fff << 17)
+#define BLM_LEGACY_MODE			(1 << 16)
 /*
  * This is the number of cycles out of the backlight modulation cycle for which
  * the backlight is on.
@@ -37,55 +37,55 @@
  * This field must be no greater than the number of cycles in the complete
  * backlight modulation cycle.
  */
-#define BACKLIGHT_DUTY_CYCLE_SHIFT		(0)
-#define BACKLIGHT_DUTY_CYCLE_MASK		(0xffff)
+#define BACKLIGHT_DUTY_CYCLE_SHIFT	(0)
+#define BACKLIGHT_DUTY_CYCLE_MASK	(0xffff)
 
 #define I915_GCFGC			0xf0
-#define I915_LOW_FREQUENCY_ENABLE		(1 << 7)
-#define I915_DISPLAY_CLOCK_190_200_MHZ		(0 << 4)
-#define I915_DISPLAY_CLOCK_333_MHZ		(4 << 4)
-#define I915_DISPLAY_CLOCK_MASK			(7 << 4)
+#define I915_LOW_FREQUENCY_ENABLE	(1 << 7)
+#define I915_DISPLAY_CLOCK_190_200_MHZ	(0 << 4)
+#define I915_DISPLAY_CLOCK_333_MHZ	(4 << 4)
+#define I915_DISPLAY_CLOCK_MASK		(7 << 4)
 
 #define I855_HPLLCC			0xc0
-#define I855_CLOCK_CONTROL_MASK			(3 << 0)
-#define I855_CLOCK_133_200			(0 << 0)
-#define I855_CLOCK_100_200			(1 << 0)
-#define I855_CLOCK_100_133			(2 << 0)
-#define I855_CLOCK_166_250			(3 << 0)
+#define I855_CLOCK_CONTROL_MASK		(3 << 0)
+#define I855_CLOCK_133_200		(0 << 0)
+#define I855_CLOCK_100_200		(1 << 0)
+#define I855_CLOCK_100_133		(2 << 0)
+#define I855_CLOCK_166_250		(3 << 0)
 
 /* I830 CRTC registers */
-#define HTOTAL_A	0x60000
-#define HBLANK_A	0x60004
-#define HSYNC_A 	0x60008
-#define VTOTAL_A	0x6000c
-#define VBLANK_A	0x60010
-#define VSYNC_A 	0x60014
-#define PIPEASRC	0x6001c
-#define BCLRPAT_A	0x60020
-#define VSYNCSHIFT_A	0x60028
-
-#define HTOTAL_B	0x61000
-#define HBLANK_B	0x61004
-#define HSYNC_B 	0x61008
-#define VTOTAL_B	0x6100c
-#define VBLANK_B	0x61010
-#define VSYNC_B 	0x61014
-#define PIPEBSRC	0x6101c
-#define BCLRPAT_B	0x61020
-#define VSYNCSHIFT_B	0x61028
-
-#define HTOTAL_C	0x62000
-#define HBLANK_C	0x62004
-#define HSYNC_C 	0x62008
-#define VTOTAL_C	0x6200c
-#define VBLANK_C	0x62010
-#define VSYNC_C 	0x62014
-#define PIPECSRC	0x6201c
-#define BCLRPAT_C	0x62020
-#define VSYNCSHIFT_C	0x62028
-
-#define PP_STATUS	0x61200
-# define PP_ON					(1 << 31)
+#define HTOTAL_A		0x60000
+#define HBLANK_A		0x60004
+#define HSYNC_A			0x60008
+#define VTOTAL_A		0x6000c
+#define VBLANK_A		0x60010
+#define VSYNC_A			0x60014
+#define PIPEASRC		0x6001c
+#define BCLRPAT_A		0x60020
+#define VSYNCSHIFT_A		0x60028
+
+#define HTOTAL_B		0x61000
+#define HBLANK_B		0x61004
+#define HSYNC_B			0x61008
+#define VTOTAL_B		0x6100c
+#define VBLANK_B		0x61010
+#define VSYNC_B			0x61014
+#define PIPEBSRC		0x6101c
+#define BCLRPAT_B		0x61020
+#define VSYNCSHIFT_B		0x61028
+
+#define HTOTAL_C		0x62000
+#define HBLANK_C		0x62004
+#define HSYNC_C			0x62008
+#define VTOTAL_C		0x6200c
+#define VBLANK_C		0x62010
+#define VSYNC_C			0x62014
+#define PIPECSRC		0x6201c
+#define BCLRPAT_C		0x62020
+#define VSYNCSHIFT_C		0x62028
+
+#define PP_STATUS		0x61200
+# define PP_ON				(1 << 31)
 /*
  * Indicates that all dependencies of the panel are on:
  *
@@ -93,56 +93,55 @@
  * - pipe enabled
  * - LVDS/DVOB/DVOC on
  */
-# define PP_READY				(1 << 30)
-# define PP_SEQUENCE_NONE			(0 << 28)
-# define PP_SEQUENCE_ON				(1 << 28)
-# define PP_SEQUENCE_OFF			(2 << 28)
-# define PP_SEQUENCE_MASK			0x30000000
-#define PP_CONTROL	0x61204
-# define POWER_TARGET_ON			(1 << 0)
-
-#define LVDSPP_ON       0x61208
-#define LVDSPP_OFF      0x6120c
-#define PP_CYCLE        0x61210
-
-#define PFIT_CONTROL	0x61230
-# define PFIT_ENABLE				(1 << 31)
-# define PFIT_PIPE_MASK				(3 << 29)
-# define PFIT_PIPE_SHIFT			29
-# define PFIT_SCALING_MODE_PILLARBOX            (1 << 27)
-# define PFIT_SCALING_MODE_LETTERBOX            (3 << 26)
-# define VERT_INTERP_DISABLE			(0 << 10)
-# define VERT_INTERP_BILINEAR			(1 << 10)
-# define VERT_INTERP_MASK			(3 << 10)
-# define VERT_AUTO_SCALE			(1 << 9)
-# define HORIZ_INTERP_DISABLE			(0 << 6)
-# define HORIZ_INTERP_BILINEAR			(1 << 6)
-# define HORIZ_INTERP_MASK			(3 << 6)
-# define HORIZ_AUTO_SCALE			(1 << 5)
-# define PANEL_8TO6_DITHER_ENABLE		(1 << 3)
-
-#define PFIT_PGM_RATIOS	0x61234
-# define PFIT_VERT_SCALE_MASK			0xfff00000
-# define PFIT_HORIZ_SCALE_MASK			0x0000fff0
+#define PP_READY			(1 << 30)
+#define PP_SEQUENCE_NONE		(0 << 28)
+#define PP_SEQUENCE_ON			(1 << 28)
+#define PP_SEQUENCE_OFF			(2 << 28)
+#define PP_SEQUENCE_MASK		0x30000000
+#define PP_CONTROL		0x61204
+#define POWER_TARGET_ON			(1 << 0)
+
+#define LVDSPP_ON		0x61208
+#define LVDSPP_OFF		0x6120c
+#define PP_CYCLE		0x61210
+
+#define PFIT_CONTROL		0x61230
+#define PFIT_ENABLE			(1 << 31)
+#define PFIT_PIPE_MASK			(3 << 29)
+#define PFIT_PIPE_SHIFT			29
+#define PFIT_SCALING_MODE_PILLARBOX	(1 << 27)
+#define PFIT_SCALING_MODE_LETTERBOX	(3 << 26)
+#define VERT_INTERP_DISABLE		(0 << 10)
+#define VERT_INTERP_BILINEAR		(1 << 10)
+#define VERT_INTERP_MASK		(3 << 10)
+#define VERT_AUTO_SCALE			(1 << 9)
+#define HORIZ_INTERP_DISABLE		(0 << 6)
+#define HORIZ_INTERP_BILINEAR		(1 << 6)
+#define HORIZ_INTERP_MASK		(3 << 6)
+#define HORIZ_AUTO_SCALE		(1 << 5)
+#define PANEL_8TO6_DITHER_ENABLE	(1 << 3)
+
+#define PFIT_PGM_RATIOS		0x61234
+#define PFIT_VERT_SCALE_MASK			0xfff00000
+#define PFIT_HORIZ_SCALE_MASK			0x0000fff0
 
 #define PFIT_AUTO_RATIOS	0x61238
 
-
-#define DPLL_A		0x06014
-#define DPLL_B		0x06018
-# define DPLL_VCO_ENABLE			(1 << 31)
-# define DPLL_DVO_HIGH_SPEED			(1 << 30)
-# define DPLL_SYNCLOCK_ENABLE			(1 << 29)
-# define DPLL_VGA_MODE_DIS			(1 << 28)
-# define DPLLB_MODE_DAC_SERIAL			(1 << 26)	/* i915 */
-# define DPLLB_MODE_LVDS			(2 << 26)	/* i915 */
-# define DPLL_MODE_MASK				(3 << 26)
-# define DPLL_DAC_SERIAL_P2_CLOCK_DIV_10	(0 << 24)	/* i915 */
-# define DPLL_DAC_SERIAL_P2_CLOCK_DIV_5		(1 << 24)	/* i915 */
-# define DPLLB_LVDS_P2_CLOCK_DIV_14		(0 << 24)	/* i915 */
-# define DPLLB_LVDS_P2_CLOCK_DIV_7		(1 << 24)	/* i915 */
-# define DPLL_P2_CLOCK_DIV_MASK			0x03000000	/* i915 */
-# define DPLL_FPA01_P1_POST_DIV_MASK		0x00ff0000	/* i915 */
+#define DPLL_A			0x06014
+#define DPLL_B			0x06018
+#define DPLL_VCO_ENABLE			(1 << 31)
+#define DPLL_DVO_HIGH_SPEED		(1 << 30)
+#define DPLL_SYNCLOCK_ENABLE		(1 << 29)
+#define DPLL_VGA_MODE_DIS		(1 << 28)
+#define DPLLB_MODE_DAC_SERIAL		(1 << 26)	/* i915 */
+#define DPLLB_MODE_LVDS			(2 << 26)	/* i915 */
+#define DPLL_MODE_MASK			(3 << 26)
+#define DPLL_DAC_SERIAL_P2_CLOCK_DIV_10	(0 << 24)	/* i915 */
+#define DPLL_DAC_SERIAL_P2_CLOCK_DIV_5	(1 << 24)	/* i915 */
+#define DPLLB_LVDS_P2_CLOCK_DIV_14	(0 << 24)	/* i915 */
+#define DPLLB_LVDS_P2_CLOCK_DIV_7	(1 << 24)	/* i915 */
+#define DPLL_P2_CLOCK_DIV_MASK		0x03000000	/* i915 */
+#define DPLL_FPA01_P1_POST_DIV_MASK	0x00ff0000	/* i915 */
 /*
  *  The i830 generation, in DAC/serial mode, defines p1 as two plus this
  * bitfield, or just 2 if PLL_P1_DIVIDE_BY_TWO is set.
@@ -152,35 +151,35 @@
  * The i830 generation, in LVDS mode, defines P1 as the bit number set within
  * this field (only one bit may be set).
  */
-# define DPLL_FPA01_P1_POST_DIV_MASK_I830_LVDS	0x003f0000
-# define DPLL_FPA01_P1_POST_DIV_SHIFT		16
-# define PLL_P2_DIVIDE_BY_4		(1 << 23)	/* i830, required
+#define DPLL_FPA01_P1_POST_DIV_MASK_I830_LVDS	0x003f0000
+#define DPLL_FPA01_P1_POST_DIV_SHIFT	16
+#define PLL_P2_DIVIDE_BY_4		(1 << 23)	/* i830, required
 							 * in DVO non-gang */
-# define PLL_P1_DIVIDE_BY_TWO			(1 << 21)	/* i830 */
-# define PLL_REF_INPUT_DREFCLK			(0 << 13)
-# define PLL_REF_INPUT_TVCLKINA			(1 << 13)	/* i830 */
-# define PLL_REF_INPUT_TVCLKINBC		(2 << 13)	/* SDVO
+# define PLL_P1_DIVIDE_BY_TWO		(1 << 21)	/* i830 */
+#define PLL_REF_INPUT_DREFCLK		(0 << 13)
+#define PLL_REF_INPUT_TVCLKINA		(1 << 13)	/* i830 */
+#define PLL_REF_INPUT_TVCLKINBC		(2 << 13)	/* SDVO
 								 * TVCLKIN */
-# define PLLB_REF_INPUT_SPREADSPECTRUMIN	(3 << 13)
-# define PLL_REF_INPUT_MASK			(3 << 13)
-# define PLL_LOAD_PULSE_PHASE_SHIFT		9
+#define PLLB_REF_INPUT_SPREADSPECTRUMIN	(3 << 13)
+#define PLL_REF_INPUT_MASK		(3 << 13)
+#define PLL_LOAD_PULSE_PHASE_SHIFT	9
 /*
  * Parallel to Serial Load Pulse phase selection.
  * Selects the phase for the 10X DPLL clock for the PCIe
  * digital display port. The range is 4 to 13; 10 or more
  * is just a flip delay. The default is 6
  */
-# define PLL_LOAD_PULSE_PHASE_MASK	(0xf << PLL_LOAD_PULSE_PHASE_SHIFT)
-# define DISPLAY_RATE_SELECT_FPA1	(1 << 8)
+#define PLL_LOAD_PULSE_PHASE_MASK	(0xf << PLL_LOAD_PULSE_PHASE_SHIFT)
+#define DISPLAY_RATE_SELECT_FPA1	(1 << 8)
 
 /*
  * SDVO multiplier for 945G/GM. Not used on 965.
  *
  * DPLL_MD_UDI_MULTIPLIER_MASK
  */
-# define SDVO_MULTIPLIER_MASK			0x000000ff
-# define SDVO_MULTIPLIER_SHIFT_HIRES		4
-# define SDVO_MULTIPLIER_SHIFT_VGA		0
+#define SDVO_MULTIPLIER_MASK		0x000000ff
+#define SDVO_MULTIPLIER_SHIFT_HIRES	4
+#define SDVO_MULTIPLIER_SHIFT_VGA	0
 
 /*
  * PLL_MD
@@ -194,11 +193,11 @@
  *
  * Value is pixels minus 1.  Must be set to 1 pixel for SDVO.
  */
-# define DPLL_MD_UDI_DIVIDER_MASK		0x3f000000
-# define DPLL_MD_UDI_DIVIDER_SHIFT		24
+#define DPLL_MD_UDI_DIVIDER_MASK	0x3f000000
+#define DPLL_MD_UDI_DIVIDER_SHIFT	24
 /* UDI pixel divider for VGA, same as DPLL_MD_UDI_DIVIDER_MASK. */
-# define DPLL_MD_VGA_UDI_DIVIDER_MASK		0x003f0000
-# define DPLL_MD_VGA_UDI_DIVIDER_SHIFT		16
+#define DPLL_MD_VGA_UDI_DIVIDER_MASK	0x003f0000
+#define DPLL_MD_VGA_UDI_DIVIDER_SHIFT	16
 /*
  * SDVO/UDI pixel multiplier.
  *
@@ -216,80 +215,80 @@
  * This register field has values of multiplication factor minus 1, with
  * a maximum multiplier of 5 for SDVO.
  */
-# define DPLL_MD_UDI_MULTIPLIER_MASK		0x00003f00
-# define DPLL_MD_UDI_MULTIPLIER_SHIFT		8
+#define DPLL_MD_UDI_MULTIPLIER_MASK	0x00003f00
+#define DPLL_MD_UDI_MULTIPLIER_SHIFT	8
 /*
  * SDVO/UDI pixel multiplier for VGA, same as DPLL_MD_UDI_MULTIPLIER_MASK.
  * This best be set to the default value (3) or the CRT won't work. No,
  * I don't entirely understand what this does...
  */
-# define DPLL_MD_VGA_UDI_MULTIPLIER_MASK	0x0000003f
-# define DPLL_MD_VGA_UDI_MULTIPLIER_SHIFT	0
+#define DPLL_MD_VGA_UDI_MULTIPLIER_MASK	0x0000003f
+#define DPLL_MD_VGA_UDI_MULTIPLIER_SHIFT 0
 
 #define DPLL_TEST		0x606c
-# define DPLLB_TEST_SDVO_DIV_1			(0 << 22)
-# define DPLLB_TEST_SDVO_DIV_2			(1 << 22)
-# define DPLLB_TEST_SDVO_DIV_4			(2 << 22)
-# define DPLLB_TEST_SDVO_DIV_MASK		(3 << 22)
-# define DPLLB_TEST_N_BYPASS			(1 << 19)
-# define DPLLB_TEST_M_BYPASS			(1 << 18)
-# define DPLLB_INPUT_BUFFER_ENABLE		(1 << 16)
-# define DPLLA_TEST_N_BYPASS			(1 << 3)
-# define DPLLA_TEST_M_BYPASS			(1 << 2)
-# define DPLLA_INPUT_BUFFER_ENABLE		(1 << 0)
+#define DPLLB_TEST_SDVO_DIV_1		(0 << 22)
+#define DPLLB_TEST_SDVO_DIV_2		(1 << 22)
+#define DPLLB_TEST_SDVO_DIV_4		(2 << 22)
+#define DPLLB_TEST_SDVO_DIV_MASK	(3 << 22)
+#define DPLLB_TEST_N_BYPASS		(1 << 19)
+#define DPLLB_TEST_M_BYPASS		(1 << 18)
+#define DPLLB_INPUT_BUFFER_ENABLE	(1 << 16)
+#define DPLLA_TEST_N_BYPASS		(1 << 3)
+#define DPLLA_TEST_M_BYPASS		(1 << 2)
+#define DPLLA_INPUT_BUFFER_ENABLE	(1 << 0)
 
 #define ADPA			0x61100
-#define ADPA_DAC_ENABLE 	(1<<31)
-#define ADPA_DAC_DISABLE	0
-#define ADPA_PIPE_SELECT_MASK	(1<<30)
-#define ADPA_PIPE_A_SELECT	0
-#define ADPA_PIPE_B_SELECT	(1<<30)
-#define ADPA_USE_VGA_HVPOLARITY (1<<15)
-#define ADPA_SETS_HVPOLARITY	0
-#define ADPA_VSYNC_CNTL_DISABLE (1<<11)
-#define ADPA_VSYNC_CNTL_ENABLE	0
-#define ADPA_HSYNC_CNTL_DISABLE (1<<10)
-#define ADPA_HSYNC_CNTL_ENABLE	0
-#define ADPA_VSYNC_ACTIVE_HIGH	(1<<4)
-#define ADPA_VSYNC_ACTIVE_LOW	0
-#define ADPA_HSYNC_ACTIVE_HIGH	(1<<3)
-#define ADPA_HSYNC_ACTIVE_LOW	0
-
-#define FPA0		0x06040
-#define FPA1		0x06044
-#define FPB0		0x06048
-#define FPB1		0x0604c
-# define FP_N_DIV_MASK				0x003f0000
-# define FP_N_DIV_SHIFT				16
-# define FP_M1_DIV_MASK				0x00003f00
-# define FP_M1_DIV_SHIFT			8
-# define FP_M2_DIV_MASK				0x0000003f
-# define FP_M2_DIV_SHIFT			0
-
+#define ADPA_DAC_ENABLE			(1 << 31)
+#define ADPA_DAC_DISABLE		0
+#define ADPA_PIPE_SELECT_MASK		(1 << 30)
+#define ADPA_PIPE_A_SELECT		0
+#define ADPA_PIPE_B_SELECT		(1 << 30)
+#define ADPA_USE_VGA_HVPOLARITY		(1 << 15)
+#define ADPA_SETS_HVPOLARITY		0
+#define ADPA_VSYNC_CNTL_DISABLE		(1 << 11)
+#define ADPA_VSYNC_CNTL_ENABLE		0
+#define ADPA_HSYNC_CNTL_DISABLE		(1 << 10)
+#define ADPA_HSYNC_CNTL_ENABLE		0
+#define ADPA_VSYNC_ACTIVE_HIGH		(1 << 4)
+#define ADPA_VSYNC_ACTIVE_LOW		0
+#define ADPA_HSYNC_ACTIVE_HIGH		(1 << 3)
+#define ADPA_HSYNC_ACTIVE_LOW		0
+
+#define FPA0			0x06040
+#define FPA1			0x06044
+#define FPB0			0x06048
+#define FPB1			0x0604c
+#define FP_N_DIV_MASK			0x003f0000
+#define FP_N_DIV_SHIFT			16
+#define FP_M1_DIV_MASK			0x00003f00
+#define FP_M1_DIV_SHIFT			8
+#define FP_M2_DIV_MASK			0x0000003f
+#define FP_M2_DIV_SHIFT			0
 
 #define PORT_HOTPLUG_EN		0x61110
-# define SDVOB_HOTPLUG_INT_EN			(1 << 26)
-# define SDVOC_HOTPLUG_INT_EN			(1 << 25)
-# define TV_HOTPLUG_INT_EN			(1 << 18)
-# define CRT_HOTPLUG_INT_EN			(1 << 9)
-# define CRT_HOTPLUG_FORCE_DETECT		(1 << 3)
+#define SDVOB_HOTPLUG_INT_EN		(1 << 26)
+#define SDVOC_HOTPLUG_INT_EN		(1 << 25)
+#define TV_HOTPLUG_INT_EN		(1 << 18)
+#define CRT_HOTPLUG_INT_EN		(1 << 9)
+#define CRT_HOTPLUG_FORCE_DETECT	(1 << 3)
 
 #define PORT_HOTPLUG_STAT	0x61114
-# define CRT_HOTPLUG_INT_STATUS			(1 << 11)
-# define TV_HOTPLUG_INT_STATUS			(1 << 10)
-# define CRT_HOTPLUG_MONITOR_MASK		(3 << 8)
-# define CRT_HOTPLUG_MONITOR_COLOR		(3 << 8)
-# define CRT_HOTPLUG_MONITOR_MONO		(2 << 8)
-# define CRT_HOTPLUG_MONITOR_NONE		(0 << 8)
-# define SDVOC_HOTPLUG_INT_STATUS		(1 << 7)
-# define SDVOB_HOTPLUG_INT_STATUS		(1 << 6)
+#define CRT_HOTPLUG_INT_STATUS		(1 << 11)
+#define TV_HOTPLUG_INT_STATUS		(1 << 10)
+#define CRT_HOTPLUG_MONITOR_MASK	(3 << 8)
+#define CRT_HOTPLUG_MONITOR_COLOR	(3 << 8)
+#define CRT_HOTPLUG_MONITOR_MONO	(2 << 8)
+#define CRT_HOTPLUG_MONITOR_NONE	(0 << 8)
+#define SDVOC_HOTPLUG_INT_STATUS	(1 << 7)
+#define SDVOB_HOTPLUG_INT_STATUS	(1 << 6)
 
 #define SDVOB			0x61140
 #define SDVOC			0x61160
-#define SDVO_ENABLE				(1 << 31)
-#define SDVO_PIPE_B_SELECT			(1 << 30)
-#define SDVO_STALL_SELECT			(1 << 29)
-#define SDVO_INTERRUPT_ENABLE			(1 << 26)
+#define SDVO_ENABLE			(1 << 31)
+#define SDVO_PIPE_B_SELECT		(1 << 30)
+#define SDVO_STALL_SELECT		(1 << 29)
+#define SDVO_INTERRUPT_ENABLE		(1 << 26)
+
 /**
  * 915G/GM SDVO pixel multiplier.
  *
@@ -297,18 +296,18 @@
  *
  * DPLL_MD_UDI_MULTIPLIER_MASK
  */
-#define SDVO_PORT_MULTIPLY_MASK			(7 << 23)
-#define SDVO_PORT_MULTIPLY_SHIFT		23
-#define SDVO_PHASE_SELECT_MASK			(15 << 19)
-#define SDVO_PHASE_SELECT_DEFAULT		(6 << 19)
-#define SDVO_CLOCK_OUTPUT_INVERT		(1 << 18)
-#define SDVOC_GANG_MODE				(1 << 16)
-#define SDVO_BORDER_ENABLE			(1 << 7)
-#define SDVOB_PCIE_CONCURRENCY			(1 << 3)
-#define SDVO_DETECTED				(1 << 2)
+#define SDVO_PORT_MULTIPLY_MASK		(7 << 23)
+#define SDVO_PORT_MULTIPLY_SHIFT	23
+#define SDVO_PHASE_SELECT_MASK		(15 << 19)
+#define SDVO_PHASE_SELECT_DEFAULT	(6 << 19)
+#define SDVO_CLOCK_OUTPUT_INVERT	(1 << 18)
+#define SDVOC_GANG_MODE			(1 << 16)
+#define SDVO_BORDER_ENABLE		(1 << 7)
+#define SDVOB_PCIE_CONCURRENCY		(1 << 3)
+#define SDVO_DETECTED			(1 << 2)
 /* Bits to be preserved when writing */
 #define SDVOB_PRESERVE_MASK		((1 << 17) | (1 << 16) | (1 << 14))
-#define SDVOC_PRESERVE_MASK			(1 << 17)
+#define SDVOC_PRESERVE_MASK		(1 << 17)
 
 /*
  * This register controls the LVDS output enable, pipe selection, and data
@@ -321,116 +320,116 @@
  * Enables the LVDS port.  This bit must be set before DPLLs are enabled, as
  * the DPLL semantics change when the LVDS is assigned to that pipe.
  */
-# define LVDS_PORT_EN			(1 << 31)
+#define LVDS_PORT_EN			(1 << 31)
 /* Selects pipe B for LVDS data.  Must be set on pre-965. */
-# define LVDS_PIPEB_SELECT		(1 << 30)
+#define LVDS_PIPEB_SELECT		(1 << 30)
 
 /* Turns on border drawing to allow centered display. */
-# define LVDS_BORDER_EN                 (1 << 15)
+#define LVDS_BORDER_EN			(1 << 15)
 
 /*
  * Enables the A0-A2 data pairs and CLKA, containing 18 bits of color data per
  * pixel.
  */
-# define LVDS_A0A2_CLKA_POWER_MASK	(3 << 8)
-# define LVDS_A0A2_CLKA_POWER_DOWN	(0 << 8)
-# define LVDS_A0A2_CLKA_POWER_UP	(3 << 8)
+#define LVDS_A0A2_CLKA_POWER_MASK	(3 << 8)
+#define LVDS_A0A2_CLKA_POWER_DOWN	(0 << 8)
+#define LVDS_A0A2_CLKA_POWER_UP		(3 << 8)
 /*
  * Controls the A3 data pair, which contains the additional LSBs for 24 bit
  * mode.  Only enabled if LVDS_A0A2_CLKA_POWER_UP also indicates it should be
  * on.
  */
-# define LVDS_A3_POWER_MASK		(3 << 6)
-# define LVDS_A3_POWER_DOWN		(0 << 6)
-# define LVDS_A3_POWER_UP		(3 << 6)
+#define LVDS_A3_POWER_MASK		(3 << 6)
+#define LVDS_A3_POWER_DOWN		(0 << 6)
+#define LVDS_A3_POWER_UP		(3 << 6)
 /*
  * Controls the CLKB pair.  This should only be set when LVDS_B0B3_POWER_UP
  * is set.
  */
-# define LVDS_CLKB_POWER_MASK		(3 << 4)
-# define LVDS_CLKB_POWER_DOWN		(0 << 4)
-# define LVDS_CLKB_POWER_UP		(3 << 4)
+#define LVDS_CLKB_POWER_MASK		(3 << 4)
+#define LVDS_CLKB_POWER_DOWN		(0 << 4)
+#define LVDS_CLKB_POWER_UP		(3 << 4)
 /*
  * Controls the B0-B3 data pairs.  This must be set to match the DPLL p2
  * setting for whether we are in dual-channel mode.  The B3 pair will
  * additionally only be powered up when LVDS_A3_POWER_UP is set.
  */
-# define LVDS_B0B3_POWER_MASK		(3 << 2)
-# define LVDS_B0B3_POWER_DOWN		(0 << 2)
-# define LVDS_B0B3_POWER_UP		(3 << 2)
-
-#define PIPEACONF 0x70008
-#define PIPEACONF_ENABLE	(1<<31)
-#define PIPEACONF_DISABLE	0
-#define PIPEACONF_DOUBLE_WIDE	(1<<30)
-#define PIPECONF_ACTIVE		(1<<30)
-#define I965_PIPECONF_ACTIVE	(1<<30)
-#define PIPECONF_DSIPLL_LOCK	(1<<29)
-#define PIPEACONF_SINGLE_WIDE	0
-#define PIPEACONF_PIPE_UNLOCKED 0
-#define PIPEACONF_DSR		(1<<26)
-#define PIPEACONF_PIPE_LOCKED	(1<<25)
-#define PIPEACONF_PALETTE	0
-#define PIPECONF_FORCE_BORDER	(1<<25)
-#define PIPEACONF_GAMMA 	(1<<24)
-#define PIPECONF_PROGRESSIVE	(0 << 21)
+#define LVDS_B0B3_POWER_MASK		(3 << 2)
+#define LVDS_B0B3_POWER_DOWN		(0 << 2)
+#define LVDS_B0B3_POWER_UP		(3 << 2)
+
+#define PIPEACONF		0x70008
+#define PIPEACONF_ENABLE		(1 << 31)
+#define PIPEACONF_DISABLE		0
+#define PIPEACONF_DOUBLE_WIDE		(1 << 30)
+#define PIPECONF_ACTIVE			(1 << 30)
+#define I965_PIPECONF_ACTIVE		(1 << 30)
+#define PIPECONF_DSIPLL_LOCK		(1 << 29)
+#define PIPEACONF_SINGLE_WIDE		0
+#define PIPEACONF_PIPE_UNLOCKED		0
+#define PIPEACONF_DSR			(1 << 26)
+#define PIPEACONF_PIPE_LOCKED		(1 << 25)
+#define PIPEACONF_PALETTE		0
+#define PIPECONF_FORCE_BORDER		(1 << 25)
+#define PIPEACONF_GAMMA			(1 << 24)
+#define PIPECONF_PROGRESSIVE		(0 << 21)
 #define PIPECONF_INTERLACE_W_FIELD_INDICATION	(6 << 21)
 #define PIPECONF_INTERLACE_FIELD_0_ONLY		(7 << 21)
-#define PIPECONF_PLANE_OFF 	(1<<19)
-#define PIPECONF_CURSOR_OFF 	(1<<18)
+#define PIPECONF_PLANE_OFF		(1 << 19)
+#define PIPECONF_CURSOR_OFF		(1 << 18)
 
+#define PIPEBCONF		0x71008
+#define PIPEBCONF_ENABLE		(1 << 31)
+#define PIPEBCONF_DISABLE		0
+#define PIPEBCONF_DOUBLE_WIDE		(1 << 30)
+#define PIPEBCONF_DISABLE		0
+#define PIPEBCONF_GAMMA			(1 << 24)
+#define PIPEBCONF_PALETTE		0
 
-#define PIPEBCONF 0x71008
-#define PIPEBCONF_ENABLE	(1<<31)
-#define PIPEBCONF_DISABLE	0
-#define PIPEBCONF_DOUBLE_WIDE	(1<<30)
-#define PIPEBCONF_DISABLE	0
-#define PIPEBCONF_GAMMA 	(1<<24)
-#define PIPEBCONF_PALETTE	0
-
-#define PIPECCONF 0x72008
+#define PIPECCONF		0x72008
 
 #define PIPEBGCMAXRED		0x71010
 #define PIPEBGCMAXGREEN		0x71014
 #define PIPEBGCMAXBLUE		0x71018
 
-#define PIPEASTAT               0x70024
+#define PIPEASTAT		0x70024
 #define PIPEBSTAT		0x71024
 #define PIPECSTAT		0x72024
-#define PIPE_VBLANK_INTERRUPT_STATUS         (1UL<<1)
-#define PIPE_START_VBLANK_INTERRUPT_STATUS   (1UL<<2)
-#define PIPE_VBLANK_CLEAR                    (1 << 1)
-#define PIPE_VBLANK_STATUS                   (1 << 1)
-#define PIPE_TE_STATUS		             (1UL<<6)
-#define PIPE_DPST_EVENT_STATUS		     (1UL<<7)
-#define PIPE_VSYNC_CLEAR                     (1UL<<9)
-#define PIPE_VSYNC_STATUS                    (1UL<<9)
-#define PIPE_HDMI_AUDIO_UNDERRUN_STATUS      (1UL<<10)
-#define PIPE_HDMI_AUDIO_BUFFER_DONE_STATUS   (1UL<<11)
-#define PIPE_VBLANK_INTERRUPT_ENABLE         (1UL<<17)
-#define PIPE_START_VBLANK_INTERRUPT_ENABLE   (1UL<<18)
-#define PIPE_TE_ENABLE		             (1UL<<22)
-#define PIPE_DPST_EVENT_ENABLE               (1UL<<23)
-#define PIPE_VSYNC_ENABL                     (1UL<<25)
-#define PIPE_HDMI_AUDIO_UNDERRUN             (1UL<<26)
-#define PIPE_HDMI_AUDIO_BUFFER_DONE          (1UL<<27)
-#define PIPE_HDMI_AUDIO_INT_MASK (PIPE_HDMI_AUDIO_UNDERRUN | PIPE_HDMI_AUDIO_BUFFER_DONE)
+#define PIPE_VBLANK_INTERRUPT_STATUS		(1UL << 1)
+#define PIPE_START_VBLANK_INTERRUPT_STATUS	(1UL << 2)
+#define PIPE_VBLANK_CLEAR			(1 << 1)
+#define PIPE_VBLANK_STATUS			(1 << 1)
+#define PIPE_TE_STATUS				(1UL << 6)
+#define PIPE_DPST_EVENT_STATUS			(1UL << 7)
+#define PIPE_VSYNC_CLEAR			(1UL << 9)
+#define PIPE_VSYNC_STATUS			(1UL << 9)
+#define PIPE_HDMI_AUDIO_UNDERRUN_STATUS		(1UL << 10)
+#define PIPE_HDMI_AUDIO_BUFFER_DONE_STATUS	(1UL << 11)
+#define PIPE_VBLANK_INTERRUPT_ENABLE		(1UL << 17)
+#define PIPE_START_VBLANK_INTERRUPT_ENABLE	(1UL << 18)
+#define PIPE_TE_ENABLE				(1UL << 22)
+#define PIPE_DPST_EVENT_ENABLE			(1UL << 23)
+#define PIPE_VSYNC_ENABL			(1UL << 25)
+#define PIPE_HDMI_AUDIO_UNDERRUN		(1UL << 26)
+#define PIPE_HDMI_AUDIO_BUFFER_DONE		(1UL << 27)
+#define PIPE_HDMI_AUDIO_INT_MASK		(PIPE_HDMI_AUDIO_UNDERRUN | \
+						PIPE_HDMI_AUDIO_BUFFER_DONE)
 #define PIPE_EVENT_MASK ((1 << 29)|(1 << 28)|(1 << 27)|(1 << 26)|(1 << 24)|(1 << 23)|(1 << 22)|(1 << 21)|(1 << 20)|(1 << 16))
 #define PIPE_VBLANK_MASK ((1 << 25)|(1 << 24)|(1 << 18)|(1 << 17))
 #define HISTOGRAM_INT_CONTROL		0x61268
 #define HISTOGRAM_BIN_DATA		0X61264
 #define HISTOGRAM_LOGIC_CONTROL		0x61260
 #define PWM_CONTROL_LOGIC		0x61250
-#define PIPE_HOTPLUG_INTERRUPT_STATUS	(1UL<<10)
-#define HISTOGRAM_INTERRUPT_ENABLE	(1UL<<31)
-#define HISTOGRAM_LOGIC_ENABLE		(1UL<<31)
-#define PWM_LOGIC_ENABLE		(1UL<<31)
-#define PWM_PHASEIN_ENABLE		(1UL<<25)
-#define PWM_PHASEIN_INT_ENABLE		(1UL<<24)
-#define PWM_PHASEIN_VB_COUNT		0x00001f00
-#define PWM_PHASEIN_INC			0x0000001f
-#define HISTOGRAM_INT_CTRL_CLEAR	(1UL<<30)
-#define DPST_YUV_LUMA_MODE		0
+#define PIPE_HOTPLUG_INTERRUPT_STATUS		(1UL << 10)
+#define HISTOGRAM_INTERRUPT_ENABLE		(1UL << 31)
+#define HISTOGRAM_LOGIC_ENABLE			(1UL << 31)
+#define PWM_LOGIC_ENABLE			(1UL << 31)
+#define PWM_PHASEIN_ENABLE			(1UL << 25)
+#define PWM_PHASEIN_INT_ENABLE			(1UL << 24)
+#define PWM_PHASEIN_VB_COUNT			0x00001f00
+#define PWM_PHASEIN_INC				0x0000001f
+#define HISTOGRAM_INT_CTRL_CLEAR		(1UL << 30)
+#define DPST_YUV_LUMA_MODE			0
 
 struct dpst_ie_histogram_control {
 	union {
@@ -470,12 +469,12 @@ struct dpst_guardband {
 #define PIPEBFRAMEPIXEL		0x71044
 #define PIPECFRAMEHIGH		0x72040
 #define PIPECFRAMEPIXEL		0x72044
-#define PIPE_FRAME_HIGH_MASK    0x0000ffff
-#define PIPE_FRAME_HIGH_SHIFT   0
-#define PIPE_FRAME_LOW_MASK     0xff000000
-#define PIPE_FRAME_LOW_SHIFT    24
-#define PIPE_PIXEL_MASK         0x00ffffff
-#define PIPE_PIXEL_SHIFT        0
+#define PIPE_FRAME_HIGH_MASK	0x0000ffff
+#define PIPE_FRAME_HIGH_SHIFT	0
+#define PIPE_FRAME_LOW_MASK	0xff000000
+#define PIPE_FRAME_LOW_SHIFT	24
+#define PIPE_PIXEL_MASK		0x00ffffff
+#define PIPE_PIXEL_SHIFT	0
 
 #define DSPARB			0x70030
 #define DSPFW1			0x70034
@@ -488,30 +487,30 @@ struct dpst_guardband {
 #define DSPACNTR		0x70180
 #define DSPBCNTR		0x71180
 #define DSPCCNTR		0x72180
-#define DISPLAY_PLANE_ENABLE 			(1<<31)
+#define DISPLAY_PLANE_ENABLE			(1 << 31)
 #define DISPLAY_PLANE_DISABLE			0
-#define DISPPLANE_GAMMA_ENABLE			(1<<30)
+#define DISPPLANE_GAMMA_ENABLE			(1 << 30)
 #define DISPPLANE_GAMMA_DISABLE			0
-#define DISPPLANE_PIXFORMAT_MASK		(0xf<<26)
-#define DISPPLANE_8BPP				(0x2<<26)
-#define DISPPLANE_15_16BPP			(0x4<<26)
-#define DISPPLANE_16BPP				(0x5<<26)
-#define DISPPLANE_32BPP_NO_ALPHA 		(0x6<<26)
-#define DISPPLANE_32BPP				(0x7<<26)
-#define DISPPLANE_STEREO_ENABLE			(1<<25)
+#define DISPPLANE_PIXFORMAT_MASK		(0xf << 26)
+#define DISPPLANE_8BPP				(0x2 << 26)
+#define DISPPLANE_15_16BPP			(0x4 << 26)
+#define DISPPLANE_16BPP				(0x5 << 26)
+#define DISPPLANE_32BPP_NO_ALPHA		(0x6 << 26)
+#define DISPPLANE_32BPP				(0x7 << 26)
+#define DISPPLANE_STEREO_ENABLE			(1 << 25)
 #define DISPPLANE_STEREO_DISABLE		0
-#define DISPPLANE_SEL_PIPE_MASK			(1<<24)
+#define DISPPLANE_SEL_PIPE_MASK			(1 << 24)
 #define DISPPLANE_SEL_PIPE_POS			24
 #define DISPPLANE_SEL_PIPE_A			0
-#define DISPPLANE_SEL_PIPE_B			(1<<24)
-#define DISPPLANE_SRC_KEY_ENABLE		(1<<22)
+#define DISPPLANE_SEL_PIPE_B			(1 << 24)
+#define DISPPLANE_SRC_KEY_ENABLE		(1 << 22)
 #define DISPPLANE_SRC_KEY_DISABLE		0
-#define DISPPLANE_LINE_DOUBLE			(1<<20)
+#define DISPPLANE_LINE_DOUBLE			(1 << 20)
 #define DISPPLANE_NO_LINE_DOUBLE		0
 #define DISPPLANE_STEREO_POLARITY_FIRST		0
-#define DISPPLANE_STEREO_POLARITY_SECOND	(1<<18)
+#define DISPPLANE_STEREO_POLARITY_SECOND	(1 << 18)
 /* plane B only */
-#define DISPPLANE_ALPHA_TRANS_ENABLE		(1<<15)
+#define DISPPLANE_ALPHA_TRANS_ENABLE		(1 << 15)
 #define DISPPLANE_ALPHA_TRANS_DISABLE		0
 #define DISPPLANE_SPRITE_ABOVE_DISPLAYA		0
 #define DISPPLANE_SPRITE_ABOVE_OVERLAY		(1)
@@ -548,25 +547,25 @@ struct dpst_guardband {
 
 #define DSPCSURF		0x7219C
 #define DSPCTILEOFF		0x721A4
-#define DSPCKEYMAXVAL 		0x721A0
-#define DSPCKEYMINVAL 		0x72194
-#define DSPCKEYMSK 		0x72198
+#define DSPCKEYMAXVAL		0x721A0
+#define DSPCKEYMINVAL		0x72194
+#define DSPCKEYMSK		0x72198
 
 #define VGACNTRL		0x71400
-# define VGA_DISP_DISABLE			(1 << 31)
-# define VGA_2X_MODE				(1 << 30)
-# define VGA_PIPE_B_SELECT			(1 << 29)
+#define VGA_DISP_DISABLE		(1 << 31)
+#define VGA_2X_MODE			(1 << 30)
+#define VGA_PIPE_B_SELECT		(1 << 29)
 
 /*
  * Overlay registers
  */
 #define OV_C_OFFSET		0x08000
 #define OV_OVADD		0x30000
-#define OV_DOVASTA              0x30008
-# define OV_PIPE_SELECT				((1 << 6)|(1 << 7))
-# define OV_PIPE_SELECT_POS			6
-# define OV_PIPE_A				0
-# define OV_PIPE_C				1
+#define OV_DOVASTA		0x30008
+# define OV_PIPE_SELECT			((1 << 6)|(1 << 7))
+# define OV_PIPE_SELECT_POS		6
+# define OV_PIPE_A			0
+# define OV_PIPE_C			1
 #define OV_OGAMC5		0x30010
 #define OV_OGAMC4		0x30014
 #define OV_OGAMC3		0x30018
@@ -574,7 +573,7 @@ struct dpst_guardband {
 #define OV_OGAMC1		0x30020
 #define OV_OGAMC0		0x30024
 #define OVC_OVADD		0x38000
-#define OVC_DOVCSTA             0x38008
+#define OVC_DOVCSTA		0x38008
 #define OVC_OGAMC5		0x38010
 #define OVC_OGAMC4		0x38014
 #define OVC_OGAMC3		0x38018
@@ -627,16 +626,16 @@ struct dpst_guardband {
 
 /* Cursor A & B regs */
 #define CURACNTR		0x70080
-#define   CURSOR_MODE_DISABLE   0x00
-#define   CURSOR_MODE_64_32B_AX 0x07
-#define   CURSOR_MODE_64_ARGB_AX ((1 << 5) | CURSOR_MODE_64_32B_AX)
-#define   MCURSOR_GAMMA_ENABLE  (1 << 26)
+#define CURSOR_MODE_DISABLE		0x00
+#define CURSOR_MODE_64_32B_AX		0x07
+#define CURSOR_MODE_64_ARGB_AX		((1 << 5) | CURSOR_MODE_64_32B_AX)
+#define MCURSOR_GAMMA_ENABLE		(1 << 26)
 #define CURABASE		0x70084
 #define CURAPOS			0x70088
-#define   CURSOR_POS_MASK       0x007FF
-#define   CURSOR_POS_SIGN       0x8000
-#define   CURSOR_X_SHIFT        0
-#define   CURSOR_Y_SHIFT        16
+#define CURSOR_POS_MASK			0x007FF
+#define CURSOR_POS_SIGN			0x8000
+#define CURSOR_X_SHIFT			0
+#define CURSOR_Y_SHIFT			16
 #define CURBCNTR		0x700c0
 #define CURBBASE		0x700c4
 #define CURBPOS			0x700c8
@@ -647,22 +646,22 @@ struct dpst_guardband {
 /*
  * Interrupt Registers
  */
-#define IER 0x020a0
-#define IIR 0x020a4
-#define IMR 0x020a8
-#define ISR 0x020ac
+#define IER			0x020a0
+#define IIR			0x020a4
+#define IMR			0x020a8
+#define ISR			0x020ac
 
 /*
  * MOORESTOWN delta registers
  */
 #define MRST_DPLL_A		0x0f014
 #define MDFLD_DPLL_B		0x0f018
-#define MDFLD_INPUT_REF_SEL	(1 << 14)
-#define MDFLD_VCO_SEL		(1 << 16)
-#define DPLLA_MODE_LVDS		(2 << 26)	/* mrst */
-#define MDFLD_PLL_LATCHEN	(1 << 28)
-#define MDFLD_PWR_GATE_EN	(1 << 30)
-#define MDFLD_P1_MASK		(0x1FF << 17)
+#define MDFLD_INPUT_REF_SEL		(1 << 14)
+#define MDFLD_VCO_SEL			(1 << 16)
+#define DPLLA_MODE_LVDS			(2 << 26)	/* mrst */
+#define MDFLD_PLL_LATCHEN		(1 << 28)
+#define MDFLD_PWR_GATE_EN		(1 << 30)
+#define MDFLD_P1_MASK			(0x1FF << 17)
 #define MRST_FPA0		0x0f040
 #define MRST_FPA1		0x0f044
 #define MDFLD_DPLL_DIV0		0x0f048
@@ -672,45 +671,45 @@ struct dpst_guardband {
 /*
  * MEDFIELD HDMI registers
  */
-#define HDMIPHYMISCCTL   	0x61134
-# define HDMI_PHY_POWER_DOWN	0x7f
-#define HDMIB_CONTROL   	0x61140
-# define HDMIB_PORT_EN			(1 << 31)
-# define HDMIB_PIPE_B_SELECT		(1 << 30)
-# define HDMIB_NULL_PACKET		(1 << 9)
-#define HDMIB_HDCP_PORT (1 << 5)
+#define HDMIPHYMISCCTL		0x61134
+#define HDMI_PHY_POWER_DOWN		0x7f
+#define HDMIB_CONTROL		0x61140
+#define HDMIB_PORT_EN			(1 << 31)
+#define HDMIB_PIPE_B_SELECT		(1 << 30)
+#define HDMIB_NULL_PACKET		(1 << 9)
+#define HDMIB_HDCP_PORT			(1 << 5)
 
 /* #define LVDS			0x61180 */
-# define MRST_PANEL_8TO6_DITHER_ENABLE		(1 << 25)
-# define MRST_PANEL_24_DOT_1_FORMAT		(1 << 24)
-# define LVDS_A3_POWER_UP_0_OUTPUT		(1 << 6)
+#define MRST_PANEL_8TO6_DITHER_ENABLE	(1 << 25)
+#define MRST_PANEL_24_DOT_1_FORMAT	(1 << 24)
+#define LVDS_A3_POWER_UP_0_OUTPUT	(1 << 6)
 
 #define MIPI			0x61190
 #define MIPI_C			0x62190
-# define MIPI_PORT_EN			(1 << 31)
+#define MIPI_PORT_EN			(1 << 31)
 /* Turns on border drawing to allow centered display. */
-# define SEL_FLOPPED_HSTX		(1 << 23)
-# define PASS_FROM_SPHY_TO_AFE 		(1 << 16)
-# define MIPI_BORDER_EN			(1 << 15)
-# define MIPIA_3LANE_MIPIC_1LANE	0x1
-# define MIPIA_2LANE_MIPIC_2LANE	0x2
-# define TE_TRIGGER_DSI_PROTOCOL	(1 << 2)
-# define TE_TRIGGER_GPIO_PIN		(1 << 3)
-#define MIPI_TE_COUNT			0x61194
+#define SEL_FLOPPED_HSTX		(1 << 23)
+#define PASS_FROM_SPHY_TO_AFE		(1 << 16)
+#define MIPI_BORDER_EN			(1 << 15)
+#define MIPIA_3LANE_MIPIC_1LANE		0x1
+#define MIPIA_2LANE_MIPIC_2LANE		0x2
+#define TE_TRIGGER_DSI_PROTOCOL		(1 << 2)
+#define TE_TRIGGER_GPIO_PIN		(1 << 3)
+#define MIPI_TE_COUNT		0x61194
 
 /* #define PP_CONTROL	0x61204 */
-# define POWER_DOWN_ON_RESET		(1 << 1)
+#define POWER_DOWN_ON_RESET		(1 << 1)
 
 /* #define PFIT_CONTROL	0x61230 */
-# define PFIT_PIPE_SELECT				(3 << 29)
-# define PFIT_PIPE_SELECT_SHIFT			(29)
+#define PFIT_PIPE_SELECT		(3 << 29)
+#define PFIT_PIPE_SELECT_SHIFT		(29)
 
 /* #define BLC_PWM_CTL		0x61254 */
-#define MRST_BACKLIGHT_MODULATION_FREQ_SHIFT		(16)
-#define MRST_BACKLIGHT_MODULATION_FREQ_MASK		(0xffff << 16)
+#define MRST_BACKLIGHT_MODULATION_FREQ_SHIFT	(16)
+#define MRST_BACKLIGHT_MODULATION_FREQ_MASK	(0xffff << 16)
 
 /* #define PIPEACONF 0x70008 */
-#define PIPEACONF_PIPE_STATE	(1<<30)
+#define PIPEACONF_PIPE_STATE		(1 << 30)
 /* #define DSPACNTR		0x70180 */
 
 #define MRST_DSPABASE		0x7019c
@@ -724,281 +723,286 @@ struct dpst_guardband {
 /*
  *	MIPI IP registers
  */
-#define MIPIC_REG_OFFSET             0x800
-#define DEVICE_READY_REG             0xb000
-#define LP_OUTPUT_HOLD               (1 << 16)
-#define EXIT_ULPS_DEV_READY          0x3
-#define LP_OUTPUT_HOLD_RELEASE       0x810000
-# define ENTERING_ULPS		(2 << 1)
-# define EXITING_ULPS		(1 << 1)
-# define ULPS_MASK		(3 << 1)
-# define BUS_POSSESSION		(1 << 3)
-#define INTR_STAT_REG                0xb004
-#define RX_SOT_ERROR (1 << 0)
-#define RX_SOT_SYNC_ERROR (1 << 1)
-#define RX_ESCAPE_MODE_ENTRY_ERROR (1 << 3)
-#define RX_LP_TX_SYNC_ERROR (1 << 4)
-#define RX_HS_RECEIVE_TIMEOUT_ERROR (1 << 5)
-#define RX_FALSE_CONTROL_ERROR (1 << 6)
-#define RX_ECC_SINGLE_BIT_ERROR (1 << 7)
-#define RX_ECC_MULTI_BIT_ERROR (1 << 8)
-#define RX_CHECKSUM_ERROR (1 << 9)
-#define RX_DSI_DATA_TYPE_NOT_RECOGNIZED (1 << 10)
-#define RX_DSI_VC_ID_INVALID (1 << 11)
-#define TX_FALSE_CONTROL_ERROR (1 << 12)
-#define TX_ECC_SINGLE_BIT_ERROR (1 << 13)
-#define TX_ECC_MULTI_BIT_ERROR (1 << 14)
-#define TX_CHECKSUM_ERROR (1 << 15)
-#define TX_DSI_DATA_TYPE_NOT_RECOGNIZED (1 << 16)
-#define TX_DSI_VC_ID_INVALID (1 << 17)
-#define HIGH_CONTENTION (1 << 18)
-#define LOW_CONTENTION (1 << 19)
-#define DPI_FIFO_UNDER_RUN (1 << 20)
-#define HS_TX_TIMEOUT (1 << 21)
-#define LP_RX_TIMEOUT (1 << 22)
-#define TURN_AROUND_ACK_TIMEOUT (1 << 23)
-#define ACK_WITH_NO_ERROR (1 << 24)
-#define HS_GENERIC_WR_FIFO_FULL (1 << 27)
-#define LP_GENERIC_WR_FIFO_FULL (1 << 28)
-#define SPL_PKT_SENT			(1 << 30)
-#define INTR_EN_REG                  0xb008
-#define DSI_FUNC_PRG_REG             0xb00c
-#define DPI_CHANNEL_NUMBER_POS   0x03
-#define DBI_CHANNEL_NUMBER_POS   0x05
-#define FMT_DPI_POS              0x07
-#define FMT_DBI_POS              0x0A
-#define DBI_DATA_WIDTH_POS       0x0D
+#define MIPIC_REG_OFFSET		0x800
+
+#define DEVICE_READY_REG		0xb000
+#define LP_OUTPUT_HOLD				(1 << 16)
+#define EXIT_ULPS_DEV_READY			0x3
+#define LP_OUTPUT_HOLD_RELEASE			0x810000
+# define ENTERING_ULPS				(2 << 1)
+# define EXITING_ULPS				(1 << 1)
+# define ULPS_MASK				(3 << 1)
+# define BUS_POSSESSION				(1 << 3)
+#define INTR_STAT_REG			0xb004
+#define RX_SOT_ERROR				(1 << 0)
+#define RX_SOT_SYNC_ERROR			(1 << 1)
+#define RX_ESCAPE_MODE_ENTRY_ERROR		(1 << 3)
+#define RX_LP_TX_SYNC_ERROR			(1 << 4)
+#define RX_HS_RECEIVE_TIMEOUT_ERROR		(1 << 5)
+#define RX_FALSE_CONTROL_ERROR			(1 << 6)
+#define RX_ECC_SINGLE_BIT_ERROR			(1 << 7)
+#define RX_ECC_MULTI_BIT_ERROR			(1 << 8)
+#define RX_CHECKSUM_ERROR			(1 << 9)
+#define RX_DSI_DATA_TYPE_NOT_RECOGNIZED		(1 << 10)
+#define RX_DSI_VC_ID_INVALID			(1 << 11)
+#define TX_FALSE_CONTROL_ERROR			(1 << 12)
+#define TX_ECC_SINGLE_BIT_ERROR			(1 << 13)
+#define TX_ECC_MULTI_BIT_ERROR			(1 << 14)
+#define TX_CHECKSUM_ERROR			(1 << 15)
+#define TX_DSI_DATA_TYPE_NOT_RECOGNIZED		(1 << 16)
+#define TX_DSI_VC_ID_INVALID			(1 << 17)
+#define HIGH_CONTENTION				(1 << 18)
+#define LOW_CONTENTION				(1 << 19)
+#define DPI_FIFO_UNDER_RUN			(1 << 20)
+#define HS_TX_TIMEOUT				(1 << 21)
+#define LP_RX_TIMEOUT				(1 << 22)
+#define TURN_AROUND_ACK_TIMEOUT			(1 << 23)
+#define ACK_WITH_NO_ERROR			(1 << 24)
+#define HS_GENERIC_WR_FIFO_FULL			(1 << 27)
+#define LP_GENERIC_WR_FIFO_FULL			(1 << 28)
+#define SPL_PKT_SENT				(1 << 30)
+#define INTR_EN_REG			0xb008
+#define DSI_FUNC_PRG_REG		0xb00c
+#define DPI_CHANNEL_NUMBER_POS			0x03
+#define DBI_CHANNEL_NUMBER_POS			0x05
+#define FMT_DPI_POS				0x07
+#define FMT_DBI_POS				0x0A
+#define DBI_DATA_WIDTH_POS			0x0D
+
 /* DPI PIXEL FORMATS */
-#define RGB_565_FMT		     0x01	/* RGB 565 FORMAT */
-#define RGB_666_FMT		     0x02	/* RGB 666 FORMAT */
-#define LRGB_666_FMT		     0x03	/* RGB LOOSELY PACKED
-						 * 666 FORMAT
-						 */
-#define RGB_888_FMT		     0x04	/* RGB 888 FORMAT */
-#define VIRTUAL_CHANNEL_NUMBER_0	0x00	/* Virtual channel 0 */
-#define VIRTUAL_CHANNEL_NUMBER_1	0x01	/* Virtual channel 1 */
-#define VIRTUAL_CHANNEL_NUMBER_2	0x02	/* Virtual channel 2 */
-#define VIRTUAL_CHANNEL_NUMBER_3	0x03	/* Virtual channel 3 */
-#define DBI_NOT_SUPPORTED		0x00	/* command mode
-						 * is not supported
-						 */
-#define DBI_DATA_WIDTH_16BIT		0x01	/* 16 bit data */
+#define RGB_565_FMT				0x01	/* RGB 565 FORMAT */
+#define RGB_666_FMT				0x02	/* RGB 666 FORMAT */
+#define LRGB_666_FMT				0x03	/* RGB LOOSELY PACKED
+							 * 666 FORMAT
+							 */
+#define RGB_888_FMT				0x04	/* RGB 888 FORMAT */
+#define VIRTUAL_CHANNEL_NUMBER_0		0x00	/* Virtual channel 0 */
+#define VIRTUAL_CHANNEL_NUMBER_1		0x01	/* Virtual channel 1 */
+#define VIRTUAL_CHANNEL_NUMBER_2		0x02	/* Virtual channel 2 */
+#define VIRTUAL_CHANNEL_NUMBER_3		0x03	/* Virtual channel 3 */
+
+#define DBI_NOT_SUPPORTED			0x00	/* command mode
+							 * is not supported
+							 */
+#define DBI_DATA_WIDTH_16BIT			0x01	/* 16 bit data */
 #define DBI_DATA_WIDTH_9BIT			0x02	/* 9 bit data */
 #define DBI_DATA_WIDTH_8BIT			0x03	/* 8 bit data */
-#define DBI_DATA_WIDTH_OPT1		0x04	/* option 1 */
-#define DBI_DATA_WIDTH_OPT2		0x05	/* option 2 */
-#define HS_TX_TIMEOUT_REG            0xb010
-#define LP_RX_TIMEOUT_REG            0xb014
-#define TURN_AROUND_TIMEOUT_REG      0xb018
-#define DEVICE_RESET_REG             0xb01C
-#define DPI_RESOLUTION_REG           0xb020
-#define RES_V_POS                0x10
-#define DBI_RESOLUTION_REG           0xb024 /* Reserved for MDFLD */
-#define HORIZ_SYNC_PAD_COUNT_REG     0xb028
-#define HORIZ_BACK_PORCH_COUNT_REG   0xb02C
-#define HORIZ_FRONT_PORCH_COUNT_REG  0xb030
-#define HORIZ_ACTIVE_AREA_COUNT_REG  0xb034
-#define VERT_SYNC_PAD_COUNT_REG      0xb038
-#define VERT_BACK_PORCH_COUNT_REG    0xb03c
-#define VERT_FRONT_PORCH_COUNT_REG   0xb040
-#define HIGH_LOW_SWITCH_COUNT_REG    0xb044
-#define DPI_CONTROL_REG              0xb048
-#define DPI_SHUT_DOWN            (1 << 0)
-#define DPI_TURN_ON              (1 << 1)
-#define DPI_COLOR_MODE_ON        (1 << 2)
-#define DPI_COLOR_MODE_OFF       (1 << 3)
-#define DPI_BACK_LIGHT_ON        (1 << 4)
-#define DPI_BACK_LIGHT_OFF       (1 << 5)
-#define DPI_LP                   (1 << 6)
-#define DPI_DATA_REG                 0xb04c
-#define DPI_BACK_LIGHT_ON_DATA   0x07
-#define DPI_BACK_LIGHT_OFF_DATA  0x17
-#define INIT_COUNT_REG               0xb050
-#define MAX_RET_PAK_REG              0xb054
-#define VIDEO_FMT_REG                0xb058
-#define COMPLETE_LAST_PCKT       (1 << 2)
-#define EOT_DISABLE_REG              0xb05c
-#define ENABLE_CLOCK_STOPPING    (1 << 1)
-#define LP_BYTECLK_REG               0xb060
-#define LP_GEN_DATA_REG              0xb064
-#define HS_GEN_DATA_REG              0xb068
-#define LP_GEN_CTRL_REG              0xb06C
-#define HS_GEN_CTRL_REG              0xb070
-#define DCS_CHANNEL_NUMBER_POS   0x06
-#define MCS_COMMANDS_POS	0x8
-#define WORD_COUNTS_POS		0x8
-#define MCS_PARAMETER_POS	0x10
-#define GEN_FIFO_STAT_REG            0xb074
-#define HS_DATA_FIFO_FULL        (1 << 0)
-#define HS_DATA_FIFO_HALF_EMPTY  (1 << 1)
-#define HS_DATA_FIFO_EMPTY       (1 << 2)
-#define LP_DATA_FIFO_FULL        (1 << 8)
-#define LP_DATA_FIFO_HALF_EMPTY  (1 << 9)
-#define LP_DATA_FIFO_EMPTY       (1 << 10)
-#define HS_CTRL_FIFO_FULL        (1 << 16)
-#define HS_CTRL_FIFO_HALF_EMPTY  (1 << 17)
-#define HS_CTRL_FIFO_EMPTY       (1 << 18)
-#define LP_CTRL_FIFO_FULL        (1 << 24)
-#define LP_CTRL_FIFO_HALF_EMPTY  (1 << 25)
-#define LP_CTRL_FIFO_EMPTY       (1 << 26)
-#define DBI_FIFO_EMPTY           (1 << 27)
-#define DPI_FIFO_EMPTY           (1 << 28)
-#define HS_LS_DBI_ENABLE_REG         0xb078
-#define TXCLKESC_REG		     0xb07c
-#define DPHY_PARAM_REG               0xb080
-#define DBI_BW_CTRL_REG              0xb084
-#define CLK_LANE_SWT_REG             0xb088
+#define DBI_DATA_WIDTH_OPT1			0x04	/* option 1 */
+#define DBI_DATA_WIDTH_OPT2			0x05	/* option 2 */
+
+#define HS_TX_TIMEOUT_REG		0xb010
+#define LP_RX_TIMEOUT_REG		0xb014
+#define TURN_AROUND_TIMEOUT_REG		0xb018
+#define DEVICE_RESET_REG		0xb01C
+#define DPI_RESOLUTION_REG		0xb020
+#define RES_V_POS				0x10
+#define DBI_RESOLUTION_REG		0xb024 /* Reserved for MDFLD */
+#define HORIZ_SYNC_PAD_COUNT_REG	0xb028
+#define HORIZ_BACK_PORCH_COUNT_REG	0xb02C
+#define HORIZ_FRONT_PORCH_COUNT_REG	0xb030
+#define HORIZ_ACTIVE_AREA_COUNT_REG	0xb034
+#define VERT_SYNC_PAD_COUNT_REG		0xb038
+#define VERT_BACK_PORCH_COUNT_REG	0xb03c
+#define VERT_FRONT_PORCH_COUNT_REG	0xb040
+#define HIGH_LOW_SWITCH_COUNT_REG	0xb044
+#define DPI_CONTROL_REG			0xb048
+#define DPI_SHUT_DOWN				(1 << 0)
+#define DPI_TURN_ON				(1 << 1)
+#define DPI_COLOR_MODE_ON			(1 << 2)
+#define DPI_COLOR_MODE_OFF			(1 << 3)
+#define DPI_BACK_LIGHT_ON			(1 << 4)
+#define DPI_BACK_LIGHT_OFF			(1 << 5)
+#define DPI_LP					(1 << 6)
+#define DPI_DATA_REG			0xb04c
+#define DPI_BACK_LIGHT_ON_DATA			0x07
+#define DPI_BACK_LIGHT_OFF_DATA			0x17
+#define INIT_COUNT_REG			0xb050
+#define MAX_RET_PAK_REG			0xb054
+#define VIDEO_FMT_REG			0xb058
+#define COMPLETE_LAST_PCKT			(1 << 2)
+#define EOT_DISABLE_REG			0xb05c
+#define ENABLE_CLOCK_STOPPING			(1 << 1)
+#define LP_BYTECLK_REG			0xb060
+#define LP_GEN_DATA_REG			0xb064
+#define HS_GEN_DATA_REG			0xb068
+#define LP_GEN_CTRL_REG			0xb06C
+#define HS_GEN_CTRL_REG			0xb070
+#define DCS_CHANNEL_NUMBER_POS		0x6
+#define MCS_COMMANDS_POS		0x8
+#define WORD_COUNTS_POS			0x8
+#define MCS_PARAMETER_POS			0x10
+#define GEN_FIFO_STAT_REG		0xb074
+#define HS_DATA_FIFO_FULL			(1 << 0)
+#define HS_DATA_FIFO_HALF_EMPTY			(1 << 1)
+#define HS_DATA_FIFO_EMPTY			(1 << 2)
+#define LP_DATA_FIFO_FULL			(1 << 8)
+#define LP_DATA_FIFO_HALF_EMPTY			(1 << 9)
+#define LP_DATA_FIFO_EMPTY			(1 << 10)
+#define HS_CTRL_FIFO_FULL			(1 << 16)
+#define HS_CTRL_FIFO_HALF_EMPTY			(1 << 17)
+#define HS_CTRL_FIFO_EMPTY			(1 << 18)
+#define LP_CTRL_FIFO_FULL			(1 << 24)
+#define LP_CTRL_FIFO_HALF_EMPTY			(1 << 25)
+#define LP_CTRL_FIFO_EMPTY			(1 << 26)
+#define DBI_FIFO_EMPTY				(1 << 27)
+#define DPI_FIFO_EMPTY				(1 << 28)
+#define HS_LS_DBI_ENABLE_REG		0xb078
+#define TXCLKESC_REG			0xb07c
+#define DPHY_PARAM_REG			0xb080
+#define DBI_BW_CTRL_REG			0xb084
+#define CLK_LANE_SWT_REG		0xb088
 
 /*
  * MIPI Adapter registers
  */
-#define MIPI_CONTROL_REG             0xb104
-#define MIPI_2X_CLOCK_BITS       ((1 << 0) | (1 << 1))
-#define MIPI_DATA_ADDRESS_REG        0xb108
-#define MIPI_DATA_LENGTH_REG         0xb10C
-#define MIPI_COMMAND_ADDRESS_REG     0xb110
-#define MIPI_COMMAND_LENGTH_REG      0xb114
-#define MIPI_READ_DATA_RETURN_REG0   0xb118
-#define MIPI_READ_DATA_RETURN_REG1   0xb11C
-#define MIPI_READ_DATA_RETURN_REG2   0xb120
-#define MIPI_READ_DATA_RETURN_REG3   0xb124
-#define MIPI_READ_DATA_RETURN_REG4   0xb128
-#define MIPI_READ_DATA_RETURN_REG5   0xb12C
-#define MIPI_READ_DATA_RETURN_REG6   0xb130
-#define MIPI_READ_DATA_RETURN_REG7   0xb134
-#define MIPI_READ_DATA_VALID_REG     0xb138
+#define MIPI_CONTROL_REG		0xb104
+#define MIPI_2X_CLOCK_BITS			((1 << 0) | (1 << 1))
+#define MIPI_DATA_ADDRESS_REG		0xb108
+#define MIPI_DATA_LENGTH_REG		0xb10C
+#define MIPI_COMMAND_ADDRESS_REG	0xb110
+#define MIPI_COMMAND_LENGTH_REG		0xb114
+#define MIPI_READ_DATA_RETURN_REG0	0xb118
+#define MIPI_READ_DATA_RETURN_REG1	0xb11C
+#define MIPI_READ_DATA_RETURN_REG2	0xb120
+#define MIPI_READ_DATA_RETURN_REG3	0xb124
+#define MIPI_READ_DATA_RETURN_REG4	0xb128
+#define MIPI_READ_DATA_RETURN_REG5	0xb12C
+#define MIPI_READ_DATA_RETURN_REG6	0xb130
+#define MIPI_READ_DATA_RETURN_REG7	0xb134
+#define MIPI_READ_DATA_VALID_REG	0xb138
+
 /* DBI COMMANDS */
-#define soft_reset                   0x01
+#define soft_reset			0x01
 /*
  *	The display module performs a software reset.
  *	Registers are written with their SW Reset default values.
  */
-#define get_power_mode               0x0a
+#define get_power_mode			0x0a
 /*
  *	The display module returns the current power mode
  */
-#define get_address_mode             0x0b
+#define get_address_mode		0x0b
 /*
  *	The display module returns the current status.
  */
-#define get_pixel_format             0x0c
+#define get_pixel_format		0x0c
 /*
  *	This command gets the pixel format for the RGB image data
  *	used by the interface.
  */
-#define get_display_mode             0x0d
+#define get_display_mode		0x0d
 /*
  *	The display module returns the Display Image Mode status.
  */
-#define get_signal_mode              0x0e
+#define get_signal_mode			0x0e
 /*
  *	The display module returns the Display Signal Mode.
  */
-#define get_diagnostic_result        0x0f
+#define get_diagnostic_result		0x0f
 /*
  *	The display module returns the self-diagnostic results following
  *	a Sleep Out command.
  */
-#define enter_sleep_mode             0x10
+#define enter_sleep_mode		0x10
 /*
  *	This command causes the display module to enter the Sleep mode.
  *	In this mode, all unnecessary blocks inside the display module are
  *	disabled except interface communication. This is the lowest power
  *	mode the display module supports.
  */
-#define exit_sleep_mode              0x11
+#define exit_sleep_mode			0x11
 /*
  *	This command causes the display module to exit Sleep mode.
  *	All blocks inside the display module are enabled.
  */
-#define enter_partial_mode           0x12
+#define enter_partial_mode		0x12
 /*
  *	This command causes the display module to enter the Partial Display
  *	Mode. The Partial Display Mode window is described by the
  *	set_partial_area command.
  */
-#define enter_normal_mode            0x13
+#define enter_normal_mode		0x13
 /*
  *	This command causes the display module to enter the Normal mode.
  *	Normal Mode is defined as Partial Display mode and Scroll mode are off
  */
-#define exit_invert_mode             0x20
+#define exit_invert_mode		0x20
 /*
  *	This command causes the display module to stop inverting the image
  *	data on the display device. The frame memory contents remain unchanged.
  *	No status bits are changed.
  */
-#define enter_invert_mode            0x21
+#define enter_invert_mode		0x21
 /*
  *	This command causes the display module to invert the image data only on
  *	the display device. The frame memory contents remain unchanged.
  *	No status bits are changed.
  */
-#define set_gamma_curve              0x26
+#define set_gamma_curve			0x26
 /*
  *	This command selects the desired gamma curve for the display device.
  *	Four fixed gamma curves are defined in section DCS spec.
  */
-#define set_display_off              0x28
+#define set_display_off			0x28
 /* ************************************************************************* *\
 This command causes the display module to stop displaying the image data
 on the display device. The frame memory contents remain unchanged.
 No status bits are changed.
 \* ************************************************************************* */
-#define set_display_on               0x29
+#define set_display_on			0x29
 /* ************************************************************************* *\
 This command causes the display module to start displaying the image data
 on the display device. The frame memory contents remain unchanged.
 No status bits are changed.
 \* ************************************************************************* */
-#define set_column_address           0x2a
+#define set_column_address		0x2a
 /*
  *	This command defines the column extent of the frame memory accessed by
  *	the hostprocessor with the read_memory_continue and
  *	write_memory_continue commands.
  *	No status bits are changed.
  */
-#define set_page_addr             0x2b
+#define set_page_addr			0x2b
 /*
  *	This command defines the page extent of the frame memory accessed by
  *	the host processor with the write_memory_continue and
- *	read_memory_continue command. 
+ *	read_memory_continue command.
  *	No status bits are changed.
  */
-#define write_mem_start              0x2c
+#define write_mem_start			0x2c
 /*
  *	This command transfers image data from the host processor to the
- *	display module s frame memory starting at the pixel location specified
+ *	display modules frame memory starting at the pixel location specified
  *	by preceding set_column_address and set_page_address commands.
  */
-#define set_partial_area             0x30
+#define set_partial_area		0x30
 /*
  *	This command defines the Partial Display mode s display area.
  *	There are two parameters associated with this command, the first
  *	defines the Start Row (SR) and the second the End Row (ER). SR and ER
  *	refer to the Frame Memory Line Pointer.
  */
-#define set_scroll_area              0x33
+#define set_scroll_area			0x33
 /*
  *	This command defines the display modules Vertical Scrolling Area.
  */
-#define set_tear_off                 0x34
+#define set_tear_off			0x34
 /*
  *	This command turns off the display modules Tearing Effect output
  *	signal on the TE signal line.
  */
-#define set_tear_on                  0x35
+#define set_tear_on			0x35
 /*
  *	This command turns on the display modules Tearing Effect output signal
  *	on the TE signal line.
  */
-#define set_address_mode             0x36
+#define set_address_mode		0x36
 /*
  *	This command sets the data order for transfers from the host processor
  *	to display modules frame memory,bits B[7:5] and B3, and from the
  *	display modules frame memory to the display device, bits B[2:0] and B4.
  */
-#define set_scroll_start             0x37
+#define set_scroll_start		0x37
 /*
  *	This command sets the start of the vertical scrolling area in the frame
  *	memory. The vertical scrolling area is fully defined when this command
@@ -1007,18 +1011,18 @@ No status bits are changed.
  *	line in the frame memory that is written to the display device as the
  *	first line of the vertical scroll area.
  */
-#define exit_idle_mode               0x38
+#define exit_idle_mode			0x38
 /*
  *	This command causes the display module to exit Idle mode.
  */
-#define enter_idle_mode              0x39
+#define enter_idle_mode			0x39
 /*
  *	This command causes the display module to enter Idle Mode.
  *	In Idle Mode, color expression is reduced. Colors are shown on the
  *	display device using the MSB of each of the R, G and B color
  *	components in the frame memory
  */
-#define set_pixel_format             0x3a
+#define set_pixel_format		0x3a
 /*
  *	This command sets the pixel format for the RGB image data used by the
  *	interface.
@@ -1026,25 +1030,27 @@ No status bits are changed.
  *	Bits D[2:0]  DBI Pixel Format Definition
  *	Bits D7 and D3 are not used.
  */
-  #define DCS_PIXEL_FORMAT_3bbp	 	0x1
-  #define DCS_PIXEL_FORMAT_8bbp 	0x2
-  #define DCS_PIXEL_FORMAT_12bbp 	0x3
-  #define DCS_PIXEL_FORMAT_16bbp	0x5
-  #define DCS_PIXEL_FORMAT_18bbp	0x6
-  #define DCS_PIXEL_FORMAT_24bbp 	0x7
-#define write_mem_cont               0x3c
+#define DCS_PIXEL_FORMAT_3bpp		0x1
+#define DCS_PIXEL_FORMAT_8bpp		0x2
+#define DCS_PIXEL_FORMAT_12bpp		0x3
+#define DCS_PIXEL_FORMAT_16bpp		0x5
+#define DCS_PIXEL_FORMAT_18bpp		0x6
+#define DCS_PIXEL_FORMAT_24bpp		0x7
+
+#define write_mem_cont			0x3c
+
 /*
  *	This command transfers image data from the host processor to the
  *	display module's frame memory continuing from the pixel location
  *	following the previous write_memory_continue or write_memory_start
  *	command.
  */
-#define set_tear_scanline            0x44
+#define set_tear_scanline		0x44
 /*
  *	This command turns on the display modules Tearing Effect output signal
  *	on the TE signal line when the display module reaches line N.
  */
-#define get_scanline                 0x45
+#define get_scanline			0x45
 /*
  *	The display module returns the current scanline, N, used to update the
  *	 display device. The total number of scanlines on a display device is
@@ -1094,22 +1100,22 @@ No status bits are changed.
 #define GAMMA_AUTO		(1 << 0)
 
 /* DCS Interface Pixel Formats */
-#define DCS_PIXEL_FORMAT_3BPP         0x1
-#define DCS_PIXEL_FORMAT_8BPP         0x2
-#define DCS_PIXEL_FORMAT_12BPP        0x3
-#define DCS_PIXEL_FORMAT_16BPP        0x5
-#define DCS_PIXEL_FORMAT_18BPP        0x6
-#define DCS_PIXEL_FORMAT_24BPP        0x7
+#define DCS_PIXEL_FORMAT_3BPP	0x1
+#define DCS_PIXEL_FORMAT_8BPP	0x2
+#define DCS_PIXEL_FORMAT_12BPP	0x3
+#define DCS_PIXEL_FORMAT_16BPP	0x5
+#define DCS_PIXEL_FORMAT_18BPP	0x6
+#define DCS_PIXEL_FORMAT_24BPP	0x7
 /* ONE PARAMETER READ DATA */
-#define addr_mode_data           0xfc
-#define diag_res_data            0x00
-#define disp_mode_data           0x23
-#define pxl_fmt_data             0x77
-#define pwr_mode_data            0x74
-#define sig_mode_data            0x00
+#define addr_mode_data		0xfc
+#define diag_res_data		0x00
+#define disp_mode_data		0x23
+#define pxl_fmt_data		0x77
+#define pwr_mode_data		0x74
+#define sig_mode_data		0x00
 /* TWO PARAMETERS READ DATA */
-#define scanline_data1           0xff
-#define scanline_data2           0xff
+#define scanline_data1		0xff
+#define scanline_data2		0xff
 #define NON_BURST_MODE_SYNC_PULSE	0x01	/* Non Burst Mode
 						 * with Sync Pulse
 						 */
@@ -1117,7 +1123,8 @@ No status bits are changed.
 						 * with Sync events
 						 */
 #define BURST_MODE			0x03	/* Burst Mode */
-#define DBI_COMMAND_BUFFER_SIZE		0x240  /* 0x32 */    /* 0x120 */	/* Allocate at least
+#define DBI_COMMAND_BUFFER_SIZE		0x240   /* 0x32 */    /* 0x120 */
+						/* Allocate at least
 						 * 0x100 Byte with 32
 						 * byte alignment
 						 */
@@ -1125,13 +1132,13 @@ No status bits are changed.
 						 * 0x100 Byte with 32
 						 * byte alignment
 						 */
-#define DBI_CB_TIME_OUT 0xFFFF
-
-#define GEN_FB_TIME_OUT 2000 
-#define ALIGNMENT_32BYTE_MASK		(~((1 << 0)|(1 << 1)|(1 << 2)|(1 << 3)|(1 << 4)))
-#define SKU_83 						0x01
-#define SKU_100 					0x02
-#define SKU_100L 					0x04
-#define SKU_BYPASS 					0x08
+#define DBI_CB_TIME_OUT			0xFFFF
+
+#define GEN_FB_TIME_OUT			2000
+
+#define SKU_83				0x01
+#define SKU_100				0x02
+#define SKU_100L			0x04
+#define SKU_BYPASS			0x08
 
 #endif
diff --git a/drivers/staging/gma500/psb_intel_sdvo.c b/drivers/staging/gma500/psb_intel_sdvo.c
index e313ce2..a4bad1a 100644
--- a/drivers/staging/gma500/psb_intel_sdvo.c
+++ b/drivers/staging/gma500/psb_intel_sdvo.c
@@ -211,7 +211,8 @@ static void psb_intel_sdvo_write_cmd(struct psb_intel_output *psb_intel_output,
 		     sizeof(sdvo_cmd_names) / sizeof(sdvo_cmd_names[0]);
 		     i++) {
 			if (cmd == sdvo_cmd_names[i].cmd) {
-				printk(KERN_CONT "(%s)", sdvo_cmd_names[i].name);
+				printk(KERN_CONT
+					"(%s)", sdvo_cmd_names[i].name);
 				break;
 			}
 		}
diff --git a/drivers/staging/gma500/psb_intel_sdvo_regs.h b/drivers/staging/gma500/psb_intel_sdvo_regs.h
index c7107a3..96862ea 100644
--- a/drivers/staging/gma500/psb_intel_sdvo_regs.h
+++ b/drivers/staging/gma500/psb_intel_sdvo_regs.h
@@ -51,7 +51,7 @@ struct psb_intel_sdvo_caps {
 	unsigned int stall_support:1;
 	unsigned int pad:1;
 	u16 output_flags;
-} __attribute__ ((packed));
+} __packed;
 
 /** This matches the EDID DTD structure, more or less */
 struct psb_intel_sdvo_dtd {
@@ -82,18 +82,18 @@ struct psb_intel_sdvo_dtd {
 		u8 v_sync_off_high;
 		u8 reserved;
 	} part2;
-} __attribute__ ((packed));
+} __packed;
 
 struct psb_intel_sdvo_pixel_clock_range {
 	u16 min;		/**< pixel clock, in 10kHz units */
 	u16 max;		/**< pixel clock, in 10kHz units */
-} __attribute__ ((packed));
+} __packed;
 
 struct psb_intel_sdvo_preferred_input_timing_args {
 	u16 clock;
 	u16 width;
 	u16 height;
-} __attribute__ ((packed));
+} __packed;
 
 /* I2C registers for SDVO */
 #define SDVO_I2C_ARG_0				0x07
@@ -147,7 +147,7 @@ struct psb_intel_sdvo_get_trained_inputs_response {
 	unsigned int input0_trained:1;
 	unsigned int input1_trained:1;
 	unsigned int pad:6;
-} __attribute__ ((packed));
+} __packed;
 
 /** Returns a struct psb_intel_sdvo_output_flags of active outputs. */
 #define SDVO_CMD_GET_ACTIVE_OUTPUTS			0x04
@@ -201,7 +201,7 @@ struct psb_intel_sdvo_get_interrupt_event_source_response {
 	u16 interrupt_status;
 	unsigned int ambient_light_interrupt:1;
 	unsigned int pad:7;
-} __attribute__ ((packed));
+} __packed;
 
 /**
  * Selects which input is affected by future input commands.
@@ -214,7 +214,7 @@ struct psb_intel_sdvo_get_interrupt_event_source_response {
 struct psb_intel_sdvo_set_target_input_args {
 	unsigned int target_1:1;
 	unsigned int pad:7;
-} __attribute__ ((packed));
+} __packed;
 
 /**
  * Takes a struct psb_intel_sdvo_output_flags of which outputs are targeted by
diff --git a/drivers/staging/gma500/psb_reg.h b/drivers/staging/gma500/psb_reg.h
index 529fda8..b81c7c1 100644
--- a/drivers/staging/gma500/psb_reg.h
+++ b/drivers/staging/gma500/psb_reg.h
@@ -22,161 +22,157 @@
 #ifndef _PSB_REG_H_
 #define _PSB_REG_H_
 
-#define PSB_CR_CLKGATECTL                0x0000
-#define _PSB_C_CLKGATECTL_AUTO_MAN_REG   (1 << 24)
-#define _PSB_C_CLKGATECTL_USE_CLKG_SHIFT (20)
-#define _PSB_C_CLKGATECTL_USE_CLKG_MASK  (0x3 << 20)
-#define _PSB_C_CLKGATECTL_DPM_CLKG_SHIFT (16)
-#define _PSB_C_CLKGATECTL_DPM_CLKG_MASK  (0x3 << 16)
-#define _PSB_C_CLKGATECTL_TA_CLKG_SHIFT  (12)
-#define _PSB_C_CLKGATECTL_TA_CLKG_MASK   (0x3 << 12)
-#define _PSB_C_CLKGATECTL_TSP_CLKG_SHIFT (8)
-#define _PSB_C_CLKGATECTL_TSP_CLKG_MASK  (0x3 << 8)
-#define _PSB_C_CLKGATECTL_ISP_CLKG_SHIFT (4)
-#define _PSB_C_CLKGATECTL_ISP_CLKG_MASK  (0x3 << 4)
-#define _PSB_C_CLKGATECTL_2D_CLKG_SHIFT  (0)
-#define _PSB_C_CLKGATECTL_2D_CLKG_MASK   (0x3 << 0)
-#define _PSB_C_CLKGATECTL_CLKG_ENABLED   (0)
-#define _PSB_C_CLKGATECTL_CLKG_DISABLED  (1)
-#define _PSB_C_CLKGATECTL_CLKG_AUTO      (2)
-
-#define PSB_CR_CORE_ID                   0x0010
-#define _PSB_CC_ID_ID_SHIFT              (16)
-#define _PSB_CC_ID_ID_MASK               (0xFFFF << 16)
-#define _PSB_CC_ID_CONFIG_SHIFT          (0)
-#define _PSB_CC_ID_CONFIG_MASK           (0xFFFF << 0)
-
-#define PSB_CR_CORE_REVISION               0x0014
-#define _PSB_CC_REVISION_DESIGNER_SHIFT    (24)
-#define _PSB_CC_REVISION_DESIGNER_MASK     (0xFF << 24)
-#define _PSB_CC_REVISION_MAJOR_SHIFT       (16)
-#define _PSB_CC_REVISION_MAJOR_MASK        (0xFF << 16)
-#define _PSB_CC_REVISION_MINOR_SHIFT       (8)
-#define _PSB_CC_REVISION_MINOR_MASK        (0xFF << 8)
-#define _PSB_CC_REVISION_MAINTENANCE_SHIFT (0)
-#define _PSB_CC_REVISION_MAINTENANCE_MASK  (0xFF << 0)
-
-#define PSB_CR_DESIGNER_REV_FIELD1       0x0018
-
-#define PSB_CR_SOFT_RESET                0x0080
-#define _PSB_CS_RESET_TSP_RESET          (1 << 6)
-#define _PSB_CS_RESET_ISP_RESET          (1 << 5)
-#define _PSB_CS_RESET_USE_RESET          (1 << 4)
-#define _PSB_CS_RESET_TA_RESET           (1 << 3)
-#define _PSB_CS_RESET_DPM_RESET          (1 << 2)
-#define _PSB_CS_RESET_TWOD_RESET         (1 << 1)
-#define _PSB_CS_RESET_BIF_RESET          (1 << 0)
-
-#define PSB_CR_DESIGNER_REV_FIELD2       0x001C
-
-#define PSB_CR_EVENT_HOST_ENABLE2        0x0110
-
-#define PSB_CR_EVENT_STATUS2             0x0118
-
-#define PSB_CR_EVENT_HOST_CLEAR2         0x0114
-#define _PSB_CE2_BIF_REQUESTER_FAULT     (1 << 4)
-
-#define PSB_CR_EVENT_STATUS              0x012C
-
-#define PSB_CR_EVENT_HOST_ENABLE         0x0130
-
-#define PSB_CR_EVENT_HOST_CLEAR          0x0134
-#define _PSB_CE_MASTER_INTERRUPT         (1 << 31)
-#define _PSB_CE_TA_DPM_FAULT             (1 << 28)
-#define _PSB_CE_TWOD_COMPLETE            (1 << 27)
-#define _PSB_CE_DPM_OUT_OF_MEMORY_ZLS    (1 << 25)
-#define _PSB_CE_DPM_TA_MEM_FREE          (1 << 24)
-#define _PSB_CE_PIXELBE_END_RENDER       (1 << 18)
-#define _PSB_CE_SW_EVENT                 (1 << 14)
-#define _PSB_CE_TA_FINISHED              (1 << 13)
-#define _PSB_CE_TA_TERMINATE             (1 << 12)
-#define _PSB_CE_DPM_REACHED_MEM_THRESH   (1 << 3)
-#define _PSB_CE_DPM_OUT_OF_MEMORY_GBL    (1 << 2)
-#define _PSB_CE_DPM_OUT_OF_MEMORY_MT     (1 << 1)
-#define _PSB_CE_DPM_3D_MEM_FREE          (1 << 0)
-
-
-#define PSB_USE_OFFSET_MASK              0x0007FFFF
-#define PSB_USE_OFFSET_SIZE              (PSB_USE_OFFSET_MASK + 1)
-#define PSB_CR_USE_CODE_BASE0            0x0A0C
-#define PSB_CR_USE_CODE_BASE1            0x0A10
-#define PSB_CR_USE_CODE_BASE2            0x0A14
-#define PSB_CR_USE_CODE_BASE3            0x0A18
-#define PSB_CR_USE_CODE_BASE4            0x0A1C
-#define PSB_CR_USE_CODE_BASE5            0x0A20
-#define PSB_CR_USE_CODE_BASE6            0x0A24
-#define PSB_CR_USE_CODE_BASE7            0x0A28
-#define PSB_CR_USE_CODE_BASE8            0x0A2C
-#define PSB_CR_USE_CODE_BASE9            0x0A30
-#define PSB_CR_USE_CODE_BASE10           0x0A34
-#define PSB_CR_USE_CODE_BASE11           0x0A38
-#define PSB_CR_USE_CODE_BASE12           0x0A3C
-#define PSB_CR_USE_CODE_BASE13           0x0A40
-#define PSB_CR_USE_CODE_BASE14           0x0A44
-#define PSB_CR_USE_CODE_BASE15           0x0A48
-#define PSB_CR_USE_CODE_BASE(_i) (0x0A0C + ((_i) << 2))
-#define _PSB_CUC_BASE_DM_SHIFT           (25)
-#define _PSB_CUC_BASE_DM_MASK            (0x3 << 25)
-#define _PSB_CUC_BASE_ADDR_SHIFT         (0)	/* 1024-bit aligned address? */
-#define _PSB_CUC_BASE_ADDR_ALIGNSHIFT    (7)
-#define _PSB_CUC_BASE_ADDR_MASK          (0x1FFFFFF << 0)
-#define _PSB_CUC_DM_VERTEX		 (0)
-#define _PSB_CUC_DM_PIXEL		 (1)
-#define _PSB_CUC_DM_RESERVED		 (2)
-#define _PSB_CUC_DM_EDM	                 (3)
-
-#define PSB_CR_PDS_EXEC_BASE             0x0AB8
-#define _PSB_CR_PDS_EXEC_BASE_ADDR_SHIFT (20)	/* 1MB aligned address */
-#define _PSB_CR_PDS_EXEC_BASE_ADDR_ALIGNSHIFT (20)
-
-#define PSB_CR_EVENT_KICKER              0x0AC4
-#define _PSB_CE_KICKER_ADDRESS_SHIFT     (4)	/* 128-bit aligned address */
-
-#define PSB_CR_EVENT_KICK                0x0AC8
-#define _PSB_CE_KICK_NOW                 (1 << 0)
-
-
-#define PSB_CR_BIF_DIR_LIST_BASE1        0x0C38
-
-#define PSB_CR_BIF_CTRL                  0x0C00
-#define _PSB_CB_CTRL_CLEAR_FAULT         (1 << 4)
-#define _PSB_CB_CTRL_INVALDC             (1 << 3)
-#define _PSB_CB_CTRL_FLUSH               (1 << 2)
-
-#define PSB_CR_BIF_INT_STAT              0x0C04
-
-#define PSB_CR_BIF_FAULT                 0x0C08
-#define _PSB_CBI_STAT_PF_N_RW            (1 << 14)
-#define _PSB_CBI_STAT_FAULT_SHIFT        (0)
-#define _PSB_CBI_STAT_FAULT_MASK         (0x3FFF << 0)
-#define _PSB_CBI_STAT_FAULT_CACHE        (1 << 1)
-#define _PSB_CBI_STAT_FAULT_TA           (1 << 2)
-#define _PSB_CBI_STAT_FAULT_VDM          (1 << 3)
-#define _PSB_CBI_STAT_FAULT_2D           (1 << 4)
-#define _PSB_CBI_STAT_FAULT_PBE          (1 << 5)
-#define _PSB_CBI_STAT_FAULT_TSP          (1 << 6)
-#define _PSB_CBI_STAT_FAULT_ISP          (1 << 7)
-#define _PSB_CBI_STAT_FAULT_USSEPDS      (1 << 8)
-#define _PSB_CBI_STAT_FAULT_HOST         (1 << 9)
-
-#define PSB_CR_BIF_BANK0                 0x0C78
-
-#define PSB_CR_BIF_BANK1                 0x0C7C
-
-#define PSB_CR_BIF_DIR_LIST_BASE0        0x0C84
-
-#define PSB_CR_BIF_TWOD_REQ_BASE         0x0C88
-#define PSB_CR_BIF_3D_REQ_BASE           0x0CAC
-
-#define PSB_CR_2D_SOCIF                  0x0E18
-#define _PSB_C2_SOCIF_FREESPACE_SHIFT    (0)
-#define _PSB_C2_SOCIF_FREESPACE_MASK     (0xFF << 0)
-#define _PSB_C2_SOCIF_EMPTY              (0x80 << 0)
-
-#define PSB_CR_2D_BLIT_STATUS            0x0E04
-#define _PSB_C2B_STATUS_BUSY             (1 << 24)
-#define _PSB_C2B_STATUS_COMPLETE_SHIFT   (0)
-#define _PSB_C2B_STATUS_COMPLETE_MASK    (0xFFFFFF << 0)
+#define PSB_CR_CLKGATECTL		0x0000
+#define _PSB_C_CLKGATECTL_AUTO_MAN_REG		(1 << 24)
+#define _PSB_C_CLKGATECTL_USE_CLKG_SHIFT	(20)
+#define _PSB_C_CLKGATECTL_USE_CLKG_MASK		(0x3 << 20)
+#define _PSB_C_CLKGATECTL_DPM_CLKG_SHIFT	(16)
+#define _PSB_C_CLKGATECTL_DPM_CLKG_MASK		(0x3 << 16)
+#define _PSB_C_CLKGATECTL_TA_CLKG_SHIFT		(12)
+#define _PSB_C_CLKGATECTL_TA_CLKG_MASK		(0x3 << 12)
+#define _PSB_C_CLKGATECTL_TSP_CLKG_SHIFT	(8)
+#define _PSB_C_CLKGATECTL_TSP_CLKG_MASK		(0x3 << 8)
+#define _PSB_C_CLKGATECTL_ISP_CLKG_SHIFT	(4)
+#define _PSB_C_CLKGATECTL_ISP_CLKG_MASK		(0x3 << 4)
+#define _PSB_C_CLKGATECTL_2D_CLKG_SHIFT		(0)
+#define _PSB_C_CLKGATECTL_2D_CLKG_MASK		(0x3 << 0)
+#define _PSB_C_CLKGATECTL_CLKG_ENABLED		(0)
+#define _PSB_C_CLKGATECTL_CLKG_DISABLED		(1)
+#define _PSB_C_CLKGATECTL_CLKG_AUTO		(2)
+
+#define PSB_CR_CORE_ID			0x0010
+#define _PSB_CC_ID_ID_SHIFT			(16)
+#define _PSB_CC_ID_ID_MASK			(0xFFFF << 16)
+#define _PSB_CC_ID_CONFIG_SHIFT			(0)
+#define _PSB_CC_ID_CONFIG_MASK			(0xFFFF << 0)
+
+#define PSB_CR_CORE_REVISION		0x0014
+#define _PSB_CC_REVISION_DESIGNER_SHIFT		(24)
+#define _PSB_CC_REVISION_DESIGNER_MASK		(0xFF << 24)
+#define _PSB_CC_REVISION_MAJOR_SHIFT		(16)
+#define _PSB_CC_REVISION_MAJOR_MASK		(0xFF << 16)
+#define _PSB_CC_REVISION_MINOR_SHIFT		(8)
+#define _PSB_CC_REVISION_MINOR_MASK		(0xFF << 8)
+#define _PSB_CC_REVISION_MAINTENANCE_SHIFT	(0)
+#define _PSB_CC_REVISION_MAINTENANCE_MASK	(0xFF << 0)
+
+#define PSB_CR_DESIGNER_REV_FIELD1	0x0018
+
+#define PSB_CR_SOFT_RESET		0x0080
+#define _PSB_CS_RESET_TSP_RESET		(1 << 6)
+#define _PSB_CS_RESET_ISP_RESET		(1 << 5)
+#define _PSB_CS_RESET_USE_RESET		(1 << 4)
+#define _PSB_CS_RESET_TA_RESET		(1 << 3)
+#define _PSB_CS_RESET_DPM_RESET		(1 << 2)
+#define _PSB_CS_RESET_TWOD_RESET	(1 << 1)
+#define _PSB_CS_RESET_BIF_RESET			(1 << 0)
+
+#define PSB_CR_DESIGNER_REV_FIELD2	0x001C
+
+#define PSB_CR_EVENT_HOST_ENABLE2	0x0110
+
+#define PSB_CR_EVENT_STATUS2		0x0118
+
+#define PSB_CR_EVENT_HOST_CLEAR2	0x0114
+#define _PSB_CE2_BIF_REQUESTER_FAULT		(1 << 4)
+
+#define PSB_CR_EVENT_STATUS		0x012C
+
+#define PSB_CR_EVENT_HOST_ENABLE	0x0130
+
+#define PSB_CR_EVENT_HOST_CLEAR		0x0134
+#define _PSB_CE_MASTER_INTERRUPT		(1 << 31)
+#define _PSB_CE_TA_DPM_FAULT			(1 << 28)
+#define _PSB_CE_TWOD_COMPLETE			(1 << 27)
+#define _PSB_CE_DPM_OUT_OF_MEMORY_ZLS		(1 << 25)
+#define _PSB_CE_DPM_TA_MEM_FREE			(1 << 24)
+#define _PSB_CE_PIXELBE_END_RENDER		(1 << 18)
+#define _PSB_CE_SW_EVENT			(1 << 14)
+#define _PSB_CE_TA_FINISHED			(1 << 13)
+#define _PSB_CE_TA_TERMINATE			(1 << 12)
+#define _PSB_CE_DPM_REACHED_MEM_THRESH		(1 << 3)
+#define _PSB_CE_DPM_OUT_OF_MEMORY_GBL		(1 << 2)
+#define _PSB_CE_DPM_OUT_OF_MEMORY_MT		(1 << 1)
+#define _PSB_CE_DPM_3D_MEM_FREE			(1 << 0)
+
+
+#define PSB_USE_OFFSET_MASK		0x0007FFFF
+#define PSB_USE_OFFSET_SIZE		(PSB_USE_OFFSET_MASK + 1)
+#define PSB_CR_USE_CODE_BASE0		0x0A0C
+#define PSB_CR_USE_CODE_BASE1		0x0A10
+#define PSB_CR_USE_CODE_BASE2		0x0A14
+#define PSB_CR_USE_CODE_BASE3		0x0A18
+#define PSB_CR_USE_CODE_BASE4		0x0A1C
+#define PSB_CR_USE_CODE_BASE5		0x0A20
+#define PSB_CR_USE_CODE_BASE6		0x0A24
+#define PSB_CR_USE_CODE_BASE7		0x0A28
+#define PSB_CR_USE_CODE_BASE8		0x0A2C
+#define PSB_CR_USE_CODE_BASE9		0x0A30
+#define PSB_CR_USE_CODE_BASE10		0x0A34
+#define PSB_CR_USE_CODE_BASE11		0x0A38
+#define PSB_CR_USE_CODE_BASE12		0x0A3C
+#define PSB_CR_USE_CODE_BASE13		0x0A40
+#define PSB_CR_USE_CODE_BASE14		0x0A44
+#define PSB_CR_USE_CODE_BASE15		0x0A48
+#define PSB_CR_USE_CODE_BASE(_i)	(0x0A0C + ((_i) << 2))
+#define _PSB_CUC_BASE_DM_SHIFT			(25)
+#define _PSB_CUC_BASE_DM_MASK			(0x3 << 25)
+#define _PSB_CUC_BASE_ADDR_SHIFT		(0)	/* 1024-bit aligned address? */
+#define _PSB_CUC_BASE_ADDR_ALIGNSHIFT		(7)
+#define _PSB_CUC_BASE_ADDR_MASK			(0x1FFFFFF << 0)
+#define _PSB_CUC_DM_VERTEX			(0)
+#define _PSB_CUC_DM_PIXEL			(1)
+#define _PSB_CUC_DM_RESERVED			(2)
+#define _PSB_CUC_DM_EDM				(3)
+
+#define PSB_CR_PDS_EXEC_BASE		0x0AB8
+#define _PSB_CR_PDS_EXEC_BASE_ADDR_SHIFT	(20)	/* 1MB aligned address */
+#define _PSB_CR_PDS_EXEC_BASE_ADDR_ALIGNSHIFT	(20)
+
+#define PSB_CR_EVENT_KICKER		0x0AC4
+#define _PSB_CE_KICKER_ADDRESS_SHIFT		(4)	/* 128-bit aligned address */
+
+#define PSB_CR_EVENT_KICK		0x0AC8
+#define _PSB_CE_KICK_NOW			(1 << 0)
+
+#define PSB_CR_BIF_DIR_LIST_BASE1	0x0C38
+
+#define PSB_CR_BIF_CTRL			0x0C00
+#define _PSB_CB_CTRL_CLEAR_FAULT		(1 << 4)
+#define _PSB_CB_CTRL_INVALDC			(1 << 3)
+#define _PSB_CB_CTRL_FLUSH			(1 << 2)
+
+#define PSB_CR_BIF_INT_STAT		0x0C04
+
+#define PSB_CR_BIF_FAULT		0x0C08
+#define _PSB_CBI_STAT_PF_N_RW			(1 << 14)
+#define _PSB_CBI_STAT_FAULT_SHIFT		(0)
+#define _PSB_CBI_STAT_FAULT_MASK		(0x3FFF << 0)
+#define _PSB_CBI_STAT_FAULT_CACHE		(1 << 1)
+#define _PSB_CBI_STAT_FAULT_TA			(1 << 2)
+#define _PSB_CBI_STAT_FAULT_VDM			(1 << 3)
+#define _PSB_CBI_STAT_FAULT_2D			(1 << 4)
+#define _PSB_CBI_STAT_FAULT_PBE			(1 << 5)
+#define _PSB_CBI_STAT_FAULT_TSP			(1 << 6)
+#define _PSB_CBI_STAT_FAULT_ISP			(1 << 7)
+#define _PSB_CBI_STAT_FAULT_USSEPDS		(1 << 8)
+#define _PSB_CBI_STAT_FAULT_HOST		(1 << 9)
+
+#define PSB_CR_BIF_BANK0		0x0C78
+#define PSB_CR_BIF_BANK1		0x0C7C
+#define PSB_CR_BIF_DIR_LIST_BASE0	0x0C84
+#define PSB_CR_BIF_TWOD_REQ_BASE	0x0C88
+#define PSB_CR_BIF_3D_REQ_BASE		0x0CAC
+
+#define PSB_CR_2D_SOCIF			0x0E18
+#define _PSB_C2_SOCIF_FREESPACE_SHIFT		(0)
+#define _PSB_C2_SOCIF_FREESPACE_MASK		(0xFF << 0)
+#define _PSB_C2_SOCIF_EMPTY			(0x80 << 0)
+
+#define PSB_CR_2D_BLIT_STATUS		0x0E04
+#define _PSB_C2B_STATUS_BUSY			(1 << 24)
+#define _PSB_C2B_STATUS_COMPLETE_SHIFT		(0)
+#define _PSB_C2B_STATUS_COMPLETE_MASK		(0xFFFFFF << 0)
 
 /*
  * 2D defs.
@@ -186,121 +182,121 @@
  * 2D Slave Port Data : Block Header's Object Type
  */
 
-#define	PSB_2D_CLIP_BH                   (0x00000000)
-#define	PSB_2D_PAT_BH                    (0x10000000)
-#define	PSB_2D_CTRL_BH                   (0x20000000)
-#define	PSB_2D_SRC_OFF_BH                (0x30000000)
-#define	PSB_2D_MASK_OFF_BH               (0x40000000)
-#define	PSB_2D_RESERVED1_BH              (0x50000000)
-#define	PSB_2D_RESERVED2_BH              (0x60000000)
-#define	PSB_2D_FENCE_BH                  (0x70000000)
-#define	PSB_2D_BLIT_BH                   (0x80000000)
-#define	PSB_2D_SRC_SURF_BH               (0x90000000)
-#define	PSB_2D_DST_SURF_BH               (0xA0000000)
-#define	PSB_2D_PAT_SURF_BH               (0xB0000000)
-#define	PSB_2D_SRC_PAL_BH                (0xC0000000)
-#define	PSB_2D_PAT_PAL_BH                (0xD0000000)
-#define	PSB_2D_MASK_SURF_BH              (0xE0000000)
-#define	PSB_2D_FLUSH_BH                  (0xF0000000)
+#define	PSB_2D_CLIP_BH			(0x00000000)
+#define	PSB_2D_PAT_BH			(0x10000000)
+#define	PSB_2D_CTRL_BH			(0x20000000)
+#define	PSB_2D_SRC_OFF_BH		(0x30000000)
+#define	PSB_2D_MASK_OFF_BH		(0x40000000)
+#define	PSB_2D_RESERVED1_BH		(0x50000000)
+#define	PSB_2D_RESERVED2_BH		(0x60000000)
+#define	PSB_2D_FENCE_BH			(0x70000000)
+#define	PSB_2D_BLIT_BH			(0x80000000)
+#define	PSB_2D_SRC_SURF_BH		(0x90000000)
+#define	PSB_2D_DST_SURF_BH		(0xA0000000)
+#define	PSB_2D_PAT_SURF_BH		(0xB0000000)
+#define	PSB_2D_SRC_PAL_BH		(0xC0000000)
+#define	PSB_2D_PAT_PAL_BH		(0xD0000000)
+#define	PSB_2D_MASK_SURF_BH		(0xE0000000)
+#define	PSB_2D_FLUSH_BH			(0xF0000000)
 
 /*
  * Clip Definition block (PSB_2D_CLIP_BH)
  */
-#define PSB_2D_CLIPCOUNT_MAX             (1)
-#define PSB_2D_CLIPCOUNT_MASK            (0x00000000)
-#define PSB_2D_CLIPCOUNT_CLRMASK         (0xFFFFFFFF)
-#define PSB_2D_CLIPCOUNT_SHIFT           (0)
+#define PSB_2D_CLIPCOUNT_MAX		(1)
+#define PSB_2D_CLIPCOUNT_MASK		(0x00000000)
+#define PSB_2D_CLIPCOUNT_CLRMASK	(0xFFFFFFFF)
+#define PSB_2D_CLIPCOUNT_SHIFT		(0)
 /* clip rectangle min & max */
-#define PSB_2D_CLIP_XMAX_MASK            (0x00FFF000)
-#define PSB_2D_CLIP_XMAX_CLRMASK         (0xFF000FFF)
-#define PSB_2D_CLIP_XMAX_SHIFT           (12)
-#define PSB_2D_CLIP_XMIN_MASK            (0x00000FFF)
-#define PSB_2D_CLIP_XMIN_CLRMASK         (0x00FFF000)
-#define PSB_2D_CLIP_XMIN_SHIFT           (0)
+#define PSB_2D_CLIP_XMAX_MASK		(0x00FFF000)
+#define PSB_2D_CLIP_XMAX_CLRMASK	(0xFF000FFF)
+#define PSB_2D_CLIP_XMAX_SHIFT		(12)
+#define PSB_2D_CLIP_XMIN_MASK		(0x00000FFF)
+#define PSB_2D_CLIP_XMIN_CLRMASK	(0x00FFF000)
+#define PSB_2D_CLIP_XMIN_SHIFT		(0)
 /* clip rectangle offset */
-#define PSB_2D_CLIP_YMAX_MASK            (0x00FFF000)
-#define PSB_2D_CLIP_YMAX_CLRMASK         (0xFF000FFF)
-#define PSB_2D_CLIP_YMAX_SHIFT           (12)
-#define PSB_2D_CLIP_YMIN_MASK            (0x00000FFF)
-#define PSB_2D_CLIP_YMIN_CLRMASK         (0x00FFF000)
-#define PSB_2D_CLIP_YMIN_SHIFT           (0)
+#define PSB_2D_CLIP_YMAX_MASK		(0x00FFF000)
+#define PSB_2D_CLIP_YMAX_CLRMASK	(0xFF000FFF)
+#define PSB_2D_CLIP_YMAX_SHIFT		(12)
+#define PSB_2D_CLIP_YMIN_MASK		(0x00000FFF)
+#define PSB_2D_CLIP_YMIN_CLRMASK	(0x00FFF000)
+#define PSB_2D_CLIP_YMIN_SHIFT		(0)
 
 /*
  * Pattern Control (PSB_2D_PAT_BH)
  */
-#define PSB_2D_PAT_HEIGHT_MASK           (0x0000001F)
-#define PSB_2D_PAT_HEIGHT_SHIFT          (0)
-#define PSB_2D_PAT_WIDTH_MASK            (0x000003E0)
-#define PSB_2D_PAT_WIDTH_SHIFT           (5)
-#define PSB_2D_PAT_YSTART_MASK           (0x00007C00)
-#define PSB_2D_PAT_YSTART_SHIFT          (10)
-#define PSB_2D_PAT_XSTART_MASK           (0x000F8000)
-#define PSB_2D_PAT_XSTART_SHIFT          (15)
+#define PSB_2D_PAT_HEIGHT_MASK		(0x0000001F)
+#define PSB_2D_PAT_HEIGHT_SHIFT		(0)
+#define PSB_2D_PAT_WIDTH_MASK		(0x000003E0)
+#define PSB_2D_PAT_WIDTH_SHIFT		(5)
+#define PSB_2D_PAT_YSTART_MASK		(0x00007C00)
+#define PSB_2D_PAT_YSTART_SHIFT		(10)
+#define PSB_2D_PAT_XSTART_MASK		(0x000F8000)
+#define PSB_2D_PAT_XSTART_SHIFT		(15)
 
 /*
  * 2D Control block (PSB_2D_CTRL_BH)
  */
 /* Present Flags */
-#define PSB_2D_SRCCK_CTRL                (0x00000001)
-#define PSB_2D_DSTCK_CTRL                (0x00000002)
-#define PSB_2D_ALPHA_CTRL                (0x00000004)
+#define PSB_2D_SRCCK_CTRL		(0x00000001)
+#define PSB_2D_DSTCK_CTRL		(0x00000002)
+#define PSB_2D_ALPHA_CTRL		(0x00000004)
 /* Colour Key Colour (SRC/DST)*/
-#define PSB_2D_CK_COL_MASK               (0xFFFFFFFF)
-#define PSB_2D_CK_COL_CLRMASK            (0x00000000)
-#define PSB_2D_CK_COL_SHIFT              (0)
+#define PSB_2D_CK_COL_MASK		(0xFFFFFFFF)
+#define PSB_2D_CK_COL_CLRMASK		(0x00000000)
+#define PSB_2D_CK_COL_SHIFT		(0)
 /* Colour Key Mask (SRC/DST)*/
-#define PSB_2D_CK_MASK_MASK              (0xFFFFFFFF)
-#define PSB_2D_CK_MASK_CLRMASK           (0x00000000)
-#define PSB_2D_CK_MASK_SHIFT             (0)
+#define PSB_2D_CK_MASK_MASK		(0xFFFFFFFF)
+#define PSB_2D_CK_MASK_CLRMASK		(0x00000000)
+#define PSB_2D_CK_MASK_SHIFT		(0)
 /* Alpha Control (Alpha/RGB)*/
-#define PSB_2D_GBLALPHA_MASK             (0x000FF000)
-#define PSB_2D_GBLALPHA_CLRMASK          (0xFFF00FFF)
-#define PSB_2D_GBLALPHA_SHIFT            (12)
-#define PSB_2D_SRCALPHA_OP_MASK          (0x00700000)
-#define PSB_2D_SRCALPHA_OP_CLRMASK       (0xFF8FFFFF)
-#define PSB_2D_SRCALPHA_OP_SHIFT         (20)
-#define PSB_2D_SRCALPHA_OP_ONE           (0x00000000)
-#define PSB_2D_SRCALPHA_OP_SRC           (0x00100000)
-#define PSB_2D_SRCALPHA_OP_DST           (0x00200000)
-#define PSB_2D_SRCALPHA_OP_SG            (0x00300000)
-#define PSB_2D_SRCALPHA_OP_DG            (0x00400000)
-#define PSB_2D_SRCALPHA_OP_GBL           (0x00500000)
-#define PSB_2D_SRCALPHA_OP_ZERO          (0x00600000)
-#define PSB_2D_SRCALPHA_INVERT           (0x00800000)
-#define PSB_2D_SRCALPHA_INVERT_CLR       (0xFF7FFFFF)
-#define PSB_2D_DSTALPHA_OP_MASK          (0x07000000)
-#define PSB_2D_DSTALPHA_OP_CLRMASK       (0xF8FFFFFF)
-#define PSB_2D_DSTALPHA_OP_SHIFT         (24)
-#define PSB_2D_DSTALPHA_OP_ONE           (0x00000000)
-#define PSB_2D_DSTALPHA_OP_SRC           (0x01000000)
-#define PSB_2D_DSTALPHA_OP_DST           (0x02000000)
-#define PSB_2D_DSTALPHA_OP_SG            (0x03000000)
-#define PSB_2D_DSTALPHA_OP_DG            (0x04000000)
-#define PSB_2D_DSTALPHA_OP_GBL           (0x05000000)
-#define PSB_2D_DSTALPHA_OP_ZERO          (0x06000000)
-#define PSB_2D_DSTALPHA_INVERT           (0x08000000)
-#define PSB_2D_DSTALPHA_INVERT_CLR       (0xF7FFFFFF)
-
-#define PSB_2D_PRE_MULTIPLICATION_ENABLE  (0x10000000)
-#define PSB_2D_PRE_MULTIPLICATION_CLRMASK (0xEFFFFFFF)
-#define PSB_2D_ZERO_SOURCE_ALPHA_ENABLE   (0x20000000)
-#define PSB_2D_ZERO_SOURCE_ALPHA_CLRMASK  (0xDFFFFFFF)
+#define PSB_2D_GBLALPHA_MASK		(0x000FF000)
+#define PSB_2D_GBLALPHA_CLRMASK		(0xFFF00FFF)
+#define PSB_2D_GBLALPHA_SHIFT		(12)
+#define PSB_2D_SRCALPHA_OP_MASK		(0x00700000)
+#define PSB_2D_SRCALPHA_OP_CLRMASK	(0xFF8FFFFF)
+#define PSB_2D_SRCALPHA_OP_SHIFT	(20)
+#define PSB_2D_SRCALPHA_OP_ONE		(0x00000000)
+#define PSB_2D_SRCALPHA_OP_SRC		(0x00100000)
+#define PSB_2D_SRCALPHA_OP_DST		(0x00200000)
+#define PSB_2D_SRCALPHA_OP_SG		(0x00300000)
+#define PSB_2D_SRCALPHA_OP_DG		(0x00400000)
+#define PSB_2D_SRCALPHA_OP_GBL		(0x00500000)
+#define PSB_2D_SRCALPHA_OP_ZERO		(0x00600000)
+#define PSB_2D_SRCALPHA_INVERT		(0x00800000)
+#define PSB_2D_SRCALPHA_INVERT_CLR	(0xFF7FFFFF)
+#define PSB_2D_DSTALPHA_OP_MASK		(0x07000000)
+#define PSB_2D_DSTALPHA_OP_CLRMASK	(0xF8FFFFFF)
+#define PSB_2D_DSTALPHA_OP_SHIFT	(24)
+#define PSB_2D_DSTALPHA_OP_ONE		(0x00000000)
+#define PSB_2D_DSTALPHA_OP_SRC		(0x01000000)
+#define PSB_2D_DSTALPHA_OP_DST		(0x02000000)
+#define PSB_2D_DSTALPHA_OP_SG		(0x03000000)
+#define PSB_2D_DSTALPHA_OP_DG		(0x04000000)
+#define PSB_2D_DSTALPHA_OP_GBL		(0x05000000)
+#define PSB_2D_DSTALPHA_OP_ZERO		(0x06000000)
+#define PSB_2D_DSTALPHA_INVERT		(0x08000000)
+#define PSB_2D_DSTALPHA_INVERT_CLR	(0xF7FFFFFF)
+
+#define PSB_2D_PRE_MULTIPLICATION_ENABLE	(0x10000000)
+#define PSB_2D_PRE_MULTIPLICATION_CLRMASK	(0xEFFFFFFF)
+#define PSB_2D_ZERO_SOURCE_ALPHA_ENABLE		(0x20000000)
+#define PSB_2D_ZERO_SOURCE_ALPHA_CLRMASK	(0xDFFFFFFF)
 
 /*
  *Source Offset (PSB_2D_SRC_OFF_BH)
  */
-#define PSB_2D_SRCOFF_XSTART_MASK        ((0x00000FFF) << 12)
-#define PSB_2D_SRCOFF_XSTART_SHIFT       (12)
-#define PSB_2D_SRCOFF_YSTART_MASK        (0x00000FFF)
-#define PSB_2D_SRCOFF_YSTART_SHIFT       (0)
+#define PSB_2D_SRCOFF_XSTART_MASK	((0x00000FFF) << 12)
+#define PSB_2D_SRCOFF_XSTART_SHIFT	(12)
+#define PSB_2D_SRCOFF_YSTART_MASK	(0x00000FFF)
+#define PSB_2D_SRCOFF_YSTART_SHIFT	(0)
 
 /*
  * Mask Offset (PSB_2D_MASK_OFF_BH)
  */
-#define PSB_2D_MASKOFF_XSTART_MASK       ((0x00000FFF) << 12)
-#define PSB_2D_MASKOFF_XSTART_SHIFT      (12)
-#define PSB_2D_MASKOFF_YSTART_MASK       (0x00000FFF)
-#define PSB_2D_MASKOFF_YSTART_SHIFT      (0)
+#define PSB_2D_MASKOFF_XSTART_MASK	((0x00000FFF) << 12)
+#define PSB_2D_MASKOFF_XSTART_SHIFT	(12)
+#define PSB_2D_MASKOFF_YSTART_MASK	(0x00000FFF)
+#define PSB_2D_MASKOFF_YSTART_SHIFT	(0)
 
 /*
  * 2D Fence (see PSB_2D_FENCE_BH): bits 0:27 are ignored
@@ -310,118 +306,118 @@
  *Blit Rectangle (PSB_2D_BLIT_BH)
  */
 
-#define PSB_2D_ROT_MASK                  (3<<25)
-#define PSB_2D_ROT_CLRMASK               (~PSB_2D_ROT_MASK)
-#define PSB_2D_ROT_NONE                  (0<<25)
-#define PSB_2D_ROT_90DEGS                (1<<25)
-#define PSB_2D_ROT_180DEGS               (2<<25)
-#define PSB_2D_ROT_270DEGS               (3<<25)
-
-#define PSB_2D_COPYORDER_MASK            (3<<23)
-#define PSB_2D_COPYORDER_CLRMASK         (~PSB_2D_COPYORDER_MASK)
-#define PSB_2D_COPYORDER_TL2BR           (0<<23)
-#define PSB_2D_COPYORDER_BR2TL           (1<<23)
-#define PSB_2D_COPYORDER_TR2BL           (2<<23)
-#define PSB_2D_COPYORDER_BL2TR           (3<<23)
-
-#define PSB_2D_DSTCK_CLRMASK             (0xFF9FFFFF)
-#define PSB_2D_DSTCK_DISABLE             (0x00000000)
-#define PSB_2D_DSTCK_PASS                (0x00200000)
-#define PSB_2D_DSTCK_REJECT              (0x00400000)
-
-#define PSB_2D_SRCCK_CLRMASK             (0xFFE7FFFF)
-#define PSB_2D_SRCCK_DISABLE             (0x00000000)
-#define PSB_2D_SRCCK_PASS                (0x00080000)
-#define PSB_2D_SRCCK_REJECT              (0x00100000)
-
-#define PSB_2D_CLIP_ENABLE               (0x00040000)
-
-#define PSB_2D_ALPHA_ENABLE              (0x00020000)
-
-#define PSB_2D_PAT_CLRMASK               (0xFFFEFFFF)
-#define PSB_2D_PAT_MASK                  (0x00010000)
-#define PSB_2D_USE_PAT                   (0x00010000)
-#define PSB_2D_USE_FILL                  (0x00000000)
+#define PSB_2D_ROT_MASK			(3 << 25)
+#define PSB_2D_ROT_CLRMASK		(~PSB_2D_ROT_MASK)
+#define PSB_2D_ROT_NONE			(0 << 25)
+#define PSB_2D_ROT_90DEGS		(1 << 25)
+#define PSB_2D_ROT_180DEGS		(2 << 25)
+#define PSB_2D_ROT_270DEGS		(3 << 25)
+
+#define PSB_2D_COPYORDER_MASK		(3 << 23)
+#define PSB_2D_COPYORDER_CLRMASK	(~PSB_2D_COPYORDER_MASK)
+#define PSB_2D_COPYORDER_TL2BR		(0 << 23)
+#define PSB_2D_COPYORDER_BR2TL		(1 << 23)
+#define PSB_2D_COPYORDER_TR2BL		(2 << 23)
+#define PSB_2D_COPYORDER_BL2TR		(3 << 23)
+
+#define PSB_2D_DSTCK_CLRMASK		(0xFF9FFFFF)
+#define PSB_2D_DSTCK_DISABLE		(0x00000000)
+#define PSB_2D_DSTCK_PASS		(0x00200000)
+#define PSB_2D_DSTCK_REJECT		(0x00400000)
+
+#define PSB_2D_SRCCK_CLRMASK		(0xFFE7FFFF)
+#define PSB_2D_SRCCK_DISABLE		(0x00000000)
+#define PSB_2D_SRCCK_PASS		(0x00080000)
+#define PSB_2D_SRCCK_REJECT		(0x00100000)
+
+#define PSB_2D_CLIP_ENABLE		(0x00040000)
+
+#define PSB_2D_ALPHA_ENABLE		(0x00020000)
+
+#define PSB_2D_PAT_CLRMASK		(0xFFFEFFFF)
+#define PSB_2D_PAT_MASK			(0x00010000)
+#define PSB_2D_USE_PAT			(0x00010000)
+#define PSB_2D_USE_FILL			(0x00000000)
 /*
  * Tungsten Graphics note on rop codes: If rop A and rop B are
  * identical, the mask surface will not be read and need not be
  * set up.
  */
 
-#define PSB_2D_ROP3B_MASK                (0x0000FF00)
-#define PSB_2D_ROP3B_CLRMASK             (0xFFFF00FF)
-#define PSB_2D_ROP3B_SHIFT               (8)
+#define PSB_2D_ROP3B_MASK		(0x0000FF00)
+#define PSB_2D_ROP3B_CLRMASK		(0xFFFF00FF)
+#define PSB_2D_ROP3B_SHIFT		(8)
 /* rop code A */
-#define PSB_2D_ROP3A_MASK                (0x000000FF)
-#define PSB_2D_ROP3A_CLRMASK             (0xFFFFFF00)
-#define PSB_2D_ROP3A_SHIFT               (0)
+#define PSB_2D_ROP3A_MASK		(0x000000FF)
+#define PSB_2D_ROP3A_CLRMASK		(0xFFFFFF00)
+#define PSB_2D_ROP3A_SHIFT		(0)
 
-#define PSB_2D_ROP4_MASK                 (0x0000FFFF)
+#define PSB_2D_ROP4_MASK		(0x0000FFFF)
 /*
  *	DWORD0:	(Only pass if Pattern control == Use Fill Colour)
  *	Fill Colour RGBA8888
  */
-#define PSB_2D_FILLCOLOUR_MASK           (0xFFFFFFFF)
-#define PSB_2D_FILLCOLOUR_SHIFT          (0)
+#define PSB_2D_FILLCOLOUR_MASK		(0xFFFFFFFF)
+#define PSB_2D_FILLCOLOUR_SHIFT		(0)
 /*
  *	DWORD1: (Always Present)
  *	X Start (Dest)
  *	Y Start (Dest)
  */
-#define PSB_2D_DST_XSTART_MASK           (0x00FFF000)
-#define PSB_2D_DST_XSTART_CLRMASK        (0xFF000FFF)
-#define PSB_2D_DST_XSTART_SHIFT          (12)
-#define PSB_2D_DST_YSTART_MASK           (0x00000FFF)
-#define PSB_2D_DST_YSTART_CLRMASK        (0xFFFFF000)
-#define PSB_2D_DST_YSTART_SHIFT          (0)
+#define PSB_2D_DST_XSTART_MASK		(0x00FFF000)
+#define PSB_2D_DST_XSTART_CLRMASK	(0xFF000FFF)
+#define PSB_2D_DST_XSTART_SHIFT		(12)
+#define PSB_2D_DST_YSTART_MASK		(0x00000FFF)
+#define PSB_2D_DST_YSTART_CLRMASK	(0xFFFFF000)
+#define PSB_2D_DST_YSTART_SHIFT		(0)
 /*
  *	DWORD2: (Always Present)
  *	X Size (Dest)
  *	Y Size (Dest)
  */
-#define PSB_2D_DST_XSIZE_MASK            (0x00FFF000)
-#define PSB_2D_DST_XSIZE_CLRMASK         (0xFF000FFF)
-#define PSB_2D_DST_XSIZE_SHIFT           (12)
-#define PSB_2D_DST_YSIZE_MASK            (0x00000FFF)
-#define PSB_2D_DST_YSIZE_CLRMASK         (0xFFFFF000)
-#define PSB_2D_DST_YSIZE_SHIFT           (0)
+#define PSB_2D_DST_XSIZE_MASK		(0x00FFF000)
+#define PSB_2D_DST_XSIZE_CLRMASK	(0xFF000FFF)
+#define PSB_2D_DST_XSIZE_SHIFT		(12)
+#define PSB_2D_DST_YSIZE_MASK		(0x00000FFF)
+#define PSB_2D_DST_YSIZE_CLRMASK	(0xFFFFF000)
+#define PSB_2D_DST_YSIZE_SHIFT		(0)
 
 /*
  * Source Surface (PSB_2D_SRC_SURF_BH)
  */
 /*
- *      WORD 0
+ * WORD 0
  */
 
-#define PSB_2D_SRC_FORMAT_MASK           (0x00078000)
-#define PSB_2D_SRC_1_PAL                 (0x00000000)
-#define PSB_2D_SRC_2_PAL                 (0x00008000)
-#define PSB_2D_SRC_4_PAL                 (0x00010000)
-#define PSB_2D_SRC_8_PAL                 (0x00018000)
-#define PSB_2D_SRC_8_ALPHA               (0x00020000)
-#define PSB_2D_SRC_4_ALPHA               (0x00028000)
-#define PSB_2D_SRC_332RGB                (0x00030000)
-#define PSB_2D_SRC_4444ARGB              (0x00038000)
-#define PSB_2D_SRC_555RGB                (0x00040000)
-#define PSB_2D_SRC_1555ARGB              (0x00048000)
-#define PSB_2D_SRC_565RGB                (0x00050000)
-#define PSB_2D_SRC_0888ARGB              (0x00058000)
-#define PSB_2D_SRC_8888ARGB              (0x00060000)
-#define PSB_2D_SRC_8888UYVY              (0x00068000)
-#define PSB_2D_SRC_RESERVED              (0x00070000)
-#define PSB_2D_SRC_1555ARGB_LOOKUP       (0x00078000)
-
-
-#define PSB_2D_SRC_STRIDE_MASK           (0x00007FFF)
-#define PSB_2D_SRC_STRIDE_CLRMASK        (0xFFFF8000)
-#define PSB_2D_SRC_STRIDE_SHIFT          (0)
+#define PSB_2D_SRC_FORMAT_MASK		(0x00078000)
+#define PSB_2D_SRC_1_PAL		(0x00000000)
+#define PSB_2D_SRC_2_PAL		(0x00008000)
+#define PSB_2D_SRC_4_PAL		(0x00010000)
+#define PSB_2D_SRC_8_PAL		(0x00018000)
+#define PSB_2D_SRC_8_ALPHA		(0x00020000)
+#define PSB_2D_SRC_4_ALPHA		(0x00028000)
+#define PSB_2D_SRC_332RGB		(0x00030000)
+#define PSB_2D_SRC_4444ARGB		(0x00038000)
+#define PSB_2D_SRC_555RGB		(0x00040000)
+#define PSB_2D_SRC_1555ARGB		(0x00048000)
+#define PSB_2D_SRC_565RGB		(0x00050000)
+#define PSB_2D_SRC_0888ARGB		(0x00058000)
+#define PSB_2D_SRC_8888ARGB		(0x00060000)
+#define PSB_2D_SRC_8888UYVY		(0x00068000)
+#define PSB_2D_SRC_RESERVED		(0x00070000)
+#define PSB_2D_SRC_1555ARGB_LOOKUP	(0x00078000)
+
+
+#define PSB_2D_SRC_STRIDE_MASK		(0x00007FFF)
+#define PSB_2D_SRC_STRIDE_CLRMASK	(0xFFFF8000)
+#define PSB_2D_SRC_STRIDE_SHIFT		(0)
 /*
  *  WORD 1 - Base Address
  */
-#define PSB_2D_SRC_ADDR_MASK             (0x0FFFFFFC)
-#define PSB_2D_SRC_ADDR_CLRMASK          (0x00000003)
-#define PSB_2D_SRC_ADDR_SHIFT            (2)
-#define PSB_2D_SRC_ADDR_ALIGNSHIFT       (2)
+#define PSB_2D_SRC_ADDR_MASK		(0x0FFFFFFC)
+#define PSB_2D_SRC_ADDR_CLRMASK		(0x00000003)
+#define PSB_2D_SRC_ADDR_SHIFT		(2)
+#define PSB_2D_SRC_ADDR_ALIGNSHIFT	(2)
 
 /*
  * Pattern Surface (PSB_2D_PAT_SURF_BH)
@@ -430,31 +426,31 @@
  *  WORD 0
  */
 
-#define PSB_2D_PAT_FORMAT_MASK           (0x00078000)
-#define PSB_2D_PAT_1_PAL                 (0x00000000)
-#define PSB_2D_PAT_2_PAL                 (0x00008000)
-#define PSB_2D_PAT_4_PAL                 (0x00010000)
-#define PSB_2D_PAT_8_PAL                 (0x00018000)
-#define PSB_2D_PAT_8_ALPHA               (0x00020000)
-#define PSB_2D_PAT_4_ALPHA               (0x00028000)
-#define PSB_2D_PAT_332RGB                (0x00030000)
-#define PSB_2D_PAT_4444ARGB              (0x00038000)
-#define PSB_2D_PAT_555RGB                (0x00040000)
-#define PSB_2D_PAT_1555ARGB              (0x00048000)
-#define PSB_2D_PAT_565RGB                (0x00050000)
-#define PSB_2D_PAT_0888ARGB              (0x00058000)
-#define PSB_2D_PAT_8888ARGB              (0x00060000)
-
-#define PSB_2D_PAT_STRIDE_MASK           (0x00007FFF)
-#define PSB_2D_PAT_STRIDE_CLRMASK        (0xFFFF8000)
-#define PSB_2D_PAT_STRIDE_SHIFT          (0)
+#define PSB_2D_PAT_FORMAT_MASK		(0x00078000)
+#define PSB_2D_PAT_1_PAL		(0x00000000)
+#define PSB_2D_PAT_2_PAL		(0x00008000)
+#define PSB_2D_PAT_4_PAL		(0x00010000)
+#define PSB_2D_PAT_8_PAL		(0x00018000)
+#define PSB_2D_PAT_8_ALPHA		(0x00020000)
+#define PSB_2D_PAT_4_ALPHA		(0x00028000)
+#define PSB_2D_PAT_332RGB		(0x00030000)
+#define PSB_2D_PAT_4444ARGB		(0x00038000)
+#define PSB_2D_PAT_555RGB		(0x00040000)
+#define PSB_2D_PAT_1555ARGB		(0x00048000)
+#define PSB_2D_PAT_565RGB		(0x00050000)
+#define PSB_2D_PAT_0888ARGB		(0x00058000)
+#define PSB_2D_PAT_8888ARGB		(0x00060000)
+
+#define PSB_2D_PAT_STRIDE_MASK		(0x00007FFF)
+#define PSB_2D_PAT_STRIDE_CLRMASK	(0xFFFF8000)
+#define PSB_2D_PAT_STRIDE_SHIFT		(0)
 /*
  *  WORD 1 - Base Address
  */
-#define PSB_2D_PAT_ADDR_MASK             (0x0FFFFFFC)
-#define PSB_2D_PAT_ADDR_CLRMASK          (0x00000003)
-#define PSB_2D_PAT_ADDR_SHIFT            (2)
-#define PSB_2D_PAT_ADDR_ALIGNSHIFT       (2)
+#define PSB_2D_PAT_ADDR_MASK		(0x0FFFFFFC)
+#define PSB_2D_PAT_ADDR_CLRMASK		(0x00000003)
+#define PSB_2D_PAT_ADDR_SHIFT		(2)
+#define PSB_2D_PAT_ADDR_ALIGNSHIFT	(2)
 
 /*
  * Destination Surface (PSB_2D_DST_SURF_BH)
@@ -463,26 +459,26 @@
  * WORD 0
  */
 
-#define PSB_2D_DST_FORMAT_MASK           (0x00078000)
-#define PSB_2D_DST_332RGB                (0x00030000)
-#define PSB_2D_DST_4444ARGB              (0x00038000)
-#define PSB_2D_DST_555RGB                (0x00040000)
-#define PSB_2D_DST_1555ARGB              (0x00048000)
-#define PSB_2D_DST_565RGB                (0x00050000)
-#define PSB_2D_DST_0888ARGB              (0x00058000)
-#define PSB_2D_DST_8888ARGB              (0x00060000)
-#define PSB_2D_DST_8888AYUV              (0x00070000)
-
-#define PSB_2D_DST_STRIDE_MASK           (0x00007FFF)
-#define PSB_2D_DST_STRIDE_CLRMASK        (0xFFFF8000)
-#define PSB_2D_DST_STRIDE_SHIFT          (0)
+#define PSB_2D_DST_FORMAT_MASK		(0x00078000)
+#define PSB_2D_DST_332RGB		(0x00030000)
+#define PSB_2D_DST_4444ARGB		(0x00038000)
+#define PSB_2D_DST_555RGB		(0x00040000)
+#define PSB_2D_DST_1555ARGB		(0x00048000)
+#define PSB_2D_DST_565RGB		(0x00050000)
+#define PSB_2D_DST_0888ARGB		(0x00058000)
+#define PSB_2D_DST_8888ARGB		(0x00060000)
+#define PSB_2D_DST_8888AYUV		(0x00070000)
+
+#define PSB_2D_DST_STRIDE_MASK		(0x00007FFF)
+#define PSB_2D_DST_STRIDE_CLRMASK	(0xFFFF8000)
+#define PSB_2D_DST_STRIDE_SHIFT		(0)
 /*
  * WORD 1 - Base Address
  */
-#define PSB_2D_DST_ADDR_MASK             (0x0FFFFFFC)
-#define PSB_2D_DST_ADDR_CLRMASK          (0x00000003)
-#define PSB_2D_DST_ADDR_SHIFT            (2)
-#define PSB_2D_DST_ADDR_ALIGNSHIFT       (2)
+#define PSB_2D_DST_ADDR_MASK		(0x0FFFFFFC)
+#define PSB_2D_DST_ADDR_CLRMASK		(0x00000003)
+#define PSB_2D_DST_ADDR_SHIFT		(2)
+#define PSB_2D_DST_ADDR_ALIGNSHIFT	(2)
 
 /*
  * Mask Surface (PSB_2D_MASK_SURF_BH)
@@ -490,99 +486,97 @@
 /*
  * WORD 0
  */
-#define PSB_2D_MASK_STRIDE_MASK          (0x00007FFF)
-#define PSB_2D_MASK_STRIDE_CLRMASK       (0xFFFF8000)
-#define PSB_2D_MASK_STRIDE_SHIFT         (0)
+#define PSB_2D_MASK_STRIDE_MASK		(0x00007FFF)
+#define PSB_2D_MASK_STRIDE_CLRMASK	(0xFFFF8000)
+#define PSB_2D_MASK_STRIDE_SHIFT	(0)
 /*
  *  WORD 1 - Base Address
  */
-#define PSB_2D_MASK_ADDR_MASK            (0x0FFFFFFC)
-#define PSB_2D_MASK_ADDR_CLRMASK         (0x00000003)
-#define PSB_2D_MASK_ADDR_SHIFT           (2)
-#define PSB_2D_MASK_ADDR_ALIGNSHIFT      (2)
+#define PSB_2D_MASK_ADDR_MASK		(0x0FFFFFFC)
+#define PSB_2D_MASK_ADDR_CLRMASK	(0x00000003)
+#define PSB_2D_MASK_ADDR_SHIFT		(2)
+#define PSB_2D_MASK_ADDR_ALIGNSHIFT	(2)
 
 /*
  * Source Palette (PSB_2D_SRC_PAL_BH)
  */
 
-#define PSB_2D_SRCPAL_ADDR_SHIFT         (0)
-#define PSB_2D_SRCPAL_ADDR_CLRMASK       (0xF0000007)
-#define PSB_2D_SRCPAL_ADDR_MASK          (0x0FFFFFF8)
-#define PSB_2D_SRCPAL_BYTEALIGN          (1024)
+#define PSB_2D_SRCPAL_ADDR_SHIFT	(0)
+#define PSB_2D_SRCPAL_ADDR_CLRMASK	(0xF0000007)
+#define PSB_2D_SRCPAL_ADDR_MASK		(0x0FFFFFF8)
+#define PSB_2D_SRCPAL_BYTEALIGN		(1024)
 
 /*
  * Pattern Palette (PSB_2D_PAT_PAL_BH)
  */
 
-#define PSB_2D_PATPAL_ADDR_SHIFT         (0)
-#define PSB_2D_PATPAL_ADDR_CLRMASK       (0xF0000007)
-#define PSB_2D_PATPAL_ADDR_MASK          (0x0FFFFFF8)
-#define PSB_2D_PATPAL_BYTEALIGN          (1024)
+#define PSB_2D_PATPAL_ADDR_SHIFT	(0)
+#define PSB_2D_PATPAL_ADDR_CLRMASK	(0xF0000007)
+#define PSB_2D_PATPAL_ADDR_MASK		(0x0FFFFFF8)
+#define PSB_2D_PATPAL_BYTEALIGN		(1024)
 
 /*
  * Rop3 Codes (2 LS bytes)
  */
 
-#define PSB_2D_ROP3_SRCCOPY              (0xCCCC)
-#define PSB_2D_ROP3_PATCOPY              (0xF0F0)
-#define PSB_2D_ROP3_WHITENESS            (0xFFFF)
-#define PSB_2D_ROP3_BLACKNESS            (0x0000)
-#define PSB_2D_ROP3_SRC                  (0xCC)
-#define PSB_2D_ROP3_PAT                  (0xF0)
-#define PSB_2D_ROP3_DST                  (0xAA)
-
+#define PSB_2D_ROP3_SRCCOPY		(0xCCCC)
+#define PSB_2D_ROP3_PATCOPY		(0xF0F0)
+#define PSB_2D_ROP3_WHITENESS		(0xFFFF)
+#define PSB_2D_ROP3_BLACKNESS		(0x0000)
+#define PSB_2D_ROP3_SRC			(0xCC)
+#define PSB_2D_ROP3_PAT			(0xF0)
+#define PSB_2D_ROP3_DST			(0xAA)
 
 /*
  * Sizes.
  */
 
-#define PSB_SCENE_HW_COOKIE_SIZE 16
-#define PSB_TA_MEM_HW_COOKIE_SIZE 16
+#define PSB_SCENE_HW_COOKIE_SIZE	16
+#define PSB_TA_MEM_HW_COOKIE_SIZE	16
 
 /*
  * Scene stuff.
  */
 
-#define PSB_NUM_HW_SCENES          2
+#define PSB_NUM_HW_SCENES		2
 
 /*
  * Scheduler completion actions.
  */
 
-#define PSB_RASTER_BLOCK 0
-#define PSB_RASTER       1
-#define PSB_RETURN       2
-#define PSB_TA       3
-
-
-/*Power management*/
-#define PSB_PUNIT_PORT		    0x04
-#define PSB_OSPMBA		    0x78
-#define PSB_APMBA		    0x7a
-#define PSB_APM_CMD		    0x0
-#define PSB_APM_STS		    0x04
-#define PSB_PWRGT_VID_ENC_MASK	    0x30
-#define PSB_PWRGT_VID_DEC_MASK	    0xc
-#define PSB_PWRGT_GL3_MASK	    0xc0
-
-#define PSB_PM_SSC		    0x20
-#define PSB_PM_SSS		    0x30
-#define PSB_PWRGT_DISPLAY_MASK	    0xc /*on a different BA than video/gfx*/
-#define MDFLD_PWRGT_DISPLAY_A_CNTR  0x0000000c
-#define MDFLD_PWRGT_DISPLAY_B_CNTR  0x0000c000
-#define MDFLD_PWRGT_DISPLAY_C_CNTR  0x00030000
-#define MDFLD_PWRGT_DISP_MIPI_CNTR  0x000c0000
-#define MDFLD_PWRGT_DISPLAY_CNTR    (MDFLD_PWRGT_DISPLAY_A_CNTR | MDFLD_PWRGT_DISPLAY_B_CNTR | MDFLD_PWRGT_DISPLAY_C_CNTR | MDFLD_PWRGT_DISP_MIPI_CNTR)// 0x000fc00c
+#define PSB_RASTER_BLOCK		0
+#define PSB_RASTER			1
+#define PSB_RETURN			2
+#define PSB_TA				3
+
+/* Power management */
+#define PSB_PUNIT_PORT			0x04
+#define PSB_OSPMBA			0x78
+#define PSB_APMBA			0x7a
+#define PSB_APM_CMD			0x0
+#define PSB_APM_STS			0x04
+#define PSB_PWRGT_VID_ENC_MASK		0x30
+#define PSB_PWRGT_VID_DEC_MASK		0xc
+#define PSB_PWRGT_GL3_MASK		0xc0
+
+#define PSB_PM_SSC			0x20
+#define PSB_PM_SSS			0x30
+#define PSB_PWRGT_DISPLAY_MASK		0xc /*on a different BA than video/gfx*/
+#define MDFLD_PWRGT_DISPLAY_A_CNTR	0x0000000c
+#define MDFLD_PWRGT_DISPLAY_B_CNTR	0x0000c000
+#define MDFLD_PWRGT_DISPLAY_C_CNTR	0x00030000
+#define MDFLD_PWRGT_DISP_MIPI_CNTR	0x000c0000
+#define MDFLD_PWRGT_DISPLAY_CNTR    (MDFLD_PWRGT_DISPLAY_A_CNTR | MDFLD_PWRGT_DISPLAY_B_CNTR | MDFLD_PWRGT_DISPLAY_C_CNTR | MDFLD_PWRGT_DISP_MIPI_CNTR) /* 0x000fc00c */
 /* Display SSS register bits are different in A0 vs. B0 */
-#define PSB_PWRGT_GFX_MASK	    0x3
-#define MDFLD_PWRGT_DISPLAY_A_STS  		0x000000c0
-#define MDFLD_PWRGT_DISPLAY_B_STS  		0x00000300
-#define MDFLD_PWRGT_DISPLAY_C_STS  		0x00000c00
-#define PSB_PWRGT_GFX_MASK_B0	   		0xc3
+#define PSB_PWRGT_GFX_MASK		0x3
+#define MDFLD_PWRGT_DISPLAY_A_STS	0x000000c0
+#define MDFLD_PWRGT_DISPLAY_B_STS	0x00000300
+#define MDFLD_PWRGT_DISPLAY_C_STS	0x00000c00
+#define PSB_PWRGT_GFX_MASK_B0		0xc3
 #define MDFLD_PWRGT_DISPLAY_A_STS_B0	0x0000000c
-#define MDFLD_PWRGT_DISPLAY_B_STS_B0  	0x0000c000
-#define MDFLD_PWRGT_DISPLAY_C_STS_B0  	0x00030000
-#define MDFLD_PWRGT_DISP_MIPI_STS  0x000c0000
-#define MDFLD_PWRGT_DISPLAY_STS_A0    (MDFLD_PWRGT_DISPLAY_A_STS | MDFLD_PWRGT_DISPLAY_B_STS | MDFLD_PWRGT_DISPLAY_C_STS | MDFLD_PWRGT_DISP_MIPI_STS)// 0x000fc00c
-#define MDFLD_PWRGT_DISPLAY_STS_B0    (MDFLD_PWRGT_DISPLAY_A_STS_B0 | MDFLD_PWRGT_DISPLAY_B_STS_B0 | MDFLD_PWRGT_DISPLAY_C_STS_B0 | MDFLD_PWRGT_DISP_MIPI_STS)// 0x000fc00c
+#define MDFLD_PWRGT_DISPLAY_B_STS_B0	0x0000c000
+#define MDFLD_PWRGT_DISPLAY_C_STS_B0	0x00030000
+#define MDFLD_PWRGT_DISP_MIPI_STS	0x000c0000
+#define MDFLD_PWRGT_DISPLAY_STS_A0    (MDFLD_PWRGT_DISPLAY_A_STS | MDFLD_PWRGT_DISPLAY_B_STS | MDFLD_PWRGT_DISPLAY_C_STS | MDFLD_PWRGT_DISP_MIPI_STS) /* 0x000fc00c */
+#define MDFLD_PWRGT_DISPLAY_STS_B0    (MDFLD_PWRGT_DISPLAY_A_STS_B0 | MDFLD_PWRGT_DISPLAY_B_STS_B0 | MDFLD_PWRGT_DISPLAY_C_STS_B0 | MDFLD_PWRGT_DISP_MIPI_STS) /* 0x000fc00c */
 #endif

