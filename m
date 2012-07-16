Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943Ab2GPUkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 16:40:31 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42963 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752845Ab2GPUk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 16:40:27 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: LKML <linux-kernel@vger.kernel.org>
Subject: PM: Summary of changes for v3.6
Date: Mon, 16 Jul 2012 22:46:03 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207162246.03660.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

All of the changes I'd like to include into the first PM pull request during
the v3.6 merge window, except maybe for one or two patches I know are in the
works, is on the 'linux-next' branch of the linux-pm.git tree now.  The summary
of those changes is appended.  If anyone finds any of them objectionable,
please let me know ASAP.  Also please let me know if you have any power
management patches you'd like me to take for v3.6.

Thanks,
Rafael

---

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
 drivers/base/dd.c                        |   6 +-
 drivers/base/power/domain.c              | 342 ++++++++++++++++++++++++-------
 drivers/base/power/main.c                |   8 +-
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
 include/linux/suspend.h                  |   6 +
 kernel/power/Kconfig                     |   4 +-
 kernel/power/hibernate.c                 |  42 ++++
 kernel/power/main.c                      |  45 ++++
 kernel/power/power.h                     |   3 +
 kernel/power/suspend.c                   |   3 +
 kernel/power/swap.c                      |  82 +++++---
 61 files changed, 828 insertions(+), 466 deletions(-)

---------------

Bojan Smojver (2):
      PM / Hibernate: Enable suspend to both for in-kernel hibernation.
      PM / Hibernate: Print hibernation/thaw progress indicator one line at a time.

Daniel Lezcano (4):
      ACPI: intel_idle : break dependency between modules
      cpuidle / ACPI : remove latency_ticks from acpi_processor_cx structure
      cpuidle / ACPI: remove usage from acpi_processor_cx structure
      cpuilde / ACPI: remove time from acpi_processor_cx structure

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
      PM / Runtime: Do not increment device usage counts before probing

Sachin Kamat (2):
      PM / Domains: Add missing static storage class specifier in domain.c file
      PM / Domains: Replace plain integer with NULL pointer in domain.c file

Sameer Nanda (1):
      PM / Sleep: add knob for printing device resume times

ShuoX Liu (1):
      cpuidle: move field disable from per-driver to per-cpu

Srivatsa S. Bhat (1):
      ftrace: Disable function tracing during suspend/resume and hibernation, again

