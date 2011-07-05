Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab1GEOxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:53:41 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50600 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab1GEOxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:53:39 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 43/49] gma500: move the power header
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:43:53 +0100
Message-ID: <20110705144351.23872.64066.stgit@localhost.localdomain>
In-Reply-To: <20110705141038.23872.55303.stgit@localhost.localdomain>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

At this point we now have the file naming making somewhat more sense
although the dependancies are not as clean as would be ideal

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/backlight.c         |    2 -
 drivers/staging/gma500/mdfld_dsi_dbi.c     |    2 -
 drivers/staging/gma500/mdfld_dsi_dbi.h     |    2 -
 drivers/staging/gma500/mdfld_dsi_output.h  |    2 -
 drivers/staging/gma500/mrst_crtc.c         |    2 -
 drivers/staging/gma500/mrst_lvds.c         |    2 -
 drivers/staging/gma500/power.c             |    2 -
 drivers/staging/gma500/power.h             |   67 ++++++++++++++++++++++++++++
 drivers/staging/gma500/psb_drv.c           |    2 -
 drivers/staging/gma500/psb_drv.h           |    2 -
 drivers/staging/gma500/psb_intel_display.c |    2 -
 drivers/staging/gma500/psb_intel_lvds.c    |    2 -
 drivers/staging/gma500/psb_irq.c           |    2 -
 drivers/staging/gma500/psb_powermgmt.h     |   67 ----------------------------
 14 files changed, 79 insertions(+), 79 deletions(-)
 create mode 100644 drivers/staging/gma500/power.h
 delete mode 100644 drivers/staging/gma500/psb_powermgmt.h

diff --git a/drivers/staging/gma500/backlight.c b/drivers/staging/gma500/backlight.c
index 117649b..4027e70 100644
--- a/drivers/staging/gma500/backlight.c
+++ b/drivers/staging/gma500/backlight.c
@@ -24,7 +24,7 @@
 #include "psb_intel_reg.h"
 #include "psb_intel_drv.h"
 #include "intel_bios.h"
