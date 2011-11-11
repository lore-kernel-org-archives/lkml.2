Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab1KKSpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 13:45:06 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54514 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702Ab1KKSpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 13:45:04 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CAOesGMj+ppJty2_pQ=nkTQ4OT-8=O+OFL3FUq6nA-uC9tj9kCg@mail.gmail.com>
References: <CAOesGMj+ppJty2_pQ=nkTQ4OT-8=O+OFL3FUq6nA-uC9tj9kCg@mail.gmail.com>
Date: Fri, 11 Nov 2011 10:45:03 -0800
Message-ID: <CAOesGMhtEmkzRkaJfUsYtkd2zPbRKi96iqkGKeVh6Duy6m5u_g@mail.gmail.com>
Subject: Re: [GIT PULL] arm-soc fixes for 3.2-rc
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <rmk@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nico@fluxnic.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 9, 2011 at 6:05 PM, Olof Johansson <olof@lixom.net> wrote:
> Hi Linus,
>
> Arnd is offline at the moment so I'm pitching in on collecting patches
> for arm-soc.
>
> See below for a set of fixes, mostly addressing fallout from the merge
> window. Please pull.

Two more branches merged in with picoxcell and i.MX fixes, so a
refreshed request below.

Thanks!



The following changes since commit 19e0bafc36abd84a5b4d7c7745b78a6f4626e944:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux (2011-11-08
18:34:16 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git fixes

Dirk Behme (1):
      ARM: mxc: Remove test_for_ltirq

Jamie Iles (1):
      ARM: picoxcell: add extra temp register to addruart

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

Olof Johansson (7):
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
      Merge branch 'imx-fixes-for-arnd' of
git://git.pengutronix.de/git/imx/linux-2.6 into fixes
      Merge branch 'picoxcell-fixes' of
git://github.com/jamieiles/linux-2.6-ji into fixes

Richard Zhao (1):
      ARM: mx51/53: set pwm clock parent to ipg_perclk

Shawn Guo (4):
      arm/mxs: fix mmc device adding for mach-mx28evk
      arm/imx: fix the references to ARCH_MX3
      arm/imx: fix AUTO_ZRELADDR selection
      arm/imx: fix imx6q mmc error when mounting rootfs

Stephen Boyd (1):
      msm: boards: Fix fallout from removal of machine_desc in fixup

Stephen Warren (2):
      arm/tegra: Don't create duplicate gpio and pinmux devices
      arm/dt: Fix ventana SDHCI power-gpios

Yufeng Shen (1):
      arm/tegra: enable headphone detection gpio on seaboard

 arch/arm/boot/dts/tegra-ventana.dts                |    3 +-
 arch/arm/mach-at91/at91cap9_devices.c              |    7 ++--
 arch/arm/mach-at91/at91rm9200_devices.c            |    5 +--
 arch/arm/mach-at91/at91sam9260_devices.c           |    5 +--
 arch/arm/mach-at91/at91sam9261_devices.c           |    5 +--
 arch/arm/mach-at91/at91sam9263_devices.c           |    5 +--
 arch/arm/mach-at91/at91sam9g45_devices.c           |    7 ++--
 arch/arm/mach-at91/at91sam9rl_devices.c            |    7 ++--
 arch/arm/mach-at91/board-yl-9200.c                 |    2 +-
 arch/arm/mach-at91/include/mach/vmalloc.h          |    2 +
 arch/arm/mach-imx/Makefile.boot                    |   34 +++++++++++---------
 arch/arm/mach-imx/clock-imx6q.c                    |   17 +++++++++-
 arch/arm/mach-msm/Makefile                         |    2 +
 arch/arm/mach-msm/board-msm7x30.c                  |    4 +-
 arch/arm/mach-msm/board-msm8960.c                  |    4 +-
 arch/arm/mach-msm/board-msm8x60.c                  |    4 +-
 arch/arm/mach-msm/scm.c                            |    3 ++
 arch/arm/mach-mx5/clock-mx51-mx53.c                |    6 ++-
 arch/arm/mach-mxs/mach-mx28evk.c                   |    4 +-
 arch/arm/mach-picoxcell/include/mach/debug-macro.S |    2 +-
 arch/arm/mach-tegra/board-dt.c                     |   13 ++++---
 arch/arm/mach-tegra/board-harmony-pinmux.c         |    6 +++-
 arch/arm/mach-tegra/board-paz00-pinmux.c           |    6 +++-
 arch/arm/mach-tegra/board-seaboard-pinmux.c        |    6 +++-
 arch/arm/mach-tegra/board-trimslice-pinmux.c       |    5 ++-
 arch/arm/plat-mxc/Kconfig                          |    4 +-
 arch/arm/plat-mxc/avic.c                           |    1 +
 arch/arm/plat-mxc/gic.c                            |   11 +-----
 arch/arm/plat-mxc/include/mach/entry-macro.S       |    3 --
 arch/arm/plat-mxc/tzic.c                           |    1 +
 drivers/mmc/host/sdhci-esdhc-imx.c                 |    8 +++++
 drivers/spi/spi-atmel.c                            |    5 ++-
 32 files changed, 117 insertions(+), 80 deletions(-)
