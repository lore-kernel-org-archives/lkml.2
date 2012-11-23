Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab2KWLM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:12:29 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56755 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab2KWLMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:12:25 -0500
From: James Hogan <james.hogan@imgtec.com>
To: David Airlie <airlied@linux.ie>
CC: <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        "James Hogan" <james.hogan@imgtec.com>
Subject: [PATCH 1/1] drm: only build ati_pcigart if PCI enabled
Date: Fri, 23 Nov 2012 11:12:10 +0000
Message-ID: <1353669130-32610-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_11_23_11_12_23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent ati_pcigart.c being built unless PCI is enabled. The exported
functions in this file are only used by drivers which depend on PCI
(namely r128 and radeon), and it tries to use PCI specific functions
(pci_unmap_page, pci_map_page, and pci_dma_mapping_error) that cause
compiler errors when PCI is disabled.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: David Airlie <airlied@linux.ie>
---
 drivers/gpu/drm/Makefile |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/Makefile b/drivers/gpu/drm/Makefile
index 2ff5cef..3e303b1b 100644
--- a/drivers/gpu/drm/Makefile
+++ b/drivers/gpu/drm/Makefile
@@ -8,7 +8,7 @@ drm-y       :=	drm_auth.o drm_buffer.o drm_bufs.o drm_cache.o \
 		drm_context.o drm_dma.o \
 		drm_drv.o drm_fops.o drm_gem.o drm_ioctl.o drm_irq.o \
 		drm_lock.o drm_memory.o drm_proc.o drm_stub.o drm_vm.o \
-		drm_agpsupport.o drm_scatter.o ati_pcigart.o drm_pci.o \
+		drm_agpsupport.o drm_scatter.o drm_pci.o \
 		drm_platform.o drm_sysfs.o drm_hashtab.o drm_mm.o \
 		drm_crtc.o drm_modes.o drm_edid.o \
 		drm_info.o drm_debugfs.o drm_encoder_slave.o \
@@ -16,6 +16,7 @@ drm-y       :=	drm_auth.o drm_buffer.o drm_bufs.o drm_cache.o \
 
 drm-$(CONFIG_COMPAT) += drm_ioc32.o
 drm-$(CONFIG_DRM_GEM_CMA_HELPER) += drm_gem_cma_helper.o
+drm-$(CONFIG_PCI) += ati_pcigart.o
 
 drm-usb-y   := drm_usb.o
 
-- 
1.7.7.6