-#include "psb_powermgmt.h"
+#include "power.h"
 
 int gma_backlight_init(struct drm_device *dev)
 {
diff --git a/drivers/staging/gma500/mdfld_dsi_dbi.c b/drivers/staging/gma500/mdfld_dsi_dbi.c
index 15055c8..9d2d97d 100644
--- a/drivers/staging/gma500/mdfld_dsi_dbi.c
+++ b/drivers/staging/gma500/mdfld_dsi_dbi.c
@@ -29,7 +29,7 @@
 #include "mdfld_dsi_dbi_dpu.h"
 #include "mdfld_dsi_pkg_sender.h"
 
-#include "psb_powermgmt.h"
+#include "power.h"
 #include <linux/pm_runtime.h>
 
 int enable_gfx_rtpm;
diff --git a/drivers/staging/gma500/mdfld_dsi_dbi.h b/drivers/staging/gma500/mdfld_dsi_dbi.h
index 5b04951..a76813e 100644
--- a/drivers/staging/gma500/mdfld_dsi_dbi.h
+++ b/drivers/staging/gma500/mdfld_dsi_dbi.h
@@ -38,7 +38,7 @@
 #include "psb_drv.h"
 #include "psb_intel_drv.h"
 #include "psb_intel_reg.h"
-#include "psb_powermgmt.h"
+#include "power.h"
 
 #include "mdfld_dsi_output.h"
 #include "mdfld_output.h"
diff --git a/drivers/staging/gma500/mdfld_dsi_output.h b/drivers/staging/gma500/mdfld_dsi_output.h
index ac25e55..0bf00ea 100644
--- a/drivers/staging/gma500/mdfld_dsi_output.h
+++ b/drivers/staging/gma500/mdfld_dsi_output.h
@@ -38,7 +38,7 @@
 #include "psb_drv.h"
 #include "psb_intel_drv.h"
 #include "psb_intel_reg.h"
-#include "psb_powermgmt.h"
+#include "power.h"
 #include "mdfld_output.h"
 
 #include <asm/mrst.h>
diff --git a/drivers/staging/gma500/mrst_crtc.c b/drivers/staging/gma500/mrst_crtc.c
index d12d1a6..72464dd 100644
--- a/drivers/staging/gma500/mrst_crtc.c
+++ b/drivers/staging/gma500/mrst_crtc.c
@@ -24,7 +24,7 @@
 #include "psb_intel_drv.h"
 #include "psb_intel_reg.h"
 #include "psb_intel_display.h"
-#include "psb_powermgmt.h"
+#include "power.h"
 
 struct psb_intel_range_t {
 	int min, max;
diff --git a/drivers/staging/gma500/mrst_lvds.c b/drivers/staging/gma500/mrst_lvds.c
index 9ecb99b..127b200 100644
--- a/drivers/staging/gma500/mrst_lvds.c
+++ b/drivers/staging/gma500/mrst_lvds.c
@@ -28,7 +28,7 @@
 #include "psb_drv.h"
 #include "psb_intel_drv.h"
 #include "psb_intel_reg.h"
-#include "psb_powermgmt.h"
+#include "power.h"
 #include <linux/pm_runtime.h>
 
 /* The max/min PWM frequency in BPCR[31:17] - */
diff --git a/drivers/staging/gma500/power.c b/drivers/staging/gma500/power.c
index 0eee7fb..79eb670 100644
--- a/drivers/staging/gma500/power.c
+++ b/drivers/staging/gma500/power.c
@@ -28,7 +28,7 @@
  *    Alan Cox <alan@linux.intel.com>
  */
 
-#include "psb_powermgmt.h"
+#include "power.h"
 #include "psb_drv.h"
 #include "psb_reg.h"
 #include "psb_intel_reg.h"
diff --git a/drivers/staging/gma500/power.h b/drivers/staging/gma500/power.h
new file mode 100644
index 0000000..333b28d
--- /dev/null
+++ b/drivers/staging/gma500/power.h
@@ -0,0 +1,67 @@
+/**************************************************************************
+ * Copyright (c) 2009-2011, Intel Corporation.
+ * All Rights Reserved.
+
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the next
+ * paragraph) shall be included in all copies or substantial portions of the
+ * Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
+ * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ *
+ * Authors:
+ *    Benjamin Defnet <benjamin.r.defnet@intel.com>
+ *    Rajesh Poornachandran <rajesh.poornachandran@intel.com>
+ * Massively reworked
+ *    Alan Cox <alan@linux.intel.com>
+ */
+#ifndef _PSB_POWERMGMT_H_
+#define _PSB_POWERMGMT_H_
+
+#include <linux/pci.h>
+#include <drm/drmP.h>
+
+void gma_power_init(struct drm_device *dev);
+void gma_power_uninit(struct drm_device *dev);
+
+/*
+ * The kernel bus power management  will call these functions
+ */
+int gma_power_suspend(struct pci_dev *pdev, pm_message_t state);
+int gma_power_resume(struct pci_dev *pdev);
+
+/*
+ * These are the functions the driver should use to wrap all hw access
+ * (i.e. register reads and writes)
+ */
+bool gma_power_begin(struct drm_device *dev, bool force);
+void gma_power_end(struct drm_device *dev);
+
+/*
+ * Use this function to do an instantaneous check for if the hw is on.
+ * Only use this in cases where you know the mutex is already held such
+ * as in irq install/uninstall and you need to
+ * prevent a deadlock situation.  Otherwise use gma_power_begin().
+ */
+bool gma_power_is_on(struct drm_device *dev);
+
+/*
+ * GFX-Runtime PM callbacks
+ */
+int psb_runtime_suspend(struct device *dev);
+int psb_runtime_resume(struct device *dev);
+int psb_runtime_idle(struct device *dev);
+
+#endif /*_PSB_POWERMGMT_H_*/
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index a7f3c08..264fdf4 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -30,7 +30,7 @@
 #include "mid_bios.h"
 #include "mdfld_dsi_dbi.h"
 #include <drm/drm_pciids.h>
-#include "psb_powermgmt.h"
+#include "power.h"
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 #include <linux/spinlock.h>
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index ee782fa..9e4f361 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -30,7 +30,7 @@
 #include "psb_reg.h"
 #include "psb_intel_drv.h"
 #include "gtt.h"
-#include "psb_powermgmt.h"
+#include "power.h"
 #include "mrst.h"
 
 /* Append new drm mode definition here, align with libdrm definition */
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index 0b650a0..8f503d9 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -27,7 +27,7 @@
 #include "psb_intel_drv.h"
 #include "psb_intel_reg.h"
 #include "psb_intel_display.h"
-#include "psb_powermgmt.h"
+#include "power.h"
 
 #include "mdfld_output.h"
 
diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index c9a13a4..4a0d234 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -27,7 +27,7 @@
 #include "psb_drv.h"
 #include "psb_intel_drv.h"
 #include "psb_intel_reg.h"
-#include "psb_powermgmt.h"
+#include "power.h"
 #include <linux/pm_runtime.h>
 
 u32 CoreClock;
diff --git a/drivers/staging/gma500/psb_irq.c b/drivers/staging/gma500/psb_irq.c
index 8fc7070..4a0fa42 100644
--- a/drivers/staging/gma500/psb_irq.c
+++ b/drivers/staging/gma500/psb_irq.c
@@ -26,7 +26,7 @@
 #include "psb_drv.h"
 #include "psb_reg.h"
 #include "psb_intel_reg.h"
-#include "psb_powermgmt.h"
+#include "power.h"
 #include "mdfld_output.h"
 
 /*
diff --git a/drivers/staging/gma500/psb_powermgmt.h b/drivers/staging/gma500/psb_powermgmt.h
deleted file mode 100644
index 333b28d..0000000
--- a/drivers/staging/gma500/psb_powermgmt.h
+++ /dev/null
@@ -1,67 +0,0 @@
-/**************************************************************************
- * Copyright (c) 2009-2011, Intel Corporation.
- * All Rights Reserved.
-
- * Permission is hereby granted, free of charge, to any person obtaining a
- * copy of this software and associated documentation files (the "Software"),
- * to deal in the Software without restriction, including without limitation
- * the rights to use, copy, modify, merge, publish, distribute, sublicense,
- * and/or sell copies of the Software, and to permit persons to whom the
- * Software is furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice (including the next
- * paragraph) shall be included in all copies or substantial portions of the
- * Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
- * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
- * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
- * Authors:
- *    Benjamin Defnet <benjamin.r.defnet@intel.com>
- *    Rajesh Poornachandran <rajesh.poornachandran@intel.com>
- * Massively reworked
- *    Alan Cox <alan@linux.intel.com>
- */
-#ifndef _PSB_POWERMGMT_H_
-#define _PSB_POWERMGMT_H_
-
-#include <linux/pci.h>
-#include <drm/drmP.h>
-
-void gma_power_init(struct drm_device *dev);
-void gma_power_uninit(struct drm_device *dev);
-
-/*
- * The kernel bus power management  will call these functions
- */
-int gma_power_suspend(struct pci_dev *pdev, pm_message_t state);
-int gma_power_resume(struct pci_dev *pdev);
-
-/*
- * These are the functions the driver should use to wrap all hw access
- * (i.e. register reads and writes)
- */
-bool gma_power_begin(struct drm_device *dev, bool force);
-void gma_power_end(struct drm_device *dev);
-
-/*
- * Use this function to do an instantaneous check for if the hw is on.
- * Only use this in cases where you know the mutex is already held such
- * as in irq install/uninstall and you need to
- * prevent a deadlock situation.  Otherwise use gma_power_begin().
- */
-bool gma_power_is_on(struct drm_device *dev);
-
-/*
- * GFX-Runtime PM callbacks
- */
-int psb_runtime_suspend(struct device *dev);
-int psb_runtime_resume(struct device *dev);
-int psb_runtime_idle(struct device *dev);
-
-#endif /*_PSB_POWERMGMT_H_*/

