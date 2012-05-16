Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324Ab2EPGo5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 02:44:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46935 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759224Ab2EPGoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 02:44:54 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, arnd@arndb.de, linux-sh@vger.kernel.org,
        lethal@linux-sh.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        horms@verge.net.au, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Date: Wed, 16 May 2012 15:45:54 +0900
Message-Id: <20120516064554.32286.70806.sendpatchset@w520>
In-Reply-To: <20120516064449.32286.77941.sendpatchset@w520>
References: <20120516064449.32286.77941.sendpatchset@w520>
Subject: [PATCH 07/08] mach-shmobile: Emma Mobile EV2 DT support V3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

This is EMEV2 DT support V3. The support is limited to
whatever devices that are complied in the kernel. At this
point we have UARTs handled by "em-uart" and a timer
handled by "em-sti". Clocks and SMP are not supported.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Changes since V2:
 - converted board-specific emev2-kzm9d.dts into emev2.dtsi

 Changes since V1:
 - cleaned up the command line in the dts file
 - removed call to clock setup code - this should be done through DT
 - removed map io callback
 - removed Makefile hacks, people will have to add them by themselves

 arch/arm/boot/dts/emev2.dtsi         |   63 ++++++++++++++++++++++++++++++++++
 arch/arm/mach-shmobile/clock-emev2.c |    5 ++
 arch/arm/mach-shmobile/setup-emev2.c |   47 ++++++++++++++++++++++++-
 3 files changed, 114 insertions(+), 1 deletion(-)

--- /dev/null
+++ work/arch/arm/boot/dts/emev2.dtsi	2012-05-16 15:01:20.000000000 +0900
@@ -0,0 +1,63 @@
+/*
+ * Device Tree Source for the EMEV2 SoC
+ *
+ * Copyright (C) 2012 Renesas Solutions Corp.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/include/ "skeleton.dtsi"
+
+/ {
+	compatible = "renesas,emev2";
+	interrupt-parent = <&gic>;
+
+	cpus {
+		cpu@0 {
+			compatible = "arm,cortex-a9";
+		};
+		cpu@1 {
+			compatible = "arm,cortex-a9";
+		};
+	};
+
+	gic: interrupt-controller@e0020000 {
+		compatible = "arm,cortex-a9-gic";
+		interrupt-controller;
+		#interrupt-cells = <3>;
+		reg = <0xe0028000 0x1000>,
+		      <0xe0020000 0x0100>;
+	};
+
+	sti@e0180000 {
+		compatible = "renesas,em-sti";
+		reg = <0xe0180000 0x54>;
+		interrupts = <0 125 0>;
+	};
+
+	uart@e1020000 {
+		compatible = "renesas,em-uart";
+		reg = <0xe1020000 0x38>;
+		interrupts = <0 8 0>;
+	};
+
+	uart@e1030000 {
+		compatible = "renesas,em-uart";
+		reg = <0xe1030000 0x38>;
+		interrupts = <0 9 0>;
+	};
+
+	uart@e1040000 {
+		compatible = "renesas,em-uart";
+		reg = <0xe1040000 0x38>;
+		interrupts = <0 10 0>;
+	};
+
+	uart@e1050000 {
+		compatible = "renesas,em-uart";
+		reg = <0xe1050000 0x38>;
+		interrupts = <0 11 0>;
+	};
+};
--- 0009/arch/arm/mach-shmobile/clock-emev2.c
+++ work/arch/arm/mach-shmobile/clock-emev2.c	2012-05-16 14:56:42.000000000 +0900
@@ -191,10 +191,15 @@ static int __init emev2_sclkdiv_register
 
 static struct clk_lookup lookups[] = {
 	CLKDEV_DEV_ID("serial8250-em.0", &gclk_clks[GCLK_USIAU0_SCLK]),
+	CLKDEV_DEV_ID("e1020000.uart", &gclk_clks[GCLK_USIAU0_SCLK]),
 	CLKDEV_DEV_ID("serial8250-em.1", &gclk_clks[GCLK_USIBU1_SCLK]),
+	CLKDEV_DEV_ID("e1030000.uart", &gclk_clks[GCLK_USIBU1_SCLK]),
 	CLKDEV_DEV_ID("serial8250-em.2", &gclk_clks[GCLK_USIBU2_SCLK]),
+	CLKDEV_DEV_ID("e1040000.uart", &gclk_clks[GCLK_USIBU2_SCLK]),
 	CLKDEV_DEV_ID("serial8250-em.3", &gclk_clks[GCLK_USIBU3_SCLK]),
+	CLKDEV_DEV_ID("e1050000.uart", &gclk_clks[GCLK_USIBU3_SCLK]),
 	CLKDEV_DEV_ID("em_sti.0", &gclk_clks[GCLK_STI_SCLK]),
+	CLKDEV_DEV_ID("e0180000.sti", &gclk_clks[GCLK_STI_SCLK]),
 };
 
 void __init emev2_clock_init(void)
--- 0010/arch/arm/mach-shmobile/setup-emev2.c
+++ work/arch/arm/mach-shmobile/setup-emev2.c	2012-05-16 14:56:42.000000000 +0900
@@ -22,9 +22,11 @@
 #include <linux/irq.h>
 #include <linux/platform_device.h>
 #include <linux/platform_data/gpio-em.h>
+#include <linux/of_platform.h>
 #include <linux/delay.h>
 #include <linux/input.h>
 #include <linux/io.h>
+#include <linux/of_irq.h>
 #include <mach/hardware.h>
 #include <mach/common.h>
 #include <mach/emev2.h>
@@ -381,9 +383,14 @@ void __init emev2_add_standard_devices(v
 			     ARRAY_SIZE(emev2_late_devices));
 }
 
-void __init emev2_add_early_devices(void)
+void __init emev2_init_delay(void)
 {
 	shmobile_setup_delay(533, 1, 3); /* Cortex-A9 @ 533MHz */
+}
+
+void __init emev2_add_early_devices(void)
+{
+	emev2_init_delay();
 
 	early_platform_add_devices(emev2_early_devices,
 				   ARRAY_SIZE(emev2_early_devices));
@@ -405,3 +412,41 @@ void __init emev2_init_irq(void)
 	/* Use GIC to handle interrupts */
 	gic_init(0, 29, gic_dist_base, gic_cpu_base);
 }
+
+#ifdef CONFIG_USE_OF
+static const struct of_dev_auxdata emev2_auxdata_lookup[] __initconst = {
+	{ }
+};
+
+void __init emev2_add_standard_devices_dt(void)
+{
+	of_platform_populate(NULL, of_default_bus_match_table,
+			     emev2_auxdata_lookup, NULL);
+}
+
+static const struct of_device_id emev2_dt_irq_match[] = {
+	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init, },
+	{},
+};
+
+static const char *emev2_boards_compat_dt[] __initdata = {
+	"renesas,emev2",
+	NULL,
+};
+
+void __init emev2_init_irq_dt(void)
+{
+	of_irq_init(emev2_dt_irq_match);
+}
+
+DT_MACHINE_START(EMEV2_DT, "Generic Emma Mobile EV2 (Flattened Device Tree)")
+	.init_early	= emev2_init_delay,
+	.nr_irqs	= NR_IRQS_LEGACY,
+	.init_irq	= emev2_init_irq_dt,
+	.handle_irq	= gic_handle_irq,
+	.init_machine	= emev2_add_standard_devices_dt,
+	.timer		= &shmobile_timer,
+	.dt_compat	= emev2_boards_compat_dt,
+MACHINE_END
+
+#endif /* CONFIG_USE_OF */
