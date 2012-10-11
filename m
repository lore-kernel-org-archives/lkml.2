Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859Ab2JKDQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 23:16:56 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:48648 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753448Ab2JKDQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 23:16:54 -0400
Message-ID: <50763A23.3010507@kernel.org>
Date: Wed, 10 Oct 2012 23:16:51 -0400
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ACPI & Thermal patches for 3.7-merge
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these ACPI & Thermal patches.

The generic Linux thermal layer is gaining some
new capabilities (generic cooling via cpufreq)
and some new customers (ARM).

Also, an ACPI EC bug fix plus a regression fix.

thanks!
Len Brown, Intel Open Source Technology Center

The following changes since commit f5a246eab9a268f51ba8189ea5b098a1bfff200e:

  Merge tag 'sound-3.7' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound (2012-10-09 07:07:14 +0900)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git release

for you to fetch changes up to d1d4a81b842db21b144ffd2334ca5eee3eb740f3:

  Merge branches 'fixes-for-37', 'ec' and 'thermal' into release (2012-10-09 01:47:35 -0400)

----------------------------------------------------------------

Amit Daniel Kachhap (6):
      thermal: add generic cpufreq cooling implementation
      hwmon: exynos4: move thermal sensor driver to driver/thermal directory
      thermal: exynos5: add exynos5250 thermal sensor driver support
      thermal: exynos: register the tmu sensor with the kernel thermal layer
      ARM: exynos: add thermal sensor driver platform data support
      thermal: exynos: Use devm_* functions

Eduardo Valentin (1):
      Fix a build error.

Feng Tang (2):
      ACPI: EC: Make the GPE storm threshold a module parameter
      ACPI: EC: Add a quirk for CLEVO M720T/M730T laptop

Guenter Roeck (2):
      thermal: fix potential out-of-bounds memory access
      thermal: Fix potential NULL pointer accesses

Jonghwa Lee (1):
      Thermal: Fix bug on cpu_cooling, cooling device's id conflict problem.

Kuninori Morimoto (1):
      thermal: add Renesas R-Car thermal sensor support

Len Brown (2):
      Merge branch 'release' of git://git.kernel.org/.../rzhang/linux into thermal
      Merge branches 'fixes-for-37', 'ec' and 'thermal' into release

Sachin Kamat (1):
      thermal: Exynos: Fix NULL pointer dereference in exynos_unregister_thermal()

Srivatsa S. Bhat (1):
      ACPI idle, CPU hotplug: Fix NULL pointer dereference during hotplug

Wei Yongjun (2):
      cpuidle / ACPI: fix potential NULL pointer dereference
      tools/power/acpi/acpidump: remove duplicated include from acpidump.c

Zhang Rui (13):
      Thermal: Introduce multiple cooling states support
      Thermal: Introduce cooling states range support
      Thermal: set upper and lower limits
      Thermal: Introduce .get_trend() callback.
      Thermal: Remove tc1/tc2 in generic thermal layer.
      Thermal: Introduce thermal_zone_trip_update()
      Thermal: rename structure thermal_cooling_device_instance to thermal_instance
      Thermal: Rename thermal_zone_device.cooling_devices
      Thermal: Rename thermal_instance.node to thermal_instance.tz_node.
      Thermal: List thermal_instance in thermal_cooling_device.
      Thermal: Introduce simple arbitrator for setting device cooling state
      Thermal: Unify the code for both active and passive cooling
      Thermal: Introduce locking for cdev.thermal_instances list.

 Documentation/thermal/cpu-cooling-api.txt          |  32 +
 .../{hwmon/exynos4_tmu => thermal/exynos_thermal}  |  35 +-
 Documentation/thermal/sysfs-api.txt                |   9 +-
 drivers/acpi/ec.c                                  |  30 +-
 drivers/acpi/processor_idle.c                      |   3 +-
 drivers/acpi/thermal.c                             |  93 +-
 drivers/cpuidle/cpuidle.c                          |   2 +-
 drivers/hwmon/Kconfig                              |  10 -
 drivers/hwmon/Makefile                             |   1 -
 drivers/hwmon/exynos4_tmu.c                        | 518 -----------
 drivers/platform/x86/acerhdf.c                     |   5 +-
 drivers/platform/x86/intel_mid_thermal.c           |   2 +-
 drivers/power/power_supply_core.c                  |   2 +-
 drivers/staging/omap-thermal/omap-thermal-common.c |   5 +-
 drivers/thermal/Kconfig                            |  26 +
 drivers/thermal/Makefile                           |   5 +-
 drivers/thermal/cpu_cooling.c                      | 449 ++++++++++
 drivers/thermal/exynos_thermal.c                   | 997 +++++++++++++++++++++
 drivers/thermal/rcar_thermal.c                     | 260 ++++++
 drivers/thermal/spear_thermal.c                    |   2 +-
 drivers/thermal/thermal_sys.c                      | 321 ++++---
 include/linux/cpu_cooling.h                        |  58 ++
 .../{exynos4_tmu.h => exynos_thermal.h}            |  47 +-
 include/linux/thermal.h                            |  28 +-
 tools/power/acpi/acpidump.c                        |   1 -
 25 files changed, 2205 insertions(+), 736 deletions(-)
 create mode 100644 Documentation/thermal/cpu-cooling-api.txt
 rename Documentation/{hwmon/exynos4_tmu => thermal/exynos_thermal} (71%)
 delete mode 100644 drivers/hwmon/exynos4_tmu.c
 create mode 100644 drivers/thermal/cpu_cooling.c
 create mode 100644 drivers/thermal/exynos_thermal.c
 create mode 100644 drivers/thermal/rcar_thermal.c
 create mode 100644 include/linux/cpu_cooling.h
 rename include/linux/platform_data/{exynos4_tmu.h => exynos_thermal.h} (64%)
