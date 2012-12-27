Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab2L0OsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 09:48:16 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:9122 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab2L0OsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 09:48:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 27 Dec 2012 06:45:58 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@wwwdotorg.org>, <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH v2 02/11] arm: tegra: Move tegra_cpu_car.h to linux/clk/tegra.h
Date: Thu, 27 Dec 2012 20:17:15 +0530
Message-ID: <1356619644-18565-3-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com>
References: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tegra_cpu_car_ops struct is going to be accessed from drivers/clk/tegra.
Move the tegra_cpu_car_ops to include/linux/clk/tegra.h.

Signed-off-by: Prashant Gaikwad <pgaikwad@nvidia.com>
---
 arch/arm/mach-tegra/clock.c                        |    2 +-
 arch/arm/mach-tegra/cpuidle-tegra30.c              |    2 +-
 arch/arm/mach-tegra/hotplug.c                      |    2 +-
 arch/arm/mach-tegra/platsmp.c                      |    2 +-
 arch/arm/mach-tegra/pm.c                           |    2 +-
 arch/arm/mach-tegra/tegra20_clocks.c               |    2 +-
 arch/arm/mach-tegra/tegra20_clocks_data.c          |    2 +-
 arch/arm/mach-tegra/tegra30_clocks.c               |    2 +-
 arch/arm/mach-tegra/tegra30_clocks_data.c          |    2 +-
 .../tegra_cpu_car.h => include/linux/clk/tegra.h   |    6 +++---
 10 files changed, 12 insertions(+), 12 deletions(-)
 rename arch/arm/mach-tegra/tegra_cpu_car.h => include/linux/clk/tegra.h (96%)

diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
index 867bf8b..8c0ff06 100644
--- a/arch/arm/mach-tegra/clock.c
+++ b/arch/arm/mach-tegra/clock.c
@@ -26,10 +26,10 @@
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/clk/tegra.h>
 
 #include "board.h"
 #include "clock.h"
-#include "tegra_cpu_car.h"
 
 /* Global data of Tegra CPU CAR ops */
 struct tegra_cpu_car_ops *tegra_cpu_car_ops;
diff --git a/arch/arm/mach-tegra/cpuidle-tegra30.c b/arch/arm/mach-tegra/cpuidle-tegra30.c
index 5e8cbf5..0b8c667 100644
--- a/arch/arm/mach-tegra/cpuidle-tegra30.c
+++ b/arch/arm/mach-tegra/cpuidle-tegra30.c
@@ -24,6 +24,7 @@
 #include <linux/cpuidle.h>
 #include <linux/cpu_pm.h>
 #include <linux/clockchips.h>
+#include <linux/clk/tegra.h>
 
 #include <asm/cpuidle.h>
 #include <asm/proc-fns.h>
@@ -32,7 +33,6 @@
 
 #include "pm.h"
 #include "sleep.h"
