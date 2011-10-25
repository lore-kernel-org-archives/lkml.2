Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab1JYNQ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 09:16:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60193 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756355Ab1JYNQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 09:16:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management updates for 3.2
Date: Tue, 25 Oct 2011 15:19:23 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        "Turquette, Mike" <mturquette@ti.com>,
        "Len Brown (Intel)" <len.brown@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110251519.23226.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management updates for 3.2 (on top of commit
3ee72ca99288f1de95ec9c570e43f531c8799f06) from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-for-linus

with top-most commit 0ab1e79b825a5cd8aeb3b34d89c9a89dea900056
"PM / Clocks: Remove redundant NULL checks before kfree()".

They include:

* Runtime PM tracepoints (replacing not very useful debug printks) and fixes
  from Ming Lei.

* Introduction of devfreq by MyungJoo Ham (special thanks to Mike Turquette
  for reviewing all of the versions of this patchset).

* Introduction of device PM QoS from Jean Pihet.

* Generic PM domains core code refinements and extensions.

* SH7372 power management changes from Magnus Damm.

* Threaded hibernate image saving from Bojan Smojver.

* New entries for the ACPI suspend blacklist.

* Assorted fixes.

Thanks!


 Documentation/ABI/testing/sysfs-class-devfreq  |   52 ++
 Documentation/kernel-parameters.txt            |    7 +
 Documentation/power/00-INDEX                   |    2 +
 Documentation/power/basic-pm-debugging.txt     |   24 +
 Documentation/power/devices.txt                |    8 +-
 Documentation/power/pm_qos_interface.txt       |   92 +++-
 Documentation/power/runtime_pm.txt             |   21 +-
 Documentation/power/suspend-and-cpuhotplug.txt |  275 ++++++++
 Documentation/usb/power-management.txt         |    8 +-
 MAINTAINERS                                    |   12 +-
 arch/arm/mach-msm/clock.c                      |    2 +-
 arch/arm/mach-omap1/pm_bus.c                   |    1 +
 arch/arm/mach-shmobile/board-ap4evb.c          |    6 +
 arch/arm/mach-shmobile/board-mackerel.c        |   11 +-
 arch/arm/mach-shmobile/include/mach/common.h   |    4 +-
 arch/arm/mach-shmobile/include/mach/sh7372.h   |   13 +
 arch/arm/mach-shmobile/intc-sh7372.c           |   52 ++-
 arch/arm/mach-shmobile/pm-sh7372.c             |  342 ++++++++--
 arch/arm/mach-shmobile/pm_runtime.c            |    1 +
 arch/arm/mach-shmobile/setup-sh7372.c          |   25 +
 arch/arm/mach-shmobile/sleep-sh7372.S          |  221 +------
 arch/s390/Kconfig                              |    1 +
 arch/s390/kernel/suspend.c                     |  118 ++++
 arch/s390/kernel/swsusp_asm64.S                |    3 +
 drivers/Kconfig                                |    2 +
 drivers/Makefile                               |    2 +
 drivers/acpi/processor_idle.c                  |    2 +-
 drivers/acpi/sleep.c                           |   24 +
 drivers/base/power/Makefile                    |    4 +-
 drivers/base/power/clock_ops.c                 |  127 ++--
 drivers/base/power/common.c                    |   86 +++
 drivers/base/power/domain.c                    |  352 ++++++-----
 drivers/base/power/main.c                      |   42 +-
 drivers/base/power/opp.c                       |   30 +
 drivers/base/power/power.h                     |   10 +-
 drivers/base/power/qos.c                       |  419 ++++++++++++
 drivers/base/power/runtime.c                   |  127 +++--
 drivers/base/power/wakeup.c                    |    4 +-
 drivers/bluetooth/btusb.c                      |    2 +-
 drivers/cpuidle/cpuidle.c                      |    2 +-
 drivers/cpuidle/governors/ladder.c             |    2 +-
 drivers/cpuidle/governors/menu.c               |    2 +-
 drivers/devfreq/Kconfig                        |   75 +++
 drivers/devfreq/Makefile                       |    5 +
 drivers/devfreq/devfreq.c                      |  601 +++++++++++++++++
 drivers/devfreq/governor.h                     |   24 +
 drivers/devfreq/governor_performance.c         |   29 +
 drivers/devfreq/governor_powersave.c           |   29 +
 drivers/devfreq/governor_simpleondemand.c      |   88 +++
 drivers/devfreq/governor_userspace.c           |  116 ++++
 drivers/hid/hid-picolcd.c                      |    2 +-
 drivers/hid/usbhid/hid-core.c                  |    7 +-
 drivers/media/video/via-camera.c               |    4 +-
 drivers/net/e1000e/netdev.c                    |    2 +-
 drivers/net/usb/usbnet.c                       |    2 +-
 drivers/net/wimax/i2400m/usb.c                 |    4 +-
 drivers/net/wireless/ipw2x00/ipw2100.c         |    4 +-
 drivers/tty/Kconfig                            |    4 +
 drivers/usb/class/cdc-acm.c                    |    2 +-
 drivers/usb/class/cdc-wdm.c                    |    6 +-
 drivers/usb/core/driver.c                      |    9 +-
 drivers/usb/core/hcd.c                         |    9 +-
 drivers/usb/core/hub.c                         |   15 +-
 drivers/usb/serial/sierra.c                    |    2 +-
 drivers/usb/serial/usb_wwan.c                  |    2 +-
 include/linux/devfreq.h                        |  238 +++++++
 include/linux/device.h                         |    5 +
 include/linux/freezer.h                        |    4 +-
 include/linux/netdevice.h                      |    4 +-
 include/linux/opp.h                            |   12 +
 include/linux/pm.h                             |   26 +-
 include/linux/pm_clock.h                       |   71 ++
 include/linux/pm_domain.h                      |   26 +-
 include/linux/pm_qos.h                         |  155 +++++
 include/linux/pm_qos_params.h                  |   38 --
 include/linux/pm_runtime.h                     |   42 --
 include/linux/suspend.h                        |   95 +++-
 include/sound/pcm.h                            |    4 +-
 include/trace/events/rpm.h                     |   99 +++
 kernel/Makefile                                |    2 +-
 kernel/freezer.c                               |    2 +-
 kernel/power/Kconfig                           |    4 +
 kernel/power/Makefile                          |    4 +-
 kernel/power/console.c                         |    4 +-
 kernel/power/hibernate.c                       |   53 ++-
 kernel/power/main.c                            |  102 +++
 kernel/power/power.h                           |    4 +-
 kernel/power/process.c                         |   30 +-
 kernel/{pm_qos_params.c => power/qos.c}        |  273 ++++----
 kernel/power/snapshot.c                        |   18 +
 kernel/power/suspend.c                         |   17 +-
 kernel/power/swap.c                            |  818 ++++++++++++++++++-----
 kernel/trace/Makefile                          |    3 +
 kernel/trace/rpm-traces.c                      |   20 +
 net/mac80211/main.c                            |    2 +-
 net/mac80211/mlme.c                            |    2 +-
 net/mac80211/scan.c                            |    2 +-
 sound/core/pcm_native.c                        |    2 +-
 sound/usb/card.c                               |    2 +-
 99 files changed, 4720 insertions(+), 1044 deletions(-)

