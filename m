Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab2GXXnp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 19:43:45 -0400
Received: from dalsmrelay2.nai.com ([205.227.136.216]:23619 "EHLO
	dalsmrelay2.nai.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab2GXXnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 19:43:39 -0400
Date: Wed, 25 Jul 2012 09:43:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
Message-ID: <201207242343.q6ONhK6t009687@goober.corp.nai.org>
CC: <gerg@uclinux.org>, <linux-kernel@vger.kernel.org>,
        <linux-m68k@vger.kernel.org>, <uclinux-dev@uclinux.org>,
        <geert@linux-m68k.org>
Subject: [git pull] m68knommu arch fixes for 3.6
To: <torvalds@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull the m68knommu git tree, for-next branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-next

Quite a varied set of changes this time. A little more merge cleanup, this
time the assembler entry code. New sub-architecture support for the ColdFire
5251/5253 and 5441x CPU families. Specific clk support code for the ColdFire
520x and 532x CPU familes. Refactoring of the ColdFire GPIO support. PCI bus
support for some ColdFire CPUS that have PCI hardware (54xx family). This
showed up a few problems with ColdFire cache, allocating coherent memory and
bi-directional DMA support. Fixes for those too.

Thanks
Greg




The following changes since commit 84a1caf1453c3d44050bd22db958af4a7f99315c:
  Linus Torvalds (1):
        Linux 3.5-rc7

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu.git for-next

Greg Ungerer (12):
      m68k: use some direct calls to ret_from_exception in entry code
      m68k: use jbsr to call functions instead of bsrl
      m68k: merge the MMU and non-MMU versions of the entry.S code
      m68knommu: platform support for 8390 based ethernet used on some boards
      m68k: use simpler dma_alloc_coherent() for ColdFire CPUs
      m68k: fix ColdFire clear cache operation
      m68k: add support for DMA_BIDIRECTIONAL in dma support functions
      m68k: common PCI support definitions and code
      m68k: add PCI bus support definitions for the ColdFire M54xx SoC family
      m68k: add IO access definitions to support PCI on ColdFire platforms
      m68k: add PCI bus code support for the ColdFire M54xx SoC family
      m68k: allow PCI bus to be enabled for ColdFire m54xx CPUs

Steven King (9):
      m68knommu: refactor Coldfire GPIO not to require GPIOLIB, eliminate mcf_gpio_chips.
      m68knommu: Add support for the Coldfire 5251/5253
      coldfire-qspi: Add support for the Coldfire 5251/5253.
      m68knommu: use MCF_IRQ_PIT1 instead of MCFINT_VECBASE + MCFINT_PIT1
      m68knommu: Add support for the Coldfire m5441x.
      m68knommu: add definitions for the third interrupt controller on devices that don't have a third interrupt controller.
      m68knommu: Add rtc device for m5441x.
      m68knommu: Add clk definitions for m520x.
      m68knommu: Add clk definitions for m532x.

 arch/m68k/Kconfig.bus                   |    7 +
 arch/m68k/Kconfig.cpu                   |   18 ++-
 arch/m68k/Makefile                      |    2 +
 arch/m68k/include/asm/cacheflush_mm.h   |   41 +++
 arch/m68k/include/asm/dma.h             |    8 +-
 arch/m68k/include/asm/gpio.h            |  179 +------------
 arch/m68k/include/asm/io_mm.h           |   50 ++++-
 arch/m68k/include/asm/m520xsim.h        |   14 +
 arch/m68k/include/asm/m523xsim.h        |    1 +
 arch/m68k/include/asm/m525xsim.h        |  194 +++++++++++++
 arch/m68k/include/asm/m527xsim.h        |    1 +
 arch/m68k/include/asm/m528xsim.h        |    2 +-
 arch/m68k/include/asm/m532xsim.h        |   17 ++
 arch/m68k/include/asm/m5441xsim.h       |  276 +++++++++++++++++++
 arch/m68k/include/asm/m54xxacr.h        |    4 +
 arch/m68k/include/asm/m54xxpci.h        |  138 ++++++++++
 arch/m68k/include/asm/m54xxsim.h        |    3 +
 arch/m68k/include/asm/mcfclk.h          |   43 +++
 arch/m68k/include/asm/mcfgpio.h         |  343 +++++++++++++++++++-----
 arch/m68k/include/asm/mcfsim.h          |    5 +
 arch/m68k/include/asm/mcftimer.h        |    2 +-
 arch/m68k/include/asm/mcfuart.h         |    4 +-
 arch/m68k/include/asm/pci.h             |    6 +
 arch/m68k/include/asm/pinmux.h          |   30 --
 arch/m68k/kernel/Makefile               |    1 +
 arch/m68k/kernel/dma.c                  |    5 +-
 arch/m68k/kernel/entry.S                |  452 ++++++++++++++++++++++++++++++-
 arch/m68k/kernel/entry_mm.S             |  419 ----------------------------
 arch/m68k/kernel/entry_no.S             |  130 ---------
 arch/m68k/kernel/pcibios.c              |  109 ++++++++
 arch/m68k/mm/memory.c                   |    2 +-
 arch/m68k/platform/coldfire/Makefile    |    7 +-
 arch/m68k/platform/coldfire/clk.c       |  108 +++++++-
 arch/m68k/platform/coldfire/device.c    |   57 ++++-
 arch/m68k/platform/coldfire/gpio.c      |  172 ++++++++-----
 arch/m68k/platform/coldfire/head.S      |    6 +-
 arch/m68k/platform/coldfire/intc-525x.c |   91 ++++++
 arch/m68k/platform/coldfire/intc-simr.c |   26 ++-
 arch/m68k/platform/coldfire/m5206.c     |    9 -
 arch/m68k/platform/coldfire/m520x.c     |  103 +++++++-
 arch/m68k/platform/coldfire/m523x.c     |   22 --
 arch/m68k/platform/coldfire/m5249.c     |   10 -
 arch/m68k/platform/coldfire/m525x.c     |   66 +++++
 arch/m68k/platform/coldfire/m5272.c     |   11 -
 arch/m68k/platform/coldfire/m527x.c     |   43 ---
 arch/m68k/platform/coldfire/m528x.c     |   33 +---
 arch/m68k/platform/coldfire/m5307.c     |    9 -
 arch/m68k/platform/coldfire/m532x.c     |  154 +++++++++--
 arch/m68k/platform/coldfire/m5407.c     |    9 -
 arch/m68k/platform/coldfire/m5441x.c    |  261 ++++++++++++++++++
 arch/m68k/platform/coldfire/m54xx.c     |    7 -
 arch/m68k/platform/coldfire/mcf8390.c   |   38 +++
 arch/m68k/platform/coldfire/pci.c       |  327 ++++++++++++++++++++++
 arch/m68k/platform/coldfire/pinmux.c    |   28 --
 arch/m68k/platform/coldfire/pit.c       |    4 +-
 arch/m68k/platform/coldfire/timers.c    |    2 +-
 drivers/spi/Kconfig                     |    2 +-
 57 files changed, 2985 insertions(+), 1126 deletions(-)
 create mode 100644 arch/m68k/include/asm/m525xsim.h
 create mode 100644 arch/m68k/include/asm/m5441xsim.h
 create mode 100644 arch/m68k/include/asm/m54xxpci.h
 create mode 100644 arch/m68k/include/asm/mcfclk.h
 delete mode 100644 arch/m68k/include/asm/pinmux.h
 delete mode 100644 arch/m68k/kernel/entry_mm.S
 delete mode 100644 arch/m68k/kernel/entry_no.S
 create mode 100644 arch/m68k/kernel/pcibios.c
 create mode 100644 arch/m68k/platform/coldfire/intc-525x.c
 create mode 100644 arch/m68k/platform/coldfire/m525x.c
 create mode 100644 arch/m68k/platform/coldfire/m5441x.c
 create mode 100644 arch/m68k/platform/coldfire/mcf8390.c
 create mode 100644 arch/m68k/platform/coldfire/pci.c
 delete mode 100644 arch/m68k/platform/coldfire/pinmux.c
