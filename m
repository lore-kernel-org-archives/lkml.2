Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab1KQPIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:08:40 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15250 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab1KQPIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:08:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 17 Nov 2011 07:07:22 -0800
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        "Marc Dietrich" <marvin24@gmx.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>
Subject: [PATCH] arm/tegra: convert tegra20 to GIC devicetree binding
Date: Thu, 17 Nov 2011 17:07:09 +0200
Message-ID: <1321542430-17971-1-git-send-email-pdeschrijver@nvidia.com>
X-Mailer: git-send-email 1.7.7.rc0.72.g4b5ea.dirty
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert tegra20 IRQ intialization to the GIC devicetree binding. Modify the
interrupt definitions in the dts files according to
Documentation/devicetree/bindings/arm/gic.txt

Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
---
 arch/arm/boot/dts/tegra-paz00.dts |    2 +-
 arch/arm/boot/dts/tegra20.dtsi    |   52 ++++++++++++++++++------------------
 arch/arm/mach-tegra/irq.c         |   18 +++++++++++-
 3 files changed, 43 insertions(+), 29 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-paz00.dts b/arch/arm/boot/dts/tegra-paz00.dts
index 15a949f..7ff8f6f 100644
--- a/arch/arm/boot/dts/tegra-paz00.dts
+++ b/arch/arm/boot/dts/tegra-paz00.dts
@@ -32,7 +32,7 @@
 		#size-cells = <0>;
 		compatible = "nvidia,nvec";
 		reg = <0x7000C500 0x100>;
-		interrupts = <124>;
+		interrupts = <0 92 0x04>;
 		clock-frequency = <80000>;
 		request-gpios = <&gpio 170 0>;
 		slave-addr = <138>;
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
index 795b921..cd01b01 100644
--- a/arch/arm/boot/dts/tegra20.dtsi
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -5,9 +5,9 @@
 	interrupt-parent = <&intc>;
 
 	intc: interrupt-controller@50041000 {
-		compatible = "nvidia,tegra20-gic";
+		compatible = "arm,cortex-a9-gic";
 		interrupt-controller;
-		#interrupt-cells = <1>;
+		#interrupt-cells = <3>;
 		reg = < 0x50041000 0x1000 >,
 		      < 0x50040100 0x0100 >;
 	};
@@ -17,7 +17,7 @@
 		#size-cells = <0>;
 		compatible = "nvidia,tegra20-i2c";
 		reg = <0x7000C000 0x100>;
-		interrupts = < 70 >;
+		interrupts = < 0 38 0x04 >;
 	};
 
 	i2c@7000c400 {
@@ -25,7 +25,7 @@
 		#size-cells = <0>;
 		compatible = "nvidia,tegra20-i2c";
 		reg = <0x7000C400 0x100>;
-		interrupts = < 116 >;
+		interrupts = < 0 84 0x04 >;
 	};
 
 	i2c@7000c500 {
@@ -33,7 +33,7 @@
 		#size-cells = <0>;
 		compatible = "nvidia,tegra20-i2c";
 		reg = <0x7000C500 0x100>;
-		interrupts = < 124 >;
+		interrupts = < 0 92 0x04 >;
 	};
 
 	i2c@7000d000 {
@@ -41,7 +41,7 @@
 		#size-cells = <0>;
 		compatible = "nvidia,tegra20-i2c";
 		reg = <0x7000D000 0x200>;
-		interrupts = < 85 >;
+		interrupts = < 0 53 0x04 >;
 	};
 
 	i2s@70002800 {
@@ -49,7 +49,7 @@
 		#size-cells = <0>;
 		compatible = "nvidia,tegra20-i2s";
 		reg = <0x70002800 0x200>;
-		interrupts = < 45 >;
+		interrupts = < 0 13 0x04 >;
 		dma-channel = < 2 >;
 	};
 
@@ -58,7 +58,7 @@
 		#size-cells = <0>;
 		compatible = "nvidia,tegra20-i2s";
 		reg = <0x70002a00 0x200>;
-		interrupts = < 35 >;
+		interrupts = < 0 3 0x04 >;
 		dma-channel = < 1 >;
 	};
 
@@ -72,7 +72,7 @@
 	gpio: gpio@6000d000 {
 		compatible = "nvidia,tegra20-gpio";
 		reg = < 0x6000d000 0x1000 >;
-		interrupts = < 64 65 66 67 87 119 121 >;
+		interrupts = < 0 32 0x04 0 33 0x04 0 34 0x04 0 35 0x04 0 55 0x04 0 87 0x04 0 89 0x04 >;
 		#gpio-cells = <2>;
 		gpio-controller;
 	};
