Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab1GVW1M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 18:27:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44167 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab1GVW1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 18:27:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management updates for 3.1
Date: Sat, 23 Jul 2011 00:27:54 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-sh@vger.kernel.org, linux-omap@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107230027.54769.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management updates for 3.1 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

They include:

* Introduction of core PM code to support power domains and related
  modifications of the ARM shmobile platform which is its first user (the
  Samsung exynos4 platform is going to use it too).

* Modifications of the runtime PM framework clarifying its interactions with
  the core system suspend/resume and hibernate code and related changes of the
  ARM OMAP platform.

* Various PM fixes and extensions.


 Documentation/power/devices.txt               |   14 +-
 Documentation/power/opp.txt                   |    2 +
 Documentation/power/runtime_pm.txt            |  229 +++--
 arch/arm/Kconfig                              |    1 +
 arch/arm/mach-omap1/pm_bus.c                  |   14 +-
 arch/arm/mach-omap2/gpio.c                    |    2 +
 arch/arm/mach-omap2/serial.c                  |    1 +
 arch/arm/mach-shmobile/board-ap4evb.c         |    5 +
 arch/arm/mach-shmobile/board-mackerel.c       |    5 +
 arch/arm/mach-shmobile/clock-sh7372.c         |    1 +
 arch/arm/mach-shmobile/include/mach/sh7372.h  |   29 +
 arch/arm/mach-shmobile/pm-sh7372.c            |  160 ++++
 arch/arm/mach-shmobile/pm_runtime.c           |   22 +-
 arch/arm/mach-shmobile/setup-sh7372.c         |   11 +
 arch/arm/plat-omap/include/plat/omap_device.h |    9 +
 arch/arm/plat-omap/omap_device.c              |   53 +-
 arch/sh/kernel/cpu/shmobile/pm_runtime.c      |    6 +-
 drivers/base/power/Makefile                   |    1 +
 drivers/base/power/clock_ops.c                |  234 +++--
 drivers/base/power/domain.c                   | 1273 +++++++++++++++++++++++++
 drivers/base/power/generic_ops.c              |   98 ++-
 drivers/base/power/main.c                     |   65 +-
 drivers/base/power/opp.c                      |   17 +
 drivers/base/power/runtime.c                  |   89 +-
 drivers/base/power/sysfs.c                    |    6 +-
 drivers/base/power/trace.c                    |    2 +-
 drivers/char/apm-emulation.c                  |    2 +-
 drivers/pci/pci-driver.c                      |   18 +-
 drivers/s390/char/vmwatchdog.c                |    4 +-
 drivers/s390/cio/css.c                        |    8 +-
 drivers/scsi/scsi_pm.c                        |    8 +-
 include/linux/device.h                        |    4 +-
 include/linux/opp.h                           |    8 +
 include/linux/pm.h                            |   10 +-
 include/linux/pm_domain.h                     |  108 +++
 include/linux/pm_runtime.h                    |   38 +-
 include/linux/suspend.h                       |    8 +
 kernel/power/Kconfig                          |    8 +-
 kernel/power/main.c                           |    5 +-
 kernel/power/suspend.c                        |   20 +-
 40 files changed, 2274 insertions(+), 324 deletions(-)

---------------

Akinobu Mita (1):
      PM: Improve error code of pm_notifier_call_chain()

Alan Stern (1):
      PM / Runtime: Prevent runtime_resume from racing with probe

Kevin Hilman (6):
      PM / Runtime: Add new helper function: pm_runtime_status_suspended()
      OMAP: PM: omap_device: conditionally use PM domain runtime helpers
      OMAP: PM: omap_device: add system PM methods for PM domain handling
      OMAP: PM: omap_device: add API to disable idle on suspend
      OMAP: PM: disable idle on suspend for GPIO and UART
      PM / Suspend: Export suspend_set_ops, suspend_valid_only_mem

Kuninori Morimoto (2):
      ARM: mach-shmobile: sh7372: make sure that fsi is peripheral of spu2
      ARM: mach-shmobile: sh7372 A4MP support

Magnus Damm (9):
      ARM: mach-shmobile: sh7372 A4LC support for AP4EVB
      ARM: mach-shmobile: sh7372 A3RV support
      ARM: mach-shmobile: sh7372 A3RI support
      ARM: mach-shmobile: sh7372 A3SG support
      ARM: mach-shmobile: sh7372 D4 support
      ARM: mach-shmobile: Runtime PM late init callback
      ARM: mach-shmobile: sh7372 late pm domain off
      PM / Domains: Export pm_genpd_poweron() in header
      ARM: mach-shmobile: sh7372 A3RV requires A4LC

MyungJoo Ham (1):
      PM / Suspend: Add .suspend_again() callback to suspend_ops

Nishanth Menon (1):
      PM / OPP: Introduce function to free cpufreq table

Rafael J. Wysocki (29):
      PM / Domains: Rename struct dev_power_domain to struct dev_pm_domain
      PM: subsys_data in struct dev_pm_info need not depend on RM_RUNTIME
      PM / Domains: Support for generic I/O PM domains (v8)
      PM: Introduce generic "noirq" callback routines for subsystems (v2)
      PM / Domains: Move code from under #ifdef CONFIG_PM_RUNTIME (v2)
      PM / Domains: System-wide transitions support for generic domains (v5)
      PM / Domains: Wakeup devices support for system sleep transitions
      PM: Allow the clocks management code to be used during system suspend
      PM: Rename clock management functions
      ARM / shmobile: Support for I/O power domains for SH7372 (v9)
      PM / Runtime: Update documentation of interactions with system sleep
      PM / Runtime: Return special error code if runtime PM is disabled
      PCI / PM: Detect early wakeup in pci_pm_prepare()
      PM: Limit race conditions between runtime PM and system sleep (v2)
      PM / Runtime: Improve documentation of enable, disable and barrier
      PM / Runtime: Replace "run-time" with "runtime" in documentation
      PM / Domains: Set device state to "active" during system resume
      PM / Domains: Make failing pm_genpd_prepare() clean up properly
      PM / Domains: Do not execute device callbacks under locks
      PM / Domains: Allow callbacks to execute all runtime PM helpers
      PM / Domains: Do not restore all devices on power off error
      PM / Domains: Improve handling of wakeup devices during system suspend
      PM / Domains: Queue up power off work only if it is not pending
      PM / Domains: Introduce function to power off all unused PM domains
      ARM / shmobile: Use pm_genpd_poweroff_unused()
      ARM / shmobile: Use genpd_queue_power_off_work()
      PM / Domains: Take .power_off() error code into account
      ARM / shmobile: Return -EBUSY from A4LC power off if A3RV is active
      PM: Add "RTC" to PM trace time stamps to avoid confusion

ShuoX Liu (1):
      PM / Runtime: Consistent utilization of deferred_resume

