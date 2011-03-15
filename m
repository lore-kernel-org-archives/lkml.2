Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab1COVTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:19:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36034 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932354Ab1COVTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:19:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] Power management updates for 2.6.39
Date: Tue, 15 Mar 2011 22:19:52 +0100
User-Agent: KMail/1.13.6 (Linux/2.6.38+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103152219.52694.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull power management updates for 2.6.39 from:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git for-linus

They include:

* Wakeup sources framework fixes.

* PM core modification preventing sysfs files related to wakeup from being
  created for devices that can't wake up the system.

* Reduction of the number of power management Kconfig options.

* Runtime PM framework modification allowing pm_runtime_suspend() to succeed
  during system suspend.

* Removal of pm_flags.

* Support for device power domains in the core PM code.

* PM core and runtime PM framework modification making them treat subsystems
  in a consistent way.

* Introduction of struct syscore_ops for implementing core subsystems'
  suspend/resume and shutdown operations without using sysdevs.

* Various PM-related fixes.


 Documentation/ABI/testing/sysfs-devices-power |   20 +-
 Documentation/power/devices.txt               |   94 +++++++---
 Documentation/power/runtime_pm.txt            |   13 +-
 Documentation/power/states.txt                |   12 +-
 arch/x86/kernel/apm_32.c                      |    5 +-
 arch/x86/xen/Kconfig                          |    2 +-
 drivers/acpi/Kconfig                          |    1 -
 drivers/acpi/bus.c                            |   23 +--
 drivers/acpi/sleep.c                          |    4 +-
 drivers/base/Makefile                         |    2 +-
 drivers/base/power/Makefile                   |    3 +-
 drivers/base/power/main.c                     |  175 ++++++++++---------
 drivers/base/power/opp.c                      |    2 +-
 drivers/base/power/power.h                    |   21 +--
 drivers/base/power/runtime.c                  |   37 +++--
 drivers/base/power/sysfs.c                    |   78 ++++++---
 drivers/base/power/trace.c                    |    6 +-
 drivers/base/power/wakeup.c                   |  109 ++++++++----
 drivers/base/syscore.c                        |  117 ++++++++++++
 drivers/net/e1000e/netdev.c                   |    8 +-
 drivers/net/pch_gbe/pch_gbe_main.c            |    2 +-
 drivers/pci/pci-driver.c                      |    4 +-
 drivers/scsi/Makefile                         |    2 +-
 drivers/scsi/scsi_priv.h                      |    2 +-
 drivers/scsi/scsi_sysfs.c                     |    2 +-
 drivers/usb/core/hcd-pci.c                    |    4 +-
 drivers/usb/core/hub.c                        |   10 +-
 include/acpi/acpi_bus.h                       |    2 +-
 include/linux/device.h                        |    1 +
 include/linux/pm.h                            |   19 +-
 include/linux/pm_runtime.h                    |    6 +
 include/linux/pm_wakeup.h                     |    8 +-
 include/linux/syscore_ops.h                   |   29 +++
 kernel/pm_qos_params.c                        |   24 +++
 kernel/power/Kconfig                          |  237 +++++++++++--------------
 kernel/power/hibernate.c                      |    9 +
 kernel/power/main.c                           |    3 -
 kernel/power/snapshot.c                       |    8 +-
 kernel/power/suspend.c                        |    4 +
 kernel/sys.c                                  |    4 +
 40 files changed, 691 insertions(+), 421 deletions(-)

---------------

Alexandre Courbot (1):
      PM: Documentation/power/states.txt: fix repetition

Jan Beulich (1):
      PM: Simplify kernel/power/Kconfig

Mandeep Singh Baines (1):
      PM: Use appropriate printk() priority level in trace.c

Nishanth Menon (1):
      PM / OPP: opp_find_freq_exact() documentation fix

Rafael J. Wysocki (16):
      PM / Wakeup: Combine atomic counters to avoid reordering issues
      PM / Wakeup: Make pm_save_wakeup_count() work as documented
      PM / Wakeup: Don't update events_check_enabled in pm_get_wakeup_count()
      USB / Hub: Do not call device_set_wakeup_capable() under spinlock
      PM: Do not create wakeup sysfs files for devices that cannot wake up
      PM / ACPI: Remove references to pm_flags from bus.c
      PM: Make CONFIG_PM depend on (CONFIG_PM_SLEEP || CONFIG_PM_RUNTIME)
      PM: Reorder power management Kconfig options
      PM: Remove CONFIG_PM_OPS
      PM: Clean up PM_TRACE dependencies and drop unnecessary Kconfig option
      PM: Allow pm_runtime_suspend() to succeed during system suspend
      PM: Drop pm_flags that is not necessary
      PM: Add support for device power domains
      PM: Make system-wide PM and runtime PM treat subsystems consistently
      PM / Core: Introduce struct syscore_ops for core subsystems PM
      PM / Hibernate: Reduce autotuned default image size

Thomas Renninger (1):
      PM QoS: Make pm_qos settings readable

