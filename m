Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab2CQEoB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 00:44:01 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36473 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751812Ab2CQEn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 00:43:56 -0400
From: Joe Perches <joe@perches.com>
To: Keith Packard <keithp@keithp.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] i915: Add and use pr_fmt and pr_<level>
Date: Fri, 16 Mar 2012 21:43:49 -0700
Message-Id: <7abee2f1eaa52183aad01bacc8179b29ace7f173.1331959343.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a more current logging style.  Ensure that appropriate
logging messages are prefixed with "i915: ".

Convert printks to pr_<level>.  Align arguments.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/i915/i915_dma.c       |    6 ++-
 drivers/gpu/drm/i915/i915_irq.c       |   70 +++++++++++++--------------------
 drivers/gpu/drm/i915/intel_opregion.c |    4 +-
 drivers/gpu/drm/i915/intel_panel.c    |    4 +-
 4 files changed, 37 insertions(+), 47 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 9341eb8..7e83818 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -26,6 +26,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "drmP.h"
 #include "drm.h"
 #include "drm_crtc_helper.h"
@@ -1158,14 +1160,14 @@ static void i915_switcheroo_set_state(struct pci_dev *pdev, enum vga_switcheroo_
 	struct drm_device *dev = pci_get_drvdata(pdev);
 	pm_message_t pmm = { .event = PM_EVENT_SUSPEND };
 	if (state == VGA_SWITCHEROO_ON) {
-		printk(KERN_INFO "i915: switched on\n");
+		pr_info("switched on\n");
 		dev->switch_power_state = DRM_SWITCH_POWER_CHANGING;
 		/* i915 resume handler doesn't set to D0 */
 		pci_set_power_state(dev->pdev, PCI_D0);
 		i915_resume(dev);
 		dev->switch_power_state = DRM_SWITCH_POWER_ON;
 	} else {
-		printk(KERN_ERR "i915: switched off\n");
+		pr_err("switched off\n");
 		dev->switch_power_state = DRM_SWITCH_POWER_CHANGING;
 		i915_suspend(dev, pmm);
 		dev->switch_power_state = DRM_SWITCH_POWER_OFF;
diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
index afd4e03..4c89149 100644
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -26,6 +26,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/sysrq.h>
 #include <linux/slab.h>
 #include "drmP.h"
@@ -1103,33 +1105,26 @@ static void i915_report_and_clear_eir(struct drm_device *dev)
 	if (!eir)
 		return;
 
-	printk(KERN_ERR "render error detected, EIR: 0x%08x\n",
-	       eir);
+	pr_err("render error detected, EIR: 0x%08x\n", eir);
 
 	if (IS_G4X(dev)) {
 		if (eir & (GM45_ERROR_MEM_PRIV | GM45_ERROR_CP_PRIV)) {
 			u32 ipeir = I915_READ(IPEIR_I965);
 
-			printk(KERN_ERR "  IPEIR: 0x%08x\n",
-			       I915_READ(IPEIR_I965));
-			printk(KERN_ERR "  IPEHR: 0x%08x\n",
-			       I915_READ(IPEHR_I965));
-			printk(KERN_ERR "  INSTDONE: 0x%08x\n",
+			pr_err("  IPEIR: 0x%08x\n", I915_READ(IPEIR_I965));
+			pr_err("  IPEHR: 0x%08x\n", I915_READ(IPEHR_I965));
+			pr_err("  INSTDONE: 0x%08x\n",
 			       I915_READ(INSTDONE_I965));
-			printk(KERN_ERR "  INSTPS: 0x%08x\n",
-			       I915_READ(INSTPS));
-			printk(KERN_ERR "  INSTDONE1: 0x%08x\n",
-			       I915_READ(INSTDONE1));
-			printk(KERN_ERR "  ACTHD: 0x%08x\n",
-			       I915_READ(ACTHD_I965));
+			pr_err("  INSTPS: 0x%08x\n", I915_READ(INSTPS));
+			pr_err("  INSTDONE1: 0x%08x\n", I915_READ(INSTDONE1));
+			pr_err("  ACTHD: 0x%08x\n", I915_READ(ACTHD_I965));
 			I915_WRITE(IPEIR_I965, ipeir);
 			POSTING_READ(IPEIR_I965);
 		}
 		if (eir & GM45_ERROR_PAGE_TABLE) {
 			u32 pgtbl_err = I915_READ(PGTBL_ER);
-			printk(KERN_ERR "page table error\n");
-			printk(KERN_ERR "  PGTBL_ER: 0x%08x\n",
-			       pgtbl_err);
+			pr_err("page table error\n");
+			pr_err("  PGTBL_ER: 0x%08x\n", pgtbl_err);
 			I915_WRITE(PGTBL_ER, pgtbl_err);
 			POSTING_READ(PGTBL_ER);
 		}
@@ -1138,53 +1133,42 @@ static void i915_report_and_clear_eir(struct drm_device *dev)
 	if (!IS_GEN2(dev)) {
 		if (eir & I915_ERROR_PAGE_TABLE) {
 			u32 pgtbl_err = I915_READ(PGTBL_ER);
-			printk(KERN_ERR "page table error\n");
-			printk(KERN_ERR "  PGTBL_ER: 0x%08x\n",
-			       pgtbl_err);
+			pr_err("page table error\n");
+			pr_err("  PGTBL_ER: 0x%08x\n", pgtbl_err);
 			I915_WRITE(PGTBL_ER, pgtbl_err);
 			POSTING_READ(PGTBL_ER);
 		}
 	}
 
 	if (eir & I915_ERROR_MEMORY_REFRESH) {
-		printk(KERN_ERR "memory refresh error:\n");
+		pr_err("memory refresh error:\n");
 		for_each_pipe(pipe)
-			printk(KERN_ERR "pipe %c stat: 0x%08x\n",
+			pr_err("pipe %c stat: 0x%08x\n",
 			       pipe_name(pipe), I915_READ(PIPESTAT(pipe)));
 		/* pipestat has already been acked */
 	}
 	if (eir & I915_ERROR_INSTRUCTION) {
-		printk(KERN_ERR "instruction error\n");
-		printk(KERN_ERR "  INSTPM: 0x%08x\n",
-		       I915_READ(INSTPM));
+		pr_err("instruction error\n");
+		pr_err("  INSTPM: 0x%08x\n", I915_READ(INSTPM));
 		if (INTEL_INFO(dev)->gen < 4) {
 			u32 ipeir = I915_READ(IPEIR);
 
-			printk(KERN_ERR "  IPEIR: 0x%08x\n",
-			       I915_READ(IPEIR));
-			printk(KERN_ERR "  IPEHR: 0x%08x\n",
-			       I915_READ(IPEHR));
-			printk(KERN_ERR "  INSTDONE: 0x%08x\n",
-			       I915_READ(INSTDONE));
-			printk(KERN_ERR "  ACTHD: 0x%08x\n",
-			       I915_READ(ACTHD));
+			pr_err("  IPEIR: 0x%08x\n", I915_READ(IPEIR));
+			pr_err("  IPEHR: 0x%08x\n", I915_READ(IPEHR));
+			pr_err("  INSTDONE: 0x%08x\n", I915_READ(INSTDONE));
+			pr_err("  ACTHD: 0x%08x\n", I915_READ(ACTHD));
 			I915_WRITE(IPEIR, ipeir);
 			POSTING_READ(IPEIR);
 		} else {
 			u32 ipeir = I915_READ(IPEIR_I965);
 
-			printk(KERN_ERR "  IPEIR: 0x%08x\n",
-			       I915_READ(IPEIR_I965));
-			printk(KERN_ERR "  IPEHR: 0x%08x\n",
-			       I915_READ(IPEHR_I965));
-			printk(KERN_ERR "  INSTDONE: 0x%08x\n",
+			pr_err("  IPEIR: 0x%08x\n", I915_READ(IPEIR_I965));
+			pr_err("  IPEHR: 0x%08x\n", I915_READ(IPEHR_I965));
+			pr_err("  INSTDONE: 0x%08x\n",
 			       I915_READ(INSTDONE_I965));
-			printk(KERN_ERR "  INSTPS: 0x%08x\n",
-			       I915_READ(INSTPS));
-			printk(KERN_ERR "  INSTDONE1: 0x%08x\n",
-			       I915_READ(INSTDONE1));
-			printk(KERN_ERR "  ACTHD: 0x%08x\n",
-			       I915_READ(ACTHD_I965));
+			pr_err("  INSTPS: 0x%08x\n", I915_READ(INSTPS));
+			pr_err("  INSTDONE1: 0x%08x\n", I915_READ(INSTDONE1));
+			pr_err("  ACTHD: 0x%08x\n", I915_READ(ACTHD_I965));
 			I915_WRITE(IPEIR_I965, ipeir);
 			POSTING_READ(IPEIR_I965);
 		}
diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index 289140b..34929ae 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -25,6 +25,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/acpi.h>
 #include <linux/acpi_io.h>
 #include <acpi/video.h>
@@ -355,7 +357,7 @@ static void intel_didl_outputs(struct drm_device *dev)
 	}
 
 	if (!acpi_video_bus) {
-		printk(KERN_WARNING "No ACPI video bus found\n");
+		pr_warn("No ACPI video bus found\n");
 		return;
 	}
 
diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
index 230a141..d360df1 100644
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@ -28,6 +28,8 @@
  *      Chris Wilson <chris@chris-wilson.co.uk>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "intel_drv.h"
 
 #define PCI_LBPC 0xf4 /* legacy/combination backlight modes */
@@ -171,7 +173,7 @@ u32 intel_panel_get_max_backlight(struct drm_device *dev)
 		/* XXX add code here to query mode clock or hardware clock
 		 * and program max PWM appropriately.
 		 */
-		printk_once(KERN_WARNING "fixme: max PWM is zero.\n");
+		pr_warn_once("fixme: max PWM is zero\n");
 		return 1;
 	}
 
-- 
1.7.8.111.gad25c.dirty

