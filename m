Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab1F1WIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:08:15 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40994 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab1F1WHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:07:46 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 18/29] gma500: Medfield support
To: linux-kernel@vger.kernel.org, greg@kroah.com
Date: Tue, 28 Jun 2011 23:07:17 +0100
Message-ID: <20110628220715.898.58831.stgit@bob.linux.org.uk>
In-Reply-To: <20110628220151.898.15775.stgit@bob.linux.org.uk>
References: <20110628220151.898.15775.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This large patch adds all the basics for Medfield support. Lots of clean up
needed in this area still.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Makefile               |   12 
 drivers/staging/gma500/displays/hdmi.h        |   33 +
 drivers/staging/gma500/displays/pyr_cmd.h     |   34 +
 drivers/staging/gma500/displays/pyr_vid.h     |   34 +
 drivers/staging/gma500/displays/tmd_cmd.h     |   34 +
 drivers/staging/gma500/displays/tmd_vid.h     |   34 +
 drivers/staging/gma500/displays/tpo_cmd.h     |   35 +
 drivers/staging/gma500/displays/tpo_vid.h     |   33 +
 drivers/staging/gma500/mdfld_dsi_dbi.c        |  872 ++++++++++++++++
 drivers/staging/gma500/mdfld_dsi_dbi.h        |  188 +++
 drivers/staging/gma500/mdfld_dsi_dbi_dpu.h    |  157 +++
 drivers/staging/gma500/mdfld_dsi_dpi.c        |  991 ++++++++++++++++++
 drivers/staging/gma500/mdfld_dsi_dpi.h        |   80 +
 drivers/staging/gma500/mdfld_dsi_output.c     |  977 ++++++++++++++++++
 drivers/staging/gma500/mdfld_dsi_output.h     |  328 ++++++
 drivers/staging/gma500/mdfld_dsi_pkg_sender.c | 1097 ++++++++++++++++++++
 drivers/staging/gma500/mdfld_dsi_pkg_sender.h |  158 +++
 drivers/staging/gma500/mdfld_intel_display.c  | 1388 +++++++++++++++++++++++++
 drivers/staging/gma500/mdfld_msic.h           |   31 +
 drivers/staging/gma500/mdfld_output.c         |  135 ++
 drivers/staging/gma500/mdfld_output.h         |   77 +
 drivers/staging/gma500/mdfld_pyr_cmd.c        |  575 ++++++++++
 drivers/staging/gma500/mdfld_tmd_vid.c        |  144 +++
 drivers/staging/gma500/mdfld_tpo_cmd.c        |  495 +++++++++
 drivers/staging/gma500/mdfld_tpo_vid.c        |  140 +++
 drivers/staging/gma500/psb_bl.c               |   68 +
 drivers/staging/gma500/psb_drm.h              |    7 
 drivers/staging/gma500/psb_drv.c              |   25 
 drivers/staging/gma500/psb_drv.h              |  132 ++
 drivers/staging/gma500/psb_fb.c               |   28 -
 drivers/staging/gma500/psb_intel_display.c    |   18 
 drivers/staging/gma500/psb_intel_display.h    |    3 
 drivers/staging/gma500/psb_intel_drv.h        |    3 
 drivers/staging/gma500/psb_intel_lvds.c       |    1 
 drivers/staging/gma500/psb_irq.c              |   61 +
 drivers/staging/gma500/psb_powermgmt.c        |  626 +++++++++++
 36 files changed, 9005 insertions(+), 49 deletions(-)
 create mode 100644 drivers/staging/gma500/displays/hdmi.h
 create mode 100644 drivers/staging/gma500/displays/pyr_cmd.h
 create mode 100644 drivers/staging/gma500/displays/pyr_vid.h
 create mode 100644 drivers/staging/gma500/displays/tmd_cmd.h
 create mode 100644 drivers/staging/gma500/displays/tmd_vid.h
 create mode 100644 drivers/staging/gma500/displays/tpo_cmd.h
 create mode 100644 drivers/staging/gma500/displays/tpo_vid.h
 create mode 100644 drivers/staging/gma500/mdfld_dsi_dbi.c
 create mode 100644 drivers/staging/gma500/mdfld_dsi_dbi.h
 create mode 100644 drivers/staging/gma500/mdfld_dsi_dbi_dpu.h
 create mode 100644 drivers/staging/gma500/mdfld_dsi_dpi.c
 create mode 100644 drivers/staging/gma500/mdfld_dsi_dpi.h
 create mode 100644 drivers/staging/gma500/mdfld_dsi_output.c
 create mode 100644 drivers/staging/gma500/mdfld_dsi_output.h
 create mode 100644 drivers/staging/gma500/mdfld_dsi_pkg_sender.c
 create mode 100644 drivers/staging/gma500/mdfld_dsi_pkg_sender.h
 create mode 100644 drivers/staging/gma500/mdfld_intel_display.c
 create mode 100644 drivers/staging/gma500/mdfld_msic.h
 create mode 100644 drivers/staging/gma500/mdfld_output.c
 create mode 100644 drivers/staging/gma500/mdfld_output.h
 create mode 100644 drivers/staging/gma500/mdfld_pyr_cmd.c
 create mode 100644 drivers/staging/gma500/mdfld_tmd_vid.c
 create mode 100644 drivers/staging/gma500/mdfld_tpo_cmd.c
 create mode 100644 drivers/staging/gma500/mdfld_tpo_vid.c


diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index 01aaa28..4c9c475 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -22,6 +22,16 @@ psb_gfx-y += gem_glue.o \
 	  psb_powermgmt.o \
 	  psb_irq.o \
 	  mrst_crtc.o \
-	  mrst_lvds.o
+	  mrst_lvds.o \
+	  mdfld_output.o \
+	  mdfld_pyr_cmd.o \
+	  mdfld_tmd_vid.o \
+	  mdfld_tpo_cmd.o \
+	  mdfld_tpo_vid.o \
+	  mdfld_dsi_pkg_sender.o \
+	  mdfld_dsi_dpi.o \
+	  mdfld_dsi_output.o \
+	  mdfld_dsi_dbi.o \
+	  mdfld_intel_display.o
 
 obj-$(CONFIG_DRM_PSB) += psb_gfx.o
diff --git a/drivers/staging/gma500/displays/hdmi.h b/drivers/staging/gma500/displays/hdmi.h
new file mode 100644
index 0000000..d58ba9b
--- /dev/null
+++ b/drivers/staging/gma500/displays/hdmi.h
@@ -0,0 +1,33 @@
+/*
+ * Copyright (c)  2010 Intel Corporation
+ *
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * Thomas Eaton <thomas.g.eaton@intel.com>
+ * Scott Rowe <scott.m.rowe@intel.com>
+ */
+
+#ifndef HDMI_H
+#define HDMI_H
+
+extern void hdmi_init(struct drm_device *dev);
+
+#endif
diff --git a/drivers/staging/gma500/displays/pyr_cmd.h b/drivers/staging/gma500/displays/pyr_cmd.h
new file mode 100644
index 0000000..84bae5c
--- /dev/null
+++ b/drivers/staging/gma500/displays/pyr_cmd.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (c)  2010 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicensen
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * Thomas Eaton <thomas.g.eaton@intel.com>
+ * Scott Rowe <scott.m.rowe@intel.com>
+ */
+
+#ifndef PYR_CMD_H
+#define PYR_CMD_H
+
+extern void pyr_cmd_init(struct drm_device *dev, struct panel_funcs *p_funcs);
+
+#endif
+
diff --git a/drivers/staging/gma500/displays/pyr_vid.h b/drivers/staging/gma500/displays/pyr_vid.h
new file mode 100644
index 0000000..ce98860
--- /dev/null
+++ b/drivers/staging/gma500/displays/pyr_vid.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (c)  2010 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicensen
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * Thomas Eaton <thomas.g.eaton@intel.com>
+ * Scott Rowe <scott.m.rowe@intel.com>
+*/
+
+#ifndef PYR_VID_H
+#define PYR_VID_H
+
+extern void pyr_vid_init(struct drm_device *dev, struct panel_funcs *p_funcs);
+extern struct drm_display_mode *pyr_vid_get_config_mode(struct drm_device* dev);
+
+#endif
diff --git a/drivers/staging/gma500/displays/tmd_cmd.h b/drivers/staging/gma500/displays/tmd_cmd.h
new file mode 100644
index 0000000..641e85e
--- /dev/null
+++ b/drivers/staging/gma500/displays/tmd_cmd.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (c)  2010 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicensen
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * Thomas Eaton <thomas.g.eaton@intel.com>
+ * Scott Rowe <scott.m.rowe@intel.com>
+ */
+
+#ifndef TMD_CMD_H
+#define TMD_CMD_H
+
+extern void tmd_cmd_init(struct drm_device *dev, struct panel_funcs *p_funcs);
+extern struct drm_display_mode *tmd_cmd_get_config_mode(struct drm_device *dev);
+
+#endif
diff --git a/drivers/staging/gma500/displays/tmd_vid.h b/drivers/staging/gma500/displays/tmd_vid.h
new file mode 100644
index 0000000..7a5fa3b
--- /dev/null
+++ b/drivers/staging/gma500/displays/tmd_vid.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright (c)  2010 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicensen
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * Thomas Eaton <thomas.g.eaton@intel.com>
+ * Scott Rowe <scott.m.rowe@intel.com>
+*/
+
+#ifndef TMD_VID_H
+#define TMD_VID_H
+
+extern void tmd_vid_init(struct drm_device *dev, struct panel_funcs *p_funcs);
+extern struct drm_display_mode *tmd_vid_get_config_mode(struct drm_device *dev);
+
+#endif
diff --git a/drivers/staging/gma500/displays/tpo_cmd.h b/drivers/staging/gma500/displays/tpo_cmd.h
new file mode 100644
index 0000000..6105527
--- /dev/null
+++ b/drivers/staging/gma500/displays/tpo_cmd.h
@@ -0,0 +1,35 @@
+/*
+ * Copyright (c)  2010 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicensen
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * Thomas Eaton <thomas.g.eaton@intel.com>
+ * Scott Rowe <scott.m.rowe@intel.com>
+*/
+
+#ifndef TPO_CMD_H
+#define TPO_CMD_H
+
+extern void tpo_cmd_init(struct drm_device *dev, struct panel_funcs *p_funcs);
+/* extern struct drm_display_mode * */
+/* tpo_cmd_get_config_mode(struct drm_device *dev); */
+
+#endif
diff --git a/drivers/staging/gma500/displays/tpo_vid.h b/drivers/staging/gma500/displays/tpo_vid.h
new file mode 100644
index 0000000..c24f057
--- /dev/null
+++ b/drivers/staging/gma500/displays/tpo_vid.h
@@ -0,0 +1,33 @@
+/*
+ * Copyright (c)  2010 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicensen
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * Thomas Eaton <thomas.g.eaton@intel.com>
+ * Scott Rowe <scott.m.rowe@intel.com>
+ */
+
+#ifndef TPO_VID_H
+#define TPO_VID_H
+
+extern void tpo_vid_init(struct drm_device *dev, struct panel_funcs *p_funcs);
+
+#endif
diff --git a/drivers/staging/gma500/mdfld_dsi_dbi.c b/drivers/staging/gma500/mdfld_dsi_dbi.c
new file mode 100644
index 0000000..15055c8
--- /dev/null
+++ b/drivers/staging/gma500/mdfld_dsi_dbi.c
@@ -0,0 +1,872 @@
+/*
+ * Copyright © 2010 Intel Corporation
+ *
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ *  jim liu <jim.liu@intel.com>
+ *  Jackie Li<yaodong.li@intel.com>
+ */
+
+#include "mdfld_dsi_dbi.h"
+#include "mdfld_dsi_dbi_dpu.h"
+#include "mdfld_dsi_pkg_sender.h"
+
+#include "psb_powermgmt.h"
+#include <linux/pm_runtime.h>
+
+int enable_gfx_rtpm;
+
+extern struct drm_device *gpDrmDevice;
+extern int gfxrtdelay;
+int enter_dsr;
+struct mdfld_dsi_dbi_output *gdbi_output;
+extern bool gbgfxsuspended;
+extern int gfxrtdelay;
+
+#ifdef CONFIG_GFX_RTPM
+static void psb_runtimepm_wq_handler(struct work_struct *work);
+DECLARE_DELAYED_WORK(rtpm_work, psb_runtimepm_wq_handler);
+
+void psb_runtimepm_wq_handler(struct work_struct *work)
+{
+	struct drm_psb_private *dev_priv =  gpDrmDevice->dev_private;
+
+	if (drm_psb_ospm && !enable_gfx_rtpm) {
+		pr_info("Enable GFX runtime_pm\n");
+		dev_priv->rpm_enabled = 1;
+		enable_gfx_rtpm = 1;
+
+		pm_runtime_enable(&gpDrmDevice->pdev->dev);
+		pm_runtime_set_active(&gpDrmDevice->pdev->dev);
+
+		pm_runtime_allow(&gpDrmDevice->pdev->dev);
+	}
+}
+#endif
+
+
+/*
+ * set refreshing area
+ */
+int mdfld_dsi_dbi_update_area(struct mdfld_dsi_dbi_output *dbi_output,
+				u16 x1, u16 y1, u16 x2, u16 y2)
+{
+	struct mdfld_dsi_pkg_sender *sender =
+		mdfld_dsi_encoder_get_pkg_sender(&dbi_output->base);
+	u8 param[4];
+	u8 cmd;
+	int err;
+
+	if (!sender) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	/*set column*/
+	cmd = set_column_address;
+	param[0] = x1 >> 8;
+	param[1] = x1;
+	param[2] = x2 >> 8;
+	param[3] = x2;
+
+	err = mdfld_dsi_send_dcs(sender,
+				 cmd,
+				 param,
+				 4,
+				 CMD_DATA_SRC_SYSTEM_MEM,
+				 MDFLD_DSI_QUEUE_PACKAGE);
+	if (err) {
+		dev_err(sender->dev->dev, "DCS 0x%x sent failed\n", cmd);
+		goto err_out;
+	}
+
+	/*set page*/
+	cmd = set_page_addr;
+	param[0] = y1 >> 8;
+	param[1] = y1;
+	param[2] = y2 >> 8;
+	param[3] = y2;
+
+	err = mdfld_dsi_send_dcs(sender,
+				 cmd,
+				 param,
+				 4,
+				 CMD_DATA_SRC_SYSTEM_MEM,
+				 MDFLD_DSI_QUEUE_PACKAGE);
+	if (err) {
+		dev_err(sender->dev->dev, "DCS 0x%x sent failed\n", cmd);
+		goto err_out;
+	}
+
+	/*update screen*/
+	err = mdfld_dsi_send_dcs(sender,
+				 write_mem_start,
+				 NULL,
+				 0,
+				 CMD_DATA_SRC_PIPE,
+				 MDFLD_DSI_QUEUE_PACKAGE);
+	if (err) {
+		dev_err(sender->dev->dev, "DCS 0x%x sent failed\n", cmd);
+		goto err_out;
+	}
+	mdfld_dsi_cmds_kick_out(sender);
+err_out:
+	return err;
+}
+
+/*
+ * set panel's power state
+ */
+int mdfld_dsi_dbi_update_power(struct mdfld_dsi_dbi_output *dbi_output,
+								int mode)
+{
+	struct drm_device *dev = dbi_output->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mdfld_dsi_pkg_sender *sender =
+		mdfld_dsi_encoder_get_pkg_sender(&dbi_output->base);
+	u8 param = 0;
+	u32 err = 0;
+
+	if (!dev_priv->dispstatus && mode != DRM_MODE_DPMS_ON) {
+		dev_err(dev->dev, "%s: already OFF ignoring\n", __func__);
+		return 0;
+	}
+	if (dev_priv->dispstatus && mode == DRM_MODE_DPMS_ON) {
+		dev_err(dev->dev, "%s: already ON ignoring\n", __func__);
+		return 0;
+	}
+
+	if (!sender) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	if (mode == DRM_MODE_DPMS_ON) {
+		/*exit sleep mode*/
+		err = mdfld_dsi_send_dcs(sender,
+					 exit_sleep_mode,
+					 NULL,
+					 0,
+					 CMD_DATA_SRC_SYSTEM_MEM,
+					 MDFLD_DSI_QUEUE_PACKAGE);
+		if (err) {
+			dev_err(dev->dev, "DCS 0x%x sent failed\n",
+						exit_sleep_mode);
+			goto power_err;
+		}
+
+		/*set display on*/
+		err = mdfld_dsi_send_dcs(sender,
+					 set_display_on,
+					 NULL,
+					 0,
+					 CMD_DATA_SRC_SYSTEM_MEM,
+					 MDFLD_DSI_QUEUE_PACKAGE);
+		if (err) {
+			dev_err(dev->dev, "DCS 0x%x sent failed\n",
+							set_display_on);
+			goto power_err;
+		}
+
+		/* set tear effect on */
+		err = mdfld_dsi_send_dcs(sender,
+					 set_tear_on,
+					 &param,
+					 1,
+					 CMD_DATA_SRC_SYSTEM_MEM,
+					 MDFLD_DSI_QUEUE_PACKAGE);
+		if (err) {
+			dev_err(dev->dev, "DCS 0x%x sent failed\n",
+							set_tear_on);
+			goto power_err;
+		}
+
+		/**
+		 * FIXME: remove this later
+		 */
+		err = mdfld_dsi_send_dcs(sender,
+					 write_mem_start,
+					 NULL,
+					 0,
+					 CMD_DATA_SRC_PIPE,
+					 MDFLD_DSI_QUEUE_PACKAGE);
+		if (err) {
+			dev_err(dev->dev, "DCS 0x%x sent failed\n",
+							set_display_on);
+			goto power_err;
+		}
+	} else {
+		/*set tear effect off */
+		err = mdfld_dsi_send_dcs(sender,
+					 set_tear_off,
+					 NULL,
+					 0,
+					 CMD_DATA_SRC_SYSTEM_MEM,
+					 MDFLD_DSI_QUEUE_PACKAGE);
+		if (err) {
+			dev_err(dev->dev, "DCS 0x%x sent failed\n",
+							set_tear_off);
+			goto power_err;
+		}
+
+		/*set display off*/
+		err = mdfld_dsi_send_dcs(sender,
+					 set_display_off,
+					 NULL,
+					 0,
+					 CMD_DATA_SRC_SYSTEM_MEM,
+					 MDFLD_DSI_QUEUE_PACKAGE);
+		if (err) {
+			dev_err(dev->dev, "DCS 0x%x sent failed\n",
+							set_display_off);
+			goto power_err;
+		}
+
+		/*enter sleep mode*/
+		err = mdfld_dsi_send_dcs(sender,
+					 enter_sleep_mode,
+					 NULL,
+					 0,
+					 CMD_DATA_SRC_SYSTEM_MEM,
+					 MDFLD_DSI_QUEUE_PACKAGE);
+		if (err) {
+			dev_err(dev->dev, "DCS 0x%x sent failed\n",
+							enter_sleep_mode);
+			goto power_err;
+		}
+	}
+	mdfld_dsi_cmds_kick_out(sender);
+power_err:
+	return err;
+}
+
+/*
+ * send a generic DCS command with a parameter list
+ */
+int mdfld_dsi_dbi_send_dcs(struct mdfld_dsi_dbi_output *dbi_output,
+			u8 dcs,  u8 *param, u32 num, u8 data_src)
+{
+	struct mdfld_dsi_pkg_sender *sender =
+		mdfld_dsi_encoder_get_pkg_sender(&dbi_output->base);
+	int ret;
+
+	if (!sender) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	ret = mdfld_dsi_send_dcs(sender,
+				 dcs,
+				 param,
+				 num,
+				 data_src,
+				 MDFLD_DSI_SEND_PACKAGE);
+
+	return ret;
+}
+
+
+/*
+ * Enter DSR
+ */
+void mdfld_dsi_dbi_enter_dsr(struct mdfld_dsi_dbi_output *dbi_output, int pipe)
+{
+	u32 reg_val;
+	struct drm_device *dev = dbi_output->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct drm_crtc *crtc = dbi_output->base.base.crtc;
+	struct psb_intel_crtc *psb_crtc = (crtc) ?
+					to_psb_intel_crtc(crtc) : NULL;
+	u32 dpll_reg = MRST_DPLL_A;
+	u32 pipeconf_reg = PIPEACONF;
+	u32 dspcntr_reg = DSPACNTR;
+
+	dev_priv->is_in_idle = true;
+
+	if (!dbi_output)
+		return;
+
+	gdbi_output = dbi_output;
+	if ((dbi_output->mode_flags & MODE_SETTING_ON_GOING) ||
+		(psb_crtc && psb_crtc->mode_flags & MODE_SETTING_ON_GOING))
+		return;
+
+	if (pipe == 2) {
+		dpll_reg = MRST_DPLL_A;
+		pipeconf_reg = PIPECCONF;
+		dspcntr_reg = DSPCCNTR;
+	}
+
+	if (!gma_power_begin(dev, true)) {
+		dev_err(dev->dev, "hw begin failed\n");
+		return;
+	}
+	/*disable te interrupts. */
+	mdfld_disable_te(dev, pipe);
+
+	/*disable plane*/
+	reg_val = REG_READ(dspcntr_reg);
+	if (!(reg_val & DISPLAY_PLANE_ENABLE)) {
+		REG_WRITE(dspcntr_reg, reg_val & ~DISPLAY_PLANE_ENABLE);
+		REG_READ(dspcntr_reg);
+	}
+	/*disable pipe*/
+	reg_val = REG_READ(pipeconf_reg);
+	if (!(reg_val & DISPLAY_PLANE_ENABLE)) {
+		reg_val &= ~DISPLAY_PLANE_ENABLE;
+		reg_val |= (PIPECONF_PLANE_OFF | PIPECONF_CURSOR_OFF);
+		REG_WRITE(pipeconf_reg, reg_val);
+		REG_READ(pipeconf_reg);
+		mdfldWaitForPipeDisable(dev, pipe);
+	}
+
+	/*disable DPLL*/
+	reg_val = REG_READ(dpll_reg);
+	if (!(reg_val & DPLL_VCO_ENABLE)) {
+		reg_val &= ~DPLL_VCO_ENABLE;
+		REG_WRITE(dpll_reg, reg_val);
+		REG_READ(dpll_reg);
+		udelay(500);
+	}
+
+	gma_power_end(dev);
+	dbi_output->mode_flags |= MODE_SETTING_IN_DSR;
+	if (pipe == 2) {
+		enter_dsr = 1;
+		/* pm_schedule_suspend(&dev->pdev->dev, gfxrtdelay); */
+	}
+}
+
+#ifndef CONFIG_MDFLD_DSI_DPU
+static void mdfld_dbi_output_exit_dsr(struct mdfld_dsi_dbi_output *dbi_output,
+			int pipe, void *p_surfaceAddr, bool check_hw_on_only)
+{
+	struct drm_device *dev = dbi_output->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct drm_crtc *crtc = dbi_output->base.base.crtc;
+	struct psb_intel_crtc *psb_crtc = (crtc) ?
+					to_psb_intel_crtc(crtc) : NULL;
+	u32 reg_val;
+	u32 dpll_reg = MRST_DPLL_A;
+	u32 pipeconf_reg = PIPEACONF;
+	u32 dspcntr_reg = DSPACNTR;
+	u32 dspsurf_reg = DSPASURF;
+	u32 reg_offset = 0;
+
+	/*if mode setting on-going, back off*/
+	if ((dbi_output->mode_flags & MODE_SETTING_ON_GOING) ||
+		(psb_crtc && psb_crtc->mode_flags & MODE_SETTING_ON_GOING))
+		return;
+
+	if (pipe == 2) {
+		dpll_reg = MRST_DPLL_A;
+		pipeconf_reg = PIPECCONF;
+		dspcntr_reg = DSPCCNTR;
+		dspsurf_reg = DSPCSURF;
+		reg_offset = MIPIC_REG_OFFSET;
+	}
+
+	if (check_hw_on_only) {
+		if (0/* FIXME!ospm_power_is_hw_on(_DISPLAY_ISLAND)*/) {
+			dev_err(dev->dev, "hw begin failed\n");
+			return;
+		}
+	} else if (!gma_power_begin(dev, true)) {
+		dev_err(dev->dev, "hw begin failed\n");
+		return;
+	}
+
+	/*enable DPLL*/
+	reg_val = REG_READ(dpll_reg);
+	if (!(reg_val & DPLL_VCO_ENABLE)) {
+
+		if (reg_val & MDFLD_PWR_GATE_EN) {
+			reg_val &= ~MDFLD_PWR_GATE_EN;
+			REG_WRITE(dpll_reg, reg_val);
+			REG_READ(dpll_reg);
+			udelay(500);
+		}
+
+		reg_val |= DPLL_VCO_ENABLE;
+		REG_WRITE(dpll_reg, reg_val);
+		REG_READ(dpll_reg);
+		udelay(500);
+
+		/* Add timeout */
+		while (!(REG_READ(pipeconf_reg) & PIPECONF_DSIPLL_LOCK))
+			cpu_relax();
+	}
+
+	/*enable pipe*/
+	reg_val = REG_READ(pipeconf_reg);
+	if (!(reg_val & PIPEACONF_ENABLE)) {
+		reg_val |= PIPEACONF_ENABLE;
+		REG_WRITE(pipeconf_reg, reg_val);
+		REG_READ(pipeconf_reg);
+		udelay(500);
+		mdfldWaitForPipeEnable(dev, pipe);
+	}
+
+	/*enable plane*/
+	reg_val = REG_READ(dspcntr_reg);
+	if (!(reg_val & DISPLAY_PLANE_ENABLE)) {
+		reg_val |= DISPLAY_PLANE_ENABLE;
+		REG_WRITE(dspcntr_reg, reg_val);
+		REG_READ(dspcntr_reg);
+		udelay(500);
+	}
+
+	/* update the surface base address. */
+	if (p_surfaceAddr)
+		REG_WRITE(dspsurf_reg, *((u32 *)p_surfaceAddr));
+
+	if (!check_hw_on_only)
+		gma_power_end(dev);
+
+	/*enable TE interrupt on this pipe*/
+	mdfld_enable_te(dev, pipe);
+
+	/*clean IN_DSR flag*/
+	dbi_output->mode_flags &= ~MODE_SETTING_IN_DSR;
+}
+
+/*
+ * Exit from DSR
+ */
+void mdfld_dsi_dbi_exit_dsr(struct drm_device *dev, u32 update_src,
+				void *p_surfaceAddr, bool check_hw_on_only)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mdfld_dbi_dsr_info *dsr_info = dev_priv->dbi_dsr_info;
+	struct mdfld_dsi_dbi_output **dbi_output;
+	int i;
+
+	dev_priv->is_in_idle = false;
+	dbi_output = dsr_info->dbi_outputs;
+
+#ifdef CONFIG_PM_RUNTIME
+	 if (!enable_gfx_rtpm) {
+/*                pm_runtime_allow(&gpDrmDevice->pdev->dev); */
+/*		schedule_delayed_work(&rtpm_work, 120 * 1000); */
+	}
+#endif
+
+	/*for each output, exit dsr*/
+	for (i = 0; i < dsr_info->dbi_output_num; i++) {
+		/*if panel has been turned off, skip*/
+		if (!dbi_output[i]->dbi_panel_on)
+			continue;
+		if (dbi_output[i]->mode_flags & MODE_SETTING_IN_DSR) {
+			enter_dsr = 0;
+			mdfld_dbi_output_exit_dsr(dbi_output[i], dbi_output[i]->channel_num ? 2 : 0, p_surfaceAddr, check_hw_on_only);
+		}
+	}
+	dev_priv->dsr_fb_update |= update_src;
+}
+
+static bool mdfld_dbi_is_in_dsr(struct drm_device *dev)
+{
+	if (REG_READ(MRST_DPLL_A) & DPLL_VCO_ENABLE)
+		return false;
+	if ((REG_READ(PIPEACONF) & PIPEACONF_ENABLE) ||
+	   (REG_READ(PIPECCONF) & PIPEACONF_ENABLE))
+		return false;
+	if ((REG_READ(DSPACNTR) & DISPLAY_PLANE_ENABLE) ||
+	   (REG_READ(DSPCCNTR) & DISPLAY_PLANE_ENABLE))
+		return false;
+
+	return true;
+}
+
+/* Perodically update dbi panel */
+void mdfld_dbi_update_panel(struct drm_device *dev, int pipe)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mdfld_dbi_dsr_info *dsr_info = dev_priv->dbi_dsr_info;
+	struct mdfld_dsi_dbi_output **dbi_outputs;
+	struct mdfld_dsi_dbi_output *dbi_output;
+	int i;
+	int enter_dsr = 0;
+	u32 damage_mask = 0;
+
+	dbi_outputs = dsr_info->dbi_outputs;
+	dbi_output = pipe ? dbi_outputs[1] : dbi_outputs[0];
+
+	if (!dbi_output)
+		return;
+
+	if (pipe == 0)
+		damage_mask = dev_priv->dsr_fb_update & (MDFLD_DSR_DAMAGE_MASK_0);
+	else if (pipe == 2)
+		damage_mask = dev_priv->dsr_fb_update & (MDFLD_DSR_DAMAGE_MASK_2);
+	else
+		return;
+
+	/*if FB is damaged and panel is on update on-panel FB*/
+	if (damage_mask && dbi_output->dbi_panel_on) {
+		dbi_output->dsr_fb_update_done = false;
+
+		if (dbi_output->p_funcs->update_fb)
+			dbi_output->p_funcs->update_fb(dbi_output, pipe);
+
+		if (dev_priv->dsr_enable && dbi_output->dsr_fb_update_done)
+			dev_priv->dsr_fb_update &= ~damage_mask;
+
+		/*clean IN_DSR flag*/
+		dbi_output->mode_flags &= ~MODE_SETTING_IN_DSR;
+
+		dbi_output->dsr_idle_count = 0;
+	} else {
+		dbi_output->dsr_idle_count++;
+	}
+
+	/*try to enter DSR*/
+	if (dbi_outputs[0]->dsr_idle_count > 1
+	    && dbi_outputs[1]->dsr_idle_count > 1) {
+		for (i = 0; i < dsr_info->dbi_output_num; i++) {
+			if (!mdfld_dbi_is_in_dsr(dev) &&
+			   !(dbi_outputs[i]->mode_flags & MODE_SETTING_ON_GOING)) {
+				mdfld_dsi_dbi_enter_dsr(dbi_outputs[i],
+					dbi_outputs[i]->channel_num ? 2 : 0);
+#if 0
+				enter_dsr = 1;
+				pr_err("%s: enter_dsr = 1\n", __func__);
+#endif
+			}
+		}
+	/*schedule rpm suspend after gfxrtdelay*/
+#ifdef CONFIG_GFX_RTPM
+		if (!dev_priv->rpm_enabled
+			|| !enter_dsr
+	/*		|| (REG_READ(HDMIB_CONTROL) & HDMIB_PORT_EN) */
+			|| pm_schedule_suspend(&dev->pdev->dev, gfxrtdelay))
+			dev_warn(dev->dev,
+				"Runtime PM schedule suspend failed, rpm %d\n",
+					dev_priv->rpm_enabled);
+#endif
+	}
+}
+
+/*timers for DSR*/
+static void mdfld_dsi_dbi_dsr_timer_func(unsigned long data)
+{
+	struct drm_device *dev = (struct drm_device *)data;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mdfld_dbi_dsr_info *dsr_info = dev_priv->dbi_dsr_info;
+	struct timer_list *dsr_timer = &dsr_info->dsr_timer;
+	unsigned long flags;
+
+	mdfld_dbi_update_panel(dev, 0);
+
+	if (dsr_info->dsr_idle_count > 1)
+		return;
+
+	spin_lock_irqsave(&dsr_info->dsr_timer_lock, flags);
+	if (!timer_pending(dsr_timer)) {
+		dsr_timer->expires = jiffies + MDFLD_DSR_DELAY;
+		add_timer(dsr_timer);
+	}
+	spin_unlock_irqrestore(&dsr_info->dsr_timer_lock, flags);
+}
+
+static int mdfld_dsi_dbi_dsr_timer_init(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mdfld_dbi_dsr_info *dsr_info = dev_priv->dbi_dsr_info;
+	struct timer_list *dsr_timer = &dsr_info->dsr_timer;
+	unsigned long flags;
+
+	spin_lock_init(&dsr_info->dsr_timer_lock);
+	spin_lock_irqsave(&dsr_info->dsr_timer_lock, flags);
+
+	init_timer(dsr_timer);
+
+	dsr_timer->data = (unsigned long)dev;
+	dsr_timer->function = mdfld_dsi_dbi_dsr_timer_func;
+	dsr_timer->expires = jiffies + MDFLD_DSR_DELAY;
+
+	spin_unlock_irqrestore(&dsr_info->dsr_timer_lock, flags);
+	return 0;
+}
+
+void mdfld_dbi_dsr_timer_start(struct mdfld_dbi_dsr_info *dsr_info)
+{
+	struct timer_list *dsr_timer = &dsr_info->dsr_timer;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dsr_info->dsr_timer_lock, flags);
+	if (!timer_pending(dsr_timer)) {
+		dsr_timer->expires = jiffies + MDFLD_DSR_DELAY;
+		add_timer(dsr_timer);
+	}
+	spin_unlock_irqrestore(&dsr_info->dsr_timer_lock, flags);
+}
+
+int mdfld_dbi_dsr_init(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mdfld_dbi_dsr_info *dsr_info = dev_priv->dbi_dsr_info;
+
+	if (!dsr_info || IS_ERR(dsr_info)) {
+		dsr_info = kzalloc(sizeof(struct mdfld_dbi_dsr_info),
+								GFP_KERNEL);
+		if (!dsr_info) {
+			dev_err(dev->dev, "No memory\n");
+			return -ENOMEM;
+		}
+		dev_priv->dbi_dsr_info = dsr_info;
+	}
+	return 0;
+}
+
+void mdfld_dbi_dsr_exit(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mdfld_dbi_dsr_info *dsr_info = dev_priv->dbi_dsr_info;
+
+	if (!dsr_info) {
+		del_timer_sync(&dsr_info->dsr_timer);
+		kfree(dsr_info);
+		dev_priv->dbi_dsr_info = NULL;
+	}
+}
+#endif
+
+void mdfld_dsi_controller_dbi_init(struct mdfld_dsi_config *dsi_config,
+								int pipe)
+{
+	struct drm_device *dev = dsi_config->dev;
+	u32 reg_offset = pipe ? MIPIC_REG_OFFSET : 0;
+	int lane_count = dsi_config->lane_count;
+	u32 val = 0;
+
+	dev_dbg(dev->dev, "Init DBI interface on pipe %d...\n", pipe);
+
+	/*un-ready device*/
+	REG_WRITE((MIPIA_DEVICE_READY_REG + reg_offset), 0x00000000);
+
+	/*init dsi adapter before kicking off*/
+	REG_WRITE((MIPIA_CONTROL_REG + reg_offset), 0x00000018);
+
+	/*TODO: figure out how to setup these registers*/
+	REG_WRITE((MIPIA_DPHY_PARAM_REG + reg_offset), 0x150c3408);
+	REG_WRITE((MIPIA_CLK_LANE_SWITCH_TIME_CNT_REG + reg_offset),
+							0x000a0014);
+	REG_WRITE((MIPIA_DBI_BW_CTRL_REG + reg_offset), 0x00000400);
+	REG_WRITE((MIPIA_DBI_FIFO_THROTTLE_REG + reg_offset), 0x00000001);
+	REG_WRITE((MIPIA_HS_LS_DBI_ENABLE_REG + reg_offset), 0x00000000);
+
+	/*enable all interrupts*/
+	REG_WRITE((MIPIA_INTR_EN_REG + reg_offset), 0xffffffff);
+	/*max value: 20 clock cycles of txclkesc*/
+	REG_WRITE((MIPIA_TURN_AROUND_TIMEOUT_REG + reg_offset), 0x0000001f);
+	/*min 21 txclkesc, max: ffffh*/
+	REG_WRITE((MIPIA_DEVICE_RESET_TIMER_REG + reg_offset), 0x0000ffff);
+	/*min: 7d0 max: 4e20*/
+	REG_WRITE((MIPIA_INIT_COUNT_REG + reg_offset), 0x00000fa0);
+
+	/*set up func_prg*/
+	val |= lane_count;
+	val |= (dsi_config->channel_num << DSI_DBI_VIRT_CHANNEL_OFFSET);
+	val |= DSI_DBI_COLOR_FORMAT_OPTION2;
+	REG_WRITE((MIPIA_DSI_FUNC_PRG_REG + reg_offset), val);
+
+	REG_WRITE((MIPIA_HS_TX_TIMEOUT_REG + reg_offset), 0x3fffff);
+	REG_WRITE((MIPIA_LP_RX_TIMEOUT_REG + reg_offset), 0xffff);
+
+	/*de-assert dbi_stall when half of DBI FIFO is empty*/
+	/* REG_WRITE((MIPIA_DBI_FIFO_THROTTLE_REG + reg_offset), 0x00000000); */
+
+	REG_WRITE((MIPIA_HIGH_LOW_SWITCH_COUNT_REG + reg_offset), 0x46);
+	REG_WRITE((MIPIA_EOT_DISABLE_REG + reg_offset), 0x00000000);
+	REG_WRITE((MIPIA_LP_BYTECLK_REG + reg_offset), 0x00000004);
+	REG_WRITE((MIPIA_DEVICE_READY_REG + reg_offset), 0x00000001);
+}
+
+#if 0
+/*DBI encoder helper funcs*/
+static const struct drm_encoder_helper_funcs mdfld_dsi_dbi_helper_funcs = {
+	.dpms = mdfld_dsi_dbi_dpms,
+	.mode_fixup = mdfld_dsi_dbi_mode_fixup,
+	.prepare = mdfld_dsi_dbi_prepare,
+	.mode_set = mdfld_dsi_dbi_mode_set,
+	.commit = mdfld_dsi_dbi_commit,
+};
+
+/*DBI encoder funcs*/
+static const struct drm_encoder_funcs mdfld_dsi_dbi_encoder_funcs = {
+	.destroy = drm_encoder_cleanup,
+};
+
+#endif
+
+static int mdfld_dbi_panel_reset(struct mdfld_dsi_dbi_output *output)
+{
+	unsigned gpio;
+	int ret;
+
+	switch (output->channel_num) {
+	case 0:
+		gpio = 128;
+		break;
+	case 1:
+		gpio = 34;
+		break;
+	default:
+		pr_err("Invalid output\n");
+		return -EINVAL;
+	}
+
+	ret = gpio_request(gpio, "gfx");
+	if (ret) {
+		pr_err("gpio_rqueset failed\n");
+		return ret;
+	}
+
+	ret = gpio_direction_output(gpio, 1);
+	if (ret) {
+		pr_err("gpio_direction_output failed\n");
+		goto gpio_error;
+	}
+	gpio_get_value(128);
+gpio_error:
+	if (gpio_is_valid(gpio))
+		gpio_free(gpio);
+
+	return ret;
+}
+
+/*
+ * Init DSI DBI encoder.
+ * Allocate an mdfld_dsi_encoder and attach it to given @dsi_connector
+ * return pointer of newly allocated DBI encoder, NULL on error
+ */
+struct mdfld_dsi_encoder *mdfld_dsi_dbi_init(struct drm_device *dev,
+				struct mdfld_dsi_connector *dsi_connector,
+				struct panel_funcs *p_funcs)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mdfld_dsi_dbi_output *dbi_output = NULL;
+	struct mdfld_dsi_config *dsi_config;
+	struct drm_connector *connector = NULL;
+	struct drm_encoder *encoder = NULL;
+	struct drm_display_mode *fixed_mode = NULL;
+	struct psb_gtt *pg = dev_priv ? (dev_priv->pg) : NULL;
+
+#ifdef CONFIG_MDFLD_DSI_DPU
+	struct mdfld_dbi_dpu_info *dpu_info = dev_priv ? (dev_priv->dbi_dpu_info) : NULL;
+#else
+	struct mdfld_dbi_dsr_info *dsr_info = dev_priv ? (dev_priv->dbi_dsr_info) : NULL;
+#endif
+	int ret;
+
+	if (!pg || !dsi_connector) {
+		WARN_ON(1);
+		return NULL;
+	}
+
+	dbi_output = kzalloc(sizeof(struct mdfld_dsi_dbi_output), GFP_KERNEL);
+	if (!dbi_output) {
+		dev_err(dev->dev, "No memory\n");
+		return NULL;
+	}
+
+	if (dsi_connector->pipe == 0) {
+		dbi_output->channel_num = 0;
+		dev_priv->dbi_output = dbi_output;
+	} else if (dsi_connector->pipe == 2) {
+		dbi_output->channel_num = 1;
+		dev_priv->dbi_output2 = dbi_output;
+	} else {
+		dev_err(dev->dev, "only support 2 DSI outputs\n");
+		goto out_err1;
+	}
+
+	dbi_output->dev = dev;
+	dbi_output->p_funcs = p_funcs;
+
+	/*panel reset*/
+	ret = mdfld_dbi_panel_reset(dbi_output);
+	if (ret) {
+		dev_err(dev->dev, "reset panel error\n");
+		goto out_err1;
+	}
+
+	/*TODO: get panel info from DDB*/
+
+	/*get fixed mode*/
+	dsi_config = mdfld_dsi_get_config(dsi_connector);
+	fixed_mode = dsi_config->fixed_mode;
+
+	dbi_output->panel_fixed_mode = fixed_mode;
+
+	/*create drm encoder object*/
+	connector = &dsi_connector->base.base;
+	encoder = &dbi_output->base.base;
+	drm_encoder_init(dev,
+			encoder,
+			p_funcs->encoder_funcs,
+			DRM_MODE_ENCODER_MIPI);
+	drm_encoder_helper_add(encoder, p_funcs->encoder_helper_funcs);
+
+	/*attach to given connector*/
+	drm_mode_connector_attach_encoder(connector, encoder);
+
+	/*set possible crtcs and clones*/
+	if (dsi_connector->pipe) {
+		encoder->possible_crtcs = (1 << 2);
+		encoder->possible_clones = (1 << 1);
+	} else {
+		encoder->possible_crtcs = (1 << 0);
+		encoder->possible_clones = (1 << 0);
+	}
+
+	dev_priv->dsr_fb_update = 0;
+	dev_priv->dsr_enable = false;
+	dev_priv->exit_idle = mdfld_dsi_dbi_exit_dsr;
+#if defined(CONFIG_MDFLD_DSI_DPU) || defined(CONFIG_MDFLD_DSI_DSR)
+	dev_priv->dsr_enable_config = false;
+#endif /*CONFIG_MDFLD_DSI_DSR*/
+
+	dbi_output->first_boot = true;
+	dbi_output->mode_flags = MODE_SETTING_IN_ENCODER;
+
+#ifdef CONFIG_MDFLD_DSI_DPU
+	/*add this output to dpu_info*/
+	if (dsi_connector->pipe == 0)
+		dpu_info->dbi_outputs[0] = dbi_output;
+	} else {
+		dpu_info->dbi_outputs[1] = dbi_output;
+	}
+	dpu_info->dbi_output_num++;
+#else /*CONFIG_MDFLD_DSI_DPU*/
+	/*add this output to dsr_info*/
+	if (dsi_connector->pipe == 0)
+		dsr_info->dbi_outputs[0] = dbi_output;
+	else
+		dsr_info->dbi_outputs[1] = dbi_output;
+	dsr_info->dbi_output_num++;
+#endif
+	return &dbi_output->base;
+out_err1:
+	kfree(dbi_output);
+	return NULL;
+}
diff --git a/drivers/staging/gma500/mdfld_dsi_dbi.h b/drivers/staging/gma500/mdfld_dsi_dbi.h
new file mode 100644
index 0000000..5b04951
--- /dev/null
+++ b/drivers/staging/gma500/mdfld_dsi_dbi.h
@@ -0,0 +1,188 @@
+/*
+ * Copyright © 2010 Intel Corporation
+ *
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * jim liu <jim.liu@intel.com>
+ * Jackie Li<yaodong.li@intel.com>
+ */
+
+#ifndef __MDFLD_DSI_DBI_H__
+#define __MDFLD_DSI_DBI_H__
+
+#include <linux/backlight.h>
+#include <linux/version.h>
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_edid.h>
+
+#include "psb_drv.h"
+#include "psb_intel_drv.h"
+#include "psb_intel_reg.h"
+#include "psb_powermgmt.h"
+
+#include "mdfld_dsi_output.h"
+#include "mdfld_output.h"
+
+#define DRM_MODE_ENCODER_MIPI  5
+
+
+/*
+ * DBI encoder which inherits from mdfld_dsi_encoder
+ */
+struct mdfld_dsi_dbi_output {
+	struct mdfld_dsi_encoder base;
+	struct drm_display_mode *panel_fixed_mode;
+	u8 last_cmd;
+	u8 lane_count;
+	u8 channel_num;
+	struct drm_device *dev;
+
+	/* Backlight operations */
+
+	/* DSR timer */
+	spinlock_t dsr_timer_lock;
+	struct timer_list dsr_timer;
+	void(*dsi_timer_func)(unsigned long data);
+	u32 dsr_idle_count;
+	bool dsr_fb_update_done;
+
+	/* Mode setting flags */
+	u32 mode_flags;
+
+	/* Panel status */
+	bool dbi_panel_on;
+	bool first_boot;
+	struct panel_funcs *p_funcs;
+};
+
+#define MDFLD_DSI_DBI_OUTPUT(dsi_encoder) \
+	container_of(dsi_encoder, struct mdfld_dsi_dbi_output, base)
+
+struct mdfld_dbi_dsr_info {
+	int dbi_output_num;
+	struct mdfld_dsi_dbi_output *dbi_outputs[2];
+
+	spinlock_t dsr_timer_lock;
+	struct timer_list dsr_timer;
+	u32 dsr_idle_count;
+};
+
+#define DBI_CB_TIMEOUT_COUNT	0xffff
+
+/* DCS commands */
+#define enter_sleep_mode	0x10
+#define exit_sleep_mode		0x11
+#define set_display_off		0x28
+#define	set_dispaly_on		0x29
+#define set_column_address	0x2a
+#define set_page_addr		0x2b
+#define write_mem_start		0x2c
+
+/* Offsets */
+#define CMD_MEM_ADDR_OFFSET	0
+
+#define CMD_DATA_SRC_SYSTEM_MEM	0
+#define CMD_DATA_SRC_PIPE	1
+
+static inline int mdfld_dsi_dbi_fifo_ready(struct mdfld_dsi_dbi_output *dbi_output)
+{
+	struct drm_device *dev = dbi_output->dev;
+	u32 retry = DBI_CB_TIMEOUT_COUNT;
+	int reg_offset = (dbi_output->channel_num == 1) ? MIPIC_REG_OFFSET : 0;
+	int ret = 0;
+
+	/* Query the dbi fifo status*/
+	while (retry--) {
+		if (REG_READ(MIPIA_GEN_FIFO_STAT_REG + reg_offset) & (1 << 27))
+			break;
+	}
+
+	if (!retry) {
+		DRM_ERROR("Timeout waiting for DBI FIFO empty\n");
+		ret = -EAGAIN;
+	}
+	return ret;
+}
+
+static inline int mdfld_dsi_dbi_cmd_sent(struct mdfld_dsi_dbi_output *dbi_output)
+{
+	struct drm_device *dev = dbi_output->dev;
+	u32 retry = DBI_CB_TIMEOUT_COUNT;
+	int reg_offset = (dbi_output->channel_num == 1) ? MIPIC_REG_OFFSET : 0;
+	int ret = 0;
+
+	/* Query the command execution status */
+	while (retry--)
+		if (!(REG_READ(MIPIA_CMD_ADD_REG + reg_offset) & (1 << 10)))
+			break;
+
+	if (!retry) {
+		DRM_ERROR("Timeout waiting for DBI command status\n");
+		ret = -EAGAIN;
+	}
+
+	return ret;
+}
+
+static inline int mdfld_dsi_dbi_cb_ready(struct mdfld_dsi_dbi_output *dbi_output)
+{
+	int ret = 0;
+
+	/* Query the command execution status*/
+	ret = mdfld_dsi_dbi_cmd_sent(dbi_output);
+	if (ret) {
+		DRM_ERROR("Peripheral is busy\n");
+		ret = -EAGAIN;
+	}
+	/* Query the dbi fifo status*/
+	ret = mdfld_dsi_dbi_fifo_ready(dbi_output);
+	if (ret) {
+		DRM_ERROR("DBI FIFO is not empty\n");
+		ret = -EAGAIN;
+	}
+	return ret;
+}
+
+extern void mdfld_dsi_dbi_output_init(struct drm_device *dev,
+			struct psb_intel_mode_device *mode_dev, int pipe);
+extern void mdfld_dsi_dbi_exit_dsr(struct drm_device *dev, u32 update_src,
+			void *p_surfaceAddr, bool check_hw_on_only);
+extern void mdfld_dsi_dbi_enter_dsr(struct mdfld_dsi_dbi_output *dbi_output,
+			int pipe);
+extern int mdfld_dbi_dsr_init(struct drm_device *dev);
+extern void mdfld_dbi_dsr_exit(struct drm_device *dev);
+extern void mdfld_dbi_dsr_timer_start(struct mdfld_dbi_dsr_info *dsr_info);
+extern struct mdfld_dsi_encoder *mdfld_dsi_dbi_init(struct drm_device *dev,
+			struct mdfld_dsi_connector *dsi_connector,
+			struct panel_funcs *p_funcs);
+extern int mdfld_dsi_dbi_send_dcs(struct mdfld_dsi_dbi_output *dbi_output,
+			u8 dcs, u8 *param, u32 num, u8 data_src);
+extern int mdfld_dsi_dbi_update_area(struct mdfld_dsi_dbi_output *dbi_output,
+			u16 x1, u16 y1, u16 x2, u16 y2);
+extern void mdfld_dbi_dsr_timer_start(struct mdfld_dbi_dsr_info *dsr_info);
+extern int mdfld_dsi_dbi_update_power(struct mdfld_dsi_dbi_output *dbi_output,
+			int mode);
+extern void mdfld_dsi_controller_dbi_init(struct mdfld_dsi_config *dsi_config,
+			int pipe);
+
+#endif /*__MDFLD_DSI_DBI_H__*/
diff --git a/drivers/staging/gma500/mdfld_dsi_dbi_dpu.h b/drivers/staging/gma500/mdfld_dsi_dbi_dpu.h
new file mode 100644
index 0000000..4ca9682
--- /dev/null
+++ b/drivers/staging/gma500/mdfld_dsi_dbi_dpu.h
@@ -0,0 +1,157 @@
+/*
+ * Copyright © 2010 Intel Corporation
+ *
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * jim liu <jim.liu@intel.com>
+ * Jackie Li<yaodong.li@intel.com>
+ */
+
+#ifndef __MDFLD_DSI_DBI_DPU_H__
+#define __MDFLD_DSI_DBI_DPU_H__
+
+#include "mdfld_dsi_dbi.h"
+
+typedef enum {
+	MDFLD_PLANEA,
+	MDFLD_PLANEC,
+	MDFLD_CURSORA,
+	MDFLD_CURSORC,
+	MDFLD_OVERLAYA,
+	MDFLD_OVERLAYC,
+	MDFLD_PLANE_NUM,
+} mdfld_plane_t;
+
+#define MDFLD_PIPEA_PLANE_MASK	0x15
+#define MDFLD_PIPEC_PLANE_MASK	0x2A
+
+struct mdfld_cursor_info {
+	int x, y;
+	int size;
+};
+
+#define MDFLD_CURSOR_SIZE	64
+
+/*
+ * enter DSR mode if screen has no update for 2 frames.
+ */
+#define MDFLD_MAX_IDLE_COUNT	2
+
+struct mdfld_dbi_dpu_info {
+	struct drm_device *dev;
+	/* Lock */
+	spinlock_t dpu_update_lock;
+
+	/* Cursor postion */
+	struct mdfld_cursor_info cursors[2];
+
+	/* Damaged area for each plane */
+	struct psb_drm_dpu_rect damaged_rects[MDFLD_PLANE_NUM];
+
+	/* Final damaged area */
+	struct psb_drm_dpu_rect damage_pipea;
+	struct psb_drm_dpu_rect damage_pipec;
+
+	/* Pending */
+	u32 pending;
+
+	/* DPU timer */
+	struct timer_list dpu_timer;
+	spinlock_t dpu_timer_lock;
+
+	/* DPU idle count */
+	u32 idle_count;
+
+	/* DSI outputs */
+	struct mdfld_dsi_dbi_output *dbi_outputs[2];
+	int dbi_output_num;
+};
+
+static inline int mdfld_dpu_region_extent(struct psb_drm_dpu_rect *origin,
+			 struct psb_drm_dpu_rect *rect)
+{
+	int x1, y1, x2, y2;
+
+	/* PSB_DEBUG_ENTRY("rect (%d, %d, %d, %d)\n",
+		rect->x, rect->y, rect->width, rect->height); */
+
+	x1 = origin->x + origin->width;
+	y1 = origin->y + origin->height;
+
+	x2 = rect->x + rect->width;
+	y2 = rect->y + rect->height;
+
+	origin->x = min(origin->x, rect->x);
+	origin->y = min(origin->y, rect->y);
+	origin->width = max(x1, x2) - origin->x;
+	origin->height = max(y1, y2) - origin->y;
+
+	return 0;
+}
+
+static inline void mdfld_check_boundary(struct mdfld_dbi_dpu_info *dpu_info,
+				struct psb_drm_dpu_rect *rect)
+{
+	if (rect->x < 0)
+		rect->x = 0;
+	if (rect->y < 0)
+		rect->y = 0;
+
+	if (rect->x + rect->width > 864)
+		rect->width = 864 - rect->x;
+	if (rect->y + rect->height > 480)
+		rect->height = 480 - rect->height;
+
+	if (!rect->width)
+		rect->width = 1;
+	if (!rect->height)
+		rect->height = 1;
+}
+
+static inline void mdfld_dpu_init_damage(struct mdfld_dbi_dpu_info *dpu_info,
+				int pipe)
+{
+	struct psb_drm_dpu_rect *rect;
+
+	if (pipe == 0)
+		rect = &dpu_info->damage_pipea;
+	else
+		rect = &dpu_info->damage_pipec;
+
+	rect->x = 864;
+	rect->y = 480;
+	rect->width = -864;
+	rect->height = -480;
+}
+
+extern int mdfld_dsi_dbi_dsr_off(struct drm_device *dev,
+				struct psb_drm_dpu_rect *rect);
+extern int mdfld_dbi_dpu_report_damage(struct drm_device *dev,
+				mdfld_plane_t plane,
+				struct psb_drm_dpu_rect *rect);
+extern int mdfld_dbi_dpu_report_fullscreen_damage(struct drm_device *dev);
+extern int mdfld_dpu_exit_dsr(struct drm_device *dev);
+extern void mdfld_dbi_dpu_timer_start(struct mdfld_dbi_dpu_info *dpu_info);
+extern int mdfld_dbi_dpu_init(struct drm_device *dev);
+extern void mdfld_dbi_dpu_exit(struct drm_device *dev);
+extern void mdfld_dpu_update_panel(struct drm_device *dev);
+
+#endif /*__MDFLD_DSI_DBI_DPU_H__*/
diff --git a/drivers/staging/gma500/mdfld_dsi_dpi.c b/drivers/staging/gma500/mdfld_dsi_dpi.c
new file mode 100644
index 0000000..fce3c20
--- /dev/null
+++ b/drivers/staging/gma500/mdfld_dsi_dpi.c
@@ -0,0 +1,991 @@
+/*
+ * Copyright © 2010 Intel Corporation
+ *
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * jim liu <jim.liu@intel.com>
+ * Jackie Li<yaodong.li@intel.com>
+ */
+
+#include "mdfld_dsi_dpi.h"
+#include "mdfld_output.h"
+#include "mdfld_dsi_pkg_sender.h"
+
+
+static void mdfld_wait_for_HS_DATA_FIFO(struct drm_device *dev, u32 pipe)
+{
+	u32 gen_fifo_stat_reg = MIPIA_GEN_FIFO_STAT_REG;
+	int timeout = 0;
+
+	if (pipe == 2)
+		gen_fifo_stat_reg += MIPIC_REG_OFFSET;
+
+	udelay(500);
+
+	/* This will time out after approximately 2+ seconds */
+	while ((timeout < 20000) && (REG_READ(gen_fifo_stat_reg) & DSI_FIFO_GEN_HS_DATA_FULL)) {
+		udelay(100);
+		timeout++;
+	}
+
+	if (timeout == 20000)
+		dev_warn(dev->dev, "MIPI: HS Data FIFO was never cleared!\n");
+}
+
+static void mdfld_wait_for_HS_CTRL_FIFO(struct drm_device *dev, u32 pipe)
+{
+	u32 gen_fifo_stat_reg = MIPIA_GEN_FIFO_STAT_REG;
+	int timeout = 0;
+
+	if (pipe == 2)
+		gen_fifo_stat_reg += MIPIC_REG_OFFSET;
+
+	udelay(500);
+
+	/* This will time out after approximately 2+ seconds */
+	while ((timeout < 20000) && (REG_READ(gen_fifo_stat_reg) & DSI_FIFO_GEN_HS_CTRL_FULL)) {
+		udelay(100);
+		timeout++;
+	}
+	if (timeout == 20000)
+		dev_warn(dev->dev, "MIPI: HS CMD FIFO was never cleared!\n");
+}
+
+static void mdfld_wait_for_PIPEA_DISABLE(struct drm_device *dev, u32 pipe)
+{
+        u32 pipeconf_reg = PIPEACONF;
+        int timeout = 0;
+
+        if (pipe == 2)
+                pipeconf_reg = PIPECCONF;
+
+        udelay(500);
+
+        /* This will time out after approximately 2+ seconds */
+        while ((timeout < 20000) && (REG_READ(pipeconf_reg) & 0x40000000)) {
+                udelay(100);
+                timeout++;
+        }
+
+        if (timeout == 20000)
+                dev_warn(dev->dev, "MIPI: PIPE was not disabled!\n");
+}
+
+static void mdfld_wait_for_DPI_CTRL_FIFO(struct drm_device *dev, u32 pipe)
+{
+	u32 gen_fifo_stat_reg = MIPIA_GEN_FIFO_STAT_REG;
+        int timeout = 0;
+
+	if (pipe == 2)
+		gen_fifo_stat_reg += MIPIC_REG_OFFSET;
+
+        udelay(500);
+
+        /* This will time out after approximately 2+ seconds */
+        while ((timeout < 20000) && ((REG_READ(gen_fifo_stat_reg) & DPI_FIFO_EMPTY)
+                                                        != DPI_FIFO_EMPTY)) {
+                udelay(100);
+                timeout++;
+        }
+
+        if (timeout == 20000)
+                dev_warn(dev->dev, "MIPI: DPI FIFO was never cleared!\n");
+}
+
+static void mdfld_wait_for_SPL_PKG_SENT(struct drm_device *dev, u32 pipe)
+{
+	u32 intr_stat_reg = MIPIA_INTR_STAT_REG;
+	int timeout = 0;
+
+	if (pipe == 2)
+		intr_stat_reg += MIPIC_REG_OFFSET;
+
+        udelay(500);
+
+        /* This will time out after approximately 2+ seconds */
+        while ((timeout < 20000) && (!(REG_READ(intr_stat_reg) & DSI_INTR_STATE_SPL_PKG_SENT))) {
+                udelay(100);
+                timeout++;
+        }
+
+        if (timeout == 20000)
+                dev_warn(dev->dev, "MIPI: SPL_PKT_SENT_INTERRUPT was not sent successfully!\n");
+}
+
+
+/* ************************************************************************* *\
+ * FUNCTION: mdfld_dsi_tpo_ic_init
+ *
+ * DESCRIPTION:  This function is called only by mrst_dsi_mode_set and
+ *               restore_display_registers.  since this function does not
+ *               acquire the mutex, it is important that the calling function
+ *               does!
+\* ************************************************************************* */
+void mdfld_dsi_tpo_ic_init(struct mdfld_dsi_config *dsi_config, u32 pipe)
+{
+	struct drm_device *dev = dsi_config->dev;
+	u32 dcsChannelNumber = dsi_config->channel_num;
+	u32 gen_data_reg = MIPIA_HS_GEN_DATA_REG; 
+	u32 gen_ctrl_reg = MIPIA_HS_GEN_CTRL_REG;
+	u32 gen_ctrl_val = GEN_LONG_WRITE;
+
+	dev_warn(dev->dev, "Enter mrst init TPO MIPI display.\n");
+
+	if (pipe == 2) {
+		gen_data_reg = HS_GEN_DATA_REG + MIPIC_REG_OFFSET; 
+		gen_ctrl_reg = HS_GEN_CTRL_REG + MIPIC_REG_OFFSET;
+	}
+
+	gen_ctrl_val |= dcsChannelNumber << DCS_CHANNEL_NUMBER_POS;
+
+	/* Flip page order */
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x00008036);
+	mdfld_wait_for_HS_CTRL_FIFO(dev, pipe);
+	REG_WRITE(gen_ctrl_reg, gen_ctrl_val | (0x02 << WORD_COUNTS_POS));
+
+	/* 0xF0 */
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x005a5af0);
+	mdfld_wait_for_HS_CTRL_FIFO(dev, pipe);
+	REG_WRITE(gen_ctrl_reg, gen_ctrl_val | (0x03 << WORD_COUNTS_POS));
+
+	/* Write protection key */
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x005a5af1);
+	mdfld_wait_for_HS_CTRL_FIFO(dev, pipe);
+	REG_WRITE(gen_ctrl_reg, gen_ctrl_val | (0x03 << WORD_COUNTS_POS));
+
+	/* 0xFC */
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x005a5afc);
+	mdfld_wait_for_HS_CTRL_FIFO(dev, pipe);
+	REG_WRITE(gen_ctrl_reg, gen_ctrl_val | (0x03 << WORD_COUNTS_POS));
+
+	/* 0xB7 */
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x770000b7);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x00000044);
+	mdfld_wait_for_HS_CTRL_FIFO(dev, pipe);
+	REG_WRITE(gen_ctrl_reg, gen_ctrl_val | (0x05 << WORD_COUNTS_POS));
+
+	/* 0xB6 */
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x000a0ab6);
+	mdfld_wait_for_HS_CTRL_FIFO(dev, pipe);
+	REG_WRITE(gen_ctrl_reg, gen_ctrl_val | (0x03 << WORD_COUNTS_POS));
+
+	/* 0xF2 */
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x081010f2);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x4a070708);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x000000c5);
+	mdfld_wait_for_HS_CTRL_FIFO(dev, pipe);
+	REG_WRITE(gen_ctrl_reg, gen_ctrl_val | (0x09 << WORD_COUNTS_POS));
+
+	/* 0xF8 */
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x024003f8);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x01030a04);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x0e020220);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x00000004);
+	mdfld_wait_for_HS_CTRL_FIFO(dev, pipe);
+	REG_WRITE(gen_ctrl_reg, gen_ctrl_val | (0x0d << WORD_COUNTS_POS));
+
+	/* 0xE2 */
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x398fc3e2);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x0000916f);
+	mdfld_wait_for_HS_CTRL_FIFO(dev, pipe);
+	REG_WRITE(gen_ctrl_reg, gen_ctrl_val | (0x06 << WORD_COUNTS_POS));
+
+	/* 0xB0 */
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x000000b0);
+	mdfld_wait_for_HS_CTRL_FIFO(dev, pipe);
+	REG_WRITE(gen_ctrl_reg, gen_ctrl_val | (0x02 << WORD_COUNTS_POS));
+
+	/* 0xF4 */
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x240242f4);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x78ee2002);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x2a071050);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x507fee10);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x10300710);
+	mdfld_wait_for_HS_CTRL_FIFO(dev, pipe);
+	REG_WRITE(gen_ctrl_reg, gen_ctrl_val | (0x14 << WORD_COUNTS_POS));
+
+	/* 0xBA */
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x19fe07ba);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x101c0a31);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x00000010);
+	mdfld_wait_for_HS_CTRL_FIFO(dev, pipe);
+	REG_WRITE(gen_ctrl_reg, gen_ctrl_val | (0x09 << WORD_COUNTS_POS));
+
+	/* 0xBB */
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x28ff07bb);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x24280a31);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x00000034);
+	mdfld_wait_for_HS_CTRL_FIFO(dev, pipe);
+	REG_WRITE(gen_ctrl_reg, gen_ctrl_val | (0x09 << WORD_COUNTS_POS));
+
+	/* 0xFB */
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x535d05fb);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x1b1a2130);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x221e180e);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x131d2120);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x535d0508);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x1c1a2131);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x231f160d);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x111b2220);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x535c2008);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x1f1d2433);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x2c251a10);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x2c34372d);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x00000023);
+	mdfld_wait_for_HS_CTRL_FIFO(dev, pipe);
+	REG_WRITE(gen_ctrl_reg, gen_ctrl_val | (0x31 << WORD_COUNTS_POS));
+
+	/* 0xFA */
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x525c0bfa);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x1c1c232f);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x2623190e);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x18212625);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x545d0d0e);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x1e1d2333);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x26231a10);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x1a222725);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x545d280f);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x21202635);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x31292013);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x31393d33);
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x00000029);
+	mdfld_wait_for_HS_CTRL_FIFO(dev, pipe);
+	REG_WRITE(gen_ctrl_reg, gen_ctrl_val | (0x31 << WORD_COUNTS_POS));
+
+	/* Set DM */
+	mdfld_wait_for_HS_DATA_FIFO(dev, pipe);
+	REG_WRITE(gen_data_reg, 0x000100f7);
+	mdfld_wait_for_HS_CTRL_FIFO(dev, pipe);
+	REG_WRITE(gen_ctrl_reg, gen_ctrl_val | (0x03 << WORD_COUNTS_POS));
+}
+
+/* ************************************************************************* *\
+ * FUNCTION: mdfld_init_TMD_MIPI
+ *
+ * DESCRIPTION:  This function is called only by mrst_dsi_mode_set and
+ *               restore_display_registers.  since this function does not
+ *               acquire the mutex, it is important that the calling function
+ *               does!
+\* ************************************************************************* */
+
+static u32 tmd_cmd_mcap_off[] = {0x000000b2};
+static u32 tmd_cmd_enable_lane_switch[] = {0x000101ef};
+static u32 tmd_cmd_set_lane_num[] = {0x006360ef};
+static u32 tmd_cmd_set_mode[] = {0x000000b3};
+static u32 tmd_cmd_set_sync_pulse_mode[] = {0x000961ef};
+static u32 tmd_cmd_set_video_mode[] = {0x00000153};
+static u32 tmd_cmd_enable_backlight[] = {0x00005ab4};//no auto_bl,need add in furtrue
+static u32 tmd_cmd_set_backlight_dimming[] = {0x00000ebd}; 
+
+void mdfld_dsi_tmd_drv_ic_init(struct mdfld_dsi_config *dsi_config, u32 pipe)
+{
+	struct mdfld_dsi_pkg_sender *sender = mdfld_dsi_get_pkg_sender(dsi_config);
+
+	if(!sender) {
+		WARN_ON(1);
+		return;
+	}
+
+	if(dsi_config->dvr_ic_inited)
+		return;
+
+	msleep(3);
+
+	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_mcap_off, 1, 0);
+	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_enable_lane_switch, 1, 0);
+	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_set_lane_num, 1, 0);
+	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_set_mode, 1, 0);
+	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_set_sync_pulse_mode, 1, 0);
+	/*TODO: set page and column here*/
+	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_set_video_mode, 1, 0);
+	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_enable_backlight, 1, 0);
+	mdfld_dsi_send_gen_long_lp(sender, tmd_cmd_set_backlight_dimming,1,0);
+	dsi_config->dvr_ic_inited = 1;
+}
+
+static u16 mdfld_dsi_dpi_to_byte_clock_count(int pixel_clock_count, int num_lane, int bpp)
+{
+	return (u16)((pixel_clock_count * bpp) / (num_lane * 8)); 
+}
+
+/*
+ * Calculate the dpi time basing on a given drm mode @mode
+ * return 0 on success.
+ * FIXME: I was using proposed mode value for calculation, may need to 
+ * use crtc mode values later 
+ */
+int mdfld_dsi_dpi_timing_calculation(struct drm_display_mode *mode, 
+									struct mdfld_dsi_dpi_timing *dpi_timing,
+									int num_lane, int bpp)
+{
+	int pclk_hsync, pclk_hfp, pclk_hbp, pclk_hactive;
+	int pclk_vsync, pclk_vfp, pclk_vbp, pclk_vactive;
+	
+	if(!mode || !dpi_timing) {
+		DRM_ERROR("Invalid parameter\n");
+		return -EINVAL;
+	}
+	
+	pclk_hactive = mode->hdisplay;
+	pclk_hfp = mode->hsync_start - mode->hdisplay;
+	pclk_hsync = mode->hsync_end - mode->hsync_start;
+	pclk_hbp = mode->htotal - mode->hsync_end;
+	
+	pclk_vactive = mode->vdisplay;
+	pclk_vfp = mode->vsync_start - mode->vdisplay;
+	pclk_vsync = mode->vsync_end - mode->vsync_start;
+	pclk_vbp = mode->vtotal - mode->vsync_end;
+
+#ifdef MIPI_DEBUG_LOG
+	printk(KERN_ALERT "[DISPLAY] %s: pclk_hactive = %d\n", __func__, pclk_hactive);
+	printk(KERN_ALERT "[DISPLAY] %s: pclk_hfp = %d\n", __func__, pclk_hfp);
+	printk(KERN_ALERT "[DISPLAY] %s: pclk_hsync = %d\n", __func__, pclk_hsync);
+	printk(KERN_ALERT "[DISPLAY] %s: pclk_hbp = %d\n", __func__, pclk_hbp);
+	printk(KERN_ALERT "[DISPLAY] %s: pclk_vactive = %d\n", __func__, pclk_vactive);
+	printk(KERN_ALERT "[DISPLAY] %s: pclk_vfp = %d\n", __func__, pclk_vfp);
+	printk(KERN_ALERT "[DISPLAY] %s: pclk_vsync = %d\n", __func__, pclk_vsync);
+	printk(KERN_ALERT "[DISPLAY] %s: pclk_vbp = %d\n", __func__, pclk_vbp);
+#endif
+	/*
+	 * byte clock counts were calculated by following formula
+	 * bclock_count = pclk_count * bpp / num_lane / 8
+	 */
+	dpi_timing->hsync_count = mdfld_dsi_dpi_to_byte_clock_count(pclk_hsync, num_lane, bpp);
+	dpi_timing->hbp_count = mdfld_dsi_dpi_to_byte_clock_count(pclk_hbp, num_lane, bpp);
+	dpi_timing->hfp_count = mdfld_dsi_dpi_to_byte_clock_count(pclk_hfp, num_lane, bpp);
+	dpi_timing->hactive_count = mdfld_dsi_dpi_to_byte_clock_count(pclk_hactive, num_lane, bpp);
+	dpi_timing->vsync_count = mdfld_dsi_dpi_to_byte_clock_count(pclk_vsync, num_lane, bpp);
+	dpi_timing->vbp_count = mdfld_dsi_dpi_to_byte_clock_count(pclk_vbp, num_lane, bpp);
+	dpi_timing->vfp_count = mdfld_dsi_dpi_to_byte_clock_count(pclk_vfp, num_lane, bpp);
+
+	return 0; 
+}
+
+void mdfld_dsi_dpi_controller_init(struct mdfld_dsi_config *dsi_config, int pipe)
+{
+	struct drm_device *dev = dsi_config->dev;
+	u32 reg_offset = pipe ? MIPIC_REG_OFFSET : 0;
+	int lane_count = dsi_config->lane_count;
+	struct mdfld_dsi_dpi_timing dpi_timing;
+	struct drm_display_mode *mode = dsi_config->mode;
+	u32 val = 0;
+	
+	/*un-ready device*/
+	REG_WRITE((MIPIA_DEVICE_READY_REG + reg_offset), 0x00000000);
+	
+	/*init dsi adapter before kicking off*/
+	REG_WRITE((MIPIA_CONTROL_REG + reg_offset), 0x00000018);
+	
+	/*enable all interrupts*/
+	REG_WRITE((MIPIA_INTR_EN_REG + reg_offset), 0xffffffff);
+	
+
+	/*set up func_prg*/
+	val |= lane_count;
+	val |= dsi_config->channel_num << DSI_DPI_VIRT_CHANNEL_OFFSET;
+		
+	switch(dsi_config->bpp) {
+	case 16:
+		val |= DSI_DPI_COLOR_FORMAT_RGB565;
+		break;
+	case 18:
+		val |= DSI_DPI_COLOR_FORMAT_RGB666;
+		break;
+	case 24:
+		val |= DSI_DPI_COLOR_FORMAT_RGB888;
+		break;
+	default:
+		DRM_ERROR("unsupported color format, bpp = %d\n", dsi_config->bpp);
+	}
+	REG_WRITE((MIPIA_DSI_FUNC_PRG_REG + reg_offset), val);
+	
+	REG_WRITE((MIPIA_HS_TX_TIMEOUT_REG + reg_offset), 
+			(mode->vtotal * mode->htotal * dsi_config->bpp / (8 * lane_count)) & DSI_HS_TX_TIMEOUT_MASK);
+	REG_WRITE((MIPIA_LP_RX_TIMEOUT_REG + reg_offset), 0xffff & DSI_LP_RX_TIMEOUT_MASK);
+	
+	/*max value: 20 clock cycles of txclkesc*/
+	REG_WRITE((MIPIA_TURN_AROUND_TIMEOUT_REG + reg_offset), 0x14 & DSI_TURN_AROUND_TIMEOUT_MASK);
+	
+	/*min 21 txclkesc, max: ffffh*/
+	REG_WRITE((MIPIA_DEVICE_RESET_TIMER_REG + reg_offset), 0xffff & DSI_RESET_TIMER_MASK);
+
+	REG_WRITE((MIPIA_DPI_RESOLUTION_REG + reg_offset), mode->vdisplay << 16 | mode->hdisplay);
+	
+	/*set DPI timing registers*/
+	mdfld_dsi_dpi_timing_calculation(mode, &dpi_timing, dsi_config->lane_count, dsi_config->bpp);
+	
+	REG_WRITE((MIPIA_HSYNC_COUNT_REG + reg_offset), dpi_timing.hsync_count & DSI_DPI_TIMING_MASK);
+	REG_WRITE((MIPIA_HBP_COUNT_REG + reg_offset), dpi_timing.hbp_count & DSI_DPI_TIMING_MASK);
+	REG_WRITE((MIPIA_HFP_COUNT_REG + reg_offset), dpi_timing.hfp_count & DSI_DPI_TIMING_MASK);
+	REG_WRITE((MIPIA_HACTIVE_COUNT_REG + reg_offset), dpi_timing.hactive_count & DSI_DPI_TIMING_MASK);
+	REG_WRITE((MIPIA_VSYNC_COUNT_REG + reg_offset), dpi_timing.vsync_count & DSI_DPI_TIMING_MASK);
+	REG_WRITE((MIPIA_VBP_COUNT_REG + reg_offset), dpi_timing.vbp_count & DSI_DPI_TIMING_MASK);
+	REG_WRITE((MIPIA_VFP_COUNT_REG + reg_offset), dpi_timing.vfp_count & DSI_DPI_TIMING_MASK);
+	
+	REG_WRITE((MIPIA_HIGH_LOW_SWITCH_COUNT_REG + reg_offset), 0x46);
+	
+	/*min: 7d0 max: 4e20*/
+	REG_WRITE((MIPIA_INIT_COUNT_REG + reg_offset), 0x000007d0);
+	
+	/*set up video mode*/
+	val = 0;
+	val = dsi_config->video_mode | DSI_DPI_COMPLETE_LAST_LINE;
+	REG_WRITE((MIPIA_VIDEO_MODE_FORMAT_REG + reg_offset), val);
+	
+	REG_WRITE((MIPIA_EOT_DISABLE_REG + reg_offset), 0x00000000);
+	
+	REG_WRITE((MIPIA_LP_BYTECLK_REG + reg_offset), 0x00000004);
+	
+	/*TODO: figure out how to setup these registers*/
+	REG_WRITE((MIPIA_DPHY_PARAM_REG + reg_offset), 0x150c3408);
+	
+	REG_WRITE((MIPIA_CLK_LANE_SWITCH_TIME_CNT_REG + reg_offset), (0xa << 16) | 0x14);
+	/*set device ready*/
+	REG_WRITE((MIPIA_DEVICE_READY_REG + reg_offset), 0x00000001);
+}
+
+void mdfld_dsi_dpi_turn_on(struct mdfld_dsi_dpi_output *output, int pipe)
+{
+	struct drm_device *dev = output->dev;
+	/* struct drm_psb_private *dev_priv = dev->dev_private; */
+	u32 reg_offset = 0;
+	
+	if(output->panel_on) 
+		return;
+		
+	if(pipe) 
+		reg_offset = MIPIC_REG_OFFSET;
+
+	/* clear special packet sent bit */
+	if(REG_READ(MIPIA_INTR_STAT_REG + reg_offset) & DSI_INTR_STATE_SPL_PKG_SENT) {
+		REG_WRITE((MIPIA_INTR_STAT_REG + reg_offset), DSI_INTR_STATE_SPL_PKG_SENT);
+	}
+		
+	/*send turn on package*/
+	REG_WRITE((MIPIA_DPI_CONTROL_REG + reg_offset), DSI_DPI_CTRL_HS_TURN_ON);
+	
+	/*wait for SPL_PKG_SENT interrupt*/
+	mdfld_wait_for_SPL_PKG_SENT(dev, pipe);
+	
+	if(REG_READ(MIPIA_INTR_STAT_REG + reg_offset) & DSI_INTR_STATE_SPL_PKG_SENT) {
+		REG_WRITE((MIPIA_INTR_STAT_REG + reg_offset), DSI_INTR_STATE_SPL_PKG_SENT);
+	}
+
+	output->panel_on = 1;
+
+	/* FIXME the following is disabled to WA the X slow start issue for TMD panel */
+	/* if(pipe == 2) */
+	/* 	dev_priv->dpi_panel_on2 = true; */
+	/* else if (pipe == 0) */
+	/* 	dev_priv->dpi_panel_on = true; */
+}
+
+static void mdfld_dsi_dpi_shut_down(struct mdfld_dsi_dpi_output *output, int pipe)
+{
+	struct drm_device *dev = output->dev;
+	/* struct drm_psb_private *dev_priv = dev->dev_private; */
+	u32 reg_offset = 0;
+	
+	/*if output is on, or mode setting didn't happen, ignore this*/
+	if((!output->panel_on) || output->first_boot) {
+		output->first_boot = 0; 
+		return;
+	}
+	
+	if(pipe)
+		reg_offset = MIPIC_REG_OFFSET;
+
+	/* Wait for dpi fifo to empty */
+	mdfld_wait_for_DPI_CTRL_FIFO(dev, pipe);
+
+	/* Clear the special packet interrupt bit if set */
+	if(REG_READ(MIPIA_INTR_STAT_REG + reg_offset) & DSI_INTR_STATE_SPL_PKG_SENT) {
+		REG_WRITE((MIPIA_INTR_STAT_REG + reg_offset), DSI_INTR_STATE_SPL_PKG_SENT);
+	}
+	
+	if(REG_READ(MIPIA_DPI_CONTROL_REG + reg_offset) == DSI_DPI_CTRL_HS_SHUTDOWN) {
+		goto shutdown_out;
+	}
+	
+	REG_WRITE((MIPIA_DPI_CONTROL_REG + reg_offset), DSI_DPI_CTRL_HS_SHUTDOWN);
+
+shutdown_out:
+	output->panel_on = 0;
+	output->first_boot = 0;
+
+	/* FIXME the following is disabled to WA the X slow start issue for TMD panel */
+	/* if(pipe == 2) */
+	/* 	dev_priv->dpi_panel_on2 = false; */
+	/* else if (pipe == 0) */
+	/* 	dev_priv->dpi_panel_on = false;	 */
+}
+
+void mdfld_dsi_dpi_set_power(struct drm_encoder *encoder, bool on)
+{
+	struct mdfld_dsi_encoder *dsi_encoder = MDFLD_DSI_ENCODER(encoder);
+	struct mdfld_dsi_dpi_output *dpi_output = MDFLD_DSI_DPI_OUTPUT(dsi_encoder);
+	struct mdfld_dsi_config *dsi_config = mdfld_dsi_encoder_get_config(dsi_encoder);
+	int pipe = mdfld_dsi_encoder_get_pipe(dsi_encoder);
+	struct drm_device *dev = dsi_config->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	u32 mipi_reg = MIPI;
+	u32 pipeconf_reg = PIPEACONF;
+	
+	if(pipe) {
+		mipi_reg = MIPI_C;
+		pipeconf_reg = PIPECCONF;
+	}
+	
+	/* Start up display island if it was shutdown */
+	if (!gma_power_begin(dev, true))
+		return;
+
+	if(on) {
+		if (mdfld_get_panel_type(dev, pipe) == TMD_VID){
+ 			mdfld_dsi_dpi_turn_on(dpi_output, pipe);
+ 		} else {
+			/*enable mipi port*/
+			REG_WRITE(mipi_reg, (REG_READ(mipi_reg) | (1 << 31)));
+			REG_READ(mipi_reg);
+
+			mdfld_dsi_dpi_turn_on(dpi_output, pipe);
+			mdfld_dsi_tpo_ic_init(dsi_config, pipe);
+		}
+
+		if(pipe == 2) {
+			dev_priv->dpi_panel_on2 = true;
+		}
+		else {
+			dev_priv->dpi_panel_on  = true;
+		}
+
+	} else {
+ 		if (mdfld_get_panel_type(dev, pipe) == TMD_VID) {
+ 			mdfld_dsi_dpi_shut_down(dpi_output, pipe);
+ 		} else {
+			mdfld_dsi_dpi_shut_down(dpi_output, pipe);
+			/*disable mipi port*/
+			REG_WRITE(mipi_reg, (REG_READ(mipi_reg) & ~(1<<31)));
+			REG_READ(mipi_reg);
+		}
+
+		if(pipe == 2)
+			dev_priv->dpi_panel_on2 = false;
+		else
+			dev_priv->dpi_panel_on  = false;
+	}
+	gma_power_end(dev);
+}
+
+void mdfld_dsi_dpi_dpms(struct drm_encoder *encoder, int mode)
+{
+	dev_dbg(encoder->dev->dev, "DPMS %s\n",
+			(mode == DRM_MODE_DPMS_ON ? "on":"off"));
+
+	if (mode == DRM_MODE_DPMS_ON)
+		mdfld_dsi_dpi_set_power(encoder, true);
+	else
+		mdfld_dsi_dpi_set_power(encoder, false);
+}
+
+bool mdfld_dsi_dpi_mode_fixup(struct drm_encoder *encoder,
+				     struct drm_display_mode *mode,
+				     struct drm_display_mode *adjusted_mode)
+{
+	struct mdfld_dsi_encoder *dsi_encoder = MDFLD_DSI_ENCODER(encoder);
+	struct mdfld_dsi_config *dsi_config = mdfld_dsi_encoder_get_config(dsi_encoder);
+	struct drm_display_mode *fixed_mode = dsi_config->fixed_mode;
+
+	if(fixed_mode) {
+		adjusted_mode->hdisplay = fixed_mode->hdisplay;
+		adjusted_mode->hsync_start = fixed_mode->hsync_start;
+		adjusted_mode->hsync_end = fixed_mode->hsync_end;
+		adjusted_mode->htotal = fixed_mode->htotal;
+		adjusted_mode->vdisplay = fixed_mode->vdisplay;
+		adjusted_mode->vsync_start = fixed_mode->vsync_start;
+		adjusted_mode->vsync_end = fixed_mode->vsync_end;
+		adjusted_mode->vtotal = fixed_mode->vtotal;
+		adjusted_mode->clock = fixed_mode->clock;
+		drm_mode_set_crtcinfo(adjusted_mode, CRTC_INTERLACE_HALVE_V);
+	}
+	
+	return true;
+}
+
+void mdfld_dsi_dpi_prepare(struct drm_encoder *encoder) 
+{
+	mdfld_dsi_dpi_set_power(encoder, false);
+}
+
+void mdfld_dsi_dpi_commit(struct drm_encoder *encoder) 
+{
+	mdfld_dsi_dpi_set_power(encoder, true);
+}
+
+void dsi_debug_MIPI_reg(struct drm_device *dev)
+{
+	u32 temp_val = 0;
+
+	temp_val = REG_READ(MIPI);
+	printk(KERN_ALERT "[DISPLAY] MIPI = %x\n", temp_val);
+
+	/* set the lane speed */
+	temp_val = REG_READ(MIPI_CONTROL_REG);
+	printk(KERN_ALERT "[DISPLAY] MIPI_CONTROL_REG = %x\n", temp_val);
+
+	/* Enable all the error interrupt */
+	temp_val = REG_READ(INTR_EN_REG);
+	printk(KERN_ALERT "[DISPLAY] INTR_EN_REG = %x\n", temp_val);
+	temp_val = REG_READ(TURN_AROUND_TIMEOUT_REG);
+	printk(KERN_ALERT "[DISPLAY] TURN_AROUND_TIMEOUT_REG = %x\n", temp_val);
+	temp_val = REG_READ(DEVICE_RESET_REG);
+	printk(KERN_ALERT "[DISPLAY] DEVICE_RESET_REG = %x\n", temp_val);
+	temp_val = REG_READ(INIT_COUNT_REG);
+	printk(KERN_ALERT "[DISPLAY] INIT_COUNT_REG = %x\n", temp_val);
+
+	temp_val = REG_READ(DSI_FUNC_PRG_REG);
+	printk(KERN_ALERT "[DISPLAY] DSI_FUNC_PRG_REG = %x\n", temp_val);
+
+	temp_val = REG_READ(DPI_RESOLUTION_REG);
+	printk(KERN_ALERT "[DISPLAY] DPI_RESOLUTION_REG = %x\n", temp_val);
+
+	temp_val = REG_READ(VERT_SYNC_PAD_COUNT_REG);
+	printk(KERN_ALERT "[DISPLAY] VERT_SYNC_PAD_COUNT_REG = %x\n", temp_val);
+	temp_val = REG_READ(VERT_BACK_PORCH_COUNT_REG);
+	printk(KERN_ALERT "[DISPLAY] VERT_BACK_PORCH_COUNT_REG = %x\n", temp_val);
+	temp_val = REG_READ(VERT_FRONT_PORCH_COUNT_REG);
+	printk(KERN_ALERT "[DISPLAY] VERT_FRONT_PORCH_COUNT_REG = %x\n", temp_val);
+
+	temp_val = REG_READ(HORIZ_SYNC_PAD_COUNT_REG);
+	printk(KERN_ALERT "[DISPLAY] HORIZ_SYNC_PAD_COUNT_REG = %x\n", temp_val);
+	temp_val = REG_READ(HORIZ_BACK_PORCH_COUNT_REG);
+	printk(KERN_ALERT "[DISPLAY] HORIZ_BACK_PORCH_COUNT_REG = %x\n", temp_val);
+	temp_val = REG_READ(HORIZ_FRONT_PORCH_COUNT_REG);
+	printk(KERN_ALERT "[DISPLAY] HORIZ_FRONT_PORCH_COUNT_REG = %x\n", temp_val);
+	temp_val = REG_READ(HORIZ_ACTIVE_AREA_COUNT_REG);
+	printk(KERN_ALERT "[DISPLAY] HORIZ_ACTIVE_AREA_COUNT_REG = %x\n", temp_val);
+
+	temp_val = REG_READ(VIDEO_FMT_REG);
+	printk(KERN_ALERT "[DISPLAY] VIDEO_FMT_REG = %x\n", temp_val);
+
+	temp_val = REG_READ(HS_TX_TIMEOUT_REG);
+	printk(KERN_ALERT "[DISPLAY] HS_TX_TIMEOUT_REG = %x\n", temp_val);
+	temp_val = REG_READ(LP_RX_TIMEOUT_REG);
+	printk(KERN_ALERT "[DISPLAY] LP_RX_TIMEOUT_REG = %x\n", temp_val);
+
+	temp_val = REG_READ(HIGH_LOW_SWITCH_COUNT_REG);
+	printk(KERN_ALERT "[DISPLAY] HIGH_LOW_SWITCH_COUNT_REG = %x\n", temp_val);
+
+	temp_val = REG_READ(EOT_DISABLE_REG);
+	printk(KERN_ALERT "[DISPLAY] EOT_DISABLE_REG = %x\n", temp_val);
+
+	temp_val = REG_READ(LP_BYTECLK_REG);
+	printk(KERN_ALERT "[DISPLAY] LP_BYTECLK_REG = %x\n", temp_val);
+	temp_val = REG_READ(MAX_RET_PAK_REG);
+	printk(KERN_ALERT "[DISPLAY] MAX_RET_PAK_REG = %x\n", temp_val);
+	temp_val = REG_READ(DPI_CONTROL_REG);
+	printk(KERN_ALERT "[DISPLAY] DPI_CONTROL_REG = %x\n", temp_val);
+	temp_val = REG_READ(DPHY_PARAM_REG);
+	printk(KERN_ALERT "[DISPLAY] DPHY_PARAM_REG = %x\n", temp_val);
+//	temp_val = REG_READ(PIPEACONF);
+//	printk(KERN_INFO "[DISPLAY] PIPEACONF = %x\n", temp_val);
+//	temp_val = REG_READ(DSPACNTR);
+//	printk(KERN_INFO "[DISPLAY] DSPACNTR = %x\n", temp_val);
+}
+
+void mdfld_dsi_dpi_mode_set(struct drm_encoder *encoder,
+				   struct drm_display_mode *mode,
+				   struct drm_display_mode *adjusted_mode)
+{
+	struct mdfld_dsi_encoder *dsi_encoder = MDFLD_DSI_ENCODER(encoder);
+	struct mdfld_dsi_dpi_output *dpi_output = MDFLD_DSI_DPI_OUTPUT(dsi_encoder);
+	struct mdfld_dsi_config *dsi_config = mdfld_dsi_encoder_get_config(dsi_encoder);
+	struct drm_device *dev = dsi_config->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int pipe = mdfld_dsi_encoder_get_pipe(dsi_encoder);
+	
+	u32 pipeconf_reg = PIPEACONF;
+	u32 dspcntr_reg = DSPACNTR;
+	u32 mipi_reg = MIPI;
+	u32 reg_offset = 0;
+	
+	u32 pipeconf = dev_priv->pipeconf;
+	u32 dspcntr = dev_priv->dspcntr;
+	u32 mipi = MIPI_PORT_EN | PASS_FROM_SPHY_TO_AFE | SEL_FLOPPED_HSTX;
+	
+	dev_dbg(dev->dev, "set mode %dx%d on pipe %d\n",
+				mode->hdisplay, mode->vdisplay, pipe);
+
+	if(pipe) {
+		pipeconf_reg = PIPECCONF;
+		dspcntr_reg = DSPCCNTR;
+		mipi_reg = MIPI_C;
+		reg_offset = MIPIC_REG_OFFSET;
+	} else {
+		mipi |= 2;
+	}
+	
+	if (!gma_power_begin(dev, true))
+		return;
+
+	/* Set up mipi port FIXME: do at init time */
+	REG_WRITE(mipi_reg, mipi);
+	REG_READ(mipi_reg);
+
+	/* Set up DSI controller DPI interface*/
+	mdfld_dsi_dpi_controller_init(dsi_config, pipe);
+
+	if (mdfld_get_panel_type(dev, pipe) == TMD_VID) {
+ 		/* init driver ic */
+ 		mdfld_dsi_tmd_drv_ic_init(dsi_config, pipe);
+	} else {
+		/*turn on DPI interface*/
+		mdfld_dsi_dpi_turn_on(dpi_output, pipe);
+	}
+	
+	/* Set up pipe */
+	REG_WRITE(pipeconf_reg, pipeconf);
+	REG_READ(pipeconf_reg);
+	
+	/* Set up display plane */
+	REG_WRITE(dspcntr_reg, dspcntr);
+	REG_READ(dspcntr_reg);
+	
+	msleep(20); /* FIXME: this should wait for vblank */
+	
+	dev_dbg(dev->dev, "State %x, power %d\n",
+		REG_READ(MIPIA_INTR_STAT_REG + reg_offset),
+		dpi_output->panel_on);
+
+	if (mdfld_get_panel_type(dev, pipe) == TMD_VID) {
+		//mdfld_dsi_dpi_turn_on(dpi_output, pipe);
+	} else {
+		/* init driver ic */
+		mdfld_dsi_tpo_ic_init(dsi_config, pipe);
+		/*init backlight*/
+		mdfld_dsi_brightness_init(dsi_config, pipe);
+	}
+	
+#ifdef MIPI_DEBUG_LOG
+	dsi_debug_MIPI_reg(dev);
+#endif
+	gma_power_end(dev);
+}
+
+static int mdfld_dpi_panel_reset(int pipe)
+{
+	unsigned gpio;
+	int ret = 0;
+	
+	switch(pipe) {
+	case 0:
+		gpio = 128;
+		break;
+	case 2:
+		gpio = 34;
+		break;
+	default:
+		DRM_ERROR("Invalid output\n");
+		return -EINVAL;
+	}
+	
+	ret = gpio_request(gpio, "gfx");
+	if(ret) {
+		DRM_ERROR("gpio_rqueset failed\n");
+		return ret;
+	}
+	ret = gpio_direction_output(gpio, 1);
+	if(ret) {
+		DRM_ERROR("gpio_direction_output failed\n");
+		goto gpio_error;
+	}
+	
+	gpio_get_value(128);
+	
+gpio_error:
+	if(gpio_is_valid(gpio))
+		gpio_free(gpio);
+	return ret;
+}
+
+/**
+ * Exit from DSR
+ */
+void mdfld_dsi_dpi_exit_idle (struct drm_device *dev, u32 update_src, void *p_surfaceAddr, bool check_hw_on_only)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	if (!gma_power_begin(dev, true)) {
+		DRM_ERROR("hw begin failed\n");
+		return;
+	}
+
+	/* update the surface base address. */
+	if (p_surfaceAddr) {
+		REG_WRITE(DSPASURF, *((u32 *)p_surfaceAddr));
+#if defined(CONFIG_MDFD_DUAL_MIPI)
+		REG_WRITE(DSPCSURF, *((u32 *)p_surfaceAddr));
+#endif
+	}
+	mid_enable_pipe_event(dev_priv, 0);
+	psb_enable_pipestat(dev_priv, 0, PIPE_VBLANK_INTERRUPT_ENABLE);
+	dev_priv->is_in_idle = false;
+	dev_priv->dsr_idle_count = 0;
+}
+
+/*
+ * Init DSI DPI encoder. 
+ * Allocate an mdfld_dsi_encoder and attach it to given @dsi_connector
+ * return pointer of newly allocated DPI encoder, NULL on error
+ */ 
+struct mdfld_dsi_encoder *mdfld_dsi_dpi_init(struct drm_device *dev, 
+				struct mdfld_dsi_connector *dsi_connector,
+				struct panel_funcs*p_funcs)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mdfld_dsi_dpi_output *dpi_output = NULL;
+	struct mdfld_dsi_config *dsi_config;
+	struct drm_connector *connector = NULL;
+	struct drm_encoder *encoder = NULL;
+	struct drm_display_mode *fixed_mode = NULL;
+	int ret;
+
+	if (!dsi_connector) {
+		WARN_ON(1);
+		return NULL;
+	}
+
+	dpi_output = kzalloc(sizeof(struct mdfld_dsi_dpi_output), GFP_KERNEL);
+	if(!dpi_output) {
+		dev_err(dev->dev, "No memory for dsi_dpi_output\n");
+		return NULL;
+	}
+	/* Panel reset */
+	ret = mdfld_dpi_panel_reset(dsi_connector->pipe);
+	if(ret) {
+		DRM_ERROR("reset panel error\n");
+		goto out_err1;
+	}
+	
+	if(dsi_connector->pipe) 
+		dpi_output->panel_on = 0;
+
+		dpi_output->panel_on = 0;
+	
+	
+	dpi_output->dev = dev;
+	dpi_output->first_boot = 1;
+	
+	/* Get fixed mode */
+	dsi_config = mdfld_dsi_get_config(dsi_connector);
+	fixed_mode = dsi_config->fixed_mode;
+	
+	/* Create drm encoder object */
+	connector = &dsi_connector->base.base;
+	encoder = &dpi_output->base.base;
+	drm_encoder_init(dev,
+			encoder,
+			p_funcs->encoder_funcs,
+			DRM_MODE_ENCODER_MIPI);
+	drm_encoder_helper_add(encoder,
+				p_funcs->encoder_helper_funcs);
+	
+	/* Attach to given connector */
+	drm_mode_connector_attach_encoder(connector, encoder);
+	
+	/* Set possible crtcs and clones */
+	if(dsi_connector->pipe) {
+		encoder->possible_crtcs = (1 << 2);
+		encoder->possible_clones = (1 << 1);
+	} else {
+		encoder->possible_crtcs = (1 << 0);
+		encoder->possible_clones = (1 << 0);
+	}
+
+	dev_priv->dsr_fb_update = 0;
+	dev_priv->dsr_enable = false;
+	dev_priv->exit_idle = mdfld_dsi_dpi_exit_idle;
+#if defined(CONFIG_MDFLD_DSI_DPU) || defined(CONFIG_MDFLD_DSI_DSR)
+	dev_priv->dsr_enable_config = true;
+#endif /*CONFIG_MDFLD_DSI_DSR*/
+
+	return &dpi_output->base;
+	
+out_err1: 
+	if(dpi_output)
+		kfree(dpi_output);
+	return NULL;	
+}
+
diff --git a/drivers/staging/gma500/mdfld_dsi_dpi.h b/drivers/staging/gma500/mdfld_dsi_dpi.h
new file mode 100644
index 0000000..68e65cc
--- /dev/null
+++ b/drivers/staging/gma500/mdfld_dsi_dpi.h
@@ -0,0 +1,80 @@
+/*
+ * Copyright © 2010 Intel Corporation
+ *
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * jim liu <jim.liu@intel.com>
+ * Jackie Li<yaodong.li@intel.com>
+ */
+
+#ifndef __MDFLD_DSI_DPI_H__
+#define __MDFLD_DSI_DPI_H__
+
+#include "mdfld_dsi_output.h"
+#include "mdfld_output.h"
+
+struct mdfld_dsi_dpi_timing {
+	u16 hsync_count;
+	u16 hbp_count;
+	u16 hfp_count;
+	u16 hactive_count;
+	u16 vsync_count;
+	u16 vbp_count;
+	u16 vfp_count;
+};
+
+struct mdfld_dsi_dpi_output {
+	struct mdfld_dsi_encoder base;
+	struct drm_device *dev;
+
+	int panel_on;
+	int first_boot;
+};
+
+#define MDFLD_DSI_DPI_OUTPUT(dsi_encoder) \
+	container_of(dsi_encoder, struct mdfld_dsi_dpi_output, base)
+
+extern int mdfld_dsi_dpi_timing_calculation(struct drm_display_mode *mode,
+			struct mdfld_dsi_dpi_timing *dpi_timing,
+			int num_lane, int bpp);
+extern struct mdfld_dsi_encoder *mdfld_dsi_dpi_init(struct drm_device *dev,
+			struct mdfld_dsi_connector *dsi_connector,
+			struct panel_funcs *p_funcs);
+
+/* Medfield DPI helper functions */
+extern void mdfld_dsi_dpi_dpms(struct drm_encoder *encoder, int mode);
+extern bool mdfld_dsi_dpi_mode_fixup(struct drm_encoder *encoder,
+			struct drm_display_mode *mode,
+			struct drm_display_mode *adjusted_mode);
+extern void mdfld_dsi_dpi_prepare(struct drm_encoder *encoder);
+extern void mdfld_dsi_dpi_commit(struct drm_encoder *encoder);
+extern void mdfld_dsi_dpi_mode_set(struct drm_encoder *encoder,
+			struct drm_display_mode *mode,
+			struct drm_display_mode *adjusted_mode);
+extern void mdfld_dsi_dpi_turn_on(struct mdfld_dsi_dpi_output *output,
+			int pipe);
+extern void mdfld_dsi_dpi_controller_init(struct mdfld_dsi_config *si_config,
+			int pipe);
+extern void mid_enable_pipe_event(struct drm_psb_private *dev_priv, int pipe);
+extern void psb_enable_pipestat(struct drm_psb_private *dev_priv, int pipe,
+			u32 mask);
+
+#endif /*__MDFLD_DSI_DPI_H__*/
diff --git a/drivers/staging/gma500/mdfld_dsi_output.c b/drivers/staging/gma500/mdfld_dsi_output.c
new file mode 100644
index 0000000..44ee3f6
--- /dev/null
+++ b/drivers/staging/gma500/mdfld_dsi_output.c
@@ -0,0 +1,977 @@
+/*
+ * Copyright © 2010 Intel Corporation
+ *
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * jim liu <jim.liu@intel.com>
+ * Jackie Li<yaodong.li@intel.com>
+ */
+
+#include "mdfld_dsi_output.h"
+#include "mdfld_dsi_dbi.h"
+#include "mdfld_dsi_dpi.h"
+#include "mdfld_output.h"
+#include <asm/intel_scu_ipc.h>
+#include "mdfld_dsi_pkg_sender.h"
+#include <linux/pm_runtime.h>
+
+#define MDFLD_DSI_BRIGHTNESS_MAX_LEVEL 100
+
+/* get the CABC LABC from command line. */
+static int CABC_control = 1;
+static int LABC_control = 1;
+
+#ifdef MODULE
+module_param (CABC_control, int, 0644);
+module_param (LABC_control, int, 0644);
+#else
+static int __init parse_CABC_control(char *arg)
+{
+	/* CABC control can be passed in as a cmdline parameter */
+	/* to enable this feature add CABC=1 to cmdline */
+	/* to disable this feature add CABC=0 to cmdline */
+	if (!arg)
+		return -EINVAL;
+
+	if (!strcasecmp(arg, "0"))
+		CABC_control = 0;
+	else if (!strcasecmp (arg, "1"))
+		CABC_control = 1;
+
+	return 0;
+}
+early_param ("CABC", parse_CABC_control);
+
+static int __init parse_LABC_control(char *arg)
+{
+	/* LABC control can be passed in as a cmdline parameter */
+	/* to enable this feature add LABC=1 to cmdline */
+	/* to disable this feature add LABC=0 to cmdline */
+	if (!arg)
+		return -EINVAL;
+
+	if (!strcasecmp(arg, "0"))
+		LABC_control = 0;
+	else if (!strcasecmp (arg, "1"))
+		LABC_control = 1;
+
+	return 0;
+}
+early_param ("LABC", parse_LABC_control);
+#endif
+
+/**
+ * make these MCS command global 
+ * we don't need 'movl' everytime we send them.
+ * FIXME: these datas were provided by OEM, we should get them from GCT.
+ **/
+static u32 mdfld_dbi_mcs_hysteresis[] = {
+	0x42000f57, 0x8c006400, 0xff00bf00, 0xffffffff,
+	0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff,
+	0x38000aff, 0x82005000, 0xff00ab00, 0xffffffff,
+	0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff,
+	0x000000ff,
+};
+
+static u32 mdfld_dbi_mcs_display_profile[] = {
+	0x50281450, 0x0000c882, 0x00000000, 0x00000000,
+	0x00000000,
+};
+
+static u32 mdfld_dbi_mcs_kbbc_profile[] = {
+	0x00ffcc60, 0x00000000, 0x00000000, 0x00000000,
+}; 
+	
+static u32 mdfld_dbi_mcs_gamma_profile[] = {
+	0x81111158, 0x88888888, 0x88888888,
+}; 
+
+/*
+ * write hysteresis values.
+ */
+static void mdfld_dsi_write_hysteresis (struct mdfld_dsi_config * dsi_config, int pipe)
+{
+	struct mdfld_dsi_pkg_sender * sender = mdfld_dsi_get_pkg_sender(dsi_config);
+
+	if(!sender) {
+	        WARN_ON(1);
+		return;
+	}
+	mdfld_dsi_send_mcs_long_hs(sender,
+				   mdfld_dbi_mcs_hysteresis,
+				   17,
+				   MDFLD_DSI_SEND_PACKAGE);
+}
+
+/*
+ * write display profile values.
+ */
+static void mdfld_dsi_write_display_profile (struct mdfld_dsi_config * dsi_config, int pipe)
+{
+	struct mdfld_dsi_pkg_sender * sender = mdfld_dsi_get_pkg_sender(dsi_config);
+
+	if(!sender) {
+	        WARN_ON(1);
+		return;
+        }
+	mdfld_dsi_send_mcs_long_hs(sender,
+				   mdfld_dbi_mcs_display_profile,
+				   5,
+				   MDFLD_DSI_SEND_PACKAGE);
+}
+
+/*
+ * write KBBC profile values.
+ */
+static void mdfld_dsi_write_kbbc_profile (struct mdfld_dsi_config * dsi_config, int pipe)
+{
+	struct mdfld_dsi_pkg_sender * sender = mdfld_dsi_get_pkg_sender(dsi_config);
+
+	if(!sender) {
+	        WARN_ON(1);
+		return;
+        }
+	mdfld_dsi_send_mcs_long_hs(sender,
+				   mdfld_dbi_mcs_kbbc_profile,
+				   4,
+				   MDFLD_DSI_SEND_PACKAGE);
+}
+
+/**
+ * write gamma setting.
+ */
+static void mdfld_dsi_write_gamma_setting (struct mdfld_dsi_config * dsi_config, int pipe)
+{
+	struct mdfld_dsi_pkg_sender * sender = mdfld_dsi_get_pkg_sender(dsi_config);
+
+	if(!sender) {
+	        WARN_ON(1);
+		return;
+	}
+	mdfld_dsi_send_mcs_long_hs(sender,
+				   mdfld_dbi_mcs_gamma_profile,
+				   3,
+				   MDFLD_DSI_SEND_PACKAGE);
+}
+
+/**
+ * Check and see if the generic control or data buffer is empty and ready.
+ */
+void mdfld_dsi_gen_fifo_ready (struct drm_device *dev, u32 gen_fifo_stat_reg, u32 fifo_stat)
+{
+	u32 GEN_BF_time_out_count = 0;
+	
+	/* Check MIPI Adatper command registers */
+	for (GEN_BF_time_out_count = 0; GEN_BF_time_out_count < GEN_FB_TIME_OUT; GEN_BF_time_out_count++)
+	{
+		if ((REG_READ(gen_fifo_stat_reg) & fifo_stat) == fifo_stat)
+			break;
+		udelay (100);
+	}
+
+	if (GEN_BF_time_out_count == GEN_FB_TIME_OUT)
+		dev_err(dev->dev,
+        "mdfld_dsi_gen_fifo_ready, Timeout. gen_fifo_stat_reg = 0x%x. \n",
+                                                gen_fifo_stat_reg);
+}
+
+/**
+ * Manage the DSI MIPI keyboard and display brightness.
+ * FIXME: this is exported to OSPM code. should work out an specific 
+ * display interface to OSPM. 
+ */
+void mdfld_dsi_brightness_init (struct mdfld_dsi_config * dsi_config, int pipe)
+{
+	struct mdfld_dsi_pkg_sender * sender = mdfld_dsi_get_pkg_sender(dsi_config);
+	struct drm_device * dev = sender->dev;
+	struct drm_psb_private * dev_priv = dev->dev_private;
+	u32 gen_ctrl_val;
+	
+	if(!sender) {
+	        WARN_ON(1);
+	        return;
+	}
+	/* Set default display backlight value to 85% (0xd8)*/
+	mdfld_dsi_send_mcs_short_hs(sender,
+				    write_display_brightness,
+				    0xd8,
+				    1,
+				    MDFLD_DSI_SEND_PACKAGE);
+
+	/* Set minimum brightness setting of CABC function to 20% (0x33)*/
+	mdfld_dsi_send_mcs_short_hs(sender,
+				    write_cabc_min_bright,
+				    0x33,
+				    1,
+				    MDFLD_DSI_SEND_PACKAGE);
+
+	mdfld_dsi_write_hysteresis (dsi_config, pipe);
+	mdfld_dsi_write_display_profile (dsi_config, pipe);
+	mdfld_dsi_write_kbbc_profile (dsi_config, pipe);
+	mdfld_dsi_write_gamma_setting (dsi_config, pipe);
+
+	/* Enable backlight or/and LABC */
+	gen_ctrl_val = BRIGHT_CNTL_BLOCK_ON | DISPLAY_DIMMING_ON| BACKLIGHT_ON;
+	if (LABC_control == 1 || CABC_control == 1)
+		gen_ctrl_val |= DISPLAY_DIMMING_ON| DISPLAY_BRIGHTNESS_AUTO | GAMMA_AUTO;
+
+	if (LABC_control == 1)
+		gen_ctrl_val |= AMBIENT_LIGHT_SENSE_ON;
+
+	dev_priv->mipi_ctrl_display = gen_ctrl_val;
+
+	mdfld_dsi_send_mcs_short_hs(sender,
+				    write_ctrl_display,
+				    (u8)gen_ctrl_val,
+				    1,
+				    MDFLD_DSI_SEND_PACKAGE);
+
+	if (CABC_control == 0)
+		return;
+	mdfld_dsi_send_mcs_short_hs(sender,
+				    write_ctrl_cabc,
+				    UI_IMAGE,
+				    1,
+				    MDFLD_DSI_SEND_PACKAGE);
+}
+
+/**
+ * Manage the mipi display brightness.
+ * TODO: refine this interface later
+ */
+void mdfld_dsi_brightness_control(struct drm_device *dev, int pipe, int level)
+{
+	struct mdfld_dsi_pkg_sender *sender;
+	struct drm_psb_private *dev_priv;
+	struct mdfld_dsi_config *dsi_config;
+	u32 gen_ctrl_val = 0;
+	int p_type = TMD_VID;	
+	
+	if (!dev || (pipe != 0 && pipe != 2)) {
+		dev_err(dev->dev, "Invalid parameter\n");
+		return;
+	}
+
+	p_type = mdfld_get_panel_type(dev, 0);
+
+	dev_priv = dev->dev_private;
+
+	if(pipe)
+		dsi_config = dev_priv->dsi_configs[1];
+	else
+		dsi_config = dev_priv->dsi_configs[0];
+
+	sender = mdfld_dsi_get_pkg_sender(dsi_config);
+
+	if(!sender) {
+	        WARN_ON(1);
+		return;
+	}
+
+	gen_ctrl_val = ((level * 0xff) / MDFLD_DSI_BRIGHTNESS_MAX_LEVEL) & 0xff;
+
+	dev_dbg(dev->dev, "pipe = %d, gen_ctrl_val = %d.  \n", pipe, gen_ctrl_val);
+	
+	if(p_type == TMD_VID || p_type == TMD_CMD){
+		/* Set display backlight value */
+		mdfld_dsi_send_mcs_short_hs(sender, 
+					tmd_write_display_brightness, 
+					(u8)gen_ctrl_val, 
+	                                 1, 
+	                        	MDFLD_DSI_SEND_PACKAGE);		
+	} else {			
+		/* Set display backlight value */
+		mdfld_dsi_send_mcs_short_hs(sender,
+				    write_display_brightness,
+				    (u8)gen_ctrl_val,
+                                    1,
+                                    MDFLD_DSI_SEND_PACKAGE);
+
+
+		/* Enable backlight control */
+		if (level == 0)
+			gen_ctrl_val = 0;
+		else 
+			gen_ctrl_val = dev_priv->mipi_ctrl_display;
+
+		mdfld_dsi_send_mcs_short_hs(sender,
+                                    write_ctrl_display,
+                                   (u8)gen_ctrl_val,
+                                   1,
+                                   MDFLD_DSI_SEND_PACKAGE);
+	}
+}
+
+/*
+ * shut down DSI controller
+ */ 
+void mdfld_dsi_controller_shutdown(struct mdfld_dsi_config * dsi_config, int pipe)
+{
+	struct drm_device * dev;
+	u32 reg_offset = pipe ? MIPIC_REG_OFFSET : 0;
+	int retry = 100;
+	
+	if (!dsi_config) {
+	        WARN_ON(1);
+		return;
+	}
+	
+	dev = dsi_config->dev;
+	
+	if (!gma_power_begin(dev, true)) {
+		dev_err(dev->dev, "hw begin failed\n");
+		return;
+	}
+		
+	if(!(REG_READ(MIPIA_DEVICE_READY_REG + reg_offset) &  DSI_DEVICE_READY)) 
+		goto shutdown_out;
+	
+	/*send shut down package, clean packet send bit first*/
+	if(REG_READ(MIPIA_INTR_STAT_REG + reg_offset) & DSI_INTR_STATE_SPL_PKG_SENT) {
+		REG_WRITE((MIPIA_INTR_STAT_REG + reg_offset), 
+				(REG_READ(MIPIA_INTR_STAT_REG + reg_offset) | DSI_INTR_STATE_SPL_PKG_SENT));
+	}
+	
+	/*send shut down package in HS*/
+	REG_WRITE((MIPIA_DPI_CONTROL_REG + reg_offset), DSI_DPI_CTRL_HS_SHUTDOWN);
+	
+	
+	/*
+	 * make sure shut down is sent.
+	 * FIXME: add max retry counter
+	 */
+	while(!(REG_READ(MIPIA_INTR_STAT_REG + reg_offset) & DSI_INTR_STATE_SPL_PKG_SENT)) {
+		retry--;
+		
+		if(!retry) {
+			dev_err(dev->dev, "timeout\n");
+			break;
+		}
+	}
+	
+	/*sleep 1 ms to ensure shutdown finished*/
+	msleep(100);
+	
+	/*un-ready device*/
+	REG_WRITE((MIPIA_DEVICE_READY_REG + reg_offset),
+			   (REG_READ(MIPIA_DEVICE_READY_REG + reg_offset) & ~DSI_DEVICE_READY));
+
+shutdown_out:			   
+	gma_power_end(dev);
+}
+
+void mdfld_dsi_controller_startup(struct mdfld_dsi_config * dsi_config, int pipe)
+{
+	struct drm_device * dev;
+	u32 reg_offset = pipe ? MIPIC_REG_OFFSET : 0;
+	int retry = 100;
+	
+	
+	if (!dsi_config) {
+		WARN_ON(1);
+		return;
+	}
+	
+	dev = dsi_config->dev;
+	dev_dbg(dev->dev, "starting up DSI controller on pipe %d...\n", pipe);
+	
+	if (!gma_power_begin(dev, true)) {
+		dev_err(dev->dev, "hw begin failed\n");
+		return;
+	}
+	
+	if((REG_READ(MIPIA_DEVICE_READY_REG + reg_offset) & DSI_DEVICE_READY)) 
+		goto startup_out;
+	
+	/*if config DPI, turn on DPI interface*/
+	if(dsi_config->type == MDFLD_DSI_ENCODER_DPI) {
+		if(REG_READ(MIPIA_INTR_STAT_REG + reg_offset) & DSI_INTR_STATE_SPL_PKG_SENT) {
+			REG_WRITE((MIPIA_INTR_STAT_REG + reg_offset), DSI_INTR_STATE_SPL_PKG_SENT);
+		}
+		
+		REG_WRITE((MIPIA_DPI_CONTROL_REG + reg_offset), DSI_DPI_CTRL_HS_TURN_ON);
+		
+		/*
+		 * make sure shut down is sent.
+		 * FIXME: add max retry counter
+		 */
+		while(!(REG_READ(MIPIA_INTR_STAT_REG + reg_offset) & DSI_INTR_STATE_SPL_PKG_SENT)) {
+			retry--;
+			if(!retry) {
+				dev_err(dev->dev, "timeout\n");
+				break;
+			}
+		}
+		
+		msleep(100);
+	}
+	
+	/*set device ready*/
+	REG_WRITE((MIPIA_DEVICE_READY_REG + reg_offset),
+			   (REG_READ(MIPIA_DEVICE_READY_REG + reg_offset) | DSI_DEVICE_READY));
+
+startup_out:	
+	gma_power_end(dev);
+}
+
+/*
+ * NOTE: this function was used by OSPM.
+ * TODO: will be removed later, should work out display interfaces for OSPM
+ */
+void mdfld_dsi_controller_init(struct mdfld_dsi_config * dsi_config, int pipe)
+{
+	if(!dsi_config || ((pipe != 0) && (pipe != 2))) {
+	        WARN_ON(1);
+		return;
+	}
+
+	if(dsi_config->type)
+		mdfld_dsi_dpi_controller_init(dsi_config, pipe);
+	else
+		mdfld_dsi_controller_dbi_init(dsi_config, pipe);
+}
+
+static void mdfld_dsi_connector_save(struct drm_connector * connector)
+{
+}
+
+static void mdfld_dsi_connector_restore(struct drm_connector * connector)
+{
+}
+
+static enum drm_connector_status mdfld_dsi_connector_detect(struct drm_connector * connector, bool force)
+{
+	return connector_status_connected;
+}
+
+static int mdfld_dsi_connector_set_property(struct drm_connector * connector,
+											struct drm_property * property,
+											uint64_t value)
+{
+	struct drm_encoder * encoder = connector->encoder;
+	struct backlight_device * psb_bd;
+
+	if (!strcmp(property->name, "scaling mode") && encoder) {
+		struct psb_intel_crtc * psb_crtc = to_psb_intel_crtc(encoder->crtc);
+		bool bTransitionFromToCentered;
+		uint64_t curValue;
+
+		if (!psb_crtc)
+			goto set_prop_error;
+
+		switch (value) {
+		case DRM_MODE_SCALE_FULLSCREEN:
+			break;
+		case DRM_MODE_SCALE_NO_SCALE:
+			break;
+		case DRM_MODE_SCALE_ASPECT:
+			break;
+		default:
+			goto set_prop_error;
+		}
+
+		if (drm_connector_property_get_value(connector, property, &curValue))
+			goto set_prop_error;
+
+		if (curValue == value)
+			goto set_prop_done;
+
+		if (drm_connector_property_set_value(connector, property, value))
+			goto set_prop_error;
+
+		bTransitionFromToCentered = (curValue == DRM_MODE_SCALE_NO_SCALE) ||
+			(value == DRM_MODE_SCALE_NO_SCALE);
+
+		if (psb_crtc->saved_mode.hdisplay != 0 &&
+		    psb_crtc->saved_mode.vdisplay != 0) {
+			if (bTransitionFromToCentered) {
+				if (!drm_crtc_helper_set_mode(encoder->crtc, &psb_crtc->saved_mode,
+					    encoder->crtc->x, encoder->crtc->y, encoder->crtc->fb))
+					goto set_prop_error;
+			} else {
+				struct drm_encoder_helper_funcs *pEncHFuncs  = encoder->helper_private;
+				pEncHFuncs->mode_set(encoder, &psb_crtc->saved_mode,
+						     &psb_crtc->saved_adjusted_mode);
+			}
+		}
+	} else if (!strcmp(property->name, "backlight") && encoder) {
+		dev_dbg(encoder->dev->dev, "backlight level = %d\n", (int)value);
+		if (drm_connector_property_set_value(connector, property, value))
+			goto set_prop_error;
+		else {
+			dev_dbg(encoder->dev->dev,
+			                "set brightness to %d", (int)value);
+			psb_bd = psb_get_backlight_device();
+			if(psb_bd) {
+				psb_bd->props.brightness = value;
+				psb_set_brightness(psb_bd);
+			}
+		}
+	} 
+set_prop_done:
+    return 0;
+set_prop_error:
+    return -1;
+}
+
+static void mdfld_dsi_connector_destroy(struct drm_connector * connector)
+{
+	struct psb_intel_output * psb_output = to_psb_intel_output(connector);
+	struct mdfld_dsi_connector * dsi_connector = MDFLD_DSI_CONNECTOR(psb_output);
+	struct mdfld_dsi_pkg_sender * sender;
+	
+	if(!dsi_connector)
+	        return;
+	
+	drm_sysfs_connector_remove(connector);
+	drm_connector_cleanup(connector);
+	
+	sender = dsi_connector->pkg_sender;
+
+	mdfld_dsi_pkg_sender_destroy(sender);
+
+	kfree(dsi_connector);
+}
+
+static int mdfld_dsi_connector_get_modes(struct drm_connector * connector)
+{
+	struct psb_intel_output * psb_output = to_psb_intel_output(connector);
+	struct mdfld_dsi_connector * dsi_connector = MDFLD_DSI_CONNECTOR(psb_output);
+	struct mdfld_dsi_config * dsi_config = mdfld_dsi_get_config(dsi_connector);
+	struct drm_display_mode * fixed_mode = dsi_config->fixed_mode;
+	struct drm_display_mode * dup_mode = NULL;
+	struct drm_device * dev = connector->dev;
+	
+	connector->display_info.min_vfreq = 0;
+	connector->display_info.max_vfreq = 200;
+	connector->display_info.min_hfreq = 0;
+	connector->display_info.max_hfreq = 200;
+
+	if(fixed_mode) {
+		dev_dbg(dev->dev, "fixed_mode %dx%d\n",
+		        fixed_mode->hdisplay, fixed_mode->vdisplay);
+		
+		dup_mode = drm_mode_duplicate(dev, fixed_mode);
+		drm_mode_probed_add(connector, dup_mode);
+		return 1;
+	}
+	dev_err(dev->dev, "Didn't get any modes!\n");
+	return 0;
+}
+
+static int mdfld_dsi_connector_mode_valid(struct drm_connector * connector, struct drm_display_mode * mode)
+{
+	struct psb_intel_output * psb_output = to_psb_intel_output(connector);
+	struct mdfld_dsi_connector * dsi_connector = MDFLD_DSI_CONNECTOR(psb_output);
+	struct mdfld_dsi_config * dsi_config = mdfld_dsi_get_config(dsi_connector);
+	struct drm_display_mode * fixed_mode = dsi_config->fixed_mode;
+
+	dev_dbg(connector->dev->dev, "mode %p, fixed mode %p\n",
+	                                                mode, fixed_mode);
+
+	if(mode->flags & DRM_MODE_FLAG_DBLSCAN) 
+		return MODE_NO_DBLESCAN;
+
+	if(mode->flags & DRM_MODE_FLAG_INTERLACE)
+		return MODE_NO_INTERLACE;
+
+	/**
+	 * FIXME: current DC has no fitting unit, reject any mode setting request
+	 * will figure out a way to do up-scaling(pannel fitting) later.  
+	 **/
+	if(fixed_mode) {
+		if(mode->hdisplay != fixed_mode->hdisplay)
+			return MODE_PANEL;
+
+		if(mode->vdisplay != fixed_mode->vdisplay)
+			return MODE_PANEL;
+	}
+	dev_dbg(connector->dev->dev, "mode ok\n");
+
+	return MODE_OK;
+}
+
+static void mdfld_dsi_connector_dpms(struct drm_connector *connector, int mode)
+{
+#ifdef CONFIG_PM_RUNTIME
+	struct drm_device * dev = connector->dev;
+	struct drm_psb_private * dev_priv = dev->dev_private;
+	bool panel_on, panel_on2;
+#endif
+	/* First, execute DPMS */
+	drm_helper_connector_dpms(connector, mode);
+
+#ifdef CONFIG_PM_RUNTIME
+	if(mdfld_panel_dpi(dev)) {
+		/* DPI panel */
+		panel_on = dev_priv->dpi_panel_on;
+		panel_on2 = dev_priv->dpi_panel_on2;
+	} else {
+		/* DBI panel */
+		panel_on = dev_priv->dbi_panel_on;
+		panel_on2 = dev_priv->dbi_panel_on2;
+	}
+
+	/* Then check all display panels + monitors status */
+	if(!panel_on && !panel_on2 && !(REG_READ(HDMIB_CONTROL)
+	                                        & HDMIB_PORT_EN)) {
+		/*request rpm idle*/
+		if(dev_priv->rpm_enabled)
+			pm_request_idle(&dev->pdev->dev);
+	}
+	/*
+	 * if rpm wasn't enabled yet, try to allow it
+	 * FIXME: won't enable rpm for DPI since DPI
+	 * CRTC setting is a little messy now.
+	 * Enable it later!
+	 */
+#if 0
+	if(!dev_priv->rpm_enabled && !mdfld_panel_dpi(dev))
+		ospm_runtime_pm_allow(dev);
+#endif
+#endif
+}
+
+static struct drm_encoder * mdfld_dsi_connector_best_encoder(
+                                        struct drm_connector * connector) 
+{
+	struct psb_intel_output * psb_output = to_psb_intel_output(connector);
+	struct mdfld_dsi_connector * dsi_connector = MDFLD_DSI_CONNECTOR(psb_output);
+	struct mdfld_dsi_config * dsi_config = mdfld_dsi_get_config(dsi_connector);
+	struct mdfld_dsi_encoder * encoder = NULL;
+	
+	if(dsi_config->type == MDFLD_DSI_ENCODER_DBI) 
+		encoder = dsi_config->encoders[MDFLD_DSI_ENCODER_DBI];
+	else if (dsi_config->type == MDFLD_DSI_ENCODER_DPI) 
+		encoder = dsi_config->encoders[MDFLD_DSI_ENCODER_DPI];
+	
+	dev_dbg(connector->dev->dev, "get encoder %p\n", encoder);
+	
+	if(!encoder) {
+		dev_err(connector->dev->dev,
+                        "Invalid encoder for type %d\n", dsi_config->type);
+		return NULL;
+	}
+	dsi_config->encoder = encoder;	
+	return &encoder->base;	
+}
+
+/* DSI connector funcs */
+static const struct drm_connector_funcs mdfld_dsi_connector_funcs = {
+	.dpms = /*drm_helper_connector_dpms*/mdfld_dsi_connector_dpms,
+	.save = mdfld_dsi_connector_save,
+	.restore = mdfld_dsi_connector_restore,
+	.detect = mdfld_dsi_connector_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.set_property = mdfld_dsi_connector_set_property,
+	.destroy = mdfld_dsi_connector_destroy,
+};
+
+/* DSI connector helper funcs */
+static const struct drm_connector_helper_funcs mdfld_dsi_connector_helper_funcs = {
+	.get_modes = mdfld_dsi_connector_get_modes,
+	.mode_valid = mdfld_dsi_connector_mode_valid,
+	.best_encoder = mdfld_dsi_connector_best_encoder,
+};
+
+static int mdfld_dsi_get_default_config(struct drm_device * dev, 
+										struct mdfld_dsi_config * config, int pipe)
+{
+	if(!dev || !config) {
+	        WARN_ON(1);
+		return -EINVAL;
+	}
+	
+	config->bpp = 24;
+	config->type = mdfld_panel_dpi(dev);
+	config->lane_count = 2;
+	config->channel_num = 0;
+	/*NOTE: video mode is ignored when type is MDFLD_DSI_ENCODER_DBI*/
+	if (mdfld_get_panel_type(dev, pipe) == TMD_VID) {
+		config->video_mode = MDFLD_DSI_VIDEO_NON_BURST_MODE_SYNC_PULSE;
+	} else {
+		config->video_mode = MDFLD_DSI_VIDEO_BURST_MODE;
+	}
+	
+	return 0;
+}
+
+/*
+ * Returns the panel fixed mode from configuration. 
+ */
+struct drm_display_mode *
+mdfld_dsi_get_configuration_mode(struct mdfld_dsi_config * dsi_config, int pipe)
+{
+	struct drm_device *dev = dsi_config->dev;
+	struct drm_display_mode *mode;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mrst_timing_info *ti = &dev_priv->gct_data.DTD;
+	bool use_gct = false;
+
+	mode = kzalloc(sizeof(*mode), GFP_KERNEL);
+	if (!mode) {
+	        dev_err(dev->dev, "Out of memory for mode\n");
+		return NULL;
+        }
+	if (use_gct) {
+		dev_dbg(dev->dev, "gct find MIPI panel.\n");
+
+		mode->hdisplay = (ti->hactive_hi << 8) | ti->hactive_lo;
+		mode->vdisplay = (ti->vactive_hi << 8) | ti->vactive_lo;
+		mode->hsync_start = mode->hdisplay + \
+				((ti->hsync_offset_hi << 8) | \
+				ti->hsync_offset_lo);
+		mode->hsync_end = mode->hsync_start + \
+				((ti->hsync_pulse_width_hi << 8) | \
+				ti->hsync_pulse_width_lo);
+		mode->htotal = mode->hdisplay + ((ti->hblank_hi << 8) | \
+								ti->hblank_lo);
+		mode->vsync_start = \
+			mode->vdisplay + ((ti->vsync_offset_hi << 8) | \
+						ti->vsync_offset_lo);
+		mode->vsync_end = \
+			mode->vsync_start + ((ti->vsync_pulse_width_hi << 8) | \
+						ti->vsync_pulse_width_lo);
+		mode->vtotal = mode->vdisplay + \
+				((ti->vblank_hi << 8) | ti->vblank_lo);
+		mode->clock = ti->pixel_clock * 10;
+
+		dev_dbg(dev->dev, "hdisplay is %d\n", mode->hdisplay);
+		dev_dbg(dev->dev, "vdisplay is %d\n", mode->vdisplay);
+		dev_dbg(dev->dev, "HSS is %d\n", mode->hsync_start);
+		dev_dbg(dev->dev, "HSE is %d\n", mode->hsync_end);
+		dev_dbg(dev->dev, "htotal is %d\n", mode->htotal);
+		dev_dbg(dev->dev, "VSS is %d\n", mode->vsync_start);
+		dev_dbg(dev->dev, "VSE is %d\n", mode->vsync_end);
+		dev_dbg(dev->dev, "vtotal is %d\n", mode->vtotal);
+		dev_dbg(dev->dev, "clock is %d\n", mode->clock);
+	} else {
+		if(dsi_config->type == MDFLD_DSI_ENCODER_DPI) { 
+			if (mdfld_get_panel_type(dev, pipe) == TMD_VID) {
+				mode->hdisplay = 480;
+				mode->vdisplay = 854;
+				mode->hsync_start = 487;
+				mode->hsync_end = 490;
+				mode->htotal = 499;
+				mode->vsync_start = 861;
+				mode->vsync_end = 865;
+				mode->vtotal = 873;
+				mode->clock = 33264;
+			} else {
+				mode->hdisplay = 864;
+				mode->vdisplay = 480;
+				mode->hsync_start = 873;
+				mode->hsync_end = 876;
+				mode->htotal = 887;
+				mode->vsync_start = 487;
+				mode->vsync_end = 490;
+				mode->vtotal = 499;
+				mode->clock = 33264;
+			}
+		} else if(dsi_config->type == MDFLD_DSI_ENCODER_DBI) {
+			mode->hdisplay = 864;
+			mode->vdisplay = 480;
+			mode->hsync_start = 872;
+			mode->hsync_end = 876;
+			mode->htotal = 884;
+			mode->vsync_start = 482;
+			mode->vsync_end = 494;
+			mode->vtotal = 486;
+			mode->clock = 25777;
+			
+		}
+	}
+
+	drm_mode_set_name(mode);
+	drm_mode_set_crtcinfo(mode, 0);
+	
+	mode->type |= DRM_MODE_TYPE_PREFERRED;
+
+	return mode;
+}
+
+/*
+ * MIPI output init
+ * @dev drm device
+ * @pipe pipe number. 0 or 2
+ * @config 
+ * 
+ * Do the initialization of a MIPI output, including create DRM mode objects
+ * initialization of DSI output on @pipe 
+ */
+void mdfld_dsi_output_init(struct drm_device * dev,
+			   int pipe, 
+			   struct mdfld_dsi_config * config,
+			   struct panel_funcs* p_cmd_funcs,
+			   struct panel_funcs* p_vid_funcs)
+{
+	struct mdfld_dsi_config * dsi_config;
+	struct mdfld_dsi_connector * dsi_connector;
+	struct psb_intel_output * psb_output;
+	struct drm_connector * connector;
+	struct mdfld_dsi_encoder * encoder;
+	struct drm_psb_private * dev_priv = dev->dev_private;
+	struct panel_info dsi_panel_info;
+	u32 width_mm, height_mm;
+
+	dev_dbg(dev->dev, "init DSI output on pipe %d\n", pipe);
+	
+	if(!dev || ((pipe != 0) && (pipe != 2))) {
+	        WARN_ON(1);
+		return;
+	}
+	
+	/*create a new connetor*/
+	dsi_connector = kzalloc(sizeof(struct mdfld_dsi_connector), GFP_KERNEL);
+	if(!dsi_connector) {
+		DRM_ERROR("No memory");
+		return;
+	}
+	
+	dsi_connector->pipe =  pipe;
+	
+	/*set DSI config*/
+	if(config) { 
+		dsi_config = config;
+	} else {
+		dsi_config = kzalloc(sizeof(struct mdfld_dsi_config), GFP_KERNEL);
+		if(!dsi_config) {
+			dev_err(dev->dev,
+			        "cannot allocate memory for DSI config\n");
+			goto dsi_init_err0;
+		}
+		
+		mdfld_dsi_get_default_config(dev, dsi_config, pipe);
+	}
+	
+	dsi_connector->private = dsi_config;
+	
+	dsi_config->changed = 1;
+	dsi_config->dev = dev;
+	
+	/*init fixed mode basing on DSI config type*/
+	if(dsi_config->type == MDFLD_DSI_ENCODER_DBI) {
+		dsi_config->fixed_mode = p_cmd_funcs->get_config_mode(dev);
+		if(p_cmd_funcs->get_panel_info(dev, pipe, &dsi_panel_info))
+			goto dsi_init_err0;
+	} else if(dsi_config->type == MDFLD_DSI_ENCODER_DPI) {
+		dsi_config->fixed_mode = p_vid_funcs->get_config_mode(dev);
+		if(p_vid_funcs->get_panel_info(dev, pipe, &dsi_panel_info))
+			goto dsi_init_err0;
+	}
+
+	width_mm = dsi_panel_info.width_mm;
+	height_mm = dsi_panel_info.height_mm;
+
+	dsi_config->mode = dsi_config->fixed_mode;
+	dsi_config->connector = dsi_connector;
+	
+	if(!dsi_config->fixed_mode) {
+		dev_err(dev->dev, "No pannel fixed mode was found\n");
+		goto dsi_init_err0;
+	}
+	
+	if(pipe && dev_priv->dsi_configs[0]) {
+		dsi_config->dvr_ic_inited = 0;
+		dev_priv->dsi_configs[1] = dsi_config;
+	} else if(pipe == 0) {
+		dsi_config->dvr_ic_inited = 1;
+		dev_priv->dsi_configs[0] = dsi_config;
+	} else {
+		dev_err(dev->dev, "Trying to init MIPI1 before MIPI0\n");
+		goto dsi_init_err0;
+	}
+
+	/*init drm connector object*/
+	psb_output = &dsi_connector->base;
+	
+	psb_output->type = (pipe == 0) ? INTEL_OUTPUT_MIPI : INTEL_OUTPUT_MIPI2;
+
+	connector = &psb_output->base;
+	drm_connector_init(dev, connector, &mdfld_dsi_connector_funcs, DRM_MODE_CONNECTOR_MIPI);
+	drm_connector_helper_add(connector, &mdfld_dsi_connector_helper_funcs);
+	
+	connector->display_info.subpixel_order = SubPixelHorizontalRGB;
+	connector->display_info.width_mm = width_mm;
+	connector->display_info.height_mm = height_mm;
+	connector->interlace_allowed = false;
+	connector->doublescan_allowed = false;
+	
+	/*attach properties*/
+	drm_connector_attach_property(connector, dev->mode_config.scaling_mode_property, DRM_MODE_SCALE_FULLSCREEN);
+	drm_connector_attach_property(connector, dev_priv->backlight_property, MDFLD_DSI_BRIGHTNESS_MAX_LEVEL);
+
+	/*init DBI & DPI encoders*/
+	if(p_cmd_funcs) {
+		encoder = mdfld_dsi_dbi_init(dev, dsi_connector, p_cmd_funcs);
+		if(!encoder) {
+			dev_err(dev->dev, "Create DBI encoder failed\n");
+			goto dsi_init_err1;
+		}
+		encoder->private = dsi_config;
+		dsi_config->encoders[MDFLD_DSI_ENCODER_DBI] = encoder;
+		if(pipe == 2)
+			dev_priv->encoder2 = encoder;
+	
+		if(pipe == 0)
+			dev_priv->encoder0 = encoder;
+			
+	}
+	
+	if(p_vid_funcs) {
+		encoder = mdfld_dsi_dpi_init(dev, dsi_connector, p_vid_funcs);
+		if(!encoder) {
+			dev_err(dev->dev, "Create DPI encoder failed\n");
+			goto dsi_init_err1;
+		}
+		encoder->private = dsi_config;
+		dsi_config->encoders[MDFLD_DSI_ENCODER_DPI] = encoder;
+
+        if(pipe == 2)
+            dev_priv->encoder2 = encoder;
+
+		if(pipe == 0)
+            dev_priv->encoder0 = encoder;
+	}
+	
+	drm_sysfs_connector_add(connector);
+	
+	/*init DSI package sender on this output*/
+	if(mdfld_dsi_pkg_sender_init(dsi_connector, pipe)) {
+		dev_err(dev->dev, 
+		        "Package Sender initialization failed on pipe %d\n",
+		                                                pipe);
+		goto dsi_init_err2;
+	}
+
+	dev_dbg(dev->dev, "successfully\n");
+	return;
+	
+	/*TODO: add code to destroy outputs on error*/
+dsi_init_err2:
+	drm_sysfs_connector_remove(connector);
+dsi_init_err1:
+	drm_connector_cleanup(connector);
+	kfree(dsi_config->fixed_mode);
+	kfree(dsi_config);
+dsi_init_err0:
+	kfree(dsi_connector);
+}
diff --git a/drivers/staging/gma500/mdfld_dsi_output.h b/drivers/staging/gma500/mdfld_dsi_output.h
new file mode 100644
index 0000000..ac25e55
--- /dev/null
+++ b/drivers/staging/gma500/mdfld_dsi_output.h
@@ -0,0 +1,328 @@
+/*
+ * Copyright © 2010 Intel Corporation
+ *
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * jim liu <jim.liu@intel.com>
+ * Jackie Li<yaodong.li@intel.com>
+ */
+
+#ifndef __MDFLD_DSI_OUTPUT_H__
+#define __MDFLD_DSI_OUTPUT_H__
+
+#include <linux/backlight.h>
+#include <linux/version.h>
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_edid.h>
+
+#include "psb_drv.h"
+#include "psb_intel_drv.h"
+#include "psb_intel_reg.h"
+#include "psb_powermgmt.h"
+#include "mdfld_output.h"
+
+#include <asm/mrst.h>
+
+#define DRM_MODE_ENCODER_MIPI  5
+
+/* Medfield DSI controller registers */
+
+#define MIPIA_DEVICE_READY_REG				0xb000
+#define MIPIA_INTR_STAT_REG				0xb004
+#define MIPIA_INTR_EN_REG				0xb008
+#define MIPIA_DSI_FUNC_PRG_REG				0xb00c
+#define MIPIA_HS_TX_TIMEOUT_REG				0xb010
+#define MIPIA_LP_RX_TIMEOUT_REG				0xb014
+#define MIPIA_TURN_AROUND_TIMEOUT_REG			0xb018
+#define MIPIA_DEVICE_RESET_TIMER_REG			0xb01c
+#define MIPIA_DPI_RESOLUTION_REG			0xb020
+#define MIPIA_DBI_FIFO_THROTTLE_REG			0xb024
+#define MIPIA_HSYNC_COUNT_REG				0xb028
+#define MIPIA_HBP_COUNT_REG				0xb02c
+#define MIPIA_HFP_COUNT_REG				0xb030
+#define MIPIA_HACTIVE_COUNT_REG				0xb034
+#define MIPIA_VSYNC_COUNT_REG				0xb038
+#define MIPIA_VBP_COUNT_REG				0xb03c
+#define MIPIA_VFP_COUNT_REG				0xb040
+#define MIPIA_HIGH_LOW_SWITCH_COUNT_REG			0xb044
+#define MIPIA_DPI_CONTROL_REG				0xb048
+#define MIPIA_DPI_DATA_REG				0xb04c
+#define MIPIA_INIT_COUNT_REG				0xb050
+#define MIPIA_MAX_RETURN_PACK_SIZE_REG			0xb054
+#define MIPIA_VIDEO_MODE_FORMAT_REG			0xb058
+#define MIPIA_EOT_DISABLE_REG				0xb05c
+#define MIPIA_LP_BYTECLK_REG				0xb060
+#define MIPIA_LP_GEN_DATA_REG				0xb064
+#define MIPIA_HS_GEN_DATA_REG				0xb068
+#define MIPIA_LP_GEN_CTRL_REG				0xb06c
+#define MIPIA_HS_GEN_CTRL_REG				0xb070
+#define MIPIA_GEN_FIFO_STAT_REG				0xb074
+#define MIPIA_HS_LS_DBI_ENABLE_REG			0xb078
+#define MIPIA_DPHY_PARAM_REG				0xb080
+#define MIPIA_DBI_BW_CTRL_REG				0xb084
+#define MIPIA_CLK_LANE_SWITCH_TIME_CNT_REG		0xb088
+
+#define DSI_DEVICE_READY				(0x1)
+#define DSI_POWER_STATE_ULPS_ENTER			(0x2 << 1)
+#define DSI_POWER_STATE_ULPS_EXIT			(0x1 << 1)
+#define DSI_POWER_STATE_ULPS_OFFSET			(0x1)
+
+
+#define DSI_ONE_DATA_LANE				(0x1)
+#define DSI_TWO_DATA_LANE				(0x2)
+#define DSI_THREE_DATA_LANE				(0X3)
+#define DSI_FOUR_DATA_LANE				(0x4)
+#define DSI_DPI_VIRT_CHANNEL_OFFSET			(0x3)
+#define DSI_DBI_VIRT_CHANNEL_OFFSET			(0x5)
+#define DSI_DPI_COLOR_FORMAT_RGB565			(0x01 << 7)
+#define DSI_DPI_COLOR_FORMAT_RGB666			(0x02 << 7)
+#define DSI_DPI_COLOR_FORMAT_RGB666_UNPACK		(0x03 << 7)
+#define DSI_DPI_COLOR_FORMAT_RGB888			(0x04 << 7)
+#define DSI_DBI_COLOR_FORMAT_OPTION2			(0x05 << 13)
+
+#define DSI_INTR_STATE_RXSOTERROR			1
+
+#define DSI_INTR_STATE_SPL_PKG_SENT			(1 << 30)
+#define DSI_INTR_STATE_TE				(1 << 31)
+
+#define DSI_HS_TX_TIMEOUT_MASK				(0xffffff)
+
+#define DSI_LP_RX_TIMEOUT_MASK				(0xffffff)
+
+#define DSI_TURN_AROUND_TIMEOUT_MASK			(0x3f)
+
+#define DSI_RESET_TIMER_MASK				(0xffff)
+
+#define DSI_DBI_FIFO_WM_HALF				(0x0)
+#define DSI_DBI_FIFO_WM_QUARTER				(0x1)
+#define DSI_DBI_FIFO_WM_LOW				(0x2)
+
+#define DSI_DPI_TIMING_MASK				(0xffff)
+
+#define DSI_INIT_TIMER_MASK				(0xffff)
+
+#define DSI_DBI_RETURN_PACK_SIZE_MASK			(0x3ff)
+
+#define DSI_LP_BYTECLK_MASK				(0x0ffff)
+
+#define DSI_HS_CTRL_GEN_SHORT_W0			(0x03)
+#define DSI_HS_CTRL_GEN_SHORT_W1			(0x13)
+#define DSI_HS_CTRL_GEN_SHORT_W2			(0x23)
+#define DSI_HS_CTRL_GEN_R0				(0x04)
+#define DSI_HS_CTRL_GEN_R1				(0x14)
+#define DSI_HS_CTRL_GEN_R2				(0x24)
+#define DSI_HS_CTRL_GEN_LONG_W				(0x29)
+#define DSI_HS_CTRL_MCS_SHORT_W0			(0x05)
+#define DSI_HS_CTRL_MCS_SHORT_W1			(0x15)
+#define DSI_HS_CTRL_MCS_R0				(0x06)
+#define DSI_HS_CTRL_MCS_LONG_W				(0x39)
+#define DSI_HS_CTRL_VC_OFFSET				(0x06)
+#define DSI_HS_CTRL_WC_OFFSET				(0x08)
+
+#define	DSI_FIFO_GEN_HS_DATA_FULL			(1 << 0)
+#define DSI_FIFO_GEN_HS_DATA_HALF_EMPTY			(1 << 1)
+#define DSI_FIFO_GEN_HS_DATA_EMPTY			(1 << 2)
+#define DSI_FIFO_GEN_LP_DATA_FULL			(1 << 8)
+#define DSI_FIFO_GEN_LP_DATA_HALF_EMPTY			(1 << 9)
+#define DSI_FIFO_GEN_LP_DATA_EMPTY			(1 << 10)
+#define DSI_FIFO_GEN_HS_CTRL_FULL			(1 << 16)
+#define DSI_FIFO_GEN_HS_CTRL_HALF_EMPTY			(1 << 17)
+#define DSI_FIFO_GEN_HS_CTRL_EMPTY			(1 << 18)
+#define DSI_FIFO_GEN_LP_CTRL_FULL			(1 << 24)
+#define DSI_FIFO_GEN_LP_CTRL_HALF_EMPTY			(1 << 25)
+#define DSI_FIFO_GEN_LP_CTRL_EMPTY			(1 << 26)
+#define DSI_FIFO_DBI_EMPTY				(1 << 27)
+#define DSI_FIFO_DPI_EMPTY				(1 << 28)
+
+#define DSI_DBI_HS_LP_SWITCH_MASK			(0x1)
+
+#define DSI_HS_LP_SWITCH_COUNTER_OFFSET			(0x0)
+#define DSI_LP_HS_SWITCH_COUNTER_OFFSET			(0x16)
+
+#define DSI_DPI_CTRL_HS_SHUTDOWN			(0x00000001)
+#define DSI_DPI_CTRL_HS_TURN_ON				(0x00000002)
+
+/* Medfield DSI adapter registers */
+#define MIPIA_CONTROL_REG				0xb104
+#define MIPIA_DATA_ADD_REG				0xb108
+#define MIPIA_DATA_LEN_REG				0xb10c
+#define MIPIA_CMD_ADD_REG				0xb110
+#define MIPIA_CMD_LEN_REG				0xb114
+
+enum {
+	MDFLD_DSI_ENCODER_DBI = 0,
+	MDFLD_DSI_ENCODER_DPI,
+};
+
+enum {
+	MDFLD_DSI_VIDEO_NON_BURST_MODE_SYNC_PULSE = 1,
+	MDFLD_DSI_VIDEO_NON_BURST_MODE_SYNC_EVENTS = 2,
+	MDFLD_DSI_VIDEO_BURST_MODE = 3,
+};
+
+#define DSI_DPI_COMPLETE_LAST_LINE			(1 << 2)
+#define DSI_DPI_DISABLE_BTA				(1 << 3)
+
+struct mdfld_dsi_connector_state {
+	u32 mipi_ctrl_reg;
+};
+
+struct mdfld_dsi_encoder_state {
+
+};
+
+struct mdfld_dsi_connector {
+	/*
+	 * This is ugly, but I have to use connector in it! :-(
+	 * FIXME: use drm_connector instead.
+	 */
+	struct psb_intel_output base;
+
+	int pipe;
+	void *private;
+	void *pkg_sender;
+};
+
+struct mdfld_dsi_encoder {
+	struct drm_encoder base;
+	void *private;
+};
+
+/*
+ * DSI config, consists of one DSI connector, two DSI encoders.
+ * DRM will pick up on DSI encoder basing on differents configs.
+ */
+struct mdfld_dsi_config {
+	struct drm_device *dev;
+	struct drm_display_mode *fixed_mode;
+	struct drm_display_mode *mode;
+
+	struct mdfld_dsi_connector *connector;
+	struct mdfld_dsi_encoder *encoders[DRM_CONNECTOR_MAX_ENCODER];
+	struct mdfld_dsi_encoder *encoder;
+
+	int changed;
+
+	int bpp;
+	int type;
+	int lane_count;
+	/*Virtual channel number for this encoder*/
+	int channel_num;
+	/*video mode configure*/
+	int video_mode;
+
+	int dvr_ic_inited;
+};
+
+#define MDFLD_DSI_CONNECTOR(psb_output) \
+		(container_of(psb_output, struct mdfld_dsi_connector, base))
+
+#define MDFLD_DSI_ENCODER(encoder) \
+		(container_of(encoder, struct mdfld_dsi_encoder, base))
+
+static inline struct mdfld_dsi_config *
+	mdfld_dsi_get_config(struct mdfld_dsi_connector *connector)
+{
+	if (!connector)
+		return NULL;
+	return (struct mdfld_dsi_config *)connector->private;
+}
+
+static inline void *mdfld_dsi_get_pkg_sender(struct mdfld_dsi_config *config)
+{
+	struct mdfld_dsi_connector *dsi_connector;
+
+	if (!config)
+		return NULL;
+
+	dsi_connector = config->connector;
+
+	if (!dsi_connector)
+		return NULL;
+
+	return dsi_connector->pkg_sender;
+}
+
+static inline struct mdfld_dsi_config *
+	mdfld_dsi_encoder_get_config(struct mdfld_dsi_encoder *encoder)
+{
+	if (!encoder)
+		return NULL;
+	return (struct mdfld_dsi_config *)encoder->private;
+}
+
+static inline struct mdfld_dsi_connector *
+	mdfld_dsi_encoder_get_connector(struct mdfld_dsi_encoder *encoder)
+{
+	struct mdfld_dsi_config *config;
+
+	if (!encoder)
+		return NULL;
+
+	config = mdfld_dsi_encoder_get_config(encoder);
+	if (!config)
+		return NULL;
+
+	return config->connector;
+}
+
+static inline void *mdfld_dsi_encoder_get_pkg_sender(
+	struct mdfld_dsi_encoder *encoder)
+{
+	struct mdfld_dsi_config *dsi_config;
+
+	dsi_config = mdfld_dsi_encoder_get_config(encoder);
+	if (!dsi_config)
+		return NULL;
+
+	return mdfld_dsi_get_pkg_sender(dsi_config);
+}
+
+static inline int mdfld_dsi_encoder_get_pipe(struct mdfld_dsi_encoder *encoder)
+{
+	struct mdfld_dsi_connector *connector;
+
+	if (!encoder)
+		return -1;
+
+	connector = mdfld_dsi_encoder_get_connector(encoder);
+	if (!connector)
+		return -1;
+
+	return connector->pipe;
+}
+
+extern void mdfld_dsi_gen_fifo_ready(struct drm_device *dev,
+				u32 gen_fifo_stat_reg, u32 fifo_stat);
+extern void mdfld_dsi_brightness_init(struct mdfld_dsi_config *dsi_config,
+				int pipe);
+extern void mdfld_dsi_brightness_control(struct drm_device *dev, int pipe,
+				int level);
+extern void mdfld_dsi_output_init(struct drm_device *dev, int pipe,
+				struct mdfld_dsi_config *config,
+				struct panel_funcs *p_cmd_funcs,
+				struct panel_funcs *p_vid_funcs);
+extern void mdfld_dsi_controller_init(struct mdfld_dsi_config *dsi_config,
+				int pipe);
+
+#endif /*__MDFLD_DSI_OUTPUT_H__*/
diff --git a/drivers/staging/gma500/mdfld_dsi_pkg_sender.c b/drivers/staging/gma500/mdfld_dsi_pkg_sender.c
new file mode 100644
index 0000000..9198aa8
--- /dev/null
+++ b/drivers/staging/gma500/mdfld_dsi_pkg_sender.c
@@ -0,0 +1,1097 @@
+/*
+ * Copyright © 2010 Intel Corporation
+ *
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * Jackie Li<yaodong.li@intel.com>
+ */
+
+#include <linux/freezer.h>
+
+#include "mdfld_dsi_output.h"
+#include "mdfld_dsi_pkg_sender.h"
+#include "mdfld_dsi_dbi.h"
+
+#define MDFLD_DSI_DBI_FIFO_TIMEOUT	100
+
+static const char * const dsi_errors[] = {
+	"RX SOT Error",
+	"RX SOT Sync Error",
+	"RX EOT Sync Error",
+	"RX Escape Mode Entry Error",
+	"RX LP TX Sync Error",
+	"RX HS Receive Timeout Error",
+	"RX False Control Error",
+	"RX ECC Single Bit Error",
+	"RX ECC Multibit Error",
+	"RX Checksum Error",
+	"RX DSI Data Type Not Recognised",
+	"RX DSI VC ID Invalid",
+	"TX False Control Error",
+	"TX ECC Single Bit Error",
+	"TX ECC Multibit Error",
+	"TX Checksum Error",
+	"TX DSI Data Type Not Recognised",
+	"TX DSI VC ID invalid",
+	"High Contention",
+	"Low contention",
+	"DPI FIFO Under run",
+	"HS TX Timeout",
+	"LP RX Timeout",
+	"Turn Around ACK Timeout",
+	"ACK With No Error",
+	"RX Invalid TX Length",
+	"RX Prot Violation",
+	"HS Generic Write FIFO Full",
+	"LP Generic Write FIFO Full",
+	"Generic Read Data Avail"
+	"Special Packet Sent",
+	"Tearing Effect",
+};
+
+static int wait_for_gen_fifo_empty(struct mdfld_dsi_pkg_sender *sender,
+								u32 mask)
+{
+	struct drm_device *dev = sender->dev;
+	u32 gen_fifo_stat_reg = sender->mipi_gen_fifo_stat_reg;
+	int retry = 0xffff;
+
+	while (retry--) {
+		if ((mask & REG_READ(gen_fifo_stat_reg)) == mask)
+			return 0;
+		udelay(100);
+	}
+	dev_err(dev->dev, "fifo is NOT empty 0x%08x\n",
+					REG_READ(gen_fifo_stat_reg));
+	return -EIO;
+}
+
+static int wait_for_all_fifos_empty(struct mdfld_dsi_pkg_sender *sender)
+{
+	return wait_for_gen_fifo_empty(sender, (1 << 2) | (1 << 10) | (1 << 18)
+		| (1 << 26) | (1 << 27) | (1 << 28));
+}
+
+static int wait_for_lp_fifos_empty(struct mdfld_dsi_pkg_sender *sender)
+{
+	return wait_for_gen_fifo_empty(sender, (1 << 10) | (1 << 26));
+}
+
+static int wait_for_hs_fifos_empty(struct mdfld_dsi_pkg_sender *sender)
+{
+	return wait_for_gen_fifo_empty(sender, (1 << 2) | (1 << 18));
+}
+
+static int wait_for_dbi_fifo_empty(struct mdfld_dsi_pkg_sender *sender)
+{
+	return wait_for_gen_fifo_empty(sender, (1 << 27));
+}
+
+static int handle_dsi_error(struct mdfld_dsi_pkg_sender *sender, u32 mask)
+{
+	u32 intr_stat_reg = sender->mipi_intr_stat_reg;
+	struct drm_device *dev = sender->dev;
+
+	switch (mask) {
+	case (1 << 0):
+	case (1 << 1):
+	case (1 << 2):
+	case (1 << 3):
+	case (1 << 4):
+	case (1 << 5):
+	case (1 << 6):
+	case (1 << 7):
+	case (1 << 8):
+	case (1 << 9):
+	case (1 << 10):
+	case (1 << 11):
+	case (1 << 12):
+	case (1 << 13):
+		break;
+	case (1 << 14):
+		/*wait for all fifo empty*/
+		/*wait_for_all_fifos_empty(sender)*/;
+		break;
+	case (1 << 15):
+		break;
+	case (1 << 16):
+		break;
+	case (1 << 17):
+		break;
+	case (1 << 18):
+	case (1 << 19):
+		/*wait for contention recovery time*/
+		/*mdelay(10);*/
+		/*wait for all fifo empty*/
+		if (0)
+			wait_for_all_fifos_empty(sender);
+		break;
+	case (1 << 20):
+		break;
+	case (1 << 21):
+		/*wait for all fifo empty*/
+		/*wait_for_all_fifos_empty(sender);*/
+		break;
+	case (1 << 22):
+		break;
+	case (1 << 23):
+	case (1 << 24):
+	case (1 << 25):
+	case (1 << 26):
+	case (1 << 27):
+		/* HS Gen fifo full */
+		REG_WRITE(intr_stat_reg, mask);
+		wait_for_hs_fifos_empty(sender);
+		break;
+	case (1 << 28):
+		/* LP Gen fifo full\n */
+		REG_WRITE(intr_stat_reg, mask);
+		wait_for_lp_fifos_empty(sender);
+		break;
+	case (1 << 29):
+	case (1 << 30):
+	case (1 << 31):
+		break;
+	}
+
+	if (mask & REG_READ(intr_stat_reg))
+		dev_warn(dev->dev, "Cannot clean interrupt 0x%08x\n", mask);
+
+	return 0;
+}
+
+static int dsi_error_handler(struct mdfld_dsi_pkg_sender *sender)
+{
+	struct drm_device *dev = sender->dev;
+	u32 intr_stat_reg = sender->mipi_intr_stat_reg;
+	u32 mask;
+	u32 intr_stat;
+	int i;
+	int err = 0;
+
+	intr_stat = REG_READ(intr_stat_reg);
+
+	for (i = 0; i < 32; i++) {
+		mask = (0x00000001UL) << i;
+		if (intr_stat & mask) {
+			dev_dbg(dev->dev, "[DSI]: %s\n", dsi_errors[i]);
+			err = handle_dsi_error(sender, mask);
+			if (err)
+				dev_err(dev->dev, "Cannot handle error\n");
+		}
+	}
+	return err;
+}
+
+static inline int dbi_cmd_sent(struct mdfld_dsi_pkg_sender *sender)
+{
+	struct drm_device *dev = sender->dev;
+	u32 retry = 0xffff;
+	u32 dbi_cmd_addr_reg = sender->mipi_cmd_addr_reg;
+
+	/* Query the command execution status */
+	while (retry--) {
+		if (!(REG_READ(dbi_cmd_addr_reg) & (1 << 0)))
+			break;
+	}
+
+	if (!retry) {
+		dev_err(dev->dev, "Timeout waiting for DBI Command status\n");
+		return -EAGAIN;
+	}
+	return 0;
+}
+
+/*
+ * NOTE: this interface is abandoned expect for write_mem_start DCS
+ * other DCS are sent via generic pkg interfaces
+ */
+static int send_dcs_pkg(struct mdfld_dsi_pkg_sender *sender,
+			struct mdfld_dsi_pkg *pkg)
+{
+	struct drm_device *dev = sender->dev;
+	struct mdfld_dsi_dcs_pkg *dcs_pkg = &pkg->pkg.dcs_pkg;
+	u32 dbi_cmd_len_reg = sender->mipi_cmd_len_reg;
+	u32 dbi_cmd_addr_reg = sender->mipi_cmd_addr_reg;
+	u32 cb_phy = sender->dbi_cb_phy;
+	u32 index = 0;
+	u8 *cb = (u8 *)sender->dbi_cb_addr;
+	int i;
+	int ret;
+
+	if (!sender->dbi_pkg_support) {
+		dev_err(dev->dev, "Trying to send DCS on a non DBI output, abort!\n");
+		return -ENOTSUPP;
+	}
+
+	/*wait for DBI fifo empty*/
+	wait_for_dbi_fifo_empty(sender);
+
+	*(cb + (index++)) = dcs_pkg->cmd;
+	if (dcs_pkg->param_num) {
+		for (i = 0; i < dcs_pkg->param_num; i++)
+			*(cb + (index++)) = *(dcs_pkg->param + i);
+	}
+
+	REG_WRITE(dbi_cmd_len_reg, (1 + dcs_pkg->param_num));
+	REG_WRITE(dbi_cmd_addr_reg,
+		(cb_phy << CMD_MEM_ADDR_OFFSET)
+		| (1 << 0)
+		| ((dcs_pkg->data_src == CMD_DATA_SRC_PIPE) ? (1 << 1) : 0));
+
+	ret = dbi_cmd_sent(sender);
+	if (ret) {
+		dev_err(dev->dev, "command 0x%x not complete\n", dcs_pkg->cmd);
+		return -EAGAIN;
+	}
+	return 0;
+}
+
+static int __send_short_pkg(struct mdfld_dsi_pkg_sender *sender,
+				struct mdfld_dsi_pkg *pkg)
+{
+	struct drm_device *dev = sender->dev;
+	u32 hs_gen_ctrl_reg = sender->mipi_hs_gen_ctrl_reg;
+	u32 lp_gen_ctrl_reg = sender->mipi_lp_gen_ctrl_reg;
+	u32 gen_ctrl_val = 0;
+	struct mdfld_dsi_gen_short_pkg *short_pkg = &pkg->pkg.short_pkg;
+
+	gen_ctrl_val |= short_pkg->cmd << MCS_COMMANDS_POS;
+	gen_ctrl_val |= 0 << DCS_CHANNEL_NUMBER_POS;
+	gen_ctrl_val |= pkg->pkg_type;
+	gen_ctrl_val |= short_pkg->param << MCS_PARAMETER_POS;
+
+	if (pkg->transmission_type == MDFLD_DSI_HS_TRANSMISSION) {
+		/* wait for hs fifo empty */
+		/* wait_for_hs_fifos_empty(sender); */
+		/* Send pkg */
+		REG_WRITE(hs_gen_ctrl_reg, gen_ctrl_val);
+	} else if (pkg->transmission_type == MDFLD_DSI_LP_TRANSMISSION) {
+		/* wait_for_lp_fifos_empty(sender); */
+		/* Send pkg*/
+		REG_WRITE(lp_gen_ctrl_reg, gen_ctrl_val);
+	} else {
+		dev_err(dev->dev, "Unknown transmission type %d\n",
+							pkg->transmission_type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __send_long_pkg(struct mdfld_dsi_pkg_sender *sender,
+				struct mdfld_dsi_pkg *pkg)
+{
+	struct drm_device *dev = sender->dev;
+	u32 hs_gen_ctrl_reg = sender->mipi_hs_gen_ctrl_reg;
+	u32 hs_gen_data_reg = sender->mipi_hs_gen_data_reg;
+	u32 lp_gen_ctrl_reg = sender->mipi_lp_gen_ctrl_reg;
+	u32 lp_gen_data_reg = sender->mipi_lp_gen_data_reg;
+	u32 gen_ctrl_val = 0;
+	u32 *dp;
+	int i;
+	struct mdfld_dsi_gen_long_pkg *long_pkg = &pkg->pkg.long_pkg;
+
+	dp = long_pkg->data;
+
+	/*
+	 * Set up word count for long pkg
+	 * FIXME: double check word count field.
+	 * currently, using the byte counts of the payload as the word count.
+	 * ------------------------------------------------------------
+	 * | DI |   WC   | ECC|         PAYLOAD              |CHECKSUM|
+	 * ------------------------------------------------------------
+	 */
+	gen_ctrl_val |= (long_pkg->len << 2) << WORD_COUNTS_POS;
+	gen_ctrl_val |= 0 << DCS_CHANNEL_NUMBER_POS;
+	gen_ctrl_val |= pkg->pkg_type;
+
+	if (pkg->transmission_type == MDFLD_DSI_HS_TRANSMISSION) {
+		/* Wait for hs ctrl and data fifos to be empty */
+		/* wait_for_hs_fifos_empty(sender); */
+		for (i = 0; i < long_pkg->len; i++)
+			REG_WRITE(hs_gen_data_reg, *(dp + i));
+		REG_WRITE(hs_gen_ctrl_reg, gen_ctrl_val);
+	} else if (pkg->transmission_type == MDFLD_DSI_LP_TRANSMISSION) {
+		/* wait_for_lp_fifos_empty(sender); */
+		for (i = 0; i < long_pkg->len; i++)
+			REG_WRITE(lp_gen_data_reg, *(dp + i));
+		REG_WRITE(lp_gen_ctrl_reg, gen_ctrl_val);
+	} else {
+		dev_err(dev->dev, "Unknown transmission type %d\n",
+						pkg->transmission_type);
+		return -EINVAL;
+	}
+
+	return 0;
+
+}
+
+static int send_mcs_short_pkg(struct mdfld_dsi_pkg_sender *sender,
+				struct mdfld_dsi_pkg *pkg)
+{
+	return __send_short_pkg(sender, pkg);
+}
+
+static int send_mcs_long_pkg(struct mdfld_dsi_pkg_sender *sender,
+				struct mdfld_dsi_pkg *pkg)
+{
+	return __send_long_pkg(sender, pkg);
+}
+
+static int send_gen_short_pkg(struct mdfld_dsi_pkg_sender *sender,
+				struct mdfld_dsi_pkg *pkg)
+{
+	return __send_short_pkg(sender, pkg);
+}
+
+static int send_gen_long_pkg(struct mdfld_dsi_pkg_sender *sender,
+				struct mdfld_dsi_pkg *pkg)
+{
+	return __send_long_pkg(sender, pkg);
+}
+
+static int send_pkg_prepare(struct mdfld_dsi_pkg_sender *sender,
+				struct mdfld_dsi_pkg *pkg)
+{
+	u8 cmd;
+	u8 *data;
+
+	switch (pkg->pkg_type) {
+	case MDFLD_DSI_PKG_DCS:
+		cmd = pkg->pkg.dcs_pkg.cmd;
+		break;
+	case MDFLD_DSI_PKG_MCS_SHORT_WRITE_0:
+	case MDFLD_DSI_PKG_MCS_SHORT_WRITE_1:
+		cmd = pkg->pkg.short_pkg.cmd;
+		break;
+	case MDFLD_DSI_PKG_MCS_LONG_WRITE:
+		data = (u8 *)pkg->pkg.long_pkg.data;
+		cmd = *data;
+		break;
+	default:
+		return 0;
+	}
+
+	/* This prevents other package sending while doing msleep */
+	sender->status = MDFLD_DSI_PKG_SENDER_BUSY;
+
+	/* Check panel mode v.s. sending command */
+	if ((sender->panel_mode & MDFLD_DSI_PANEL_MODE_SLEEP) &&
+		cmd != exit_sleep_mode) {
+		dev_err(sender->dev->dev,
+				"sending 0x%x when panel sleep in\n", cmd);
+		sender->status = MDFLD_DSI_PKG_SENDER_FREE;
+		return -EINVAL;
+	}
+
+	/* Wait for 120 milliseconds in case exit_sleep_mode just be sent */
+	if (cmd == enter_sleep_mode)
+		mdelay(120);
+	return 0;
+}
+
+static int send_pkg_done(struct mdfld_dsi_pkg_sender *sender,
+				struct mdfld_dsi_pkg *pkg)
+{
+	u8 cmd;
+	u8 *data;
+
+	switch (pkg->pkg_type) {
+	case MDFLD_DSI_PKG_DCS:
+		cmd = pkg->pkg.dcs_pkg.cmd;
+		break;
+	case MDFLD_DSI_PKG_MCS_SHORT_WRITE_0:
+	case MDFLD_DSI_PKG_MCS_SHORT_WRITE_1:
+		cmd = pkg->pkg.short_pkg.cmd;
+		break;
+	case MDFLD_DSI_PKG_MCS_LONG_WRITE:
+		data = (u8 *)pkg->pkg.long_pkg.data;
+		cmd = *data;
+		break;
+	default:
+		return 0;
+	}
+
+	/* Update panel status */
+	if (cmd == enter_sleep_mode) {
+		sender->panel_mode |= MDFLD_DSI_PANEL_MODE_SLEEP;
+		/*TODO: replace it with msleep later*/
+		mdelay(120);
+	} else if (cmd == exit_sleep_mode) {
+		sender->panel_mode &= ~MDFLD_DSI_PANEL_MODE_SLEEP;
+		/*TODO: replace it with msleep later*/
+		mdelay(120);
+	}
+
+	sender->status = MDFLD_DSI_PKG_SENDER_FREE;
+	return 0;
+
+}
+
+static int do_send_pkg(struct mdfld_dsi_pkg_sender *sender,
+			struct mdfld_dsi_pkg *pkg)
+{
+	int ret;
+
+	if (sender->status == MDFLD_DSI_PKG_SENDER_BUSY) {
+		dev_err(sender->dev->dev, "sender is busy\n");
+		return -EAGAIN;
+	}
+
+	ret = send_pkg_prepare(sender, pkg);
+	if (ret) {
+		dev_err(sender->dev->dev, "send_pkg_prepare error\n");
+		return ret;
+	}
+
+	switch (pkg->pkg_type) {
+	case MDFLD_DSI_PKG_DCS:
+		ret = send_dcs_pkg(sender, pkg);
+		break;
+	case MDFLD_DSI_PKG_GEN_SHORT_WRITE_0:
+	case MDFLD_DSI_PKG_GEN_SHORT_WRITE_1:
+	case MDFLD_DSI_PKG_GEN_SHORT_WRITE_2:
+		ret = send_gen_short_pkg(sender, pkg);
+		break;
+	case MDFLD_DSI_PKG_GEN_LONG_WRITE:
+		ret = send_gen_long_pkg(sender, pkg);
+		break;
+	case MDFLD_DSI_PKG_MCS_SHORT_WRITE_0:
+	case MDFLD_DSI_PKG_MCS_SHORT_WRITE_1:
+		ret = send_mcs_short_pkg(sender, pkg);
+		break;
+	case MDFLD_DSI_PKG_MCS_LONG_WRITE:
+		ret = send_mcs_long_pkg(sender, pkg);
+		break;
+	default:
+		dev_err(sender->dev->dev, "Invalid pkg type 0x%x\n",
+							pkg->pkg_type);
+		ret = -EINVAL;
+	}
+	send_pkg_done(sender, pkg);
+	return ret;
+}
+
+static int send_pkg(struct mdfld_dsi_pkg_sender *sender,
+			struct mdfld_dsi_pkg *pkg)
+{
+	int err ;
+
+	/* Handle DSI error */
+	err = dsi_error_handler(sender);
+	if (err) {
+		dev_err(sender->dev->dev, "Error handling failed\n");
+		err = -EAGAIN;
+		goto send_pkg_err;
+	}
+
+	/* Send pkg */
+	err = do_send_pkg(sender, pkg);
+	if (err) {
+		dev_err(sender->dev->dev, "sent pkg failed\n");
+		err = -EAGAIN;
+		goto send_pkg_err;
+	}
+
+	/* FIXME: should I query complete and fifo empty here? */
+send_pkg_err:
+	return err;
+}
+
+static struct mdfld_dsi_pkg *pkg_sender_get_pkg_locked(
+					struct mdfld_dsi_pkg_sender *sender)
+{
+	struct mdfld_dsi_pkg *pkg;
+
+	if (list_empty(&sender->free_list)) {
+		dev_err(sender->dev->dev, "No free pkg left\n");
+		return NULL;
+	}
+	pkg = list_first_entry(&sender->free_list, struct mdfld_dsi_pkg, entry);
+	/* Detach from free list */
+	list_del_init(&pkg->entry);
+	return pkg;
+}
+
+static void pkg_sender_put_pkg_locked(struct mdfld_dsi_pkg_sender *sender,
+					struct mdfld_dsi_pkg *pkg)
+{
+	memset(pkg, 0, sizeof(struct mdfld_dsi_pkg));
+	INIT_LIST_HEAD(&pkg->entry);
+	list_add_tail(&pkg->entry, &sender->free_list);
+}
+
+static int mdfld_dbi_cb_init(struct mdfld_dsi_pkg_sender *sender,
+					struct psb_gtt *pg, int pipe)
+{
+	unsigned long phys;
+	void *virt_addr = NULL;
+
+	switch (pipe) {
+	case 0:
+		phys = pg->gtt_phys_start - 0x1000;
+		break;
+	case 2:
+		phys = pg->gtt_phys_start - 0x800;
+		break;
+	default:
+		dev_err(sender->dev->dev, "Unsupported channel %d\n", pipe);
+		return -EINVAL;
+	}
+
+	virt_addr = ioremap_nocache(phys, 0x800);
+	if (!virt_addr) {
+		dev_err(sender->dev->dev, "Map DBI command buffer error\n");
+		return -ENOMEM;
+	}
+	sender->dbi_cb_phy = phys;
+	sender->dbi_cb_addr = virt_addr;
+	return 0;
+}
+
+static void mdfld_dbi_cb_destroy(struct mdfld_dsi_pkg_sender *sender)
+{
+	if (sender && sender->dbi_cb_addr)
+		iounmap(sender->dbi_cb_addr);
+}
+
+static void pkg_sender_queue_pkg(struct mdfld_dsi_pkg_sender *sender,
+					struct mdfld_dsi_pkg *pkg,
+					int delay)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&sender->lock, flags);
+
+	if (!delay) {
+		send_pkg(sender, pkg);
+		pkg_sender_put_pkg_locked(sender, pkg);
+	} else {
+		/* Queue it */
+		list_add_tail(&pkg->entry, &sender->pkg_list);
+	}
+	spin_unlock_irqrestore(&sender->lock, flags);
+}
+
+static void process_pkg_list(struct mdfld_dsi_pkg_sender *sender)
+{
+	struct mdfld_dsi_pkg *pkg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sender->lock, flags);
+
+	while (!list_empty(&sender->pkg_list)) {
+		pkg = list_first_entry(&sender->pkg_list,
+					struct mdfld_dsi_pkg, entry);
+		send_pkg(sender, pkg);
+		list_del_init(&pkg->entry);
+		pkg_sender_put_pkg_locked(sender, pkg);
+	}
+
+	spin_unlock_irqrestore(&sender->lock, flags);
+}
+
+static int mdfld_dsi_send_mcs_long(struct mdfld_dsi_pkg_sender *sender,
+	u32 *data, u32 len, u8 transmission, int delay)
+{
+	struct mdfld_dsi_pkg *pkg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sender->lock, flags);
+	pkg = pkg_sender_get_pkg_locked(sender);
+	spin_unlock_irqrestore(&sender->lock, flags);
+
+	if (!pkg) {
+		dev_err(sender->dev->dev, "No memory\n");
+		return -ENOMEM;
+	}
+	pkg->pkg_type = MDFLD_DSI_PKG_MCS_LONG_WRITE;
+	pkg->transmission_type = transmission;
+	pkg->pkg.long_pkg.data = data;
+	pkg->pkg.long_pkg.len = len;
+	INIT_LIST_HEAD(&pkg->entry);
+
+	pkg_sender_queue_pkg(sender, pkg, delay);
+	return 0;
+}
+
+static int mdfld_dsi_send_mcs_short(struct mdfld_dsi_pkg_sender *sender,
+					u8 cmd, u8 param, u8 param_num,
+					u8 transmission,
+					int delay)
+{
+	struct mdfld_dsi_pkg *pkg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sender->lock, flags);
+	pkg = pkg_sender_get_pkg_locked(sender);
+	spin_unlock_irqrestore(&sender->lock, flags);
+
+	if (!pkg) {
+		dev_err(sender->dev->dev, "No memory\n");
+		return -ENOMEM;
+	}
+
+	if (param_num) {
+		pkg->pkg_type = MDFLD_DSI_PKG_MCS_SHORT_WRITE_1;
+		pkg->pkg.short_pkg.param = param;
+	} else {
+		pkg->pkg_type = MDFLD_DSI_PKG_MCS_SHORT_WRITE_0;
+		pkg->pkg.short_pkg.param = 0;
+	}
+	pkg->transmission_type = transmission;
+	pkg->pkg.short_pkg.cmd = cmd;
+	INIT_LIST_HEAD(&pkg->entry);
+
+	pkg_sender_queue_pkg(sender, pkg, delay);
+	return 0;
+}
+
+static int mdfld_dsi_send_gen_short(struct mdfld_dsi_pkg_sender *sender,
+					u8 param0, u8 param1, u8 param_num,
+					u8 transmission,
+					int delay)
+{
+	struct mdfld_dsi_pkg *pkg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sender->lock, flags);
+	pkg = pkg_sender_get_pkg_locked(sender);
+	spin_unlock_irqrestore(&sender->lock, flags);
+
+	if (!pkg) {
+		dev_err(sender->dev->dev, "No pkg memory\n");
+		return -ENOMEM;
+	}
+
+	switch (param_num) {
+	case 0:
+		pkg->pkg_type = MDFLD_DSI_PKG_GEN_SHORT_WRITE_0;
+		pkg->pkg.short_pkg.cmd = 0;
+		pkg->pkg.short_pkg.param = 0;
+		break;
+	case 1:
+		pkg->pkg_type = MDFLD_DSI_PKG_GEN_SHORT_WRITE_1;
+		pkg->pkg.short_pkg.cmd = param0;
+		pkg->pkg.short_pkg.param = 0;
+		break;
+	case 2:
+		pkg->pkg_type = MDFLD_DSI_PKG_GEN_SHORT_WRITE_2;
+		pkg->pkg.short_pkg.cmd = param0;
+		pkg->pkg.short_pkg.param = param1;
+		break;
+	}
+
+	pkg->transmission_type = transmission;
+	INIT_LIST_HEAD(&pkg->entry);
+
+	pkg_sender_queue_pkg(sender, pkg, delay);
+	return 0;
+}
+
+static int mdfld_dsi_send_gen_long(struct mdfld_dsi_pkg_sender *sender,
+				u32 *data, u32 len, u8 transmission, int delay)
+{
+	struct mdfld_dsi_pkg *pkg;
+	unsigned long flags;
+
+	spin_lock_irqsave(&sender->lock, flags);
+	pkg = pkg_sender_get_pkg_locked(sender);
+	spin_unlock_irqrestore(&sender->lock, flags);
+
+	if (!pkg) {
+		dev_err(sender->dev->dev, "No pkg memory\n");
+		return -ENOMEM;
+	}
+
+	pkg->pkg_type = MDFLD_DSI_PKG_GEN_LONG_WRITE;
+	pkg->transmission_type = transmission;
+	pkg->pkg.long_pkg.data = data;
+	pkg->pkg.long_pkg.len = len;
+
+	INIT_LIST_HEAD(&pkg->entry);
+
+	pkg_sender_queue_pkg(sender, pkg, delay);
+
+	return 0;
+}
+
+void mdfld_dsi_cmds_kick_out(struct mdfld_dsi_pkg_sender *sender)
+{
+	process_pkg_list(sender);
+}
+
+int mdfld_dsi_send_dcs(struct mdfld_dsi_pkg_sender *sender,
+			u8 dcs, u8 *param, u32 param_num, u8 data_src,
+			int delay)
+{
+	struct mdfld_dsi_pkg *pkg;
+	u32 cb_phy = sender->dbi_cb_phy;
+	struct drm_device *dev = sender->dev;
+	u32 index = 0;
+	u8 *cb = (u8 *)sender->dbi_cb_addr;
+	unsigned long flags;
+	int retry;
+	u8 *dst = NULL;
+	u32 len;
+
+	if (!sender) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	if (!sender->dbi_pkg_support) {
+		dev_err(dev->dev, "No DBI pkg sending on this sender\n");
+		return -ENOTSUPP;
+	}
+
+	if (param_num > MDFLD_MAX_DCS_PARAM) {
+		dev_err(dev->dev, "Sender only supports up to %d DCS params\n",
+							MDFLD_MAX_DCS_PARAM);
+		return -EINVAL;
+	}
+
+	/*
+	 * If dcs is write_mem_start, send it directly using DSI adapter
+	 * interface
+	 */
+	if (dcs == write_mem_start) {
+		if (!spin_trylock(&sender->lock))
+			return -EAGAIN;
+
+		/*
+		 * query whether DBI FIFO is empty,
+		 * if not wait it becoming empty
+		 */
+		retry = MDFLD_DSI_DBI_FIFO_TIMEOUT;
+		while (retry &&
+		    !(REG_READ(sender->mipi_gen_fifo_stat_reg) & (1 << 27))) {
+			udelay(500);
+			retry--;
+		}
+
+		/* If DBI FIFO timeout, drop this frame */
+		if (!retry) {
+			spin_unlock(&sender->lock);
+			return 0;
+		}
+
+		*(cb + (index++)) = write_mem_start;
+
+		REG_WRITE(sender->mipi_cmd_len_reg, 1);
+		REG_WRITE(sender->mipi_cmd_addr_reg,
+					cb_phy | (1 << 0) | (1 << 1));
+
+		retry = MDFLD_DSI_DBI_FIFO_TIMEOUT;
+		while (retry &&
+			(REG_READ(sender->mipi_cmd_addr_reg) & (1 << 0))) {
+			udelay(1);
+			retry--;
+		}
+
+		spin_unlock(&sender->lock);
+		return 0;
+	}
+
+	/* Get a free pkg */
+	spin_lock_irqsave(&sender->lock, flags);
+	pkg = pkg_sender_get_pkg_locked(sender);
+	spin_unlock_irqrestore(&sender->lock, flags);
+
+	if (!pkg) {
+		dev_err(dev->dev, "No packages memory\n");
+		return -ENOMEM;
+	}
+
+	dst = pkg->pkg.dcs_pkg.param;
+	memcpy(dst, param, param_num);
+
+	pkg->pkg_type = MDFLD_DSI_PKG_DCS;
+	pkg->transmission_type = MDFLD_DSI_DCS;
+	pkg->pkg.dcs_pkg.cmd = dcs;
+	pkg->pkg.dcs_pkg.param_num = param_num;
+	pkg->pkg.dcs_pkg.data_src = data_src;
+
+	INIT_LIST_HEAD(&pkg->entry);
+
+	if (param_num == 0)
+		return mdfld_dsi_send_mcs_short_hs(sender, dcs, 0, 0, delay);
+	else if (param_num == 1)
+		return mdfld_dsi_send_mcs_short_hs(sender, dcs,
+							param[0], 1, delay);
+	else if (param_num > 1) {
+		len = (param_num + 1) / 4;
+		if ((param_num + 1) % 4)
+			len++;
+		return mdfld_dsi_send_mcs_long_hs(sender,
+				(u32 *)&pkg->pkg.dcs_pkg, len, delay);
+	}
+	return 0;
+}
+
+int mdfld_dsi_send_mcs_short_hs(struct mdfld_dsi_pkg_sender *sender,
+				u8 cmd, u8 param, u8 param_num, int delay)
+{
+	if (!sender) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	return mdfld_dsi_send_mcs_short(sender, cmd, param, param_num,
+					MDFLD_DSI_HS_TRANSMISSION, delay);
+}
+
+int mdfld_dsi_send_mcs_short_lp(struct mdfld_dsi_pkg_sender *sender,
+				u8 cmd, u8 param, u8 param_num, int delay)
+{
+	if (!sender) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	return mdfld_dsi_send_mcs_short(sender, cmd, param, param_num,
+					MDFLD_DSI_LP_TRANSMISSION, delay);
+}
+
+int mdfld_dsi_send_mcs_long_hs(struct mdfld_dsi_pkg_sender *sender,
+				u32 *data,
+				u32 len,
+				int delay)
+{
+	if (!sender || !data || !len) {
+		DRM_ERROR("Invalid parameters\n");
+		return -EINVAL;
+	}
+	return mdfld_dsi_send_mcs_long(sender, data, len,
+					MDFLD_DSI_HS_TRANSMISSION, delay);
+}
+
+int mdfld_dsi_send_mcs_long_lp(struct mdfld_dsi_pkg_sender *sender,
+				u32 *data,
+				u32 len,
+				int delay)
+{
+	if (!sender || !data || !len) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	return mdfld_dsi_send_mcs_long(sender, data, len,
+				MDFLD_DSI_LP_TRANSMISSION, delay);
+}
+
+int mdfld_dsi_send_gen_short_hs(struct mdfld_dsi_pkg_sender *sender,
+				u8 param0, u8 param1, u8 param_num, int delay)
+{
+	if (!sender) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	return mdfld_dsi_send_gen_short(sender, param0, param1, param_num,
+					MDFLD_DSI_HS_TRANSMISSION, delay);
+}
+
+int mdfld_dsi_send_gen_short_lp(struct mdfld_dsi_pkg_sender *sender,
+				u8 param0, u8 param1, u8 param_num, int delay)
+{
+	if (!sender || param_num < 0 || param_num > 2) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	return mdfld_dsi_send_gen_short(sender, param0, param1, param_num,
+					MDFLD_DSI_LP_TRANSMISSION, delay);
+}
+
+int mdfld_dsi_send_gen_long_hs(struct mdfld_dsi_pkg_sender *sender,
+				u32 *data,
+				u32 len,
+				int delay)
+{
+	if (!sender || !data || !len) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	return mdfld_dsi_send_gen_long(sender, data, len,
+					MDFLD_DSI_HS_TRANSMISSION, delay);
+}
+
+int mdfld_dsi_send_gen_long_lp(struct mdfld_dsi_pkg_sender *sender,
+				u32 *data,
+				u32 len,
+				int delay)
+{
+	if (!sender || !data || !len) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+	return mdfld_dsi_send_gen_long(sender, data, len,
+					MDFLD_DSI_LP_TRANSMISSION, delay);
+}
+
+int mdfld_dsi_pkg_sender_init(struct mdfld_dsi_connector *dsi_connector,
+								int pipe)
+{
+	int ret;
+	struct mdfld_dsi_pkg_sender *pkg_sender;
+	struct mdfld_dsi_config *dsi_config =
+					mdfld_dsi_get_config(dsi_connector);
+	struct drm_device *dev = dsi_config->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_gtt *pg = dev_priv->pg;
+	int i;
+	struct mdfld_dsi_pkg *pkg, *tmp;
+
+	if (!dsi_connector) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	pkg_sender = dsi_connector->pkg_sender;
+
+	if (!pkg_sender || IS_ERR(pkg_sender)) {
+		pkg_sender = kzalloc(sizeof(struct mdfld_dsi_pkg_sender),
+								GFP_KERNEL);
+		if (!pkg_sender) {
+			dev_err(dev->dev, "Create DSI pkg sender failed\n");
+			return -ENOMEM;
+		}
+
+		dsi_connector->pkg_sender = (void *)pkg_sender;
+	}
+
+	pkg_sender->dev = dev;
+	pkg_sender->dsi_connector = dsi_connector;
+	pkg_sender->pipe = pipe;
+	pkg_sender->pkg_num = 0;
+	pkg_sender->panel_mode = 0;
+	pkg_sender->status = MDFLD_DSI_PKG_SENDER_FREE;
+
+	/* Init dbi command buffer*/
+
+	if (dsi_config->type == MDFLD_DSI_ENCODER_DBI) {
+		pkg_sender->dbi_pkg_support = 1;
+		ret = mdfld_dbi_cb_init(pkg_sender, pg, pipe);
+		if (ret) {
+			dev_err(dev->dev, "DBI command buffer map failed\n");
+			goto mapping_err;
+		}
+	}
+
+	/* Init regs */
+	if (pipe == 0) {
+		pkg_sender->dpll_reg = MRST_DPLL_A;
+		pkg_sender->dspcntr_reg = DSPACNTR;
+		pkg_sender->pipeconf_reg = PIPEACONF;
+		pkg_sender->dsplinoff_reg = DSPALINOFF;
+		pkg_sender->dspsurf_reg = DSPASURF;
+		pkg_sender->pipestat_reg = PIPEASTAT;
+
+		pkg_sender->mipi_intr_stat_reg = MIPIA_INTR_STAT_REG;
+		pkg_sender->mipi_lp_gen_data_reg = MIPIA_LP_GEN_DATA_REG;
+		pkg_sender->mipi_hs_gen_data_reg = MIPIA_HS_GEN_DATA_REG;
+		pkg_sender->mipi_lp_gen_ctrl_reg = MIPIA_LP_GEN_CTRL_REG;
+		pkg_sender->mipi_hs_gen_ctrl_reg = MIPIA_HS_GEN_CTRL_REG;
+		pkg_sender->mipi_gen_fifo_stat_reg = MIPIA_GEN_FIFO_STAT_REG;
+		pkg_sender->mipi_data_addr_reg = MIPIA_DATA_ADD_REG;
+		pkg_sender->mipi_data_len_reg = MIPIA_DATA_LEN_REG;
+		pkg_sender->mipi_cmd_addr_reg = MIPIA_CMD_ADD_REG;
+		pkg_sender->mipi_cmd_len_reg = MIPIA_CMD_LEN_REG;
+	} else if (pipe == 2) {
+		pkg_sender->dpll_reg = MRST_DPLL_A;
+		pkg_sender->dspcntr_reg = DSPCCNTR;
+		pkg_sender->pipeconf_reg = PIPECCONF;
+		pkg_sender->dsplinoff_reg = DSPCLINOFF;
+		pkg_sender->dspsurf_reg = DSPCSURF;
+		pkg_sender->pipestat_reg = 72024;
+
+		pkg_sender->mipi_intr_stat_reg =
+				MIPIA_INTR_STAT_REG + MIPIC_REG_OFFSET;
+		pkg_sender->mipi_lp_gen_data_reg =
+				MIPIA_LP_GEN_DATA_REG + MIPIC_REG_OFFSET;
+		pkg_sender->mipi_hs_gen_data_reg =
+				MIPIA_HS_GEN_DATA_REG + MIPIC_REG_OFFSET;
+		pkg_sender->mipi_lp_gen_ctrl_reg =
+				MIPIA_LP_GEN_CTRL_REG + MIPIC_REG_OFFSET;
+		pkg_sender->mipi_hs_gen_ctrl_reg =
+				MIPIA_HS_GEN_CTRL_REG + MIPIC_REG_OFFSET;
+		pkg_sender->mipi_gen_fifo_stat_reg =
+				MIPIA_GEN_FIFO_STAT_REG + MIPIC_REG_OFFSET;
+		pkg_sender->mipi_data_addr_reg =
+				MIPIA_DATA_ADD_REG + MIPIC_REG_OFFSET;
+		pkg_sender->mipi_data_len_reg =
+				MIPIA_DATA_LEN_REG + MIPIC_REG_OFFSET;
+		pkg_sender->mipi_cmd_addr_reg =
+				MIPIA_CMD_ADD_REG + MIPIC_REG_OFFSET;
+		pkg_sender->mipi_cmd_len_reg =
+				MIPIA_CMD_LEN_REG + MIPIC_REG_OFFSET;
+	}
+
+	/* Init pkg list */
+	INIT_LIST_HEAD(&pkg_sender->pkg_list);
+	INIT_LIST_HEAD(&pkg_sender->free_list);
+
+	spin_lock_init(&pkg_sender->lock);
+
+	/* Allocate free pkg pool */
+	for (i = 0; i < MDFLD_MAX_PKG_NUM; i++) {
+		pkg = kzalloc(sizeof(struct mdfld_dsi_pkg), GFP_KERNEL);
+		if (!pkg) {
+			dev_err(dev->dev, "Out of memory allocating pkg pool");
+			ret = -ENOMEM;
+			goto pkg_alloc_err;
+		}
+		INIT_LIST_HEAD(&pkg->entry);
+		list_add_tail(&pkg->entry, &pkg_sender->free_list);
+	}
+	return 0;
+
+pkg_alloc_err:
+	list_for_each_entry_safe(pkg, tmp, &pkg_sender->free_list, entry) {
+		list_del(&pkg->entry);
+		kfree(pkg);
+	}
+
+	/* Free mapped command buffer */
+	mdfld_dbi_cb_destroy(pkg_sender);
+mapping_err:
+	kfree(pkg_sender);
+	dsi_connector->pkg_sender = NULL;
+	return ret;
+}
+
+void mdfld_dsi_pkg_sender_destroy(struct mdfld_dsi_pkg_sender *sender)
+{
+	struct mdfld_dsi_pkg *pkg, *tmp;
+
+	if (!sender || IS_ERR(sender))
+		return;
+
+	/* Free pkg pool */
+	list_for_each_entry_safe(pkg, tmp, &sender->free_list, entry) {
+		list_del(&pkg->entry);
+		kfree(pkg);
+	}
+	/* Free pkg list */
+	list_for_each_entry_safe(pkg, tmp, &sender->pkg_list, entry) {
+		list_del(&pkg->entry);
+		kfree(pkg);
+	}
+	mdfld_dbi_cb_destroy(sender);	/* free mapped command buffer */
+	kfree(sender);
+}
diff --git a/drivers/staging/gma500/mdfld_dsi_pkg_sender.h b/drivers/staging/gma500/mdfld_dsi_pkg_sender.h
new file mode 100644
index 0000000..296b1ea
--- /dev/null
+++ b/drivers/staging/gma500/mdfld_dsi_pkg_sender.h
@@ -0,0 +1,158 @@
+/*
+ * Copyright © 2010 Intel Corporation
+ *
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * Jackie Li<yaodong.li@intel.com>
+ */
+#ifndef __MDFLD_DSI_PKG_SENDER_H__
+#define __MDFLD_DSI_PKG_SENDER_H__
+
+#include <linux/kthread.h>
+
+#define MDFLD_MAX_DCS_PARAM	8
+#define MDFLD_MAX_PKG_NUM	2048
+
+enum {
+	MDFLD_DSI_PKG_DCS,
+	MDFLD_DSI_PKG_GEN_SHORT_WRITE_0 = 0x03,
+	MDFLD_DSI_PKG_GEN_SHORT_WRITE_1 = 0x13,
+	MDFLD_DSI_PKG_GEN_SHORT_WRITE_2 = 0x23,
+	MDFLD_DSI_PKG_GEN_LONG_WRITE = 0x29,
+	MDFLD_DSI_PKG_MCS_SHORT_WRITE_0 = 0x05,
+	MDFLD_DSI_PKG_MCS_SHORT_WRITE_1 = 0x15,
+	MDFLD_DSI_PKG_MCS_LONG_WRITE = 0x39,
+};
+
+enum {
+	MDFLD_DSI_LP_TRANSMISSION,
+	MDFLD_DSI_HS_TRANSMISSION,
+	MDFLD_DSI_DCS,
+};
+
+enum {
+	MDFLD_DSI_PANEL_MODE_SLEEP = 0x1,
+};
+
+enum {
+	MDFLD_DSI_PKG_SENDER_FREE = 0x0,
+	MDFLD_DSI_PKG_SENDER_BUSY = 0x1,
+};
+
+enum {
+	MDFLD_DSI_SEND_PACKAGE,
+	MDFLD_DSI_QUEUE_PACKAGE,
+};
+
+struct mdfld_dsi_gen_short_pkg {
+	u8 cmd;
+	u8 param;
+};
+
+struct mdfld_dsi_gen_long_pkg {
+	u32 *data;
+	u32 len;
+};
+
+struct mdfld_dsi_dcs_pkg {
+	u8 cmd;
+	u8 param[MDFLD_MAX_DCS_PARAM];
+	u32 param_num;
+	u8 data_src;
+};
+
+struct mdfld_dsi_pkg {
+	u8 pkg_type;
+	u8 transmission_type;
+
+	union {
+		struct mdfld_dsi_gen_short_pkg short_pkg;
+		struct mdfld_dsi_gen_long_pkg long_pkg;
+		struct mdfld_dsi_dcs_pkg dcs_pkg;
+	} pkg;
+
+	struct list_head entry;
+};
+
+struct mdfld_dsi_pkg_sender {
+	struct drm_device *dev;
+	struct mdfld_dsi_connector *dsi_connector;
+	u32 status;
+
+	u32 panel_mode;
+
+	int pipe;
+
+	spinlock_t lock;
+	struct list_head pkg_list;
+	struct list_head free_list;
+
+	u32 pkg_num;
+
+	int dbi_pkg_support;
+
+	u32 dbi_cb_phy;
+	void *dbi_cb_addr;
+
+	/* Registers */
+	u32 dpll_reg;
+	u32 dspcntr_reg;
+	u32 pipeconf_reg;
+	u32 pipestat_reg;
+	u32 dsplinoff_reg;
+	u32 dspsurf_reg;
+
+	u32 mipi_intr_stat_reg;
+	u32 mipi_lp_gen_data_reg;
+	u32 mipi_hs_gen_data_reg;
+	u32 mipi_lp_gen_ctrl_reg;
+	u32 mipi_hs_gen_ctrl_reg;
+	u32 mipi_gen_fifo_stat_reg;
+	u32 mipi_data_addr_reg;
+	u32 mipi_data_len_reg;
+	u32 mipi_cmd_addr_reg;
+	u32 mipi_cmd_len_reg;
+};
+
+extern int mdfld_dsi_pkg_sender_init(struct mdfld_dsi_connector *dsi_connector,
+			int pipe);
+extern void mdfld_dsi_pkg_sender_destroy(struct mdfld_dsi_pkg_sender *sender);
+extern int mdfld_dsi_send_dcs(struct mdfld_dsi_pkg_sender *sender, u8 dcs,
+			u8 *param, u32 param_num, u8 data_src, int delay);
+extern int mdfld_dsi_send_mcs_short_hs(struct mdfld_dsi_pkg_sender *sender,
+			u8 cmd, u8 param, u8 param_num, int delay);
+extern int mdfld_dsi_send_mcs_short_lp(struct mdfld_dsi_pkg_sender *sender,
+			u8 cmd, u8 param, u8 param_num, int delay);
+extern int mdfld_dsi_send_mcs_long_hs(struct mdfld_dsi_pkg_sender *sender,
+			u32 *data, u32 len, int delay);
+extern int mdfld_dsi_send_mcs_long_lp(struct mdfld_dsi_pkg_sender *sender,
+			u32 *data, u32 len, int delay);
+extern int mdfld_dsi_send_gen_short_hs(struct mdfld_dsi_pkg_sender *sender,
+			u8 param0, u8 param1, u8 param_num, int delay);
+extern int mdfld_dsi_send_gen_short_lp(struct mdfld_dsi_pkg_sender *sender,
+			u8 param0, u8 param1, u8 param_num, int delay);
+extern int mdfld_dsi_send_gen_long_hs(struct mdfld_dsi_pkg_sender *sender,
+			u32 *data, u32 len, int delay);
+extern int mdfld_dsi_send_gen_long_lp(struct mdfld_dsi_pkg_sender *sender,
+			u32 *data, u32 len, int delay);
+extern void mdfld_dsi_cmds_kick_out(struct mdfld_dsi_pkg_sender *sender);
+
+#endif /* __MDFLD_DSI_PKG_SENDER_H__ */
diff --git a/drivers/staging/gma500/mdfld_intel_display.c b/drivers/staging/gma500/mdfld_intel_display.c
new file mode 100644
index 0000000..26d7f80
--- /dev/null
+++ b/drivers/staging/gma500/mdfld_intel_display.c
@@ -0,0 +1,1388 @@
+/*
+ * Copyright © 2006-2011 Intel Corporation
+ *
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ *	Eric Anholt <eric@anholt.net>
+ */
+
+#include "psb_fb.h"
+#include "psb_intel_display.h"
+#include "mdfld_dsi_dbi.h"
+#include "mdfld_dsi_dpi.h"
+//#include "mdfld_dsi_output.h"
+#ifdef CONFIG_MDFLD_DSI_DPU
+#include "mdfld_dsi_dbi_dpu.h"
+#endif
+
+#include <linux/pm_runtime.h>
+
+#ifdef MIN
+#undef MIN
+#endif
+
+#define MIN(x, y) (((x) < (y)) ? (x) : (y))
+
+/* Hardcoded currently */
+static int ksel = KSEL_CRYSTAL_19;
+
+extern struct drm_device *gpDrmDevice;
+extern void mdfld_save_display(struct drm_device *dev);
+extern bool gbgfxsuspended;
+
+struct psb_intel_range_t {
+	int min, max;
+};
+
+struct mdfld_limit_t {
+	struct psb_intel_range_t dot, m, p1;
+};
+
+struct mdfld_intel_clock_t {
+	/* given values */
+	int n;
+	int m1, m2;
+	int p1, p2;
+	/* derived values */
+	int dot;
+	int vco;
+	int m;
+	int p;
+};
+
+
+
+#define COUNT_MAX 0x10000000
+
+void mdfldWaitForPipeDisable(struct drm_device *dev, int pipe)
+{
+	int count, temp;
+	u32 pipeconf_reg = PIPEACONF;
+	
+	switch (pipe) {
+	case 0:
+		break;
+	case 1:
+		pipeconf_reg = PIPEBCONF;
+		break;
+	case 2:
+		pipeconf_reg = PIPECCONF;
+		break;
+	default:
+		DRM_ERROR("Illegal Pipe Number. \n");
+		return;
+	}
+
+	/* FIXME JLIU7_PO */
+	psb_intel_wait_for_vblank(dev);
+	return;
+
+	/* Wait for for the pipe disable to take effect. */
+	for (count = 0; count < COUNT_MAX; count++) {
+		temp = REG_READ(pipeconf_reg);
+		if ((temp & PIPEACONF_PIPE_STATE) == 0)
+			break;
+	}
+}
+
+void mdfldWaitForPipeEnable(struct drm_device *dev, int pipe)
+{
+	int count, temp;
+	u32 pipeconf_reg = PIPEACONF;
+	
+	switch (pipe) {
+	case 0:
+		break;
+	case 1:
+		pipeconf_reg = PIPEBCONF;
+		break;
+	case 2:
+		pipeconf_reg = PIPECCONF;
+		break;
+	default:
+		dev_err(dev->dev, "Illegal Pipe Number.\n");
+		return;
+	}
+
+	/* FIXME JLIU7_PO */
+	psb_intel_wait_for_vblank(dev);
+	return;
+
+	/* Wait for for the pipe enable to take effect. */
+	for (count = 0; count < COUNT_MAX; count++) {
+		temp = REG_READ(pipeconf_reg);
+		if ((temp & PIPEACONF_PIPE_STATE) == 1)
+			break;
+	}
+}
+
+
+static int mdfld_intel_crtc_cursor_set(struct drm_crtc *crtc,
+				 struct drm_file *file_priv,
+				 uint32_t handle,
+				 uint32_t width, uint32_t height)
+{
+	struct drm_device *dev = crtc->dev;
+	struct drm_psb_private * dev_priv = (struct drm_psb_private *)dev->dev_private;
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int pipe = psb_intel_crtc->pipe;
+	uint32_t control = CURACNTR;
+	uint32_t base = CURABASE;
+	uint32_t temp;
+	size_t addr = 0;
+	struct gtt_range *gt;
+	struct drm_gem_object *obj;
+	int ret;
+
+	switch (pipe) {
+	case 0:
+		break;
+	case 1:
+		control = CURBCNTR;
+		base = CURBBASE;
+		break;
+	case 2:
+		control = CURCCNTR;
+		base = CURCBASE;
+		break;
+	default:
+		dev_err(dev->dev, "Illegal Pipe Number. \n");
+		return -EINVAL;
+	}
+	
+#if 1 /* FIXME_JLIU7 can't enalbe cursorB/C HW issue. need to remove after HW fix */
+	if (pipe != 0)
+		return 0;
+#endif 
+	/* if we want to turn of the cursor ignore width and height */
+	if (!handle) {
+		dev_dbg(dev->dev, "cursor off\n");
+		/* turn off the cursor */
+		temp = 0;
+		temp |= CURSOR_MODE_DISABLE;
+
+		if (gma_power_begin(dev, true)) {
+			REG_WRITE(control, temp);
+			REG_WRITE(base, 0);
+			gma_power_end(dev);
+		}
+		/* Unpin the old GEM object */
+		if (psb_intel_crtc->cursor_obj) {
+			gt = container_of(psb_intel_crtc->cursor_obj,
+							struct gtt_range, gem);
+			psb_gtt_unpin(gt);
+			drm_gem_object_unreference(psb_intel_crtc->cursor_obj);
+			psb_intel_crtc->cursor_obj = NULL;
+		}
+		return 0;
+	}
+
+	/* Currently we only support 64x64 cursors */
+	if (width != 64 || height != 64) {
+		DRM_ERROR("we currently only support 64x64 cursors\n");
+		return -EINVAL;
+	}
+
+	obj = drm_gem_object_lookup(dev, file_priv, handle);
+	if (!obj)
+		return -ENOENT;
+
+	if (obj->size < width * height * 4) {
+		dev_dbg(dev->dev, "buffer is to small\n");
+		return -ENOMEM;
+	}
+
+	gt = container_of(obj, struct gtt_range, gem);
+
+	/* Pin the memory into the GTT */
+	ret = psb_gtt_pin(gt);
+	if (ret) {
+		dev_err(dev->dev, "Can not pin down handle 0x%x\n", handle);
+		return ret;
+	}
+
+
+	addr = gt->offset;	/* Or resource.start ??? */
+
+	psb_intel_crtc->cursor_addr = addr;
+
+	temp = 0;
+	/* set the pipe for the cursor */
+	temp |= (pipe << 28);
+	temp |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
+
+	if (gma_power_begin(dev, true)) {
+		REG_WRITE(control, temp);
+		REG_WRITE(base, addr);
+		gma_power_end(dev);
+	}
+#if 0
+        /* FIXME: COnvert to GEM */
+	/* unpin the old bo */
+	if (psb_intel_crtc->cursor_bo && psb_intel_crtc->cursor_bo != bo) {
+		mode_dev->bo_unpin_for_scanout(dev, psb_intel_crtc->cursor_bo);
+		psb_intel_crtc->cursor_bo = bo;
+	}
+#endif
+	return 0;
+}
+
+static int mdfld_intel_crtc_cursor_move(struct drm_crtc *crtc, int x, int y)
+{
+	struct drm_device *dev = crtc->dev;
+#ifndef CONFIG_MDFLD_DSI_DPU
+	struct drm_psb_private * dev_priv = (struct drm_psb_private *)dev->dev_private;
+#else
+	struct psb_drm_dpu_rect rect;
+#endif
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int pipe = psb_intel_crtc->pipe;
+	uint32_t pos = CURAPOS;
+	uint32_t base = CURABASE;
+	uint32_t temp = 0;
+	uint32_t addr;
+
+	switch (pipe) {
+	case 0:
+#ifndef CONFIG_MDFLD_DSI_DPU
+		if (!(dev_priv->dsr_fb_update & MDFLD_DSR_CURSOR_0))
+			mdfld_dsi_dbi_exit_dsr (dev, MDFLD_DSR_CURSOR_0, 0, 0);
+#else /*CONFIG_MDFLD_DSI_DPU*/
+		rect.x = x;
+		rect.y = y;
+		
+		mdfld_dbi_dpu_report_damage(dev, MDFLD_CURSORA, &rect);
+		mdfld_dpu_exit_dsr(dev);
+#endif
+		break;
+	case 1:
+		pos = CURBPOS;
+		base = CURBBASE;
+		break;
+	case 2:
+#ifndef CONFIG_MDFLD_DSI_DPU
+		if (!(dev_priv->dsr_fb_update & MDFLD_DSR_CURSOR_2))
+			mdfld_dsi_dbi_exit_dsr (dev, MDFLD_DSR_CURSOR_2, 0, 0);
+#else /*CONFIG_MDFLD_DSI_DPU*/
+		mdfld_dbi_dpu_report_damage(dev, MDFLD_CURSORC, &rect);
+		mdfld_dpu_exit_dsr(dev);
+#endif
+		pos = CURCPOS;
+		base = CURCBASE;
+		break;
+	default:
+		DRM_ERROR("Illegal Pipe Number. \n");
+		return -EINVAL;
+	}
+		
+#if 1 /* FIXME_JLIU7 can't enalbe cursorB/C HW issue. need to remove after HW fix */
+	if (pipe != 0)
+		return 0;
+#endif 
+	if (x < 0) {
+		temp |= (CURSOR_POS_SIGN << CURSOR_X_SHIFT);
+		x = -x;
+	}
+	if (y < 0) {
+		temp |= (CURSOR_POS_SIGN << CURSOR_Y_SHIFT);
+		y = -y;
+	}
+
+	temp |= ((x & CURSOR_POS_MASK) << CURSOR_X_SHIFT);
+	temp |= ((y & CURSOR_POS_MASK) << CURSOR_Y_SHIFT);
+
+	addr = psb_intel_crtc->cursor_addr;
+
+	if (gma_power_begin(dev, true)) {
+		REG_WRITE(pos, temp);
+		REG_WRITE(base, addr);
+		gma_power_end(dev);
+	}
+
+	return 0;
+}
+
+const struct drm_crtc_funcs mdfld_intel_crtc_funcs = {
+	.cursor_set = mdfld_intel_crtc_cursor_set,
+	.cursor_move = mdfld_intel_crtc_cursor_move,
+	.gamma_set = psb_intel_crtc_gamma_set,
+	.set_config = drm_crtc_helper_set_config,
+	.destroy = psb_intel_crtc_destroy,
+};
+
+static struct drm_device globle_dev;
+
+void mdfld__intel_plane_set_alpha(int enable)
+{
+	struct drm_device *dev = &globle_dev;
+	int dspcntr_reg = DSPACNTR;
+	u32 dspcntr;
+
+	dspcntr = REG_READ(dspcntr_reg);
+
+	if (enable) {
+		dspcntr &= ~DISPPLANE_32BPP_NO_ALPHA;
+		dspcntr |= DISPPLANE_32BPP;
+	} else {
+		dspcntr &= ~DISPPLANE_32BPP;
+		dspcntr |= DISPPLANE_32BPP_NO_ALPHA;
+	}
+
+	REG_WRITE(dspcntr_reg, dspcntr);
+}
+
+int mdfld__intel_pipe_set_base(struct drm_crtc *crtc, int x, int y, struct drm_framebuffer *old_fb)
+{
+	struct drm_device *dev = crtc->dev;
+	/* struct drm_i915_master_private *master_priv; */
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	struct psb_framebuffer *psbfb = to_psb_fb(crtc->fb);
+	struct psb_intel_mode_device *mode_dev = psb_intel_crtc->mode_dev;
+	int pipe = psb_intel_crtc->pipe;
+	unsigned long start, offset;
+	int dsplinoff = DSPALINOFF;
+	int dspsurf = DSPASURF;
+	int dspstride = DSPASTRIDE;
+	int dspcntr_reg = DSPACNTR;
+	u32 dspcntr;
+	int ret = 0;
+
+	memcpy(&globle_dev, dev, sizeof(struct drm_device));
+
+	if (!gma_power_begin(dev, true))
+		return 0;
+
+	/* no fb bound */
+	if (!crtc->fb) {
+		dev_err(dev->dev, "No FB bound\n");
+		goto psb_intel_pipe_cleaner;
+	}
+
+	switch (pipe) {
+	case 0:
+		dsplinoff = DSPALINOFF;
+		break;
+	case 1:
+		dsplinoff = DSPBLINOFF;
+		dspsurf = DSPBSURF;
+		dspstride = DSPBSTRIDE;
+		dspcntr_reg = DSPBCNTR;
+		break;
+	case 2:
+		dsplinoff = DSPCLINOFF;
+		dspsurf = DSPCSURF;
+		dspstride = DSPCSTRIDE;
+		dspcntr_reg = DSPCCNTR;
+		break;
+	default:
+		dev_err(dev->dev, "Illegal Pipe Number.\n");
+		return -EINVAL;
+	}
+
+	ret = psb_gtt_pin(psbfb->gtt);
+	if (ret < 0)
+	        goto psb_intel_pipe_set_base_exit;
+
+	start = psbfb->gtt->offset;
+	offset = y * crtc->fb->pitch + x * (crtc->fb->bits_per_pixel / 8);
+
+	REG_WRITE(dspstride, crtc->fb->pitch);
+	dspcntr = REG_READ(dspcntr_reg);
+	dspcntr &= ~DISPPLANE_PIXFORMAT_MASK;
+
+	switch (crtc->fb->bits_per_pixel) {
+	case 8:
+		dspcntr |= DISPPLANE_8BPP;
+		break;
+	case 16:
+		if (crtc->fb->depth == 15)
+			dspcntr |= DISPPLANE_15_16BPP;
+		else
+			dspcntr |= DISPPLANE_16BPP;
+		break;
+	case 24:
+	case 32:
+		dspcntr |= DISPPLANE_32BPP_NO_ALPHA;
+		break;
+	default:
+		dev_err(dev->dev, "Unknown color depth\n");
+		ret = -EINVAL;
+		goto psb_intel_pipe_set_base_exit;
+	}
+	REG_WRITE(dspcntr_reg, dspcntr);
+
+	dev_dbg(dev->dev, "Writing base %08lX %08lX %d %d\n",
+	                                        start, offset, x, y);
+
+	REG_WRITE(dsplinoff, offset);
+	REG_READ(dsplinoff);
+	REG_WRITE(dspsurf, start);
+	REG_READ(dspsurf);
+
+psb_intel_pipe_cleaner:
+	/* If there was a previous display we can now unpin it */
+	if (old_fb)
+		psb_gtt_unpin(to_psb_fb(old_fb)->gtt);
+
+psb_intel_pipe_set_base_exit:
+	gma_power_end(dev);
+	return ret;
+}
+
+/**
+ * Disable the pipe, plane and pll.
+ *
+ */
+void mdfld_disable_crtc (struct drm_device *dev, int pipe)
+{
+	int dpll_reg = MRST_DPLL_A;
+	int dspcntr_reg = DSPACNTR;
+	int dspbase_reg = MRST_DSPABASE;
+	int pipeconf_reg = PIPEACONF;
+	u32 gen_fifo_stat_reg = GEN_FIFO_STAT_REG;
+	u32 temp;
+
+	switch (pipe) {
+	case 0:
+		break;
+	case 1:
+		dpll_reg = MDFLD_DPLL_B;
+		dspcntr_reg = DSPBCNTR;
+		dspbase_reg = DSPBSURF;
+		pipeconf_reg = PIPEBCONF;
+		break;
+	case 2:
+		dpll_reg = MRST_DPLL_A;
+		dspcntr_reg = DSPCCNTR;
+		dspbase_reg = MDFLD_DSPCBASE;
+		pipeconf_reg = PIPECCONF;
+		gen_fifo_stat_reg = GEN_FIFO_STAT_REG + MIPIC_REG_OFFSET;
+		break;
+	default:
+		dev_err(dev->dev, "Illegal Pipe Number. \n");
+		return;
+	}
+
+	if (pipe != 1)
+		mdfld_dsi_gen_fifo_ready (dev, gen_fifo_stat_reg, HS_CTRL_FIFO_EMPTY | HS_DATA_FIFO_EMPTY);
+
+	/* Disable display plane */
+	temp = REG_READ(dspcntr_reg);
+	if ((temp & DISPLAY_PLANE_ENABLE) != 0) {
+		REG_WRITE(dspcntr_reg,
+			  temp & ~DISPLAY_PLANE_ENABLE);
+		/* Flush the plane changes */
+		REG_WRITE(dspbase_reg, REG_READ(dspbase_reg));
+		REG_READ(dspbase_reg);
+	}
+
+	/* FIXME_JLIU7 MDFLD_PO revisit */
+	/* Wait for vblank for the disable to take effect */
+// MDFLD_PO_JLIU7		psb_intel_wait_for_vblank(dev);
+
+	/* Next, disable display pipes */
+	temp = REG_READ(pipeconf_reg);
+	if ((temp & PIPEACONF_ENABLE) != 0) {
+		temp &= ~PIPEACONF_ENABLE;
+		temp |= PIPECONF_PLANE_OFF | PIPECONF_CURSOR_OFF;
+		REG_WRITE(pipeconf_reg, temp);
+		REG_READ(pipeconf_reg);
+
+		/* Wait for for the pipe disable to take effect. */
+		mdfldWaitForPipeDisable(dev, pipe);
+	}
+
+	temp = REG_READ(dpll_reg);
+	if (temp & DPLL_VCO_ENABLE) {
+		if (((pipe != 1) && !((REG_READ(PIPEACONF) | REG_READ(PIPECCONF)) & PIPEACONF_ENABLE))
+				|| (pipe == 1)){
+			temp &= ~(DPLL_VCO_ENABLE);
+			REG_WRITE(dpll_reg, temp);
+			REG_READ(dpll_reg);
+			/* Wait for the clocks to turn off. */
+			/* FIXME_MDFLD PO may need more delay */
+			udelay(500);
+
+			if (!(temp & MDFLD_PWR_GATE_EN)) {
+				/* gating power of DPLL */
+				REG_WRITE(dpll_reg, temp | MDFLD_PWR_GATE_EN);
+				/* FIXME_MDFLD PO - change 500 to 1 after PO */
+				udelay(5000);
+			}
+		}
+	}
+
+}
+
+/**
+ * Sets the power management mode of the pipe and plane.
+ *
+ * This code should probably grow support for turning the cursor off and back
+ * on appropriately at the same time as we're turning the pipe off/on.
+ */
+static void mdfld_crtc_dpms(struct drm_crtc *crtc, int mode)
+{
+	struct drm_device *dev = crtc->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int pipe = psb_intel_crtc->pipe;
+	int dpll_reg = MRST_DPLL_A;
+	int dspcntr_reg = DSPACNTR;
+	int dspbase_reg = MRST_DSPABASE;
+	int pipeconf_reg = PIPEACONF;
+	u32 pipestat_reg = PIPEASTAT;
+	u32 gen_fifo_stat_reg = GEN_FIFO_STAT_REG;
+	u32 pipeconf = dev_priv->pipeconf;
+	u32 dspcntr = dev_priv->dspcntr;
+	u32 mipi_enable_reg = MIPIA_DEVICE_READY_REG;
+	u32 temp;
+	bool enabled;
+	int timeout = 0;
+
+	if (!gma_power_begin(dev, true))
+		return;
+
+	 /* Ignore if system is already in DSR and in suspended state. */
+	if(gbgfxsuspended && dev_priv->dispstatus == false && mode == 3){
+	    if(dev_priv->rpm_enabled && pipe == 1){
+	//          dev_priv->is_mipi_on = false;
+	            pm_request_idle(&gpDrmDevice->pdev->dev);
+	    }
+	    return;
+	}else if(mode == 0) {
+		//do not need to set gbdispstatus=true in crtc.
+		//this will be set in encoder such as mdfld_dsi_dbi_dpms
+	    //gbdispstatus = true;
+	}
+
+
+/* FIXME_JLIU7 MDFLD_PO replaced w/ the following function */
+/* mdfld_dbi_dpms (struct drm_device *dev, int pipe, bool enabled) */
+
+	switch (pipe) {
+	case 0:
+		break;
+	case 1:
+		dpll_reg = DPLL_B;
+		dspcntr_reg = DSPBCNTR;
+		dspbase_reg = MRST_DSPBBASE;
+		pipeconf_reg = PIPEBCONF;
+		pipeconf = dev_priv->pipeconf1;
+		dspcntr = dev_priv->dspcntr1;
+		dpll_reg = MDFLD_DPLL_B;
+		break;
+	case 2:
+		dpll_reg = MRST_DPLL_A;
+		dspcntr_reg = DSPCCNTR;
+		dspbase_reg = MDFLD_DSPCBASE;
+		pipeconf_reg = PIPECCONF;
+		pipestat_reg = PIPECSTAT;
+		pipeconf = dev_priv->pipeconf2;
+		dspcntr = dev_priv->dspcntr2;
+		gen_fifo_stat_reg = GEN_FIFO_STAT_REG + MIPIC_REG_OFFSET;
+		mipi_enable_reg = MIPIA_DEVICE_READY_REG + MIPIC_REG_OFFSET;
+		break;
+	default:
+		dev_err(dev->dev, "Illegal Pipe Number.\n");
+		return;
+	}
+
+	/* XXX: When our outputs are all unaware of DPMS modes other than off
+	 * and on, we should map those modes to DRM_MODE_DPMS_OFF in the CRTC.
+	 */
+	switch (mode) {
+	case DRM_MODE_DPMS_ON:
+	case DRM_MODE_DPMS_STANDBY:
+	case DRM_MODE_DPMS_SUSPEND:
+		/* Enable the DPLL */
+		temp = REG_READ(dpll_reg);
+
+		if ((temp & DPLL_VCO_ENABLE) == 0) {
+			/* When ungating power of DPLL, needs to wait 0.5us before enable the VCO */
+			if (temp & MDFLD_PWR_GATE_EN) {
+				temp &= ~MDFLD_PWR_GATE_EN;
+				REG_WRITE(dpll_reg, temp);
+				/* FIXME_MDFLD PO - change 500 to 1 after PO */
+				udelay(500);
+			}
+
+			REG_WRITE(dpll_reg, temp);
+			REG_READ(dpll_reg);
+			/* FIXME_MDFLD PO - change 500 to 1 after PO */
+			udelay(500);
+			
+			REG_WRITE(dpll_reg, temp | DPLL_VCO_ENABLE);
+			REG_READ(dpll_reg);
+
+			/**
+			 * wait for DSI PLL to lock
+			 * NOTE: only need to poll status of pipe 0 and pipe 1,
+			 * since both MIPI pipes share the same PLL.
+			 */
+			while ((pipe != 2) && (timeout < 20000) && !(REG_READ(pipeconf_reg) & PIPECONF_DSIPLL_LOCK)) {
+				udelay(150);
+				timeout ++;
+			}
+		}
+
+		/* Enable the plane */
+		temp = REG_READ(dspcntr_reg);
+		if ((temp & DISPLAY_PLANE_ENABLE) == 0) {
+			REG_WRITE(dspcntr_reg,
+				temp | DISPLAY_PLANE_ENABLE);
+			/* Flush the plane changes */
+			REG_WRITE(dspbase_reg, REG_READ(dspbase_reg));
+		}
+
+		/* Enable the pipe */
+		temp = REG_READ(pipeconf_reg);
+		if ((temp & PIPEACONF_ENABLE) == 0) {
+			REG_WRITE(pipeconf_reg, pipeconf);
+
+			/* Wait for for the pipe enable to take effect. */
+			mdfldWaitForPipeEnable(dev, pipe);
+		}
+
+		/*workaround for sighting 3741701 Random X blank display*/
+		/*perform w/a in video mode only on pipe A or C*/
+		if ((pipe == 0 || pipe == 2) &&
+			(mdfld_panel_dpi(dev) == true)) {
+			REG_WRITE(pipestat_reg, REG_READ(pipestat_reg));
+			msleep(100);
+			if(PIPE_VBLANK_STATUS & REG_READ(pipestat_reg)) {
+				printk(KERN_ALERT "OK");
+			} else {
+				printk(KERN_ALERT "STUCK!!!!");
+				/*shutdown controller*/
+				temp = REG_READ(dspcntr_reg);
+				REG_WRITE(dspcntr_reg, temp & ~DISPLAY_PLANE_ENABLE);
+				REG_WRITE(dspbase_reg, REG_READ(dspbase_reg));
+				/*mdfld_dsi_dpi_shut_down(dev, pipe);*/
+				REG_WRITE(0xb048, 1);
+				msleep(100);
+				temp = REG_READ(pipeconf_reg);
+				temp &= ~PIPEACONF_ENABLE;
+				REG_WRITE(pipeconf_reg, temp);
+				msleep(100); /*wait for pipe disable*/
+			/*printk(KERN_ALERT "70008 is %x\n", REG_READ(0x70008));
+			printk(KERN_ALERT "b074 is %x\n", REG_READ(0xb074));*/
+				REG_WRITE(mipi_enable_reg, 0);
+				msleep(100);
+			printk(KERN_ALERT "70008 is %x\n", REG_READ(0x70008));
+			printk(KERN_ALERT "b074 is %x\n", REG_READ(0xb074));
+				REG_WRITE(0xb004, REG_READ(0xb004));
+				/* try to bring the controller back up again*/
+				REG_WRITE(mipi_enable_reg, 1);
+				temp = REG_READ(dspcntr_reg);
+				REG_WRITE(dspcntr_reg, temp | DISPLAY_PLANE_ENABLE);
+				REG_WRITE(dspbase_reg, REG_READ(dspbase_reg));
+				/*mdfld_dsi_dpi_turn_on(dev, pipe);*/
+				REG_WRITE(0xb048, 2);
+				msleep(100);
+				temp = REG_READ(pipeconf_reg);
+				temp |= PIPEACONF_ENABLE;
+				REG_WRITE(pipeconf_reg, temp);
+			}
+		}
+
+		psb_intel_crtc_load_lut(crtc);
+
+		/* Give the overlay scaler a chance to enable
+		   if it's on this pipe */
+		/* psb_intel_crtc_dpms_video(crtc, true); TODO */
+
+		break;
+	case DRM_MODE_DPMS_OFF:
+		/* Give the overlay scaler a chance to disable
+		 * if it's on this pipe */
+		/* psb_intel_crtc_dpms_video(crtc, FALSE); TODO */
+		if (pipe != 1)
+			mdfld_dsi_gen_fifo_ready (dev, gen_fifo_stat_reg, HS_CTRL_FIFO_EMPTY | HS_DATA_FIFO_EMPTY);
+
+		/* Disable the VGA plane that we never use */
+		REG_WRITE(VGACNTRL, VGA_DISP_DISABLE);
+
+		/* Disable display plane */
+		temp = REG_READ(dspcntr_reg);
+		if ((temp & DISPLAY_PLANE_ENABLE) != 0) {
+			REG_WRITE(dspcntr_reg,
+				  temp & ~DISPLAY_PLANE_ENABLE);
+			/* Flush the plane changes */
+			REG_WRITE(dspbase_reg, REG_READ(dspbase_reg));
+			REG_READ(dspbase_reg);
+		}
+
+		/* FIXME_JLIU7 MDFLD_PO revisit */
+		/* Wait for vblank for the disable to take effect */
+// MDFLD_PO_JLIU7		psb_intel_wait_for_vblank(dev);
+
+		/* Next, disable display pipes */
+		temp = REG_READ(pipeconf_reg);
+		if ((temp & PIPEACONF_ENABLE) != 0) {
+			temp &= ~PIPEACONF_ENABLE;
+			temp |= PIPECONF_PLANE_OFF | PIPECONF_CURSOR_OFF;
+			REG_WRITE(pipeconf_reg, temp);
+//			REG_WRITE(pipeconf_reg, 0);
+			REG_READ(pipeconf_reg);
+
+			/* Wait for for the pipe disable to take effect. */
+			mdfldWaitForPipeDisable(dev, pipe);
+		}
+
+		temp = REG_READ(dpll_reg);
+		if (temp & DPLL_VCO_ENABLE) {
+			if (((pipe != 1) && !((REG_READ(PIPEACONF) | REG_READ(PIPECCONF)) & PIPEACONF_ENABLE))
+					|| (pipe == 1)){
+				temp &= ~(DPLL_VCO_ENABLE);
+				REG_WRITE(dpll_reg, temp);
+				REG_READ(dpll_reg);
+				/* Wait for the clocks to turn off. */
+				/* FIXME_MDFLD PO may need more delay */
+				udelay(500);
+#if 0 /* MDFLD_PO_JLIU7 */	
+		if (!(temp & MDFLD_PWR_GATE_EN)) {
+			/* gating power of DPLL */
+			REG_WRITE(dpll_reg, temp | MDFLD_PWR_GATE_EN);
+			/* FIXME_MDFLD PO - change 500 to 1 after PO */
+			udelay(5000);
+		}
+#endif  /* MDFLD_PO_JLIU7 */	
+			}
+		}
+		break;
+	}
+
+	enabled = crtc->enabled && mode != DRM_MODE_DPMS_OFF;
+
+#if 0				/* JB: Add vblank support later */
+	if (enabled)
+		dev_priv->vblank_pipe |= (1 << pipe);
+	else
+		dev_priv->vblank_pipe &= ~(1 << pipe);
+#endif
+
+	gma_power_end(dev);
+}
+
+
+#define MDFLD_LIMT_DPLL_19	    0
+#define MDFLD_LIMT_DPLL_25	    1
+#define MDFLD_LIMT_DPLL_83	    2
+#define MDFLD_LIMT_DPLL_100	    3
+#define MDFLD_LIMT_DSIPLL_19	    4
+#define MDFLD_LIMT_DSIPLL_25	    5
+#define MDFLD_LIMT_DSIPLL_83	    6
+#define MDFLD_LIMT_DSIPLL_100	    7
+
+#define MDFLD_DOT_MIN		  19750  /* FIXME_MDFLD JLIU7 need to find out  min & max for MDFLD */
+#define MDFLD_DOT_MAX		  120000
+#define MDFLD_DPLL_M_MIN_19	    113
+#define MDFLD_DPLL_M_MAX_19	    155
+#define MDFLD_DPLL_P1_MIN_19	    2
+#define MDFLD_DPLL_P1_MAX_19	    10
+#define MDFLD_DPLL_M_MIN_25	    101
+#define MDFLD_DPLL_M_MAX_25	    130
+#define MDFLD_DPLL_P1_MIN_25	    2
+#define MDFLD_DPLL_P1_MAX_25	    10
+#define MDFLD_DPLL_M_MIN_83	    64
+#define MDFLD_DPLL_M_MAX_83	    64
+#define MDFLD_DPLL_P1_MIN_83	    2
+#define MDFLD_DPLL_P1_MAX_83	    2
+#define MDFLD_DPLL_M_MIN_100	    64
+#define MDFLD_DPLL_M_MAX_100	    64
+#define MDFLD_DPLL_P1_MIN_100	    2
+#define MDFLD_DPLL_P1_MAX_100	    2
+#define MDFLD_DSIPLL_M_MIN_19	    131
+#define MDFLD_DSIPLL_M_MAX_19	    175
+#define MDFLD_DSIPLL_P1_MIN_19	    3
+#define MDFLD_DSIPLL_P1_MAX_19	    8
+#define MDFLD_DSIPLL_M_MIN_25	    97
+#define MDFLD_DSIPLL_M_MAX_25	    140
+#define MDFLD_DSIPLL_P1_MIN_25	    3
+#define MDFLD_DSIPLL_P1_MAX_25	    9
+#define MDFLD_DSIPLL_M_MIN_83	    33
+#define MDFLD_DSIPLL_M_MAX_83	    92
+#define MDFLD_DSIPLL_P1_MIN_83	    2
+#define MDFLD_DSIPLL_P1_MAX_83	    3
+#define MDFLD_DSIPLL_M_MIN_100	    97
+#define MDFLD_DSIPLL_M_MAX_100	    140
+#define MDFLD_DSIPLL_P1_MIN_100	    3
+#define MDFLD_DSIPLL_P1_MAX_100	    9
+
+static const struct mdfld_limit_t mdfld_limits[] = {
+	{			/* MDFLD_LIMT_DPLL_19 */
+	 .dot = {.min = MDFLD_DOT_MIN, .max = MDFLD_DOT_MAX},
+	 .m = {.min = MDFLD_DPLL_M_MIN_19, .max = MDFLD_DPLL_M_MAX_19},
+	 .p1 = {.min = MDFLD_DPLL_P1_MIN_19, .max = MDFLD_DPLL_P1_MAX_19},
+	 },
+	{			/* MDFLD_LIMT_DPLL_25 */
+	 .dot = {.min = MDFLD_DOT_MIN, .max = MDFLD_DOT_MAX},
+	 .m = {.min = MDFLD_DPLL_M_MIN_25, .max = MDFLD_DPLL_M_MAX_25},
+	 .p1 = {.min = MDFLD_DPLL_P1_MIN_25, .max = MDFLD_DPLL_P1_MAX_25},
+	 },
+	{			/* MDFLD_LIMT_DPLL_83 */
+	 .dot = {.min = MDFLD_DOT_MIN, .max = MDFLD_DOT_MAX},
+	 .m = {.min = MDFLD_DPLL_M_MIN_83, .max = MDFLD_DPLL_M_MAX_83},
+	 .p1 = {.min = MDFLD_DPLL_P1_MIN_83, .max = MDFLD_DPLL_P1_MAX_83},
+	 },
+	{			/* MDFLD_LIMT_DPLL_100 */
+	 .dot = {.min = MDFLD_DOT_MIN, .max = MDFLD_DOT_MAX},
+	 .m = {.min = MDFLD_DPLL_M_MIN_100, .max = MDFLD_DPLL_M_MAX_100},
+	 .p1 = {.min = MDFLD_DPLL_P1_MIN_100, .max = MDFLD_DPLL_P1_MAX_100},
+	 },
+	{			/* MDFLD_LIMT_DSIPLL_19 */
+	 .dot = {.min = MDFLD_DOT_MIN, .max = MDFLD_DOT_MAX},
+	 .m = {.min = MDFLD_DSIPLL_M_MIN_19, .max = MDFLD_DSIPLL_M_MAX_19},
+	 .p1 = {.min = MDFLD_DSIPLL_P1_MIN_19, .max = MDFLD_DSIPLL_P1_MAX_19},
+	 },
+	{			/* MDFLD_LIMT_DSIPLL_25 */
+	 .dot = {.min = MDFLD_DOT_MIN, .max = MDFLD_DOT_MAX},
+	 .m = {.min = MDFLD_DSIPLL_M_MIN_25, .max = MDFLD_DSIPLL_M_MAX_25},
+	 .p1 = {.min = MDFLD_DSIPLL_P1_MIN_25, .max = MDFLD_DSIPLL_P1_MAX_25},
+	 },
+	{			/* MDFLD_LIMT_DSIPLL_83 */
+	 .dot = {.min = MDFLD_DOT_MIN, .max = MDFLD_DOT_MAX},
+	 .m = {.min = MDFLD_DSIPLL_M_MIN_83, .max = MDFLD_DSIPLL_M_MAX_83},
+	 .p1 = {.min = MDFLD_DSIPLL_P1_MIN_83, .max = MDFLD_DSIPLL_P1_MAX_83},
+	 },
+	{			/* MDFLD_LIMT_DSIPLL_100 */
+	 .dot = {.min = MDFLD_DOT_MIN, .max = MDFLD_DOT_MAX},
+	 .m = {.min = MDFLD_DSIPLL_M_MIN_100, .max = MDFLD_DSIPLL_M_MAX_100},
+	 .p1 = {.min = MDFLD_DSIPLL_P1_MIN_100, .max = MDFLD_DSIPLL_P1_MAX_100},
+	 },
+};
+
+#define MDFLD_M_MIN	    21
+#define MDFLD_M_MAX	    180
+static const u32 mdfld_m_converts[] = {
+/* M configuration table from 9-bit LFSR table */
+	224, 368, 440, 220, 366, 439, 219, 365, 182, 347, /* 21 - 30 */
+	173, 342, 171, 85, 298, 149, 74, 37, 18, 265,   /* 31 - 40 */
+	388, 194, 353, 432, 216, 108, 310, 155, 333, 166, /* 41 - 50 */
+	83, 41, 276, 138, 325, 162, 337, 168, 340, 170, /* 51 - 60 */
+	341, 426, 469, 234, 373, 442, 221, 110, 311, 411, /* 61 - 70 */
+	461, 486, 243, 377, 188, 350, 175, 343, 427, 213, /* 71 - 80 */
+	106, 53, 282, 397, 354, 227, 113, 56, 284, 142, /* 81 - 90 */
+	71, 35, 273, 136, 324, 418, 465, 488, 500, 506, /* 91 - 100 */
+	253, 126, 63, 287, 399, 455, 483, 241, 376, 444, /* 101 - 110 */
+	478, 495, 503, 251, 381, 446, 479, 239, 375, 443, /* 111 - 120 */
+	477, 238, 119, 315, 157, 78, 295, 147, 329, 420, /* 121 - 130 */
+	210, 105, 308, 154, 77, 38, 275, 137, 68, 290, /* 131 - 140 */
+	145, 328, 164, 82, 297, 404, 458, 485, 498, 249, /* 141 - 150 */
+	380, 190, 351, 431, 471, 235, 117, 314, 413, 206, /* 151 - 160 */
+	103, 51, 25, 12, 262, 387, 193, 96, 48, 280, /* 161 - 170 */
+	396, 198, 99, 305, 152, 76, 294, 403, 457, 228, /* 171 - 180 */
+};
+
+static const struct mdfld_limit_t *mdfld_limit(struct drm_crtc *crtc)
+{
+	const struct mdfld_limit_t *limit = NULL;
+	struct drm_device *dev = crtc->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	if (psb_intel_pipe_has_type(crtc, INTEL_OUTPUT_MIPI)
+	    || psb_intel_pipe_has_type(crtc, INTEL_OUTPUT_MIPI2)) {
+		if ((ksel == KSEL_CRYSTAL_19) || (ksel == KSEL_BYPASS_19))
+			limit = &mdfld_limits[MDFLD_LIMT_DSIPLL_19];
+		else if (ksel == KSEL_BYPASS_25) 
+			limit = &mdfld_limits[MDFLD_LIMT_DSIPLL_25];
+		else if ((ksel == KSEL_BYPASS_83_100) && (dev_priv->core_freq == 166))
+			limit = &mdfld_limits[MDFLD_LIMT_DSIPLL_83];
+		else if ((ksel == KSEL_BYPASS_83_100) &&
+			 (dev_priv->core_freq == 100 || dev_priv->core_freq == 200))
+			limit = &mdfld_limits[MDFLD_LIMT_DSIPLL_100];
+	} else if (psb_intel_pipe_has_type(crtc, INTEL_OUTPUT_HDMI)) {
+		if ((ksel == KSEL_CRYSTAL_19) || (ksel == KSEL_BYPASS_19))
+			limit = &mdfld_limits[MDFLD_LIMT_DPLL_19];
+		else if (ksel == KSEL_BYPASS_25) 
+			limit = &mdfld_limits[MDFLD_LIMT_DPLL_25];
+		else if ((ksel == KSEL_BYPASS_83_100) && (dev_priv->core_freq == 166))
+			limit = &mdfld_limits[MDFLD_LIMT_DPLL_83];
+		else if ((ksel == KSEL_BYPASS_83_100) &&
+			 (dev_priv->core_freq == 100 || dev_priv->core_freq == 200))
+			limit = &mdfld_limits[MDFLD_LIMT_DPLL_100];
+	} else {
+		limit = NULL;
+		dev_err(dev->dev, "mdfld_limit Wrong display type.\n");
+	}
+
+	return limit;
+}
+
+/** Derive the pixel clock for the given refclk and divisors for 8xx chips. */
+static void mdfld_clock(int refclk, struct mdfld_intel_clock_t *clock)
+{
+	clock->dot = (refclk * clock->m) / clock->p1;
+}
+
+/**
+ * Returns a set of divisors for the desired target clock with the given refclk,
+ * or FALSE.  Divisor values are the actual divisors for
+ */
+static bool
+mdfldFindBestPLL(struct drm_crtc *crtc, int target, int refclk,
+		struct mdfld_intel_clock_t *best_clock)
+{
+	struct mdfld_intel_clock_t clock;
+	const struct mdfld_limit_t *limit = mdfld_limit(crtc);
+	int err = target;
+
+	memset(best_clock, 0, sizeof(*best_clock));
+
+	for (clock.m = limit->m.min; clock.m <= limit->m.max; clock.m++) {
+		for (clock.p1 = limit->p1.min; clock.p1 <= limit->p1.max;
+		     clock.p1++) {
+			int this_err;
+
+			mdfld_clock(refclk, &clock);
+
+			this_err = abs(clock.dot - target);
+			if (this_err < err) {
+				*best_clock = clock;
+				err = this_err;
+			}
+		}
+	}
+	return err != target;
+}
+
+/**
+ * Return the pipe currently connected to the panel fitter,
+ * or -1 if the panel fitter is not present or not in use
+ */
+static int mdfld_panel_fitter_pipe(struct drm_device *dev)
+{
+	u32 pfit_control;
+
+	pfit_control = REG_READ(PFIT_CONTROL);
+
+	/* See if the panel fitter is in use */
+	if ((pfit_control & PFIT_ENABLE) == 0)
+		return -1;
+	return (pfit_control >> 29) & 3;
+}
+
+static int mdfld_crtc_mode_set(struct drm_crtc *crtc,
+			      struct drm_display_mode *mode,
+			      struct drm_display_mode *adjusted_mode,
+			      int x, int y,
+			      struct drm_framebuffer *old_fb)
+{
+	struct drm_device *dev = crtc->dev;
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int pipe = psb_intel_crtc->pipe;
+	int fp_reg = MRST_FPA0;
+	int dpll_reg = MRST_DPLL_A;
+	int dspcntr_reg = DSPACNTR;
+	int pipeconf_reg = PIPEACONF;
+	int htot_reg = HTOTAL_A;
+	int hblank_reg = HBLANK_A;
+	int hsync_reg = HSYNC_A;
+	int vtot_reg = VTOTAL_A;
+	int vblank_reg = VBLANK_A;
+	int vsync_reg = VSYNC_A;
+	int dspsize_reg = DSPASIZE; 
+	int dsppos_reg = DSPAPOS; 
+	int pipesrc_reg = PIPEASRC;
+	u32 *pipeconf = &dev_priv->pipeconf;
+	u32 *dspcntr = &dev_priv->dspcntr;
+	int refclk = 0;
+	int clk_n = 0, clk_p2 = 0, clk_byte = 1, clk = 0, m_conv = 0, clk_tmp = 0;
+	struct mdfld_intel_clock_t clock;
+	bool ok;
+	u32 dpll = 0, fp = 0;
+	bool is_crt = false, is_lvds = false, is_tv = false;
+	bool is_mipi = false, is_mipi2 = false, is_hdmi = false;
+	struct drm_mode_config *mode_config = &dev->mode_config;
+	struct psb_intel_output *psb_intel_output = NULL;
+	uint64_t scalingType = DRM_MODE_SCALE_FULLSCREEN;
+	struct drm_encoder *encoder;
+	struct drm_connector *connector;
+	int timeout = 0;
+
+	dev_dbg(dev->dev, "pipe = 0x%x \n", pipe);
+
+	switch (pipe) {
+	case 0:
+		break;
+	case 1:
+		fp_reg = FPB0;
+		dpll_reg = DPLL_B;
+		dspcntr_reg = DSPBCNTR;
+		pipeconf_reg = PIPEBCONF;
+		htot_reg = HTOTAL_B;
+		hblank_reg = HBLANK_B;
+		hsync_reg = HSYNC_B;
+		vtot_reg = VTOTAL_B;
+		vblank_reg = VBLANK_B;
+		vsync_reg = VSYNC_B;
+		dspsize_reg = DSPBSIZE; 
+		dsppos_reg = DSPBPOS; 
+		pipesrc_reg = PIPEBSRC;
+		pipeconf = &dev_priv->pipeconf1;
+		dspcntr = &dev_priv->dspcntr1;
+		fp_reg = MDFLD_DPLL_DIV0;
+		dpll_reg = MDFLD_DPLL_B;
+		break;
+	case 2:
+		dpll_reg = MRST_DPLL_A;
+		dspcntr_reg = DSPCCNTR;
+		pipeconf_reg = PIPECCONF;
+		htot_reg = HTOTAL_C;
+		hblank_reg = HBLANK_C;
+		hsync_reg = HSYNC_C;
+		vtot_reg = VTOTAL_C;
+		vblank_reg = VBLANK_C;
+		vsync_reg = VSYNC_C;
+		dspsize_reg = DSPCSIZE; 
+		dsppos_reg = DSPCPOS; 
+		pipesrc_reg = PIPECSRC;
+		pipeconf = &dev_priv->pipeconf2;
+		dspcntr = &dev_priv->dspcntr2;
+		break;
+	default:
+		DRM_ERROR("Illegal Pipe Number. \n");
+		return 0;
+	}
+
+	dev_dbg(dev->dev, "adjusted_hdisplay = %d\n",
+		 adjusted_mode->hdisplay);
+	dev_dbg(dev->dev, "adjusted_vdisplay = %d\n",
+		 adjusted_mode->vdisplay);
+	dev_dbg(dev->dev, "adjusted_hsync_start = %d\n",
+		 adjusted_mode->hsync_start);
+	dev_dbg(dev->dev, "adjusted_hsync_end = %d\n",
+		 adjusted_mode->hsync_end);
+	dev_dbg(dev->dev, "adjusted_htotal = %d\n",
+		 adjusted_mode->htotal);
+	dev_dbg(dev->dev, "adjusted_vsync_start = %d\n",
+		 adjusted_mode->vsync_start);
+	dev_dbg(dev->dev, "adjusted_vsync_end = %d\n",
+		 adjusted_mode->vsync_end);
+	dev_dbg(dev->dev, "adjusted_vtotal = %d\n",
+		 adjusted_mode->vtotal);
+	dev_dbg(dev->dev, "adjusted_clock = %d\n",
+		 adjusted_mode->clock);
+	dev_dbg(dev->dev, "hdisplay = %d\n",
+		 mode->hdisplay);
+	dev_dbg(dev->dev, "vdisplay = %d\n",
+		 mode->vdisplay);
+
+	if (!gma_power_begin(dev, true))
+		return 0;
+
+	memcpy(&psb_intel_crtc->saved_mode, mode, sizeof(struct drm_display_mode));
+	memcpy(&psb_intel_crtc->saved_adjusted_mode, adjusted_mode, sizeof(struct drm_display_mode));
+
+	list_for_each_entry(connector, &mode_config->connector_list, head) {
+		if(!connector)
+			continue;
+			
+		encoder = connector->encoder;
+		
+		if(!encoder)
+			continue;
+
+		if (encoder->crtc != crtc)
+			continue;
+
+		psb_intel_output = to_psb_intel_output(connector);
+		
+		dev_dbg(dev->dev, "output->type = 0x%x \n", psb_intel_output->type);
+
+		switch (psb_intel_output->type) {
+		case INTEL_OUTPUT_LVDS:
+			is_lvds = true;
+			break;
+		case INTEL_OUTPUT_TVOUT:
+			is_tv = true;
+			break;
+		case INTEL_OUTPUT_ANALOG:
+			is_crt = true;
+			break;
+		case INTEL_OUTPUT_MIPI:
+			is_mipi = true;
+			break;
+		case INTEL_OUTPUT_MIPI2:
+			is_mipi2 = true;
+			break;
+		case INTEL_OUTPUT_HDMI:
+			is_hdmi = true;
+			break;
+		}
+	}
+
+	/* Disable the VGA plane that we never use */
+	REG_WRITE(VGACNTRL, VGA_DISP_DISABLE);
+
+	/* Disable the panel fitter if it was on our pipe */
+	if (mdfld_panel_fitter_pipe(dev) == pipe)
+		REG_WRITE(PFIT_CONTROL, 0);
+
+	/* pipesrc and dspsize control the size that is scaled from,
+	 * which should always be the user's requested size.
+	 */
+	if (pipe == 1) {
+		/* FIXME: To make HDMI display with 864x480 (TPO), 480x864 (PYR) or 480x854 (TMD), set the sprite
+		 * width/height and souce image size registers with the adjusted mode for pipe B. */
+
+		/* The defined sprite rectangle must always be completely contained within the displayable
+		 * area of the screen image (frame buffer). */
+		REG_WRITE(dspsize_reg, ((MIN(mode->crtc_vdisplay, adjusted_mode->crtc_vdisplay) - 1) << 16)
+				| (MIN(mode->crtc_hdisplay, adjusted_mode->crtc_hdisplay) - 1));
+		/* Set the CRTC with encoder mode. */
+		REG_WRITE(pipesrc_reg, ((mode->crtc_hdisplay - 1) << 16)
+				 | (mode->crtc_vdisplay - 1));
+	} else {
+		REG_WRITE(dspsize_reg, ((mode->crtc_vdisplay - 1) << 16) | (mode->crtc_hdisplay - 1));
+		REG_WRITE(pipesrc_reg, ((mode->crtc_hdisplay - 1) << 16) | (mode->crtc_vdisplay - 1));
+	}
+
+	REG_WRITE(dsppos_reg, 0);
+
+	if (psb_intel_output)
+		drm_connector_property_get_value(&psb_intel_output->base,
+			dev->mode_config.scaling_mode_property, &scalingType);
+
+	if (scalingType == DRM_MODE_SCALE_NO_SCALE) {
+		/*Moorestown doesn't have register support for centering so we need to
+		  mess with the h/vblank and h/vsync start and ends to get centering*/
+		int offsetX = 0, offsetY = 0;
+
+		offsetX = (adjusted_mode->crtc_hdisplay - mode->crtc_hdisplay) / 2;
+		offsetY = (adjusted_mode->crtc_vdisplay - mode->crtc_vdisplay) / 2;
+
+		REG_WRITE(htot_reg, (mode->crtc_hdisplay - 1) |
+			((adjusted_mode->crtc_htotal - 1) << 16));
+		REG_WRITE(vtot_reg, (mode->crtc_vdisplay - 1) |
+			((adjusted_mode->crtc_vtotal - 1) << 16));
+		REG_WRITE(hblank_reg, (adjusted_mode->crtc_hblank_start - offsetX - 1) |
+			((adjusted_mode->crtc_hblank_end - offsetX - 1) << 16));
+		REG_WRITE(hsync_reg, (adjusted_mode->crtc_hsync_start - offsetX - 1) |
+			((adjusted_mode->crtc_hsync_end - offsetX - 1) << 16));
+		REG_WRITE(vblank_reg, (adjusted_mode->crtc_vblank_start - offsetY - 1) |
+			((adjusted_mode->crtc_vblank_end - offsetY - 1) << 16));
+		REG_WRITE(vsync_reg, (adjusted_mode->crtc_vsync_start - offsetY - 1) |
+			((adjusted_mode->crtc_vsync_end - offsetY - 1) << 16));
+	} else {
+		REG_WRITE(htot_reg, (adjusted_mode->crtc_hdisplay - 1) |
+			((adjusted_mode->crtc_htotal - 1) << 16));
+		REG_WRITE(vtot_reg, (adjusted_mode->crtc_vdisplay - 1) |
+			((adjusted_mode->crtc_vtotal - 1) << 16));
+		REG_WRITE(hblank_reg, (adjusted_mode->crtc_hblank_start - 1) |
+			((adjusted_mode->crtc_hblank_end - 1) << 16));
+		REG_WRITE(hsync_reg, (adjusted_mode->crtc_hsync_start - 1) |
+			((adjusted_mode->crtc_hsync_end - 1) << 16));
+		REG_WRITE(vblank_reg, (adjusted_mode->crtc_vblank_start - 1) |
+			((adjusted_mode->crtc_vblank_end - 1) << 16));
+		REG_WRITE(vsync_reg, (adjusted_mode->crtc_vsync_start - 1) |
+			((adjusted_mode->crtc_vsync_end - 1) << 16));
+	}
+
+	/* Flush the plane changes */
+	{
+		struct drm_crtc_helper_funcs *crtc_funcs =
+		    crtc->helper_private;
+		crtc_funcs->mode_set_base(crtc, x, y, old_fb);
+	}
+
+	/* setup pipeconf */
+	*pipeconf = PIPEACONF_ENABLE; /* FIXME_JLIU7 REG_READ(pipeconf_reg); */
+
+	/* Set up the display plane register */
+ 	*dspcntr = REG_READ(dspcntr_reg);
+	*dspcntr |= pipe << DISPPLANE_SEL_PIPE_POS;
+	*dspcntr |= DISPLAY_PLANE_ENABLE;
+/* MDFLD_PO_JLIU7	dspcntr |= DISPPLANE_BOTTOM; */
+/* MDFLD_PO_JLIU7	dspcntr |= DISPPLANE_GAMMA_ENABLE; */
+
+	if (is_mipi2)
+	{
+		goto mrst_crtc_mode_set_exit;
+	}
+/* FIXME JLIU7 Add MDFLD HDMI supports */
+/* FIXME_MDFLD JLIU7 DSIPLL clock *= 8? */
+/* FIXME_MDFLD JLIU7 need to revist for dual MIPI supports */
+	clk = adjusted_mode->clock;
+
+	if (is_hdmi) {
+		if ((ksel == KSEL_CRYSTAL_19) || (ksel == KSEL_BYPASS_19))
+		{
+			refclk = 19200;
+
+			if (is_mipi || is_mipi2)
+			{
+				clk_n = 1, clk_p2 = 8;
+			} else if (is_hdmi) {
+				clk_n = 1, clk_p2 = 10;
+			}
+		} else if (ksel == KSEL_BYPASS_25) { 
+			refclk = 25000;
+
+			if (is_mipi || is_mipi2)
+			{
+				clk_n = 1, clk_p2 = 8;
+			} else if (is_hdmi) {
+				clk_n = 1, clk_p2 = 10;
+			}
+		} else if ((ksel == KSEL_BYPASS_83_100) && (dev_priv->core_freq == 166)) {
+			refclk = 83000;
+
+			if (is_mipi || is_mipi2)
+			{
+				clk_n = 4, clk_p2 = 8;
+			} else if (is_hdmi) {
+				clk_n = 4, clk_p2 = 10;
+			}
+		} else if ((ksel == KSEL_BYPASS_83_100) &&
+			   (dev_priv->core_freq == 100 || dev_priv->core_freq == 200)) {
+			refclk = 100000;
+			if (is_mipi || is_mipi2)
+			{
+				clk_n = 4, clk_p2 = 8;
+			} else if (is_hdmi) {
+				clk_n = 4, clk_p2 = 10;
+			}
+		}
+
+		if (is_mipi)
+			clk_byte = dev_priv->bpp / 8;
+		else if (is_mipi2)
+			clk_byte = dev_priv->bpp2 / 8;
+	
+		clk_tmp = clk * clk_n * clk_p2 * clk_byte;
+
+		dev_dbg(dev->dev, "clk = %d, clk_n = %d, clk_p2 = %d. \n", clk, clk_n, clk_p2);
+		dev_dbg(dev->dev, "adjusted_mode->clock = %d, clk_tmp = %d. \n", adjusted_mode->clock, clk_tmp);
+
+		ok = mdfldFindBestPLL(crtc, clk_tmp, refclk, &clock);
+
+		if (!ok) {
+			dev_err(dev->dev, 
+			   "mdfldFindBestPLL fail in mdfld_crtc_mode_set. \n");
+		} else {
+			m_conv = mdfld_m_converts[(clock.m - MDFLD_M_MIN)];
+
+			dev_dbg(dev->dev, "dot clock = %d,"
+				 "m = %d, p1 = %d, m_conv = %d. \n", clock.dot, clock.m,
+				 clock.p1, m_conv);
+		}
+
+		dpll = REG_READ(dpll_reg);
+
+		if (dpll & DPLL_VCO_ENABLE) {
+			dpll &= ~DPLL_VCO_ENABLE;
+			REG_WRITE(dpll_reg, dpll);
+			REG_READ(dpll_reg);
+
+			/* FIXME jliu7 check the DPLL lock bit PIPEACONF[29] */
+			/* FIXME_MDFLD PO - change 500 to 1 after PO */
+			udelay(500);
+
+			/* reset M1, N1 & P1 */
+			REG_WRITE(fp_reg, 0);
+			dpll &= ~MDFLD_P1_MASK;
+			REG_WRITE(dpll_reg, dpll);
+			/* FIXME_MDFLD PO - change 500 to 1 after PO */
+			udelay(500);
+		}
+
+		/* When ungating power of DPLL, needs to wait 0.5us before enable the VCO */
+		if (dpll & MDFLD_PWR_GATE_EN) {
+			dpll &= ~MDFLD_PWR_GATE_EN;
+			REG_WRITE(dpll_reg, dpll);
+			/* FIXME_MDFLD PO - change 500 to 1 after PO */
+			udelay(500);
+		}	
+
+		dpll = 0; 
+
+#if 0 /* FIXME revisit later */
+		if ((ksel == KSEL_CRYSTAL_19) || (ksel == KSEL_BYPASS_19) || (ksel == KSEL_BYPASS_25)) {
+			dpll &= ~MDFLD_INPUT_REF_SEL;	
+		} else if (ksel == KSEL_BYPASS_83_100) { 
+			dpll |= MDFLD_INPUT_REF_SEL;	
+		}
+#endif /* FIXME revisit later */
+
+		if (is_hdmi)
+			dpll |= MDFLD_VCO_SEL;	
+
+		fp = (clk_n / 2) << 16;
+		fp |= m_conv; 
+
+		/* compute bitmask from p1 value */
+		dpll |= (1 << (clock.p1 - 2)) << 17;
+
+#if 0 /* 1080p30 & 720p */
+        	dpll = 0x00050000;
+        	fp = 0x000001be;
+#endif 
+#if 0 /* 480p */
+        	dpll = 0x02010000;
+        	fp = 0x000000d2;
+#endif 
+	} else {
+#if 0 /*DBI_TPO_480x864*/
+		dpll = 0x00020000;
+		fp = 0x00000156; 
+#endif /* DBI_TPO_480x864 */ /* get from spec. */
+
+        	dpll = 0x00800000;
+	        fp = 0x000000c1;
+}
+
+	REG_WRITE(fp_reg, fp);
+	REG_WRITE(dpll_reg, dpll);
+	/* FIXME_MDFLD PO - change 500 to 1 after PO */
+	udelay(500);
+
+	dpll |= DPLL_VCO_ENABLE;
+	REG_WRITE(dpll_reg, dpll);
+	REG_READ(dpll_reg);
+
+	/* wait for DSI PLL to lock */
+	while ((timeout < 20000) && !(REG_READ(pipeconf_reg) & PIPECONF_DSIPLL_LOCK)) {
+		udelay(150);
+		timeout ++;
+	}
+
+	if (is_mipi)
+		goto mrst_crtc_mode_set_exit;
+
+	dev_dbg(dev->dev, "is_mipi = 0x%x \n", is_mipi);
+
+	REG_WRITE(pipeconf_reg, *pipeconf);
+	REG_READ(pipeconf_reg);
+
+	/* Wait for for the pipe enable to take effect. */
+//FIXME_JLIU7 HDMI	mrstWaitForPipeEnable(dev);
+
+	REG_WRITE(dspcntr_reg, *dspcntr);
+	psb_intel_wait_for_vblank(dev);
+
+mrst_crtc_mode_set_exit:
+
+	gma_power_end(dev);
+
+	return 0;
+}
diff --git a/drivers/staging/gma500/mdfld_msic.h b/drivers/staging/gma500/mdfld_msic.h
new file mode 100644
index 0000000..a7ad6547
--- /dev/null
+++ b/drivers/staging/gma500/mdfld_msic.h
@@ -0,0 +1,31 @@
+/*
+ * Copyright © 2010 Intel Corporation
+ *
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ *	Jim Liu <jim.liu@intel.com>
+ */
+
+#define MSIC_PCI_DEVICE_ID	0x831
+
+int msic_regsiter_driver(void);
+int msic_unregister_driver(void);
+extern void hpd_notify_um(void);
diff --git a/drivers/staging/gma500/mdfld_output.c b/drivers/staging/gma500/mdfld_output.c
new file mode 100644
index 0000000..b1fc765
--- /dev/null
+++ b/drivers/staging/gma500/mdfld_output.c
@@ -0,0 +1,135 @@
+/*
+ * Copyright (c)  2010 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicensen
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * Thomas Eaton <thomas.g.eaton@intel.com>
+ * Scott Rowe <scott.m.rowe@intel.com>
+*/
+
+#include <linux/init.h>
+#include "mdfld_dsi_dbi.h"
+#include "mdfld_dsi_dpi.h"
+#include "mdfld_dsi_output.h"
+#include "mdfld_output.h"
+
+#include "displays/tpo_cmd.h"
+#include "displays/tpo_vid.h"
+#include "displays/tmd_cmd.h"
+#include "displays/tmd_vid.h"
+#include "displays/pyr_cmd.h"
+#include "displays/pyr_vid.h"
+/* #include "displays/hdmi.h" */
+
+/* For now a single type per device is all we cope with */
+int mdfld_get_panel_type(struct drm_device *dev, int pipe)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	return dev_priv->panel_id;
+}
+
+int mdfld_panel_dpi(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	switch (dev_priv->panel_id) {
+	case TMD_VID:
+	case TPO_VID:
+	case PYR_VID:
+		return true;
+	case TMD_CMD:
+	case TPO_CMD:
+	case PYR_CMD:
+	default:
+		return false;
+	}
+}
+
+static void init_panel(struct drm_device *dev, int mipi_pipe, int p_type)
+{
+	struct panel_funcs *p_cmd_funcs;
+	struct panel_funcs *p_vid_funcs;
+
+	/* Oh boy ... FIXME */
+	p_cmd_funcs = kzalloc(sizeof(struct panel_funcs), GFP_KERNEL);
+	p_vid_funcs = kzalloc(sizeof(struct panel_funcs), GFP_KERNEL);
+
+	switch (p_type) {
+	case TPO_CMD:
+		tpo_cmd_init(dev, p_cmd_funcs);
+		mdfld_dsi_output_init(dev, mipi_pipe, NULL, p_cmd_funcs, NULL);
+		break;
+	case TPO_VID:
+		tpo_vid_init(dev, p_vid_funcs);
+		mdfld_dsi_output_init(dev, mipi_pipe, NULL, NULL, p_vid_funcs);
+		break;
+	case TMD_CMD:
+		/*tmd_cmd_init(dev, p_cmd_funcs); */
+		mdfld_dsi_output_init(dev, mipi_pipe, NULL, p_cmd_funcs, NULL);
+		break;
+	case TMD_VID:
+		tmd_vid_init(dev, p_vid_funcs);
+		mdfld_dsi_output_init(dev, mipi_pipe, NULL, NULL, p_vid_funcs);
+		break;
+	case PYR_CMD:
+		pyr_cmd_init(dev, p_cmd_funcs);
+		mdfld_dsi_output_init(dev, mipi_pipe, NULL, p_cmd_funcs, NULL);
+		break;
+	case PYR_VID:
+		/*pyr_vid_init(dev, p_vid_funcs); */
+		mdfld_dsi_output_init(dev, mipi_pipe, NULL, NULL, p_vid_funcs);
+		break;
+	case TPO:	/* TPO panel supports both cmd & vid interfaces */
+		tpo_cmd_init(dev, p_cmd_funcs);
+		tpo_vid_init(dev, p_vid_funcs);
+		mdfld_dsi_output_init(dev, mipi_pipe, NULL, p_cmd_funcs,
+				      p_vid_funcs);
+		break;
+	case TMD:
+		break;
+	case PYR:
+		break;
+#if 0
+	case HDMI:
+		dev_dbg(dev->dev, "Initializing HDMI");
+		mdfld_hdmi_init(dev, &dev_priv->mode_dev);
+		break;
+#endif
+	default:
+		dev_err(dev->dev, "Unsupported interface %d", p_type);
+		break;
+	}
+}
+
+void mdfld_output_init(struct drm_device *dev)
+{
+	int type;
+
+	/* MIPI panel 1 */
+	type = mdfld_get_panel_type(dev, 0);
+	dev_info(dev->dev, "panel 1: type is %d\n", type);
+	init_panel(dev, 0, type);
+
+	/* MIPI panel 2 */
+	type = mdfld_get_panel_type(dev, 2);
+	dev_info(dev->dev, "panel 2: type is %d\n", type);
+	init_panel(dev, 2, type);
+}
diff --git a/drivers/staging/gma500/mdfld_output.h b/drivers/staging/gma500/mdfld_output.h
new file mode 100644
index 0000000..36f43e1
--- /dev/null
+++ b/drivers/staging/gma500/mdfld_output.h
@@ -0,0 +1,77 @@
+/*
+ * Copyright (c)  2010 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicensen
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * Thomas Eaton <thomas.g.eaton@intel.com>
+ * Scott Rowe <scott.m.rowe@intel.com>
+*/
+
+#ifndef MDFLD_OUTPUT_H
+#define MDFLD_OUTPUT_H
+
+#include "psb_drv.h"
+
+/* Panel types */
+enum {
+	TPO_CMD,
+	TPO_VID,
+	TMD_CMD,
+	TMD_VID,
+	PYR_CMD,
+	PYR_VID,
+	TPO,
+	TMD,
+	PYR,
+	HDMI,
+	GCT_DETECT
+};
+
+/* Junk that belongs elsewhere */
+#define TPO_PANEL_WIDTH		84
+#define TPO_PANEL_HEIGHT	46
+#define TMD_PANEL_WIDTH		39
+#define TMD_PANEL_HEIGHT	71
+#define PYR_PANEL_WIDTH		53
+#define PYR_PANEL_HEIGHT	95
+
+/* Panel interface */
+struct panel_info {
+	u32 width_mm;
+	u32 height_mm;
+};
+
+struct mdfld_dsi_dbi_output;
+
+struct panel_funcs {
+	const struct drm_encoder_funcs *encoder_funcs;
+	const struct drm_encoder_helper_funcs *encoder_helper_funcs;
+	struct drm_display_mode *(*get_config_mode) (struct drm_device *);
+	void (*update_fb) (struct mdfld_dsi_dbi_output *, int);
+	int (*get_panel_info) (struct drm_device *, int, struct panel_info *);
+};
+
+void mdfld_output_init(struct drm_device *dev);
+int mdfld_panel_dpi(struct drm_device *dev);
+int mdfld_get_panel_type(struct drm_device *dev, int pipe);
+void mdfld_disable_crtc (struct drm_device *dev, int pipe);
+
+#endif
diff --git a/drivers/staging/gma500/mdfld_pyr_cmd.c b/drivers/staging/gma500/mdfld_pyr_cmd.c
new file mode 100644
index 0000000..0d89384
--- /dev/null
+++ b/drivers/staging/gma500/mdfld_pyr_cmd.c
@@ -0,0 +1,575 @@
+/*
+ * Copyright (c)  2010 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicensen
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * Thomas Eaton <thomas.g.eaton@intel.com>
+ * Scott Rowe <scott.m.rowe@intel.com>
+*/
+
+#include "mdfld_dsi_dbi.h"
+#include "mdfld_dsi_dpi.h"
+#include "mdfld_dsi_output.h"
+#include "mdfld_output.h"
+
+#include "mdfld_dsi_pkg_sender.h"
+
+#include "displays/pyr_cmd.h"
+
+static struct drm_display_mode *pyr_cmd_get_config_mode(struct drm_device *dev)
+{
+	struct drm_display_mode *mode;
+
+	mode = kzalloc(sizeof(*mode), GFP_KERNEL);
+	if (!mode) {
+		dev_err(dev->dev, "Out of memory\n");
+		return NULL;
+	}
+
+	dev_dbg(dev->dev, "hdisplay is %d\n", mode->hdisplay);
+	dev_dbg(dev->dev, "vdisplay is %d\n", mode->vdisplay);
+	dev_dbg(dev->dev, "HSS is %d\n", mode->hsync_start);
+	dev_dbg(dev->dev, "HSE is %d\n", mode->hsync_end);
+	dev_dbg(dev->dev, "htotal is %d\n", mode->htotal);
+	dev_dbg(dev->dev, "VSS is %d\n", mode->vsync_start);
+	dev_dbg(dev->dev, "VSE is %d\n", mode->vsync_end);
+	dev_dbg(dev->dev, "vtotal is %d\n", mode->vtotal);
+	dev_dbg(dev->dev, "clock is %d\n", mode->clock);
+
+	mode->hdisplay = 480;
+	mode->vdisplay = 864;
+	mode->hsync_start = 487;
+	mode->hsync_end = 490;
+	mode->htotal = 499;
+	mode->vsync_start = 874;
+	mode->vsync_end = 878;
+	mode->vtotal = 886;
+	mode->clock = 25777;
+
+	drm_mode_set_name(mode);
+	drm_mode_set_crtcinfo(mode, 0);
+
+	mode->type |= DRM_MODE_TYPE_PREFERRED;
+
+	return mode;
+}
+
+static bool pyr_dsi_dbi_mode_fixup(struct drm_encoder *encoder,
+				struct drm_display_mode *mode,
+				struct drm_display_mode *adjusted_mode)
+{
+	struct drm_device *dev = encoder->dev;
+	struct drm_display_mode *fixed_mode = pyr_cmd_get_config_mode(dev);
+
+	if (fixed_mode) {
+		adjusted_mode->hdisplay = fixed_mode->hdisplay;
+		adjusted_mode->hsync_start = fixed_mode->hsync_start;
+		adjusted_mode->hsync_end = fixed_mode->hsync_end;
+		adjusted_mode->htotal = fixed_mode->htotal;
+		adjusted_mode->vdisplay = fixed_mode->vdisplay;
+		adjusted_mode->vsync_start = fixed_mode->vsync_start;
+		adjusted_mode->vsync_end = fixed_mode->vsync_end;
+		adjusted_mode->vtotal = fixed_mode->vtotal;
+		adjusted_mode->clock = fixed_mode->clock;
+		drm_mode_set_crtcinfo(adjusted_mode, CRTC_INTERLACE_HALVE_V);
+		kfree(fixed_mode);
+	}
+	return true;
+}
+
+static void pyr_dsi_dbi_set_power(struct drm_encoder *encoder, bool on)
+{
+	int ret = 0;
+	struct mdfld_dsi_encoder *dsi_encoder = MDFLD_DSI_ENCODER(encoder);
+	struct mdfld_dsi_dbi_output *dbi_output =
+				MDFLD_DSI_DBI_OUTPUT(dsi_encoder);
+	struct drm_device *dev = encoder->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	u32 reg_offset = 0;
+	int pipe = (dbi_output->channel_num == 0) ? 0 : 2;
+
+	dev_dbg(dev->dev, "pipe %d : %s, panel on: %s\n", pipe,
+			on ? "On" : "Off",
+			dbi_output->dbi_panel_on ? "True" : "False");
+
+	if (pipe == 2) {
+		if (on)
+			dev_priv->dual_mipi = true;
+		else
+			dev_priv->dual_mipi = false;
+
+		reg_offset = MIPIC_REG_OFFSET;
+	} else {
+		if (!on)
+			dev_priv->dual_mipi = false;
+	}
+
+	if (!gma_power_begin(dev, true)) {
+		dev_err(dev->dev, "hw begin failed\n");
+		return;
+	}
+
+
+	if (on) {
+		if (dbi_output->dbi_panel_on)
+			goto out_err;
+
+		ret = mdfld_dsi_dbi_update_power(dbi_output, DRM_MODE_DPMS_ON);
+		if (ret) {
+			dev_err(dev->dev, "power on error\n");
+			goto out_err;
+		}
+
+		dbi_output->dbi_panel_on = true;
+
+		if (pipe == 2) {
+			dev_priv->dbi_panel_on2 = true;
+		} else {
+			dev_priv->dbi_panel_on = true;
+			mdfld_enable_te(dev, 0);
+		}
+	} else {
+		if (!dbi_output->dbi_panel_on && !dbi_output->first_boot)
+			goto out_err;
+
+		dbi_output->dbi_panel_on = false;
+		dbi_output->first_boot = false;
+
+		if (pipe == 2) {
+			dev_priv->dbi_panel_on2 = false;
+			mdfld_disable_te(dev, 2);
+		} else {
+			dev_priv->dbi_panel_on = false;
+			mdfld_disable_te(dev, 0);
+
+			if (dev_priv->dbi_panel_on2)
+				mdfld_enable_te(dev, 2);
+		}
+
+		ret = mdfld_dsi_dbi_update_power(dbi_output, DRM_MODE_DPMS_OFF);
+		if (ret) {
+			dev_err(dev->dev, "power on error\n");
+			goto out_err;
+		}
+	}
+
+out_err:
+	gma_power_end(dev);
+
+	if (ret)
+		dev_err(dev->dev, "failed\n");
+}
+
+static void pyr_dsi_controller_dbi_init(struct mdfld_dsi_config *dsi_config,
+								int pipe)
+{
+	struct drm_device *dev = dsi_config->dev;
+	u32 reg_offset = pipe ? MIPIC_REG_OFFSET : 0;
+	int lane_count = dsi_config->lane_count;
+	u32 val = 0;
+
+	dev_dbg(dev->dev, "Init DBI interface on pipe %d...\n", pipe);
+
+	/* In-ready device */
+	REG_WRITE((MIPIA_DEVICE_READY_REG + reg_offset), 0x00000000);
+
+	/* Init dsi adapter before kicking off */
+	REG_WRITE((MIPIA_CONTROL_REG + reg_offset), 0x00000018);
+
+	/* TODO: figure out how to setup these registers */
+	REG_WRITE((MIPIA_DPHY_PARAM_REG + reg_offset), 0x150c600F);
+	REG_WRITE((MIPIA_CLK_LANE_SWITCH_TIME_CNT_REG + reg_offset),
+								0x000a0014);
+	REG_WRITE((MIPIA_DBI_BW_CTRL_REG + reg_offset), 0x00000400);
+	REG_WRITE((MIPIA_HS_LS_DBI_ENABLE_REG + reg_offset), 0x00000000);
+
+	/* Enable all interrupts */
+	REG_WRITE((MIPIA_INTR_EN_REG + reg_offset), 0xffffffff);
+	/* Max value: 20 clock cycles of txclkesc */
+	REG_WRITE((MIPIA_TURN_AROUND_TIMEOUT_REG + reg_offset), 0x0000001f);
+	/* Min 21 txclkesc, max: ffffh */
+	REG_WRITE((MIPIA_DEVICE_RESET_TIMER_REG + reg_offset), 0x0000ffff);
+	/* Min: 7d0 max: 4e20 */
+	REG_WRITE((MIPIA_INIT_COUNT_REG + reg_offset), 0x00000fa0);
+
+	/* Set up func_prg */
+	val |= lane_count;
+	val |= (dsi_config->channel_num << DSI_DBI_VIRT_CHANNEL_OFFSET);
+	val |= DSI_DBI_COLOR_FORMAT_OPTION2;
+	REG_WRITE((MIPIA_DSI_FUNC_PRG_REG + reg_offset), val);
+
+	REG_WRITE((MIPIA_HS_TX_TIMEOUT_REG + reg_offset), 0x3fffff);
+	REG_WRITE((MIPIA_LP_RX_TIMEOUT_REG + reg_offset), 0xffff);
+
+	/* De-assert dbi_stall when half of DBI FIFO is empty */
+	/* REG_WRITE((MIPIA_DBI_FIFO_THROTTLE_REG + reg_offset), 0x00000000); */
+
+	REG_WRITE((MIPIA_HIGH_LOW_SWITCH_COUNT_REG + reg_offset), 0x46);
+	REG_WRITE((MIPIA_EOT_DISABLE_REG + reg_offset), 0x00000002);
+	REG_WRITE((MIPIA_LP_BYTECLK_REG + reg_offset), 0x00000004);
+	REG_WRITE((MIPIA_DEVICE_READY_REG + reg_offset), 0x00000001);
+}
+
+static void pyr_dsi_dbi_mode_set(struct drm_encoder *encoder,
+				struct drm_display_mode *mode,
+				struct drm_display_mode *adjusted_mode)
+{
+	int ret = 0;
+	struct drm_device *dev = encoder->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mdfld_dsi_encoder *dsi_encoder = MDFLD_DSI_ENCODER(encoder);
+	struct mdfld_dsi_dbi_output *dsi_output =
+					MDFLD_DSI_DBI_OUTPUT(dsi_encoder);
+	struct mdfld_dsi_config *dsi_config =
+				mdfld_dsi_encoder_get_config(dsi_encoder);
+	struct mdfld_dsi_connector *dsi_connector = dsi_config->connector;
+	int pipe = dsi_connector->pipe;
+	u8 param = 0;
+
+	/* Regs */
+	u32 mipi_reg = MIPI;
+	u32 dspcntr_reg = DSPACNTR;
+	u32 pipeconf_reg = PIPEACONF;
+	u32 reg_offset = 0;
+
+	/* Values */
+	u32 dspcntr_val = dev_priv->dspcntr;
+	u32 pipeconf_val = dev_priv->pipeconf;
+	u32 h_active_area = mode->hdisplay;
+	u32 v_active_area = mode->vdisplay;
+	u32 mipi_val = (PASS_FROM_SPHY_TO_AFE | SEL_FLOPPED_HSTX |
+							TE_TRIGGER_GPIO_PIN);
+
+	dev_dbg(dev->dev, "mipi_val =0x%x\n", mipi_val);
+
+	dev_dbg(dev->dev, "type %s\n", (pipe == 2) ? "MIPI2" : "MIPI");
+	dev_dbg(dev->dev, "h %d v %d\n", mode->hdisplay, mode->vdisplay);
+
+	if (pipe == 2) {
+		mipi_reg = MIPI_C;
+		dspcntr_reg = DSPCCNTR;
+		pipeconf_reg = PIPECCONF;
+
+		reg_offset = MIPIC_REG_OFFSET;
+
+		dspcntr_val = dev_priv->dspcntr2;
+		pipeconf_val = dev_priv->pipeconf2;
+	} else {
+		mipi_val |= 0x2; /* Two lanes for port A and C respectively */
+	}
+
+	if (!gma_power_begin(dev, true)) {
+		dev_err(dev->dev, "hw begin failed\n");
+		return;
+	}
+
+	/* Set up pipe related registers */
+	REG_WRITE(mipi_reg, mipi_val);
+	REG_READ(mipi_reg);
+
+	pyr_dsi_controller_dbi_init(dsi_config, pipe);
+
+	msleep(20);
+
+	REG_WRITE(dspcntr_reg, dspcntr_val);
+	REG_READ(dspcntr_reg);
+
+	/* 20ms delay before sending exit_sleep_mode */
+	msleep(20);
+
+	/* Send exit_sleep_mode DCS */
+	ret = mdfld_dsi_dbi_send_dcs(dsi_output, exit_sleep_mode, NULL,
+						0, CMD_DATA_SRC_SYSTEM_MEM);
+	if (ret) {
+		dev_err(dev->dev, "sent exit_sleep_mode faild\n");
+		goto out_err;
+	}
+
+	/*send set_tear_on DCS*/
+	ret = mdfld_dsi_dbi_send_dcs(dsi_output, set_tear_on,
+					&param, 1, CMD_DATA_SRC_SYSTEM_MEM);
+	if (ret) {
+		dev_err(dev->dev, "%s - sent set_tear_on faild\n", __func__);
+		goto out_err;
+	}
+
+	/* Do some init stuff */
+	mdfld_dsi_brightness_init(dsi_config, pipe);
+	mdfld_dsi_gen_fifo_ready(dev, (MIPIA_GEN_FIFO_STAT_REG + reg_offset),
+				HS_CTRL_FIFO_EMPTY | HS_DATA_FIFO_EMPTY);
+
+	REG_WRITE(pipeconf_reg, pipeconf_val | PIPEACONF_DSR);
+	REG_READ(pipeconf_reg);
+
+	/* TODO: this looks ugly, try to move it to CRTC mode setting */
+	if (pipe == 2)
+		dev_priv->pipeconf2 |= PIPEACONF_DSR;
+	else
+		dev_priv->pipeconf |= PIPEACONF_DSR;
+
+	dev_dbg(dev->dev, "pipeconf %x\n",  REG_READ(pipeconf_reg));
+
+	ret = mdfld_dsi_dbi_update_area(dsi_output, 0, 0,
+				h_active_area - 1, v_active_area - 1);
+	if (ret) {
+		dev_err(dev->dev, "update area failed\n");
+		goto out_err;
+	}
+
+out_err:
+	gma_power_end(dev);
+
+	if (ret)
+		dev_err(dev->dev, "mode set failed\n");
+	else
+		dev_dbg(dev->dev, "mode set done successfully\n");
+}
+
+static void pyr_dsi_dbi_prepare(struct drm_encoder *encoder)
+{
+	struct mdfld_dsi_encoder *dsi_encoder = MDFLD_DSI_ENCODER(encoder);
+	struct mdfld_dsi_dbi_output *dbi_output =
+					MDFLD_DSI_DBI_OUTPUT(dsi_encoder);
+
+	dbi_output->mode_flags |= MODE_SETTING_IN_ENCODER;
+	dbi_output->mode_flags &= ~MODE_SETTING_ENCODER_DONE;
+
+	pyr_dsi_dbi_set_power(encoder, false);
+}
+
+static void pyr_dsi_dbi_commit(struct drm_encoder *encoder)
+{
+	struct mdfld_dsi_encoder *dsi_encoder = MDFLD_DSI_ENCODER(encoder);
+	struct mdfld_dsi_dbi_output *dbi_output =
+					MDFLD_DSI_DBI_OUTPUT(dsi_encoder);
+	struct drm_device *dev = dbi_output->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_drm_dpu_rect rect;
+
+	pyr_dsi_dbi_set_power(encoder, true);
+
+	dbi_output->mode_flags &= ~MODE_SETTING_IN_ENCODER;
+
+	rect.x = rect.y = 0;
+	rect.width = 864;
+	rect.height = 480;
+
+	if (dbi_output->channel_num == 1) {
+		dev_priv->dsr_fb_update |= MDFLD_DSR_2D_3D_2;
+#ifdef CONFIG_MDFLD_DSI_DPU
+		/* If DPU enabled report a fullscreen damage */
+		mdfld_dbi_dpu_report_damage(dev, MDFLD_PLANEC, &rect);
+#endif
+	} else {
+		dev_priv->dsr_fb_update |= MDFLD_DSR_2D_3D_0;
+
+#ifdef CONFIG_MDFLD_DSI_DPU
+		mdfld_dbi_dpu_report_damage(dev, MDFLD_PLANEA, &rect);
+#endif
+	}
+	dbi_output->mode_flags |= MODE_SETTING_ENCODER_DONE;
+}
+
+static void pyr_dsi_dbi_dpms(struct drm_encoder *encoder, int mode)
+{
+	struct mdfld_dsi_encoder *dsi_encoder = MDFLD_DSI_ENCODER(encoder);
+	struct mdfld_dsi_dbi_output *dbi_output =
+					MDFLD_DSI_DBI_OUTPUT(dsi_encoder);
+	struct drm_device *dev = dbi_output->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	static bool bdispoff;
+
+	dev_dbg(dev->dev, "%s\n",  (mode == DRM_MODE_DPMS_ON ? "on" : "off"));
+
+	if (mode == DRM_MODE_DPMS_ON) {
+		if (/*gbgfxsuspended && */bdispoff) {
+			bdispoff = false;
+			dev_priv->dispstatus = true;
+			/*gbgfxsuspended = false;
+			*/
+			mdfld_dsi_dbi_exit_dsr(dev, MDFLD_DSR_2D_3D, 0, 0);
+		}
+		pyr_dsi_dbi_set_power(encoder, true);
+	} else {
+		bdispoff = true;
+		dev_priv->dispstatus = false;
+		pyr_dsi_dbi_set_power(encoder, false);
+	}
+}
+
+/*
+ * Update the DBI MIPI Panel Frame Buffer.
+ */
+static void pyr_dsi_dbi_update_fb(struct mdfld_dsi_dbi_output *dbi_output,
+								int pipe)
+{
+	struct mdfld_dsi_pkg_sender *sender =
+		mdfld_dsi_encoder_get_pkg_sender(&dbi_output->base);
+	struct drm_device *dev = dbi_output->dev;
+	struct drm_crtc *crtc = dbi_output->base.base.crtc;
+	struct psb_intel_crtc *psb_crtc = (crtc) ?
+				to_psb_intel_crtc(crtc) : NULL;
+
+	u32 dpll_reg = MRST_DPLL_A;
+	u32 dspcntr_reg = DSPACNTR;
+	u32 pipeconf_reg = PIPEACONF;
+	u32 dsplinoff_reg = DSPALINOFF;
+	u32 dspsurf_reg = DSPASURF;
+	u32 hs_gen_ctrl_reg = HS_GEN_CTRL_REG;
+	u32 gen_fifo_stat_reg = GEN_FIFO_STAT_REG;
+	u32 reg_offset = 0;
+
+	u32 intr_status;
+	u32 fifo_stat_reg_val;
+	u32 dpll_reg_val;
+	u32 dspcntr_reg_val;
+	u32 pipeconf_reg_val;
+
+	/* If mode setting on-going, back off */
+	if ((dbi_output->mode_flags & MODE_SETTING_ON_GOING) ||
+		(psb_crtc && psb_crtc->mode_flags & MODE_SETTING_ON_GOING) ||
+		!(dbi_output->mode_flags & MODE_SETTING_ENCODER_DONE))
+		return;
+
+	/*
+	 * Look for errors here.  In particular we're checking for whatever
+	 * error status might have appeared during the last frame transmit
+	 * (memory write).
+	 *
+	 * Normally, the bits we're testing here would be set infrequently,
+	 * if at all.  However, one panel (at least) returns at least one
+	 * error bit on most frames.  So we've disabled the kernel message
+	 * for now.
+	 *
+	 * Still clear whatever error bits are set, except don't clear the
+	 * ones that would make the Penwell DSI controller reset if we
+	 * cleared them.
+	 */
+	intr_status = REG_READ(INTR_STAT_REG);
+	if ((intr_status & 0x26FFFFFF) != 0) {
+		/* dev_err(dev->dev, "DSI status: 0x%08X\n", intr_status); */
+		intr_status &= 0x26F3FFFF;
+		REG_WRITE(INTR_STAT_REG, intr_status);
+	}
+
+	if (pipe == 2) {
+		dspcntr_reg = DSPCCNTR;
+		pipeconf_reg = PIPECCONF;
+		dsplinoff_reg = DSPCLINOFF;
+		dspsurf_reg = DSPCSURF;
+
+		hs_gen_ctrl_reg = HS_GEN_CTRL_REG + MIPIC_REG_OFFSET;
+		gen_fifo_stat_reg = GEN_FIFO_STAT_REG + MIPIC_REG_OFFSET,
+
+		reg_offset = MIPIC_REG_OFFSET;
+	}
+
+	if (!gma_power_begin(dev, true)) {
+		dev_err(dev->dev, "hw begin failed\n");
+		return;
+	}
+
+	fifo_stat_reg_val = REG_READ(MIPIA_GEN_FIFO_STAT_REG + reg_offset);
+	dpll_reg_val = REG_READ(dpll_reg);
+	dspcntr_reg_val = REG_READ(dspcntr_reg);
+	pipeconf_reg_val = REG_READ(pipeconf_reg);
+
+	if (!(fifo_stat_reg_val & (1 << 27)) ||
+		(dpll_reg_val & DPLL_VCO_ENABLE) ||
+		!(dspcntr_reg_val & DISPLAY_PLANE_ENABLE) ||
+		!(pipeconf_reg_val & DISPLAY_PLANE_ENABLE)) {
+		goto update_fb_out0;
+	}
+
+	/* Refresh plane changes */
+	REG_WRITE(dsplinoff_reg, REG_READ(dsplinoff_reg));
+	REG_WRITE(dspsurf_reg, REG_READ(dspsurf_reg));
+	REG_READ(dspsurf_reg);
+
+	mdfld_dsi_send_dcs(sender,
+			   write_mem_start,
+			   NULL,
+			   0,
+			   CMD_DATA_SRC_PIPE,
+			   MDFLD_DSI_SEND_PACKAGE);
+
+	/*
+	 * The idea here is to transmit a Generic Read command after the
+	 * Write Memory Start/Continue commands finish.  This asks for
+	 * the panel to return an "ACK No Errors," or (if it has errors
+	 * to report) an Error Report.  This allows us to monitor the
+	 * panel's perception of the health of the DSI.
+	 */
+	mdfld_dsi_gen_fifo_ready(dev, gen_fifo_stat_reg,
+				HS_CTRL_FIFO_EMPTY | HS_DATA_FIFO_EMPTY);
+	REG_WRITE(hs_gen_ctrl_reg, (1 << WORD_COUNTS_POS) | GEN_READ_0);
+
+	dbi_output->dsr_fb_update_done = true;
+update_fb_out0:
+	gma_power_end(dev);
+}
+
+/*
+ * TODO: will be removed later, should work out display interfaces for power
+ */
+void pyr_dsi_adapter_init(struct mdfld_dsi_config *dsi_config, int pipe)
+{
+	if (!dsi_config || (pipe != 0 && pipe != 2)) {
+		WARN_ON(1);
+		return;
+	}
+	pyr_dsi_controller_dbi_init(dsi_config, pipe);
+}
+
+static int pyr_cmd_get_panel_info(struct drm_device *dev, int pipe,
+							struct panel_info *pi)
+{
+	if (!dev || !pi)
+		return -EINVAL;
+
+	pi->width_mm = PYR_PANEL_WIDTH;
+	pi->height_mm = PYR_PANEL_HEIGHT;
+
+	return 0;
+}
+
+/* PYR DBI encoder helper funcs */
+static const struct drm_encoder_helper_funcs pyr_dsi_dbi_helper_funcs = {
+	.dpms = pyr_dsi_dbi_dpms,
+	.mode_fixup = pyr_dsi_dbi_mode_fixup,
+	.prepare = pyr_dsi_dbi_prepare,
+	.mode_set = pyr_dsi_dbi_mode_set,
+	.commit = pyr_dsi_dbi_commit,
+};
+
+/* PYR DBI encoder funcs */
+static const struct drm_encoder_funcs mdfld_dsi_dbi_encoder_funcs = {
+	.destroy = drm_encoder_cleanup,
+};
+
+void pyr_cmd_init(struct drm_device *dev, struct panel_funcs *p_funcs)
+{
+	p_funcs->encoder_funcs = &mdfld_dsi_dbi_encoder_funcs;
+	p_funcs->encoder_helper_funcs = &pyr_dsi_dbi_helper_funcs;
+	p_funcs->get_config_mode = &pyr_cmd_get_config_mode;
+	p_funcs->update_fb = pyr_dsi_dbi_update_fb;
+	p_funcs->get_panel_info = pyr_cmd_get_panel_info;
+}
diff --git a/drivers/staging/gma500/mdfld_tmd_vid.c b/drivers/staging/gma500/mdfld_tmd_vid.c
new file mode 100644
index 0000000..b29c905
--- /dev/null
+++ b/drivers/staging/gma500/mdfld_tmd_vid.c
@@ -0,0 +1,144 @@
+/*
+ * Copyright © 2010 Intel Corporation
+ *
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * Jim Liu <jim.liu@intel.com>
+ * Jackie Li<yaodong.li@intel.com>
+ * Gideon Eaton <eaton.
+ * Scott Rowe <scott.m.rowe@intel.com>
+ */
+
+#include "mdfld_dsi_dbi.h"
+#include "mdfld_dsi_dpi.h"
+#include "mdfld_dsi_output.h"
+#include "mdfld_output.h"
+
+#include "mdfld_dsi_pkg_sender.h"
+
+#include "displays/tmd_vid.h"
+
+/* FIXME: static ? */
+struct drm_display_mode *tmd_vid_get_config_mode(struct drm_device *dev)
+{
+	struct drm_display_mode *mode;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mrst_timing_info *ti = &dev_priv->gct_data.DTD;
+	bool use_gct = false; /*Disable GCT for now*/
+
+	mode = kzalloc(sizeof(*mode), GFP_KERNEL);
+	if (!mode) {
+		dev_err(dev->dev, "Out of memory\n");
+		return NULL;
+	}
+
+	if (use_gct) {
+		dev_dbg(dev->dev, "gct find MIPI panel.\n");
+
+		mode->hdisplay = (ti->hactive_hi << 8) | ti->hactive_lo;
+		mode->vdisplay = (ti->vactive_hi << 8) | ti->vactive_lo;
+		mode->hsync_start = mode->hdisplay +
+				((ti->hsync_offset_hi << 8) |
+				ti->hsync_offset_lo);
+		mode->hsync_end = mode->hsync_start +
+				((ti->hsync_pulse_width_hi << 8) |
+				ti->hsync_pulse_width_lo);
+		mode->htotal = mode->hdisplay + ((ti->hblank_hi << 8) |
+								ti->hblank_lo);
+		mode->vsync_start = \
+			mode->vdisplay + ((ti->vsync_offset_hi << 8) |
+						ti->vsync_offset_lo);
+		mode->vsync_end = \
+			mode->vsync_start + ((ti->vsync_pulse_width_hi << 8) | \
+						ti->vsync_pulse_width_lo);
+		mode->vtotal = mode->vdisplay +
+				((ti->vblank_hi << 8) | ti->vblank_lo);
+		mode->clock = ti->pixel_clock * 10;
+
+		dev_dbg(dev->dev, "hdisplay is %d\n", mode->hdisplay);
+		dev_dbg(dev->dev, "vdisplay is %d\n", mode->vdisplay);
+		dev_dbg(dev->dev, "HSS is %d\n", mode->hsync_start);
+		dev_dbg(dev->dev, "HSE is %d\n", mode->hsync_end);
+		dev_dbg(dev->dev, "htotal is %d\n", mode->htotal);
+		dev_dbg(dev->dev, "VSS is %d\n", mode->vsync_start);
+		dev_dbg(dev->dev, "VSE is %d\n", mode->vsync_end);
+		dev_dbg(dev->dev, "vtotal is %d\n", mode->vtotal);
+		dev_dbg(dev->dev, "clock is %d\n", mode->clock);
+	} else {
+		mode->hdisplay = 480;
+		mode->vdisplay = 854;
+		mode->hsync_start = 487;
+		mode->hsync_end = 490;
+		mode->htotal = 499;
+		mode->vsync_start = 861;
+		mode->vsync_end = 865;
+		mode->vtotal = 873;
+		mode->clock = 33264;
+	}
+	drm_mode_set_name(mode);
+	drm_mode_set_crtcinfo(mode, 0);
+
+	mode->type |= DRM_MODE_TYPE_PREFERRED;
+
+	return mode;
+}
+
+static int tmd_vid_get_panel_info(struct drm_device *dev,
+				int pipe,
+				struct panel_info *pi)
+{
+	if (!dev || !pi)
+		return -EINVAL;
+
+	pi->width_mm = TMD_PANEL_WIDTH;
+	pi->height_mm = TMD_PANEL_HEIGHT;
+
+	return 0;
+}
+
+/* TMD DPI encoder helper funcs */
+static const struct drm_encoder_helper_funcs
+					mdfld_tpo_dpi_encoder_helper_funcs = {
+	.dpms = mdfld_dsi_dpi_dpms,
+	.mode_fixup = mdfld_dsi_dpi_mode_fixup,
+	.prepare = mdfld_dsi_dpi_prepare,
+	.mode_set = mdfld_dsi_dpi_mode_set,
+	.commit = mdfld_dsi_dpi_commit,
+};
+
+/* TMD DPI encoder funcs */
+static const struct drm_encoder_funcs mdfld_tpo_dpi_encoder_funcs = {
+	.destroy = drm_encoder_cleanup,
+};
+
+void tmd_vid_init(struct drm_device *dev, struct panel_funcs *p_funcs)
+{
+	if (!dev || !p_funcs) {
+		dev_err(dev->dev, "Invalid parameters\n");
+		return;
+	}
+
+	p_funcs->encoder_funcs = &mdfld_tpo_dpi_encoder_funcs;
+	p_funcs->encoder_helper_funcs = &mdfld_tpo_dpi_encoder_helper_funcs;
+	p_funcs->get_config_mode = &tmd_vid_get_config_mode;
+	p_funcs->update_fb = NULL;
+	p_funcs->get_panel_info = tmd_vid_get_panel_info;
+}
diff --git a/drivers/staging/gma500/mdfld_tpo_cmd.c b/drivers/staging/gma500/mdfld_tpo_cmd.c
new file mode 100644
index 0000000..d2e1818
--- /dev/null
+++ b/drivers/staging/gma500/mdfld_tpo_cmd.c
@@ -0,0 +1,495 @@
+/*
+ * Copyright (c)  2010 Intel Corporation
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicensen
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * Thomas Eaton <thomas.g.eaton@intel.com>
+ * Scott Rowe <scott.m.rowe@intel.com>
+ */
+
+#include "mdfld_dsi_dbi.h"
+#include "mdfld_dsi_dpi.h"
+#include "mdfld_dsi_output.h"
+#include "mdfld_output.h"
+
+#include "mdfld_dsi_pkg_sender.h"
+
+#include "displays/tpo_cmd.h"
+
+static struct drm_display_mode *tpo_cmd_get_config_mode(struct drm_device *dev)
+{
+	struct drm_display_mode *mode;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mrst_timing_info *ti = &dev_priv->gct_data.DTD;
+	bool use_gct = false;
+
+	mode = kzalloc(sizeof(*mode), GFP_KERNEL);
+	if (!mode)
+		return NULL;
+
+	if (use_gct) {
+		dev_dbg(dev->dev, "gct find MIPI panel.\n");
+
+		mode->hdisplay = (ti->hactive_hi << 8) | ti->hactive_lo;
+		mode->vdisplay = (ti->vactive_hi << 8) | ti->vactive_lo;
+		mode->hsync_start = mode->hdisplay + \
+				((ti->hsync_offset_hi << 8) | \
+				ti->hsync_offset_lo);
+		mode->hsync_end = mode->hsync_start + \
+				((ti->hsync_pulse_width_hi << 8) | \
+				ti->hsync_pulse_width_lo);
+		mode->htotal = mode->hdisplay + ((ti->hblank_hi << 8) | \
+								ti->hblank_lo);
+		mode->vsync_start = \
+			mode->vdisplay + ((ti->vsync_offset_hi << 8) | \
+						ti->vsync_offset_lo);
+		mode->vsync_end = \
+			mode->vsync_start + ((ti->vsync_pulse_width_hi << 8) | \
+						ti->vsync_pulse_width_lo);
+		mode->vtotal = mode->vdisplay + \
+				((ti->vblank_hi << 8) | ti->vblank_lo);
+		mode->clock = ti->pixel_clock * 10;
+
+		dev_dbg(dev->dev, "hdisplay is %d\n", mode->hdisplay);
+		dev_dbg(dev->dev, "vdisplay is %d\n", mode->vdisplay);
+		dev_dbg(dev->dev, "HSS is %d\n", mode->hsync_start);
+		dev_dbg(dev->dev, "HSE is %d\n", mode->hsync_end);
+		dev_dbg(dev->dev, "htotal is %d\n", mode->htotal);
+		dev_dbg(dev->dev, "VSS is %d\n", mode->vsync_start);
+		dev_dbg(dev->dev, "VSE is %d\n", mode->vsync_end);
+		dev_dbg(dev->dev, "vtotal is %d\n", mode->vtotal);
+		dev_dbg(dev->dev, "clock is %d\n", mode->clock);
+	} else {
+		mode->hdisplay = 864;
+		mode->vdisplay = 480;
+		mode->hsync_start = 872;
+		mode->hsync_end = 876;
+		mode->htotal = 884;
+		mode->vsync_start = 482;
+		mode->vsync_end = 494;
+		mode->vtotal = 486;
+		mode->clock = 25777;
+	}
+
+	drm_mode_set_name(mode);
+	drm_mode_set_crtcinfo(mode, 0);
+
+	mode->type |= DRM_MODE_TYPE_PREFERRED;
+
+	return mode;
+}
+
+static bool mdfld_dsi_dbi_mode_fixup(struct drm_encoder *encoder,
+				     struct drm_display_mode *mode,
+				     struct drm_display_mode *adjusted_mode)
+{
+	struct drm_device *dev = encoder->dev;
+	struct drm_display_mode *fixed_mode = tpo_cmd_get_config_mode(dev);
+
+	if (fixed_mode) {
+		adjusted_mode->hdisplay = fixed_mode->hdisplay;
+		adjusted_mode->hsync_start = fixed_mode->hsync_start;
+		adjusted_mode->hsync_end = fixed_mode->hsync_end;
+		adjusted_mode->htotal = fixed_mode->htotal;
+		adjusted_mode->vdisplay = fixed_mode->vdisplay;
+		adjusted_mode->vsync_start = fixed_mode->vsync_start;
+		adjusted_mode->vsync_end = fixed_mode->vsync_end;
+		adjusted_mode->vtotal = fixed_mode->vtotal;
+		adjusted_mode->clock = fixed_mode->clock;
+		drm_mode_set_crtcinfo(adjusted_mode, CRTC_INTERLACE_HALVE_V);
+		kfree(fixed_mode);
+	}
+	return true;
+}
+
+static void mdfld_dsi_dbi_set_power(struct drm_encoder *encoder, bool on)
+{
+	int ret = 0;
+	struct mdfld_dsi_encoder *dsi_encoder = MDFLD_DSI_ENCODER(encoder);
+	struct mdfld_dsi_dbi_output *dbi_output =
+				MDFLD_DSI_DBI_OUTPUT(dsi_encoder);
+	/*struct drm_device *dev = dbi_output->dev;*/
+	struct drm_device *dev = encoder->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	u32 reg_offset = 0;
+	int pipe = (dbi_output->channel_num == 0) ? 0 : 2;
+
+	dev_dbg(dev->dev, "pipe %d : %s, panel on: %s\n",
+			pipe, on ? "On" : "Off",
+			dbi_output->dbi_panel_on ? "True" : "False");
+
+	if (pipe == 2) {
+		if (on)
+			dev_priv->dual_mipi = true;
+		else
+			dev_priv->dual_mipi = false;
+		reg_offset = MIPIC_REG_OFFSET;
+	} else {
+		if (!on)
+			dev_priv->dual_mipi = false;
+	}
+
+	if (!gma_power_begin(dev, true)) {
+		dev_err(dev->dev, "hw begin failed\n");
+		return;
+	}
+
+	if (on) {
+		if (dbi_output->dbi_panel_on)
+			goto out_err;
+
+		ret = mdfld_dsi_dbi_update_power(dbi_output, DRM_MODE_DPMS_ON);
+		if (ret) {
+			dev_err(dev->dev, "power on error\n");
+			goto out_err;
+		}
+
+		dbi_output->dbi_panel_on = true;
+
+		if (pipe == 2)
+			dev_priv->dbi_panel_on2 = true;
+		else
+			dev_priv->dbi_panel_on = true;
+		mdfld_enable_te(dev, pipe);
+	} else {
+		if (!dbi_output->dbi_panel_on && !dbi_output->first_boot)
+			goto out_err;
+
+		dbi_output->dbi_panel_on = false;
+		dbi_output->first_boot = false;
+
+		if (pipe == 2)
+			dev_priv->dbi_panel_on2 = false;
+		else
+			dev_priv->dbi_panel_on = false;
+
+		mdfld_disable_te(dev, pipe);
+
+		ret = mdfld_dsi_dbi_update_power(dbi_output, DRM_MODE_DPMS_OFF);
+		if (ret) {
+			dev_err(dev->dev, "power on error\n");
+			goto out_err;
+		}
+	}
+
+out_err:
+	gma_power_end(dev);
+
+	if (ret)
+		dev_err(dev->dev, "failed\n");
+}
+
+
+static void mdfld_dsi_dbi_mode_set(struct drm_encoder *encoder,
+				   struct drm_display_mode *mode,
+				   struct drm_display_mode *adjusted_mode)
+{
+	int ret = 0;
+	struct drm_device *dev = encoder->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mdfld_dsi_encoder *dsi_encoder = MDFLD_DSI_ENCODER(encoder);
+	struct mdfld_dsi_dbi_output *dsi_output =
+					MDFLD_DSI_DBI_OUTPUT(dsi_encoder);
+	struct mdfld_dsi_config *dsi_config =
+				mdfld_dsi_encoder_get_config(dsi_encoder);
+	struct mdfld_dsi_connector *dsi_connector = dsi_config->connector;
+	int pipe = dsi_connector->pipe;
+	u8 param = 0;
+
+	/* Regs */
+	u32 mipi_reg = MIPI;
+	u32 dspcntr_reg = DSPACNTR;
+	u32 pipeconf_reg = PIPEACONF;
+	u32 reg_offset = 0;
+
+	/* Values */
+	u32 dspcntr_val = dev_priv->dspcntr;
+	u32 pipeconf_val = dev_priv->pipeconf;
+	u32 h_active_area = mode->hdisplay;
+	u32 v_active_area = mode->vdisplay;
+	u32 mipi_val;
+
+	mipi_val = (PASS_FROM_SPHY_TO_AFE | SEL_FLOPPED_HSTX |
+						TE_TRIGGER_GPIO_PIN);
+
+	dev_dbg(dev->dev, "mipi_val =0x%x\n", mipi_val);
+
+	dev_dbg(dev->dev, "type %s\n", (pipe == 2) ? "MIPI2" : "MIPI");
+	dev_dbg(dev->dev, "h %d v %d\n", mode->hdisplay, mode->vdisplay);
+
+	if (pipe == 2) {
+		mipi_reg = MIPI_C;
+		dspcntr_reg = DSPCCNTR;
+		pipeconf_reg = PIPECCONF;
+
+		reg_offset = MIPIC_REG_OFFSET;
+
+		dspcntr_val = dev_priv->dspcntr2;
+		pipeconf_val = dev_priv->pipeconf2;
+	} else {
+		mipi_val |= 0x2; /*two lanes for port A and C respectively*/
+	}
+
+	if (!gma_power_begin(dev, true)) {
+		dev_err(dev->dev, "hw begin failed\n");
+		return;
+	}
+
+	/* Set up pipe related registers */
+	REG_WRITE(mipi_reg, mipi_val);
+	REG_READ(mipi_reg);
+
+	mdfld_dsi_controller_dbi_init(dsi_config, pipe);
+
+	msleep(20);
+
+	REG_WRITE(dspcntr_reg, dspcntr_val);
+	REG_READ(dspcntr_reg);
+
+	/* 20ms delay before sending exit_sleep_mode */
+	msleep(20);
+
+	/* Send exit_sleep_mode DCS */
+	ret = mdfld_dsi_dbi_send_dcs(dsi_output, exit_sleep_mode,
+					NULL, 0, CMD_DATA_SRC_SYSTEM_MEM);
+	if (ret) {
+		dev_err(dev->dev, "sent exit_sleep_mode faild\n");
+		goto out_err;
+	}
+
+	/* Send set_tear_on DCS */
+	ret = mdfld_dsi_dbi_send_dcs(dsi_output, set_tear_on,
+					&param, 1, CMD_DATA_SRC_SYSTEM_MEM);
+	if (ret) {
+		dev_err(dev->dev, "%s - sent set_tear_on faild\n", __func__);
+		goto out_err;
+	}
+
+	/* Do some init stuff */
+	mdfld_dsi_brightness_init(dsi_config, pipe);
+
+	mdfld_dsi_gen_fifo_ready(dev, (MIPIA_GEN_FIFO_STAT_REG + reg_offset),
+				HS_CTRL_FIFO_EMPTY | HS_DATA_FIFO_EMPTY);
+
+	REG_WRITE(pipeconf_reg, pipeconf_val | PIPEACONF_DSR);
+	REG_READ(pipeconf_reg);
+
+	/* TODO: this looks ugly, try to move it to CRTC mode setting*/
+	if (pipe == 2)
+		dev_priv->pipeconf2 |= PIPEACONF_DSR;
+	else
+		dev_priv->pipeconf |= PIPEACONF_DSR;
+
+	dev_dbg(dev->dev, "pipeconf %x\n",  REG_READ(pipeconf_reg));
+
+	ret = mdfld_dsi_dbi_update_area(dsi_output, 0, 0,
+				h_active_area - 1, v_active_area - 1);
+	if (ret) {
+		dev_err(dev->dev, "update area failed\n");
+		goto out_err;
+	}
+
+out_err:
+	gma_power_end(dev);
+
+	if (ret)
+		dev_err(dev->dev, "mode set failed\n");
+}
+
+static void mdfld_dsi_dbi_prepare(struct drm_encoder *encoder)
+{
+	struct mdfld_dsi_encoder *dsi_encoder = MDFLD_DSI_ENCODER(encoder);
+	struct mdfld_dsi_dbi_output *dbi_output
+				= MDFLD_DSI_DBI_OUTPUT(dsi_encoder);
+
+	dbi_output->mode_flags |= MODE_SETTING_IN_ENCODER;
+	dbi_output->mode_flags &= ~MODE_SETTING_ENCODER_DONE;
+
+	mdfld_dsi_dbi_set_power(encoder, false);
+}
+
+static void mdfld_dsi_dbi_commit(struct drm_encoder *encoder)
+{
+	struct mdfld_dsi_encoder *dsi_encoder = MDFLD_DSI_ENCODER(encoder);
+	struct mdfld_dsi_dbi_output *dbi_output =
+					MDFLD_DSI_DBI_OUTPUT(dsi_encoder);
+	struct drm_device *dev = dbi_output->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_drm_dpu_rect rect;
+
+	mdfld_dsi_dbi_set_power(encoder, true);
+	dbi_output->mode_flags &= ~MODE_SETTING_IN_ENCODER;
+
+	rect.x = rect.y = 0;
+	rect.width = 864;
+	rect.height = 480;
+
+	if (dbi_output->channel_num == 1) {
+		dev_priv->dsr_fb_update |= MDFLD_DSR_2D_3D_2;
+#ifdef CONFIG_MDFLD_DSI_DPU
+		/*if dpu enabled report a fullscreen damage*/
+		mdfld_dbi_dpu_report_damage(dev, MDFLD_PLANEC, &rect);
+#endif
+	} else {
+		dev_priv->dsr_fb_update |= MDFLD_DSR_2D_3D_0;
+#ifdef CONFIG_MDFLD_DSI_DPU
+		mdfld_dbi_dpu_report_damage(dev, MDFLD_PLANEA, &rect);
+#endif
+	}
+	dbi_output->mode_flags |= MODE_SETTING_ENCODER_DONE;
+}
+
+static void mdfld_dsi_dbi_dpms(struct drm_encoder *encoder, int mode)
+{
+	struct mdfld_dsi_encoder *dsi_encoder = MDFLD_DSI_ENCODER(encoder);
+	struct mdfld_dsi_dbi_output *dbi_output
+				= MDFLD_DSI_DBI_OUTPUT(dsi_encoder);
+	struct drm_device *dev = dbi_output->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	static bool bdispoff;
+
+	dev_dbg(dev->dev, "%s\n", (mode == DRM_MODE_DPMS_ON ? "on" : "off"));
+
+	if (mode == DRM_MODE_DPMS_ON) {
+		/*
+		 * FIXME: in case I am wrong!
+		 * we don't need to exit dsr here to wake up plane/pipe/pll
+		 * if everything goes right, hw_begin will resume them all
+		 * during set_power.
+		 */
+		if (bdispoff)
+			mdfld_dsi_dbi_exit_dsr(dev, MDFLD_DSR_2D_3D, 0, 0);
+
+		mdfld_dsi_dbi_set_power(encoder, true);
+		/* FIXME if (gbgfxsuspended)
+			gbgfxsuspended = false; */
+		bdispoff = false;
+		dev_priv->dispstatus = true;
+	} else {
+		/*
+		 * I am not sure whether this is the perfect place to
+		 * turn rpm on since we still have a lot of CRTC turnning
+		 * on work to do.
+		 */
+		mdfld_dsi_dbi_set_power(encoder, false);
+		bdispoff = true;
+		dev_priv->dispstatus = false;
+	}
+}
+
+
+/*
+ * Update the DBI MIPI Panel Frame Buffer.
+ */
+static void mdfld_dsi_dbi_update_fb(struct mdfld_dsi_dbi_output *dbi_output,
+								int pipe)
+{
+	struct mdfld_dsi_pkg_sender *sender =
+		mdfld_dsi_encoder_get_pkg_sender(&dbi_output->base);
+	struct drm_device *dev = dbi_output->dev;
+	struct drm_crtc *crtc = dbi_output->base.base.crtc;
+	struct psb_intel_crtc *psb_crtc = (crtc) ?
+					to_psb_intel_crtc(crtc) : NULL;
+	u32 dpll_reg = MRST_DPLL_A;
+	u32 dspcntr_reg = DSPACNTR;
+	u32 pipeconf_reg = PIPEACONF;
+	u32 dsplinoff_reg = DSPALINOFF;
+	u32 dspsurf_reg = DSPASURF;
+	u32 reg_offset = 0;
+
+	/* If mode setting on-going, back off */
+	if ((dbi_output->mode_flags & MODE_SETTING_ON_GOING) ||
+		(psb_crtc && psb_crtc->mode_flags & MODE_SETTING_ON_GOING) ||
+		!(dbi_output->mode_flags & MODE_SETTING_ENCODER_DONE))
+		return;
+
+	if (pipe == 2) {
+		dspcntr_reg = DSPCCNTR;
+		pipeconf_reg = PIPECCONF;
+		dsplinoff_reg = DSPCLINOFF;
+		dspsurf_reg = DSPCSURF;
+		reg_offset = MIPIC_REG_OFFSET;
+	}
+
+	if (!gma_power_begin(dev, true)) {
+		dev_err(dev->dev, "hw begin failed\n");
+		return;
+	}
+
+	/* Check DBI FIFO status */
+	if (!(REG_READ(dpll_reg) & DPLL_VCO_ENABLE) ||
+	   !(REG_READ(dspcntr_reg) & DISPLAY_PLANE_ENABLE) ||
+	   !(REG_READ(pipeconf_reg) & DISPLAY_PLANE_ENABLE))
+		goto update_fb_out0;
+
+	/* Refresh plane changes */
+	REG_WRITE(dsplinoff_reg, REG_READ(dsplinoff_reg));
+	REG_WRITE(dspsurf_reg, REG_READ(dspsurf_reg));
+	REG_READ(dspsurf_reg);
+
+	mdfld_dsi_send_dcs(sender,
+			   write_mem_start,
+			   NULL,
+			   0,
+			   CMD_DATA_SRC_PIPE,
+			   MDFLD_DSI_SEND_PACKAGE);
+
+	dbi_output->dsr_fb_update_done = true;
+update_fb_out0:
+	gma_power_end(dev);
+}
+
+static int tpo_cmd_get_panel_info(struct drm_device *dev,
+				int pipe,
+				struct panel_info *pi)
+{
+	if (!dev || !pi)
+		return -EINVAL;
+
+	pi->width_mm = TPO_PANEL_WIDTH;
+	pi->height_mm = TPO_PANEL_HEIGHT;
+
+	return 0;
+}
+
+
+/* TPO DBI encoder helper funcs */
+static const struct drm_encoder_helper_funcs mdfld_dsi_dbi_helper_funcs = {
+	.dpms = mdfld_dsi_dbi_dpms,
+	.mode_fixup = mdfld_dsi_dbi_mode_fixup,
+	.prepare = mdfld_dsi_dbi_prepare,
+	.mode_set = mdfld_dsi_dbi_mode_set,
+	.commit = mdfld_dsi_dbi_commit,
+};
+
+/* TPO DBI encoder funcs */
+static const struct drm_encoder_funcs mdfld_dsi_dbi_encoder_funcs = {
+	.destroy = drm_encoder_cleanup,
+};
+
+void tpo_cmd_init(struct drm_device *dev, struct panel_funcs *p_funcs)
+{
+	p_funcs->encoder_funcs = &mdfld_dsi_dbi_encoder_funcs;
+	p_funcs->encoder_helper_funcs = &mdfld_dsi_dbi_helper_funcs;
+	p_funcs->get_config_mode = &tpo_cmd_get_config_mode;
+	p_funcs->update_fb = mdfld_dsi_dbi_update_fb;
+	p_funcs->get_panel_info = tpo_cmd_get_panel_info;
+}
diff --git a/drivers/staging/gma500/mdfld_tpo_vid.c b/drivers/staging/gma500/mdfld_tpo_vid.c
new file mode 100644
index 0000000..9549017
--- /dev/null
+++ b/drivers/staging/gma500/mdfld_tpo_vid.c
@@ -0,0 +1,140 @@
+/*
+ * Copyright © 2010 Intel Corporation
+ *
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
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ * Authors:
+ * jim liu <jim.liu@intel.com>
+ * Jackie Li<yaodong.li@intel.com>
+ */
+
+#include "mdfld_dsi_dbi.h"
+#include "mdfld_dsi_dpi.h"
+#include "mdfld_dsi_output.h"
+#include "mdfld_output.h"
+
+#include "mdfld_dsi_pkg_sender.h"
+
+#include "displays/tpo_vid.h"
+
+static struct drm_display_mode *tpo_vid_get_config_mode(struct drm_device *dev)
+{
+	struct drm_display_mode *mode;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mrst_timing_info *ti = &dev_priv->gct_data.DTD;
+	bool use_gct = false;
+
+	mode = kzalloc(sizeof(*mode), GFP_KERNEL);
+	if (!mode) {
+		dev_err(dev->dev, "out of memory\n");
+		return NULL;
+	}
+
+	if (use_gct) {
+		mode->hdisplay = (ti->hactive_hi << 8) | ti->hactive_lo;
+		mode->vdisplay = (ti->vactive_hi << 8) | ti->vactive_lo;
+		mode->hsync_start = mode->hdisplay + \
+				((ti->hsync_offset_hi << 8) | \
+				ti->hsync_offset_lo);
+		mode->hsync_end = mode->hsync_start + \
+				((ti->hsync_pulse_width_hi << 8) | \
+				ti->hsync_pulse_width_lo);
+		mode->htotal = mode->hdisplay + ((ti->hblank_hi << 8) | \
+								ti->hblank_lo);
+		mode->vsync_start = \
+			mode->vdisplay + ((ti->vsync_offset_hi << 8) | \
+						ti->vsync_offset_lo);
+		mode->vsync_end = \
+			mode->vsync_start + ((ti->vsync_pulse_width_hi << 8) | \
+						ti->vsync_pulse_width_lo);
+		mode->vtotal = mode->vdisplay + \
+				((ti->vblank_hi << 8) | ti->vblank_lo);
+		mode->clock = ti->pixel_clock * 10;
+
+		dev_dbg(dev->dev, "hdisplay is %d\n", mode->hdisplay);
+		dev_dbg(dev->dev, "vdisplay is %d\n", mode->vdisplay);
+		dev_dbg(dev->dev, "HSS is %d\n", mode->hsync_start);
+		dev_dbg(dev->dev, "HSE is %d\n", mode->hsync_end);
+		dev_dbg(dev->dev, "htotal is %d\n", mode->htotal);
+		dev_dbg(dev->dev, "VSS is %d\n", mode->vsync_start);
+		dev_dbg(dev->dev, "VSE is %d\n", mode->vsync_end);
+		dev_dbg(dev->dev, "vtotal is %d\n", mode->vtotal);
+		dev_dbg(dev->dev, "clock is %d\n", mode->clock);
+	} else {
+		mode->hdisplay = 864;
+		mode->vdisplay = 480;
+		mode->hsync_start = 873;
+		mode->hsync_end = 876;
+		mode->htotal = 887;
+		mode->vsync_start = 487;
+		mode->vsync_end = 490;
+		mode->vtotal = 499;
+		mode->clock = 33264;
+	}
+
+	drm_mode_set_name(mode);
+	drm_mode_set_crtcinfo(mode, 0);
+
+	mode->type |= DRM_MODE_TYPE_PREFERRED;
+
+	return mode;
+}
+
+static int tpo_vid_get_panel_info(struct drm_device *dev,
+				int pipe,
+				struct panel_info *pi)
+{
+	if (!dev || !pi)
+		return -EINVAL;
+
+	pi->width_mm = TPO_PANEL_WIDTH;
+	pi->height_mm = TPO_PANEL_HEIGHT;
+
+	return 0;
+}
+
+/*TPO DPI encoder helper funcs*/
+static const struct drm_encoder_helper_funcs
+					mdfld_tpo_dpi_encoder_helper_funcs = {
+	.dpms = mdfld_dsi_dpi_dpms,
+	.mode_fixup = mdfld_dsi_dpi_mode_fixup,
+	.prepare = mdfld_dsi_dpi_prepare,
+	.mode_set = mdfld_dsi_dpi_mode_set,
+	.commit = mdfld_dsi_dpi_commit,
+};
+
+/*TPO DPI encoder funcs*/
+static const struct drm_encoder_funcs mdfld_tpo_dpi_encoder_funcs = {
+	.destroy = drm_encoder_cleanup,
+};
+
+void tpo_vid_init(struct drm_device *dev, struct panel_funcs *p_funcs)
+{
+	if (!dev || !p_funcs) {
+		dev_err(dev->dev, "tpo_vid_init: Invalid parameters\n");
+		return;
+	}
+
+	p_funcs->encoder_funcs = &mdfld_tpo_dpi_encoder_funcs;
+	p_funcs->encoder_helper_funcs = &mdfld_tpo_dpi_encoder_helper_funcs;
+	p_funcs->get_config_mode = &tpo_vid_get_config_mode;
+	p_funcs->update_fb = NULL;
+	p_funcs->get_panel_info = tpo_vid_get_panel_info;
+}
diff --git a/drivers/staging/gma500/psb_bl.c b/drivers/staging/gma500/psb_bl.c
index 4a00047..c84d261 100644
--- a/drivers/staging/gma500/psb_bl.c
+++ b/drivers/staging/gma500/psb_bl.c
@@ -105,6 +105,46 @@ int mrst_set_brightness(struct backlight_device *bd)
 	return 0;
 }
 
+int mfld_set_brightness(struct backlight_device *bd)
+{
+	struct drm_device *dev = bl_get_data(psb_backlight_device);
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int level = bd->props.brightness;
+
+	DRM_DEBUG_DRIVER("backlight level set to %d\n", level);
+
+	/* Percentage 1-100% being valid */
+	if (level < 1)
+		level = 1;
+
+	if (gma_power_begin(dev, 0)) {
+		/* Calculate and set the brightness value */
+		u32 adjusted_level;
+
+		/* Adjust the backlight level with the percent in
+		 * dev_priv->blc_adj2;
+		 */
+		adjusted_level = level * dev_priv->blc_adj2;
+		adjusted_level = adjusted_level / BLC_ADJUSTMENT_MAX;
+#if 0
+#ifndef CONFIG_MDFLD_DSI_DPU
+		if(!(dev_priv->dsr_fb_update & MDFLD_DSR_MIPI_CONTROL) && 
+			(dev_priv->dbi_panel_on || dev_priv->dbi_panel_on2)){
+			mdfld_dsi_dbi_exit_dsr(dev,MDFLD_DSR_MIPI_CONTROL, 0, 0);
+			dev_dbg(dev->dev, "Out of DSR before set brightness to %d.\n",adjusted_level);
+		}
+#endif
+		mdfld_dsi_brightness_control(dev, 0, adjusted_level);
+
+		if ((dev_priv->dbi_panel_on2) || (dev_priv->dpi_panel_on2))
+			mdfld_dsi_brightness_control(dev, 2, adjusted_level);
+#endif
+		gma_power_end(dev);
+	}
+	psb_brightness = level;
+	return 0;
+}
+
 int psb_get_brightness(struct backlight_device *bd)
 {
 	/* return locally cached var instead of HW read (due to DPST etc.) */
@@ -118,6 +158,16 @@ static const struct backlight_ops psb_ops = {
 	.update_status  = psb_set_brightness,
 };
 
+static const struct backlight_ops mrst_ops = {
+	.get_brightness = psb_get_brightness,
+	.update_status  = mrst_set_brightness,
+};
+
+static const struct backlight_ops mfld_ops = {
+	.get_brightness = psb_get_brightness,
+	.update_status  = mfld_set_brightness,
+};
+
 static int device_backlight_init(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
@@ -128,7 +178,11 @@ static int device_backlight_init(struct drm_device *dev)
 	uint32_t value;
 	uint32_t blc_pwm_precision_factor;
 
-	if (IS_MRST(dev)) {
+	if (IS_MFLD(dev)) {
+		dev_priv->blc_adj1 = BLC_ADJUSTMENT_MAX;
+		dev_priv->blc_adj2 = BLC_ADJUSTMENT_MAX;
+		return 0;
+	} else if (IS_MRST(dev)) {
 		dev_priv->blc_adj1 = BLC_ADJUSTMENT_MAX;
 		dev_priv->blc_adj2 = BLC_ADJUSTMENT_MAX;
 		bl_max_freq = 256;
@@ -190,8 +244,16 @@ int psb_backlight_init(struct drm_device *dev)
 	props.max_brightness = 100;
 	props.type = BACKLIGHT_PLATFORM;
 
-	psb_backlight_device = backlight_device_register("psb-bl", NULL,
-						(void *)dev, &psb_ops, &props);
+	if (IS_MFLD(dev))
+		psb_backlight_device = backlight_device_register("mfld-bl",
+					NULL, (void *)dev, &mfld_ops, &props);
+	else if (IS_MRST(dev))
+		psb_backlight_device = backlight_device_register("mrst-bl",
+					NULL, (void *)dev, &psb_ops, &props);
+	else
+		psb_backlight_device = backlight_device_register("psb-bl",
+					NULL, (void *)dev, &psb_ops, &props);
+					
 	if (IS_ERR(psb_backlight_device))
 		return PTR_ERR(psb_backlight_device);
 
diff --git a/drivers/staging/gma500/psb_drm.h b/drivers/staging/gma500/psb_drm.h
index 8c259b8..c541137 100644
--- a/drivers/staging/gma500/psb_drm.h
+++ b/drivers/staging/gma500/psb_drm.h
@@ -186,4 +186,11 @@ struct drm_psb_get_pipe_from_crtc_id_arg {
 	u32 pipe;
 };
 
+/* FIXME: move this into a medfield header once we are sure it isn't needed for an
+   ioctl  */
+struct psb_drm_dpu_rect {  
+	int x, y;             
+	int width, height;    
+};  
+
 #endif
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index 3c2363a..8df9c58 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -58,6 +58,14 @@ static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
 	{ 0x8086, 0x4105, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MRST_4100},
 	{ 0x8086, 0x4106, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MRST_4100},
 	{ 0x8086, 0x4107, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MRST_4100},
+	{ 0x8086, 0x0130, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MFLD_0130},
+	{ 0x8086, 0x0131, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MFLD_0130},
+	{ 0x8086, 0x0132, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MFLD_0130},
+	{ 0x8086, 0x0133, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MFLD_0130},
+	{ 0x8086, 0x0134, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MFLD_0130},
+	{ 0x8086, 0x0135, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MFLD_0130},
+	{ 0x8086, 0x0136, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MFLD_0130},
+	{ 0x8086, 0x0137, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_MFLD_0130},
 	{ 0, 0, 0}
 };
 MODULE_DEVICE_TABLE(pci, pciidlist);
@@ -176,7 +184,9 @@ void mrst_get_fuse_settings(struct drm_device *dev)
 	pci_write_config_dword(pci_root, 0xD0, FB_REG06);
 	pci_read_config_dword(pci_root, 0xD4, &fuse_value);
 
-	dev_priv->iLVDS_enable = fuse_value & FB_MIPI_DISABLE;
+	/* FB_MIPI_DISABLE doesn't mean LVDS on with Medfield */
+	if (IS_MRST(dev))
+		dev_priv->iLVDS_enable = fuse_value & FB_MIPI_DISABLE;
 
 	DRM_INFO("internal display is %s\n",
 		 dev_priv->iLVDS_enable ? "LVDS display" : "MIPI display");
@@ -360,6 +370,7 @@ void mrst_get_vbt_data(struct drm_psb_private *dev_priv)
 		printk(KERN_ERR "Unknown revision of GCT!\n");
 		vbt->size = 0;
 	}
+	/* FIXME: Need to sort out Medfield panel identifiers in future */
 }
 
 static void psb_get_core_freq(struct drm_device *dev)
@@ -539,6 +550,8 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 
 	if (IS_MRST(dev))
 		dev_priv->num_pipe = 1;
+	else if (IS_MFLD(dev))
+		dev_priv->num_pipe = 3;
 	else
 		dev_priv->num_pipe = 2;
 
@@ -554,7 +567,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	if (!dev_priv->vdc_reg)
 		goto out_err;
 
-	if (IS_MRST(dev))
+	if (IS_MRST(dev) || IS_MFLD(dev))
 		dev_priv->sgx_reg = ioremap(resource_start + MRST_SGX_OFFSET,
 							PSB_SGX_SIZE);
 	else
@@ -564,7 +577,7 @@ static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
 	if (!dev_priv->sgx_reg)
 		goto out_err;
 
-	if (IS_MRST(dev)) {
+	if (IS_MRST(dev) || IS_MFLD(dev)) {
 		mrst_get_fuse_settings(dev);
 		mrst_get_vbt_data(dev_priv);
 		mid_get_pci_revID(dev_priv);
@@ -706,6 +719,11 @@ static int psb_dc_state_ioctl(struct drm_device *dev, void * data,
 	struct drm_psb_dc_state_arg *arg =
 		(struct drm_psb_dc_state_arg *)data;
 
+
+	/* Double check MRST case */
+	if (IS_MRST(dev) || IS_MFLD(dev))
+		return -EOPNOTSUPP;
+
 	flags = arg->flags;
 	obj_id = arg->obj_id;
 
@@ -954,6 +972,7 @@ static int psb_stolen_memory_ioctl(struct drm_device *dev, void *data,
 	return 0;
 }
 
+/* FIXME: needs Medfield changes */
 static int psb_register_rw_ioctl(struct drm_device *dev, void *data,
 				 struct drm_file *file_priv)
 {
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index cafbfcd..86abf26 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -34,15 +34,18 @@
 #include "mrst.h"
 
 /* Append new drm mode definition here, align with libdrm definition */
-#define DRM_MODE_SCALE_NO_SCALE   2
+#define DRM_MODE_SCALE_NO_SCALE   	2
+#define DRM_MODE_CONNECTOR_MIPI         15
 
 enum {
 	CHIP_PSB_8108 = 0,		/* Poulsbo */
 	CHIP_PSB_8109 = 1,		/* Poulsbo */
 	CHIP_MRST_4100 = 2,		/* Moorestown/Oaktrail */
+	CHIP_MFLD_0130 = 3,		/* Medfield */
 };
 
 #define IS_MRST(dev) (((dev)->pci_device & 0xfffc) == 0x4100)
+#define IS_MFLD(dev) (((dev)->pci_device & 0xfff8) == 0x0130)
 
 /*
  * Driver definitions
@@ -204,10 +207,25 @@ enum {
 #define PSB_WATCHDOG_DELAY (DRM_HZ * 2)
 #define PSB_LID_DELAY (DRM_HZ / 10)
 
-#define MDFLD_PNW_A0 0x00
 #define MDFLD_PNW_B0 0x04
 #define MDFLD_PNW_C0 0x08
 
+#define MDFLD_DSR_2D_3D_0 	(1 << 0)
+#define MDFLD_DSR_2D_3D_2 	(1 << 1)
+#define MDFLD_DSR_CURSOR_0 	(1 << 2)
+#define MDFLD_DSR_CURSOR_2	(1 << 3)
+#define MDFLD_DSR_OVERLAY_0 	(1 << 4)
+#define MDFLD_DSR_OVERLAY_2 	(1 << 5)
+#define MDFLD_DSR_MIPI_CONTROL	(1 << 6)
+#define MDFLD_DSR_DAMAGE_MASK_0	(1 << 0) | (1 << 2) | (1 << 4)
+#define MDFLD_DSR_DAMAGE_MASK_2	(1 << 1) | (1 << 3) | (1 << 5)
+#define MDFLD_DSR_2D_3D 	(MDFLD_DSR_2D_3D_0 | MDFLD_DSR_2D_3D_2)
+
+#define MDFLD_DSR_RR		45
+#define MDFLD_DPU_ENABLE 	(1 << 31)
+#define MDFLD_DSR_FULLSCREEN 	(1 << 30)
+#define MDFLD_DSR_DELAY		(DRM_HZ / MDFLD_DSR_RR)
+
 #define PSB_PWR_STATE_ON		1
 #define PSB_PWR_STATE_OFF		2
 
@@ -221,6 +239,12 @@ enum {
 #define PSB_PCIx_MSI_ADDR_LOC		0x94
 #define PSB_PCIx_MSI_DATA_LOC		0x98
 
+/* Medfield crystal settings */
+#define KSEL_CRYSTAL_19 1
+#define KSEL_BYPASS_19 5
+#define KSEL_BYPASS_25 6
+#define KSEL_BYPASS_83_100 7
+
 struct opregion_header;
 struct opregion_acpi;
 struct opregion_swsci;
@@ -331,6 +355,7 @@ struct drm_psb_private {
 	int lvds_ssc_freq;
 	bool is_lvds_on;
 	bool is_mipi_on;
+	u32 mipi_ctrl_display;
 
 	unsigned int core_freq;
 	uint32_t iLVDS_enable;
@@ -338,10 +363,19 @@ struct drm_psb_private {
 	/* Runtime PM state */
 	int rpm_enabled;
 
-	/* Moorestown specific */
+	/* MID specific */
 	struct mrst_vbt vbt_data;
 	struct mrst_gct_data gct_data;
 
+	/* MIPI Panel type etc */
+	int panel_id;
+	bool dual_mipi;		/* dual display - DPI & DBI */
+	bool dpi_panel_on;	/* The DPI panel power is on */
+	bool dpi_panel_on2;	/* The DPI panel power is on */
+	bool dbi_panel_on;	/* The DBI panel power is on */
+	bool dbi_panel_on2;	/* The DBI panel power is on */
+	u32 dsr_fb_update;	/* DSR FB update counter */
+
 	/* Moorestown pipe config register value cache */
 	uint32_t pipeconf;
 	uint32_t pipeconf1;
@@ -376,6 +410,7 @@ struct drm_psb_private {
 	uint32_t saveDSPAPOS;
 	uint32_t saveDSPABASE;
 	uint32_t saveDSPASURF;
+	uint32_t saveDSPASTATUS;
 	uint32_t saveFPB0;
 	uint32_t saveFPB1;
 	uint32_t saveDPLL_B;
@@ -391,6 +426,7 @@ struct drm_psb_private {
 	uint32_t saveDSPBPOS;
 	uint32_t saveDSPBBASE;
 	uint32_t saveDSPBSURF;
+	uint32_t saveDSPBSTATUS;
 	uint32_t saveVCLK_DIVISOR_VGA0;
 	uint32_t saveVCLK_DIVISOR_VGA1;
 	uint32_t saveVCLK_POST_DIV;
@@ -461,6 +497,77 @@ struct drm_psb_private {
 	uint32_t msi_addr;
 	uint32_t msi_data;
 
+	/* Medfield specific register save state */
+	uint32_t saveHDMIPHYMISCCTL;
+	uint32_t saveHDMIB_CONTROL;
+	uint32_t saveDSPCCNTR;
+	uint32_t savePIPECCONF;
+	uint32_t savePIPECSRC;
+	uint32_t saveHTOTAL_C;
+	uint32_t saveHBLANK_C;
+	uint32_t saveHSYNC_C;
+	uint32_t saveVTOTAL_C;
+	uint32_t saveVBLANK_C;
+	uint32_t saveVSYNC_C;
+	uint32_t saveDSPCSTRIDE;
+	uint32_t saveDSPCSIZE;
+	uint32_t saveDSPCPOS;
+	uint32_t saveDSPCSURF;
+	uint32_t saveDSPCSTATUS;
+	uint32_t saveDSPCLINOFF;
+	uint32_t saveDSPCTILEOFF;
+	uint32_t saveDSPCCURSOR_CTRL;
+	uint32_t saveDSPCCURSOR_BASE;
+	uint32_t saveDSPCCURSOR_POS;
+	uint32_t save_palette_c[256];
+	uint32_t saveOV_OVADD_C;
+	uint32_t saveOV_OGAMC0_C;
+	uint32_t saveOV_OGAMC1_C;
+	uint32_t saveOV_OGAMC2_C;
+	uint32_t saveOV_OGAMC3_C;
+	uint32_t saveOV_OGAMC4_C;
+	uint32_t saveOV_OGAMC5_C;
+
+	/* DSI register save */
+	uint32_t saveDEVICE_READY_REG;
+	uint32_t saveINTR_EN_REG;
+	uint32_t saveDSI_FUNC_PRG_REG;
+	uint32_t saveHS_TX_TIMEOUT_REG;
+	uint32_t saveLP_RX_TIMEOUT_REG;
+	uint32_t saveTURN_AROUND_TIMEOUT_REG;
+	uint32_t saveDEVICE_RESET_REG;
+	uint32_t saveDPI_RESOLUTION_REG;
+	uint32_t saveHORIZ_SYNC_PAD_COUNT_REG;
+	uint32_t saveHORIZ_BACK_PORCH_COUNT_REG;
+	uint32_t saveHORIZ_FRONT_PORCH_COUNT_REG;
+	uint32_t saveHORIZ_ACTIVE_AREA_COUNT_REG;
+	uint32_t saveVERT_SYNC_PAD_COUNT_REG;
+	uint32_t saveVERT_BACK_PORCH_COUNT_REG;
+	uint32_t saveVERT_FRONT_PORCH_COUNT_REG;
+	uint32_t saveHIGH_LOW_SWITCH_COUNT_REG;
+	uint32_t saveINIT_COUNT_REG;
+	uint32_t saveMAX_RET_PAK_REG;
+	uint32_t saveVIDEO_FMT_REG;
+	uint32_t saveEOT_DISABLE_REG;
+	uint32_t saveLP_BYTECLK_REG;
+	uint32_t saveHS_LS_DBI_ENABLE_REG;
+	uint32_t saveTXCLKESC_REG;
+	uint32_t saveDPHY_PARAM_REG;
+	uint32_t saveMIPI_CONTROL_REG;
+	uint32_t saveMIPI;
+	uint32_t saveMIPI_C;
+
+	/* DPST register save */
+	uint32_t saveHISTOGRAM_INT_CONTROL_REG;
+	uint32_t saveHISTOGRAM_LOGIC_CONTROL_REG;
+	uint32_t savePWM_CONTROL_LOGIC;
+
+	/*
+	 * DSI info. 
+	 */
+	void * dbi_dsr_info;	
+	void * dbi_dpu_info;
+	void * dsi_configs[2];
 	/*
 	 * LID-Switch
 	 */
@@ -486,6 +593,22 @@ struct drm_psb_private {
 	uint32_t blc_adj2;
 
 	void *fbdev;
+
+	/* DPST state */
+	uint32_t dsr_idle_count;
+	bool is_in_idle;
+	bool dsr_enable;
+	void (*exit_idle)(struct drm_device *dev, u32 update_src, void *p_surfaceAddr, bool check_hw_on_only);
+
+	/* FIXME: Arrays anyone ? */
+	struct mdfld_dsi_encoder *encoder0;	
+	struct mdfld_dsi_encoder *encoder2;	
+	struct mdfld_dsi_dbi_output * dbi_output;
+	struct mdfld_dsi_dbi_output * dbi_output2;
+	u32 bpp;
+	u32 bpp2;
+	
+	bool dispstatus;
 };
 
 
@@ -567,6 +690,9 @@ psb_disable_pipestat(struct drm_psb_private *dev_priv, int pipe, u32 mask);
 
 extern u32 psb_get_vblank_counter(struct drm_device *dev, int crtc);
 
+extern int mdfld_enable_te(struct drm_device *dev, int pipe);
+extern void mdfld_disable_te(struct drm_device *dev, int pipe);
+
 /*
  * psb_opregion.c
  */
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
index c2d4b23..8377a99 100644
--- a/drivers/staging/gma500/psb_fb.c
+++ b/drivers/staging/gma500/psb_fb.c
@@ -38,6 +38,8 @@
 #include "psb_intel_drv.h"
 #include "psb_fb.h"
 
+#include "mdfld_output.h"
+
 static void psb_user_framebuffer_destroy(struct drm_framebuffer *fb);
 static int psb_user_framebuffer_create_handle(struct drm_framebuffer *fb,
 					      struct drm_file *file_priv,
@@ -270,6 +272,8 @@ static int psbfb_ioctl(struct fb_info *info, unsigned int cmd,
 	case 0x12345678:
 		if (!capable(CAP_SYS_RAWIO))
 			return -EPERM;
+	        if (IS_MFLD(dev))
+                        return -EOPNOTSUPP;
 		if (get_user(l, p))
 			return -EFAULT;
 		if (l > 32)
@@ -297,6 +301,19 @@ static struct fb_ops psbfb_ops = {
 	.fb_ioctl = psbfb_ioctl,
 };
 
+static struct fb_ops psbfb_mfld_ops = {
+	.owner = THIS_MODULE,
+	.fb_check_var = drm_fb_helper_check_var,
+	.fb_set_par = drm_fb_helper_set_par,
+	.fb_blank = drm_fb_helper_blank,
+	.fb_setcolreg = psbfb_setcolreg,
+	.fb_fillrect = cfb_fillrect,
+	.fb_copyarea = cfb_copyarea,
+	.fb_imageblit = cfb_imageblit,
+	.fb_mmap = psbfb_mmap,
+	.fb_ioctl = psbfb_ioctl,
+};
+
 /**
  *	psb_framebuffer_init	-	initialize a framebuffer
  *	@dev: our DRM device
@@ -346,6 +363,7 @@ static int psb_framebuffer_init(struct drm_device *dev,
  *
  *	TODO: review object references
  */
+
 static struct drm_framebuffer *psb_framebuffer_create
 			(struct drm_device *dev,
 			 struct drm_mode_fb_cmd *mode_cmd,
@@ -468,7 +486,11 @@ static int psbfb_create(struct psb_fbdev *fbdev,
 	strcpy(info->fix.id, "psbfb");
 
 	info->flags = FBINFO_DEFAULT;
-	info->fbops = &psbfb_ops;
+	/* No 2D engine */
+	if (IS_MFLD(dev))
+	        info->fbops = &psbfb_mfld_ops;
+        else
+        	info->fbops = &psbfb_ops;
 
 	ret = fb_alloc_cmap(&info->cmap, 256, 0);
 	if (ret) {
@@ -781,7 +803,9 @@ static void psb_setup_outputs(struct drm_device *dev)
 			mrst_lvds_init(dev, &dev_priv->mode_dev);
 		else
 			dev_err(dev->dev, "DSI is not supported\n");
-	} else {
+	} else if (IS_MFLD(dev)) {
+		mdfld_output_init(dev);
+        } else {
 		psb_intel_lvds_init(dev, &dev_priv->mode_dev);
 		psb_intel_sdvo_init(dev, SDVOB);
 	}
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
index 1bb2144..ac0d9da 100644
--- a/drivers/staging/gma500/psb_intel_display.c
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -1,5 +1,5 @@
 /*
- * Copyright Â© 2006-2007 Intel Corporation
+ * Copyright Â© 2006-2011 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -1080,7 +1080,7 @@ static int psb_intel_crtc_cursor_move(struct drm_crtc *crtc, int x, int y)
 	return 0;
 }
 
-static void psb_intel_crtc_gamma_set(struct drm_crtc *crtc, u16 *red,
+void psb_intel_crtc_gamma_set(struct drm_crtc *crtc, u16 *red,
 			 u16 *green, u16 *blue, uint32_t type, uint32_t size)
 {
 	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
@@ -1241,7 +1241,7 @@ struct drm_display_mode *psb_intel_crtc_mode_get(struct drm_device *dev,
 	return mode;
 }
 
-static void psb_intel_crtc_destroy(struct drm_crtc *crtc)
+void psb_intel_crtc_destroy(struct drm_crtc *crtc)
 {
 	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
 	struct gtt_range *gt;
@@ -1303,7 +1303,14 @@ void psb_intel_crtc_init(struct drm_device *dev, int pipe,
 		return;
 	}
 
-	drm_crtc_init(dev, &psb_intel_crtc->base, &psb_intel_crtc_funcs);
+#if 0	/* FIXME */
+	if (IS_MFLD(dev))
+		drm_crtc_init(dev, &psb_intel_crtc->base,
+						&mfld_intel_crtc_funcs);
+	else
+#endif
+        	drm_crtc_init(dev, &psb_intel_crtc->base,
+						&psb_intel_crtc_funcs);
 
 	drm_mode_crtc_set_gamma_size(&psb_intel_crtc->base, 256);
 	psb_intel_crtc->pipe = pipe;
@@ -1329,6 +1336,9 @@ void psb_intel_crtc_init(struct drm_device *dev, int pipe,
 	if (IS_MRST(dev))
 		drm_crtc_helper_add(&psb_intel_crtc->base,
 				    &mrst_helper_funcs);
+/*	else if (IS_MDFLD(dev))
+		drm_crtc_helper_add(&psb_intel_crtc->base,
+				    &mfld_helper_funcs); */
 	else
 		drm_crtc_helper_add(&psb_intel_crtc->base,
 				    &psb_intel_helper_funcs);
diff --git a/drivers/staging/gma500/psb_intel_display.h b/drivers/staging/gma500/psb_intel_display.h
index 3724b97..535b49a 100644
--- a/drivers/staging/gma500/psb_intel_display.h
+++ b/drivers/staging/gma500/psb_intel_display.h
@@ -21,5 +21,8 @@
 #define _INTEL_DISPLAY_H_
 
 bool psb_intel_pipe_has_type(struct drm_crtc *crtc, int type);
+void psb_intel_crtc_gamma_set(struct drm_crtc *crtc, u16 *red,
+			 u16 *green, u16 *blue, uint32_t type, uint32_t size);
+void psb_intel_crtc_destroy(struct drm_crtc *crtc);
 
 #endif
diff --git a/drivers/staging/gma500/psb_intel_drv.h b/drivers/staging/gma500/psb_intel_drv.h
index 75a95f7..9d7151a 100644
--- a/drivers/staging/gma500/psb_intel_drv.h
+++ b/drivers/staging/gma500/psb_intel_drv.h
@@ -224,4 +224,7 @@ extern int psb_intel_lvds_set_property(struct drm_connector *connector,
 extern void psb_intel_lvds_destroy(struct drm_connector *connector);
 extern const struct drm_encoder_funcs psb_intel_lvds_enc_funcs;
 
+extern void mdfldWaitForPipeDisable(struct drm_device *dev, int pipe);
+extern void mdfldWaitForPipeEnable(struct drm_device *dev, int pipe);
+
 #endif				/* __INTEL_DRV_H__ */
diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
index 1cbc9bc..850d07d 100644
--- a/drivers/staging/gma500/psb_intel_lvds.c
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -388,6 +388,7 @@ bool psb_intel_lvds_mode_fixup(struct drm_encoder *encoder,
 	if (psb_intel_output->type == INTEL_OUTPUT_MIPI2)
 		panel_fixed_mode = mode_dev->panel_fixed_mode2;
 
+	/* FIXME: review for Medfield */
 	/* PSB requires the LVDS is on pipe B, MRST has only one pipe anyway */
 	if (!IS_MRST(dev) && psb_intel_crtc->pipe == 0) {
 		printk(KERN_ERR "Can't support LVDS on pipe A\n");
diff --git a/drivers/staging/gma500/psb_irq.c b/drivers/staging/gma500/psb_irq.c
index 1cbfeb6..3768cf1 100644
--- a/drivers/staging/gma500/psb_irq.c
+++ b/drivers/staging/gma500/psb_irq.c
@@ -27,7 +27,7 @@
 #include "psb_reg.h"
 #include "psb_intel_reg.h"
 #include "psb_powermgmt.h"
-
+#include "mdfld_output.h"
 
 /*
  * inline functions
@@ -455,6 +455,11 @@ int psb_enable_vblank(struct drm_device *dev, int pipe)
 	uint32_t reg_val = 0;
 	uint32_t pipeconf_reg = mid_pipeconf(pipe);
 
+	/* Medfield is different - we should perhaps extract out vblank
+	   and blacklight etc ops */
+	if (IS_MFLD(dev) && !mdfld_panel_dpi(dev))
+		return mdfld_enable_te(dev, pipe);
+
 	if (gma_power_begin(dev, false)) {
 		reg_val = REG_READ(pipeconf_reg);
 		gma_power_end(dev);
@@ -481,6 +486,8 @@ void psb_disable_vblank(struct drm_device *dev, int pipe)
 	struct drm_psb_private *dev_priv = dev->dev_private;
 	unsigned long irqflags;
 
+	if (IS_MFLD(dev) && !mdfld_panel_dpi(dev))
+		mdfld_disable_te(dev, pipe);
 	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
 
 	mid_disable_pipe_event(dev_priv, pipe);
@@ -489,6 +496,58 @@ void psb_disable_vblank(struct drm_device *dev, int pipe)
 	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
 }
 
+/**
+ *	mdfld_enable_te		-	enable TE events
+ *	@dev: our DRM device
+ *	@pipe: which pipe to work on
+ *
+ *	Enable TE events on a Medfield display pipe. Medfield specific.
+ */
+int mdfld_enable_te(struct drm_device *dev, int pipe)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	unsigned long flags;
+	uint32_t reg_val = 0;
+	uint32_t pipeconf_reg = mid_pipeconf(pipe);
+
+	if (gma_power_begin(dev, false)) {
+		reg_val = REG_READ(pipeconf_reg);
+		gma_power_end(dev);
+	}
+
+	if (!(reg_val & PIPEACONF_ENABLE))
+		return -EINVAL;
+
+	spin_lock_irqsave(&dev_priv->irqmask_lock, flags);
+
+	mid_enable_pipe_event(dev_priv, pipe);
+	psb_enable_pipestat(dev_priv, pipe, PIPE_TE_ENABLE);
+
+	spin_unlock_irqrestore(&dev_priv->irqmask_lock, flags);
+
+	return 0;
+}
+
+/**
+ *	mdfld_disable_te		-	disable TE events
+ *	@dev: our DRM device
+ *	@pipe: which pipe to work on
+ *
+ *	Disable TE events on a Medfield display pipe. Medfield specific.
+ */
+void mdfld_disable_te(struct drm_device *dev, int pipe)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev_priv->irqmask_lock, flags);
+
+	mid_disable_pipe_event(dev_priv, pipe);
+	psb_disable_pipestat(dev_priv, pipe, PIPE_TE_ENABLE);
+
+	spin_unlock_irqrestore(&dev_priv->irqmask_lock, flags);
+}
+
 /* Called from drm generic code, passed a 'crtc', which
  * we use as a pipe index
  */
diff --git a/drivers/staging/gma500/psb_powermgmt.c b/drivers/staging/gma500/psb_powermgmt.c
index 50f2234..f837ab0 100644
--- a/drivers/staging/gma500/psb_powermgmt.c
+++ b/drivers/staging/gma500/psb_powermgmt.c
@@ -31,8 +31,16 @@
 #include "psb_drv.h"
 #include "psb_reg.h"
 #include "psb_intel_reg.h"
+#include "mdfld_output.h"
+#include "mdfld_dsi_output.h"
 #include <linux/mutex.h>
 #include <linux/pm_runtime.h>
+#include <asm/intel_scu_ipc.h>
+
+/* IPC message and command defines used to enable/disable mipi panel voltages */
+#define IPC_MSG_PANEL_ON_OFF    0xE9
+#define IPC_CMD_PANEL_ON        1
+#define IPC_CMD_PANEL_OFF       0
 
 static struct mutex power_mutex;
 
@@ -46,6 +54,8 @@ void gma_power_init(struct drm_device *dev)
 {
 	struct drm_psb_private *dev_priv = dev->dev_private;
 
+	/* FIXME: need to sort out fetching apm_reg for both platforms ?? */
+
 	dev_priv->apm_base = dev_priv->apm_reg & 0xffff;
 	dev_priv->ospm_base &= 0xffff;
 
@@ -154,6 +164,521 @@ static int restore_display_registers(struct drm_device *dev)
 }
 
 /**
+ * mdfld_save_display_registers	-	save registers for pipe
+ * @dev: our device
+ * @pipe: pipe to save
+ *
+ * Save the pipe state of the device before we power it off. Keep everything
+ * we need to put it back again
+ */
+static int mdfld_save_display_registers(struct drm_device *dev, int pipe)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int i;
+
+	/* register */
+	u32 dpll_reg = MRST_DPLL_A;
+	u32 fp_reg = MRST_FPA0;
+	u32 pipeconf_reg = PIPEACONF;
+	u32 htot_reg = HTOTAL_A;
+	u32 hblank_reg = HBLANK_A;
+	u32 hsync_reg = HSYNC_A;
+	u32 vtot_reg = VTOTAL_A;
+	u32 vblank_reg = VBLANK_A;
+	u32 vsync_reg = VSYNC_A;
+	u32 pipesrc_reg = PIPEASRC;
+	u32 dspstride_reg = DSPASTRIDE;
+	u32 dsplinoff_reg = DSPALINOFF;
+	u32 dsptileoff_reg = DSPATILEOFF;
+	u32 dspsize_reg = DSPASIZE;
+	u32 dsppos_reg = DSPAPOS;
+	u32 dspsurf_reg = DSPASURF;
+	u32 mipi_reg = MIPI;
+	u32 dspcntr_reg = DSPACNTR;
+	u32 dspstatus_reg = PIPEASTAT;
+	u32 palette_reg = PALETTE_A;
+
+	/* pointer to values */
+	u32 *dpll_val = &dev_priv->saveDPLL_A;
+	u32 *fp_val = &dev_priv->saveFPA0;
+	u32 *pipeconf_val = &dev_priv->savePIPEACONF;
+	u32 *htot_val = &dev_priv->saveHTOTAL_A;
+	u32 *hblank_val = &dev_priv->saveHBLANK_A;
+	u32 *hsync_val = &dev_priv->saveHSYNC_A;
+	u32 *vtot_val = &dev_priv->saveVTOTAL_A;
+	u32 *vblank_val = &dev_priv->saveVBLANK_A;
+	u32 *vsync_val = &dev_priv->saveVSYNC_A;
+	u32 *pipesrc_val = &dev_priv->savePIPEASRC;
+	u32 *dspstride_val = &dev_priv->saveDSPASTRIDE;
+	u32 *dsplinoff_val = &dev_priv->saveDSPALINOFF;
+	u32 *dsptileoff_val = &dev_priv->saveDSPATILEOFF;
+	u32 *dspsize_val = &dev_priv->saveDSPASIZE;
+	u32 *dsppos_val = &dev_priv->saveDSPAPOS;
+	u32 *dspsurf_val = &dev_priv->saveDSPASURF;
+	u32 *mipi_val = &dev_priv->saveMIPI;
+	u32 *dspcntr_val = &dev_priv->saveDSPACNTR;
+	u32 *dspstatus_val = &dev_priv->saveDSPASTATUS;
+	u32 *palette_val = dev_priv->save_palette_a;
+
+	switch (pipe) {
+	case 0:
+		break;
+	case 1:
+		/* register */
+		dpll_reg = MDFLD_DPLL_B;
+		fp_reg = MDFLD_DPLL_DIV0;
+		pipeconf_reg = PIPEBCONF;
+		htot_reg = HTOTAL_B;
+		hblank_reg = HBLANK_B;
+		hsync_reg = HSYNC_B;
+		vtot_reg = VTOTAL_B;
+		vblank_reg = VBLANK_B;
+		vsync_reg = VSYNC_B;
+		pipesrc_reg = PIPEBSRC;
+		dspstride_reg = DSPBSTRIDE;
+		dsplinoff_reg = DSPBLINOFF;
+		dsptileoff_reg = DSPBTILEOFF;
+		dspsize_reg = DSPBSIZE;
+		dsppos_reg = DSPBPOS;
+		dspsurf_reg = DSPBSURF;
+		dspcntr_reg = DSPBCNTR;
+		dspstatus_reg = PIPEBSTAT;
+		palette_reg = PALETTE_B;
+
+		/* values */
+		dpll_val = &dev_priv->saveDPLL_B;
+		fp_val = &dev_priv->saveFPB0;
+		pipeconf_val = &dev_priv->savePIPEBCONF;
+		htot_val = &dev_priv->saveHTOTAL_B;
+		hblank_val = &dev_priv->saveHBLANK_B;
+		hsync_val = &dev_priv->saveHSYNC_B;
+		vtot_val = &dev_priv->saveVTOTAL_B;
+		vblank_val = &dev_priv->saveVBLANK_B;
+		vsync_val = &dev_priv->saveVSYNC_B;
+		pipesrc_val = &dev_priv->savePIPEBSRC;
+		dspstride_val = &dev_priv->saveDSPBSTRIDE;
+		dsplinoff_val = &dev_priv->saveDSPBLINOFF;
+		dsptileoff_val = &dev_priv->saveDSPBTILEOFF;
+		dspsize_val = &dev_priv->saveDSPBSIZE;
+		dsppos_val = &dev_priv->saveDSPBPOS;
+		dspsurf_val = &dev_priv->saveDSPBSURF;
+		dspcntr_val = &dev_priv->saveDSPBCNTR;
+		dspstatus_val = &dev_priv->saveDSPBSTATUS;
+		palette_val = dev_priv->save_palette_b;
+		break;
+	case 2:
+		/* register */
+		pipeconf_reg = PIPECCONF;
+		htot_reg = HTOTAL_C;
+		hblank_reg = HBLANK_C;
+		hsync_reg = HSYNC_C;
+		vtot_reg = VTOTAL_C;
+		vblank_reg = VBLANK_C;
+		vsync_reg = VSYNC_C;
+		pipesrc_reg = PIPECSRC;
+		dspstride_reg = DSPCSTRIDE;
+		dsplinoff_reg = DSPCLINOFF;
+		dsptileoff_reg = DSPCTILEOFF;
+		dspsize_reg = DSPCSIZE;
+		dsppos_reg = DSPCPOS;
+		dspsurf_reg = DSPCSURF;
+		mipi_reg = MIPI_C;
+		dspcntr_reg = DSPCCNTR;
+		dspstatus_reg = PIPECSTAT;
+		palette_reg = PALETTE_C;
+
+		/* pointer to values */
+		pipeconf_val = &dev_priv->savePIPECCONF;
+		htot_val = &dev_priv->saveHTOTAL_C;
+		hblank_val = &dev_priv->saveHBLANK_C;
+		hsync_val = &dev_priv->saveHSYNC_C;
+		vtot_val = &dev_priv->saveVTOTAL_C;
+		vblank_val = &dev_priv->saveVBLANK_C;
+		vsync_val = &dev_priv->saveVSYNC_C;
+		pipesrc_val = &dev_priv->savePIPECSRC;
+		dspstride_val = &dev_priv->saveDSPCSTRIDE;
+		dsplinoff_val = &dev_priv->saveDSPCLINOFF;
+		dsptileoff_val = &dev_priv->saveDSPCTILEOFF;
+		dspsize_val = &dev_priv->saveDSPCSIZE;
+		dsppos_val = &dev_priv->saveDSPCPOS;
+		dspsurf_val = &dev_priv->saveDSPCSURF;
+		mipi_val = &dev_priv->saveMIPI_C;
+		dspcntr_val = &dev_priv->saveDSPCCNTR;
+		dspstatus_val = &dev_priv->saveDSPCSTATUS;
+		palette_val = dev_priv->save_palette_c;
+		break;
+	default:
+		DRM_ERROR("%s, invalid pipe number.\n", __func__);
+		return -EINVAL;
+	}
+
+	/* Pipe & plane A info */
+	*dpll_val = PSB_RVDC32(dpll_reg);
+	*fp_val = PSB_RVDC32(fp_reg);
+	*pipeconf_val = PSB_RVDC32(pipeconf_reg);
+	*htot_val = PSB_RVDC32(htot_reg);
+	*hblank_val = PSB_RVDC32(hblank_reg);
+	*hsync_val = PSB_RVDC32(hsync_reg);
+	*vtot_val = PSB_RVDC32(vtot_reg);
+	*vblank_val = PSB_RVDC32(vblank_reg);
+	*vsync_val = PSB_RVDC32(vsync_reg);
+	*pipesrc_val = PSB_RVDC32(pipesrc_reg);
+	*dspstride_val = PSB_RVDC32(dspstride_reg);
+	*dsplinoff_val = PSB_RVDC32(dsplinoff_reg);
+	*dsptileoff_val = PSB_RVDC32(dsptileoff_reg);
+	*dspsize_val = PSB_RVDC32(dspsize_reg);
+	*dsppos_val = PSB_RVDC32(dsppos_reg);
+	*dspsurf_val = PSB_RVDC32(dspsurf_reg);
+	*dspcntr_val = PSB_RVDC32(dspcntr_reg);
+	*dspstatus_val = PSB_RVDC32(dspstatus_reg);
+
+	/*save palette (gamma) */
+	for (i = 0; i < 256; i++)
+		palette_val[i] = PSB_RVDC32(palette_reg + (i<<2));
+
+	if (pipe == 1) {
+		dev_priv->savePFIT_CONTROL = PSB_RVDC32(PFIT_CONTROL);
+		dev_priv->savePFIT_PGM_RATIOS = PSB_RVDC32(PFIT_PGM_RATIOS);
+		dev_priv->saveHDMIPHYMISCCTL = PSB_RVDC32(HDMIPHYMISCCTL);
+		dev_priv->saveHDMIB_CONTROL = PSB_RVDC32(HDMIB_CONTROL);
+		return 0;
+	}
+	*mipi_val = PSB_RVDC32(mipi_reg);
+	return 0;
+}
+
+/**
+ * mdfld_save_cursor_overlay_registers	-	save cursor overlay info
+ * @dev: our device
+ *
+ * Save the cursor and overlay register state
+ */
+static int mdfld_save_cursor_overlay_registers(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	/* Save cursor regs */
+	dev_priv->saveDSPACURSOR_CTRL = PSB_RVDC32(CURACNTR);
+	dev_priv->saveDSPACURSOR_BASE = PSB_RVDC32(CURABASE);
+	dev_priv->saveDSPACURSOR_POS = PSB_RVDC32(CURAPOS);
+
+	dev_priv->saveDSPBCURSOR_CTRL = PSB_RVDC32(CURBCNTR);
+	dev_priv->saveDSPBCURSOR_BASE = PSB_RVDC32(CURBBASE);
+	dev_priv->saveDSPBCURSOR_POS = PSB_RVDC32(CURBPOS);
+
+	dev_priv->saveDSPCCURSOR_CTRL = PSB_RVDC32(CURCCNTR);
+	dev_priv->saveDSPCCURSOR_BASE = PSB_RVDC32(CURCBASE);
+	dev_priv->saveDSPCCURSOR_POS = PSB_RVDC32(CURCPOS);
+
+	/* HW overlay */
+	dev_priv->saveOV_OVADD = PSB_RVDC32(OV_OVADD);
+	dev_priv->saveOV_OGAMC0 = PSB_RVDC32(OV_OGAMC0);
+	dev_priv->saveOV_OGAMC1 = PSB_RVDC32(OV_OGAMC1);
+	dev_priv->saveOV_OGAMC2 = PSB_RVDC32(OV_OGAMC2);
+	dev_priv->saveOV_OGAMC3 = PSB_RVDC32(OV_OGAMC3);
+	dev_priv->saveOV_OGAMC4 = PSB_RVDC32(OV_OGAMC4);
+	dev_priv->saveOV_OGAMC5 = PSB_RVDC32(OV_OGAMC5);
+
+	dev_priv->saveOV_OVADD_C = PSB_RVDC32(OV_OVADD + OV_C_OFFSET);
+	dev_priv->saveOV_OGAMC0_C = PSB_RVDC32(OV_OGAMC0 + OV_C_OFFSET);
+	dev_priv->saveOV_OGAMC1_C = PSB_RVDC32(OV_OGAMC1 + OV_C_OFFSET);
+	dev_priv->saveOV_OGAMC2_C = PSB_RVDC32(OV_OGAMC2 + OV_C_OFFSET);
+	dev_priv->saveOV_OGAMC3_C = PSB_RVDC32(OV_OGAMC3 + OV_C_OFFSET);
+	dev_priv->saveOV_OGAMC4_C = PSB_RVDC32(OV_OGAMC4 + OV_C_OFFSET);
+	dev_priv->saveOV_OGAMC5_C = PSB_RVDC32(OV_OGAMC5 + OV_C_OFFSET);
+
+	return 0;
+}
+/*
+ * mdfld_restore_display_registers	-	restore the state of a pipe
+ * @dev: our device
+ * @pipe: the pipe to restore
+ *
+ * Restore the state of a pipe to that which was saved by the register save
+ * functions.
+ */
+static int mdfld_restore_display_registers(struct drm_device *dev, int pipe)
+{
+	/* To get  panel out of ULPS mode */
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct mdfld_dsi_config *dsi_config = NULL;
+	u32 i = 0;
+	u32 dpll = 0;
+	u32 timeout = 0;
+	u32 reg_offset = 0;
+
+	/* register */
+	u32 dpll_reg = MRST_DPLL_A;
+	u32 fp_reg = MRST_FPA0;
+	u32 pipeconf_reg = PIPEACONF;
+	u32 htot_reg = HTOTAL_A;
+	u32 hblank_reg = HBLANK_A;
+	u32 hsync_reg = HSYNC_A;
+	u32 vtot_reg = VTOTAL_A;
+	u32 vblank_reg = VBLANK_A;
+	u32 vsync_reg = VSYNC_A;
+	u32 pipesrc_reg = PIPEASRC;
+	u32 dspstride_reg = DSPASTRIDE;
+	u32 dsplinoff_reg = DSPALINOFF;
+	u32 dsptileoff_reg = DSPATILEOFF;
+	u32 dspsize_reg = DSPASIZE;
+	u32 dsppos_reg = DSPAPOS;
+	u32 dspsurf_reg = DSPASURF;
+	u32 dspstatus_reg = PIPEASTAT;
+	u32 mipi_reg = MIPI;
+	u32 dspcntr_reg = DSPACNTR;
+	u32 palette_reg = PALETTE_A;
+
+	/* values */
+	u32 dpll_val = dev_priv->saveDPLL_A & ~DPLL_VCO_ENABLE;
+	u32 fp_val = dev_priv->saveFPA0;
+	u32 pipeconf_val = dev_priv->savePIPEACONF;
+	u32 htot_val = dev_priv->saveHTOTAL_A;
+	u32 hblank_val = dev_priv->saveHBLANK_A;
+	u32 hsync_val = dev_priv->saveHSYNC_A;
+	u32 vtot_val = dev_priv->saveVTOTAL_A;
+	u32 vblank_val = dev_priv->saveVBLANK_A;
+	u32 vsync_val = dev_priv->saveVSYNC_A;
+	u32 pipesrc_val = dev_priv->savePIPEASRC;
+	u32 dspstride_val = dev_priv->saveDSPASTRIDE;
+	u32 dsplinoff_val = dev_priv->saveDSPALINOFF;
+	u32 dsptileoff_val = dev_priv->saveDSPATILEOFF;
+	u32 dspsize_val = dev_priv->saveDSPASIZE;
+	u32 dsppos_val = dev_priv->saveDSPAPOS;
+	u32 dspsurf_val = dev_priv->saveDSPASURF;
+	u32 dspstatus_val = dev_priv->saveDSPASTATUS;
+	u32 mipi_val = dev_priv->saveMIPI;
+	u32 dspcntr_val = dev_priv->saveDSPACNTR;
+	u32 *palette_val = dev_priv->save_palette_a;
+
+	switch (pipe) {
+	case 0:
+		dsi_config = dev_priv->dsi_configs[0];
+		break;
+	case 1:
+		/* register */
+		dpll_reg = MDFLD_DPLL_B;
+		fp_reg = MDFLD_DPLL_DIV0;
+		pipeconf_reg = PIPEBCONF;
+		htot_reg = HTOTAL_B;
+		hblank_reg = HBLANK_B;
+		hsync_reg = HSYNC_B;
+		vtot_reg = VTOTAL_B;
+		vblank_reg = VBLANK_B;
+		vsync_reg = VSYNC_B;
+		pipesrc_reg = PIPEBSRC;
+		dspstride_reg = DSPBSTRIDE;
+		dsplinoff_reg = DSPBLINOFF;
+		dsptileoff_reg = DSPBTILEOFF;
+		dspsize_reg = DSPBSIZE;
+		dsppos_reg = DSPBPOS;
+		dspsurf_reg = DSPBSURF;
+		dspcntr_reg = DSPBCNTR;
+		palette_reg = PALETTE_B;
+		dspstatus_reg = PIPEBSTAT;
+
+		/* values */
+		dpll_val = dev_priv->saveDPLL_B & ~DPLL_VCO_ENABLE;
+		fp_val = dev_priv->saveFPB0;
+		pipeconf_val = dev_priv->savePIPEBCONF;
+		htot_val = dev_priv->saveHTOTAL_B;
+		hblank_val = dev_priv->saveHBLANK_B;
+		hsync_val = dev_priv->saveHSYNC_B;
+		vtot_val = dev_priv->saveVTOTAL_B;
+		vblank_val = dev_priv->saveVBLANK_B;
+		vsync_val = dev_priv->saveVSYNC_B;
+		pipesrc_val = dev_priv->savePIPEBSRC;
+		dspstride_val = dev_priv->saveDSPBSTRIDE;
+		dsplinoff_val = dev_priv->saveDSPBLINOFF;
+		dsptileoff_val = dev_priv->saveDSPBTILEOFF;
+		dspsize_val = dev_priv->saveDSPBSIZE;
+		dsppos_val = dev_priv->saveDSPBPOS;
+		dspsurf_val = dev_priv->saveDSPBSURF;
+		dspcntr_val = dev_priv->saveDSPBCNTR;
+		dspstatus_val = dev_priv->saveDSPBSTATUS;
+		palette_val = dev_priv->save_palette_b;
+		break;
+	case 2:
+		reg_offset = MIPIC_REG_OFFSET;
+
+		/* register */
+		pipeconf_reg = PIPECCONF;
+		htot_reg = HTOTAL_C;
+		hblank_reg = HBLANK_C;
+		hsync_reg = HSYNC_C;
+		vtot_reg = VTOTAL_C;
+		vblank_reg = VBLANK_C;
+		vsync_reg = VSYNC_C;
+		pipesrc_reg = PIPECSRC;
+		dspstride_reg = DSPCSTRIDE;
+		dsplinoff_reg = DSPCLINOFF;
+		dsptileoff_reg = DSPCTILEOFF;
+		dspsize_reg = DSPCSIZE;
+		dsppos_reg = DSPCPOS;
+		dspsurf_reg = DSPCSURF;
+		mipi_reg = MIPI_C;
+		dspcntr_reg = DSPCCNTR;
+		palette_reg = PALETTE_C;
+		dspstatus_reg = PIPECSTAT;
+
+		/* values */
+		pipeconf_val = dev_priv->savePIPECCONF;
+		htot_val = dev_priv->saveHTOTAL_C;
+		hblank_val = dev_priv->saveHBLANK_C;
+		hsync_val = dev_priv->saveHSYNC_C;
+		vtot_val = dev_priv->saveVTOTAL_C;
+		vblank_val = dev_priv->saveVBLANK_C;
+		vsync_val = dev_priv->saveVSYNC_C;
+		pipesrc_val = dev_priv->savePIPECSRC;
+		dspstride_val = dev_priv->saveDSPCSTRIDE;
+		dsplinoff_val = dev_priv->saveDSPCLINOFF;
+		dsptileoff_val = dev_priv->saveDSPCTILEOFF;
+		dspsize_val = dev_priv->saveDSPCSIZE;
+		dsppos_val = dev_priv->saveDSPCPOS;
+		dspsurf_val = dev_priv->saveDSPCSURF;
+		dspstatus_val = dev_priv->saveDSPCSTATUS;
+		mipi_val = dev_priv->saveMIPI_C;
+		dspcntr_val = dev_priv->saveDSPCCNTR;
+		palette_val = dev_priv->save_palette_c;
+
+		dsi_config = dev_priv->dsi_configs[1];
+		break;
+	default:
+		DRM_ERROR("%s, invalid pipe number.\n", __func__);
+		return -EINVAL;
+	}
+
+	/* Make sure VGA plane is off. it initializes to on after reset!*/
+	PSB_WVDC32(0x80000000, VGACNTRL);
+	if (pipe == 1) {
+		PSB_WVDC32(dpll_val & ~DPLL_VCO_ENABLE, dpll_reg);
+		PSB_RVDC32(dpll_reg);
+
+		PSB_WVDC32(fp_val, fp_reg);
+	} else {
+		dpll = PSB_RVDC32(dpll_reg);
+
+		if (!(dpll & DPLL_VCO_ENABLE)) {
+
+			/* When ungating power of DPLL, needs to wait 0.5us before enable the VCO */
+			if (dpll & MDFLD_PWR_GATE_EN) {
+				dpll &= ~MDFLD_PWR_GATE_EN;
+				PSB_WVDC32(dpll, dpll_reg);
+				udelay(500);	/* FIXME: 1 ? */
+			}
+
+			PSB_WVDC32(fp_val, fp_reg);
+			PSB_WVDC32(dpll_val, dpll_reg);
+			/* FIXME_MDFLD PO - change 500 to 1 after PO */
+			udelay(500);
+
+			dpll_val |= DPLL_VCO_ENABLE;
+			PSB_WVDC32(dpll_val, dpll_reg);
+			PSB_RVDC32(dpll_reg);
+
+			/* wait for DSI PLL to lock */
+			while ((timeout < 20000) && !(PSB_RVDC32(pipeconf_reg) & PIPECONF_DSIPLL_LOCK)) {
+				udelay(150);
+				timeout++;
+			}
+
+			if (timeout == 20000) {
+				DRM_ERROR("%s, can't lock DSIPLL.\n",
+							__func__);
+				return -EINVAL;
+			}
+		}
+	}
+	/* Restore mode */
+	PSB_WVDC32(htot_val, htot_reg);
+	PSB_WVDC32(hblank_val, hblank_reg);
+	PSB_WVDC32(hsync_val, hsync_reg);
+	PSB_WVDC32(vtot_val, vtot_reg);
+	PSB_WVDC32(vblank_val, vblank_reg);
+	PSB_WVDC32(vsync_val, vsync_reg);
+	PSB_WVDC32(pipesrc_val, pipesrc_reg);
+	PSB_WVDC32(dspstatus_val, dspstatus_reg);
+
+	/* Set up the plane */
+	PSB_WVDC32(dspstride_val, dspstride_reg);
+	PSB_WVDC32(dsplinoff_val, dsplinoff_reg);
+	PSB_WVDC32(dsptileoff_val, dsptileoff_reg);
+	PSB_WVDC32(dspsize_val, dspsize_reg);
+	PSB_WVDC32(dsppos_val, dsppos_reg);
+	PSB_WVDC32(dspsurf_val, dspsurf_reg);
+
+	if (pipe == 1) {
+		PSB_WVDC32(dev_priv->savePFIT_CONTROL, PFIT_CONTROL);
+		PSB_WVDC32(dev_priv->savePFIT_PGM_RATIOS, PFIT_PGM_RATIOS);
+		PSB_WVDC32(dev_priv->saveHDMIPHYMISCCTL, HDMIPHYMISCCTL);
+		PSB_WVDC32(dev_priv->saveHDMIB_CONTROL, HDMIB_CONTROL);
+
+	} else {
+		/* Set up pipe related registers */
+		PSB_WVDC32(mipi_val, mipi_reg);
+		/* Setup MIPI adapter + MIPI IP registers */
+		mdfld_dsi_controller_init(dsi_config, pipe);
+		msleep(20);
+	}
+	/* Enable the plane */
+	PSB_WVDC32(dspcntr_val, dspcntr_reg);
+	msleep(20);
+	/* Enable the pipe */
+	PSB_WVDC32(pipeconf_val, pipeconf_reg);
+
+	for (i = 0; i < 256; i++)
+		PSB_WVDC32(palette_val[i], palette_reg + (i<<2));
+	if (pipe == 1)
+		return 0;
+	if (IS_MFLD(dev) && !mdfld_panel_dpi(dev))
+		mdfld_enable_te(dev, pipe);
+	return 0;
+}
+
+/**
+ * mdfld_restore_cursor_overlay_registers	-	restore cursor
+ * @dev: our device
+ *
+ * Restore the cursor and overlay state that was saved earlier
+ */
+static int mdfld_restore_cursor_overlay_registers(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	/* Enable Cursor A */
+	PSB_WVDC32(dev_priv->saveDSPACURSOR_CTRL, CURACNTR);
+	PSB_WVDC32(dev_priv->saveDSPACURSOR_POS, CURAPOS);
+	PSB_WVDC32(dev_priv->saveDSPACURSOR_BASE, CURABASE);
+
+	PSB_WVDC32(dev_priv->saveDSPBCURSOR_CTRL, CURBCNTR);
+	PSB_WVDC32(dev_priv->saveDSPBCURSOR_POS, CURBPOS);
+	PSB_WVDC32(dev_priv->saveDSPBCURSOR_BASE, CURBBASE);
+
+	PSB_WVDC32(dev_priv->saveDSPCCURSOR_CTRL, CURCCNTR);
+	PSB_WVDC32(dev_priv->saveDSPCCURSOR_POS, CURCPOS);
+	PSB_WVDC32(dev_priv->saveDSPCCURSOR_BASE, CURCBASE);
+
+	/* Restore HW overlay */
+	PSB_WVDC32(dev_priv->saveOV_OVADD, OV_OVADD);
+	PSB_WVDC32(dev_priv->saveOV_OGAMC0, OV_OGAMC0);
+	PSB_WVDC32(dev_priv->saveOV_OGAMC1, OV_OGAMC1);
+	PSB_WVDC32(dev_priv->saveOV_OGAMC2, OV_OGAMC2);
+	PSB_WVDC32(dev_priv->saveOV_OGAMC3, OV_OGAMC3);
+	PSB_WVDC32(dev_priv->saveOV_OGAMC4, OV_OGAMC4);
+	PSB_WVDC32(dev_priv->saveOV_OGAMC5, OV_OGAMC5);
+
+	PSB_WVDC32(dev_priv->saveOV_OVADD_C, OV_OVADD + OV_C_OFFSET);
+	PSB_WVDC32(dev_priv->saveOV_OGAMC0_C, OV_OGAMC0 + OV_C_OFFSET);
+	PSB_WVDC32(dev_priv->saveOV_OGAMC1_C, OV_OGAMC1 + OV_C_OFFSET);
+	PSB_WVDC32(dev_priv->saveOV_OGAMC2_C, OV_OGAMC2 + OV_C_OFFSET);
+	PSB_WVDC32(dev_priv->saveOV_OGAMC3_C, OV_OGAMC3 + OV_C_OFFSET);
+	PSB_WVDC32(dev_priv->saveOV_OGAMC4_C, OV_OGAMC4 + OV_C_OFFSET);
+	PSB_WVDC32(dev_priv->saveOV_OGAMC5_C, OV_OGAMC5 + OV_C_OFFSET);
+
+	return 0;
+}
+
+/**
  *	power_down	-	power down the display island
  *	@dev: our DRM device
  *
@@ -186,6 +711,10 @@ static void power_down(struct drm_device *dev)
  *	@dev: our DRM device
  *
  *	Suspend the display logic of the graphics interface
+ *
+ *	FIXME: This ought to be replaced by a dev_priv-> ops interface
+ *	where the various platforms register their save/restore methods
+ *	and keep them in their own support files.
  */
 static void gma_suspend_display(struct drm_device *dev)
 {
@@ -195,38 +724,57 @@ static void gma_suspend_display(struct drm_device *dev)
 	if (dev_priv->suspended)
 		return;
 
-	save_display_registers(dev);
-
-	if (dev_priv->iLVDS_enable) {
-		/*shutdown the panel*/
-		PSB_WVDC32(0, PP_CONTROL);
-
-		do {
-			pp_stat = PSB_RVDC32(PP_STATUS);
-		} while (pp_stat & 0x80000000);
-
-		/*turn off the plane*/
-		PSB_WVDC32(0x58000000, DSPACNTR);
-		PSB_WVDC32(0, DSPASURF);/*trigger the plane disable*/
-		/*wait ~4 ticks*/
-		msleep(4);
-
-		/*turn off pipe*/
-		PSB_WVDC32(0x0, PIPEACONF);
-		/*wait ~8 ticks*/
-		msleep(8);
-
-		/*turn off PLLs*/
-		PSB_WVDC32(0, MRST_DPLL_A);
+	if (IS_MFLD(dev)) {
+		/* FIXME: We need to shut down panels here if using them
+		   and once the right bits are merged */
+		mdfld_save_cursor_overlay_registers(dev);
+		mdfld_save_display_registers(dev, 0);
+		mdfld_save_display_registers(dev, 0);
+		mdfld_save_display_registers(dev, 2);
+		mdfld_save_display_registers(dev, 1);
+		mdfld_disable_crtc(dev, 0);
+		mdfld_disable_crtc(dev, 2);
+		mdfld_disable_crtc(dev, 1);
 	} else {
-		PSB_WVDC32(DPI_SHUT_DOWN, DPI_CONTROL_REG);
-		PSB_WVDC32(0x0, PIPEACONF);
-		PSB_WVDC32(0x2faf0000, BLC_PWM_CTL);
-		while (REG_READ(0x70008) & 0x40000000);
-		while ((PSB_RVDC32(GEN_FIFO_STAT_REG) & DPI_FIFO_EMPTY)
-			!= DPI_FIFO_EMPTY);
-		PSB_WVDC32(0, DEVICE_READY_REG);
-			/* turn off panel power */
+		save_display_registers(dev);
+
+		if (dev_priv->iLVDS_enable) {
+			/*shutdown the panel*/
+			PSB_WVDC32(0, PP_CONTROL);
+
+			do {
+				pp_stat = PSB_RVDC32(PP_STATUS);
+			} while (pp_stat & 0x80000000);
+
+			/* Turn off the plane */
+			PSB_WVDC32(0x58000000, DSPACNTR);
+			PSB_WVDC32(0, DSPASURF);/*trigger the plane disable*/
+			/* Wait ~4 ticks */
+			msleep(4);
+
+			/* Turn off pipe */
+			PSB_WVDC32(0x0, PIPEACONF);
+			/* Wait ~8 ticks */
+			msleep(8);
+
+			/* Turn off PLLs */
+			PSB_WVDC32(0, MRST_DPLL_A);
+		} else {
+			PSB_WVDC32(DPI_SHUT_DOWN, DPI_CONTROL_REG);
+			PSB_WVDC32(0x0, PIPEACONF);
+			PSB_WVDC32(0x2faf0000, BLC_PWM_CTL);
+			while (REG_READ(0x70008) & 0x40000000)
+				cpu_relax();
+			while ((PSB_RVDC32(GEN_FIFO_STAT_REG) & DPI_FIFO_EMPTY)
+				!= DPI_FIFO_EMPTY)
+				cpu_relax();
+			PSB_WVDC32(0, DEVICE_READY_REG);
+			/* Turn off panel power */
+#ifdef CONFIG_X86_MRST
+			intel_scu_ipc_simple_command(IPC_MSG_PANEL_ON_OFF,
+							IPC_CMD_PANEL_OFF);
+#endif
+		}
 	}
 	power_down(dev);
 }
@@ -286,7 +834,21 @@ static void gma_resume_display(struct pci_dev *pdev)
 	 * above.
 	 */
 	/*psb_gtt_init(dev_priv->pg, 1);*/
-
+	if (IS_MFLD(dev)) {
+		mdfld_restore_display_registers(dev, 1);
+		mdfld_restore_display_registers(dev, 0);
+		mdfld_restore_display_registers(dev, 2);
+		mdfld_restore_cursor_overlay_registers(dev);
+	} else if (IS_MRST(dev)) {
+		if (!dev_priv->iLVDS_enable) {
+#ifdef CONFIG_X86_MRST
+			intel_scu_ipc_simple_command(IPC_MSG_PANEL_ON_OFF,
+							IPC_CMD_PANEL_ON);
+			/* FIXME: can we avoid this delay ? */
+			msleep(2000); /* wait 2 seconds */
+#endif
+		}
+	}
 	restore_display_registers(dev);
 }
 

