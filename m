Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab2EVFi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 01:38:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56961 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab2EVFhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 01:37:42 -0400
From: Olof Johansson <olof@lixom.net>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 5/8] arm-soc: support for new SoCs
Date: Mon, 21 May 2012 22:35:05 -0700
Message-Id: <1337664908-17478-6-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1337664908-17478-1-git-send-email-olof@lixom.net>
References: <1337664908-17478-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Three new system-on-chip models are supported: the st-ericsson u9540
in ux500, the sam9n12 in at91 and the emma ev2 in shmobile.

Emma is a little bit special because it is completely unrelated to
the classic shmobile models, but the new Renesas rmobile SoCs are a
combination of things from both Emma and shmobile, so it was decided to
have them all live in one directory.

This also contains updates to existing shmobile soc code as well as some
related board changes due to dependencies.

----------------------------------------------------------------

The following changes since commit 0144ea8a4789f9049e993b12aad6334f1788fc74:

  Merge tag 'dt' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/soc

for you to fetch changes up to 0804dcb2afdcf014947ee98264041765f580d43f:

  Merge branch 'emev2' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/renesas into next/soc

----------------------------------------------------------------

Arnd Bergmann (3):
      Merge tag 'at91-for-next-soc' of git://github.com/at91linux/linux-at91 into next/newsoc
      Merge branch 'ux500-u9540-for-arm-soc' of git://git.kernel.org/.../linusw/linux-stericsson into next/newsoc
      Merge branch 'ux500/delete-u5500' into next/soc

Hong Xu (3):
      ARM: at91: Add machine header file for AT91SAM9N12 SoC
      ARM: at91: Add machine files for AT91SAM9N12 SoC
      ARM: at91: Add DT description files for AT91SAM9N12-EK

Kuninori Morimoto (9):
      ARM: mach-shmobile: sh7372: Add FSI DMAEngine support
      ARM: mach-shmobile: r8a7740: add gpio_irq support
      ARM: mach-shmobile: r8a7740: cleanup I2C workaround method
      ARM: mach-shmobile: clock-r8a7740: add FSI clock
      ARM: mach-shmobile: clock-r8a7740: add USB clock
      ARM: mach-shmobile: clock-r8a7740: add SDHI clock
      ARM: mach-shmobile: clock-r8a7740: add MMCIF clock
      ARM: mach-shmobile: clock-r8a7740: use followparent_recalc on usb24s
      ARM: mach-shmobile: sh73a0: fixup PINT/IRQ16-IRQ31 irq number conflict

Linus Walleij (1):
      ARM: ux500: core U9540 support

Magnus Damm (9):
      ARM / mach-shmobile: Use preset_lpj with calibrate_delay()
      gpio: Emma Mobile GPIO driver V2
      mach-shmobile: Emma Mobile EV2 SoC base support V3
      mach-shmobile: KZM9D board support V3
      mach-shmobile: Emma Mobile EV2 SMP support V3
      mach-shmobile: Emma Mobile EV2 GPIO support V3
      mach-shmobile: KZM9D board Ethernet support V3
      mach-shmobile: Emma Mobile EV2 DT support V3
      mach-shmobile: Use DT_MACHINE for KZM9D V3

Michel Jaouen (1):
      ARM: ux500: ioremap differences for DB9540

Olof Johansson (3):
      Merge branch 'soc-core' of git://git.kernel.org/.../rafael/renesas into next/soc
      Merge branch 'soc-core' of git://git.kernel.org/.../rafael/renesas into next/soc
      Merge branch 'emev2' of git://git.kernel.org/.../rafael/renesas into next/soc

