Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab3AGXrg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 18:47:36 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34436 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab3AGXrd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 18:47:33 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management fixes for v3.8-rc3
Date: Tue, 08 Jan 2013 00:53:14 +0100
Message-ID: <1839593.9xn3VhCMTU@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc2+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-for-3.8-rc3

to receive ACPI and power management fixes for v3.8-rc3 with top-most commit
f67ffa95836b31be5d8fe336aee3bfc6412c5696

  Merge branch 'pm-sleep'

on top of commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed

  Linux 3.8-rc2

Included are:

* Removal of some ACPICA code that the kernel will never use from Lv Zheng.

* APEI fix for erst_dbg_read() return value when persistent store is empty
  initially from Adrian Huang.

* Removal of some unnecessary code from ACPI memory hotplug driver from
  Liu Jinsong.

* ACPI power management fixes preventing useless messages from being printed
  and correcting acpi_bus_get_device() result check.

* ACPI debug code fix to prevent some debug messages from being printed
  with levels greater than KERN_DEBUG from Joe Perches.

* ACPI namespace scanning code fix to make system bus device nodes (like _SB)
  get the right names (-stable material).

* PNP resources handling fixes from Witold Szczeponik.

* cpuidle fix for a recent regression stalling boot on systems with great
  numbers (like hundreds) of CPUs from Daniel Lezcano.

* cpuidle fixes (one of them being -stable material) from Sivaram Nair.

* intel_idle debug message fix from Youquan Song.

* cpufreq build regression fix from Larry Finger.

* cpufreq fix for an obscure initialization race related to statistics from
  Konstantin Khlebnikov.

* cpufreq change disabling the Longhaul driver by default (which apparently
  is hopless to debug and fix) from Rafał Bilski.

* PM core fix preventing device suspend errors from happening during system
  suspend due to obscure race conditions (-stable material).

* PM QoS local variable name cleanup.

Thanks!


 Documentation/power/runtime_pm.txt |   9 +-
 drivers/acpi/acpi_memhotplug.c     |  18 --
 drivers/acpi/acpica/Makefile       |   2 +-
 drivers/acpi/acpica/utclib.c       | 749 ---------------------------------------------
 drivers/acpi/apei/erst-dbg.c       |  11 +-
 drivers/acpi/device_pm.c           |   3 +-
 drivers/acpi/glue.c                |   9 +-
 drivers/acpi/power.c               |  11 +-
 drivers/acpi/scan.c                |   2 +-
 drivers/base/power/main.c          |   9 +-
 drivers/base/power/qos.c           |  10 +-
 drivers/cpufreq/Kconfig            |   5 +
 drivers/cpufreq/Makefile           |   5 +-
 drivers/cpufreq/cpufreq_stats.c    |  11 +-
 drivers/cpufreq/longhaul.c         |  10 +-
 drivers/cpuidle/coupled.c          |   2 +-
 drivers/cpuidle/cpuidle.c          |   2 +-
 drivers/cpuidle/driver.c           |   8 +-
 drivers/cpuidle/governors/menu.c   |   2 +-
 drivers/idle/intel_idle.c          |   2 +-
 drivers/pnp/interface.c            | 105 ++++---
 drivers/pnp/manager.c              |  25 +-
 22 files changed, 154 insertions(+), 856 deletions(-)

---------------

Adrian Huang (1):
      ACPI / APEI: Fix the returned value in erst_dbg_read

Daniel Lezcano (1):
      cpuidle: fix lock contention in the idle path

Joe Perches (1):
      ACPI / glue: Update DBG macro to include KERN_DEBUG

Konstantin Khlebnikov (1):
      cpufreq / stats: fix race between stats allocation and first usage

Larry Finger (1):
      cpufreq / governor: Fix problem with cpufreq_ondemand or cpufreq_conservative

Liu Jinsong (1):
      ACPI / memhotplug: remove redundant logic of acpi memory hotadd

Lv Zheng (1):
      ACPICA: Remove useless mini-C library.

Rafael J. Wysocki (5):
      ACPI / PM: Do not apply ACPI_SUCCESS() to acpi_bus_get_device() result
      ACPI / power: Remove useless message from device registering routine
      ACPI / scan: Do not use dummy HID for system bus ACPI nodes
      PM / QoS: Rename local variable in dev_pm_qos_add_ancestor_request()
      PM: Move disabling/enabling runtime PM to late suspend/early resume

Rafał Bilski (1):
      cpufreq / Longhaul: Disable driver by default

Sivaram Nair (2):
      cpuidle: Fix finding state with min power_usage
      cpuidle / coupled: fix ready counter decrement

Witold Szczeponik (2):
      PNP: Simplify setting of resources
      PNP: Handle IORESOURCE_BITS in resource allocation

Youquan Song (1):
      intel_idle: pr_debug information need separated


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