-#include "tegra_cpu_car.h"
 
 #ifdef CONFIG_PM_SLEEP
 static int tegra30_idle_lp2(struct cpuidle_device *dev,
diff --git a/arch/arm/mach-tegra/hotplug.c b/arch/arm/mach-tegra/hotplug.c
index dca5141..2faea56 100644
--- a/arch/arm/mach-tegra/hotplug.c
+++ b/arch/arm/mach-tegra/hotplug.c
@@ -10,12 +10,12 @@
  */
 #include <linux/kernel.h>
 #include <linux/smp.h>
+#include <linux/clk/tegra.h>
 
 #include <asm/cacheflush.h>
 #include <asm/smp_plat.h>
 
 #include "sleep.h"
-#include "tegra_cpu_car.h"
 
 static void (*tegra_hotplug_shutdown)(void);
 
diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
index 1b926df..dec6704 100644
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -18,6 +18,7 @@
 #include <linux/jiffies.h>
 #include <linux/smp.h>
 #include <linux/io.h>
+#include <linux/clk/tegra.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/gic.h>
@@ -29,7 +30,6 @@
 #include "fuse.h"
 #include "flowctrl.h"
 #include "reset.h"
-#include "tegra_cpu_car.h"
 
 #include "common.h"
 #include "iomap.h"
diff --git a/arch/arm/mach-tegra/pm.c b/arch/arm/mach-tegra/pm.c
index 1b11707..db44cd5 100644
--- a/arch/arm/mach-tegra/pm.c
+++ b/arch/arm/mach-tegra/pm.c
@@ -24,6 +24,7 @@
 #include <linux/cpu_pm.h>
 #include <linux/clk.h>
 #include <linux/err.h>
+#include <linux/clk/tegra.h>
 
 #include <asm/smp_plat.h>
 #include <asm/cacheflush.h>
@@ -36,7 +37,6 @@
 #include "reset.h"
 #include "flowctrl.h"
 #include "sleep.h"
-#include "tegra_cpu_car.h"
 
 #define TEGRA_POWER_CPU_PWRREQ_OE	(1 << 16)  /* CPU pwr req enable */
 
diff --git a/arch/arm/mach-tegra/tegra20_clocks.c b/arch/arm/mach-tegra/tegra20_clocks.c
index 4eb6bc8..1a80ff6 100644
--- a/arch/arm/mach-tegra/tegra20_clocks.c
+++ b/arch/arm/mach-tegra/tegra20_clocks.c
@@ -26,12 +26,12 @@
 #include <linux/io.h>
 #include <linux/clkdev.h>
 #include <linux/clk.h>
+#include <linux/clk/tegra.h>
 
 #include "clock.h"
 #include "fuse.h"
 #include "iomap.h"
 #include "tegra2_emc.h"
-#include "tegra_cpu_car.h"
 
 #define RST_DEVICES			0x004
 #define RST_DEVICES_SET			0x300
diff --git a/arch/arm/mach-tegra/tegra20_clocks_data.c b/arch/arm/mach-tegra/tegra20_clocks_data.c
index a23a073..022cdae 100644
--- a/arch/arm/mach-tegra/tegra20_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra20_clocks_data.c
@@ -26,12 +26,12 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/clk.h>
+#include <linux/clk/tegra.h>
 
 #include "clock.h"
 #include "fuse.h"
 #include "tegra2_emc.h"
 #include "tegra20_clocks.h"
-#include "tegra_cpu_car.h"
 
 /* Clock definitions */
 
diff --git a/arch/arm/mach-tegra/tegra30_clocks.c b/arch/arm/mach-tegra/tegra30_clocks.c
index d714777..4330787 100644
--- a/arch/arm/mach-tegra/tegra30_clocks.c
+++ b/arch/arm/mach-tegra/tegra30_clocks.c
@@ -28,6 +28,7 @@
 #include <linux/clk.h>
 #include <linux/cpufreq.h>
 #include <linux/syscore_ops.h>
+#include <linux/clk/tegra.h>
 
 #include <asm/clkdev.h>
 
@@ -36,7 +37,6 @@
 #include "clock.h"
 #include "fuse.h"
 #include "iomap.h"
-#include "tegra_cpu_car.h"
 
 #define USE_PLL_LOCK_BITS 0
 
diff --git a/arch/arm/mach-tegra/tegra30_clocks_data.c b/arch/arm/mach-tegra/tegra30_clocks_data.c
index 6942c7a..ee01711 100644
--- a/arch/arm/mach-tegra/tegra30_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra30_clocks_data.c
@@ -28,11 +28,11 @@
 #include <linux/io.h>
 #include <linux/clk.h>
 #include <linux/cpufreq.h>
+#include <linux/clk/tegra.h>
 
 #include "clock.h"
 #include "fuse.h"
 #include "tegra30_clocks.h"
-#include "tegra_cpu_car.h"
 
 #define DEFINE_CLK_TEGRA(_name, _rate, _ops, _flags,		\
 		   _parent_names, _parents, _parent)		\
diff --git a/arch/arm/mach-tegra/tegra_cpu_car.h b/include/linux/clk/tegra.h
similarity index 96%
rename from arch/arm/mach-tegra/tegra_cpu_car.h
rename to include/linux/clk/tegra.h
index 9764d31..0977f2a 100644
--- a/arch/arm/mach-tegra/tegra_cpu_car.h
+++ b/include/linux/clk/tegra.h
@@ -14,8 +14,8 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
-#ifndef __MACH_TEGRA_CPU_CAR_H
-#define __MACH_TEGRA_CPU_CAR_H
+#ifndef __LINUX_CLK_TEGRA_H_
+#define __LINUX_CLK_TEGRA_H_
 
 /*
  * Tegra CPU clock and reset control ops
@@ -121,4 +121,4 @@ static inline void tegra_cpu_clock_resume(void)
 void tegra20_cpu_car_ops_init(void);
 void tegra30_cpu_car_ops_init(void);
 
-#endif /* __MACH_TEGRA_CPU_CAR_H */
+#endif /* __LINUX_CLK_TEGRA_H_ */
-- 
1.7.4.1

