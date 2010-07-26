Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab0GZOLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 10:11:35 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:20949 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab0GZOKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 10:10:31 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 26 Jul 2010 16:11:44 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv2 4/4] arm: Added CMA to Aquila and Goni
In-reply-to: <03fd80bba187c767530614402793963d62e44e1c.1280151963.git.m.nazarewicz@samsung.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.arm.linux.org.uk,
        Hiremath Vaibhav <hvaibhav@ti.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Jonathan Corbet <corbet@lwn.net>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>
Message-id: <a5ee70136d10de93d0a20608fa3aaf6242493772.1280151963.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <cover.1280151963.git.m.nazarewicz@samsung.com>
 <743102607e2c5fb20e3c0676fadbcb93d501a78e.1280151963.git.m.nazarewicz@samsung.com>
 <dc4bdf3e0b02c0ac4770927f72b6cbc3f0b486a2.1280151963.git.m.nazarewicz@samsung.com>
 <03fd80bba187c767530614402793963d62e44e1c.1280151963.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the CMA initialisation code to two Samsung platforms.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/mach-s5pv210/mach-aquila.c |   13 +++++++++++++
 arch/arm/mach-s5pv210/mach-goni.c   |   13 +++++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-s5pv210/mach-aquila.c b/arch/arm/mach-s5pv210/mach-aquila.c
index 0992618..ab156f9 100644
--- a/arch/arm/mach-s5pv210/mach-aquila.c
+++ b/arch/arm/mach-s5pv210/mach-aquila.c
@@ -19,6 +19,7 @@
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/gpio.h>
+#include <linux/cma.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -454,6 +455,17 @@ static void __init aquila_map_io(void)
 	s3c24xx_init_uarts(aquila_uartcfgs, ARRAY_SIZE(aquila_uartcfgs));
 }
 
+static void __init aquila_reserve(void)
+{
+	static char regions[] __initdata =
+		"-mfc_fw=1M/128K;mfc_b1=32M;mfc_b2=16M@0x40000000";
+	static char map[] __initdata =
+		"s3c-mfc5/f=mfc_fw;s3c-mfc5/a=mfc_b1;s3c-mfc5/b=mfc_b2";
+
+	cma_set_defaults(regions, map, NULL);
+	cma_early_regions_reserve(NULL);
+}
+
 static void __init aquila_machine_init(void)
 {
 	/* PMIC */
@@ -478,4 +490,5 @@ MACHINE_START(AQUILA, "Aquila")
 	.map_io		= aquila_map_io,
 	.init_machine	= aquila_machine_init,
 	.timer		= &s3c24xx_timer,
+	.reserve	= aquila_reserve,
 MACHINE_END
diff --git a/arch/arm/mach-s5pv210/mach-goni.c b/arch/arm/mach-s5pv210/mach-goni.c
index 7b18505..2b0a349 100644
--- a/arch/arm/mach-s5pv210/mach-goni.c
+++ b/arch/arm/mach-s5pv210/mach-goni.c
@@ -19,6 +19,7 @@
 #include <linux/gpio_keys.h>
 #include <linux/input.h>
 #include <linux/gpio.h>
+#include <linux/cma.h>
 
 #include <asm/mach/arch.h>
 #include <asm/mach/map.h>
@@ -435,6 +436,17 @@ static void __init goni_map_io(void)
 	s3c24xx_init_uarts(goni_uartcfgs, ARRAY_SIZE(goni_uartcfgs));
 }
 
+static void __init goni_reserve(void)
+{
+	static char regions[] __initdata =
+		"-mfc_fw=1M/128K;mfc_b1=32M;mfc_b2=16M@0x40000000";
+	static char map[] __initdata =
+		"s3c-mfc5/f=mfc_fw;s3c-mfc5/a=mfc_b1;s3c-mfc5/b=mfc_b2";
+
+	cma_set_defaults(regions, map, NULL);
+	cma_early_regions_reserve(NULL);
+}
+
 static void __init goni_machine_init(void)
 {
 	/* PMIC */
@@ -456,4 +468,5 @@ MACHINE_START(GONI, "GONI")
 	.map_io		= goni_map_io,
 	.init_machine	= goni_machine_init,
 	.timer		= &s3c24xx_timer,
+	.reserve	= goni_reserve,
 MACHINE_END
-- 
1.7.1

