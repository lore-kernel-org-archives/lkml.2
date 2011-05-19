Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934960Ab1ESVsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 17:48:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41099 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933194Ab1ESVsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 17:48:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Power management updates for 2.6.40
Date: Thu, 19 May 2011 23:48:49 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105192348.49412.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management updates for 2.6.40 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

They include:

* Elimination of suspend/resume and shutdown callbacks from struct sysdev_class
  and struct sysdev_driver.

* Consolidation of ARM OMAP and shmobile runtime PM clock management and update
  of the core PM code related to power domains.

* Various PM fixes and extensions.


 Documentation/ABI/testing/sysfs-power      |   14 +
 Documentation/feature-removal-schedule.txt |    8 -
 Documentation/kernel-parameters.txt        |    2 +-
 Documentation/power/devices.txt            |   14 +-
 Documentation/power/notifiers.txt          |   51 ++--
 arch/arm/common/vic.c                      |   69 ++---
 arch/arm/include/asm/mach/time.h           |    1 -
 arch/arm/kernel/leds.c                     |   28 +-
 arch/arm/kernel/time.c                     |   35 +--
 arch/arm/mach-exynos4/pm.c                 |   45 ++--
 arch/arm/mach-integrator/integrator_ap.c   |   26 +--
 arch/arm/mach-omap1/pm_bus.c               |   69 ++---
 arch/arm/mach-omap2/Makefile               |    6 +-
 arch/arm/mach-omap2/pm_bus.c               |   85 ------
 arch/arm/mach-pxa/balloon3.c               |    1 -
 arch/arm/mach-pxa/clock-pxa2xx.c           |   18 +-
 arch/arm/mach-pxa/clock-pxa3xx.c           |   17 +-
 arch/arm/mach-pxa/clock.h                  |    7 +-
 arch/arm/mach-pxa/cm-x270.c                |    1 -
 arch/arm/mach-pxa/cm-x2xx.c                |   23 +-
 arch/arm/mach-pxa/colibri-evalboard.c      |    1 -
 arch/arm/mach-pxa/colibri-pxa270-income.c  |    1 -
 arch/arm/mach-pxa/colibri-pxa270.c         |    1 -
 arch/arm/mach-pxa/generic.h                |    8 +-
 arch/arm/mach-pxa/irq.c                    |   17 +-
 arch/arm/mach-pxa/lpd270.c                 |   20 +-
 arch/arm/mach-pxa/lubbock.c                |   21 +-
 arch/arm/mach-pxa/mainstone.c              |   22 +-
 arch/arm/mach-pxa/mfp-pxa2xx.c             |   12 +-
 arch/arm/mach-pxa/mfp-pxa3xx.c             |   21 +-
 arch/arm/mach-pxa/mioa701.c                |   43 +---
 arch/arm/mach-pxa/palmld.c                 |    1 -
 arch/arm/mach-pxa/palmtreo.c               |    1 -
 arch/arm/mach-pxa/palmz72.c                |   24 +-
 arch/arm/mach-pxa/pxa25x.c                 |   25 +--
 arch/arm/mach-pxa/pxa27x.c                 |   25 +--
 arch/arm/mach-pxa/pxa3xx.c                 |   25 +--
 arch/arm/mach-pxa/pxa95x.c                 |   20 +-
 arch/arm/mach-pxa/raumfeld.c               |    1 -
 arch/arm/mach-pxa/smemc.c                  |   29 +--
 arch/arm/mach-pxa/trizeps4.c               |    1 -
 arch/arm/mach-pxa/viper.c                  |   12 +-
 arch/arm/mach-pxa/vpac270.c                |    1 -
 arch/arm/mach-s3c2410/irq.c                |   30 +--
 arch/arm/mach-s3c2410/mach-bast.c          |   17 +-
 arch/arm/mach-s3c2410/pm.c                 |   13 +-
 arch/arm/mach-s3c2410/s3c2410.c            |    5 +
 arch/arm/mach-s3c2412/irq.c                |    2 -
 arch/arm/mach-s3c2412/mach-jive.c          |   19 +-
 arch/arm/mach-s3c2412/pm.c                 |   27 +-
 arch/arm/mach-s3c2412/s3c2412.c            |    4 +
 arch/arm/mach-s3c2416/irq.c                |    2 -
 arch/arm/mach-s3c2416/pm.c                 |   27 +-
 arch/arm/mach-s3c2416/s3c2416.c            |    5 +
 arch/arm/mach-s3c2440/mach-osiris.c        |   18 +-
 arch/arm/mach-s3c2440/s3c2440.c            |    8 +
 arch/arm/mach-s3c2440/s3c2442.c            |    6 +
 arch/arm/mach-s3c2440/s3c244x-irq.c        |    4 -
 arch/arm/mach-s3c2440/s3c244x.c            |   62 ++--
 arch/arm/mach-s3c64xx/irq-pm.c             |   18 +-
 arch/arm/mach-s5pv210/pm.c                 |   25 ++-
 arch/arm/mach-sa1100/irq.c                 |   19 +-
 arch/arm/mach-shmobile/pm_runtime.c        |  145 ++--------
 arch/arm/plat-omap/gpio.c                  |   35 +--
 arch/arm/plat-omap/omap_device.c           |   23 ++
 arch/arm/plat-pxa/gpio.c                   |   17 +-
 arch/arm/plat-pxa/mfp.c                    |    1 -
 arch/arm/plat-s3c24xx/dma.c                |   68 ++---
 arch/arm/plat-s3c24xx/irq-pm.c             |    7 +-
 arch/arm/plat-s5p/irq-pm.c                 |    7 +-
 arch/arm/plat-samsung/include/plat/cpu.h   |    6 +
 arch/arm/plat-samsung/include/plat/pm.h    |    6 +-
 arch/arm/vfp/vfpmodule.c                   |   19 +-
 arch/avr32/mach-at32ap/intc.c              |   38 +--
 arch/blackfin/kernel/nmi.c                 |   30 +--
 arch/powerpc/include/asm/mpic.h            |    3 -
 arch/powerpc/platforms/cell/spu_base.c     |   28 ++-
 arch/powerpc/platforms/powermac/pic.c      |   42 +--
 arch/powerpc/sysdev/ipic.c                 |   36 +--
 arch/powerpc/sysdev/mpic.c                 |   48 ++--
 arch/sh/Kconfig                            |    1 -
 arch/sh/configs/apsh4ad0a_defconfig        |    1 -
 arch/sh/configs/sdk7786_defconfig          |    1 -
 arch/sh/kernel/cpu/shmobile/pm_runtime.c   |   33 ++-
 arch/unicore32/kernel/irq.c                |   23 +-
 arch/x86/Kconfig                           |    1 -
 arch/x86/kernel/acpi/sleep.c               |    5 -
 arch/x86/kernel/apm_32.c                   |    4 -
 drivers/base/Kconfig                       |    7 -
 drivers/base/base.h                        |    2 -
 drivers/base/dd.c                          |    6 +-
 drivers/base/firmware_class.c              |    5 +
 drivers/base/platform.c                    |  138 ++--------
 drivers/base/power/Makefile                |    4 +-
 drivers/base/power/clock_ops.c             |  431 ++++++++++++++++++++++++++++
 drivers/base/power/generic_ops.c           |   39 +++
 drivers/base/power/main.c                  |   82 +++---
 drivers/base/power/runtime.c               |   29 +--
 drivers/base/power/sysfs.c                 |    4 +-
 drivers/base/power/wakeup.c                |    1 -
 drivers/base/sys.c                         |  202 +-------------
 drivers/xen/manage.c                       |    8 +-
 include/linux/device.h                     |    7 -
 include/linux/kmod.h                       |    1 +
 include/linux/platform_device.h            |   63 ++++-
 include/linux/pm.h                         |   39 ++-
 include/linux/pm_runtime.h                 |   42 +++
 include/linux/sysdev.h                     |   11 -
 kernel/freezer.c                           |    4 +-
 kernel/kexec.c                             |    9 +-
 kernel/kmod.c                              |   16 +-
 kernel/power/Kconfig                       |   10 +-
 kernel/power/hibernate.c                   |   58 +++--
 kernel/power/main.c                        |    1 +
 kernel/power/power.h                       |    4 +
 kernel/power/snapshot.c                    |   33 ++-
 kernel/power/suspend.c                     |   10 +-
 kernel/sys.c                               |    3 -
 118 files changed, 1393 insertions(+), 1667 deletions(-)

