Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483Ab1KJCFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 21:05:18 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38822 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab1KJCFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 21:05:16 -0500
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:1aa9:5ff:fe24:37a9]
Date: Wed, 9 Nov 2011 18:05:15 -0800
Message-ID: <CAOesGMj+ppJty2_pQ=nkTQ4OT-8=O+OFL3FUq6nA-uC9tj9kCg@mail.gmail.com>
Subject: [GIT PULL] arm-soc fixes for 3.2-rc
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <rmk@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Arnd is offline at the moment so I'm pitching in on collecting patches
for arm-soc.

See below for a set of fixes, mostly addressing fallout from the merge
window. Please pull.


Thanks!


-Olof


The following changes since commit 19e0bafc36abd84a5b4d7c7745b78a6f4626e944:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux (2011-11-08
18:34:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes

Dirk Behme (1):
      ARM: mxc: Remove test_for_ltirq

Jason Liu (2):
      ARM:i.MX: fix build error in tzic/avic.c
      ARM:i.MX: fix build error in clock-mx51-mx53.c

Jean-Christophe PLAGNIOL-VILLARD (4):
      ARM: at91: usart: drop static map regs for dbgu
      at91: vmalloc fix missing AT91_VIRT_BASE define
      at91/yl-9200: Fix section mismatch
      atmel/spi: fix missing probe

Jochen Friedrich (1):
      ARM: at91: Fix USBA gadget registration

Marc Zyngier (2):
      ARM: mxc: fix local timer interrupt handling
      ARM: msm: fix compilation flags for MSM_SCM

Olof Johansson (5):
      Merge branch 'mxs/fixes' of
git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge branch 'imx/compile-fixes' of
git://git.linaro.org/people/shawnguo/linux-2.6 into fixes
      Merge branch 'at91-fixes' of
git://github.com/at91linux/linux-at91 into fixes
      Merge branch 'for-3.2/fixes' of
git://git.kernel.org/.../olof/tegra into fixes
      Merge branch 'msm-fix' of
git://codeaurora.org/quic/kernel/davidb/linux-msm into fixes

Shawn Guo (1):
      arm/mxs: fix mmc device adding for mach-mx28evk

Stephen Boyd (1):
      msm: boards: Fix fallout from removal of machine_desc in fixup

Stephen Warren (2):
      arm/tegra: Don't create duplicate gpio and pinmux devices
      arm/dt: Fix ventana SDHCI power-gpios

Yufeng Shen (1):
      arm/tegra: enable headphone detection gpio on seaboard

 arch/arm/boot/dts/tegra-ventana.dts          |    3 +--
 arch/arm/mach-at91/at91cap9_devices.c        |    7 +++----
 arch/arm/mach-at91/at91rm9200_devices.c      |    5 ++---
 arch/arm/mach-at91/at91sam9260_devices.c     |    5 ++---
 arch/arm/mach-at91/at91sam9261_devices.c     |    5 ++---
 arch/arm/mach-at91/at91sam9263_devices.c     |    5 ++---
 arch/arm/mach-at91/at91sam9g45_devices.c     |    7 +++----
 arch/arm/mach-at91/at91sam9rl_devices.c      |    7 +++----
 arch/arm/mach-at91/board-yl-9200.c           |    2 +-
 arch/arm/mach-at91/include/mach/vmalloc.h    |    2 ++
 arch/arm/mach-msm/Makefile                   |    2 ++
 arch/arm/mach-msm/board-msm7x30.c            |    4 ++--
 arch/arm/mach-msm/board-msm8960.c            |    4 ++--
 arch/arm/mach-msm/board-msm8x60.c            |    4 ++--
 arch/arm/mach-msm/scm.c                      |    3 +++
 arch/arm/mach-mx5/clock-mx51-mx53.c          |    2 ++
 arch/arm/mach-mxs/mach-mx28evk.c             |    4 ++--
 arch/arm/mach-tegra/board-dt.c               |   13 +++++++------
 arch/arm/mach-tegra/board-harmony-pinmux.c   |    6 +++++-
 arch/arm/mach-tegra/board-paz00-pinmux.c     |    6 +++++-
 arch/arm/mach-tegra/board-seaboard-pinmux.c  |    6 +++++-
 arch/arm/mach-tegra/board-trimslice-pinmux.c |    5 ++++-
 arch/arm/plat-mxc/avic.c                     |    1 +
 arch/arm/plat-mxc/gic.c                      |   11 ++---------
 arch/arm/plat-mxc/include/mach/entry-macro.S |    3 ---
 arch/arm/plat-mxc/tzic.c                     |    1 +
 drivers/spi/spi-atmel.c                      |    5 +++--
 27 files changed, 69 insertions(+), 59 deletions(-)
