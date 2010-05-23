Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0EWX7x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 19:59:53 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:58480 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190Ab0EWX7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 19:59:51 -0400
Date: Mon, 24 May 2010 08:59:40 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.35-rc1, part 2.
Message-ID: <20100523235939.GB19552@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Andrea Gelmini (1):
      arch/sh/lib/strlen.S: Checkpatch cleanup

Guennadi Liakhovetski (20):
      sh: add Video Output Unit and AK8813 video encoder support on ecovec
      sh: add Video Output Unit (VOU) and AK8813 TV-encoder support to ms7724se
      sh: define DMA slaves per CPU type, remove now redundant header
      sh: add DMA slaves for two SDHI controllers to sh7722
      sh: add DMA slave definitions to sh7724
      mmc: prepare tmio_mmc for passing of DMA configuration from the MFD cell
      sh: prepare the SDHI MFD driver to pass DMA configuration to tmio_mmc.c
      mmc: add DMA support to tmio_mmc driver, when used on SuperH
      sh: Add SDHI DMA support to ecovec
      sh: Add SDHI DMA support to ms7724se
      sh: Add SDHI DMA support to kfr2r09
      sh: Add SDHI DMA support to migor
      tmio: add a platform flag to disable card write-protection detection
      mfd: pass platform flags down to the tmio_mmc driver
      sh: disable SD-card write-protection detection on kfr2r09
      mmc: let MFD's provide supported Vdd card voltages to tmio_mmc
      sh: allow platforms to specify SD-card supported voltages
      sh: fix Oops in the serial SCI driver
      sh: prevent the DMA driver from unloading, while in use
      sh: guard cookie consistency across termination in the DMA driver

Huang Weiyi (1):
      sh: remove duplicated #include

Paul Mundt (3):
      sh: fix up the dwarf unwinder build for MODULES=n.
      sh: fix up sh7786 dmaengine build.
      sh: fix up sh7785lcr_32bit_defconfig.

 arch/sh/boards/mach-ecovec24/setup.c      |   87 +++++++-
 arch/sh/boards/mach-kfr2r09/setup.c       |   11 +
 arch/sh/boards/mach-migor/setup.c         |    9 +
 arch/sh/boards/mach-se/7724/setup.c       |  107 ++++++++-
 arch/sh/configs/sh7785lcr_32bit_defconfig |  273 +++++++++++++---------
 arch/sh/include/asm/dmaengine.h           |   34 ---
 arch/sh/include/asm/siu.h                 |    2 -
 arch/sh/include/cpu-sh4/cpu/sh7722.h      |   15 ++
 arch/sh/include/cpu-sh4/cpu/sh7724.h      |   19 ++
 arch/sh/kernel/cpu/sh4a/clock-sh7786.c    |    1 -
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c    |   11 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7724.c    |   88 +++++++-
 arch/sh/kernel/cpu/sh4a/setup-sh7780.c    |    3 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7785.c    |    2 +-
 arch/sh/kernel/cpu/sh4a/setup-sh7786.c    |    2 +-
 arch/sh/kernel/dwarf.c                    |    4 +
 arch/sh/lib/strlen.S                      |    2 +-
 drivers/dma/shdma.c                       |    5 +
 drivers/mfd/Kconfig                       |    6 +
 drivers/mfd/sh_mobile_sdhi.c              |   28 ++-
 drivers/mmc/host/tmio_mmc.c               |  367 ++++++++++++++++++++++++++---
 drivers/mmc/host/tmio_mmc.h               |   13 +
 drivers/serial/sh-sci.c                   |    5 +-
 include/linux/mfd/sh_mobile_sdhi.h        |    6 +
 include/linux/mfd/tmio.h                  |   11 +
 sound/soc/sh/siu.h                        |    3 +-
 sound/soc/sh/siu_pcm.c                    |    9 +-
 27 files changed, 916 insertions(+), 207 deletions(-)
 delete mode 100644 arch/sh/include/asm/dmaengine.h
