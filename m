Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1BVMkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 07:40:15 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35972 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751695Ab1BVMj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 07:39:59 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] gma500: Intel GMA500 staging driver
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 22 Feb 2011 12:17:46 +0000
Message-ID: <20110222121704.19437.4650.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an initial staging driver for the GMA500. It's been stripped out
of the PVR drivers and crunched together from various bits of code and
different kernels.

Currently it's unaccelerated but still pretty snappy even compositing with
the frame buffer X server.

Lots of work is needed to rework the ttm and bo interfaces from being
ripped out and then 2D acceleration wants putting back for framebuffer and
somehow eventually via DRM.

There is no support for the parts without open source userspace (video
accelerators, 3D) as per kernel policy.

I'm not a DRM expert so if there is anyone with a GMA500 who actually knows
something about DRI internals then help would be most welcome.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/Kconfig                         |    2 
 drivers/staging/Makefile                        |    9 
 drivers/staging/gma500/Kconfig                  |   12 
 drivers/staging/gma500/Makefile                 |   30 
 drivers/staging/gma500/psb_bl.c                 |  167 ++
 drivers/staging/gma500/psb_buffer.c             |  450 ++++++
 drivers/staging/gma500/psb_drm.h                |  696 ++++++++++
 drivers/staging/gma500/psb_drv.c                | 1677 +++++++++++++++++++++++
 drivers/staging/gma500/psb_drv.h                | 1139 ++++++++++++++++
 drivers/staging/gma500/psb_fb.c                 |  840 ++++++++++++
 drivers/staging/gma500/psb_fb.h                 |   59 +
 drivers/staging/gma500/psb_fence.c              |  122 ++
 drivers/staging/gma500/psb_gfx.mod.c            |   27 
 drivers/staging/gma500/psb_gtt.c                | 1034 ++++++++++++++
 drivers/staging/gma500/psb_gtt.h                |  105 +
 drivers/staging/gma500/psb_intel_bios.c         |  301 ++++
 drivers/staging/gma500/psb_intel_bios.h         |  430 ++++++
 drivers/staging/gma500/psb_intel_display.c      | 1489 ++++++++++++++++++++
 drivers/staging/gma500/psb_intel_display.h      |   25 
 drivers/staging/gma500/psb_intel_drv.h          |  247 +++
 drivers/staging/gma500/psb_intel_i2c.c          |  169 ++
 drivers/staging/gma500/psb_intel_lvds.c         |  889 ++++++++++++
 drivers/staging/gma500/psb_intel_modes.c        |   77 +
 drivers/staging/gma500/psb_intel_opregion.c     |   78 +
 drivers/staging/gma500/psb_intel_reg.h          | 1200 ++++++++++++++++
 drivers/staging/gma500/psb_intel_sdvo.c         | 1298 ++++++++++++++++++
 drivers/staging/gma500/psb_intel_sdvo_regs.h    |  338 +++++
 drivers/staging/gma500/psb_irq.c                |  637 +++++++++
 drivers/staging/gma500/psb_irq.h                |   49 +
 drivers/staging/gma500/psb_mmu.c                |  919 +++++++++++++
 drivers/staging/gma500/psb_powermgmt.c          |  797 +++++++++++
 drivers/staging/gma500/psb_powermgmt.h          |   96 +
 drivers/staging/gma500/psb_pvr_glue.c           |   73 +
 drivers/staging/gma500/psb_pvr_glue.h           |   25 
 drivers/staging/gma500/psb_reg.h                |  588 ++++++++
 drivers/staging/gma500/psb_reset.c              |   90 +
 drivers/staging/gma500/psb_sgx.c                |  238 +++
 drivers/staging/gma500/psb_sgx.h                |   32 
 drivers/staging/gma500/psb_ttm_fence.c          |  605 ++++++++
 drivers/staging/gma500/psb_ttm_fence_api.h      |  272 ++++
 drivers/staging/gma500/psb_ttm_fence_driver.h   |  302 ++++
 drivers/staging/gma500/psb_ttm_fence_user.c     |  237 +++
 drivers/staging/gma500/psb_ttm_fence_user.h     |  140 ++
 drivers/staging/gma500/psb_ttm_glue.c           |  349 +++++
 drivers/staging/gma500/psb_ttm_placement_user.c |  628 +++++++++
 drivers/staging/gma500/psb_ttm_placement_user.h |  252 +++
 drivers/staging/gma500/psb_ttm_userobj_api.h    |   85 +
 47 files changed, 19320 insertions(+), 4 deletions(-)
 create mode 100644 drivers/staging/gma500/Kconfig
 create mode 100644 drivers/staging/gma500/Makefile
 create mode 100644 drivers/staging/gma500/psb_bl.c
 create mode 100644 drivers/staging/gma500/psb_buffer.c
 create mode 100644 drivers/staging/gma500/psb_drm.h
 create mode 100644 drivers/staging/gma500/psb_drv.c
 create mode 100644 drivers/staging/gma500/psb_drv.h
 create mode 100644 drivers/staging/gma500/psb_fb.c
 create mode 100644 drivers/staging/gma500/psb_fb.h
 create mode 100644 drivers/staging/gma500/psb_fence.c
 create mode 100644 drivers/staging/gma500/psb_gfx.mod.c
 create mode 100644 drivers/staging/gma500/psb_gtt.c
 create mode 100644 drivers/staging/gma500/psb_gtt.h
 create mode 100644 drivers/staging/gma500/psb_intel_bios.c
 create mode 100644 drivers/staging/gma500/psb_intel_bios.h
 create mode 100644 drivers/staging/gma500/psb_intel_display.c
 create mode 100644 drivers/staging/gma500/psb_intel_display.h
 create mode 100644 drivers/staging/gma500/psb_intel_drv.h
 create mode 100644 drivers/staging/gma500/psb_intel_i2c.c
 create mode 100644 drivers/staging/gma500/psb_intel_lvds.c
 create mode 100644 drivers/staging/gma500/psb_intel_modes.c
 create mode 100644 drivers/staging/gma500/psb_intel_opregion.c
 create mode 100644 drivers/staging/gma500/psb_intel_reg.h
 create mode 100644 drivers/staging/gma500/psb_intel_sdvo.c
 create mode 100644 drivers/staging/gma500/psb_intel_sdvo_regs.h
 create mode 100644 drivers/staging/gma500/psb_irq.c
 create mode 100644 drivers/staging/gma500/psb_irq.h
 create mode 100644 drivers/staging/gma500/psb_mmu.c
 create mode 100644 drivers/staging/gma500/psb_powermgmt.c
 create mode 100644 drivers/staging/gma500/psb_powermgmt.h
 create mode 100644 drivers/staging/gma500/psb_pvr_glue.c
 create mode 100644 drivers/staging/gma500/psb_pvr_glue.h
 create mode 100644 drivers/staging/gma500/psb_reg.h
 create mode 100644 drivers/staging/gma500/psb_reset.c
 create mode 100644 drivers/staging/gma500/psb_sgx.c
 create mode 100644 drivers/staging/gma500/psb_sgx.h
 create mode 100644 drivers/staging/gma500/psb_ttm_fence.c
 create mode 100644 drivers/staging/gma500/psb_ttm_fence_api.h
 create mode 100644 drivers/staging/gma500/psb_ttm_fence_driver.h
 create mode 100644 drivers/staging/gma500/psb_ttm_fence_user.c
 create mode 100644 drivers/staging/gma500/psb_ttm_fence_user.h
 create mode 100644 drivers/staging/gma500/psb_ttm_glue.c
 create mode 100644 drivers/staging/gma500/psb_ttm_placement_user.c
 create mode 100644 drivers/staging/gma500/psb_ttm_placement_user.h
 create mode 100644 drivers/staging/gma500/psb_ttm_userobj_api.h

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 8da4531..1da2ce2 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -192,5 +192,7 @@ source "drivers/staging/cptm1217/Kconfig"
 
 source "drivers/staging/ste_rmi4/Kconfig"
 
+source "drivers/staging/gma500/Kconfig"
+
 endif # !STAGING_EXCLUDE_BUILD
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 35704b4..ab38da6 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -62,12 +62,13 @@ obj-$(CONFIG_SOLO6X10)		+= solo6x10/
 obj-$(CONFIG_TIDSPBRIDGE)	+= tidspbridge/
 obj-$(CONFIG_ACPI_QUICKSTART)	+= quickstart/
 obj-$(CONFIG_WESTBRIDGE_ASTORIA)	+= westbridge/astoria/
-obj-$(CONFIG_SBE_2T3E3)	+= sbe-2t3e3/
+obj-$(CONFIG_SBE_2T3E3)		+= sbe-2t3e3/
 obj-$(CONFIG_ATH6K_LEGACY)	+= ath6kl/
 obj-$(CONFIG_USB_ENESTORAGE)	+= keucr/
-obj-$(CONFIG_BCM_WIMAX)	+= bcm/
+obj-$(CONFIG_BCM_WIMAX)		+= bcm/
 obj-$(CONFIG_FT1000)		+= ft1000/
-obj-$(CONFIG_SND_INTEL_SST)		+= intel_sst/
-obj-$(CONFIG_SPEAKUP)	+= speakup/
+obj-$(CONFIG_SND_INTEL_SST)	+= intel_sst/
+obj-$(CONFIG_SPEAKUP)		+= speakup/
 obj-$(CONFIG_TOUCHSCREEN_CLEARPAD_TM1217)	+= cptm1217/
 obj-$(CONFIG_TOUCHSCREEN_SYNAPTICS_I2C_RMI4)	+= ste_rmi4/
+obj-$(CONFIG_DRM_PSB)		+= gma500/
diff --git a/drivers/staging/gma500/Kconfig b/drivers/staging/gma500/Kconfig
new file mode 100644
index 0000000..5501eb9
--- /dev/null
+++ b/drivers/staging/gma500/Kconfig
@@ -0,0 +1,12 @@
+config DRM_PSB
+	tristate "Intel GMA500 KMS Framebuffer"
+	depends on DRM && PCI
+	select FB_CFB_COPYAREA
+        select FB_CFB_FILLRECT
+        select FB_CFB_IMAGEBLIT
+        select DRM_KMS_HELPER
+        select DRM_TTM
+	help
+	  Say yes for an experimental KMS framebuffer driver for the
+	  Intel GMA500 ('Poulsbo') graphics support.
+
diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
new file mode 100644
index 0000000..21381eb
--- /dev/null
+++ b/drivers/staging/gma500/Makefile
@@ -0,0 +1,30 @@
+#
+#	KMS driver for the GMA500
+#
+ccflags-y += -Iinclude/drm
+
+psb_gfx-y += psb_bl.o \
+	  psb_drv.o \
+	  psb_fb.o \
+	  psb_gtt.o \
+	  psb_intel_bios.o \
+	  psb_intel_opregion.o \
+	  psb_intel_display.o \
+	  psb_intel_i2c.o \
+	  psb_intel_lvds.o \
+	  psb_intel_modes.o \
+	  psb_intel_sdvo.o \
+	  psb_reset.o \
+	  psb_sgx.o \
+	  psb_pvr_glue.o \
+	  psb_buffer.o \
+	  psb_fence.o \
+	  psb_mmu.o \
+	  psb_ttm_glue.o \
+	  psb_ttm_fence.o \
+	  psb_ttm_fence_user.o \
+	  psb_ttm_placement_user.o \
+	  psb_powermgmt.o \
+	  psb_irq.o
+
+obj-$(CONFIG_DRM_PSB) += psb_gfx.o
diff --git a/drivers/staging/gma500/psb_bl.c b/drivers/staging/gma500/psb_bl.c
new file mode 100644
index 0000000..52edb43
--- /dev/null
+++ b/drivers/staging/gma500/psb_bl.c
@@ -0,0 +1,167 @@
+/*
+ *  psb backlight using HAL
+ *
+ * Copyright (c) 2009, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors: Eric Knopp
+ *
+ */
+
+#include <linux/backlight.h>
+#include <linux/version.h>
+#include "psb_drv.h"
+#include "psb_intel_reg.h"
+#include "psb_intel_drv.h"
+#include "psb_intel_bios.h"
+#include "psb_powermgmt.h"
+
+#define MRST_BLC_MAX_PWM_REG_FREQ	    0xFFFF
+#define BLC_PWM_PRECISION_FACTOR 100	/* 10000000 */
+#define BLC_PWM_FREQ_CALC_CONSTANT 32
+#define MHz 1000000
+#define BRIGHTNESS_MIN_LEVEL 1
+#define BRIGHTNESS_MAX_LEVEL 100
+#define BRIGHTNESS_MASK	0xFF
+#define BLC_POLARITY_NORMAL 0
+#define BLC_POLARITY_INVERSE 1
+#define BLC_ADJUSTMENT_MAX 100
+
+#define PSB_BLC_PWM_PRECISION_FACTOR    10
+#define PSB_BLC_MAX_PWM_REG_FREQ        0xFFFE
+#define PSB_BLC_MIN_PWM_REG_FREQ        0x2
+
+#define PSB_BACKLIGHT_PWM_POLARITY_BIT_CLEAR (0xFFFE)
+#define PSB_BACKLIGHT_PWM_CTL_SHIFT	(16)
+
+static int psb_brightness;
+static struct backlight_device *psb_backlight_device;
+static u8 blc_brightnesscmd;
+static u8 blc_pol;
+static u8 blc_type;
+
+int psb_set_brightness(struct backlight_device *bd)
+{
+	struct drm_device *dev = bl_get_data(psb_backlight_device);
+	int level = bd->props.brightness;
+
+	DRM_DEBUG_DRIVER("backlight level set to %d\n", level);
+
+	/* Perform value bounds checking */
+	if (level < BRIGHTNESS_MIN_LEVEL)
+		level = BRIGHTNESS_MIN_LEVEL;
+
+	psb_intel_lvds_set_brightness(dev, level);
+	psb_brightness = level;
+	return 0;
+}
+
+int psb_get_brightness(struct backlight_device *bd)
+{
+	DRM_DEBUG_DRIVER("brightness = 0x%x\n", psb_brightness);
+
+	/* return locally cached var instead of HW read (due to DPST etc.) */
+	return psb_brightness;
+}
+
+static const struct backlight_ops psb_ops = {
+	.get_brightness = psb_get_brightness,
+	.update_status  = psb_set_brightness,
+};
+
+static int device_backlight_init(struct drm_device *dev)
+{
+	unsigned long CoreClock;
+	/* u32 bl_max_freq; */
+	/* unsigned long value; */
+	u16 bl_max_freq;
+	uint32_t value;
+	uint32_t blc_pwm_precision_factor;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	/* get bl_max_freq and pol from dev_priv*/
+	if (!dev_priv->lvds_bl) {
+		DRM_ERROR("Has no valid LVDS backlight info\n");
+		return 1;
+	}
+	bl_max_freq = dev_priv->lvds_bl->freq;
+	blc_pol = dev_priv->lvds_bl->pol;
+	blc_pwm_precision_factor = PSB_BLC_PWM_PRECISION_FACTOR;
+	blc_brightnesscmd = dev_priv->lvds_bl->brightnesscmd;
+	blc_type = dev_priv->lvds_bl->type;
+
+	CoreClock = dev_priv->core_freq;
+
+	value = (CoreClock * MHz) / BLC_PWM_FREQ_CALC_CONSTANT;
+	value *= blc_pwm_precision_factor;
+	value /= bl_max_freq;
+	value /= blc_pwm_precision_factor;
+
+	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+						OSPM_UHB_ONLY_IF_ON)) {
+		/* Check: may be MFLD only */
+		if (
+		 value > (unsigned long long)PSB_BLC_MAX_PWM_REG_FREQ ||
+		 value < (unsigned long long)PSB_BLC_MIN_PWM_REG_FREQ)
+			return 2;
+		else {
+			value &= PSB_BACKLIGHT_PWM_POLARITY_BIT_CLEAR;
+			REG_WRITE(BLC_PWM_CTL,
+				(value << PSB_BACKLIGHT_PWM_CTL_SHIFT) |
+				(value));
+		}
+		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	}
+	return 0;
+}
+
+int psb_backlight_init(struct drm_device *dev)
+{
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+	int ret = 0;
+
+	struct backlight_properties props;
+	memset(&props, 0, sizeof(struct backlight_properties));
+	props.max_brightness = BRIGHTNESS_MAX_LEVEL;
+
+	psb_backlight_device = backlight_device_register("psb-bl", NULL,
+						(void *)dev, &psb_ops, &props);
+	if (IS_ERR(psb_backlight_device))
+		return PTR_ERR(psb_backlight_device);
+
+	ret = device_backlight_init(dev);
+	if (ret < 0)
+		return ret;
+
+	psb_backlight_device->props.brightness = BRIGHTNESS_MAX_LEVEL;
+	psb_backlight_device->props.max_brightness = BRIGHTNESS_MAX_LEVEL;
+	backlight_update_status(psb_backlight_device);
+#endif
+	return 0;
+}
+
+void psb_backlight_exit(void)
+{
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+	psb_backlight_device->props.brightness = 0;
+	backlight_update_status(psb_backlight_device);
+	backlight_device_unregister(psb_backlight_device);
+#endif
+}
+
+struct backlight_device *psb_get_backlight_device(void)
+{
+	return psb_backlight_device;
+}
diff --git a/drivers/staging/gma500/psb_buffer.c b/drivers/staging/gma500/psb_buffer.c
new file mode 100644
index 0000000..3077f6a
--- /dev/null
+++ b/drivers/staging/gma500/psb_buffer.c
@@ -0,0 +1,450 @@
+/**************************************************************************
+ * Copyright (c) 2007, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics.com>
+ */
+#include "ttm/ttm_placement.h"
+#include "ttm/ttm_execbuf_util.h"
+#include "psb_ttm_fence_api.h"
+#include <drm/drmP.h>
+#include "psb_drv.h"
+
+#define DRM_MEM_TTM       26
+
+struct drm_psb_ttm_backend {
+	struct ttm_backend base;
+	struct page **pages;
+	unsigned int desired_tile_stride;
+	unsigned int hw_tile_stride;
+	int mem_type;
+	unsigned long offset;
+	unsigned long num_pages;
+};
+
+/*
+ * MSVDX/TOPAZ GPU virtual space looks like this
+ * (We currently use only one MMU context).
+ * PSB_MEM_MMU_START: from 0x00000000~0xe000000, for generic buffers
+ * TTM_PL_CI: from 0xe0000000+half GTT space, for camear/video buffer sharing
+ * TTM_PL_RAR: from TTM_PL_CI+CI size, for RAR/video buffer sharing
+ * TTM_PL_TT: from TTM_PL_RAR+RAR size, for buffers need to mapping into GTT
+ */
+static int psb_init_mem_type(struct ttm_bo_device *bdev, uint32_t type,
+			     struct ttm_mem_type_manager *man)
+{
+
+	struct drm_psb_private *dev_priv =
+	    container_of(bdev, struct drm_psb_private, bdev);
+	struct psb_gtt *pg = dev_priv->pg;
+
+	switch (type) {
+	case TTM_PL_SYSTEM:
+		man->flags = TTM_MEMTYPE_FLAG_MAPPABLE;
+		man->available_caching = TTM_PL_FLAG_CACHED |
+		    TTM_PL_FLAG_UNCACHED | TTM_PL_FLAG_WC;
+		man->default_caching = TTM_PL_FLAG_CACHED;
+		break;
+	case DRM_PSB_MEM_MMU:
+		man->func = &ttm_bo_manager_func;
+		man->flags = TTM_MEMTYPE_FLAG_MAPPABLE |
+		    TTM_MEMTYPE_FLAG_CMA;
+		man->gpu_offset = PSB_MEM_MMU_START;
+		man->available_caching = TTM_PL_FLAG_CACHED |
+		    TTM_PL_FLAG_UNCACHED | TTM_PL_FLAG_WC;
+		man->default_caching = TTM_PL_FLAG_WC;
+		break;
+	case TTM_PL_CI:
+		man->func = &ttm_bo_manager_func;
+		man->flags = TTM_MEMTYPE_FLAG_MAPPABLE |
+			TTM_MEMTYPE_FLAG_FIXED;
+		man->gpu_offset = pg->mmu_gatt_start + (pg->ci_start);
+		man->available_caching = TTM_PL_FLAG_UNCACHED;
+		man->default_caching = TTM_PL_FLAG_UNCACHED;
+		break;
+	case TTM_PL_RAR:	/* Unmappable RAR memory */
+		man->func = &ttm_bo_manager_func;
+		man->flags = TTM_MEMTYPE_FLAG_MAPPABLE |
+			TTM_MEMTYPE_FLAG_FIXED;
+		man->available_caching = TTM_PL_FLAG_UNCACHED;
+		man->default_caching = TTM_PL_FLAG_UNCACHED;
+		man->gpu_offset = pg->mmu_gatt_start + (pg->rar_start);
+		break;
+	case TTM_PL_TT:	/* Mappable GATT memory */
+		man->func = &ttm_bo_manager_func;
+#ifdef PSB_WORKING_HOST_MMU_ACCESS
+		man->flags = TTM_MEMTYPE_FLAG_MAPPABLE;
+#else
+		man->flags = TTM_MEMTYPE_FLAG_MAPPABLE |
+		    TTM_MEMTYPE_FLAG_CMA;
+#endif
+		man->available_caching = TTM_PL_FLAG_CACHED |
+		    TTM_PL_FLAG_UNCACHED | TTM_PL_FLAG_WC;
+		man->default_caching = TTM_PL_FLAG_WC;
+		man->gpu_offset = pg->mmu_gatt_start +
+				(pg->rar_start + dev_priv->rar_region_size);
+		break;
+	default:
+		DRM_ERROR("Unsupported memory type %u\n", (unsigned) type);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+
+static void psb_evict_mask(struct ttm_buffer_object *bo,
+					struct ttm_placement *placement)
+{
+	static uint32_t cur_placement;
+
+	cur_placement = bo->mem.placement & ~TTM_PL_MASK_MEM;
+	cur_placement |= TTM_PL_FLAG_SYSTEM;
+
+	placement->fpfn = 0;
+	placement->lpfn = 0;
+	placement->num_placement = 1;
+	placement->placement = &cur_placement;
+	placement->num_busy_placement = 0;
+	placement->busy_placement = NULL;
+
+	/* all buffers evicted to system memory */
+	/* return cur_placement | TTM_PL_FLAG_SYSTEM; */
+}
+
+static int psb_invalidate_caches(struct ttm_bo_device *bdev,
+				 uint32_t placement)
+{
+	return 0;
+}
+
+static int psb_move_blit(struct ttm_buffer_object *bo,
+			 bool evict, bool no_wait,
+			 struct ttm_mem_reg *new_mem)
+{
+	BUG();
+	return 0;
+}
+
+/*
+ * Flip destination ttm into GATT,
+ * then blit and subsequently move out again.
+ */
+
+static int psb_move_flip(struct ttm_buffer_object *bo,
+			 bool evict, bool interruptible, bool no_wait,
+			 struct ttm_mem_reg *new_mem)
+{
+	/*struct ttm_bo_device *bdev = bo->bdev;*/
+	struct ttm_mem_reg tmp_mem;
+	int ret;
+	struct ttm_placement placement;
+	uint32_t flags = TTM_PL_FLAG_TT;
+
+	tmp_mem = *new_mem;
+	tmp_mem.mm_node = NULL;
+
+	placement.fpfn = 0;
+	placement.lpfn = 0;
+	placement.num_placement = 1;
+	placement.placement = &flags;
+	placement.num_busy_placement = 0; /* FIXME */
+	placement.busy_placement = NULL;
+
+	ret = ttm_bo_mem_space(bo, &placement, &tmp_mem, interruptible,
+							false, no_wait);
+	if (ret)
+		return ret;
+	ret = ttm_tt_bind(bo->ttm, &tmp_mem);
+	if (ret)
+		goto out_cleanup;
+	ret = psb_move_blit(bo, true, no_wait, &tmp_mem);
+	if (ret)
+		goto out_cleanup;
+
+	ret = ttm_bo_move_ttm(bo, evict, false, no_wait, new_mem);
+out_cleanup:
+	if (tmp_mem.mm_node) {
+		drm_mm_put_block(tmp_mem.mm_node);
+		tmp_mem.mm_node = NULL;
+	}
+	return ret;
+}
+
+static int psb_move(struct ttm_buffer_object *bo,
+		    bool evict, bool interruptible, bool no_wait_reserve,
+		    bool no_wait, struct ttm_mem_reg *new_mem)
+{
+	struct ttm_mem_reg *old_mem = &bo->mem;
+
+	if ((old_mem->mem_type == TTM_PL_RAR) ||
+	    (new_mem->mem_type == TTM_PL_RAR)) {
+		if (old_mem->mm_node) {
+			spin_lock(&bo->glob->lru_lock);
+			drm_mm_put_block(old_mem->mm_node);
+			spin_unlock(&bo->glob->lru_lock);
+		}
+		old_mem->mm_node = NULL;
+		*old_mem = *new_mem;
+	} else if (old_mem->mem_type == TTM_PL_SYSTEM) {
+		return ttm_bo_move_memcpy(bo, evict, false, no_wait, new_mem);
+	} else if (new_mem->mem_type == TTM_PL_SYSTEM) {
+		int ret = psb_move_flip(bo, evict, interruptible,
+					no_wait, new_mem);
+		if (unlikely(ret != 0)) {
+			if (ret == -ERESTART)
+				return ret;
+			else
+				return ttm_bo_move_memcpy(bo, evict, false,
+						no_wait, new_mem);
+		}
+	} else {
+		if (psb_move_blit(bo, evict, no_wait, new_mem))
+			return ttm_bo_move_memcpy(bo, evict, false, no_wait,
+						  new_mem);
+	}
+	return 0;
+}
+
+static int drm_psb_tbe_populate(struct ttm_backend *backend,
+				unsigned long num_pages,
+				struct page **pages,
+				struct page *dummy_read_page,
+				dma_addr_t *dma_addrs)
+{
+	struct drm_psb_ttm_backend *psb_be =
+	    container_of(backend, struct drm_psb_ttm_backend, base);
+
+	psb_be->pages = pages;
+	return 0;
+}
+
+static int drm_psb_tbe_unbind(struct ttm_backend *backend)
+{
+	struct ttm_bo_device *bdev = backend->bdev;
+	struct drm_psb_private *dev_priv =
+	    container_of(bdev, struct drm_psb_private, bdev);
+	struct drm_psb_ttm_backend *psb_be =
+	    container_of(backend, struct drm_psb_ttm_backend, base);
+	struct psb_mmu_pd *pd = psb_mmu_get_default_pd(dev_priv->mmu);
+	/* struct ttm_mem_type_manager *man = &bdev->man[psb_be->mem_type]; */
+
+	if (psb_be->mem_type == TTM_PL_TT) {
+		uint32_t gatt_p_offset =
+			(psb_be->offset - dev_priv->pg->mmu_gatt_start)
+								>> PAGE_SHIFT;
+
+		(void) psb_gtt_remove_pages(dev_priv->pg, gatt_p_offset,
+					    psb_be->num_pages,
+					    psb_be->desired_tile_stride,
+					    psb_be->hw_tile_stride, 0);
+	}
+
+	psb_mmu_remove_pages(pd, psb_be->offset,
+			     psb_be->num_pages,
+			     psb_be->desired_tile_stride,
+			     psb_be->hw_tile_stride);
+
+	return 0;
+}
+
+static int drm_psb_tbe_bind(struct ttm_backend *backend,
+			    struct ttm_mem_reg *bo_mem)
+{
+	struct ttm_bo_device *bdev = backend->bdev;
+	struct drm_psb_private *dev_priv =
+	    container_of(bdev, struct drm_psb_private, bdev);
+	struct drm_psb_ttm_backend *psb_be =
+	    container_of(backend, struct drm_psb_ttm_backend, base);
+	struct psb_mmu_pd *pd = psb_mmu_get_default_pd(dev_priv->mmu);
+	struct ttm_mem_type_manager *man = &bdev->man[bo_mem->mem_type];
+	struct drm_mm_node *mm_node = bo_mem->mm_node;
+	int type;
+	int ret = 0;
+
+	psb_be->mem_type = bo_mem->mem_type;
+	psb_be->num_pages = bo_mem->num_pages;
+	psb_be->desired_tile_stride = 0;
+	psb_be->hw_tile_stride = 0;
+	psb_be->offset = (mm_node->start << PAGE_SHIFT) +
+	    man->gpu_offset;
+
+	type =
+	    (bo_mem->
+	     placement & TTM_PL_FLAG_CACHED) ? PSB_MMU_CACHED_MEMORY : 0;
+
+	if (psb_be->mem_type == TTM_PL_TT) {
+		uint32_t gatt_p_offset =
+				(psb_be->offset - dev_priv->pg->mmu_gatt_start)
+								>> PAGE_SHIFT;
+
+		ret = psb_gtt_insert_pages(dev_priv->pg, psb_be->pages,
+					   gatt_p_offset,
+					   psb_be->num_pages,
+					   psb_be->desired_tile_stride,
+					   psb_be->hw_tile_stride, type);
+	}
+
+	ret = psb_mmu_insert_pages(pd, psb_be->pages,
+				   psb_be->offset, psb_be->num_pages,
+				   psb_be->desired_tile_stride,
+				   psb_be->hw_tile_stride, type);
+	if (ret)
+		goto out_err;
+
+	return 0;
+out_err:
+	drm_psb_tbe_unbind(backend);
+	return ret;
+
+}
+
+static void drm_psb_tbe_clear(struct ttm_backend *backend)
+{
+	struct drm_psb_ttm_backend *psb_be =
+	    container_of(backend, struct drm_psb_ttm_backend, base);
+
+	psb_be->pages = NULL;
+	return;
+}
+
+static void drm_psb_tbe_destroy(struct ttm_backend *backend)
+{
+	struct drm_psb_ttm_backend *psb_be =
+	    container_of(backend, struct drm_psb_ttm_backend, base);
+
+	if (backend)
+		kfree(psb_be);
+}
+
+static struct ttm_backend_func psb_ttm_backend = {
+	.populate = drm_psb_tbe_populate,
+	.clear = drm_psb_tbe_clear,
+	.bind = drm_psb_tbe_bind,
+	.unbind = drm_psb_tbe_unbind,
+	.destroy = drm_psb_tbe_destroy,
+};
+
+static struct ttm_backend *drm_psb_tbe_init(struct ttm_bo_device *bdev)
+{
+	struct drm_psb_ttm_backend *psb_be;
+
+	psb_be = kzalloc(sizeof(*psb_be), GFP_KERNEL);
+	if (!psb_be)
+		return NULL;
+	psb_be->pages = NULL;
+	psb_be->base.func = &psb_ttm_backend;
+	psb_be->base.bdev = bdev;
+	return &psb_be->base;
+}
+
+static int psb_ttm_io_mem_reserve(struct ttm_bo_device *bdev,
+						struct ttm_mem_reg *mem)
+{
+	struct ttm_mem_type_manager *man = &bdev->man[mem->mem_type];
+	struct drm_psb_private *dev_priv =
+	    container_of(bdev, struct drm_psb_private, bdev);
+	struct psb_gtt *pg = dev_priv->pg;
+	struct drm_mm_node *mm_node = mem->mm_node;
+
+	mem->bus.addr = NULL;
+	mem->bus.offset = 0;
+	mem->bus.size = mem->num_pages << PAGE_SHIFT;
+	mem->bus.base = 0;
+	mem->bus.is_iomem = false;
+	if (!(man->flags & TTM_MEMTYPE_FLAG_MAPPABLE))
+		return -EINVAL;
+	switch (mem->mem_type) {
+	case TTM_PL_SYSTEM:
+		/* system memory */
+		return 0;
+	case TTM_PL_TT:
+		mem->bus.offset = mm_node->start << PAGE_SHIFT;
+		mem->bus.base = pg->gatt_start;
+		mem->bus.is_iomem = false;
+		/* Don't know whether it is IO_MEM, this flag
+						used in vm_fault handle */
+		break;
+	case DRM_PSB_MEM_MMU:
+		mem->bus.offset = mm_node->start << PAGE_SHIFT;
+		mem->bus.base = 0x00000000;
+		break;
+	case TTM_PL_CI:
+		mem->bus.offset = mm_node->start << PAGE_SHIFT;
+		mem->bus.base = dev_priv->ci_region_start;;
+		mem->bus.is_iomem = true;
+		break;
+	case TTM_PL_RAR:
+		mem->bus.offset = mm_node->start << PAGE_SHIFT;
+		mem->bus.base = dev_priv->rar_region_start;;
+		mem->bus.is_iomem = true;
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void psb_ttm_io_mem_free(struct ttm_bo_device *bdev,
+						struct ttm_mem_reg *mem)
+{
+}
+
+/*
+ * Use this memory type priority if no eviction is needed.
+ */
+/*
+static uint32_t psb_mem_prios[] = {
+	TTM_PL_CI,
+	TTM_PL_RAR,
+	TTM_PL_TT,
+	DRM_PSB_MEM_MMU,
+	TTM_PL_SYSTEM
+};
+*/
+/*
+ * Use this memory type priority if need to evict.
+ */
+/*
+static uint32_t psb_busy_prios[] = {
+	TTM_PL_TT,
+	TTM_PL_CI,
+	TTM_PL_RAR,
+	DRM_PSB_MEM_MMU,
+	TTM_PL_SYSTEM
+};
+*/
+struct ttm_bo_driver psb_ttm_bo_driver = {
+/*
+	.mem_type_prio = psb_mem_prios,
+	.mem_busy_prio = psb_busy_prios,
+	.num_mem_type_prio = ARRAY_SIZE(psb_mem_prios),
+	.num_mem_busy_prio = ARRAY_SIZE(psb_busy_prios),
+*/
+	.create_ttm_backend_entry = &drm_psb_tbe_init,
+	.invalidate_caches = &psb_invalidate_caches,
+	.init_mem_type = &psb_init_mem_type,
+	.evict_flags = &psb_evict_mask,
+	.move = &psb_move,
+	.verify_access = &psb_verify_access,
+	.sync_obj_signaled = &ttm_fence_sync_obj_signaled,
+	.sync_obj_wait = &ttm_fence_sync_obj_wait,
+	.sync_obj_flush = &ttm_fence_sync_obj_flush,
+	.sync_obj_unref = &ttm_fence_sync_obj_unref,
+	.sync_obj_ref = &ttm_fence_sync_obj_ref,
+	.io_mem_reserve = &psb_ttm_io_mem_reserve,
+	.io_mem_free = &psb_ttm_io_mem_free
+};
diff --git a/drivers/staging/gma500/psb_drm.h b/drivers/staging/gma500/psb_drm.h
new file mode 100644
index 0000000..ef5fcd0
--- /dev/null
+++ b/drivers/staging/gma500/psb_drm.h
@@ -0,0 +1,696 @@
+/**************************************************************************
+ * Copyright (c) 2007, Intel Corporation.
+ * All Rights Reserved.
+ * Copyright (c) 2008, Tungsten Graphics Inc.  Cedar Park, TX., USA.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+
+#ifndef _PSB_DRM_H_
+#define _PSB_DRM_H_
+
+#if defined(__linux__) && !defined(__KERNEL__)
+#include<stdint.h>
+#include <linux/types.h>
+#include "drm_mode.h"
+#endif
+
+#include "psb_ttm_fence_user.h"
+#include "psb_ttm_placement_user.h"
+
+/*
+ * Menlow/MRST graphics driver package version
+ * a.b.c.xxxx
+ * a - Product Family: 5 - Linux
+ * b - Major Release Version: 0 - non-Gallium (Unbuntu);
+ *                            1 - Gallium (Moblin2)
+ * c - Hotfix Release
+ * xxxx - Graphics internal build #
+ */
+#define PSB_PACKAGE_VERSION "5.3.0.32L.0036"
+
+#define DRM_PSB_SAREA_MAJOR 0
+#define DRM_PSB_SAREA_MINOR 2
+#define PSB_FIXED_SHIFT 16
+
+#define PSB_NUM_PIPE 3
+
+/*
+ * Public memory types.
+ */
+
+#define DRM_PSB_MEM_MMU TTM_PL_PRIV1
+#define DRM_PSB_FLAG_MEM_MMU TTM_PL_FLAG_PRIV1
+
+#define TTM_PL_CI               TTM_PL_PRIV0
+#define TTM_PL_FLAG_CI          TTM_PL_FLAG_PRIV0
+
+#define TTM_PL_RAR               TTM_PL_PRIV2
+#define TTM_PL_FLAG_RAR          TTM_PL_FLAG_PRIV2
+
+typedef int32_t psb_fixed;
+typedef uint32_t psb_ufixed;
+
+static inline int32_t psb_int_to_fixed(int a)
+{
+	return a * (1 << PSB_FIXED_SHIFT);
+}
+
+static inline uint32_t psb_unsigned_to_ufixed(unsigned int a)
+{
+	return a << PSB_FIXED_SHIFT;
+}
+
+/*Status of the command sent to the gfx device.*/
+typedef enum {
+	DRM_CMD_SUCCESS,
+	DRM_CMD_FAILED,
+	DRM_CMD_HANG
+} drm_cmd_status_t;
+
+struct drm_psb_scanout {
+	uint32_t buffer_id;	/* DRM buffer object ID */
+	uint32_t rotation;	/* Rotation as in RR_rotation definitions */
+	uint32_t stride;	/* Buffer stride in bytes */
+	uint32_t depth;		/* Buffer depth in bits (NOT) bpp */
+	uint32_t width;		/* Buffer width in pixels */
+	uint32_t height;	/* Buffer height in lines */
+	int32_t transform[3][3];	/* Buffer composite transform */
+	/* (scaling, rot, reflect) */
+};
+
+#define DRM_PSB_SAREA_OWNERS 16
+#define DRM_PSB_SAREA_OWNER_2D 0
+#define DRM_PSB_SAREA_OWNER_3D 1
+
+#define DRM_PSB_SAREA_SCANOUTS 3
+
+struct drm_psb_sarea {
+	/* Track changes of this data structure */
+
+	uint32_t major;
+	uint32_t minor;
+
+	/* Last context to touch part of hw */
+	uint32_t ctx_owners[DRM_PSB_SAREA_OWNERS];
+
+	/* Definition of front- and rotated buffers */
+	uint32_t num_scanouts;
+	struct drm_psb_scanout scanouts[DRM_PSB_SAREA_SCANOUTS];
+
+	int planeA_x;
+	int planeA_y;
+	int planeA_w;
+	int planeA_h;
+	int planeB_x;
+	int planeB_y;
+	int planeB_w;
+	int planeB_h;
+	/* Number of active scanouts */
+	uint32_t num_active_scanouts;
+};
+
+#define PSB_RELOC_MAGIC         0x67676767
+#define PSB_RELOC_SHIFT_MASK    0x0000FFFF
+#define PSB_RELOC_SHIFT_SHIFT   0
+#define PSB_RELOC_ALSHIFT_MASK  0xFFFF0000
+#define PSB_RELOC_ALSHIFT_SHIFT 16
+
+#define PSB_RELOC_OP_OFFSET     0	/* Offset of the indicated
+					 * buffer
+					 */
+
+struct drm_psb_reloc {
+	uint32_t reloc_op;
+	uint32_t where;		/* offset in destination buffer */
+	uint32_t buffer;	/* Buffer reloc applies to */
+	uint32_t mask;		/* Destination format: */
+	uint32_t shift;		/* Destination format: */
+	uint32_t pre_add;	/* Destination format: */
+	uint32_t background;	/* Destination add */
+	uint32_t dst_buffer;	/* Destination buffer. Index into buffer_list */
+	uint32_t arg0;		/* Reloc-op dependant */
+	uint32_t arg1;
+};
+
+
+#define PSB_GPU_ACCESS_READ         (1ULL << 32)
+#define PSB_GPU_ACCESS_WRITE        (1ULL << 33)
+#define PSB_GPU_ACCESS_MASK         (PSB_GPU_ACCESS_READ | PSB_GPU_ACCESS_WRITE)
+
+#define PSB_BO_FLAG_COMMAND         (1ULL << 52)
+
+#define PSB_ENGINE_2D 0
+#define PSB_ENGINE_VIDEO 1
+#define LNC_ENGINE_ENCODE 5
+
+/*
+ * For this fence class we have a couple of
+ * fence types.
+ */
+
+#define _PSB_FENCE_EXE_SHIFT           0
+#define _PSB_FENCE_FEEDBACK_SHIFT      4
+
+#define _PSB_FENCE_TYPE_EXE         (1 << _PSB_FENCE_EXE_SHIFT)
+#define _PSB_FENCE_TYPE_FEEDBACK    (1 << _PSB_FENCE_FEEDBACK_SHIFT)
+
+#define PSB_NUM_ENGINES 6
+
+
+#define PSB_FEEDBACK_OP_VISTEST (1 << 0)
+
+struct drm_psb_extension_rep {
+	int32_t exists;
+	uint32_t driver_ioctl_offset;
+	uint32_t sarea_offset;
+	uint32_t major;
+	uint32_t minor;
+	uint32_t pl;
+};
+
+#define DRM_PSB_EXT_NAME_LEN 128
+
+union drm_psb_extension_arg {
+	char extension[DRM_PSB_EXT_NAME_LEN];
+	struct drm_psb_extension_rep rep;
+};
+
+struct psb_validate_req {
+	uint64_t set_flags;
+	uint64_t clear_flags;
+	uint64_t next;
+	uint64_t presumed_gpu_offset;
+	uint32_t buffer_handle;
+	uint32_t presumed_flags;
+	uint32_t group;
+	uint32_t pad64;
+};
+
+struct psb_validate_rep {
+	uint64_t gpu_offset;
+	uint32_t placement;
+	uint32_t fence_type_mask;
+};
+
+#define PSB_USE_PRESUMED     (1 << 0)
+
+struct psb_validate_arg {
+	int handled;
+	int ret;
+	union {
+		struct psb_validate_req req;
+		struct psb_validate_rep rep;
+	} d;
+};
+
+
+#define DRM_PSB_FENCE_NO_USER        (1 << 0)
+
+struct psb_ttm_fence_rep {
+	uint32_t handle;
+	uint32_t fence_class;
+	uint32_t fence_type;
+	uint32_t signaled_types;
+	uint32_t error;
+};
+
+typedef struct drm_psb_cmdbuf_arg {
+	uint64_t buffer_list;	/* List of buffers to validate */
+	uint64_t clip_rects;	/* See i915 counterpart */
+	uint64_t scene_arg;
+	uint64_t fence_arg;
+
+	uint32_t ta_flags;
+
+	uint32_t ta_handle;	/* TA reg-value pairs */
+	uint32_t ta_offset;
+	uint32_t ta_size;
+
+	uint32_t oom_handle;
+	uint32_t oom_offset;
+	uint32_t oom_size;
+
+	uint32_t cmdbuf_handle;	/* 2D Command buffer object or, */
+	uint32_t cmdbuf_offset;	/* rasterizer reg-value pairs */
+	uint32_t cmdbuf_size;
+
+	uint32_t reloc_handle;	/* Reloc buffer object */
+	uint32_t reloc_offset;
+	uint32_t num_relocs;
+
+	int32_t damage;		/* Damage front buffer with cliprects */
+	/* Not implemented yet */
+	uint32_t fence_flags;
+	uint32_t engine;
+
+	/*
+	 * Feedback;
+	 */
+
+	uint32_t feedback_ops;
+	uint32_t feedback_handle;
+	uint32_t feedback_offset;
+	uint32_t feedback_breakpoints;
+	uint32_t feedback_size;
+} drm_psb_cmdbuf_arg_t;
+
+typedef struct drm_psb_pageflip_arg {
+	uint32_t flip_offset;
+	uint32_t stride;
+} drm_psb_pageflip_arg_t;
+
+typedef enum {
+	LNC_VIDEO_DEVICE_INFO,
+	LNC_VIDEO_GETPARAM_RAR_INFO,
+	LNC_VIDEO_GETPARAM_CI_INFO,
+	LNC_VIDEO_GETPARAM_RAR_HANDLER_OFFSET,
+	LNC_VIDEO_FRAME_SKIP,
+	IMG_VIDEO_DECODE_STATUS,
+	IMG_VIDEO_NEW_CONTEXT,
+	IMG_VIDEO_RM_CONTEXT,
+	IMG_VIDEO_MB_ERROR
+} lnc_getparam_key_t;
+
+struct drm_lnc_video_getparam_arg {
+	lnc_getparam_key_t key;
+	uint64_t arg;	/* argument pointer */
+	uint64_t value;	/* feed back pointer */
+};
+
+
+/*
+ * Feedback components:
+ */
+
+/*
+ * Vistest component. The number of these in the feedback buffer
+ * equals the number of vistest breakpoints + 1.
+ * This is currently the only feedback component.
+ */
+
+struct drm_psb_vistest {
+	uint32_t vt[8];
+};
+
+struct drm_psb_sizes_arg {
+	uint32_t ta_mem_size;
+	uint32_t mmu_size;
+	uint32_t pds_size;
+	uint32_t rastgeom_size;
+	uint32_t tt_size;
+	uint32_t vram_size;
+};
+
+struct drm_psb_hist_status_arg {
+	uint32_t buf[32];
+};
+
+struct drm_psb_dpst_lut_arg {
+	uint8_t lut[256];
+	int output_id;
+};
+
+struct mrst_timing_info {
+	uint16_t pixel_clock;
+	uint8_t hactive_lo;
+	uint8_t hblank_lo;
+	uint8_t hblank_hi:4;
+	uint8_t hactive_hi:4;
+	uint8_t vactive_lo;
+	uint8_t vblank_lo;
+	uint8_t vblank_hi:4;
+	uint8_t vactive_hi:4;
+	uint8_t hsync_offset_lo;
+	uint8_t hsync_pulse_width_lo;
+	uint8_t vsync_pulse_width_lo:4;
+	uint8_t vsync_offset_lo:4;
+	uint8_t vsync_pulse_width_hi:2;
+	uint8_t vsync_offset_hi:2;
+	uint8_t hsync_pulse_width_hi:2;
+	uint8_t hsync_offset_hi:2;
+	uint8_t width_mm_lo;
+	uint8_t height_mm_lo;
+	uint8_t height_mm_hi:4;
+	uint8_t width_mm_hi:4;
+	uint8_t hborder;
+	uint8_t vborder;
+	uint8_t unknown0:1;
+	uint8_t hsync_positive:1;
+	uint8_t vsync_positive:1;
+	uint8_t separate_sync:2;
+	uint8_t stereo:1;
+	uint8_t unknown6:1;
+	uint8_t interlaced:1;
+} __attribute__((packed));
+
+struct gct_r10_timing_info {
+	uint16_t pixel_clock;
+	uint32_t hactive_lo:8;
+	uint32_t hactive_hi:4;
+	uint32_t hblank_lo:8;
+	uint32_t hblank_hi:4;
+	uint32_t hsync_offset_lo:8;
+	uint16_t hsync_offset_hi:2;
+	uint16_t hsync_pulse_width_lo:8;
+	uint16_t hsync_pulse_width_hi:2;
+	uint16_t hsync_positive:1;
+	uint16_t rsvd_1:3;
+	uint8_t  vactive_lo:8;
+	uint16_t vactive_hi:4;
+	uint16_t vblank_lo:8;
+	uint16_t vblank_hi:4;
+	uint16_t vsync_offset_lo:4;
+	uint16_t vsync_offset_hi:2;
+	uint16_t vsync_pulse_width_lo:4;
+	uint16_t vsync_pulse_width_hi:2;
+	uint16_t vsync_positive:1;
+	uint16_t rsvd_2:3;
+} __attribute__((packed));
+
+struct mrst_panel_descriptor_v1{
+	uint32_t Panel_Port_Control; /* 1 dword, Register 0x61180 if LVDS */
+				/* 0x61190 if MIPI */
+	uint32_t Panel_Power_On_Sequencing;/*1 dword,Register 0x61208,*/
+	uint32_t Panel_Power_Off_Sequencing;/*1 dword,Register 0x6120C,*/
+	uint32_t Panel_Power_Cycle_Delay_and_Reference_Divisor;/* 1 dword */
+						/* Register 0x61210 */
+	struct mrst_timing_info DTD;/*18 bytes, Standard definition */
+	uint16_t Panel_Backlight_Inverter_Descriptor;/* 16 bits, as follows */
+				/* Bit 0, Frequency, 15 bits,0 - 32767Hz */
+			/* Bit 15, Polarity, 1 bit, 0: Normal, 1: Inverted */
+	uint16_t Panel_MIPI_Display_Descriptor;
+			/*16 bits, Defined as follows: */
+			/* if MIPI, 0x0000 if LVDS */
+			/* Bit 0, Type, 2 bits, */
+			/* 0: Type-1, */
+			/* 1: Type-2, */
+			/* 2: Type-3, */
+			/* 3: Type-4 */
+			/* Bit 2, Pixel Format, 4 bits */
+			/* Bit0: 16bpp (not supported in LNC), */
+			/* Bit1: 18bpp loosely packed, */
+			/* Bit2: 18bpp packed, */
+			/* Bit3: 24bpp */
+			/* Bit 6, Reserved, 2 bits, 00b */
+		/* Bit 8, Minimum Supported Frame Rate, 6 bits, 0 - 63Hz */
+			/* Bit 14, Reserved, 2 bits, 00b */
+} __attribute__ ((packed));
+
+struct mrst_panel_descriptor_v2{
+	uint32_t Panel_Port_Control; /* 1 dword, Register 0x61180 if LVDS */
+				/* 0x61190 if MIPI */
+	uint32_t Panel_Power_On_Sequencing;/*1 dword,Register 0x61208,*/
+	uint32_t Panel_Power_Off_Sequencing;/*1 dword,Register 0x6120C,*/
+	uint8_t Panel_Power_Cycle_Delay_and_Reference_Divisor;/* 1 byte */
+						/* Register 0x61210 */
+	struct mrst_timing_info DTD;/*18 bytes, Standard definition */
+	uint16_t Panel_Backlight_Inverter_Descriptor;/*16 bits, as follows*/
+				/*Bit 0, Frequency, 16 bits, 0 - 32767Hz*/
+	uint8_t Panel_Initial_Brightness;/* [7:0] 0 - 100% */
+			/*Bit 7, Polarity, 1 bit,0: Normal, 1: Inverted*/
+	uint16_t Panel_MIPI_Display_Descriptor;
+			/*16 bits, Defined as follows: */
+			/* if MIPI, 0x0000 if LVDS */
+			/* Bit 0, Type, 2 bits, */
+			/* 0: Type-1, */
+			/* 1: Type-2, */
+			/* 2: Type-3, */
+			/* 3: Type-4 */
+			/* Bit 2, Pixel Format, 4 bits */
+			/* Bit0: 16bpp (not supported in LNC), */
+			/* Bit1: 18bpp loosely packed, */
+			/* Bit2: 18bpp packed, */
+			/* Bit3: 24bpp */
+			/* Bit 6, Reserved, 2 bits, 00b */
+		/* Bit 8, Minimum Supported Frame Rate, 6 bits, 0 - 63Hz */
+			/* Bit 14, Reserved, 2 bits, 00b */
+} __attribute__ ((packed));
+
+union mrst_panel_rx{
+	struct{
+		uint16_t NumberOfLanes:2; /*Num of Lanes, 2 bits,0 = 1 lane,*/
+			/* 1 = 2 lanes, 2 = 3 lanes, 3 = 4 lanes. */
+		uint16_t MaxLaneFreq:3; /* 0: 100MHz, 1: 200MHz, 2: 300MHz, */
+		/*3: 400MHz, 4: 500MHz, 5: 600MHz, 6: 700MHz, 7: 800MHz.*/
+		uint16_t SupportedVideoTransferMode:2; /*0: Non-burst only */
+					/* 1: Burst and non-burst */
+					/* 2/3: Reserved */
+		uint16_t HSClkBehavior:1; /*0: Continuous, 1: Non-continuous*/
+		uint16_t DuoDisplaySupport:1; /*1 bit,0: No, 1: Yes*/
+		uint16_t ECC_ChecksumCapabilities:1;/*1 bit,0: No, 1: Yes*/
+		uint16_t BidirectionalCommunication:1;/*1 bit,0: No, 1: Yes */
+		uint16_t Rsvd:5;/*5 bits,00000b */
+	} panelrx;
+	uint16_t panel_receiver;
+} __attribute__ ((packed));
+
+struct gct_ioctl_arg{
+	uint8_t bpi; /* boot panel index, number of panel used during boot */
+	uint8_t pt; /* panel type, 4 bit field, 0=lvds, 1=mipi */
+	struct mrst_timing_info DTD; /* timing info for the selected panel */
+	uint32_t Panel_Port_Control;
+	uint32_t PP_On_Sequencing;/*1 dword,Register 0x61208,*/
+	uint32_t PP_Off_Sequencing;/*1 dword,Register 0x6120C,*/
+	uint32_t PP_Cycle_Delay;
+	uint16_t Panel_Backlight_Inverter_Descriptor;
+	uint16_t Panel_MIPI_Display_Descriptor;
+} __attribute__ ((packed));
+
+struct mrst_vbt{
+	char Signature[4]; /*4 bytes,"$GCT" */
+	uint8_t Revision; /*1 byte */
+	uint8_t Size; /*1 byte */
+	uint8_t Checksum; /*1 byte,Calculated*/
+	void *mrst_gct;
+} __attribute__ ((packed));
+
+struct mrst_gct_v1{ /* expect this table to change per customer request*/
+	union{ /*8 bits,Defined as follows: */
+		struct{
+			uint8_t PanelType:4; /*4 bits, Bit field for panels*/
+					/* 0 - 3: 0 = LVDS, 1 = MIPI*/
+					/*2 bits,Specifies which of the*/
+			uint8_t BootPanelIndex:2;
+					/* 4 panels to use by default*/
+			uint8_t BootMIPI_DSI_RxIndex:2;/*Specifies which of*/
+					/* the 4 MIPI DSI receivers to use*/
+			} PD;
+		uint8_t PanelDescriptor;
+	};
+	struct mrst_panel_descriptor_v1 panel[4];/*panel descrs,38 bytes each*/
+	union mrst_panel_rx panelrx[4]; /* panel receivers*/
+} __attribute__ ((packed));
+
+struct mrst_gct_v2{ /* expect this table to change per customer request*/
+	union{ /*8 bits,Defined as follows: */
+		struct{
+			uint8_t PanelType:4; /*4 bits, Bit field for panels*/
+					/* 0 - 3: 0 = LVDS, 1 = MIPI*/
+					/*2 bits,Specifies which of the*/
+			uint8_t BootPanelIndex:2;
+					/* 4 panels to use by default*/
+			uint8_t BootMIPI_DSI_RxIndex:2;/*Specifies which of*/
+					/* the 4 MIPI DSI receivers to use*/
+			} PD;
+		uint8_t PanelDescriptor;
+	};
+	struct mrst_panel_descriptor_v2 panel[4];/*panel descrs,38 bytes each*/
+	union mrst_panel_rx panelrx[4]; /* panel receivers*/
+} __attribute__ ((packed));
+
+#define PSB_DC_CRTC_SAVE 0x01
+#define PSB_DC_CRTC_RESTORE 0x02
+#define PSB_DC_OUTPUT_SAVE 0x04
+#define PSB_DC_OUTPUT_RESTORE 0x08
+#define PSB_DC_CRTC_MASK 0x03
+#define PSB_DC_OUTPUT_MASK 0x0C
+
+struct drm_psb_dc_state_arg {
+	uint32_t flags;
+	uint32_t obj_id;
+};
+
+struct drm_psb_mode_operation_arg {
+	uint32_t obj_id;
+	uint16_t operation;
+	struct drm_mode_modeinfo mode;
+	void *data;
+};
+
+struct drm_psb_stolen_memory_arg {
+	uint32_t base;
+	uint32_t size;
+};
+
+/*Display Register Bits*/
+#define REGRWBITS_PFIT_CONTROLS			(1 << 0)
+#define REGRWBITS_PFIT_AUTOSCALE_RATIOS		(1 << 1)
+#define REGRWBITS_PFIT_PROGRAMMED_SCALE_RATIOS	(1 << 2)
+#define REGRWBITS_PIPEASRC			(1 << 3)
+#define REGRWBITS_PIPEBSRC			(1 << 4)
+#define REGRWBITS_VTOTAL_A			(1 << 5)
+#define REGRWBITS_VTOTAL_B			(1 << 6)
+#define REGRWBITS_DSPACNTR	(1 << 8)
+#define REGRWBITS_DSPBCNTR	(1 << 9)
+#define REGRWBITS_DSPCCNTR	(1 << 10)
+
+/*Overlay Register Bits*/
+#define OV_REGRWBITS_OVADD			(1 << 0)
+#define OV_REGRWBITS_OGAM_ALL			(1 << 1)
+
+#define OVC_REGRWBITS_OVADD                  (1 << 2)
+#define OVC_REGRWBITS_OGAM_ALL			(1 << 3)
+
+struct drm_psb_register_rw_arg {
+	uint32_t b_force_hw_on;
+
+	uint32_t display_read_mask;
+	uint32_t display_write_mask;
+
+	struct {
+		uint32_t pfit_controls;
+		uint32_t pfit_autoscale_ratios;
+		uint32_t pfit_programmed_scale_ratios;
+		uint32_t pipeasrc;
+		uint32_t pipebsrc;
+		uint32_t vtotal_a;
+		uint32_t vtotal_b;
+	} display;
+
+	uint32_t overlay_read_mask;
+	uint32_t overlay_write_mask;
+
+	struct {
+		uint32_t OVADD;
+		uint32_t OGAMC0;
+		uint32_t OGAMC1;
+		uint32_t OGAMC2;
+		uint32_t OGAMC3;
+		uint32_t OGAMC4;
+		uint32_t OGAMC5;
+        	uint32_t IEP_ENABLED;
+        	uint32_t IEP_BLE_MINMAX;
+        	uint32_t IEP_BSSCC_CONTROL;
+                uint32_t b_wait_vblank;
+	} overlay;
+
+	uint32_t sprite_enable_mask;
+	uint32_t sprite_disable_mask;
+
+	struct {
+		uint32_t dspa_control;
+		uint32_t dspa_key_value;
+		uint32_t dspa_key_mask;
+		uint32_t dspc_control;
+		uint32_t dspc_stride;
+		uint32_t dspc_position;
+		uint32_t dspc_linear_offset;
+		uint32_t dspc_size;
+		uint32_t dspc_surface;
+	} sprite;
+
+	uint32_t subpicture_enable_mask;
+	uint32_t subpicture_disable_mask;
+};
+
+struct psb_gtt_mapping_arg {
+	void *hKernelMemInfo;
+	uint32_t offset_pages;
+};
+
+struct drm_psb_getpageaddrs_arg {
+	uint32_t handle;
+	unsigned long *page_addrs;
+	unsigned long gtt_offset;
+};
+
+/* Controlling the kernel modesetting buffers */
+
+#define DRM_PSB_KMS_OFF		0x00
+#define DRM_PSB_KMS_ON		0x01
+#define DRM_PSB_VT_LEAVE        0x02
+#define DRM_PSB_VT_ENTER        0x03
+#define DRM_PSB_EXTENSION       0x06
+#define DRM_PSB_SIZES           0x07
+#define DRM_PSB_FUSE_REG	0x08
+#define DRM_PSB_VBT		0x09
+#define DRM_PSB_DC_STATE	0x0A
+#define DRM_PSB_ADB		0x0B
+#define DRM_PSB_MODE_OPERATION	0x0C
+#define DRM_PSB_STOLEN_MEMORY	0x0D
+#define DRM_PSB_REGISTER_RW	0x0E
+#define DRM_PSB_GTT_MAP         0x0F
+#define DRM_PSB_GTT_UNMAP       0x10
+#define DRM_PSB_GETPAGEADDRS	0x11
+/**
+ * NOTE: Add new commands here, but increment
+ * the values below and increment their
+ * corresponding defines where they're
+ * defined elsewhere.
+ */
+#define DRM_PVR_RESERVED1	0x12
+#define DRM_PVR_RESERVED2	0x13
+#define DRM_PVR_RESERVED3	0x14
+#define DRM_PVR_RESERVED4	0x15
+#define DRM_PVR_RESERVED5	0x16
+
+#define DRM_PSB_HIST_ENABLE	0x17
+#define DRM_PSB_HIST_STATUS	0x18
+#define DRM_PSB_UPDATE_GUARD	0x19
+#define DRM_PSB_INIT_COMM	0x1A
+#define DRM_PSB_DPST		0x1B
+#define DRM_PSB_GAMMA		0x1C
+#define DRM_PSB_DPST_BL		0x1D
+
+#define DRM_PVR_RESERVED6	0x1E
+
+#define DRM_PSB_GET_PIPE_FROM_CRTC_ID 0x1F
+#define DRM_PSB_DPU_QUERY 0x20
+#define DRM_PSB_DPU_DSR_ON 0x21
+#define DRM_PSB_DPU_DSR_OFF 0x22
+
+#define DRM_PSB_DSR_ENABLE	0xfffffffe
+#define DRM_PSB_DSR_DISABLE	0xffffffff
+
+struct psb_drm_dpu_rect {
+    int x, y;
+    int width, height;
+};
+
+struct drm_psb_drv_dsr_off_arg {
+	int screen;
+	struct psb_drm_dpu_rect damage_rect;
+};
+
+
+struct drm_psb_dev_info_arg {
+	uint32_t num_use_attribute_registers;
+};
+#define DRM_PSB_DEVINFO         0x01
+
+#define PSB_MODE_OPERATION_MODE_VALID	0x01
+#define PSB_MODE_OPERATION_SET_DC_BASE  0x02
+
+struct drm_psb_get_pipe_from_crtc_id_arg {
+	/** ID of CRTC being requested **/
+	uint32_t crtc_id;
+
+	/** pipe of requested CRTC **/
+	uint32_t pipe;
+};
+
+#endif
diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
new file mode 100644
index 0000000..2fe09c8
--- /dev/null
+++ b/drivers/staging/gma500/psb_drv.c
@@ -0,0 +1,1677 @@
+/**************************************************************************
+ * Copyright (c) 2007, Intel Corporation.
+ * All Rights Reserved.
+ * Copyright (c) 2008, Tungsten Graphics, Inc. Cedar Park, TX., USA.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include "psb_drm.h"
+#include "psb_drv.h"
+#include "psb_fb.h"
+#include "psb_reg.h"
+#include "psb_intel_reg.h"
+#include "psb_intel_bios.h"
+#include <drm/drm_pciids.h>
+#include "psb_powermgmt.h"
+#include <linux/cpu.h>
+#include <linux/notifier.h>
+#include <linux/spinlock.h>
+#include <linux/pm_runtime.h>
+
+int drm_psb_debug;
+static int drm_psb_trap_pagefaults;
+
+int drm_psb_disable_vsync = 1;
+int drm_psb_no_fb;
+int drm_psb_force_pipeb;
+int drm_idle_check_interval = 5;
+int gfxrtdelay = 2 * 1000;
+
+static int psb_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
+
+MODULE_PARM_DESC(debug, "Enable debug output");
+MODULE_PARM_DESC(no_fb, "Disable FBdev");
+MODULE_PARM_DESC(trap_pagefaults, "Error and reset on MMU pagefaults");
+MODULE_PARM_DESC(disable_vsync, "Disable vsync interrupts");
+MODULE_PARM_DESC(force_pipeb, "Forces PIPEB to become primary fb");
+MODULE_PARM_DESC(ta_mem_size, "TA memory size in kiB");
+MODULE_PARM_DESC(ospm, "switch for ospm support");
+MODULE_PARM_DESC(rtpm, "Specifies Runtime PM delay for GFX");
+MODULE_PARM_DESC(hdmi_edid, "EDID info for HDMI monitor");
+module_param_named(debug, drm_psb_debug, int, 0600);
+module_param_named(no_fb, drm_psb_no_fb, int, 0600);
+module_param_named(trap_pagefaults, drm_psb_trap_pagefaults, int, 0600);
+module_param_named(force_pipeb, drm_psb_force_pipeb, int, 0600);
+module_param_named(rtpm, gfxrtdelay, int, 0600);
+
+
+static struct pci_device_id pciidlist[] = {
+	{ 0x8086, 0x8108, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8108 },
+	{ 0x8086, 0x8109, PCI_ANY_ID, PCI_ANY_ID, 0, 0, CHIP_PSB_8109 },
+	{ 0, 0, 0}
+};
+MODULE_DEVICE_TABLE(pci, pciidlist);
+
+/*
+ * Standard IOCTLs.
+ */
+
+#define DRM_IOCTL_PSB_KMS_OFF	\
+		DRM_IO(DRM_PSB_KMS_OFF + DRM_COMMAND_BASE)
+#define DRM_IOCTL_PSB_KMS_ON	\
+		DRM_IO(DRM_PSB_KMS_ON + DRM_COMMAND_BASE)
+#define DRM_IOCTL_PSB_VT_LEAVE	\
+		DRM_IO(DRM_PSB_VT_LEAVE + DRM_COMMAND_BASE)
+#define DRM_IOCTL_PSB_VT_ENTER	\
+		DRM_IO(DRM_PSB_VT_ENTER + DRM_COMMAND_BASE)
+#define DRM_IOCTL_PSB_SIZES	\
+		DRM_IOR(DRM_PSB_SIZES + DRM_COMMAND_BASE, \
+			struct drm_psb_sizes_arg)
+#define DRM_IOCTL_PSB_FUSE_REG	\
+		DRM_IOWR(DRM_PSB_FUSE_REG + DRM_COMMAND_BASE, uint32_t)
+#define DRM_IOCTL_PSB_DC_STATE	\
+		DRM_IOW(DRM_PSB_DC_STATE + DRM_COMMAND_BASE, \
+			struct drm_psb_dc_state_arg)
+#define DRM_IOCTL_PSB_ADB	\
+		DRM_IOWR(DRM_PSB_ADB + DRM_COMMAND_BASE, uint32_t)
+#define DRM_IOCTL_PSB_MODE_OPERATION	\
+		DRM_IOWR(DRM_PSB_MODE_OPERATION + DRM_COMMAND_BASE, \
+			 struct drm_psb_mode_operation_arg)
+#define DRM_IOCTL_PSB_STOLEN_MEMORY	\
+		DRM_IOWR(DRM_PSB_STOLEN_MEMORY + DRM_COMMAND_BASE, \
+			 struct drm_psb_stolen_memory_arg)
+#define DRM_IOCTL_PSB_REGISTER_RW	\
+		DRM_IOWR(DRM_PSB_REGISTER_RW + DRM_COMMAND_BASE, \
+			 struct drm_psb_register_rw_arg)
+#define DRM_IOCTL_PSB_GTT_MAP	\
+		DRM_IOWR(DRM_PSB_GTT_MAP + DRM_COMMAND_BASE, \
+			 struct psb_gtt_mapping_arg)
+#define DRM_IOCTL_PSB_GTT_UNMAP	\
+		DRM_IOW(DRM_PSB_GTT_UNMAP + DRM_COMMAND_BASE, \
+			struct psb_gtt_mapping_arg)
+#define DRM_IOCTL_PSB_GETPAGEADDRS	\
+		DRM_IOWR(DRM_COMMAND_BASE + DRM_PSB_GETPAGEADDRS,\
+			 struct drm_psb_getpageaddrs_arg)
+#define DRM_IOCTL_PSB_HIST_ENABLE	\
+		DRM_IOWR(DRM_PSB_HIST_ENABLE + DRM_COMMAND_BASE, \
+			 uint32_t)
+#define DRM_IOCTL_PSB_HIST_STATUS	\
+		DRM_IOWR(DRM_PSB_HIST_STATUS + DRM_COMMAND_BASE, \
+			 struct drm_psb_hist_status_arg)
+#define DRM_IOCTL_PSB_UPDATE_GUARD	\
+		DRM_IOWR(DRM_PSB_UPDATE_GUARD + DRM_COMMAND_BASE, \
+			 uint32_t)
+#define DRM_IOCTL_PSB_DPST	\
+		DRM_IOWR(DRM_PSB_DPST + DRM_COMMAND_BASE, \
+			 uint32_t)
+#define DRM_IOCTL_PSB_GAMMA	\
+		DRM_IOWR(DRM_PSB_GAMMA + DRM_COMMAND_BASE, \
+			 struct drm_psb_dpst_lut_arg)
+#define DRM_IOCTL_PSB_DPST_BL	\
+		DRM_IOWR(DRM_PSB_DPST_BL + DRM_COMMAND_BASE, \
+			 uint32_t)
+#define DRM_IOCTL_PSB_GET_PIPE_FROM_CRTC_ID	\
+		DRM_IOWR(DRM_PSB_GET_PIPE_FROM_CRTC_ID + DRM_COMMAND_BASE, \
+			 struct drm_psb_get_pipe_from_crtc_id_arg)
+
+/*
+ * TTM execbuf extension.
+ */
+#define DRM_PSB_CMDBUF		  (DRM_PSB_DPU_DSR_OFF + 1)
+
+#define DRM_PSB_SCENE_UNREF	  (DRM_PSB_CMDBUF + 1)
+#define DRM_IOCTL_PSB_CMDBUF	\
+		DRM_IOW(DRM_PSB_CMDBUF + DRM_COMMAND_BASE,	\
+			struct drm_psb_cmdbuf_arg)
+#define DRM_IOCTL_PSB_SCENE_UNREF	\
+		DRM_IOW(DRM_PSB_SCENE_UNREF + DRM_COMMAND_BASE, \
+			struct drm_psb_scene)
+#define DRM_IOCTL_PSB_KMS_OFF	  DRM_IO(DRM_PSB_KMS_OFF + DRM_COMMAND_BASE)
+#define DRM_IOCTL_PSB_KMS_ON	  DRM_IO(DRM_PSB_KMS_ON + DRM_COMMAND_BASE)
+/*
+ * TTM placement user extension.
+ */
+
+#define DRM_PSB_PLACEMENT_OFFSET   (DRM_PSB_SCENE_UNREF + 1)
+
+#define DRM_PSB_TTM_PL_CREATE	 (TTM_PL_CREATE + DRM_PSB_PLACEMENT_OFFSET)
+#define DRM_PSB_TTM_PL_REFERENCE (TTM_PL_REFERENCE + DRM_PSB_PLACEMENT_OFFSET)
+#define DRM_PSB_TTM_PL_UNREF	 (TTM_PL_UNREF + DRM_PSB_PLACEMENT_OFFSET)
+#define DRM_PSB_TTM_PL_SYNCCPU	 (TTM_PL_SYNCCPU + DRM_PSB_PLACEMENT_OFFSET)
+#define DRM_PSB_TTM_PL_WAITIDLE  (TTM_PL_WAITIDLE + DRM_PSB_PLACEMENT_OFFSET)
+#define DRM_PSB_TTM_PL_SETSTATUS (TTM_PL_SETSTATUS + DRM_PSB_PLACEMENT_OFFSET)
+#define DRM_PSB_TTM_PL_CREATE_UB (TTM_PL_CREATE_UB + DRM_PSB_PLACEMENT_OFFSET)
+
+/*
+ * TTM fence extension.
+ */
+
+#define DRM_PSB_FENCE_OFFSET	   (DRM_PSB_TTM_PL_CREATE_UB + 1)
+#define DRM_PSB_TTM_FENCE_SIGNALED (TTM_FENCE_SIGNALED + DRM_PSB_FENCE_OFFSET)
+#define DRM_PSB_TTM_FENCE_FINISH   (TTM_FENCE_FINISH + DRM_PSB_FENCE_OFFSET)
+#define DRM_PSB_TTM_FENCE_UNREF    (TTM_FENCE_UNREF + DRM_PSB_FENCE_OFFSET)
+
+#define DRM_PSB_FLIP	   (DRM_PSB_TTM_FENCE_UNREF + 1)	/*20*/
+/* PSB video extension */
+#define DRM_LNC_VIDEO_GETPARAM		(DRM_PSB_FLIP + 1)
+
+#define DRM_IOCTL_PSB_TTM_PL_CREATE    \
+	DRM_IOWR(DRM_COMMAND_BASE + DRM_PSB_TTM_PL_CREATE,\
+		 union ttm_pl_create_arg)
+#define DRM_IOCTL_PSB_TTM_PL_REFERENCE \
+	DRM_IOWR(DRM_COMMAND_BASE + DRM_PSB_TTM_PL_REFERENCE,\
+		 union ttm_pl_reference_arg)
+#define DRM_IOCTL_PSB_TTM_PL_UNREF    \
+	DRM_IOW(DRM_COMMAND_BASE + DRM_PSB_TTM_PL_UNREF,\
+		struct ttm_pl_reference_req)
+#define DRM_IOCTL_PSB_TTM_PL_SYNCCPU	\
+	DRM_IOW(DRM_COMMAND_BASE + DRM_PSB_TTM_PL_SYNCCPU,\
+		struct ttm_pl_synccpu_arg)
+#define DRM_IOCTL_PSB_TTM_PL_WAITIDLE	 \
+	DRM_IOW(DRM_COMMAND_BASE + DRM_PSB_TTM_PL_WAITIDLE,\
+		struct ttm_pl_waitidle_arg)
+#define DRM_IOCTL_PSB_TTM_PL_SETSTATUS \
+	DRM_IOWR(DRM_COMMAND_BASE + DRM_PSB_TTM_PL_SETSTATUS,\
+		 union ttm_pl_setstatus_arg)
+#define DRM_IOCTL_PSB_TTM_PL_CREATE_UB    \
+	DRM_IOWR(DRM_COMMAND_BASE + DRM_PSB_TTM_PL_CREATE_UB,\
+		 union ttm_pl_create_ub_arg)
+#define DRM_IOCTL_PSB_TTM_FENCE_SIGNALED \
+	DRM_IOWR(DRM_COMMAND_BASE + DRM_PSB_TTM_FENCE_SIGNALED,	\
+		  union ttm_fence_signaled_arg)
+#define DRM_IOCTL_PSB_TTM_FENCE_FINISH \
+	DRM_IOWR(DRM_COMMAND_BASE + DRM_PSB_TTM_FENCE_FINISH,	\
+		 union ttm_fence_finish_arg)
+#define DRM_IOCTL_PSB_TTM_FENCE_UNREF \
+	DRM_IOW(DRM_COMMAND_BASE + DRM_PSB_TTM_FENCE_UNREF,	\
+		 struct ttm_fence_unref_arg)
+#define DRM_IOCTL_PSB_FLIP \
+	DRM_IOWR(DRM_COMMAND_BASE + DRM_PSB_FLIP, \
+		 struct drm_psb_pageflip_arg)
+#define DRM_IOCTL_LNC_VIDEO_GETPARAM \
+	DRM_IOWR(DRM_COMMAND_BASE + DRM_LNC_VIDEO_GETPARAM, \
+		 struct drm_lnc_video_getparam_arg)
+
+static int psb_vt_leave_ioctl(struct drm_device *dev, void *data,
+			      struct drm_file *file_priv);
+static int psb_vt_enter_ioctl(struct drm_device *dev, void *data,
+			      struct drm_file *file_priv);
+static int psb_sizes_ioctl(struct drm_device *dev, void *data,
+			   struct drm_file *file_priv);
+static int psb_dc_state_ioctl(struct drm_device *dev, void * data,
+			      struct drm_file *file_priv);
+static int psb_adb_ioctl(struct drm_device *dev, void *data,
+			 struct drm_file *file_priv);
+static int psb_mode_operation_ioctl(struct drm_device *dev, void *data,
+				    struct drm_file *file_priv);
+static int psb_stolen_memory_ioctl(struct drm_device *dev, void *data,
+				   struct drm_file *file_priv);
+static int psb_register_rw_ioctl(struct drm_device *dev, void *data,
+				 struct drm_file *file_priv);
+static int psb_dpst_ioctl(struct drm_device *dev, void *data,
+			  struct drm_file *file_priv);
+static int psb_gamma_ioctl(struct drm_device *dev, void *data,
+			   struct drm_file *file_priv);
+static int psb_dpst_bl_ioctl(struct drm_device *dev, void *data,
+			     struct drm_file *file_priv);
+
+#define PSB_IOCTL_DEF(ioctl, func, flags) \
+	[DRM_IOCTL_NR(ioctl) - DRM_COMMAND_BASE] = {ioctl, flags, func}
+
+static struct drm_ioctl_desc psb_ioctls[] = {
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_KMS_OFF, psbfb_kms_off_ioctl,
+		      DRM_ROOT_ONLY),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_KMS_ON,
+			psbfb_kms_on_ioctl,
+			DRM_ROOT_ONLY),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_VT_LEAVE, psb_vt_leave_ioctl,
+		      DRM_ROOT_ONLY),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_VT_ENTER,
+			psb_vt_enter_ioctl,
+			DRM_ROOT_ONLY),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_SIZES, psb_sizes_ioctl, DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_DC_STATE, psb_dc_state_ioctl, DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_ADB, psb_adb_ioctl, DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_MODE_OPERATION, psb_mode_operation_ioctl,
+		      DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_STOLEN_MEMORY, psb_stolen_memory_ioctl,
+		      DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_REGISTER_RW, psb_register_rw_ioctl,
+		      DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_GTT_MAP,
+			psb_gtt_map_meminfo_ioctl,
+			DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_GTT_UNMAP,
+			psb_gtt_unmap_meminfo_ioctl,
+			DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_GETPAGEADDRS,
+			psb_getpageaddrs_ioctl,
+			DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_DPST, psb_dpst_ioctl, DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_GAMMA, psb_gamma_ioctl, DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_DPST_BL, psb_dpst_bl_ioctl, DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_GET_PIPE_FROM_CRTC_ID,
+					psb_intel_get_pipe_from_crtc_id, 0),
+	/*to be removed later*/
+	/*PSB_IOCTL_DEF(DRM_IOCTL_PSB_SCENE_UNREF, drm_psb_scene_unref_ioctl,
+		      DRM_AUTH),*/
+
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_PL_CREATE, psb_pl_create_ioctl,
+		      DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_PL_REFERENCE, psb_pl_reference_ioctl,
+		      DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_PL_UNREF, psb_pl_unref_ioctl,
+		      DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_PL_SYNCCPU, psb_pl_synccpu_ioctl,
+		      DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_PL_WAITIDLE, psb_pl_waitidle_ioctl,
+		      DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_PL_SETSTATUS, psb_pl_setstatus_ioctl,
+		      DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_PL_CREATE_UB, psb_pl_ub_create_ioctl,
+		      DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_FENCE_SIGNALED,
+		      psb_fence_signaled_ioctl, DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_FENCE_FINISH, psb_fence_finish_ioctl,
+		      DRM_AUTH),
+	PSB_IOCTL_DEF(DRM_IOCTL_PSB_TTM_FENCE_UNREF, psb_fence_unref_ioctl,
+		      DRM_AUTH),
+};
+
+static void psb_set_uopt(struct drm_psb_uopt *uopt)
+{
+	return;
+}
+
+static void psb_lastclose(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv =
+	    (struct drm_psb_private *) dev->dev_private;
+
+	return;
+
+	if (!dev->dev_private)
+		return;
+
+	mutex_lock(&dev_priv->cmdbuf_mutex);
+	if (dev_priv->context.buffers) {
+		vfree(dev_priv->context.buffers);
+		dev_priv->context.buffers = NULL;
+	}
+	mutex_unlock(&dev_priv->cmdbuf_mutex);
+}
+
+static void psb_do_takedown(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv =
+	    (struct drm_psb_private *) dev->dev_private;
+	struct ttm_bo_device *bdev = &dev_priv->bdev;
+
+
+	if (dev_priv->have_mem_mmu) {
+		ttm_bo_clean_mm(bdev, DRM_PSB_MEM_MMU);
+		dev_priv->have_mem_mmu = 0;
+	}
+
+	if (dev_priv->have_tt) {
+		ttm_bo_clean_mm(bdev, TTM_PL_TT);
+		dev_priv->have_tt = 0;
+	}
+
+	if (dev_priv->have_camera) {
+		ttm_bo_clean_mm(bdev, TTM_PL_CI);
+		dev_priv->have_camera = 0;
+	}
+	if (dev_priv->have_rar) {
+		ttm_bo_clean_mm(bdev, TTM_PL_RAR);
+		dev_priv->have_rar = 0;
+	}
+
+}
+
+static void psb_get_core_freq(struct drm_device *dev)
+{
+	uint32_t clock;
+	struct pci_dev *pci_root = pci_get_bus_and_slot(0, 0);
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	/*pci_write_config_dword(pci_root, 0xD4, 0x00C32004);*/
+	/*pci_write_config_dword(pci_root, 0xD0, 0xE0033000);*/
+
+	pci_write_config_dword(pci_root, 0xD0, 0xD0050300);
+	pci_read_config_dword(pci_root, 0xD4, &clock);
+	pci_dev_put(pci_root);
+
+	switch (clock & 0x07) {
+	case 0:
+		dev_priv->core_freq = 100;
+		break;
+	case 1:
+		dev_priv->core_freq = 133;
+		break;
+	case 2:
+		dev_priv->core_freq = 150;
+		break;
+	case 3:
+		dev_priv->core_freq = 178;
+		break;
+	case 4:
+		dev_priv->core_freq = 200;
+		break;
+	case 5:
+	case 6:
+	case 7:
+		dev_priv->core_freq = 266;
+	default:
+		dev_priv->core_freq = 0;
+	}
+}
+
+#define FB_REG06 0xD0810600
+#define FB_TOPAZ_DISABLE BIT0
+#define FB_MIPI_DISABLE  BIT11
+#define FB_REG09 0xD0810900
+#define FB_SKU_MASK  (BIT12|BIT13|BIT14)
+#define FB_SKU_SHIFT 12
+#define FB_SKU_100 0
+#define FB_SKU_100L 1
+#define FB_SKU_83 2
+#if 1 /* FIXME remove it after PO */
+#define FB_GFX_CLK_DIVIDE_MASK	(BIT20|BIT21|BIT22)
+#define FB_GFX_CLK_DIVIDE_SHIFT 20
+#define FB_VED_CLK_DIVIDE_MASK	(BIT23|BIT24)
+#define FB_VED_CLK_DIVIDE_SHIFT 23
+#define FB_VEC_CLK_DIVIDE_MASK	(BIT25|BIT26)
+#define FB_VEC_CLK_DIVIDE_SHIFT 25
+#endif	/* FIXME remove it after PO */
+
+
+bool mid_get_pci_revID(struct drm_psb_private *dev_priv)
+{
+	uint32_t platform_rev_id = 0;
+	struct pci_dev *pci_gfx_root = pci_get_bus_and_slot(0, PCI_DEVFN(2, 0));
+
+	/*get the revison ID, B0:D2:F0;0x08 */
+	pci_read_config_dword(pci_gfx_root, 0x08, &platform_rev_id);
+	dev_priv->platform_rev_id = (uint8_t) platform_rev_id;
+	pci_dev_put(pci_gfx_root);
+	PSB_DEBUG_ENTRY("platform_rev_id is %x\n",
+					dev_priv->platform_rev_id);
+
+	return true;
+}
+
+static int psb_do_init(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv =
+	    (struct drm_psb_private *) dev->dev_private;
+	struct ttm_bo_device *bdev = &dev_priv->bdev;
+	struct psb_gtt *pg = dev_priv->pg;
+
+	uint32_t stolen_gtt;
+	uint32_t tt_start;
+	uint32_t tt_pages;
+
+	int ret = -ENOMEM;
+
+
+	/*
+	 * Initialize sequence numbers for the different command
+	 * submission mechanisms.
+	 */
+
+	dev_priv->sequence[PSB_ENGINE_2D] = 0;
+	dev_priv->sequence[PSB_ENGINE_VIDEO] = 0;
+	dev_priv->sequence[LNC_ENGINE_ENCODE] = 0;
+
+	if (pg->mmu_gatt_start & 0x0FFFFFFF) {
+		DRM_ERROR("Gatt must be 256M aligned. This is a bug.\n");
+		ret = -EINVAL;
+		goto out_err;
+	}
+
+	stolen_gtt = (pg->stolen_size >> PAGE_SHIFT) * 4;
+	stolen_gtt = (stolen_gtt + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	stolen_gtt =
+	    (stolen_gtt < pg->gtt_pages) ? stolen_gtt : pg->gtt_pages;
+
+	dev_priv->gatt_free_offset = pg->mmu_gatt_start +
+	    (stolen_gtt << PAGE_SHIFT) * 1024;
+
+	if (1 || drm_debug) {
+		uint32_t core_id = PSB_RSGX32(PSB_CR_CORE_ID);
+		uint32_t core_rev = PSB_RSGX32(PSB_CR_CORE_REVISION);
+		DRM_INFO("SGX core id = 0x%08x\n", core_id);
+		DRM_INFO("SGX core rev major = 0x%02x, minor = 0x%02x\n",
+			 (core_rev & _PSB_CC_REVISION_MAJOR_MASK) >>
+			 _PSB_CC_REVISION_MAJOR_SHIFT,
+			 (core_rev & _PSB_CC_REVISION_MINOR_MASK) >>
+			 _PSB_CC_REVISION_MINOR_SHIFT);
+		DRM_INFO
+		    ("SGX core rev maintenance = 0x%02x, designer = 0x%02x\n",
+		     (core_rev & _PSB_CC_REVISION_MAINTENANCE_MASK) >>
+		     _PSB_CC_REVISION_MAINTENANCE_SHIFT,
+		     (core_rev & _PSB_CC_REVISION_DESIGNER_MASK) >>
+		     _PSB_CC_REVISION_DESIGNER_SHIFT);
+	}
+
+	spin_lock_init(&dev_priv->irqmask_lock);
+
+	tt_pages = (pg->gatt_pages < PSB_TT_PRIV0_PLIMIT) ?
+	    pg->gatt_pages : PSB_TT_PRIV0_PLIMIT;
+	tt_start = dev_priv->gatt_free_offset - pg->mmu_gatt_start;
+	tt_pages -= tt_start >> PAGE_SHIFT;
+	dev_priv->sizes.ta_mem_size = 0;
+
+
+	/* TT region managed by TTM. */
+	if (!ttm_bo_init_mm(bdev, TTM_PL_TT,
+			pg->gatt_pages -
+			(pg->ci_start >> PAGE_SHIFT) -
+			((dev_priv->ci_region_size + dev_priv->rar_region_size)
+			 >> PAGE_SHIFT))) {
+
+		dev_priv->have_tt = 1;
+		dev_priv->sizes.tt_size =
+			(tt_pages << PAGE_SHIFT) / (1024 * 1024) / 2;
+	}
+
+	if (!ttm_bo_init_mm(bdev,
+			DRM_PSB_MEM_MMU,
+			PSB_MEM_TT_START >> PAGE_SHIFT)) {
+		dev_priv->have_mem_mmu = 1;
+		dev_priv->sizes.mmu_size =
+			PSB_MEM_TT_START / (1024*1024);
+	}
+
+
+	PSB_DEBUG_INIT("Init MSVDX\n");
+	return 0;
+out_err:
+	psb_do_takedown(dev);
+	return ret;
+}
+
+static int psb_driver_unload(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv =
+	    (struct drm_psb_private *) dev->dev_private;
+
+	/* Kill vblank etc here */
+
+	psb_backlight_exit(); /*writes minimum value to backlight HW reg */
+
+	if (drm_psb_no_fb == 0)
+		psb_modeset_cleanup(dev);
+
+	if (dev_priv) {
+		psb_lid_timer_takedown(dev_priv);
+
+		psb_do_takedown(dev);
+
+
+		if (dev_priv->pf_pd) {
+			psb_mmu_free_pagedir(dev_priv->pf_pd);
+			dev_priv->pf_pd = NULL;
+		}
+		if (dev_priv->mmu) {
+			struct psb_gtt *pg = dev_priv->pg;
+
+			down_read(&pg->sem);
+			psb_mmu_remove_pfn_sequence(
+					psb_mmu_get_default_pd
+					(dev_priv->mmu),
+					pg->mmu_gatt_start,
+					pg->vram_stolen_size >> PAGE_SHIFT);
+			if (pg->ci_stolen_size != 0)
+				psb_mmu_remove_pfn_sequence(
+					psb_mmu_get_default_pd
+					(dev_priv->mmu),
+					pg->ci_start,
+					pg->ci_stolen_size >> PAGE_SHIFT);
+			if (pg->rar_stolen_size != 0)
+				psb_mmu_remove_pfn_sequence(
+					psb_mmu_get_default_pd
+					(dev_priv->mmu),
+					pg->rar_start,
+					pg->rar_stolen_size >> PAGE_SHIFT);
+			up_read(&pg->sem);
+			psb_mmu_driver_takedown(dev_priv->mmu);
+			dev_priv->mmu = NULL;
+		}
+		psb_gtt_takedown(dev_priv->pg, 1);
+		if (dev_priv->scratch_page) {
+			__free_page(dev_priv->scratch_page);
+			dev_priv->scratch_page = NULL;
+		}
+		if (dev_priv->has_bo_device) {
+			ttm_bo_device_release(&dev_priv->bdev);
+			dev_priv->has_bo_device = 0;
+		}
+		if (dev_priv->has_fence_device) {
+			ttm_fence_device_release(&dev_priv->fdev);
+			dev_priv->has_fence_device = 0;
+		}
+		if (dev_priv->vdc_reg) {
+			iounmap(dev_priv->vdc_reg);
+			dev_priv->vdc_reg = NULL;
+		}
+		if (dev_priv->sgx_reg) {
+			iounmap(dev_priv->sgx_reg);
+			dev_priv->sgx_reg = NULL;
+		}
+
+		if (dev_priv->tdev)
+			ttm_object_device_release(&dev_priv->tdev);
+
+		if (dev_priv->has_global)
+			psb_ttm_global_release(dev_priv);
+
+		kfree(dev_priv);
+		dev->dev_private = NULL;
+
+		/*destory VBT data*/
+		psb_intel_destory_bios(dev);
+	}
+
+	ospm_power_uninit();
+
+	return 0;
+}
+
+
+static int psb_driver_load(struct drm_device *dev, unsigned long chipset)
+{
+	struct drm_psb_private *dev_priv;
+	struct ttm_bo_device *bdev;
+	unsigned long resource_start;
+	struct psb_gtt *pg;
+	unsigned long irqflags;
+	int ret = -ENOMEM;
+	uint32_t tt_pages;
+
+	DRM_INFO("psb - %s\n", PSB_PACKAGE_VERSION);
+
+	DRM_INFO("Run drivers on Poulsbo platform!\n");
+
+	dev_priv = kzalloc(sizeof(*dev_priv), GFP_KERNEL);
+	if (dev_priv == NULL)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&dev_priv->video_ctx);
+
+	dev_priv->num_pipe = 2;
+
+
+	dev_priv->dev = dev;
+	bdev = &dev_priv->bdev;
+
+	ret = psb_ttm_global_init(dev_priv);
+	if (unlikely(ret != 0))
+		goto out_err;
+	dev_priv->has_global = 1;
+
+	dev_priv->tdev = ttm_object_device_init
+		(dev_priv->mem_global_ref.object, PSB_OBJECT_HASH_ORDER);
+	if (unlikely(dev_priv->tdev == NULL))
+		goto out_err;
+
+	mutex_init(&dev_priv->temp_mem);
+	mutex_init(&dev_priv->cmdbuf_mutex);
+	mutex_init(&dev_priv->reset_mutex);
+	INIT_LIST_HEAD(&dev_priv->context.validate_list);
+	INIT_LIST_HEAD(&dev_priv->context.kern_validate_list);
+
+/*	mutex_init(&dev_priv->dsr_mutex); */
+
+	spin_lock_init(&dev_priv->reloc_lock);
+
+	DRM_INIT_WAITQUEUE(&dev_priv->rel_mapped_queue);
+
+	dev->dev_private = (void *) dev_priv;
+	dev_priv->chipset = chipset;
+	psb_set_uopt(&dev_priv->uopt);
+
+	PSB_DEBUG_INIT("Mapping MMIO\n");
+	resource_start = pci_resource_start(dev->pdev, PSB_MMIO_RESOURCE);
+
+	dev_priv->vdc_reg =
+	    ioremap(resource_start + PSB_VDC_OFFSET, PSB_VDC_SIZE);
+	if (!dev_priv->vdc_reg)
+		goto out_err;
+
+	dev_priv->sgx_reg = ioremap(resource_start + PSB_SGX_OFFSET,
+							PSB_SGX_SIZE);
+
+	if (!dev_priv->sgx_reg)
+		goto out_err;
+
+	psb_get_core_freq(dev);
+	psb_intel_opregion_init(dev);
+	psb_intel_init_bios(dev);
+
+	PSB_DEBUG_INIT("Init TTM fence and BO driver\n");
+
+	/* Init OSPM support */
+	ospm_power_init(dev);
+
+	ret = psb_ttm_fence_device_init(&dev_priv->fdev);
+	if (unlikely(ret != 0))
+		goto out_err;
+
+	dev_priv->has_fence_device = 1;
+	ret = ttm_bo_device_init(bdev,
+				 dev_priv->bo_global_ref.ref.object,
+				 &psb_ttm_bo_driver,
+				 DRM_PSB_FILE_PAGE_OFFSET, false);
+	if (unlikely(ret != 0))
+		goto out_err;
+	dev_priv->has_bo_device = 1;
+	ttm_lock_init(&dev_priv->ttm_lock);
+
+	ret = -ENOMEM;
+
+	dev_priv->scratch_page = alloc_page(GFP_DMA32 | __GFP_ZERO);
+	if (!dev_priv->scratch_page)
+		goto out_err;
+
+	set_pages_uc(dev_priv->scratch_page, 1);
+
+	dev_priv->pg = psb_gtt_alloc(dev);
+	if (!dev_priv->pg)
+		goto out_err;
+
+	ret = psb_gtt_init(dev_priv->pg, 0);
+	if (ret)
+		goto out_err;
+
+	ret = psb_gtt_mm_init(dev_priv->pg);
+	if (ret)
+		goto out_err;
+
+	dev_priv->mmu = psb_mmu_driver_init((void *)0,
+					drm_psb_trap_pagefaults, 0,
+					dev_priv);
+	if (!dev_priv->mmu)
+		goto out_err;
+
+	pg = dev_priv->pg;
+
+	tt_pages = (pg->gatt_pages < PSB_TT_PRIV0_PLIMIT) ?
+		(pg->gatt_pages) : PSB_TT_PRIV0_PLIMIT;
+
+	/* CI/RAR use the lower half of TT. */
+	pg->ci_start = (tt_pages / 2) << PAGE_SHIFT;
+	pg->rar_start = pg->ci_start + pg->ci_stolen_size;
+
+
+	/*
+	 * Make MSVDX/TOPAZ MMU aware of the CI stolen memory area.
+	 */
+	if (dev_priv->pg->ci_stolen_size != 0) {
+		down_read(&pg->sem);
+		ret = psb_mmu_insert_pfn_sequence(psb_mmu_get_default_pd
+				(dev_priv->mmu),
+				dev_priv->ci_region_start >> PAGE_SHIFT,
+				pg->mmu_gatt_start + pg->ci_start,
+				pg->ci_stolen_size >> PAGE_SHIFT, 0);
+		up_read(&pg->sem);
+		if (ret)
+			goto out_err;
+	}
+
+	/*
+	 * Make MSVDX/TOPAZ MMU aware of the rar stolen memory area.
+	 */
+	if (dev_priv->pg->rar_stolen_size != 0) {
+		down_read(&pg->sem);
+		ret = psb_mmu_insert_pfn_sequence(
+				psb_mmu_get_default_pd(dev_priv->mmu),
+				dev_priv->rar_region_start >> PAGE_SHIFT,
+				pg->mmu_gatt_start + pg->rar_start,
+				pg->rar_stolen_size >> PAGE_SHIFT, 0);
+		up_read(&pg->sem);
+		if (ret)
+			goto out_err;
+	}
+
+	dev_priv->pf_pd = psb_mmu_alloc_pd(dev_priv->mmu, 1, 0);
+	if (!dev_priv->pf_pd)
+		goto out_err;
+
+	psb_mmu_set_pd_context(psb_mmu_get_default_pd(dev_priv->mmu), 0);
+	psb_mmu_set_pd_context(dev_priv->pf_pd, 1);
+
+	spin_lock_init(&dev_priv->sequence_lock);
+
+	PSB_DEBUG_INIT("Begin to init MSVDX/Topaz\n");
+
+	ret = psb_do_init(dev);
+	if (ret)
+		return ret;
+
+	/**
+	 *  Init lid switch timer.
+	 *  NOTE: must do this after psb_intel_opregion_init
+	 *  and psb_backlight_init
+	 */
+	if (dev_priv->lid_state)
+		psb_lid_timer_init(dev_priv);
+
+	ret = drm_vblank_init(dev, dev_priv->num_pipe);
+	if (ret)
+		goto out_err;
+
+	/*
+	 * Install interrupt handlers prior to powering off SGX or else we will
+	 * crash.
+	 */
+	dev_priv->vdc_irq_mask = 0;
+	dev_priv->pipestat[0] = 0;
+	dev_priv->pipestat[1] = 0;
+	dev_priv->pipestat[2] = 0;
+	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
+	PSB_WVDC32(0x00000000, PSB_INT_ENABLE_R);
+	PSB_WVDC32(0xFFFFFFFF, PSB_INT_MASK_R);
+	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
+	if (drm_core_check_feature(dev, DRIVER_MODESET))
+		drm_irq_install(dev);
+
+	dev->vblank_disable_allowed = 1;
+
+	dev->max_vblank_count = 0xffffff; /* only 24 bits of frame count */
+
+	dev->driver->get_vblank_counter = psb_get_vblank_counter;
+
+	if (drm_psb_no_fb == 0) {
+		psb_modeset_init(dev);
+		psb_fbdev_init(dev);
+		drm_kms_helper_poll_init(dev);
+	}
+
+	ret = psb_backlight_init(dev);
+	if (ret)
+		return ret;
+#if 0
+	/*enable runtime pm at last*/
+	pm_runtime_enable(&dev->pdev->dev);
+	pm_runtime_set_active(&dev->pdev->dev);
+#endif
+	/*Intel drm driver load is done, continue doing pvr load*/
+	DRM_DEBUG("Pvr driver load\n");
+
+/*	if (PVRCore_Init() < 0)
+		goto out_err; */
+/*	if (MRSTLFBInit(dev) < 0)
+		goto out_err;*/
+	return 0;
+out_err:
+	psb_driver_unload(dev);
+	return ret;
+}
+
+int psb_driver_device_is_agp(struct drm_device *dev)
+{
+	return 0;
+}
+
+
+static int psb_vt_leave_ioctl(struct drm_device *dev, void *data,
+			      struct drm_file *file_priv)
+{
+	struct drm_psb_private *dev_priv = psb_priv(dev);
+	struct ttm_bo_device *bdev = &dev_priv->bdev;
+	struct ttm_mem_type_manager *man;
+	int ret;
+
+	ret = ttm_vt_lock(&dev_priv->ttm_lock, 1,
+			     psb_fpriv(file_priv)->tfile);
+	if (unlikely(ret != 0))
+		return ret;
+
+	ret = ttm_bo_evict_mm(&dev_priv->bdev, TTM_PL_TT);
+	if (unlikely(ret != 0))
+		goto out_unlock;
+
+	man = &bdev->man[TTM_PL_TT];
+
+#if 0		/* What to do with this ? */
+	if (unlikely(!drm_mm_clean(&man->manager)))
+		DRM_INFO("Warning: GATT was not clean after VT switch.\n");
+#endif
+
+	ttm_bo_swapout_all(&dev_priv->bdev);
+
+	return 0;
+out_unlock:
+	(void) ttm_vt_unlock(&dev_priv->ttm_lock);
+	return ret;
+}
+
+static int psb_vt_enter_ioctl(struct drm_device *dev, void *data,
+			      struct drm_file *file_priv)
+{
+	struct drm_psb_private *dev_priv = psb_priv(dev);
+	return ttm_vt_unlock(&dev_priv->ttm_lock);
+}
+
+static int psb_sizes_ioctl(struct drm_device *dev, void *data,
+			   struct drm_file *file_priv)
+{
+	struct drm_psb_private *dev_priv = psb_priv(dev);
+	struct drm_psb_sizes_arg *arg =
+		(struct drm_psb_sizes_arg *) data;
+
+	*arg = dev_priv->sizes;
+	return 0;
+}
+
+static int psb_dc_state_ioctl(struct drm_device *dev, void * data,
+				struct drm_file *file_priv)
+{
+	uint32_t flags;
+	uint32_t obj_id;
+	struct drm_mode_object *obj;
+	struct drm_connector *connector;
+	struct drm_crtc *crtc;
+	struct drm_psb_dc_state_arg *arg =
+		(struct drm_psb_dc_state_arg *)data;
+
+	flags = arg->flags;
+	obj_id = arg->obj_id;
+
+	if (flags & PSB_DC_CRTC_MASK) {
+		obj = drm_mode_object_find(dev, obj_id,
+				DRM_MODE_OBJECT_CRTC);
+		if (!obj) {
+			DRM_DEBUG("Invalid CRTC object.\n");
+			return -EINVAL;
+		}
+
+		crtc = obj_to_crtc(obj);
+
+		mutex_lock(&dev->mode_config.mutex);
+		if (drm_helper_crtc_in_use(crtc)) {
+			if (flags & PSB_DC_CRTC_SAVE)
+				crtc->funcs->save(crtc);
+			else
+				crtc->funcs->restore(crtc);
+		}
+		mutex_unlock(&dev->mode_config.mutex);
+
+		return 0;
+	} else if (flags & PSB_DC_OUTPUT_MASK) {
+		obj = drm_mode_object_find(dev, obj_id,
+				DRM_MODE_OBJECT_CONNECTOR);
+		if (!obj) {
+			DRM_DEBUG("Invalid connector id.\n");
+			return -EINVAL;
+		}
+
+		connector = obj_to_connector(obj);
+		if (flags & PSB_DC_OUTPUT_SAVE)
+			connector->funcs->save(connector);
+		else
+			connector->funcs->restore(connector);
+
+		return 0;
+	}
+
+	DRM_DEBUG("Bad flags 0x%x\n", flags);
+	return -EINVAL;
+}
+
+static int psb_dpst_bl_ioctl(struct drm_device *dev, void *data,
+		       struct drm_file *file_priv)
+{
+	struct drm_psb_private *dev_priv = psb_priv(dev);
+	uint32_t *arg = data;
+	struct backlight_device bd;
+	dev_priv->blc_adj2 = *arg;
+
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+	bd.props.brightness = psb_get_brightness(&bd);
+	psb_set_brightness(&bd);
+#endif
+	return 0;
+}
+
+static int psb_adb_ioctl(struct drm_device *dev, void *data,
+			struct drm_file *file_priv)
+{
+	struct drm_psb_private *dev_priv = psb_priv(dev);
+	uint32_t *arg = data;
+	struct backlight_device bd;
+	dev_priv->blc_adj1 = *arg;
+
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+	bd.props.brightness = psb_get_brightness(&bd);
+	psb_set_brightness(&bd);
+#endif
+	return 0;
+}
+
+/* return the current mode to the dpst module */
+static int psb_dpst_ioctl(struct drm_device *dev, void *data,
+			  struct drm_file *file_priv)
+{
+	struct drm_psb_private *dev_priv = psb_priv(dev);
+	uint32_t *arg = data;
+	uint32_t x;
+	uint32_t y;
+	uint32_t reg;
+
+	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+							OSPM_UHB_ONLY_IF_ON))
+		return 0;
+
+	reg = PSB_RVDC32(PIPEASRC);
+
+	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+
+	/* horizontal is the left 16 bits */
+	x = reg >> 16;
+	/* vertical is the right 16 bits */
+	y = reg & 0x0000ffff;
+
+	/* the values are the image size minus one */
+	x++;
+	y++;
+
+	*arg = (x << 16) | y;
+
+	return 0;
+}
+static int psb_gamma_ioctl(struct drm_device *dev, void *data,
+			   struct drm_file *file_priv)
+{
+	struct drm_psb_dpst_lut_arg *lut_arg = data;
+	struct drm_mode_object *obj;
+	struct drm_crtc *crtc;
+	struct drm_connector *connector;
+	struct psb_intel_crtc *psb_intel_crtc;
+	int i = 0;
+	int32_t obj_id;
+
+	obj_id = lut_arg->output_id;
+	obj = drm_mode_object_find(dev, obj_id, DRM_MODE_OBJECT_CONNECTOR);
+	if (!obj) {
+		DRM_DEBUG("Invalid Connector object.\n");
+		return -EINVAL;
+	}
+
+	connector = obj_to_connector(obj);
+	crtc = connector->encoder->crtc;
+	psb_intel_crtc = to_psb_intel_crtc(crtc);
+
+	for (i = 0; i < 256; i++)
+		psb_intel_crtc->lut_adj[i] = lut_arg->lut[i];
+
+	psb_intel_crtc_load_lut(crtc);
+
+	return 0;
+}
+
+static int psb_mode_operation_ioctl(struct drm_device *dev, void *data,
+				struct drm_file *file_priv)
+{
+	uint32_t obj_id;
+	uint16_t op;
+	struct drm_mode_modeinfo *umode;
+	struct drm_display_mode *mode = NULL;
+	struct drm_psb_mode_operation_arg *arg;
+	struct drm_mode_object *obj;
+	struct drm_connector *connector;
+	struct drm_framebuffer *drm_fb;
+	struct psb_framebuffer *psb_fb;
+	struct drm_connector_helper_funcs *connector_funcs;
+	int ret = 0;
+	int resp = MODE_OK;
+	struct drm_psb_private *dev_priv = psb_priv(dev);
+
+	arg = (struct drm_psb_mode_operation_arg *)data;
+	obj_id = arg->obj_id;
+	op = arg->operation;
+
+	switch (op) {
+	case PSB_MODE_OPERATION_SET_DC_BASE:
+		obj = drm_mode_object_find(dev, obj_id, DRM_MODE_OBJECT_FB);
+		if (!obj) {
+			DRM_ERROR("Invalid FB id %d\n", obj_id);
+			return -EINVAL;
+		}
+
+		drm_fb = obj_to_fb(obj);
+		psb_fb = to_psb_fb(drm_fb);
+
+		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+					      OSPM_UHB_ONLY_IF_ON)) {
+			REG_WRITE(DSPASURF, psb_fb->offset);
+			REG_READ(DSPASURF);
+			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		} else {
+			dev_priv->saveDSPASURF = psb_fb->offset;
+		}
+
+		return 0;
+	case PSB_MODE_OPERATION_MODE_VALID:
+		umode = &arg->mode;
+
+		mutex_lock(&dev->mode_config.mutex);
+
+		obj = drm_mode_object_find(dev, obj_id,
+					DRM_MODE_OBJECT_CONNECTOR);
+		if (!obj) {
+			ret = -EINVAL;
+			goto mode_op_out;
+		}
+
+		connector = obj_to_connector(obj);
+
+		mode = drm_mode_create(dev);
+		if (!mode) {
+			ret = -ENOMEM;
+			goto mode_op_out;
+		}
+
+		/* drm_crtc_convert_umode(mode, umode); */
+		{
+			mode->clock = umode->clock;
+			mode->hdisplay = umode->hdisplay;
+			mode->hsync_start = umode->hsync_start;
+			mode->hsync_end = umode->hsync_end;
+			mode->htotal = umode->htotal;
+			mode->hskew = umode->hskew;
+			mode->vdisplay = umode->vdisplay;
+			mode->vsync_start = umode->vsync_start;
+			mode->vsync_end = umode->vsync_end;
+			mode->vtotal = umode->vtotal;
+			mode->vscan = umode->vscan;
+			mode->vrefresh = umode->vrefresh;
+			mode->flags = umode->flags;
+			mode->type = umode->type;
+			strncpy(mode->name, umode->name, DRM_DISPLAY_MODE_LEN);
+			mode->name[DRM_DISPLAY_MODE_LEN-1] = 0;
+		}
+
+		connector_funcs = (struct drm_connector_helper_funcs *)
+				   connector->helper_private;
+
+		if (connector_funcs->mode_valid) {
+			resp = connector_funcs->mode_valid(connector, mode);
+			arg->data = (void *)resp;
+		}
+
+		/*do some clean up work*/
+		if (mode)
+			drm_mode_destroy(dev, mode);
+mode_op_out:
+		mutex_unlock(&dev->mode_config.mutex);
+		return ret;
+
+	default:
+		DRM_DEBUG("Unsupported psb mode operation");
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
+static int psb_stolen_memory_ioctl(struct drm_device *dev, void *data,
+				   struct drm_file *file_priv)
+{
+	struct drm_psb_private *dev_priv = psb_priv(dev);
+	struct drm_psb_stolen_memory_arg *arg = data;
+
+	arg->base = dev_priv->pg->stolen_base;
+	arg->size = dev_priv->pg->vram_stolen_size;
+
+	return 0;
+}
+
+static int psb_register_rw_ioctl(struct drm_device *dev, void *data,
+				 struct drm_file *file_priv)
+{
+	struct drm_psb_private *dev_priv = psb_priv(dev);
+	struct drm_psb_register_rw_arg *arg = data;
+	UHBUsage usage =
+	  arg->b_force_hw_on ? OSPM_UHB_FORCE_POWER_ON : OSPM_UHB_ONLY_IF_ON;
+
+	if (arg->display_write_mask != 0) {
+		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, usage)) {
+			if (arg->display_write_mask & REGRWBITS_PFIT_CONTROLS)
+				PSB_WVDC32(arg->display.pfit_controls,
+					   PFIT_CONTROL);
+			if (arg->display_write_mask &
+			    REGRWBITS_PFIT_AUTOSCALE_RATIOS)
+				PSB_WVDC32(arg->display.pfit_autoscale_ratios,
+					   PFIT_AUTO_RATIOS);
+			if (arg->display_write_mask &
+			    REGRWBITS_PFIT_PROGRAMMED_SCALE_RATIOS)
+				PSB_WVDC32(
+				   arg->display.pfit_programmed_scale_ratios,
+				   PFIT_PGM_RATIOS);
+			if (arg->display_write_mask & REGRWBITS_PIPEASRC)
+				PSB_WVDC32(arg->display.pipeasrc,
+					   PIPEASRC);
+			if (arg->display_write_mask & REGRWBITS_PIPEBSRC)
+				PSB_WVDC32(arg->display.pipebsrc,
+					   PIPEBSRC);
+			if (arg->display_write_mask & REGRWBITS_VTOTAL_A)
+				PSB_WVDC32(arg->display.vtotal_a,
+					   VTOTAL_A);
+			if (arg->display_write_mask & REGRWBITS_VTOTAL_B)
+				PSB_WVDC32(arg->display.vtotal_b,
+					   VTOTAL_B);
+			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		} else {
+			if (arg->display_write_mask & REGRWBITS_PFIT_CONTROLS)
+				dev_priv->savePFIT_CONTROL =
+						arg->display.pfit_controls;
+			if (arg->display_write_mask &
+			    REGRWBITS_PFIT_AUTOSCALE_RATIOS)
+				dev_priv->savePFIT_AUTO_RATIOS =
+					arg->display.pfit_autoscale_ratios;
+			if (arg->display_write_mask &
+			    REGRWBITS_PFIT_PROGRAMMED_SCALE_RATIOS)
+				dev_priv->savePFIT_PGM_RATIOS =
+				   arg->display.pfit_programmed_scale_ratios;
+			if (arg->display_write_mask & REGRWBITS_PIPEASRC)
+				dev_priv->savePIPEASRC = arg->display.pipeasrc;
+			if (arg->display_write_mask & REGRWBITS_PIPEBSRC)
+				dev_priv->savePIPEBSRC = arg->display.pipebsrc;
+			if (arg->display_write_mask & REGRWBITS_VTOTAL_A)
+				dev_priv->saveVTOTAL_A = arg->display.vtotal_a;
+			if (arg->display_write_mask & REGRWBITS_VTOTAL_B)
+				dev_priv->saveVTOTAL_B = arg->display.vtotal_b;
+		}
+	}
+
+	if (arg->display_read_mask != 0) {
+		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, usage)) {
+			if (arg->display_read_mask &
+			    REGRWBITS_PFIT_CONTROLS)
+				arg->display.pfit_controls =
+						PSB_RVDC32(PFIT_CONTROL);
+			if (arg->display_read_mask &
+			    REGRWBITS_PFIT_AUTOSCALE_RATIOS)
+				arg->display.pfit_autoscale_ratios =
+						PSB_RVDC32(PFIT_AUTO_RATIOS);
+			if (arg->display_read_mask &
+			    REGRWBITS_PFIT_PROGRAMMED_SCALE_RATIOS)
+				arg->display.pfit_programmed_scale_ratios =
+						PSB_RVDC32(PFIT_PGM_RATIOS);
+			if (arg->display_read_mask & REGRWBITS_PIPEASRC)
+				arg->display.pipeasrc = PSB_RVDC32(PIPEASRC);
+			if (arg->display_read_mask & REGRWBITS_PIPEBSRC)
+				arg->display.pipebsrc = PSB_RVDC32(PIPEBSRC);
+			if (arg->display_read_mask & REGRWBITS_VTOTAL_A)
+				arg->display.vtotal_a = PSB_RVDC32(VTOTAL_A);
+			if (arg->display_read_mask & REGRWBITS_VTOTAL_B)
+				arg->display.vtotal_b = PSB_RVDC32(VTOTAL_B);
+			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		} else {
+			if (arg->display_read_mask &
+			    REGRWBITS_PFIT_CONTROLS)
+				arg->display.pfit_controls =
+						dev_priv->savePFIT_CONTROL;
+			if (arg->display_read_mask &
+			    REGRWBITS_PFIT_AUTOSCALE_RATIOS)
+				arg->display.pfit_autoscale_ratios =
+						dev_priv->savePFIT_AUTO_RATIOS;
+			if (arg->display_read_mask &
+			    REGRWBITS_PFIT_PROGRAMMED_SCALE_RATIOS)
+				arg->display.pfit_programmed_scale_ratios =
+						dev_priv->savePFIT_PGM_RATIOS;
+			if (arg->display_read_mask & REGRWBITS_PIPEASRC)
+				arg->display.pipeasrc = dev_priv->savePIPEASRC;
+			if (arg->display_read_mask & REGRWBITS_PIPEBSRC)
+				arg->display.pipebsrc = dev_priv->savePIPEBSRC;
+			if (arg->display_read_mask & REGRWBITS_VTOTAL_A)
+				arg->display.vtotal_a = dev_priv->saveVTOTAL_A;
+			if (arg->display_read_mask & REGRWBITS_VTOTAL_B)
+				arg->display.vtotal_b = dev_priv->saveVTOTAL_B;
+		}
+	}
+
+	if (arg->overlay_write_mask != 0) {
+		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, usage)) {
+			if (arg->overlay_write_mask & OV_REGRWBITS_OGAM_ALL) {
+				PSB_WVDC32(arg->overlay.OGAMC5, OV_OGAMC5);
+				PSB_WVDC32(arg->overlay.OGAMC4, OV_OGAMC4);
+				PSB_WVDC32(arg->overlay.OGAMC3, OV_OGAMC3);
+				PSB_WVDC32(arg->overlay.OGAMC2, OV_OGAMC2);
+				PSB_WVDC32(arg->overlay.OGAMC1, OV_OGAMC1);
+				PSB_WVDC32(arg->overlay.OGAMC0, OV_OGAMC0);
+			}
+			if (arg->overlay_write_mask & OVC_REGRWBITS_OGAM_ALL) {
+				PSB_WVDC32(arg->overlay.OGAMC5, OVC_OGAMC5);
+				PSB_WVDC32(arg->overlay.OGAMC4, OVC_OGAMC4);
+				PSB_WVDC32(arg->overlay.OGAMC3, OVC_OGAMC3);
+				PSB_WVDC32(arg->overlay.OGAMC2, OVC_OGAMC2);
+				PSB_WVDC32(arg->overlay.OGAMC1, OVC_OGAMC1);
+				PSB_WVDC32(arg->overlay.OGAMC0, OVC_OGAMC0);
+			}
+
+			if (arg->overlay_write_mask & OV_REGRWBITS_OVADD) {
+				PSB_WVDC32(arg->overlay.OVADD, OV_OVADD);
+
+				if (arg->overlay.b_wait_vblank) {
+					/* Wait for 20ms.*/
+					unsigned long vblank_timeout = jiffies
+								+ HZ/50;
+					uint32_t temp;
+					while (time_before_eq(jiffies,
+							vblank_timeout)) {
+						temp = PSB_RVDC32(OV_DOVASTA);
+						if ((temp & (0x1 << 31)) != 0)
+							break;
+						cpu_relax();
+					}
+				}
+			}
+			if (arg->overlay_write_mask & OVC_REGRWBITS_OVADD) {
+				PSB_WVDC32(arg->overlay.OVADD, OVC_OVADD);
+				if (arg->overlay.b_wait_vblank) {
+					/* Wait for 20ms.*/
+					unsigned long vblank_timeout =
+							jiffies + HZ/50;
+					uint32_t temp;
+					while (time_before_eq(jiffies,
+							vblank_timeout)) {
+						temp = PSB_RVDC32(OVC_DOVCSTA);
+						if ((temp & (0x1 << 31)) != 0)
+							break;
+						cpu_relax();
+					}
+				}
+			}
+			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		} else {
+			if (arg->overlay_write_mask & OV_REGRWBITS_OGAM_ALL) {
+				dev_priv->saveOV_OGAMC5 = arg->overlay.OGAMC5;
+				dev_priv->saveOV_OGAMC4 = arg->overlay.OGAMC4;
+				dev_priv->saveOV_OGAMC3 = arg->overlay.OGAMC3;
+				dev_priv->saveOV_OGAMC2 = arg->overlay.OGAMC2;
+				dev_priv->saveOV_OGAMC1 = arg->overlay.OGAMC1;
+				dev_priv->saveOV_OGAMC0 = arg->overlay.OGAMC0;
+			}
+			if (arg->overlay_write_mask & OVC_REGRWBITS_OGAM_ALL) {
+				dev_priv->saveOVC_OGAMC5 = arg->overlay.OGAMC5;
+				dev_priv->saveOVC_OGAMC4 = arg->overlay.OGAMC4;
+				dev_priv->saveOVC_OGAMC3 = arg->overlay.OGAMC3;
+				dev_priv->saveOVC_OGAMC2 = arg->overlay.OGAMC2;
+				dev_priv->saveOVC_OGAMC1 = arg->overlay.OGAMC1;
+				dev_priv->saveOVC_OGAMC0 = arg->overlay.OGAMC0;
+			}
+			if (arg->overlay_write_mask & OV_REGRWBITS_OVADD)
+				dev_priv->saveOV_OVADD = arg->overlay.OVADD;
+			if (arg->overlay_write_mask & OVC_REGRWBITS_OVADD)
+				dev_priv->saveOVC_OVADD = arg->overlay.OVADD;
+		}
+	}
+
+	if (arg->overlay_read_mask != 0) {
+		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, usage)) {
+			if (arg->overlay_read_mask & OV_REGRWBITS_OGAM_ALL) {
+				arg->overlay.OGAMC5 = PSB_RVDC32(OV_OGAMC5);
+				arg->overlay.OGAMC4 = PSB_RVDC32(OV_OGAMC4);
+				arg->overlay.OGAMC3 = PSB_RVDC32(OV_OGAMC3);
+				arg->overlay.OGAMC2 = PSB_RVDC32(OV_OGAMC2);
+				arg->overlay.OGAMC1 = PSB_RVDC32(OV_OGAMC1);
+				arg->overlay.OGAMC0 = PSB_RVDC32(OV_OGAMC0);
+			}
+			if (arg->overlay_read_mask & OVC_REGRWBITS_OGAM_ALL) {
+				arg->overlay.OGAMC5 = PSB_RVDC32(OVC_OGAMC5);
+				arg->overlay.OGAMC4 = PSB_RVDC32(OVC_OGAMC4);
+				arg->overlay.OGAMC3 = PSB_RVDC32(OVC_OGAMC3);
+				arg->overlay.OGAMC2 = PSB_RVDC32(OVC_OGAMC2);
+				arg->overlay.OGAMC1 = PSB_RVDC32(OVC_OGAMC1);
+				arg->overlay.OGAMC0 = PSB_RVDC32(OVC_OGAMC0);
+			}
+			if (arg->overlay_read_mask & OV_REGRWBITS_OVADD)
+				arg->overlay.OVADD = PSB_RVDC32(OV_OVADD);
+			if (arg->overlay_read_mask & OVC_REGRWBITS_OVADD)
+				arg->overlay.OVADD = PSB_RVDC32(OVC_OVADD);
+			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		} else {
+			if (arg->overlay_read_mask & OV_REGRWBITS_OGAM_ALL) {
+				arg->overlay.OGAMC5 = dev_priv->saveOV_OGAMC5;
+				arg->overlay.OGAMC4 = dev_priv->saveOV_OGAMC4;
+				arg->overlay.OGAMC3 = dev_priv->saveOV_OGAMC3;
+				arg->overlay.OGAMC2 = dev_priv->saveOV_OGAMC2;
+				arg->overlay.OGAMC1 = dev_priv->saveOV_OGAMC1;
+				arg->overlay.OGAMC0 = dev_priv->saveOV_OGAMC0;
+			}
+			if (arg->overlay_read_mask & OVC_REGRWBITS_OGAM_ALL) {
+				arg->overlay.OGAMC5 = dev_priv->saveOVC_OGAMC5;
+				arg->overlay.OGAMC4 = dev_priv->saveOVC_OGAMC4;
+				arg->overlay.OGAMC3 = dev_priv->saveOVC_OGAMC3;
+				arg->overlay.OGAMC2 = dev_priv->saveOVC_OGAMC2;
+				arg->overlay.OGAMC1 = dev_priv->saveOVC_OGAMC1;
+				arg->overlay.OGAMC0 = dev_priv->saveOVC_OGAMC0;
+			}
+			if (arg->overlay_read_mask & OV_REGRWBITS_OVADD)
+				arg->overlay.OVADD = dev_priv->saveOV_OVADD;
+			if (arg->overlay_read_mask & OVC_REGRWBITS_OVADD)
+				arg->overlay.OVADD = dev_priv->saveOVC_OVADD;
+		}
+	}
+
+	if (arg->sprite_enable_mask != 0) {
+		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, usage)) {
+			PSB_WVDC32(0x1F3E, DSPARB);
+			PSB_WVDC32(arg->sprite.dspa_control
+					| PSB_RVDC32(DSPACNTR), DSPACNTR);
+			PSB_WVDC32(arg->sprite.dspa_key_value, DSPAKEYVAL);
+			PSB_WVDC32(arg->sprite.dspa_key_mask, DSPAKEYMASK);
+			PSB_WVDC32(PSB_RVDC32(DSPASURF), DSPASURF);
+			PSB_RVDC32(DSPASURF);
+			PSB_WVDC32(arg->sprite.dspc_control, DSPCCNTR);
+			PSB_WVDC32(arg->sprite.dspc_stride, DSPCSTRIDE);
+			PSB_WVDC32(arg->sprite.dspc_position, DSPCPOS);
+			PSB_WVDC32(arg->sprite.dspc_linear_offset, DSPCLINOFF);
+			PSB_WVDC32(arg->sprite.dspc_size, DSPCSIZE);
+			PSB_WVDC32(arg->sprite.dspc_surface, DSPCSURF);
+			PSB_RVDC32(DSPCSURF);
+			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		}
+	}
+
+	if (arg->sprite_disable_mask != 0) {
+		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, usage)) {
+			PSB_WVDC32(0x3F3E, DSPARB);
+			PSB_WVDC32(0x0, DSPCCNTR);
+			PSB_WVDC32(arg->sprite.dspc_surface, DSPCSURF);
+			PSB_RVDC32(DSPCSURF);
+			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		}
+	}
+
+	if (arg->subpicture_enable_mask != 0) {
+		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, usage)) {
+			uint32_t temp;
+			if (arg->subpicture_enable_mask & REGRWBITS_DSPACNTR) {
+				temp =  PSB_RVDC32(DSPACNTR);
+				temp &= ~DISPPLANE_PIXFORMAT_MASK;
+				temp &= ~DISPPLANE_BOTTOM;
+				temp |= DISPPLANE_32BPP;
+				PSB_WVDC32(temp, DSPACNTR);
+
+				temp =  PSB_RVDC32(DSPABASE);
+				PSB_WVDC32(temp, DSPABASE);
+				PSB_RVDC32(DSPABASE);
+				temp =  PSB_RVDC32(DSPASURF);
+				PSB_WVDC32(temp, DSPASURF);
+				PSB_RVDC32(DSPASURF);
+			}
+			if (arg->subpicture_enable_mask & REGRWBITS_DSPBCNTR) {
+				temp =  PSB_RVDC32(DSPBCNTR);
+				temp &= ~DISPPLANE_PIXFORMAT_MASK;
+				temp &= ~DISPPLANE_BOTTOM;
+				temp |= DISPPLANE_32BPP;
+				PSB_WVDC32(temp, DSPBCNTR);
+
+				temp =  PSB_RVDC32(DSPBBASE);
+				PSB_WVDC32(temp, DSPBBASE);
+				PSB_RVDC32(DSPBBASE);
+				temp =  PSB_RVDC32(DSPBSURF);
+				PSB_WVDC32(temp, DSPBSURF);
+				PSB_RVDC32(DSPBSURF);
+			}
+			if (arg->subpicture_enable_mask & REGRWBITS_DSPCCNTR) {
+				temp =  PSB_RVDC32(DSPCCNTR);
+				temp &= ~DISPPLANE_PIXFORMAT_MASK;
+				temp &= ~DISPPLANE_BOTTOM;
+				temp |= DISPPLANE_32BPP;
+				PSB_WVDC32(temp, DSPCCNTR);
+
+				temp =  PSB_RVDC32(DSPCBASE);
+				PSB_WVDC32(temp, DSPCBASE);
+				PSB_RVDC32(DSPCBASE);
+				temp =  PSB_RVDC32(DSPCSURF);
+				PSB_WVDC32(temp, DSPCSURF);
+				PSB_RVDC32(DSPCSURF);
+			}
+			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		}
+	}
+
+	if (arg->subpicture_disable_mask != 0) {
+		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, usage)) {
+			uint32_t temp;
+			if (arg->subpicture_disable_mask & REGRWBITS_DSPACNTR) {
+				temp =  PSB_RVDC32(DSPACNTR);
+				temp &= ~DISPPLANE_PIXFORMAT_MASK;
+				temp |= DISPPLANE_32BPP_NO_ALPHA;
+				PSB_WVDC32(temp, DSPACNTR);
+
+				temp =  PSB_RVDC32(DSPABASE);
+				PSB_WVDC32(temp, DSPABASE);
+				PSB_RVDC32(DSPABASE);
+				temp =  PSB_RVDC32(DSPASURF);
+				PSB_WVDC32(temp, DSPASURF);
+				PSB_RVDC32(DSPASURF);
+			}
+			if (arg->subpicture_disable_mask & REGRWBITS_DSPBCNTR) {
+				temp =  PSB_RVDC32(DSPBCNTR);
+				temp &= ~DISPPLANE_PIXFORMAT_MASK;
+				temp |= DISPPLANE_32BPP_NO_ALPHA;
+				PSB_WVDC32(temp, DSPBCNTR);
+
+				temp =  PSB_RVDC32(DSPBBASE);
+				PSB_WVDC32(temp, DSPBBASE);
+				PSB_RVDC32(DSPBBASE);
+				temp =  PSB_RVDC32(DSPBSURF);
+				PSB_WVDC32(temp, DSPBSURF);
+				PSB_RVDC32(DSPBSURF);
+			}
+			if (arg->subpicture_disable_mask & REGRWBITS_DSPCCNTR) {
+				temp =  PSB_RVDC32(DSPCCNTR);
+				temp &= ~DISPPLANE_PIXFORMAT_MASK;
+				temp |= DISPPLANE_32BPP_NO_ALPHA;
+				PSB_WVDC32(temp, DSPCCNTR);
+
+				temp =  PSB_RVDC32(DSPCBASE);
+				PSB_WVDC32(temp, DSPCBASE);
+				PSB_RVDC32(DSPCBASE);
+				temp =  PSB_RVDC32(DSPCSURF);
+				PSB_WVDC32(temp, DSPCSURF);
+				PSB_RVDC32(DSPCSURF);
+			}
+			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		}
+	}
+
+	return 0;
+}
+
+/* always available as we are SIGIO'd */
+static unsigned int psb_poll(struct file *filp,
+			     struct poll_table_struct *wait)
+{
+	return POLLIN | POLLRDNORM;
+}
+
+/* Not sure what we will need yet - in the PVR driver this disappears into
+   a tangle of abstracted handlers and per process crap */
+
+struct psb_priv {
+	int dummy;
+};
+
+static int psb_driver_open(struct drm_device *dev, struct drm_file *priv)
+{
+	struct psb_priv *psb = kzalloc(sizeof(struct psb_priv), GFP_KERNEL);
+	if (psb == NULL)
+		return -ENOMEM;
+	priv->driver_priv = psb;
+	DRM_DEBUG("\n");
+	/*return PVRSRVOpen(dev, priv);*/
+	return 0;
+}
+
+static void psb_driver_close(struct drm_device *dev, struct drm_file *priv)
+{
+	kfree(priv->driver_priv);
+	priv->driver_priv = NULL;
+}
+
+static long psb_unlocked_ioctl(struct file *filp, unsigned int cmd,
+			       unsigned long arg)
+{
+	struct drm_file *file_priv = filp->private_data;
+	struct drm_device *dev = file_priv->minor->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	static unsigned int runtime_allowed;
+	unsigned int nr = DRM_IOCTL_NR(cmd);
+
+	DRM_DEBUG("cmd = %x, nr = %x\n", cmd, nr);
+
+	if (runtime_allowed == 1 && dev_priv->is_lvds_on) {
+		runtime_allowed++;
+		pm_runtime_allow(&dev->pdev->dev);
+		dev_priv->rpm_enabled = 1;
+	}
+	/*
+	 * The driver private ioctls and TTM ioctls should be
+	 * thread-safe.
+	 */
+
+	if ((nr >= DRM_COMMAND_BASE) && (nr < DRM_COMMAND_END)
+	     && (nr < DRM_COMMAND_BASE + dev->driver->num_ioctls)) {
+		struct drm_ioctl_desc *ioctl =
+					&psb_ioctls[nr - DRM_COMMAND_BASE];
+
+		if (unlikely(ioctl->cmd != cmd)) {
+			DRM_ERROR(
+				"Invalid drm cmnd %d ioctl->cmd %x, cmd %x\n",
+				nr - DRM_COMMAND_BASE, ioctl->cmd, cmd);
+			return -EINVAL;
+		}
+
+		return drm_ioctl(filp, cmd, arg);
+	}
+	/*
+	 * Not all old drm ioctls are thread-safe.
+	 */
+
+	return drm_ioctl(filp, cmd, arg);
+}
+
+
+/* When a client dies:
+ *    - Check for and clean up flipped page state
+ */
+void psb_driver_preclose(struct drm_device *dev, struct drm_file *priv)
+{
+}
+
+static void psb_remove(struct pci_dev *pdev)
+{
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	drm_put_dev(dev);
+}
+
+
+static const struct dev_pm_ops psb_pm_ops = {
+	.runtime_suspend = psb_runtime_suspend,
+	.runtime_resume = psb_runtime_resume,
+	.runtime_idle = psb_runtime_idle,
+};
+
+static struct drm_driver driver = {
+	.driver_features = DRIVER_HAVE_IRQ | DRIVER_IRQ_SHARED | \
+			   DRIVER_IRQ_VBL | DRIVER_MODESET,
+	.load = psb_driver_load,
+	.unload = psb_driver_unload,
+
+	.ioctls = psb_ioctls,
+	.num_ioctls = DRM_ARRAY_SIZE(psb_ioctls),
+	.device_is_agp = psb_driver_device_is_agp,
+	.irq_preinstall = psb_irq_preinstall,
+	.irq_postinstall = psb_irq_postinstall,
+	.irq_uninstall = psb_irq_uninstall,
+	.irq_handler = psb_irq_handler,
+	.enable_vblank = psb_enable_vblank,
+	.disable_vblank = psb_disable_vblank,
+	.get_vblank_counter = psb_get_vblank_counter,
+	.firstopen = NULL,
+	.lastclose = psb_lastclose,
+	.open = psb_driver_open,
+	.postclose = psb_driver_close,
+#if 0	/* ACFIXME */
+	.get_map_ofs = drm_core_get_map_ofs,
+	.get_reg_ofs = drm_core_get_reg_ofs,
+	.proc_init = psb_proc_init,
+	.proc_cleanup = psb_proc_cleanup,
+#endif
+	.preclose = psb_driver_preclose,
+	.fops = {
+		 .owner = THIS_MODULE,
+		 .open = psb_open,
+		 .release = psb_release,
+		 .unlocked_ioctl = psb_unlocked_ioctl,
+		 .mmap = psb_mmap,
+		 .poll = psb_poll,
+		 .fasync = drm_fasync,
+		 .read = drm_read,
+		 },
+	.pci_driver = {
+		       .name = DRIVER_NAME,
+		       .id_table = pciidlist,
+		       .resume = ospm_power_resume,
+		       .suspend = ospm_power_suspend,
+		       .probe = psb_probe,
+		       .remove = psb_remove,
+#ifdef CONFIG_PM
+			.driver.pm = &psb_pm_ops,
+#endif
+		       },
+	.name = DRIVER_NAME,
+	.desc = DRIVER_DESC,
+	.date = PSB_DRM_DRIVER_DATE,
+	.major = PSB_DRM_DRIVER_MAJOR,
+	.minor = PSB_DRM_DRIVER_MINOR,
+	.patchlevel = PSB_DRM_DRIVER_PATCHLEVEL
+};
+
+static int psb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	/* MLD Added this from Inaky's patch */
+	if (pci_enable_msi(pdev))
+		DRM_ERROR("Enable MSI failed!\n");
+	return drm_get_pci_dev(pdev, ent, &driver);
+}
+
+static int __init psb_init(void)
+{
+	return drm_init(&driver);
+}
+
+static void __exit psb_exit(void)
+{
+	drm_exit(&driver);
+}
+
+late_initcall(psb_init);
+module_exit(psb_exit);
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
new file mode 100644
index 0000000..b75b9d8
--- /dev/null
+++ b/drivers/staging/gma500/psb_drv.h
@@ -0,0 +1,1139 @@
+/**************************************************************************
+ * Copyright (c) 2007-2008, Intel Corporation.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+
+#ifndef _PSB_DRV_H_
+#define _PSB_DRV_H_
+
+#include <linux/version.h>
+
+#include <drm/drmP.h>
+#include "drm_global.h"
+#include "psb_drm.h"
+#include "psb_reg.h"
+#include "psb_intel_drv.h"
+#include "psb_gtt.h"
+#include "psb_powermgmt.h"
+#include "ttm/ttm_object.h"
+#include "psb_ttm_fence_driver.h"
+#include "psb_ttm_userobj_api.h"
+#include "ttm/ttm_bo_driver.h"
+#include "ttm/ttm_lock.h"
+
+/*Append new drm mode definition here, align with libdrm definition*/
+#define DRM_MODE_SCALE_NO_SCALE   2
+
+extern struct ttm_bo_driver psb_ttm_bo_driver;
+
+enum {
+	CHIP_PSB_8108 = 0,
+	CHIP_PSB_8109 = 1,
+};
+
+/*
+ *Hardware bugfixes
+ */
+
+#define DRIVER_NAME "pvrsrvkm"
+#define DRIVER_DESC "drm driver for the Intel GMA500"
+#define DRIVER_AUTHOR "Intel Corporation"
+#define OSPM_PROC_ENTRY "ospm"
+#define RTPM_PROC_ENTRY "rtpm"
+#define BLC_PROC_ENTRY "mrst_blc"
+#define DISPLAY_PROC_ENTRY "display_status"
+
+#define PSB_DRM_DRIVER_DATE "2009-03-10"
+#define PSB_DRM_DRIVER_MAJOR 8
+#define PSB_DRM_DRIVER_MINOR 1
+#define PSB_DRM_DRIVER_PATCHLEVEL 0
+
+/*
+ *TTM driver private offsets.
+ */
+
+#define DRM_PSB_FILE_PAGE_OFFSET (0x100000000ULL >> PAGE_SHIFT)
+
+#define PSB_OBJECT_HASH_ORDER 13
+#define PSB_FILE_OBJECT_HASH_ORDER 12
+#define PSB_BO_HASH_ORDER 12
+
+#define PSB_VDC_OFFSET		 0x00000000
+#define PSB_VDC_SIZE		 0x000080000
+#define MRST_MMIO_SIZE		 0x0000C0000
+#define MDFLD_MMIO_SIZE          0x000100000
+#define PSB_SGX_SIZE		 0x8000
+#define PSB_SGX_OFFSET		 0x00040000
+#define MRST_SGX_OFFSET		 0x00080000
+#define PSB_MMIO_RESOURCE	 0
+#define PSB_GATT_RESOURCE	 2
+#define PSB_GTT_RESOURCE	 3
+#define PSB_GMCH_CTRL		 0x52
+#define PSB_BSM			 0x5C
+#define _PSB_GMCH_ENABLED	 0x4
+#define PSB_PGETBL_CTL		 0x2020
+#define _PSB_PGETBL_ENABLED	 0x00000001
+#define PSB_SGX_2D_SLAVE_PORT	 0x4000
+#define PSB_TT_PRIV0_LIMIT	 (256*1024*1024)
+#define PSB_TT_PRIV0_PLIMIT	 (PSB_TT_PRIV0_LIMIT >> PAGE_SHIFT)
+#define PSB_NUM_VALIDATE_BUFFERS 2048
+
+#define PSB_MEM_MMU_START       0x00000000
+#define PSB_MEM_TT_START        0xE0000000
+
+#define PSB_GL3_CACHE_CTL	0x2100
+#define PSB_GL3_CACHE_STAT	0x2108
+
+/*
+ *Flags for external memory type field.
+ */
+
+#define MRST_MSVDX_OFFSET	0x90000	/*MSVDX Base offset */
+#define PSB_MSVDX_OFFSET	0x50000	/*MSVDX Base offset */
+/* MSVDX MMIO region is 0x50000 - 0x57fff ==> 32KB */
+#define PSB_MSVDX_SIZE		0x10000
+
+#define LNC_TOPAZ_OFFSET	0xA0000
+#define PNW_TOPAZ_OFFSET	0xC0000
+#define PNW_GL3_OFFSET		0xB0000
+#define LNC_TOPAZ_SIZE		0x10000
+#define PNW_TOPAZ_SIZE		0x30000 /* PNW VXE285 has two cores */
+#define PSB_MMU_CACHED_MEMORY	  0x0001	/* Bind to MMU only */
+#define PSB_MMU_RO_MEMORY	  0x0002	/* MMU RO memory */
+#define PSB_MMU_WO_MEMORY	  0x0004	/* MMU WO memory */
+
+/*
+ *PTE's and PDE's
+ */
+
+#define PSB_PDE_MASK		  0x003FFFFF
+#define PSB_PDE_SHIFT		  22
+#define PSB_PTE_SHIFT		  12
+
+#define PSB_PTE_VALID		  0x0001	/* PTE / PDE valid */
+#define PSB_PTE_WO		  0x0002	/* Write only */
+#define PSB_PTE_RO		  0x0004	/* Read only */
+#define PSB_PTE_CACHED		  0x0008	/* CPU cache coherent */
+
+/*
+ *VDC registers and bits
+ */
+#define PSB_MSVDX_CLOCKGATING	  0x2064
+#define PSB_TOPAZ_CLOCKGATING	  0x2068
+#define PSB_HWSTAM		  0x2098
+#define PSB_INSTPM		  0x20C0
+#define PSB_INT_IDENTITY_R        0x20A4
+#define _MDFLD_PIPEC_EVENT_FLAG   (1<<2)
+#define _MDFLD_PIPEC_VBLANK_FLAG  (1<<3)
+#define _PSB_DPST_PIPEB_FLAG      (1<<4)
+#define _MDFLD_PIPEB_EVENT_FLAG   (1<<4)
+#define _PSB_VSYNC_PIPEB_FLAG	  (1<<5)
+#define _PSB_DPST_PIPEA_FLAG      (1<<6)
+#define _PSB_PIPEA_EVENT_FLAG     (1<<6)
+#define _PSB_VSYNC_PIPEA_FLAG	  (1<<7)
+#define _MDFLD_MIPIA_FLAG	  (1<<16)
+#define _MDFLD_MIPIC_FLAG	  (1<<17)
+#define _PSB_IRQ_SGX_FLAG	  (1<<18)
+#define _PSB_IRQ_MSVDX_FLAG	  (1<<19)
+#define _LNC_IRQ_TOPAZ_FLAG	  (1<<20)
+
+/* This flag includes all the display IRQ bits excepts the vblank irqs. */
+#define _MDFLD_DISP_ALL_IRQ_FLAG (_MDFLD_PIPEC_EVENT_FLAG | _MDFLD_PIPEB_EVENT_FLAG | \
+        _PSB_PIPEA_EVENT_FLAG | _PSB_VSYNC_PIPEA_FLAG | _MDFLD_MIPIA_FLAG | _MDFLD_MIPIC_FLAG)
+#define PSB_INT_IDENTITY_R	  0x20A4
+#define PSB_INT_MASK_R		  0x20A8
+#define PSB_INT_ENABLE_R	  0x20A0
+
+#define _PSB_MMU_ER_MASK      0x0001FF00
+#define _PSB_MMU_ER_HOST      (1 << 16)
+#define GPIOA			0x5010
+#define GPIOB			0x5014
+#define GPIOC			0x5018
+#define GPIOD			0x501c
+#define GPIOE			0x5020
+#define GPIOF			0x5024
+#define GPIOG			0x5028
+#define GPIOH			0x502c
+#define GPIO_CLOCK_DIR_MASK		(1 << 0)
+#define GPIO_CLOCK_DIR_IN		(0 << 1)
+#define GPIO_CLOCK_DIR_OUT		(1 << 1)
+#define GPIO_CLOCK_VAL_MASK		(1 << 2)
+#define GPIO_CLOCK_VAL_OUT		(1 << 3)
+#define GPIO_CLOCK_VAL_IN		(1 << 4)
+#define GPIO_CLOCK_PULLUP_DISABLE	(1 << 5)
+#define GPIO_DATA_DIR_MASK		(1 << 8)
+#define GPIO_DATA_DIR_IN		(0 << 9)
+#define GPIO_DATA_DIR_OUT		(1 << 9)
+#define GPIO_DATA_VAL_MASK		(1 << 10)
+#define GPIO_DATA_VAL_OUT		(1 << 11)
+#define GPIO_DATA_VAL_IN		(1 << 12)
+#define GPIO_DATA_PULLUP_DISABLE	(1 << 13)
+
+#define VCLK_DIVISOR_VGA0   0x6000
+#define VCLK_DIVISOR_VGA1   0x6004
+#define VCLK_POST_DIV	    0x6010
+
+#define PSB_COMM_2D (PSB_ENGINE_2D << 4)
+#define PSB_COMM_3D (PSB_ENGINE_3D << 4)
+#define PSB_COMM_TA (PSB_ENGINE_TA << 4)
+#define PSB_COMM_HP (PSB_ENGINE_HP << 4)
+#define PSB_COMM_USER_IRQ (1024 >> 2)
+#define PSB_COMM_USER_IRQ_LOST (PSB_COMM_USER_IRQ + 1)
+#define PSB_COMM_FW (2048 >> 2)
+
+#define PSB_UIRQ_VISTEST	       1
+#define PSB_UIRQ_OOM_REPLY	       2
+#define PSB_UIRQ_FIRE_TA_REPLY	       3
+#define PSB_UIRQ_FIRE_RASTER_REPLY     4
+
+#define PSB_2D_SIZE (256*1024*1024)
+#define PSB_MAX_RELOC_PAGES 1024
+
+#define PSB_LOW_REG_OFFS 0x0204
+#define PSB_HIGH_REG_OFFS 0x0600
+
+#define PSB_NUM_VBLANKS 2
+
+
+#define PSB_2D_SIZE (256*1024*1024)
+#define PSB_MAX_RELOC_PAGES 1024
+
+#define PSB_LOW_REG_OFFS 0x0204
+#define PSB_HIGH_REG_OFFS 0x0600
+
+#define PSB_NUM_VBLANKS 2
+#define PSB_WATCHDOG_DELAY (DRM_HZ * 2)
+#define PSB_LID_DELAY (DRM_HZ / 10)
+
+#define MDFLD_PNW_A0 0x00
+#define MDFLD_PNW_B0 0x04
+#define MDFLD_PNW_C0 0x08
+
+#define MDFLD_DSR_2D_3D_0 BIT0
+#define MDFLD_DSR_2D_3D_2 BIT1
+#define MDFLD_DSR_CURSOR_0 BIT2
+#define MDFLD_DSR_CURSOR_2 BIT3
+#define MDFLD_DSR_OVERLAY_0 BIT4
+#define MDFLD_DSR_OVERLAY_2 BIT5
+#define MDFLD_DSR_MIPI_CONTROL	BIT6
+#define MDFLD_DSR_2D_3D 	(MDFLD_DSR_2D_3D_0 | MDFLD_DSR_2D_3D_2)
+
+#define MDFLD_DSR_RR 45 
+#define MDFLD_DPU_ENABLE BIT31
+#define MDFLD_DSR_FULLSCREEN BIT30
+#define MDFLD_DSR_DELAY (DRM_HZ / MDFLD_DSR_RR)
+
+#define PSB_PWR_STATE_ON		1
+#define PSB_PWR_STATE_OFF		2
+
+#define PSB_PMPOLICY_NOPM		0
+#define PSB_PMPOLICY_CLOCKGATING	1
+#define PSB_PMPOLICY_POWERDOWN		2
+
+#define PSB_PMSTATE_POWERUP		0
+#define PSB_PMSTATE_CLOCKGATED		1
+#define PSB_PMSTATE_POWERDOWN		2
+#define PSB_PCIx_MSI_ADDR_LOC		0x94
+#define PSB_PCIx_MSI_DATA_LOC		0x98
+
+#define MDFLD_PLANE_MAX_WIDTH		2048
+#define MDFLD_PLANE_MAX_HEIGHT		2048
+
+struct opregion_header;
+struct opregion_acpi;
+struct opregion_swsci;
+struct opregion_asle;
+
+struct psb_intel_opregion {
+	struct opregion_header *header;
+	struct opregion_acpi *acpi;
+	struct opregion_swsci *swsci;
+	struct opregion_asle *asle;
+	int enabled;
+};
+
+/*
+ *User options.
+ */
+
+struct drm_psb_uopt {
+	int pad; /*keep it here in case we use it in future*/
+};
+
+/**
+ *struct psb_context
+ *
+ *@buffers:	 array of pre-allocated validate buffers.
+ *@used_buffers: number of buffers in @buffers array currently in use.
+ *@validate_buffer: buffers validated from user-space.
+ *@kern_validate_buffers : buffers validated from kernel-space.
+ *@fence_flags : Fence flags to be used for fence creation.
+ *
+ *This structure is used during execbuf validation.
+ */
+
+struct psb_context {
+	struct psb_validate_buffer *buffers;
+	uint32_t used_buffers;
+	struct list_head validate_list;
+	struct list_head kern_validate_list;
+	uint32_t fence_types;
+	uint32_t val_seq;
+};
+
+struct psb_validate_buffer;
+
+/* Currently defined profiles */
+enum VAProfile {
+	VAProfileMPEG2Simple		= 0,
+	VAProfileMPEG2Main		= 1,
+	VAProfileMPEG4Simple		= 2,
+	VAProfileMPEG4AdvancedSimple	= 3,
+	VAProfileMPEG4Main		= 4,
+	VAProfileH264Baseline		= 5,
+	VAProfileH264Main		= 6,
+	VAProfileH264High		= 7,
+	VAProfileVC1Simple		= 8,
+	VAProfileVC1Main		= 9,
+	VAProfileVC1Advanced		= 10,
+	VAProfileH263Baseline		= 11,
+	VAProfileJPEGBaseline           = 12,
+	VAProfileH264ConstrainedBaseline = 13
+};
+
+/* Currently defined entrypoints */
+enum VAEntrypoint {
+	VAEntrypointVLD		= 1,
+	VAEntrypointIZZ		= 2,
+	VAEntrypointIDCT	= 3,
+	VAEntrypointMoComp	= 4,
+	VAEntrypointDeblocking	= 5,
+	VAEntrypointEncSlice	= 6,	/* slice level encode */
+	VAEntrypointEncPicture 	= 7	/* pictuer encode, JPEG, etc */
+};
+
+
+struct psb_video_ctx {
+	struct list_head head;
+	struct file *filp; /* DRM device file pointer */
+	int ctx_type; /* profile<<8|entrypoint */
+	/* todo: more context specific data for multi-context support */
+};
+
+#define MODE_SETTING_IN_CRTC 	0x1
+#define MODE_SETTING_IN_ENCODER 0x2
+#define MODE_SETTING_ON_GOING 	0x3
+#define MODE_SETTING_IN_DSR 	0x4
+#define MODE_SETTING_ENCODER_DONE 0x8
+#define GCT_R10_HEADER_SIZE	16
+#define GCT_R10_DISPLAY_DESC_SIZE	28
+
+struct drm_psb_private {
+	/*
+	 * DSI info. 
+	 */
+	void * dbi_dsr_info;	
+	void * dsi_configs[2];
+
+	/*
+	 *TTM Glue.
+	 */
+
+	struct drm_global_reference mem_global_ref;
+	struct ttm_bo_global_ref bo_global_ref;
+	int has_global;
+
+	struct drm_device *dev;
+	struct ttm_object_device *tdev;
+	struct ttm_fence_device fdev;
+	struct ttm_bo_device bdev;
+	struct ttm_lock ttm_lock;
+	struct vm_operations_struct *ttm_vm_ops;
+	int has_fence_device;
+	int has_bo_device;
+
+	unsigned long chipset;
+
+	struct drm_psb_dev_info_arg dev_info;
+	struct drm_psb_uopt uopt;
+
+	struct psb_gtt *pg;
+
+	/*GTT Memory manager*/
+	struct psb_gtt_mm *gtt_mm;
+
+	struct page *scratch_page;
+	uint32_t sequence[PSB_NUM_ENGINES];
+	uint32_t last_sequence[PSB_NUM_ENGINES];
+	uint32_t last_submitted_seq[PSB_NUM_ENGINES];
+
+	struct psb_mmu_driver *mmu;
+	struct psb_mmu_pd *pf_pd;
+
+	uint8_t *sgx_reg;
+	uint8_t *vdc_reg;
+	uint32_t gatt_free_offset;
+	
+	/* IMG video context */
+	struct list_head video_ctx;
+
+
+
+	/*
+	 *Fencing / irq.
+	 */
+
+	uint32_t vdc_irq_mask;
+	uint32_t pipestat[PSB_NUM_PIPE];
+	bool vblanksEnabledForFlips;
+
+	spinlock_t irqmask_lock;
+	spinlock_t sequence_lock;
+
+	/*
+	 *Modesetting
+	 */
+	struct psb_intel_mode_device mode_dev;
+
+	struct drm_crtc *plane_to_crtc_mapping[PSB_NUM_PIPE];
+	struct drm_crtc *pipe_to_crtc_mapping[PSB_NUM_PIPE];
+	uint32_t num_pipe;
+
+	/*
+	 * CI share buffer
+	 */
+	unsigned int ci_region_start;
+	unsigned int ci_region_size;
+
+	/*
+	 * RAR share buffer;
+	 */
+	unsigned int rar_region_start;
+	unsigned int rar_region_size;
+
+	/*
+	 *Memory managers
+	 */
+
+	int have_camera;
+	int have_rar;
+	int have_tt;
+	int have_mem_mmu;
+	struct mutex temp_mem;
+
+	/*
+	 *Relocation buffer mapping.
+	 */
+
+	spinlock_t reloc_lock;
+	unsigned int rel_mapped_pages;
+	wait_queue_head_t rel_mapped_queue;
+
+	/*
+	 *SAREA
+	 */
+	struct drm_psb_sarea *sarea_priv;
+
+	/*
+	*OSPM info
+	*/
+	uint32_t ospm_base;
+
+	/*
+	 * Sizes info
+	 */
+
+	struct drm_psb_sizes_arg sizes;
+
+	uint32_t fuse_reg_value;
+
+	/* pci revision id for B0:D2:F0 */
+	uint8_t platform_rev_id;
+
+	/*
+	 *LVDS info
+	 */
+	int backlight_duty_cycle;	/* restore backlight to this value */
+	bool panel_wants_dither;
+	struct drm_display_mode *panel_fixed_mode;
+	struct drm_display_mode *lfp_lvds_vbt_mode;
+	struct drm_display_mode *sdvo_lvds_vbt_mode;
+
+	struct bdb_lvds_backlight *lvds_bl; /*LVDS backlight info from VBT*/
+	struct psb_intel_i2c_chan *lvds_i2c_bus;
+
+	/* Feature bits from the VBIOS*/
+	unsigned int int_tv_support:1;
+	unsigned int lvds_dither:1;
+	unsigned int lvds_vbt:1;
+	unsigned int int_crt_support:1;
+	unsigned int lvds_use_ssc:1;
+	int lvds_ssc_freq;
+	bool is_lvds_on;
+
+	unsigned int core_freq;
+	uint32_t iLVDS_enable;
+
+	/*runtime PM state*/
+	int rpm_enabled;
+
+	/*
+	 *Register state
+	 */
+	uint32_t saveDSPACNTR;
+	uint32_t saveDSPBCNTR;
+	uint32_t savePIPEACONF;
+	uint32_t savePIPEBCONF;
+	uint32_t savePIPEASRC;
+	uint32_t savePIPEBSRC;
+	uint32_t saveFPA0;
+	uint32_t saveFPA1;
+	uint32_t saveDPLL_A;
+	uint32_t saveDPLL_A_MD;
+	uint32_t saveHTOTAL_A;
+	uint32_t saveHBLANK_A;
+	uint32_t saveHSYNC_A;
+	uint32_t saveVTOTAL_A;
+	uint32_t saveVBLANK_A;
+	uint32_t saveVSYNC_A;
+	uint32_t saveDSPASTRIDE;
+	uint32_t saveDSPASIZE;
+	uint32_t saveDSPAPOS;
+	uint32_t saveDSPABASE;
+	uint32_t saveDSPASURF;
+	uint32_t saveFPB0;
+	uint32_t saveFPB1;
+	uint32_t saveDPLL_B;
+	uint32_t saveDPLL_B_MD;
+	uint32_t saveHTOTAL_B;
+	uint32_t saveHBLANK_B;
+	uint32_t saveHSYNC_B;
+	uint32_t saveVTOTAL_B;
+	uint32_t saveVBLANK_B;
+	uint32_t saveVSYNC_B;
+	uint32_t saveDSPBSTRIDE;
+	uint32_t saveDSPBSIZE;
+	uint32_t saveDSPBPOS;
+	uint32_t saveDSPBBASE;
+	uint32_t saveDSPBSURF;
+	uint32_t saveVCLK_DIVISOR_VGA0;
+	uint32_t saveVCLK_DIVISOR_VGA1;
+	uint32_t saveVCLK_POST_DIV;
+	uint32_t saveVGACNTRL;
+	uint32_t saveADPA;
+	uint32_t saveLVDS;
+	uint32_t saveDVOA;
+	uint32_t saveDVOB;
+	uint32_t saveDVOC;
+	uint32_t savePP_ON;
+	uint32_t savePP_OFF;
+	uint32_t savePP_CONTROL;
+	uint32_t savePP_CYCLE;
+	uint32_t savePFIT_CONTROL;
+	uint32_t savePaletteA[256];
+	uint32_t savePaletteB[256];
+	uint32_t saveBLC_PWM_CTL2;
+	uint32_t saveBLC_PWM_CTL;
+	uint32_t saveCLOCKGATING;
+	uint32_t saveDSPARB;
+	uint32_t saveDSPATILEOFF;
+	uint32_t saveDSPBTILEOFF;
+	uint32_t saveDSPAADDR;
+	uint32_t saveDSPBADDR;
+	uint32_t savePFIT_AUTO_RATIOS;
+	uint32_t savePFIT_PGM_RATIOS;
+	uint32_t savePP_ON_DELAYS;
+	uint32_t savePP_OFF_DELAYS;
+	uint32_t savePP_DIVISOR;
+	uint32_t saveBSM;
+	uint32_t saveVBT;
+	uint32_t saveBCLRPAT_A;
+	uint32_t saveBCLRPAT_B;
+	uint32_t saveDSPALINOFF;
+	uint32_t saveDSPBLINOFF;
+	uint32_t savePERF_MODE;
+	uint32_t saveDSPFW1;
+	uint32_t saveDSPFW2;
+	uint32_t saveDSPFW3;
+	uint32_t saveDSPFW4;
+	uint32_t saveDSPFW5;
+	uint32_t saveDSPFW6;
+	uint32_t saveCHICKENBIT;
+	uint32_t saveDSPACURSOR_CTRL;
+	uint32_t saveDSPBCURSOR_CTRL;
+	uint32_t saveDSPACURSOR_BASE;
+	uint32_t saveDSPBCURSOR_BASE;
+	uint32_t saveDSPACURSOR_POS;
+	uint32_t saveDSPBCURSOR_POS;
+	uint32_t save_palette_a[256];
+	uint32_t save_palette_b[256];
+	uint32_t saveOV_OVADD;
+	uint32_t saveOV_OGAMC0;
+	uint32_t saveOV_OGAMC1;
+	uint32_t saveOV_OGAMC2;
+	uint32_t saveOV_OGAMC3;
+	uint32_t saveOV_OGAMC4;
+	uint32_t saveOV_OGAMC5;
+	uint32_t saveOVC_OVADD;
+	uint32_t saveOVC_OGAMC0;
+	uint32_t saveOVC_OGAMC1;
+	uint32_t saveOVC_OGAMC2;
+	uint32_t saveOVC_OGAMC3;
+	uint32_t saveOVC_OGAMC4;
+	uint32_t saveOVC_OGAMC5;
+
+	/*
+	 * extra MDFLD Register state
+	 */
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
+	/* DSI reg save */
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
+	void (*init_drvIC)(struct drm_device *dev);
+	void (*dsi_prePowerState)(struct drm_device *dev);
+	void (*dsi_postPowerState)(struct drm_device *dev);
+
+	/* DPST Register Save */
+	uint32_t saveHISTOGRAM_INT_CONTROL_REG;
+	uint32_t saveHISTOGRAM_LOGIC_CONTROL_REG;
+	uint32_t savePWM_CONTROL_LOGIC;
+
+	/* MSI reg save */
+
+	uint32_t msi_addr;
+	uint32_t msi_data;
+
+	/*
+	 *Scheduling.
+	 */
+
+	struct mutex reset_mutex;
+	struct mutex cmdbuf_mutex;
+	/*uint32_t ta_mem_pages;
+	struct psb_ta_mem *ta_mem;
+	int force_ta_mem_load;*/
+	atomic_t val_seq;
+
+	/*
+	 *TODO: change this to be per drm-context.
+	 */
+
+	struct psb_context context;
+
+	/*
+	 * LID-Switch
+	 */
+	spinlock_t lid_lock;
+	struct timer_list lid_timer;
+	struct psb_intel_opregion opregion;
+	u32 *lid_state;
+	u32 lid_last_state;
+
+	/*
+	 *Watchdog
+	 */
+
+	int timer_available;
+
+	uint32_t apm_reg;
+	uint16_t apm_base;
+
+	/*
+	 * Used for modifying backlight from
+	 * xrandr -- consider removing and using HAL instead
+	 */
+	struct drm_property *backlight_property;
+	uint32_t blc_adj1;
+	uint32_t blc_adj2;
+
+	void * fbdev;
+};
+
+
+struct psb_file_data {	/* TODO: Audit this, remove the indirection and set
+			   it up properly in open/postclose  ACFIXME */
+	void *priv;
+};
+
+struct psb_fpriv {
+	struct ttm_object_file *tfile;
+};
+
+struct psb_mmu_driver;
+
+extern int drm_crtc_probe_output_modes(struct drm_device *dev, int, int);
+extern int drm_pick_crtcs(struct drm_device *dev);
+
+static inline struct psb_fpriv *psb_fpriv(struct drm_file *file_priv)
+{
+	struct psb_file_data *pvr_file_priv
+			= (struct psb_file_data *)file_priv->driver_priv;
+	return (struct psb_fpriv *) pvr_file_priv->priv;
+}
+
+static inline struct drm_psb_private *psb_priv(struct drm_device *dev)
+{
+	return (struct drm_psb_private *) dev->dev_private;
+}
+
+/*
+ *TTM glue. psb_ttm_glue.c
+ */
+
+extern int psb_open(struct inode *inode, struct file *filp);
+extern int psb_release(struct inode *inode, struct file *filp);
+extern int psb_mmap(struct file *filp, struct vm_area_struct *vma);
+
+extern int psb_fence_signaled_ioctl(struct drm_device *dev, void *data,
+				    struct drm_file *file_priv);
+extern int psb_verify_access(struct ttm_buffer_object *bo,
+			     struct file *filp);
+extern ssize_t psb_ttm_read(struct file *filp, char __user *buf,
+			    size_t count, loff_t *f_pos);
+extern ssize_t psb_ttm_write(struct file *filp, const char __user *buf,
+			    size_t count, loff_t *f_pos);
+extern int psb_fence_finish_ioctl(struct drm_device *dev, void *data,
+				  struct drm_file *file_priv);
+extern int psb_fence_unref_ioctl(struct drm_device *dev, void *data,
+				 struct drm_file *file_priv);
+extern int psb_pl_waitidle_ioctl(struct drm_device *dev, void *data,
+				 struct drm_file *file_priv);
+extern int psb_pl_setstatus_ioctl(struct drm_device *dev, void *data,
+				  struct drm_file *file_priv);
+extern int psb_pl_synccpu_ioctl(struct drm_device *dev, void *data,
+				struct drm_file *file_priv);
+extern int psb_pl_unref_ioctl(struct drm_device *dev, void *data,
+			      struct drm_file *file_priv);
+extern int psb_pl_reference_ioctl(struct drm_device *dev, void *data,
+				  struct drm_file *file_priv);
+extern int psb_pl_create_ioctl(struct drm_device *dev, void *data,
+			       struct drm_file *file_priv);
+extern int psb_pl_ub_create_ioctl(struct drm_device *dev, void *data,
+			       struct drm_file *file_priv);
+extern int psb_extension_ioctl(struct drm_device *dev, void *data,
+			       struct drm_file *file_priv);
+extern int psb_ttm_global_init(struct drm_psb_private *dev_priv);
+extern void psb_ttm_global_release(struct drm_psb_private *dev_priv);
+extern int psb_getpageaddrs_ioctl(struct drm_device *dev, void *data,
+				struct drm_file *file_priv);
+/*
+ *MMU stuff.
+ */
+
+extern struct psb_mmu_driver *psb_mmu_driver_init(uint8_t __iomem * registers,
+					int trap_pagefaults,
+					int invalid_type,
+					struct drm_psb_private *dev_priv);
+extern void psb_mmu_driver_takedown(struct psb_mmu_driver *driver);
+extern struct psb_mmu_pd *psb_mmu_get_default_pd(struct psb_mmu_driver
+						 *driver);
+extern void psb_mmu_mirror_gtt(struct psb_mmu_pd *pd, uint32_t mmu_offset,
+			       uint32_t gtt_start, uint32_t gtt_pages);
+extern struct psb_mmu_pd *psb_mmu_alloc_pd(struct psb_mmu_driver *driver,
+					   int trap_pagefaults,
+					   int invalid_type);
+extern void psb_mmu_free_pagedir(struct psb_mmu_pd *pd);
+extern void psb_mmu_flush(struct psb_mmu_driver *driver, int rc_prot);
+extern void psb_mmu_remove_pfn_sequence(struct psb_mmu_pd *pd,
+					unsigned long address,
+					uint32_t num_pages);
+extern int psb_mmu_insert_pfn_sequence(struct psb_mmu_pd *pd,
+				       uint32_t start_pfn,
+				       unsigned long address,
+				       uint32_t num_pages, int type);
+extern int psb_mmu_virtual_to_pfn(struct psb_mmu_pd *pd, uint32_t virtual,
+				  unsigned long *pfn);
+
+/*
+ *Enable / disable MMU for different requestors.
+ */
+
+
+extern void psb_mmu_set_pd_context(struct psb_mmu_pd *pd, int hw_context);
+extern int psb_mmu_insert_pages(struct psb_mmu_pd *pd, struct page **pages,
+				unsigned long address, uint32_t num_pages,
+				uint32_t desired_tile_stride,
+				uint32_t hw_tile_stride, int type);
+extern void psb_mmu_remove_pages(struct psb_mmu_pd *pd,
+				 unsigned long address, uint32_t num_pages,
+				 uint32_t desired_tile_stride,
+				 uint32_t hw_tile_stride);
+/*
+ *psb_sgx.c
+ */
+
+
+
+extern int psb_cmdbuf_ioctl(struct drm_device *dev, void *data,
+			    struct drm_file *file_priv);
+extern int psb_reg_submit(struct drm_psb_private *dev_priv,
+			  uint32_t *regs, unsigned int cmds);
+
+
+extern void psb_fence_or_sync(struct drm_file *file_priv,
+			      uint32_t engine,
+			      uint32_t fence_types,
+			      uint32_t fence_flags,
+			      struct list_head *list,
+			      struct psb_ttm_fence_rep *fence_arg,
+			      struct ttm_fence_object **fence_p);
+extern int psb_validate_kernel_buffer(struct psb_context *context,
+				      struct ttm_buffer_object *bo,
+				      uint32_t fence_class,
+				      uint64_t set_flags,
+				      uint64_t clr_flags);
+
+/*
+ *psb_irq.c
+ */
+
+extern irqreturn_t psb_irq_handler(DRM_IRQ_ARGS);
+extern int psb_irq_enable_dpst(struct drm_device *dev);
+extern int psb_irq_disable_dpst(struct drm_device *dev);
+extern void psb_irq_preinstall(struct drm_device *dev);
+extern int psb_irq_postinstall(struct drm_device *dev);
+extern void psb_irq_uninstall(struct drm_device *dev);
+extern void psb_irq_preinstall_islands(struct drm_device *dev, int hw_islands);
+extern int psb_irq_postinstall_islands(struct drm_device *dev, int hw_islands);
+extern void psb_irq_turn_on_dpst(struct drm_device *dev);
+extern void psb_irq_turn_off_dpst(struct drm_device *dev);
+
+extern void psb_irq_uninstall_islands(struct drm_device *dev, int hw_islands);
+extern int psb_vblank_wait2(struct drm_device *dev,unsigned int *sequence);
+extern int psb_vblank_wait(struct drm_device *dev, unsigned int *sequence);
+extern int psb_enable_vblank(struct drm_device *dev, int crtc);
+extern void psb_disable_vblank(struct drm_device *dev, int crtc);
+void
+psb_enable_pipestat(struct drm_psb_private *dev_priv, int pipe, u32 mask);
+
+void
+psb_disable_pipestat(struct drm_psb_private *dev_priv, int pipe, u32 mask);
+
+extern u32 psb_get_vblank_counter(struct drm_device *dev, int crtc);
+
+/*
+ *psb_fence.c
+ */
+
+extern void psb_fence_handler(struct drm_device *dev, uint32_t class);
+
+extern int psb_fence_emit_sequence(struct ttm_fence_device *fdev,
+				   uint32_t fence_class,
+				   uint32_t flags, uint32_t *sequence,
+				   unsigned long *timeout_jiffies);
+extern void psb_fence_error(struct drm_device *dev,
+			    uint32_t class,
+			    uint32_t sequence, uint32_t type, int error);
+extern int psb_ttm_fence_device_init(struct ttm_fence_device *fdev);
+
+/* MSVDX/Topaz stuff */
+extern int psb_remove_videoctx(struct drm_psb_private *dev_priv, struct file *filp);
+
+extern int lnc_video_frameskip(struct drm_device *dev,
+			       uint64_t user_pointer);
+extern int lnc_video_getparam(struct drm_device *dev, void *data,
+			      struct drm_file *file_priv);
+
+/*
+ * psb_opregion.c
+ */
+extern int psb_intel_opregion_init(struct drm_device *dev);
+
+/*
+ *psb_fb.c
+ */
+extern int psbfb_probed(struct drm_device *dev);
+extern int psbfb_remove(struct drm_device *dev,
+			struct drm_framebuffer *fb);
+extern int psbfb_kms_off_ioctl(struct drm_device *dev, void *data,
+			       struct drm_file *file_priv);
+extern int psbfb_kms_on_ioctl(struct drm_device *dev, void *data,
+			      struct drm_file *file_priv);
+extern void *psbfb_vdc_reg(struct drm_device* dev);
+
+/*
+ *psb_reset.c
+ */
+
+extern void psb_lid_timer_init(struct drm_psb_private *dev_priv);
+extern void psb_lid_timer_takedown(struct drm_psb_private *dev_priv);
+extern void psb_print_pagefault(struct drm_psb_private *dev_priv);
+
+/* modesetting */
+extern void psb_modeset_init(struct drm_device *dev);
+extern void psb_modeset_cleanup(struct drm_device *dev);
+extern int psb_fbdev_init(struct drm_device * dev);
+
+/* psb_bl.c */
+int psb_backlight_init(struct drm_device *dev);
+void psb_backlight_exit(void);
+int psb_set_brightness(struct backlight_device *bd);
+int psb_get_brightness(struct backlight_device *bd);
+struct backlight_device * psb_get_backlight_device(void);
+
+/*
+ *Debug print bits setting
+ */
+#define PSB_D_GENERAL (1 << 0)
+#define PSB_D_INIT    (1 << 1)
+#define PSB_D_IRQ     (1 << 2)
+#define PSB_D_ENTRY   (1 << 3)
+/* debug the get H/V BP/FP count */
+#define PSB_D_HV      (1 << 4)
+#define PSB_D_DBI_BF  (1 << 5)
+#define PSB_D_PM      (1 << 6)
+#define PSB_D_RENDER  (1 << 7)
+#define PSB_D_REG     (1 << 8)
+#define PSB_D_MSVDX   (1 << 9)
+#define PSB_D_TOPAZ   (1 << 10)
+
+#ifndef DRM_DEBUG_CODE
+/* To enable debug printout, set drm_psb_debug in psb_drv.c
+ * to any combination of above print flags.
+ */
+/* #define DRM_DEBUG_CODE 2 */
+#endif
+
+extern int drm_psb_debug;
+extern int drm_psb_no_fb;
+extern int drm_psb_disable_vsync;
+extern int drm_idle_check_interval;
+
+#define PSB_DEBUG_GENERAL(_fmt, _arg...) \
+	PSB_DEBUG(PSB_D_GENERAL, _fmt, ##_arg)
+#define PSB_DEBUG_INIT(_fmt, _arg...) \
+	PSB_DEBUG(PSB_D_INIT, _fmt, ##_arg)
+#define PSB_DEBUG_IRQ(_fmt, _arg...) \
+	PSB_DEBUG(PSB_D_IRQ, _fmt, ##_arg)
+#define PSB_DEBUG_ENTRY(_fmt, _arg...) \
+	PSB_DEBUG(PSB_D_ENTRY, _fmt, ##_arg)
+#define PSB_DEBUG_HV(_fmt, _arg...) \
+	PSB_DEBUG(PSB_D_HV, _fmt, ##_arg)
+#define PSB_DEBUG_DBI_BF(_fmt, _arg...) \
+	PSB_DEBUG(PSB_D_DBI_BF, _fmt, ##_arg)
+#define PSB_DEBUG_PM(_fmt, _arg...) \
+	PSB_DEBUG(PSB_D_PM, _fmt, ##_arg)
+#define PSB_DEBUG_RENDER(_fmt, _arg...) \
+	PSB_DEBUG(PSB_D_RENDER, _fmt, ##_arg)
+#define PSB_DEBUG_REG(_fmt, _arg...) \
+	PSB_DEBUG(PSB_D_REG, _fmt, ##_arg)
+#define PSB_DEBUG_MSVDX(_fmt, _arg...) \
+	PSB_DEBUG(PSB_D_MSVDX, _fmt, ##_arg)
+#define PSB_DEBUG_TOPAZ(_fmt, _arg...) \
+	PSB_DEBUG(PSB_D_TOPAZ, _fmt, ##_arg)
+
+#if DRM_DEBUG_CODE
+#define PSB_DEBUG(_flag, _fmt, _arg...)					\
+	do {								\
+		if (unlikely((_flag) & drm_psb_debug))			\
+			printk(KERN_DEBUG				\
+			       "[psb:0x%02x:%s] " _fmt , _flag,		\
+			       __func__ , ##_arg);			\
+	} while (0)
+#else
+#define PSB_DEBUG(_fmt, _arg...)     do { } while (0)
+#endif
+
+/*
+ *Utilities
+ */
+#define DRM_DRIVER_PRIVATE_T struct drm_psb_private
+
+static inline u32 MRST_MSG_READ32(uint port, uint offset)
+{
+	int mcr = (0xD0<<24) | (port << 16) | (offset << 8);
+	uint32_t ret_val = 0;
+	struct pci_dev *pci_root = pci_get_bus_and_slot (0, 0);
+	pci_write_config_dword (pci_root, 0xD0, mcr);
+	pci_read_config_dword (pci_root, 0xD4, &ret_val);
+	pci_dev_put(pci_root);
+	return ret_val;
+}
+static inline void MRST_MSG_WRITE32(uint port, uint offset, u32 value)
+{
+	int mcr = (0xE0<<24) | (port << 16) | (offset << 8) | 0xF0;
+	struct pci_dev *pci_root = pci_get_bus_and_slot (0, 0);
+	pci_write_config_dword (pci_root, 0xD4, value);
+	pci_write_config_dword (pci_root, 0xD0, mcr);
+	pci_dev_put(pci_root);
+}
+static inline u32 MDFLD_MSG_READ32(uint port, uint offset)
+{
+	int mcr = (0x10<<24) | (port << 16) | (offset << 8);
+	uint32_t ret_val = 0;
+	struct pci_dev *pci_root = pci_get_bus_and_slot (0, 0);
+	pci_write_config_dword (pci_root, 0xD0, mcr);
+	pci_read_config_dword (pci_root, 0xD4, &ret_val);
+	pci_dev_put(pci_root);
+	return ret_val;
+}
+static inline void MDFLD_MSG_WRITE32(uint port, uint offset, u32 value)
+{
+	int mcr = (0x11<<24) | (port << 16) | (offset << 8) | 0xF0;
+	struct pci_dev *pci_root = pci_get_bus_and_slot (0, 0);
+	pci_write_config_dword (pci_root, 0xD4, value);
+	pci_write_config_dword (pci_root, 0xD0, mcr);
+	pci_dev_put(pci_root);
+}
+
+static inline uint32_t REGISTER_READ(struct drm_device *dev, uint32_t reg)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int reg_val = ioread32(dev_priv->vdc_reg + (reg));
+	PSB_DEBUG_REG("reg = 0x%x. reg_val = 0x%x. \n", reg, reg_val);
+	return reg_val;
+}
+
+#define REG_READ(reg)	       REGISTER_READ(dev, (reg))
+static inline void REGISTER_WRITE(struct drm_device *dev, uint32_t reg,
+				      uint32_t val)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	if ((reg < 0x70084 || reg >0x70088) && (reg < 0xa000 || reg >0xa3ff))
+		PSB_DEBUG_REG("reg = 0x%x, val = 0x%x. \n", reg, val);
+
+	iowrite32((val), dev_priv->vdc_reg + (reg));
+}
+
+#define REG_WRITE(reg, val)	REGISTER_WRITE(dev, (reg), (val))
+
+static inline void REGISTER_WRITE16(struct drm_device *dev,
+					uint32_t reg, uint32_t val)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	PSB_DEBUG_REG("reg = 0x%x, val = 0x%x. \n", reg, val);
+
+	iowrite16((val), dev_priv->vdc_reg + (reg));
+}
+
+#define REG_WRITE16(reg, val)	  REGISTER_WRITE16(dev, (reg), (val))
+
+static inline void REGISTER_WRITE8(struct drm_device *dev,
+				       uint32_t reg, uint32_t val)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	PSB_DEBUG_REG("reg = 0x%x, val = 0x%x. \n", reg, val);
+
+	iowrite8((val), dev_priv->vdc_reg + (reg));
+}
+
+#define REG_WRITE8(reg, val)	 REGISTER_WRITE8(dev, (reg), (val))
+
+#define PSB_ALIGN_TO(_val, _align) \
+  (((_val) + ((_align) - 1)) & ~((_align) - 1))
+#define PSB_WVDC32(_val, _offs) \
+  iowrite32(_val, dev_priv->vdc_reg + (_offs))
+#define PSB_RVDC32(_offs) \
+  ioread32(dev_priv->vdc_reg + (_offs))
+
+/* #define TRAP_SGX_PM_FAULT 1 */
+#ifdef TRAP_SGX_PM_FAULT
+#define PSB_RSGX32(_offs)					\
+({								\
+    if (inl(dev_priv->apm_base + PSB_APM_STS) & 0x3) {		\
+	printk(KERN_ERR "access sgx when it's off!! (READ) %s, %d\n", \
+	       __FILE__, __LINE__);				\
+	mdelay(1000);						\
+    }								\
+    ioread32(dev_priv->sgx_reg + (_offs));			\
+})
+#else
+#define PSB_RSGX32(_offs)					\
+  ioread32(dev_priv->sgx_reg + (_offs))
+#endif
+#define PSB_WSGX32(_val, _offs) \
+  iowrite32(_val, dev_priv->sgx_reg + (_offs))
+
+#define MSVDX_REG_DUMP 0
+#if MSVDX_REG_DUMP
+
+#define PSB_WMSVDX32(_val, _offs) \
+  printk("MSVDX: write %08x to reg 0x%08x\n", (unsigned int)(_val), (unsigned int)(_offs));\
+  iowrite32(_val, dev_priv->msvdx_reg + (_offs))
+#define PSB_RMSVDX32(_offs) \
+  ioread32(dev_priv->msvdx_reg + (_offs))
+
+#else
+
+#define PSB_WMSVDX32(_val, _offs) \
+  iowrite32(_val, dev_priv->msvdx_reg + (_offs))
+#define PSB_RMSVDX32(_offs) \
+  ioread32(dev_priv->msvdx_reg + (_offs))
+
+#endif
+
+#define PSB_ALPL(_val, _base)			\
+  (((_val) >> (_base ## _ALIGNSHIFT)) << (_base ## _SHIFT))
+#define PSB_ALPLM(_val, _base)			\
+  ((((_val) >> (_base ## _ALIGNSHIFT)) << (_base ## _SHIFT)) & (_base ## _MASK))
+
+#endif
diff --git a/drivers/staging/gma500/psb_fb.c b/drivers/staging/gma500/psb_fb.c
new file mode 100644
index 0000000..6585e88
--- /dev/null
+++ b/drivers/staging/gma500/psb_fb.c
@@ -0,0 +1,840 @@
+/**************************************************************************
+ * Copyright (c) 2007, Intel Corporation.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/tty.h>
+#include <linux/slab.h>
+#include <linux/delay.h>
+#include <linux/fb.h>
+#include <linux/init.h>
+#include <linux/console.h>
+
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_crtc.h>
+
+#include "psb_drv.h"
+#include "psb_intel_reg.h"
+#include "psb_intel_drv.h"
+#include "psb_ttm_userobj_api.h"
+#include "psb_fb.h"
+#include "psb_sgx.h"
+#include "psb_pvr_glue.h"
+
+static void psb_user_framebuffer_destroy(struct drm_framebuffer *fb);
+static int psb_user_framebuffer_create_handle(struct drm_framebuffer *fb,
+					      struct drm_file *file_priv,
+					      unsigned int *handle);
+
+static const struct drm_framebuffer_funcs psb_fb_funcs = {
+	.destroy = psb_user_framebuffer_destroy,
+	.create_handle = psb_user_framebuffer_create_handle,
+};
+
+#define CMAP_TOHW(_val, _width) ((((_val) << (_width)) + 0x7FFF - (_val)) >> 16)
+
+void *psbfb_vdc_reg(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv;
+	dev_priv = (struct drm_psb_private *) dev->dev_private;
+	return dev_priv->vdc_reg;
+}
+/*EXPORT_SYMBOL(psbfb_vdc_reg); */
+
+static int psbfb_setcolreg(unsigned regno, unsigned red, unsigned green,
+			   unsigned blue, unsigned transp,
+			   struct fb_info *info)
+{
+	struct psb_fbdev *fbdev = info->par;
+	struct drm_framebuffer *fb = fbdev->psb_fb_helper.fb;
+	uint32_t v;
+
+	if (!fb)
+		return -ENOMEM;
+
+	if (regno > 255)
+		return 1;
+
+	red = CMAP_TOHW(red, info->var.red.length);
+	blue = CMAP_TOHW(blue, info->var.blue.length);
+	green = CMAP_TOHW(green, info->var.green.length);
+	transp = CMAP_TOHW(transp, info->var.transp.length);
+
+	v = (red << info->var.red.offset) |
+	    (green << info->var.green.offset) |
+	    (blue << info->var.blue.offset) |
+	    (transp << info->var.transp.offset);
+
+	if (regno < 16) {
+		switch (fb->bits_per_pixel) {
+		case 16:
+			((uint32_t *) info->pseudo_palette)[regno] = v;
+			break;
+		case 24:
+		case 32:
+			((uint32_t *) info->pseudo_palette)[regno] = v;
+			break;
+		}
+	}
+
+	return 0;
+}
+
+static int psbfb_kms_off(struct drm_device *dev, int suspend)
+{
+	struct drm_framebuffer *fb = 0;
+	struct psb_framebuffer *psbfb = to_psb_fb(fb);
+	DRM_DEBUG("psbfb_kms_off_ioctl\n");
+
+	mutex_lock(&dev->mode_config.mutex);
+	list_for_each_entry(fb, &dev->mode_config.fb_list, head) {
+		struct fb_info *info = psbfb->fbdev;
+
+		if (suspend) {
+			fb_set_suspend(info, 1);
+			drm_fb_helper_blank(FB_BLANK_POWERDOWN, info);
+		}
+	}
+	mutex_unlock(&dev->mode_config.mutex);
+	return 0;
+}
+
+int psbfb_kms_off_ioctl(struct drm_device *dev, void *data,
+			struct drm_file *file_priv)
+{
+	int ret;
+
+	if (drm_psb_no_fb)
+		return 0;
+	console_lock();
+	ret = psbfb_kms_off(dev, 0);
+	console_unlock();
+
+	return ret;
+}
+
+static int psbfb_kms_on(struct drm_device *dev, int resume)
+{
+	struct drm_framebuffer *fb = 0;
+	struct psb_framebuffer *psbfb = to_psb_fb(fb);
+
+	DRM_DEBUG("psbfb_kms_on_ioctl\n");
+
+	mutex_lock(&dev->mode_config.mutex);
+	list_for_each_entry(fb, &dev->mode_config.fb_list, head) {
+		struct fb_info *info = psbfb->fbdev;
+
+		if (resume) {
+			fb_set_suspend(info, 0);
+			drm_fb_helper_blank(FB_BLANK_UNBLANK, info);
+		}
+	}
+	mutex_unlock(&dev->mode_config.mutex);
+
+	return 0;
+}
+
+int psbfb_kms_on_ioctl(struct drm_device *dev, void *data,
+		       struct drm_file *file_priv)
+{
+	int ret;
+
+	if (drm_psb_no_fb)
+		return 0;
+	console_lock();
+	ret = psbfb_kms_on(dev, 0);
+	console_unlock();
+	drm_helper_disable_unused_functions(dev);
+	return ret;
+}
+
+void psbfb_suspend(struct drm_device *dev)
+{
+	console_lock();
+	psbfb_kms_off(dev, 1);
+	console_unlock();
+}
+
+void psbfb_resume(struct drm_device *dev)
+{
+	console_lock();
+	psbfb_kms_on(dev, 1);
+	console_unlock();
+	drm_helper_disable_unused_functions(dev);
+}
+
+static int psbfb_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	int page_num = 0;
+	int i;
+	unsigned long address = 0;
+	int ret;
+	unsigned long pfn;
+	struct psb_framebuffer *psbfb = vma->vm_private_data;
+	struct drm_device *dev = psbfb->base.dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_gtt *pg = dev_priv->pg;
+	unsigned long phys_addr = (unsigned long)pg->stolen_base;;
+
+	page_num = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+
+	address = (unsigned long)vmf->virtual_address;
+
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	for (i = 0; i < page_num; i++) {
+		pfn = (phys_addr >> PAGE_SHIFT); /* phys_to_pfn(phys_addr); */
+
+		ret = vm_insert_mixed(vma, address, pfn);
+		if (unlikely((ret == -EBUSY) || (ret != 0 && i > 0)))
+			break;
+		else if (unlikely(ret != 0)) {
+			ret = (ret == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS;
+			return ret;
+		}
+
+		address += PAGE_SIZE;
+		phys_addr += PAGE_SIZE;
+	}
+
+	return VM_FAULT_NOPAGE;
+}
+
+static void psbfb_vm_open(struct vm_area_struct *vma)
+{
+	DRM_DEBUG("vm_open\n");
+}
+
+static void psbfb_vm_close(struct vm_area_struct *vma)
+{
+	DRM_DEBUG("vm_close\n");
+}
+
+static struct vm_operations_struct psbfb_vm_ops = {
+	.fault	= psbfb_vm_fault,
+	.open	= psbfb_vm_open,
+	.close	= psbfb_vm_close
+};
+
+static int psbfb_mmap(struct fb_info *info, struct vm_area_struct *vma)
+{
+	struct psb_fbdev *fbdev = info->par;
+	struct psb_framebuffer *psbfb = fbdev->pfb;
+	char *fb_screen_base = NULL;
+	struct drm_device *dev = psbfb->base.dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_gtt *pg = dev_priv->pg;
+
+	if (vma->vm_pgoff != 0)
+		return -EINVAL;
+	if (vma->vm_pgoff > (~0UL >> PAGE_SHIFT))
+		return -EINVAL;
+
+	if (!psbfb->addr_space)
+		psbfb->addr_space = vma->vm_file->f_mapping;
+
+	fb_screen_base = (char *)info->screen_base;
+
+	DRM_DEBUG("vm_pgoff 0x%lx, screen base %p vram_addr %p\n",
+				vma->vm_pgoff, fb_screen_base, pg->vram_addr);
+
+	/*if using stolen memory, */
+	if (fb_screen_base == pg->vram_addr) {
+		vma->vm_ops = &psbfb_vm_ops;
+		vma->vm_private_data = (void *)psbfb;
+		vma->vm_flags |= VM_RESERVED | VM_IO |
+						VM_MIXEDMAP | VM_DONTEXPAND;
+	} else {
+	/*using IMG meminfo, can I use pvrmmap to map it?*/
+
+	}
+
+	return 0;
+}
+
+
+static struct fb_ops psbfb_ops = {
+	.owner = THIS_MODULE,
+	.fb_check_var = drm_fb_helper_check_var,
+	.fb_set_par = drm_fb_helper_set_par,
+	.fb_blank = drm_fb_helper_blank,
+	.fb_setcolreg = psbfb_setcolreg,
+	.fb_fillrect = cfb_fillrect,
+	.fb_copyarea = cfb_copyarea,
+	.fb_imageblit = cfb_imageblit,
+	.fb_mmap = psbfb_mmap,
+};
+
+static struct drm_framebuffer *psb_framebuffer_create
+			(struct drm_device *dev, struct drm_mode_fb_cmd *r,
+			 void *mm_private)
+{
+	struct psb_framebuffer *fb;
+	int ret;
+
+	fb = kzalloc(sizeof(*fb), GFP_KERNEL);
+	if (!fb)
+		return NULL;
+
+	ret = drm_framebuffer_init(dev, &fb->base, &psb_fb_funcs);
+
+	if (ret)
+		goto err;
+
+	drm_helper_mode_fill_fb_struct(&fb->base, r);
+
+	fb->bo = mm_private;
+
+	return &fb->base;
+
+err:
+	kfree(fb);
+	return NULL;
+}
+
+static struct drm_framebuffer *psb_user_framebuffer_create
+			(struct drm_device *dev, struct drm_file *filp,
+			 struct drm_mode_fb_cmd *r)
+{
+	struct ttm_buffer_object *bo = NULL;
+	uint64_t size;
+
+	bo = ttm_buffer_object_lookup(psb_fpriv(filp)->tfile, r->handle);
+	if (!bo)
+		return NULL;
+
+	/* JB: TODO not drop, make smarter */
+	size = ((uint64_t) bo->num_pages) << PAGE_SHIFT;
+	if (size < r->width * r->height * 4)
+		return NULL;
+
+	/* JB: TODO not drop, refcount buffer */
+	return psb_framebuffer_create(dev, r, bo);
+
+#if 0
+	struct psb_framebuffer *psbfb;
+	struct drm_framebuffer *fb;
+	struct fb_info *info;
+	void *psKernelMemInfo = NULL;
+	void * hKernelMemInfo = (void *)r->handle;
+	struct drm_psb_private *dev_priv
+		= (struct drm_psb_private *)dev->dev_private;
+	struct psb_fbdev *fbdev = dev_priv->fbdev;
+	struct psb_gtt *pg = dev_priv->pg;
+	int ret;
+	uint32_t offset;
+	uint64_t size;
+
+	ret = psb_get_meminfo_by_handle(hKernelMemInfo, &psKernelMemInfo);
+	if (ret) {
+		DRM_ERROR("Cannot get meminfo for handle 0x%x\n",
+						(u32)hKernelMemInfo);
+		return NULL;
+	}
+
+	DRM_DEBUG("Got Kernel MemInfo for handle %lx\n",
+		  (u32)hKernelMemInfo);
+
+	/* JB: TODO not drop, make smarter */
+	size = psKernelMemInfo->ui32AllocSize;
+	if (size < r->height * r->pitch)
+		return NULL;
+
+	/* JB: TODO not drop, refcount buffer */
+	/* return psb_framebuffer_create(dev, r, bo); */
+
+	fb = psb_framebuffer_create(dev, r, (void *)psKernelMemInfo);
+	if (!fb) {
+		DRM_ERROR("failed to allocate fb.\n");
+		return NULL;
+	}
+
+	psbfb = to_psb_fb(fb);
+	psbfb->size = size;
+	psbfb->hKernelMemInfo = hKernelMemInfo;
+
+	DRM_DEBUG("Mapping to gtt..., KernelMemInfo %p\n", psKernelMemInfo);
+
+	/*if not VRAM, map it into tt aperture*/
+	if (psKernelMemInfo->pvLinAddrKM != pg->vram_addr) {
+		ret = psb_gtt_map_meminfo(dev, hKernelMemInfo, &offset);
+		if (ret) {
+			DRM_ERROR("map meminfo for 0x%x failed\n",
+				  (u32)hKernelMemInfo);
+			return NULL;
+		}
+		psbfb->offset = (offset << PAGE_SHIFT);
+	} else {
+		psbfb->offset = 0;
+	}
+	info = framebuffer_alloc(0, &dev->pdev->dev);
+	if (!info)
+		return NULL;
+
+	strcpy(info->fix.id, "psbfb");
+
+	info->flags = FBINFO_DEFAULT;
+	info->fbops = &psbfb_ops;
+
+	info->fix.smem_start = dev->mode_config.fb_base;
+	info->fix.smem_len = size;
+
+	info->screen_base = psKernelMemInfo->pvLinAddrKM;
+	info->screen_size = size;
+
+	drm_fb_helper_fill_fix(info, fb->pitch, fb->depth);
+	drm_fb_helper_fill_var(info, &fbdev->psb_fb_helper,
+							fb->width, fb->height);
+
+	info->fix.mmio_start = pci_resource_start(dev->pdev, 0);
+	info->fix.mmio_len = pci_resource_len(dev->pdev, 0);
+
+	info->pixmap.size = 64 * 1024;
+	info->pixmap.buf_align = 8;
+	info->pixmap.access_align = 32;
+	info->pixmap.flags = FB_PIXMAP_SYSTEM;
+	info->pixmap.scan_align = 1;
+
+	psbfb->fbdev = info;
+	fbdev->pfb = psbfb;
+
+	fbdev->psb_fb_helper.fb = fb;
+	fbdev->psb_fb_helper.fbdev = info;
+	MRSTLFBHandleChangeFB(dev, psbfb);
+
+	return fb;
+#endif
+}
+
+static int psbfb_create(struct psb_fbdev *fbdev,
+				struct drm_fb_helper_surface_size *sizes)
+{
+	struct drm_device *dev = fbdev->psb_fb_helper.dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_gtt *pg = dev_priv->pg;
+	struct fb_info *info;
+	struct drm_framebuffer *fb;
+	struct psb_framebuffer *psbfb;
+	struct drm_mode_fb_cmd mode_cmd;
+	struct device *device = &dev->pdev->dev;
+
+	struct ttm_buffer_object *fbo = NULL;
+	int size, aligned_size;
+	int ret;
+
+	mode_cmd.width = sizes->surface_width;
+	mode_cmd.height = sizes->surface_height;
+
+	mode_cmd.bpp = 32;
+	/* HW requires pitch to be 64 byte aligned */
+	mode_cmd.pitch =  ALIGN(mode_cmd.width * ((mode_cmd.bpp + 1) / 8), 64);
+	mode_cmd.depth = 24;
+
+	size = mode_cmd.pitch * mode_cmd.height;
+	aligned_size = ALIGN(size, PAGE_SIZE);
+
+	mutex_lock(&dev->struct_mutex);
+	fb = psb_framebuffer_create(dev, &mode_cmd, fbo);
+	if (!fb) {
+		DRM_ERROR("failed to allocate fb.\n");
+		ret = -ENOMEM;
+		goto out_err0;
+	}
+	psbfb = to_psb_fb(fb);
+	psbfb->size = size;
+
+	info = framebuffer_alloc(sizeof(struct psb_fbdev), device);
+	if (!info) {
+		ret = -ENOMEM;
+		goto out_err1;
+	}
+
+	info->par = fbdev;
+
+	psbfb->fbdev = info;
+
+	fbdev->psb_fb_helper.fb = fb;
+	fbdev->psb_fb_helper.fbdev = info;
+	fbdev->pfb = psbfb;
+
+	strcpy(info->fix.id, "psbfb");
+
+	info->flags = FBINFO_DEFAULT;
+	info->fbops = &psbfb_ops;
+	info->fix.smem_start = dev->mode_config.fb_base;
+	info->fix.smem_len = size;
+	info->screen_base = (char *)pg->vram_addr;
+	info->screen_size = size;
+	memset(info->screen_base, 0, size);
+
+	drm_fb_helper_fill_fix(info, fb->pitch, fb->depth);
+	drm_fb_helper_fill_var(info, &fbdev->psb_fb_helper,
+				sizes->fb_width, sizes->fb_height);
+
+	info->fix.mmio_start = pci_resource_start(dev->pdev, 0);
+	info->fix.mmio_len = pci_resource_len(dev->pdev, 0);
+
+	info->pixmap.size = 64 * 1024;
+	info->pixmap.buf_align = 8;
+	info->pixmap.access_align = 32;
+	info->pixmap.flags = FB_PIXMAP_SYSTEM;
+	info->pixmap.scan_align = 1;
+
+	DRM_DEBUG("fb depth is %d\n", fb->depth);
+	DRM_DEBUG("   pitch is %d\n", fb->pitch);
+
+	printk(KERN_INFO"allocated %dx%d fb\n",
+				psbfb->base.width, psbfb->base.height);
+
+	mutex_unlock(&dev->struct_mutex);
+
+	return 0;
+out_err0:
+	fb->funcs->destroy(fb);
+out_err1:
+	mutex_unlock(&dev->struct_mutex);
+	return ret;
+}
+
+static void psbfb_gamma_set(struct drm_crtc *crtc, u16 red, u16 green,
+							u16 blue, int regno)
+{
+	DRM_DEBUG("%s\n", __func__);
+}
+
+static void psbfb_gamma_get(struct drm_crtc *crtc, u16 *red,
+					u16 *green, u16 *blue, int regno)
+{
+	DRM_DEBUG("%s\n", __func__);
+}
+
+static int psbfb_probe(struct drm_fb_helper *helper,
+				struct drm_fb_helper_surface_size *sizes)
+{
+	struct psb_fbdev *psb_fbdev = (struct psb_fbdev *)helper;
+	int new_fb = 0;
+	int ret;
+
+	DRM_DEBUG("%s\n", __func__);
+
+	if (!helper->fb) {
+		ret = psbfb_create(psb_fbdev, sizes);
+		if (ret)
+			return ret;
+		new_fb = 1;
+	}
+	return new_fb;
+}
+
+struct drm_fb_helper_funcs psb_fb_helper_funcs = {
+	.gamma_set = psbfb_gamma_set,
+	.gamma_get = psbfb_gamma_get,
+	.fb_probe = psbfb_probe,
+};
+
+int psb_fbdev_destroy(struct drm_device *dev, struct psb_fbdev *fbdev)
+{
+	struct fb_info *info;
+	struct psb_framebuffer *psbfb = fbdev->pfb;
+
+	if (fbdev->psb_fb_helper.fbdev) {
+		info = fbdev->psb_fb_helper.fbdev;
+		unregister_framebuffer(info);
+		iounmap(info->screen_base);
+		framebuffer_release(info);
+	}
+
+	drm_fb_helper_fini(&fbdev->psb_fb_helper);
+
+	drm_framebuffer_cleanup(&psbfb->base);
+
+	return 0;
+}
+
+int psb_fbdev_init(struct drm_device *dev)
+{
+	struct psb_fbdev *fbdev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int num_crtc;
+
+	fbdev = kzalloc(sizeof(struct psb_fbdev), GFP_KERNEL);
+	if (!fbdev) {
+		DRM_ERROR("no memory\n");
+		return -ENOMEM;
+	}
+
+	dev_priv->fbdev = fbdev;
+	fbdev->psb_fb_helper.funcs = &psb_fb_helper_funcs;
+
+	num_crtc = 2;
+
+	drm_fb_helper_init(dev, &fbdev->psb_fb_helper, num_crtc,
+							INTELFB_CONN_LIMIT);
+
+	drm_fb_helper_single_add_all_connectors(&fbdev->psb_fb_helper);
+	drm_fb_helper_initial_config(&fbdev->psb_fb_helper, 32);
+	return 0;
+}
+
+void psb_fbdev_fini(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	if (!dev_priv->fbdev)
+		return;
+
+	psb_fbdev_destroy(dev, dev_priv->fbdev);
+	kfree(dev_priv->fbdev);
+	dev_priv->fbdev = NULL;
+}
+
+
+static void psbfb_output_poll_changed(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_fbdev *fbdev = (struct psb_fbdev *)dev_priv->fbdev;
+	drm_fb_helper_hotplug_event(&fbdev->psb_fb_helper);
+}
+
+int psbfb_remove(struct drm_device *dev, struct drm_framebuffer *fb)
+{
+	struct fb_info *info;
+	struct psb_framebuffer *psbfb = to_psb_fb(fb);
+
+	if (drm_psb_no_fb)
+		return 0;
+
+	info = psbfb->fbdev;
+	psbfb->pvrBO = NULL;
+
+	if (info)
+		framebuffer_release(info);
+	return 0;
+}
+/*EXPORT_SYMBOL(psbfb_remove); */
+
+static int psb_user_framebuffer_create_handle(struct drm_framebuffer *fb,
+					      struct drm_file *file_priv,
+					      unsigned int *handle)
+{
+	/* JB: TODO currently we can't go from a bo to a handle with ttm */
+	(void) file_priv;
+	*handle = 0;
+	return 0;
+}
+
+static void psb_user_framebuffer_destroy(struct drm_framebuffer *fb)
+{
+	struct drm_device *dev = fb->dev;
+	struct psb_framebuffer *psbfb = to_psb_fb(fb);
+
+	/*ummap gtt pages*/
+	psb_gtt_unmap_meminfo(dev, psbfb->hKernelMemInfo);
+	if (psbfb->fbdev)
+		psbfb_remove(dev, fb);
+
+	/* JB: TODO not drop, refcount buffer */
+	drm_framebuffer_cleanup(fb);
+	kfree(fb);
+}
+
+static const struct drm_mode_config_funcs psb_mode_funcs = {
+	.fb_create = psb_user_framebuffer_create,
+	.output_poll_changed = psbfb_output_poll_changed,
+};
+
+static int psb_create_backlight_property(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv
+				= (struct drm_psb_private *) dev->dev_private;
+	struct drm_property *backlight;
+
+	if (dev_priv->backlight_property)
+		return 0;
+
+	backlight = drm_property_create(dev,
+					DRM_MODE_PROP_RANGE,
+					"backlight",
+					2);
+	backlight->values[0] = 0;
+	backlight->values[1] = 100;
+
+	dev_priv->backlight_property = backlight;
+
+	return 0;
+}
+
+static void psb_setup_outputs(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv =
+	    (struct drm_psb_private *) dev->dev_private;
+	struct drm_connector *connector;
+
+	PSB_DEBUG_ENTRY("\n");
+
+	drm_mode_create_scaling_mode_property(dev);
+
+	psb_create_backlight_property(dev);
+
+	psb_intel_lvds_init(dev, &dev_priv->mode_dev);
+	/* psb_intel_sdvo_init(dev, SDVOB); */
+
+	list_for_each_entry(connector, &dev->mode_config.connector_list,
+			    head) {
+		struct psb_intel_output *psb_intel_output =
+		    to_psb_intel_output(connector);
+		struct drm_encoder *encoder = &psb_intel_output->enc;
+		int crtc_mask = 0, clone_mask = 0;
+
+		/* valid crtcs */
+		switch (psb_intel_output->type) {
+		case INTEL_OUTPUT_SDVO:
+			crtc_mask = ((1 << 0) | (1 << 1));
+			clone_mask = (1 << INTEL_OUTPUT_SDVO);
+			break;
+		case INTEL_OUTPUT_LVDS:
+			PSB_DEBUG_ENTRY("LVDS.\n");
+			crtc_mask = (1 << 1);
+			clone_mask = (1 << INTEL_OUTPUT_LVDS);
+			break;
+		case INTEL_OUTPUT_MIPI:
+			PSB_DEBUG_ENTRY("MIPI.\n");
+			crtc_mask = (1 << 0);
+			clone_mask = (1 << INTEL_OUTPUT_MIPI);
+			break;
+		case INTEL_OUTPUT_MIPI2:
+			PSB_DEBUG_ENTRY("MIPI2.\n");
+			crtc_mask = (1 << 2);
+			clone_mask = (1 << INTEL_OUTPUT_MIPI2);
+			break;
+		case INTEL_OUTPUT_HDMI:
+			PSB_DEBUG_ENTRY("HDMI.\n");
+			crtc_mask = (1 << 1);
+			clone_mask = (1 << INTEL_OUTPUT_HDMI);
+			break;
+		}
+
+		encoder->possible_crtcs = crtc_mask;
+		encoder->possible_clones =
+		    psb_intel_connector_clones(dev, clone_mask);
+
+	}
+}
+
+static void *psb_bo_from_handle(struct drm_device *dev,
+				struct drm_file *file_priv,
+				unsigned int handle)
+{
+	void *psKernelMemInfo = NULL;
+	void * hKernelMemInfo = (void *)handle;
+	int ret;
+
+	ret = psb_get_meminfo_by_handle(hKernelMemInfo, &psKernelMemInfo);
+	if (ret) {
+		DRM_ERROR("Cannot get meminfo for handle 0x%x\n",
+			  (u32)hKernelMemInfo);
+		return NULL;
+	}
+
+	return (void *)psKernelMemInfo;
+}
+
+static size_t psb_bo_size(struct drm_device *dev, void *bof)
+{
+#if 0
+	void *psKernelMemInfo	= (void *)bof;
+	return (size_t)psKernelMemInfo->ui32AllocSize;
+#else
+	return 0;
+#endif
+}
+
+static size_t psb_bo_offset(struct drm_device *dev, void *bof)
+{
+	struct psb_framebuffer *psbfb
+		= (struct psb_framebuffer *)bof;
+
+	return (size_t)psbfb->offset;
+}
+
+static int psb_bo_pin_for_scanout(struct drm_device *dev, void *bo)
+{
+	 return 0;
+}
+
+static int psb_bo_unpin_for_scanout(struct drm_device *dev, void *bo)
+{
+	return 0;
+}
+
+void psb_modeset_init(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv =
+	    (struct drm_psb_private *) dev->dev_private;
+	struct psb_intel_mode_device *mode_dev = &dev_priv->mode_dev;
+	int i;
+
+	PSB_DEBUG_ENTRY("\n");
+	/* Init mm functions */
+	mode_dev->bo_from_handle = psb_bo_from_handle;
+	mode_dev->bo_size = psb_bo_size;
+	mode_dev->bo_offset = psb_bo_offset;
+	mode_dev->bo_pin_for_scanout = psb_bo_pin_for_scanout;
+	mode_dev->bo_unpin_for_scanout = psb_bo_unpin_for_scanout;
+
+	drm_mode_config_init(dev);
+
+	dev->mode_config.min_width = 0;
+	dev->mode_config.min_height = 0;
+
+	dev->mode_config.funcs = (void *) &psb_mode_funcs;
+
+	/* set memory base */
+	/* MRST and PSB should use BAR 2*/
+	pci_read_config_dword(dev->pdev, PSB_BSM, (u32 *)
+					&(dev->mode_config.fb_base));
+
+	/* num pipes is 2 for PSB but 1 for Mrst */
+	for (i = 0; i < dev_priv->num_pipe; i++)
+		psb_intel_crtc_init(dev, i, mode_dev);
+
+	dev->mode_config.max_width = 2048;
+	dev->mode_config.max_height = 2048;
+
+	psb_setup_outputs(dev);
+
+	/* setup fbs */
+	/* drm_initial_config(dev); */
+}
+
+void psb_modeset_cleanup(struct drm_device *dev)
+{
+	mutex_lock(&dev->struct_mutex);
+
+	drm_kms_helper_poll_fini(dev);
+	psb_fbdev_fini(dev);
+
+	drm_mode_config_cleanup(dev);
+
+	mutex_unlock(&dev->struct_mutex);
+}
diff --git a/drivers/staging/gma500/psb_fb.h b/drivers/staging/gma500/psb_fb.h
new file mode 100644
index 0000000..d39d84d
--- /dev/null
+++ b/drivers/staging/gma500/psb_fb.h
@@ -0,0 +1,59 @@
+/*
+ * Copyright (c) 2008, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors:
+ *      Eric Anholt <eric@anholt.net>
+ *
+ */
+
+#ifndef _PSB_FB_H_
+#define _PSB_FB_H_
+
+#include <linux/version.h>
+#include <drm/drmP.h>
+#include <drm/drm_fb_helper.h>
+
+#include "psb_drv.h"
+
+/*IMG Headers*/
+/*#include "servicesint.h"*/
+
+struct psb_framebuffer {
+	struct drm_framebuffer base;
+	struct address_space *addr_space;
+	struct ttm_buffer_object *bo;
+	struct fb_info * fbdev;
+	/* struct ttm_bo_kmap_obj kmap; */
+	void *pvrBO;	/* FIXME: sort this out */
+	void * hKernelMemInfo;
+	uint32_t size;
+	uint32_t offset;
+};
+
+struct psb_fbdev {
+	struct drm_fb_helper psb_fb_helper;
+	struct psb_framebuffer * pfb;
+};
+
+
+#define to_psb_fb(x) container_of(x, struct psb_framebuffer, base)
+
+
+extern int psb_intel_connector_clones(struct drm_device *dev, int type_mask);
+
+
+#endif
+
diff --git a/drivers/staging/gma500/psb_fence.c b/drivers/staging/gma500/psb_fence.c
new file mode 100644
index 0000000..a70aa64
--- /dev/null
+++ b/drivers/staging/gma500/psb_fence.c
@@ -0,0 +1,122 @@
+/*
+ * Copyright (c) 2007, Intel Corporation.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ *
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+#include <drm/drmP.h>
+#include "psb_drv.h"
+
+
+static void psb_fence_poll(struct ttm_fence_device *fdev,
+			   uint32_t fence_class, uint32_t waiting_types)
+{
+	struct drm_psb_private *dev_priv =
+	    container_of(fdev, struct drm_psb_private, fdev);
+
+
+	if (unlikely(!dev_priv))
+		return;
+
+	if (waiting_types == 0)
+		return;
+
+	/* DRM_ERROR("Polling fence sequence, got 0x%08x\n", sequence); */
+	ttm_fence_handler(fdev, fence_class, 0 /* Sequence */,
+			_PSB_FENCE_TYPE_EXE, 0);
+}
+
+void psb_fence_error(struct drm_device *dev,
+		     uint32_t fence_class,
+		     uint32_t sequence, uint32_t type, int error)
+{
+	struct drm_psb_private *dev_priv = psb_priv(dev);
+	struct ttm_fence_device *fdev = &dev_priv->fdev;
+	unsigned long irq_flags;
+	struct ttm_fence_class_manager *fc =
+	    &fdev->fence_class[fence_class];
+
+	BUG_ON(fence_class >= PSB_NUM_ENGINES);
+	write_lock_irqsave(&fc->lock, irq_flags);
+	ttm_fence_handler(fdev, fence_class, sequence, type, error);
+	write_unlock_irqrestore(&fc->lock, irq_flags);
+}
+
+int psb_fence_emit_sequence(struct ttm_fence_device *fdev,
+			    uint32_t fence_class,
+			    uint32_t flags, uint32_t *sequence,
+			    unsigned long *timeout_jiffies)
+{
+	struct drm_psb_private *dev_priv =
+	    container_of(fdev, struct drm_psb_private, fdev);
+
+	if (!dev_priv)
+		return -EINVAL;
+
+	if (fence_class >= PSB_NUM_ENGINES)
+		return -EINVAL;
+
+	DRM_ERROR("Unexpected fence class\n");
+	return -EINVAL;
+}
+
+static void psb_fence_lockup(struct ttm_fence_object *fence,
+			     uint32_t fence_types)
+{
+	DRM_ERROR("Unsupported fence class\n");
+}
+
+void psb_fence_handler(struct drm_device *dev, uint32_t fence_class)
+{
+	struct drm_psb_private *dev_priv = psb_priv(dev);
+	struct ttm_fence_device *fdev = &dev_priv->fdev;
+	struct ttm_fence_class_manager *fc =
+	    &fdev->fence_class[fence_class];
+	unsigned long irq_flags;
+
+	write_lock_irqsave(&fc->lock, irq_flags);
+	psb_fence_poll(fdev, fence_class, fc->waiting_types);
+	write_unlock_irqrestore(&fc->lock, irq_flags);
+}
+
+
+static struct ttm_fence_driver psb_ttm_fence_driver = {
+	.has_irq = NULL,
+	.emit = psb_fence_emit_sequence,
+	.flush = NULL,
+	.poll = psb_fence_poll,
+	.needed_flush = NULL,
+	.wait = NULL,
+	.signaled = NULL,
+	.lockup = psb_fence_lockup,
+};
+
+int psb_ttm_fence_device_init(struct ttm_fence_device *fdev)
+{
+	struct drm_psb_private *dev_priv =
+		container_of(fdev, struct drm_psb_private, fdev);
+	struct ttm_fence_class_init fci = {.wrap_diff = (1 << 30),
+		.flush_diff = (1 << 29),
+		.sequence_mask = 0xFFFFFFFF
+	};
+
+	return ttm_fence_device_init(PSB_NUM_ENGINES,
+				     dev_priv->mem_global_ref.object,
+				     fdev, &fci, 1,
+				     &psb_ttm_fence_driver);
+}
diff --git a/drivers/staging/gma500/psb_gfx.mod.c b/drivers/staging/gma500/psb_gfx.mod.c
new file mode 100644
index 0000000..1a663ab
--- /dev/null
+++ b/drivers/staging/gma500/psb_gfx.mod.c
@@ -0,0 +1,27 @@
+#include <linux/module.h>
+#include <linux/vermagic.h>
+#include <linux/compiler.h>
+
+MODULE_INFO(vermagic, VERMAGIC_STRING);
+
+struct module __this_module
+__attribute__((section(".gnu.linkonce.this_module"))) = {
+ .name = KBUILD_MODNAME,
+ .init = init_module,
+#ifdef CONFIG_MODULE_UNLOAD
+ .exit = cleanup_module,
+#endif
+ .arch = MODULE_ARCH_INIT,
+};
+
+MODULE_INFO(staging, "Y");
+
+static const char __module_depends[]
+__used
+__attribute__((section(".modinfo"))) =
+"depends=ttm,drm,drm_kms_helper,i2c-core,cfbfillrect,cfbimgblt,cfbcopyarea,i2c-algo-bit";
+
+MODULE_ALIAS("pci:v00008086d00008108sv*sd*bc*sc*i*");
+MODULE_ALIAS("pci:v00008086d00008109sv*sd*bc*sc*i*");
+
+MODULE_INFO(srcversion, "933CCC78041722973001B78");
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
new file mode 100644
index 0000000..53c1e1e
--- /dev/null
+++ b/drivers/staging/gma500/psb_gtt.c
@@ -0,0 +1,1034 @@
+/*
+ * Copyright (c) 2007, Intel Corporation.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics.com>
+ */
+
+#include <drm/drmP.h>
+#include "psb_drv.h"
+#include "psb_pvr_glue.h"
+
+static inline uint32_t psb_gtt_mask_pte(uint32_t pfn, int type)
+{
+	uint32_t mask = PSB_PTE_VALID;
+
+	if (type & PSB_MMU_CACHED_MEMORY)
+		mask |= PSB_PTE_CACHED;
+	if (type & PSB_MMU_RO_MEMORY)
+		mask |= PSB_PTE_RO;
+	if (type & PSB_MMU_WO_MEMORY)
+		mask |= PSB_PTE_WO;
+
+	return (pfn << PAGE_SHIFT) | mask;
+}
+
+struct psb_gtt *psb_gtt_alloc(struct drm_device *dev)
+{
+	struct psb_gtt *tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
+
+	if (!tmp)
+		return NULL;
+
+	init_rwsem(&tmp->sem);
+	tmp->dev = dev;
+
+	return tmp;
+}
+
+void psb_gtt_takedown(struct psb_gtt *pg, int free)
+{
+	struct drm_psb_private *dev_priv = pg->dev->dev_private;
+
+	if (!pg)
+		return;
+
+	if (pg->gtt_map) {
+		iounmap(pg->gtt_map);
+		pg->gtt_map = NULL;
+	}
+	if (pg->initialized) {
+		pci_write_config_word(pg->dev->pdev, PSB_GMCH_CTRL,
+				      pg->gmch_ctrl);
+		PSB_WVDC32(pg->pge_ctl, PSB_PGETBL_CTL);
+		(void) PSB_RVDC32(PSB_PGETBL_CTL);
+	}
+	if (free)
+		kfree(pg);
+}
+
+int psb_gtt_init(struct psb_gtt *pg, int resume)
+{
+	struct drm_device *dev = pg->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	unsigned gtt_pages;
+	unsigned long stolen_size, vram_stolen_size, ci_stolen_size;
+	unsigned long rar_stolen_size;
+	unsigned i, num_pages;
+	unsigned pfn_base;
+	uint32_t ci_pages, vram_pages;
+	uint32_t tt_pages;
+	uint32_t *ttm_gtt_map;
+	uint32_t dvmt_mode = 0;
+
+	int ret = 0;
+	uint32_t pte;
+
+	pci_read_config_word(dev->pdev, PSB_GMCH_CTRL, &pg->gmch_ctrl);
+	pci_write_config_word(dev->pdev, PSB_GMCH_CTRL,
+			      pg->gmch_ctrl | _PSB_GMCH_ENABLED);
+
+	pg->pge_ctl = PSB_RVDC32(PSB_PGETBL_CTL);
+	PSB_WVDC32(pg->pge_ctl | _PSB_PGETBL_ENABLED, PSB_PGETBL_CTL);
+	(void) PSB_RVDC32(PSB_PGETBL_CTL);
+
+	pg->initialized = 1;
+
+	pg->gtt_phys_start = pg->pge_ctl & PAGE_MASK;
+
+	pg->gatt_start = pci_resource_start(dev->pdev, PSB_GATT_RESOURCE);
+	/* fix me: video mmu has hw bug to access 0x0D0000000,
+	 * then make gatt start at 0x0e000,0000 */
+	pg->mmu_gatt_start = PSB_MEM_TT_START;
+	pg->gtt_start = pci_resource_start(dev->pdev, PSB_GTT_RESOURCE);
+	gtt_pages =
+	    pci_resource_len(dev->pdev, PSB_GTT_RESOURCE) >> PAGE_SHIFT;
+	pg->gatt_pages = pci_resource_len(dev->pdev, PSB_GATT_RESOURCE)
+	    >> PAGE_SHIFT;
+
+	pci_read_config_dword(dev->pdev, PSB_BSM, &pg->stolen_base);
+	vram_stolen_size = pg->gtt_phys_start - pg->stolen_base - PAGE_SIZE;
+
+	/* CI is not included in the stolen size since the TOPAZ MMU bug */
+	ci_stolen_size = dev_priv->ci_region_size;
+	/* Don't add CI & RAR share buffer space
+	 * managed by TTM to stolen_size */
+	stolen_size = vram_stolen_size;
+
+	rar_stolen_size = dev_priv->rar_region_size;
+
+	printk(KERN_INFO"GMMADR(region 0) start: 0x%08x (%dM).\n",
+		pg->gatt_start, pg->gatt_pages/256);
+	printk(KERN_INFO"GTTADR(region 3) start: 0x%08x (can map %dM RAM), and actual RAM base 0x%08x.\n",
+		pg->gtt_start, gtt_pages * 4, pg->gtt_phys_start);
+	printk(KERN_INFO "Stole memory information\n");
+	printk(KERN_INFO "      base in RAM: 0x%x\n", pg->stolen_base);
+	printk(KERN_INFO "      size: %luK, calculated by (GTT RAM base) - (Stolen base), seems wrong\n",
+		vram_stolen_size/1024);
+	dvmt_mode = (pg->gmch_ctrl >> 4) & 0x7;
+	printk(KERN_INFO "      the correct size should be: %dM(dvmt mode=%d)\n",
+		(dvmt_mode == 1) ? 1 : (2 << (dvmt_mode - 1)), dvmt_mode);
+
+	if (ci_stolen_size > 0)
+		printk(KERN_INFO"CI Stole memory: RAM base = 0x%08x, size = %lu M\n",
+				dev_priv->ci_region_start,
+				ci_stolen_size / 1024 / 1024);
+	if (rar_stolen_size > 0)
+		printk(KERN_INFO "RAR Stole memory: RAM base = 0x%08x, size = %lu M\n",
+			dev_priv->rar_region_start,
+			rar_stolen_size / 1024 / 1024);
+
+	if (resume && (gtt_pages != pg->gtt_pages) &&
+	    (stolen_size != pg->stolen_size)) {
+		DRM_ERROR("GTT resume error.\n");
+		ret = -EINVAL;
+		goto out_err;
+	}
+
+	pg->gtt_pages = gtt_pages;
+	pg->stolen_size = stolen_size;
+	pg->vram_stolen_size = vram_stolen_size;
+	pg->ci_stolen_size = ci_stolen_size;
+	pg->rar_stolen_size = rar_stolen_size;
+	pg->gtt_map =
+	    ioremap_nocache(pg->gtt_phys_start, gtt_pages << PAGE_SHIFT);
+	if (!pg->gtt_map) {
+		DRM_ERROR("Failure to map gtt.\n");
+		ret = -ENOMEM;
+		goto out_err;
+	}
+
+	pg->vram_addr = ioremap_wc(pg->stolen_base, stolen_size);
+	if (!pg->vram_addr) {
+		DRM_ERROR("Failure to map stolen base.\n");
+		ret = -ENOMEM;
+		goto out_err;
+	}
+
+	DRM_DEBUG("%s: vram kernel virtual address %p\n", pg->vram_addr);
+
+	tt_pages = (pg->gatt_pages < PSB_TT_PRIV0_PLIMIT) ?
+		(pg->gatt_pages) : PSB_TT_PRIV0_PLIMIT;
+
+	ttm_gtt_map = pg->gtt_map + tt_pages / 2;
+
+	/*
+	 * insert vram stolen pages.
+	 */
+
+	pfn_base = pg->stolen_base >> PAGE_SHIFT;
+	vram_pages = num_pages = vram_stolen_size >> PAGE_SHIFT;
+	printk(KERN_INFO"Set up %d stolen pages starting at 0x%08x, GTT offset %dK\n",
+		num_pages, pfn_base, 0);
+	for (i = 0; i < num_pages; ++i) {
+		pte = psb_gtt_mask_pte(pfn_base + i, 0);
+		iowrite32(pte, pg->gtt_map + i);
+	}
+
+	/*
+	 * Init rest of gtt managed by IMG.
+	 */
+	pfn_base = page_to_pfn(dev_priv->scratch_page);
+	pte = psb_gtt_mask_pte(pfn_base, 0);
+	for (; i < tt_pages / 2 - 1; ++i)
+		iowrite32(pte, pg->gtt_map + i);
+
+	/*
+	 * insert CI stolen pages
+	 */
+
+	pfn_base = dev_priv->ci_region_start >> PAGE_SHIFT;
+	ci_pages = num_pages = ci_stolen_size >> PAGE_SHIFT;
+	printk(KERN_INFO"Set up %d CI stolen pages starting at 0x%08x, GTT offset %dK\n",
+	       num_pages, pfn_base, (ttm_gtt_map - pg->gtt_map) * 4);
+	for (i = 0; i < num_pages; ++i) {
+		pte = psb_gtt_mask_pte(pfn_base + i, 0);
+		iowrite32(pte, ttm_gtt_map + i);
+	}
+
+	/*
+	 * insert RAR stolen pages
+	 */
+	if (rar_stolen_size != 0) {
+		pfn_base = dev_priv->rar_region_start >> PAGE_SHIFT;
+		num_pages = rar_stolen_size >> PAGE_SHIFT;
+		printk(KERN_INFO"Set up %d RAR stolen pages starting at 0x%08x, GTT offset %dK\n",
+			num_pages, pfn_base,
+			(ttm_gtt_map - pg->gtt_map + i) * 4);
+		for (; i < num_pages + ci_pages; ++i) {
+			pte = psb_gtt_mask_pte(pfn_base + i - ci_pages, 0);
+			iowrite32(pte, ttm_gtt_map + i);
+		}
+	}
+	/*
+	 * Init rest of gtt managed by TTM.
+	 */
+
+	pfn_base = page_to_pfn(dev_priv->scratch_page);
+	pte = psb_gtt_mask_pte(pfn_base, 0);
+	PSB_DEBUG_INIT("Initializing the rest of a total "
+		       "of %d gtt pages.\n", pg->gatt_pages);
+
+	for (; i < pg->gatt_pages - tt_pages / 2; ++i)
+		iowrite32(pte, ttm_gtt_map + i);
+	(void) ioread32(pg->gtt_map + i - 1);
+
+	return 0;
+
+out_err:
+	psb_gtt_takedown(pg, 0);
+	return ret;
+}
+
+int psb_gtt_insert_pages(struct psb_gtt *pg, struct page **pages,
+			 unsigned offset_pages, unsigned num_pages,
+			 unsigned desired_tile_stride,
+			 unsigned hw_tile_stride, int type)
+{
+	unsigned rows = 1;
+	unsigned add;
+	unsigned row_add;
+	unsigned i;
+	unsigned j;
+	uint32_t *cur_page = NULL;
+	uint32_t pte;
+
+	if (hw_tile_stride)
+		rows = num_pages / desired_tile_stride;
+	else
+		desired_tile_stride = num_pages;
+
+	add = desired_tile_stride;
+	row_add = hw_tile_stride;
+
+	down_read(&pg->sem);
+	for (i = 0; i < rows; ++i) {
+		cur_page = pg->gtt_map + offset_pages;
+		for (j = 0; j < desired_tile_stride; ++j) {
+			pte =
+			    psb_gtt_mask_pte(page_to_pfn(*pages++), type);
+			iowrite32(pte, cur_page++);
+		}
+		offset_pages += add;
+	}
+	(void) ioread32(cur_page - 1);
+	up_read(&pg->sem);
+
+	return 0;
+}
+
+int psb_gtt_insert_phys_addresses(struct psb_gtt *pg, dma_addr_t *pPhysFrames,
+			unsigned offset_pages, unsigned num_pages, int type)
+{
+	unsigned j;
+	uint32_t *cur_page = NULL;
+	uint32_t pte;
+	u32 ba;
+
+	down_read(&pg->sem);
+	cur_page = pg->gtt_map + offset_pages;
+	for (j = 0; j < num_pages; ++j) {
+		ba = *pPhysFrames++;
+		pte =  psb_gtt_mask_pte(ba >> PAGE_SHIFT, type);
+		iowrite32(pte, cur_page++);
+	}
+	(void) ioread32(cur_page - 1);
+	up_read(&pg->sem);
+	return 0;
+}
+
+int psb_gtt_remove_pages(struct psb_gtt *pg, unsigned offset_pages,
+			 unsigned num_pages, unsigned desired_tile_stride,
+			 unsigned hw_tile_stride, int rc_prot)
+{
+	struct drm_psb_private *dev_priv = pg->dev->dev_private;
+	unsigned rows = 1;
+	unsigned add;
+	unsigned row_add;
+	unsigned i;
+	unsigned j;
+	uint32_t *cur_page = NULL;
+	unsigned pfn_base = page_to_pfn(dev_priv->scratch_page);
+	uint32_t pte = psb_gtt_mask_pte(pfn_base, 0);
+
+	if (hw_tile_stride)
+		rows = num_pages / desired_tile_stride;
+	else
+		desired_tile_stride = num_pages;
+
+	add = desired_tile_stride;
+	row_add = hw_tile_stride;
+
+	if (rc_prot)
+		down_read(&pg->sem);
+	for (i = 0; i < rows; ++i) {
+		cur_page = pg->gtt_map + offset_pages;
+		for (j = 0; j < desired_tile_stride; ++j)
+			iowrite32(pte, cur_page++);
+
+		offset_pages += add;
+	}
+	(void) ioread32(cur_page - 1);
+	if (rc_prot)
+		up_read(&pg->sem);
+
+	return 0;
+}
+
+int psb_gtt_mm_init(struct psb_gtt *pg)
+{
+	struct psb_gtt_mm *gtt_mm;
+	struct drm_psb_private *dev_priv = pg->dev->dev_private;
+	struct drm_open_hash *ht;
+	struct drm_mm *mm;
+	int ret;
+	uint32_t tt_start;
+	uint32_t tt_size;
+
+	if (!pg || !pg->initialized) {
+		DRM_DEBUG("Invalid gtt struct\n");
+		return -EINVAL;
+	}
+
+	gtt_mm =  kzalloc(sizeof(struct psb_gtt_mm), GFP_KERNEL);
+	if (!gtt_mm)
+		return -ENOMEM;
+
+	spin_lock_init(&gtt_mm->lock);
+
+	ht = &gtt_mm->hash;
+	ret = drm_ht_create(ht, 20);
+	if (ret) {
+		DRM_DEBUG("Create hash table failed(%d)\n", ret);
+		goto err_free;
+	}
+
+	tt_start = (pg->stolen_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	tt_start = (tt_start < pg->gatt_pages) ? tt_start : pg->gatt_pages;
+	tt_size = (pg->gatt_pages < PSB_TT_PRIV0_PLIMIT) ?
+			(pg->gatt_pages) : PSB_TT_PRIV0_PLIMIT;
+
+	mm = &gtt_mm->base;
+
+	/*will use tt_start ~ 128M for IMG TT buffers*/
+	ret = drm_mm_init(mm, tt_start, ((tt_size / 2) - tt_start));
+	if (ret) {
+		DRM_DEBUG("drm_mm_int error(%d)\n", ret);
+		goto err_mm_init;
+	}
+
+	gtt_mm->count = 0;
+
+	dev_priv->gtt_mm = gtt_mm;
+
+	DRM_INFO("PSB GTT mem manager ready, tt_start %ld, tt_size %ld pages\n",
+		(unsigned long)tt_start,
+		(unsigned long)((tt_size / 2) - tt_start));
+	return 0;
+err_mm_init:
+	drm_ht_remove(ht);
+
+err_free:
+	kfree(gtt_mm);
+	return ret;
+}
+
+/**
+ * Delete all hash entries;
+ */
+void psb_gtt_mm_takedown(void)
+{
+	return;
+}
+
+static int psb_gtt_mm_get_ht_by_pid_locked(struct psb_gtt_mm *mm,
+				    u32 tgid,
+				    struct psb_gtt_hash_entry **hentry)
+{
+	struct drm_hash_item *entry;
+	struct psb_gtt_hash_entry *psb_entry;
+	int ret;
+
+	ret = drm_ht_find_item(&mm->hash, tgid, &entry);
+	if (ret) {
+		DRM_DEBUG("Cannot find entry pid=%ld\n", tgid);
+		return ret;
+	}
+
+	psb_entry = container_of(entry, struct psb_gtt_hash_entry, item);
+	if (!psb_entry) {
+		DRM_DEBUG("Invalid entry");
+		return -EINVAL;
+	}
+
+	*hentry = psb_entry;
+	return 0;
+}
+
+
+static int psb_gtt_mm_insert_ht_locked(struct psb_gtt_mm *mm,
+				       u32 tgid,
+				       struct psb_gtt_hash_entry *hentry)
+{
+	struct drm_hash_item *item;
+	int ret;
+
+	if (!hentry) {
+		DRM_DEBUG("Invalid parameters\n");
+		return -EINVAL;
+	}
+
+	item = &hentry->item;
+	item->key = tgid;
+
+	/**
+	 * NOTE: drm_ht_insert_item will perform such a check
+	ret = psb_gtt_mm_get_ht_by_pid(mm, tgid, &tmp);
+	if (!ret) {
+		DRM_DEBUG("Entry already exists for pid %ld\n", tgid);
+		return -EAGAIN;
+	}
+	*/
+
+	/*Insert the given entry*/
+	ret = drm_ht_insert_item(&mm->hash, item);
+	if (ret) {
+		DRM_DEBUG("Insert failure\n");
+		return ret;
+	}
+
+	mm->count++;
+
+	return 0;
+}
+
+static int psb_gtt_mm_alloc_insert_ht(struct psb_gtt_mm *mm,
+				      u32 tgid,
+				      struct psb_gtt_hash_entry **entry)
+{
+	struct psb_gtt_hash_entry *hentry;
+	int ret;
+
+	/*if the hentry for this tgid exists, just get it and return*/
+	spin_lock(&mm->lock);
+	ret = psb_gtt_mm_get_ht_by_pid_locked(mm, tgid, &hentry);
+	if (!ret) {
+		DRM_DEBUG("Entry for tgid %ld exist, hentry %p\n",
+			  tgid, hentry);
+		*entry = hentry;
+		spin_unlock(&mm->lock);
+		return 0;
+	}
+	spin_unlock(&mm->lock);
+
+	DRM_DEBUG("Entry for tgid %ld doesn't exist, will create it\n", tgid);
+
+	hentry = kzalloc(sizeof(struct psb_gtt_hash_entry), GFP_KERNEL);
+	if (!hentry) {
+		DRM_DEBUG("Kmalloc failled\n");
+		return -ENOMEM;
+	}
+
+	ret = drm_ht_create(&hentry->ht, 20);
+	if (ret) {
+		DRM_DEBUG("Create hash table failed\n");
+		return ret;
+	}
+
+	spin_lock(&mm->lock);
+	ret = psb_gtt_mm_insert_ht_locked(mm, tgid, hentry);
+	spin_unlock(&mm->lock);
+
+	if (!ret)
+		*entry = hentry;
+
+	return ret;
+}
+
+static struct psb_gtt_hash_entry *
+psb_gtt_mm_remove_ht_locked(struct psb_gtt_mm *mm, u32 tgid)
+{
+	struct psb_gtt_hash_entry *tmp;
+	int ret;
+
+	ret = psb_gtt_mm_get_ht_by_pid_locked(mm, tgid, &tmp);
+	if (ret) {
+		DRM_DEBUG("Cannot find entry pid %ld\n", tgid);
+		return NULL;
+	}
+
+	/*remove it from ht*/
+	drm_ht_remove_item(&mm->hash, &tmp->item);
+
+	mm->count--;
+
+	return tmp;
+}
+
+static int psb_gtt_mm_remove_free_ht_locked(struct psb_gtt_mm *mm, u32 tgid)
+{
+	struct psb_gtt_hash_entry *entry;
+
+	entry = psb_gtt_mm_remove_ht_locked(mm, tgid);
+
+	if (!entry) {
+		DRM_DEBUG("Invalid entry");
+		return -EINVAL;
+	}
+
+	/*delete ht*/
+	drm_ht_remove(&entry->ht);
+
+	/*free this entry*/
+	kfree(entry);
+	return 0;
+}
+
+static int
+psb_gtt_mm_get_mem_mapping_locked(struct drm_open_hash *ht,
+			   u32 key,
+			   struct psb_gtt_mem_mapping **hentry)
+{
+	struct drm_hash_item *entry;
+	struct psb_gtt_mem_mapping *mapping;
+	int ret;
+
+	ret = drm_ht_find_item(ht, key, &entry);
+	if (ret) {
+		DRM_DEBUG("Cannot find key %ld\n", key);
+		return ret;
+	}
+
+	mapping =  container_of(entry, struct psb_gtt_mem_mapping, item);
+	if (!mapping) {
+		DRM_DEBUG("Invalid entry\n");
+		return -EINVAL;
+	}
+
+	*hentry = mapping;
+	return 0;
+}
+
+static int
+psb_gtt_mm_insert_mem_mapping_locked(struct drm_open_hash *ht,
+			      u32 key,
+			      struct psb_gtt_mem_mapping *hentry)
+{
+	struct drm_hash_item *item;
+	struct psb_gtt_hash_entry *entry;
+	int ret;
+
+	if (!hentry) {
+		DRM_DEBUG("hentry is NULL\n");
+		return -EINVAL;
+	}
+
+	item = &hentry->item;
+	item->key = key;
+
+	ret = drm_ht_insert_item(ht, item);
+	if (ret) {
+		DRM_DEBUG("insert_item failed\n");
+		return ret;
+	}
+
+	entry = container_of(ht, struct psb_gtt_hash_entry, ht);
+	if (entry)
+		entry->count++;
+
+	return 0;
+}
+
+static int
+psb_gtt_mm_alloc_insert_mem_mapping(struct psb_gtt_mm *mm,
+				    struct drm_open_hash *ht,
+				    u32 key,
+				    struct drm_mm_node *node,
+				    struct psb_gtt_mem_mapping **entry)
+{
+	struct psb_gtt_mem_mapping *mapping;
+	int ret;
+
+	if (!node || !ht) {
+		DRM_DEBUG("parameter error\n");
+		return -EINVAL;
+	}
+
+	/*try to get this mem_map */
+	spin_lock(&mm->lock);
+	ret = psb_gtt_mm_get_mem_mapping_locked(ht, key, &mapping);
+	if (!ret) {
+		DRM_DEBUG("mapping entry for key %ld exists, entry %p\n",
+			  key, mapping);
+		*entry = mapping;
+		spin_unlock(&mm->lock);
+		return 0;
+	}
+	spin_unlock(&mm->lock);
+
+	DRM_DEBUG("Mapping entry for key %ld doesn't exist, will create it\n",
+		  key);
+
+	mapping = kzalloc(sizeof(struct psb_gtt_mem_mapping), GFP_KERNEL);
+	if (!mapping) {
+		DRM_DEBUG("kmalloc failed\n");
+		return -ENOMEM;
+	}
+
+	mapping->node = node;
+
+	spin_lock(&mm->lock);
+	ret = psb_gtt_mm_insert_mem_mapping_locked(ht, key, mapping);
+	spin_unlock(&mm->lock);
+
+	if (!ret)
+		*entry = mapping;
+
+	return ret;
+}
+
+static struct psb_gtt_mem_mapping *
+psb_gtt_mm_remove_mem_mapping_locked(struct drm_open_hash *ht, u32 key)
+{
+	struct psb_gtt_mem_mapping *tmp;
+	struct psb_gtt_hash_entry *entry;
+	int ret;
+
+	ret = psb_gtt_mm_get_mem_mapping_locked(ht, key, &tmp);
+	if (ret) {
+		DRM_DEBUG("Cannot find key %ld\n", key);
+		return NULL;
+	}
+
+	drm_ht_remove_item(ht, &tmp->item);
+
+	entry = container_of(ht, struct psb_gtt_hash_entry, ht);
+	if (entry)
+		entry->count--;
+
+	return tmp;
+}
+
+static int psb_gtt_mm_remove_free_mem_mapping_locked(struct drm_open_hash *ht,
+					      u32 key,
+					      struct drm_mm_node **node)
+{
+	struct psb_gtt_mem_mapping *entry;
+
+	entry = psb_gtt_mm_remove_mem_mapping_locked(ht, key);
+	if (!entry) {
+		DRM_DEBUG("entry is NULL\n");
+		return -EINVAL;
+	}
+
+	*node = entry->node;
+
+	kfree(entry);
+	return 0;
+}
+
+static int psb_gtt_add_node(struct psb_gtt_mm *mm,
+			    u32 tgid,
+			    u32 key,
+			    struct drm_mm_node *node,
+			    struct psb_gtt_mem_mapping **entry)
+{
+	struct psb_gtt_hash_entry *hentry;
+	struct psb_gtt_mem_mapping *mapping;
+	int ret;
+
+	ret = psb_gtt_mm_alloc_insert_ht(mm, tgid, &hentry);
+	if (ret) {
+		DRM_DEBUG("alloc_insert failed\n");
+		return ret;
+	}
+
+	ret = psb_gtt_mm_alloc_insert_mem_mapping(mm,
+						  &hentry->ht,
+						  key,
+						  node,
+						  &mapping);
+	if (ret) {
+		DRM_DEBUG("mapping alloc_insert failed\n");
+		return ret;
+	}
+
+	*entry = mapping;
+
+	return 0;
+}
+
+static int psb_gtt_remove_node(struct psb_gtt_mm *mm,
+			       u32 tgid,
+			       u32 key,
+			       struct drm_mm_node **node)
+{
+	struct psb_gtt_hash_entry *hentry;
+	struct drm_mm_node *tmp;
+	int ret;
+
+	spin_lock(&mm->lock);
+	ret = psb_gtt_mm_get_ht_by_pid_locked(mm, tgid, &hentry);
+	if (ret) {
+		DRM_DEBUG("Cannot find entry for pid %ld\n", tgid);
+		spin_unlock(&mm->lock);
+		return ret;
+	}
+	spin_unlock(&mm->lock);
+
+	/*remove mapping entry*/
+	spin_lock(&mm->lock);
+	ret = psb_gtt_mm_remove_free_mem_mapping_locked(&hentry->ht,
+							key,
+							&tmp);
+	if (ret) {
+		DRM_DEBUG("remove_free failed\n");
+		spin_unlock(&mm->lock);
+		return ret;
+	}
+
+	*node = tmp;
+
+	/*check the count of mapping entry*/
+	if (!hentry->count) {
+		DRM_DEBUG("count of mapping entry is zero, tgid=%ld\n", tgid);
+		psb_gtt_mm_remove_free_ht_locked(mm, tgid);
+	}
+
+	spin_unlock(&mm->lock);
+
+	return 0;
+}
+
+static int psb_gtt_mm_alloc_mem(struct psb_gtt_mm *mm,
+				uint32_t pages,
+				uint32_t align,
+				struct drm_mm_node **node)
+{
+	struct drm_mm_node *tmp_node;
+	int ret;
+
+	do {
+		ret = drm_mm_pre_get(&mm->base);
+		if (unlikely(ret)) {
+			DRM_DEBUG("drm_mm_pre_get error\n");
+			return ret;
+		}
+
+		spin_lock(&mm->lock);
+		tmp_node = drm_mm_search_free(&mm->base, pages, align, 1);
+		if (unlikely(!tmp_node)) {
+			DRM_DEBUG("No free node found\n");
+			spin_unlock(&mm->lock);
+			break;
+		}
+
+		tmp_node = drm_mm_get_block_atomic(tmp_node, pages, align);
+		spin_unlock(&mm->lock);
+	} while (!tmp_node);
+
+	if (!tmp_node) {
+		DRM_DEBUG("Node allocation failed\n");
+		return -ENOMEM;
+	}
+
+	*node = tmp_node;
+	return 0;
+}
+
+static void psb_gtt_mm_free_mem(struct psb_gtt_mm *mm, struct drm_mm_node *node)
+{
+	spin_lock(&mm->lock);
+	drm_mm_put_block(node);
+	spin_unlock(&mm->lock);
+}
+
+int psb_gtt_map_meminfo(struct drm_device *dev,
+			void *hKernelMemInfo,
+			uint32_t *offset)
+{
+	return -EINVAL;
+	/* FIXMEAC */
+#if 0
+	struct drm_psb_private *dev_priv
+	       = (struct drm_psb_private *)dev->dev_private;
+	void *psKernelMemInfo;
+	struct psb_gtt_mm *mm = dev_priv->gtt_mm;
+	struct psb_gtt *pg = dev_priv->pg;
+	uint32_t size, pages, offset_pages;
+	void *kmem;
+	struct drm_mm_node *node;
+	struct page **page_list;
+	struct psb_gtt_mem_mapping *mapping = NULL;
+	int ret;
+
+	ret = psb_get_meminfo_by_handle(hKernelMemInfo, &psKernelMemInfo);
+	if (ret) {
+		DRM_DEBUG("Cannot find kernelMemInfo handle %ld\n",
+			  hKernelMemInfo);
+		return -EINVAL;
+	}
+
+	DRM_DEBUG("Got psKernelMemInfo %p for handle %lx\n",
+		  psKernelMemInfo, (u32)hKernelMemInfo);
+	size = psKernelMemInfo->ui32AllocSize;
+	kmem = psKernelMemInfo->pvLinAddrKM;
+	pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+
+	DRM_DEBUG("KerMemInfo size %ld, cpuVadr %lx, pages %ld, osMemHdl %lx\n",
+		  size, kmem, pages, psKernelMemInfo->sMemBlk.hOSMemHandle);
+
+	if (!kmem)
+		DRM_DEBUG("kmem is NULL");
+
+	/*get pages*/
+	ret = psb_get_pages_by_mem_handle(psKernelMemInfo->sMemBlk.hOSMemHandle,
+					  &page_list);
+	if (ret) {
+		DRM_DEBUG("get pages error\n");
+		return ret;
+	}
+
+	DRM_DEBUG("get %ld pages\n", pages);
+
+	/*alloc memory in TT apeture*/
+	ret = psb_gtt_mm_alloc_mem(mm, pages, 0, &node);
+	if (ret) {
+		DRM_DEBUG("alloc TT memory error\n");
+		goto failed_pages_alloc;
+	}
+
+	/*update psb_gtt_mm*/
+	ret = psb_gtt_add_node(mm,
+			       task_tgid_nr(current),
+			       (u32)hKernelMemInfo,
+			       node,
+			       &mapping);
+	if (ret) {
+		DRM_DEBUG("add_node failed");
+		goto failed_add_node;
+	}
+
+	node = mapping->node;
+	offset_pages = node->start;
+
+	DRM_DEBUG("get free node for %ld pages, offset %ld pages",
+		  pages, offset_pages);
+
+	/*update gtt*/
+	psb_gtt_insert_pages(pg, page_list,
+			     (unsigned)offset_pages,
+			     (unsigned)pages,
+			     0,
+			     0,
+			     0);
+
+	*offset = offset_pages;
+	return 0;
+
+failed_add_node:
+	psb_gtt_mm_free_mem(mm, node);
+failed_pages_alloc:
+	kfree(page_list);
+	return ret;
+#endif
+}
+
+int psb_gtt_unmap_meminfo(struct drm_device *dev, void * hKernelMemInfo)
+{
+	struct drm_psb_private *dev_priv
+	       = (struct drm_psb_private *)dev->dev_private;
+	struct psb_gtt_mm *mm = dev_priv->gtt_mm;
+	struct psb_gtt *pg = dev_priv->pg;
+	uint32_t pages, offset_pages;
+	struct drm_mm_node *node;
+	int ret;
+
+	ret = psb_gtt_remove_node(mm,
+			task_tgid_nr(current),
+			(u32)hKernelMemInfo,
+			&node);
+	if (ret) {
+		DRM_DEBUG("remove node failed\n");
+		return ret;
+	}
+
+	/*remove gtt entries*/
+	offset_pages = node->start;
+	pages = node->size;
+
+	psb_gtt_remove_pages(pg, offset_pages, pages, 0, 0, 1);
+
+
+	/*free tt node*/
+
+	psb_gtt_mm_free_mem(mm, node);
+	return 0;
+}
+
+int psb_gtt_map_meminfo_ioctl(struct drm_device *dev, void *data,
+			       struct drm_file *file_priv)
+{
+	struct psb_gtt_mapping_arg *arg
+	       = (struct psb_gtt_mapping_arg *)data;
+	uint32_t *offset_pages = &arg->offset_pages;
+
+	DRM_DEBUG("\n");
+
+	return psb_gtt_map_meminfo(dev, arg->hKernelMemInfo, offset_pages);
+}
+
+int psb_gtt_unmap_meminfo_ioctl(struct drm_device *dev, void *data,
+				struct drm_file *file_priv)
+{
+
+	struct psb_gtt_mapping_arg *arg
+	       = (struct psb_gtt_mapping_arg *)data;
+
+	DRM_DEBUG("\n");
+
+	return psb_gtt_unmap_meminfo(dev, arg->hKernelMemInfo);
+}
+
+int psb_gtt_map_pvr_memory(struct drm_device *dev,  unsigned int hHandle,
+			unsigned int ui32TaskId, dma_addr_t *pPages,
+			unsigned int ui32PagesNum, unsigned int *ui32Offset)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_gtt_mm *mm = dev_priv->gtt_mm;
+	struct psb_gtt *pg = dev_priv->pg;
+	uint32_t size, pages, offset_pages;
+	struct drm_mm_node *node = NULL;
+	struct psb_gtt_mem_mapping *mapping = NULL;
+	int ret;
+
+	size = ui32PagesNum * PAGE_SIZE;
+	pages = 0;
+
+	/*alloc memory in TT apeture*/
+	ret = psb_gtt_mm_alloc_mem(mm, ui32PagesNum, 0, &node);
+	if (ret) {
+		DRM_DEBUG("alloc TT memory error\n");
+		goto failed_pages_alloc;
+	}
+
+   /*update psb_gtt_mm*/
+	ret = psb_gtt_add_node(mm,
+						   (u32)ui32TaskId,
+						   (u32)hHandle,
+						   node,
+						   &mapping);
+	if (ret) {
+		DRM_DEBUG("add_node failed");
+		goto failed_add_node;
+	}
+
+	node = mapping->node;
+	offset_pages = node->start;
+
+	DRM_DEBUG("get free node for %ld pages, offset %ld pages",
+							pages, offset_pages);
+
+	/*update gtt*/
+	psb_gtt_insert_phys_addresses(pg, pPages, (unsigned)offset_pages,
+						(unsigned)ui32PagesNum, 0);
+
+	*ui32Offset = offset_pages;
+	return 0;
+
+failed_add_node:
+	psb_gtt_mm_free_mem(mm, node);
+failed_pages_alloc:
+	return ret;
+}
+
+
+int psb_gtt_unmap_pvr_memory(struct drm_device *dev, unsigned int hHandle,
+						unsigned int ui32TaskId)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_gtt_mm *mm = dev_priv->gtt_mm;
+	struct psb_gtt *pg = dev_priv->pg;
+	uint32_t pages, offset_pages;
+	struct drm_mm_node *node;
+	int ret;
+
+	ret = psb_gtt_remove_node(mm, (u32)ui32TaskId, (u32)hHandle, &node);
+	if (ret) {
+		printk(KERN_ERR "remove node failed\n");
+		return ret;
+	}
+
+	/*remove gtt entries*/
+	offset_pages = node->start;
+	pages = node->size;
+
+	psb_gtt_remove_pages(pg, offset_pages, pages, 0, 0, 1);
+
+	/*free tt node*/
+	psb_gtt_mm_free_mem(mm, node);
+	return 0;
+}
diff --git a/drivers/staging/gma500/psb_gtt.h b/drivers/staging/gma500/psb_gtt.h
new file mode 100644
index 0000000..3544b4d
--- /dev/null
+++ b/drivers/staging/gma500/psb_gtt.h
@@ -0,0 +1,105 @@
+/**************************************************************************
+ * Copyright (c) 2007-2008, Intel Corporation.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+
+#ifndef _PSB_GTT_H_
+#define _PSB_GTT_H_
+
+#include <drm/drmP.h>
+
+/*#include "img_types.h"*/
+
+struct psb_gtt {
+	struct drm_device *dev;
+	int initialized;
+	uint32_t gatt_start;
+	uint32_t mmu_gatt_start;
+	uint32_t ci_start;
+	uint32_t rar_start;
+	uint32_t gtt_start;
+	uint32_t gtt_phys_start;
+	unsigned gtt_pages;
+	unsigned gatt_pages;
+	uint32_t stolen_base;
+	void *vram_addr;
+	uint32_t pge_ctl;
+	u16 gmch_ctrl;
+	unsigned long stolen_size;
+	unsigned long vram_stolen_size;
+	unsigned long ci_stolen_size;
+	unsigned long rar_stolen_size;
+	uint32_t *gtt_map;
+	struct rw_semaphore sem;
+};
+
+struct psb_gtt_mm {
+	struct drm_mm base;
+	struct drm_open_hash hash;
+	uint32_t count;
+	spinlock_t lock;
+};
+
+struct psb_gtt_hash_entry {
+	struct drm_open_hash ht;
+	uint32_t count;
+	struct drm_hash_item item;
+};
+
+struct psb_gtt_mem_mapping {
+	struct drm_mm_node *node;
+	struct drm_hash_item item;
+};
+
+/*Exported functions*/
+extern int psb_gtt_init(struct psb_gtt *pg, int resume);
+extern int psb_gtt_insert_pages(struct psb_gtt *pg, struct page **pages,
+				unsigned offset_pages, unsigned num_pages,
+				unsigned desired_tile_stride,
+				unsigned hw_tile_stride, int type);
+extern int psb_gtt_remove_pages(struct psb_gtt *pg, unsigned offset_pages,
+				unsigned num_pages,
+				unsigned desired_tile_stride,
+				unsigned hw_tile_stride,
+				int rc_prot);
+
+extern struct psb_gtt *psb_gtt_alloc(struct drm_device *dev);
+extern void psb_gtt_takedown(struct psb_gtt *pg, int free);
+extern int psb_gtt_map_meminfo(struct drm_device *dev,
+				void * hKernelMemInfo,
+				uint32_t *offset);
+extern int psb_gtt_unmap_meminfo(struct drm_device *dev,
+				 void * hKernelMemInfo);
+extern int psb_gtt_map_meminfo_ioctl(struct drm_device *dev, void *data,
+				     struct drm_file *file_priv);
+extern int psb_gtt_unmap_meminfo_ioctl(struct drm_device *dev, void *data,
+				       struct drm_file *file_priv);
+extern int psb_gtt_mm_init(struct psb_gtt *pg);
+extern void psb_gtt_mm_takedown(void);
+
+extern int psb_gtt_map_pvr_memory(struct drm_device *dev,
+                                                                  unsigned int hHandle,
+                                                                  unsigned int ui32TaskId,
+                                                                  dma_addr_t *pPages,
+                                                                  unsigned int ui32PagesNum,
+                                                                  unsigned int *ui32Offset);
+
+extern int psb_gtt_unmap_pvr_memory(struct drm_device *dev,
+                                                                        unsigned int hHandle,
+                                                                        unsigned int ui32TaskId);
+
+#endif
diff --git a/drivers/staging/gma500/psb_intel_bios.c b/drivers/staging/gma500/psb_intel_bios.c
new file mode 100644
index 0000000..83d8e93
--- /dev/null
+++ b/drivers/staging/gma500/psb_intel_bios.c
@@ -0,0 +1,301 @@
+/*
+ * Copyright (c) 2006 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors:
+ *    Eric Anholt <eric@anholt.net>
+ *
+ */
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include "psb_drm.h"
+#include "psb_drv.h"
+#include "psb_intel_drv.h"
+#include "psb_intel_reg.h"
+#include "psb_intel_bios.h"
+
+
+static void *find_section(struct bdb_header *bdb, int section_id)
+{
+	u8 *base = (u8 *)bdb;
+	int index = 0;
+	u16 total, current_size;
+	u8 current_id;
+
+	/* skip to first section */
+	index += bdb->header_size;
+	total = bdb->bdb_size;
+
+	/* walk the sections looking for section_id */
+	while (index < total) {
+		current_id = *(base + index);
+		index++;
+		current_size = *((u16 *)(base + index));
+		index += 2;
+		if (current_id == section_id)
+			return base + index;
+		index += current_size;
+	}
+
+	return NULL;
+}
+
+static void fill_detail_timing_data(struct drm_display_mode *panel_fixed_mode,
+			struct lvds_dvo_timing *dvo_timing)
+{
+	panel_fixed_mode->hdisplay = (dvo_timing->hactive_hi << 8) |
+		dvo_timing->hactive_lo;
+	panel_fixed_mode->hsync_start = panel_fixed_mode->hdisplay +
+		((dvo_timing->hsync_off_hi << 8) | dvo_timing->hsync_off_lo);
+	panel_fixed_mode->hsync_end = panel_fixed_mode->hsync_start +
+		dvo_timing->hsync_pulse_width;
+	panel_fixed_mode->htotal = panel_fixed_mode->hdisplay +
+		((dvo_timing->hblank_hi << 8) | dvo_timing->hblank_lo);
+
+	panel_fixed_mode->vdisplay = (dvo_timing->vactive_hi << 8) |
+		dvo_timing->vactive_lo;
+	panel_fixed_mode->vsync_start = panel_fixed_mode->vdisplay +
+		dvo_timing->vsync_off;
+	panel_fixed_mode->vsync_end = panel_fixed_mode->vsync_start +
+		dvo_timing->vsync_pulse_width;
+	panel_fixed_mode->vtotal = panel_fixed_mode->vdisplay +
+		((dvo_timing->vblank_hi << 8) | dvo_timing->vblank_lo);
+	panel_fixed_mode->clock = dvo_timing->clock * 10;
+	panel_fixed_mode->type = DRM_MODE_TYPE_PREFERRED;
+
+	/* Some VBTs have bogus h/vtotal values */
+	if (panel_fixed_mode->hsync_end > panel_fixed_mode->htotal)
+		panel_fixed_mode->htotal = panel_fixed_mode->hsync_end + 1;
+	if (panel_fixed_mode->vsync_end > panel_fixed_mode->vtotal)
+		panel_fixed_mode->vtotal = panel_fixed_mode->vsync_end + 1;
+
+	drm_mode_set_name(panel_fixed_mode);
+}
+
+static void parse_backlight_data(struct drm_psb_private *dev_priv,
+				struct bdb_header *bdb)
+{
+	struct bdb_lvds_backlight *vbt_lvds_bl = NULL;
+	struct bdb_lvds_backlight *lvds_bl;
+	u8 p_type = 0;
+	void *bl_start = NULL;
+	struct bdb_lvds_options *lvds_opts
+				= find_section(bdb, BDB_LVDS_OPTIONS);
+
+	dev_priv->lvds_bl = NULL;
+
+	if (lvds_opts) {
+		DRM_DEBUG("lvds_options found at %p\n", lvds_opts);
+		p_type = lvds_opts->panel_type;
+	} else {
+		DRM_DEBUG("no lvds_options\n");
+		return;
+	}
+
+	bl_start = find_section(bdb, BDB_LVDS_BACKLIGHT);
+	vbt_lvds_bl = (struct bdb_lvds_backlight *)(bl_start + 1) + p_type;
+
+	lvds_bl = kzalloc(sizeof(*vbt_lvds_bl), GFP_KERNEL);
+	if (!lvds_bl) {
+		DRM_DEBUG("No memory\n");
+		return;
+	}
+
+	memcpy(lvds_bl, vbt_lvds_bl, sizeof(*vbt_lvds_bl));
+
+	dev_priv->lvds_bl = lvds_bl;
+}
+
+/* Try to find integrated panel data */
+static void parse_lfp_panel_data(struct drm_psb_private *dev_priv,
+			    struct bdb_header *bdb)
+{
+	struct bdb_lvds_options *lvds_options;
+	struct bdb_lvds_lfp_data *lvds_lfp_data;
+	struct bdb_lvds_lfp_data_entry *entry;
+	struct lvds_dvo_timing *dvo_timing;
+	struct drm_display_mode *panel_fixed_mode;
+
+	/* Defaults if we can't find VBT info */
+	dev_priv->lvds_dither = 0;
+	dev_priv->lvds_vbt = 0;
+
+	lvds_options = find_section(bdb, BDB_LVDS_OPTIONS);
+	if (!lvds_options)
+		return;
+
+	dev_priv->lvds_dither = lvds_options->pixel_dither;
+	if (lvds_options->panel_type == 0xff)
+		return;
+
+	lvds_lfp_data = find_section(bdb, BDB_LVDS_LFP_DATA);
+	if (!lvds_lfp_data)
+		return;
+
+	dev_priv->lvds_vbt = 1;
+
+	entry = &lvds_lfp_data->data[lvds_options->panel_type];
+	dvo_timing = &entry->dvo_timing;
+
+	panel_fixed_mode = kzalloc(sizeof(*panel_fixed_mode),
+				      GFP_KERNEL);
+
+	fill_detail_timing_data(panel_fixed_mode, dvo_timing);
+
+	dev_priv->lfp_lvds_vbt_mode = panel_fixed_mode;
+
+	DRM_DEBUG("Found panel mode in BIOS VBT tables:\n");
+	drm_mode_debug_printmodeline(panel_fixed_mode);
+
+	return;
+}
+
+/* Try to find sdvo panel data */
+static void parse_sdvo_panel_data(struct drm_psb_private *dev_priv,
+		      struct bdb_header *bdb)
+{
+	struct bdb_sdvo_lvds_options *sdvo_lvds_options;
+	struct lvds_dvo_timing *dvo_timing;
+	struct drm_display_mode *panel_fixed_mode;
+
+	dev_priv->sdvo_lvds_vbt_mode = NULL;
+
+	sdvo_lvds_options = find_section(bdb, BDB_SDVO_LVDS_OPTIONS);
+	if (!sdvo_lvds_options)
+		return;
+
+	dvo_timing = find_section(bdb, BDB_SDVO_PANEL_DTDS);
+	if (!dvo_timing)
+		return;
+
+	panel_fixed_mode = kzalloc(sizeof(*panel_fixed_mode), GFP_KERNEL);
+
+	if (!panel_fixed_mode)
+		return;
+
+	fill_detail_timing_data(panel_fixed_mode,
+			dvo_timing + sdvo_lvds_options->panel_type);
+
+	dev_priv->sdvo_lvds_vbt_mode = panel_fixed_mode;
+
+	return;
+}
+
+static void parse_general_features(struct drm_psb_private *dev_priv,
+		       struct bdb_header *bdb)
+{
+	struct bdb_general_features *general;
+
+	/* Set sensible defaults in case we can't find the general block */
+	dev_priv->int_tv_support = 1;
+	dev_priv->int_crt_support = 1;
+
+	general = find_section(bdb, BDB_GENERAL_FEATURES);
+	if (general) {
+		dev_priv->int_tv_support = general->int_tv_support;
+		dev_priv->int_crt_support = general->int_crt_support;
+		dev_priv->lvds_use_ssc = general->enable_ssc;
+
+		if (dev_priv->lvds_use_ssc) {
+			dev_priv->lvds_ssc_freq
+				= general->ssc_freq ? 100 : 96;
+		}
+	}
+}
+
+/**
+ * psb_intel_init_bios - initialize VBIOS settings & find VBT
+ * @dev: DRM device
+ *
+ * Loads the Video BIOS and checks that the VBT exists.  Sets scratch registers
+ * to appropriate values.
+ *
+ * VBT existence is a sanity check that is relied on by other i830_bios.c code.
+ * Note that it would be better to use a BIOS call to get the VBT, as BIOSes may
+ * feed an updated VBT back through that, compared to what we'll fetch using
+ * this method of groping around in the BIOS data.
+ *
+ * Returns 0 on success, nonzero on failure.
+ */
+bool psb_intel_init_bios(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct pci_dev *pdev = dev->pdev;
+	struct vbt_header *vbt = NULL;
+	struct bdb_header *bdb;
+	u8 __iomem *bios;
+	size_t size;
+	int i;
+
+	bios = pci_map_rom(pdev, &size);
+	if (!bios)
+		return -1;
+
+	/* Scour memory looking for the VBT signature */
+	for (i = 0; i + 4 < size; i++) {
+		if (!memcmp(bios + i, "$VBT", 4)) {
+			vbt = (struct vbt_header *)(bios + i);
+			break;
+		}
+	}
+
+	if (!vbt) {
+		DRM_ERROR("VBT signature missing\n");
+		pci_unmap_rom(pdev, bios);
+		return -1;
+	}
+
+	bdb = (struct bdb_header *)(bios + i + vbt->bdb_offset);
+
+	/* Grab useful general definitions */
+	parse_general_features(dev_priv, bdb);
+	parse_lfp_panel_data(dev_priv, bdb);
+	parse_sdvo_panel_data(dev_priv, bdb);
+	parse_backlight_data(dev_priv, bdb);
+
+	pci_unmap_rom(pdev, bios);
+
+	return 0;
+}
+
+/**
+ * Destory and free VBT data
+ */
+void psb_intel_destory_bios(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct drm_display_mode *sdvo_lvds_vbt_mode =
+				dev_priv->sdvo_lvds_vbt_mode;
+	struct drm_display_mode *lfp_lvds_vbt_mode =
+				dev_priv->lfp_lvds_vbt_mode;
+	struct bdb_lvds_backlight *lvds_bl =
+				dev_priv->lvds_bl;
+
+	/*free sdvo panel mode*/
+	if (sdvo_lvds_vbt_mode) {
+		dev_priv->sdvo_lvds_vbt_mode = NULL;
+		kfree(sdvo_lvds_vbt_mode);
+	}
+
+	if (lfp_lvds_vbt_mode) {
+		dev_priv->lfp_lvds_vbt_mode = NULL;
+		kfree(lfp_lvds_vbt_mode);
+	}
+
+	if (lvds_bl) {
+		dev_priv->lvds_bl = NULL;
+		kfree(lvds_bl);
+	}
+}
diff --git a/drivers/staging/gma500/psb_intel_bios.h b/drivers/staging/gma500/psb_intel_bios.h
new file mode 100644
index 0000000..dfcae62
--- /dev/null
+++ b/drivers/staging/gma500/psb_intel_bios.h
@@ -0,0 +1,430 @@
+/*
+ * Copyright (c) 2006 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors:
+ *    Eric Anholt <eric@anholt.net>
+ *
+ */
+
+#ifndef _I830_BIOS_H_
+#define _I830_BIOS_H_
+
+#include <drm/drmP.h>
+
+struct vbt_header {
+	u8 signature[20];		/**< Always starts with 'VBT$' */
+	u16 version;			/**< decimal */
+	u16 header_size;		/**< in bytes */
+	u16 vbt_size;			/**< in bytes */
+	u8 vbt_checksum;
+	u8 reserved0;
+	u32 bdb_offset;			/**< from beginning of VBT */
+	u32 aim_offset[4];		/**< from beginning of VBT */
+} __attribute__((packed));
+
+
+struct bdb_header {
+	u8 signature[16];		/**< Always 'BIOS_DATA_BLOCK' */
+	u16 version;			/**< decimal */
+	u16 header_size;		/**< in bytes */
+	u16 bdb_size;			/**< in bytes */
+};
+
+/* strictly speaking, this is a "skip" block, but it has interesting info */
+struct vbios_data {
+	u8 type; /* 0 == desktop, 1 == mobile */
+	u8 relstage;
+	u8 chipset;
+	u8 lvds_present:1;
+	u8 tv_present:1;
+	u8 rsvd2:6; /* finish byte */
+	u8 rsvd3[4];
+	u8 signon[155];
+	u8 copyright[61];
+	u16 code_segment;
+	u8 dos_boot_mode;
+	u8 bandwidth_percent;
+	u8 rsvd4; /* popup memory size */
+	u8 resize_pci_bios;
+	u8 rsvd5; /* is crt already on ddc2 */
+} __attribute__((packed));
+
+/*
+ * There are several types of BIOS data blocks (BDBs), each block has
+ * an ID and size in the first 3 bytes (ID in first, size in next 2).
+ * Known types are listed below.
+ */
+#define BDB_GENERAL_FEATURES	  1
+#define BDB_GENERAL_DEFINITIONS	  2
+#define BDB_OLD_TOGGLE_LIST	  3
+#define BDB_MODE_SUPPORT_LIST	  4
+#define BDB_GENERIC_MODE_TABLE	  5
+#define BDB_EXT_MMIO_REGS	  6
+#define BDB_SWF_IO		  7
+#define BDB_SWF_MMIO		  8
+#define BDB_DOT_CLOCK_TABLE	  9
+#define BDB_MODE_REMOVAL_TABLE	 10
+#define BDB_CHILD_DEVICE_TABLE	 11
+#define BDB_DRIVER_FEATURES	 12
+#define BDB_DRIVER_PERSISTENCE	 13
+#define BDB_EXT_TABLE_PTRS	 14
+#define BDB_DOT_CLOCK_OVERRIDE	 15
+#define BDB_DISPLAY_SELECT	 16
+/* 17 rsvd */
+#define BDB_DRIVER_ROTATION	 18
+#define BDB_DISPLAY_REMOVE	 19
+#define BDB_OEM_CUSTOM		 20
+#define BDB_EFP_LIST		 21 /* workarounds for VGA hsync/vsync */
+#define BDB_SDVO_LVDS_OPTIONS	 22
+#define BDB_SDVO_PANEL_DTDS	 23
+#define BDB_SDVO_LVDS_PNP_IDS	 24
+#define BDB_SDVO_LVDS_POWER_SEQ	 25
+#define BDB_TV_OPTIONS		 26
+#define BDB_LVDS_OPTIONS	 40
+#define BDB_LVDS_LFP_DATA_PTRS	 41
+#define BDB_LVDS_LFP_DATA	 42
+#define BDB_LVDS_BACKLIGHT	 43
+#define BDB_LVDS_POWER		 44
+#define BDB_SKIP		254 /* VBIOS private block, ignore */
+
+struct bdb_general_features {
+	/* bits 1 */
+	u8 panel_fitting:2;
+	u8 flexaim:1;
+	u8 msg_enable:1;
+	u8 clear_screen:3;
+	u8 color_flip:1;
+
+	/* bits 2 */
+	u8 download_ext_vbt:1;
+	u8 enable_ssc:1;
+	u8 ssc_freq:1;
+	u8 enable_lfp_on_override:1;
+	u8 disable_ssc_ddt:1;
+	u8 rsvd8:3; /* finish byte */
+
+	/* bits 3 */
+	u8 disable_smooth_vision:1;
+	u8 single_dvi:1;
+	u8 rsvd9:6; /* finish byte */
+
+	/* bits 4 */
+	u8 legacy_monitor_detect;
+
+	/* bits 5 */
+	u8 int_crt_support:1;
+	u8 int_tv_support:1;
+	u8 rsvd11:6; /* finish byte */
+} __attribute__((packed));
+
+struct bdb_general_definitions {
+	/* DDC GPIO */
+	u8 crt_ddc_gmbus_pin;
+
+	/* DPMS bits */
+	u8 dpms_acpi:1;
+	u8 skip_boot_crt_detect:1;
+	u8 dpms_aim:1;
+	u8 rsvd1:5; /* finish byte */
+
+	/* boot device bits */
+	u8 boot_display[2];
+	u8 child_dev_size;
+
+	/* device info */
+	u8 tv_or_lvds_info[33];
+	u8 dev1[33];
+	u8 dev2[33];
+	u8 dev3[33];
+	u8 dev4[33];
+	/* may be another device block here on some platforms */
+};
+
+struct bdb_lvds_options {
+	u8 panel_type;
+	u8 rsvd1;
+	/* LVDS capabilities, stored in a dword */
+	u8 pfit_mode:2;
+	u8 pfit_text_mode_enhanced:1;
+	u8 pfit_gfx_mode_enhanced:1;
+	u8 pfit_ratio_auto:1;
+	u8 pixel_dither:1;
+	u8 lvds_edid:1;
+	u8 rsvd2:1;
+	u8 rsvd4;
+} __attribute__((packed));
+
+struct bdb_lvds_backlight {
+	u8 type:2;
+	u8 pol:1;
+	u8 gpio:3;
+	u8 gmbus:2;
+	u16 freq;
+	u8 minbrightness;
+	u8 i2caddr;
+	u8 brightnesscmd;
+	/*FIXME: more...*/
+} __attribute__((packed));
+
+/* LFP pointer table contains entries to the struct below */
+struct bdb_lvds_lfp_data_ptr {
+	u16 fp_timing_offset; /* offsets are from start of bdb */
+	u8 fp_table_size;
+	u16 dvo_timing_offset;
+	u8 dvo_table_size;
+	u16 panel_pnp_id_offset;
+	u8 pnp_table_size;
+} __attribute__((packed));
+
+struct bdb_lvds_lfp_data_ptrs {
+	u8 lvds_entries; /* followed by one or more lvds_data_ptr structs */
+	struct bdb_lvds_lfp_data_ptr ptr[16];
+} __attribute__((packed));
+
+/* LFP data has 3 blocks per entry */
+struct lvds_fp_timing {
+	u16 x_res;
+	u16 y_res;
+	u32 lvds_reg;
+	u32 lvds_reg_val;
+	u32 pp_on_reg;
+	u32 pp_on_reg_val;
+	u32 pp_off_reg;
+	u32 pp_off_reg_val;
+	u32 pp_cycle_reg;
+	u32 pp_cycle_reg_val;
+	u32 pfit_reg;
+	u32 pfit_reg_val;
+	u16 terminator;
+} __attribute__((packed));
+
+struct lvds_dvo_timing {
+	u16 clock;		/**< In 10khz */
+	u8 hactive_lo;
+	u8 hblank_lo;
+	u8 hblank_hi:4;
+	u8 hactive_hi:4;
+	u8 vactive_lo;
+	u8 vblank_lo;
+	u8 vblank_hi:4;
+	u8 vactive_hi:4;
+	u8 hsync_off_lo;
+	u8 hsync_pulse_width;
+	u8 vsync_pulse_width:4;
+	u8 vsync_off:4;
+	u8 rsvd0:6;
+	u8 hsync_off_hi:2;
+	u8 h_image;
+	u8 v_image;
+	u8 max_hv;
+	u8 h_border;
+	u8 v_border;
+	u8 rsvd1:3;
+	u8 digital:2;
+	u8 vsync_positive:1;
+	u8 hsync_positive:1;
+	u8 rsvd2:1;
+} __attribute__((packed));
+
+struct lvds_pnp_id {
+	u16 mfg_name;
+	u16 product_code;
+	u32 serial;
+	u8 mfg_week;
+	u8 mfg_year;
+} __attribute__((packed));
+
+struct bdb_lvds_lfp_data_entry {
+	struct lvds_fp_timing fp_timing;
+	struct lvds_dvo_timing dvo_timing;
+	struct lvds_pnp_id pnp_id;
+} __attribute__((packed));
+
+struct bdb_lvds_lfp_data {
+	struct bdb_lvds_lfp_data_entry data[16];
+} __attribute__((packed));
+
+struct aimdb_header {
+	char signature[16];
+	char oem_device[20];
+	u16 aimdb_version;
+	u16 aimdb_header_size;
+	u16 aimdb_size;
+} __attribute__((packed));
+
+struct aimdb_block {
+	u8 aimdb_id;
+	u16 aimdb_size;
+} __attribute__((packed));
+
+struct vch_panel_data {
+	u16 fp_timing_offset;
+	u8 fp_timing_size;
+	u16 dvo_timing_offset;
+	u8 dvo_timing_size;
+	u16 text_fitting_offset;
+	u8 text_fitting_size;
+	u16 graphics_fitting_offset;
+	u8 graphics_fitting_size;
+} __attribute__((packed));
+
+struct vch_bdb_22 {
+	struct aimdb_block aimdb_block;
+	struct vch_panel_data panels[16];
+} __attribute__((packed));
+
+struct bdb_sdvo_lvds_options {
+	u8 panel_backlight;
+	u8 h40_set_panel_type;
+	u8 panel_type;
+	u8 ssc_clk_freq;
+	u16 als_low_trip;
+	u16 als_high_trip;
+	u8 sclalarcoeff_tab_row_num;
+	u8 sclalarcoeff_tab_row_size;
+	u8 coefficient[8];
+	u8 panel_misc_bits_1;
+	u8 panel_misc_bits_2;
+	u8 panel_misc_bits_3;
+	u8 panel_misc_bits_4;
+} __attribute__((packed));
+
+
+extern bool psb_intel_init_bios(struct drm_device *dev);
+extern void psb_intel_destory_bios(struct drm_device *dev);
+
+/*
+ * Driver<->VBIOS interaction occurs through scratch bits in
+ * GR18 & SWF*.
+ */
+
+/* GR18 bits are set on display switch and hotkey events */
+#define GR18_DRIVER_SWITCH_EN	(1<<7) /* 0: VBIOS control, 1: driver control */
+#define GR18_HOTKEY_MASK	0x78 /* See also SWF4 15:0 */
+#define   GR18_HK_NONE		(0x0<<3)
+#define   GR18_HK_LFP_STRETCH	(0x1<<3)
+#define   GR18_HK_TOGGLE_DISP	(0x2<<3)
+#define   GR18_HK_DISP_SWITCH	(0x4<<3) /* see SWF14 15:0 for what to enable */
+#define   GR18_HK_POPUP_DISABLED (0x6<<3)
+#define   GR18_HK_POPUP_ENABLED	(0x7<<3)
+#define   GR18_HK_PFIT		(0x8<<3)
+#define   GR18_HK_APM_CHANGE	(0xa<<3)
+#define   GR18_HK_MULTIPLE	(0xc<<3)
+#define GR18_USER_INT_EN	(1<<2)
+#define GR18_A0000_FLUSH_EN	(1<<1)
+#define GR18_SMM_EN		(1<<0)
+
+/* Set by driver, cleared by VBIOS */
+#define SWF00_YRES_SHIFT	16
+#define SWF00_XRES_SHIFT	0
+#define SWF00_RES_MASK		0xffff
+
+/* Set by VBIOS at boot time and driver at runtime */
+#define SWF01_TV2_FORMAT_SHIFT	8
+#define SWF01_TV1_FORMAT_SHIFT	0
+#define SWF01_TV_FORMAT_MASK	0xffff
+
+#define SWF10_VBIOS_BLC_I2C_EN	(1<<29)
+#define SWF10_GTT_OVERRIDE_EN	(1<<28)
+#define SWF10_LFP_DPMS_OVR	(1<<27) /* override DPMS on display switch */
+#define SWF10_ACTIVE_TOGGLE_LIST_MASK (7<<24)
+#define   SWF10_OLD_TOGGLE	0x0
+#define   SWF10_TOGGLE_LIST_1	0x1
+#define   SWF10_TOGGLE_LIST_2	0x2
+#define   SWF10_TOGGLE_LIST_3	0x3
+#define   SWF10_TOGGLE_LIST_4	0x4
+#define SWF10_PANNING_EN	(1<<23)
+#define SWF10_DRIVER_LOADED	(1<<22)
+#define SWF10_EXTENDED_DESKTOP	(1<<21)
+#define SWF10_EXCLUSIVE_MODE	(1<<20)
+#define SWF10_OVERLAY_EN	(1<<19)
+#define SWF10_PLANEB_HOLDOFF	(1<<18)
+#define SWF10_PLANEA_HOLDOFF	(1<<17)
+#define SWF10_VGA_HOLDOFF	(1<<16)
+#define SWF10_ACTIVE_DISP_MASK	0xffff
+#define   SWF10_PIPEB_LFP2	(1<<15)
+#define   SWF10_PIPEB_EFP2	(1<<14)
+#define   SWF10_PIPEB_TV2	(1<<13)
+#define   SWF10_PIPEB_CRT2	(1<<12)
+#define   SWF10_PIPEB_LFP	(1<<11)
+#define   SWF10_PIPEB_EFP	(1<<10)
+#define   SWF10_PIPEB_TV	(1<<9)
+#define   SWF10_PIPEB_CRT	(1<<8)
+#define   SWF10_PIPEA_LFP2	(1<<7)
+#define   SWF10_PIPEA_EFP2	(1<<6)
+#define   SWF10_PIPEA_TV2	(1<<5)
+#define   SWF10_PIPEA_CRT2	(1<<4)
+#define   SWF10_PIPEA_LFP	(1<<3)
+#define   SWF10_PIPEA_EFP	(1<<2)
+#define   SWF10_PIPEA_TV	(1<<1)
+#define   SWF10_PIPEA_CRT	(1<<0)
+
+#define SWF11_MEMORY_SIZE_SHIFT	16
+#define SWF11_SV_TEST_EN	(1<<15)
+#define SWF11_IS_AGP		(1<<14)
+#define SWF11_DISPLAY_HOLDOFF	(1<<13)
+#define SWF11_DPMS_REDUCED	(1<<12)
+#define SWF11_IS_VBE_MODE	(1<<11)
+#define SWF11_PIPEB_ACCESS	(1<<10) /* 0 here means pipe a */
+#define SWF11_DPMS_MASK		0x07
+#define   SWF11_DPMS_OFF	(1<<2)
+#define   SWF11_DPMS_SUSPEND	(1<<1)
+#define   SWF11_DPMS_STANDBY	(1<<0)
+#define   SWF11_DPMS_ON		0
+
+#define SWF14_GFX_PFIT_EN	(1<<31)
+#define SWF14_TEXT_PFIT_EN	(1<<30)
+#define SWF14_LID_STATUS_CLOSED	(1<<29) /* 0 here means open */
+#define SWF14_POPUP_EN		(1<<28)
+#define SWF14_DISPLAY_HOLDOFF	(1<<27)
+#define SWF14_DISP_DETECT_EN	(1<<26)
+#define SWF14_DOCKING_STATUS_DOCKED (1<<25) /* 0 here means undocked */
+#define SWF14_DRIVER_STATUS	(1<<24)
+#define SWF14_OS_TYPE_WIN9X	(1<<23)
+#define SWF14_OS_TYPE_WINNT	(1<<22)
+/* 21:19 rsvd */
+#define SWF14_PM_TYPE_MASK	0x00070000
+#define   SWF14_PM_ACPI_VIDEO	(0x4 << 16)
+#define   SWF14_PM_ACPI		(0x3 << 16)
+#define   SWF14_PM_APM_12	(0x2 << 16)
+#define   SWF14_PM_APM_11	(0x1 << 16)
+#define SWF14_HK_REQUEST_MASK	0x0000ffff /* see GR18 6:3 for event type */
+	  /* if GR18 indicates a display switch */
+#define   SWF14_DS_PIPEB_LFP2_EN (1<<15)
+#define   SWF14_DS_PIPEB_EFP2_EN (1<<14)
+#define   SWF14_DS_PIPEB_TV2_EN  (1<<13)
+#define   SWF14_DS_PIPEB_CRT2_EN (1<<12)
+#define   SWF14_DS_PIPEB_LFP_EN  (1<<11)
+#define   SWF14_DS_PIPEB_EFP_EN  (1<<10)
+#define   SWF14_DS_PIPEB_TV_EN	 (1<<9)
+#define   SWF14_DS_PIPEB_CRT_EN  (1<<8)
+#define   SWF14_DS_PIPEA_LFP2_EN (1<<7)
+#define   SWF14_DS_PIPEA_EFP2_EN (1<<6)
+#define   SWF14_DS_PIPEA_TV2_EN  (1<<5)
+#define   SWF14_DS_PIPEA_CRT2_EN (1<<4)
+#define   SWF14_DS_PIPEA_LFP_EN  (1<<3)
+#define   SWF14_DS_PIPEA_EFP_EN  (1<<2)
+#define   SWF14_DS_PIPEA_TV_EN	 (1<<1)
+#define   SWF14_DS_PIPEA_CRT_EN  (1<<0)
+	  /* if GR18 indicates a panel fitting request */
+#define   SWF14_PFIT_EN		(1<<0) /* 0 means disable */
+	  /* if GR18 indicates an APM change request */
+#define   SWF14_APM_HIBERNATE	0x4
+#define   SWF14_APM_SUSPEND	0x3
+#define   SWF14_APM_STANDBY	0x1
+#define   SWF14_APM_RESTORE	0x0
+
+#endif /* _I830_BIOS_H_ */
diff --git a/drivers/staging/gma500/psb_intel_display.c b/drivers/staging/gma500/psb_intel_display.c
new file mode 100644
index 0000000..80b37f4
--- /dev/null
+++ b/drivers/staging/gma500/psb_intel_display.c
@@ -0,0 +1,1489 @@
+/*
+ * Copyright Â© 2006-2007 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors:
+ *	Eric Anholt <eric@anholt.net>
+ */
+
+#include <linux/i2c.h>
+#include <linux/pm_runtime.h>
+
+#include <drm/drmP.h>
+#include "psb_fb.h"
+#include "psb_drv.h"
+#include "psb_intel_drv.h"
+#include "psb_intel_reg.h"
+#include "psb_intel_display.h"
+#include "psb_powermgmt.h"
+
+
+struct psb_intel_clock_t {
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
+struct psb_intel_range_t {
+	int min, max;
+};
+
+struct psb_intel_p2_t {
+	int dot_limit;
+	int p2_slow, p2_fast;
+};
+
+#define INTEL_P2_NUM		      2
+
+struct psb_intel_limit_t {
+	struct psb_intel_range_t dot, vco, n, m, m1, m2, p, p1;
+	struct psb_intel_p2_t p2;
+};
+
+#define I8XX_DOT_MIN		  25000
+#define I8XX_DOT_MAX		 350000
+#define I8XX_VCO_MIN		 930000
+#define I8XX_VCO_MAX		1400000
+#define I8XX_N_MIN		      3
+#define I8XX_N_MAX		     16
+#define I8XX_M_MIN		     96
+#define I8XX_M_MAX		    140
+#define I8XX_M1_MIN		     18
+#define I8XX_M1_MAX		     26
+#define I8XX_M2_MIN		      6
+#define I8XX_M2_MAX		     16
+#define I8XX_P_MIN		      4
+#define I8XX_P_MAX		    128
+#define I8XX_P1_MIN		      2
+#define I8XX_P1_MAX		     33
+#define I8XX_P1_LVDS_MIN	      1
+#define I8XX_P1_LVDS_MAX	      6
+#define I8XX_P2_SLOW		      4
+#define I8XX_P2_FAST		      2
+#define I8XX_P2_LVDS_SLOW	      14
+#define I8XX_P2_LVDS_FAST	      14	/* No fast option */
+#define I8XX_P2_SLOW_LIMIT	 165000
+
+#define I9XX_DOT_MIN		  20000
+#define I9XX_DOT_MAX		 400000
+#define I9XX_VCO_MIN		1400000
+#define I9XX_VCO_MAX		2800000
+#define I9XX_N_MIN		      3
+#define I9XX_N_MAX		      8
+#define I9XX_M_MIN		     70
+#define I9XX_M_MAX		    120
+#define I9XX_M1_MIN		     10
+#define I9XX_M1_MAX		     20
+#define I9XX_M2_MIN		      5
+#define I9XX_M2_MAX		      9
+#define I9XX_P_SDVO_DAC_MIN	      5
+#define I9XX_P_SDVO_DAC_MAX	     80
+#define I9XX_P_LVDS_MIN		      7
+#define I9XX_P_LVDS_MAX		     98
+#define I9XX_P1_MIN		      1
+#define I9XX_P1_MAX		      8
+#define I9XX_P2_SDVO_DAC_SLOW		     10
+#define I9XX_P2_SDVO_DAC_FAST		      5
+#define I9XX_P2_SDVO_DAC_SLOW_LIMIT	 200000
+#define I9XX_P2_LVDS_SLOW		     14
+#define I9XX_P2_LVDS_FAST		      7
+#define I9XX_P2_LVDS_SLOW_LIMIT		 112000
+
+#define INTEL_LIMIT_I8XX_DVO_DAC    0
+#define INTEL_LIMIT_I8XX_LVDS	    1
+#define INTEL_LIMIT_I9XX_SDVO_DAC   2
+#define INTEL_LIMIT_I9XX_LVDS	    3
+
+static const struct psb_intel_limit_t psb_intel_limits[] = {
+	{			/* INTEL_LIMIT_I8XX_DVO_DAC */
+	 .dot = {.min = I8XX_DOT_MIN, .max = I8XX_DOT_MAX},
+	 .vco = {.min = I8XX_VCO_MIN, .max = I8XX_VCO_MAX},
+	 .n = {.min = I8XX_N_MIN, .max = I8XX_N_MAX},
+	 .m = {.min = I8XX_M_MIN, .max = I8XX_M_MAX},
+	 .m1 = {.min = I8XX_M1_MIN, .max = I8XX_M1_MAX},
+	 .m2 = {.min = I8XX_M2_MIN, .max = I8XX_M2_MAX},
+	 .p = {.min = I8XX_P_MIN, .max = I8XX_P_MAX},
+	 .p1 = {.min = I8XX_P1_MIN, .max = I8XX_P1_MAX},
+	 .p2 = {.dot_limit = I8XX_P2_SLOW_LIMIT,
+		.p2_slow = I8XX_P2_SLOW, .p2_fast = I8XX_P2_FAST},
+	 },
+	{			/* INTEL_LIMIT_I8XX_LVDS */
+	 .dot = {.min = I8XX_DOT_MIN, .max = I8XX_DOT_MAX},
+	 .vco = {.min = I8XX_VCO_MIN, .max = I8XX_VCO_MAX},
+	 .n = {.min = I8XX_N_MIN, .max = I8XX_N_MAX},
+	 .m = {.min = I8XX_M_MIN, .max = I8XX_M_MAX},
+	 .m1 = {.min = I8XX_M1_MIN, .max = I8XX_M1_MAX},
+	 .m2 = {.min = I8XX_M2_MIN, .max = I8XX_M2_MAX},
+	 .p = {.min = I8XX_P_MIN, .max = I8XX_P_MAX},
+	 .p1 = {.min = I8XX_P1_LVDS_MIN, .max = I8XX_P1_LVDS_MAX},
+	 .p2 = {.dot_limit = I8XX_P2_SLOW_LIMIT,
+		.p2_slow = I8XX_P2_LVDS_SLOW, .p2_fast = I8XX_P2_LVDS_FAST},
+	 },
+	{			/* INTEL_LIMIT_I9XX_SDVO_DAC */
+	 .dot = {.min = I9XX_DOT_MIN, .max = I9XX_DOT_MAX},
+	 .vco = {.min = I9XX_VCO_MIN, .max = I9XX_VCO_MAX},
+	 .n = {.min = I9XX_N_MIN, .max = I9XX_N_MAX},
+	 .m = {.min = I9XX_M_MIN, .max = I9XX_M_MAX},
+	 .m1 = {.min = I9XX_M1_MIN, .max = I9XX_M1_MAX},
+	 .m2 = {.min = I9XX_M2_MIN, .max = I9XX_M2_MAX},
+	 .p = {.min = I9XX_P_SDVO_DAC_MIN, .max = I9XX_P_SDVO_DAC_MAX},
+	 .p1 = {.min = I9XX_P1_MIN, .max = I9XX_P1_MAX},
+	 .p2 = {.dot_limit = I9XX_P2_SDVO_DAC_SLOW_LIMIT,
+		.p2_slow = I9XX_P2_SDVO_DAC_SLOW, .p2_fast =
+		I9XX_P2_SDVO_DAC_FAST},
+	 },
+	{			/* INTEL_LIMIT_I9XX_LVDS */
+	 .dot = {.min = I9XX_DOT_MIN, .max = I9XX_DOT_MAX},
+	 .vco = {.min = I9XX_VCO_MIN, .max = I9XX_VCO_MAX},
+	 .n = {.min = I9XX_N_MIN, .max = I9XX_N_MAX},
+	 .m = {.min = I9XX_M_MIN, .max = I9XX_M_MAX},
+	 .m1 = {.min = I9XX_M1_MIN, .max = I9XX_M1_MAX},
+	 .m2 = {.min = I9XX_M2_MIN, .max = I9XX_M2_MAX},
+	 .p = {.min = I9XX_P_LVDS_MIN, .max = I9XX_P_LVDS_MAX},
+	 .p1 = {.min = I9XX_P1_MIN, .max = I9XX_P1_MAX},
+	 /* The single-channel range is 25-112Mhz, and dual-channel
+	  * is 80-224Mhz.  Prefer single channel as much as possible.
+	  */
+	 .p2 = {.dot_limit = I9XX_P2_LVDS_SLOW_LIMIT,
+		.p2_slow = I9XX_P2_LVDS_SLOW, .p2_fast = I9XX_P2_LVDS_FAST},
+	 },
+};
+
+static const struct psb_intel_limit_t *psb_intel_limit(struct drm_crtc *crtc)
+{
+	const struct psb_intel_limit_t *limit;
+
+	if (psb_intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS))
+		limit = &psb_intel_limits[INTEL_LIMIT_I9XX_LVDS];
+	else
+		limit = &psb_intel_limits[INTEL_LIMIT_I9XX_SDVO_DAC];
+	return limit;
+}
+
+/** Derive the pixel clock for the given refclk and divisors for 8xx chips. */
+
+static void i8xx_clock(int refclk, struct psb_intel_clock_t *clock)
+{
+	clock->m = 5 * (clock->m1 + 2) + (clock->m2 + 2);
+	clock->p = clock->p1 * clock->p2;
+	clock->vco = refclk * clock->m / (clock->n + 2);
+	clock->dot = clock->vco / clock->p;
+}
+
+/** Derive the pixel clock for the given refclk and divisors for 9xx chips. */
+
+static void i9xx_clock(int refclk, struct psb_intel_clock_t *clock)
+{
+	clock->m = 5 * (clock->m1 + 2) + (clock->m2 + 2);
+	clock->p = clock->p1 * clock->p2;
+	clock->vco = refclk * clock->m / (clock->n + 2);
+	clock->dot = clock->vco / clock->p;
+}
+
+static void psb_intel_clock(struct drm_device *dev, int refclk,
+			struct psb_intel_clock_t *clock)
+{
+	return i9xx_clock(refclk, clock);
+}
+
+/**
+ * Returns whether any output on the specified pipe is of the specified type
+ */
+bool psb_intel_pipe_has_type(struct drm_crtc *crtc, int type)
+{
+	struct drm_device *dev = crtc->dev;
+	struct drm_mode_config *mode_config = &dev->mode_config;
+	struct drm_connector *l_entry;
+
+	list_for_each_entry(l_entry, &mode_config->connector_list, head) {
+		if (l_entry->encoder && l_entry->encoder->crtc == crtc) {
+			struct psb_intel_output *psb_intel_output =
+			    to_psb_intel_output(l_entry);
+			if (psb_intel_output->type == type)
+				return true;
+		}
+	}
+	return false;
+}
+
+#define INTELPllInvalid(s)   { /* ErrorF (s) */; return false; }
+/**
+ * Returns whether the given set of divisors are valid for a given refclk with
+ * the given connectors.
+ */
+
+static bool psb_intel_PLL_is_valid(struct drm_crtc *crtc,
+			       struct psb_intel_clock_t *clock)
+{
+	const struct psb_intel_limit_t *limit = psb_intel_limit(crtc);
+
+	if (clock->p1 < limit->p1.min || limit->p1.max < clock->p1)
+		INTELPllInvalid("p1 out of range\n");
+	if (clock->p < limit->p.min || limit->p.max < clock->p)
+		INTELPllInvalid("p out of range\n");
+	if (clock->m2 < limit->m2.min || limit->m2.max < clock->m2)
+		INTELPllInvalid("m2 out of range\n");
+	if (clock->m1 < limit->m1.min || limit->m1.max < clock->m1)
+		INTELPllInvalid("m1 out of range\n");
+	if (clock->m1 <= clock->m2)
+		INTELPllInvalid("m1 <= m2\n");
+	if (clock->m < limit->m.min || limit->m.max < clock->m)
+		INTELPllInvalid("m out of range\n");
+	if (clock->n < limit->n.min || limit->n.max < clock->n)
+		INTELPllInvalid("n out of range\n");
+	if (clock->vco < limit->vco.min || limit->vco.max < clock->vco)
+		INTELPllInvalid("vco out of range\n");
+	/* XXX: We may need to be checking "Dot clock"
+	 * depending on the multiplier, connector, etc.,
+	 * rather than just a single range.
+	 */
+	if (clock->dot < limit->dot.min || limit->dot.max < clock->dot)
+		INTELPllInvalid("dot out of range\n");
+
+	return true;
+}
+
+/**
+ * Returns a set of divisors for the desired target clock with the given
+ * refclk, or FALSE.  The returned values represent the clock equation:
+ * reflck * (5 * (m1 + 2) + (m2 + 2)) / (n + 2) / p1 / p2.
+ */
+static bool psb_intel_find_best_PLL(struct drm_crtc *crtc, int target,
+				int refclk,
+				struct psb_intel_clock_t *best_clock)
+{
+	struct drm_device *dev = crtc->dev;
+	struct psb_intel_clock_t clock;
+	const struct psb_intel_limit_t *limit = psb_intel_limit(crtc);
+	int err = target;
+
+	if (psb_intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS) &&
+	    (REG_READ(LVDS) & LVDS_PORT_EN) != 0) {
+		/*
+		 * For LVDS, if the panel is on, just rely on its current
+		 * settings for dual-channel.  We haven't figured out how to
+		 * reliably set up different single/dual channel state, if we
+		 * even can.
+		 */
+		if ((REG_READ(LVDS) & LVDS_CLKB_POWER_MASK) ==
+		    LVDS_CLKB_POWER_UP)
+			clock.p2 = limit->p2.p2_fast;
+		else
+			clock.p2 = limit->p2.p2_slow;
+	} else {
+		if (target < limit->p2.dot_limit)
+			clock.p2 = limit->p2.p2_slow;
+		else
+			clock.p2 = limit->p2.p2_fast;
+	}
+
+	memset(best_clock, 0, sizeof(*best_clock));
+
+	for (clock.m1 = limit->m1.min; clock.m1 <= limit->m1.max;
+	     clock.m1++) {
+		for (clock.m2 = limit->m2.min;
+		     clock.m2 < clock.m1 && clock.m2 <= limit->m2.max;
+		     clock.m2++) {
+			for (clock.n = limit->n.min;
+			     clock.n <= limit->n.max; clock.n++) {
+				for (clock.p1 = limit->p1.min;
+				     clock.p1 <= limit->p1.max;
+				     clock.p1++) {
+					int this_err;
+
+					psb_intel_clock(dev, refclk, &clock);
+
+					if (!psb_intel_PLL_is_valid
+					    (crtc, &clock))
+						continue;
+
+					this_err = abs(clock.dot - target);
+					if (this_err < err) {
+						*best_clock = clock;
+						err = this_err;
+					}
+				}
+			}
+		}
+	}
+
+	return err != target;
+}
+
+void psb_intel_wait_for_vblank(struct drm_device *dev)
+{
+	/* Wait for 20ms, i.e. one cycle at 50hz. */
+	udelay(20000);
+}
+
+int psb_intel_pipe_set_base(struct drm_crtc *crtc,
+			    int x, int y, struct drm_framebuffer *old_fb)
+{
+	struct drm_device *dev = crtc->dev;
+	/* struct drm_i915_master_private *master_priv; */
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	struct psb_framebuffer *psbfb = to_psb_fb(crtc->fb);
+	struct psb_intel_mode_device *mode_dev = psb_intel_crtc->mode_dev;
+	int pipe = psb_intel_crtc->pipe;
+	unsigned long Start, Offset;
+	int dspbase = (pipe == 0 ? DSPABASE : DSPBBASE);
+	int dspsurf = (pipe == 0 ? DSPASURF : DSPBSURF);
+	int dspstride = (pipe == 0) ? DSPASTRIDE : DSPBSTRIDE;
+	int dspcntr_reg = (pipe == 0) ? DSPACNTR : DSPBCNTR;
+	u32 dspcntr;
+	int ret = 0;
+
+	PSB_DEBUG_ENTRY("\n");
+
+	/* no fb bound */
+	if (!crtc->fb) {
+		DRM_DEBUG("No FB bound\n");
+		return 0;
+	}
+
+	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+				       OSPM_UHB_FORCE_POWER_ON))
+		return 0;
+
+	Start = mode_dev->bo_offset(dev, psbfb);
+	Offset = y * crtc->fb->pitch + x * (crtc->fb->bits_per_pixel / 8);
+
+	REG_WRITE(dspstride, crtc->fb->pitch);
+
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
+		DRM_ERROR("Unknown color depth\n");
+		ret = -EINVAL;
+		goto psb_intel_pipe_set_base_exit;
+	}
+	REG_WRITE(dspcntr_reg, dspcntr);
+
+	DRM_DEBUG("Writing base %08lX %08lX %d %d\n", Start, Offset, x, y);
+	if (0 /* FIXMEAC - check what PSB needs */) {
+		REG_WRITE(dspbase, Offset);
+		REG_READ(dspbase);
+		REG_WRITE(dspsurf, Start);
+		REG_READ(dspsurf);
+	} else {
+		REG_WRITE(dspbase, Start + Offset);
+		REG_READ(dspbase);
+	}
+
+psb_intel_pipe_set_base_exit:
+
+	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+
+	return ret;
+}
+
+/**
+ * Sets the power management mode of the pipe and plane.
+ *
+ * This code should probably grow support for turning the cursor off and back
+ * on appropriately at the same time as we're turning the pipe off/on.
+ */
+static void psb_intel_crtc_dpms(struct drm_crtc *crtc, int mode)
+{
+	struct drm_device *dev = crtc->dev;
+	/* struct drm_i915_master_private *master_priv; */
+	/* struct drm_i915_private *dev_priv = dev->dev_private; */
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int pipe = psb_intel_crtc->pipe;
+	int dpll_reg = (pipe == 0) ? DPLL_A : DPLL_B;
+	int dspcntr_reg = (pipe == 0) ? DSPACNTR : DSPBCNTR;
+	int dspbase_reg = (pipe == 0) ? DSPABASE : DSPBBASE;
+	int pipeconf_reg = (pipe == 0) ? PIPEACONF : PIPEBCONF;
+	u32 temp;
+	bool enabled;
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
+		if ((temp & DPLL_VCO_ENABLE) == 0) {
+			REG_WRITE(dpll_reg, temp);
+			REG_READ(dpll_reg);
+			/* Wait for the clocks to stabilize. */
+			udelay(150);
+			REG_WRITE(dpll_reg, temp | DPLL_VCO_ENABLE);
+			REG_READ(dpll_reg);
+			/* Wait for the clocks to stabilize. */
+			udelay(150);
+			REG_WRITE(dpll_reg, temp | DPLL_VCO_ENABLE);
+			REG_READ(dpll_reg);
+			/* Wait for the clocks to stabilize. */
+			udelay(150);
+		}
+
+		/* Enable the pipe */
+		temp = REG_READ(pipeconf_reg);
+		if ((temp & PIPEACONF_ENABLE) == 0)
+			REG_WRITE(pipeconf_reg, temp | PIPEACONF_ENABLE);
+
+		/* Enable the plane */
+		temp = REG_READ(dspcntr_reg);
+		if ((temp & DISPLAY_PLANE_ENABLE) == 0) {
+			REG_WRITE(dspcntr_reg,
+				  temp | DISPLAY_PLANE_ENABLE);
+			/* Flush the plane changes */
+			REG_WRITE(dspbase_reg, REG_READ(dspbase_reg));
+		}
+
+		psb_intel_crtc_load_lut(crtc);
+
+		/* Give the overlay scaler a chance to enable
+		 * if it's on this pipe */
+		/* psb_intel_crtc_dpms_video(crtc, true); TODO */
+		break;
+	case DRM_MODE_DPMS_OFF:
+		/* Give the overlay scaler a chance to disable
+		 * if it's on this pipe */
+		/* psb_intel_crtc_dpms_video(crtc, FALSE); TODO */
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
+		/* Next, disable display pipes */
+		temp = REG_READ(pipeconf_reg);
+		if ((temp & PIPEACONF_ENABLE) != 0) {
+			REG_WRITE(pipeconf_reg, temp & ~PIPEACONF_ENABLE);
+			REG_READ(pipeconf_reg);
+		}
+
+		/* Wait for vblank for the disable to take effect. */
+		psb_intel_wait_for_vblank(dev);
+
+		temp = REG_READ(dpll_reg);
+		if ((temp & DPLL_VCO_ENABLE) != 0) {
+			REG_WRITE(dpll_reg, temp & ~DPLL_VCO_ENABLE);
+			REG_READ(dpll_reg);
+		}
+
+		/* Wait for the clocks to turn off. */
+		udelay(150);
+		break;
+	}
+
+	enabled = crtc->enabled && mode != DRM_MODE_DPMS_OFF;
+
+	/*Set FIFO Watermarks*/
+	REG_WRITE(DSPARB, 0x3F3E);
+}
+
+static void psb_intel_crtc_prepare(struct drm_crtc *crtc)
+{
+	struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
+	crtc_funcs->dpms(crtc, DRM_MODE_DPMS_OFF);
+}
+
+static void psb_intel_crtc_commit(struct drm_crtc *crtc)
+{
+	struct drm_crtc_helper_funcs *crtc_funcs = crtc->helper_private;
+	crtc_funcs->dpms(crtc, DRM_MODE_DPMS_ON);
+}
+
+void psb_intel_encoder_prepare(struct drm_encoder *encoder)
+{
+	struct drm_encoder_helper_funcs *encoder_funcs =
+	    encoder->helper_private;
+	/* lvds has its own version of prepare see psb_intel_lvds_prepare */
+	encoder_funcs->dpms(encoder, DRM_MODE_DPMS_OFF);
+}
+
+void psb_intel_encoder_commit(struct drm_encoder *encoder)
+{
+	struct drm_encoder_helper_funcs *encoder_funcs =
+	    encoder->helper_private;
+	/* lvds has its own version of commit see psb_intel_lvds_commit */
+	encoder_funcs->dpms(encoder, DRM_MODE_DPMS_ON);
+}
+
+static bool psb_intel_crtc_mode_fixup(struct drm_crtc *crtc,
+				  struct drm_display_mode *mode,
+				  struct drm_display_mode *adjusted_mode)
+{
+	return true;
+}
+
+
+/**
+ * Return the pipe currently connected to the panel fitter,
+ * or -1 if the panel fitter is not present or not in use
+ */
+static int psb_intel_panel_fitter_pipe(struct drm_device *dev)
+{
+	u32 pfit_control;
+
+	pfit_control = REG_READ(PFIT_CONTROL);
+
+	/* See if the panel fitter is in use */
+	if ((pfit_control & PFIT_ENABLE) == 0)
+		return -1;
+	/* Must be on PIPE 1 for PSB */
+	return 1;
+}
+
+static int psb_intel_crtc_mode_set(struct drm_crtc *crtc,
+			       struct drm_display_mode *mode,
+			       struct drm_display_mode *adjusted_mode,
+			       int x, int y,
+			       struct drm_framebuffer *old_fb)
+{
+	struct drm_device *dev = crtc->dev;
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int pipe = psb_intel_crtc->pipe;
+	int fp_reg = (pipe == 0) ? FPA0 : FPB0;
+	int dpll_reg = (pipe == 0) ? DPLL_A : DPLL_B;
+	int dspcntr_reg = (pipe == 0) ? DSPACNTR : DSPBCNTR;
+	int pipeconf_reg = (pipe == 0) ? PIPEACONF : PIPEBCONF;
+	int htot_reg = (pipe == 0) ? HTOTAL_A : HTOTAL_B;
+	int hblank_reg = (pipe == 0) ? HBLANK_A : HBLANK_B;
+	int hsync_reg = (pipe == 0) ? HSYNC_A : HSYNC_B;
+	int vtot_reg = (pipe == 0) ? VTOTAL_A : VTOTAL_B;
+	int vblank_reg = (pipe == 0) ? VBLANK_A : VBLANK_B;
+	int vsync_reg = (pipe == 0) ? VSYNC_A : VSYNC_B;
+	int dspsize_reg = (pipe == 0) ? DSPASIZE : DSPBSIZE;
+	int dsppos_reg = (pipe == 0) ? DSPAPOS : DSPBPOS;
+	int pipesrc_reg = (pipe == 0) ? PIPEASRC : PIPEBSRC;
+	int refclk;
+	struct psb_intel_clock_t clock;
+	u32 dpll = 0, fp = 0, dspcntr, pipeconf;
+	bool ok, is_sdvo = false, is_dvo = false;
+	bool is_crt = false, is_lvds = false, is_tv = false;
+	struct drm_mode_config *mode_config = &dev->mode_config;
+	struct drm_connector *connector;
+
+	list_for_each_entry(connector, &mode_config->connector_list, head) {
+		struct psb_intel_output *psb_intel_output =
+		    to_psb_intel_output(connector);
+
+		if (!connector->encoder
+		    || connector->encoder->crtc != crtc)
+			continue;
+
+		switch (psb_intel_output->type) {
+		case INTEL_OUTPUT_LVDS:
+			is_lvds = true;
+			break;
+		case INTEL_OUTPUT_SDVO:
+			is_sdvo = true;
+			break;
+		case INTEL_OUTPUT_DVO:
+			is_dvo = true;
+			break;
+		case INTEL_OUTPUT_TVOUT:
+			is_tv = true;
+			break;
+		case INTEL_OUTPUT_ANALOG:
+			is_crt = true;
+			break;
+		}
+	}
+
+	refclk = 96000;
+
+	ok = psb_intel_find_best_PLL(crtc, adjusted_mode->clock, refclk,
+				 &clock);
+	if (!ok) {
+		DRM_ERROR("Couldn't find PLL settings for mode!\n");
+		return 0;
+	}
+
+	fp = clock.n << 16 | clock.m1 << 8 | clock.m2;
+
+	dpll = DPLL_VGA_MODE_DIS;
+	if (is_lvds) {
+		dpll |= DPLLB_MODE_LVDS;
+		dpll |= DPLL_DVO_HIGH_SPEED;
+	} else
+		dpll |= DPLLB_MODE_DAC_SERIAL;
+	if (is_sdvo) {
+		int sdvo_pixel_multiply =
+			    adjusted_mode->clock / mode->clock;
+		dpll |= DPLL_DVO_HIGH_SPEED;
+		dpll |=
+		    (sdvo_pixel_multiply - 1) << SDVO_MULTIPLIER_SHIFT_HIRES;
+	}
+
+	/* compute bitmask from p1 value */
+	dpll |= (1 << (clock.p1 - 1)) << 16;
+	switch (clock.p2) {
+	case 5:
+		dpll |= DPLL_DAC_SERIAL_P2_CLOCK_DIV_5;
+		break;
+	case 7:
+		dpll |= DPLLB_LVDS_P2_CLOCK_DIV_7;
+		break;
+	case 10:
+		dpll |= DPLL_DAC_SERIAL_P2_CLOCK_DIV_10;
+		break;
+	case 14:
+		dpll |= DPLLB_LVDS_P2_CLOCK_DIV_14;
+		break;
+	}
+
+	if (is_tv) {
+		/* XXX: just matching BIOS for now */
+/*	dpll |= PLL_REF_INPUT_TVCLKINBC; */
+		dpll |= 3;
+	}
+	dpll |= PLL_REF_INPUT_DREFCLK;
+
+	/* setup pipeconf */
+	pipeconf = REG_READ(pipeconf_reg);
+
+	/* Set up the display plane register */
+	dspcntr = DISPPLANE_GAMMA_ENABLE;
+
+	if (pipe == 0)
+		dspcntr |= DISPPLANE_SEL_PIPE_A;
+	else
+		dspcntr |= DISPPLANE_SEL_PIPE_B;
+
+	dspcntr |= DISPLAY_PLANE_ENABLE;
+	pipeconf |= PIPEACONF_ENABLE;
+	dpll |= DPLL_VCO_ENABLE;
+
+
+	/* Disable the panel fitter if it was on our pipe */
+	if (psb_intel_panel_fitter_pipe(dev) == pipe)
+		REG_WRITE(PFIT_CONTROL, 0);
+
+	DRM_DEBUG("Mode for pipe %c:\n", pipe == 0 ? 'A' : 'B');
+	drm_mode_debug_printmodeline(mode);
+
+	if (dpll & DPLL_VCO_ENABLE) {
+		REG_WRITE(fp_reg, fp);
+		REG_WRITE(dpll_reg, dpll & ~DPLL_VCO_ENABLE);
+		REG_READ(dpll_reg);
+		udelay(150);
+	}
+
+	/* The LVDS pin pair needs to be on before the DPLLs are enabled.
+	 * This is an exception to the general rule that mode_set doesn't turn
+	 * things on.
+	 */
+	if (is_lvds) {
+		u32 lvds = REG_READ(LVDS);
+
+		lvds |=
+		    LVDS_PORT_EN | LVDS_A0A2_CLKA_POWER_UP |
+		    LVDS_PIPEB_SELECT;
+		/* Set the B0-B3 data pairs corresponding to
+		 * whether we're going to
+		 * set the DPLLs for dual-channel mode or not.
+		 */
+		if (clock.p2 == 7)
+			lvds |= LVDS_B0B3_POWER_UP | LVDS_CLKB_POWER_UP;
+		else
+			lvds &= ~(LVDS_B0B3_POWER_UP | LVDS_CLKB_POWER_UP);
+
+		/* It would be nice to set 24 vs 18-bit mode (LVDS_A3_POWER_UP)
+		 * appropriately here, but we need to look more
+		 * thoroughly into how panels behave in the two modes.
+		 */
+
+		REG_WRITE(LVDS, lvds);
+		REG_READ(LVDS);
+	}
+
+	REG_WRITE(fp_reg, fp);
+	REG_WRITE(dpll_reg, dpll);
+	REG_READ(dpll_reg);
+	/* Wait for the clocks to stabilize. */
+	udelay(150);
+
+	/* write it again -- the BIOS does, after all */
+	REG_WRITE(dpll_reg, dpll);
+
+	REG_READ(dpll_reg);
+	/* Wait for the clocks to stabilize. */
+	udelay(150);
+
+	REG_WRITE(htot_reg, (adjusted_mode->crtc_hdisplay - 1) |
+		  ((adjusted_mode->crtc_htotal - 1) << 16));
+	REG_WRITE(hblank_reg, (adjusted_mode->crtc_hblank_start - 1) |
+		  ((adjusted_mode->crtc_hblank_end - 1) << 16));
+	REG_WRITE(hsync_reg, (adjusted_mode->crtc_hsync_start - 1) |
+		  ((adjusted_mode->crtc_hsync_end - 1) << 16));
+	REG_WRITE(vtot_reg, (adjusted_mode->crtc_vdisplay - 1) |
+		  ((adjusted_mode->crtc_vtotal - 1) << 16));
+	REG_WRITE(vblank_reg, (adjusted_mode->crtc_vblank_start - 1) |
+		  ((adjusted_mode->crtc_vblank_end - 1) << 16));
+	REG_WRITE(vsync_reg, (adjusted_mode->crtc_vsync_start - 1) |
+		  ((adjusted_mode->crtc_vsync_end - 1) << 16));
+	/* pipesrc and dspsize control the size that is scaled from,
+	 * which should always be the user's requested size.
+	 */
+	REG_WRITE(dspsize_reg,
+		  ((mode->vdisplay - 1) << 16) | (mode->hdisplay - 1));
+	REG_WRITE(dsppos_reg, 0);
+	REG_WRITE(pipesrc_reg,
+		  ((mode->hdisplay - 1) << 16) | (mode->vdisplay - 1));
+	REG_WRITE(pipeconf_reg, pipeconf);
+	REG_READ(pipeconf_reg);
+
+	psb_intel_wait_for_vblank(dev);
+
+	REG_WRITE(dspcntr_reg, dspcntr);
+
+	/* Flush the plane changes */
+	{
+		struct drm_crtc_helper_funcs *crtc_funcs =
+		    crtc->helper_private;
+		crtc_funcs->mode_set_base(crtc, x, y, old_fb);
+	}
+
+	psb_intel_wait_for_vblank(dev);
+
+	return 0;
+}
+
+/** Loads the palette/gamma unit for the CRTC with the prepared values */
+void psb_intel_crtc_load_lut(struct drm_crtc *crtc)
+{
+	struct drm_device *dev = crtc->dev;
+	struct drm_psb_private *dev_priv =
+				(struct drm_psb_private *)dev->dev_private;
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int palreg = PALETTE_A;
+	int i;
+
+	/* The clocks have to be on to load the palette. */
+	if (!crtc->enabled)
+		return;
+
+	switch (psb_intel_crtc->pipe) {
+	case 0:
+		break;
+	case 1:
+		palreg = PALETTE_B;
+		break;
+	case 2:
+		palreg = PALETTE_C;
+		break;
+	default:
+		DRM_ERROR("Illegal Pipe Number.\n");
+		return;
+	}
+
+	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+				      OSPM_UHB_ONLY_IF_ON)) {
+		for (i = 0; i < 256; i++) {
+			REG_WRITE(palreg + 4 * i,
+				  ((psb_intel_crtc->lut_r[i] +
+				  psb_intel_crtc->lut_adj[i]) << 16) |
+				  ((psb_intel_crtc->lut_g[i] +
+				  psb_intel_crtc->lut_adj[i]) << 8) |
+				  (psb_intel_crtc->lut_b[i] +
+				  psb_intel_crtc->lut_adj[i]));
+		}
+		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	} else {
+		for (i = 0; i < 256; i++) {
+			dev_priv->save_palette_a[i] =
+				  ((psb_intel_crtc->lut_r[i] +
+				  psb_intel_crtc->lut_adj[i]) << 16) |
+				  ((psb_intel_crtc->lut_g[i] +
+				  psb_intel_crtc->lut_adj[i]) << 8) |
+				  (psb_intel_crtc->lut_b[i] +
+				  psb_intel_crtc->lut_adj[i]);
+		}
+
+	}
+}
+
+/**
+ * Save HW states of giving crtc
+ */
+static void psb_intel_crtc_save(struct drm_crtc *crtc)
+{
+	struct drm_device *dev = crtc->dev;
+	/* struct drm_psb_private *dev_priv =
+			(struct drm_psb_private *)dev->dev_private; */
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	struct psb_intel_crtc_state *crtc_state = psb_intel_crtc->crtc_state;
+	int pipeA = (psb_intel_crtc->pipe == 0);
+	uint32_t paletteReg;
+	int i;
+
+	DRM_DEBUG("\n");
+
+	if (!crtc_state) {
+		DRM_DEBUG("No CRTC state found\n");
+		return;
+	}
+
+	crtc_state->saveDSPCNTR = REG_READ(pipeA ? DSPACNTR : DSPBCNTR);
+	crtc_state->savePIPECONF = REG_READ(pipeA ? PIPEACONF : PIPEBCONF);
+	crtc_state->savePIPESRC = REG_READ(pipeA ? PIPEASRC : PIPEBSRC);
+	crtc_state->saveFP0 = REG_READ(pipeA ? FPA0 : FPB0);
+	crtc_state->saveFP1 = REG_READ(pipeA ? FPA1 : FPB1);
+	crtc_state->saveDPLL = REG_READ(pipeA ? DPLL_A : DPLL_B);
+	crtc_state->saveHTOTAL = REG_READ(pipeA ? HTOTAL_A : HTOTAL_B);
+	crtc_state->saveHBLANK = REG_READ(pipeA ? HBLANK_A : HBLANK_B);
+	crtc_state->saveHSYNC = REG_READ(pipeA ? HSYNC_A : HSYNC_B);
+	crtc_state->saveVTOTAL = REG_READ(pipeA ? VTOTAL_A : VTOTAL_B);
+	crtc_state->saveVBLANK = REG_READ(pipeA ? VBLANK_A : VBLANK_B);
+	crtc_state->saveVSYNC = REG_READ(pipeA ? VSYNC_A : VSYNC_B);
+	crtc_state->saveDSPSTRIDE = REG_READ(pipeA ? DSPASTRIDE : DSPBSTRIDE);
+
+	/*NOTE: DSPSIZE DSPPOS only for psb*/
+	crtc_state->saveDSPSIZE = REG_READ(pipeA ? DSPASIZE : DSPBSIZE);
+	crtc_state->saveDSPPOS = REG_READ(pipeA ? DSPAPOS : DSPBPOS);
+
+	crtc_state->saveDSPBASE = REG_READ(pipeA ? DSPABASE : DSPBBASE);
+
+	DRM_DEBUG("(%x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x)\n",
+			crtc_state->saveDSPCNTR,
+			crtc_state->savePIPECONF,
+			crtc_state->savePIPESRC,
+			crtc_state->saveFP0,
+			crtc_state->saveFP1,
+			crtc_state->saveDPLL,
+			crtc_state->saveHTOTAL,
+			crtc_state->saveHBLANK,
+			crtc_state->saveHSYNC,
+			crtc_state->saveVTOTAL,
+			crtc_state->saveVBLANK,
+			crtc_state->saveVSYNC,
+			crtc_state->saveDSPSTRIDE,
+			crtc_state->saveDSPSIZE,
+			crtc_state->saveDSPPOS,
+			crtc_state->saveDSPBASE
+		);
+
+	paletteReg = pipeA ? PALETTE_A : PALETTE_B;
+	for (i = 0; i < 256; ++i)
+		crtc_state->savePalette[i] = REG_READ(paletteReg + (i << 2));
+}
+
+/**
+ * Restore HW states of giving crtc
+ */
+static void psb_intel_crtc_restore(struct drm_crtc *crtc)
+{
+	struct drm_device *dev = crtc->dev;
+	/* struct drm_psb_private * dev_priv =
+				(struct drm_psb_private *)dev->dev_private; */
+	struct psb_intel_crtc *psb_intel_crtc =  to_psb_intel_crtc(crtc);
+	struct psb_intel_crtc_state *crtc_state = psb_intel_crtc->crtc_state;
+	/* struct drm_crtc_helper_funcs * crtc_funcs = crtc->helper_private; */
+	int pipeA = (psb_intel_crtc->pipe == 0);
+	uint32_t paletteReg;
+	int i;
+
+	DRM_DEBUG("\n");
+
+	if (!crtc_state) {
+		DRM_DEBUG("No crtc state\n");
+		return;
+	}
+
+	DRM_DEBUG(
+		"current:(%x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x)\n",
+		REG_READ(pipeA ? DSPACNTR : DSPBCNTR),
+		REG_READ(pipeA ? PIPEACONF : PIPEBCONF),
+		REG_READ(pipeA ? PIPEASRC : PIPEBSRC),
+		REG_READ(pipeA ? FPA0 : FPB0),
+		REG_READ(pipeA ? FPA1 : FPB1),
+		REG_READ(pipeA ? DPLL_A : DPLL_B),
+		REG_READ(pipeA ? HTOTAL_A : HTOTAL_B),
+		REG_READ(pipeA ? HBLANK_A : HBLANK_B),
+		REG_READ(pipeA ? HSYNC_A : HSYNC_B),
+		REG_READ(pipeA ? VTOTAL_A : VTOTAL_B),
+		REG_READ(pipeA ? VBLANK_A : VBLANK_B),
+		REG_READ(pipeA ? VSYNC_A : VSYNC_B),
+		REG_READ(pipeA ? DSPASTRIDE : DSPBSTRIDE),
+		REG_READ(pipeA ? DSPASIZE : DSPBSIZE),
+		REG_READ(pipeA ? DSPAPOS : DSPBPOS),
+		REG_READ(pipeA ? DSPABASE : DSPBBASE)
+		);
+
+	DRM_DEBUG(
+		"saved: (%x %x %x %x %x %x %x %x %x %x %x %x %x %x %x %x)\n",
+		crtc_state->saveDSPCNTR,
+		crtc_state->savePIPECONF,
+		crtc_state->savePIPESRC,
+		crtc_state->saveFP0,
+		crtc_state->saveFP1,
+		crtc_state->saveDPLL,
+		crtc_state->saveHTOTAL,
+		crtc_state->saveHBLANK,
+		crtc_state->saveHSYNC,
+		crtc_state->saveVTOTAL,
+		crtc_state->saveVBLANK,
+		crtc_state->saveVSYNC,
+		crtc_state->saveDSPSTRIDE,
+		crtc_state->saveDSPSIZE,
+		crtc_state->saveDSPPOS,
+		crtc_state->saveDSPBASE
+		);
+
+
+	if (crtc_state->saveDPLL & DPLL_VCO_ENABLE) {
+		REG_WRITE(pipeA ? DPLL_A : DPLL_B,
+			crtc_state->saveDPLL & ~DPLL_VCO_ENABLE);
+		REG_READ(pipeA ? DPLL_A : DPLL_B);
+		DRM_DEBUG("write dpll: %x\n",
+				REG_READ(pipeA ? DPLL_A : DPLL_B));
+		udelay(150);
+	}
+
+	REG_WRITE(pipeA ? FPA0 : FPB0, crtc_state->saveFP0);
+	REG_READ(pipeA ? FPA0 : FPB0);
+
+	REG_WRITE(pipeA ? FPA1 : FPB1, crtc_state->saveFP1);
+	REG_READ(pipeA ? FPA1 : FPB1);
+
+	REG_WRITE(pipeA ? DPLL_A : DPLL_B, crtc_state->saveDPLL);
+	REG_READ(pipeA ? DPLL_A : DPLL_B);
+	udelay(150);
+
+	REG_WRITE(pipeA ? HTOTAL_A : HTOTAL_B, crtc_state->saveHTOTAL);
+	REG_WRITE(pipeA ? HBLANK_A : HBLANK_B, crtc_state->saveHBLANK);
+	REG_WRITE(pipeA ? HSYNC_A : HSYNC_B, crtc_state->saveHSYNC);
+	REG_WRITE(pipeA ? VTOTAL_A : VTOTAL_B, crtc_state->saveVTOTAL);
+	REG_WRITE(pipeA ? VBLANK_A : VBLANK_B, crtc_state->saveVBLANK);
+	REG_WRITE(pipeA ? VSYNC_A : VSYNC_B, crtc_state->saveVSYNC);
+	REG_WRITE(pipeA ? DSPASTRIDE : DSPBSTRIDE, crtc_state->saveDSPSTRIDE);
+
+	REG_WRITE(pipeA ? DSPASIZE : DSPBSIZE, crtc_state->saveDSPSIZE);
+	REG_WRITE(pipeA ? DSPAPOS : DSPBPOS, crtc_state->saveDSPPOS);
+
+	REG_WRITE(pipeA ? PIPEASRC : PIPEBSRC, crtc_state->savePIPESRC);
+	REG_WRITE(pipeA ? DSPABASE : DSPBBASE, crtc_state->saveDSPBASE);
+	REG_WRITE(pipeA ? PIPEACONF : PIPEBCONF, crtc_state->savePIPECONF);
+
+	psb_intel_wait_for_vblank(dev);
+
+	REG_WRITE(pipeA ? DSPACNTR : DSPBCNTR, crtc_state->saveDSPCNTR);
+	REG_WRITE(pipeA ? DSPABASE : DSPBBASE, crtc_state->saveDSPBASE);
+
+	psb_intel_wait_for_vblank(dev);
+
+	paletteReg = pipeA ? PALETTE_A : PALETTE_B;
+	for (i = 0; i < 256; ++i)
+		REG_WRITE(paletteReg + (i << 2), crtc_state->savePalette[i]);
+}
+
+static int psb_intel_crtc_cursor_set(struct drm_crtc *crtc,
+				 struct drm_file *file_priv,
+				 uint32_t handle,
+				 uint32_t width, uint32_t height)
+{
+	struct drm_device *dev = crtc->dev;
+	struct drm_psb_private *dev_priv =
+				(struct drm_psb_private *)dev->dev_private;
+	struct psb_gtt *pg = dev_priv->pg;
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	struct psb_intel_mode_device *mode_dev = psb_intel_crtc->mode_dev;
+	int pipe = psb_intel_crtc->pipe;
+	uint32_t control = (pipe == 0) ? CURACNTR : CURBCNTR;
+	uint32_t base = (pipe == 0) ? CURABASE : CURBBASE;
+	uint32_t temp;
+	size_t addr = 0;
+	uint32_t page_offset;
+	size_t size;
+	void *bo;
+	int ret;
+
+	DRM_DEBUG("\n");
+
+	/* if we want to turn of the cursor ignore width and height */
+	if (!handle) {
+		DRM_DEBUG("cursor off\n");
+		/* turn off the cursor */
+		temp = 0;
+		temp |= CURSOR_MODE_DISABLE;
+
+		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+					      OSPM_UHB_ONLY_IF_ON)) {
+			REG_WRITE(control, temp);
+			REG_WRITE(base, 0);
+			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		}
+
+		/* unpin the old bo */
+		if (psb_intel_crtc->cursor_bo) {
+			mode_dev->bo_unpin_for_scanout(dev,
+						       psb_intel_crtc->
+						       cursor_bo);
+			psb_intel_crtc->cursor_bo = NULL;
+		}
+
+		return 0;
+	}
+
+	/* Currently we only support 64x64 cursors */
+	if (width != 64 || height != 64) {
+		DRM_ERROR("we currently only support 64x64 cursors\n");
+		return -EINVAL;
+	}
+
+	bo = mode_dev->bo_from_handle(dev, file_priv, handle);
+	if (!bo)
+		return -ENOENT;
+
+	ret = mode_dev->bo_pin_for_scanout(dev, bo);
+	if (ret)
+		return ret;
+	size = mode_dev->bo_size(dev, bo);
+	if (size < width * height * 4) {
+		DRM_ERROR("buffer is to small\n");
+		return -ENOMEM;
+	}
+
+	/*insert this bo into gtt*/
+	DRM_DEBUG("%s: map meminfo for hw cursor. handle %x\n",
+						__func__, handle);
+
+	ret = psb_gtt_map_meminfo(dev, (void *)handle, &page_offset);
+	if (ret) {
+		DRM_ERROR("Can not map meminfo to GTT. handle 0x%x\n", handle);
+		return ret;
+	}
+
+	addr = page_offset << PAGE_SHIFT;
+
+	addr += pg->stolen_base;
+
+	psb_intel_crtc->cursor_addr = addr;
+
+	temp = 0;
+	/* set the pipe for the cursor */
+	temp |= (pipe << 28);
+	temp |= CURSOR_MODE_64_ARGB_AX | MCURSOR_GAMMA_ENABLE;
+
+	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+				      OSPM_UHB_ONLY_IF_ON)) {
+		REG_WRITE(control, temp);
+		REG_WRITE(base, addr);
+		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	}
+
+	/* unpin the old bo */
+	if (psb_intel_crtc->cursor_bo && psb_intel_crtc->cursor_bo != bo) {
+		mode_dev->bo_unpin_for_scanout(dev, psb_intel_crtc->cursor_bo);
+		psb_intel_crtc->cursor_bo = bo;
+	}
+
+	return 0;
+}
+
+static int psb_intel_crtc_cursor_move(struct drm_crtc *crtc, int x, int y)
+{
+	struct drm_device *dev = crtc->dev;
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int pipe = psb_intel_crtc->pipe;
+	uint32_t temp = 0;
+	uint32_t adder;
+
+
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
+	adder = psb_intel_crtc->cursor_addr;
+
+	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+				      OSPM_UHB_ONLY_IF_ON)) {
+		REG_WRITE((pipe == 0) ? CURAPOS : CURBPOS, temp);
+		REG_WRITE((pipe == 0) ? CURABASE : CURBBASE, adder);
+		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	}
+	return 0;
+}
+
+static void psb_intel_crtc_gamma_set(struct drm_crtc *crtc, u16 *red,
+			 u16 *green, u16 *blue, uint32_t type, uint32_t size)
+{
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int i;
+
+	if (size != 256)
+		return;
+
+	for (i = 0; i < 256; i++) {
+		psb_intel_crtc->lut_r[i] = red[i] >> 8;
+		psb_intel_crtc->lut_g[i] = green[i] >> 8;
+		psb_intel_crtc->lut_b[i] = blue[i] >> 8;
+	}
+
+	psb_intel_crtc_load_lut(crtc);
+}
+
+static int psb_crtc_set_config(struct drm_mode_set *set)
+{
+	int ret;
+	struct drm_device *dev = set->crtc->dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	if (!dev_priv->rpm_enabled)
+		return drm_crtc_helper_set_config(set);
+
+	pm_runtime_forbid(&dev->pdev->dev);
+	ret = drm_crtc_helper_set_config(set);
+	pm_runtime_allow(&dev->pdev->dev);
+	return ret;
+}
+
+/* Returns the clock of the currently programmed mode of the given pipe. */
+static int psb_intel_crtc_clock_get(struct drm_device *dev,
+				struct drm_crtc *crtc)
+{
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int pipe = psb_intel_crtc->pipe;
+	u32 dpll;
+	u32 fp;
+	struct psb_intel_clock_t clock;
+	bool is_lvds;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+				      OSPM_UHB_ONLY_IF_ON)) {
+		dpll = REG_READ((pipe == 0) ? DPLL_A : DPLL_B);
+		if ((dpll & DISPLAY_RATE_SELECT_FPA1) == 0)
+			fp = REG_READ((pipe == 0) ? FPA0 : FPB0);
+		else
+			fp = REG_READ((pipe == 0) ? FPA1 : FPB1);
+		is_lvds = (pipe == 1) && (REG_READ(LVDS) & LVDS_PORT_EN);
+		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	} else {
+		dpll = (pipe == 0) ?
+			dev_priv->saveDPLL_A : dev_priv->saveDPLL_B;
+
+		if ((dpll & DISPLAY_RATE_SELECT_FPA1) == 0)
+			fp = (pipe == 0) ?
+				dev_priv->saveFPA0 :
+				dev_priv->saveFPB0;
+		else
+			fp = (pipe == 0) ?
+				dev_priv->saveFPA1 :
+				dev_priv->saveFPB1;
+
+		is_lvds = (pipe == 1) && (dev_priv->saveLVDS & LVDS_PORT_EN);
+	}
+
+	clock.m1 = (fp & FP_M1_DIV_MASK) >> FP_M1_DIV_SHIFT;
+	clock.m2 = (fp & FP_M2_DIV_MASK) >> FP_M2_DIV_SHIFT;
+	clock.n = (fp & FP_N_DIV_MASK) >> FP_N_DIV_SHIFT;
+
+	if (is_lvds) {
+		clock.p1 =
+		    ffs((dpll &
+			 DPLL_FPA01_P1_POST_DIV_MASK_I830_LVDS) >>
+			DPLL_FPA01_P1_POST_DIV_SHIFT);
+		clock.p2 = 14;
+
+		if ((dpll & PLL_REF_INPUT_MASK) ==
+		    PLLB_REF_INPUT_SPREADSPECTRUMIN) {
+			/* XXX: might not be 66MHz */
+			i8xx_clock(66000, &clock);
+		} else
+			i8xx_clock(48000, &clock);
+	} else {
+		if (dpll & PLL_P1_DIVIDE_BY_TWO)
+			clock.p1 = 2;
+		else {
+			clock.p1 =
+			    ((dpll &
+			      DPLL_FPA01_P1_POST_DIV_MASK_I830) >>
+			     DPLL_FPA01_P1_POST_DIV_SHIFT) + 2;
+		}
+		if (dpll & PLL_P2_DIVIDE_BY_4)
+			clock.p2 = 4;
+		else
+			clock.p2 = 2;
+
+		i8xx_clock(48000, &clock);
+	}
+
+	/* XXX: It would be nice to validate the clocks, but we can't reuse
+	 * i830PllIsValid() because it relies on the xf86_config connector
+	 * configuration being accurate, which it isn't necessarily.
+	 */
+
+	return clock.dot;
+}
+
+/** Returns the currently programmed mode of the given pipe. */
+struct drm_display_mode *psb_intel_crtc_mode_get(struct drm_device *dev,
+					     struct drm_crtc *crtc)
+{
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	int pipe = psb_intel_crtc->pipe;
+	struct drm_display_mode *mode;
+	int htot;
+	int hsync;
+	int vtot;
+	int vsync;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+				      OSPM_UHB_ONLY_IF_ON)) {
+		htot = REG_READ((pipe == 0) ? HTOTAL_A : HTOTAL_B);
+		hsync = REG_READ((pipe == 0) ? HSYNC_A : HSYNC_B);
+		vtot = REG_READ((pipe == 0) ? VTOTAL_A : VTOTAL_B);
+		vsync = REG_READ((pipe == 0) ? VSYNC_A : VSYNC_B);
+		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	} else {
+		htot = (pipe == 0) ?
+			dev_priv->saveHTOTAL_A : dev_priv->saveHTOTAL_B;
+		hsync = (pipe == 0) ?
+			dev_priv->saveHSYNC_A : dev_priv->saveHSYNC_B;
+		vtot = (pipe == 0) ?
+			dev_priv->saveVTOTAL_A : dev_priv->saveVTOTAL_B;
+		vsync = (pipe == 0) ?
+			dev_priv->saveVSYNC_A : dev_priv->saveVSYNC_B;
+	}
+
+	mode = kzalloc(sizeof(*mode), GFP_KERNEL);
+	if (!mode)
+		return NULL;
+
+	mode->clock = psb_intel_crtc_clock_get(dev, crtc);
+	mode->hdisplay = (htot & 0xffff) + 1;
+	mode->htotal = ((htot & 0xffff0000) >> 16) + 1;
+	mode->hsync_start = (hsync & 0xffff) + 1;
+	mode->hsync_end = ((hsync & 0xffff0000) >> 16) + 1;
+	mode->vdisplay = (vtot & 0xffff) + 1;
+	mode->vtotal = ((vtot & 0xffff0000) >> 16) + 1;
+	mode->vsync_start = (vsync & 0xffff) + 1;
+	mode->vsync_end = ((vsync & 0xffff0000) >> 16) + 1;
+
+	drm_mode_set_name(mode);
+	drm_mode_set_crtcinfo(mode, 0);
+
+	return mode;
+}
+
+static void psb_intel_crtc_destroy(struct drm_crtc *crtc)
+{
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+
+	kfree(psb_intel_crtc->crtc_state);
+	drm_crtc_cleanup(crtc);
+	kfree(psb_intel_crtc);
+}
+
+static const struct drm_crtc_helper_funcs psb_intel_helper_funcs = {
+	.dpms = psb_intel_crtc_dpms,
+	.mode_fixup = psb_intel_crtc_mode_fixup,
+	.mode_set = psb_intel_crtc_mode_set,
+	.mode_set_base = psb_intel_pipe_set_base,
+	.prepare = psb_intel_crtc_prepare,
+	.commit = psb_intel_crtc_commit,
+};
+
+static const struct drm_crtc_helper_funcs mrst_helper_funcs;
+static const struct drm_crtc_helper_funcs mdfld_helper_funcs;
+const struct drm_crtc_funcs mdfld_intel_crtc_funcs;
+
+const struct drm_crtc_funcs psb_intel_crtc_funcs = {
+	.save = psb_intel_crtc_save,
+	.restore = psb_intel_crtc_restore,
+	.cursor_set = psb_intel_crtc_cursor_set,
+	.cursor_move = psb_intel_crtc_cursor_move,
+	.gamma_set = psb_intel_crtc_gamma_set,
+	.set_config = psb_crtc_set_config,
+	.destroy = psb_intel_crtc_destroy,
+};
+
+void psb_intel_crtc_init(struct drm_device *dev, int pipe,
+		     struct psb_intel_mode_device *mode_dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_intel_crtc *psb_intel_crtc;
+	int i;
+	uint16_t *r_base, *g_base, *b_base;
+
+	PSB_DEBUG_ENTRY("\n");
+
+	/* We allocate a extra array of drm_connector pointers
+	 * for fbdev after the crtc */
+	psb_intel_crtc =
+	    kzalloc(sizeof(struct psb_intel_crtc) +
+		    (INTELFB_CONN_LIMIT * sizeof(struct drm_connector *)),
+		    GFP_KERNEL);
+	if (psb_intel_crtc == NULL)
+		return;
+
+	psb_intel_crtc->crtc_state =
+		kzalloc(sizeof(struct psb_intel_crtc_state), GFP_KERNEL);
+	if (!psb_intel_crtc->crtc_state) {
+		DRM_INFO("Crtc state error: No memory\n");
+		kfree(psb_intel_crtc);
+		return;
+	}
+
+	drm_crtc_init(dev, &psb_intel_crtc->base, &psb_intel_crtc_funcs);
+
+	drm_mode_crtc_set_gamma_size(&psb_intel_crtc->base, 256);
+	psb_intel_crtc->pipe = pipe;
+	psb_intel_crtc->plane = pipe;
+
+	r_base = psb_intel_crtc->base.gamma_store;
+	g_base = r_base + 256;
+	b_base = g_base + 256;
+	for (i = 0; i < 256; i++) {
+		psb_intel_crtc->lut_r[i] = i;
+		psb_intel_crtc->lut_g[i] = i;
+		psb_intel_crtc->lut_b[i] = i;
+		r_base[i] = i << 8;
+		g_base[i] = i << 8;
+		b_base[i] = i << 8;
+
+		psb_intel_crtc->lut_adj[i] = 0;
+	}
+
+	psb_intel_crtc->mode_dev = mode_dev;
+	psb_intel_crtc->cursor_addr = 0;
+
+	drm_crtc_helper_add(&psb_intel_crtc->base,
+				    &psb_intel_helper_funcs);
+
+	/* Setup the array of drm_connector pointer array */
+	psb_intel_crtc->mode_set.crtc = &psb_intel_crtc->base;
+	BUG_ON(pipe >= ARRAY_SIZE(dev_priv->plane_to_crtc_mapping) ||
+	       dev_priv->plane_to_crtc_mapping[psb_intel_crtc->plane] != NULL);
+	dev_priv->plane_to_crtc_mapping[psb_intel_crtc->plane] =
+							&psb_intel_crtc->base;
+	dev_priv->pipe_to_crtc_mapping[psb_intel_crtc->pipe] =
+							&psb_intel_crtc->base;
+	psb_intel_crtc->mode_set.connectors =
+	    (struct drm_connector **) (psb_intel_crtc + 1);
+	psb_intel_crtc->mode_set.num_connectors = 0;
+}
+
+int psb_intel_get_pipe_from_crtc_id(struct drm_device *dev, void *data,
+				struct drm_file *file_priv)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct drm_psb_get_pipe_from_crtc_id_arg *pipe_from_crtc_id = data;
+	struct drm_mode_object *drmmode_obj;
+	struct psb_intel_crtc *crtc;
+
+	if (!dev_priv) {
+		DRM_ERROR("called with no initialization\n");
+		return -EINVAL;
+	}
+
+	drmmode_obj = drm_mode_object_find(dev, pipe_from_crtc_id->crtc_id,
+			DRM_MODE_OBJECT_CRTC);
+
+	if (!drmmode_obj) {
+		DRM_ERROR("no such CRTC id\n");
+		return -EINVAL;
+	}
+
+	crtc = to_psb_intel_crtc(obj_to_crtc(drmmode_obj));
+	pipe_from_crtc_id->pipe = crtc->pipe;
+
+	return 0;
+}
+
+struct drm_crtc *psb_intel_get_crtc_from_pipe(struct drm_device *dev, int pipe)
+{
+	struct drm_crtc *crtc = NULL;
+
+	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
+		struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+		if (psb_intel_crtc->pipe == pipe)
+			break;
+	}
+	return crtc;
+}
+
+int psb_intel_connector_clones(struct drm_device *dev, int type_mask)
+{
+	int index_mask = 0;
+	struct drm_connector *connector;
+	int entry = 0;
+
+	list_for_each_entry(connector, &dev->mode_config.connector_list,
+			    head) {
+		struct psb_intel_output *psb_intel_output =
+		    to_psb_intel_output(connector);
+		if (type_mask & (1 << psb_intel_output->type))
+			index_mask |= (1 << entry);
+		entry++;
+	}
+	return index_mask;
+}
+
+
+void psb_intel_modeset_cleanup(struct drm_device *dev)
+{
+	drm_mode_config_cleanup(dev);
+}
+
+
+/* current intel driver doesn't take advantage of encoders
+   always give back the encoder for the connector
+*/
+struct drm_encoder *psb_intel_best_encoder(struct drm_connector *connector)
+{
+	struct psb_intel_output *psb_intel_output =
+					to_psb_intel_output(connector);
+
+	return &psb_intel_output->enc;
+}
+
diff --git a/drivers/staging/gma500/psb_intel_display.h b/drivers/staging/gma500/psb_intel_display.h
new file mode 100644
index 0000000..74e3b5e
--- /dev/null
+++ b/drivers/staging/gma500/psb_intel_display.h
@@ -0,0 +1,25 @@
+/* copyright (c) 2008, Intel Corporation
+ * 
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors:
+ * Eric Anholt <eric@anholt.net>
+ */
+
+#ifndef _INTEL_DISPLAY_H_
+#define _INTEL_DISPLAY_H_
+
+bool psb_intel_pipe_has_type(struct drm_crtc *crtc, int type);
+
+#endif
diff --git a/drivers/staging/gma500/psb_intel_drv.h b/drivers/staging/gma500/psb_intel_drv.h
new file mode 100644
index 0000000..cb0a91b
--- /dev/null
+++ b/drivers/staging/gma500/psb_intel_drv.h
@@ -0,0 +1,247 @@
+/*
+ * Copyright (c) 2009, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#ifndef __INTEL_DRV_H__
+#define __INTEL_DRV_H__
+
+#include <linux/i2c.h>
+#include <linux/i2c-algo-bit.h>
+#include <drm/drm_crtc.h>
+#include <drm/drm_crtc_helper.h>
+#include <linux/gpio.h>
+
+/*
+ * MOORESTOWN defines
+ */
+#define DELAY_TIME1 2000 /* 1000 = 1ms */
+
+/*
+ * Display related stuff
+ */
+
+/* store information about an Ixxx DVO */
+/* The i830->i865 use multiple DVOs with multiple i2cs */
+/* the i915, i945 have a single sDVO i2c bus - which is different */
+#define MAX_OUTPUTS 6
+/* maximum connectors per crtcs in the mode set */
+#define INTELFB_CONN_LIMIT 4
+
+#define INTEL_I2C_BUS_DVO 1
+#define INTEL_I2C_BUS_SDVO 2
+
+/* these are outputs from the chip - integrated only
+ * external chips are via DVO or SDVO output */
+#define INTEL_OUTPUT_UNUSED 0
+#define INTEL_OUTPUT_ANALOG 1
+#define INTEL_OUTPUT_DVO 2
+#define INTEL_OUTPUT_SDVO 3
+#define INTEL_OUTPUT_LVDS 4
+#define INTEL_OUTPUT_TVOUT 5
+#define INTEL_OUTPUT_HDMI 6
+#define INTEL_OUTPUT_MIPI 7
+#define INTEL_OUTPUT_MIPI2 8
+
+#define INTEL_DVO_CHIP_NONE 0
+#define INTEL_DVO_CHIP_LVDS 1
+#define INTEL_DVO_CHIP_TMDS 2
+#define INTEL_DVO_CHIP_TVOUT 4
+
+enum mipi_panel_type {
+	NSC_800X480 = 1,
+	LGE_480X1024 = 2,
+	TPO_864X480 = 3
+};
+
+/**
+ * Hold information useally put on the device driver privates here,
+ * since it needs to be shared across multiple of devices drivers privates.
+*/
+struct psb_intel_mode_device {
+
+	/*
+	 * Abstracted memory manager operations
+	 */
+	void *(*bo_from_handle) (struct drm_device *dev,
+				 struct drm_file *file_priv,
+				 unsigned int handle);
+	 size_t(*bo_size) (struct drm_device *dev, void *bo);
+	 size_t(*bo_offset) (struct drm_device *dev, void *bo);
+	int (*bo_pin_for_scanout) (struct drm_device *dev, void *bo);
+	int (*bo_unpin_for_scanout) (struct drm_device *dev, void *bo);
+
+	/*
+	 * Cursor
+	 */
+	int cursor_needs_physical;
+
+	/*
+	 * LVDS info
+	 */
+	int backlight_duty_cycle;	/* restore backlight to this value */
+	bool panel_wants_dither;
+	struct drm_display_mode *panel_fixed_mode;
+	struct drm_display_mode *panel_fixed_mode2;
+	struct drm_display_mode *vbt_mode;	/* if any */
+
+	uint32_t saveBLC_PWM_CTL;
+};
+
+struct psb_intel_i2c_chan {
+	/* for getting at dev. private (mmio etc.) */
+	struct drm_device *drm_dev;
+	u32 reg;		/* GPIO reg */
+	struct i2c_adapter adapter;
+	struct i2c_algo_bit_data algo;
+	u8 slave_addr;
+};
+
+struct psb_intel_output {
+	struct drm_connector base;
+
+	struct drm_encoder enc;
+	int type;
+
+	struct psb_intel_i2c_chan *i2c_bus;	/* for control functions */
+	struct psb_intel_i2c_chan *ddc_bus;	/* for DDC only stuff */
+	bool load_detect_temp;
+	void *dev_priv;
+
+	struct psb_intel_mode_device *mode_dev;
+
+};
+
+struct psb_intel_crtc_state {
+	uint32_t saveDSPCNTR;
+	uint32_t savePIPECONF;
+	uint32_t savePIPESRC;
+	uint32_t saveDPLL;
+	uint32_t saveFP0;
+	uint32_t saveFP1;
+	uint32_t saveHTOTAL;
+	uint32_t saveHBLANK;
+	uint32_t saveHSYNC;
+	uint32_t saveVTOTAL;
+	uint32_t saveVBLANK;
+	uint32_t saveVSYNC;
+	uint32_t saveDSPSTRIDE;
+	uint32_t saveDSPSIZE;
+	uint32_t saveDSPPOS;
+	uint32_t saveDSPBASE;
+	uint32_t savePalette[256];
+};
+
+struct psb_intel_crtc {
+	struct drm_crtc base;
+	int pipe;
+	int plane;
+	uint32_t cursor_addr;
+	u8 lut_r[256], lut_g[256], lut_b[256];
+	u8 lut_adj[256];
+	struct psb_intel_framebuffer *fbdev_fb;
+	/* a mode_set for fbdev users on this crtc */
+	struct drm_mode_set mode_set;
+
+	/* current bo we scanout from */
+	void *scanout_bo;
+
+	/* current bo we cursor from */
+	void *cursor_bo;
+
+	struct drm_display_mode saved_mode;
+	struct drm_display_mode saved_adjusted_mode;
+
+	struct psb_intel_mode_device *mode_dev;
+
+	/*crtc mode setting flags*/
+	u32 mode_flags;
+
+	/* Saved Crtc HW states */
+	struct psb_intel_crtc_state *crtc_state;
+};
+
+#define to_psb_intel_crtc(x)	\
+		container_of(x, struct psb_intel_crtc, base)
+#define to_psb_intel_output(x)	\
+		container_of(x, struct psb_intel_output, base)
+#define enc_to_psb_intel_output(x)	\
+		container_of(x, struct psb_intel_output, enc)
+#define to_psb_intel_framebuffer(x)	\
+		container_of(x, struct psb_intel_framebuffer, base)
+
+struct psb_intel_i2c_chan *psb_intel_i2c_create(struct drm_device *dev,
+					const u32 reg, const char *name);
+void psb_intel_i2c_destroy(struct psb_intel_i2c_chan *chan);
+int psb_intel_ddc_get_modes(struct psb_intel_output *psb_intel_output);
+extern bool psb_intel_ddc_probe(struct psb_intel_output *psb_intel_output);
+
+extern void psb_intel_crtc_init(struct drm_device *dev, int pipe,
+			    struct psb_intel_mode_device *mode_dev);
+extern void psb_intel_crt_init(struct drm_device *dev);
+extern void psb_intel_sdvo_init(struct drm_device *dev, int output_device);
+extern void psb_intel_dvo_init(struct drm_device *dev);
+extern void psb_intel_tv_init(struct drm_device *dev);
+extern void psb_intel_lvds_init(struct drm_device *dev,
+			    struct psb_intel_mode_device *mode_dev);
+extern void psb_intel_lvds_set_brightness(struct drm_device *dev, int level);
+extern void mrst_lvds_init(struct drm_device *dev,
+			   struct psb_intel_mode_device *mode_dev);
+extern void mrst_wait_for_INTR_PKT_SENT(struct drm_device *dev);
+extern void mrst_dsi_init(struct drm_device *dev,
+			   struct psb_intel_mode_device *mode_dev);
+extern void mid_dsi_init(struct drm_device *dev,
+		    struct psb_intel_mode_device *mode_dev, int dsi_num);
+
+extern void psb_intel_crtc_load_lut(struct drm_crtc *crtc);
+extern void psb_intel_encoder_prepare(struct drm_encoder *encoder);
+extern void psb_intel_encoder_commit(struct drm_encoder *encoder);
+
+extern struct drm_encoder *psb_intel_best_encoder(struct drm_connector
+					      *connector);
+
+extern struct drm_display_mode *psb_intel_crtc_mode_get(struct drm_device *dev,
+						    struct drm_crtc *crtc);
+extern void psb_intel_wait_for_vblank(struct drm_device *dev);
+extern int psb_intel_get_pipe_from_crtc_id(struct drm_device *dev, void *data,
+				struct drm_file *file_priv);
+extern struct drm_crtc *psb_intel_get_crtc_from_pipe(struct drm_device *dev,
+						 int pipe);
+extern struct drm_connector *psb_intel_sdvo_find(struct drm_device *dev,
+					     int sdvoB);
+extern int psb_intel_sdvo_supports_hotplug(struct drm_connector *connector);
+extern void psb_intel_sdvo_set_hotplug(struct drm_connector *connector,
+				   int enable);
+extern int intelfb_probe(struct drm_device *dev);
+extern int intelfb_remove(struct drm_device *dev,
+			  struct drm_framebuffer *fb);
+extern struct drm_framebuffer *psb_intel_framebuffer_create(struct drm_device
+							*dev, struct
+							drm_mode_fb_cmd
+							*mode_cmd,
+							void *mm_private);
+extern bool psb_intel_lvds_mode_fixup(struct drm_encoder *encoder,
+				      struct drm_display_mode *mode,
+				      struct drm_display_mode *adjusted_mode);
+extern int psb_intel_lvds_mode_valid(struct drm_connector *connector,
+				     struct drm_display_mode *mode);
+extern int psb_intel_lvds_set_property(struct drm_connector *connector,
+					struct drm_property *property,
+					uint64_t value);
+extern void psb_intel_lvds_destroy(struct drm_connector *connector);
+extern const struct drm_encoder_funcs psb_intel_lvds_enc_funcs;
+
+#endif				/* __INTEL_DRV_H__ */
diff --git a/drivers/staging/gma500/psb_intel_i2c.c b/drivers/staging/gma500/psb_intel_i2c.c
new file mode 100644
index 0000000..e33432d
--- /dev/null
+++ b/drivers/staging/gma500/psb_intel_i2c.c
@@ -0,0 +1,169 @@
+/*
+ * Copyright © 2006-2007 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors:
+ *	Eric Anholt <eric@anholt.net>
+ */
+
+#include <linux/i2c.h>
+#include <linux/i2c-algo-bit.h>
+
+#include "psb_drv.h"
+#include "psb_intel_reg.h"
+
+/*
+ * Intel GPIO access functions
+ */
+
+#define I2C_RISEFALL_TIME 20
+
+static int get_clock(void *data)
+{
+	struct psb_intel_i2c_chan *chan = data;
+	struct drm_device *dev = chan->drm_dev;
+	u32 val;
+
+	val = REG_READ(chan->reg);
+	return (val & GPIO_CLOCK_VAL_IN) != 0;
+}
+
+static int get_data(void *data)
+{
+	struct psb_intel_i2c_chan *chan = data;
+	struct drm_device *dev = chan->drm_dev;
+	u32 val;
+
+	val = REG_READ(chan->reg);
+	return (val & GPIO_DATA_VAL_IN) != 0;
+}
+
+static void set_clock(void *data, int state_high)
+{
+	struct psb_intel_i2c_chan *chan = data;
+	struct drm_device *dev = chan->drm_dev;
+	u32 reserved = 0, clock_bits;
+
+	/* On most chips, these bits must be preserved in software. */
+	reserved =
+		    REG_READ(chan->reg) & (GPIO_DATA_PULLUP_DISABLE |
+					   GPIO_CLOCK_PULLUP_DISABLE);
+
+	if (state_high)
+		clock_bits = GPIO_CLOCK_DIR_IN | GPIO_CLOCK_DIR_MASK;
+	else
+		clock_bits = GPIO_CLOCK_DIR_OUT | GPIO_CLOCK_DIR_MASK |
+		    GPIO_CLOCK_VAL_MASK;
+	REG_WRITE(chan->reg, reserved | clock_bits);
+	udelay(I2C_RISEFALL_TIME);	/* wait for the line to change state */
+}
+
+static void set_data(void *data, int state_high)
+{
+	struct psb_intel_i2c_chan *chan = data;
+	struct drm_device *dev = chan->drm_dev;
+	u32 reserved = 0, data_bits;
+
+	/* On most chips, these bits must be preserved in software. */
+	reserved =
+		    REG_READ(chan->reg) & (GPIO_DATA_PULLUP_DISABLE |
+					   GPIO_CLOCK_PULLUP_DISABLE);
+
+	if (state_high)
+		data_bits = GPIO_DATA_DIR_IN | GPIO_DATA_DIR_MASK;
+	else
+		data_bits =
+		    GPIO_DATA_DIR_OUT | GPIO_DATA_DIR_MASK |
+		    GPIO_DATA_VAL_MASK;
+
+	REG_WRITE(chan->reg, reserved | data_bits);
+	udelay(I2C_RISEFALL_TIME);	/* wait for the line to change state */
+}
+
+/**
+ * psb_intel_i2c_create - instantiate an Intel i2c bus using the specified GPIO reg
+ * @dev: DRM device
+ * @output: driver specific output device
+ * @reg: GPIO reg to use
+ * @name: name for this bus
+ *
+ * Creates and registers a new i2c bus with the Linux i2c layer, for use
+ * in output probing and control (e.g. DDC or SDVO control functions).
+ *
+ * Possible values for @reg include:
+ *   %GPIOA
+ *   %GPIOB
+ *   %GPIOC
+ *   %GPIOD
+ *   %GPIOE
+ *   %GPIOF
+ *   %GPIOG
+ *   %GPIOH
+ * see PRM for details on how these different busses are used.
+ */
+struct psb_intel_i2c_chan *psb_intel_i2c_create(struct drm_device *dev,
+					const u32 reg, const char *name)
+{
+	struct psb_intel_i2c_chan *chan;
+
+	chan = kzalloc(sizeof(struct psb_intel_i2c_chan), GFP_KERNEL);
+	if (!chan)
+		goto out_free;
+
+	chan->drm_dev = dev;
+	chan->reg = reg;
+	snprintf(chan->adapter.name, I2C_NAME_SIZE, "intel drm %s", name);
+	chan->adapter.owner = THIS_MODULE;
+	chan->adapter.algo_data = &chan->algo;
+	chan->adapter.dev.parent = &dev->pdev->dev;
+	chan->algo.setsda = set_data;
+	chan->algo.setscl = set_clock;
+	chan->algo.getsda = get_data;
+	chan->algo.getscl = get_clock;
+	chan->algo.udelay = 20;
+	chan->algo.timeout = usecs_to_jiffies(2200);
+	chan->algo.data = chan;
+
+	i2c_set_adapdata(&chan->adapter, chan);
+
+	if (i2c_bit_add_bus(&chan->adapter))
+		goto out_free;
+
+	/* JJJ:  raise SCL and SDA? */
+	set_data(chan, 1);
+	set_clock(chan, 1);
+	udelay(20);
+
+	return chan;
+
+out_free:
+	kfree(chan);
+	return NULL;
+}
+
+/**
+ * psb_intel_i2c_destroy - unregister and free i2c bus resources
+ * @output: channel to free
+ *
+ * Unregister the adapter from the i2c layer, then free the structure.
+ */
+void psb_intel_i2c_destroy(struct psb_intel_i2c_chan *chan)
+{
+	if (!chan)
+		return;
+
+	i2c_del_adapter(&chan->adapter);
+	kfree(chan);
+}
diff --git a/drivers/staging/gma500/psb_intel_lvds.c b/drivers/staging/gma500/psb_intel_lvds.c
new file mode 100644
index 0000000..d3d210a
--- /dev/null
+++ b/drivers/staging/gma500/psb_intel_lvds.c
@@ -0,0 +1,889 @@
+/*
+ * Copyright © 2006-2007 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors:
+ *	Eric Anholt <eric@anholt.net>
+ *	Dave Airlie <airlied@linux.ie>
+ *	Jesse Barnes <jesse.barnes@intel.com>
+ */
+
+#include <linux/i2c.h>
+/* #include <drm/drm_crtc.h> */
+/* #include <drm/drm_edid.h> */
+#include <drm/drmP.h>
+
+#include "psb_intel_bios.h"
+#include "psb_drv.h"
+#include "psb_intel_drv.h"
+#include "psb_intel_reg.h"
+#include "psb_powermgmt.h"
+#include <linux/pm_runtime.h>
+
+/* MRST defines start */
+uint8_t blc_freq;
+uint8_t blc_minbrightness;
+uint8_t blc_i2caddr;
+uint8_t blc_brightnesscmd;
+int lvds_backlight;		/* restore backlight to this value */
+
+u32 CoreClock;
+u32 PWMControlRegFreq;
+
+/**
+ * LVDS I2C backlight control macros
+ */
+#define BRIGHTNESS_MAX_LEVEL 100
+#define BRIGHTNESS_MASK 0xFF
+#define BLC_I2C_TYPE	0x01
+#define BLC_PWM_TYPT	0x02
+
+#define BLC_POLARITY_NORMAL 0
+#define BLC_POLARITY_INVERSE 1
+
+#define PSB_BLC_MAX_PWM_REG_FREQ       (0xFFFE)
+#define PSB_BLC_MIN_PWM_REG_FREQ	(0x2)
+#define PSB_BLC_PWM_PRECISION_FACTOR	(10)
+#define PSB_BACKLIGHT_PWM_CTL_SHIFT	(16)
+#define PSB_BACKLIGHT_PWM_POLARITY_BIT_CLEAR (0xFFFE)
+
+struct psb_intel_lvds_priv {
+	/**
+	 * Saved LVDO output states
+	 */
+	uint32_t savePP_ON;
+	uint32_t savePP_OFF;
+	uint32_t saveLVDS;
+	uint32_t savePP_CONTROL;
+	uint32_t savePP_CYCLE;
+	uint32_t savePFIT_CONTROL;
+	uint32_t savePFIT_PGM_RATIOS;
+	uint32_t saveBLC_PWM_CTL;
+};
+
+/* MRST defines end */
+
+/**
+ * Returns the maximum level of the backlight duty cycle field.
+ */
+static u32 psb_intel_lvds_get_max_backlight(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	u32 retVal;
+
+	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+					OSPM_UHB_ONLY_IF_ON)) {
+		retVal = ((REG_READ(BLC_PWM_CTL) &
+			  BACKLIGHT_MODULATION_FREQ_MASK) >>
+			  BACKLIGHT_MODULATION_FREQ_SHIFT) * 2;
+
+		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	} else
+		retVal = ((dev_priv->saveBLC_PWM_CTL &
+			  BACKLIGHT_MODULATION_FREQ_MASK) >>
+			  BACKLIGHT_MODULATION_FREQ_SHIFT) * 2;
+
+	return retVal;
+}
+
+/**
+ * Set LVDS backlight level by I2C command
+ */
+static int psb_lvds_i2c_set_brightness(struct drm_device *dev,
+					unsigned int level)
+{
+	struct drm_psb_private *dev_priv =
+		(struct drm_psb_private *)dev->dev_private;
+
+	struct psb_intel_i2c_chan *lvds_i2c_bus = dev_priv->lvds_i2c_bus;
+	u8 out_buf[2];
+	unsigned int blc_i2c_brightness;
+
+	struct i2c_msg msgs[] = {
+		{
+			.addr = lvds_i2c_bus->slave_addr,
+			.flags = 0,
+			.len = 2,
+			.buf = out_buf,
+		}
+	};
+
+	blc_i2c_brightness = BRIGHTNESS_MASK & ((unsigned int)level *
+			     BRIGHTNESS_MASK /
+			     BRIGHTNESS_MAX_LEVEL);
+
+	if (dev_priv->lvds_bl->pol == BLC_POLARITY_INVERSE)
+		blc_i2c_brightness = BRIGHTNESS_MASK - blc_i2c_brightness;
+
+	out_buf[0] = dev_priv->lvds_bl->brightnesscmd;
+	out_buf[1] = (u8)blc_i2c_brightness;
+
+	if (i2c_transfer(&lvds_i2c_bus->adapter, msgs, 1) == 1) {
+		DRM_DEBUG("I2C set brightness.(command, value) (%d, %d)\n",
+			blc_brightnesscmd,
+			blc_i2c_brightness);
+		return 0;
+	}
+
+	DRM_ERROR("I2C transfer error\n");
+	return -1;
+}
+
+
+static int psb_lvds_pwm_set_brightness(struct drm_device *dev, int level)
+{
+	struct drm_psb_private *dev_priv =
+			(struct drm_psb_private *)dev->dev_private;
+
+	u32 max_pwm_blc;
+	u32 blc_pwm_duty_cycle;
+
+	max_pwm_blc = psb_intel_lvds_get_max_backlight(dev);
+
+	/*BLC_PWM_CTL Should be initiated while backlight device init*/
+	BUG_ON((max_pwm_blc & PSB_BLC_MAX_PWM_REG_FREQ) == 0);
+
+	blc_pwm_duty_cycle = level * max_pwm_blc / BRIGHTNESS_MAX_LEVEL;
+
+	if (dev_priv->lvds_bl->pol == BLC_POLARITY_INVERSE)
+		blc_pwm_duty_cycle = max_pwm_blc - blc_pwm_duty_cycle;
+
+	blc_pwm_duty_cycle &= PSB_BACKLIGHT_PWM_POLARITY_BIT_CLEAR;
+	REG_WRITE(BLC_PWM_CTL,
+		  (max_pwm_blc << PSB_BACKLIGHT_PWM_CTL_SHIFT) |
+		  (blc_pwm_duty_cycle));
+
+	return 0;
+}
+
+/**
+ * Set LVDS backlight level either by I2C or PWM
+ */
+void psb_intel_lvds_set_brightness(struct drm_device *dev, int level)
+{
+	/*u32 blc_pwm_ctl;*/
+	struct drm_psb_private *dev_priv =
+			(struct drm_psb_private *)dev->dev_private;
+
+	DRM_DEBUG("backlight level is %d\n", level);
+
+	if (!dev_priv->lvds_bl) {
+		DRM_ERROR("NO LVDS Backlight Info\n");
+		return;
+	}
+
+	if (dev_priv->lvds_bl->type == BLC_I2C_TYPE)
+		psb_lvds_i2c_set_brightness(dev, level);
+	else
+		psb_lvds_pwm_set_brightness(dev, level);
+}
+
+/**
+ * Sets the backlight level.
+ *
+ * \param level backlight level, from 0 to psb_intel_lvds_get_max_backlight().
+ */
+static void psb_intel_lvds_set_backlight(struct drm_device *dev, int level)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	u32 blc_pwm_ctl;
+
+	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+					OSPM_UHB_ONLY_IF_ON)) {
+		blc_pwm_ctl =
+			REG_READ(BLC_PWM_CTL) & ~BACKLIGHT_DUTY_CYCLE_MASK;
+		REG_WRITE(BLC_PWM_CTL,
+				(blc_pwm_ctl |
+				(level << BACKLIGHT_DUTY_CYCLE_SHIFT)));
+		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	} else {
+		blc_pwm_ctl = dev_priv->saveBLC_PWM_CTL &
+				~BACKLIGHT_DUTY_CYCLE_MASK;
+		dev_priv->saveBLC_PWM_CTL = (blc_pwm_ctl |
+					(level << BACKLIGHT_DUTY_CYCLE_SHIFT));
+	}
+}
+
+/**
+ * Sets the power state for the panel.
+ */
+static void psb_intel_lvds_set_power(struct drm_device *dev,
+				 struct psb_intel_output *output, bool on)
+{
+	u32 pp_status;
+
+	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+					OSPM_UHB_FORCE_POWER_ON))
+		return;
+
+	if (on) {
+		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) |
+			  POWER_TARGET_ON);
+		do {
+			pp_status = REG_READ(PP_STATUS);
+		} while ((pp_status & PP_ON) == 0);
+
+		psb_intel_lvds_set_backlight(dev,
+					 output->
+					 mode_dev->backlight_duty_cycle);
+	} else {
+		psb_intel_lvds_set_backlight(dev, 0);
+
+		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) &
+			  ~POWER_TARGET_ON);
+		do {
+			pp_status = REG_READ(PP_STATUS);
+		} while (pp_status & PP_ON);
+	}
+
+	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+}
+
+static void psb_intel_lvds_encoder_dpms(struct drm_encoder *encoder, int mode)
+{
+	struct drm_device *dev = encoder->dev;
+	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
+
+	if (mode == DRM_MODE_DPMS_ON)
+		psb_intel_lvds_set_power(dev, output, true);
+	else
+		psb_intel_lvds_set_power(dev, output, false);
+
+	/* XXX: We never power down the LVDS pairs. */
+}
+
+static void psb_intel_lvds_save(struct drm_connector *connector)
+{
+	struct drm_device *dev = connector->dev;
+	struct drm_psb_private *dev_priv =
+		(struct drm_psb_private *)dev->dev_private;
+	struct psb_intel_output *psb_intel_output =
+		to_psb_intel_output(connector);
+	struct psb_intel_lvds_priv *lvds_priv =
+		(struct psb_intel_lvds_priv *)psb_intel_output->dev_priv;
+
+	lvds_priv->savePP_ON = REG_READ(LVDSPP_ON);
+	lvds_priv->savePP_OFF = REG_READ(LVDSPP_OFF);
+	lvds_priv->saveLVDS = REG_READ(LVDS);
+	lvds_priv->savePP_CONTROL = REG_READ(PP_CONTROL);
+	lvds_priv->savePP_CYCLE = REG_READ(PP_CYCLE);
+	/*lvds_priv->savePP_DIVISOR = REG_READ(PP_DIVISOR);*/
+	lvds_priv->saveBLC_PWM_CTL = REG_READ(BLC_PWM_CTL);
+	lvds_priv->savePFIT_CONTROL = REG_READ(PFIT_CONTROL);
+	lvds_priv->savePFIT_PGM_RATIOS = REG_READ(PFIT_PGM_RATIOS);
+
+	/*TODO: move backlight_duty_cycle to psb_intel_lvds_priv*/
+	dev_priv->backlight_duty_cycle = (dev_priv->saveBLC_PWM_CTL &
+						BACKLIGHT_DUTY_CYCLE_MASK);
+
+	/*
+	 * If the light is off at server startup,
+	 * just make it full brightness
+	 */
+	if (dev_priv->backlight_duty_cycle == 0)
+		dev_priv->backlight_duty_cycle =
+		psb_intel_lvds_get_max_backlight(dev);
+
+	DRM_DEBUG("(0x%x, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x)\n",
+			lvds_priv->savePP_ON,
+			lvds_priv->savePP_OFF,
+			lvds_priv->saveLVDS,
+			lvds_priv->savePP_CONTROL,
+			lvds_priv->savePP_CYCLE,
+			lvds_priv->saveBLC_PWM_CTL);
+}
+
+static void psb_intel_lvds_restore(struct drm_connector *connector)
+{
+	struct drm_device *dev = connector->dev;
+	u32 pp_status;
+
+	/*struct drm_psb_private *dev_priv =
+				(struct drm_psb_private *)dev->dev_private;*/
+	struct psb_intel_output *psb_intel_output =
+					to_psb_intel_output(connector);
+	struct psb_intel_lvds_priv *lvds_priv =
+		(struct psb_intel_lvds_priv *)psb_intel_output->dev_priv;
+
+	DRM_DEBUG("(0x%x, 0x%x, 0x%x, 0x%x, 0x%x, 0x%x)\n",
+			lvds_priv->savePP_ON,
+			lvds_priv->savePP_OFF,
+			lvds_priv->saveLVDS,
+			lvds_priv->savePP_CONTROL,
+			lvds_priv->savePP_CYCLE,
+			lvds_priv->saveBLC_PWM_CTL);
+
+	REG_WRITE(BLC_PWM_CTL, lvds_priv->saveBLC_PWM_CTL);
+	REG_WRITE(PFIT_CONTROL, lvds_priv->savePFIT_CONTROL);
+	REG_WRITE(PFIT_PGM_RATIOS, lvds_priv->savePFIT_PGM_RATIOS);
+	REG_WRITE(LVDSPP_ON, lvds_priv->savePP_ON);
+	REG_WRITE(LVDSPP_OFF, lvds_priv->savePP_OFF);
+	/*REG_WRITE(PP_DIVISOR, lvds_priv->savePP_DIVISOR);*/
+	REG_WRITE(PP_CYCLE, lvds_priv->savePP_CYCLE);
+	REG_WRITE(PP_CONTROL, lvds_priv->savePP_CONTROL);
+	REG_WRITE(LVDS, lvds_priv->saveLVDS);
+
+	if (lvds_priv->savePP_CONTROL & POWER_TARGET_ON) {
+		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) |
+			POWER_TARGET_ON);
+		do {
+			pp_status = REG_READ(PP_STATUS);
+		} while ((pp_status & PP_ON) == 0);
+	} else {
+		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) &
+			~POWER_TARGET_ON);
+		do {
+			pp_status = REG_READ(PP_STATUS);
+		} while (pp_status & PP_ON);
+	}
+}
+
+int psb_intel_lvds_mode_valid(struct drm_connector *connector,
+				 struct drm_display_mode *mode)
+{
+	struct psb_intel_output *psb_intel_output =
+				to_psb_intel_output(connector);
+	struct drm_display_mode *fixed_mode =
+	    psb_intel_output->mode_dev->panel_fixed_mode;
+
+	PSB_DEBUG_ENTRY("\n");
+
+	if (psb_intel_output->type == INTEL_OUTPUT_MIPI2)
+		fixed_mode = psb_intel_output->mode_dev->panel_fixed_mode2;
+
+	/* just in case */
+	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
+		return MODE_NO_DBLESCAN;
+
+	/* just in case */
+	if (mode->flags & DRM_MODE_FLAG_INTERLACE)
+		return MODE_NO_INTERLACE;
+
+	if (fixed_mode) {
+		if (mode->hdisplay > fixed_mode->hdisplay)
+			return MODE_PANEL;
+		if (mode->vdisplay > fixed_mode->vdisplay)
+			return MODE_PANEL;
+	}
+	return MODE_OK;
+}
+
+bool psb_intel_lvds_mode_fixup(struct drm_encoder *encoder,
+				  struct drm_display_mode *mode,
+				  struct drm_display_mode *adjusted_mode)
+{
+	struct psb_intel_mode_device *mode_dev =
+	    enc_to_psb_intel_output(encoder)->mode_dev;
+	struct drm_device *dev = encoder->dev;
+	struct psb_intel_crtc *psb_intel_crtc =
+				to_psb_intel_crtc(encoder->crtc);
+	struct drm_encoder *tmp_encoder;
+	struct drm_display_mode *panel_fixed_mode = mode_dev->panel_fixed_mode;
+	struct psb_intel_output *psb_intel_output =
+					enc_to_psb_intel_output(encoder);
+
+	PSB_DEBUG_ENTRY("type = 0x%x, pipe = %d.\n",
+			psb_intel_output->type, psb_intel_crtc->pipe);
+
+	if (psb_intel_output->type == INTEL_OUTPUT_MIPI2)
+		panel_fixed_mode = mode_dev->panel_fixed_mode2;
+
+	/* PSB doesn't appear to be GEN4 */
+	if (psb_intel_crtc->pipe == 0) {
+		printk(KERN_ERR "Can't support LVDS on pipe A\n");
+		return false;
+	}
+	/* Should never happen!! */
+	list_for_each_entry(tmp_encoder, &dev->mode_config.encoder_list,
+			    head) {
+		if (tmp_encoder != encoder
+		    && tmp_encoder->crtc == encoder->crtc) {
+			printk(KERN_ERR "Can't enable LVDS and another "
+			       "encoder on the same pipe\n");
+			return false;
+		}
+	}
+
+	/*
+	 * If we have timings from the BIOS for the panel, put them in
+	 * to the adjusted mode.  The CRTC will be set up for this mode,
+	 * with the panel scaling set up to source from the H/VDisplay
+	 * of the original mode.
+	 */
+	if (panel_fixed_mode != NULL) {
+		adjusted_mode->hdisplay = panel_fixed_mode->hdisplay;
+		adjusted_mode->hsync_start = panel_fixed_mode->hsync_start;
+		adjusted_mode->hsync_end = panel_fixed_mode->hsync_end;
+		adjusted_mode->htotal = panel_fixed_mode->htotal;
+		adjusted_mode->vdisplay = panel_fixed_mode->vdisplay;
+		adjusted_mode->vsync_start = panel_fixed_mode->vsync_start;
+		adjusted_mode->vsync_end = panel_fixed_mode->vsync_end;
+		adjusted_mode->vtotal = panel_fixed_mode->vtotal;
+		adjusted_mode->clock = panel_fixed_mode->clock;
+		drm_mode_set_crtcinfo(adjusted_mode,
+				      CRTC_INTERLACE_HALVE_V);
+	}
+
+	/*
+	 * XXX: It would be nice to support lower refresh rates on the
+	 * panels to reduce power consumption, and perhaps match the
+	 * user's requested refresh rate.
+	 */
+
+	return true;
+}
+
+static void psb_intel_lvds_prepare(struct drm_encoder *encoder)
+{
+	struct drm_device *dev = encoder->dev;
+	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
+	struct psb_intel_mode_device *mode_dev = output->mode_dev;
+
+	PSB_DEBUG_ENTRY("\n");
+
+	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+					OSPM_UHB_FORCE_POWER_ON))
+		return;
+
+	mode_dev->saveBLC_PWM_CTL = REG_READ(BLC_PWM_CTL);
+	mode_dev->backlight_duty_cycle = (mode_dev->saveBLC_PWM_CTL &
+					  BACKLIGHT_DUTY_CYCLE_MASK);
+
+	psb_intel_lvds_set_power(dev, output, false);
+
+	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+}
+
+static void psb_intel_lvds_commit(struct drm_encoder *encoder)
+{
+	struct drm_device *dev = encoder->dev;
+	struct psb_intel_output *output = enc_to_psb_intel_output(encoder);
+	struct psb_intel_mode_device *mode_dev = output->mode_dev;
+
+	PSB_DEBUG_ENTRY("\n");
+
+	if (mode_dev->backlight_duty_cycle == 0)
+		mode_dev->backlight_duty_cycle =
+		    psb_intel_lvds_get_max_backlight(dev);
+
+	psb_intel_lvds_set_power(dev, output, true);
+}
+
+static void psb_intel_lvds_mode_set(struct drm_encoder *encoder,
+				struct drm_display_mode *mode,
+				struct drm_display_mode *adjusted_mode)
+{
+	struct psb_intel_mode_device *mode_dev =
+	    enc_to_psb_intel_output(encoder)->mode_dev;
+	struct drm_device *dev = encoder->dev;
+	u32 pfit_control;
+
+	/*
+	 * The LVDS pin pair will already have been turned on in the
+	 * psb_intel_crtc_mode_set since it has a large impact on the DPLL
+	 * settings.
+	 */
+
+	/*
+	 * Enable automatic panel scaling so that non-native modes fill the
+	 * screen.  Should be enabled before the pipe is enabled, according to
+	 * register description and PRM.
+	 */
+	if (mode->hdisplay != adjusted_mode->hdisplay ||
+	    mode->vdisplay != adjusted_mode->vdisplay)
+		pfit_control = (PFIT_ENABLE | VERT_AUTO_SCALE |
+				HORIZ_AUTO_SCALE | VERT_INTERP_BILINEAR |
+				HORIZ_INTERP_BILINEAR);
+	else
+		pfit_control = 0;
+
+	if (mode_dev->panel_wants_dither)
+		pfit_control |= PANEL_8TO6_DITHER_ENABLE;
+
+	REG_WRITE(PFIT_CONTROL, pfit_control);
+}
+
+/**
+ * Detect the LVDS connection.
+ *
+ * This always returns CONNECTOR_STATUS_CONNECTED.
+ * This connector should only have
+ * been set up if the LVDS was actually connected anyway.
+ */
+static enum drm_connector_status psb_intel_lvds_detect(struct drm_connector
+						   *connector, bool force)
+{
+	return connector_status_connected;
+}
+
+/**
+ * Return the list of DDC modes if available, or the BIOS fixed mode otherwise.
+ */
+static int psb_intel_lvds_get_modes(struct drm_connector *connector)
+{
+	struct drm_device *dev = connector->dev;
+	struct psb_intel_output *psb_intel_output =
+					to_psb_intel_output(connector);
+	struct psb_intel_mode_device *mode_dev =
+					psb_intel_output->mode_dev;
+	int ret = 0;
+
+	ret = psb_intel_ddc_get_modes(psb_intel_output);
+
+	if (ret)
+		return ret;
+
+	/* Didn't get an EDID, so
+	 * Set wide sync ranges so we get all modes
+	 * handed to valid_mode for checking
+	 */
+	connector->display_info.min_vfreq = 0;
+	connector->display_info.max_vfreq = 200;
+	connector->display_info.min_hfreq = 0;
+	connector->display_info.max_hfreq = 200;
+
+	if (mode_dev->panel_fixed_mode != NULL) {
+		struct drm_display_mode *mode =
+		    drm_mode_duplicate(dev, mode_dev->panel_fixed_mode);
+		drm_mode_probed_add(connector, mode);
+		return 1;
+	}
+
+	return 0;
+}
+
+/**
+ * psb_intel_lvds_destroy - unregister and free LVDS structures
+ * @connector: connector to free
+ *
+ * Unregister the DDC bus for this connector then free the driver private
+ * structure.
+ */
+void psb_intel_lvds_destroy(struct drm_connector *connector)
+{
+	struct psb_intel_output *psb_intel_output =
+					to_psb_intel_output(connector);
+
+	if (psb_intel_output->ddc_bus)
+		psb_intel_i2c_destroy(psb_intel_output->ddc_bus);
+	drm_sysfs_connector_remove(connector);
+	drm_connector_cleanup(connector);
+	kfree(connector);
+}
+
+int psb_intel_lvds_set_property(struct drm_connector *connector,
+				       struct drm_property *property,
+				       uint64_t value)
+{
+	struct drm_encoder *pEncoder = connector->encoder;
+
+	PSB_DEBUG_ENTRY("\n");
+
+	if (!strcmp(property->name, "scaling mode") && pEncoder) {
+		struct psb_intel_crtc *pPsbCrtc =
+					to_psb_intel_crtc(pEncoder->crtc);
+		uint64_t curValue;
+
+		PSB_DEBUG_ENTRY("scaling mode\n");
+
+		if (!pPsbCrtc)
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
+		if (drm_connector_property_get_value(connector,
+						     property,
+						     &curValue))
+			goto set_prop_error;
+
+		if (curValue == value)
+			goto set_prop_done;
+
+		if (drm_connector_property_set_value(connector,
+							property,
+							value))
+			goto set_prop_error;
+
+		if (pPsbCrtc->saved_mode.hdisplay != 0 &&
+		    pPsbCrtc->saved_mode.vdisplay != 0) {
+			if (!drm_crtc_helper_set_mode(pEncoder->crtc,
+						      &pPsbCrtc->saved_mode,
+						      pEncoder->crtc->x,
+						      pEncoder->crtc->y,
+						      pEncoder->crtc->fb))
+				goto set_prop_error;
+		}
+	} else if (!strcmp(property->name, "backlight") && pEncoder) {
+		PSB_DEBUG_ENTRY("backlight\n");
+
+		if (drm_connector_property_set_value(connector,
+							property,
+							value))
+			goto set_prop_error;
+		else {
+#ifdef CONFIG_BACKLIGHT_CLASS_DEVICE
+			struct backlight_device bd;
+			bd.props.brightness = value;
+			psb_set_brightness(&bd);
+#endif
+		}
+	} else if (!strcmp(property->name, "DPMS") && pEncoder) {
+		struct drm_encoder_helper_funcs *pEncHFuncs
+						= pEncoder->helper_private;
+		PSB_DEBUG_ENTRY("DPMS\n");
+		pEncHFuncs->dpms(pEncoder, value);
+	}
+
+set_prop_done:
+	return 0;
+set_prop_error:
+	return -1;
+}
+
+static const struct drm_encoder_helper_funcs psb_intel_lvds_helper_funcs = {
+	.dpms = psb_intel_lvds_encoder_dpms,
+	.mode_fixup = psb_intel_lvds_mode_fixup,
+	.prepare = psb_intel_lvds_prepare,
+	.mode_set = psb_intel_lvds_mode_set,
+	.commit = psb_intel_lvds_commit,
+};
+
+static const struct drm_connector_helper_funcs
+				psb_intel_lvds_connector_helper_funcs = {
+	.get_modes = psb_intel_lvds_get_modes,
+	.mode_valid = psb_intel_lvds_mode_valid,
+	.best_encoder = psb_intel_best_encoder,
+};
+
+static const struct drm_connector_funcs psb_intel_lvds_connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.save = psb_intel_lvds_save,
+	.restore = psb_intel_lvds_restore,
+	.detect = psb_intel_lvds_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.set_property = psb_intel_lvds_set_property,
+	.destroy = psb_intel_lvds_destroy,
+};
+
+
+static void psb_intel_lvds_enc_destroy(struct drm_encoder *encoder)
+{
+	drm_encoder_cleanup(encoder);
+}
+
+const struct drm_encoder_funcs psb_intel_lvds_enc_funcs = {
+	.destroy = psb_intel_lvds_enc_destroy,
+};
+
+
+
+/**
+ * psb_intel_lvds_init - setup LVDS connectors on this device
+ * @dev: drm device
+ *
+ * Create the connector, register the LVDS DDC bus, and try to figure out what
+ * modes we can display on the LVDS panel (if present).
+ */
+void psb_intel_lvds_init(struct drm_device *dev,
+		     struct psb_intel_mode_device *mode_dev)
+{
+	struct psb_intel_output *psb_intel_output;
+	struct psb_intel_lvds_priv *lvds_priv;
+	struct drm_connector *connector;
+	struct drm_encoder *encoder;
+	struct drm_display_mode *scan;	/* *modes, *bios_mode; */
+	struct drm_crtc *crtc;
+	struct drm_psb_private *dev_priv =
+				(struct drm_psb_private *)dev->dev_private;
+	u32 lvds;
+	int pipe;
+
+	psb_intel_output = kzalloc(sizeof(struct psb_intel_output), GFP_KERNEL);
+	if (!psb_intel_output)
+		return;
+
+	lvds_priv = kzalloc(sizeof(struct psb_intel_lvds_priv), GFP_KERNEL);
+	if (!lvds_priv) {
+		kfree(psb_intel_output);
+		DRM_DEBUG("LVDS private allocation error\n");
+		return;
+	}
+
+	psb_intel_output->dev_priv = lvds_priv;
+
+	psb_intel_output->mode_dev = mode_dev;
+	connector = &psb_intel_output->base;
+	encoder = &psb_intel_output->enc;
+	drm_connector_init(dev, &psb_intel_output->base,
+			   &psb_intel_lvds_connector_funcs,
+			   DRM_MODE_CONNECTOR_LVDS);
+
+	drm_encoder_init(dev, &psb_intel_output->enc,
+			 &psb_intel_lvds_enc_funcs,
+			 DRM_MODE_ENCODER_LVDS);
+
+	drm_mode_connector_attach_encoder(&psb_intel_output->base,
+					  &psb_intel_output->enc);
+	psb_intel_output->type = INTEL_OUTPUT_LVDS;
+
+	drm_encoder_helper_add(encoder, &psb_intel_lvds_helper_funcs);
+	drm_connector_helper_add(connector,
+				 &psb_intel_lvds_connector_helper_funcs);
+	connector->display_info.subpixel_order = SubPixelHorizontalRGB;
+	connector->interlace_allowed = false;
+	connector->doublescan_allowed = false;
+
+	/*Attach connector properties*/
+	drm_connector_attach_property(connector,
+				      dev->mode_config.scaling_mode_property,
+				      DRM_MODE_SCALE_FULLSCREEN);
+	drm_connector_attach_property(connector,
+				      dev_priv->backlight_property,
+				      BRIGHTNESS_MAX_LEVEL);
+
+	/**
+	 * Set up I2C bus
+	 * FIXME: distroy i2c_bus when exit
+	 */
+	psb_intel_output->i2c_bus = psb_intel_i2c_create(dev,
+							 GPIOB,
+							 "LVDSBLC_B");
+	if (!psb_intel_output->i2c_bus) {
+		dev_printk(KERN_ERR,
+			&dev->pdev->dev, "I2C bus registration failed.\n");
+		goto failed_blc_i2c;
+	}
+	psb_intel_output->i2c_bus->slave_addr = 0x2C;
+	dev_priv->lvds_i2c_bus =  psb_intel_output->i2c_bus;
+
+	/*
+	 * LVDS discovery:
+	 * 1) check for EDID on DDC
+	 * 2) check for VBT data
+	 * 3) check to see if LVDS is already on
+	 *    if none of the above, no panel
+	 * 4) make sure lid is open
+	 *    if closed, act like it's not there for now
+	 */
+
+	/* Set up the DDC bus. */
+	psb_intel_output->ddc_bus = psb_intel_i2c_create(dev,
+							 GPIOC,
+							 "LVDSDDC_C");
+	if (!psb_intel_output->ddc_bus) {
+		dev_printk(KERN_ERR, &dev->pdev->dev,
+			   "DDC bus registration " "failed.\n");
+		goto failed_ddc;
+	}
+
+	/*
+	 * Attempt to get the fixed panel mode from DDC.  Assume that the
+	 * preferred mode is the right one.
+	 */
+	psb_intel_ddc_get_modes(psb_intel_output);
+	list_for_each_entry(scan, &connector->probed_modes, head) {
+		if (scan->type & DRM_MODE_TYPE_PREFERRED) {
+			mode_dev->panel_fixed_mode =
+			    drm_mode_duplicate(dev, scan);
+			goto out;	/* FIXME: check for quirks */
+		}
+	}
+
+	/* Failed to get EDID, what about VBT? do we need this?*/
+	if (mode_dev->vbt_mode)
+		mode_dev->panel_fixed_mode =
+		    drm_mode_duplicate(dev, mode_dev->vbt_mode);
+
+	if (!mode_dev->panel_fixed_mode)
+		if (dev_priv->lfp_lvds_vbt_mode)
+			mode_dev->panel_fixed_mode =
+				drm_mode_duplicate(dev,
+					dev_priv->lfp_lvds_vbt_mode);
+
+	/*
+	 * If we didn't get EDID, try checking if the panel is already turned
+	 * on.	If so, assume that whatever is currently programmed is the
+	 * correct mode.
+	 */
+	lvds = REG_READ(LVDS);
+	pipe = (lvds & LVDS_PIPEB_SELECT) ? 1 : 0;
+	crtc = psb_intel_get_crtc_from_pipe(dev, pipe);
+
+	if (crtc && (lvds & LVDS_PORT_EN)) {
+		mode_dev->panel_fixed_mode =
+		    psb_intel_crtc_mode_get(dev, crtc);
+		if (mode_dev->panel_fixed_mode) {
+			mode_dev->panel_fixed_mode->type |=
+			    DRM_MODE_TYPE_PREFERRED;
+			goto out;	/* FIXME: check for quirks */
+		}
+	}
+
+	/* If we still don't have a mode after all that, give up. */
+	if (!mode_dev->panel_fixed_mode) {
+		DRM_DEBUG
+			("Found no modes on the lvds, ignoring the LVDS\n");
+		goto failed_find;
+	}
+
+	/*
+	 * Blacklist machines with BIOSes that list an LVDS panel without
+	 * actually having one.
+	 */
+out:
+	drm_sysfs_connector_add(connector);
+
+	PSB_DEBUG_ENTRY("hdisplay = %d\n",
+		 mode_dev->panel_fixed_mode->hdisplay);
+	PSB_DEBUG_ENTRY(" vdisplay = %d\n",
+		 mode_dev->panel_fixed_mode->vdisplay);
+	PSB_DEBUG_ENTRY(" hsync_start = %d\n",
+		 mode_dev->panel_fixed_mode->hsync_start);
+	PSB_DEBUG_ENTRY(" hsync_end = %d\n",
+		 mode_dev->panel_fixed_mode->hsync_end);
+	PSB_DEBUG_ENTRY(" htotal = %d\n",
+		 mode_dev->panel_fixed_mode->htotal);
+	PSB_DEBUG_ENTRY(" vsync_start = %d\n",
+		 mode_dev->panel_fixed_mode->vsync_start);
+	PSB_DEBUG_ENTRY(" vsync_end = %d\n",
+		 mode_dev->panel_fixed_mode->vsync_end);
+	PSB_DEBUG_ENTRY(" vtotal = %d\n",
+		 mode_dev->panel_fixed_mode->vtotal);
+	PSB_DEBUG_ENTRY(" clock = %d\n",
+		 mode_dev->panel_fixed_mode->clock);
+
+	return;
+
+failed_find:
+	if (psb_intel_output->ddc_bus)
+		psb_intel_i2c_destroy(psb_intel_output->ddc_bus);
+failed_ddc:
+	if (psb_intel_output->i2c_bus)
+		psb_intel_i2c_destroy(psb_intel_output->i2c_bus);
+failed_blc_i2c:
+	drm_encoder_cleanup(encoder);
+	drm_connector_cleanup(connector);
+	kfree(connector);
+}
+
diff --git a/drivers/staging/gma500/psb_intel_modes.c b/drivers/staging/gma500/psb_intel_modes.c
new file mode 100644
index 0000000..bde1aff
--- /dev/null
+++ b/drivers/staging/gma500/psb_intel_modes.c
@@ -0,0 +1,77 @@
+/*
+ * Copyright (c) 2007 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authers: Jesse Barnes <jesse.barnes@intel.com>
+ */
+
+#include <linux/i2c.h>
+#include <linux/fb.h>
+#include <drm/drmP.h>
+#include "psb_intel_drv.h"
+
+/**
+ * psb_intel_ddc_probe
+ *
+ */
+bool psb_intel_ddc_probe(struct psb_intel_output *psb_intel_output)
+{
+	u8 out_buf[] = { 0x0, 0x0 };
+	u8 buf[2];
+	int ret;
+	struct i2c_msg msgs[] = {
+		{
+		 .addr = 0x50,
+		 .flags = 0,
+		 .len = 1,
+		 .buf = out_buf,
+		 },
+		{
+		 .addr = 0x50,
+		 .flags = I2C_M_RD,
+		 .len = 1,
+		 .buf = buf,
+		 }
+	};
+
+	ret = i2c_transfer(&psb_intel_output->ddc_bus->adapter, msgs, 2);
+	if (ret == 2)
+		return true;
+
+	return false;
+}
+
+/**
+ * psb_intel_ddc_get_modes - get modelist from monitor
+ * @connector: DRM connector device to use
+ *
+ * Fetch the EDID information from @connector using the DDC bus.
+ */
+int psb_intel_ddc_get_modes(struct psb_intel_output *psb_intel_output)
+{
+	struct edid *edid;
+	int ret = 0;
+
+	edid =
+	    drm_get_edid(&psb_intel_output->base,
+			 &psb_intel_output->ddc_bus->adapter);
+	if (edid) {
+		drm_mode_connector_update_edid_property(&psb_intel_output->
+							base, edid);
+		ret = drm_add_edid_modes(&psb_intel_output->base, edid);
+		kfree(edid);
+	}
+	return ret;
+}
diff --git a/drivers/staging/gma500/psb_intel_opregion.c b/drivers/staging/gma500/psb_intel_opregion.c
new file mode 100644
index 0000000..65e3e9b
--- /dev/null
+++ b/drivers/staging/gma500/psb_intel_opregion.c
@@ -0,0 +1,78 @@
+/*
+ * Copyright 2010 Intel Corporation
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
+ */
+
+#include "psb_drv.h"
+
+struct opregion_header {
+	u8 signature[16];
+	u32 size;
+	u32 opregion_ver;
+	u8 bios_ver[32];
+	u8 vbios_ver[16];
+	u8 driver_ver[16];
+	u32 mboxes;
+	u8 reserved[164];
+} __attribute__((packed));
+
+struct opregion_apci {
+	/*FIXME: add it later*/
+} __attribute__((packed));
+
+struct opregion_swsci {
+	/*FIXME: add it later*/
+} __attribute__((packed));
+
+struct opregion_acpi {
+	/*FIXME: add it later*/
+} __attribute__((packed));
+
+int psb_intel_opregion_init(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	/*struct psb_intel_opregion * opregion = &dev_priv->opregion;*/
+	u32 opregion_phy;
+	void *base;
+	u32 *lid_state;
+
+	dev_priv->lid_state = NULL;
+
+	pci_read_config_dword(dev->pdev, 0xfc, &opregion_phy);
+	if (opregion_phy == 0) {
+		DRM_DEBUG("Opregion not supported, won't support lid-switch\n");
+		return -ENOTSUPP;
+	}
+	DRM_DEBUG("OpRegion detected at 0x%8x\n", opregion_phy);
+
+	base = ioremap(opregion_phy, 8*1024);
+	if (!base)
+		return -ENOMEM;
+
+	lid_state = base + 0x01ac;
+
+	DRM_DEBUG("Lid switch state 0x%08x\n", *lid_state);
+
+	dev_priv->lid_state = lid_state;
+	dev_priv->lid_last_state = *lid_state;
+	return 0;
+}
diff --git a/drivers/staging/gma500/psb_intel_reg.h b/drivers/staging/gma500/psb_intel_reg.h
new file mode 100644
index 0000000..6cae118
--- /dev/null
+++ b/drivers/staging/gma500/psb_intel_reg.h
@@ -0,0 +1,1200 @@
+/*
+ * Copyright (c) 2009, Intel Corporation.
+ * 
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+#ifndef __PSB_INTEL_REG_H__
+#define __PSB_INTEL_REG_H__
+
+#define BLC_PWM_CTL		0x61254
+#define BLC_PWM_CTL2		0x61250
+#define BLC_PWM_CTL_C		0x62254
+#define BLC_PWM_CTL2_C		0x62250
+#define BACKLIGHT_MODULATION_FREQ_SHIFT		(17)
+/**
+ * This is the most significant 15 bits of the number of backlight cycles in a
+ * complete cycle of the modulated backlight control.
+ *
+ * The actual value is this field multiplied by two.
+ */
+#define BACKLIGHT_MODULATION_FREQ_MASK		(0x7fff << 17)
+#define BLM_LEGACY_MODE				(1 << 16)
+/**
+ * This is the number of cycles out of the backlight modulation cycle for which
+ * the backlight is on.
+ *
+ * This field must be no greater than the number of cycles in the complete
+ * backlight modulation cycle.
+ */
+#define BACKLIGHT_DUTY_CYCLE_SHIFT		(0)
+#define BACKLIGHT_DUTY_CYCLE_MASK		(0xffff)
+
+#define I915_GCFGC			0xf0
+#define I915_LOW_FREQUENCY_ENABLE		(1 << 7)
+#define I915_DISPLAY_CLOCK_190_200_MHZ		(0 << 4)
+#define I915_DISPLAY_CLOCK_333_MHZ		(4 << 4)
+#define I915_DISPLAY_CLOCK_MASK			(7 << 4)
+
+#define I855_HPLLCC			0xc0
+#define I855_CLOCK_CONTROL_MASK			(3 << 0)
+#define I855_CLOCK_133_200			(0 << 0)
+#define I855_CLOCK_100_200			(1 << 0)
+#define I855_CLOCK_100_133			(2 << 0)
+#define I855_CLOCK_166_250			(3 << 0)
+
+/* I830 CRTC registers */
+#define HTOTAL_A	0x60000
+#define HBLANK_A	0x60004
+#define HSYNC_A 	0x60008
+#define VTOTAL_A	0x6000c
+#define VBLANK_A	0x60010
+#define VSYNC_A 	0x60014
+#define PIPEASRC	0x6001c
+#define BCLRPAT_A	0x60020
+#define VSYNCSHIFT_A	0x60028
+
+#define HTOTAL_B	0x61000
+#define HBLANK_B	0x61004
+#define HSYNC_B 	0x61008
+#define VTOTAL_B	0x6100c
+#define VBLANK_B	0x61010
+#define VSYNC_B 	0x61014
+#define PIPEBSRC	0x6101c
+#define BCLRPAT_B	0x61020
+#define VSYNCSHIFT_B	0x61028
+
+#define HTOTAL_C	0x62000
+#define HBLANK_C	0x62004
+#define HSYNC_C 	0x62008
+#define VTOTAL_C	0x6200c
+#define VBLANK_C	0x62010
+#define VSYNC_C 	0x62014
+#define PIPECSRC	0x6201c
+#define BCLRPAT_C	0x62020
+#define VSYNCSHIFT_C	0x62028
+
+#define PP_STATUS	0x61200
+# define PP_ON					(1 << 31)
+/**
+ * Indicates that all dependencies of the panel are on:
+ *
+ * - PLL enabled
+ * - pipe enabled
+ * - LVDS/DVOB/DVOC on
+ */
+# define PP_READY				(1 << 30)
+# define PP_SEQUENCE_NONE			(0 << 28)
+# define PP_SEQUENCE_ON				(1 << 28)
+# define PP_SEQUENCE_OFF			(2 << 28)
+# define PP_SEQUENCE_MASK			0x30000000
+#define PP_CONTROL	0x61204
+# define POWER_TARGET_ON			(1 << 0)
+
+#define LVDSPP_ON       0x61208
+#define LVDSPP_OFF      0x6120c
+#define PP_CYCLE        0x61210
+
+#define PFIT_CONTROL	0x61230
+# define PFIT_ENABLE				(1 << 31)
+# define PFIT_PIPE_MASK				(3 << 29)
+# define PFIT_PIPE_SHIFT			29
+# define PFIT_SCALING_MODE_PILLARBOX            (1 << 27)
+# define PFIT_SCALING_MODE_LETTERBOX            (3 << 26)
+# define VERT_INTERP_DISABLE			(0 << 10)
+# define VERT_INTERP_BILINEAR			(1 << 10)
+# define VERT_INTERP_MASK			(3 << 10)
+# define VERT_AUTO_SCALE			(1 << 9)
+# define HORIZ_INTERP_DISABLE			(0 << 6)
+# define HORIZ_INTERP_BILINEAR			(1 << 6)
+# define HORIZ_INTERP_MASK			(3 << 6)
+# define HORIZ_AUTO_SCALE			(1 << 5)
+# define PANEL_8TO6_DITHER_ENABLE		(1 << 3)
+
+#define PFIT_PGM_RATIOS	0x61234
+# define PFIT_VERT_SCALE_MASK			0xfff00000
+# define PFIT_HORIZ_SCALE_MASK			0x0000fff0
+
+#define PFIT_AUTO_RATIOS	0x61238
+
+
+#define DPLL_A		0x06014
+#define DPLL_B		0x06018
+# define DPLL_VCO_ENABLE			(1 << 31)
+# define DPLL_DVO_HIGH_SPEED			(1 << 30)
+# define DPLL_SYNCLOCK_ENABLE			(1 << 29)
+# define DPLL_VGA_MODE_DIS			(1 << 28)
+# define DPLLB_MODE_DAC_SERIAL			(1 << 26)	/* i915 */
+# define DPLLB_MODE_LVDS			(2 << 26)	/* i915 */
+# define DPLL_MODE_MASK				(3 << 26)
+# define DPLL_DAC_SERIAL_P2_CLOCK_DIV_10	(0 << 24)	/* i915 */
+# define DPLL_DAC_SERIAL_P2_CLOCK_DIV_5		(1 << 24)	/* i915 */
+# define DPLLB_LVDS_P2_CLOCK_DIV_14		(0 << 24)	/* i915 */
+# define DPLLB_LVDS_P2_CLOCK_DIV_7		(1 << 24)	/* i915 */
+# define DPLL_P2_CLOCK_DIV_MASK			0x03000000	/* i915 */
+# define DPLL_FPA01_P1_POST_DIV_MASK		0x00ff0000	/* i915 */
+/**
+ *  The i830 generation, in DAC/serial mode, defines p1 as two plus this
+ * bitfield, or just 2 if PLL_P1_DIVIDE_BY_TWO is set.
+ */
+# define DPLL_FPA01_P1_POST_DIV_MASK_I830	0x001f0000
+/**
+ * The i830 generation, in LVDS mode, defines P1 as the bit number set within
+ * this field (only one bit may be set).
+ */
+# define DPLL_FPA01_P1_POST_DIV_MASK_I830_LVDS	0x003f0000
+# define DPLL_FPA01_P1_POST_DIV_SHIFT		16
+# define PLL_P2_DIVIDE_BY_4		(1 << 23)	/* i830, required
+							 * in DVO non-gang */
+# define PLL_P1_DIVIDE_BY_TWO			(1 << 21)	/* i830 */
+# define PLL_REF_INPUT_DREFCLK			(0 << 13)
+# define PLL_REF_INPUT_TVCLKINA			(1 << 13)	/* i830 */
+# define PLL_REF_INPUT_TVCLKINBC		(2 << 13)	/* SDVO
+								 * TVCLKIN */
+# define PLLB_REF_INPUT_SPREADSPECTRUMIN	(3 << 13)
+# define PLL_REF_INPUT_MASK			(3 << 13)
+# define PLL_LOAD_PULSE_PHASE_SHIFT		9
+/*
+ * Parallel to Serial Load Pulse phase selection.
+ * Selects the phase for the 10X DPLL clock for the PCIe
+ * digital display port. The range is 4 to 13; 10 or more
+ * is just a flip delay. The default is 6
+ */
+# define PLL_LOAD_PULSE_PHASE_MASK	(0xf << PLL_LOAD_PULSE_PHASE_SHIFT)
+# define DISPLAY_RATE_SELECT_FPA1	(1 << 8)
+
+/**
+ * SDVO multiplier for 945G/GM. Not used on 965.
+ *
+ * \sa DPLL_MD_UDI_MULTIPLIER_MASK
+ */
+# define SDVO_MULTIPLIER_MASK			0x000000ff
+# define SDVO_MULTIPLIER_SHIFT_HIRES		4
+# define SDVO_MULTIPLIER_SHIFT_VGA		0
+
+/** @defgroup DPLL_MD
+ * @{
+ */
+/** Pipe A SDVO/UDI clock multiplier/divider register for G965. */
+#define DPLL_A_MD		0x0601c
+/** Pipe B SDVO/UDI clock multiplier/divider register for G965. */
+#define DPLL_B_MD		0x06020
+/**
+ * UDI pixel divider, controlling how many pixels are stuffed into a packet.
+ *
+ * Value is pixels minus 1.  Must be set to 1 pixel for SDVO.
+ */
+# define DPLL_MD_UDI_DIVIDER_MASK		0x3f000000
+# define DPLL_MD_UDI_DIVIDER_SHIFT		24
+/** UDI pixel divider for VGA, same as DPLL_MD_UDI_DIVIDER_MASK. */
+# define DPLL_MD_VGA_UDI_DIVIDER_MASK		0x003f0000
+# define DPLL_MD_VGA_UDI_DIVIDER_SHIFT		16
+/**
+ * SDVO/UDI pixel multiplier.
+ *
+ * SDVO requires that the bus clock rate be between 1 and 2 Ghz, and the bus
+ * clock rate is 10 times the DPLL clock.  At low resolution/refresh rate
+ * modes, the bus rate would be below the limits, so SDVO allows for stuffing
+ * dummy bytes in the datastream at an increased clock rate, with both sides of
+ * the link knowing how many bytes are fill.
+ *
+ * So, for a mode with a dotclock of 65Mhz, we would want to double the clock
+ * rate to 130Mhz to get a bus rate of 1.30Ghz.  The DPLL clock rate would be
+ * set to 130Mhz, and the SDVO multiplier set to 2x in this register and
+ * through an SDVO command.
+ *
+ * This register field has values of multiplication factor minus 1, with
+ * a maximum multiplier of 5 for SDVO.
+ */
+# define DPLL_MD_UDI_MULTIPLIER_MASK		0x00003f00
+# define DPLL_MD_UDI_MULTIPLIER_SHIFT		8
+/** SDVO/UDI pixel multiplier for VGA, same as DPLL_MD_UDI_MULTIPLIER_MASK.
+ * This best be set to the default value (3) or the CRT won't work. No,
+ * I don't entirely understand what this does...
+ */
+# define DPLL_MD_VGA_UDI_MULTIPLIER_MASK	0x0000003f
+# define DPLL_MD_VGA_UDI_MULTIPLIER_SHIFT	0
+/** @} */
+
+#define DPLL_TEST		0x606c
+# define DPLLB_TEST_SDVO_DIV_1			(0 << 22)
+# define DPLLB_TEST_SDVO_DIV_2			(1 << 22)
+# define DPLLB_TEST_SDVO_DIV_4			(2 << 22)
+# define DPLLB_TEST_SDVO_DIV_MASK		(3 << 22)
+# define DPLLB_TEST_N_BYPASS			(1 << 19)
+# define DPLLB_TEST_M_BYPASS			(1 << 18)
+# define DPLLB_INPUT_BUFFER_ENABLE		(1 << 16)
+# define DPLLA_TEST_N_BYPASS			(1 << 3)
+# define DPLLA_TEST_M_BYPASS			(1 << 2)
+# define DPLLA_INPUT_BUFFER_ENABLE		(1 << 0)
+
+#define ADPA			0x61100
+#define ADPA_DAC_ENABLE 	(1<<31)
+#define ADPA_DAC_DISABLE	0
+#define ADPA_PIPE_SELECT_MASK	(1<<30)
+#define ADPA_PIPE_A_SELECT	0
+#define ADPA_PIPE_B_SELECT	(1<<30)
+#define ADPA_USE_VGA_HVPOLARITY (1<<15)
+#define ADPA_SETS_HVPOLARITY	0
+#define ADPA_VSYNC_CNTL_DISABLE (1<<11)
+#define ADPA_VSYNC_CNTL_ENABLE	0
+#define ADPA_HSYNC_CNTL_DISABLE (1<<10)
+#define ADPA_HSYNC_CNTL_ENABLE	0
+#define ADPA_VSYNC_ACTIVE_HIGH	(1<<4)
+#define ADPA_VSYNC_ACTIVE_LOW	0
+#define ADPA_HSYNC_ACTIVE_HIGH	(1<<3)
+#define ADPA_HSYNC_ACTIVE_LOW	0
+
+#define FPA0		0x06040
+#define FPA1		0x06044
+#define FPB0		0x06048
+#define FPB1		0x0604c
+# define FP_N_DIV_MASK				0x003f0000
+# define FP_N_DIV_SHIFT				16
+# define FP_M1_DIV_MASK				0x00003f00
+# define FP_M1_DIV_SHIFT			8
+# define FP_M2_DIV_MASK				0x0000003f
+# define FP_M2_DIV_SHIFT			0
+
+
+#define PORT_HOTPLUG_EN		0x61110
+# define SDVOB_HOTPLUG_INT_EN			(1 << 26)
+# define SDVOC_HOTPLUG_INT_EN			(1 << 25)
+# define TV_HOTPLUG_INT_EN			(1 << 18)
+# define CRT_HOTPLUG_INT_EN			(1 << 9)
+# define CRT_HOTPLUG_FORCE_DETECT		(1 << 3)
+
+#define PORT_HOTPLUG_STAT	0x61114
+# define CRT_HOTPLUG_INT_STATUS			(1 << 11)
+# define TV_HOTPLUG_INT_STATUS			(1 << 10)
+# define CRT_HOTPLUG_MONITOR_MASK		(3 << 8)
+# define CRT_HOTPLUG_MONITOR_COLOR		(3 << 8)
+# define CRT_HOTPLUG_MONITOR_MONO		(2 << 8)
+# define CRT_HOTPLUG_MONITOR_NONE		(0 << 8)
+# define SDVOC_HOTPLUG_INT_STATUS		(1 << 7)
+# define SDVOB_HOTPLUG_INT_STATUS		(1 << 6)
+
+#define SDVOB			0x61140
+#define SDVOC			0x61160
+#define SDVO_ENABLE				(1 << 31)
+#define SDVO_PIPE_B_SELECT			(1 << 30)
+#define SDVO_STALL_SELECT			(1 << 29)
+#define SDVO_INTERRUPT_ENABLE			(1 << 26)
+/**
+ * 915G/GM SDVO pixel multiplier.
+ *
+ * Programmed value is multiplier - 1, up to 5x.
+ *
+ * \sa DPLL_MD_UDI_MULTIPLIER_MASK
+ */
+#define SDVO_PORT_MULTIPLY_MASK			(7 << 23)
+#define SDVO_PORT_MULTIPLY_SHIFT		23
+#define SDVO_PHASE_SELECT_MASK			(15 << 19)
+#define SDVO_PHASE_SELECT_DEFAULT		(6 << 19)
+#define SDVO_CLOCK_OUTPUT_INVERT		(1 << 18)
+#define SDVOC_GANG_MODE				(1 << 16)
+#define SDVO_BORDER_ENABLE			(1 << 7)
+#define SDVOB_PCIE_CONCURRENCY			(1 << 3)
+#define SDVO_DETECTED				(1 << 2)
+/* Bits to be preserved when writing */
+#define SDVOB_PRESERVE_MASK		((1 << 17) | (1 << 16) | (1 << 14))
+#define SDVOC_PRESERVE_MASK			(1 << 17)
+
+/** @defgroup LVDS
+ * @{
+ */
+/**
+ * This register controls the LVDS output enable, pipe selection, and data
+ * format selection.
+ *
+ * All of the clock/data pairs are force powered down by power sequencing.
+ */
+#define LVDS			0x61180
+/**
+ * Enables the LVDS port.  This bit must be set before DPLLs are enabled, as
+ * the DPLL semantics change when the LVDS is assigned to that pipe.
+ */
+# define LVDS_PORT_EN			(1 << 31)
+/** Selects pipe B for LVDS data.  Must be set on pre-965. */
+# define LVDS_PIPEB_SELECT		(1 << 30)
+
+/** Turns on border drawing to allow centered display. */
+# define LVDS_BORDER_EN                 (1 << 15)
+
+/**
+ * Enables the A0-A2 data pairs and CLKA, containing 18 bits of color data per
+ * pixel.
+ */
+# define LVDS_A0A2_CLKA_POWER_MASK	(3 << 8)
+# define LVDS_A0A2_CLKA_POWER_DOWN	(0 << 8)
+# define LVDS_A0A2_CLKA_POWER_UP	(3 << 8)
+/**
+ * Controls the A3 data pair, which contains the additional LSBs for 24 bit
+ * mode.  Only enabled if LVDS_A0A2_CLKA_POWER_UP also indicates it should be
+ * on.
+ */
+# define LVDS_A3_POWER_MASK		(3 << 6)
+# define LVDS_A3_POWER_DOWN		(0 << 6)
+# define LVDS_A3_POWER_UP		(3 << 6)
+/**
+ * Controls the CLKB pair.  This should only be set when LVDS_B0B3_POWER_UP
+ * is set.
+ */
+# define LVDS_CLKB_POWER_MASK		(3 << 4)
+# define LVDS_CLKB_POWER_DOWN		(0 << 4)
+# define LVDS_CLKB_POWER_UP		(3 << 4)
+
+/**
+ * Controls the B0-B3 data pairs.  This must be set to match the DPLL p2
+ * setting for whether we are in dual-channel mode.  The B3 pair will
+ * additionally only be powered up when LVDS_A3_POWER_UP is set.
+ */
+# define LVDS_B0B3_POWER_MASK		(3 << 2)
+# define LVDS_B0B3_POWER_DOWN		(0 << 2)
+# define LVDS_B0B3_POWER_UP		(3 << 2)
+
+#define PIPEACONF 0x70008
+#define PIPEACONF_ENABLE	(1<<31)
+#define PIPEACONF_DISABLE	0
+#define PIPEACONF_DOUBLE_WIDE	(1<<30)
+#define PIPECONF_ACTIVE		(1<<30)
+#define I965_PIPECONF_ACTIVE	(1<<30)
+#define PIPECONF_DSIPLL_LOCK	(1<<29)
+#define PIPEACONF_SINGLE_WIDE	0
+#define PIPEACONF_PIPE_UNLOCKED 0
+#define PIPEACONF_DSR		(1<<26)
+#define PIPEACONF_PIPE_LOCKED	(1<<25)
+#define PIPEACONF_PALETTE	0
+#define PIPECONF_FORCE_BORDER	(1<<25)
+#define PIPEACONF_GAMMA 	(1<<24)
+#define PIPECONF_PROGRESSIVE	(0 << 21)
+#define PIPECONF_INTERLACE_W_FIELD_INDICATION	(6 << 21)
+#define PIPECONF_INTERLACE_FIELD_0_ONLY		(7 << 21)
+#define PIPECONF_PLANE_OFF 	(1<<19)
+#define PIPECONF_CURSOR_OFF 	(1<<18)
+
+
+#define PIPEBCONF 0x71008
+#define PIPEBCONF_ENABLE	(1<<31)
+#define PIPEBCONF_DISABLE	0
+#define PIPEBCONF_DOUBLE_WIDE	(1<<30)
+#define PIPEBCONF_DISABLE	0
+#define PIPEBCONF_GAMMA 	(1<<24)
+#define PIPEBCONF_PALETTE	0
+
+#define PIPECCONF 0x72008
+
+#define PIPEBGCMAXRED		0x71010
+#define PIPEBGCMAXGREEN		0x71014
+#define PIPEBGCMAXBLUE		0x71018
+
+#define PIPEASTAT               0x70024
+#define PIPEBSTAT		0x71024
+#define PIPECSTAT		0x72024
+#define PIPE_VBLANK_INTERRUPT_STATUS         (1UL<<1)
+#define PIPE_START_VBLANK_INTERRUPT_STATUS   (1UL<<2)
+#define PIPE_VBLANK_CLEAR                    (1 << 1)
+#define PIPE_VBLANK_STATUS                   (1 << 1)
+#define PIPE_TE_STATUS		             (1UL<<6)
+#define PIPE_DPST_EVENT_STATUS		     (1UL<<7)
+#define PIPE_VSYNC_CLEAR                     (1UL<<9)
+#define PIPE_VSYNC_STATUS                    (1UL<<9)
+#define PIPE_HDMI_AUDIO_UNDERRUN_STATUS      (1UL<<10)
+#define PIPE_HDMI_AUDIO_BUFFER_DONE_STATUS   (1UL<<11)
+#define PIPE_VBLANK_INTERRUPT_ENABLE         (1UL<<17)
+#define PIPE_START_VBLANK_INTERRUPT_ENABLE   (1UL<<18)
+#define PIPE_TE_ENABLE		             (1UL<<22)
+#define PIPE_DPST_EVENT_ENABLE               (1UL<<23)
+#define PIPE_VSYNC_ENABL                     (1UL<<25)
+#define PIPE_HDMI_AUDIO_UNDERRUN             (1UL<<26)
+#define PIPE_HDMI_AUDIO_BUFFER_DONE          (1UL<<27)
+#define PIPE_HDMI_AUDIO_INT_MASK (PIPE_HDMI_AUDIO_UNDERRUN | PIPE_HDMI_AUDIO_BUFFER_DONE)
+#define PIPE_EVENT_MASK (BIT29|BIT28|BIT27|BIT26|BIT24|BIT23|BIT22|BIT21|BIT20|BIT16)
+#define PIPE_VBLANK_MASK (BIT25|BIT24|BIT18|BIT17)
+#define HISTOGRAM_INT_CONTROL		0x61268
+#define HISTOGRAM_BIN_DATA		0X61264
+#define HISTOGRAM_LOGIC_CONTROL		0x61260
+#define PWM_CONTROL_LOGIC		0x61250
+#define PIPE_HOTPLUG_INTERRUPT_STATUS	(1UL<<10)
+#define HISTOGRAM_INTERRUPT_ENABLE	(1UL<<31)
+#define HISTOGRAM_LOGIC_ENABLE		(1UL<<31)
+#define PWM_LOGIC_ENABLE		(1UL<<31)
+#define PWM_PHASEIN_ENABLE		(1UL<<25)
+#define PWM_PHASEIN_INT_ENABLE		(1UL<<24)
+#define PWM_PHASEIN_VB_COUNT		0x00001f00
+#define PWM_PHASEIN_INC			0x0000001f
+#define HISTOGRAM_INT_CTRL_CLEAR	(1UL<<30)
+#define DPST_YUV_LUMA_MODE		0
+
+struct dpst_ie_histogram_control {
+	union {
+		uint32_t data;
+		struct {
+			uint32_t bin_reg_index:7;
+			uint32_t reserved:4;
+			uint32_t bin_reg_func_select:1;
+			uint32_t sync_to_phase_in:1;
+			uint32_t alt_enhancement_mode:2;
+			uint32_t reserved1:1;
+			uint32_t sync_to_phase_in_count:8;
+			uint32_t histogram_mode_select:1;
+			uint32_t reserved2:4;
+			uint32_t ie_pipe_assignment:1;
+			uint32_t ie_mode_table_enabled:1;
+			uint32_t ie_histogram_enable:1;
+		};
+	};
+};
+
+struct dpst_guardband {
+	union {
+		uint32_t data;
+		struct {
+			uint32_t guardband:22;
+			uint32_t guardband_interrupt_delay:8;
+			uint32_t interrupt_status:1;
+			uint32_t interrupt_enable:1;
+		};
+	};
+};
+
+#define PIPEAFRAMEHIGH		0x70040
+#define PIPEAFRAMEPIXEL		0x70044
+#define PIPEBFRAMEHIGH		0x71040
+#define PIPEBFRAMEPIXEL		0x71044
+#define PIPECFRAMEHIGH		0x72040
+#define PIPECFRAMEPIXEL		0x72044
+#define PIPE_FRAME_HIGH_MASK    0x0000ffff
+#define PIPE_FRAME_HIGH_SHIFT   0
+#define PIPE_FRAME_LOW_MASK     0xff000000
+#define PIPE_FRAME_LOW_SHIFT    24
+#define PIPE_PIXEL_MASK         0x00ffffff
+#define PIPE_PIXEL_SHIFT        0
+
+#define DSPARB			0x70030
+#define DSPFW1			0x70034
+#define DSPFW2			0x70038
+#define DSPFW3			0x7003c
+#define DSPFW4			0x70050
+#define DSPFW5			0x70054
+#define DSPFW6			0x70058
+#define DSPCHICKENBIT		0x70400
+#define DSPACNTR		0x70180
+#define DSPBCNTR		0x71180
+#define DSPCCNTR		0x72180
+#define DISPLAY_PLANE_ENABLE 			(1<<31)
+#define DISPLAY_PLANE_DISABLE			0
+#define DISPPLANE_GAMMA_ENABLE			(1<<30)
+#define DISPPLANE_GAMMA_DISABLE			0
+#define DISPPLANE_PIXFORMAT_MASK		(0xf<<26)
+#define DISPPLANE_8BPP				(0x2<<26)
+#define DISPPLANE_15_16BPP			(0x4<<26)
+#define DISPPLANE_16BPP				(0x5<<26)
+#define DISPPLANE_32BPP_NO_ALPHA 		(0x6<<26)
+#define DISPPLANE_32BPP				(0x7<<26)
+#define DISPPLANE_STEREO_ENABLE			(1<<25)
+#define DISPPLANE_STEREO_DISABLE		0
+#define DISPPLANE_SEL_PIPE_MASK			(1<<24)
+#define DISPPLANE_SEL_PIPE_POS			24
+#define DISPPLANE_SEL_PIPE_A			0
+#define DISPPLANE_SEL_PIPE_B			(1<<24)
+#define DISPPLANE_SRC_KEY_ENABLE		(1<<22)
+#define DISPPLANE_SRC_KEY_DISABLE		0
+#define DISPPLANE_LINE_DOUBLE			(1<<20)
+#define DISPPLANE_NO_LINE_DOUBLE		0
+#define DISPPLANE_STEREO_POLARITY_FIRST		0
+#define DISPPLANE_STEREO_POLARITY_SECOND	(1<<18)
+/* plane B only */
+#define DISPPLANE_ALPHA_TRANS_ENABLE		(1<<15)
+#define DISPPLANE_ALPHA_TRANS_DISABLE		0
+#define DISPPLANE_SPRITE_ABOVE_DISPLAYA		0
+#define DISPPLANE_SPRITE_ABOVE_OVERLAY		(1)
+#define DISPPLANE_BOTTOM			(4)
+
+#define DSPABASE		0x70184
+#define DSPALINOFF		0x70184
+#define DSPASTRIDE		0x70188
+
+#define DSPBBASE		0x71184
+#define DSPBLINOFF		0X71184
+#define DSPBADDR		DSPBBASE
+#define DSPBSTRIDE		0x71188
+
+#define DSPCBASE		0x72184
+#define DSPCLINOFF		0x72184
+#define DSPCSTRIDE		0x72188
+
+#define DSPAKEYVAL		0x70194
+#define DSPAKEYMASK		0x70198
+
+#define DSPAPOS			0x7018C	/* reserved */
+#define DSPASIZE		0x70190
+#define DSPBPOS			0x7118C
+#define DSPBSIZE		0x71190
+#define DSPCPOS			0x7218C
+#define DSPCSIZE		0x72190
+
+#define DSPASURF		0x7019C
+#define DSPATILEOFF		0x701A4
+
+#define DSPBSURF		0x7119C
+#define DSPBTILEOFF		0x711A4
+
+#define DSPCSURF		0x7219C
+#define DSPCTILEOFF		0x721A4
+#define DSPCKEYMAXVAL 		0x721A0
+#define DSPCKEYMINVAL 		0x72194
+#define DSPCKEYMSK 		0x72198
+
+#define VGACNTRL		0x71400
+# define VGA_DISP_DISABLE			(1 << 31)
+# define VGA_2X_MODE				(1 << 30)
+# define VGA_PIPE_B_SELECT			(1 << 29)
+
+/*
+ * Overlay registers
+ */
+#define OV_C_OFFSET		0x08000
+#define OV_OVADD		0x30000
+#define OV_DOVASTA              0x30008
+# define OV_PIPE_SELECT				(BIT6|BIT7)
+# define OV_PIPE_SELECT_POS			6
+# define OV_PIPE_A				0
+# define OV_PIPE_C				1
+#define OV_OGAMC5		0x30010
+#define OV_OGAMC4		0x30014
+#define OV_OGAMC3		0x30018
+#define OV_OGAMC2		0x3001C
+#define OV_OGAMC1		0x30020
+#define OV_OGAMC0		0x30024
+#define OVC_OVADD		0x38000
+#define OVC_DOVCSTA             0x38008
+#define OVC_OGAMC5		0x38010
+#define OVC_OGAMC4		0x38014
+#define OVC_OGAMC3		0x38018
+#define OVC_OGAMC2		0x3801C
+#define OVC_OGAMC1		0x38020
+#define OVC_OGAMC0		0x38024
+
+/*
+ * Some BIOS scratch area registers.  The 845 (and 830?) store the amount
+ * of video memory available to the BIOS in SWF1.
+ */ 
+#define SWF0			0x71410
+#define SWF1			0x71414
+#define SWF2			0x71418
+#define SWF3			0x7141c
+#define SWF4			0x71420
+#define SWF5			0x71424
+#define SWF6			0x71428
+
+/*
+ * 855 scratch registers.
+ */
+#define SWF00			0x70410
+#define SWF01			0x70414
+#define SWF02			0x70418
+#define SWF03			0x7041c
+#define SWF04			0x70420
+#define SWF05			0x70424
+#define SWF06			0x70428
+
+#define SWF10			SWF0
+#define SWF11			SWF1
+#define SWF12			SWF2
+#define SWF13			SWF3
+#define SWF14			SWF4
+#define SWF15			SWF5
+#define SWF16			SWF6
+
+#define SWF30			0x72414
+#define SWF31			0x72418
+#define SWF32			0x7241c
+
+
+/*
+ * Palette registers
+ */
+#define PALETTE_A		0x0a000
+#define PALETTE_B		0x0a800
+#define PALETTE_C		0x0ac00
+
+#define IS_I830(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82830_CGC)
+#define IS_845G(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82845G_IG)
+#define IS_I85X(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82855GM_IG)
+#define IS_I855(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82855GM_IG)
+#define IS_I865G(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82865_IG)
+
+
+/* || dev->pci_device == PCI_DEVICE_ID_INTELPCI_CHIP_E7221_G) */
+#define IS_I915G(dev) (dev->pci_device == PCI_DEVICE_ID_INTEL_82915G_IG)
+#define IS_I915GM(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82915GM_IG)
+#define IS_I945G(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82945G_IG)
+#define IS_I945GM(dev) ((dev)->pci_device == PCI_DEVICE_ID_INTEL_82945GM_IG)
+
+#define IS_I965G(dev) ((dev)->pci_device == 0x2972 || \
+		       (dev)->pci_device == 0x2982 || \
+		       (dev)->pci_device == 0x2992 || \
+		       (dev)->pci_device == 0x29A2 || \
+		       (dev)->pci_device == 0x2A02 || \
+		       (dev)->pci_device == 0x2A12)
+
+#define IS_I965GM(dev) ((dev)->pci_device == 0x2A02)
+
+#define IS_G33(dev)    ((dev)->pci_device == 0x29C2 ||	\
+			(dev)->pci_device == 0x29B2 ||	\
+			(dev)->pci_device == 0x29D2)
+
+#define IS_I9XX(dev) (IS_I915G(dev) || IS_I915GM(dev) || IS_I945G(dev) || \
+		      IS_I945GM(dev) || IS_I965G(dev) || IS_POULSBO(dev) || \
+		      IS_MRST(dev))
+
+#define IS_MOBILE(dev) (IS_I830(dev) || IS_I85X(dev) || IS_I915GM(dev) || \
+			IS_I945GM(dev) || IS_I965GM(dev) || \
+			IS_POULSBO(dev) || IS_MRST(dev))
+
+/* Cursor A & B regs */
+#define CURACNTR		0x70080
+#define   CURSOR_MODE_DISABLE   0x00
+#define   CURSOR_MODE_64_32B_AX 0x07
+#define   CURSOR_MODE_64_ARGB_AX ((1 << 5) | CURSOR_MODE_64_32B_AX)
+#define   MCURSOR_GAMMA_ENABLE  (1 << 26)
+#define CURABASE		0x70084
+#define CURAPOS			0x70088
+#define   CURSOR_POS_MASK       0x007FF
+#define   CURSOR_POS_SIGN       0x8000
+#define   CURSOR_X_SHIFT        0
+#define   CURSOR_Y_SHIFT        16
+#define CURBCNTR		0x700c0
+#define CURBBASE		0x700c4
+#define CURBPOS			0x700c8
+#define CURCCNTR		0x700e0
+#define CURCBASE		0x700e4
+#define CURCPOS			0x700e8
+
+/*
+ * Interrupt Registers
+ */
+#define IER 0x020a0
+#define IIR 0x020a4
+#define IMR 0x020a8
+#define ISR 0x020ac
+
+/*
+ * MOORESTOWN delta registers
+ */
+#define MRST_DPLL_A		0x0f014
+#define MDFLD_DPLL_B		0x0f018
+#define MDFLD_INPUT_REF_SEL	(1 << 14) 
+#define MDFLD_VCO_SEL		(1 << 16) 
+#define DPLLA_MODE_LVDS		(2 << 26)	/* mrst */
+#define MDFLD_PLL_LATCHEN	(1 << 28) 
+#define MDFLD_PWR_GATE_EN	(1 << 30) 
+#define MDFLD_P1_MASK		(0x1FF << 17) 
+#define MRST_FPA0		0x0f040
+#define MRST_FPA1		0x0f044
+#define MDFLD_DPLL_DIV0		0x0f048
+#define MDFLD_DPLL_DIV1		0x0f04c
+#define MRST_PERF_MODE		0x020f4
+
+/* MEDFIELD HDMI registers */
+#define HDMIPHYMISCCTL   	0x61134
+# define HDMI_PHY_POWER_DOWN	0x7f
+#define HDMIB_CONTROL   	0x61140
+# define HDMIB_PORT_EN			(1 << 31)
+# define HDMIB_PIPE_B_SELECT		(1 << 30)
+# define HDMIB_NULL_PACKET		(1 << 9)
+#define HDMIB_HDCP_PORT (1 << 5)
+
+/* #define LVDS			0x61180 */
+# define MRST_PANEL_8TO6_DITHER_ENABLE		(1 << 25)
+# define MRST_PANEL_24_DOT_1_FORMAT		(1 << 24)
+# define LVDS_A3_POWER_UP_0_OUTPUT		(1 << 6)
+
+#define MIPI			0x61190
+#define MIPI_C			0x62190
+# define MIPI_PORT_EN			(1 << 31)
+/** Turns on border drawing to allow centered display. */
+# define SEL_FLOPPED_HSTX		(1 << 23)
+# define PASS_FROM_SPHY_TO_AFE 		(1 << 16)
+# define MIPI_BORDER_EN			(1 << 15)
+# define MIPIA_3LANE_MIPIC_1LANE	0x1
+# define MIPIA_2LANE_MIPIC_2LANE	0x2
+# define TE_TRIGGER_DSI_PROTOCOL	(1 << 2)
+# define TE_TRIGGER_GPIO_PIN		(1 << 3)
+#define MIPI_TE_COUNT			0x61194
+
+/* #define PP_CONTROL	0x61204 */
+# define POWER_DOWN_ON_RESET		(1 << 1)
+
+/* #define PFIT_CONTROL	0x61230 */
+# define PFIT_PIPE_SELECT				(3 << 29)
+# define PFIT_PIPE_SELECT_SHIFT			(29)
+
+/* #define BLC_PWM_CTL		0x61254 */
+#define MRST_BACKLIGHT_MODULATION_FREQ_SHIFT		(16)
+#define MRST_BACKLIGHT_MODULATION_FREQ_MASK		(0xffff << 16)
+
+/* #define PIPEACONF 0x70008 */
+#define PIPEACONF_PIPE_STATE	(1<<30)
+/* #define DSPACNTR		0x70180 */
+
+#define MRST_DSPABASE		0x7019c
+#define MRST_DSPBBASE		0x7119c
+#define MDFLD_DSPCBASE		0x7219c
+
+/*
+ * Moorestown registers.
+ */
+/*===========================================================================
+; General Constants
+;--------------------------------------------------------------------------*/
+#define BIT0  0x00000001
+#define BIT1  0x00000002
+#define BIT2  0x00000004
+#define BIT3  0x00000008
+#define BIT4  0x00000010
+#define BIT5  0x00000020
+#define BIT6  0x00000040
+#define BIT7  0x00000080
+#define BIT8  0x00000100
+#define BIT9  0x00000200
+#define BIT10 0x00000400
+#define BIT11 0x00000800
+#define BIT12 0x00001000
+#define BIT13 0x00002000
+#define BIT14 0x00004000
+#define BIT15 0x00008000
+#define BIT16 0x00010000
+#define BIT17 0x00020000
+#define BIT18 0x00040000
+#define BIT19 0x00080000
+#define BIT20 0x00100000
+#define BIT21 0x00200000
+#define BIT22 0x00400000
+#define BIT23 0x00800000
+#define BIT24 0x01000000
+#define BIT25 0x02000000
+#define BIT26 0x04000000
+#define BIT27 0x08000000
+#define BIT28 0x10000000
+#define BIT29 0x20000000
+#define BIT30 0x40000000
+#define BIT31 0x80000000
+/*===========================================================================
+; MIPI IP registers
+;--------------------------------------------------------------------------*/
+#define MIPIC_REG_OFFSET             0x800
+#define DEVICE_READY_REG             0xb000
+#define LP_OUTPUT_HOLD               BIT16
+#define EXIT_ULPS_DEV_READY          0x3
+#define LP_OUTPUT_HOLD_RELEASE       0x810000
+# define ENTERING_ULPS		(2 << 1)
+# define EXITING_ULPS		(1 << 1)
+# define ULPS_MASK		(3 << 1)
+# define BUS_POSSESSION		(1 << 3)
+#define INTR_STAT_REG                0xb004
+#define RX_SOT_ERROR BIT0
+#define RX_SOT_SYNC_ERROR BIT1
+#define RX_ESCAPE_MODE_ENTRY_ERROR BIT3
+#define RX_LP_TX_SYNC_ERROR BIT4
+#define RX_HS_RECEIVE_TIMEOUT_ERROR BIT5
+#define RX_FALSE_CONTROL_ERROR BIT6
+#define RX_ECC_SINGLE_BIT_ERROR BIT7
+#define RX_ECC_MULTI_BIT_ERROR BIT8
+#define RX_CHECKSUM_ERROR BIT9
+#define RX_DSI_DATA_TYPE_NOT_RECOGNIZED BIT10
+#define RX_DSI_VC_ID_INVALID BIT11
+#define TX_FALSE_CONTROL_ERROR BIT12
+#define TX_ECC_SINGLE_BIT_ERROR BIT13
+#define TX_ECC_MULTI_BIT_ERROR BIT14
+#define TX_CHECKSUM_ERROR BIT15
+#define TX_DSI_DATA_TYPE_NOT_RECOGNIZED BIT16
+#define TX_DSI_VC_ID_INVALID BIT17
+#define HIGH_CONTENTION BIT18
+#define LOW_CONTENTION BIT19
+#define DPI_FIFO_UNDER_RUN BIT20
+#define HS_TX_TIMEOUT BIT21
+#define LP_RX_TIMEOUT BIT22
+#define TURN_AROUND_ACK_TIMEOUT BIT23
+#define ACK_WITH_NO_ERROR BIT24
+#define HS_GENERIC_WR_FIFO_FULL BIT27
+#define LP_GENERIC_WR_FIFO_FULL BIT28
+#define SPL_PKT_SENT			BIT30
+#define INTR_EN_REG                  0xb008
+#define DSI_FUNC_PRG_REG             0xb00c
+#define DPI_CHANNEL_NUMBER_POS   0x03
+#define DBI_CHANNEL_NUMBER_POS   0x05
+#define FMT_DPI_POS              0x07
+#define FMT_DBI_POS              0x0A
+#define DBI_DATA_WIDTH_POS       0x0D
+/* DPI PIXEL FORMATS */
+#define RGB_565_FMT		     0x01	/* RGB 565 FORMAT */
+#define RGB_666_FMT		     0x02	/* RGB 666 FORMAT */
+#define LRGB_666_FMT		     0x03	/* RGB LOOSELY PACKED
+						 * 666 FORMAT
+						 */
+#define RGB_888_FMT		     0x04	/* RGB 888 FORMAT */
+#define VIRTUAL_CHANNEL_NUMBER_0	0x00	/* Virtual channel 0 */
+#define VIRTUAL_CHANNEL_NUMBER_1	0x01	/* Virtual channel 1 */
+#define VIRTUAL_CHANNEL_NUMBER_2	0x02	/* Virtual channel 2 */
+#define VIRTUAL_CHANNEL_NUMBER_3	0x03	/* Virtual channel 3 */
+#define DBI_NOT_SUPPORTED		0x00	/* command mode
+						 * is not supported
+						 */
+#define DBI_DATA_WIDTH_16BIT		0x01	/* 16 bit data */
+#define DBI_DATA_WIDTH_9BIT			0x02	/* 9 bit data */
+#define DBI_DATA_WIDTH_8BIT			0x03	/* 8 bit data */
+#define DBI_DATA_WIDTH_OPT1		0x04	/* option 1 */
+#define DBI_DATA_WIDTH_OPT2		0x05	/* option 2 */
+#define HS_TX_TIMEOUT_REG            0xb010
+#define LP_RX_TIMEOUT_REG            0xb014
+#define TURN_AROUND_TIMEOUT_REG      0xb018
+#define DEVICE_RESET_REG             0xb01C
+#define DPI_RESOLUTION_REG           0xb020
+#define RES_V_POS                0x10
+#define DBI_RESOLUTION_REG           0xb024 /* Reserved for MDFLD */
+#define HORIZ_SYNC_PAD_COUNT_REG     0xb028
+#define HORIZ_BACK_PORCH_COUNT_REG   0xb02C
+#define HORIZ_FRONT_PORCH_COUNT_REG  0xb030
+#define HORIZ_ACTIVE_AREA_COUNT_REG  0xb034
+#define VERT_SYNC_PAD_COUNT_REG      0xb038
+#define VERT_BACK_PORCH_COUNT_REG    0xb03c
+#define VERT_FRONT_PORCH_COUNT_REG   0xb040
+#define HIGH_LOW_SWITCH_COUNT_REG    0xb044
+#define DPI_CONTROL_REG              0xb048
+#define DPI_SHUT_DOWN            BIT0
+#define DPI_TURN_ON              BIT1
+#define DPI_COLOR_MODE_ON        BIT2
+#define DPI_COLOR_MODE_OFF       BIT3
+#define DPI_BACK_LIGHT_ON        BIT4
+#define DPI_BACK_LIGHT_OFF       BIT5
+#define DPI_LP                   BIT6
+#define DPI_DATA_REG                 0xb04c
+#define DPI_BACK_LIGHT_ON_DATA   0x07
+#define DPI_BACK_LIGHT_OFF_DATA  0x17
+#define INIT_COUNT_REG               0xb050
+#define MAX_RET_PAK_REG              0xb054
+#define VIDEO_FMT_REG                0xb058
+#define COMPLETE_LAST_PCKT       BIT2
+#define EOT_DISABLE_REG              0xb05c
+#define ENABLE_CLOCK_STOPPING    BIT1
+#define LP_BYTECLK_REG               0xb060
+#define LP_GEN_DATA_REG              0xb064
+#define HS_GEN_DATA_REG              0xb068
+#define LP_GEN_CTRL_REG              0xb06C
+#define HS_GEN_CTRL_REG              0xb070
+#define DCS_CHANNEL_NUMBER_POS   0x06
+#define MCS_COMMANDS_POS	0x8
+#define WORD_COUNTS_POS		0x8
+#define MCS_PARAMETER_POS	0x10
+#define GEN_FIFO_STAT_REG            0xb074
+#define HS_DATA_FIFO_FULL        BIT0
+#define HS_DATA_FIFO_HALF_EMPTY  BIT1
+#define HS_DATA_FIFO_EMPTY       BIT2
+#define LP_DATA_FIFO_FULL        BIT8
+#define LP_DATA_FIFO_HALF_EMPTY  BIT9
+#define LP_DATA_FIFO_EMPTY       BIT10
+#define HS_CTRL_FIFO_FULL        BIT16
+#define HS_CTRL_FIFO_HALF_EMPTY  BIT17
+#define HS_CTRL_FIFO_EMPTY       BIT18
+#define LP_CTRL_FIFO_FULL        BIT24
+#define LP_CTRL_FIFO_HALF_EMPTY  BIT25
+#define LP_CTRL_FIFO_EMPTY       BIT26
+#define DBI_FIFO_EMPTY           BIT27
+#define DPI_FIFO_EMPTY           BIT28
+#define HS_LS_DBI_ENABLE_REG         0xb078
+#define TXCLKESC_REG		     0xb07c
+#define DPHY_PARAM_REG               0xb080
+#define DBI_BW_CTRL_REG              0xb084
+#define CLK_LANE_SWT_REG             0xb088
+/*===========================================================================
+; MIPI Adapter registers
+;--------------------------------------------------------------------------*/
+#define MIPI_CONTROL_REG             0xb104
+#define MIPI_2X_CLOCK_BITS       (BIT0 | BIT1)
+#define MIPI_DATA_ADDRESS_REG        0xb108
+#define MIPI_DATA_LENGTH_REG         0xb10C
+#define MIPI_COMMAND_ADDRESS_REG     0xb110
+#define MIPI_COMMAND_LENGTH_REG      0xb114
+#define MIPI_READ_DATA_RETURN_REG0   0xb118
+#define MIPI_READ_DATA_RETURN_REG1   0xb11C
+#define MIPI_READ_DATA_RETURN_REG2   0xb120
+#define MIPI_READ_DATA_RETURN_REG3   0xb124
+#define MIPI_READ_DATA_RETURN_REG4   0xb128
+#define MIPI_READ_DATA_RETURN_REG5   0xb12C
+#define MIPI_READ_DATA_RETURN_REG6   0xb130
+#define MIPI_READ_DATA_RETURN_REG7   0xb134
+#define MIPI_READ_DATA_VALID_REG     0xb138
+/* DBI COMMANDS */
+#define soft_reset                   0x01
+/* ************************************************************************* *\
+The display module performs a software reset.
+Registers are written with their SW Reset default values.
+\* ************************************************************************* */
+#define get_power_mode               0x0a
+/* ************************************************************************* *\
+The display module returns the current power mode
+\* ************************************************************************* */
+#define get_address_mode             0x0b
+/* ************************************************************************* *\
+The display module returns the current status.
+\* ************************************************************************* */
+#define get_pixel_format             0x0c
+/* ************************************************************************* *\
+This command gets the pixel format for the RGB image data
+used by the interface.
+\* ************************************************************************* */
+#define get_display_mode             0x0d
+/* ************************************************************************* *\
+The display module returns the Display Image Mode status.
+\* ************************************************************************* */
+#define get_signal_mode              0x0e
+/* ************************************************************************* *\
+The display module returns the Display Signal Mode.
+\* ************************************************************************* */
+#define get_diagnostic_result        0x0f
+/* ************************************************************************* *\
+The display module returns the self-diagnostic results following
+a Sleep Out command.
+\* ************************************************************************* */
+#define enter_sleep_mode             0x10
+/* ************************************************************************* *\
+This command causes the display module to enter the Sleep mode.
+In this mode, all unnecessary blocks inside the display module are disabled
+except interface communication. This is the lowest power mode
+the display module supports.
+\* ************************************************************************* */
+#define exit_sleep_mode              0x11
+/* ************************************************************************* *\
+This command causes the display module to exit Sleep mode.
+All blocks inside the display module are enabled.
+\* ************************************************************************* */
+#define enter_partial_mode           0x12
+/* ************************************************************************* *\
+This command causes the display module to enter the Partial Display Mode.
+The Partial Display Mode window is described by the set_partial_area command.
+\* ************************************************************************* */
+#define enter_normal_mode            0x13
+/* ************************************************************************* *\
+This command causes the display module to enter the Normal mode.
+Normal Mode is defined as Partial Display mode and Scroll mode are off
+\* ************************************************************************* */
+#define exit_invert_mode             0x20
+/* ************************************************************************* *\
+This command causes the display module to stop inverting the image data on
+the display device. The frame memory contents remain unchanged.
+No status bits are changed.
+\* ************************************************************************* */
+#define enter_invert_mode            0x21
+/* ************************************************************************* *\
+This command causes the display module to invert the image data only on
+the display device. The frame memory contents remain unchanged.
+No status bits are changed.
+\* ************************************************************************* */
+#define set_gamma_curve              0x26
+/* ************************************************************************* *\
+This command selects the desired gamma curve for the display device.
+Four fixed gamma curves are defined in section DCS spec.
+\* ************************************************************************* */
+#define set_display_off              0x28
+/* ************************************************************************* *\
+This command causes the display module to stop displaying the image data
+on the display device. The frame memory contents remain unchanged.
+No status bits are changed.
+\* ************************************************************************* */
+#define set_display_on               0x29
+/* ************************************************************************* *\
+This command causes the display module to start displaying the image data
+on the display device. The frame memory contents remain unchanged.
+No status bits are changed.
+\* ************************************************************************* */
+#define set_column_address           0x2a
+/* ************************************************************************* *\
+This command defines the column extent of the frame memory accessed by the
+hostprocessor with the read_memory_continue and write_memory_continue commands.
+No status bits are changed.
+\* ************************************************************************* */
+#define set_page_addr             0x2b
+/* ************************************************************************* *\
+This command defines the page extent of the frame memory accessed by the host
+processor with the write_memory_continue and read_memory_continue command.
+No status bits are changed.
+\* ************************************************************************* */
+#define write_mem_start              0x2c
+/* ************************************************************************* *\
+This command transfers image data from the host processor to the display
+module s frame memory starting at the pixel location specified by
+preceding set_column_address and set_page_address commands.
+\* ************************************************************************* */
+#define set_partial_area             0x30
+/* ************************************************************************* *\
+This command defines the Partial Display mode s display area.
+There are two parameters associated with
+this command, the first defines the Start Row (SR) and the second the End Row
+(ER). SR and ER refer to the Frame Memory Line Pointer.
+\* ************************************************************************* */
+#define set_scroll_area              0x33
+/* ************************************************************************* *\
+This command defines the display modules Vertical Scrolling Area.
+\* ************************************************************************* */
+#define set_tear_off                 0x34
+/* ************************************************************************* *\
+This command turns off the display modules Tearing Effect output signal on
+the TE signal line.
+\* ************************************************************************* */
+#define set_tear_on                  0x35
+/* ************************************************************************* *\
+This command turns on the display modules Tearing Effect output signal
+on the TE signal line.
+\* ************************************************************************* */
+#define set_address_mode             0x36
+/* ************************************************************************* *\
+This command sets the data order for transfers from the host processor to
+display modules frame memory,bits B[7:5] and B3, and from the display
+modules frame memory to the display device, bits B[2:0] and B4.
+\* ************************************************************************* */
+#define set_scroll_start             0x37
+/* ************************************************************************* *\
+This command sets the start of the vertical scrolling area in the frame memory.
+The vertical scrolling area is fully defined when this command is used with
+the set_scroll_area command The set_scroll_start command has one parameter,
+the Vertical Scroll Pointer. The VSP defines the line in the frame memory
+that is written to the display device as the first line of the vertical
+scroll area.
+\* ************************************************************************* */
+#define exit_idle_mode               0x38
+/* ************************************************************************* *\
+This command causes the display module to exit Idle mode.
+\* ************************************************************************* */
+#define enter_idle_mode              0x39
+/* ************************************************************************* *\
+This command causes the display module to enter Idle Mode.
+In Idle Mode, color expression is reduced. Colors are shown on the display
+device using the MSB of each of the R, G and B color components in the frame
+memory
+\* ************************************************************************* */
+#define set_pixel_format             0x3a
+/* ************************************************************************* *\
+This command sets the pixel format for the RGB image data used by the interface.
+Bits D[6:4]  DPI Pixel Format Definition
+Bits D[2:0]  DBI Pixel Format Definition
+Bits D7 and D3 are not used.
+\* ************************************************************************* */
+  #define DCS_PIXEL_FORMAT_3bbp	 	0x1
+  #define DCS_PIXEL_FORMAT_8bbp 	0x2
+  #define DCS_PIXEL_FORMAT_12bbp 	0x3
+  #define DCS_PIXEL_FORMAT_16bbp	0x5 
+  #define DCS_PIXEL_FORMAT_18bbp	0x6 
+  #define DCS_PIXEL_FORMAT_24bbp 	0x7
+#define write_mem_cont               0x3c
+/* ************************************************************************* *\
+This command transfers image data from the host processor to the display
+module's frame memory continuing from the pixel location following the
+previous write_memory_continue or write_memory_start command.
+\* ************************************************************************* */
+#define set_tear_scanline            0x44
+/* ************************************************************************* *\
+This command turns on the display modules Tearing Effect output signal on the
+TE signal line when the display module reaches line N.
+\* ************************************************************************* */
+#define get_scanline                 0x45
+/* ************************************************************************* *\
+The display module returns the current scanline, N, used to update the
+display device. The total number of scanlines on a display device is
+defined as VSYNC + VBP + VACT + VFP.The first scanline is defined as
+the first line of V Sync and is denoted as Line 0.
+When in Sleep Mode, the value returned by get_scanline is undefined.
+\* ************************************************************************* */
+
+/* MCS or Generic COMMANDS */
+/* MCS/generic data type */
+#define GEN_SHORT_WRITE_0	0x03  /* generic short write, no parameters */
+#define GEN_SHORT_WRITE_1	0x13  /* generic short write, 1 parameters */
+#define GEN_SHORT_WRITE_2	0x23  /* generic short write, 2 parameters */
+#define GEN_READ_0		0x04  /* generic read, no parameters */
+#define GEN_READ_1		0x14  /* generic read, 1 parameters */
+#define GEN_READ_2		0x24  /* generic read, 2 parameters */
+#define GEN_LONG_WRITE		0x29  /* generic long write */
+#define MCS_SHORT_WRITE_0	0x05  /* MCS short write, no parameters */
+#define MCS_SHORT_WRITE_1	0x15  /* MCS short write, 1 parameters */
+#define MCS_READ		0x06  /* MCS read, no parameters */
+#define MCS_LONG_WRITE		0x39  /* MCS long write */
+/* MCS/generic commands */
+/*****TPO MCS**********/
+#define write_display_profile		0x50
+#define write_display_brightness	0x51
+#define write_ctrl_display		0x53
+#define write_ctrl_cabc			0x55
+  #define UI_IMAGE		0x01
+  #define STILL_IMAGE		0x02
+  #define MOVING_IMAGE		0x03
+#define write_hysteresis		0x57
+#define write_gamma_setting		0x58
+#define write_cabc_min_bright		0x5e
+#define write_kbbc_profile		0x60
+/*****TMD MCS**************/
+#define tmd_write_display_brightness 0x8c
+
+/* ************************************************************************* *\
+This command is used to control ambient light, panel backlight brightness and
+gamma settings.
+\* ************************************************************************* */
+#define BRIGHT_CNTL_BLOCK_ON	BIT5
+#define AMBIENT_LIGHT_SENSE_ON	BIT4
+#define DISPLAY_DIMMING_ON	BIT3
+#define BACKLIGHT_ON		BIT2
+#define DISPLAY_BRIGHTNESS_AUTO	BIT1
+#define GAMMA_AUTO		BIT0
+
+/* DCS Interface Pixel Formats */
+#define DCS_PIXEL_FORMAT_3BPP         0x1
+#define DCS_PIXEL_FORMAT_8BPP         0x2
+#define DCS_PIXEL_FORMAT_12BPP        0x3
+#define DCS_PIXEL_FORMAT_16BPP        0x5
+#define DCS_PIXEL_FORMAT_18BPP        0x6
+#define DCS_PIXEL_FORMAT_24BPP        0x7
+/* ONE PARAMETER READ DATA */
+#define addr_mode_data           0xfc
+#define diag_res_data            0x00
+#define disp_mode_data           0x23
+#define pxl_fmt_data             0x77
+#define pwr_mode_data            0x74
+#define sig_mode_data            0x00
+/* TWO PARAMETERS READ DATA */
+#define scanline_data1           0xff
+#define scanline_data2           0xff
+#define NON_BURST_MODE_SYNC_PULSE	0x01	/* Non Burst Mode
+						 * with Sync Pulse
+						 */
+#define NON_BURST_MODE_SYNC_EVENTS	0x02	/* Non Burst Mode
+						 * with Sync events
+						 */
+#define BURST_MODE			0x03	/* Burst Mode */
+#define DBI_COMMAND_BUFFER_SIZE		0x240  /* 0x32 */    /* 0x120 */	/* Allocate at least
+						 * 0x100 Byte with 32
+						 * byte alignment
+						 */
+#define DBI_DATA_BUFFER_SIZE		0x120	/* Allocate at least
+						 * 0x100 Byte with 32
+						 * byte alignment
+						 */
+#define DBI_CB_TIME_OUT 0xFFFF
+#define GEN_FB_TIME_OUT 2000 
+#define ALIGNMENT_32BYTE_MASK		(~(BIT0|BIT1|BIT2|BIT3|BIT4))
+#define SKU_83 						0x01
+#define SKU_100 					0x02
+#define SKU_100L 					0x04
+#define SKU_BYPASS 					0x08
+
+#endif
diff --git a/drivers/staging/gma500/psb_intel_sdvo.c b/drivers/staging/gma500/psb_intel_sdvo.c
new file mode 100644
index 0000000..731a5a2
--- /dev/null
+++ b/drivers/staging/gma500/psb_intel_sdvo.c
@@ -0,0 +1,1298 @@
+/*
+ * Copyright (c) 2006-2007 Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors:
+ *	Eric Anholt <eric@anholt.net>
+ */
+
+#include <linux/i2c.h>
+#include <linux/delay.h>
+/* #include <drm/drm_crtc.h> */
+#include <drm/drmP.h>
+#include "psb_drv.h"
+#include "psb_intel_drv.h"
+#include "psb_intel_reg.h"
+#include "psb_intel_sdvo_regs.h"
+
+struct psb_intel_sdvo_priv {
+	struct psb_intel_i2c_chan *i2c_bus;
+	int slaveaddr;
+	int output_device;
+
+	u16 active_outputs;
+
+	struct psb_intel_sdvo_caps caps;
+	int pixel_clock_min, pixel_clock_max;
+
+	int save_sdvo_mult;
+	u16 save_active_outputs;
+	struct psb_intel_sdvo_dtd save_input_dtd_1, save_input_dtd_2;
+	struct psb_intel_sdvo_dtd save_output_dtd[16];
+	u32 save_SDVOX;
+	u8 in_out_map[4];
+
+	u8 by_input_wiring;
+	u32 active_device;
+};
+
+/**
+ * Writes the SDVOB or SDVOC with the given value, but always writes both
+ * SDVOB and SDVOC to work around apparent hardware issues (according to
+ * comments in the BIOS).
+ */
+void psb_intel_sdvo_write_sdvox(struct psb_intel_output *psb_intel_output,
+				u32 val)
+{
+	struct drm_device *dev = psb_intel_output->base.dev;
+	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
+	u32 bval = val, cval = val;
+	int i;
+
+	if (sdvo_priv->output_device == SDVOB)
+		cval = REG_READ(SDVOC);
+	else
+		bval = REG_READ(SDVOB);
+	/*
+	 * Write the registers twice for luck. Sometimes,
+	 * writing them only once doesn't appear to 'stick'.
+	 * The BIOS does this too. Yay, magic
+	 */
+	for (i = 0; i < 2; i++) {
+		REG_WRITE(SDVOB, bval);
+		REG_READ(SDVOB);
+		REG_WRITE(SDVOC, cval);
+		REG_READ(SDVOC);
+	}
+}
+
+static bool psb_intel_sdvo_read_byte(
+				struct psb_intel_output *psb_intel_output,
+				u8 addr, u8 *ch)
+{
+	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
+	u8 out_buf[2];
+	u8 buf[2];
+	int ret;
+
+	struct i2c_msg msgs[] = {
+		{
+		 .addr = sdvo_priv->i2c_bus->slave_addr,
+		 .flags = 0,
+		 .len = 1,
+		 .buf = out_buf,
+		 },
+		{
+		 .addr = sdvo_priv->i2c_bus->slave_addr,
+		 .flags = I2C_M_RD,
+		 .len = 1,
+		 .buf = buf,
+		 }
+	};
+
+	out_buf[0] = addr;
+	out_buf[1] = 0;
+
+	ret = i2c_transfer(&sdvo_priv->i2c_bus->adapter, msgs, 2);
+	if (ret == 2) {
+		/* DRM_DEBUG("got back from addr %02X = %02x\n",
+		 * out_buf[0], buf[0]);
+		 */
+		*ch = buf[0];
+		return true;
+	}
+
+	DRM_DEBUG("i2c transfer returned %d\n", ret);
+	return false;
+}
+
+static bool psb_intel_sdvo_write_byte(
+			struct psb_intel_output *psb_intel_output,
+			int addr, u8 ch)
+{
+	u8 out_buf[2];
+	struct i2c_msg msgs[] = {
+		{
+		 .addr = psb_intel_output->i2c_bus->slave_addr,
+		 .flags = 0,
+		 .len = 2,
+		 .buf = out_buf,
+		 }
+	};
+
+	out_buf[0] = addr;
+	out_buf[1] = ch;
+
+	if (i2c_transfer(&psb_intel_output->i2c_bus->adapter, msgs, 1) == 1)
+		return true;
+	return false;
+}
+
+#define SDVO_CMD_NAME_ENTRY(cmd) {cmd, #cmd}
+/** Mapping of command numbers to names, for debug output */
+static const struct _sdvo_cmd_name {
+	u8 cmd;
+	char *name;
+} sdvo_cmd_names[] = {
+SDVO_CMD_NAME_ENTRY(SDVO_CMD_RESET),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_DEVICE_CAPS),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_FIRMWARE_REV),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_TRAINED_INPUTS),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ACTIVE_OUTPUTS),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_ACTIVE_OUTPUTS),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_IN_OUT_MAP),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_IN_OUT_MAP),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ATTACHED_DISPLAYS),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_HOT_PLUG_SUPPORT),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_ACTIVE_HOT_PLUG),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_ACTIVE_HOT_PLUG),
+	    SDVO_CMD_NAME_ENTRY
+	    (SDVO_CMD_GET_INTERRUPT_EVENT_SOURCE),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TARGET_INPUT),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TARGET_OUTPUT),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INPUT_TIMINGS_PART1),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_INPUT_TIMINGS_PART2),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_INPUT_TIMINGS_PART1),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_INPUT_TIMINGS_PART2),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_INPUT_TIMINGS_PART1),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_OUTPUT_TIMINGS_PART1),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_OUTPUT_TIMINGS_PART2),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OUTPUT_TIMINGS_PART1),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_OUTPUT_TIMINGS_PART2),
+	    SDVO_CMD_NAME_ENTRY
+	    (SDVO_CMD_CREATE_PREFERRED_INPUT_TIMING),
+	    SDVO_CMD_NAME_ENTRY
+	    (SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART1),
+	    SDVO_CMD_NAME_ENTRY
+	    (SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART2),
+	    SDVO_CMD_NAME_ENTRY
+	    (SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE),
+	    SDVO_CMD_NAME_ENTRY
+	    (SDVO_CMD_GET_OUTPUT_PIXEL_CLOCK_RANGE),
+	    SDVO_CMD_NAME_ENTRY
+	    (SDVO_CMD_GET_SUPPORTED_CLOCK_RATE_MULTS),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_CLOCK_RATE_MULT),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_CLOCK_RATE_MULT),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_SUPPORTED_TV_FORMATS),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_GET_TV_FORMAT),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_TV_FORMAT),
+	    SDVO_CMD_NAME_ENTRY
+	    (SDVO_CMD_SET_TV_RESOLUTION_SUPPORT),
+	    SDVO_CMD_NAME_ENTRY(SDVO_CMD_SET_CONTROL_BUS_SWITCH),};
+
+#define SDVO_NAME(dev_priv) \
+		 ((dev_priv)->output_device == SDVOB ? "SDVOB" : "SDVOC")
+#define SDVO_PRIV(output)   ((struct psb_intel_sdvo_priv *) (output)->dev_priv)
+
+static void psb_intel_sdvo_write_cmd(struct psb_intel_output *psb_intel_output,
+				     u8 cmd,
+				     void *args,
+				     int args_len)
+{
+	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
+	int i;
+
+	if (1) {
+		DRM_DEBUG("%s: W: %02X ", SDVO_NAME(sdvo_priv), cmd);
+		for (i = 0; i < args_len; i++)
+			printk(KERN_INFO"%02X ", ((u8 *) args)[i]);
+		for (; i < 8; i++)
+			printk("   ");
+		for (i = 0;
+		     i <
+		     sizeof(sdvo_cmd_names) / sizeof(sdvo_cmd_names[0]);
+		     i++) {
+			if (cmd == sdvo_cmd_names[i].cmd) {
+				printk("(%s)", sdvo_cmd_names[i].name);
+				break;
+			}
+		}
+		if (i ==
+		    sizeof(sdvo_cmd_names) / sizeof(sdvo_cmd_names[0]))
+			printk("(%02X)", cmd);
+		printk("\n");
+	}
+
+	for (i = 0; i < args_len; i++) {
+		psb_intel_sdvo_write_byte(psb_intel_output,
+					SDVO_I2C_ARG_0 - i,
+					((u8 *) args)[i]);
+	}
+
+	psb_intel_sdvo_write_byte(psb_intel_output, SDVO_I2C_OPCODE, cmd);
+}
+
+static const char *const cmd_status_names[] = {
+	"Power on",
+	"Success",
+	"Not supported",
+	"Invalid arg",
+	"Pending",
+	"Target not specified",
+	"Scaling not supported"
+};
+
+static u8 psb_intel_sdvo_read_response(
+				struct psb_intel_output *psb_intel_output,
+				void *response, int response_len)
+{
+	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
+	int i;
+	u8 status;
+	u8 retry = 50;
+
+	while (retry--) {
+		/* Read the command response */
+		for (i = 0; i < response_len; i++) {
+			psb_intel_sdvo_read_byte(psb_intel_output,
+					     SDVO_I2C_RETURN_0 + i,
+					     &((u8 *) response)[i]);
+		}
+
+		/* read the return status */
+		psb_intel_sdvo_read_byte(psb_intel_output,
+					 SDVO_I2C_CMD_STATUS,
+					 &status);
+
+		if (1) {
+			DRM_DEBUG("%s: R: ", SDVO_NAME(sdvo_priv));
+			for (i = 0; i < response_len; i++)
+				printk(KERN_INFO"%02X ", ((u8 *) response)[i]);
+			for (; i < 8; i++)
+				printk("   ");
+			if (status <= SDVO_CMD_STATUS_SCALING_NOT_SUPP)
+				printk(KERN_INFO"(%s)",
+					 cmd_status_names[status]);
+			else
+				printk(KERN_INFO"(??? %d)", status);
+			printk("\n");
+		}
+
+		if (status != SDVO_CMD_STATUS_PENDING)
+			return status;
+
+		mdelay(50);
+	}
+
+	return status;
+}
+
+int psb_intel_sdvo_get_pixel_multiplier(struct drm_display_mode *mode)
+{
+	if (mode->clock >= 100000)
+		return 1;
+	else if (mode->clock >= 50000)
+		return 2;
+	else
+		return 4;
+}
+
+/**
+ * Don't check status code from this as it switches the bus back to the
+ * SDVO chips which defeats the purpose of doing a bus switch in the first
+ * place.
+ */
+void psb_intel_sdvo_set_control_bus_switch(
+				struct psb_intel_output *psb_intel_output,
+				u8 target)
+{
+	psb_intel_sdvo_write_cmd(psb_intel_output,
+				 SDVO_CMD_SET_CONTROL_BUS_SWITCH,
+				 &target,
+				 1);
+}
+
+static bool psb_intel_sdvo_set_target_input(
+				struct psb_intel_output *psb_intel_output,
+				bool target_0, bool target_1)
+{
+	struct psb_intel_sdvo_set_target_input_args targets = { 0 };
+	u8 status;
+
+	if (target_0 && target_1)
+		return SDVO_CMD_STATUS_NOTSUPP;
+
+	if (target_1)
+		targets.target_1 = 1;
+
+	psb_intel_sdvo_write_cmd(psb_intel_output, SDVO_CMD_SET_TARGET_INPUT,
+			     &targets, sizeof(targets));
+
+	status = psb_intel_sdvo_read_response(psb_intel_output, NULL, 0);
+
+	return status == SDVO_CMD_STATUS_SUCCESS;
+}
+
+/**
+ * Return whether each input is trained.
+ *
+ * This function is making an assumption about the layout of the response,
+ * which should be checked against the docs.
+ */
+static bool psb_intel_sdvo_get_trained_inputs(struct psb_intel_output
+					  *psb_intel_output, bool *input_1,
+					  bool *input_2)
+{
+	struct psb_intel_sdvo_get_trained_inputs_response response;
+	u8 status;
+
+	psb_intel_sdvo_write_cmd(psb_intel_output, SDVO_CMD_GET_TRAINED_INPUTS,
+			     NULL, 0);
+	status =
+	    psb_intel_sdvo_read_response(psb_intel_output, &response,
+				     sizeof(response));
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+
+	*input_1 = response.input0_trained;
+	*input_2 = response.input1_trained;
+	return true;
+}
+
+static bool psb_intel_sdvo_get_active_outputs(struct psb_intel_output
+					  *psb_intel_output, u16 *outputs)
+{
+	u8 status;
+
+	psb_intel_sdvo_write_cmd(psb_intel_output, SDVO_CMD_GET_ACTIVE_OUTPUTS,
+			     NULL, 0);
+	status =
+	    psb_intel_sdvo_read_response(psb_intel_output, outputs,
+				     sizeof(*outputs));
+
+	return status == SDVO_CMD_STATUS_SUCCESS;
+}
+
+static bool psb_intel_sdvo_set_active_outputs(struct psb_intel_output
+					  *psb_intel_output, u16 outputs)
+{
+	u8 status;
+
+	psb_intel_sdvo_write_cmd(psb_intel_output, SDVO_CMD_SET_ACTIVE_OUTPUTS,
+			     &outputs, sizeof(outputs));
+	status = psb_intel_sdvo_read_response(psb_intel_output, NULL, 0);
+	return status == SDVO_CMD_STATUS_SUCCESS;
+}
+
+static bool psb_intel_sdvo_set_encoder_power_state(struct psb_intel_output
+					       *psb_intel_output, int mode)
+{
+	u8 status, state = SDVO_ENCODER_STATE_ON;
+
+	switch (mode) {
+	case DRM_MODE_DPMS_ON:
+		state = SDVO_ENCODER_STATE_ON;
+		break;
+	case DRM_MODE_DPMS_STANDBY:
+		state = SDVO_ENCODER_STATE_STANDBY;
+		break;
+	case DRM_MODE_DPMS_SUSPEND:
+		state = SDVO_ENCODER_STATE_SUSPEND;
+		break;
+	case DRM_MODE_DPMS_OFF:
+		state = SDVO_ENCODER_STATE_OFF;
+		break;
+	}
+
+	psb_intel_sdvo_write_cmd(psb_intel_output,
+			     SDVO_CMD_SET_ENCODER_POWER_STATE, &state,
+			     sizeof(state));
+	status = psb_intel_sdvo_read_response(psb_intel_output, NULL, 0);
+
+	return status == SDVO_CMD_STATUS_SUCCESS;
+}
+
+static bool psb_intel_sdvo_get_input_pixel_clock_range(struct psb_intel_output
+						   *psb_intel_output,
+						   int *clock_min,
+						   int *clock_max)
+{
+	struct psb_intel_sdvo_pixel_clock_range clocks;
+	u8 status;
+
+	psb_intel_sdvo_write_cmd(psb_intel_output,
+			     SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE, NULL,
+			     0);
+
+	status =
+	    psb_intel_sdvo_read_response(psb_intel_output, &clocks,
+				     sizeof(clocks));
+
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+
+	/* Convert the values from units of 10 kHz to kHz. */
+	*clock_min = clocks.min * 10;
+	*clock_max = clocks.max * 10;
+
+	return true;
+}
+
+static bool psb_intel_sdvo_set_target_output(
+				struct psb_intel_output *psb_intel_output,
+				u16 outputs)
+{
+	u8 status;
+
+	psb_intel_sdvo_write_cmd(psb_intel_output, SDVO_CMD_SET_TARGET_OUTPUT,
+			     &outputs, sizeof(outputs));
+
+	status = psb_intel_sdvo_read_response(psb_intel_output, NULL, 0);
+	return status == SDVO_CMD_STATUS_SUCCESS;
+}
+
+static bool psb_intel_sdvo_get_timing(struct psb_intel_output *psb_intel_output,
+				  u8 cmd, struct psb_intel_sdvo_dtd *dtd)
+{
+	u8 status;
+
+	psb_intel_sdvo_write_cmd(psb_intel_output, cmd, NULL, 0);
+	status = psb_intel_sdvo_read_response(psb_intel_output, &dtd->part1,
+					  sizeof(dtd->part1));
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+
+	psb_intel_sdvo_write_cmd(psb_intel_output, cmd + 1, NULL, 0);
+	status = psb_intel_sdvo_read_response(psb_intel_output, &dtd->part2,
+					  sizeof(dtd->part2));
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+
+	return true;
+}
+
+static bool psb_intel_sdvo_get_input_timing(
+				struct psb_intel_output *psb_intel_output,
+				struct psb_intel_sdvo_dtd *dtd)
+{
+	return psb_intel_sdvo_get_timing(psb_intel_output,
+				     SDVO_CMD_GET_INPUT_TIMINGS_PART1,
+				     dtd);
+}
+
+static bool psb_intel_sdvo_set_timing(
+				struct psb_intel_output *psb_intel_output,
+				u8 cmd,
+				struct psb_intel_sdvo_dtd *dtd)
+{
+	u8 status;
+
+	psb_intel_sdvo_write_cmd(psb_intel_output, cmd, &dtd->part1,
+			     sizeof(dtd->part1));
+	status = psb_intel_sdvo_read_response(psb_intel_output, NULL, 0);
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+
+	psb_intel_sdvo_write_cmd(psb_intel_output, cmd + 1, &dtd->part2,
+			     sizeof(dtd->part2));
+	status = psb_intel_sdvo_read_response(psb_intel_output, NULL, 0);
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+
+	return true;
+}
+
+static bool psb_intel_sdvo_set_input_timing(
+				struct psb_intel_output *psb_intel_output,
+				struct psb_intel_sdvo_dtd *dtd)
+{
+	return psb_intel_sdvo_set_timing(psb_intel_output,
+				     SDVO_CMD_SET_INPUT_TIMINGS_PART1,
+				     dtd);
+}
+
+static bool psb_intel_sdvo_set_output_timing(
+				struct psb_intel_output *psb_intel_output,
+				struct psb_intel_sdvo_dtd *dtd)
+{
+	return psb_intel_sdvo_set_timing(psb_intel_output,
+				     SDVO_CMD_SET_OUTPUT_TIMINGS_PART1,
+				     dtd);
+}
+
+static int psb_intel_sdvo_get_clock_rate_mult(struct psb_intel_output
+						*psb_intel_output)
+{
+	u8 response, status;
+
+	psb_intel_sdvo_write_cmd(psb_intel_output,
+				 SDVO_CMD_GET_CLOCK_RATE_MULT,
+				 NULL,
+				 0);
+
+	status = psb_intel_sdvo_read_response(psb_intel_output, &response, 1);
+
+	if (status != SDVO_CMD_STATUS_SUCCESS) {
+		DRM_DEBUG("Couldn't get SDVO clock rate multiplier\n");
+		return SDVO_CLOCK_RATE_MULT_1X;
+	} else {
+		DRM_DEBUG("Current clock rate multiplier: %d\n", response);
+	}
+
+	return response;
+}
+
+static bool psb_intel_sdvo_set_clock_rate_mult(struct psb_intel_output
+						*psb_intel_output, u8 val)
+{
+	u8 status;
+
+	psb_intel_sdvo_write_cmd(psb_intel_output,
+				SDVO_CMD_SET_CLOCK_RATE_MULT,
+				&val,
+				1);
+
+	status = psb_intel_sdvo_read_response(psb_intel_output, NULL, 0);
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+
+	return true;
+}
+
+static bool psb_sdvo_set_current_inoutmap(struct psb_intel_output *output,
+					  u32 in0outputmask,
+					  u32 in1outputmask)
+{
+	u8 byArgs[4];
+	u8 status;
+	int i;
+	struct psb_intel_sdvo_priv *sdvo_priv = output->dev_priv;
+
+	/* Make all fields of the  args/ret to zero */
+	memset(byArgs, 0, sizeof(byArgs));
+
+	/* Fill up the arguement values; */
+	byArgs[0] = (u8) (in0outputmask & 0xFF);
+	byArgs[1] = (u8) ((in0outputmask >> 8) & 0xFF);
+	byArgs[2] = (u8) (in1outputmask & 0xFF);
+	byArgs[3] = (u8) ((in1outputmask >> 8) & 0xFF);
+
+
+	/*save inoutmap arg here*/
+	for (i = 0; i < 4; i++)
+		sdvo_priv->in_out_map[i] = byArgs[0];
+
+	psb_intel_sdvo_write_cmd(output, SDVO_CMD_SET_IN_OUT_MAP, byArgs, 4);
+	status = psb_intel_sdvo_read_response(output, NULL, 0);
+
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+	return true;
+}
+
+
+static void psb_intel_sdvo_set_iomap(struct psb_intel_output *output)
+{
+	u32 dwCurrentSDVOIn0 = 0;
+	u32 dwCurrentSDVOIn1 = 0;
+	u32 dwDevMask = 0;
+
+
+	struct psb_intel_sdvo_priv *sdvo_priv = output->dev_priv;
+
+	/* Please DO NOT change the following code. */
+	/* SDVOB_IN0 or SDVOB_IN1 ==> sdvo_in0 */
+	/* SDVOC_IN0 or SDVOC_IN1 ==> sdvo_in1 */
+	if (sdvo_priv->by_input_wiring & (SDVOB_IN0 | SDVOC_IN0)) {
+		switch (sdvo_priv->active_device) {
+		case SDVO_DEVICE_LVDS:
+			dwDevMask = SDVO_OUTPUT_LVDS0 | SDVO_OUTPUT_LVDS1;
+			break;
+		case SDVO_DEVICE_TMDS:
+			dwDevMask = SDVO_OUTPUT_TMDS0 | SDVO_OUTPUT_TMDS1;
+			break;
+		case SDVO_DEVICE_TV:
+			dwDevMask =
+			SDVO_OUTPUT_YPRPB0 | SDVO_OUTPUT_SVID0 |
+			SDVO_OUTPUT_CVBS0 | SDVO_OUTPUT_YPRPB1 |
+			SDVO_OUTPUT_SVID1 | SDVO_OUTPUT_CVBS1 |
+			SDVO_OUTPUT_SCART0 | SDVO_OUTPUT_SCART1;
+			break;
+		case SDVO_DEVICE_CRT:
+			dwDevMask = SDVO_OUTPUT_RGB0 | SDVO_OUTPUT_RGB1;
+			break;
+		}
+		dwCurrentSDVOIn0 = (sdvo_priv->active_outputs & dwDevMask);
+	} else if (sdvo_priv->by_input_wiring & (SDVOB_IN1 | SDVOC_IN1)) {
+		switch (sdvo_priv->active_device) {
+		case SDVO_DEVICE_LVDS:
+			dwDevMask = SDVO_OUTPUT_LVDS0 | SDVO_OUTPUT_LVDS1;
+			break;
+		case SDVO_DEVICE_TMDS:
+			dwDevMask = SDVO_OUTPUT_TMDS0 | SDVO_OUTPUT_TMDS1;
+			break;
+		case SDVO_DEVICE_TV:
+			dwDevMask =
+			SDVO_OUTPUT_YPRPB0 | SDVO_OUTPUT_SVID0 |
+			SDVO_OUTPUT_CVBS0 | SDVO_OUTPUT_YPRPB1 |
+			SDVO_OUTPUT_SVID1 | SDVO_OUTPUT_CVBS1 |
+			SDVO_OUTPUT_SCART0 | SDVO_OUTPUT_SCART1;
+			break;
+		case SDVO_DEVICE_CRT:
+			dwDevMask = SDVO_OUTPUT_RGB0 | SDVO_OUTPUT_RGB1;
+			break;
+		}
+		dwCurrentSDVOIn1 = (sdvo_priv->active_outputs & dwDevMask);
+	}
+
+	psb_sdvo_set_current_inoutmap(output, dwCurrentSDVOIn0,
+					  dwCurrentSDVOIn1);
+}
+
+
+static bool psb_intel_sdvo_mode_fixup(struct drm_encoder *encoder,
+				  struct drm_display_mode *mode,
+				  struct drm_display_mode *adjusted_mode)
+{
+	/* Make the CRTC code factor in the SDVO pixel multiplier.  The SDVO
+	 * device will be told of the multiplier during mode_set.
+	 */
+	adjusted_mode->clock *= psb_intel_sdvo_get_pixel_multiplier(mode);
+	return true;
+}
+
+static void psb_intel_sdvo_mode_set(struct drm_encoder *encoder,
+				struct drm_display_mode *mode,
+				struct drm_display_mode *adjusted_mode)
+{
+	struct drm_device *dev = encoder->dev;
+	struct drm_crtc *crtc = encoder->crtc;
+	struct psb_intel_crtc *psb_intel_crtc = to_psb_intel_crtc(crtc);
+	struct psb_intel_output *psb_intel_output =
+					enc_to_psb_intel_output(encoder);
+	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
+	u16 width, height;
+	u16 h_blank_len, h_sync_len, v_blank_len, v_sync_len;
+	u16 h_sync_offset, v_sync_offset;
+	u32 sdvox;
+	struct psb_intel_sdvo_dtd output_dtd;
+	int sdvo_pixel_multiply;
+
+	if (!mode)
+		return;
+
+	psb_intel_sdvo_set_target_output(psb_intel_output, 0);
+
+	width = mode->crtc_hdisplay;
+	height = mode->crtc_vdisplay;
+
+	/* do some mode translations */
+	h_blank_len = mode->crtc_hblank_end - mode->crtc_hblank_start;
+	h_sync_len = mode->crtc_hsync_end - mode->crtc_hsync_start;
+
+	v_blank_len = mode->crtc_vblank_end - mode->crtc_vblank_start;
+	v_sync_len = mode->crtc_vsync_end - mode->crtc_vsync_start;
+
+	h_sync_offset = mode->crtc_hsync_start - mode->crtc_hblank_start;
+	v_sync_offset = mode->crtc_vsync_start - mode->crtc_vblank_start;
+
+	output_dtd.part1.clock = mode->clock / 10;
+	output_dtd.part1.h_active = width & 0xff;
+	output_dtd.part1.h_blank = h_blank_len & 0xff;
+	output_dtd.part1.h_high = (((width >> 8) & 0xf) << 4) |
+	    ((h_blank_len >> 8) & 0xf);
+	output_dtd.part1.v_active = height & 0xff;
+	output_dtd.part1.v_blank = v_blank_len & 0xff;
+	output_dtd.part1.v_high = (((height >> 8) & 0xf) << 4) |
+	    ((v_blank_len >> 8) & 0xf);
+
+	output_dtd.part2.h_sync_off = h_sync_offset;
+	output_dtd.part2.h_sync_width = h_sync_len & 0xff;
+	output_dtd.part2.v_sync_off_width = (v_sync_offset & 0xf) << 4 |
+	    (v_sync_len & 0xf);
+	output_dtd.part2.sync_off_width_high =
+	    ((h_sync_offset & 0x300) >> 2) | ((h_sync_len & 0x300) >> 4) |
+	    ((v_sync_offset & 0x30) >> 2) | ((v_sync_len & 0x30) >> 4);
+
+	output_dtd.part2.dtd_flags = 0x18;
+	if (mode->flags & DRM_MODE_FLAG_PHSYNC)
+		output_dtd.part2.dtd_flags |= 0x2;
+	if (mode->flags & DRM_MODE_FLAG_PVSYNC)
+		output_dtd.part2.dtd_flags |= 0x4;
+
+	output_dtd.part2.sdvo_flags = 0;
+	output_dtd.part2.v_sync_off_high = v_sync_offset & 0xc0;
+	output_dtd.part2.reserved = 0;
+
+	/* Set the output timing to the screen */
+	psb_intel_sdvo_set_target_output(psb_intel_output,
+				     sdvo_priv->active_outputs);
+
+	/* Set the input timing to the screen. Assume always input 0. */
+	psb_intel_sdvo_set_target_input(psb_intel_output, true, false);
+
+	psb_intel_sdvo_set_output_timing(psb_intel_output, &output_dtd);
+
+	/* We would like to use i830_sdvo_create_preferred_input_timing() to
+	 * provide the device with a timing it can support, if it supports that
+	 * feature.  However, presumably we would need to adjust the CRTC to
+	 * output the preferred timing, and we don't support that currently.
+	 */
+	psb_intel_sdvo_set_input_timing(psb_intel_output, &output_dtd);
+
+	switch (psb_intel_sdvo_get_pixel_multiplier(mode)) {
+	case 1:
+		psb_intel_sdvo_set_clock_rate_mult(psb_intel_output,
+					       SDVO_CLOCK_RATE_MULT_1X);
+		break;
+	case 2:
+		psb_intel_sdvo_set_clock_rate_mult(psb_intel_output,
+					       SDVO_CLOCK_RATE_MULT_2X);
+		break;
+	case 4:
+		psb_intel_sdvo_set_clock_rate_mult(psb_intel_output,
+					       SDVO_CLOCK_RATE_MULT_4X);
+		break;
+	}
+
+	/* Set the SDVO control regs. */
+	sdvox = REG_READ(sdvo_priv->output_device);
+	switch (sdvo_priv->output_device) {
+	case SDVOB:
+		sdvox &= SDVOB_PRESERVE_MASK;
+		break;
+	case SDVOC:
+		sdvox &= SDVOC_PRESERVE_MASK;
+		break;
+	}
+	sdvox |= (9 << 19) | SDVO_BORDER_ENABLE;
+	if (psb_intel_crtc->pipe == 1)
+		sdvox |= SDVO_PIPE_B_SELECT;
+
+	sdvo_pixel_multiply = psb_intel_sdvo_get_pixel_multiplier(mode);
+
+	psb_intel_sdvo_write_sdvox(psb_intel_output, sdvox);
+
+	 psb_intel_sdvo_set_iomap(psb_intel_output);
+}
+
+static void psb_intel_sdvo_dpms(struct drm_encoder *encoder, int mode)
+{
+	struct drm_device *dev = encoder->dev;
+	struct psb_intel_output *psb_intel_output =
+					enc_to_psb_intel_output(encoder);
+	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
+	u32 temp;
+
+	if (mode != DRM_MODE_DPMS_ON) {
+		psb_intel_sdvo_set_active_outputs(psb_intel_output, 0);
+		if (0)
+			psb_intel_sdvo_set_encoder_power_state(
+							psb_intel_output,
+							mode);
+
+		if (mode == DRM_MODE_DPMS_OFF) {
+			temp = REG_READ(sdvo_priv->output_device);
+			if ((temp & SDVO_ENABLE) != 0) {
+				psb_intel_sdvo_write_sdvox(psb_intel_output,
+						       temp &
+						       ~SDVO_ENABLE);
+			}
+		}
+	} else {
+		bool input1, input2;
+		int i;
+		u8 status;
+
+		temp = REG_READ(sdvo_priv->output_device);
+		if ((temp & SDVO_ENABLE) == 0)
+			psb_intel_sdvo_write_sdvox(psb_intel_output,
+					       temp | SDVO_ENABLE);
+		for (i = 0; i < 2; i++)
+			psb_intel_wait_for_vblank(dev);
+
+		status =
+		    psb_intel_sdvo_get_trained_inputs(psb_intel_output,
+							&input1,
+							&input2);
+
+
+		/* Warn if the device reported failure to sync.
+		 * A lot of SDVO devices fail to notify of sync, but it's
+		 * a given it the status is a success, we succeeded.
+		 */
+		if (status == SDVO_CMD_STATUS_SUCCESS && !input1) {
+			DRM_DEBUG
+			    ("First %s output reported failure to sync\n",
+			     SDVO_NAME(sdvo_priv));
+		}
+
+		if (0)
+			psb_intel_sdvo_set_encoder_power_state(
+							psb_intel_output,
+							mode);
+		psb_intel_sdvo_set_active_outputs(psb_intel_output,
+					      sdvo_priv->active_outputs);
+	}
+	return;
+}
+
+static void psb_intel_sdvo_save(struct drm_connector *connector)
+{
+	struct drm_device *dev = connector->dev;
+	struct psb_intel_output *psb_intel_output =
+					to_psb_intel_output(connector);
+	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
+	/*int o;*/
+
+	sdvo_priv->save_sdvo_mult =
+	    psb_intel_sdvo_get_clock_rate_mult(psb_intel_output);
+	psb_intel_sdvo_get_active_outputs(psb_intel_output,
+				      &sdvo_priv->save_active_outputs);
+
+	if (sdvo_priv->caps.sdvo_inputs_mask & 0x1) {
+		psb_intel_sdvo_set_target_input(psb_intel_output,
+						true,
+						false);
+		psb_intel_sdvo_get_input_timing(psb_intel_output,
+					    &sdvo_priv->save_input_dtd_1);
+	}
+
+	if (sdvo_priv->caps.sdvo_inputs_mask & 0x2) {
+		psb_intel_sdvo_set_target_input(psb_intel_output,
+						false,
+						true);
+		psb_intel_sdvo_get_input_timing(psb_intel_output,
+					    &sdvo_priv->save_input_dtd_2);
+	}
+	sdvo_priv->save_SDVOX = REG_READ(sdvo_priv->output_device);
+
+	/*TODO: save the in_out_map state*/
+}
+
+static void psb_intel_sdvo_restore(struct drm_connector *connector)
+{
+	struct drm_device *dev = connector->dev;
+	struct psb_intel_output *psb_intel_output =
+					to_psb_intel_output(connector);
+	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
+	/*int o;*/
+	int i;
+	bool input1, input2;
+	u8 status;
+
+	psb_intel_sdvo_set_active_outputs(psb_intel_output, 0);
+
+	if (sdvo_priv->caps.sdvo_inputs_mask & 0x1) {
+		psb_intel_sdvo_set_target_input(psb_intel_output, true, false);
+		psb_intel_sdvo_set_input_timing(psb_intel_output,
+					    &sdvo_priv->save_input_dtd_1);
+	}
+
+	if (sdvo_priv->caps.sdvo_inputs_mask & 0x2) {
+		psb_intel_sdvo_set_target_input(psb_intel_output, false, true);
+		psb_intel_sdvo_set_input_timing(psb_intel_output,
+					    &sdvo_priv->save_input_dtd_2);
+	}
+
+	psb_intel_sdvo_set_clock_rate_mult(psb_intel_output,
+				       sdvo_priv->save_sdvo_mult);
+
+	REG_WRITE(sdvo_priv->output_device, sdvo_priv->save_SDVOX);
+
+	if (sdvo_priv->save_SDVOX & SDVO_ENABLE) {
+		for (i = 0; i < 2; i++)
+			psb_intel_wait_for_vblank(dev);
+		status =
+		    psb_intel_sdvo_get_trained_inputs(psb_intel_output,
+							&input1,
+							&input2);
+		if (status == SDVO_CMD_STATUS_SUCCESS && !input1)
+			DRM_DEBUG
+			    ("First %s output reported failure to sync\n",
+			     SDVO_NAME(sdvo_priv));
+	}
+
+	psb_intel_sdvo_set_active_outputs(psb_intel_output,
+				      sdvo_priv->save_active_outputs);
+
+	/*TODO: restore in_out_map*/
+	psb_intel_sdvo_write_cmd(psb_intel_output,
+				 SDVO_CMD_SET_IN_OUT_MAP,
+				 sdvo_priv->in_out_map,
+				 4);
+
+	psb_intel_sdvo_read_response(psb_intel_output, NULL, 0);
+}
+
+static int psb_intel_sdvo_mode_valid(struct drm_connector *connector,
+				 struct drm_display_mode *mode)
+{
+	struct psb_intel_output *psb_intel_output =
+				to_psb_intel_output(connector);
+	struct psb_intel_sdvo_priv *sdvo_priv = psb_intel_output->dev_priv;
+
+	if (mode->flags & DRM_MODE_FLAG_DBLSCAN)
+		return MODE_NO_DBLESCAN;
+
+	if (sdvo_priv->pixel_clock_min > mode->clock)
+		return MODE_CLOCK_LOW;
+
+	if (sdvo_priv->pixel_clock_max < mode->clock)
+		return MODE_CLOCK_HIGH;
+
+	return MODE_OK;
+}
+
+static bool psb_intel_sdvo_get_capabilities(
+				struct psb_intel_output *psb_intel_output,
+				struct psb_intel_sdvo_caps *caps)
+{
+	u8 status;
+
+	psb_intel_sdvo_write_cmd(psb_intel_output,
+				 SDVO_CMD_GET_DEVICE_CAPS,
+				 NULL,
+				 0);
+	status = psb_intel_sdvo_read_response(psb_intel_output,
+						caps,
+						sizeof(*caps));
+	if (status != SDVO_CMD_STATUS_SUCCESS)
+		return false;
+
+	return true;
+}
+
+struct drm_connector *psb_intel_sdvo_find(struct drm_device *dev, int sdvoB)
+{
+	struct drm_connector *connector = NULL;
+	struct psb_intel_output *iout = NULL;
+	struct psb_intel_sdvo_priv *sdvo;
+
+	/* find the sdvo connector */
+	list_for_each_entry(connector, &dev->mode_config.connector_list,
+			    head) {
+		iout = to_psb_intel_output(connector);
+
+		if (iout->type != INTEL_OUTPUT_SDVO)
+			continue;
+
+		sdvo = iout->dev_priv;
+
+		if (sdvo->output_device == SDVOB && sdvoB)
+			return connector;
+
+		if (sdvo->output_device == SDVOC && !sdvoB)
+			return connector;
+
+	}
+
+	return NULL;
+}
+
+int psb_intel_sdvo_supports_hotplug(struct drm_connector *connector)
+{
+	u8 response[2];
+	u8 status;
+	struct psb_intel_output *psb_intel_output;
+	DRM_DEBUG("\n");
+
+	if (!connector)
+		return 0;
+
+	psb_intel_output = to_psb_intel_output(connector);
+
+	psb_intel_sdvo_write_cmd(psb_intel_output,
+				 SDVO_CMD_GET_HOT_PLUG_SUPPORT,
+				 NULL,
+				 0);
+	status = psb_intel_sdvo_read_response(psb_intel_output,
+						&response,
+						2);
+
+	if (response[0] != 0)
+		return 1;
+
+	return 0;
+}
+
+void psb_intel_sdvo_set_hotplug(struct drm_connector *connector, int on)
+{
+	u8 response[2];
+	u8 status;
+	struct psb_intel_output *psb_intel_output =
+					to_psb_intel_output(connector);
+
+	psb_intel_sdvo_write_cmd(psb_intel_output,
+				 SDVO_CMD_GET_ACTIVE_HOT_PLUG,
+				 NULL,
+				 0);
+	psb_intel_sdvo_read_response(psb_intel_output, &response, 2);
+
+	if (on) {
+		psb_intel_sdvo_write_cmd(psb_intel_output,
+				     SDVO_CMD_GET_HOT_PLUG_SUPPORT, NULL,
+				     0);
+		status = psb_intel_sdvo_read_response(psb_intel_output,
+						      &response,
+						      2);
+
+		psb_intel_sdvo_write_cmd(psb_intel_output,
+				     SDVO_CMD_SET_ACTIVE_HOT_PLUG,
+				     &response, 2);
+	} else {
+		response[0] = 0;
+		response[1] = 0;
+		psb_intel_sdvo_write_cmd(psb_intel_output,
+				     SDVO_CMD_SET_ACTIVE_HOT_PLUG,
+				     &response, 2);
+	}
+
+	psb_intel_sdvo_write_cmd(psb_intel_output,
+				 SDVO_CMD_GET_ACTIVE_HOT_PLUG,
+				 NULL,
+				 0);
+	psb_intel_sdvo_read_response(psb_intel_output, &response, 2);
+}
+
+static enum drm_connector_status psb_intel_sdvo_detect(struct drm_connector
+						   *connector, bool force)
+{
+	u8 response[2];
+	u8 status;
+	struct psb_intel_output *psb_intel_output =
+					to_psb_intel_output(connector);
+
+	psb_intel_sdvo_write_cmd(psb_intel_output,
+				 SDVO_CMD_GET_ATTACHED_DISPLAYS,
+				 NULL,
+				 0);
+	status = psb_intel_sdvo_read_response(psb_intel_output, &response, 2);
+
+	DRM_DEBUG("SDVO response %d %d\n", response[0], response[1]);
+	if ((response[0] != 0) || (response[1] != 0))
+		return connector_status_connected;
+	else
+		return connector_status_disconnected;
+}
+
+static int psb_intel_sdvo_get_modes(struct drm_connector *connector)
+{
+	struct psb_intel_output *psb_intel_output =
+					to_psb_intel_output(connector);
+
+	/* set the bus switch and get the modes */
+	psb_intel_sdvo_set_control_bus_switch(psb_intel_output,
+					  SDVO_CONTROL_BUS_DDC2);
+	psb_intel_ddc_get_modes(psb_intel_output);
+
+	if (list_empty(&connector->probed_modes))
+		return 0;
+	return 1;
+}
+
+static void psb_intel_sdvo_destroy(struct drm_connector *connector)
+{
+	struct psb_intel_output *psb_intel_output =
+				to_psb_intel_output(connector);
+
+	if (psb_intel_output->i2c_bus)
+		psb_intel_i2c_destroy(psb_intel_output->i2c_bus);
+	drm_sysfs_connector_remove(connector);
+	drm_connector_cleanup(connector);
+	kfree(psb_intel_output);
+}
+
+static const struct drm_encoder_helper_funcs psb_intel_sdvo_helper_funcs = {
+	.dpms = psb_intel_sdvo_dpms,
+	.mode_fixup = psb_intel_sdvo_mode_fixup,
+	.prepare = psb_intel_encoder_prepare,
+	.mode_set = psb_intel_sdvo_mode_set,
+	.commit = psb_intel_encoder_commit,
+};
+
+static const struct drm_connector_funcs psb_intel_sdvo_connector_funcs = {
+	.dpms = drm_helper_connector_dpms,
+	.save = psb_intel_sdvo_save,
+	.restore = psb_intel_sdvo_restore,
+	.detect = psb_intel_sdvo_detect,
+	.fill_modes = drm_helper_probe_single_connector_modes,
+	.destroy = psb_intel_sdvo_destroy,
+};
+
+static const struct drm_connector_helper_funcs
+				psb_intel_sdvo_connector_helper_funcs = {
+	.get_modes = psb_intel_sdvo_get_modes,
+	.mode_valid = psb_intel_sdvo_mode_valid,
+	.best_encoder = psb_intel_best_encoder,
+};
+
+void psb_intel_sdvo_enc_destroy(struct drm_encoder *encoder)
+{
+	drm_encoder_cleanup(encoder);
+}
+
+static const struct drm_encoder_funcs psb_intel_sdvo_enc_funcs = {
+	.destroy = psb_intel_sdvo_enc_destroy,
+};
+
+
+void psb_intel_sdvo_init(struct drm_device *dev, int output_device)
+{
+	struct drm_connector *connector;
+	struct psb_intel_output *psb_intel_output;
+	struct psb_intel_sdvo_priv *sdvo_priv;
+	struct psb_intel_i2c_chan *i2cbus = NULL;
+	int connector_type;
+	u8 ch[0x40];
+	int i;
+	int encoder_type, output_id;
+
+	psb_intel_output =
+	    kcalloc(sizeof(struct psb_intel_output) +
+		    sizeof(struct psb_intel_sdvo_priv), 1, GFP_KERNEL);
+	if (!psb_intel_output)
+		return;
+
+	connector = &psb_intel_output->base;
+
+	drm_connector_init(dev, connector, &psb_intel_sdvo_connector_funcs,
+			   DRM_MODE_CONNECTOR_Unknown);
+	drm_connector_helper_add(connector,
+				 &psb_intel_sdvo_connector_helper_funcs);
+	sdvo_priv = (struct psb_intel_sdvo_priv *) (psb_intel_output + 1);
+	psb_intel_output->type = INTEL_OUTPUT_SDVO;
+
+	connector->interlace_allowed = 0;
+	connector->doublescan_allowed = 0;
+
+	/* setup the DDC bus. */
+	if (output_device == SDVOB)
+		i2cbus =
+		    psb_intel_i2c_create(dev, GPIOE, "SDVOCTRL_E for SDVOB");
+	else
+		i2cbus =
+		    psb_intel_i2c_create(dev, GPIOE, "SDVOCTRL_E for SDVOC");
+
+	if (!i2cbus)
+		goto err_connector;
+
+	sdvo_priv->i2c_bus = i2cbus;
+
+	if (output_device == SDVOB) {
+		output_id = 1;
+		sdvo_priv->by_input_wiring = SDVOB_IN0;
+		sdvo_priv->i2c_bus->slave_addr = 0x38;
+	} else {
+		output_id = 2;
+		sdvo_priv->i2c_bus->slave_addr = 0x39;
+	}
+
+	sdvo_priv->output_device = output_device;
+	psb_intel_output->i2c_bus = i2cbus;
+	psb_intel_output->dev_priv = sdvo_priv;
+
+
+	/* Read the regs to test if we can talk to the device */
+	for (i = 0; i < 0x40; i++) {
+		if (!psb_intel_sdvo_read_byte(psb_intel_output, i, &ch[i])) {
+			DRM_DEBUG("No SDVO device found on SDVO%c\n",
+				  output_device == SDVOB ? 'B' : 'C');
+			goto err_i2c;
+		}
+	}
+
+	psb_intel_sdvo_get_capabilities(psb_intel_output, &sdvo_priv->caps);
+
+	memset(&sdvo_priv->active_outputs, 0,
+	       sizeof(sdvo_priv->active_outputs));
+
+	/* TODO, CVBS, SVID, YPRPB & SCART outputs. */
+	if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_RGB0) {
+		sdvo_priv->active_outputs = SDVO_OUTPUT_RGB0;
+		sdvo_priv->active_device = SDVO_DEVICE_CRT;
+		connector->display_info.subpixel_order =
+		    SubPixelHorizontalRGB;
+		encoder_type = DRM_MODE_ENCODER_DAC;
+		connector_type = DRM_MODE_CONNECTOR_VGA;
+	} else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_RGB1) {
+		sdvo_priv->active_outputs = SDVO_OUTPUT_RGB1;
+		sdvo_priv->active_outputs = SDVO_DEVICE_CRT;
+		connector->display_info.subpixel_order =
+		    SubPixelHorizontalRGB;
+		encoder_type = DRM_MODE_ENCODER_DAC;
+		connector_type = DRM_MODE_CONNECTOR_VGA;
+	} else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_TMDS0) {
+		sdvo_priv->active_outputs = SDVO_OUTPUT_TMDS0;
+		sdvo_priv->active_device = SDVO_DEVICE_TMDS;
+		connector->display_info.subpixel_order =
+		    SubPixelHorizontalRGB;
+		encoder_type = DRM_MODE_ENCODER_TMDS;
+		connector_type = DRM_MODE_CONNECTOR_DVID;
+	} else if (sdvo_priv->caps.output_flags & SDVO_OUTPUT_TMDS1) {
+		sdvo_priv->active_outputs = SDVO_OUTPUT_TMDS1;
+		sdvo_priv->active_device = SDVO_DEVICE_TMDS;
+		connector->display_info.subpixel_order =
+		    SubPixelHorizontalRGB;
+		encoder_type = DRM_MODE_ENCODER_TMDS;
+		connector_type = DRM_MODE_CONNECTOR_DVID;
+	} else {
+		unsigned char bytes[2];
+
+		memcpy(bytes, &sdvo_priv->caps.output_flags, 2);
+		DRM_DEBUG
+		    ("%s: No active RGB or TMDS outputs (0x%02x%02x)\n",
+		     SDVO_NAME(sdvo_priv), bytes[0], bytes[1]);
+		goto err_i2c;
+	}
+
+	drm_encoder_init(dev, &psb_intel_output->enc, &psb_intel_sdvo_enc_funcs,
+			 encoder_type);
+	drm_encoder_helper_add(&psb_intel_output->enc,
+			       &psb_intel_sdvo_helper_funcs);
+	connector->connector_type = connector_type;
+
+	drm_mode_connector_attach_encoder(&psb_intel_output->base,
+					  &psb_intel_output->enc);
+	drm_sysfs_connector_add(connector);
+
+	/* Set the input timing to the screen. Assume always input 0. */
+	psb_intel_sdvo_set_target_input(psb_intel_output, true, false);
+
+	psb_intel_sdvo_get_input_pixel_clock_range(psb_intel_output,
+					       &sdvo_priv->pixel_clock_min,
+					       &sdvo_priv->
+					       pixel_clock_max);
+
+
+	DRM_DEBUG("%s device VID/DID: %02X:%02X.%02X, "
+		  "clock range %dMHz - %dMHz, "
+		  "input 1: %c, input 2: %c, "
+		  "output 1: %c, output 2: %c\n",
+		  SDVO_NAME(sdvo_priv),
+		  sdvo_priv->caps.vendor_id, sdvo_priv->caps.device_id,
+		  sdvo_priv->caps.device_rev_id,
+		  sdvo_priv->pixel_clock_min / 1000,
+		  sdvo_priv->pixel_clock_max / 1000,
+		  (sdvo_priv->caps.sdvo_inputs_mask & 0x1) ? 'Y' : 'N',
+		  (sdvo_priv->caps.sdvo_inputs_mask & 0x2) ? 'Y' : 'N',
+		  /* check currently supported outputs */
+		  sdvo_priv->caps.output_flags &
+		  (SDVO_OUTPUT_TMDS0 | SDVO_OUTPUT_RGB0) ? 'Y' : 'N',
+		  sdvo_priv->caps.output_flags &
+		  (SDVO_OUTPUT_TMDS1 | SDVO_OUTPUT_RGB1) ? 'Y' : 'N');
+
+	psb_intel_output->ddc_bus = i2cbus;
+
+	return;
+
+err_i2c:
+	psb_intel_i2c_destroy(psb_intel_output->i2c_bus);
+err_connector:
+	drm_connector_cleanup(connector);
+	kfree(psb_intel_output);
+
+	return;
+}
diff --git a/drivers/staging/gma500/psb_intel_sdvo_regs.h b/drivers/staging/gma500/psb_intel_sdvo_regs.h
new file mode 100644
index 0000000..ed2f136
--- /dev/null
+++ b/drivers/staging/gma500/psb_intel_sdvo_regs.h
@@ -0,0 +1,338 @@
+/*
+ * SDVO command definitions and structures.
+ *  
+ * Copyright (c) 2008, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors:
+ *	Eric Anholt <eric@anholt.net>
+ */
+
+#define SDVO_OUTPUT_FIRST   (0)
+#define SDVO_OUTPUT_TMDS0   (1 << 0)
+#define SDVO_OUTPUT_RGB0    (1 << 1)
+#define SDVO_OUTPUT_CVBS0   (1 << 2)
+#define SDVO_OUTPUT_SVID0   (1 << 3)
+#define SDVO_OUTPUT_YPRPB0  (1 << 4)
+#define SDVO_OUTPUT_SCART0  (1 << 5)
+#define SDVO_OUTPUT_LVDS0   (1 << 6)
+#define SDVO_OUTPUT_TMDS1   (1 << 8)
+#define SDVO_OUTPUT_RGB1    (1 << 9)
+#define SDVO_OUTPUT_CVBS1   (1 << 10)
+#define SDVO_OUTPUT_SVID1   (1 << 11)
+#define SDVO_OUTPUT_YPRPB1  (1 << 12)
+#define SDVO_OUTPUT_SCART1  (1 << 13)
+#define SDVO_OUTPUT_LVDS1   (1 << 14)
+#define SDVO_OUTPUT_LAST    (14)
+
+struct psb_intel_sdvo_caps {
+	u8 vendor_id;
+	u8 device_id;
+	u8 device_rev_id;
+	u8 sdvo_version_major;
+	u8 sdvo_version_minor;
+	unsigned int sdvo_inputs_mask:2;
+	unsigned int smooth_scaling:1;
+	unsigned int sharp_scaling:1;
+	unsigned int up_scaling:1;
+	unsigned int down_scaling:1;
+	unsigned int stall_support:1;
+	unsigned int pad:1;
+	u16 output_flags;
+} __attribute__ ((packed));
+
+/** This matches the EDID DTD structure, more or less */
+struct psb_intel_sdvo_dtd {
+	struct {
+		u16 clock;	/**< pixel clock, in 10kHz units */
+		u8 h_active;	/**< lower 8 bits (pixels) */
+		u8 h_blank;	/**< lower 8 bits (pixels) */
+		u8 h_high;	/**< upper 4 bits each h_active, h_blank */
+		u8 v_active;	/**< lower 8 bits (lines) */
+		u8 v_blank;	/**< lower 8 bits (lines) */
+		u8 v_high;	/**< upper 4 bits each v_active, v_blank */
+	} part1;
+
+	struct {
+		u8 h_sync_off;
+			/**< lower 8 bits, from hblank start */
+		u8 h_sync_width;/**< lower 8 bits (pixels) */
+	/** lower 4 bits each vsync offset, vsync width */
+		u8 v_sync_off_width;
+	/**
+	 * 2 high bits of hsync offset, 2 high bits of hsync width,
+	 * bits 4-5 of vsync offset, and 2 high bits of vsync width.
+	 */
+		u8 sync_off_width_high;
+		u8 dtd_flags;
+		u8 sdvo_flags;
+	/** bits 6-7 of vsync offset at bits 6-7 */
+		u8 v_sync_off_high;
+		u8 reserved;
+	} part2;
+} __attribute__ ((packed));
+
+struct psb_intel_sdvo_pixel_clock_range {
+	u16 min;		/**< pixel clock, in 10kHz units */
+	u16 max;		/**< pixel clock, in 10kHz units */
+} __attribute__ ((packed));
+
+struct psb_intel_sdvo_preferred_input_timing_args {
+	u16 clock;
+	u16 width;
+	u16 height;
+} __attribute__ ((packed));
+
+/* I2C registers for SDVO */
+#define SDVO_I2C_ARG_0				0x07
+#define SDVO_I2C_ARG_1				0x06
+#define SDVO_I2C_ARG_2				0x05
+#define SDVO_I2C_ARG_3				0x04
+#define SDVO_I2C_ARG_4				0x03
+#define SDVO_I2C_ARG_5				0x02
+#define SDVO_I2C_ARG_6				0x01
+#define SDVO_I2C_ARG_7				0x00
+#define SDVO_I2C_OPCODE				0x08
+#define SDVO_I2C_CMD_STATUS			0x09
+#define SDVO_I2C_RETURN_0			0x0a
+#define SDVO_I2C_RETURN_1			0x0b
+#define SDVO_I2C_RETURN_2			0x0c
+#define SDVO_I2C_RETURN_3			0x0d
+#define SDVO_I2C_RETURN_4			0x0e
+#define SDVO_I2C_RETURN_5			0x0f
+#define SDVO_I2C_RETURN_6			0x10
+#define SDVO_I2C_RETURN_7			0x11
+#define SDVO_I2C_VENDOR_BEGIN			0x20
+
+/* Status results */
+#define SDVO_CMD_STATUS_POWER_ON		0x0
+#define SDVO_CMD_STATUS_SUCCESS			0x1
+#define SDVO_CMD_STATUS_NOTSUPP			0x2
+#define SDVO_CMD_STATUS_INVALID_ARG		0x3
+#define SDVO_CMD_STATUS_PENDING			0x4
+#define SDVO_CMD_STATUS_TARGET_NOT_SPECIFIED	0x5
+#define SDVO_CMD_STATUS_SCALING_NOT_SUPP	0x6
+
+/* SDVO commands, argument/result registers */
+
+#define SDVO_CMD_RESET					0x01
+
+/** Returns a struct psb_intel_sdvo_caps */
+#define SDVO_CMD_GET_DEVICE_CAPS			0x02
+
+#define SDVO_CMD_GET_FIRMWARE_REV			0x86
+# define SDVO_DEVICE_FIRMWARE_MINOR			SDVO_I2C_RETURN_0
+# define SDVO_DEVICE_FIRMWARE_MAJOR			SDVO_I2C_RETURN_1
+# define SDVO_DEVICE_FIRMWARE_PATCH			SDVO_I2C_RETURN_2
+
+/**
+ * Reports which inputs are trained (managed to sync).
+ *
+ * Devices must have trained within 2 vsyncs of a mode change.
+ */
+#define SDVO_CMD_GET_TRAINED_INPUTS			0x03
+struct psb_intel_sdvo_get_trained_inputs_response {
+	unsigned int input0_trained:1;
+	unsigned int input1_trained:1;
+	unsigned int pad:6;
+} __attribute__ ((packed));
+
+/** Returns a struct psb_intel_sdvo_output_flags of active outputs. */
+#define SDVO_CMD_GET_ACTIVE_OUTPUTS			0x04
+
+/**
+ * Sets the current set of active outputs.
+ *
+ * Takes a struct psb_intel_sdvo_output_flags.
+ * Must be preceded by a SET_IN_OUT_MAP
+ * on multi-output devices.
+ */
+#define SDVO_CMD_SET_ACTIVE_OUTPUTS			0x05
+
+/**
+ * Returns the current mapping of SDVO inputs to outputs on the device.
+ *
+ * Returns two struct psb_intel_sdvo_output_flags structures.
+ */
+#define SDVO_CMD_GET_IN_OUT_MAP				0x06
+
+/**
+ * Sets the current mapping of SDVO inputs to outputs on the device.
+ *
+ * Takes two struct i380_sdvo_output_flags structures.
+ */
+#define SDVO_CMD_SET_IN_OUT_MAP				0x07
+
+/**
+ * Returns a struct psb_intel_sdvo_output_flags of attached displays.
+ */
+#define SDVO_CMD_GET_ATTACHED_DISPLAYS			0x0b
+
+/**
+ * Returns a struct psb_intel_sdvo_ouptut_flags of displays supporting hot plugging.
+ */
+#define SDVO_CMD_GET_HOT_PLUG_SUPPORT			0x0c
+
+/**
+ * Takes a struct psb_intel_sdvo_output_flags.
+ */
+#define SDVO_CMD_SET_ACTIVE_HOT_PLUG			0x0d
+
+/**
+ * Returns a struct psb_intel_sdvo_output_flags of displays with hot plug
+ * interrupts enabled.
+ */
+#define SDVO_CMD_GET_ACTIVE_HOT_PLUG			0x0e
+
+#define SDVO_CMD_GET_INTERRUPT_EVENT_SOURCE		0x0f
+struct psb_intel_sdvo_get_interrupt_event_source_response {
+	u16 interrupt_status;
+	unsigned int ambient_light_interrupt:1;
+	unsigned int pad:7;
+} __attribute__ ((packed));
+
+/**
+ * Selects which input is affected by future input commands.
+ *
+ * Commands affected include SET_INPUT_TIMINGS_PART[12],
+ * GET_INPUT_TIMINGS_PART[12], GET_PREFERRED_INPUT_TIMINGS_PART[12],
+ * GET_INPUT_PIXEL_CLOCK_RANGE, and CREATE_PREFERRED_INPUT_TIMINGS.
+ */
+#define SDVO_CMD_SET_TARGET_INPUT			0x10
+struct psb_intel_sdvo_set_target_input_args {
+	unsigned int target_1:1;
+	unsigned int pad:7;
+} __attribute__ ((packed));
+
+/**
+ * Takes a struct psb_intel_sdvo_output_flags of which outputs are targetted by
+ * future output commands.
+ *
+ * Affected commands inclue SET_OUTPUT_TIMINGS_PART[12],
+ * GET_OUTPUT_TIMINGS_PART[12], and GET_OUTPUT_PIXEL_CLOCK_RANGE.
+ */
+#define SDVO_CMD_SET_TARGET_OUTPUT			0x11
+
+#define SDVO_CMD_GET_INPUT_TIMINGS_PART1		0x12
+#define SDVO_CMD_GET_INPUT_TIMINGS_PART2		0x13
+#define SDVO_CMD_SET_INPUT_TIMINGS_PART1		0x14
+#define SDVO_CMD_SET_INPUT_TIMINGS_PART2		0x15
+#define SDVO_CMD_SET_OUTPUT_TIMINGS_PART1		0x16
+#define SDVO_CMD_SET_OUTPUT_TIMINGS_PART2		0x17
+#define SDVO_CMD_GET_OUTPUT_TIMINGS_PART1		0x18
+#define SDVO_CMD_GET_OUTPUT_TIMINGS_PART2		0x19
+/* Part 1 */
+# define SDVO_DTD_CLOCK_LOW				SDVO_I2C_ARG_0
+# define SDVO_DTD_CLOCK_HIGH				SDVO_I2C_ARG_1
+# define SDVO_DTD_H_ACTIVE				SDVO_I2C_ARG_2
+# define SDVO_DTD_H_BLANK				SDVO_I2C_ARG_3
+# define SDVO_DTD_H_HIGH				SDVO_I2C_ARG_4
+# define SDVO_DTD_V_ACTIVE				SDVO_I2C_ARG_5
+# define SDVO_DTD_V_BLANK				SDVO_I2C_ARG_6
+# define SDVO_DTD_V_HIGH				SDVO_I2C_ARG_7
+/* Part 2 */
+# define SDVO_DTD_HSYNC_OFF				SDVO_I2C_ARG_0
+# define SDVO_DTD_HSYNC_WIDTH				SDVO_I2C_ARG_1
+# define SDVO_DTD_VSYNC_OFF_WIDTH			SDVO_I2C_ARG_2
+# define SDVO_DTD_SYNC_OFF_WIDTH_HIGH			SDVO_I2C_ARG_3
+# define SDVO_DTD_DTD_FLAGS				SDVO_I2C_ARG_4
+# define SDVO_DTD_DTD_FLAG_INTERLACED				(1 << 7)
+# define SDVO_DTD_DTD_FLAG_STEREO_MASK				(3 << 5)
+# define SDVO_DTD_DTD_FLAG_INPUT_MASK				(3 << 3)
+# define SDVO_DTD_DTD_FLAG_SYNC_MASK				(3 << 1)
+# define SDVO_DTD_SDVO_FLAS				SDVO_I2C_ARG_5
+# define SDVO_DTD_SDVO_FLAG_STALL				(1 << 7)
+# define SDVO_DTD_SDVO_FLAG_CENTERED				(0 << 6)
+# define SDVO_DTD_SDVO_FLAG_UPPER_LEFT				(1 << 6)
+# define SDVO_DTD_SDVO_FLAG_SCALING_MASK			(3 << 4)
+# define SDVO_DTD_SDVO_FLAG_SCALING_NONE			(0 << 4)
+# define SDVO_DTD_SDVO_FLAG_SCALING_SHARP			(1 << 4)
+# define SDVO_DTD_SDVO_FLAG_SCALING_SMOOTH			(2 << 4)
+# define SDVO_DTD_VSYNC_OFF_HIGH			SDVO_I2C_ARG_6
+
+/**
+ * Generates a DTD based on the given width, height, and flags.
+ *
+ * This will be supported by any device supporting scaling or interlaced
+ * modes.
+ */
+#define SDVO_CMD_CREATE_PREFERRED_INPUT_TIMING		0x1a
+# define SDVO_PREFERRED_INPUT_TIMING_CLOCK_LOW		SDVO_I2C_ARG_0
+# define SDVO_PREFERRED_INPUT_TIMING_CLOCK_HIGH		SDVO_I2C_ARG_1
+# define SDVO_PREFERRED_INPUT_TIMING_WIDTH_LOW		SDVO_I2C_ARG_2
+# define SDVO_PREFERRED_INPUT_TIMING_WIDTH_HIGH		SDVO_I2C_ARG_3
+# define SDVO_PREFERRED_INPUT_TIMING_HEIGHT_LOW		SDVO_I2C_ARG_4
+# define SDVO_PREFERRED_INPUT_TIMING_HEIGHT_HIGH	SDVO_I2C_ARG_5
+# define SDVO_PREFERRED_INPUT_TIMING_FLAGS		SDVO_I2C_ARG_6
+# define SDVO_PREFERRED_INPUT_TIMING_FLAGS_INTERLACED		(1 << 0)
+# define SDVO_PREFERRED_INPUT_TIMING_FLAGS_SCALED		(1 << 1)
+
+#define SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART1	0x1b
+#define SDVO_CMD_GET_PREFERRED_INPUT_TIMING_PART2	0x1c
+
+/** Returns a struct psb_intel_sdvo_pixel_clock_range */
+#define SDVO_CMD_GET_INPUT_PIXEL_CLOCK_RANGE		0x1d
+/** Returns a struct psb_intel_sdvo_pixel_clock_range */
+#define SDVO_CMD_GET_OUTPUT_PIXEL_CLOCK_RANGE		0x1e
+
+/** Returns a byte bitfield containing SDVO_CLOCK_RATE_MULT_* flags */
+#define SDVO_CMD_GET_SUPPORTED_CLOCK_RATE_MULTS		0x1f
+
+/** Returns a byte containing a SDVO_CLOCK_RATE_MULT_* flag */
+#define SDVO_CMD_GET_CLOCK_RATE_MULT			0x20
+/** Takes a byte containing a SDVO_CLOCK_RATE_MULT_* flag */
+#define SDVO_CMD_SET_CLOCK_RATE_MULT			0x21
+# define SDVO_CLOCK_RATE_MULT_1X				(1 << 0)
+# define SDVO_CLOCK_RATE_MULT_2X				(1 << 1)
+# define SDVO_CLOCK_RATE_MULT_4X				(1 << 3)
+
+#define SDVO_CMD_GET_SUPPORTED_TV_FORMATS		0x27
+
+#define SDVO_CMD_GET_TV_FORMAT				0x28
+
+#define SDVO_CMD_SET_TV_FORMAT				0x29
+
+#define SDVO_CMD_GET_SUPPORTED_POWER_STATES		0x2a
+#define SDVO_CMD_GET_ENCODER_POWER_STATE		0x2b
+#define SDVO_CMD_SET_ENCODER_POWER_STATE		0x2c
+# define SDVO_ENCODER_STATE_ON					(1 << 0)
+# define SDVO_ENCODER_STATE_STANDBY				(1 << 1)
+# define SDVO_ENCODER_STATE_SUSPEND				(1 << 2)
+# define SDVO_ENCODER_STATE_OFF					(1 << 3)
+
+#define SDVO_CMD_SET_TV_RESOLUTION_SUPPORT		0x93
+
+#define SDVO_CMD_SET_CONTROL_BUS_SWITCH			0x7a
+# define SDVO_CONTROL_BUS_PROM				0x0
+# define SDVO_CONTROL_BUS_DDC1				0x1
+# define SDVO_CONTROL_BUS_DDC2				0x2
+# define SDVO_CONTROL_BUS_DDC3				0x3
+
+/* SDVO Bus & SDVO Inputs wiring details*/
+/* Bit 0: Is SDVOB connected to In0 (1 = yes, 0 = no*/
+/* Bit 1: Is SDVOB connected to In1 (1 = yes, 0 = no*/
+/* Bit 2: Is SDVOC connected to In0 (1 = yes, 0 = no*/
+/* Bit 3: Is SDVOC connected to In1 (1 = yes, 0 = no*/
+#define SDVOB_IN0 0x01
+#define SDVOB_IN1 0x02
+#define SDVOC_IN0 0x04
+#define SDVOC_IN1 0x08
+
+#define SDVO_DEVICE_NONE 0x00
+#define        SDVO_DEVICE_CRT 0x01
+#define        SDVO_DEVICE_TV 0x02
+#define        SDVO_DEVICE_LVDS 0x04
+#define        SDVO_DEVICE_TMDS 0x08
+
diff --git a/drivers/staging/gma500/psb_irq.c b/drivers/staging/gma500/psb_irq.c
new file mode 100644
index 0000000..3cdcd1e
--- /dev/null
+++ b/drivers/staging/gma500/psb_irq.c
@@ -0,0 +1,637 @@
+/**************************************************************************
+ * Copyright (c) 2007, Intel Corporation.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Intel funded Tungsten Graphics (http://www.tungstengraphics.com) to
+ * develop this driver.
+ *
+ **************************************************************************/
+/*
+ */
+
+#include <drm/drmP.h>
+#include "psb_drv.h"
+#include "psb_reg.h"
+#include "psb_intel_reg.h"
+#include "psb_powermgmt.h"
+
+
+/*
+ * inline functions
+ */
+
+static inline u32
+psb_pipestat(int pipe)
+{
+	if (pipe == 0)
+		return PIPEASTAT;
+	if (pipe == 1)
+		return PIPEBSTAT;
+	if (pipe == 2)
+		return PIPECSTAT;
+	BUG();
+}
+
+static inline u32
+mid_pipe_event(int pipe)
+{
+	if (pipe == 0)
+		return _PSB_PIPEA_EVENT_FLAG;
+	if (pipe == 1)
+		return _MDFLD_PIPEB_EVENT_FLAG;
+	if (pipe == 2)
+		return _MDFLD_PIPEC_EVENT_FLAG;
+	BUG();
+}
+
+static inline u32
+mid_pipe_vsync(int pipe)
+{
+	if (pipe == 0)
+		return _PSB_VSYNC_PIPEA_FLAG;
+	if (pipe == 1)
+		return _PSB_VSYNC_PIPEB_FLAG;
+	if (pipe == 2)
+		return _MDFLD_PIPEC_VBLANK_FLAG;
+	BUG();
+}
+
+static inline u32
+mid_pipeconf(int pipe)
+{
+	if (pipe == 0)
+		return PIPEACONF;
+	if (pipe == 1)
+		return PIPEBCONF;
+	if (pipe == 2)
+		return PIPECCONF;
+	BUG();
+}
+
+void
+psb_enable_pipestat(struct drm_psb_private *dev_priv, int pipe, u32 mask)
+{
+	if ((dev_priv->pipestat[pipe] & mask) != mask) {
+		u32 reg = psb_pipestat(pipe);
+		dev_priv->pipestat[pipe] |= mask;
+		/* Enable the interrupt, clear any pending status */
+		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+							OSPM_UHB_ONLY_IF_ON)) {
+			u32 writeVal = PSB_RVDC32(reg);
+			writeVal |= (mask | (mask >> 16));
+			PSB_WVDC32(writeVal, reg);
+			(void) PSB_RVDC32(reg);
+			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		}
+	}
+}
+
+void
+psb_disable_pipestat(struct drm_psb_private *dev_priv, int pipe, u32 mask)
+{
+	if ((dev_priv->pipestat[pipe] & mask) != 0) {
+		u32 reg = psb_pipestat(pipe);
+		dev_priv->pipestat[pipe] &= ~mask;
+		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+							OSPM_UHB_ONLY_IF_ON)) {
+			u32 writeVal = PSB_RVDC32(reg);
+			writeVal &= ~mask;
+			PSB_WVDC32(writeVal, reg);
+			(void) PSB_RVDC32(reg);
+			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		}
+	}
+}
+
+void mid_enable_pipe_event(struct drm_psb_private *dev_priv, int pipe)
+{
+	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+							OSPM_UHB_ONLY_IF_ON)) {
+		u32 pipe_event = mid_pipe_event(pipe);
+		dev_priv->vdc_irq_mask |= pipe_event;
+		PSB_WVDC32(~dev_priv->vdc_irq_mask, PSB_INT_MASK_R);
+		PSB_WVDC32(dev_priv->vdc_irq_mask, PSB_INT_ENABLE_R);
+		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	}
+}
+
+void mid_disable_pipe_event(struct drm_psb_private *dev_priv, int pipe)
+{
+	if (dev_priv->pipestat[pipe] == 0) {
+		if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+							OSPM_UHB_ONLY_IF_ON)) {
+			u32 pipe_event = mid_pipe_event(pipe);
+			dev_priv->vdc_irq_mask &= ~pipe_event;
+			PSB_WVDC32(~dev_priv->vdc_irq_mask, PSB_INT_MASK_R);
+			PSB_WVDC32(dev_priv->vdc_irq_mask, PSB_INT_ENABLE_R);
+			ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+		}
+	}
+}
+
+/**
+ * Display controller interrupt handler for vsync/vblank.
+ *
+ */
+static void mid_vblank_handler(struct drm_device *dev, uint32_t pipe)
+{
+	drm_handle_vblank(dev, pipe);
+}
+
+
+/**
+ * Display controller interrupt handler for pipe event.
+ *
+ */
+#define WAIT_STATUS_CLEAR_LOOP_COUNT 0xffff
+static void mid_pipe_event_handler(struct drm_device *dev, uint32_t pipe)
+{
+	struct drm_psb_private *dev_priv =
+	    (struct drm_psb_private *) dev->dev_private;
+
+	uint32_t pipe_stat_val = 0;
+	uint32_t pipe_stat_reg = psb_pipestat(pipe);
+	uint32_t pipe_enable = dev_priv->pipestat[pipe];
+	uint32_t pipe_status = dev_priv->pipestat[pipe] >> 16;
+	uint32_t i = 0;
+
+	spin_lock(&dev_priv->irqmask_lock);
+
+	pipe_stat_val = PSB_RVDC32(pipe_stat_reg);
+	pipe_stat_val &= pipe_enable | pipe_status;
+	pipe_stat_val &= pipe_stat_val >> 16;
+
+	spin_unlock(&dev_priv->irqmask_lock);
+
+	/* clear the 2nd level interrupt status bits */
+	/**
+	* FIXME: shouldn't use while loop here. However, the interrupt
+	* status 'sticky' bits cannot be cleared by setting '1' to that
+	* bit once...
+	*/
+	for (i = 0; i < WAIT_STATUS_CLEAR_LOOP_COUNT; i++) {
+		PSB_WVDC32(PSB_RVDC32(pipe_stat_reg), pipe_stat_reg);
+		(void) PSB_RVDC32(pipe_stat_reg);
+
+		if ((PSB_RVDC32(pipe_stat_reg) & pipe_status) == 0)
+			break;
+	}
+
+	if (i == WAIT_STATUS_CLEAR_LOOP_COUNT)
+		DRM_ERROR("%s, can't clear the status bits in pipe_stat_reg, its value = 0x%x.\n",
+			__func__, PSB_RVDC32(pipe_stat_reg));
+
+	if (pipe_stat_val & PIPE_VBLANK_STATUS)
+		mid_vblank_handler(dev, pipe);
+
+	if (pipe_stat_val & PIPE_TE_STATUS)
+		drm_handle_vblank(dev, pipe);
+}
+
+/*
+ * Display controller interrupt handler.
+ */
+static void psb_vdc_interrupt(struct drm_device *dev, uint32_t vdc_stat)
+{
+	if (vdc_stat & _PSB_PIPEA_EVENT_FLAG)
+		mid_pipe_event_handler(dev, 0);
+}
+
+irqreturn_t psb_irq_handler(DRM_IRQ_ARGS)
+{
+	struct drm_device *dev = (struct drm_device *) arg;
+	struct drm_psb_private *dev_priv =
+	    (struct drm_psb_private *) dev->dev_private;
+
+	uint32_t vdc_stat, dsp_int = 0, sgx_int = 0;
+	int handled = 0;
+
+	spin_lock(&dev_priv->irqmask_lock);
+
+	vdc_stat = PSB_RVDC32(PSB_INT_IDENTITY_R);
+
+	if (vdc_stat & _MDFLD_DISP_ALL_IRQ_FLAG) {
+		PSB_DEBUG_IRQ("Got DISP interrupt\n");
+		dsp_int = 1;
+	}
+
+	if (vdc_stat & _PSB_IRQ_SGX_FLAG) {
+		PSB_DEBUG_IRQ("Got SGX interrupt\n");
+		sgx_int = 1;
+	}
+	if (vdc_stat & _PSB_IRQ_MSVDX_FLAG)
+		PSB_DEBUG_IRQ("Got MSVDX interrupt\n");
+
+	if (vdc_stat & _LNC_IRQ_TOPAZ_FLAG)
+		PSB_DEBUG_IRQ("Got TOPAZ interrupt\n");
+
+
+	vdc_stat &= dev_priv->vdc_irq_mask;
+	spin_unlock(&dev_priv->irqmask_lock);
+
+	if (dsp_int && ospm_power_is_hw_on(OSPM_DISPLAY_ISLAND)) {
+		psb_vdc_interrupt(dev, vdc_stat);
+		handled = 1;
+	}
+
+	if (sgx_int) {
+		/* Not expected - we have it masked, shut it up */
+		u32 s, s2;
+		s = PSB_RSGX32(PSB_CR_EVENT_STATUS);
+		s2 = PSB_RSGX32(PSB_CR_EVENT_STATUS2);
+		PSB_WSGX32(s, PSB_CR_EVENT_HOST_CLEAR);
+		PSB_WSGX32(s2, PSB_CR_EVENT_HOST_CLEAR2);
+		/* if s & _PSB_CE_TWOD_COMPLETE we have 2D done but
+		   we may as well poll even if we add that ! */
+	}
+
+	PSB_WVDC32(vdc_stat, PSB_INT_IDENTITY_R);
+	(void) PSB_RVDC32(PSB_INT_IDENTITY_R);
+	DRM_READMEMORYBARRIER();
+
+	if (!handled)
+		return IRQ_NONE;
+
+	return IRQ_HANDLED;
+}
+
+void psb_irq_preinstall(struct drm_device *dev)
+{
+	psb_irq_preinstall_islands(dev, OSPM_ALL_ISLANDS);
+}
+
+/**
+ * FIXME: should I remove display irq enable here??
+ */
+void psb_irq_preinstall_islands(struct drm_device *dev, int hw_islands)
+{
+	struct drm_psb_private *dev_priv =
+	    (struct drm_psb_private *) dev->dev_private;
+	unsigned long irqflags;
+
+	PSB_DEBUG_ENTRY("\n");
+
+	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
+
+	if (hw_islands & OSPM_DISPLAY_ISLAND) {
+		if (ospm_power_is_hw_on(OSPM_DISPLAY_ISLAND)) {
+			PSB_WVDC32(0xFFFFFFFF, PSB_HWSTAM);
+			if (dev->vblank_enabled[0])
+				dev_priv->vdc_irq_mask |=
+						_PSB_PIPEA_EVENT_FLAG;
+			if (dev->vblank_enabled[1])
+				dev_priv->vdc_irq_mask |=
+						_MDFLD_PIPEB_EVENT_FLAG;
+			if (dev->vblank_enabled[2])
+				dev_priv->vdc_irq_mask |=
+						_MDFLD_PIPEC_EVENT_FLAG;
+		}
+	}
+	if (hw_islands & OSPM_GRAPHICS_ISLAND)
+		dev_priv->vdc_irq_mask |= _PSB_IRQ_SGX_FLAG;
+
+	/*This register is safe even if display island is off*/
+	PSB_WVDC32(~dev_priv->vdc_irq_mask, PSB_INT_MASK_R);
+
+	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
+}
+
+int psb_irq_postinstall(struct drm_device *dev)
+{
+	return psb_irq_postinstall_islands(dev, OSPM_ALL_ISLANDS);
+}
+
+int psb_irq_postinstall_islands(struct drm_device *dev, int hw_islands)
+{
+
+	struct drm_psb_private *dev_priv =
+	    (struct drm_psb_private *) dev->dev_private;
+	unsigned long irqflags;
+
+	PSB_DEBUG_ENTRY("\n");
+
+	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
+
+	/*This register is safe even if display island is off*/
+	PSB_WVDC32(dev_priv->vdc_irq_mask, PSB_INT_ENABLE_R);
+
+	if (hw_islands & OSPM_DISPLAY_ISLAND) {
+		if (true/*powermgmt_is_hw_on(dev->pdev, PSB_DISPLAY_ISLAND)*/) {
+			PSB_WVDC32(0xFFFFFFFF, PSB_HWSTAM);
+
+			if (dev->vblank_enabled[0])
+				psb_enable_pipestat(dev_priv, 0,
+				    PIPE_VBLANK_INTERRUPT_ENABLE);
+			else
+				psb_disable_pipestat(dev_priv, 0,
+				    PIPE_VBLANK_INTERRUPT_ENABLE);
+
+			if (dev->vblank_enabled[1])
+					psb_enable_pipestat(dev_priv, 1,
+					    PIPE_VBLANK_INTERRUPT_ENABLE);
+			else
+				psb_disable_pipestat(dev_priv, 1,
+				    PIPE_VBLANK_INTERRUPT_ENABLE);
+
+			if (dev->vblank_enabled[2])
+				psb_enable_pipestat(dev_priv, 2,
+				    PIPE_VBLANK_INTERRUPT_ENABLE);
+			else
+				psb_disable_pipestat(dev_priv, 2,
+				    PIPE_VBLANK_INTERRUPT_ENABLE);
+		}
+	}
+
+	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
+
+	return 0;
+}
+
+void psb_irq_uninstall(struct drm_device *dev)
+{
+	psb_irq_uninstall_islands(dev, OSPM_ALL_ISLANDS);
+}
+
+void psb_irq_uninstall_islands(struct drm_device *dev, int hw_islands)
+{
+	struct drm_psb_private *dev_priv =
+	    (struct drm_psb_private *) dev->dev_private;
+	unsigned long irqflags;
+
+	PSB_DEBUG_ENTRY("\n");
+
+	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
+
+	if (hw_islands & OSPM_DISPLAY_ISLAND) {
+		if (true/*powermgmt_is_hw_on(dev->pdev, PSB_DISPLAY_ISLAND)*/) {
+			PSB_WVDC32(0xFFFFFFFF, PSB_HWSTAM);
+
+			if (dev->vblank_enabled[0])
+				psb_disable_pipestat(dev_priv, 0,
+				    PIPE_VBLANK_INTERRUPT_ENABLE);
+
+			if (dev->vblank_enabled[1])
+				psb_disable_pipestat(dev_priv, 1,
+				    PIPE_VBLANK_INTERRUPT_ENABLE);
+
+			if (dev->vblank_enabled[2])
+				psb_disable_pipestat(dev_priv, 2,
+				    PIPE_VBLANK_INTERRUPT_ENABLE);
+		}
+		dev_priv->vdc_irq_mask &= _PSB_IRQ_SGX_FLAG |
+					  _PSB_IRQ_MSVDX_FLAG |
+					  _LNC_IRQ_TOPAZ_FLAG;
+	}
+	/*TODO: remove following code*/
+	if (hw_islands & OSPM_GRAPHICS_ISLAND)
+		dev_priv->vdc_irq_mask &= ~_PSB_IRQ_SGX_FLAG;
+
+	/*These two registers are safe even if display island is off*/
+	PSB_WVDC32(~dev_priv->vdc_irq_mask, PSB_INT_MASK_R);
+	PSB_WVDC32(dev_priv->vdc_irq_mask, PSB_INT_ENABLE_R);
+
+	wmb();
+
+	/*This register is safe even if display island is off*/
+	PSB_WVDC32(PSB_RVDC32(PSB_INT_IDENTITY_R), PSB_INT_IDENTITY_R);
+
+	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
+}
+
+void psb_irq_turn_on_dpst(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv =
+		(struct drm_psb_private *) dev->dev_private;
+	u32 hist_reg;
+	u32 pwm_reg;
+
+	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+							OSPM_UHB_ONLY_IF_ON)) {
+		PSB_WVDC32(BIT31, HISTOGRAM_LOGIC_CONTROL);
+		hist_reg = PSB_RVDC32(HISTOGRAM_LOGIC_CONTROL);
+		PSB_WVDC32(BIT31, HISTOGRAM_INT_CONTROL);
+		hist_reg = PSB_RVDC32(HISTOGRAM_INT_CONTROL);
+
+		PSB_WVDC32(0x80010100, PWM_CONTROL_LOGIC);
+		pwm_reg = PSB_RVDC32(PWM_CONTROL_LOGIC);
+		PSB_WVDC32(pwm_reg | PWM_PHASEIN_ENABLE
+						| PWM_PHASEIN_INT_ENABLE,
+							   PWM_CONTROL_LOGIC);
+		pwm_reg = PSB_RVDC32(PWM_CONTROL_LOGIC);
+
+		psb_enable_pipestat(dev_priv, 0, PIPE_DPST_EVENT_ENABLE);
+
+		hist_reg = PSB_RVDC32(HISTOGRAM_INT_CONTROL);
+		PSB_WVDC32(hist_reg | HISTOGRAM_INT_CTRL_CLEAR,
+							HISTOGRAM_INT_CONTROL);
+		pwm_reg = PSB_RVDC32(PWM_CONTROL_LOGIC);
+		PSB_WVDC32(pwm_reg | 0x80010100 | PWM_PHASEIN_ENABLE,
+							PWM_CONTROL_LOGIC);
+
+		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	}
+}
+
+int psb_irq_enable_dpst(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv =
+		(struct drm_psb_private *) dev->dev_private;
+	unsigned long irqflags;
+
+	PSB_DEBUG_ENTRY("\n");
+
+	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
+
+	/* enable DPST */
+	mid_enable_pipe_event(dev_priv, 0);
+	psb_irq_turn_on_dpst(dev);
+
+	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
+	return 0;
+}
+
+void psb_irq_turn_off_dpst(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv =
+	    (struct drm_psb_private *) dev->dev_private;
+	u32 hist_reg;
+	u32 pwm_reg;
+
+	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+							OSPM_UHB_ONLY_IF_ON)) {
+		PSB_WVDC32(0x00000000, HISTOGRAM_INT_CONTROL);
+		hist_reg = PSB_RVDC32(HISTOGRAM_INT_CONTROL);
+
+		psb_disable_pipestat(dev_priv, 0, PIPE_DPST_EVENT_ENABLE);
+
+		pwm_reg = PSB_RVDC32(PWM_CONTROL_LOGIC);
+		PSB_WVDC32(pwm_reg & !(PWM_PHASEIN_INT_ENABLE),
+							PWM_CONTROL_LOGIC);
+		pwm_reg = PSB_RVDC32(PWM_CONTROL_LOGIC);
+
+		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	}
+}
+
+int psb_irq_disable_dpst(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv =
+	    (struct drm_psb_private *) dev->dev_private;
+	unsigned long irqflags;
+
+	PSB_DEBUG_ENTRY("\n");
+
+	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
+
+	mid_disable_pipe_event(dev_priv, 0);
+	psb_irq_turn_off_dpst(dev);
+
+	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
+
+	return 0;
+}
+
+#ifdef PSB_FIXME
+static int psb_vblank_do_wait(struct drm_device *dev,
+			      unsigned int *sequence, atomic_t *counter)
+{
+	unsigned int cur_vblank;
+	int ret = 0;
+	DRM_WAIT_ON(ret, dev->vbl_queue, 3 * DRM_HZ,
+		    (((cur_vblank = atomic_read(counter))
+		      - *sequence) <= (1 << 23)));
+	*sequence = cur_vblank;
+
+	return ret;
+}
+#endif
+
+/*
+ * It is used to enable VBLANK interrupt
+ */
+int psb_enable_vblank(struct drm_device *dev, int pipe)
+{
+	struct drm_psb_private *dev_priv =
+	    (struct drm_psb_private *) dev->dev_private;
+	unsigned long irqflags;
+	uint32_t reg_val = 0;
+	uint32_t pipeconf_reg = mid_pipeconf(pipe);
+
+	PSB_DEBUG_ENTRY("\n");
+
+	if (ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND,
+							OSPM_UHB_ONLY_IF_ON)) {
+		reg_val = REG_READ(pipeconf_reg);
+		ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+	}
+
+	if (!(reg_val & PIPEACONF_ENABLE))
+		return -EINVAL;
+
+	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
+
+	drm_psb_disable_vsync = 0;
+	mid_enable_pipe_event(dev_priv, pipe);
+	psb_enable_pipestat(dev_priv, pipe, PIPE_VBLANK_INTERRUPT_ENABLE);
+
+	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
+
+	return 0;
+}
+
+/*
+ * It is used to disable VBLANK interrupt
+ */
+void psb_disable_vblank(struct drm_device *dev, int pipe)
+{
+	struct drm_psb_private *dev_priv =
+	    (struct drm_psb_private *) dev->dev_private;
+	unsigned long irqflags;
+
+	PSB_DEBUG_ENTRY("\n");
+
+	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
+
+	drm_psb_disable_vsync = 1;
+	mid_disable_pipe_event(dev_priv, pipe);
+	psb_disable_pipestat(dev_priv, pipe, PIPE_VBLANK_INTERRUPT_ENABLE);
+
+	spin_unlock_irqrestore(&dev_priv->irqmask_lock, irqflags);
+}
+
+/* Called from drm generic code, passed a 'crtc', which
+ * we use as a pipe index
+ */
+u32 psb_get_vblank_counter(struct drm_device *dev, int pipe)
+{
+	uint32_t high_frame = PIPEAFRAMEHIGH;
+	uint32_t low_frame = PIPEAFRAMEPIXEL;
+	uint32_t pipeconf_reg = PIPEACONF;
+	uint32_t reg_val = 0;
+	uint32_t high1 = 0, high2 = 0, low = 0, count = 0;
+
+	switch (pipe) {
+	case 0:
+		break;
+	case 1:
+		high_frame = PIPEBFRAMEHIGH;
+		low_frame = PIPEBFRAMEPIXEL;
+		pipeconf_reg = PIPEBCONF;
+		break;
+	case 2:
+		high_frame = PIPECFRAMEHIGH;
+		low_frame = PIPECFRAMEPIXEL;
+		pipeconf_reg = PIPECCONF;
+		break;
+	default:
+		DRM_ERROR("%s, invalded pipe.\n", __func__);
+		return 0;
+	}
+
+	if (!ospm_power_using_hw_begin(OSPM_DISPLAY_ISLAND, false))
+		return 0;
+
+	reg_val = REG_READ(pipeconf_reg);
+
+	if (!(reg_val & PIPEACONF_ENABLE)) {
+		DRM_ERROR("trying to get vblank count for disabled pipe %d\n",
+								pipe);
+		goto psb_get_vblank_counter_exit;
+	}
+
+	/*
+	 * High & low register fields aren't synchronized, so make sure
+	 * we get a low value that's stable across two reads of the high
+	 * register.
+	 */
+	do {
+		high1 = ((REG_READ(high_frame) & PIPE_FRAME_HIGH_MASK) >>
+			 PIPE_FRAME_HIGH_SHIFT);
+		low =  ((REG_READ(low_frame) & PIPE_FRAME_LOW_MASK) >>
+			PIPE_FRAME_LOW_SHIFT);
+		high2 = ((REG_READ(high_frame) & PIPE_FRAME_HIGH_MASK) >>
+			 PIPE_FRAME_HIGH_SHIFT);
+	} while (high1 != high2);
+
+	count = (high1 << 8) | low;
+
+psb_get_vblank_counter_exit:
+
+	ospm_power_using_hw_end(OSPM_DISPLAY_ISLAND);
+
+	return count;
+}
+
diff --git a/drivers/staging/gma500/psb_irq.h b/drivers/staging/gma500/psb_irq.h
new file mode 100644
index 0000000..3e56f33
--- /dev/null
+++ b/drivers/staging/gma500/psb_irq.h
@@ -0,0 +1,49 @@
+/**************************************************************************
+ * Copyright (c) 2009, Intel Corporation.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors:
+ *    Benjamin Defnet <benjamin.r.defnet@intel.com>
+ *    Rajesh Poornachandran <rajesh.poornachandran@intel.com>
+ *
+ **************************************************************************/
+
+#ifndef _SYSIRQ_H_
+#define _SYSIRQ_H_
+
+#include <drm/drmP.h>
+
+bool sysirq_init(struct drm_device *dev);
+void sysirq_uninit(struct drm_device *dev);
+
+void psb_irq_preinstall(struct drm_device *dev);
+int  psb_irq_postinstall(struct drm_device *dev);
+void psb_irq_uninstall(struct drm_device *dev);
+irqreturn_t psb_irq_handler(DRM_IRQ_ARGS);
+
+void psb_irq_preinstall_islands(struct drm_device *dev, int hw_islands);
+int  psb_irq_postinstall_islands(struct drm_device *dev, int hw_islands);
+void psb_irq_uninstall_islands(struct drm_device *dev, int hw_islands);
+
+int psb_irq_enable_dpst(struct drm_device *dev);
+int psb_irq_disable_dpst(struct drm_device *dev);
+void psb_irq_turn_on_dpst(struct drm_device *dev);
+void psb_irq_turn_off_dpst(struct drm_device *dev);
+int  psb_enable_vblank(struct drm_device *dev, int pipe);
+void psb_disable_vblank(struct drm_device *dev, int pipe);
+u32  psb_get_vblank_counter(struct drm_device *dev, int pipe);
+
+#endif //_SYSIRQ_H_
diff --git a/drivers/staging/gma500/psb_mmu.c b/drivers/staging/gma500/psb_mmu.c
new file mode 100644
index 0000000..edd0d49
--- /dev/null
+++ b/drivers/staging/gma500/psb_mmu.c
@@ -0,0 +1,919 @@
+/**************************************************************************
+ * Copyright (c) 2007, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+#include <drm/drmP.h>
+#include "psb_drv.h"
+#include "psb_reg.h"
+
+/*
+ * Code for the SGX MMU:
+ */
+
+/*
+ * clflush on one processor only:
+ * clflush should apparently flush the cache line on all processors in an
+ * SMP system.
+ */
+
+/*
+ * kmap atomic:
+ * The usage of the slots must be completely encapsulated within a spinlock, and
+ * no other functions that may be using the locks for other purposed may be
+ * called from within the locked region.
+ * Since the slots are per processor, this will guarantee that we are the only
+ * user.
+ */
+
+/*
+ * TODO: Inserting ptes from an interrupt handler:
+ * This may be desirable for some SGX functionality where the GPU can fault in
+ * needed pages. For that, we need to make an atomic insert_pages function, that
+ * may fail.
+ * If it fails, the caller need to insert the page using a workqueue function,
+ * but on average it should be fast.
+ */
+
+struct psb_mmu_driver {
+	/* protects driver- and pd structures. Always take in read mode
+	 * before taking the page table spinlock.
+	 */
+	struct rw_semaphore sem;
+
+	/* protects page tables, directory tables and pt tables.
+	 * and pt structures.
+	 */
+	spinlock_t lock;
+
+	atomic_t needs_tlbflush;
+
+	uint8_t __iomem *register_map;
+	struct psb_mmu_pd *default_pd;
+	/*uint32_t bif_ctrl;*/
+	int has_clflush;
+	int clflush_add;
+	unsigned long clflush_mask;
+
+	struct drm_psb_private *dev_priv;
+};
+
+struct psb_mmu_pd;
+
+struct psb_mmu_pt {
+	struct psb_mmu_pd *pd;
+	uint32_t index;
+	uint32_t count;
+	struct page *p;
+	uint32_t *v;
+};
+
+struct psb_mmu_pd {
+	struct psb_mmu_driver *driver;
+	int hw_context;
+	struct psb_mmu_pt **tables;
+	struct page *p;
+	struct page *dummy_pt;
+	struct page *dummy_page;
+	uint32_t pd_mask;
+	uint32_t invalid_pde;
+	uint32_t invalid_pte;
+};
+
+static inline uint32_t psb_mmu_pt_index(uint32_t offset)
+{
+	return (offset >> PSB_PTE_SHIFT) & 0x3FF;
+}
+
+static inline uint32_t psb_mmu_pd_index(uint32_t offset)
+{
+	return offset >> PSB_PDE_SHIFT;
+}
+
+static inline void psb_clflush(void *addr)
+{
+	__asm__ __volatile__("clflush (%0)\n" : : "r"(addr) : "memory");
+}
+
+static inline void psb_mmu_clflush(struct psb_mmu_driver *driver,
+				   void *addr)
+{
+	if (!driver->has_clflush)
+		return;
+
+	mb();
+	psb_clflush(addr);
+	mb();
+}
+
+static void psb_page_clflush(struct psb_mmu_driver *driver, struct page* page)
+{
+	uint32_t clflush_add = driver->clflush_add >> PAGE_SHIFT;
+	uint32_t clflush_count = PAGE_SIZE / clflush_add;
+	int i;
+	uint8_t *clf;
+
+	clf = kmap_atomic(page, KM_USER0);
+	mb();
+	for (i = 0; i < clflush_count; ++i) {
+		psb_clflush(clf);
+		clf += clflush_add;
+	}
+	mb();
+	kunmap_atomic(clf, KM_USER0);
+}
+
+static void psb_pages_clflush(struct psb_mmu_driver *driver,
+				struct page *page[], unsigned long num_pages)
+{
+	int i;
+
+	if (!driver->has_clflush)
+		return ;
+
+	for (i = 0; i < num_pages; i++)
+		psb_page_clflush(driver, *page++);
+}
+
+static void psb_mmu_flush_pd_locked(struct psb_mmu_driver *driver,
+				    int force)
+{
+	atomic_set(&driver->needs_tlbflush, 0);
+}
+
+static void psb_mmu_flush_pd(struct psb_mmu_driver *driver, int force)
+{
+	down_write(&driver->sem);
+	psb_mmu_flush_pd_locked(driver, force);
+	up_write(&driver->sem);
+}
+
+void psb_mmu_flush(struct psb_mmu_driver *driver, int rc_prot)
+{
+	if (rc_prot)
+		down_write(&driver->sem);
+	if (rc_prot)
+		up_write(&driver->sem);
+}
+
+void psb_mmu_set_pd_context(struct psb_mmu_pd *pd, int hw_context)
+{
+	/*ttm_tt_cache_flush(&pd->p, 1);*/
+	psb_pages_clflush(pd->driver, &pd->p, 1);
+	down_write(&pd->driver->sem);
+	wmb();
+	psb_mmu_flush_pd_locked(pd->driver, 1);
+	pd->hw_context = hw_context;
+	up_write(&pd->driver->sem);
+
+}
+
+static inline unsigned long psb_pd_addr_end(unsigned long addr,
+					    unsigned long end)
+{
+
+	addr = (addr + PSB_PDE_MASK + 1) & ~PSB_PDE_MASK;
+	return (addr < end) ? addr : end;
+}
+
+static inline uint32_t psb_mmu_mask_pte(uint32_t pfn, int type)
+{
+	uint32_t mask = PSB_PTE_VALID;
+
+	if (type & PSB_MMU_CACHED_MEMORY)
+		mask |= PSB_PTE_CACHED;
+	if (type & PSB_MMU_RO_MEMORY)
+		mask |= PSB_PTE_RO;
+	if (type & PSB_MMU_WO_MEMORY)
+		mask |= PSB_PTE_WO;
+
+	return (pfn << PAGE_SHIFT) | mask;
+}
+
+struct psb_mmu_pd *psb_mmu_alloc_pd(struct psb_mmu_driver *driver,
+				    int trap_pagefaults, int invalid_type)
+{
+	struct psb_mmu_pd *pd = kmalloc(sizeof(*pd), GFP_KERNEL);
+	uint32_t *v;
+	int i;
+
+	if (!pd)
+		return NULL;
+
+	pd->p = alloc_page(GFP_DMA32);
+	if (!pd->p)
+		goto out_err1;
+	pd->dummy_pt = alloc_page(GFP_DMA32);
+	if (!pd->dummy_pt)
+		goto out_err2;
+	pd->dummy_page = alloc_page(GFP_DMA32);
+	if (!pd->dummy_page)
+		goto out_err3;
+
+	if (!trap_pagefaults) {
+		pd->invalid_pde =
+		    psb_mmu_mask_pte(page_to_pfn(pd->dummy_pt),
+				     invalid_type);
+		pd->invalid_pte =
+		    psb_mmu_mask_pte(page_to_pfn(pd->dummy_page),
+				     invalid_type);
+	} else {
+		pd->invalid_pde = 0;
+		pd->invalid_pte = 0;
+	}
+
+	v = kmap(pd->dummy_pt);
+	for (i = 0; i < (PAGE_SIZE / sizeof(uint32_t)); ++i)
+		v[i] = pd->invalid_pte;
+
+	kunmap(pd->dummy_pt);
+
+	v = kmap(pd->p);
+	for (i = 0; i < (PAGE_SIZE / sizeof(uint32_t)); ++i)
+		v[i] = pd->invalid_pde;
+
+	kunmap(pd->p);
+
+	clear_page(kmap(pd->dummy_page));
+	kunmap(pd->dummy_page);
+
+	pd->tables = vmalloc_user(sizeof(struct psb_mmu_pt *) * 1024);
+	if (!pd->tables)
+		goto out_err4;
+
+	pd->hw_context = -1;
+	pd->pd_mask = PSB_PTE_VALID;
+	pd->driver = driver;
+
+	return pd;
+
+out_err4:
+	__free_page(pd->dummy_page);
+out_err3:
+	__free_page(pd->dummy_pt);
+out_err2:
+	__free_page(pd->p);
+out_err1:
+	kfree(pd);
+	return NULL;
+}
+
+void psb_mmu_free_pt(struct psb_mmu_pt *pt)
+{
+	__free_page(pt->p);
+	kfree(pt);
+}
+
+void psb_mmu_free_pagedir(struct psb_mmu_pd *pd)
+{
+	struct psb_mmu_driver *driver = pd->driver;
+	struct psb_mmu_pt *pt;
+	int i;
+
+	down_write(&driver->sem);
+	if (pd->hw_context != -1)
+		psb_mmu_flush_pd_locked(driver, 1);
+
+	/* Should take the spinlock here, but we don't need to do that
+	   since we have the semaphore in write mode. */
+
+	for (i = 0; i < 1024; ++i) {
+		pt = pd->tables[i];
+		if (pt)
+			psb_mmu_free_pt(pt);
+	}
+
+	vfree(pd->tables);
+	__free_page(pd->dummy_page);
+	__free_page(pd->dummy_pt);
+	__free_page(pd->p);
+	kfree(pd);
+	up_write(&driver->sem);
+}
+
+static struct psb_mmu_pt *psb_mmu_alloc_pt(struct psb_mmu_pd *pd)
+{
+	struct psb_mmu_pt *pt = kmalloc(sizeof(*pt), GFP_KERNEL);
+	void *v;
+	uint32_t clflush_add = pd->driver->clflush_add >> PAGE_SHIFT;
+	uint32_t clflush_count = PAGE_SIZE / clflush_add;
+	spinlock_t *lock = &pd->driver->lock;
+	uint8_t *clf;
+	uint32_t *ptes;
+	int i;
+
+	if (!pt)
+		return NULL;
+
+	pt->p = alloc_page(GFP_DMA32);
+	if (!pt->p) {
+		kfree(pt);
+		return NULL;
+	}
+
+	spin_lock(lock);
+
+	v = kmap_atomic(pt->p, KM_USER0);
+	clf = (uint8_t *) v;
+	ptes = (uint32_t *) v;
+	for (i = 0; i < (PAGE_SIZE / sizeof(uint32_t)); ++i)
+		*ptes++ = pd->invalid_pte;
+
+
+	if (pd->driver->has_clflush && pd->hw_context != -1) {
+		mb();
+		for (i = 0; i < clflush_count; ++i) {
+			psb_clflush(clf);
+			clf += clflush_add;
+		}
+		mb();
+	}
+
+	kunmap_atomic(v, KM_USER0);
+	spin_unlock(lock);
+
+	pt->count = 0;
+	pt->pd = pd;
+	pt->index = 0;
+
+	return pt;
+}
+
+struct psb_mmu_pt *psb_mmu_pt_alloc_map_lock(struct psb_mmu_pd *pd,
+					     unsigned long addr)
+{
+	uint32_t index = psb_mmu_pd_index(addr);
+	struct psb_mmu_pt *pt;
+	uint32_t *v;
+	spinlock_t *lock = &pd->driver->lock;
+
+	spin_lock(lock);
+	pt = pd->tables[index];
+	while (!pt) {
+		spin_unlock(lock);
+		pt = psb_mmu_alloc_pt(pd);
+		if (!pt)
+			return NULL;
+		spin_lock(lock);
+
+		if (pd->tables[index]) {
+			spin_unlock(lock);
+			psb_mmu_free_pt(pt);
+			spin_lock(lock);
+			pt = pd->tables[index];
+			continue;
+		}
+
+		v = kmap_atomic(pd->p, KM_USER0);
+		pd->tables[index] = pt;
+		v[index] = (page_to_pfn(pt->p) << 12) | pd->pd_mask;
+		pt->index = index;
+		kunmap_atomic((void *) v, KM_USER0);
+
+		if (pd->hw_context != -1) {
+			psb_mmu_clflush(pd->driver, (void *) &v[index]);
+			atomic_set(&pd->driver->needs_tlbflush, 1);
+		}
+	}
+	pt->v = kmap_atomic(pt->p, KM_USER0);
+	return pt;
+}
+
+static struct psb_mmu_pt *psb_mmu_pt_map_lock(struct psb_mmu_pd *pd,
+					      unsigned long addr)
+{
+	uint32_t index = psb_mmu_pd_index(addr);
+	struct psb_mmu_pt *pt;
+	spinlock_t *lock = &pd->driver->lock;
+
+	spin_lock(lock);
+	pt = pd->tables[index];
+	if (!pt) {
+		spin_unlock(lock);
+		return NULL;
+	}
+	pt->v = kmap_atomic(pt->p, KM_USER0);
+	return pt;
+}
+
+static void psb_mmu_pt_unmap_unlock(struct psb_mmu_pt *pt)
+{
+	struct psb_mmu_pd *pd = pt->pd;
+	uint32_t *v;
+
+	kunmap_atomic(pt->v, KM_USER0);
+	if (pt->count == 0) {
+		v = kmap_atomic(pd->p, KM_USER0);
+		v[pt->index] = pd->invalid_pde;
+		pd->tables[pt->index] = NULL;
+
+		if (pd->hw_context != -1) {
+			psb_mmu_clflush(pd->driver,
+					(void *) &v[pt->index]);
+			atomic_set(&pd->driver->needs_tlbflush, 1);
+		}
+		kunmap_atomic(pt->v, KM_USER0);
+		spin_unlock(&pd->driver->lock);
+		psb_mmu_free_pt(pt);
+		return;
+	}
+	spin_unlock(&pd->driver->lock);
+}
+
+static inline void psb_mmu_set_pte(struct psb_mmu_pt *pt,
+				   unsigned long addr, uint32_t pte)
+{
+	pt->v[psb_mmu_pt_index(addr)] = pte;
+}
+
+static inline void psb_mmu_invalidate_pte(struct psb_mmu_pt *pt,
+					  unsigned long addr)
+{
+	pt->v[psb_mmu_pt_index(addr)] = pt->pd->invalid_pte;
+}
+
+#if 0
+static uint32_t psb_mmu_check_pte_locked(struct psb_mmu_pd *pd,
+					 uint32_t mmu_offset)
+{
+	uint32_t *v;
+	uint32_t pfn;
+
+	v = kmap_atomic(pd->p, KM_USER0);
+	if (!v) {
+		printk(KERN_INFO "Could not kmap pde page.\n");
+		return 0;
+	}
+	pfn = v[psb_mmu_pd_index(mmu_offset)];
+	/*      printk(KERN_INFO "pde is 0x%08x\n",pfn); */
+	kunmap_atomic(v, KM_USER0);
+	if (((pfn & 0x0F) != PSB_PTE_VALID)) {
+		printk(KERN_INFO "Strange pde at 0x%08x: 0x%08x.\n",
+		       mmu_offset, pfn);
+	}
+	v = ioremap(pfn & 0xFFFFF000, 4096);
+	if (!v) {
+		printk(KERN_INFO "Could not kmap pte page.\n");
+		return 0;
+	}
+	pfn = v[psb_mmu_pt_index(mmu_offset)];
+	/* printk(KERN_INFO "pte is 0x%08x\n",pfn); */
+	iounmap(v);
+	if (((pfn & 0x0F) != PSB_PTE_VALID)) {
+		printk(KERN_INFO "Strange pte at 0x%08x: 0x%08x.\n",
+		       mmu_offset, pfn);
+	}
+	return pfn >> PAGE_SHIFT;
+}
+
+static void psb_mmu_check_mirrored_gtt(struct psb_mmu_pd *pd,
+				       uint32_t mmu_offset,
+				       uint32_t gtt_pages)
+{
+	uint32_t start;
+	uint32_t next;
+
+	printk(KERN_INFO "Checking mirrored gtt 0x%08x %d\n",
+	       mmu_offset, gtt_pages);
+	down_read(&pd->driver->sem);
+	start = psb_mmu_check_pte_locked(pd, mmu_offset);
+	mmu_offset += PAGE_SIZE;
+	gtt_pages -= 1;
+	while (gtt_pages--) {
+		next = psb_mmu_check_pte_locked(pd, mmu_offset);
+		if (next != start + 1) {
+			printk(KERN_INFO
+			       "Ptes out of order: 0x%08x, 0x%08x.\n",
+			       start, next);
+		}
+		start = next;
+		mmu_offset += PAGE_SIZE;
+	}
+	up_read(&pd->driver->sem);
+}
+
+#endif
+
+void psb_mmu_mirror_gtt(struct psb_mmu_pd *pd,
+			uint32_t mmu_offset, uint32_t gtt_start,
+			uint32_t gtt_pages)
+{
+	uint32_t *v;
+	uint32_t start = psb_mmu_pd_index(mmu_offset);
+	struct psb_mmu_driver *driver = pd->driver;
+	int num_pages = gtt_pages;
+
+	down_read(&driver->sem);
+	spin_lock(&driver->lock);
+
+	v = kmap_atomic(pd->p, KM_USER0);
+	v += start;
+
+	while (gtt_pages--) {
+		*v++ = gtt_start | pd->pd_mask;
+		gtt_start += PAGE_SIZE;
+	}
+
+	/*ttm_tt_cache_flush(&pd->p, num_pages);*/
+	psb_pages_clflush(pd->driver, &pd->p, num_pages);
+	kunmap_atomic(v, KM_USER0);
+	spin_unlock(&driver->lock);
+
+	if (pd->hw_context != -1)
+		atomic_set(&pd->driver->needs_tlbflush, 1);
+
+	up_read(&pd->driver->sem);
+	psb_mmu_flush_pd(pd->driver, 0);
+}
+
+struct psb_mmu_pd *psb_mmu_get_default_pd(struct psb_mmu_driver *driver)
+{
+	struct psb_mmu_pd *pd;
+
+	/* down_read(&driver->sem); */
+	pd = driver->default_pd;
+	/* up_read(&driver->sem); */
+
+	return pd;
+}
+
+/* Returns the physical address of the PD shared by sgx/msvdx */
+uint32_t psb_get_default_pd_addr(struct psb_mmu_driver *driver)
+{
+	struct psb_mmu_pd *pd;
+
+	pd = psb_mmu_get_default_pd(driver);
+	return page_to_pfn(pd->p) << PAGE_SHIFT;
+}
+
+void psb_mmu_driver_takedown(struct psb_mmu_driver *driver)
+{
+	psb_mmu_free_pagedir(driver->default_pd);
+	kfree(driver);
+}
+
+struct psb_mmu_driver *psb_mmu_driver_init(uint8_t __iomem * registers,
+					int trap_pagefaults,
+					int invalid_type,
+					struct drm_psb_private *dev_priv)
+{
+	struct psb_mmu_driver *driver;
+
+	driver = kmalloc(sizeof(*driver), GFP_KERNEL);
+
+	if (!driver)
+		return NULL;
+	driver->dev_priv = dev_priv;
+
+	driver->default_pd = psb_mmu_alloc_pd(driver, trap_pagefaults,
+					      invalid_type);
+	if (!driver->default_pd)
+		goto out_err1;
+
+	spin_lock_init(&driver->lock);
+	init_rwsem(&driver->sem);
+	down_write(&driver->sem);
+	driver->register_map = registers;
+	atomic_set(&driver->needs_tlbflush, 1);
+
+	driver->has_clflush = 0;
+
+	if (boot_cpu_has(X86_FEATURE_CLFLSH)) {
+		uint32_t tfms, misc, cap0, cap4, clflush_size;
+
+		/*
+		 * clflush size is determined at kernel setup for x86_64
+		 *  but not for i386. We have to do it here.
+		 */
+
+		cpuid(0x00000001, &tfms, &misc, &cap0, &cap4);
+		clflush_size = ((misc >> 8) & 0xff) * 8;
+		driver->has_clflush = 1;
+		driver->clflush_add =
+		    PAGE_SIZE * clflush_size / sizeof(uint32_t);
+		driver->clflush_mask = driver->clflush_add - 1;
+		driver->clflush_mask = ~driver->clflush_mask;
+	}
+
+	up_write(&driver->sem);
+	return driver;
+
+out_err1:
+	kfree(driver);
+	return NULL;
+}
+
+static void psb_mmu_flush_ptes(struct psb_mmu_pd *pd,
+			       unsigned long address, uint32_t num_pages,
+			       uint32_t desired_tile_stride,
+			       uint32_t hw_tile_stride)
+{
+	struct psb_mmu_pt *pt;
+	uint32_t rows = 1;
+	uint32_t i;
+	unsigned long addr;
+	unsigned long end;
+	unsigned long next;
+	unsigned long add;
+	unsigned long row_add;
+	unsigned long clflush_add = pd->driver->clflush_add;
+	unsigned long clflush_mask = pd->driver->clflush_mask;
+
+	if (!pd->driver->has_clflush) {
+		/*ttm_tt_cache_flush(&pd->p, num_pages);*/
+		psb_pages_clflush(pd->driver, &pd->p, num_pages);
+		return;
+	}
+
+	if (hw_tile_stride)
+		rows = num_pages / desired_tile_stride;
+	else
+		desired_tile_stride = num_pages;
+
+	add = desired_tile_stride << PAGE_SHIFT;
+	row_add = hw_tile_stride << PAGE_SHIFT;
+	mb();
+	for (i = 0; i < rows; ++i) {
+
+		addr = address;
+		end = addr + add;
+
+		do {
+			next = psb_pd_addr_end(addr, end);
+			pt = psb_mmu_pt_map_lock(pd, addr);
+			if (!pt)
+				continue;
+			do {
+				psb_clflush(&pt->v
+					    [psb_mmu_pt_index(addr)]);
+			} while (addr +=
+				 clflush_add,
+				 (addr & clflush_mask) < next);
+
+			psb_mmu_pt_unmap_unlock(pt);
+		} while (addr = next, next != end);
+		address += row_add;
+	}
+	mb();
+}
+
+void psb_mmu_remove_pfn_sequence(struct psb_mmu_pd *pd,
+				 unsigned long address, uint32_t num_pages)
+{
+	struct psb_mmu_pt *pt;
+	unsigned long addr;
+	unsigned long end;
+	unsigned long next;
+	unsigned long f_address = address;
+
+	down_read(&pd->driver->sem);
+
+	addr = address;
+	end = addr + (num_pages << PAGE_SHIFT);
+
+	do {
+		next = psb_pd_addr_end(addr, end);
+		pt = psb_mmu_pt_alloc_map_lock(pd, addr);
+		if (!pt)
+			goto out;
+		do {
+			psb_mmu_invalidate_pte(pt, addr);
+			--pt->count;
+		} while (addr += PAGE_SIZE, addr < next);
+		psb_mmu_pt_unmap_unlock(pt);
+
+	} while (addr = next, next != end);
+
+out:
+	if (pd->hw_context != -1)
+		psb_mmu_flush_ptes(pd, f_address, num_pages, 1, 1);
+
+	up_read(&pd->driver->sem);
+
+	if (pd->hw_context != -1)
+		psb_mmu_flush(pd->driver, 0);
+
+	return;
+}
+
+void psb_mmu_remove_pages(struct psb_mmu_pd *pd, unsigned long address,
+			  uint32_t num_pages, uint32_t desired_tile_stride,
+			  uint32_t hw_tile_stride)
+{
+	struct psb_mmu_pt *pt;
+	uint32_t rows = 1;
+	uint32_t i;
+	unsigned long addr;
+	unsigned long end;
+	unsigned long next;
+	unsigned long add;
+	unsigned long row_add;
+	unsigned long f_address = address;
+
+	if (hw_tile_stride)
+		rows = num_pages / desired_tile_stride;
+	else
+		desired_tile_stride = num_pages;
+
+	add = desired_tile_stride << PAGE_SHIFT;
+	row_add = hw_tile_stride << PAGE_SHIFT;
+
+	/* down_read(&pd->driver->sem); */
+
+	/* Make sure we only need to flush this processor's cache */
+
+	for (i = 0; i < rows; ++i) {
+
+		addr = address;
+		end = addr + add;
+
+		do {
+			next = psb_pd_addr_end(addr, end);
+			pt = psb_mmu_pt_map_lock(pd, addr);
+			if (!pt)
+				continue;
+			do {
+				psb_mmu_invalidate_pte(pt, addr);
+				--pt->count;
+
+			} while (addr += PAGE_SIZE, addr < next);
+			psb_mmu_pt_unmap_unlock(pt);
+
+		} while (addr = next, next != end);
+		address += row_add;
+	}
+	if (pd->hw_context != -1)
+		psb_mmu_flush_ptes(pd, f_address, num_pages,
+				   desired_tile_stride, hw_tile_stride);
+
+	/* up_read(&pd->driver->sem); */
+
+	if (pd->hw_context != -1)
+		psb_mmu_flush(pd->driver, 0);
+}
+
+int psb_mmu_insert_pfn_sequence(struct psb_mmu_pd *pd, uint32_t start_pfn,
+				unsigned long address, uint32_t num_pages,
+				int type)
+{
+	struct psb_mmu_pt *pt;
+	uint32_t pte;
+	unsigned long addr;
+	unsigned long end;
+	unsigned long next;
+	unsigned long f_address = address;
+	int ret = 0;
+
+	down_read(&pd->driver->sem);
+
+	addr = address;
+	end = addr + (num_pages << PAGE_SHIFT);
+
+	do {
+		next = psb_pd_addr_end(addr, end);
+		pt = psb_mmu_pt_alloc_map_lock(pd, addr);
+		if (!pt) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		do {
+			pte = psb_mmu_mask_pte(start_pfn++, type);
+			psb_mmu_set_pte(pt, addr, pte);
+			pt->count++;
+		} while (addr += PAGE_SIZE, addr < next);
+		psb_mmu_pt_unmap_unlock(pt);
+
+	} while (addr = next, next != end);
+
+out:
+	if (pd->hw_context != -1)
+		psb_mmu_flush_ptes(pd, f_address, num_pages, 1, 1);
+
+	up_read(&pd->driver->sem);
+
+	if (pd->hw_context != -1)
+		psb_mmu_flush(pd->driver, 1);
+
+	return ret;
+}
+
+int psb_mmu_insert_pages(struct psb_mmu_pd *pd, struct page **pages,
+			 unsigned long address, uint32_t num_pages,
+			 uint32_t desired_tile_stride,
+			 uint32_t hw_tile_stride, int type)
+{
+	struct psb_mmu_pt *pt;
+	uint32_t rows = 1;
+	uint32_t i;
+	uint32_t pte;
+	unsigned long addr;
+	unsigned long end;
+	unsigned long next;
+	unsigned long add;
+	unsigned long row_add;
+	unsigned long f_address = address;
+	int ret = 0;
+
+	if (hw_tile_stride) {
+		if (num_pages % desired_tile_stride != 0)
+			return -EINVAL;
+		rows = num_pages / desired_tile_stride;
+	} else {
+		desired_tile_stride = num_pages;
+	}
+
+	add = desired_tile_stride << PAGE_SHIFT;
+	row_add = hw_tile_stride << PAGE_SHIFT;
+
+	down_read(&pd->driver->sem);
+
+	for (i = 0; i < rows; ++i) {
+
+		addr = address;
+		end = addr + add;
+
+		do {
+			next = psb_pd_addr_end(addr, end);
+			pt = psb_mmu_pt_alloc_map_lock(pd, addr);
+			if (!pt) {
+				ret = -ENOMEM;
+				goto out;
+			}
+			do {
+				pte =
+				    psb_mmu_mask_pte(page_to_pfn(*pages++),
+						     type);
+				psb_mmu_set_pte(pt, addr, pte);
+				pt->count++;
+			} while (addr += PAGE_SIZE, addr < next);
+			psb_mmu_pt_unmap_unlock(pt);
+
+		} while (addr = next, next != end);
+
+		address += row_add;
+	}
+out:
+	if (pd->hw_context != -1)
+		psb_mmu_flush_ptes(pd, f_address, num_pages,
+				   desired_tile_stride, hw_tile_stride);
+
+	up_read(&pd->driver->sem);
+
+	if (pd->hw_context != -1)
+		psb_mmu_flush(pd->driver, 1);
+
+	return ret;
+}
+
+int psb_mmu_virtual_to_pfn(struct psb_mmu_pd *pd, uint32_t virtual,
+			   unsigned long *pfn)
+{
+	int ret;
+	struct psb_mmu_pt *pt;
+	uint32_t tmp;
+	spinlock_t *lock = &pd->driver->lock;
+
+	down_read(&pd->driver->sem);
+	pt = psb_mmu_pt_map_lock(pd, virtual);
+	if (!pt) {
+		uint32_t *v;
+
+		spin_lock(lock);
+		v = kmap_atomic(pd->p, KM_USER0);
+		tmp = v[psb_mmu_pd_index(virtual)];
+		kunmap_atomic(v, KM_USER0);
+		spin_unlock(lock);
+
+		if (tmp != pd->invalid_pde || !(tmp & PSB_PTE_VALID) ||
+		    !(pd->invalid_pte & PSB_PTE_VALID)) {
+			ret = -EINVAL;
+			goto out;
+		}
+		ret = 0;
+		*pfn = pd->invalid_pte >> PAGE_SHIFT;
+		goto out;
+	}
+	tmp = pt->v[psb_mmu_pt_index(virtual)];
+	if (!(tmp & PSB_PTE_VALID)) {
+		ret = -EINVAL;
+	} else {
+		ret = 0;
+		*pfn = tmp >> PAGE_SHIFT;
+	}
+	psb_mmu_pt_unmap_unlock(pt);
+out:
+	up_read(&pd->driver->sem);
+	return ret;
+}
diff --git a/drivers/staging/gma500/psb_powermgmt.c b/drivers/staging/gma500/psb_powermgmt.c
new file mode 100644
index 0000000..3a6ffb7
--- /dev/null
+++ b/drivers/staging/gma500/psb_powermgmt.c
@@ -0,0 +1,797 @@
+/**************************************************************************
+ * Copyright (c) 2009, Intel Corporation.
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
+ *
+ */
+#include "psb_powermgmt.h"
+#include "psb_drv.h"
+#include "psb_intel_reg.h"
+#include <linux/mutex.h>
+#include <linux/pm_runtime.h>
+
+#undef OSPM_GFX_DPK
+
+extern u32 gui32SGXDeviceID;
+extern u32 gui32MRSTDisplayDeviceID;
+extern u32 gui32MRSTMSVDXDeviceID;
+extern u32 gui32MRSTTOPAZDeviceID;
+
+struct drm_device *gpDrmDevice = NULL;
+static struct mutex power_mutex;
+static bool gbSuspendInProgress = false;
+static bool gbResumeInProgress = false;
+static int g_hw_power_status_mask;
+static atomic_t g_display_access_count;
+static atomic_t g_graphics_access_count;
+static atomic_t g_videoenc_access_count;
+static atomic_t g_videodec_access_count;
+int allow_runtime_pm = 0;
+
+void ospm_power_island_up(int hw_islands);
+void ospm_power_island_down(int hw_islands);
+static bool gbSuspended = false;
+bool gbgfxsuspended = false;
+
+/*
+ * ospm_power_init
+ *
+ * Description: Initialize this ospm power management module
+ */
+void ospm_power_init(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = (struct drm_psb_private *)dev->dev_private;
+
+	gpDrmDevice = dev;
+
+	dev_priv->apm_base = dev_priv->apm_reg & 0xffff;
+	dev_priv->ospm_base &= 0xffff;
+
+	mutex_init(&power_mutex);
+	g_hw_power_status_mask = OSPM_ALL_ISLANDS;
+	atomic_set(&g_display_access_count, 0);
+	atomic_set(&g_graphics_access_count, 0);
+	atomic_set(&g_videoenc_access_count, 0);
+	atomic_set(&g_videodec_access_count, 0);
+}
+
+/*
+ * ospm_power_uninit
+ *
+ * Description: Uninitialize this ospm power management module
+ */
+void ospm_power_uninit(void)
+{
+	mutex_destroy(&power_mutex);
+    	pm_runtime_disable(&gpDrmDevice->pdev->dev);
+	pm_runtime_set_suspended(&gpDrmDevice->pdev->dev);
+}
+
+
+/*
+ * save_display_registers
+ *
+ * Description: We are going to suspend so save current display
+ * register state.
+ */
+static int save_display_registers(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct drm_crtc * crtc;
+	struct drm_connector * connector;
+
+	/* Display arbitration control + watermarks */
+	dev_priv->saveDSPARB = PSB_RVDC32(DSPARB);
+	dev_priv->saveDSPFW1 = PSB_RVDC32(DSPFW1);
+	dev_priv->saveDSPFW2 = PSB_RVDC32(DSPFW2);
+	dev_priv->saveDSPFW3 = PSB_RVDC32(DSPFW3);
+	dev_priv->saveDSPFW4 = PSB_RVDC32(DSPFW4);
+	dev_priv->saveDSPFW5 = PSB_RVDC32(DSPFW5);
+	dev_priv->saveDSPFW6 = PSB_RVDC32(DSPFW6);
+	dev_priv->saveCHICKENBIT = PSB_RVDC32(DSPCHICKENBIT);
+
+	/*save crtc and output state*/
+	mutex_lock(&dev->mode_config.mutex);
+	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
+		if(drm_helper_crtc_in_use(crtc)) {
+			crtc->funcs->save(crtc);
+		}
+	}
+	
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		connector->funcs->save(connector);
+	}
+	mutex_unlock(&dev->mode_config.mutex);
+
+	/* Interrupt state */
+	/*
+	 * Handled in psb_irq.c
+	 */
+
+	return 0;
+}
+
+/*
+ * restore_display_registers
+ *
+ * Description: We are going to resume so restore display register state.
+ */
+static int restore_display_registers(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct drm_crtc * crtc;
+	struct drm_connector * connector;
+
+	/* Display arbitration + watermarks */
+	PSB_WVDC32(dev_priv->saveDSPARB, DSPARB);
+	PSB_WVDC32(dev_priv->saveDSPFW1, DSPFW1);
+	PSB_WVDC32(dev_priv->saveDSPFW2, DSPFW2);
+	PSB_WVDC32(dev_priv->saveDSPFW3, DSPFW3);
+	PSB_WVDC32(dev_priv->saveDSPFW4, DSPFW4);
+	PSB_WVDC32(dev_priv->saveDSPFW5, DSPFW5);
+	PSB_WVDC32(dev_priv->saveDSPFW6, DSPFW6);
+	PSB_WVDC32(dev_priv->saveCHICKENBIT, DSPCHICKENBIT);
+
+	/*make sure VGA plane is off. it initializes to on after reset!*/
+	PSB_WVDC32(0x80000000, VGACNTRL);
+
+	mutex_lock(&dev->mode_config.mutex);
+	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
+		if(drm_helper_crtc_in_use(crtc))
+			crtc->funcs->restore(crtc);
+	}
+	list_for_each_entry(connector, &dev->mode_config.connector_list, head) {
+		connector->funcs->restore(connector);
+	}
+	mutex_unlock(&dev->mode_config.mutex);
+
+	/*Interrupt state*/
+	/*
+	 * Handled in psb_irq.c
+	 */
+
+	return 0;
+}
+/*
+ * powermgmt_suspend_display
+ *
+ * Description: Suspend the display hardware saving state and disabling
+ * as necessary.
+ */
+void ospm_suspend_display(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int pp_stat, ret=0;
+
+	printk(KERN_ALERT "%s \n", __func__);
+
+#ifdef OSPM_GFX_DPK
+	printk(KERN_ALERT "%s \n", __func__);
+#endif
+	if (!(g_hw_power_status_mask & OSPM_DISPLAY_ISLAND))
+		return;
+
+	save_display_registers(dev);
+		
+	if (dev_priv->iLVDS_enable) {
+		/*shutdown the panel*/
+		PSB_WVDC32(0, PP_CONTROL);
+
+		do {
+			pp_stat = PSB_RVDC32(PP_STATUS);
+		} while (pp_stat & 0x80000000);
+
+		/*turn off the plane*/
+		PSB_WVDC32(0x58000000, DSPACNTR);
+		PSB_WVDC32(0, DSPASURF);/*trigger the plane disable*/
+		/*wait ~4 ticks*/
+		msleep(4);
+
+		/*turn off pipe*/
+		PSB_WVDC32(0x0, PIPEACONF);
+		/*wait ~8 ticks*/
+		msleep(8);
+
+		/*turn off PLLs*/
+		PSB_WVDC32(0, MRST_DPLL_A);
+	} else {
+		PSB_WVDC32(DPI_SHUT_DOWN, DPI_CONTROL_REG);
+		PSB_WVDC32(0x0, PIPEACONF);
+		PSB_WVDC32(0x2faf0000, BLC_PWM_CTL);
+		while (REG_READ(0x70008) & 0x40000000);
+		while ((PSB_RVDC32(GEN_FIFO_STAT_REG) & DPI_FIFO_EMPTY)
+			!= DPI_FIFO_EMPTY);
+		PSB_WVDC32(0, DEVICE_READY_REG);
+			/* turn off panel power */
+		ret = 0;
+	}
+	ospm_power_island_down(OSPM_DISPLAY_ISLAND);
+}
+
+/*
+ * ospm_resume_display
+ *
+ * Description: Resume the display hardware restoring state and enabling
+ * as necessary.
+ */
+void ospm_resume_display(struct pci_dev *pdev)
+{
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct psb_gtt *pg = dev_priv->pg;
+
+	printk(KERN_ALERT "%s \n", __func__);
+		
+#ifdef OSPM_GFX_DPK
+	printk(KERN_ALERT "%s \n", __func__);
+#endif
+	if (g_hw_power_status_mask & OSPM_DISPLAY_ISLAND)
+		return;
+
+	/* turn on the display power island */
+	ospm_power_island_up(OSPM_DISPLAY_ISLAND);
+
+	PSB_WVDC32(pg->pge_ctl | _PSB_PGETBL_ENABLED, PSB_PGETBL_CTL);
+	pci_write_config_word(pdev, PSB_GMCH_CTRL,
+			pg->gmch_ctrl | _PSB_GMCH_ENABLED);
+
+	/* Don't reinitialize the GTT as it is unnecessary.  The gtt is
+	 * stored in memory so it will automatically be restored.  All
+	 * we need to do is restore the PGETBL_CTL which we already do
+	 * above.
+	 */
+	/*psb_gtt_init(dev_priv->pg, 1);*/
+	
+	restore_display_registers(dev);
+}
+
+#if 1
+/*
+ * ospm_suspend_pci
+ *
+ * Description: Suspend the pci device saving state and disabling
+ * as necessary.
+ */
+static void ospm_suspend_pci(struct pci_dev *pdev)
+{
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int bsm, vbt;
+
+	if (gbSuspended)
+		return;
+
+#ifdef OSPM_GFX_DPK
+	printk(KERN_ALERT "ospm_suspend_pci\n");
+#endif
+
+#ifdef CONFIG_MDFD_GL3
+	// Power off GL3 after all GFX sub-systems are powered off.
+	ospm_power_island_down(OSPM_GL3_CACHE_ISLAND);
+#endif
+
+	pci_save_state(pdev);
+	pci_read_config_dword(pdev, 0x5C, &bsm);
+	dev_priv->saveBSM = bsm;
+	pci_read_config_dword(pdev, 0xFC, &vbt);
+	dev_priv->saveVBT = vbt;
+	pci_read_config_dword(pdev, PSB_PCIx_MSI_ADDR_LOC, &dev_priv->msi_addr);
+	pci_read_config_dword(pdev, PSB_PCIx_MSI_DATA_LOC, &dev_priv->msi_data);
+
+	pci_disable_device(pdev);
+	pci_set_power_state(pdev, PCI_D3hot);
+
+	gbSuspended = true;
+	gbgfxsuspended = true;
+}
+
+/*
+ * ospm_resume_pci
+ *
+ * Description: Resume the pci device restoring state and enabling
+ * as necessary.
+ */
+static bool ospm_resume_pci(struct pci_dev *pdev)
+{
+	struct drm_device *dev = pci_get_drvdata(pdev);
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	int ret = 0;
+
+	if (!gbSuspended)
+		return true;
+
+#ifdef OSPM_GFX_DPK
+	printk(KERN_ALERT "ospm_resume_pci\n");
+#endif
+
+	pci_set_power_state(pdev, PCI_D0);
+	pci_restore_state(pdev);
+	pci_write_config_dword(pdev, 0x5c, dev_priv->saveBSM);
+	pci_write_config_dword(pdev, 0xFC, dev_priv->saveVBT);
+	/* retoring MSI address and data in PCIx space */
+	pci_write_config_dword(pdev, PSB_PCIx_MSI_ADDR_LOC, dev_priv->msi_addr);
+	pci_write_config_dword(pdev, PSB_PCIx_MSI_DATA_LOC, dev_priv->msi_data);
+	ret = pci_enable_device(pdev);
+
+	if (ret != 0)
+		printk(KERN_ALERT "ospm_resume_pci: pci_enable_device failed: %d\n", ret);
+	else
+		gbSuspended = false;
+
+	return !gbSuspended;
+}
+#endif
+/*
+ * ospm_power_suspend
+ *
+ * Description: OSPM is telling our driver to suspend so save state
+ * and power down all hardware.
+ */
+int ospm_power_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+        int ret = 0;
+        int graphics_access_count;
+        int videoenc_access_count;
+        int videodec_access_count;
+        int display_access_count;
+    	bool suspend_pci = true; 
+
+	if(gbSuspendInProgress || gbResumeInProgress)
+        {
+#ifdef OSPM_GFX_DPK
+                printk(KERN_ALERT "OSPM_GFX_DPK: %s system BUSY \n", __func__);
+#endif
+                return  -EBUSY;
+        }
+
+        mutex_lock(&power_mutex);
+
+        if (!gbSuspended) {
+                graphics_access_count = atomic_read(&g_graphics_access_count);
+                videoenc_access_count = atomic_read(&g_videoenc_access_count);
+                videodec_access_count = atomic_read(&g_videodec_access_count);
+                display_access_count = atomic_read(&g_display_access_count);
+
+                if (graphics_access_count ||
+			videoenc_access_count ||
+			videodec_access_count ||
+			display_access_count)
+                        ret = -EBUSY;
+
+                if (!ret) {
+                        gbSuspendInProgress = true;
+
+                        psb_irq_uninstall_islands(gpDrmDevice, OSPM_DISPLAY_ISLAND);
+                        ospm_suspend_display(gpDrmDevice);
+                        if (suspend_pci == true) {
+				ospm_suspend_pci(pdev);
+                        }
+                        gbSuspendInProgress = false;
+                } else {
+                        printk(KERN_ALERT "ospm_power_suspend: device busy: graphics %d videoenc %d videodec %d display %d\n", graphics_access_count, videoenc_access_count, videodec_access_count, display_access_count);
+                }
+        }
+
+
+        mutex_unlock(&power_mutex);
+        return ret;
+}
+
+/*
+ * ospm_power_island_up
+ *
+ * Description: Restore power to the specified island(s) (powergating)
+ */
+void ospm_power_island_up(int hw_islands)
+{
+	u32 pwr_cnt = 0;
+	u32 pwr_sts = 0;
+	u32 pwr_mask = 0;
+
+	struct drm_psb_private *dev_priv =
+		(struct drm_psb_private *) gpDrmDevice->dev_private;
+
+
+	if (hw_islands & OSPM_DISPLAY_ISLAND) {
+		pwr_mask = PSB_PWRGT_DISPLAY_MASK;
+
+		pwr_cnt = inl(dev_priv->ospm_base + PSB_PM_SSC);
+		pwr_cnt &= ~pwr_mask;
+		outl(pwr_cnt, (dev_priv->ospm_base + PSB_PM_SSC));
+
+		while (true) {
+			pwr_sts = inl(dev_priv->ospm_base + PSB_PM_SSS);
+			if ((pwr_sts & pwr_mask) == 0)
+				break;
+			else
+				udelay(10);
+		}
+	}
+
+	g_hw_power_status_mask |= hw_islands;
+}
+
+/*
+ * ospm_power_resume
+ */
+int ospm_power_resume(struct pci_dev *pdev)
+{
+	if(gbSuspendInProgress || gbResumeInProgress)
+        {
+#ifdef OSPM_GFX_DPK
+                printk(KERN_ALERT "OSPM_GFX_DPK: %s hw_island: Suspend || gbResumeInProgress!!!! \n", __func__);
+#endif
+                return 0;
+        }
+
+        mutex_lock(&power_mutex);
+
+#ifdef OSPM_GFX_DPK
+	printk(KERN_ALERT "OSPM_GFX_DPK: ospm_power_resume \n");
+#endif
+
+  	gbResumeInProgress = true;
+
+        ospm_resume_pci(pdev);
+
+	ospm_resume_display(gpDrmDevice->pdev);
+        psb_irq_preinstall_islands(gpDrmDevice, OSPM_DISPLAY_ISLAND);
+        psb_irq_postinstall_islands(gpDrmDevice, OSPM_DISPLAY_ISLAND);
+
+	gbResumeInProgress = false;
+
+        mutex_unlock(&power_mutex);
+
+	return 0;
+}
+
+
+/*
+ * ospm_power_island_down
+ *
+ * Description: Cut power to the specified island(s) (powergating)
+ */
+void ospm_power_island_down(int islands)
+{
+#if 0
+	u32 pwr_cnt = 0;
+	u32 pwr_mask = 0;
+	u32 pwr_sts = 0;
+
+	struct drm_psb_private *dev_priv =
+		(struct drm_psb_private *) gpDrmDevice->dev_private;
+
+	g_hw_power_status_mask &= ~islands;
+
+	if (islands & OSPM_GRAPHICS_ISLAND) {
+		pwr_cnt |= PSB_PWRGT_GFX_MASK;
+		pwr_mask |= PSB_PWRGT_GFX_MASK;
+		if (dev_priv->graphics_state == PSB_PWR_STATE_ON) {
+			dev_priv->gfx_on_time += (jiffies - dev_priv->gfx_last_mode_change) * 1000 / HZ;
+			dev_priv->gfx_last_mode_change = jiffies;
+			dev_priv->graphics_state = PSB_PWR_STATE_OFF;
+			dev_priv->gfx_off_cnt++;
+		}
+	}
+	if (islands & OSPM_VIDEO_ENC_ISLAND) {
+		pwr_cnt |= PSB_PWRGT_VID_ENC_MASK;
+		pwr_mask |= PSB_PWRGT_VID_ENC_MASK;
+	}
+	if (islands & OSPM_VIDEO_DEC_ISLAND) {
+		pwr_cnt |= PSB_PWRGT_VID_DEC_MASK;
+		pwr_mask |= PSB_PWRGT_VID_DEC_MASK;
+	}
+	if (pwr_cnt) {
+		pwr_cnt |= inl(dev_priv->apm_base);
+		outl(pwr_cnt, dev_priv->apm_base  + PSB_APM_CMD);
+		while (true) {
+			pwr_sts = inl(dev_priv->apm_base + PSB_APM_STS);
+
+			if ((pwr_sts & pwr_mask) == pwr_mask)
+				break;
+			else
+				udelay(10);
+		}
+	}
+
+	if (islands & OSPM_DISPLAY_ISLAND) {
+		pwr_mask = PSB_PWRGT_DISPLAY_MASK;
+	
+		outl(pwr_mask, (dev_priv->ospm_base + PSB_PM_SSC));
+
+		while (true) {
+			pwr_sts = inl(dev_priv->ospm_base + PSB_PM_SSS);
+			if ((pwr_sts & pwr_mask) == pwr_mask)
+				break;
+			else
+				udelay(10);
+		}
+	}
+#endif	
+}
+
+
+/*
+ * ospm_power_is_hw_on
+ *
+ * Description: do an instantaneous check for if the specified islands
+ * are on.  Only use this in cases where you know the g_state_change_mutex
+ * is already held such as in irq install/uninstall.  Otherwise, use
+ * ospm_power_using_hw_begin().
+ */
+bool ospm_power_is_hw_on(int hw_islands)
+{
+	return ((g_hw_power_status_mask & hw_islands) == hw_islands) ? true:false;
+}
+
+/*
+ * ospm_power_using_hw_begin
+ *
+ * Description: Notify PowerMgmt module that you will be accessing the
+ * specified island's hw so don't power it off.  If force_on is true,
+ * this will power on the specified island if it is off.
+ * Otherwise, this will return false and the caller is expected to not
+ * access the hw.  
+ * 
+ * NOTE *** If this is called from and interrupt handler or other atomic 
+ * context, then it will return false if we are in the middle of a
+ * power state transition and the caller will be expected to handle that
+ * even if force_on is set to true.
+ */
+bool ospm_power_using_hw_begin(int hw_island, UHBUsage usage)
+{
+        return 1;	/*FIXMEAC */
+#if 0         
+	bool ret = true;
+	bool island_is_off = false;
+	bool b_atomic = (in_interrupt() || in_atomic());
+	bool locked = true;
+	struct pci_dev *pdev = gpDrmDevice->pdev;
+	u32 deviceID = 0;
+	bool force_on = usage ? true: false;
+	/*quick path, not 100% race safe, but should be enough comapre to current other code in this file */
+	if (!force_on) {
+		if (hw_island & (OSPM_ALL_ISLANDS & ~g_hw_power_status_mask))
+			return false;
+		else {
+			locked = false;
+#ifdef CONFIG_PM_RUNTIME
+			/* increment pm_runtime_refcount */
+			pm_runtime_get(&pdev->dev);
+#endif
+			goto increase_count;
+		}
+	}
+
+
+	if (!b_atomic)
+		mutex_lock(&power_mutex);
+
+	island_is_off = hw_island & (OSPM_ALL_ISLANDS & ~g_hw_power_status_mask);
+
+	if (b_atomic && (gbSuspendInProgress || gbResumeInProgress || gbSuspended) && force_on && island_is_off)
+		ret = false;
+
+	if (ret && island_is_off && !force_on)
+		ret = false;
+
+	if (ret && island_is_off && force_on) {
+		gbResumeInProgress = true;
+
+		ret = ospm_resume_pci(pdev);
+
+		if (ret) {
+			switch(hw_island)
+			{
+			case OSPM_DISPLAY_ISLAND:
+				deviceID = gui32MRSTDisplayDeviceID;
+				ospm_resume_display(pdev);
+				psb_irq_preinstall_islands(gpDrmDevice, OSPM_DISPLAY_ISLAND);
+				psb_irq_postinstall_islands(gpDrmDevice, OSPM_DISPLAY_ISLAND);
+				break;
+			case OSPM_GRAPHICS_ISLAND:
+				deviceID = gui32SGXDeviceID;
+				ospm_power_island_up(OSPM_GRAPHICS_ISLAND);
+				psb_irq_preinstall_islands(gpDrmDevice, OSPM_GRAPHICS_ISLAND);
+				psb_irq_postinstall_islands(gpDrmDevice, OSPM_GRAPHICS_ISLAND);
+				break;
+#if 1
+			case OSPM_VIDEO_DEC_ISLAND:
+				if(!ospm_power_is_hw_on(OSPM_DISPLAY_ISLAND)) {
+					//printk(KERN_ALERT "%s power on display for video decode use\n", __func__);
+					deviceID = gui32MRSTDisplayDeviceID;
+					ospm_resume_display(pdev);
+					psb_irq_preinstall_islands(gpDrmDevice, OSPM_DISPLAY_ISLAND);
+					psb_irq_postinstall_islands(gpDrmDevice, OSPM_DISPLAY_ISLAND);
+				}
+				else{
+					//printk(KERN_ALERT "%s display is already on for video decode use\n", __func__);
+				}
+
+				if(!ospm_power_is_hw_on(OSPM_VIDEO_DEC_ISLAND)) {
+					//printk(KERN_ALERT "%s power on video decode\n", __func__);
+					deviceID = gui32MRSTMSVDXDeviceID;
+					ospm_power_island_up(OSPM_VIDEO_DEC_ISLAND);
+					psb_irq_preinstall_islands(gpDrmDevice, OSPM_VIDEO_DEC_ISLAND);
+					psb_irq_postinstall_islands(gpDrmDevice, OSPM_VIDEO_DEC_ISLAND);
+				}
+				else{
+					//printk(KERN_ALERT "%s video decode is already on\n", __func__);
+				}
+
+				break;
+			case OSPM_VIDEO_ENC_ISLAND:
+				if(!ospm_power_is_hw_on(OSPM_DISPLAY_ISLAND)) {
+					//printk(KERN_ALERT "%s power on display for video encode\n", __func__);
+					deviceID = gui32MRSTDisplayDeviceID;
+					ospm_resume_display(pdev);
+					psb_irq_preinstall_islands(gpDrmDevice, OSPM_DISPLAY_ISLAND);
+					psb_irq_postinstall_islands(gpDrmDevice, OSPM_DISPLAY_ISLAND);
+				}
+				else{
+					//printk(KERN_ALERT "%s display is already on for video encode use\n", __func__);
+				}
+
+				if(!ospm_power_is_hw_on(OSPM_VIDEO_ENC_ISLAND)) {
+					//printk(KERN_ALERT "%s power on video encode\n", __func__);
+					deviceID = gui32MRSTTOPAZDeviceID;
+					ospm_power_island_up(OSPM_VIDEO_ENC_ISLAND);
+					psb_irq_preinstall_islands(gpDrmDevice, OSPM_VIDEO_ENC_ISLAND);
+					psb_irq_postinstall_islands(gpDrmDevice, OSPM_VIDEO_ENC_ISLAND);
+				}
+				else{
+					//printk(KERN_ALERT "%s video decode is already on\n", __func__);
+				}
+#endif
+				break;
+
+			default:
+				printk(KERN_ALERT "%s unknown island !!!! \n", __func__);
+				break;
+			}
+
+		}
+
+		if (!ret)
+			printk(KERN_ALERT "ospm_power_using_hw_begin: forcing on %d failed\n", hw_island);
+
+		gbResumeInProgress = false;
+	}
+increase_count:
+	if (ret) {
+		switch(hw_island)
+		{
+		case OSPM_GRAPHICS_ISLAND:
+			atomic_inc(&g_graphics_access_count);
+			break;
+		case OSPM_VIDEO_ENC_ISLAND:
+			atomic_inc(&g_videoenc_access_count);
+			break;
+		case OSPM_VIDEO_DEC_ISLAND:
+			atomic_inc(&g_videodec_access_count);
+			break;
+		case OSPM_DISPLAY_ISLAND:
+			atomic_inc(&g_display_access_count);
+			break;
+		}
+	}
+
+	if (!b_atomic && locked)
+		mutex_unlock(&power_mutex);
+
+	return ret;
+#endif	
+}
+
+
+/*
+ * ospm_power_using_hw_end
+ *
+ * Description: Notify PowerMgmt module that you are done accessing the
+ * specified island's hw so feel free to power it off.  Note that this
+ * function doesn't actually power off the islands.
+ */
+void ospm_power_using_hw_end(int hw_island)
+{
+#if 0 /* FIXMEAC */
+	switch(hw_island)
+	{
+	case OSPM_GRAPHICS_ISLAND:
+		atomic_dec(&g_graphics_access_count);
+		break;
+	case OSPM_VIDEO_ENC_ISLAND:
+		atomic_dec(&g_videoenc_access_count);
+		break;
+	case OSPM_VIDEO_DEC_ISLAND:
+		atomic_dec(&g_videodec_access_count);
+		break;
+	case OSPM_DISPLAY_ISLAND:
+		atomic_dec(&g_display_access_count);
+		break;
+	}
+
+	//decrement runtime pm ref count
+	pm_runtime_put(&gpDrmDevice->pdev->dev);
+
+	WARN_ON(atomic_read(&g_graphics_access_count) < 0);
+	WARN_ON(atomic_read(&g_videoenc_access_count) < 0);
+	WARN_ON(atomic_read(&g_videodec_access_count) < 0);
+	WARN_ON(atomic_read(&g_display_access_count) < 0);
+#endif	
+}
+
+int ospm_runtime_pm_allow(struct drm_device * dev)
+{
+	return 0;
+}
+
+void ospm_runtime_pm_forbid(struct drm_device * dev)
+{
+	struct drm_psb_private * dev_priv = dev->dev_private;
+	
+	DRM_INFO("%s\n", __FUNCTION__);
+	
+	pm_runtime_forbid(&dev->pdev->dev);
+	dev_priv->rpm_enabled = 0;
+}
+
+int psb_runtime_suspend(struct device *dev)
+{
+	pm_message_t state;
+	int ret = 0;
+	state.event = 0;
+
+#ifdef OSPM_GFX_DPK
+	printk(KERN_ALERT "OSPM_GFX_DPK: %s \n", __func__);
+#endif
+        if (atomic_read(&g_graphics_access_count) || atomic_read(&g_videoenc_access_count)
+		|| atomic_read(&g_videodec_access_count) || atomic_read(&g_display_access_count)){
+#ifdef OSPM_GFX_DPK
+                printk(KERN_ALERT "OSPM_GFX_DPK: GFX: %d VEC: %d VED: %d DC: %d DSR: %d \n", atomic_read(&g_graphics_access_count),
+			atomic_read(&g_videoenc_access_count), atomic_read(&g_videodec_access_count), atomic_read(&g_display_access_count));
+#endif
+                return -EBUSY;
+        }
+        else
+		ret = ospm_power_suspend(gpDrmDevice->pdev, state);
+
+	return ret;
+}
+
+int psb_runtime_resume(struct device *dev)
+{
+	return 0;
+}
+
+int psb_runtime_idle(struct device *dev)
+{
+	/*printk (KERN_ALERT "lvds:%d,mipi:%d\n", dev_priv->is_lvds_on, dev_priv->is_mipi_on);*/
+	if (atomic_read(&g_graphics_access_count) || atomic_read(&g_videoenc_access_count)
+		|| atomic_read(&g_videodec_access_count) || atomic_read(&g_display_access_count))
+		return 1;
+	else
+		return 0;
+}
+
diff --git a/drivers/staging/gma500/psb_powermgmt.h b/drivers/staging/gma500/psb_powermgmt.h
new file mode 100644
index 0000000..bf6f27a
--- /dev/null
+++ b/drivers/staging/gma500/psb_powermgmt.h
@@ -0,0 +1,96 @@
+/**************************************************************************
+ * Copyright (c) 2009, Intel Corporation.
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
+ *
+ */
+#ifndef _PSB_POWERMGMT_H_
+#define _PSB_POWERMGMT_H_
+
+#include <linux/pci.h>
+#include <drm/drmP.h>
+
+#define OSPM_GRAPHICS_ISLAND	0x1
+#define OSPM_VIDEO_ENC_ISLAND	0x2
+#define OSPM_VIDEO_DEC_ISLAND	0x4
+#define OSPM_DISPLAY_ISLAND	0x8
+#define OSPM_GL3_CACHE_ISLAND	0x10
+#define OSPM_ALL_ISLANDS	0x1f
+
+/* IPC message and command defines used to enable/disable mipi panel voltages */
+#define IPC_MSG_PANEL_ON_OFF    0xE9
+#define IPC_CMD_PANEL_ON        1
+#define IPC_CMD_PANEL_OFF       0
+
+typedef enum _UHBUsage
+{
+    OSPM_UHB_ONLY_IF_ON = 0,
+    OSPM_UHB_FORCE_POWER_ON,
+} UHBUsage;
+
+/* Use these functions to power down video HW for D0i3 purpose  */
+
+void ospm_power_init(struct drm_device *dev);
+void ospm_power_uninit(void);
+
+
+/*
+ * OSPM will call these functions
+ */
+int ospm_power_suspend(struct pci_dev *pdev, pm_message_t state);
+int ospm_power_resume(struct pci_dev *pdev);
+
+/*
+ * These are the functions the driver should use to wrap all hw access
+ * (i.e. register reads and writes)
+ */
+bool ospm_power_using_hw_begin(int hw_island, UHBUsage usage);
+void ospm_power_using_hw_end(int hw_island);
+
+/*
+ * Use this function to do an instantaneous check for if the hw is on.
+ * Only use this in cases where you know the g_state_change_mutex
+ * is already held such as in irq install/uninstall and you need to
+ * prevent a deadlock situation.  Otherwise use ospm_power_using_hw_begin().
+ */
+bool ospm_power_is_hw_on(int hw_islands);
+
+/*
+ * Power up/down different hw component rails/islands
+ */
+void ospm_power_island_down(int hw_islands);
+void ospm_power_island_up(int hw_islands);
+void ospm_suspend_graphics(void);
+/*
+ * GFX-Runtime PM callbacks
+ */
+int psb_runtime_suspend(struct device *dev);
+int psb_runtime_resume(struct device *dev);
+int psb_runtime_idle(struct device *dev);
+int ospm_runtime_pm_allow(struct drm_device * dev);
+void ospm_runtime_pm_forbid(struct drm_device * dev);
+
+
+#endif /*_PSB_POWERMGMT_H_*/
diff --git a/drivers/staging/gma500/psb_pvr_glue.c b/drivers/staging/gma500/psb_pvr_glue.c
new file mode 100644
index 0000000..da78946
--- /dev/null
+++ b/drivers/staging/gma500/psb_pvr_glue.c
@@ -0,0 +1,73 @@
+/*
+ * Copyright (c) 2009, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#include "psb_pvr_glue.h"
+
+/**
+ * FIXME: should NOT use these file under env/linux directly
+ */
+
+int psb_get_meminfo_by_handle(void *hKernelMemInfo,
+				void **ppsKernelMemInfo)
+{
+	return -EINVAL;
+#if 0
+	void *psKernelMemInfo = IMG_NULL;
+	PVRSRV_PER_PROCESS_DATA *psPerProc = IMG_NULL;
+	PVRSRV_ERROR eError;
+
+	psPerProc = PVRSRVPerProcessData(task_tgid_nr(current));
+	eError = PVRSRVLookupHandle(psPerProc->psHandleBase,
+				    (IMG_VOID *)&psKernelMemInfo,
+				    hKernelMemInfo,
+				    PVRSRV_HANDLE_TYPE_MEM_INFO);
+	if (eError != PVRSRV_OK) {
+		DRM_ERROR("Cannot find kernel meminfo for handle 0x%x\n",
+			  (u32)hKernelMemInfo);
+		return -EINVAL;
+	}
+
+	*ppsKernelMemInfo = psKernelMemInfo;
+
+	DRM_DEBUG("Got Kernel MemInfo for handle %lx\n",
+		  (u32)hKernelMemInfo);
+	return 0;
+#endif
+}
+
+int psb_get_pages_by_mem_handle(void *hOSMemHandle, struct page ***pages)
+{
+	return -EINVAL;
+#if 0
+	LinuxMemArea *psLinuxMemArea = (LinuxMemArea *)hOSMemHandle;
+	struct page **page_list;
+	if (psLinuxMemArea->eAreaType != LINUX_MEM_AREA_ALLOC_PAGES) {
+		DRM_ERROR("MemArea type is not LINUX_MEM_AREA_ALLOC_PAGES\n");
+		return -EINVAL;
+	}
+
+	page_list = psLinuxMemArea->uData.sPageList.pvPageList;
+	if (!page_list) {
+		DRM_DEBUG("Page List is NULL\n");
+		return -ENOMEM;
+	}
+
+	*pages = page_list;
+	return 0;
+#endif
+}
diff --git a/drivers/staging/gma500/psb_pvr_glue.h b/drivers/staging/gma500/psb_pvr_glue.h
new file mode 100644
index 0000000..63dd094
--- /dev/null
+++ b/drivers/staging/gma500/psb_pvr_glue.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2009, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#include "psb_drv.h"
+
+extern int psb_get_meminfo_by_handle(void * hKernelMemInfo,
+				void **ppsKernelMemInfo);
+extern u32 psb_get_tgid(void);
+extern int psb_get_pages_by_mem_handle(void * hOSMemHandle,
+					struct page ***pages);
diff --git a/drivers/staging/gma500/psb_reg.h b/drivers/staging/gma500/psb_reg.h
new file mode 100644
index 0000000..d80b4f3
--- /dev/null
+++ b/drivers/staging/gma500/psb_reg.h
@@ -0,0 +1,588 @@
+/**************************************************************************
+ *
+ * Copyright (c) (2005-2007) Imagination Technologies Limited.
+ * Copyright (c) 2007, Intel Corporation.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA..
+ *
+ **************************************************************************/
+
+#ifndef _PSB_REG_H_
+#define _PSB_REG_H_
+
+#define PSB_CR_CLKGATECTL                0x0000
+#define _PSB_C_CLKGATECTL_AUTO_MAN_REG   (1 << 24)
+#define _PSB_C_CLKGATECTL_USE_CLKG_SHIFT (20)
+#define _PSB_C_CLKGATECTL_USE_CLKG_MASK  (0x3 << 20)
+#define _PSB_C_CLKGATECTL_DPM_CLKG_SHIFT (16)
+#define _PSB_C_CLKGATECTL_DPM_CLKG_MASK  (0x3 << 16)
+#define _PSB_C_CLKGATECTL_TA_CLKG_SHIFT  (12)
+#define _PSB_C_CLKGATECTL_TA_CLKG_MASK   (0x3 << 12)
+#define _PSB_C_CLKGATECTL_TSP_CLKG_SHIFT (8)
+#define _PSB_C_CLKGATECTL_TSP_CLKG_MASK  (0x3 << 8)
+#define _PSB_C_CLKGATECTL_ISP_CLKG_SHIFT (4)
+#define _PSB_C_CLKGATECTL_ISP_CLKG_MASK  (0x3 << 4)
+#define _PSB_C_CLKGATECTL_2D_CLKG_SHIFT  (0)
+#define _PSB_C_CLKGATECTL_2D_CLKG_MASK   (0x3 << 0)
+#define _PSB_C_CLKGATECTL_CLKG_ENABLED   (0)
+#define _PSB_C_CLKGATECTL_CLKG_DISABLED  (1)
+#define _PSB_C_CLKGATECTL_CLKG_AUTO      (2)
+
+#define PSB_CR_CORE_ID                   0x0010
+#define _PSB_CC_ID_ID_SHIFT              (16)
+#define _PSB_CC_ID_ID_MASK               (0xFFFF << 16)
+#define _PSB_CC_ID_CONFIG_SHIFT          (0)
+#define _PSB_CC_ID_CONFIG_MASK           (0xFFFF << 0)
+
+#define PSB_CR_CORE_REVISION               0x0014
+#define _PSB_CC_REVISION_DESIGNER_SHIFT    (24)
+#define _PSB_CC_REVISION_DESIGNER_MASK     (0xFF << 24)
+#define _PSB_CC_REVISION_MAJOR_SHIFT       (16)
+#define _PSB_CC_REVISION_MAJOR_MASK        (0xFF << 16)
+#define _PSB_CC_REVISION_MINOR_SHIFT       (8)
+#define _PSB_CC_REVISION_MINOR_MASK        (0xFF << 8)
+#define _PSB_CC_REVISION_MAINTENANCE_SHIFT (0)
+#define _PSB_CC_REVISION_MAINTENANCE_MASK  (0xFF << 0)
+
+#define PSB_CR_DESIGNER_REV_FIELD1       0x0018
+
+#define PSB_CR_SOFT_RESET                0x0080
+#define _PSB_CS_RESET_TSP_RESET          (1 << 6)
+#define _PSB_CS_RESET_ISP_RESET          (1 << 5)
+#define _PSB_CS_RESET_USE_RESET          (1 << 4)
+#define _PSB_CS_RESET_TA_RESET           (1 << 3)
+#define _PSB_CS_RESET_DPM_RESET          (1 << 2)
+#define _PSB_CS_RESET_TWOD_RESET         (1 << 1)
+#define _PSB_CS_RESET_BIF_RESET          (1 << 0)
+
+#define PSB_CR_DESIGNER_REV_FIELD2       0x001C
+
+#define PSB_CR_EVENT_HOST_ENABLE2        0x0110
+
+#define PSB_CR_EVENT_STATUS2             0x0118
+
+#define PSB_CR_EVENT_HOST_CLEAR2         0x0114
+#define _PSB_CE2_BIF_REQUESTER_FAULT     (1 << 4)
+
+#define PSB_CR_EVENT_STATUS              0x012C
+
+#define PSB_CR_EVENT_HOST_ENABLE         0x0130
+
+#define PSB_CR_EVENT_HOST_CLEAR          0x0134
+#define _PSB_CE_MASTER_INTERRUPT         (1 << 31)
+#define _PSB_CE_TA_DPM_FAULT             (1 << 28)
+#define _PSB_CE_TWOD_COMPLETE            (1 << 27)
+#define _PSB_CE_DPM_OUT_OF_MEMORY_ZLS    (1 << 25)
+#define _PSB_CE_DPM_TA_MEM_FREE          (1 << 24)
+#define _PSB_CE_PIXELBE_END_RENDER       (1 << 18)
+#define _PSB_CE_SW_EVENT                 (1 << 14)
+#define _PSB_CE_TA_FINISHED              (1 << 13)
+#define _PSB_CE_TA_TERMINATE             (1 << 12)
+#define _PSB_CE_DPM_REACHED_MEM_THRESH   (1 << 3)
+#define _PSB_CE_DPM_OUT_OF_MEMORY_GBL    (1 << 2)
+#define _PSB_CE_DPM_OUT_OF_MEMORY_MT     (1 << 1)
+#define _PSB_CE_DPM_3D_MEM_FREE          (1 << 0)
+
+
+#define PSB_USE_OFFSET_MASK              0x0007FFFF
+#define PSB_USE_OFFSET_SIZE              (PSB_USE_OFFSET_MASK + 1)
+#define PSB_CR_USE_CODE_BASE0            0x0A0C
+#define PSB_CR_USE_CODE_BASE1            0x0A10
+#define PSB_CR_USE_CODE_BASE2            0x0A14
+#define PSB_CR_USE_CODE_BASE3            0x0A18
+#define PSB_CR_USE_CODE_BASE4            0x0A1C
+#define PSB_CR_USE_CODE_BASE5            0x0A20
+#define PSB_CR_USE_CODE_BASE6            0x0A24
+#define PSB_CR_USE_CODE_BASE7            0x0A28
+#define PSB_CR_USE_CODE_BASE8            0x0A2C
+#define PSB_CR_USE_CODE_BASE9            0x0A30
+#define PSB_CR_USE_CODE_BASE10           0x0A34
+#define PSB_CR_USE_CODE_BASE11           0x0A38
+#define PSB_CR_USE_CODE_BASE12           0x0A3C
+#define PSB_CR_USE_CODE_BASE13           0x0A40
+#define PSB_CR_USE_CODE_BASE14           0x0A44
+#define PSB_CR_USE_CODE_BASE15           0x0A48
+#define PSB_CR_USE_CODE_BASE(_i) (0x0A0C + ((_i) << 2))
+#define _PSB_CUC_BASE_DM_SHIFT           (25)
+#define _PSB_CUC_BASE_DM_MASK            (0x3 << 25)
+#define _PSB_CUC_BASE_ADDR_SHIFT         (0)	/* 1024-bit aligned address? */
+#define _PSB_CUC_BASE_ADDR_ALIGNSHIFT    (7)
+#define _PSB_CUC_BASE_ADDR_MASK          (0x1FFFFFF << 0)
+#define _PSB_CUC_DM_VERTEX		 (0)
+#define _PSB_CUC_DM_PIXEL		 (1)
+#define _PSB_CUC_DM_RESERVED		 (2)
+#define _PSB_CUC_DM_EDM	                 (3)
+
+#define PSB_CR_PDS_EXEC_BASE             0x0AB8
+#define _PSB_CR_PDS_EXEC_BASE_ADDR_SHIFT (20)	/* 1MB aligned address */
+#define _PSB_CR_PDS_EXEC_BASE_ADDR_ALIGNSHIFT (20)
+
+#define PSB_CR_EVENT_KICKER              0x0AC4
+#define _PSB_CE_KICKER_ADDRESS_SHIFT     (4)	/* 128-bit aligned address */
+
+#define PSB_CR_EVENT_KICK                0x0AC8
+#define _PSB_CE_KICK_NOW                 (1 << 0)
+
+
+#define PSB_CR_BIF_DIR_LIST_BASE1        0x0C38
+
+#define PSB_CR_BIF_CTRL                  0x0C00
+#define _PSB_CB_CTRL_CLEAR_FAULT         (1 << 4)
+#define _PSB_CB_CTRL_INVALDC             (1 << 3)
+#define _PSB_CB_CTRL_FLUSH               (1 << 2)
+
+#define PSB_CR_BIF_INT_STAT              0x0C04
+
+#define PSB_CR_BIF_FAULT                 0x0C08
+#define _PSB_CBI_STAT_PF_N_RW            (1 << 14)
+#define _PSB_CBI_STAT_FAULT_SHIFT        (0)
+#define _PSB_CBI_STAT_FAULT_MASK         (0x3FFF << 0)
+#define _PSB_CBI_STAT_FAULT_CACHE        (1 << 1)
+#define _PSB_CBI_STAT_FAULT_TA           (1 << 2)
+#define _PSB_CBI_STAT_FAULT_VDM          (1 << 3)
+#define _PSB_CBI_STAT_FAULT_2D           (1 << 4)
+#define _PSB_CBI_STAT_FAULT_PBE          (1 << 5)
+#define _PSB_CBI_STAT_FAULT_TSP          (1 << 6)
+#define _PSB_CBI_STAT_FAULT_ISP          (1 << 7)
+#define _PSB_CBI_STAT_FAULT_USSEPDS      (1 << 8)
+#define _PSB_CBI_STAT_FAULT_HOST         (1 << 9)
+
+#define PSB_CR_BIF_BANK0                 0x0C78
+
+#define PSB_CR_BIF_BANK1                 0x0C7C
+
+#define PSB_CR_BIF_DIR_LIST_BASE0        0x0C84
+
+#define PSB_CR_BIF_TWOD_REQ_BASE         0x0C88
+#define PSB_CR_BIF_3D_REQ_BASE           0x0CAC
+
+#define PSB_CR_2D_SOCIF                  0x0E18
+#define _PSB_C2_SOCIF_FREESPACE_SHIFT    (0)
+#define _PSB_C2_SOCIF_FREESPACE_MASK     (0xFF << 0)
+#define _PSB_C2_SOCIF_EMPTY              (0x80 << 0)
+
+#define PSB_CR_2D_BLIT_STATUS            0x0E04
+#define _PSB_C2B_STATUS_BUSY             (1 << 24)
+#define _PSB_C2B_STATUS_COMPLETE_SHIFT   (0)
+#define _PSB_C2B_STATUS_COMPLETE_MASK    (0xFFFFFF << 0)
+
+/*
+ * 2D defs.
+ */
+
+/*
+ * 2D Slave Port Data : Block Header's Object Type
+ */
+
+#define	PSB_2D_CLIP_BH                   (0x00000000)
+#define	PSB_2D_PAT_BH                    (0x10000000)
+#define	PSB_2D_CTRL_BH                   (0x20000000)
+#define	PSB_2D_SRC_OFF_BH                (0x30000000)
+#define	PSB_2D_MASK_OFF_BH               (0x40000000)
+#define	PSB_2D_RESERVED1_BH              (0x50000000)
+#define	PSB_2D_RESERVED2_BH              (0x60000000)
+#define	PSB_2D_FENCE_BH                  (0x70000000)
+#define	PSB_2D_BLIT_BH                   (0x80000000)
+#define	PSB_2D_SRC_SURF_BH               (0x90000000)
+#define	PSB_2D_DST_SURF_BH               (0xA0000000)
+#define	PSB_2D_PAT_SURF_BH               (0xB0000000)
+#define	PSB_2D_SRC_PAL_BH                (0xC0000000)
+#define	PSB_2D_PAT_PAL_BH                (0xD0000000)
+#define	PSB_2D_MASK_SURF_BH              (0xE0000000)
+#define	PSB_2D_FLUSH_BH                  (0xF0000000)
+
+/*
+ * Clip Definition block (PSB_2D_CLIP_BH)
+ */
+#define PSB_2D_CLIPCOUNT_MAX             (1)
+#define PSB_2D_CLIPCOUNT_MASK            (0x00000000)
+#define PSB_2D_CLIPCOUNT_CLRMASK         (0xFFFFFFFF)
+#define PSB_2D_CLIPCOUNT_SHIFT           (0)
+/* clip rectangle min & max */
+#define PSB_2D_CLIP_XMAX_MASK            (0x00FFF000)
+#define PSB_2D_CLIP_XMAX_CLRMASK         (0xFF000FFF)
+#define PSB_2D_CLIP_XMAX_SHIFT           (12)
+#define PSB_2D_CLIP_XMIN_MASK            (0x00000FFF)
+#define PSB_2D_CLIP_XMIN_CLRMASK         (0x00FFF000)
+#define PSB_2D_CLIP_XMIN_SHIFT           (0)
+/* clip rectangle offset */
+#define PSB_2D_CLIP_YMAX_MASK            (0x00FFF000)
+#define PSB_2D_CLIP_YMAX_CLRMASK         (0xFF000FFF)
+#define PSB_2D_CLIP_YMAX_SHIFT           (12)
+#define PSB_2D_CLIP_YMIN_MASK            (0x00000FFF)
+#define PSB_2D_CLIP_YMIN_CLRMASK         (0x00FFF000)
+#define PSB_2D_CLIP_YMIN_SHIFT           (0)
+
+/*
+ * Pattern Control (PSB_2D_PAT_BH)
+ */
+#define PSB_2D_PAT_HEIGHT_MASK           (0x0000001F)
+#define PSB_2D_PAT_HEIGHT_SHIFT          (0)
+#define PSB_2D_PAT_WIDTH_MASK            (0x000003E0)
+#define PSB_2D_PAT_WIDTH_SHIFT           (5)
+#define PSB_2D_PAT_YSTART_MASK           (0x00007C00)
+#define PSB_2D_PAT_YSTART_SHIFT          (10)
+#define PSB_2D_PAT_XSTART_MASK           (0x000F8000)
+#define PSB_2D_PAT_XSTART_SHIFT          (15)
+
+/*
+ * 2D Control block (PSB_2D_CTRL_BH)
+ */
+/* Present Flags */
+#define PSB_2D_SRCCK_CTRL                (0x00000001)
+#define PSB_2D_DSTCK_CTRL                (0x00000002)
+#define PSB_2D_ALPHA_CTRL                (0x00000004)
+/* Colour Key Colour (SRC/DST)*/
+#define PSB_2D_CK_COL_MASK               (0xFFFFFFFF)
+#define PSB_2D_CK_COL_CLRMASK            (0x00000000)
+#define PSB_2D_CK_COL_SHIFT              (0)
+/* Colour Key Mask (SRC/DST)*/
+#define PSB_2D_CK_MASK_MASK              (0xFFFFFFFF)
+#define PSB_2D_CK_MASK_CLRMASK           (0x00000000)
+#define PSB_2D_CK_MASK_SHIFT             (0)
+/* Alpha Control (Alpha/RGB)*/
+#define PSB_2D_GBLALPHA_MASK             (0x000FF000)
+#define PSB_2D_GBLALPHA_CLRMASK          (0xFFF00FFF)
+#define PSB_2D_GBLALPHA_SHIFT            (12)
+#define PSB_2D_SRCALPHA_OP_MASK          (0x00700000)
+#define PSB_2D_SRCALPHA_OP_CLRMASK       (0xFF8FFFFF)
+#define PSB_2D_SRCALPHA_OP_SHIFT         (20)
+#define PSB_2D_SRCALPHA_OP_ONE           (0x00000000)
+#define PSB_2D_SRCALPHA_OP_SRC           (0x00100000)
+#define PSB_2D_SRCALPHA_OP_DST           (0x00200000)
+#define PSB_2D_SRCALPHA_OP_SG            (0x00300000)
+#define PSB_2D_SRCALPHA_OP_DG            (0x00400000)
+#define PSB_2D_SRCALPHA_OP_GBL           (0x00500000)
+#define PSB_2D_SRCALPHA_OP_ZERO          (0x00600000)
+#define PSB_2D_SRCALPHA_INVERT           (0x00800000)
+#define PSB_2D_SRCALPHA_INVERT_CLR       (0xFF7FFFFF)
+#define PSB_2D_DSTALPHA_OP_MASK          (0x07000000)
+#define PSB_2D_DSTALPHA_OP_CLRMASK       (0xF8FFFFFF)
+#define PSB_2D_DSTALPHA_OP_SHIFT         (24)
+#define PSB_2D_DSTALPHA_OP_ONE           (0x00000000)
+#define PSB_2D_DSTALPHA_OP_SRC           (0x01000000)
+#define PSB_2D_DSTALPHA_OP_DST           (0x02000000)
+#define PSB_2D_DSTALPHA_OP_SG            (0x03000000)
+#define PSB_2D_DSTALPHA_OP_DG            (0x04000000)
+#define PSB_2D_DSTALPHA_OP_GBL           (0x05000000)
+#define PSB_2D_DSTALPHA_OP_ZERO          (0x06000000)
+#define PSB_2D_DSTALPHA_INVERT           (0x08000000)
+#define PSB_2D_DSTALPHA_INVERT_CLR       (0xF7FFFFFF)
+
+#define PSB_2D_PRE_MULTIPLICATION_ENABLE  (0x10000000)
+#define PSB_2D_PRE_MULTIPLICATION_CLRMASK (0xEFFFFFFF)
+#define PSB_2D_ZERO_SOURCE_ALPHA_ENABLE   (0x20000000)
+#define PSB_2D_ZERO_SOURCE_ALPHA_CLRMASK  (0xDFFFFFFF)
+
+/*
+ *Source Offset (PSB_2D_SRC_OFF_BH)
+ */
+#define PSB_2D_SRCOFF_XSTART_MASK        ((0x00000FFF) << 12)
+#define PSB_2D_SRCOFF_XSTART_SHIFT       (12)
+#define PSB_2D_SRCOFF_YSTART_MASK        (0x00000FFF)
+#define PSB_2D_SRCOFF_YSTART_SHIFT       (0)
+
+/*
+ * Mask Offset (PSB_2D_MASK_OFF_BH)
+ */
+#define PSB_2D_MASKOFF_XSTART_MASK       ((0x00000FFF) << 12)
+#define PSB_2D_MASKOFF_XSTART_SHIFT      (12)
+#define PSB_2D_MASKOFF_YSTART_MASK       (0x00000FFF)
+#define PSB_2D_MASKOFF_YSTART_SHIFT      (0)
+
+/*
+ * 2D Fence (see PSB_2D_FENCE_BH): bits 0:27 are ignored
+ */
+
+/*
+ *Blit Rectangle (PSB_2D_BLIT_BH)
+ */
+
+#define PSB_2D_ROT_MASK                  (3<<25)
+#define PSB_2D_ROT_CLRMASK               (~PSB_2D_ROT_MASK)
+#define PSB_2D_ROT_NONE                  (0<<25)
+#define PSB_2D_ROT_90DEGS                (1<<25)
+#define PSB_2D_ROT_180DEGS               (2<<25)
+#define PSB_2D_ROT_270DEGS               (3<<25)
+
+#define PSB_2D_COPYORDER_MASK            (3<<23)
+#define PSB_2D_COPYORDER_CLRMASK         (~PSB_2D_COPYORDER_MASK)
+#define PSB_2D_COPYORDER_TL2BR           (0<<23)
+#define PSB_2D_COPYORDER_BR2TL           (1<<23)
+#define PSB_2D_COPYORDER_TR2BL           (2<<23)
+#define PSB_2D_COPYORDER_BL2TR           (3<<23)
+
+#define PSB_2D_DSTCK_CLRMASK             (0xFF9FFFFF)
+#define PSB_2D_DSTCK_DISABLE             (0x00000000)
+#define PSB_2D_DSTCK_PASS                (0x00200000)
+#define PSB_2D_DSTCK_REJECT              (0x00400000)
+
+#define PSB_2D_SRCCK_CLRMASK             (0xFFE7FFFF)
+#define PSB_2D_SRCCK_DISABLE             (0x00000000)
+#define PSB_2D_SRCCK_PASS                (0x00080000)
+#define PSB_2D_SRCCK_REJECT              (0x00100000)
+
+#define PSB_2D_CLIP_ENABLE               (0x00040000)
+
+#define PSB_2D_ALPHA_ENABLE              (0x00020000)
+
+#define PSB_2D_PAT_CLRMASK               (0xFFFEFFFF)
+#define PSB_2D_PAT_MASK                  (0x00010000)
+#define PSB_2D_USE_PAT                   (0x00010000)
+#define PSB_2D_USE_FILL                  (0x00000000)
+/*
+ * Tungsten Graphics note on rop codes: If rop A and rop B are
+ * identical, the mask surface will not be read and need not be
+ * set up.
+ */
+
+#define PSB_2D_ROP3B_MASK                (0x0000FF00)
+#define PSB_2D_ROP3B_CLRMASK             (0xFFFF00FF)
+#define PSB_2D_ROP3B_SHIFT               (8)
+/* rop code A */
+#define PSB_2D_ROP3A_MASK                (0x000000FF)
+#define PSB_2D_ROP3A_CLRMASK             (0xFFFFFF00)
+#define PSB_2D_ROP3A_SHIFT               (0)
+
+#define PSB_2D_ROP4_MASK                 (0x0000FFFF)
+/*
+ *	DWORD0:	(Only pass if Pattern control == Use Fill Colour)
+ *	Fill Colour RGBA8888
+ */
+#define PSB_2D_FILLCOLOUR_MASK           (0xFFFFFFFF)
+#define PSB_2D_FILLCOLOUR_SHIFT          (0)
+/*
+ *	DWORD1: (Always Present)
+ *	X Start (Dest)
+ *	Y Start (Dest)
+ */
+#define PSB_2D_DST_XSTART_MASK           (0x00FFF000)
+#define PSB_2D_DST_XSTART_CLRMASK        (0xFF000FFF)
+#define PSB_2D_DST_XSTART_SHIFT          (12)
+#define PSB_2D_DST_YSTART_MASK           (0x00000FFF)
+#define PSB_2D_DST_YSTART_CLRMASK        (0xFFFFF000)
+#define PSB_2D_DST_YSTART_SHIFT          (0)
+/*
+ *	DWORD2: (Always Present)
+ *	X Size (Dest)
+ *	Y Size (Dest)
+ */
+#define PSB_2D_DST_XSIZE_MASK            (0x00FFF000)
+#define PSB_2D_DST_XSIZE_CLRMASK         (0xFF000FFF)
+#define PSB_2D_DST_XSIZE_SHIFT           (12)
+#define PSB_2D_DST_YSIZE_MASK            (0x00000FFF)
+#define PSB_2D_DST_YSIZE_CLRMASK         (0xFFFFF000)
+#define PSB_2D_DST_YSIZE_SHIFT           (0)
+
+/*
+ * Source Surface (PSB_2D_SRC_SURF_BH)
+ */
+/*
+ *      WORD 0
+ */
+
+#define PSB_2D_SRC_FORMAT_MASK           (0x00078000)
+#define PSB_2D_SRC_1_PAL                 (0x00000000)
+#define PSB_2D_SRC_2_PAL                 (0x00008000)
+#define PSB_2D_SRC_4_PAL                 (0x00010000)
+#define PSB_2D_SRC_8_PAL                 (0x00018000)
+#define PSB_2D_SRC_8_ALPHA               (0x00020000)
+#define PSB_2D_SRC_4_ALPHA               (0x00028000)
+#define PSB_2D_SRC_332RGB                (0x00030000)
+#define PSB_2D_SRC_4444ARGB              (0x00038000)
+#define PSB_2D_SRC_555RGB                (0x00040000)
+#define PSB_2D_SRC_1555ARGB              (0x00048000)
+#define PSB_2D_SRC_565RGB                (0x00050000)
+#define PSB_2D_SRC_0888ARGB              (0x00058000)
+#define PSB_2D_SRC_8888ARGB              (0x00060000)
+#define PSB_2D_SRC_8888UYVY              (0x00068000)
+#define PSB_2D_SRC_RESERVED              (0x00070000)
+#define PSB_2D_SRC_1555ARGB_LOOKUP       (0x00078000)
+
+
+#define PSB_2D_SRC_STRIDE_MASK           (0x00007FFF)
+#define PSB_2D_SRC_STRIDE_CLRMASK        (0xFFFF8000)
+#define PSB_2D_SRC_STRIDE_SHIFT          (0)
+/*
+ *  WORD 1 - Base Address
+ */
+#define PSB_2D_SRC_ADDR_MASK             (0x0FFFFFFC)
+#define PSB_2D_SRC_ADDR_CLRMASK          (0x00000003)
+#define PSB_2D_SRC_ADDR_SHIFT            (2)
+#define PSB_2D_SRC_ADDR_ALIGNSHIFT       (2)
+
+/*
+ * Pattern Surface (PSB_2D_PAT_SURF_BH)
+ */
+/*
+ *  WORD 0
+ */
+
+#define PSB_2D_PAT_FORMAT_MASK           (0x00078000)
+#define PSB_2D_PAT_1_PAL                 (0x00000000)
+#define PSB_2D_PAT_2_PAL                 (0x00008000)
+#define PSB_2D_PAT_4_PAL                 (0x00010000)
+#define PSB_2D_PAT_8_PAL                 (0x00018000)
+#define PSB_2D_PAT_8_ALPHA               (0x00020000)
+#define PSB_2D_PAT_4_ALPHA               (0x00028000)
+#define PSB_2D_PAT_332RGB                (0x00030000)
+#define PSB_2D_PAT_4444ARGB              (0x00038000)
+#define PSB_2D_PAT_555RGB                (0x00040000)
+#define PSB_2D_PAT_1555ARGB              (0x00048000)
+#define PSB_2D_PAT_565RGB                (0x00050000)
+#define PSB_2D_PAT_0888ARGB              (0x00058000)
+#define PSB_2D_PAT_8888ARGB              (0x00060000)
+
+#define PSB_2D_PAT_STRIDE_MASK           (0x00007FFF)
+#define PSB_2D_PAT_STRIDE_CLRMASK        (0xFFFF8000)
+#define PSB_2D_PAT_STRIDE_SHIFT          (0)
+/*
+ *  WORD 1 - Base Address
+ */
+#define PSB_2D_PAT_ADDR_MASK             (0x0FFFFFFC)
+#define PSB_2D_PAT_ADDR_CLRMASK          (0x00000003)
+#define PSB_2D_PAT_ADDR_SHIFT            (2)
+#define PSB_2D_PAT_ADDR_ALIGNSHIFT       (2)
+
+/*
+ * Destination Surface (PSB_2D_DST_SURF_BH)
+ */
+/*
+ * WORD 0
+ */
+
+#define PSB_2D_DST_FORMAT_MASK           (0x00078000)
+#define PSB_2D_DST_332RGB                (0x00030000)
+#define PSB_2D_DST_4444ARGB              (0x00038000)
+#define PSB_2D_DST_555RGB                (0x00040000)
+#define PSB_2D_DST_1555ARGB              (0x00048000)
+#define PSB_2D_DST_565RGB                (0x00050000)
+#define PSB_2D_DST_0888ARGB              (0x00058000)
+#define PSB_2D_DST_8888ARGB              (0x00060000)
+#define PSB_2D_DST_8888AYUV              (0x00070000)
+
+#define PSB_2D_DST_STRIDE_MASK           (0x00007FFF)
+#define PSB_2D_DST_STRIDE_CLRMASK        (0xFFFF8000)
+#define PSB_2D_DST_STRIDE_SHIFT          (0)
+/*
+ * WORD 1 - Base Address
+ */
+#define PSB_2D_DST_ADDR_MASK             (0x0FFFFFFC)
+#define PSB_2D_DST_ADDR_CLRMASK          (0x00000003)
+#define PSB_2D_DST_ADDR_SHIFT            (2)
+#define PSB_2D_DST_ADDR_ALIGNSHIFT       (2)
+
+/*
+ * Mask Surface (PSB_2D_MASK_SURF_BH)
+ */
+/*
+ * WORD 0
+ */
+#define PSB_2D_MASK_STRIDE_MASK          (0x00007FFF)
+#define PSB_2D_MASK_STRIDE_CLRMASK       (0xFFFF8000)
+#define PSB_2D_MASK_STRIDE_SHIFT         (0)
+/*
+ *  WORD 1 - Base Address
+ */
+#define PSB_2D_MASK_ADDR_MASK            (0x0FFFFFFC)
+#define PSB_2D_MASK_ADDR_CLRMASK         (0x00000003)
+#define PSB_2D_MASK_ADDR_SHIFT           (2)
+#define PSB_2D_MASK_ADDR_ALIGNSHIFT      (2)
+
+/*
+ * Source Palette (PSB_2D_SRC_PAL_BH)
+ */
+
+#define PSB_2D_SRCPAL_ADDR_SHIFT         (0)
+#define PSB_2D_SRCPAL_ADDR_CLRMASK       (0xF0000007)
+#define PSB_2D_SRCPAL_ADDR_MASK          (0x0FFFFFF8)
+#define PSB_2D_SRCPAL_BYTEALIGN          (1024)
+
+/*
+ * Pattern Palette (PSB_2D_PAT_PAL_BH)
+ */
+
+#define PSB_2D_PATPAL_ADDR_SHIFT         (0)
+#define PSB_2D_PATPAL_ADDR_CLRMASK       (0xF0000007)
+#define PSB_2D_PATPAL_ADDR_MASK          (0x0FFFFFF8)
+#define PSB_2D_PATPAL_BYTEALIGN          (1024)
+
+/*
+ * Rop3 Codes (2 LS bytes)
+ */
+
+#define PSB_2D_ROP3_SRCCOPY              (0xCCCC)
+#define PSB_2D_ROP3_PATCOPY              (0xF0F0)
+#define PSB_2D_ROP3_WHITENESS            (0xFFFF)
+#define PSB_2D_ROP3_BLACKNESS            (0x0000)
+#define PSB_2D_ROP3_SRC                  (0xCC)
+#define PSB_2D_ROP3_PAT                  (0xF0)
+#define PSB_2D_ROP3_DST                  (0xAA)
+
+
+/*
+ * Sizes.
+ */
+
+#define PSB_SCENE_HW_COOKIE_SIZE 16
+#define PSB_TA_MEM_HW_COOKIE_SIZE 16
+
+/*
+ * Scene stuff.
+ */
+
+#define PSB_NUM_HW_SCENES          2
+
+/*
+ * Scheduler completion actions.
+ */
+
+#define PSB_RASTER_BLOCK 0
+#define PSB_RASTER       1
+#define PSB_RETURN       2
+#define PSB_TA       3
+
+
+/*Power management*/
+#define PSB_PUNIT_PORT		    0x04
+#define PSB_OSPMBA		    0x78
+#define PSB_APMBA		    0x7a
+#define PSB_APM_CMD		    0x0
+#define PSB_APM_STS		    0x04
+#define PSB_PWRGT_VID_ENC_MASK	    0x30
+#define PSB_PWRGT_VID_DEC_MASK	    0xc
+#define PSB_PWRGT_GL3_MASK	    0xc0
+
+#define PSB_PM_SSC		    0x20
+#define PSB_PM_SSS		    0x30
+#define PSB_PWRGT_DISPLAY_MASK	    0xc /*on a different BA than video/gfx*/
+#define MDFLD_PWRGT_DISPLAY_A_CNTR  0x0000000c 
+#define MDFLD_PWRGT_DISPLAY_B_CNTR  0x0000c000 
+#define MDFLD_PWRGT_DISPLAY_C_CNTR  0x00030000 
+#define MDFLD_PWRGT_DISP_MIPI_CNTR  0x000c0000 
+#define MDFLD_PWRGT_DISPLAY_CNTR    (MDFLD_PWRGT_DISPLAY_A_CNTR | MDFLD_PWRGT_DISPLAY_B_CNTR | MDFLD_PWRGT_DISPLAY_C_CNTR | MDFLD_PWRGT_DISP_MIPI_CNTR)// 0x000fc00c
+// Display SSS register bits are different in A0 vs. B0
+#define PSB_PWRGT_GFX_MASK	    0x3
+#define MDFLD_PWRGT_DISPLAY_A_STS  		0x000000c0
+#define MDFLD_PWRGT_DISPLAY_B_STS  		0x00000300
+#define MDFLD_PWRGT_DISPLAY_C_STS  		0x00000c00
+#define PSB_PWRGT_GFX_MASK_B0	   		0xc3
+#define MDFLD_PWRGT_DISPLAY_A_STS_B0	0x0000000c
+#define MDFLD_PWRGT_DISPLAY_B_STS_B0  	0x0000c000
+#define MDFLD_PWRGT_DISPLAY_C_STS_B0  	0x00030000
+#define MDFLD_PWRGT_DISP_MIPI_STS  0x000c0000 
+#define MDFLD_PWRGT_DISPLAY_STS_A0    (MDFLD_PWRGT_DISPLAY_A_STS | MDFLD_PWRGT_DISPLAY_B_STS | MDFLD_PWRGT_DISPLAY_C_STS | MDFLD_PWRGT_DISP_MIPI_STS)// 0x000fc00c
+#define MDFLD_PWRGT_DISPLAY_STS_B0    (MDFLD_PWRGT_DISPLAY_A_STS_B0 | MDFLD_PWRGT_DISPLAY_B_STS_B0 | MDFLD_PWRGT_DISPLAY_C_STS_B0 | MDFLD_PWRGT_DISP_MIPI_STS)// 0x000fc00c
+#endif
diff --git a/drivers/staging/gma500/psb_reset.c b/drivers/staging/gma500/psb_reset.c
new file mode 100644
index 0000000..21fd202
--- /dev/null
+++ b/drivers/staging/gma500/psb_reset.c
@@ -0,0 +1,90 @@
+/**************************************************************************
+ * Copyright (c) 2007, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ **************************************************************************/
+
+#include <drm/drmP.h>
+#include "psb_drv.h"
+#include "psb_reg.h"
+#include "psb_intel_reg.h"
+#include <linux/spinlock.h>
+
+static void psb_lid_timer_func(unsigned long data)
+{
+	struct drm_psb_private * dev_priv = (struct drm_psb_private *)data;
+	struct drm_device *dev = (struct drm_device *)dev_priv->dev;
+	struct timer_list *lid_timer = &dev_priv->lid_timer;
+	unsigned long irq_flags;
+	u32 *lid_state = dev_priv->lid_state;
+	u32 pp_status;
+
+	if (*lid_state == dev_priv->lid_last_state)
+		goto lid_timer_schedule;
+
+	if ((*lid_state) & 0x01) {
+		/*lid state is open*/
+		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) | POWER_TARGET_ON);
+		do {
+			pp_status = REG_READ(PP_STATUS);
+		} while ((pp_status & PP_ON) == 0);
+
+		/*FIXME: should be backlight level before*/
+		psb_intel_lvds_set_brightness(dev, 100);
+	} else {
+		psb_intel_lvds_set_brightness(dev, 0);
+
+		REG_WRITE(PP_CONTROL, REG_READ(PP_CONTROL) & ~POWER_TARGET_ON);
+		do {
+			pp_status = REG_READ(PP_STATUS);
+		} while ((pp_status & PP_ON) == 0);
+	}
+		/* printk(KERN_INFO"%s: lid: closed\n", __FUNCTION__); */
+
+	dev_priv->lid_last_state =  *lid_state;
+
+lid_timer_schedule:
+	spin_lock_irqsave(&dev_priv->lid_lock, irq_flags);
+	if (!timer_pending(lid_timer)) {
+		lid_timer->expires = jiffies + PSB_LID_DELAY;
+		add_timer(lid_timer);
+	}
+	spin_unlock_irqrestore(&dev_priv->lid_lock, irq_flags);
+}
+
+void psb_lid_timer_init(struct drm_psb_private *dev_priv)
+{
+	struct timer_list *lid_timer = &dev_priv->lid_timer;
+	unsigned long irq_flags;
+
+	spin_lock_init(&dev_priv->lid_lock);
+	spin_lock_irqsave(&dev_priv->lid_lock, irq_flags);
+
+	init_timer(lid_timer);
+
+	lid_timer->data = (unsigned long)dev_priv;
+	lid_timer->function = psb_lid_timer_func;
+	lid_timer->expires = jiffies + PSB_LID_DELAY;
+
+	add_timer(lid_timer);
+	spin_unlock_irqrestore(&dev_priv->lid_lock, irq_flags);
+}
+
+void psb_lid_timer_takedown(struct drm_psb_private *dev_priv)
+{
+	del_timer_sync(&dev_priv->lid_timer);
+}
+
diff --git a/drivers/staging/gma500/psb_sgx.c b/drivers/staging/gma500/psb_sgx.c
new file mode 100644
index 0000000..973134b
--- /dev/null
+++ b/drivers/staging/gma500/psb_sgx.c
@@ -0,0 +1,238 @@
+/**************************************************************************
+ * Copyright (c) 2007, Intel Corporation.
+ * All Rights Reserved.
+ * Copyright (c) 2008, Tungsten Graphics, Inc. Cedar Park, TX. USA.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+
+#include <drm/drmP.h>
+#include "psb_drv.h"
+#include "psb_drm.h"
+#include "psb_reg.h"
+#include "ttm/ttm_bo_api.h"
+#include "ttm/ttm_execbuf_util.h"
+#include "psb_ttm_userobj_api.h"
+#include "ttm/ttm_placement.h"
+#include "psb_sgx.h"
+#include "psb_intel_reg.h"
+#include "psb_powermgmt.h"
+
+
+static inline int psb_same_page(unsigned long offset,
+				unsigned long offset2)
+{
+	return (offset & PAGE_MASK) == (offset2 & PAGE_MASK);
+}
+
+static inline unsigned long psb_offset_end(unsigned long offset,
+					      unsigned long end)
+{
+	offset = (offset + PAGE_SIZE) & PAGE_MASK;
+	return (end < offset) ? end : offset;
+}
+
+struct psb_dstbuf_cache {
+	unsigned int dst;
+	struct ttm_buffer_object *dst_buf;
+	unsigned long dst_offset;
+	uint32_t *dst_page;
+	unsigned int dst_page_offset;
+	struct ttm_bo_kmap_obj dst_kmap;
+	bool dst_is_iomem;
+};
+
+struct psb_validate_buffer {
+	struct ttm_validate_buffer base;
+	struct psb_validate_req req;
+	int ret;
+	struct psb_validate_arg __user *user_val_arg;
+	uint32_t flags;
+	uint32_t offset;
+	int po_correct;
+};
+static int
+psb_placement_fence_type(struct ttm_buffer_object *bo,
+			 uint64_t set_val_flags,
+			 uint64_t clr_val_flags,
+			 uint32_t new_fence_class,
+			 uint32_t *new_fence_type)
+{
+	int ret;
+	uint32_t n_fence_type;
+	/*
+	uint32_t set_flags = set_val_flags & 0xFFFFFFFF;
+	uint32_t clr_flags = clr_val_flags & 0xFFFFFFFF;
+	*/
+	struct ttm_fence_object *old_fence;
+	uint32_t old_fence_type;
+	struct ttm_placement placement;
+
+	if (unlikely
+	    (!(set_val_flags &
+	       (PSB_GPU_ACCESS_READ | PSB_GPU_ACCESS_WRITE)))) {
+		DRM_ERROR
+		    ("GPU access type (read / write) is not indicated.\n");
+		return -EINVAL;
+	}
+
+	/* User space driver doesn't set any TTM placement flags in
+					set_val_flags or clr_val_flags */
+	placement.num_placement = 0;/* FIXME  */
+	placement.num_busy_placement = 0;
+	placement.fpfn = 0;
+	placement.lpfn = 0;
+	ret = psb_ttm_bo_check_placement(bo, &placement);
+	if (unlikely(ret != 0))
+		return ret;
+
+	switch (new_fence_class) {
+	default:
+		n_fence_type = _PSB_FENCE_TYPE_EXE;
+	}
+
+	*new_fence_type = n_fence_type;
+	old_fence = (struct ttm_fence_object *) bo->sync_obj;
+	old_fence_type = (uint32_t) (unsigned long) bo->sync_obj_arg;
+
+	if (old_fence && ((new_fence_class != old_fence->fence_class) ||
+			  ((n_fence_type ^ old_fence_type) &
+			   old_fence_type))) {
+		ret = ttm_bo_wait(bo, 0, 1, 0);
+		if (unlikely(ret != 0))
+			return ret;
+	}
+	/*
+	bo->proposed_flags = (bo->proposed_flags | set_flags)
+		& ~clr_flags & TTM_PL_MASK_MEMTYPE;
+	*/
+	return 0;
+}
+
+int psb_validate_kernel_buffer(struct psb_context *context,
+			       struct ttm_buffer_object *bo,
+			       uint32_t fence_class,
+			       uint64_t set_flags, uint64_t clr_flags)
+{
+	struct psb_validate_buffer *item;
+	uint32_t cur_fence_type;
+	int ret;
+
+	if (unlikely(context->used_buffers >= PSB_NUM_VALIDATE_BUFFERS)) {
+		DRM_ERROR("Out of free validation buffer entries for "
+			  "kernel buffer validation.\n");
+		return -ENOMEM;
+	}
+
+	item = &context->buffers[context->used_buffers];
+	item->user_val_arg = NULL;
+	item->base.reserved = 0;
+
+	ret = ttm_bo_reserve(bo, 1, 0, 1, context->val_seq);
+	if (unlikely(ret != 0))
+	        return ret;
+
+	ret = psb_placement_fence_type(bo, set_flags, clr_flags, fence_class,
+				       &cur_fence_type);
+	if (unlikely(ret != 0)) {
+		ttm_bo_unreserve(bo);
+		return ret;
+	}
+
+	item->base.bo = ttm_bo_reference(bo);
+	item->base.new_sync_obj_arg = (void *) (unsigned long) cur_fence_type;
+	item->base.reserved = 1;
+
+	/* Internal locking ??? FIXMEAC */
+	list_add_tail(&item->base.head, &context->kern_validate_list);
+	context->used_buffers++;
+	/*
+	ret = ttm_bo_validate(bo, 1, 0, 0);
+	if (unlikely(ret != 0))
+		goto out_unlock;
+	*/
+	item->offset = bo->offset;
+	item->flags = bo->mem.placement;
+	context->fence_types |= cur_fence_type;
+
+	return ret;
+}
+
+void psb_fence_or_sync(struct drm_file *file_priv,
+		       uint32_t engine,
+		       uint32_t fence_types,
+		       uint32_t fence_flags,
+		       struct list_head *list,
+		       struct psb_ttm_fence_rep *fence_arg,
+		       struct ttm_fence_object **fence_p)
+{
+	struct drm_device *dev = file_priv->minor->dev;
+	struct drm_psb_private *dev_priv = psb_priv(dev);
+	struct ttm_fence_device *fdev = &dev_priv->fdev;
+	int ret;
+	struct ttm_fence_object *fence;
+	struct ttm_object_file *tfile = psb_fpriv(file_priv)->tfile;
+	uint32_t handle;
+
+	ret = ttm_fence_user_create(fdev, tfile,
+				    engine, fence_types,
+				    TTM_FENCE_FLAG_EMIT, &fence, &handle);
+	if (ret) {
+
+		/*
+		 * Fence creation failed.
+		 * Fall back to synchronous operation and idle the engine.
+		 */
+
+		if (!(fence_flags & DRM_PSB_FENCE_NO_USER)) {
+
+			/*
+			 * Communicate to user-space that
+			 * fence creation has failed and that
+			 * the engine is idle.
+			 */
+
+			fence_arg->handle = ~0;
+			fence_arg->error = ret;
+		}
+
+		ttm_eu_backoff_reservation(list);
+		if (fence_p)
+			*fence_p = NULL;
+		return;
+	}
+
+	ttm_eu_fence_buffer_objects(list, fence);
+	if (!(fence_flags & DRM_PSB_FENCE_NO_USER)) {
+		struct ttm_fence_info info = ttm_fence_get_info(fence);
+		fence_arg->handle = handle;
+		fence_arg->fence_class = ttm_fence_class(fence);
+		fence_arg->fence_type = ttm_fence_types(fence);
+		fence_arg->signaled_types = info.signaled_types;
+		fence_arg->error = 0;
+	} else {
+		ret =
+		    ttm_ref_object_base_unref(tfile, handle,
+					      ttm_fence_type);
+		BUG_ON(ret);
+	}
+
+	if (fence_p)
+		*fence_p = fence;
+	else if (fence)
+		ttm_fence_object_unref(&fence);
+}
+
diff --git a/drivers/staging/gma500/psb_sgx.h b/drivers/staging/gma500/psb_sgx.h
new file mode 100644
index 0000000..2934e5d
--- /dev/null
+++ b/drivers/staging/gma500/psb_sgx.h
@@ -0,0 +1,32 @@
+/*
+ * Copyright (c) 2008, Intel Corporation
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors:
+ *    Eric Anholt <eric@anholt.net>
+ *
+ **/
+#ifndef _PSB_SGX_H_
+#define _PSB_SGX_H_
+
+extern int psb_submit_video_cmdbuf(struct drm_device *dev,
+			       struct ttm_buffer_object *cmd_buffer,
+			       unsigned long cmd_offset,
+			       unsigned long cmd_size,
+			       struct ttm_fence_object *fence);
+
+extern int drm_idle_check_interval;
+
+#endif
diff --git a/drivers/staging/gma500/psb_ttm_fence.c b/drivers/staging/gma500/psb_ttm_fence.c
new file mode 100644
index 0000000..d1c3590
--- /dev/null
+++ b/drivers/staging/gma500/psb_ttm_fence.c
@@ -0,0 +1,605 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+#include "psb_ttm_fence_api.h"
+#include "psb_ttm_fence_driver.h"
+#include <linux/wait.h>
+#include <linux/sched.h>
+
+#include <drm/drmP.h>
+
+/*
+ * Simple implementation for now.
+ */
+
+static void ttm_fence_lockup(struct ttm_fence_object *fence, uint32_t mask)
+{
+	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
+
+	printk(KERN_ERR "GPU lockup dectected on engine %u "
+	       "fence type 0x%08x\n",
+	       (unsigned int)fence->fence_class, (unsigned int)mask);
+	/*
+	 * Give engines some time to idle?
+	 */
+
+	write_lock(&fc->lock);
+	ttm_fence_handler(fence->fdev, fence->fence_class,
+			  fence->sequence, mask, -EBUSY);
+	write_unlock(&fc->lock);
+}
+
+/*
+ * Convenience function to be called by fence::wait methods that
+ * need polling.
+ */
+
+int ttm_fence_wait_polling(struct ttm_fence_object *fence, bool lazy,
+			   bool interruptible, uint32_t mask)
+{
+	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
+	const struct ttm_fence_driver *driver = ttm_fence_driver(fence);
+	uint32_t count = 0;
+	int ret;
+	unsigned long end_jiffies = fence->timeout_jiffies;
+
+	DECLARE_WAITQUEUE(entry, current);
+	add_wait_queue(&fc->fence_queue, &entry);
+
+	ret = 0;
+
+	for (;;) {
+		__set_current_state((interruptible) ?
+				    TASK_INTERRUPTIBLE : TASK_UNINTERRUPTIBLE);
+		if (ttm_fence_object_signaled(fence, mask))
+			break;
+		if (time_after_eq(jiffies, end_jiffies)) {
+			if (driver->lockup)
+				driver->lockup(fence, mask);
+			else
+				ttm_fence_lockup(fence, mask);
+			continue;
+		}
+		if (lazy)
+			schedule_timeout(1);
+		else if ((++count & 0x0F) == 0) {
+			__set_current_state(TASK_RUNNING);
+			schedule();
+			__set_current_state((interruptible) ?
+					    TASK_INTERRUPTIBLE :
+					    TASK_UNINTERRUPTIBLE);
+		}
+		if (interruptible && signal_pending(current)) {
+			ret = -ERESTART;
+			break;
+		}
+	}
+	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(&fc->fence_queue, &entry);
+	return ret;
+}
+
+/*
+ * Typically called by the IRQ handler.
+ */
+
+void ttm_fence_handler(struct ttm_fence_device *fdev, uint32_t fence_class,
+		       uint32_t sequence, uint32_t type, uint32_t error)
+{
+	int wake = 0;
+	uint32_t diff;
+	uint32_t relevant_type;
+	uint32_t new_type;
+	struct ttm_fence_class_manager *fc = &fdev->fence_class[fence_class];
+	const struct ttm_fence_driver *driver = ttm_fence_driver_from_dev(fdev);
+	struct list_head *head;
+	struct ttm_fence_object *fence, *next;
+	bool found = false;
+
+	if (list_empty(&fc->ring))
+		return;
+
+	list_for_each_entry(fence, &fc->ring, ring) {
+		diff = (sequence - fence->sequence) & fc->sequence_mask;
+		if (diff > fc->wrap_diff) {
+			found = true;
+			break;
+		}
+	}
+
+	fc->waiting_types &= ~type;
+	head = (found) ? &fence->ring : &fc->ring;
+
+	list_for_each_entry_safe_reverse(fence, next, head, ring) {
+		if (&fence->ring == &fc->ring)
+			break;
+
+		DRM_DEBUG("Fence 0x%08lx, sequence 0x%08x, type 0x%08x\n",
+			  (unsigned long)fence, fence->sequence,
+			  fence->fence_type);
+
+		if (error) {
+			fence->info.error = error;
+			fence->info.signaled_types = fence->fence_type;
+			list_del_init(&fence->ring);
+			wake = 1;
+			break;
+		}
+
+		relevant_type = type & fence->fence_type;
+		new_type = (fence->info.signaled_types | relevant_type) ^
+		    fence->info.signaled_types;
+
+		if (new_type) {
+			fence->info.signaled_types |= new_type;
+			DRM_DEBUG("Fence 0x%08lx signaled 0x%08x\n",
+				  (unsigned long)fence,
+				  fence->info.signaled_types);
+
+			if (unlikely(driver->signaled))
+				driver->signaled(fence);
+
+			if (driver->needed_flush)
+				fc->pending_flush |=
+				    driver->needed_flush(fence);
+
+			if (new_type & fence->waiting_types)
+				wake = 1;
+		}
+
+		fc->waiting_types |=
+		    fence->waiting_types & ~fence->info.signaled_types;
+
+		if (!(fence->fence_type & ~fence->info.signaled_types)) {
+			DRM_DEBUG("Fence completely signaled 0x%08lx\n",
+				  (unsigned long)fence);
+			list_del_init(&fence->ring);
+		}
+	}
+
+	/*
+	 * Reinstate lost waiting types.
+	 */
+
+	if ((fc->waiting_types & type) != type) {
+		head = head->prev;
+		list_for_each_entry(fence, head, ring) {
+			if (&fence->ring == &fc->ring)
+				break;
+			diff =
+			    (fc->highest_waiting_sequence -
+			     fence->sequence) & fc->sequence_mask;
+			if (diff > fc->wrap_diff)
+				break;
+
+			fc->waiting_types |=
+			    fence->waiting_types & ~fence->info.signaled_types;
+		}
+	}
+
+	if (wake)
+		wake_up_all(&fc->fence_queue);
+}
+
+static void ttm_fence_unring(struct ttm_fence_object *fence)
+{
+	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
+	unsigned long irq_flags;
+
+	write_lock_irqsave(&fc->lock, irq_flags);
+	list_del_init(&fence->ring);
+	write_unlock_irqrestore(&fc->lock, irq_flags);
+}
+
+bool ttm_fence_object_signaled(struct ttm_fence_object *fence, uint32_t mask)
+{
+	unsigned long flags;
+	bool signaled;
+	const struct ttm_fence_driver *driver = ttm_fence_driver(fence);
+	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
+
+	mask &= fence->fence_type;
+	read_lock_irqsave(&fc->lock, flags);
+	signaled = (mask & fence->info.signaled_types) == mask;
+	read_unlock_irqrestore(&fc->lock, flags);
+	if (!signaled && driver->poll) {
+		write_lock_irqsave(&fc->lock, flags);
+		driver->poll(fence->fdev, fence->fence_class, mask);
+		signaled = (mask & fence->info.signaled_types) == mask;
+		write_unlock_irqrestore(&fc->lock, flags);
+	}
+	return signaled;
+}
+
+int ttm_fence_object_flush(struct ttm_fence_object *fence, uint32_t type)
+{
+	const struct ttm_fence_driver *driver = ttm_fence_driver(fence);
+	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
+	unsigned long irq_flags;
+	uint32_t saved_pending_flush;
+	uint32_t diff;
+	bool call_flush;
+
+	if (type & ~fence->fence_type) {
+		DRM_ERROR("Flush trying to extend fence type, "
+			  "0x%x, 0x%x\n", type, fence->fence_type);
+		return -EINVAL;
+	}
+
+	write_lock_irqsave(&fc->lock, irq_flags);
+	fence->waiting_types |= type;
+	fc->waiting_types |= fence->waiting_types;
+	diff = (fence->sequence - fc->highest_waiting_sequence) &
+	    fc->sequence_mask;
+
+	if (diff < fc->wrap_diff)
+		fc->highest_waiting_sequence = fence->sequence;
+
+	/*
+	 * fence->waiting_types has changed. Determine whether
+	 * we need to initiate some kind of flush as a result of this.
+	 */
+
+	saved_pending_flush = fc->pending_flush;
+	if (driver->needed_flush)
+		fc->pending_flush |= driver->needed_flush(fence);
+
+	if (driver->poll)
+		driver->poll(fence->fdev, fence->fence_class,
+			     fence->waiting_types);
+
+	call_flush = (fc->pending_flush != 0);
+	write_unlock_irqrestore(&fc->lock, irq_flags);
+
+	if (call_flush && driver->flush)
+		driver->flush(fence->fdev, fence->fence_class);
+
+	return 0;
+}
+
+/*
+ * Make sure old fence objects are signaled before their fence sequences are
+ * wrapped around and reused.
+ */
+
+void ttm_fence_flush_old(struct ttm_fence_device *fdev,
+			 uint32_t fence_class, uint32_t sequence)
+{
+	struct ttm_fence_class_manager *fc = &fdev->fence_class[fence_class];
+	struct ttm_fence_object *fence;
+	unsigned long irq_flags;
+	const struct ttm_fence_driver *driver = fdev->driver;
+	bool call_flush;
+
+	uint32_t diff;
+
+	write_lock_irqsave(&fc->lock, irq_flags);
+
+	list_for_each_entry_reverse(fence, &fc->ring, ring) {
+		diff = (sequence - fence->sequence) & fc->sequence_mask;
+		if (diff <= fc->flush_diff)
+			break;
+
+		fence->waiting_types = fence->fence_type;
+		fc->waiting_types |= fence->fence_type;
+
+		if (driver->needed_flush)
+			fc->pending_flush |= driver->needed_flush(fence);
+	}
+
+	if (driver->poll)
+		driver->poll(fdev, fence_class, fc->waiting_types);
+
+	call_flush = (fc->pending_flush != 0);
+	write_unlock_irqrestore(&fc->lock, irq_flags);
+
+	if (call_flush && driver->flush)
+		driver->flush(fdev, fence->fence_class);
+
+	/*
+	 * FIXME: Shold we implement a wait here for really old fences?
+	 */
+
+}
+
+int ttm_fence_object_wait(struct ttm_fence_object *fence,
+			  bool lazy, bool interruptible, uint32_t mask)
+{
+	const struct ttm_fence_driver *driver = ttm_fence_driver(fence);
+	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
+	int ret = 0;
+	unsigned long timeout;
+	unsigned long cur_jiffies;
+	unsigned long to_jiffies;
+
+	if (mask & ~fence->fence_type) {
+		DRM_ERROR("Wait trying to extend fence type"
+			  " 0x%08x 0x%08x\n", mask, fence->fence_type);
+		BUG();
+		return -EINVAL;
+	}
+
+	if (driver->wait)
+		return driver->wait(fence, lazy, interruptible, mask);
+
+	ttm_fence_object_flush(fence, mask);
+retry:
+	if (!driver->has_irq ||
+	    driver->has_irq(fence->fdev, fence->fence_class, mask)) {
+
+		cur_jiffies = jiffies;
+		to_jiffies = fence->timeout_jiffies;
+
+		timeout = (time_after(to_jiffies, cur_jiffies)) ?
+		    to_jiffies - cur_jiffies : 1;
+
+		if (interruptible)
+			ret = wait_event_interruptible_timeout
+			    (fc->fence_queue,
+			     ttm_fence_object_signaled(fence, mask), timeout);
+		else
+			ret = wait_event_timeout
+			    (fc->fence_queue,
+			     ttm_fence_object_signaled(fence, mask), timeout);
+
+		if (unlikely(ret == -ERESTARTSYS))
+			return -ERESTART;
+
+		if (unlikely(ret == 0)) {
+			if (driver->lockup)
+				driver->lockup(fence, mask);
+			else
+				ttm_fence_lockup(fence, mask);
+			goto retry;
+		}
+
+		return 0;
+	}
+
+	return ttm_fence_wait_polling(fence, lazy, interruptible, mask);
+}
+
+int ttm_fence_object_emit(struct ttm_fence_object *fence, uint32_t fence_flags,
+			  uint32_t fence_class, uint32_t type)
+{
+	const struct ttm_fence_driver *driver = ttm_fence_driver(fence);
+	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
+	unsigned long flags;
+	uint32_t sequence;
+	unsigned long timeout;
+	int ret;
+
+	ttm_fence_unring(fence);
+	ret = driver->emit(fence->fdev,
+			   fence_class, fence_flags, &sequence, &timeout);
+	if (ret)
+		return ret;
+
+	write_lock_irqsave(&fc->lock, flags);
+	fence->fence_class = fence_class;
+	fence->fence_type = type;
+	fence->waiting_types = 0;
+	fence->info.signaled_types = 0;
+	fence->info.error = 0;
+	fence->sequence = sequence;
+	fence->timeout_jiffies = timeout;
+	if (list_empty(&fc->ring))
+		fc->highest_waiting_sequence = sequence - 1;
+	list_add_tail(&fence->ring, &fc->ring);
+	fc->latest_queued_sequence = sequence;
+	write_unlock_irqrestore(&fc->lock, flags);
+	return 0;
+}
+
+int ttm_fence_object_init(struct ttm_fence_device *fdev,
+			  uint32_t fence_class,
+			  uint32_t type,
+			  uint32_t create_flags,
+			  void (*destroy) (struct ttm_fence_object *),
+			  struct ttm_fence_object *fence)
+{
+	int ret = 0;
+
+	kref_init(&fence->kref);
+	fence->fence_class = fence_class;
+	fence->fence_type = type;
+	fence->info.signaled_types = 0;
+	fence->waiting_types = 0;
+	fence->sequence = 0;
+	fence->info.error = 0;
+	fence->fdev = fdev;
+	fence->destroy = destroy;
+	INIT_LIST_HEAD(&fence->ring);
+	atomic_inc(&fdev->count);
+
+	if (create_flags & TTM_FENCE_FLAG_EMIT) {
+		ret = ttm_fence_object_emit(fence, create_flags,
+					    fence->fence_class, type);
+	}
+
+	return ret;
+}
+
+int ttm_fence_object_create(struct ttm_fence_device *fdev,
+			    uint32_t fence_class,
+			    uint32_t type,
+			    uint32_t create_flags,
+			    struct ttm_fence_object **c_fence)
+{
+	struct ttm_fence_object *fence;
+	int ret;
+
+	ret = ttm_mem_global_alloc(fdev->mem_glob,
+				   sizeof(*fence),
+				   false,
+				   false);
+	if (unlikely(ret != 0)) {
+		printk(KERN_ERR "Out of memory creating fence object\n");
+		return ret;
+	}
+
+	fence = kmalloc(sizeof(*fence), GFP_KERNEL);
+	if (!fence) {
+		printk(KERN_ERR "Out of memory creating fence object\n");
+		ttm_mem_global_free(fdev->mem_glob, sizeof(*fence));
+		return -ENOMEM;
+	}
+
+	ret = ttm_fence_object_init(fdev, fence_class, type,
+				    create_flags, NULL, fence);
+	if (ret) {
+		ttm_fence_object_unref(&fence);
+		return ret;
+	}
+	*c_fence = fence;
+
+	return 0;
+}
+
+static void ttm_fence_object_destroy(struct kref *kref)
+{
+	struct ttm_fence_object *fence =
+	    container_of(kref, struct ttm_fence_object, kref);
+	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
+	unsigned long irq_flags;
+
+	write_lock_irqsave(&fc->lock, irq_flags);
+	list_del_init(&fence->ring);
+	write_unlock_irqrestore(&fc->lock, irq_flags);
+
+	atomic_dec(&fence->fdev->count);
+	if (fence->destroy)
+		fence->destroy(fence);
+	else {
+		ttm_mem_global_free(fence->fdev->mem_glob,
+				    sizeof(*fence));
+		kfree(fence);
+	}
+}
+
+void ttm_fence_device_release(struct ttm_fence_device *fdev)
+{
+	kfree(fdev->fence_class);
+}
+
+int
+ttm_fence_device_init(int num_classes,
+		      struct ttm_mem_global *mem_glob,
+		      struct ttm_fence_device *fdev,
+		      const struct ttm_fence_class_init *init,
+		      bool replicate_init,
+		      const struct ttm_fence_driver *driver)
+{
+	struct ttm_fence_class_manager *fc;
+	const struct ttm_fence_class_init *fci;
+	int i;
+
+	fdev->mem_glob = mem_glob;
+	fdev->fence_class = kzalloc(num_classes *
+				    sizeof(*fdev->fence_class), GFP_KERNEL);
+
+	if (unlikely(!fdev->fence_class))
+		return -ENOMEM;
+
+	fdev->num_classes = num_classes;
+	atomic_set(&fdev->count, 0);
+	fdev->driver = driver;
+
+	for (i = 0; i < fdev->num_classes; ++i) {
+		fc = &fdev->fence_class[i];
+		fci = &init[(replicate_init) ? 0 : i];
+
+		fc->wrap_diff = fci->wrap_diff;
+		fc->flush_diff = fci->flush_diff;
+		fc->sequence_mask = fci->sequence_mask;
+
+		rwlock_init(&fc->lock);
+		INIT_LIST_HEAD(&fc->ring);
+		init_waitqueue_head(&fc->fence_queue);
+	}
+
+	return 0;
+}
+
+struct ttm_fence_info ttm_fence_get_info(struct ttm_fence_object *fence)
+{
+	struct ttm_fence_class_manager *fc = ttm_fence_fc(fence);
+	struct ttm_fence_info tmp;
+	unsigned long irq_flags;
+
+	read_lock_irqsave(&fc->lock, irq_flags);
+	tmp = fence->info;
+	read_unlock_irqrestore(&fc->lock, irq_flags);
+
+	return tmp;
+}
+
+void ttm_fence_object_unref(struct ttm_fence_object **p_fence)
+{
+	struct ttm_fence_object *fence = *p_fence;
+
+	*p_fence = NULL;
+	(void)kref_put(&fence->kref, &ttm_fence_object_destroy);
+}
+
+/*
+ * Placement / BO sync object glue.
+ */
+
+bool ttm_fence_sync_obj_signaled(void *sync_obj, void *sync_arg)
+{
+	struct ttm_fence_object *fence = (struct ttm_fence_object *)sync_obj;
+	uint32_t fence_types = (uint32_t) (unsigned long)sync_arg;
+
+	return ttm_fence_object_signaled(fence, fence_types);
+}
+
+int ttm_fence_sync_obj_wait(void *sync_obj, void *sync_arg,
+			    bool lazy, bool interruptible)
+{
+	struct ttm_fence_object *fence = (struct ttm_fence_object *)sync_obj;
+	uint32_t fence_types = (uint32_t) (unsigned long)sync_arg;
+
+	return ttm_fence_object_wait(fence, lazy, interruptible, fence_types);
+}
+
+int ttm_fence_sync_obj_flush(void *sync_obj, void *sync_arg)
+{
+	struct ttm_fence_object *fence = (struct ttm_fence_object *)sync_obj;
+	uint32_t fence_types = (uint32_t) (unsigned long)sync_arg;
+
+	return ttm_fence_object_flush(fence, fence_types);
+}
+
+void ttm_fence_sync_obj_unref(void **sync_obj)
+{
+	ttm_fence_object_unref((struct ttm_fence_object **)sync_obj);
+}
+
+void *ttm_fence_sync_obj_ref(void *sync_obj)
+{
+	return (void *)
+	    ttm_fence_object_ref((struct ttm_fence_object *)sync_obj);
+}
diff --git a/drivers/staging/gma500/psb_ttm_fence_api.h b/drivers/staging/gma500/psb_ttm_fence_api.h
new file mode 100644
index 0000000..d42904c
--- /dev/null
+++ b/drivers/staging/gma500/psb_ttm_fence_api.h
@@ -0,0 +1,272 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+#ifndef _TTM_FENCE_API_H_
+#define _TTM_FENCE_API_H_
+
+#include <linux/list.h>
+#include <linux/kref.h>
+
+#define TTM_FENCE_FLAG_EMIT (1 << 0)
+#define TTM_FENCE_TYPE_EXE  (1 << 0)
+
+struct ttm_fence_device;
+
+/**
+ * struct ttm_fence_info
+ *
+ * @fence_class:    The fence class.
+ * @fence_type:     Bitfield indicating types for this fence.
+ * @signaled_types: Bitfield indicating which types are signaled.
+ * @error:          Last error reported from the device.
+ *
+ * Used as output from the ttm_fence_get_info
+ */
+
+struct ttm_fence_info {
+	uint32_t signaled_types;
+	uint32_t error;
+};
+
+/**
+ * struct ttm_fence_object
+ *
+ * @fdev:            Pointer to the fence device struct.
+ * @kref:            Holds the reference count of this fence object.
+ * @ring:            List head used for the circular list of not-completely
+ *                   signaled fences.
+ * @info:            Data for fast retrieval using the ttm_fence_get_info()
+ * function.
+ * @timeout_jiffies: Absolute jiffies value indicating when this fence
+ *                   object times out and, if waited on, calls ttm_fence_lockup
+ *                   to check for and resolve a GPU lockup.
+ * @sequence:        Fence sequence number.
+ * @waiting_types:   Types currently waited on.
+ * @destroy:         Called to free the fence object, when its refcount has
+ *                   reached zero. If NULL, kfree is used.
+ *
+ * This struct is provided in the driver interface so that drivers can
+ * derive from it and create their own fence implementation. All members
+ * are private to the fence implementation and the fence driver callbacks.
+ * Otherwise a driver may access the derived object using container_of().
+ */
+
+struct ttm_fence_object {
+	struct ttm_fence_device *fdev;
+	struct kref kref;
+	uint32_t fence_class;
+	uint32_t fence_type;
+
+	/*
+	 * The below fields are protected by the fence class
+	 * manager spinlock.
+	 */
+
+	struct list_head ring;
+	struct ttm_fence_info info;
+	unsigned long timeout_jiffies;
+	uint32_t sequence;
+	uint32_t waiting_types;
+	void (*destroy) (struct ttm_fence_object *);
+};
+
+/**
+ * ttm_fence_object_init
+ *
+ * @fdev: Pointer to a struct ttm_fence_device.
+ * @fence_class: Fence class for this fence.
+ * @type: Fence type for this fence.
+ * @create_flags: Flags indicating varios actions at init time. At this point
+ * there's only TTM_FENCE_FLAG_EMIT, which triggers a sequence emission to
+ * the command stream.
+ * @destroy: Destroy function. If NULL, kfree() is used.
+ * @fence: The struct ttm_fence_object to initialize.
+ *
+ * Initialize a pre-allocated fence object. This function, together with the
+ * destroy function makes it possible to derive driver-specific fence objects.
+ */
+
+extern int
+ttm_fence_object_init(struct ttm_fence_device *fdev,
+		      uint32_t fence_class,
+		      uint32_t type,
+		      uint32_t create_flags,
+		      void (*destroy) (struct ttm_fence_object *fence),
+		      struct ttm_fence_object *fence);
+
+/**
+ * ttm_fence_object_create
+ *
+ * @fdev: Pointer to a struct ttm_fence_device.
+ * @fence_class: Fence class for this fence.
+ * @type: Fence type for this fence.
+ * @create_flags: Flags indicating varios actions at init time. At this point
+ * there's only TTM_FENCE_FLAG_EMIT, which triggers a sequence emission to
+ * the command stream.
+ * @c_fence: On successful termination, *(@c_fence) will point to the created
+ * fence object.
+ *
+ * Create and initialize a struct ttm_fence_object. The destroy function will
+ * be set to kfree().
+ */
+
+extern int
+ttm_fence_object_create(struct ttm_fence_device *fdev,
+			uint32_t fence_class,
+			uint32_t type,
+			uint32_t create_flags,
+			struct ttm_fence_object **c_fence);
+
+/**
+ * ttm_fence_object_wait
+ *
+ * @fence: The fence object to wait on.
+ * @lazy: Allow sleeps to reduce the cpu-usage if polling.
+ * @interruptible: Sleep interruptible when waiting.
+ * @type_mask: Wait for the given type_mask to signal.
+ *
+ * Wait for a fence to signal the given type_mask. The function will
+ * perform a fence_flush using type_mask. (See ttm_fence_object_flush).
+ *
+ * Returns
+ * -ERESTART if interrupted by a signal.
+ * May return driver-specific error codes if timed-out.
+ */
+
+extern int
+ttm_fence_object_wait(struct ttm_fence_object *fence,
+		      bool lazy, bool interruptible, uint32_t type_mask);
+
+/**
+ * ttm_fence_object_flush
+ *
+ * @fence: The fence object to flush.
+ * @flush_mask: Fence types to flush.
+ *
+ * Make sure that the given fence eventually signals the
+ * types indicated by @flush_mask. Note that this may or may not
+ * map to a CPU or GPU flush.
+ */
+
+extern int
+ttm_fence_object_flush(struct ttm_fence_object *fence, uint32_t flush_mask);
+
+/**
+ * ttm_fence_get_info
+ *
+ * @fence: The fence object.
+ *
+ * Copy the info block from the fence while holding relevant locks.
+ */
+
+struct ttm_fence_info ttm_fence_get_info(struct ttm_fence_object *fence);
+
+/**
+ * ttm_fence_object_ref
+ *
+ * @fence: The fence object.
+ *
+ * Return a ref-counted pointer to the fence object indicated by @fence.
+ */
+
+static inline struct ttm_fence_object *ttm_fence_object_ref(struct
+							    ttm_fence_object
+							    *fence)
+{
+	kref_get(&fence->kref);
+	return fence;
+}
+
+/**
+ * ttm_fence_object_unref
+ *
+ * @p_fence: Pointer to a ref-counted pinter to a struct ttm_fence_object.
+ *
+ * Unreference the fence object pointed to by *(@p_fence), clearing
+ * *(p_fence).
+ */
+
+extern void ttm_fence_object_unref(struct ttm_fence_object **p_fence);
+
+/**
+ * ttm_fence_object_signaled
+ *
+ * @fence: Pointer to the struct ttm_fence_object.
+ * @mask: Type mask to check whether signaled.
+ *
+ * This function checks (without waiting) whether the fence object
+ * pointed to by @fence has signaled the types indicated by @mask,
+ * and returns 1 if true, 0 if false. This function does NOT perform
+ * an implicit fence flush.
+ */
+
+extern bool
+ttm_fence_object_signaled(struct ttm_fence_object *fence, uint32_t mask);
+
+/**
+ * ttm_fence_class
+ *
+ * @fence: Pointer to the struct ttm_fence_object.
+ *
+ * Convenience function that returns the fence class of a
+ * struct ttm_fence_object.
+ */
+
+static inline uint32_t ttm_fence_class(const struct ttm_fence_object *fence)
+{
+	return fence->fence_class;
+}
+
+/**
+ * ttm_fence_types
+ *
+ * @fence: Pointer to the struct ttm_fence_object.
+ *
+ * Convenience function that returns the fence types of a
+ * struct ttm_fence_object.
+ */
+
+static inline uint32_t ttm_fence_types(const struct ttm_fence_object *fence)
+{
+	return fence->fence_type;
+}
+
+/*
+ * The functions below are wrappers to the above functions, with
+ * similar names but with sync_obj omitted. These wrappers are intended
+ * to be plugged directly into the buffer object driver's sync object
+ * API, if the driver chooses to use ttm_fence_objects as buffer object
+ * sync objects. In the prototypes below, a sync_obj is cast to a
+ * struct ttm_fence_object, whereas a sync_arg is cast to an
+ * uint32_t representing a fence_type argument.
+ */
+
+extern bool ttm_fence_sync_obj_signaled(void *sync_obj, void *sync_arg);
+extern int ttm_fence_sync_obj_wait(void *sync_obj, void *sync_arg,
+				   bool lazy, bool interruptible);
+extern int ttm_fence_sync_obj_flush(void *sync_obj, void *sync_arg);
+extern void ttm_fence_sync_obj_unref(void **sync_obj);
+extern void *ttm_fence_sync_obj_ref(void *sync_obj);
+
+#endif
diff --git a/drivers/staging/gma500/psb_ttm_fence_driver.h b/drivers/staging/gma500/psb_ttm_fence_driver.h
new file mode 100644
index 0000000..233c6ba
--- /dev/null
+++ b/drivers/staging/gma500/psb_ttm_fence_driver.h
@@ -0,0 +1,302 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+#ifndef _TTM_FENCE_DRIVER_H_
+#define _TTM_FENCE_DRIVER_H_
+
+#include <linux/kref.h>
+#include <linux/spinlock.h>
+#include <linux/wait.h>
+#include "psb_ttm_fence_api.h"
+#include "ttm/ttm_memory.h"
+
+/** @file ttm_fence_driver.h
+ *
+ * Definitions needed for a driver implementing the
+ * ttm_fence subsystem.
+ */
+
+/**
+ * struct ttm_fence_class_manager:
+ *
+ * @wrap_diff: Sequence difference to catch 32-bit wrapping.
+ * if (seqa - seqb) > @wrap_diff, then seqa < seqb.
+ * @flush_diff: Sequence difference to trigger fence flush.
+ * if (cur_seq - seqa) > @flush_diff, then consider fence object with
+ * seqa as old an needing a flush.
+ * @sequence_mask: Mask of valid bits in a fence sequence.
+ * @lock: Lock protecting this struct as well as fence objects
+ * associated with this struct.
+ * @ring: Circular sequence-ordered list of fence objects.
+ * @pending_flush: Fence types currently needing a flush.
+ * @waiting_types: Fence types that are currently waited for.
+ * @fence_queue: Queue of waiters on fences belonging to this fence class.
+ * @highest_waiting_sequence: Sequence number of the fence with highest
+ * sequence number and that is waited for.
+ * @latest_queued_sequence: Sequence number of the fence latest queued
+ * on the ring.
+ */
+
+struct ttm_fence_class_manager {
+
+	/*
+	 * Unprotected constant members.
+	 */
+
+	uint32_t wrap_diff;
+	uint32_t flush_diff;
+	uint32_t sequence_mask;
+
+	/*
+	 * The rwlock protects this structure as well as
+	 * the data in all fence objects belonging to this
+	 * class. This should be OK as most fence objects are
+	 * only read from once they're created.
+	 */
+
+	rwlock_t lock;
+	struct list_head ring;
+	uint32_t pending_flush;
+	uint32_t waiting_types;
+	wait_queue_head_t fence_queue;
+	uint32_t highest_waiting_sequence;
+	uint32_t latest_queued_sequence;
+};
+
+/**
+ * struct ttm_fence_device
+ *
+ * @fence_class:  Array of fence class managers.
+ * @num_classes:  Array dimension of @fence_class.
+ * @count:        Current number of fence objects for statistics.
+ * @driver:       Driver struct.
+ *
+ * Provided in the driver interface so that the driver can derive
+ * from this struct for its driver_private, and accordingly
+ * access the driver_private from the fence driver callbacks.
+ *
+ * All members except "count" are initialized at creation and
+ * never touched after that. No protection needed.
+ *
+ * This struct is private to the fence implementation and to the fence
+ * driver callbacks, and may otherwise be used by drivers only to
+ * obtain the derived device_private object using container_of().
+ */
+
+struct ttm_fence_device {
+	struct ttm_mem_global *mem_glob;
+	struct ttm_fence_class_manager *fence_class;
+	uint32_t num_classes;
+	atomic_t count;
+	const struct ttm_fence_driver *driver;
+};
+
+/**
+ * struct ttm_fence_class_init
+ *
+ * @wrap_diff:    Fence sequence number wrap indicator. If
+ * (sequence1 - sequence2) > @wrap_diff, then sequence1 is
+ * considered to be older than sequence2.
+ * @flush_diff:   Fence sequence number flush indicator.
+ * If a non-completely-signaled fence has a fence sequence number
+ * sequence1 and (sequence1 - current_emit_sequence) > @flush_diff,
+ * the fence is considered too old and it will be flushed upon the
+ * next call of ttm_fence_flush_old(), to make sure no fences with
+ * stale sequence numbers remains unsignaled. @flush_diff should
+ * be sufficiently less than @wrap_diff.
+ * @sequence_mask: Mask with valid bits of the fence sequence
+ * number set to 1.
+ *
+ * This struct is used as input to ttm_fence_device_init.
+ */
+
+struct ttm_fence_class_init {
+	uint32_t wrap_diff;
+	uint32_t flush_diff;
+	uint32_t sequence_mask;
+};
+
+/**
+ * struct ttm_fence_driver
+ *
+ * @has_irq: Called by a potential waiter. Should return 1 if a
+ * fence object with indicated parameters is expected to signal
+ * automatically, and 0 if the fence implementation needs to
+ * repeatedly call @poll to make it signal.
+ * @emit:    Make sure a fence with the given parameters is
+ * present in the indicated command stream. Return its sequence number
+ * in "breadcrumb".
+ * @poll:    Check and report sequences of the given "fence_class"
+ *           that have signaled "types"
+ * @flush:   Make sure that the types indicated by the bitfield
+ *           ttm_fence_class_manager::pending_flush will eventually
+ *           signal. These bits have been put together using the
+ *           result from the needed_flush function described below.
+ * @needed_flush: Given the fence_class and fence_types indicated by
+ *           "fence", and the last received fence sequence of this
+ *           fence class, indicate what types need a fence flush to
+ *           signal. Return as a bitfield.
+ * @wait:    Set to non-NULL if the driver wants to override the fence
+ *           wait implementation. Return 0 on success, -EBUSY on failure,
+ *           and -ERESTART if interruptible and a signal is pending.
+ * @signaled:  Driver callback that is called whenever a
+ *           ttm_fence_object::signaled_types has changed status.
+ *           This function is called from atomic context,
+ *           with the ttm_fence_class_manager::lock held in write mode.
+ * @lockup:  Driver callback that is called whenever a wait has exceeded
+ *           the lifetime of a fence object.
+ *           If there is a GPU lockup,
+ *           this function should, if possible, reset the GPU,
+ *           call the ttm_fence_handler with an error status, and
+ *           return. If no lockup was detected, simply extend the
+ *           fence timeout_jiffies and return. The driver might
+ *           want to protect the lockup check with a mutex and cache a
+ *           non-locked-up status for a while to avoid an excessive
+ *           amount of lockup checks from every waiting thread.
+ */
+
+struct ttm_fence_driver {
+	bool (*has_irq) (struct ttm_fence_device *fdev,
+			uint32_t fence_class, uint32_t flags);
+	int (*emit) (struct ttm_fence_device *fdev,
+		     uint32_t fence_class,
+		     uint32_t flags,
+		     uint32_t *breadcrumb, unsigned long *timeout_jiffies);
+	void (*flush) (struct ttm_fence_device *fdev, uint32_t fence_class);
+	void (*poll) (struct ttm_fence_device *fdev,
+		      uint32_t fence_class, uint32_t types);
+	 uint32_t(*needed_flush)
+	 (struct ttm_fence_object *fence);
+	int (*wait) (struct ttm_fence_object *fence, bool lazy,
+		     bool interruptible, uint32_t mask);
+	void (*signaled) (struct ttm_fence_object *fence);
+	void (*lockup) (struct ttm_fence_object *fence, uint32_t fence_types);
+};
+
+/**
+ * function ttm_fence_device_init
+ *
+ * @num_classes:      Number of fence classes for this fence implementation.
+ * @mem_global:       Pointer to the global memory accounting info.
+ * @fdev:             Pointer to an uninitialised struct ttm_fence_device.
+ * @init:             Array of initialization info for each fence class.
+ * @replicate_init:   Use the first @init initialization info for all classes.
+ * @driver:           Driver callbacks.
+ *
+ * Initialize a struct ttm_fence_driver structure. Returns -ENOMEM if
+ * out-of-memory. Otherwise returns 0.
+ */
+extern int
+ttm_fence_device_init(int num_classes,
+		      struct ttm_mem_global *mem_glob,
+		      struct ttm_fence_device *fdev,
+		      const struct ttm_fence_class_init *init,
+		      bool replicate_init,
+		      const struct ttm_fence_driver *driver);
+
+/**
+ * function ttm_fence_device_release
+ *
+ * @fdev:             Pointer to the fence device.
+ *
+ * Release all resources held by a fence device. Note that before
+ * this function is called, the caller must have made sure all fence
+ * objects belonging to this fence device are completely signaled.
+ */
+
+extern void ttm_fence_device_release(struct ttm_fence_device *fdev);
+
+/**
+ * ttm_fence_handler - the fence handler.
+ *
+ * @fdev:        Pointer to the fence device.
+ * @fence_class: Fence class that signals.
+ * @sequence:    Signaled sequence.
+ * @type:        Types that signal.
+ * @error:       Error from the engine.
+ *
+ * This function signals all fences with a sequence previous to the
+ * @sequence argument, and belonging to @fence_class. The signaled fence
+ * types are provided in @type. If error is non-zero, the error member
+ * of the fence with sequence = @sequence is set to @error. This value
+ * may be reported back to user-space, indicating, for example an illegal
+ * 3D command or illegal mpeg data.
+ *
+ * This function is typically called from the driver::poll method when the
+ * command sequence preceding the fence marker has executed. It should be
+ * called with the ttm_fence_class_manager::lock held in write mode and
+ * may be called from interrupt context.
+ */
+
+extern void
+ttm_fence_handler(struct ttm_fence_device *fdev,
+		  uint32_t fence_class,
+		  uint32_t sequence, uint32_t type, uint32_t error);
+
+/**
+ * ttm_fence_driver_from_dev
+ *
+ * @fdev:        The ttm fence device.
+ *
+ * Returns a pointer to the fence driver struct.
+ */
+
+static inline const struct ttm_fence_driver *ttm_fence_driver_from_dev(
+						struct ttm_fence_device *fdev)
+{
+	return fdev->driver;
+}
+
+/**
+ * ttm_fence_driver
+ *
+ * @fence:        Pointer to a ttm fence object.
+ *
+ * Returns a pointer to the fence driver struct.
+ */
+
+static inline const struct ttm_fence_driver *ttm_fence_driver(struct
+							      ttm_fence_object
+							      *fence)
+{
+	return ttm_fence_driver_from_dev(fence->fdev);
+}
+
+/**
+ * ttm_fence_fc
+ *
+ * @fence:        Pointer to a ttm fence object.
+ *
+ * Returns a pointer to the struct ttm_fence_class_manager for the
+ * fence class of @fence.
+ */
+
+static inline struct ttm_fence_class_manager *ttm_fence_fc(struct
+							   ttm_fence_object
+							   *fence)
+{
+	return &fence->fdev->fence_class[fence->fence_class];
+}
+
+#endif
diff --git a/drivers/staging/gma500/psb_ttm_fence_user.c b/drivers/staging/gma500/psb_ttm_fence_user.c
new file mode 100644
index 0000000..36f974f
--- /dev/null
+++ b/drivers/staging/gma500/psb_ttm_fence_user.c
@@ -0,0 +1,237 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+#include <drm/drmP.h>
+#include "psb_ttm_fence_user.h"
+#include "ttm/ttm_object.h"
+#include "psb_ttm_fence_driver.h"
+#include "psb_ttm_userobj_api.h"
+
+/**
+ * struct ttm_fence_user_object
+ *
+ * @base:    The base object used for user-space visibility and refcounting.
+ *
+ * @fence:   The fence object itself.
+ *
+ */
+
+struct ttm_fence_user_object {
+	struct ttm_base_object base;
+	struct ttm_fence_object fence;
+};
+
+static struct ttm_fence_user_object *ttm_fence_user_object_lookup(
+					struct ttm_object_file *tfile,
+					uint32_t handle)
+{
+	struct ttm_base_object *base;
+
+	base = ttm_base_object_lookup(tfile, handle);
+	if (unlikely(base == NULL)) {
+		printk(KERN_ERR "Invalid fence handle 0x%08lx\n",
+		       (unsigned long)handle);
+		return NULL;
+	}
+
+	if (unlikely(base->object_type != ttm_fence_type)) {
+		ttm_base_object_unref(&base);
+		printk(KERN_ERR "Invalid fence handle 0x%08lx\n",
+		       (unsigned long)handle);
+		return NULL;
+	}
+
+	return container_of(base, struct ttm_fence_user_object, base);
+}
+
+/*
+ * The fence object destructor.
+ */
+
+static void ttm_fence_user_destroy(struct ttm_fence_object *fence)
+{
+	struct ttm_fence_user_object *ufence =
+	    container_of(fence, struct ttm_fence_user_object, fence);
+
+	ttm_mem_global_free(fence->fdev->mem_glob, sizeof(*ufence));
+	kfree(ufence);
+}
+
+/*
+ * The base object destructor. We basically unly unreference the
+ * attached fence object.
+ */
+
+static void ttm_fence_user_release(struct ttm_base_object **p_base)
+{
+	struct ttm_fence_user_object *ufence;
+	struct ttm_base_object *base = *p_base;
+	struct ttm_fence_object *fence;
+
+	*p_base = NULL;
+
+	if (unlikely(base == NULL))
+		return;
+
+	ufence = container_of(base, struct ttm_fence_user_object, base);
+	fence = &ufence->fence;
+	ttm_fence_object_unref(&fence);
+}
+
+int
+ttm_fence_user_create(struct ttm_fence_device *fdev,
+		      struct ttm_object_file *tfile,
+		      uint32_t fence_class,
+		      uint32_t fence_types,
+		      uint32_t create_flags,
+		      struct ttm_fence_object **fence,
+		      uint32_t *user_handle)
+{
+	int ret;
+	struct ttm_fence_object *tmp;
+	struct ttm_fence_user_object *ufence;
+
+	ret = ttm_mem_global_alloc(fdev->mem_glob,
+				   sizeof(*ufence),
+				   false,
+				   false);
+	if (unlikely(ret != 0))
+		return -ENOMEM;
+
+	ufence = kmalloc(sizeof(*ufence), GFP_KERNEL);
+	if (unlikely(ufence == NULL)) {
+		ttm_mem_global_free(fdev->mem_glob, sizeof(*ufence));
+		return -ENOMEM;
+	}
+
+	ret = ttm_fence_object_init(fdev,
+				    fence_class,
+				    fence_types, create_flags,
+				    &ttm_fence_user_destroy, &ufence->fence);
+
+	if (unlikely(ret != 0))
+		goto out_err0;
+
+	/*
+	 * One fence ref is held by the fence ptr we return.
+	 * The other one by the base object. Need to up the
+	 * fence refcount before we publish this object to
+	 * user-space.
+	 */
+
+	tmp = ttm_fence_object_ref(&ufence->fence);
+	ret = ttm_base_object_init(tfile, &ufence->base,
+				   false, ttm_fence_type,
+				   &ttm_fence_user_release, NULL);
+
+	if (unlikely(ret != 0))
+		goto out_err1;
+
+	*fence = &ufence->fence;
+	*user_handle = ufence->base.hash.key;
+
+	return 0;
+out_err1:
+	ttm_fence_object_unref(&tmp);
+	tmp = &ufence->fence;
+	ttm_fence_object_unref(&tmp);
+	return ret;
+out_err0:
+	ttm_mem_global_free(fdev->mem_glob, sizeof(*ufence));
+	kfree(ufence);
+	return ret;
+}
+
+int ttm_fence_signaled_ioctl(struct ttm_object_file *tfile, void *data)
+{
+	int ret;
+	union ttm_fence_signaled_arg *arg = data;
+	struct ttm_fence_object *fence;
+	struct ttm_fence_info info;
+	struct ttm_fence_user_object *ufence;
+	struct ttm_base_object *base;
+	ret = 0;
+
+	ufence = ttm_fence_user_object_lookup(tfile, arg->req.handle);
+	if (unlikely(ufence == NULL))
+		return -EINVAL;
+
+	fence = &ufence->fence;
+
+	if (arg->req.flush) {
+		ret = ttm_fence_object_flush(fence, arg->req.fence_type);
+		if (unlikely(ret != 0))
+			goto out;
+	}
+
+	info = ttm_fence_get_info(fence);
+	arg->rep.signaled_types = info.signaled_types;
+	arg->rep.fence_error = info.error;
+
+out:
+	base = &ufence->base;
+	ttm_base_object_unref(&base);
+	return ret;
+}
+
+int ttm_fence_finish_ioctl(struct ttm_object_file *tfile, void *data)
+{
+	int ret;
+	union ttm_fence_finish_arg *arg = data;
+	struct ttm_fence_user_object *ufence;
+	struct ttm_base_object *base;
+	struct ttm_fence_object *fence;
+	ret = 0;
+
+	ufence = ttm_fence_user_object_lookup(tfile, arg->req.handle);
+	if (unlikely(ufence == NULL))
+		return -EINVAL;
+
+	fence = &ufence->fence;
+
+	ret = ttm_fence_object_wait(fence,
+				    arg->req.mode & TTM_FENCE_FINISH_MODE_LAZY,
+				    true, arg->req.fence_type);
+	if (likely(ret == 0)) {
+		struct ttm_fence_info info = ttm_fence_get_info(fence);
+
+		arg->rep.signaled_types = info.signaled_types;
+		arg->rep.fence_error = info.error;
+	}
+
+	base = &ufence->base;
+	ttm_base_object_unref(&base);
+
+	return ret;
+}
+
+int ttm_fence_unref_ioctl(struct ttm_object_file *tfile, void *data)
+{
+	struct ttm_fence_unref_arg *arg = data;
+	int ret = 0;
+
+	ret = ttm_ref_object_base_unref(tfile, arg->handle, ttm_fence_type);
+	return ret;
+}
diff --git a/drivers/staging/gma500/psb_ttm_fence_user.h b/drivers/staging/gma500/psb_ttm_fence_user.h
new file mode 100644
index 0000000..ee95e6a
--- /dev/null
+++ b/drivers/staging/gma500/psb_ttm_fence_user.h
@@ -0,0 +1,140 @@
+/**************************************************************************
+ *
+ * Copyright 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+/*
+ * Authors
+ * Thomas Hellström <thomas-at-tungstengraphics-dot-com>
+ */
+
+#ifndef TTM_FENCE_USER_H
+#define TTM_FENCE_USER_H
+
+#if !defined(__KERNEL__) && !defined(_KERNEL)
+#include <stdint.h>
+#endif
+
+#define TTM_FENCE_MAJOR 0
+#define TTM_FENCE_MINOR 1
+#define TTM_FENCE_PL    0
+#define TTM_FENCE_DATE  "080819"
+
+/**
+ * struct ttm_fence_signaled_req
+ *
+ * @handle: Handle to the fence object. Input.
+ *
+ * @fence_type: Fence types we want to flush. Input.
+ *
+ * @flush: Boolean. Flush the indicated fence_types. Input.
+ *
+ * Argument to the TTM_FENCE_SIGNALED ioctl.
+ */
+
+struct ttm_fence_signaled_req {
+	uint32_t handle;
+	uint32_t fence_type;
+	int32_t flush;
+	uint32_t pad64;
+};
+
+/**
+ * struct ttm_fence_rep
+ *
+ * @signaled_types: Fence type that has signaled.
+ *
+ * @fence_error: Command execution error.
+ * Hardware errors that are consequences of the execution
+ * of the command stream preceding the fence are reported
+ * here.
+ *
+ * Output argument to the TTM_FENCE_SIGNALED and
+ * TTM_FENCE_FINISH ioctls.
+ */
+
+struct ttm_fence_rep {
+	uint32_t signaled_types;
+	uint32_t fence_error;
+};
+
+union ttm_fence_signaled_arg {
+	struct ttm_fence_signaled_req req;
+	struct ttm_fence_rep rep;
+};
+
+/*
+ * Waiting mode flags for the TTM_FENCE_FINISH ioctl.
+ *
+ * TTM_FENCE_FINISH_MODE_LAZY: Allow for sleeps during polling
+ * wait.
+ *
+ * TTM_FENCE_FINISH_MODE_NO_BLOCK: Don't block waiting for GPU,
+ * but return -EBUSY if the buffer is busy.
+ */
+
+#define TTM_FENCE_FINISH_MODE_LAZY     (1 << 0)
+#define TTM_FENCE_FINISH_MODE_NO_BLOCK (1 << 1)
+
+/**
+ * struct ttm_fence_finish_req
+ *
+ * @handle: Handle to the fence object. Input.
+ *
+ * @fence_type: Fence types we want to finish.
+ *
+ * @mode: Wait mode.
+ *
+ * Input to the TTM_FENCE_FINISH ioctl.
+ */
+
+struct ttm_fence_finish_req {
+	uint32_t handle;
+	uint32_t fence_type;
+	uint32_t mode;
+	uint32_t pad64;
+};
+
+union ttm_fence_finish_arg {
+	struct ttm_fence_finish_req req;
+	struct ttm_fence_rep rep;
+};
+
+/**
+ * struct ttm_fence_unref_arg
+ *
+ * @handle: Handle to the fence object.
+ *
+ * Argument to the TTM_FENCE_UNREF ioctl.
+ */
+
+struct ttm_fence_unref_arg {
+	uint32_t handle;
+	uint32_t pad64;
+};
+
+/*
+ * Ioctl offsets frome extenstion start.
+ */
+
+#define TTM_FENCE_SIGNALED 0x01
+#define TTM_FENCE_FINISH   0x02
+#define TTM_FENCE_UNREF    0x03
+
+#endif
diff --git a/drivers/staging/gma500/psb_ttm_glue.c b/drivers/staging/gma500/psb_ttm_glue.c
new file mode 100644
index 0000000..d1d965e
--- /dev/null
+++ b/drivers/staging/gma500/psb_ttm_glue.c
@@ -0,0 +1,349 @@
+/**************************************************************************
+ * Copyright (c) 2008, Intel Corporation.
+ * All Rights Reserved.
+ * Copyright (c) 2008, Tungsten Graphics Inc.  Cedar Park, TX., USA.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+
+
+#include <drm/drmP.h>
+#include "psb_drv.h"
+#include "psb_ttm_userobj_api.h"
+#include <linux/io.h>
+
+
+static struct vm_operations_struct psb_ttm_vm_ops;
+
+/**
+ * NOTE: driver_private of drm_file is now a struct psb_file_data struct
+ * pPriv in struct psb_file_data contains the original psb_fpriv;
+ */
+int psb_open(struct inode *inode, struct file *filp)
+{
+	struct drm_file *file_priv;
+	struct drm_psb_private *dev_priv;
+	struct psb_fpriv *psb_fp;
+	struct psb_file_data *pvr_file_priv;
+	int ret;
+
+	DRM_DEBUG("\n");
+
+	ret = drm_open(inode, filp);
+	if (unlikely(ret))
+		return ret;
+
+	psb_fp = kzalloc(sizeof(*psb_fp), GFP_KERNEL);
+
+	if (unlikely(psb_fp == NULL))
+		goto out_err0;
+
+	file_priv = (struct drm_file *) filp->private_data;
+	dev_priv = psb_priv(file_priv->minor->dev);
+
+	DRM_DEBUG("is_master %d\n", file_priv->is_master ? 1 : 0);
+
+	psb_fp->tfile = ttm_object_file_init(dev_priv->tdev,
+					     PSB_FILE_OBJECT_HASH_ORDER);
+	if (unlikely(psb_fp->tfile == NULL))
+		goto out_err1;
+
+	pvr_file_priv = (struct psb_file_data *)file_priv->driver_priv;
+	if (!pvr_file_priv) {
+		DRM_ERROR("drm file private is NULL\n");
+		goto out_err1;
+	}
+
+	pvr_file_priv->priv = psb_fp;
+	if (unlikely(dev_priv->bdev.dev_mapping == NULL))
+		dev_priv->bdev.dev_mapping = dev_priv->dev->dev_mapping;
+
+	return 0;
+
+out_err1:
+	kfree(psb_fp);
+out_err0:
+	(void) drm_release(inode, filp);
+	return ret;
+}
+
+int psb_release(struct inode *inode, struct file *filp)
+{
+	struct drm_file *file_priv;
+	struct psb_fpriv *psb_fp;
+	struct drm_psb_private *dev_priv;
+	int ret;
+	file_priv = (struct drm_file *) filp->private_data;
+	psb_fp = psb_fpriv(file_priv);
+	dev_priv = psb_priv(file_priv->minor->dev);
+
+	ttm_object_file_release(&psb_fp->tfile);
+	kfree(psb_fp);
+
+	ret = drm_release(inode, filp);
+
+	return ret;
+}
+
+int psb_fence_signaled_ioctl(struct drm_device *dev, void *data,
+			     struct drm_file *file_priv)
+{
+
+	return ttm_fence_signaled_ioctl(psb_fpriv(file_priv)->tfile, data);
+}
+
+int psb_fence_finish_ioctl(struct drm_device *dev, void *data,
+			   struct drm_file *file_priv)
+{
+	return ttm_fence_finish_ioctl(psb_fpriv(file_priv)->tfile, data);
+}
+
+int psb_fence_unref_ioctl(struct drm_device *dev, void *data,
+			  struct drm_file *file_priv)
+{
+	return ttm_fence_unref_ioctl(psb_fpriv(file_priv)->tfile, data);
+}
+
+int psb_pl_waitidle_ioctl(struct drm_device *dev, void *data,
+			  struct drm_file *file_priv)
+{
+	return ttm_pl_waitidle_ioctl(psb_fpriv(file_priv)->tfile, data);
+}
+
+int psb_pl_setstatus_ioctl(struct drm_device *dev, void *data,
+			   struct drm_file *file_priv)
+{
+	return ttm_pl_setstatus_ioctl(psb_fpriv(file_priv)->tfile,
+				      &psb_priv(dev)->ttm_lock, data);
+
+}
+
+int psb_pl_synccpu_ioctl(struct drm_device *dev, void *data,
+			 struct drm_file *file_priv)
+{
+	return ttm_pl_synccpu_ioctl(psb_fpriv(file_priv)->tfile, data);
+}
+
+int psb_pl_unref_ioctl(struct drm_device *dev, void *data,
+		       struct drm_file *file_priv)
+{
+	return ttm_pl_unref_ioctl(psb_fpriv(file_priv)->tfile, data);
+
+}
+
+int psb_pl_reference_ioctl(struct drm_device *dev, void *data,
+			   struct drm_file *file_priv)
+{
+	return  ttm_pl_reference_ioctl(psb_fpriv(file_priv)->tfile, data);
+
+}
+
+int psb_pl_create_ioctl(struct drm_device *dev, void *data,
+			struct drm_file *file_priv)
+{
+	struct drm_psb_private *dev_priv = psb_priv(dev);
+
+	return ttm_pl_create_ioctl(psb_fpriv(file_priv)->tfile,
+				   &dev_priv->bdev, &dev_priv->ttm_lock, data);
+
+}
+
+int psb_pl_ub_create_ioctl(struct drm_device *dev, void *data,
+			struct drm_file *file_priv)
+{
+	struct drm_psb_private *dev_priv = psb_priv(dev);
+
+	return ttm_pl_ub_create_ioctl(psb_fpriv(file_priv)->tfile,
+				   &dev_priv->bdev, &dev_priv->ttm_lock, data);
+
+}
+/**
+ * psb_ttm_fault - Wrapper around the ttm fault method.
+ *
+ * @vma: The struct vm_area_struct as in the vm fault() method.
+ * @vmf: The struct vm_fault as in the vm fault() method.
+ *
+ * Since ttm_fault() will reserve buffers while faulting,
+ * we need to take the ttm read lock around it, as this driver
+ * relies on the ttm_lock in write mode to exclude all threads from
+ * reserving and thus validating buffers in aperture- and memory shortage
+ * situations.
+ */
+
+static int psb_ttm_fault(struct vm_area_struct *vma,
+			 struct vm_fault *vmf)
+{
+	struct ttm_buffer_object *bo = (struct ttm_buffer_object *)
+		vma->vm_private_data;
+	struct drm_psb_private *dev_priv =
+		container_of(bo->bdev, struct drm_psb_private, bdev);
+	int ret;
+
+	ret = ttm_read_lock(&dev_priv->ttm_lock, true);
+	if (unlikely(ret != 0))
+		return VM_FAULT_NOPAGE;
+
+	ret = dev_priv->ttm_vm_ops->fault(vma, vmf);
+
+	ttm_read_unlock(&dev_priv->ttm_lock);
+	return ret;
+}
+
+/**
+ * if vm_pgoff < DRM_PSB_FILE_PAGE_OFFSET call directly to
+ * PVRMMap
+ */
+int psb_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct drm_file *file_priv;
+	struct drm_psb_private *dev_priv;
+	int ret;
+
+	if (vma->vm_pgoff < DRM_PSB_FILE_PAGE_OFFSET ||
+	    vma->vm_pgoff > 2 * DRM_PSB_FILE_PAGE_OFFSET)
+#if 0		/* FIXMEAC */
+		return PVRMMap(filp, vma);
+#else
+		return -EINVAL;
+#endif
+
+	file_priv = (struct drm_file *) filp->private_data;
+	dev_priv = psb_priv(file_priv->minor->dev);
+
+	ret = ttm_bo_mmap(filp, vma, &dev_priv->bdev);
+	if (unlikely(ret != 0))
+		return ret;
+
+	if (unlikely(dev_priv->ttm_vm_ops == NULL)) {
+		dev_priv->ttm_vm_ops = (struct vm_operations_struct *)
+								vma->vm_ops;
+		psb_ttm_vm_ops = *vma->vm_ops;
+		psb_ttm_vm_ops.fault = &psb_ttm_fault;
+	}
+
+	vma->vm_ops = &psb_ttm_vm_ops;
+
+	return 0;
+}
+/*
+ssize_t psb_ttm_write(struct file *filp, const char __user *buf,
+		      size_t count, loff_t *f_pos)
+{
+	struct drm_file *file_priv = (struct drm_file *)filp->private_data;
+	struct drm_psb_private *dev_priv = psb_priv(file_priv->minor->dev);
+
+	return ttm_bo_io(&dev_priv->bdev, filp, buf, NULL, count, f_pos, 1);
+}
+
+ssize_t psb_ttm_read(struct file *filp, char __user *buf,
+		     size_t count, loff_t *f_pos)
+{
+	struct drm_file *file_priv = (struct drm_file *)filp->private_data;
+	struct drm_psb_private *dev_priv = psb_priv(file_priv->minor->dev);
+
+	return ttm_bo_io(&dev_priv->bdev, filp, NULL, buf, count, f_pos, 1);
+}
+*/
+int psb_verify_access(struct ttm_buffer_object *bo,
+		      struct file *filp)
+{
+	struct drm_file *file_priv = (struct drm_file *)filp->private_data;
+
+	if (capable(CAP_SYS_ADMIN))
+		return 0;
+
+	if (unlikely(!file_priv->authenticated))
+		return -EPERM;
+
+	return ttm_pl_verify_access(bo, psb_fpriv(file_priv)->tfile);
+}
+
+static int psb_ttm_mem_global_init(struct drm_global_reference *ref)
+{
+	return ttm_mem_global_init(ref->object);
+}
+
+static void psb_ttm_mem_global_release(struct drm_global_reference *ref)
+{
+	ttm_mem_global_release(ref->object);
+}
+
+int psb_ttm_global_init(struct drm_psb_private *dev_priv)
+{
+	struct drm_global_reference *global_ref;
+	int ret;
+
+	global_ref = &dev_priv->mem_global_ref;
+	global_ref->global_type = DRM_GLOBAL_TTM_MEM;
+	global_ref->size = sizeof(struct ttm_mem_global);
+	global_ref->init = &psb_ttm_mem_global_init;
+	global_ref->release = &psb_ttm_mem_global_release;
+
+	ret = drm_global_item_ref(global_ref);
+	if (unlikely(ret != 0)) {
+		DRM_ERROR("Failed referencing a global TTM memory object.\n");
+		return ret;
+	}
+
+	dev_priv->bo_global_ref.mem_glob = dev_priv->mem_global_ref.object;
+	global_ref = &dev_priv->bo_global_ref.ref;
+	global_ref->global_type = DRM_GLOBAL_TTM_BO;
+	global_ref->size = sizeof(struct ttm_bo_global);
+	global_ref->init = &ttm_bo_global_init;
+	global_ref->release = &ttm_bo_global_release;
+	ret = drm_global_item_ref(global_ref);
+	if (ret != 0) {
+		DRM_ERROR("Failed setting up TTM BO subsystem.\n");
+		drm_global_item_unref(global_ref);
+		return ret;
+	}
+	return 0;
+}
+
+void psb_ttm_global_release(struct drm_psb_private *dev_priv)
+{
+	drm_global_item_unref(&dev_priv->mem_global_ref);
+}
+
+int psb_getpageaddrs_ioctl(struct drm_device *dev, void *data,
+		struct drm_file *file_priv)
+{
+	struct drm_psb_getpageaddrs_arg *arg = data;
+	struct ttm_buffer_object *bo;
+	struct ttm_tt *ttm;
+	struct page **tt_pages;
+	unsigned long i, num_pages;
+	unsigned long *p = arg->page_addrs;
+	int ret = 0;
+
+	bo = ttm_buffer_object_lookup(psb_fpriv(file_priv)->tfile,
+					arg->handle);
+	if (unlikely(bo == NULL)) {
+		printk(KERN_ERR
+			"Could not find buffer object for getpageaddrs.\n");
+		return -EINVAL;
+	}
+
+	arg->gtt_offset = bo->offset;
+	ttm = bo->ttm;
+	num_pages = ttm->num_pages;
+	tt_pages = ttm->pages;
+
+	for (i = 0; i < num_pages; i++)
+		p[i] = (unsigned long)page_to_phys(tt_pages[i]);
+
+	return ret;
+}
diff --git a/drivers/staging/gma500/psb_ttm_placement_user.c b/drivers/staging/gma500/psb_ttm_placement_user.c
new file mode 100644
index 0000000..272b397
--- /dev/null
+++ b/drivers/staging/gma500/psb_ttm_placement_user.c
@@ -0,0 +1,628 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+#include "psb_ttm_placement_user.h"
+#include "ttm/ttm_bo_driver.h"
+#include "ttm/ttm_object.h"
+#include "psb_ttm_userobj_api.h"
+#include "ttm/ttm_lock.h"
+#include <linux/slab.h>
+#include <linux/sched.h>
+
+struct ttm_bo_user_object {
+	struct ttm_base_object base;
+	struct ttm_buffer_object bo;
+};
+
+static size_t pl_bo_size;
+
+static uint32_t psb_busy_prios[] = {
+	TTM_PL_TT,
+	TTM_PL_PRIV0, /* CI */
+	TTM_PL_PRIV2, /* RAR */
+	TTM_PL_PRIV1, /* DRM_PSB_MEM_MMU */
+	TTM_PL_SYSTEM
+};
+
+static const struct ttm_placement default_placement = {
+				0, 0, 0, NULL, 5, psb_busy_prios
+};
+
+static size_t ttm_pl_size(struct ttm_bo_device *bdev, unsigned long num_pages)
+{
+	size_t page_array_size =
+	    (num_pages * sizeof(void *) + PAGE_SIZE - 1) & PAGE_MASK;
+
+	if (unlikely(pl_bo_size == 0)) {
+		pl_bo_size = bdev->glob->ttm_bo_extra_size +
+		    ttm_round_pot(sizeof(struct ttm_bo_user_object));
+	}
+
+	return bdev->glob->ttm_bo_size + 2 * page_array_size;
+}
+
+static struct ttm_bo_user_object *ttm_bo_user_lookup(struct ttm_object_file
+						     *tfile, uint32_t handle)
+{
+	struct ttm_base_object *base;
+
+	base = ttm_base_object_lookup(tfile, handle);
+	if (unlikely(base == NULL)) {
+		printk(KERN_ERR "Invalid buffer object handle 0x%08lx.\n",
+		       (unsigned long)handle);
+		return NULL;
+	}
+
+	if (unlikely(base->object_type != ttm_buffer_type)) {
+		ttm_base_object_unref(&base);
+		printk(KERN_ERR "Invalid buffer object handle 0x%08lx.\n",
+		       (unsigned long)handle);
+		return NULL;
+	}
+
+	return container_of(base, struct ttm_bo_user_object, base);
+}
+
+struct ttm_buffer_object *ttm_buffer_object_lookup(struct ttm_object_file
+						   *tfile, uint32_t handle)
+{
+	struct ttm_bo_user_object *user_bo;
+	struct ttm_base_object *base;
+
+	user_bo = ttm_bo_user_lookup(tfile, handle);
+	if (unlikely(user_bo == NULL))
+		return NULL;
+
+	(void)ttm_bo_reference(&user_bo->bo);
+	base = &user_bo->base;
+	ttm_base_object_unref(&base);
+	return &user_bo->bo;
+}
+
+static void ttm_bo_user_destroy(struct ttm_buffer_object *bo)
+{
+	struct ttm_bo_user_object *user_bo =
+	    container_of(bo, struct ttm_bo_user_object, bo);
+
+	ttm_mem_global_free(bo->glob->mem_glob, bo->acc_size);
+	kfree(user_bo);
+}
+
+static void ttm_bo_user_release(struct ttm_base_object **p_base)
+{
+	struct ttm_bo_user_object *user_bo;
+	struct ttm_base_object *base = *p_base;
+	struct ttm_buffer_object *bo;
+
+	*p_base = NULL;
+
+	if (unlikely(base == NULL))
+		return;
+
+	user_bo = container_of(base, struct ttm_bo_user_object, base);
+	bo = &user_bo->bo;
+	ttm_bo_unref(&bo);
+}
+
+static void ttm_bo_user_ref_release(struct ttm_base_object *base,
+				    enum ttm_ref_type ref_type)
+{
+	struct ttm_bo_user_object *user_bo =
+	    container_of(base, struct ttm_bo_user_object, base);
+	struct ttm_buffer_object *bo = &user_bo->bo;
+
+	switch (ref_type) {
+	case TTM_REF_SYNCCPU_WRITE:
+		ttm_bo_synccpu_write_release(bo);
+		break;
+	default:
+		BUG();
+	}
+}
+
+static void ttm_pl_fill_rep(struct ttm_buffer_object *bo,
+			    struct ttm_pl_rep *rep)
+{
+	struct ttm_bo_user_object *user_bo =
+	    container_of(bo, struct ttm_bo_user_object, bo);
+
+	rep->gpu_offset = bo->offset;
+	rep->bo_size = bo->num_pages << PAGE_SHIFT;
+	rep->map_handle = bo->addr_space_offset;
+	rep->placement = bo->mem.placement;
+	rep->handle = user_bo->base.hash.key;
+	rep->sync_object_arg = (uint32_t) (unsigned long)bo->sync_obj_arg;
+}
+
+/* FIXME Copy from upstream TTM */
+static inline size_t ttm_bo_size(struct ttm_bo_global *glob,
+				 unsigned long num_pages)
+{
+	size_t page_array_size = (num_pages * sizeof(void *) + PAGE_SIZE - 1) &
+	    PAGE_MASK;
+
+	return glob->ttm_bo_size + 2 * page_array_size;
+}
+
+/* FIXME Copy from upstream TTM "ttm_bo_create", upstream TTM does not
+   export this, so copy it here */
+static int ttm_bo_create_private(struct ttm_bo_device *bdev,
+			unsigned long size,
+			enum ttm_bo_type type,
+			struct ttm_placement *placement,
+			uint32_t page_alignment,
+			unsigned long buffer_start,
+			bool interruptible,
+			struct file *persistant_swap_storage,
+			struct ttm_buffer_object **p_bo)
+{
+	struct ttm_buffer_object *bo;
+	struct ttm_mem_global *mem_glob = bdev->glob->mem_glob;
+	int ret;
+
+	size_t acc_size =
+	    ttm_bo_size(bdev->glob, (size + PAGE_SIZE - 1) >> PAGE_SHIFT);
+	ret = ttm_mem_global_alloc(mem_glob, acc_size, false, false);
+	if (unlikely(ret != 0))
+		return ret;
+
+	bo = kzalloc(sizeof(*bo), GFP_KERNEL);
+
+	if (unlikely(bo == NULL)) {
+		ttm_mem_global_free(mem_glob, acc_size);
+		return -ENOMEM;
+	}
+
+	ret = ttm_bo_init(bdev, bo, size, type, placement, page_alignment,
+				buffer_start, interruptible,
+				persistant_swap_storage, acc_size, NULL);
+	if (likely(ret == 0))
+		*p_bo = bo;
+
+	return ret;
+}
+
+int psb_ttm_bo_check_placement(struct ttm_buffer_object *bo,
+				struct ttm_placement *placement)
+{
+	int i;
+
+	for (i = 0; i < placement->num_placement; i++) {
+		if (!capable(CAP_SYS_ADMIN)) {
+			if (placement->placement[i] & TTM_PL_FLAG_NO_EVICT) {
+				printk(KERN_ERR TTM_PFX "Need to be root to "
+					"modify NO_EVICT status.\n");
+				return -EINVAL;
+			}
+		}
+	}
+	for (i = 0; i < placement->num_busy_placement; i++) {
+		if (!capable(CAP_SYS_ADMIN)) {
+			if (placement->busy_placement[i]
+						& TTM_PL_FLAG_NO_EVICT) {
+				printk(KERN_ERR TTM_PFX "Need to be root to modify NO_EVICT status.\n");
+				return -EINVAL;
+			}
+		}
+	}
+	return 0;
+}
+
+int ttm_buffer_object_create(struct ttm_bo_device *bdev,
+			unsigned long size,
+			enum ttm_bo_type type,
+			uint32_t flags,
+			uint32_t page_alignment,
+			unsigned long buffer_start,
+			bool interruptible,
+			struct file *persistant_swap_storage,
+			struct ttm_buffer_object **p_bo)
+{
+	struct ttm_placement placement = default_placement;
+	int ret;
+
+	if ((flags & TTM_PL_MASK_CACHING) == 0)
+		flags |= TTM_PL_FLAG_WC | TTM_PL_FLAG_UNCACHED;
+
+	placement.num_placement = 1;
+	placement.placement = &flags;
+
+	ret = ttm_bo_create_private(bdev,
+			size,
+			type,
+			&placement,
+			page_alignment,
+			buffer_start,
+			interruptible,
+			persistant_swap_storage,
+			p_bo);
+
+	return ret;
+}
+
+
+int ttm_pl_create_ioctl(struct ttm_object_file *tfile,
+			struct ttm_bo_device *bdev,
+			struct ttm_lock *lock, void *data)
+{
+	union ttm_pl_create_arg *arg = data;
+	struct ttm_pl_create_req *req = &arg->req;
+	struct ttm_pl_rep *rep = &arg->rep;
+	struct ttm_buffer_object *bo;
+	struct ttm_buffer_object *tmp;
+	struct ttm_bo_user_object *user_bo;
+	uint32_t flags;
+	int ret = 0;
+	struct ttm_mem_global *mem_glob = bdev->glob->mem_glob;
+	struct ttm_placement placement = default_placement;
+	size_t acc_size =
+	    ttm_pl_size(bdev, (req->size + PAGE_SIZE - 1) >> PAGE_SHIFT);
+	ret = ttm_mem_global_alloc(mem_glob, acc_size, false, false);
+	if (unlikely(ret != 0))
+		return ret;
+
+	flags = req->placement;
+	user_bo = kzalloc(sizeof(*user_bo), GFP_KERNEL);
+	if (unlikely(user_bo == NULL)) {
+		ttm_mem_global_free(mem_glob, acc_size);
+		return -ENOMEM;
+	}
+
+	bo = &user_bo->bo;
+	ret = ttm_read_lock(lock, true);
+	if (unlikely(ret != 0)) {
+		ttm_mem_global_free(mem_glob, acc_size);
+		kfree(user_bo);
+		return ret;
+	}
+
+	placement.num_placement = 1;
+	placement.placement = &flags;
+
+	if ((flags & TTM_PL_MASK_CACHING) == 0)
+		flags |=  TTM_PL_FLAG_WC | TTM_PL_FLAG_UNCACHED;
+
+	ret = ttm_bo_init(bdev, bo, req->size,
+				     ttm_bo_type_device, &placement,
+				     req->page_alignment, 0, true,
+				     NULL, acc_size, &ttm_bo_user_destroy);
+	ttm_read_unlock(lock);
+
+	/*
+	 * Note that the ttm_buffer_object_init function
+	 * would've called the destroy function on failure!!
+	 */
+
+	if (unlikely(ret != 0))
+		goto out;
+
+	tmp = ttm_bo_reference(bo);
+	ret = ttm_base_object_init(tfile, &user_bo->base,
+				   flags & TTM_PL_FLAG_SHARED,
+				   ttm_buffer_type,
+				   &ttm_bo_user_release,
+				   &ttm_bo_user_ref_release);
+	if (unlikely(ret != 0))
+		goto out_err;
+
+	ttm_pl_fill_rep(bo, rep);
+	ttm_bo_unref(&bo);
+out:
+	return 0;
+out_err:
+	ttm_bo_unref(&tmp);
+	ttm_bo_unref(&bo);
+	return ret;
+}
+
+int ttm_pl_ub_create_ioctl(struct ttm_object_file *tfile,
+			   struct ttm_bo_device *bdev,
+			   struct ttm_lock *lock, void *data)
+{
+	union ttm_pl_create_ub_arg *arg = data;
+	struct ttm_pl_create_ub_req *req = &arg->req;
+	struct ttm_pl_rep *rep = &arg->rep;
+	struct ttm_buffer_object *bo;
+	struct ttm_buffer_object *tmp;
+	struct ttm_bo_user_object *user_bo;
+	uint32_t flags;
+	int ret = 0;
+	struct ttm_mem_global *mem_glob = bdev->glob->mem_glob;
+	struct ttm_placement placement = default_placement;
+	size_t acc_size =
+	    ttm_pl_size(bdev, (req->size + PAGE_SIZE - 1) >> PAGE_SHIFT);
+	ret = ttm_mem_global_alloc(mem_glob, acc_size, false, false);
+	if (unlikely(ret != 0))
+		return ret;
+
+	flags = req->placement;
+	user_bo = kzalloc(sizeof(*user_bo), GFP_KERNEL);
+	if (unlikely(user_bo == NULL)) {
+		ttm_mem_global_free(mem_glob, acc_size);
+		return -ENOMEM;
+	}
+	ret = ttm_read_lock(lock, true);
+	if (unlikely(ret != 0)) {
+		ttm_mem_global_free(mem_glob, acc_size);
+		kfree(user_bo);
+		return ret;
+	}
+	bo = &user_bo->bo;
+
+	placement.num_placement = 1;
+	placement.placement = &flags;
+
+	ret = ttm_bo_init(bdev,
+					bo,
+					req->size,
+					ttm_bo_type_user,
+					&placement,
+					req->page_alignment,
+					req->user_address,
+					true,
+					NULL,
+					acc_size,
+					&ttm_bo_user_destroy);
+
+	/*
+	 * Note that the ttm_buffer_object_init function
+	 * would've called the destroy function on failure!!
+	 */
+	ttm_read_unlock(lock);
+	if (unlikely(ret != 0))
+		goto out;
+
+	tmp = ttm_bo_reference(bo);
+	ret = ttm_base_object_init(tfile, &user_bo->base,
+				   flags & TTM_PL_FLAG_SHARED,
+				   ttm_buffer_type,
+				   &ttm_bo_user_release,
+				   &ttm_bo_user_ref_release);
+	if (unlikely(ret != 0))
+		goto out_err;
+
+	ttm_pl_fill_rep(bo, rep);
+	ttm_bo_unref(&bo);
+out:
+	return 0;
+out_err:
+	ttm_bo_unref(&tmp);
+	ttm_bo_unref(&bo);
+	return ret;
+}
+
+int ttm_pl_reference_ioctl(struct ttm_object_file *tfile, void *data)
+{
+	union ttm_pl_reference_arg *arg = data;
+	struct ttm_pl_rep *rep = &arg->rep;
+	struct ttm_bo_user_object *user_bo;
+	struct ttm_buffer_object *bo;
+	struct ttm_base_object *base;
+	int ret;
+
+	user_bo = ttm_bo_user_lookup(tfile, arg->req.handle);
+	if (unlikely(user_bo == NULL)) {
+		printk(KERN_ERR "Could not reference buffer object.\n");
+		return -EINVAL;
+	}
+
+	bo = &user_bo->bo;
+	ret = ttm_ref_object_add(tfile, &user_bo->base, TTM_REF_USAGE, NULL);
+	if (unlikely(ret != 0)) {
+		printk(KERN_ERR
+		       "Could not add a reference to buffer object.\n");
+		goto out;
+	}
+
+	ttm_pl_fill_rep(bo, rep);
+
+out:
+	base = &user_bo->base;
+	ttm_base_object_unref(&base);
+	return ret;
+}
+
+int ttm_pl_unref_ioctl(struct ttm_object_file *tfile, void *data)
+{
+	struct ttm_pl_reference_req *arg = data;
+
+	return ttm_ref_object_base_unref(tfile, arg->handle, TTM_REF_USAGE);
+}
+
+int ttm_pl_synccpu_ioctl(struct ttm_object_file *tfile, void *data)
+{
+	struct ttm_pl_synccpu_arg *arg = data;
+	struct ttm_bo_user_object *user_bo;
+	struct ttm_buffer_object *bo;
+	struct ttm_base_object *base;
+	bool existed;
+	int ret;
+
+	switch (arg->op) {
+	case TTM_PL_SYNCCPU_OP_GRAB:
+		user_bo = ttm_bo_user_lookup(tfile, arg->handle);
+		if (unlikely(user_bo == NULL)) {
+			printk(KERN_ERR
+			       "Could not find buffer object for synccpu.\n");
+			return -EINVAL;
+		}
+		bo = &user_bo->bo;
+		base = &user_bo->base;
+		ret = ttm_bo_synccpu_write_grab(bo,
+						arg->access_mode &
+						TTM_PL_SYNCCPU_MODE_NO_BLOCK);
+		if (unlikely(ret != 0)) {
+			ttm_base_object_unref(&base);
+			goto out;
+		}
+		ret = ttm_ref_object_add(tfile, &user_bo->base,
+					 TTM_REF_SYNCCPU_WRITE, &existed);
+		if (existed || ret != 0)
+			ttm_bo_synccpu_write_release(bo);
+		ttm_base_object_unref(&base);
+		break;
+	case TTM_PL_SYNCCPU_OP_RELEASE:
+		ret = ttm_ref_object_base_unref(tfile, arg->handle,
+						TTM_REF_SYNCCPU_WRITE);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+out:
+	return ret;
+}
+
+int ttm_pl_setstatus_ioctl(struct ttm_object_file *tfile,
+			   struct ttm_lock *lock, void *data)
+{
+	union ttm_pl_setstatus_arg *arg = data;
+	struct ttm_pl_setstatus_req *req = &arg->req;
+	struct ttm_pl_rep *rep = &arg->rep;
+	struct ttm_buffer_object *bo;
+	struct ttm_bo_device *bdev;
+	struct ttm_placement placement = default_placement;
+	uint32_t flags[2];
+	int ret;
+
+	bo = ttm_buffer_object_lookup(tfile, req->handle);
+	if (unlikely(bo == NULL)) {
+		printk(KERN_ERR
+		       "Could not find buffer object for setstatus.\n");
+		return -EINVAL;
+	}
+
+	bdev = bo->bdev;
+
+	ret = ttm_read_lock(lock, true);
+	if (unlikely(ret != 0))
+		goto out_err0;
+
+	ret = ttm_bo_reserve(bo, true, false, false, 0);
+	if (unlikely(ret != 0))
+		goto out_err1;
+
+	ret = ttm_bo_wait_cpu(bo, false);
+	if (unlikely(ret != 0))
+		goto out_err2;
+
+	flags[0] = req->set_placement;
+	flags[1] = req->clr_placement;
+
+	placement.num_placement = 2;
+	placement.placement = flags;
+
+	/* Review internal locking ? FIXMEAC */
+	ret = psb_ttm_bo_check_placement(bo, &placement);
+	if (unlikely(ret != 0))
+		goto out_err2;
+
+	placement.num_placement = 1;
+	flags[0] = (req->set_placement | bo->mem.placement)
+						& ~req->clr_placement;
+
+	ret = ttm_bo_validate(bo, &placement, true, false, false);
+	if (unlikely(ret != 0))
+		goto out_err2;
+
+	ttm_pl_fill_rep(bo, rep);
+out_err2:
+	ttm_bo_unreserve(bo);
+out_err1:
+	ttm_read_unlock(lock);
+out_err0:
+	ttm_bo_unref(&bo);
+	return ret;
+}
+
+static int psb_ttm_bo_block_reservation(struct ttm_buffer_object *bo,
+				bool interruptible, bool no_wait)
+{
+	int ret;
+
+	while (unlikely(atomic_cmpxchg(&bo->reserved, 0, 1) != 0)) {
+		if (no_wait)
+			return -EBUSY;
+		else if (interruptible) {
+			ret = wait_event_interruptible(bo->event_queue,
+					atomic_read(&bo->reserved) == 0);
+			if (unlikely(ret != 0))
+				return -ERESTART;
+		} else {
+			wait_event(bo->event_queue,
+				atomic_read(&bo->reserved) == 0);
+		}
+	}
+	return 0;
+}
+
+static void psb_ttm_bo_unblock_reservation(struct ttm_buffer_object *bo)
+{
+	atomic_set(&bo->reserved, 0);
+	wake_up_all(&bo->event_queue);
+}
+
+int ttm_pl_waitidle_ioctl(struct ttm_object_file *tfile, void *data)
+{
+	struct ttm_pl_waitidle_arg *arg = data;
+	struct ttm_buffer_object *bo;
+	int ret;
+
+	bo = ttm_buffer_object_lookup(tfile, arg->handle);
+	if (unlikely(bo == NULL)) {
+		printk(KERN_ERR "Could not find buffer object for waitidle.\n");
+		return -EINVAL;
+	}
+
+	ret =
+	    psb_ttm_bo_block_reservation(bo, true,
+				     arg->mode & TTM_PL_WAITIDLE_MODE_NO_BLOCK);
+	if (unlikely(ret != 0))
+		goto out;
+	ret = ttm_bo_wait(bo,
+			  arg->mode & TTM_PL_WAITIDLE_MODE_LAZY,
+			  true, arg->mode & TTM_PL_WAITIDLE_MODE_NO_BLOCK);
+	psb_ttm_bo_unblock_reservation(bo);
+out:
+	ttm_bo_unref(&bo);
+	return ret;
+}
+
+int ttm_pl_verify_access(struct ttm_buffer_object *bo,
+			 struct ttm_object_file *tfile)
+{
+	struct ttm_bo_user_object *ubo;
+
+	/*
+	 * Check bo subclass.
+	 */
+
+	if (unlikely(bo->destroy != &ttm_bo_user_destroy))
+		return -EPERM;
+
+	ubo = container_of(bo, struct ttm_bo_user_object, bo);
+	if (likely(ubo->base.shareable || ubo->base.tfile == tfile))
+		return 0;
+
+	return -EPERM;
+}
diff --git a/drivers/staging/gma500/psb_ttm_placement_user.h b/drivers/staging/gma500/psb_ttm_placement_user.h
new file mode 100644
index 0000000..f17bf48
--- /dev/null
+++ b/drivers/staging/gma500/psb_ttm_placement_user.h
@@ -0,0 +1,252 @@
+/**************************************************************************
+ *
+ * Copyright 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+/*
+ * Authors
+ * Thomas Hellström <thomas-at-tungstengraphics-dot-com>
+ */
+
+#ifndef _TTM_PLACEMENT_USER_H_
+#define _TTM_PLACEMENT_USER_H_
+
+#if !defined(__KERNEL__) && !defined(_KERNEL)
+#include <stdint.h>
+#else
+#include <linux/kernel.h>
+#endif
+
+#include "ttm/ttm_placement.h"
+
+#define TTM_PLACEMENT_MAJOR 0
+#define TTM_PLACEMENT_MINOR 1
+#define TTM_PLACEMENT_PL    0
+#define TTM_PLACEMENT_DATE  "080819"
+
+/**
+ * struct ttm_pl_create_req
+ *
+ * @size: The buffer object size.
+ * @placement: Flags that indicate initial acceptable
+ *  placement.
+ * @page_alignment: Required alignment in pages.
+ *
+ * Input to the TTM_BO_CREATE ioctl.
+ */
+
+struct ttm_pl_create_req {
+	uint64_t size;
+	uint32_t placement;
+	uint32_t page_alignment;
+};
+
+/**
+ * struct ttm_pl_create_ub_req
+ *
+ * @size: The buffer object size.
+ * @user_address: User-space address of the memory area that
+ * should be used to back the buffer object cast to 64-bit.
+ * @placement: Flags that indicate initial acceptable
+ *  placement.
+ * @page_alignment: Required alignment in pages.
+ *
+ * Input to the TTM_BO_CREATE_UB ioctl.
+ */
+
+struct ttm_pl_create_ub_req {
+	uint64_t size;
+	uint64_t user_address;
+	uint32_t placement;
+	uint32_t page_alignment;
+};
+
+/**
+ * struct ttm_pl_rep
+ *
+ * @gpu_offset: The current offset into the memory region used.
+ * This can be used directly by the GPU if there are no
+ * additional GPU mapping procedures used by the driver.
+ *
+ * @bo_size: Actual buffer object size.
+ *
+ * @map_handle: Offset into the device address space.
+ * Used for map, seek, read, write. This will never change
+ * during the lifetime of an object.
+ *
+ * @placement: Flag indicating the placement status of
+ * the buffer object using the TTM_PL flags above.
+ *
+ * @sync_object_arg: Used for user-space synchronization and
+ * depends on the synchronization model used. If fences are
+ * used, this is the buffer_object::fence_type_mask
+ *
+ * Output from the TTM_PL_CREATE and TTM_PL_REFERENCE, and
+ * TTM_PL_SETSTATUS ioctls.
+ */
+
+struct ttm_pl_rep {
+	uint64_t gpu_offset;
+	uint64_t bo_size;
+	uint64_t map_handle;
+	uint32_t placement;
+	uint32_t handle;
+	uint32_t sync_object_arg;
+	uint32_t pad64;
+};
+
+/**
+ * struct ttm_pl_setstatus_req
+ *
+ * @set_placement: Placement flags to set.
+ *
+ * @clr_placement: Placement flags to clear.
+ *
+ * @handle: The object handle
+ *
+ * Input to the TTM_PL_SETSTATUS ioctl.
+ */
+
+struct ttm_pl_setstatus_req {
+	uint32_t set_placement;
+	uint32_t clr_placement;
+	uint32_t handle;
+	uint32_t pad64;
+};
+
+/**
+ * struct ttm_pl_reference_req
+ *
+ * @handle: The object to put a reference on.
+ *
+ * Input to the TTM_PL_REFERENCE and the TTM_PL_UNREFERENCE ioctls.
+ */
+
+struct ttm_pl_reference_req {
+	uint32_t handle;
+	uint32_t pad64;
+};
+
+/*
+ * ACCESS mode flags for SYNCCPU.
+ *
+ * TTM_SYNCCPU_MODE_READ will guarantee that the GPU is not
+ * writing to the buffer.
+ *
+ * TTM_SYNCCPU_MODE_WRITE will guarantee that the GPU is not
+ * accessing the buffer.
+ *
+ * TTM_SYNCCPU_MODE_NO_BLOCK makes sure the call does not wait
+ * for GPU accesses to finish but return -EBUSY.
+ *
+ * TTM_SYNCCPU_MODE_TRYCACHED Try to place the buffer in cacheable
+ * memory while synchronized for CPU.
+ */
+
+#define TTM_PL_SYNCCPU_MODE_READ      TTM_ACCESS_READ
+#define TTM_PL_SYNCCPU_MODE_WRITE     TTM_ACCESS_WRITE
+#define TTM_PL_SYNCCPU_MODE_NO_BLOCK  (1 << 2)
+#define TTM_PL_SYNCCPU_MODE_TRYCACHED (1 << 3)
+
+/**
+ * struct ttm_pl_synccpu_arg
+ *
+ * @handle: The object to synchronize.
+ *
+ * @access_mode: access mode indicated by the
+ * TTM_SYNCCPU_MODE flags.
+ *
+ * @op: indicates whether to grab or release the
+ * buffer for cpu usage.
+ *
+ * Input to the TTM_PL_SYNCCPU ioctl.
+ */
+
+struct ttm_pl_synccpu_arg {
+	uint32_t handle;
+	uint32_t access_mode;
+	enum {
+		TTM_PL_SYNCCPU_OP_GRAB,
+		TTM_PL_SYNCCPU_OP_RELEASE
+	} op;
+	uint32_t pad64;
+};
+
+/*
+ * Waiting mode flags for the TTM_BO_WAITIDLE ioctl.
+ *
+ * TTM_WAITIDLE_MODE_LAZY: Allow for sleeps during polling
+ * wait.
+ *
+ * TTM_WAITIDLE_MODE_NO_BLOCK: Don't block waiting for GPU,
+ * but return -EBUSY if the buffer is busy.
+ */
+
+#define TTM_PL_WAITIDLE_MODE_LAZY     (1 << 0)
+#define TTM_PL_WAITIDLE_MODE_NO_BLOCK (1 << 1)
+
+/**
+ * struct ttm_waitidle_arg
+ *
+ * @handle: The object to synchronize.
+ *
+ * @mode: wait mode indicated by the
+ * TTM_SYNCCPU_MODE flags.
+ *
+ * Argument to the TTM_BO_WAITIDLE ioctl.
+ */
+
+struct ttm_pl_waitidle_arg {
+	uint32_t handle;
+	uint32_t mode;
+};
+
+union ttm_pl_create_arg {
+	struct ttm_pl_create_req req;
+	struct ttm_pl_rep rep;
+};
+
+union ttm_pl_reference_arg {
+	struct ttm_pl_reference_req req;
+	struct ttm_pl_rep rep;
+};
+
+union ttm_pl_setstatus_arg {
+	struct ttm_pl_setstatus_req req;
+	struct ttm_pl_rep rep;
+};
+
+union ttm_pl_create_ub_arg {
+	struct ttm_pl_create_ub_req req;
+	struct ttm_pl_rep rep;
+};
+
+/*
+ * Ioctl offsets.
+ */
+
+#define TTM_PL_CREATE      0x00
+#define TTM_PL_REFERENCE   0x01
+#define TTM_PL_UNREF       0x02
+#define TTM_PL_SYNCCPU     0x03
+#define TTM_PL_WAITIDLE    0x04
+#define TTM_PL_SETSTATUS   0x05
+#define TTM_PL_CREATE_UB   0x06
+
+#endif
diff --git a/drivers/staging/gma500/psb_ttm_userobj_api.h b/drivers/staging/gma500/psb_ttm_userobj_api.h
new file mode 100644
index 0000000..c69fa88
--- /dev/null
+++ b/drivers/staging/gma500/psb_ttm_userobj_api.h
@@ -0,0 +1,85 @@
+/**************************************************************************
+ *
+ * Copyright (c) 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
+ * All Rights Reserved.
+ * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc., 
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics-dot-com>
+ */
+
+#ifndef _TTM_USEROBJ_API_H_
+#define _TTM_USEROBJ_API_H_
+
+#include "psb_ttm_placement_user.h"
+#include "psb_ttm_fence_user.h"
+#include "ttm/ttm_object.h"
+#include "psb_ttm_fence_api.h"
+#include "ttm/ttm_bo_api.h"
+
+struct ttm_lock;
+
+/*
+ * User ioctls.
+ */
+
+extern int ttm_pl_create_ioctl(struct ttm_object_file *tfile,
+			       struct ttm_bo_device *bdev,
+			       struct ttm_lock *lock, void *data);
+extern int ttm_pl_ub_create_ioctl(struct ttm_object_file *tfile,
+				  struct ttm_bo_device *bdev,
+				  struct ttm_lock *lock, void *data);
+extern int ttm_pl_reference_ioctl(struct ttm_object_file *tfile, void *data);
+extern int ttm_pl_unref_ioctl(struct ttm_object_file *tfile, void *data);
+extern int ttm_pl_synccpu_ioctl(struct ttm_object_file *tfile, void *data);
+extern int ttm_pl_setstatus_ioctl(struct ttm_object_file *tfile,
+				  struct ttm_lock *lock, void *data);
+extern int ttm_pl_waitidle_ioctl(struct ttm_object_file *tfile, void *data);
+extern int ttm_fence_signaled_ioctl(struct ttm_object_file *tfile, void *data);
+extern int ttm_fence_finish_ioctl(struct ttm_object_file *tfile, void *data);
+extern int ttm_fence_unref_ioctl(struct ttm_object_file *tfile, void *data);
+
+extern int
+ttm_fence_user_create(struct ttm_fence_device *fdev,
+		      struct ttm_object_file *tfile,
+		      uint32_t fence_class,
+		      uint32_t fence_types,
+		      uint32_t create_flags,
+		      struct ttm_fence_object **fence, uint32_t * user_handle);
+
+extern struct ttm_buffer_object *ttm_buffer_object_lookup(struct ttm_object_file
+							  *tfile,
+							  uint32_t handle);
+
+extern int
+ttm_pl_verify_access(struct ttm_buffer_object *bo,
+		     struct ttm_object_file *tfile);
+
+extern int ttm_buffer_object_create(struct ttm_bo_device *bdev,
+			unsigned long size,
+			enum ttm_bo_type type,
+			uint32_t flags,
+			uint32_t page_alignment,
+			unsigned long buffer_start,
+			bool interruptible,
+			struct file *persistant_swap_storage,
+			struct ttm_buffer_object **p_bo);
+
+extern int psb_ttm_bo_check_placement(struct ttm_buffer_object *bo,
+				struct ttm_placement *placement);
+#endif

