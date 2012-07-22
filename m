Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab2GVUXO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 16:23:14 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:51589 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429Ab2GVUXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 16:23:09 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management updates for 3.6
Date: Sun, 22 Jul 2012 22:28:52 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Len Brown <lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207222228.52383.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-for-3.6-rc1

to receive power management updates for v3.6 with top-most commit
75a4161a58dd157a2bd2dc8e9986e45b62ac46cf

  Merge branch 'pm-cpufreq'

on top of commit d9914cf66181b8aa0929775f5c6f675c6ebc3eb5

  PM: Rename CAP_EPOLLWAKEUP to CAP_BLOCK_SUSPEND

Included are:

* ACPI conversion to PM handling based on struct dev_pm_ops (this series got
  Len's blessing: http://marc.info/?l=linux-kernel&m=134267459913007&w=2).

* Conversion of a number of platform drivers to PM handling based on struct
  dev_pm_ops and removal of empty legacy PM callbacks from a couple of PCI
  drivers.

* Suspend-to-both for in-kernel hibernation from Bojan Smojver.

* cpuidle fixes and cleanups from ShuoX Liu, Daniel Lezcano and Preeti U Murthy.

* cpufreq bug fixes from Jonghwa Lee and Stephen Boyd.

* Suspend and hibernate fixes from Srivatsa S. Bhat and Colin Cross.

* Generic PM domains framework updates.

* RTC CMOS wakeup signaling update from Paul Fox.

* sparse warnings fixes from Sachin Kamat.

* Build warnings fixes for the generic PM domains framework and PM sysfs code.

* sysfs switch for printing device suspend times from Sameer Nanda.

* Documentation fix from Oskar Schirmer.

That's more changes than usually, but they tend to be rather small.

Thanks!


 Documentation/ABI/testing/sysfs-power    |  13 ++
 Documentation/power/devices.txt          |   9 +-
 Documentation/power/swsusp.txt           |   5 +
 arch/x86/platform/olpc/olpc-xo15-sci.c   |   6 +-
 drivers/acpi/ac.c                        |  17 +-
 drivers/acpi/battery.c                   |  15 +-
 drivers/acpi/button.c                    |   9 +-
 drivers/acpi/fan.c                       |  21 +-
 drivers/acpi/power.c                     |  12 +-
 drivers/acpi/processor_driver.c          |  13 +-
 drivers/acpi/processor_idle.c            |  43 +---
 drivers/acpi/sbs.c                       |  10 +-
 drivers/acpi/scan.c                      |  22 --
 drivers/acpi/thermal.c                   |  17 +-
 drivers/base/power/domain.c              | 342 ++++++++++++++++++++++++-------
 drivers/base/power/main.c                |  26 ++-
 drivers/base/power/qos.c                 |   2 +-
 drivers/base/power/sysfs.c               |   4 +
 drivers/block/mg_disk.c                  |  13 +-
 drivers/char/hw_random/omap-rng.c        |  13 +-
 drivers/char/ipmi/ipmi_si_intf.c         |  16 --
 drivers/char/sonypi.c                    |  13 +-
 drivers/char/tpm/tpm.c                   |   2 +-
 drivers/char/tpm/tpm.h                   |   2 +-
 drivers/char/tpm/tpm_atmel.c             |  12 +-
 drivers/char/tpm/tpm_nsc.c               |  13 +-
 drivers/char/tpm/tpm_tis.c               |  18 +-
 drivers/cpufreq/cpufreq.c                |  35 +++-
 drivers/cpufreq/exynos-cpufreq.c         |  14 +-
 drivers/cpuidle/cpuidle.c                |  18 +-
 drivers/cpuidle/driver.c                 |  29 ++-
 drivers/cpuidle/governors/menu.c         |   6 +-
 drivers/cpuidle/sysfs.c                  |  21 +-
 drivers/crypto/ux500/cryp/cryp_core.c    |  39 ++--
 drivers/crypto/ux500/hash/hash_core.c    |  33 ++-
 drivers/hwmon/acpi_power_meter.c         |  13 +-
 drivers/idle/intel_idle.c                |  41 ++--
 drivers/platform/x86/acer-wmi.c          |  10 +-
 drivers/platform/x86/classmate-laptop.c  |  13 +-
 drivers/platform/x86/fujitsu-tablet.c    |   8 +-
 drivers/platform/x86/hdaps.c             |   6 +-
 drivers/platform/x86/hp_accel.c          |  15 +-
 drivers/platform/x86/intel_ips.c         |  17 --
 drivers/platform/x86/intel_mid_thermal.c |  16 +-
 drivers/platform/x86/msi-laptop.c        |   7 +-
 drivers/platform/x86/panasonic-laptop.c  |  16 +-
 drivers/platform/x86/sony-laptop.c       |  20 +-
 drivers/platform/x86/thinkpad_acpi.c     |  23 ++-
 drivers/platform/x86/toshiba_acpi.c      |  15 +-
 drivers/platform/x86/toshiba_bluetooth.c |  10 +-
 drivers/platform/x86/xo15-ebook.c        |   8 +-
 drivers/rtc/rtc-cmos.c                   |   1 +
 include/acpi/acpi_bus.h                  |   5 -
 include/acpi/processor.h                 |   7 +-
 include/linux/cpuidle.h                  |  20 +-
 include/linux/pm_domain.h                |  18 ++
 include/linux/pm_qos.h                   |   2 +-
 include/linux/suspend.h                  |   6 +
 kernel/power/Kconfig                     |   4 +-
 kernel/power/hibernate.c                 |  42 ++++
 kernel/power/main.c                      |  45 ++++
 kernel/power/power.h                     |   3 +
 kernel/power/suspend.c                   |   3 +
 kernel/power/swap.c                      |  82 +++++---
 kernel/power/wakelock.c                  |   7 +
 65 files changed, 887 insertions(+), 479 deletions(-)

---------------

Bojan Smojver (2):
      PM / Hibernate: Enable suspend to both for in-kernel hibernation.
      PM / Hibernate: Print hibernation/thaw progress indicator one line at a time.

Colin Cross (1):
      PM / Sleep: call early resume handlers when suspend_noirq fails

Daniel Lezcano (4):
      ACPI: intel_idle : break dependency between modules
      cpuidle / ACPI : remove latency_ticks from acpi_processor_cx structure
      cpuidle / ACPI: remove usage from acpi_processor_cx structure
      cpuilde / ACPI: remove time from acpi_processor_cx structure

Jonghwa Lee (1):
      EXYNOS: bugfix on retrieving old_index from freqs.old

Oskar Schirmer (1):
      PM / Documentation: fix typos in power management description

Paul Fox (1):
      rtc-cmos: report wakeups from interrupt handler

Preeti U Murthy (1):
      PM / cpuidle: System resume hang fix with cpuidle

Rafael J. Wysocki (50):
      ACPI / PM: Drop pm_message_t argument from device suspend callback
      ACPI / PM: Make acpi_bus_type use struct dev_pm_ops for PM handling
      ACPI / PM: Make acpi_bus_type use driver struct dev_pm_ops callbacks
      ACPI: Use struct dev_pm_ops for power management in the fan driver
      ACPI: Use struct dev_pm_ops for power management in the thermal driver
      ACPI: Use struct dev_pm_ops for power management in processor driver
      ACPI: Use struct dev_pm_ops for power management in the AC driver
      ACPI: Use struct dev_pm_ops for power management in the battery driver
      ACPI: Use struct dev_pm_ops for power management in the button driver
      ACPI: Use struct dev_pm_ops for power management in the power driver
      ACPI: Use struct dev_pm_ops for power management in the SBS driver
      toshiba_acpi: Use struct dev_pm_ops for power management
      hp_accel: Use struct dev_pm_ops for power management
      sony-laptop: Use struct dev_pm_ops for power management
      panasonic-laptop: Use struct dev_pm_ops for power management
      toshiba_bluetooth: Use struct dev_pm_ops for power management
      xo15-ebook: Use struct dev_pm_ops for power management
      classmate-laptop: Use struct dev_pm_ops for power management
      fujitsu-tablet: Use struct dev_pm_ops for power management
      acpi_power_meter: Use struct dev_pm_ops for power management
      ACPI / PM: Do not execute legacy driver PM callbacks
      ACPI / PM: Drop legacy driver PM callbacks that are not used any more
      ACPI / PM: Drop PM callbacks from the ACPI bus type
      thinkpad_acpi: Drop pm_message_t arguments from suspend routines
      thinkpad_acpi: Use struct dev_pm_ops instead of legacy PM routines
      intel_ips: Remove empty legacy PM callbacks
      acer-wmi: Use struct dev_pm_ops for power management
      intel_mid_thermal: Use struct dev_pm_ops for power management
      sonypi: Use struct dev_pm_ops for power management
      PM / Sleep: Separate printing suspend times from initcall_debug
      PM / Domains: Use subsystem runtime suspend/resume callbacks by default
      PM / Domains: Do not stop devices after restoring their states
      hdaps: Use struct dev_pm_ops for power management
      PM / cpuidle: Add driver reference counter
      PM / Domains: Add preliminary support for cpuidle, v2
      PM / Domains: Add device domain data reference counter
      PM / Domains: Allow device callbacks to be added at any time
      msi-laptop: Use struct dev_pm_ops for power management
      mg_disk: Use struct dev_pm_ops for power management
      omap-rng: Use struct dev_pm_ops for power management
      PM / TPM: Drop unused pm_message_t argument from tpm_pm_suspend()
      tpm_atmel: Use struct dev_pm_ops for power management
      tpm_tis: Use struct dev_pm_ops for power management
      tpm_nsc: Use struct dev_pm_ops for power management
      PM / IPMI: Remove empty legacy PCI PM callbacks
      PM / crypto / ux500: Use struct dev_pm_ops for power management
      olpc-xo15-sci: Use struct dev_pm_ops for power management
      PM / Domains: Fix build warning for CONFIG_PM_RUNTIME unset
      PM / Sleep: Fix build warning in sysfs.c for CONFIG_PM_SLEEP unset
      PM / Sleep: Require CAP_BLOCK_SUSPEND to use wake_lock/wake_unlock

Sachin Kamat (5):
      PM / Domains: Add missing static storage class specifier in domain.c file
      PM / Domains: Replace plain integer with NULL pointer in domain.c file
      PM / Sleep: Add missing static storage class specifiers in main.c
      PM / QoS: Use NULL pointer instead of plain integer in pm_qos.h
      PM / QoS: Use NULL pointer instead of plain integer in qos.c

Sameer Nanda (1):
      PM / Sleep: add knob for printing device resume times

ShuoX Liu (1):
      cpuidle: move field disable from per-driver to per-cpu

Srivatsa S. Bhat (1):
      ftrace: Disable function tracing during suspend/resume and hibernation, again

Stephen Boyd (1):
      cpufreq: Fix sysfs deadlock with concurrent hotplug/frequency switch

