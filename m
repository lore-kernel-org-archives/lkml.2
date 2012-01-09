Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab2AIWOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:14:03 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:60437 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512Ab2AIWN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:13:57 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL 09/11] power management changes for omap and imx
Date: Mon,  9 Jan 2012 22:12:49 +0000
Message-Id: <1326147171-13752-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1326147171-13752-1-git-send-email-arnd@arndb.de>
References: <1326147171-13752-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:I3E8pq0KFu0L/Onuec+QN/PkZeC17RPwDKIBDCdpCe9
 SX/1hQ3iY6p2F+ntOom91h068h4+UDQka2YSsTFIN5rW3S0jiU
 zqg78OktHAg5GF6PgTgaLG8KE7SQylY5GpfpwiBu23OX4oCVhe
 Sb34f9I+fTrJuqvhbqNFM2TqwOFNRQkv0Q4TTXni/hwciB9hFG
 YsXO7Fr1ZPzM/7C3Du//ls+6h/07myTbKzmGsrxCh2FOXUmMX/
 pBpiymGmyWrsfk3PUBqCSSsDe6+TBs4emJ16F5pGyLi9iqSAWl
 ANm5vTN2RmavhJX87TAZaKoCqzXJKH4Pv79yr5TIpmTwWYWgnk
 LL+6fSLc02Ho+7ruPodkVlw0LLUuGspRVSLoAi8ItwCJIG+QbB
 RdCPGLkPni2ng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A significant part of the changes for these two platforms went into
power management, so they are split out into a separate branch.

