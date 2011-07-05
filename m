Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab1GEU3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 16:29:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:54239 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab1GEU3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 16:29:34 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 2/3] ARM: tegra: Use engineering names in DT compatible property
Date: Tue,  5 Jul 2011 14:29:21 -0600
Message-Id: <1309897762-23564-3-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1309897762-23564-1-git-send-email-swarren@nvidia.com>
References: <1309897762-23564-1-git-send-email-swarren@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Engineering names are more stable than marketing names. Hence, use them
for Device Tree compatible properties instead.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 arch/arm/boot/dts/tegra-harmony.dts  |    4 +-
 arch/arm/boot/dts/tegra-seaboard.dts |    4 +-
 arch/arm/boot/dts/tegra20.dtsi       |  162 ++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/tegra250.dtsi      |  162 ----------------------------------
 arch/arm/mach-tegra/board-dt.c       |   32 ++++----
 5 files changed, 182 insertions(+), 182 deletions(-)
 create mode 100644 arch/arm/boot/dts/tegra20.dtsi
 delete mode 100644 arch/arm/boot/dts/tegra250.dtsi

diff --git a/arch/arm/boot/dts/tegra-harmony.dts b/arch/arm/boot/dts/tegra-harmony.dts
index ea8ea92..c2bee7e 100644
--- a/arch/arm/boot/dts/tegra-harmony.dts
+++ b/arch/arm/boot/dts/tegra-harmony.dts
@@ -1,11 +1,11 @@
 /dts-v1/;
 
 /memreserve/ 0x1c000000 0x04000000;