---------------

Alan Stern (3):
      PM / Runtime: Add macro to test for runtime PM events
      USB: Add wakeup info to debugging messages
      PM: Update the policy on default wakeup settings

Barry Song (4):
      PM / Hibernate: Fix typo in a kerneldoc comment
      PM / Hibernate: Add resumewait param to support MMC-like devices as resume file
      PM / Hibernate: Add resumedelay kernel param in addition to resumewait
      PM / Hibernate: Do not initialize static and extern variables to 0

Bogdan Radulescu (1):
      PM / ACPI: Blacklist Vaio VGN-FW520F machine known to require acpi_sleep=nonvs

Bojan Smojver (1):
      PM / Hibernate: Improve performance of LZO/plain hibernation, checksum image

Colin Cross (1):
      PM / Runtime: Add might_sleep() to runtime PM functions

Dan Carpenter (1):
      PM / Suspend: Off by one in pm_suspend()

Dave Jones (1):
      ACPI / PM: Add Sony VGN-FW21E to nonvs blacklist.

H Hartley Sweeten (1):
      PM / VT: Cleanup #if defined uglyness and fix compile error

Jean Pihet (8):
      PM QoS: Move and rename the implementation files
      PM QoS: Minor clean-ups
      PM QoS: Code reorganization
      PM QoS: Reorganize data structs
      PM QoS: Generalize and export constraints management code
      PM QoS: Implement per-device PM QoS constraints
      PM QoS: Add global notification mechanism for device constraints
      PM / QoS: Update Documentation for the pm_qos and dev_pm_qos frameworks

