Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127Ab2LWLID (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 06:08:03 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:19774 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215Ab2LWLHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 06:07:49 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Sun, 23 Dec 2012 03:04:57 -0800
From: Prashant Gaikwad <pgaikwad@nvidia.com>
To: <swarren@wwwdotorg.org>, <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-tegra@vger.kernel.org>, Prashant Gaikwad <pgaikwad@nvidia.com>
Subject: [PATCH 02/11] arm: tegra: Move tegra_cpu_car.h to linux/clk/tegra.h
Date: Sun, 23 Dec 2012 16:35:42 +0530
Message-ID: <1356260751-3667-3-git-send-email-pgaikwad@nvidia.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1356260751-3667-1-git-send-email-pgaikwad@nvidia.com>
References: <1356260751-3667-1-git-send-email-pgaikwad@nvidia.com>
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
 arch/arm/mach-tegra/hotplug.c                      |    2 +-
 arch/arm/mach-tegra/platsmp.c                      |    2 +-
 arch/arm/mach-tegra/tegra20_clocks.c               |    2 +-
 arch/arm/mach-tegra/tegra20_clocks_data.c          |    2 +-
 arch/arm/mach-tegra/tegra30_clocks.c               |    2 +-
 arch/arm/mach-tegra/tegra30_clocks_data.c          |    2 +-
 .../tegra_cpu_car.h => include/linux/clk/tegra.h   |    6 +++---
 8 files changed, 10 insertions(+), 10 deletions(-)
 rename arch/arm/mach-tegra/tegra_cpu_car.h => include/linux/clk/tegra.h (95%)

diff --git a/arch/arm/mach-tegra/clock.c b/arch/arm/mach-tegra/clock.c
index fd82085..59f25d2 100644
--- a/arch/arm/mach-tegra/clock.c
+++ b/arch/arm/mach-tegra/clock.c
@@ -26,12 +26,12 @@
 #include <linux/sched.h>
 #include <linux/seq_file.h>
 #include <linux/slab.h>
+#include <linux/clk/tegra.h>
 
 #include <mach/clk.h>
 
 #include "board.h"
 #include "clock.h"
-#include "tegra_cpu_car.h"
 
 /* Global data of Tegra CPU CAR ops */
 struct tegra_cpu_car_ops *tegra_cpu_car_ops;
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
index 81cb265..00a4124 100644
--- a/arch/arm/mach-tegra/platsmp.c
+++ b/arch/arm/mach-tegra/platsmp.c
@@ -18,6 +18,7 @@
 #include <linux/jiffies.h>
 #include <linux/smp.h>
 #include <linux/io.h>
+#include <linux/clk/tegra.h>
 
 #include <asm/cacheflush.h>
 #include <asm/hardware/gic.h>
@@ -31,7 +32,6 @@
 #include "fuse.h"
 #include "flowctrl.h"
 #include "reset.h"
-#include "tegra_cpu_car.h"
 
 #include "common.h"
 
diff --git a/arch/arm/mach-tegra/tegra20_clocks.c b/arch/arm/mach-tegra/tegra20_clocks.c
index deb873f..0780876 100644
--- a/arch/arm/mach-tegra/tegra20_clocks.c
+++ b/arch/arm/mach-tegra/tegra20_clocks.c
@@ -26,13 +26,13 @@
 #include <linux/io.h>
 #include <linux/clkdev.h>
 #include <linux/clk.h>
+#include <linux/clk/tegra.h>
 
 #include <mach/iomap.h>
 
 #include "clock.h"
 #include "fuse.h"
 #include "tegra2_emc.h"
-#include "tegra_cpu_car.h"
 
 #define RST_DEVICES			0x004
 #define RST_DEVICES_SET			0x300
diff --git a/arch/arm/mach-tegra/tegra20_clocks_data.c b/arch/arm/mach-tegra/tegra20_clocks_data.c
index 8d398a3..bb99346 100644
--- a/arch/arm/mach-tegra/tegra20_clocks_data.c
+++ b/arch/arm/mach-tegra/tegra20_clocks_data.c
@@ -26,6 +26,7 @@
 #include <linux/delay.h>
 #include <linux/io.h>
 #include <linux/clk.h>
+#include <linux/clk/tegra.h>
 
 #include <mach/iomap.h>
 
@@ -33,7 +34,6 @@
 #include "fuse.h"
 #include "tegra2_emc.h"
 #include "tegra20_clocks.h"
-#include "tegra_cpu_car.h"
 
 /* Clock definitions */
 
diff --git a/arch/arm/mach-tegra/tegra30_clocks.c b/arch/arm/mach-tegra/tegra30_clocks.c
index c2102a3..fb7cbcb 100644
--- a/arch/arm/mach-tegra/tegra30_clocks.c
+++ b/arch/arm/mach-tegra/tegra30_clocks.c
@@ -28,6 +28,7 @@
 #include <linux/clk.h>
 #include <linux/cpufreq.h>
 #include <linux/syscore_ops.h>
+#include <linux/clk/tegra.h>
 
 #include <asm/clkdev.h>
 
@@ -35,7 +36,6 @@
 
 #include "clock.h"
 #include "fuse.h"
-#include "tegra_cpu_car.h"
 
 #define USE_PLL_LOCK_BITS 0
 
diff --git a/arch/arm/mach-tegra/tegra30_clocks_data.c b/arch/arm/mach-tegra/tegra30_clocks_data.c
index 3d2e553..161c743 100644
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
similarity index 95%
rename from arch/arm/mach-tegra/tegra_cpu_car.h
rename to include/linux/clk/tegra.h
index 30d063a..c1ed98f 100644
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
@@ -84,4 +84,4 @@ static inline void tegra_disable_cpu_clock(u32 cpu)
 void tegra20_cpu_car_ops_init(void);
 void tegra30_cpu_car_ops_init(void);
 
-#endif /* __MACH_TEGRA_CPU_CAR_H */
+#endif /* __LINUX_CLK_TEGRA_H_ */
-- 
1.7.4.1

