Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760177Ab1D1PnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 11:43:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49591 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab1D1PnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 11:43:16 -0400
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Fernando Guzman Lugo <x0095840@ti.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Nishanth Menon <nm@ti.com>,
        lkml <linux-kernel@vger.kernel.org>,
        devel <devel@driverdev.osuosl.org>
Subject: [PATCH v4 0/6] staging tidspbridge: iommu migration
Date: Thu, 28 Apr 2011 10:31:46 -0500
Message-Id: <1304004712-8487-1-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DO-NOT-APPLY to staging yet.

Rework and rebase of the previous set of patches for iommu migration[1].

Reorganized the patches to avoid several iterations to change the same code.

Patches were tested with an OMAP3630 board, with both, basic samples and
gst-dsp; these are dependant on patch:
	"OMAP: iovmm: fix SW flags passed by user"[2].

[1] http://bit.ly/lUxbRO
[2] http://bit.ly/mgSrr8

Fernando Guzman Lugo (3):
  staging: tidspbridge: remove custom mmu code
  staging: tidspbridge: remove dmm module
  staging: tidspbridge: decouple mmu functions from regular code

Omar Ramirez Luna (3):
  staging: tidspbridge: introduce mapping search based on device
    address
  staging: tidspbridge: replace custom mmu for omap iommu framework
  staging: tidspbridge: mapping support when SG_CHAIN is not defined

 drivers/staging/tidspbridge/Kconfig                |   11 +
 drivers/staging/tidspbridge/Makefile               |    7 +-
 drivers/staging/tidspbridge/core/_deh.h            |    5 +-
 drivers/staging/tidspbridge/core/_tiomap.h         |   19 +-
 drivers/staging/tidspbridge/core/dsp_mmu.c         |  396 +++++++
 drivers/staging/tidspbridge/core/io_sm.c           |  181 +---
 drivers/staging/tidspbridge/core/tiomap3430.c      | 1087 +++-----------------
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |    6 +-
 drivers/staging/tidspbridge/core/tiomap_io.c       |   14 +-
 drivers/staging/tidspbridge/core/ue_deh.c          |  115 +--
 drivers/staging/tidspbridge/hw/EasiGlobal.h        |   41 -
 drivers/staging/tidspbridge/hw/MMUAccInt.h         |   76 --
 drivers/staging/tidspbridge/hw/MMURegAcM.h         |  225 ----
 drivers/staging/tidspbridge/hw/hw_defs.h           |   58 -
 drivers/staging/tidspbridge/hw/hw_mmu.c            |  562 ----------
 drivers/staging/tidspbridge/hw/hw_mmu.h            |  163 ---
 .../tidspbridge/include/dspbridge/cfgdefs.h        |    1 -
 .../staging/tidspbridge/include/dspbridge/dev.h    |   24 -
 .../staging/tidspbridge/include/dspbridge/dmm.h    |   75 --
 .../staging/tidspbridge/include/dspbridge/drv.h    |   13 -
 .../tidspbridge/include/dspbridge/dsp_mmu.h        |   33 +
 .../tidspbridge/include/dspbridge/dspdefs.h        |   44 -
 .../tidspbridge/include/dspbridge/dspioctl.h       |    7 -
 .../staging/tidspbridge/include/dspbridge/proc.h   |   46 -
 drivers/staging/tidspbridge/pmgr/dev.c             |   63 +--
 drivers/staging/tidspbridge/pmgr/dmm.c             |  533 ----------
 drivers/staging/tidspbridge/pmgr/dspapi.c          |   36 +-
 drivers/staging/tidspbridge/rmgr/drv.c             |   14 -
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    2 -
 drivers/staging/tidspbridge/rmgr/node.c            |   57 +-
 drivers/staging/tidspbridge/rmgr/proc.c            |  224 +---
 31 files changed, 684 insertions(+), 3454 deletions(-)
 create mode 100644 drivers/staging/tidspbridge/core/dsp_mmu.c
 delete mode 100644 drivers/staging/tidspbridge/hw/EasiGlobal.h
 delete mode 100644 drivers/staging/tidspbridge/hw/MMUAccInt.h
 delete mode 100644 drivers/staging/tidspbridge/hw/MMURegAcM.h
 delete mode 100644 drivers/staging/tidspbridge/hw/hw_defs.h
 delete mode 100644 drivers/staging/tidspbridge/hw/hw_mmu.c
 delete mode 100644 drivers/staging/tidspbridge/hw/hw_mmu.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dmm.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dsp_mmu.h
 delete mode 100644 drivers/staging/tidspbridge/pmgr/dmm.c

