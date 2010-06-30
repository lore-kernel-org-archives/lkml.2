Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545Ab0F3Xu7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 19:50:59 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:34195 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757512Ab0F3Xug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 19:50:36 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <ohad@wizery.com>, <hiroshi.doyo@nokia.com>, <ameya.palande@nokia.com>,
       <felipe.contreras@nokia.com>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCHv3 0/9] dspbridge: iommu migration
Date: Wed, 30 Jun 2010 18:59:52 -0500
Message-Id: <1277942401-3566-1-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches remove the dspbridge custom mmu implementation
and use iommu module instead.


NOTE: in order to dspbridge can work properly the patch
"0001-iovmm-add-superpages-support-to-fixed-da-address.patch"
is needed (specifically iommu_kmap calls need this patch).

Fernando Guzman Lugo (9):
  dspbridge: replace iommu custom for opensource implementation
  dspbridge: move shared memory iommu maps to tiomap3430.c
  dspbridge: rename bridge_brd_mem_map/unmap to a proper name
  dspbridge: remove custom mmu code from tiomap3430.c
  dspbridge: add mmufault support
  dspbridge: remove hw directory
  dspbridge: move all iommu related code to a new file
  dspbridge: add map support for big buffers
  dspbridge: cleanup bridge_dev_context and cfg_hostres structures

 arch/arm/plat-omap/include/dspbridge/cfgdefs.h  |    1 -
 arch/arm/plat-omap/include/dspbridge/dsp-mmu.h  |   90 ++
 arch/arm/plat-omap/include/dspbridge/dspdefs.h  |   44 -
 arch/arm/plat-omap/include/dspbridge/dspdeh.h   |    1 -
 arch/arm/plat-omap/include/dspbridge/dspioctl.h |    7 -
 drivers/dsp/bridge/Makefile                     |    5 +-
 drivers/dsp/bridge/core/_deh.h                  |    3 -
 drivers/dsp/bridge/core/_tiomap.h               |   15 +-
 drivers/dsp/bridge/core/dsp-mmu.c               |  229 ++++
 drivers/dsp/bridge/core/io_sm.c                 |  185 +---
 drivers/dsp/bridge/core/mmu_fault.c             |  139 ---
 drivers/dsp/bridge/core/mmu_fault.h             |   36 -
 drivers/dsp/bridge/core/tiomap3430.c            | 1297 ++++-------------------
 drivers/dsp/bridge/core/tiomap3430_pwr.c        |  183 +---
 drivers/dsp/bridge/core/tiomap_io.c             |   16 +-
 drivers/dsp/bridge/core/ue_deh.c                |   87 +--
 drivers/dsp/bridge/hw/EasiGlobal.h              |   41 -
 drivers/dsp/bridge/hw/GlobalTypes.h             |  308 ------
 drivers/dsp/bridge/hw/MMUAccInt.h               |   76 --
 drivers/dsp/bridge/hw/MMURegAcM.h               |  226 ----
 drivers/dsp/bridge/hw/hw_defs.h                 |   60 --
 drivers/dsp/bridge/hw/hw_mmu.c                  |  587 ----------
 drivers/dsp/bridge/hw/hw_mmu.h                  |  161 ---
 drivers/dsp/bridge/pmgr/dev.c                   |    2 -
 drivers/dsp/bridge/rmgr/drv.c                   |    4 -
 drivers/dsp/bridge/rmgr/node.c                  |    4 +-
 drivers/dsp/bridge/rmgr/proc.c                  |   19 +-
 27 files changed, 599 insertions(+), 3227 deletions(-)
 create mode 100644 arch/arm/plat-omap/include/dspbridge/dsp-mmu.h
 create mode 100644 drivers/dsp/bridge/core/dsp-mmu.c
 delete mode 100644 drivers/dsp/bridge/core/mmu_fault.c
 delete mode 100644 drivers/dsp/bridge/core/mmu_fault.h
 delete mode 100644 drivers/dsp/bridge/hw/EasiGlobal.h
 delete mode 100644 drivers/dsp/bridge/hw/GlobalTypes.h
 delete mode 100644 drivers/dsp/bridge/hw/MMUAccInt.h
 delete mode 100644 drivers/dsp/bridge/hw/MMURegAcM.h
 delete mode 100644 drivers/dsp/bridge/hw/hw_defs.h
 delete mode 100644 drivers/dsp/bridge/hw/hw_mmu.c
 delete mode 100644 drivers/dsp/bridge/hw/hw_mmu.h

