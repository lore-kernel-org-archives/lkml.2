Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab1DASDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 14:03:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37963 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751225Ab1DASDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 14:03:46 -0400
From: Alan Cox <alan@linux.jf.intel.com>
Subject: [PATCH 1/9] gma500: Another file we don't need
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Fri, 01 Apr 2011 18:41:04 +0100
Message-ID: <20110401173745.18112.3603.stgit@localhost.localdomain>
In-Reply-To: <20110401173554.18112.67483.stgit@localhost.localdomain>
References: <20110401173554.18112.67483.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zap... bang

And take out a few more variables that are now dead

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/psb_drv.c                |   10 -
 drivers/staging/gma500/psb_drv.h                |    1 
 drivers/staging/gma500/psb_irq.c                |    2 
 drivers/staging/gma500/psb_ttm_placement_user.h |  252 -----------------------
 4 files changed, 1 insertions(+), 264 deletions(-)
 delete mode 100644 drivers/staging/gma500/psb_ttm_placement_user.h

diff --git a/drivers/staging/gma500/psb_drv.c b/drivers/staging/gma500/psb_drv.c
index ba08b07..5f72e5a 100644
--- a/drivers/staging/gma500/psb_drv.c
+++ b/drivers/staging/gma500/psb_drv.c
@@ -38,25 +38,16 @@
 int drm_psb_debug;
 static int drm_psb_trap_pagefaults;
 
-int drm_psb_disable_vsync = 1;
 int drm_psb_no_fb;
-int gfxrtdelay = 2 * 1000;
 
 static int psb_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
 
 MODULE_PARM_DESC(debug, "Enable debug output");
 MODULE_PARM_DESC(no_fb, "Disable FBdev");
 MODULE_PARM_DESC(trap_pagefaults, "Error and reset on MMU pagefaults");
-MODULE_PARM_DESC(disable_vsync, "Disable vsync interrupts");
-MODULE_PARM_DESC(force_pipeb, "Forces PIPEB to become primary fb");
-MODULE_PARM_DESC(ta_mem_size, "TA memory size in kiB");
-MODULE_PARM_DESC(ospm, "switch for ospm support");
-MODULE_PARM_DESC(rtpm, "Specifies Runtime PM delay for GFX");
-MODULE_PARM_DESC(hdmi_edid, "EDID info for HDMI monitor");
 module_param_named(debug, drm_psb_debug, int, 0600);
 module_param_named(no_fb, drm_psb_no_fb, int, 0600);
 module_param_named(trap_pagefaults, drm_psb_trap_pagefaults, int, 0600);
