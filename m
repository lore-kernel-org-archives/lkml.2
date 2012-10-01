Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab2JAX5w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:57:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55016 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758810Ab2JAX5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:57:41 -0400
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [GIT PULL 6/12] ARM: soc: cleanups, part 2
Date: Mon,  1 Oct 2012 16:57:01 -0700
Message-Id: <1349135827-24790-7-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
In-Reply-To: <1349135827-24790-1-git-send-email-olof@lixom.net>
References: <1349135827-24790-1-git-send-email-olof@lixom.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A shorter cleanup branch submitted separately due to dependencies with
some of the previous topics.

Major thing here is that the Broadcom bcmring platform is removed. It's an
SoC that's used on some stationary VoIP platforms, and is in desperate
need of some cleanup. Broadcom came back and suggested that we just
deprecate the platform for now, since they aren't going to spend the
resources needed on cleaning it up, and there are no users of the platform
directly from mainline.

Conflicts:
* A few removed files in tegra, safe to remove here.
* bcmring/bcm2835 conflicts in Kconfig and Makefile, remove bcmring.

----------------------------------------------------------------

The following changes since commit 7e95c548818d2b311090848083277fb907cfb56d:

  Merge branch 'next/dt' into HEAD

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup2

for you to fetch changes up to b98138e00d96abc85b100c9b6886f105d9868ab5:

  Merge branch 'cleanup/__iomem' into next/cleanup2

----------------------------------------------------------------

Alexander Shiyan (4):
      ARM: clps711x: Added simple clock framework
      ARM: clps711x: Fix lowlevel debug-macro
      ARM: clps711x: Fix register definitions
      ARM: clps711x: Remove board support for CEIVA

Andrew Lunn (1):
      ARM: Orion5x: ts78xx: Add IOMEM for virtual addresses.

Arnd Bergmann (6):
      Merge branch 'clps711x/cleanup' into next/cleanup2
      ARM: Remove mach-bcmring
      Merge branch 'bcmring/cleanup' into bcmring/removal
      Merge branch 'bcmring/removal' into next/cleanup2
      ARM: ux500: use __iomem pointers for MMIO
      Merge branch 'cleanup/__iomem' into next/cleanup2

Olof Johansson (2):
      Merge tag 'xceiv-for-v3.7' of git://git.kernel.org/.../balbi/usb into next/cleanup2
      Merge tag 'tegra-for-3.7-cleanup2' of git://git.kernel.org/.../swarren/linux-tegra into next/cleanup2