@@ -87,81 +87,81 @@
 
 	serial@70006000 {
 		compatible = "nvidia,tegra20-uart";
-		reg = <0x70006000 0x40>;
+		reg = <0x70006000 0x040>;
 		reg-shift = <2>;
-		interrupts = < 68 >;
+		interrupts = < 0 36 0x04 >;
 	};
 
 	serial@70006040 {
 		compatible = "nvidia,tegra20-uart";
-		reg = <0x70006040 0x40>;
+		reg = <0x70006040 0x040>;
 		reg-shift = <2>;
-		interrupts = < 69 >;
+		interrupts = < 0 37 0x04 >;
 	};
 
 	serial@70006200 {
 		compatible = "nvidia,tegra20-uart";
 		reg = <0x70006200 0x100>;
 		reg-shift = <2>;
-		interrupts = < 78 >;
+		interrupts = < 0 46 0x04 >;
 	};
 
 	serial@70006300 {
 		compatible = "nvidia,tegra20-uart";
 		reg = <0x70006300 0x100>;
 		reg-shift = <2>;
-		interrupts = < 122 >;
+		interrupts = < 0 90 0x04 >;
 	};
 
 	serial@70006400 {
 		compatible = "nvidia,tegra20-uart";
 		reg = <0x70006400 0x100>;
 		reg-shift = <2>;
-		interrupts = < 123 >;
+		interrupts = < 0 91 0x04 >;
 	};
 
 	sdhci@c8000000 {
 		compatible = "nvidia,tegra20-sdhci";
 		reg = <0xc8000000 0x200>;
-		interrupts = < 46 >;
+		interrupts = < 0 14 0x04 >;
 	};
 
 	sdhci@c8000200 {
 		compatible = "nvidia,tegra20-sdhci";
 		reg = <0xc8000200 0x200>;
-		interrupts = < 47 >;
+		interrupts = < 0 15 0x04 >;
 	};
 
 	sdhci@c8000400 {
 		compatible = "nvidia,tegra20-sdhci";
 		reg = <0xc8000400 0x200>;
-		interrupts = < 51 >;
+		interrupts = < 0 19 0x04 >;
 	};
 
 	sdhci@c8000600 {
 		compatible = "nvidia,tegra20-sdhci";
 		reg = <0xc8000600 0x200>;
-		interrupts = < 63 >;
+		interrupts = < 0 31 0x04 >;
 	};
 
 	usb@c5000000 {
 		compatible = "nvidia,tegra20-ehci", "usb-ehci";
-		reg = <0xc5000000 0x4000>;
-		interrupts = < 52 >;
+		reg = <0xc5000000 0x04000>;
+		interrupts = < 0 20 0x04 >;
 		phy_type = "utmi";
 	};
 
 	usb@c5004000 {
 		compatible = "nvidia,tegra20-ehci", "usb-ehci";
-		reg = <0xc5004000 0x4000>;
-		interrupts = < 53 >;
+		reg = <0xc5004000 0x04000>;
+		interrupts = < 0 21 0x04 >;
 		phy_type = "ulpi";
 	};
 
 	usb@c5008000 {
 		compatible = "nvidia,tegra20-ehci", "usb-ehci";
-		reg = <0xc5008000 0x4000>;
-		interrupts = < 129 >;
+		reg = <0xc5008000 0x04000>;
+		interrupts = < 0 97 0x04 >;
 		phy_type = "utmi";
 	};
 };
diff --git a/arch/arm/mach-tegra/irq.c b/arch/arm/mach-tegra/irq.c
index 8ad82af..c6d02a4 100644
--- a/arch/arm/mach-tegra/irq.c
+++ b/arch/arm/mach-tegra/irq.c
@@ -21,6 +21,7 @@
 #include <linux/interrupt.h>
 #include <linux/irq.h>
 #include <linux/io.h>
+#include <linux/of_irq.h>
 
 #include <asm/hardware/gic.h>
 
@@ -109,6 +110,11 @@ static int tegra_retrigger(struct irq_data *d)
 	return 1;
 }
 
+static const struct of_device_id tegra_irq_match[] __initconst = {
+	{ .compatible = "arm,cortex-a9-gic", .data = gic_of_init },
+	{ /* sentinel */ }
+};
+
 void __init tegra_init_irq(void)
 {
 	int i;
@@ -125,6 +131,14 @@ void __init tegra_init_irq(void)
 	gic_arch_extn.irq_unmask = tegra_unmask;
 	gic_arch_extn.irq_retrigger = tegra_retrigger;
 
-	gic_init(0, 29, IO_ADDRESS(TEGRA_ARM_INT_DIST_BASE),
-		 IO_ADDRESS(TEGRA_ARM_PERIF_BASE + 0x100));
+#ifdef CONFIG_OF
+	/* Check if there is a devicetree present as of_irq_init doesn't
+	 * indicate if an interrupt controller node was found.
+	 */
+	if (of_find_node_by_path("/"))
+		of_irq_init(tegra_irq_match);
+	else
+#endif
+		gic_init(0, 29, IO_ADDRESS(TEGRA_ARM_INT_DIST_BASE),
+			IO_ADDRESS(TEGRA_ARM_PERIF_BASE + 0x100));
 }
-- 
1.7.7.rc0.72.g4b5ea.dirty