Jeff Layton (1):
      PM / Freezer: Make fake_signal_wake_up() wake TASK_KILLABLE tasks too

Jonghwan Choi (1):
      PM / Clocks: Remove redundant NULL checks before kfree()

Magnus Damm (5):
      ARM: mach-shmobile: sh7372 generic suspend/resume support
      ARM: mach-shmobile: sh7372 A3SM support
      ARM: mach-shmobile: sh7372 sleep warning fixes
      ARM: mach-shmobile: sh7372 A3SP support (v4)
      ARM: mach-shmobile: sh7372 A4R support (v4)

Martin Schwidefsky (1):
      PM / Hibernate: Include storage keys in hibernation image on s390

Ming Lei (7):
      PM / Runtime: pm_runtime_idle() can be called in atomic context
      PM / Runtime: Introduce trace points for tracing rpm_* functions
      PM / Runtime: Replace dev_dbg() with trace_rpm_*()
      PM / Tracing: build rpm-traces.c only if CONFIG_PM_RUNTIME is set
      PM / Runtime: Update document about callbacks
      PM / Runtime: Fix kerneldoc comment for rpm_suspend()
      PM / Runtime: Handle .runtime_suspend() failure correctly

MyungJoo Ham (4):
      PM / OPP: Add OPP availability change notifier.
      PM: Introduce devfreq: generic DVFS framework with device-specific OPPs
      PM / devfreq: Add common sysfs interfaces
      PM / devfreq: Add basic governors

Rafael J. Wysocki (20):
      PM / Domains: Implement subdomain counters as atomic fields
      PM / Domains: Do not take parent locks to modify subdomain counters
      PM / Domains: Make pm_genpd_poweron() always survive parent removal
      PM / Domains: Add "wait for parent" status for generic PM domains
      PM / Domains: Allow generic PM domains to have multiple masters
      PM / Domains: Rename GPD_STATE_WAIT_PARENT to GPD_STATE_WAIT_MASTER
      PM / Domains: Rename argument of pm_genpd_add_subdomain()
      ARM / shmobile: Make A3RV be a subdomain of A4LC on SH7372
      PM: Introduce struct pm_subsys_data
      PM: Reference counting of power.subsys_data
      PM / Domains: Use power.sybsys_data to reduce overhead
      PM: Move clock-related definitions and headers to separate file
      PM / Domains: Preliminary support for devices with power.irq_safe set
      PM / Domains: Split device PM domain data into base and need_restore
      PM / Runtime: Don't run callbacks under lock for power.irq_safe set
      PM / QoS: Add function dev_pm_qos_read_value() (v3)
      PM: Fix build issue in main.c for CONFIG_PM_SLEEP unset
      PM / Hibernate: Freeze kernel threads after preallocating memory
      PM / ACPI: Blacklist Sony Vaio known to require acpi_sleep=nonvs
      PM / Sleep: Mark devices involved in wakeup signaling during suspend

ShuoX Liu (1):
      PM / Suspend: Add statistics debugfs file for suspend to RAM

Srivatsa S. Bhat (1):
      PM / Documentation: Update docs about suspend and CPU hotplug

WANG Cong (1):
      MAINTAINERS: Update linux-pm list address

