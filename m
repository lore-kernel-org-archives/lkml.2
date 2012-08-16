Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab2HPLmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 07:42:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41063 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2HPLmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 07:42:06 -0400
From: Amit Daniel Kachhap <amit.kachhap@linaro.org>
To: linux-pm@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, lm-sensors@lm-sensors.org,
        amit.kachhap@linaro.org
Subject: [PATCH v6 0/6] thermal: Add kernel thermal support for exynos platform
Date: Thu, 16 Aug 2012 17:11:39 +0530
Message-Id: <1345117305-8299-1-git-send-email-amit.kachhap@linaro.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew/Zhang/Len,

This current patchset is based on 3.6-rc1 and Zhang Rui's core thermal
enhancement patches(http://permalink.gmane.org/gmane.linux.acpi.devel/54564).

Version V5 is present in linux-next tree. Since Zhang Rui's implementation are
already present in linux-next so requesting Andrew to add this V6 series and drop
earlier V5 version.

Changes since v5:
This patchset basically simplifies the cpufreq cooling API's to take just
cpumask as an input parameter and also removes the state management logic as they
are now taken care in the core thermal layer.

All these patches over Zhang Rui's work can be found in the git link
git://git.linaro.org/people/amitdanielk/linux.git exynos_v6_thermal_tree

Thanks,
Amit Daniel

Amit Daniel Kachhap (6):
  thermal: add generic cpufreq cooling implementation
  hwmon: exynos4: move thermal sensor driver to driver/thermal
    directory
  thermal: exynos5: add exynos5250 thermal sensor driver support
  thermal: exynos: register the tmu sensor with the kernel thermal
    layer
  ARM: exynos: add thermal sensor driver platform data support
  thermal: exynos: Use devm_* functions

 Documentation/hwmon/exynos4_tmu              |   81 ---
 Documentation/thermal/cpu-cooling-api.txt    |   52 ++
 Documentation/thermal/exynos_thermal         |   52 ++
 drivers/hwmon/Kconfig                        |   10 -
 drivers/hwmon/Makefile                       |    1 -
 drivers/hwmon/exynos4_tmu.c                  |  518 --------------
 drivers/thermal/Kconfig                      |   18 +
 drivers/thermal/Makefile                     |    2 +
 drivers/thermal/cpu_cooling.c                |  512 +++++++++++++
 drivers/thermal/exynos_thermal.c             |  994 ++++++++++++++++++++++++++
 include/linux/cpu_cooling.h                  |   79 ++
 include/linux/platform_data/exynos4_tmu.h    |   83 ---
 include/linux/platform_data/exynos_thermal.h |  116 +++
 13 files changed, 1825 insertions(+), 693 deletions(-)
 delete mode 100644 Documentation/hwmon/exynos4_tmu
 create mode 100644 Documentation/thermal/cpu-cooling-api.txt
 create mode 100644 Documentation/thermal/exynos_thermal
 delete mode 100644 drivers/hwmon/exynos4_tmu.c
 create mode 100644 drivers/thermal/cpu_cooling.c
 create mode 100644 drivers/thermal/exynos_thermal.c
 create mode 100644 include/linux/cpu_cooling.h
 delete mode 100644 include/linux/platform_data/exynos4_tmu.h
 create mode 100644 include/linux/platform_data/exynos_thermal.h

