Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751242Ab1CPB2K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 21:28:10 -0400
Received: from smtp-out.google.com ([74.125.121.67]:4676 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab1CPB2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 21:28:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=iRnpEz053bzFQP0hXiJmZHh3sBpAU12NWxAVPtNjAjAZedlm2rd6il4+l4u6psigCV
         DTO3jVOyDRv3EPMKCabQ==
MIME-Version: 1.0
Date: Tue, 15 Mar 2011 18:28:01 -0700
Message-ID: <AANLkTikkb4RYxN2=HjpLgz-SWDKZ=ysE6HQuEEaDfiz8@mail.gmail.com>
Subject: ARM Tegra updates for 2.6.39
From: Colin Cross <ccross@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Tegra Mailing List <linux-tegra@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Erik Gilling <konkers@android.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
Please pull updates for Tegra from:

 git://android.git.kernel.org/kernel/tegra.git for-linus

Thanks,
Colin

The following changes since commit 100b33c8bd8a3235fd0b7948338d6cbb3db3c63d:

  Linux 2.6.38-rc4 (2011-02-07 16:03:55 -0800)

are available in the git repository at:
  git://android.git.kernel.org/kernel/tegra.git for-linus

Colin Cross (37):
      ARM: tegra: Centralize macros to define debug uart base
      ARM: tegra: Add api to control internal powergating
      ARM: tegra: irqs: Update irq list
      ARM: tegra: Add prototypes for subsystem suspend functions
      ARM: tegra: clock: Suspend fixes, and add new clocks
      ARM: tegra: timer: Add idle and suspend support to timers
      ARM: tegra: irq: Add support for suspend wake sources
      ARM: tegra: irq: Implement retrigger
      ARM: tegra: cpufreq: Disable cpufreq during suspend
      ARM: tegra: Allow overriding arch_reset
      ARM: tegra: dma: Fix critical data corruption bugs
      ARM: tegra: Use writel_relaxed in tegra_init_cache
      Merge branch 'tegra-arch' of
git://git.kernel.org/.../broonie/sound-2.6 into outside-for-next
      ARM: tegra: clock: Don't BUG on changing an enabled PLL
      ARM: tegra: clock: Drop debugging
      ARM: tegra: clock: Don't use PLL lock bits
      ARM: tegra: clock: Initialize clocks that have no enable
      ARM: tegra: clock: Drop CPU dvfs
      ARM: tegra: clock: Rearrange static clock tables
      ARM: tegra: clock: Move unshared clk struct members into union
      ARM: tegra: clock: Convert global lock to a lock per clock
      ARM: tegra: cpufreq: Take an extra reference to pllx
      ARM: tegra: clock: Add shared bus clock type
      ARM: tegra: clock: Minor cleanups
      ARM: tegra: Add external memory controller driver
      ARM: tegra: clocks: Add emc scaling
      ARM: tegra: cpufreq: Adjust memory frequency with cpu frequency
      ARM: tegra: clock: Add function to set SDMMC tap delay
      ARM: tegra: clock: Fix clock issues in suspend
      ARM: tegra: clock: Miscellaneous clock updates
      ARM: tegra: clock: Refcount periph clock enables
      ARM: tegra: clock: Round rate before setting rate
      ARM: tegra: clock: prevent accidental disables of cpu clock
      ARM: tegra: Move tegra_common_init to tegra_init_early
      ARM: tegra: timer: Enable timer and rtc clocks
      ARM: tegra: common: Enable core clocks
      Merge branch 'boards-for-next' of
git://git.kernel.org/.../olof/tegra-2.6 into for-next

Dima Zavin (1):
      ARM: tegra: clock: enable clk reset for non-peripheral clocks

Gary King (2):
      ARM: tegra: pinmux: Add missing drive pingroups and fix suspend
      ARM: tegra: iomap: Add missing devices

Mark Brown (1):
      ARM: tegra: Hide EMC scaling config behind ARCH_TEGRA

Mike Rapoport (4):
      ARM: tegra: add TrimSlice board
      ARM: tegra: PCIE minor code refactoring
      ARM: tegra: add PCI Express power gating
      ARM: tegra: trimslice: initialize PCI-e only when running on TrimSlice

Olof Johansson (8):
      ARM: tegra: add tegra_defconfig
      ARM: tegra: add tegra_gpio_table and tegra_gpio_config
      ARM: tegra: harmony: move over to tegra_gpio_config
      ARM: tegra: common device resources
      ARM: tegra: remove stale nvidia atag handler
      ARM: tegra: harmony: register sdhci devices
      ARM: tegra: harmony: fix pinmux for MMC slot
      ARM: tegra: add seaboard, wario and kaen boards

Simon Glass (1):
      ARM: tegra: Fix hang on reboot

Stephen Warren (9):
      ARM: tegra: Add Harmony sound platform data type
      ARM: tegra: Add to struct harmony_audio_platform_data
      ARM: tegra: Prevent requeuing in-progress DMA requests
      ARM: tegra: APB DMA: Enable clock and remove reset.
      ARM: tegra: Fix typo in TEGRA_IRQ_TO_GPIO
      ARM: Tegra: Make tegra_dma_init a postcore_initcall
      ARM: Tegra: Rename I2S clocks to match driver name
      ARM: Tegra: Rename clk_dev1/2 to cdev1/2
      ARM: Tegra: DMA: Fail safe if initialization fails

 arch/arm/configs/tegra_defconfig                   |  123 +++
 arch/arm/mach-tegra/Kconfig                        |   28 +
 arch/arm/mach-tegra/Makefile                       |   10 +-
 arch/arm/mach-tegra/board-harmony-pinmux.c         |   19 +-
 arch/arm/mach-tegra/board-harmony.c                |   62 +-
 arch/arm/mach-tegra/board-seaboard-pinmux.c        |  179 ++++
 arch/arm/mach-tegra/board-seaboard.c               |  196 ++++
 arch/arm/mach-tegra/board-seaboard.h               |   38 +
 arch/arm/mach-tegra/board-trimslice-pinmux.c       |  145 +++
 arch/arm/mach-tegra/board-trimslice.c              |  106 ++
 .../{tegra2_dvfs.h => board-trimslice.h}           |   14 +-
 arch/arm/mach-tegra/board.h                        |    4 +-
 arch/arm/mach-tegra/clock.c                        |  532 +++++-----
 arch/arm/mach-tegra/clock.h                        |  129 +--
 arch/arm/mach-tegra/common.c                       |   27 +-
 arch/arm/mach-tegra/cpu-tegra.c                    |  100 ++-
 arch/arm/mach-tegra/devices.c                      |  505 +++++++++
 arch/arm/mach-tegra/devices.h                      |   46 +
 arch/arm/mach-tegra/dma.c                          |  243 +++--
 arch/arm/mach-tegra/gpio.c                         |   15 +
 arch/arm/mach-tegra/include/mach/clk.h             |    6 +-
 arch/arm/mach-tegra/include/mach/debug-macro.S     |   25 +-
 arch/arm/mach-tegra/include/mach/gpio.h            |    9 +-
 .../mach/harmony_audio.h}                          |   14 +-
 arch/arm/mach-tegra/include/mach/iomap.h           |   47 +
 arch/arm/mach-tegra/include/mach/irqs.h            |   14 +-
 arch/arm/mach-tegra/include/mach/legacy_irq.h      |    4 +
 arch/arm/mach-tegra/include/mach/pinmux-t2.h       |   10 +
 arch/arm/mach-tegra/include/mach/powergate.h       |   40 +
 arch/arm/mach-tegra/include/mach/suspend.h         |   38 +
 arch/arm/mach-tegra/include/mach/system.h          |   10 +-
 arch/arm/mach-tegra/include/mach/uncompress.h      |   18 +-
 arch/arm/mach-tegra/irq.c                          |  186 ++--
 arch/arm/mach-tegra/legacy_irq.c                   |  109 ++-
 arch/arm/mach-tegra/pcie.c                         |   38 +-
 arch/arm/mach-tegra/pinmux-t2-tables.c             |   26 +-
 arch/arm/mach-tegra/powergate.c                    |  212 ++++
 arch/arm/mach-tegra/tegra2_clocks.c                | 1120 +++++++++++++++-----
 arch/arm/mach-tegra/tegra2_dvfs.c                  |   86 --
 arch/arm/mach-tegra/tegra2_emc.c                   |  178 ++++
 .../arm/mach-tegra/{tegra2_dvfs.h => tegra2_emc.h} |   17 +-
 arch/arm/mach-tegra/timer.c                        |   77 ++-
 42 files changed, 3755 insertions(+), 1050 deletions(-)
 create mode 100644 arch/arm/configs/tegra_defconfig
 create mode 100644 arch/arm/mach-tegra/board-seaboard-pinmux.c
 create mode 100644 arch/arm/mach-tegra/board-seaboard.c
 create mode 100644 arch/arm/mach-tegra/board-seaboard.h
 create mode 100644 arch/arm/mach-tegra/board-trimslice-pinmux.c
 create mode 100644 arch/arm/mach-tegra/board-trimslice.c
 copy arch/arm/mach-tegra/{tegra2_dvfs.h => board-trimslice.h} (70%)
 create mode 100644 arch/arm/mach-tegra/devices.c
 create mode 100644 arch/arm/mach-tegra/devices.h
 copy arch/arm/mach-tegra/{tegra2_dvfs.h => include/mach/harmony_audio.h} (69%)
 create mode 100644 arch/arm/mach-tegra/include/mach/powergate.h
 create mode 100644 arch/arm/mach-tegra/include/mach/suspend.h
 create mode 100644 arch/arm/mach-tegra/powergate.c
 delete mode 100644 arch/arm/mach-tegra/tegra2_dvfs.c
 create mode 100644 arch/arm/mach-tegra/tegra2_emc.c
 rename arch/arm/mach-tegra/{tegra2_dvfs.h => tegra2_emc.h} (58%)
