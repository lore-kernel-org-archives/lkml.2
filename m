Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874Ab2JOUkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:40:25 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52738 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab2JOUkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:40:18 -0400
Date: Mon, 15 Oct 2012 13:40:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
cc: Amit Daniel Kachhap <amit.kachhap@linaro.org>,
        Zhang Rui <rui.zhang@intel.com>, Viresh Kumar <viresh.linux@gmail.com>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: [patch for-3.7] thermal, cpufreq: Fix build when CPU_FREQ_TABLE
 isn't configured
Message-ID: <alpine.DEB.2.00.1210151333450.17947@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 02361418 ("thermal: add generic cpufreq cooling implementation") 
requires cpufreq_frequency_get_table(), but that function is only defined 
for CONFIG_CPU_FREQ_TABLE resulting in the following build error:

drivers/built-in.o: In function `cpufreq_get_max_state':
drivers/thermal/cpu_cooling.c:259: undefined reference to `cpufreq_frequency_get_table'
drivers/built-in.o: In function `get_cpu_frequency':
drivers/thermal/cpu_cooling.c:129: undefined reference to `cpufreq_frequency_get_table'

Fix it by selecting CONFIG_CPU_FREQ_TABLE for such a configuration.

It turns out CONFIG_EXYNOS_THERMAL also needs CONFIG_CPU_FREQ_TABLE, so 
select it there as well.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/thermal/Kconfig |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/thermal/Kconfig b/drivers/thermal/Kconfig
--- a/drivers/thermal/Kconfig
+++ b/drivers/thermal/Kconfig
@@ -22,6 +22,7 @@ config THERMAL_HWMON
 config CPU_THERMAL
 	bool "generic cpu cooling support"
 	depends on THERMAL && CPU_FREQ
+	select CPU_FREQ_TABLE
 	help
 	  This implements the generic cpu cooling mechanism through frequency
 	  reduction, cpu hotplug and any other ways of reducing temperature. An
@@ -50,6 +51,7 @@ config RCAR_THERMAL
 config EXYNOS_THERMAL
 	tristate "Temperature sensor on Samsung EXYNOS"
 	depends on (ARCH_EXYNOS4 || ARCH_EXYNOS5) && THERMAL
+	select CPU_FREQ_TABLE
 	help
 	  If you say yes here you get support for TMU (Thermal Managment
 	  Unit) on SAMSUNG EXYNOS series of SoC.
