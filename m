Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab1KIBXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 20:23:38 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49036 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1KIBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 20:23:36 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: devicetree-discuss@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org,
        Sascha Hauer <kernel@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: [RFC 8/8] dt/arm: versatile add clock parsing
Date: Tue,  8 Nov 2011 18:19:43 -0700
Message-Id: <1320801583-12774-9-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
References: <1320801583-12774-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/arm/boot/dts/versatile-ab.dts     |   37 ++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/versatile-pb.dts     |    2 +
 arch/arm/mach-versatile/core.c         |   37 +------------------------------
 arch/arm/mach-versatile/versatile_dt.c |   33 ++++++++++++++++++++++++++++
 4 files changed, 74 insertions(+), 35 deletions(-)

diff --git a/arch/arm/boot/dts/versatile-ab.dts b/arch/arm/boot/dts/versatile-ab.dts
index 0b32925..cb8a49e 100644
--- a/arch/arm/boot/dts/versatile-ab.dts
+++ b/arch/arm/boot/dts/versatile-ab.dts
@@ -19,6 +19,35 @@
 		reg = <0x0 0x08000000>;
 	};
 
+	clocks {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		ref24_clk: clock0 {
+			compatible = "fixed-clock";
+			#clock-cells = <1>;
+			clock-frequency = <24000000>;
+			clock-output-names = "ref";
+		};
+
+		sp804_clk: clock1 {
+			compatible = "fixed-clock";
+			#clock-cells = <1>;
+			clock-frequency = <1000000>;
+			clock-output-names = "ref";
+		};
+
+		osc4_clk: clock3 {
+			compatible = "ics,icst307";
+			#clock-cells = <1>;
+			ref = <24000>;
+			vco-max = <200000>;
+			vd-range = <12 519>;
+			rd-range = <3 129>;
+			clock-output-names = "osc4";
+		};
+	};
+
 	flash@34000000 {
 		compatible = "arm,versatile-flash";
 		reg = <0x34000000 0x4000000>;
@@ -80,18 +109,21 @@
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0x101f1000 0x1000>;
 			interrupts = <12>;
+			clock = <&ref24_clk 0>;
 		};
 
 		uart1: uart@101f2000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0x101f2000 0x1000>;
 			interrupts = <13>;
+			clock = <&ref24_clk 0>;
 		};
 
 		uart2: uart@101f3000 {
 			compatible = "arm,pl011", "arm,primecell";
 			reg = <0x101f3000 0x1000>;
 			interrupts = <14>;
+			clock = <&ref24_clk 0>;
 		};
 
 		smc@10100000 {
@@ -108,6 +140,7 @@
 			compatible = "arm,pl110", "arm,primecell";
 			reg = <0x10120000 0x1000>;
 			interrupts = <16>;
+			clock = <&osc4_clk 0>;
 		};
 
 		sctl@101e0000 {
@@ -157,6 +190,7 @@
 			compatible = "arm,pl022", "arm,primecell";
 			reg = <0x101f4000 0x1000>;
 			interrupts = <11>;
+			clock = <&ref24_clk 0>;
 		};
 
 		fpga {
@@ -174,18 +208,21 @@
 				compatible = "arm,primecell";
 				reg = < 0x5000 0x1000>;
 				interrupts = <22>;
+				clock = <&ref24_clk 0>;
 			};
 			kmi@6000 {
 				compatible = "arm,pl050", "arm,primecell";
 				reg = <0x6000 0x1000>;
 				interrupt-parent = <&sic>;
 				interrupts = <3>;
+				clock = <&ref24_clk 0>;
 			};
 			kmi@7000 {
 				compatible = "arm,pl050", "arm,primecell";
 				reg = <0x7000 0x1000>;
 				interrupt-parent = <&sic>;
 				interrupts = <4>;
+				clock = <&ref24_clk 0>;
 			};
 		};
 	};
diff --git a/arch/arm/boot/dts/versatile-pb.dts b/arch/arm/boot/dts/versatile-pb.dts
index 1664610..05e014a 100644
--- a/arch/arm/boot/dts/versatile-pb.dts
+++ b/arch/arm/boot/dts/versatile-pb.dts
@@ -31,6 +31,7 @@
 				reg = <0x9000 0x1000>;
 				interrupt-parent = <&sic>;
 				interrupts = <6>;