-/include/ "tegra250.dtsi"
+/include/ "tegra20.dtsi"
 
 / {
 	model = "NVIDIA Tegra2 Harmony evaluation board";
-	compatible = "nvidia,harmony", "nvidia,tegra250";
+	compatible = "nvidia,harmony", "nvidia,tegra20";
 
 	chosen {
 		bootargs = "vmalloc=192M video=tegrafb console=ttyS0,115200n8 root=/dev/mmcblk0p2 rw rootwait";
diff --git a/arch/arm/boot/dts/tegra-seaboard.dts b/arch/arm/boot/dts/tegra-seaboard.dts
index 418c7b8..5a99b4c 100644
--- a/arch/arm/boot/dts/tegra-seaboard.dts
+++ b/arch/arm/boot/dts/tegra-seaboard.dts
@@ -1,11 +1,11 @@
 /dts-v1/;
 
 /memreserve/ 0x1c000000 0x04000000;
-/include/ "tegra250.dtsi"
+/include/ "tegra20.dtsi"
 
 / {
 	model = "NVIDIA Seaboard";
-	compatible = "nvidia,seaboard", "nvidia,tegra250";
+	compatible = "nvidia,seaboard", "nvidia,tegra20";
 
 	chosen {
 		bootargs = "vmalloc=192M video=tegrafb console=ttyS0,115200n8 root=/dev/mmcblk1p3 rw rootwait";
diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20.dtsi
new file mode 100644
index 0000000..1c1a4df
--- /dev/null
+++ b/arch/arm/boot/dts/tegra20.dtsi
@@ -0,0 +1,162 @@
+/include/ "skeleton.dtsi"
+
+/ {
+	model = "NVIDIA Tegra 250";
+	compatible = "nvidia,tegra20";
+	interrupt-parent = <&intc>;
+
+	amba {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		intc: interrupt-controller@50041000 {
+			compatible = "nvidia,tegra20-gic", "arm,gic";
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			reg = < 0x50041000 0x1000 >,
+			      < 0x50040100 0x0100 >;
+		};
+	};
+
+
+	i2c@7000c000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra20-i2c";
+		reg = <0x7000C000 0x100>;
+		interrupts = < 70 >;
+		status = "disabled";
+	};
+
+	i2c@7000c400 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra20-i2c";
+		reg = <0x7000C400 0x100>;
+		interrupts = < 116 >;
+		status = "disabled";
+	};
+
+	i2c@7000c500 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra20-i2c";
+		reg = <0x7000C500 0x100>;
+		interrupts = < 124 >;
+		status = "disabled";
+	};
+
+	i2c@7000d000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra20-i2c";
+		reg = <0x7000D000 0x200>;
+		interrupts = < 85 >;
+		status = "disabled";
+	};
+
+	i2s@70002800 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra20-i2s";
+		reg = <0x70002800 0x200>;
+		interrupts = < 45 >;
+		status = "disabled";
+	};
+
+	i2s@70002a00 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra20-i2s";
+		reg = <0x70002a00 0x200>;
+		interrupts = < 35 >;
+		status = "disabled";
+	};
+
+	das@70000c00 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		compatible = "nvidia,tegra20-das";
+		reg = <0x70000c00 0x80>;
+		status = "disabled";
+	};
+
+	gpio: gpio@6000d000 {
+		compatible = "nvidia,tegra20-gpio";
+		reg = < 0x6000d000 0x1000 >;
+		interrupts = < 64 65 66 67 87 119 121 >;
+		#gpio-cells = <2>;
+		gpio-controller;
+	};
+
+	serial@70006000 {
+		compatible = "nvidia,tegra20-uart";
+		reg = <0x70006000 0x40>;
+		reg-shift = <2>;
+		interrupts = < 68 >;
+		status = "disabled";
+	};
+
+	serial@70006040 {
+		compatible = "nvidia,tegra20-uart";
+		reg = <0x70006040 0x40>;
+		reg-shift = <2>;
+		interrupts = < 69 >;
+		status = "disabled";
+	};
+
+	serial@70006200 {
+		compatible = "nvidia,tegra20-uart";
+		reg = <0x70006200 0x100>;
+		reg-shift = <2>;
+		interrupts = < 78 >;
+		status = "disabled";
+	};
+
+	serial@70006300 {
+		compatible = "nvidia,tegra20-uart";
+		reg = <0x70006300 0x100>;
+		reg-shift = <2>;
+		interrupts = < 122 >;
+		status = "disabled";
+	};
+
+	serial@70006400 {
+		compatible = "nvidia,tegra20-uart";
+		reg = <0x70006400 0x100>;
+		reg-shift = <2>;
+		interrupts = < 123 >;
+		status = "disabled";
+	};
+
+	sdhci@c8000000 {
+		compatible = "nvidia,tegra20-sdhci";
+		reg = <0xc8000000 0x200>;
+		interrupts = < 46 >;
+		status = "disabled";
+	};
+
+	sdhci@c8000200 {
+		compatible = "nvidia,tegra20-sdhci";
+		reg = <0xc8000200 0x200>;
+		interrupts = < 47 >;
+		status = "disabled";
+	};
+
+	sdhci@c8000400 {
+		compatible = "nvidia,tegra20-sdhci";
+		reg = <0xc8000400 0x200>;
+		interrupts = < 51 >;
+		status = "disabled";
+	};
+
+	sdhci@c8000600 {
+		compatible = "nvidia,tegra20-sdhci";
+		reg = <0xc8000600 0x200>;
+		interrupts = < 63 >;
+		status = "disabled";
+	};
+};
+
diff --git a/arch/arm/boot/dts/tegra250.dtsi b/arch/arm/boot/dts/tegra250.dtsi
deleted file mode 100644
index ad1bf99..0000000
--- a/arch/arm/boot/dts/tegra250.dtsi
+++ /dev/null
@@ -1,162 +0,0 @@
-/include/ "skeleton.dtsi"
-
-/ {
-	model = "NVIDIA Tegra 250";
-	compatible = "nvidia,tegra250";
-	interrupt-parent = <&intc>;
-
-	amba {
-		compatible = "simple-bus";
-		#address-cells = <1>;
-		#size-cells = <1>;
-		ranges;
-
-		intc: interrupt-controller@50041000 {
-			compatible = "nvidia,tegra250-gic", "arm,gic";
-			interrupt-controller;
-			#interrupt-cells = <1>;
-			reg = < 0x50041000 0x1000 >,
-			      < 0x50040100 0x0100 >;
-		};
-	};
-
-
-	i2c@7000c000 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "nvidia,tegra250-i2c";
-		reg = <0x7000C000 0x100>;
-		interrupts = < 70 >;
-		status = "disabled";
-	};
-
-	i2c@7000c400 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "nvidia,tegra250-i2c";
-		reg = <0x7000C400 0x100>;
-		interrupts = < 116 >;
-		status = "disabled";
-	};
-
-	i2c@7000c500 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "nvidia,tegra250-i2c";
-		reg = <0x7000C500 0x100>;
-		interrupts = < 124 >;
-		status = "disabled";
-	};
-
-	i2c@7000d000 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "nvidia,tegra250-i2c";
-		reg = <0x7000D000 0x200>;
-		interrupts = < 85 >;
-		status = "disabled";
-	};
-
-	i2s@70002800 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "nvidia,tegra250-i2s";
-		reg = <0x70002800 0x200>;
-		interrupts = < 45 >;
-		status = "disabled";
-	};
-
-	i2s@70002a00 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "nvidia,tegra250-i2s";
-		reg = <0x70002a00 0x200>;
-		interrupts = < 35 >;
-		status = "disabled";
-	};
-
-	das@70000c00 {
-		#address-cells = <1>;
-		#size-cells = <0>;
-		compatible = "nvidia,tegra250-das";
-		reg = <0x70000c00 0x80>;
-		status = "disabled";
-	};
-
-	gpio: gpio@6000d000 {
-		compatible = "nvidia,tegra250-gpio";
-		reg = < 0x6000d000 0x1000 >;
-		interrupts = < 64 65 66 67 87 119 121 >;
-		#gpio-cells = <2>;
-		gpio-controller;
-	};
-
-	serial@70006000 {
-		compatible = "nvidia,tegra250-uart";
-		reg = <0x70006000 0x40>;
-		reg-shift = <2>;
-		interrupts = < 68 >;
-		status = "disabled";
-	};
-
-	serial@70006040 {
-		compatible = "nvidia,tegra250-uart";
-		reg = <0x70006040 0x40>;
-		reg-shift = <2>;
-		interrupts = < 69 >;
-		status = "disabled";
-	};
-
-	serial@70006200 {
-		compatible = "nvidia,tegra250-uart";
-		reg = <0x70006200 0x100>;
-		reg-shift = <2>;
-		interrupts = < 78 >;
-		status = "disabled";
-	};
-
-	serial@70006300 {
-		compatible = "nvidia,tegra250-uart";
-		reg = <0x70006300 0x100>;
-		reg-shift = <2>;
-		interrupts = < 122 >;
-		status = "disabled";
-	};
-
-	serial@70006400 {
-		compatible = "nvidia,tegra250-uart";
-		reg = <0x70006400 0x100>;
-		reg-shift = <2>;
-		interrupts = < 123 >;
-		status = "disabled";
-	};
-
-	sdhci@c8000000 {
-		compatible = "nvidia,tegra250-sdhci";
-		reg = <0xc8000000 0x200>;
-		interrupts = < 46 >;
-		status = "disabled";
-	};
-
-	sdhci@c8000200 {
-		compatible = "nvidia,tegra250-sdhci";
-		reg = <0xc8000200 0x200>;
-		interrupts = < 47 >;
-		status = "disabled";
-	};
-
-	sdhci@c8000400 {
-		compatible = "nvidia,tegra250-sdhci";
-		reg = <0xc8000400 0x200>;
-		interrupts = < 51 >;
-		status = "disabled";
-	};
-
-	sdhci@c8000600 {
-		compatible = "nvidia,tegra250-sdhci";
-		reg = <0xc8000600 0x200>;
-		interrupts = < 63 >;
-		status = "disabled";
-	};
-};
-
diff --git a/arch/arm/mach-tegra/board-dt.c b/arch/arm/mach-tegra/board-dt.c
index 75691d5..cc6776e 100644
--- a/arch/arm/mach-tegra/board-dt.c
+++ b/arch/arm/mach-tegra/board-dt.c
@@ -45,26 +45,26 @@
 
 void harmony_pinmux_init(void);
 
