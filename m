Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab0GTPux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:50:53 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42177 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367Ab0GTPuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:50:51 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 20 Jul 2010 17:51:27 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH 4/4] arm: Added CMA to Aquila and Goni
In-reply-to: <b356e2fbc65342d902ed67a5b0aa00459a04fe49.1279639238.git.m.nazarewicz@samsung.com>
To: linux-mm@kvack.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Xiaolin Zhang <xiaolin.zhang@intel.com>,
        Hiremath Vaibhav <hvaibhav@ti.com>,
        Robert Fekete <robert.fekete@stericsson.com>,
        Marcus Lorentzon <marcus.xm.lorentzon@stericsson.com>,
        linux-kernel@vger.kernel.org,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <ba86bb724b47e834c5639256e851f3937f5a40e7.1279639238.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <cover.1279639238.git.m.nazarewicz@samsung.com>
 <d6d104950c1391eaf3614d56615617cee5722fb4.1279639238.git.m.nazarewicz@samsung.com>
 <adceebd371e8a66a2c153f429b38068eca99e99f.1279639238.git.m.nazarewicz@samsung.com>
 <b356e2fbc65342d902ed67a5b0aa00459a04fe49.1279639238.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the CMA initialisation code to two Samsung platforms.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/Kconfig                    |    1 +
 arch/arm/mach-s5pv210/Kconfig       |    1 +
 arch/arm/mach-s5pv210/mach-aquila.c |    7 +++++++
 arch/arm/mach-s5pv210/mach-goni.c   |    7 +++++++
 4 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 2e5b0f3..40c7380 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -691,6 +691,7 @@ config ARCH_S5PC100
 	select CPU_V7
 	select ARM_L1_CACHE_SHIFT_6
 	select ARCH_USES_GETTIMEOFFSET
+	select ARCH_CMA_POSSIBLE
 	help
 	  Samsung S5PC100 series based systems
 
diff --git a/arch/arm/mach-s5pv210/Kconfig b/arch/arm/mach-s5pv210/Kconfig
index e65825f..5fa1378 100644
--- a/arch/arm/mach-s5pv210/Kconfig
+++ b/arch/arm/mach-s5pv210/Kconfig
@@ -14,6 +14,7 @@ config CPU_S5PV210
 	select PLAT_S5P
 	select S3C_PL330_DMA
 	select S5P_EXT_INT
+	select ARCH_CMA_POSSIBLE
 	help
 	  Enable S5PV210 CPU support
 
diff --git a/arch/arm/mach-s5pv210/mach-aquila.c b/arch/arm/mach-s5pv210/mach-aquila.c
index 0992618..4044233 100644
--- a/arch/arm/mach-s5pv210/mach-aquila.c
+++ b/arch/arm/mach-s5pv210/mach-aquila.c
@@ -19,6 +19,7 @@
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/gpio.h>
+#include <linux/cma-int.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -454,6 +455,11 @@ static void __init aquila_map_io(void)
 	s3c24xx_init_uarts(aquila_uartcfgs, ARRAY_SIZE(aquila_uartcfgs));
 }
 
+static void __init aquila_reserve(void)
+{
+	cma_regions_allocate(NULL);
+}
+
 static void __init aquila_machine_init(void)
 {
 	/* PMIC */
@@ -478,4 +484,5 @@ MACHINE_START(AQUILA, "Aquila")
 	.map_io		= aquila_map_io,
 	.init_machine	= aquila_machine_init,
 	.timer		= &s3c24xx_timer,
+	.reserve	= aquila_reserve,
 MACHINE_END
diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index 7b18505..8ab0751 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -19,6 +19,7 @@
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/gpio.h>
+#include <linux/cma-int.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -435,6 +436,11 @@ static void __init goni_map_io(void)
 	s3c24xx_init_uarts(goni_uartcfgs, ARRAY_SIZE(goni_uartcfgs));
 }
 
+static void __init goni_reserve(void)
+{
+	cma_regions_allocate(NULL);
+}
+
 static void __init goni_machine_init(void)
 {
 	/* PMIC */
@@ -456,4 +462,5 @@ MACHINE_START(GONI, "GONI")
 	.map_io		= goni_map_io,
 	.init_machine	= goni_machine_init,
 	.timer		= &s3c24xx_timer,
+	.reserve	= goni_reserve,
 MACHINE_END
-- 
1.7.1

