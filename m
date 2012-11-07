Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073Ab2KGKYJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:24:09 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:42808 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab2KGKYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:24:07 -0500
From: "hongbo.zhang" <hongbo.zhang@linaro.org>
To: linux-acpi@vger.kernel.org, rui.zhang@intel.com
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        amit.kachhap@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>
Subject: [PATCH V4 0/2] Upstream ST-Ericsson thermal driver
Date: Wed,  7 Nov 2012 18:23:00 +0800
Message-Id: <1352283782-16489-1-git-send-email-hongbo.zhang@linaro.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "hongbo.zhang" <hongbo.zhang@linaro.com>

V3->V4 Changes:

1. In previous patch set V3 "Fix thermal bugs and Upstream ST-Ericsson thermal
driver", there were 5 patches in total, since the first 3 for fixing thermal
layer bugs have been accepted by the maintainer, I'd like to send out the
updated last 2 only this time, for upstreaming ST-Ericsson thermal driver.

2. In patch "Thermal: Add ST-Ericsson DB8500 thermal driver"
  - typo in commit message: diver -> driver;
  - add more explanation of device tree properties are optional or required.
  - in function db8500_thermal_match_cdev: remove cdev_name, use
    trip_points->cdev_name[i] directly instead;
  - in function db8500_cdev_bind: move cdev->ops->get_max_state(cdev,
    &max_state) out of for loop to call it only once;
  - in function db8500_thermal_parse_dt: update checking strlen(tmp_str) >=
    THERMAL_NAME_LENGTH
  - add Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
  - add Reviewed-by: Francesco Lavra <francescolavra.fl@gmail.com>

3. In patch "Thermal: Add ST-Ericsson DB8500 thermal properties and platform
data"
  - add Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>

hongbo.zhang (2):
  Thermal: Add ST-Ericsson DB8500 thermal driver.
  Thermal: Add ST-Ericsson DB8500 thermal properties and platform data.

 .../devicetree/bindings/thermal/db8500-thermal.txt |  44 ++
 arch/arm/boot/dts/dbx5x0.dtsi                      |  14 +
 arch/arm/boot/dts/snowball.dts                     |  31 ++
 arch/arm/configs/u8500_defconfig                   |   2 +
 arch/arm/mach-ux500/board-mop500.c                 |  64 +++
 drivers/thermal/Kconfig                            |  20 +
 drivers/thermal/Makefile                           |   2 +
 drivers/thermal/db8500_cpufreq_cooling.c           | 108 +++++
 drivers/thermal/db8500_thermal.c                   | 530 +++++++++++++++++++++
 include/linux/platform_data/db8500_thermal.h       |  38 ++
 10 files changed, 853 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/thermal/db8500-thermal.txt
 create mode 100644 drivers/thermal/db8500_cpufreq_cooling.c
 create mode 100644 drivers/thermal/db8500_thermal.c
 create mode 100644 include/linux/platform_data/db8500_thermal.h

-- 
1.7.11.3

