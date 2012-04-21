Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab2DUOzF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 10:55:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43373 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab2DUOzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 10:55:03 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
Date: Sat, 21 Apr 2012 07:55:02 -0700
Message-ID: <CAOesGMhUFtoGpqMteGS95bN+aLH-39N1L8uEA8eBWsDJFrYjPQ@mail.gmail.com>
Subject: [GIT PULL] ARM: SoC fixes for 3.4-rc
From: Olof Johansson <olof@lixom.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,


The following changes since commit e816b57a337ea3b755de72bec38c10c864f23015:

  Linux 3.4-rc3 (2012-04-15 18:28:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git
tags/fixes-for-linus

for you to fetch changes up to 6842d4c2a980ce821cb20562f8df85bfcfd02012:

  Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into
fixes (2012-04-18 21:30:16 -0700)

----------------------------------------------------------------

ARM: SoC fixes for 3.4-rc

- at91, ux500, imx, omap and bcmring:
  - at91 fixes for =m driver build issues, irqdomain fixes and config
    dependency fixes
  - ux500 kconfig dependency fixes and a  smp wakeup bugfix
  - imx idle bugfix and build fix due to irq domain changes
  - omap uart pinmux fixes, softreset regression revert and misc fixes
  - bcmring build error regression fix

- ux500 and imx had some small defconfig updates in this branch

----------------------------------------------------------------
Aaro Koskinen (1):
      ARM: OMAP1: mux: add missing include

Archit Taneja (1):
      ARM: OMAP2/3: VENC hwmods: Remove OCPIF_SWSUP_IDLE flag from
VENC slave interface

Fabio Estevam (2):
      ARM: imx_v4_v5_defconfig: Add support for CONFIG_REGULATOR_FIXED_VOLTAGE
      ARM: imx27-dt: Fix build due to removal of irq_domain_add_simple()

Fernando Guzman Lugo (1):
      ARM: OMAP2+: hwmod: add softreset delay field and OMAP4 data

Govindraj.R (1):
      ARM: OMAP2+: UART: Fix incorrect population of default uart pads

Grazvydas Ignotas (1):
      ARM: OMAP: sram: fix BUG in dpll code for !PM case

Jean-Christophe PLAGNIOL-VILLARD (2):
      ARM: at91: fix rm9200ek flash size
      ARM: at91: fix at91sam9261ek Ethernet dm9000 irq

Joachim Eastwood (5):
      ARM: at91: Export at91_st_base
      ARM: at91: Export at91_ramc_base
      ARM: at91: Export at91_pmc_base
      ARM: at91: Export at91_matrix_base
      ARM: at91: remove empty at91_init_serial function

Jonas Aaberg (1):
      ARM: ux500: wake secondary cpu via resched

Lee Jones (1):
      ARM: ux500: Fix unmet direct dependency

Linus Walleij (1):
      ARM: ux500: update defconfig

Nicolas Ferre (5):
      ARM: at91: fix typo in at91_pmc_base assembly declaration
      leds-atmel-pwm.c: Make pwmled_probe() __devinit
      USB: ohci-at91: change annotations for probe/remove functions
      USB: gadget/at91_udc: add gpio_to_irq() function to vbus interrupt
      dmaengine: Kconfig: fix Atmel at_hdmac entry

Olof Johansson (4):
      Merge tag 'omap-fixes-for-v3.4-rc3' of
git://git.kernel.org/.../tmlind/linux-omap into fixes
      Merge tag 'v3.4-rc3-imx-fixes' of
git://git.pengutronix.de/git/imx/linux-2.6 into fixes
      Merge branch 'fixes-for-arm-soc-20120416' of
git://git.kernel.org/.../linusw/linux-stericsson into fixes
      Merge tag 'at91-fixes' of git://github.com/at91linux/linux-at91 into fixes

Paul Gortmaker (1):
      ARM: bcmring: fix UART declarations

Paul Walmsley (2):
      ARM: OMAP2+: hwmod: Revert "ARM: OMAP2+: hwmod: Make
omap_hwmod_softreset wait for reset status"
      ARM: OMAP1: DMTIMER: fix broken timer clock source selection

Robert Lee (1):
      ARM: imx: Fix imx5 idle logic bug

Santosh Shilimkar (1):
      ARM: OMAP: serial: Fix the ocp smart idlemode handling bug

Tony Lindgren (1):
      Merge tag 'omap-fixes-b-for-3.4rc' of
git://git.kernel.org/.../pjw/omap-pending into fixes

 arch/arm/configs/imx_v4_v5_defconfig         |    1 +
 arch/arm/configs/u8500_defconfig             |    9 +-
 arch/arm/mach-at91/at91rm9200_devices.c      |    1 -
 arch/arm/mach-at91/at91rm9200_time.c         |    2 +
 arch/arm/mach-at91/board-rm9200ek.c          |    2 +-
 arch/arm/mach-at91/board-sam9261ek.c         |    5 +-
 arch/arm/mach-at91/clock.c                   |    1 +
 arch/arm/mach-at91/include/mach/at91_pmc.h   |    2 +-
 arch/arm/mach-at91/setup.c                   |    2 +
 arch/arm/mach-bcmring/core.c                 |    4 +-
 arch/arm/mach-imx/imx27-dt.c                 |    6 +-
 arch/arm/mach-imx/mm-imx5.c                  |    2 +-
 arch/arm/mach-omap1/mux.c                    |    1 +
 arch/arm/mach-omap1/timer.c                  |    4 +-
 arch/arm/mach-omap2/omap_hwmod.c             |   17 +++-
 arch/arm/mach-omap2/omap_hwmod_2420_data.c   |    1 -
 arch/arm/mach-omap2/omap_hwmod_2430_data.c   |    1 -
 arch/arm/mach-omap2/omap_hwmod_3xxx_data.c   |    1 -
 arch/arm/mach-omap2/omap_hwmod_44xx_data.c   |    9 ++
 arch/arm/mach-omap2/serial.c                 |  124 ++------------------------
 arch/arm/mach-ux500/Kconfig                  |    1 +
 arch/arm/mach-ux500/platsmp.c                |    2 +-
 arch/arm/plat-omap/include/plat/omap_hwmod.h |    4 +-
 arch/arm/plat-omap/sram.c                    |   12 +--
 drivers/dma/Kconfig                          |    5 +-
 drivers/leds/leds-atmel-pwm.c                |    2 +-
 drivers/usb/gadget/at91_udc.c                |    8 +-
 drivers/usb/host/ohci-at91.c                 |   12 +--
 28 files changed, 80 insertions(+), 161 deletions(-)