+				clock = <&ref24_clk 0>;
 			};
 			sci@a000 {
 				compatible = "arm,primecell";
@@ -42,6 +43,7 @@
 				compatible = "arm,primecell";
 				reg = <0xb000 0x1000>;
 				interrupts = <23>;
+				clock = <&ref24_clk 0>;
 			};
 		};
 	};
diff --git a/arch/arm/mach-versatile/core.c b/arch/arm/mach-versatile/core.c
index e340a54..4cd9822 100644
--- a/arch/arm/mach-versatile/core.c
+++ b/arch/arm/mach-versatile/core.c
@@ -666,44 +666,11 @@ static struct amba_device *amba_devs[] __initdata = {
 /*
  * Lookup table for attaching a specific name and platform_data pointer to
  * devices as they get created by of_platform_populate().  Ideally this table
- * would not exist, but the current clock implementation depends on some devices
- * having a specific name.
+ * would not exist, but some devices still need platform data.
  */
 struct of_dev_auxdata versatile_auxdata_lookup[] __initdata = {
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_MMCI0_BASE, "fpga:05", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_KMI0_BASE, "fpga:06", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_KMI1_BASE, "fpga:07", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_UART3_BASE, "fpga:09", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_MMCI1_BASE, "fpga:0b", NULL),
-
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_CLCD_BASE, "dev:20", &clcd_plat_data),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_UART0_BASE, "dev:f1", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_UART1_BASE, "dev:f2", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_UART2_BASE, "dev:f3", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SSP_BASE, "dev:f4", NULL),
 
-#if 0
-	/*
-	 * These entries are unnecessary because no clocks referencing
-	 * them.  I've left them in for now as place holders in case
-	 * any of them need to be added back, but they should be
-	 * removed before actually committing this patch.  --gcl
-	 */
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_AACI_BASE, "fpga:04", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SCI1_BASE, "fpga:0a", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SMC_BASE, "dev:00", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_MPMC_BASE, "dev:10", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_DMAC_BASE, "dev:30", NULL),
-
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SCTL_BASE, "dev:e0", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_WATCHDOG_BASE, "dev:e1", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_GPIO0_BASE, "dev:e4", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_GPIO1_BASE, "dev:e5", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_GPIO2_BASE, "dev:e6", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_GPIO3_BASE, "dev:e7", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_RTC_BASE, "dev:e8", NULL),
-	OF_DEV_AUXDATA("arm,primecell", VERSATILE_SCI_BASE, "dev:f0", NULL),
-#endif
+	OF_DEV_AUXDATA("arm,primecell", VERSATILE_CLCD_BASE, NULL, &clcd_plat_data),
 	{}
 };
 #endif
diff --git a/arch/arm/mach-versatile/versatile_dt.c b/arch/arm/mach-versatile/versatile_dt.c
index 54e037c..f11f6d0 100644
--- a/arch/arm/mach-versatile/versatile_dt.c
+++ b/arch/arm/mach-versatile/versatile_dt.c
@@ -24,13 +24,46 @@
 #include <linux/init.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
+#include <linux/of_clk.h>
+#include <linux/slab.h>
+
+#include <mach/hardware.h>
+#include <mach/clkdev.h>
+#include <asm/irq.h>
 #include <asm/mach-types.h>
 #include <asm/mach/arch.h>
 
 #include "core.h"
 
+/* Scan for fixed clocks */
+static struct clk *versatile_dt_clk_get(struct of_phandle_args *a, void *data)
+{
+	return data;
+}
+
 static void __init versatile_dt_init(void)
 {
+	struct device_node *node;
+	struct clk *clk;
+	int rc;
+
+	for_each_compatible_node(node, NULL, "fixed-clock") {
+		u32 rate;
+		if (of_property_read_u32(node, "clock-frequency", &rate))
+			continue;
+
+		clk = kzalloc(sizeof(*clk), GFP_KERNEL);
+		if (!clk)
+			panic("out of memory\n");
+		clk->rate = rate;
+
+		rc = of_clk_add_provider(node, versatile_dt_clk_get, clk);
+		if (rc) {
+			kfree(clk);
+			pr_err("error adding fixed clk %s\n", node->name);
+		}
+	}
+
 	of_platform_populate(NULL, of_default_bus_match_table,
 			     versatile_auxdata_lookup, NULL);
 }
-- 
1.7.5.4

