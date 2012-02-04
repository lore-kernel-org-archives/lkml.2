Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab2BDUF0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 15:05:26 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34884 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390Ab2BDUFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 15:05:25 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
Date: Sat, 4 Feb 2012 12:05:24 -0800
Message-ID: <CAOesGMjUL6fg9ReSSVb6Ofy6PWzbLo-bxC7Ut0_x1Sv+4bNkog@mail.gmail.com>
Subject: [GIT PULL] arm-soc fixes for 3.3-rc
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>, arm@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,


The following changes since commit deb9b4ce97cbbf61a150f317badbeb7531aab276:

  Merge branch 'fixes' of git://git.linaro.org/people/rmk/linux-arm
(2012-01-28 13:27:10 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes-for-linus

for you to fetch changes up to ca43784daa7a400407d851799ac69d3de2b2ab4e:

  ARM: bcmring: fix build failure in mach-bcmring/arch.c (2012-02-04
11:38:20 -0800)

----------------------------------------------------------------
arm-soc fixes for 3.3-rc

* A series of OMAP regression fixes for merge window fallout
* Two patches for Davinci, one removes some misdefined clocks, the other
  is a regression fix for merge window fallout
* Two patches that makes Broadcom bcmring build again (and removes a
  bunch of unused code in the process)

----------------------------------------------------------------
Bas van den Berg (1):
      ARM: davinci: DA850: remove non-existing pll1_sysclk4-7 clocks

Cousson, Benoit (1):
      i2c: OMAP: Fix OMAP1 build error

Felipe Contreras (2):
      ARM: OMAP2: fix omap3 touchbook kconfig warning
      ARM: OMAP2: fix regulator warnings

Grazvydas Ignotas (2):
      ARM: OMAP: fix erroneous mmc2 clock change on mmc3 setup
      ARM: OMAP: fix MMC2 loopback clock handling

Ilya Yanok (1):
      ARM: OMAP3: hwmod data: register dss hwmods after dss_core

JD Zheng (1):
      ARM: bcmring: remove unused DMA map code

Julia Lawall (2):
      ARM: OMAP2+: arch/arm/mach-omap2/devices.c: introduce missing kfree
      ARM: OMAP2+: arch/arm/mach-omap2/smartreflex.c: add missing iounmap

Olof Johansson (2):
      Merge branch 'fixes' of
git://gitorious.org/linux-davinci/linux-davinci into fixes
      Merge branch 'fixes' of
git://git.kernel.org/.../tmlind/linux-omap into fixes

Paul Gortmaker (1):
      ARM: bcmring: fix build failure in mach-bcmring/arch.c

Paul Walmsley (2):
      ARM: OMAP2+: io: fix compilation breakage on 2420-only configs
      ARM: OMAP2/3: PRM: fix missing plat/irqs.h build breakage

Peter Ujfalusi (1):
      ARM: OMAP4: hwmod data: Add names for DMIC memory address space

Sekhar Nori (1):
      ARM: davinci: update mdio bus name

Tomi Valkeinen (2):
      ARM: OMAP2+: hwmod data: split omap2/3 dispc hwmod class
      ARM: OMAP3: hwmod data: add SYSC_HAS_ENAWAKEUP for dispc

Tony Lindgren (1):
      Merge branch 'omap_fixes_a_3.3rc' of
git://git.pwsan.com/linux-2.6 into fixes

Vaibhav Hiremath (1):
      ARM: OMAP2+: timer: Fix crash due to wrong arg to
__omap_dm_timer_read_counter

Yegor Yefremov (1):
      ARM: OMAP2+: GPMC: fix device size setup

 arch/arm/mach-bcmring/arch.c                       |    2 +-
 arch/arm/mach-bcmring/dma.c                        |  812 --------------------
 arch/arm/mach-bcmring/include/mach/dma.h           |  196 -----
 arch/arm/mach-davinci/board-da850-evm.c            |    2 +-
 arch/arm/mach-davinci/board-dm365-evm.c            |    2 +-
 arch/arm/mach-davinci/board-dm644x-evm.c           |    2 +-
 arch/arm/mach-davinci/board-dm646x-evm.c           |    2 +-
 arch/arm/mach-davinci/board-neuros-osd2.c          |    2 +-
 arch/arm/mach-davinci/board-omapl138-hawk.c        |    2 +-
 arch/arm/mach-davinci/board-sffsdr.c               |    2 +-
 arch/arm/mach-davinci/da850.c                      |   32 -
 arch/arm/mach-omap2/Kconfig                        |   11 +-
 arch/arm/mach-omap2/devices.c                      |    1 +
 arch/arm/mach-omap2/gpmc.c                         |    6 +
 arch/arm/mach-omap2/hsmmc.c                        |   16 +-
 arch/arm/mach-omap2/io.c                           |    4 +-
 .../mach-omap2/omap_hwmod_2xxx_3xxx_ipblock_data.c |   21 -
 arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c |   22 +
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c         |   54 ++-
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c         |    2 +
 arch/arm/mach-omap2/prm2xxx_3xxx.c                 |    1 +
 arch/arm/mach-omap2/smartreflex.c                  |    2 +-
 arch/arm/mach-omap2/timer.c                        |    2 +-
 drivers/i2c/busses/i2c-omap.c                      |    2 +-
 24 files changed, 106 insertions(+), 1094 deletions(-)