Rafael J. Wysocki (1):
      Merge branch 'renesas-dt' into renesas-soc-core


 arch/arm/boot/dts/at91sam9n12.dtsi              | 221 +++++++++
 arch/arm/boot/dts/at91sam9n12ek.dts             |  84 ++++
 arch/arm/boot/dts/emev2-kzm9d.dts               |  26 ++
 arch/arm/boot/dts/emev2.dtsi                    |  63 +++
 arch/arm/mach-at91/Kconfig                      |   8 +
 arch/arm/mach-at91/Makefile                     |   1 +
 arch/arm/mach-at91/Makefile.boot                |   2 +
 arch/arm/mach-at91/at91sam9n12.c                | 233 ++++++++++
 arch/arm/mach-at91/clock.c                      |  15 +-
 arch/arm/mach-at91/include/mach/at91sam9n12.h   |  60 +++
 .../mach-at91/include/mach/at91sam9n12_matrix.h |  53 +++
 arch/arm/mach-at91/include/mach/cpu.h           |  10 +
 arch/arm/mach-at91/include/mach/hardware.h      |   1 +
 arch/arm/mach-at91/setup.c                      |   6 +
 arch/arm/mach-at91/soc.h                        |   5 +
 arch/arm/mach-shmobile/Kconfig                  |  11 +
 arch/arm/mach-shmobile/Makefile                 |   3 +
 arch/arm/mach-shmobile/board-kzm9d.c            |  85 ++++
 arch/arm/mach-shmobile/clock-emev2.c            | 249 ++++++++++
 arch/arm/mach-shmobile/clock-r8a7740.c          | 125 ++++-
 arch/arm/mach-shmobile/include/mach/emev2.h     |  19 +
 arch/arm/mach-shmobile/include/mach/sh7372.h    |   2 +
 arch/arm/mach-shmobile/include/mach/sh73a0.h    |  34 +-
 arch/arm/mach-shmobile/pfc-r8a7740.c            |  39 ++
 arch/arm/mach-shmobile/platsmp.c                |  18 +
 arch/arm/mach-shmobile/setup-emev2.c            | 452 +++++++++++++++++++
 arch/arm/mach-shmobile/setup-r8a7740.c          |  12 +-
 arch/arm/mach-shmobile/setup-sh7372.c           |  10 +
 arch/arm/mach-shmobile/smp-emev2.c              |  97 ++++
 arch/arm/mach-shmobile/timer.c                  |   3 +-
 arch/arm/mach-ux500/board-mop500-uib.c          |   2 +-
 arch/arm/mach-ux500/cache-l2x0.c                |  16 +-
 arch/arm/mach-ux500/clock.c                     |   2 +-
 arch/arm/mach-ux500/cpu-db8500.c                |  24 +-
 arch/arm/mach-ux500/cpu.c                       |   4 +-
 arch/arm/mach-ux500/id.c                        |   9 +-
 arch/arm/mach-ux500/include/mach/db8500-regs.h  |   6 +
 arch/arm/mach-ux500/include/mach/hardware.h     |   3 +
 arch/arm/mach-ux500/include/mach/id.h           |  17 +-
 arch/arm/mach-ux500/include/mach/irqs.h         |   2 +-
 arch/arm/mach-ux500/platsmp.c                   |   4 +-
 arch/arm/mach-ux500/timer.c                     |   2 +-
 drivers/cpufreq/db8500-cpufreq.c                |   2 +-
 drivers/gpio/Kconfig                            |   6 +
 drivers/gpio/Makefile                           |   1 +
 drivers/gpio/gpio-em.c                          | 418 +++++++++++++++++
 include/linux/platform_data/gpio-em.h           |  10 +
 47 files changed, 2439 insertions(+), 36 deletions(-)
 create mode 100644 arch/arm/boot/dts/at91sam9n12.dtsi
 create mode 100644 arch/arm/boot/dts/at91sam9n12ek.dts
 create mode 100644 arch/arm/boot/dts/emev2-kzm9d.dts
 create mode 100644 arch/arm/boot/dts/emev2.dtsi
 create mode 100644 arch/arm/mach-at91/at91sam9n12.c
 create mode 100644 arch/arm/mach-at91/include/mach/at91sam9n12.h
 create mode 100644 arch/arm/mach-at91/include/mach/at91sam9n12_matrix.h
 create mode 100644 arch/arm/mach-shmobile/board-kzm9d.c
 create mode 100644 arch/arm/mach-shmobile/clock-emev2.c
 create mode 100644 arch/arm/mach-shmobile/include/mach/emev2.h
 create mode 100644 arch/arm/mach-shmobile/setup-emev2.c
 create mode 100644 arch/arm/mach-shmobile/smp-emev2.c
 create mode 100644 drivers/gpio/gpio-em.c
 create mode 100644 include/linux/platform_data/gpio-em.h
