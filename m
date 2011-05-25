Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab1EYPhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 11:37:45 -0400
Received: from linux-sh.org ([111.68.239.195]:48797 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758111Ab1EYPho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 11:37:44 -0400
Date: Thu, 26 May 2011 00:37:09 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] rmobile updates for 2.6.40-rc1
Message-ID: <20110525153708.GA20089@linux-sh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git rmobile-latest

Which contains:

Damian Hobson-Garcia (1):
      sh_mobile: Add MSTP clock for MERAM

Guennadi Liakhovetski (5):
      ARM: mach-shmobile: MMCIF on mackerel can also be a module
      ARM: mach-shmobile: add DMA for MMCIF on mackerel
      ARM: mach-shmobile: PLL does not have to run constantly for HDMI
      ARM: switch mackerel to dynamically manage the platform camera
      ARM: mach-shmobile: mark DMA slave ID 0 as invalid

Kuninori Morimoto (3):
      ARM: mach-shmobile: clock-sh7372: remove status check from fsidiv_recalc
      ARM: arch-shmobile: sh7372: add renesas_usbhs irq support
      ARM: mach-shmobile: mackerel: add renesas_usbhs support for USB1

Magnus Damm (20):
      ARM: mach-shmobile: Use SCIFA and SCIFB port types on sh7377
      ARM: mach-shmobile: sh7367 UIO platform data V3
      ARM: mach-shmobile: sh7372 UIO platform data V3
      ARM: mach-shmobile: sh7377 UIO platform data V3
      ARM: mach-shmobile: Disable sh7372 RT side MSTP bits
      ARM: mach-shmobile: headsmp.S build fix
      ARM: mach-shmobile: sh73a0 twd_base fix
      ARM: mach-shmobile: AG5EVM DSI resource string update
      ARM: mach-shmobile: Add SDHI support for AG5EVM and sh73a0
      ARM: mach-shmobile: Suspend-to-RAM support
      ARM: mach-shmobile: sh7372 Core Standby Suspend-to-RAM
      ARM: mach-shmobile: CPUIdle support
      ARM: mach-shmobile: sh7372 Core Standby CPUIdle
      dmaengine: shdma: Make second memory window optional
      dmaengine: shdma: Fix SH_DMAC_MAX_CHANNELS handling
      dmaengine: shdma: Update SH_DMAC_MAX_CHANNELS to 20
      ARM: mach-shmobile: sh73a0 DMA Engine support for SY-DMAC
      ARM: mach-shmobile: Enable DMAEngine for MMCIF on AG5EVM
      ARM: mach-shmobile: Enable DMAEngine for SDHI on AG5EVM
      ARM: mach-shmobile: sh73a0: mark DMA slave ID 0 as invalid

Paul Mundt (3):
      mailmap: Add entry for Damian Hobson-Garcia.
      ARM: mach-shmobile: Tidy up after SH7372 pm changes.
      ARM: mach-shmobile: Correct the G4EVM SDHI0 I/O range.

Simon Horman (2):
      ARM: mach-shmobile: ap4evb, mackerel: fixup scif initialisation for zboot
      ARM: arch-shmobile: Use multiple irq vectors for SDHI

 .mailmap                                           |    1 +
 arch/arm/mach-shmobile/Makefile                    |    5 +
 arch/arm/mach-shmobile/board-ag5evm.c              |  118 +++++++++
 arch/arm/mach-shmobile/board-ap4evb.c              |   30 ++-
 arch/arm/mach-shmobile/board-g4evm.c               |    2 +-
 arch/arm/mach-shmobile/board-mackerel.c            |  272 +++++++++++++++++---
 arch/arm/mach-shmobile/clock-sh7372.c              |   21 ++-
 arch/arm/mach-shmobile/clock-sh73a0.c              |   19 ++-
 arch/arm/mach-shmobile/cpuidle.c                   |   92 +++++++
 arch/arm/mach-shmobile/headsmp.S                   |    2 +-
 arch/arm/mach-shmobile/include/mach/common.h       |    7 +
 .../arm/mach-shmobile/include/mach/head-ap4evb.txt |    3 +-
 .../mach-shmobile/include/mach/head-mackerel.txt   |    3 +-
 arch/arm/mach-shmobile/include/mach/sh7372.h       |    1 +
 arch/arm/mach-shmobile/include/mach/sh73a0.h       |   30 +++
 arch/arm/mach-shmobile/intc-sh7372.c               |   46 ++--
 arch/arm/mach-shmobile/pm-sh7372.c                 |  108 ++++++++
 arch/arm/mach-shmobile/setup-sh7367.c              |  223 ++++++++++++++++
 arch/arm/mach-shmobile/setup-sh7372.c              |  217 ++++++++++++++++
 arch/arm/mach-shmobile/setup-sh7377.c              |  239 +++++++++++++++++-
 arch/arm/mach-shmobile/setup-sh73a0.c              |  244 ++++++++++++++++++
 arch/arm/mach-shmobile/sleep-sh7372.S              |  260 +++++++++++++++++++
 arch/arm/mach-shmobile/smp-sh73a0.c                |    9 +-
 arch/arm/mach-shmobile/suspend.c                   |   47 ++++
 drivers/dma/shdma.c                                |   42 +++-
 drivers/dma/shdma.h                                |    2 +-
 26 files changed, 1942 insertions(+), 101 deletions(-)
 create mode 100644 arch/arm/mach-shmobile/cpuidle.c
 create mode 100644 arch/arm/mach-shmobile/pm-sh7372.c
 create mode 100644 arch/arm/mach-shmobile/sleep-sh7372.S
 create mode 100644 arch/arm/mach-shmobile/suspend.c
