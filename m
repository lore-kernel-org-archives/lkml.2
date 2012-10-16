Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab2JPLpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 07:45:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:60770 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab2JPLpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 07:45:54 -0400
From: "hongbo.zhang" <hongbo.zhang@linaro.org>
To: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Cc: patches@linaro.org, linaro-kernel@lists.linaro.org,
        STEricsson_nomadik_linux@list.st.com, kernel@igloocommunity.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>
Subject: [PATCH 0/5] Fix thermal bugs and Upstream ST-Ericsson thermal driver
Date: Tue, 16 Oct 2012 19:44:44 +0800
Message-Id: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "hongbo.zhang" <hongbo.zhang@linaro.com>

Hi all,
This patch set is to upstream ST-Ericsson thermal driver and fix some bugs
of thermal layer at the same time.
All of these patches are based on v3.7-rc1.


[PATCH 1/5] Thermal: do bind operation after thermal zone or cooling
 device register returns.

In the previous bind function, cdev->get_max_state(cdev, &max_state) is called
before the registration function finishes, but at this moment, the parameter
cdev at thermal driver layer isn't ready--it will get ready only after its
registration, so the the get_max_state callback cannot tell the max_state
according to the cdev input.
This problem can be fixed by separating the bind operation out of registration
and doing it when registration completely finished.

There is no such problem with the current exynos thermal driver because it 
regsters cooling device before thermal zone device. As a generic thermal layer
any sequence should be supported, thermal zone first or cooling device first,
this will be also helpful to add/remove cooling device dynamically.


[PATCH 2/5] Thermal: add indent for code alignment.
[PATCH 3/5] Thermal: fix empty list checking method.
[PATCH 4/5] Thermal: make sure cpufreq cooling register after
 cpufreq driver

Bug fix for generic cpufreq cooling layer as described in the commit logs.


[PATCH 5/5] Thermal: Add ST-Ericsson db8500 thermal dirver.

This patch is to add ST-Ericsson into the latest kervel version.


hongbo.zhang (5):
  Thermal: do bind operation after thermal zone or cooling device
    register returns.
  Thermal: add indent for code alignment.
  Thermal: fix empty list checking method.
  Thermal: make sure cpufreq cooling register after cpufreq driver
  Thermal: Add ST-Ericsson db8500 thermal dirver.

 arch/arm/boot/dts/dbx5x0.dtsi                |  11 +
 arch/arm/configs/u8500_defconfig             |   4 +
 arch/arm/mach-ux500/board-mop500.c           |  73 ++++
 drivers/thermal/Kconfig                      |  20 ++
 drivers/thermal/Makefile                     |   2 +
 drivers/thermal/cpu_cooling.c                |  19 +-
 drivers/thermal/db8500_cpufreq_cooling.c     | 118 +++++++
 drivers/thermal/db8500_thermal.c             | 507 +++++++++++++++++++++++++++
 drivers/thermal/thermal_sys.c                |  86 +++--
 include/linux/platform_data/db8500_thermal.h |  39 +++
 10 files changed, 847 insertions(+), 32 deletions(-)
 create mode 100644 drivers/thermal/db8500_cpufreq_cooling.c
 create mode 100644 drivers/thermal/db8500_thermal.c
 create mode 100644 include/linux/platform_data/db8500_thermal.h

-- 
1.7.11.3

