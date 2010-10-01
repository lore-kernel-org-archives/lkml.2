Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab0JAB7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 21:59:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42307 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753897Ab0JAB7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 21:59:50 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <gregkh@suse.de>
Cc: <felipe.contreras@nokia.com>, <ameya.palande@nokia.com>, <nm@ti.com>,
        <Hiroshi.DOYU@nokia.com>, <ohad@wizery.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCHv2 00/11] staging tidspbridge: iommu migration
Date: Thu, 30 Sep 2010 21:12:47 -0500
Message-Id: <1285899178-14413-1-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This set of patches remove the dspbridge custom mmu
implementation and use iommu module instead.

Version2:
- Comments from FUJITA Tomonori and previous patch
  "tidspbridge: add map support for big buffers"
  was removed and instead a patch to define
  ARCH_HAS_SG_CHAIN in arm architecture will be
  sent.
- Rebase to the latest tidspbridge.


Fernando Guzman Lugo (11):
  staging: tidspbridge: replace iommu custom for opensource
    implementation
  staging: tidspbridge - move shared memory iommu maps to tiomap3430.c
  staging: tidspbridge - rename bridge_brd_mem_map/unmap to a proper
    name
  staging: tidspbridge - remove custom mmu code from tiomap3430.c
  staging: tidspbridge - fix mmufault support
  staging: tidspbrge - remove hw directory
  staging: tidspbridge - move all iommu related code to a new file
  staging: tidspbridge: remove dw_dmmu_base from cfg_hostres struct
  staging: tidspbridge - remove reserved memory clean up
  staging: tidspbridge - deprecate reserve/unreserve_memory funtions
  staging: tidspbridge - remove dmm custom module

 drivers/staging/tidspbridge/Makefile               |    7 +-
 drivers/staging/tidspbridge/core/_deh.h            |    5 +-
 drivers/staging/tidspbridge/core/_tiomap.h         |   19 +-
 drivers/staging/tidspbridge/core/dsp-mmu.c         |  316 ++++++
 drivers/staging/tidspbridge/core/io_sm.c           |  180 +---
 drivers/staging/tidspbridge/core/tiomap3430.c      | 1070 ++------------------
 drivers/staging/tidspbridge/core/tiomap3430_pwr.c  |    4 -
 drivers/staging/tidspbridge/core/tiomap_io.c       |   17 +-
 drivers/staging/tidspbridge/core/ue_deh.c          |  115 +---
 drivers/staging/tidspbridge/hw/EasiGlobal.h        |   41 -
 drivers/staging/tidspbridge/hw/MMUAccInt.h         |   76 --
 drivers/staging/tidspbridge/hw/MMURegAcM.h         |  225 ----
 drivers/staging/tidspbridge/hw/hw_defs.h           |   58 --
 drivers/staging/tidspbridge/hw/hw_mmu.c            |  562 ----------
 drivers/staging/tidspbridge/hw/hw_mmu.h            |  163 ---
 .../tidspbridge/include/dspbridge/cfgdefs.h        |    1 -
 .../staging/tidspbridge/include/dspbridge/dev.h    |   24 -
 .../staging/tidspbridge/include/dspbridge/dmm.h    |   75 --
 .../staging/tidspbridge/include/dspbridge/drv.h    |   10 -
 .../tidspbridge/include/dspbridge/dsp-mmu.h        |   67 ++
 .../tidspbridge/include/dspbridge/dspdefs.h        |   44 -
 .../tidspbridge/include/dspbridge/dspioctl.h       |    7 -
 .../staging/tidspbridge/include/dspbridge/proc.h   |   46 -
 drivers/staging/tidspbridge/pmgr/dev.c             |   63 +--
 drivers/staging/tidspbridge/pmgr/dmm.c             |  533 ----------
 drivers/staging/tidspbridge/pmgr/dspapi.c          |   34 +-
 drivers/staging/tidspbridge/rmgr/drv.c             |   15 -
 drivers/staging/tidspbridge/rmgr/drv_interface.c   |    2 -
 drivers/staging/tidspbridge/rmgr/node.c            |   48 +-
 drivers/staging/tidspbridge/rmgr/proc.c            |  197 +----
 30 files changed, 568 insertions(+), 3456 deletions(-)
 create mode 100644 drivers/staging/tidspbridge/core/dsp-mmu.c
 delete mode 100644 drivers/staging/tidspbridge/hw/EasiGlobal.h
 delete mode 100644 drivers/staging/tidspbridge/hw/MMUAccInt.h
 delete mode 100644 drivers/staging/tidspbridge/hw/MMURegAcM.h
 delete mode 100644 drivers/staging/tidspbridge/hw/hw_defs.h
 delete mode 100644 drivers/staging/tidspbridge/hw/hw_mmu.c
 delete mode 100644 drivers/staging/tidspbridge/hw/hw_mmu.h
 delete mode 100644 drivers/staging/tidspbridge/include/dspbridge/dmm.h
 create mode 100644 drivers/staging/tidspbridge/include/dspbridge/dsp-mmu.h
 delete mode 100644 drivers/staging/tidspbridge/pmgr/dmm.c