The following changes since commit b1258a936802a0e49ab1832aa62b87b09443a086:

  Merge branch 'next/drivers' into for-next3 (2012-01-09 17:08:21 +0000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git next/pm

Arnd Bergmann (3):
      Merge branch 'imx/pm' of git://git.linaro.org/people/shawnguo/linux-2.6 into imx6/pm
      Merge branch 'v3.2-rc7' into next/pm
      Merge branch 'imx6/pm' into next/pm

Deepak K (1):
      ARM: OMAP2+: UART: Allow UART parameters to be configured from board file.

Eric Miao (2):
      ARM: imx6q: build pm code only when CONFIG_PM selected
      ARM: imx6q: resume PL310 only when CACHE_L2X0 defined

Govindraj R (1):
      ARM: OMAP2+: hwmod: Add API to enable IO ring wakeup

Govindraj.R (19):
      ARM: OMAP2+: UART: cleanup + remove uart pm specific API
      ARM: OMAP2+: UART: cleanup 8250 console driver support
      ARM: OMAP2+: UART: Cleanup part of clock gating mechanism for uart
      ARM: OMAP2+: UART: Add default mux for all uarts.
      ARM: OMAP2+: UART: Remove mapbase/membase fields from pdata.
      ARM: OMAP2+: UART: Add runtime pm support for omap-serial driver
      ARM: OMAP2+: UART: Remove context_save and move context restore to driver
      ARM: OMAP2+: UART: Ensure all reg values configured are available from port structure
      ARM: OMAP2+: UART: Remove uart reset function.
      ARM: OMAP2+: UART: Get context loss count to context restore
      ARM: OMAP2+: UART: Move errata handling from serial.c to omap-serial
      ARM: OMAP2+: UART: Add wakeup mechanism for omap-uarts
      ARM: OMAP2+: UART: Remove old and unused clocks handling funcs
      ARM: OMAP2+: UART: remove temporary variable used to count uart instance
      ARM: OMAP2+: UART: Avoid console uart idling during bootup
      ARM: OMAP2+: UART: Avoid uart idling on suspend for no_console_suspend usecase
      ARM: OMAP2+: UART: Do not gate uart clocks if used for debug_prints
      ARM: OMAP2+: UART: Remove omap_uart_can_sleep and add pm_qos
      ARM: OMAP2+: UART: Fix compilation/sparse warnings

Hui Wang (1):
      ARM: mx5: use generic irq chip pm interface for pm functions on

Jon Hunter (1):
      ARM: OMAP2+: UART: Make the RX_TIMEOUT for DMA configurable for each UART

Olof Johansson (8):
      Merge branch 'omap4' of git://git.kernel.org/.../tmlind/linux-omap into omap/omap4
      Merge branch 'omap/omap4' into next/pm
      Merge branch 'prcm' of git://git.kernel.org/.../tmlind/linux-omap into omap/prcm
      Merge branch 'omap/prcm' into next/pm
      Merge branch 'uart' of git://git.kernel.org/.../tmlind/linux-omap into omap/uart
      Merge branch 'omap/uart' into next/pm
      Merge branch 'imx/pm2' of git://git.linaro.org/people/shawnguo/linux-2.6 into imx6/pm
      Merge branch 'imx6/pm' into next/pm

Paul Walmsley (2):
      ARM: OMAP2+: mux: add wakeup-capable hwmod mux entries to dynamic list
      ARM: OMAP3/4: PRM: add functions to read pending IRQs, PRM barrier

Rajendra Nayak (5):
      ARM: OMAP2+: hwmod: Add a new flag to handle hwmods left enabled at init
      omap-serial: Get rid of all pdev->id usage
      omap-serial: Use default clock speed (48Mhz) if not specified
      omap-serial: Add minimal device tree support
      ARM: omap: pass minimal SoC/board data for UART from dt

Santosh Shilimkar (24):
      ARM: OMAP4: Use WARN_ON() instead of BUG_ON() with graceful exit
      ARM: OMAP4: Export omap4_get_base*() rather than global address pointers
      ARM: OMAP4: PM: Add SAR RAM support
      ARM: OMAP4: PM: Keep static dep between MPUSS-EMIF and MPUSS-L3/L4 and DUCATI-L3
      ARM: OMAP4: PM: Avoid omap4_pm_init() on OMAP4430 ES1.0
      ARM: OMAP4: PM: Initialise all the clockdomains to supported states
      ARM: OMAP: Add Secure HAL and monitor mode API infrastructure.
      ARM: OMAP: PM: Add support to allocate the memory for secure RAM
      ARM: OMAP4: PM: Add WakeupGen module as OMAP gic_arch_extn
      ARM: OMAP4: PM: Add CPUX OFF mode support
      ARM: OMAP4: Remove __INIT from omap_secondary_startup() to re-use it for hotplug.
      ARM: OMAP4: PM: Program CPU1 to hit OFF when off-lined
      ARM: OMAP4: PM: CPU1 wakeup workaround from Low power modes
      ARM: OMAP4: PM: Use custom omap_do_wfi() for default idle.
      ARM: OMAP4: suspend: Add MPUSS power domain RETENTION support
      ARM: OMAP4: Remove un-used do_wfi() macro.
      ARM: OMAP4: PM: Add WakeupGen and secure GIC low power support
      ARM: OMAP4: PM: Add L2X0 cache lowpower support
      ARM: OMAP4: PM: Add MPUSS power domain OSWR support
      ARM: OMAP4: PM: Add power domain statistics support
      ARM: OMAP4: Fix errata i688 with MPU interconnect barriers.
      ARM: OMAP4: PM: Add CPUidle support
      ARM: OMAP4: cpuidle: Switch to gptimer from twd in deeper C-states.
      ARM: OMAP3: CPUidle: Make use of CPU PM notifiers

Shawn Guo (2):
      ARM: imx6: fix v7_invalidate_l1 by adding I-Cache invalidation
      ARM: imx6: remove __CPUINIT annotation from v7_invalidate_l1

Tero Kristo (6):
      ARM: OMAP: PRCM: add support for chain interrupt handler
      ARM: OMAP: PRCM: add suspend prepare / finish support
      ARM: OMAP2+: mux: add support for PAD wakeup interrupts
      ARM: OMAP: hwmod: add support for selecting mpu_irq for each wakeup pad
      ARM: OMAP3: pm: use prcm chain handler
      ARM: OMAP4: PRM: use PRCM interrupt handler

Tony Lindgren (4):
      Merge branch 'for_3.3/pm/omap4-mpuss' of git://git.kernel.org/.../khilman/linux-omap-pm into omap4
      Merge branch 'tk_prm_chain_handler_devel_3.3' of git://git.pwsan.com/linux-2.6 into prcm
      Merge branch 'for_3.3/uart/runtime-pm' of git://git.kernel.org/.../khilman/linux-omap-pm into uart
      arm/dts: Add minimal device tree support for omap2420 and omap2430

 .../devicetree/bindings/serial/omap_serial.txt     |   10 +
 arch/arm/boot/dts/omap2.dtsi                       |   67 ++
 arch/arm/boot/dts/omap3.dtsi                       |   31 +
 arch/arm/boot/dts/omap4.dtsi                       |   28 +
 arch/arm/mach-imx/Kconfig                          |    1 +
 arch/arm/mach-imx/Makefile                         |    6 +-
 arch/arm/mach-imx/head-v7.S                        |   17 +-
 arch/arm/mach-imx/pm-imx6q.c                       |    2 +
 arch/arm/mach-mx5/mm.c                             |   19 +-
 arch/arm/mach-mx5/system.c                         |    3 -
 arch/arm/mach-omap2/Kconfig                        |   21 +
 arch/arm/mach-omap2/Makefile                       |   19 +-
 arch/arm/mach-omap2/board-3430sdp.c                |  100 +---
 arch/arm/mach-omap2/board-4430sdp.c                |   68 +--
 arch/arm/mach-omap2/board-generic.c                |    1 -
 arch/arm/mach-omap2/board-n8x0.c                   |    6 +-
 arch/arm/mach-omap2/board-omap4panda.c             |   68 +--
 arch/arm/mach-omap2/common.h                       |   64 ++-
 arch/arm/mach-omap2/cpuidle34xx.c                  |   21 +-
 arch/arm/mach-omap2/cpuidle44xx.c                  |  245 ++++++
 arch/arm/mach-omap2/include/mach/barriers.h        |   31 +
 arch/arm/mach-omap2/include/mach/omap-secure.h     |   57 ++
 arch/arm/mach-omap2/include/mach/omap-wakeupgen.h  |   39 +
 arch/arm/mach-omap2/io.c                           |    9 +
 arch/arm/mach-omap2/mux.c                          |   89 ++-
 arch/arm/mach-omap2/omap-headsmp.S                 |    5 -
 arch/arm/mach-omap2/omap-hotplug.c                 |   14 +-
 arch/arm/mach-omap2/omap-mpuss-lowpower.c          |  398 +++++++++
 arch/arm/mach-omap2/omap-secure.c                  |   81 ++
 arch/arm/mach-omap2/omap-smc.S                     |   80 ++
 arch/arm/mach-omap2/omap-smp.c                     |   45 +
 arch/arm/mach-omap2/omap-wakeupgen.c               |  389 +++++++++
 arch/arm/mach-omap2/omap4-common.c                 |   94 ++-
 arch/arm/mach-omap2/omap4-sar-layout.h             |   50 ++
 arch/arm/mach-omap2/omap44xx-smc.S                 |   57 --
 arch/arm/mach-omap2/omap_hwmod.c                   |  125 +++-
 arch/arm/mach-omap2/pm.h                           |    1 +
 arch/arm/mach-omap2/pm24xx.c                       |   20 -
 arch/arm/mach-omap2/pm34xx.c                       |  158 +---
 arch/arm/mach-omap2/pm44xx.c                       |  153 ++++-
 arch/arm/mach-omap2/prcm-common.h                  |   75 ++-
 arch/arm/mach-omap2/prm2xxx_3xxx.c                 |   97 ++-
 arch/arm/mach-omap2/prm2xxx_3xxx.h                 |    9 +-
 arch/arm/mach-omap2/prm44xx.c                      |  116 +++
 arch/arm/mach-omap2/prm44xx.h                      |    8 +-
 arch/arm/mach-omap2/prm_common.c                   |  320 +++++++
 arch/arm/mach-omap2/serial.c                       |  907 ++++++--------------
 arch/arm/mach-omap2/sleep44xx.S                    |  379 ++++++++
 arch/arm/plat-mxc/include/mach/common.h            |    8 +-
 arch/arm/plat-mxc/include/mach/mxc.h               |    2 +-
 arch/arm/plat-mxc/tzic.c                           |   40 +-
 arch/arm/plat-omap/common.c                        |    3 +
 arch/arm/plat-omap/include/plat/omap-secure.h      |   13 +
 arch/arm/plat-omap/include/plat/omap-serial.h      |   37 +-
 arch/arm/plat-omap/include/plat/omap44xx.h         |    1 +
 arch/arm/plat-omap/include/plat/omap_hwmod.h       |    6 +
 arch/arm/plat-omap/include/plat/serial.h           |   10 +-
 arch/arm/plat-omap/include/plat/sram.h             |    6 +-
 arch/arm/plat-omap/sram.c                          |    8 +
 drivers/tty/serial/omap-serial.c                   |  428 ++++++++--
 60 files changed, 3928 insertions(+), 1237 deletions(-)
