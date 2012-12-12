Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab2LLE5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 23:57:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:35476 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754276Ab2LLE5T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 23:57:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,264,1355126400"; 
   d="scan'208";a="262795584"
Message-ID: <1355288236.2317.17.camel@rzhang1-mobl4>
Subject: [GIT PULL] thermal management updates for v3.8-rc1
From: Zhang Rui <rui.zhang@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 12 Dec 2012 12:57:16 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git release

to receive thermal management updates for v3.8.

Highlights:

* Introduction of thermal policy support, together with three new
  thermal governors, including step_wise, user_space, fire_share.

* Introduction of ST-Ericsson db8500_thermal driver and ST-Ericsson
  db8500_cpufreq_cooling driver.

* Thermal Kconfig file and Makefile refactor.

* Fixes for generic cpucooling, rcar thermal driver and Exynos thermal
  driver.

thanks,
rui

The following changes since commit
3d70f8c617a436c7146ecb81df2265b4626dfe89:

  Linux 3.7-rc4 (2012-11-04 11:07:39 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git release

Durgadoss R (16):
      Thermal: Refactor thermal.h file
      Thermal: Move thermal_instance to thermal_core.h
      Thermal: Add get trend, get instance API's to thermal_sys
      Thermal: Add platform level information to thermal.h
      Thermal: Pass zone parameters as argument to tzd_register
      Thermal: Add thermal governor registration APIs
      Thermal: Add a policy sysfs attribute
      Thermal: Update binding logic based on platform data
      Thermal: Make thermal_cdev_update as a global function
      Thermal: Introduce fair_share thermal governor
      Thermal: Introduce a step_wise thermal governor
      Thermal: Add a thermal notifier for user space
      Thermal: Remove throttling logic out of thermal_sys.c
      Thermal: Add a notification API
      Thermal: Add documentation for platform layer data
      Thermal: Provide option to choose default thermal governor

Eduardo Valentin (2):
      thermal: cpu cooling: use const parameter while registering
      thermal: cpu cooling: allow module builds

Hugh Dickins (1):
      Thermal: Fix oops and unlocking in thermal_sys.c

Kuninori Morimoto (3):
      thermal: rcar_thermal: remove explicitly used devm_kfree/iounap()
      thermal: rcar: fixup the unit of temperature
      thermal: rcar: add rcar_zone_to_priv() macro

Sachin Kamat (4):
      thermal: step_wise: Add missing static storage class specifiers
      thermal: fair_share: Add missing static storage class specifiers
      thermal: user_space: Add missing static storage class specifiers
      thermal: cpu_cooling: Make 'notify_device' static

Zhang Rui (3):
      Refactor drivers/thermal/Kconfig
      Exynos: Add missing dependency
      drivers/thermal/Makefile refactor

hongbo.zhang (5):
      Thermal: add indent for code alignment.
      Thermal: fix bug of counting cpu frequencies.
      Thermal: Remove the cooling_cpufreq_list.
      Thermal: Add ST-Ericsson DB8500 thermal driver.
      Thermal: Add ST-Ericsson DB8500 thermal properties and platform
data.

 .../devicetree/bindings/thermal/db8500-thermal.txt |   44 ++
 Documentation/thermal/sysfs-api.txt                |   64 ++
 arch/arm/boot/dts/dbx5x0.dtsi                      |   14 +
 arch/arm/boot/dts/snowball.dts                     |   31 +
 arch/arm/configs/u8500_defconfig                   |    2 +
 arch/arm/mach-ux500/board-mop500.c                 |   64 ++
 drivers/acpi/thermal.c                             |    6 +-
 drivers/platform/x86/acerhdf.c                     |    2 +-
 drivers/platform/x86/intel_mid_thermal.c           |    2 +-
 drivers/power/power_supply_core.c                  |    2 +-
 drivers/staging/omap-thermal/omap-thermal-common.c |    2 +-
 drivers/thermal/Kconfig                            |   82 +++-
 drivers/thermal/Makefile                           |   17 +-
 drivers/thermal/cpu_cooling.c                      |  107 +---
 drivers/thermal/db8500_cpufreq_cooling.c           |  108 +++
 drivers/thermal/db8500_thermal.c                   |  531
+++++++++++++++
 drivers/thermal/exynos_thermal.c                   |    2 +-
 drivers/thermal/fair_share.c                       |  133 ++++
 drivers/thermal/rcar_thermal.c                     |   27 +-
 drivers/thermal/spear_thermal.c                    |    2 +-
 drivers/thermal/step_wise.c                        |  194 ++++++
 drivers/thermal/thermal_core.h                     |   53 ++
 drivers/thermal/thermal_sys.c                      |  700
+++++++++++++-------
 drivers/thermal/user_space.c                       |   68 ++
 include/linux/cpu_cooling.h                        |    6 +-
 include/linux/platform_data/db8500_thermal.h       |   38 ++
 include/linux/thermal.h                            |  128 +++-
 27 files changed, 2031 insertions(+), 398 deletions(-)
 create mode 100644
Documentation/devicetree/bindings/thermal/db8500-thermal.txt
 create mode 100644 drivers/thermal/db8500_cpufreq_cooling.c
 create mode 100644 drivers/thermal/db8500_thermal.c
 create mode 100644 drivers/thermal/fair_share.c
 create mode 100644 drivers/thermal/step_wise.c
 create mode 100644 drivers/thermal/thermal_core.h
 create mode 100644 drivers/thermal/user_space.c
 create mode 100644 include/linux/platform_data/db8500_thermal.h


