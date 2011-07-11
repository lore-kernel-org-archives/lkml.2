Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758514Ab1GKSs5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:48:57 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58557 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758420Ab1GKSsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:48:55 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/4] gma500: Final polish
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Mon, 11 Jul 2011 19:39:43 +0100
Message-ID: <20110711183933.8996.37507.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This completes the clean up all the non Medfield C files to the point where
checkpatch approves of them barring some silly 80 column whining.

The Medfield stuff is still in a lot of flux but the rest is now ready for
general tidy and review.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/framebuffer.c       |    8 ++++----
 drivers/staging/gma500/gtt.c               |    2 +-
 drivers/staging/gma500/psb_device.c        |    2 +-
 drivers/staging/gma500/psb_drv.c           |    8 ++++----
 drivers/staging/gma500/psb_intel_display.c |    8 ++++----
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/gma500/framebuffer.c b/drivers/staging/gma500/framebuffer.c
index c6dd4d8..e2ee579 100644
--- a/drivers/staging/gma500/framebuffer.c
+++ b/drivers/staging/gma500/framebuffer.c
@@ -756,10 +756,10 @@ static void psb_setup_outputs(struct drm_device *dev)
 			clone_mask = (1 << INTEL_OUTPUT_MIPI2);
 			break;
 		case INTEL_OUTPUT_HDMI:
-		        if (IS_MFLD(dev))
-        			crtc_mask = (1 << 1);
-                        else	/* FIXME: review Oaktrail */
-                                crtc_mask = (1 << 0);	/* Cedarview */
+			if (IS_MFLD(dev))
+				crtc_mask = (1 << 1);
+			else	/* FIXME: review Oaktrail */
+				crtc_mask = (1 << 0);	/* Cedarview */
 			clone_mask = (1 << INTEL_OUTPUT_HDMI);
 			break;
 		}
diff --git a/drivers/staging/gma500/gtt.c b/drivers/staging/gma500/gtt.c
index 78dd01b..7a1a89a 100644
--- a/drivers/staging/gma500/gtt.c
+++ b/drivers/staging/gma500/gtt.c
@@ -398,7 +398,7 @@ int psb_gtt_init(struct drm_device *dev, int resume)
 	dev_priv->gtt_initialized = 1;
 
 	pg->gtt_phys_start = dev_priv->pge_ctl & PAGE_MASK;
-	
+
 	/*
 	 *	FIXME: video mmu has hw bug to access 0x0D0000000,
 	 *	then make gatt start at 0x0e000,0000
diff --git a/drivers/staging/gma500/psb_device.c b/drivers/staging/gma500/psb_device.c
index e26a176..1e117f0 100644
--- a/drivers/staging/gma500/psb_device.c
+++ b/drivers/staging/gma500/psb_device.c
@@ -347,6 +347,6 @@ const struct psb_ops psb_chip_ops = {
 	.save_regs = psb_save_display_registers,
 	.restore_regs = psb_restore_display_registers,
 	.power_down = psb_power_down,
-	.power_up = psb_power_up,	
+	.power_up = psb_power_up,
 };
 
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 397b605..b85e538 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -52,7 +52,7 @@ module_param_named(trap_pagefaults, drm_psb_trap_pagefaults, int, 0600);
 static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
 	{ 0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &psb_chip_ops },
 	{ 0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &psb_chip_ops },
-#if defined(CONFIG_DRM_PSB_MRST)	
+#if defined(CONFIG_DRM_PSB_MRST)
 	{ 0x8086, 0x4100, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mrst_chip_ops},
 	{ 0x8086, 0x4101, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mrst_chip_ops},
 	{ 0x8086, 0x4102, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mrst_chip_ops},
@@ -72,7 +72,7 @@ static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
 	{ 0x8086, 0x0136, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mdfld_chip_ops},
 	{ 0x8086, 0x0137, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &mdfld_chip_ops},
 #endif
-#if defined(CONFIG_DRM_PSB_CDV)	
+#if defined(CONFIG_DRM_PSB_CDV)
 	{ 0x8086, 0x0be0, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
 	{ 0x8086, 0x0be1, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
 	{ 0x8086, 0x0be2, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
@@ -81,7 +81,7 @@ static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
 	{ 0x8086, 0x0be5, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
 	{ 0x8086, 0x0be6, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
 	{ 0x8086, 0x0be7, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (long) &cdv_chip_ops},
-#endif	
+#endif
 	{ 0, 0, 0}
 };
 MODULE_DEVICE_TABLE(pci, pciidlist);
@@ -409,7 +409,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 #ifdef CONFIG_MDFLD_DSI_DPU
 		/*init dpu info*/
 		mdfld_dbi_dpu_init(dev);
-#else 
+#else
 		mdfld_dbi_dsr_init(dev);
 #endif /*CONFIG_MDFLD_DSI_DPU*/
 		/* INIT_WORK(&dev_priv->te_work, mdfld_te_handler_work);*/
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index cc7237e..f1d1b22 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -1284,9 +1284,9 @@ const struct drm_crtc_funcs psb_intel_crtc_funcs = {
  */
 static void psb_intel_cursor_init(struct drm_device *dev, int pipe)
 {
-        u32 control[3] = { CURACNTR, CURBCNTR, CURCCNTR };
-        u32 base[3] = { CURABASE, CURBBASE, CURCBASE };
-        
+	u32 control[3] = { CURACNTR, CURBCNTR, CURCCNTR };
+	u32 base[3] = { CURABASE, CURBBASE, CURCBASE };
+
 	REG_WRITE(control[pipe], 0);
 	REG_WRITE(base[pipe], 0);
 }
@@ -1341,7 +1341,7 @@ void psb_intel_crtc_init(struct drm_device *dev, int pipe,
 	psb_intel_crtc->cursor_addr = 0;
 
 	drm_crtc_helper_add(&psb_intel_crtc->base,
-	                                dev_priv->ops->crtc_helper);
+						dev_priv->ops->crtc_helper);
 
 	/* Setup the array of drm_connector pointer array */
 	psb_intel_crtc->mode_set.crtc = &psb_intel_crtc->base;