-static struct platform_device *tegra250_devices[] __initdata = {
+static struct platform_device *tegra20_devices[] __initdata = {
 	&tegra_i2s_device1,
 	&tegra_pcm_device,
 };
 
-struct of_dev_auxdata tegra250_auxdata_lookup[] __initdata = {
-	OF_DEV_AUXDATA("nvidia,tegra250-sdhci", TEGRA_SDMMC1_BASE, "sdhci-tegra.0", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra250-sdhci", TEGRA_SDMMC2_BASE, "sdhci-tegra.1", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra250-sdhci", TEGRA_SDMMC3_BASE, "sdhci-tegra.2", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra250-sdhci", TEGRA_SDMMC4_BASE, "sdhci-tegra.3", NULL),
+struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
+	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC1_BASE, "sdhci-tegra.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC2_BASE, "sdhci-tegra.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC3_BASE, "sdhci-tegra.2", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-sdhci", TEGRA_SDMMC4_BASE, "sdhci-tegra.3", NULL),
 
-	OF_DEV_AUXDATA("nvidia,tegra250-i2c", TEGRA_I2C_BASE, "tegra-i2c.0", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra250-i2c", TEGRA_I2C2_BASE, "tegra-i2c.1", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra250-i2c", TEGRA_I2C3_BASE, "tegra-i2c.2", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra250-i2c", TEGRA_DVC_BASE, "tegra-i2c.3", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_I2C_BASE, "tegra-i2c.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_I2C2_BASE, "tegra-i2c.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_I2C3_BASE, "tegra-i2c.2", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2c", TEGRA_DVC_BASE, "tegra-i2c.3", NULL),
 #if 0
-	OF_DEV_AUXDATA("nvidia,tegra250-i2s", TEGRA_I2S1_BASE, "tegra-i2s.0", NULL),
-	OF_DEV_AUXDATA("nvidia,tegra250-i2s", TEGRA_I2S1_BASE, "tegra-i2s.1", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2s", TEGRA_I2S1_BASE, "tegra-i2s.0", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-i2s", TEGRA_I2S1_BASE, "tegra-i2s.1", NULL),
 #endif
-	OF_DEV_AUXDATA("nvidia,tegra250-das", TEGRA_APB_MISC_DAS_BASE, "tegra-das", NULL),
+	OF_DEV_AUXDATA("nvidia,tegra20-das", TEGRA_APB_MISC_DAS_BASE, "tegra-das", NULL),
 	{}
 };
 
@@ -80,7 +80,7 @@ static struct of_device_id tegra_dt_match_table[] __initdata = {
 };
 
 static struct of_device_id tegra_dt_gic_match[] __initdata = {
-	{ .compatible = "nvidia,tegra250-gic", },
+	{ .compatible = "nvidia,tegra20-gic", },
 	{}
 };
 
@@ -106,13 +106,13 @@ static void __init tegra_dt_init(void)
 
 	harmony_pinmux_init();
 
-	platform_add_devices(tegra250_devices, ARRAY_SIZE(tegra250_devices));
+	platform_add_devices(tegra20_devices, ARRAY_SIZE(tegra20_devices));
 
 	/*
 	 * Finished with the static registrations now; fill in the missing
 	 * devices
 	 */
-	of_platform_populate(NULL, tegra_dt_match_table, tegra250_auxdata_lookup, NULL);
+	of_platform_populate(NULL, tegra_dt_match_table, tegra20_auxdata_lookup, NULL);
 }
 
 static const char * tegra_dt_board_compat[] = {
-- 
1.7.0.4

