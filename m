Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339Ab2C3EPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 00:15:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52707 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786Ab2C3EPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 00:15:07 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
Date: Thu, 29 Mar 2012 21:15:06 -0700
Message-ID: <CAOesGMiGrqe6eB_pO_OxKFKprheZaRLsoQCus_CikfoPcs0H9w@mail.gmail.com>
Subject: [GIT PULL] ARM: arm-soc fixes for 3.4-rc
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,


The following changes since commit b5174fa3a7f4f8f150bfa3b917c92608953dfa0f:

  Merge tag 'mmc-merge-for-3.4-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc (2012-03-28
20:59:45 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
tags/fixes-for-linus

for you to fetch changes up to f00e9b11863abdb837e555a2b1e3417e8b5d80dd:

  Merge branch 'fixes' of git://github.com/hzhuang1/linux into fixes
(2012-03-29 20:36:18 -0700)

----------------------------------------------------------------

ARM: arm-soc fixes for 3.4-rc

This is a first pass of some of the merge window fallout for ARM platforms.

Nothing controversial:

* A system.h fallout fix for OMAP
* PXA fixes for breakage caused by the regulator struct changes
* GPIO fixes for OMAP to properly deal with dynamic IRQ allocation
* A mismerge in our arm-soc tree of an lpc32xx change for networking
* A fix for USB setup on tegra
* An undo of __init annotation of display mux setup on OMAP that's needed
  at runtime

----------------------------------------------------------------
Govindraj.R (1):
      ARM: OMAP: pm: fix compilation break

Haojian Zhuang (2):
      ARM: pxa: fix build issue on cm-x300
      ARM: pxa: fix build issue on stargate2

Olof Johansson (3):
      Merge branch 'for-3.4/fixes-for-rc1-and-v3.3' of
git://git.kernel.org/.../swarren/linux-tegra into fixes
      Merge branch 'fixes' of
git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge branch 'fixes' of git://github.com/hzhuang1/linux into fixes

Paul Gortmaker (2):
      ARM: pxa: fix regulator related build fail in magician_defconfig
      ARM: pxa: fix build failure for regulator consumer in em-x270.c

Roland Stigge (1):
      ARM: LPC32xx: clock.c: Fix lpc-eth clock reference

Stephen Warren (1):
      ARM: tegra: Fix device tree AUXDATA for USB/EHCI

Tarun Kanti DebBarma (3):
      ARM: OMAP: boards: Fix OMAP_GPIO_IRQ usage with gpio_to_irq()
      drivers: input: Fix OMAP_GPIO_IRQ with gpio_to_irq() in
ams_delta_serio_exit()
      ARM: OMAP: Remove OMAP_GPIO_IRQ macro definition

Tomi Valkeinen (1):
      ARM: OMAP2+: Remove __init from DSI mux functions

Tony Lindgren (2):
      Merge branch 'fix-dss-mux' into fixes
      Merge branch 'fixes-gpio-to-irq' into fixes

 arch/arm/mach-lpc32xx/clock.c                |    2 +-
 arch/arm/mach-omap1/board-h2.c               |    8 ++++----
 arch/arm/mach-omap1/board-h3.c               |    9 ++++-----
 arch/arm/mach-omap1/board-htcherald.c        |    6 +++---
 arch/arm/mach-omap1/board-innovator.c        |    4 ++--
 arch/arm/mach-omap1/board-nokia770.c         |    2 +-
 arch/arm/mach-omap1/board-osk.c              |   12 ++++++------
 arch/arm/mach-omap1/board-palmte.c           |    2 +-
 arch/arm/mach-omap1/board-palmtt.c           |    2 +-
 arch/arm/mach-omap1/board-palmz71.c          |    2 +-
 arch/arm/mach-omap1/board-voiceblue.c        |   16 +++++++---------
 arch/arm/mach-omap1/pm.c                     |    1 +
 arch/arm/mach-omap2/board-2430sdp.c          |    2 +-
 arch/arm/mach-omap2/board-4430sdp.c          |    2 +-
 arch/arm/mach-omap2/board-apollon.c          |    4 ++--
 arch/arm/mach-omap2/board-devkit8000.c       |    2 +-
 arch/arm/mach-omap2/board-h4.c               |    2 +-
 arch/arm/mach-omap2/board-omap3evm.c         |    2 +-
 arch/arm/mach-omap2/board-omap4panda.c       |    2 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c |    3 ++-
 arch/arm/mach-omap2/board-zoom-debugboard.c  |    3 ++-
 arch/arm/mach-omap2/board-zoom-peripherals.c |    6 ++++--
 arch/arm/mach-omap2/common-board-devices.c   |    2 +-
 arch/arm/mach-omap2/display.c                |    8 ++++----
 arch/arm/mach-omap2/pm.c                     |    2 ++
 arch/arm/mach-pxa/cm-x300.c                  |    1 -
 arch/arm/mach-pxa/em-x270.c                  |   10 +++++-----
 arch/arm/mach-pxa/hx4700.c                   |    2 --
 arch/arm/mach-pxa/magician.c                 |    2 --
 arch/arm/mach-pxa/stargate2.c                |    2 +-
 arch/arm/mach-tegra/board-dt-tegra20.c       |    6 +++---
 arch/arm/mach-tegra/devices.c                |    7 +++----
 arch/arm/mach-tegra/devices.h                |    5 +++++
 arch/arm/plat-omap/include/plat/gpio.h       |    4 ----
 drivers/input/serio/ams_delta_serio.c        |    2 +-
 35 files changed, 73 insertions(+), 74 deletions(-)