-module_param_named(rtpm, gfxrtdelay, int, 0600);
 
 
 static struct pci_device_id pciidlist[] = {
@@ -498,6 +489,7 @@ static int psb_do_init(struct drm_device *dev)
 	    pg->gatt_pages : PSB_TT_PRIV0_PLIMIT;
 	tt_start = dev_priv->gatt_free_offset - pg->mmu_gatt_start;
 	tt_pages -= tt_start >> PAGE_SHIFT;
+	/* FIXME: can we kill ta_mem_size ? */
 	dev_priv->sizes.ta_mem_size = 0;
 
 	PSB_WSGX32(0x00000000, PSB_CR_BIF_BANK0);
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index aad09fb..7361fbf 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -769,7 +769,6 @@ extern const struct drm_connector_funcs psb_intel_lvds_connector_funcs;
 
 extern int drm_psb_debug;
 extern int drm_psb_no_fb;
-extern int drm_psb_disable_vsync;
 extern int drm_idle_check_interval;
 
 #define PSB_DEBUG_GENERAL(_fmt, _arg...) \
diff --git a/drivers/staging/gma500/psb_irq.c b/drivers/staging/gma500/psb_irq.c
index 4597c88..9c2dbe4 100644
--- a/drivers/staging/gma500/psb_irq.c
+++ b/drivers/staging/gma500/psb_irq.c
@@ -545,7 +545,6 @@ int psb_enable_vblank(struct drm_device *dev, int pipe)
 
 	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
 
-	drm_psb_disable_vsync = 0;
 	mid_enable_pipe_event(dev_priv, pipe);
 	psb_enable_pipestat(dev_priv, pipe, PIPE_VBLANK_INTERRUPT_ENABLE);
 
@@ -567,7 +566,6 @@ void psb_disable_vblank(struct drm_device *dev, int pipe)
 
 	spin_lock_irqsave(&dev_priv->irqmask_lock, irqflags);
 
-	drm_psb_disable_vsync = 1;
 	mid_disable_pipe_event(dev_priv, pipe);
 	psb_disable_pipestat(dev_priv, pipe, PIPE_VBLANK_INTERRUPT_ENABLE);
 
diff --git a/drivers/staging/gma500/psb_ttm_placement_user.h b/drivers/staging/gma500/psb_ttm_placement_user.h
deleted file mode 100644
index 8b7068b..0000000
--- a/drivers/staging/gma500/psb_ttm_placement_user.h
+++ /dev/null
@@ -1,252 +0,0 @@
-/**************************************************************************
- *
- * Copyright 2006-2008 Tungsten Graphics, Inc., Cedar Park, TX., USA
- * All Rights Reserved.
- * Copyright (c) 2009 VMware, Inc., Palo Alto, CA., USA
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- *
- **************************************************************************/
-/*
- * Authors
- * Thomas Hellström <thomas-at-tungstengraphics-dot-com>
- */
-
-#ifndef _TTM_PLACEMENT_USER_H_
-#define _TTM_PLACEMENT_USER_H_
-
-#if !defined(__KERNEL__) && !defined(_KERNEL)
-#include <stdint.h>
-#else
-#include <linux/kernel.h>
-#endif
-
-#include "ttm/ttm_placement.h"
-
-#define TTM_PLACEMENT_MAJOR 0
-#define TTM_PLACEMENT_MINOR 1
-#define TTM_PLACEMENT_PL    0
-#define TTM_PLACEMENT_DATE  "080819"
-
-/**
- * struct ttm_pl_create_req
- *
- * @size: The buffer object size.
- * @placement: Flags that indicate initial acceptable
- *  placement.
- * @page_alignment: Required alignment in pages.
- *
- * Input to the TTM_BO_CREATE ioctl.
- */
-
-struct ttm_pl_create_req {
-	uint64_t size;
-	uint32_t placement;
-	uint32_t page_alignment;
-};
-
-/**
- * struct ttm_pl_create_ub_req
- *
- * @size: The buffer object size.
- * @user_address: User-space address of the memory area that
- * should be used to back the buffer object cast to 64-bit.
- * @placement: Flags that indicate initial acceptable
- *  placement.
- * @page_alignment: Required alignment in pages.
- *
- * Input to the TTM_BO_CREATE_UB ioctl.
- */
-
-struct ttm_pl_create_ub_req {
-	uint64_t size;
-	uint64_t user_address;
-	uint32_t placement;
-	uint32_t page_alignment;
-};
-
-/**
- * struct ttm_pl_rep
- *
- * @gpu_offset: The current offset into the memory region used.
- * This can be used directly by the GPU if there are no
- * additional GPU mapping procedures used by the driver.
- *
- * @bo_size: Actual buffer object size.
- *
- * @map_handle: Offset into the device address space.
- * Used for map, seek, read, write. This will never change
- * during the lifetime of an object.
- *
- * @placement: Flag indicating the placement status of
- * the buffer object using the TTM_PL flags above.
- *
- * @sync_object_arg: Used for user-space synchronization and
- * depends on the synchronization model used. If fences are
- * used, this is the buffer_object::fence_type_mask
- *
- * Output from the TTM_PL_CREATE and TTM_PL_REFERENCE, and
- * TTM_PL_SETSTATUS ioctls.
- */
-
-struct ttm_pl_rep {
-	uint64_t gpu_offset;
-	uint64_t bo_size;
-	uint64_t map_handle;
-	uint32_t placement;
-	uint32_t handle;
-	uint32_t sync_object_arg;
-	uint32_t pad64;
-};
-
-/**
- * struct ttm_pl_setstatus_req
- *
- * @set_placement: Placement flags to set.
- *
- * @clr_placement: Placement flags to clear.
- *
- * @handle: The object handle
- *
- * Input to the TTM_PL_SETSTATUS ioctl.
- */
-
-struct ttm_pl_setstatus_req {
-	uint32_t set_placement;
-	uint32_t clr_placement;
-	uint32_t handle;
-	uint32_t pad64;
-};
-
-/**
- * struct ttm_pl_reference_req
- *
- * @handle: The object to put a reference on.
- *
- * Input to the TTM_PL_REFERENCE and the TTM_PL_UNREFERENCE ioctls.
- */
-
-struct ttm_pl_reference_req {
-	uint32_t handle;
-	uint32_t pad64;
-};
-
-/*
- * ACCESS mode flags for SYNCCPU.
- *
- * TTM_SYNCCPU_MODE_READ will guarantee that the GPU is not
- * writing to the buffer.
- *
- * TTM_SYNCCPU_MODE_WRITE will guarantee that the GPU is not
- * accessing the buffer.
- *
- * TTM_SYNCCPU_MODE_NO_BLOCK makes sure the call does not wait
- * for GPU accesses to finish but return -EBUSY.
- *
- * TTM_SYNCCPU_MODE_TRYCACHED Try to place the buffer in cacheable
- * memory while synchronized for CPU.
- */
-
-#define TTM_PL_SYNCCPU_MODE_READ      TTM_ACCESS_READ
-#define TTM_PL_SYNCCPU_MODE_WRITE     TTM_ACCESS_WRITE
-#define TTM_PL_SYNCCPU_MODE_NO_BLOCK  (1 << 2)
-#define TTM_PL_SYNCCPU_MODE_TRYCACHED (1 << 3)
-
-/**
- * struct ttm_pl_synccpu_arg
- *
- * @handle: The object to synchronize.
- *
- * @access_mode: access mode indicated by the
- * TTM_SYNCCPU_MODE flags.
- *
- * @op: indicates whether to grab or release the
- * buffer for cpu usage.
- *
- * Input to the TTM_PL_SYNCCPU ioctl.
- */
-
-struct ttm_pl_synccpu_arg {
-	uint32_t handle;
-	uint32_t access_mode;
-	enum {
-		TTM_PL_SYNCCPU_OP_GRAB,
-		TTM_PL_SYNCCPU_OP_RELEASE
-	} op;
-	uint32_t pad64;
-};
-
-/*
- * Waiting mode flags for the TTM_BO_WAITIDLE ioctl.
- *
- * TTM_WAITIDLE_MODE_LAZY: Allow for sleeps during polling
- * wait.
- *
- * TTM_WAITIDLE_MODE_NO_BLOCK: Don't block waiting for GPU,
- * but return -EBUSY if the buffer is busy.
- */
-
-#define TTM_PL_WAITIDLE_MODE_LAZY     (1 << 0)
-#define TTM_PL_WAITIDLE_MODE_NO_BLOCK (1 << 1)
-
-/**
- * struct ttm_waitidle_arg
- *
- * @handle: The object to synchronize.
- *
- * @mode: wait mode indicated by the
- * TTM_SYNCCPU_MODE flags.
- *
- * Argument to the TTM_BO_WAITIDLE ioctl.
- */
-
-struct ttm_pl_waitidle_arg {
-	uint32_t handle;
-	uint32_t mode;
-};
-
-union ttm_pl_create_arg {
-	struct ttm_pl_create_req req;
-	struct ttm_pl_rep rep;
-};
-
-union ttm_pl_reference_arg {
-	struct ttm_pl_reference_req req;
-	struct ttm_pl_rep rep;
-};
-
-union ttm_pl_setstatus_arg {
-	struct ttm_pl_setstatus_req req;
-	struct ttm_pl_rep rep;
-};
-
-union ttm_pl_create_ub_arg {
-	struct ttm_pl_create_ub_req req;
-	struct ttm_pl_rep rep;
-};
-
-/*
- * Ioctl offsets.
- */
-
-#define TTM_PL_CREATE      0x00
-#define TTM_PL_REFERENCE   0x01
-#define TTM_PL_UNREF       0x02
-#define TTM_PL_SYNCCPU     0x03
-#define TTM_PL_WAITIDLE    0x04
-#define TTM_PL_SETSTATUS   0x05
-#define TTM_PL_CREATE_UB   0x06
-
-#endif