Stephen Warren (7):
      Merge branch 'for-3.7/board-removal' into for-3.7/cleanup2
      Merge branch 'for-3.7/common-clk' into for-3.7/cleanup2
      Merge commit 'xceiv-for-v3.7' into for-3.7/cleanup2
      ARM: tegra: remove dead code
      ARM: tegra: remove useless includes of <mach/*.h>
      ARM: tegra: delete unused headers
      pinctrl: tegra: move pinconf-tegra.h content into drivers/pinctrl


 MAINTAINERS                                     |   16 -
 arch/arm/Kconfig                                |   16 +-
 arch/arm/Makefile                               |    1 -
 arch/arm/configs/bcmring_defconfig              |   79 -
 arch/arm/mach-bcmring/Kconfig                   |   19 -
 arch/arm/mach-bcmring/Makefile                  |    8 -
 arch/arm/mach-bcmring/Makefile.boot             |    6 -
 arch/arm/mach-bcmring/arch.c                    |  198 ---
 arch/arm/mach-bcmring/clock.c                   |  223 ---
 arch/arm/mach-bcmring/clock.h                   |   33 -
 arch/arm/mach-bcmring/core.c                    |  227 ---
 arch/arm/mach-bcmring/core.h                    |   31 -
 arch/arm/mach-bcmring/csp/Makefile              |    3 -
 arch/arm/mach-bcmring/csp/chipc/Makefile        |    1 -
 arch/arm/mach-bcmring/csp/chipc/chipcHw.c       |  779 --------
 arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c  |  283 ---
 arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c |  125 --
 arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c   |   64 -
 arch/arm/mach-bcmring/csp/dmac/Makefile         |    1 -
 arch/arm/mach-bcmring/csp/dmac/dmacHw.c         |  916 ----------
 arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c   | 1017 -----------
 arch/arm/mach-bcmring/csp/tmr/Makefile          |    1 -
 arch/arm/mach-bcmring/csp/tmr/tmrHw.c           |  576 ------
 arch/arm/mach-bcmring/dma.c                     | 1518 ----------------
 arch/arm/mach-bcmring/dma_device.c              |  593 ------
 arch/arm/mach-bcmring/include/mach/cfg_global.h |   51 -
 arch/arm/mach-bcmring/include/mach/csp/cap.h    |   63 -
 .../mach-bcmring/include/mach/csp/cap_inline.h  |  409 -----
 .../mach-bcmring/include/mach/csp/chipcHw_def.h | 1123 ------------
 .../include/mach/csp/chipcHw_inline.h           | 1682 ------------------
 .../mach-bcmring/include/mach/csp/chipcHw_reg.h |  530 ------
 .../arm/mach-bcmring/include/mach/csp/ddrcReg.h |  872 ---------
 arch/arm/mach-bcmring/include/mach/csp/dmacHw.h |  596 -------
 .../mach-bcmring/include/mach/csp/dmacHw_priv.h |  145 --
 .../mach-bcmring/include/mach/csp/dmacHw_reg.h  |  406 -----
 arch/arm/mach-bcmring/include/mach/csp/hw_cfg.h |   73 -
 .../mach-bcmring/include/mach/csp/intcHw_reg.h  |  246 ---
 .../arm/mach-bcmring/include/mach/csp/mm_addr.h |  101 --
 arch/arm/mach-bcmring/include/mach/csp/mm_io.h  |  147 --
 arch/arm/mach-bcmring/include/mach/csp/reg.h    |  115 --
 .../mach-bcmring/include/mach/csp/secHw_def.h   |  100 --
 .../include/mach/csp/secHw_inline.h             |   79 -
 arch/arm/mach-bcmring/include/mach/csp/tmrHw.h  |  263 ---
 .../mach-bcmring/include/mach/csp/tmrHw_reg.h   |   82 -
 arch/arm/mach-bcmring/include/mach/dma.h        |  630 -------
 .../arm/mach-bcmring/include/mach/entry-macro.S |   76 -
 arch/arm/mach-bcmring/include/mach/hardware.h   |   57 -
 arch/arm/mach-bcmring/include/mach/irqs.h       |  132 --
 .../mach-bcmring/include/mach/memory_settings.h |   67 -
 arch/arm/mach-bcmring/include/mach/reg_nand.h   |   66 -
 arch/arm/mach-bcmring/include/mach/reg_umi.h    |  237 ---
 arch/arm/mach-bcmring/include/mach/timer.h      |   77 -
 arch/arm/mach-bcmring/include/mach/timex.h      |   25 -
 arch/arm/mach-bcmring/include/mach/uncompress.h |   43 -
 arch/arm/mach-bcmring/irq.c                     |  126 --
 arch/arm/mach-bcmring/mm.c                      |   60 -
 arch/arm/mach-bcmring/timer.c                   |   61 -
 arch/arm/mach-clps711x/Kconfig                  |    6 -
 arch/arm/mach-clps711x/Makefile                 |    1 -
 arch/arm/mach-clps711x/ceiva.c                  |   64 -
 arch/arm/mach-clps711x/common.c                 |   89 +-
 arch/arm/mach-clps711x/include/mach/clps711x.h  |    9 +-
 .../mach-clps711x/include/mach/debug-macro.S    |    8 +-
 arch/arm/mach-clps711x/include/mach/hardware.h  |   48 -
 arch/arm/mach-clps711x/include/mach/timex.h     |   23 +-
 arch/arm/mach-orion5x/ts78xx-setup.c            |   12 +-
 arch/arm/mach-tegra/Makefile                    |    2 -
 arch/arm/mach-tegra/board-dt-tegra20.c          |   27 +-
 arch/arm/mach-tegra/board-pinmux.c              |   87 -
 arch/arm/mach-tegra/board-pinmux.h              |   54 -
 arch/arm/mach-tegra/devices.c                   |  701 --------
 arch/arm/mach-tegra/devices.h                   |   60 -
 arch/arm/mach-tegra/include/mach/gpio-tegra.h   |   28 -
 .../arm/mach-tegra/include/mach/pinconf-tegra.h |   63 -
 arch/arm/mach-tegra/include/mach/suspend.h      |   38 -
 arch/arm/mach-tegra/tegra20_clocks.c            |    1 -
 arch/arm/mach-tegra/tegra20_clocks_data.c       |    1 -
 arch/arm/mach-tegra/timer.c                     |    1 -
 arch/arm/mach-ux500/include/mach/uncompress.h   |    4 +-
 arch/arm/tools/mach-types                       |    1 -
 drivers/pinctrl/pinctrl-tegra.c                 |    2 -
 drivers/pinctrl/pinctrl-tegra.h                 |   44 +
 drivers/usb/phy/tegra_usb_phy.c                 |    1 -
 drivers/video/Kconfig                           |   12 -
 drivers/video/Makefile                          |    1 -
 drivers/video/epson1355fb.c                     |  749 --------
 include/video/epson1355.h                       |   64 -
 87 files changed, 159 insertions(+), 17516 deletions(-)
 delete mode 100644 arch/arm/configs/bcmring_defconfig
 delete mode 100644 arch/arm/mach-bcmring/Kconfig
 delete mode 100644 arch/arm/mach-bcmring/Makefile
 delete mode 100644 arch/arm/mach-bcmring/Makefile.boot
 delete mode 100644 arch/arm/mach-bcmring/arch.c
 delete mode 100644 arch/arm/mach-bcmring/clock.c
 delete mode 100644 arch/arm/mach-bcmring/clock.h
 delete mode 100644 arch/arm/mach-bcmring/core.c
 delete mode 100644 arch/arm/mach-bcmring/core.h
 delete mode 100644 arch/arm/mach-bcmring/csp/Makefile
 delete mode 100644 arch/arm/mach-bcmring/csp/chipc/Makefile
 delete mode 100644 arch/arm/mach-bcmring/csp/chipc/chipcHw.c
 delete mode 100644 arch/arm/mach-bcmring/csp/chipc/chipcHw_init.c
 delete mode 100644 arch/arm/mach-bcmring/csp/chipc/chipcHw_reset.c
 delete mode 100644 arch/arm/mach-bcmring/csp/chipc/chipcHw_str.c
 delete mode 100644 arch/arm/mach-bcmring/csp/dmac/Makefile
 delete mode 100644 arch/arm/mach-bcmring/csp/dmac/dmacHw.c
 delete mode 100644 arch/arm/mach-bcmring/csp/dmac/dmacHw_extra.c
 delete mode 100644 arch/arm/mach-bcmring/csp/tmr/Makefile
 delete mode 100644 arch/arm/mach-bcmring/csp/tmr/tmrHw.c
 delete mode 100644 arch/arm/mach-bcmring/dma.c
 delete mode 100644 arch/arm/mach-bcmring/dma_device.c
 delete mode 100644 arch/arm/mach-bcmring/include/mach/cfg_global.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/cap.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/cap_inline.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/chipcHw_def.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/chipcHw_inline.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/chipcHw_reg.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/ddrcReg.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/dmacHw.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/dmacHw_priv.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/dmacHw_reg.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/hw_cfg.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/intcHw_reg.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/mm_addr.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/mm_io.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/reg.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/secHw_def.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/secHw_inline.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/tmrHw.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/csp/tmrHw_reg.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/dma.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/entry-macro.S
 delete mode 100644 arch/arm/mach-bcmring/include/mach/hardware.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/irqs.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/memory_settings.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/reg_nand.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/reg_umi.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/timer.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/timex.h
 delete mode 100644 arch/arm/mach-bcmring/include/mach/uncompress.h
 delete mode 100644 arch/arm/mach-bcmring/irq.c
 delete mode 100644 arch/arm/mach-bcmring/mm.c
 delete mode 100644 arch/arm/mach-bcmring/timer.c
 delete mode 100644 arch/arm/mach-clps711x/ceiva.c
 delete mode 100644 arch/arm/mach-tegra/board-pinmux.c
 delete mode 100644 arch/arm/mach-tegra/board-pinmux.h
 delete mode 100644 arch/arm/mach-tegra/devices.c
 delete mode 100644 arch/arm/mach-tegra/devices.h
 delete mode 100644 arch/arm/mach-tegra/include/mach/gpio-tegra.h
 delete mode 100644 arch/arm/mach-tegra/include/mach/pinconf-tegra.h
 delete mode 100644 arch/arm/mach-tegra/include/mach/suspend.h
 delete mode 100644 drivers/video/epson1355fb.c
 delete mode 100644 include/video/epson1355.h