---------------

Amerigo Wang (1):
      PM / ACPI: Remove acpi_sleep=s4_nonvs

Eric Dumazet (1):
      PM / Wakeup: Remove useless synchronize_rcu() call

Kay Sievers (1):
      kmod: always provide usermodehelper_disable()

Kevin Hilman (2):
      OMAP2+ / PM: move runtime PM implementation to use device power domains
      PM: Revert "driver core: platform_bus: allow runtime override of dev_pm_ops"

Mike Frysinger (1):
      Freezer: Use SMP barriers

MyungJoo Ham (1):
      PM / Suspend: Do not ignore error codes returned by suspend_enter()

Rafael J. Wysocki (27):
      ARM: Use struct syscore_ops instead of sysdevs for PM in common code
      ARM / OMAP: Use struct syscore_ops for "core" power management
      ARM / Integrator: Use struct syscore_ops for core PM
      ARM / SA1100: Use struct syscore_ops for "core" power management
      ARM / PXA: Use struct syscore_ops for "core" power management
      ARM / Samsung: Use struct syscore_ops for "core" power management
      PM / Blackfin: Use struct syscore_ops instead of sysdevs for PM
      PM: Make power domain callbacks take precedence over subsystem ones
      PM: Export platform bus type's default PM callbacks
      shmobile: Use power domains for platform runtime PM
      PM / Platform: Use generic runtime PM callbacks directly
      PM / Runtime: Add subsystem data field to struct dev_pm_info
      PM / Runtime: Generic clock manipulation rountines for runtime PM (v6)
      PM / AVR32: Use struct syscore_ops instead of sysdevs for PM
      PM / UNICORE32: Use struct syscore_ops instead of sysdevs for PM
      PM / PowerPC: Use struct syscore_ops instead of sysdevs for PM
      PM: Remove sysdev suspend, resume and shutdown operations
      OMAP1 / PM: Use generic clock manipulation routines for runtime PM
      PM: Fix build issue in clock_ops.c for CONFIG_PM_RUNTIME unset
      PM / Runtime: Rework runtime PM handling during driver removal
      PM: Print a warning if firmware is requested when tasks are frozen
      PM / Wakeup: Fix build warning related to the "wakeup" sysfs file
      PM / Hibernate: Add sysfs knob to control size of memory for drivers
      Revert "PM / Hibernate: Reduce autotuned default image size"
      PM: Remove CONFIG_PM_VERBOSE
      PM: Allow drivers to allocate memory from .prepare() callbacks safely
      PM: Introduce generic prepare and complete callbacks for subsystems

