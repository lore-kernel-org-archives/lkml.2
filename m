Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab2JWHTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:19:36 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12992 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786Ab2JWHT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:19:29 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 23 Oct 2012 00:19:24 -0700
From: Pavan Kunapuli <pkunapuli@nvidia.com>
To: <swarren@wwwdotorg.org>, <linux@arm.linux.org.uk>, <cjb@laptop.org>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>
CC: Pavan Kunapuli <pkunapuli@nvidia.com>
Subject: [PATCH 1/2] ARM: dt: tegra: Add sdhci regulators
Date: Tue, 23 Oct 2012 12:48:59 +0530
Message-ID: <1350976740-19284-2-git-send-email-pkunapuli@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1350976740-19284-1-git-send-email-pkunapuli@nvidia.com>
References: <1350976740-19284-1-git-send-email-pkunapuli@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding vmmc and vmmcq supplies for sdhci nodes
in tegra dt files.

Signed-off-by: Pavan Kunapuli <pkunapuli@nvidia.com>
---
 arch/arm/boot/dts/tegra20-harmony.dts    |   27 ++++++++++++++++++++-
 arch/arm/boot/dts/tegra20-paz00.dts      |   24 +++++++++++++++++++-
 arch/arm/boot/dts/tegra20-seaboard.dts   |   35 ++++++++++++++++++++++++++++-
 arch/arm/boot/dts/tegra20-tamonten.dtsi  |   10 ++++++++
 arch/arm/boot/dts/tegra20-ventana.dts    |   36 ++++++++++++++++++++++++++++-
 arch/arm/boot/dts/tegra20-whistler.dts   |    9 +++++-
 arch/arm/boot/dts/tegra30-cardhu-a02.dts |    2 +
 arch/arm/boot/dts/tegra30-cardhu-a04.dts |    2 +
 arch/arm/boot/dts/tegra30-cardhu.dtsi    |   19 ++++++++++++++-
 9 files changed, 154 insertions(+), 10 deletions(-)

diff --git a/arch/arm/boot/dts/tegra20-harmony.dts b/arch/arm/boot/dts/tegra20-harmony.dts
index 74b8a47..5b02afe 100644
--- a/arch/arm/boot/dts/tegra20-harmony.dts
+++ b/arch/arm/boot/dts/tegra20-harmony.dts
@@ -419,7 +419,8 @@
 		status = "okay";
 		cd-gpios = <&gpio 69 0>; /* gpio PI5 */
 		wp-gpios = <&gpio 57 0>; /* gpio PH1 */
-		power-gpios = <&gpio 155 0>; /* gpio PT3 */
+		vmmc-supply = <&vddio_sd_reg>;
+		vqmmc-supply = <&vddio_sd_reg>;
 		bus-width = <4>;
 	};
 
@@ -427,7 +428,8 @@
 		status = "okay";
 		cd-gpios = <&gpio 58 0>; /* gpio PH2 */
 		wp-gpios = <&gpio 59 0>; /* gpio PH3 */
-		power-gpios = <&gpio 70 0>; /* gpio PI6 */
+		vmmc-supply = <&vddio_sdmmc_reg>;
+		vqmmc-supply = <&vddio_sdmmc_reg>;
 		bus-width = <8>;
 	};
 
@@ -495,6 +497,27 @@
 			gpio = <&gpio 176 0>; /* gpio PW0 */
 			enable-active-high;
 		};
+
+		vddio_sdmmc_reg: regulator@6 {
+			compatible = "regulator-fixed";
+			reg = <6>;
+			regulator-name = "vddio_sdmmc";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			gpio = <&gpio 70 0>; /* gpio PW0 */
+			enable-active-high;
+		};
+
+		vddio_sd_reg: regulator@7 {
+			compatible = "regulator-fixed";
+			reg = <7>;
+			regulator-name = "vddio_sd";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			gpio = <&gpio 155 0>; /* gpio PW0 */
+			enable-active-high;
+		};
+
 	};
 
 	sound {
diff --git a/arch/arm/boot/dts/tegra20-paz00.dts b/arch/arm/boot/dts/tegra20-paz00.dts
index 6a93d14..e161b65 100644
--- a/arch/arm/boot/dts/tegra20-paz00.dts
+++ b/arch/arm/boot/dts/tegra20-paz00.dts
@@ -422,13 +422,17 @@
 		status = "okay";
 		cd-gpios = <&gpio 173 0>; /* gpio PV5 */
 		wp-gpios = <&gpio 57 0>;  /* gpio PH1 */
-		power-gpios = <&gpio 169 0>; /* gpio PV1 */
 		bus-width = <4>;
+		vmmc-supply = <&vddio_sd_reg>;
+		vqmmc-supply = <&vddio_sd_reg>;
+
 	};
 
 	sdhci@c8000600 {
 		status = "okay";
 		bus-width = <8>;
+		vmmc-supply = <&vddio_sdmmc_reg>;
+		vqmmc-supply = <&vddio_sdmmc_reg>;
 	};
 
 	gpio-keys {
@@ -465,6 +469,24 @@
 			regulator-max-microvolt = <5000000>;
 			regulator-always-on;
 		};
+
+		vddio_sd_reg: regulator@1 {
+			compatible = "regulator-fixed";
+			reg = <1>;
+			regulator-name = "vddio_sd";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			enable-active-high;
+			gpio = <&gpio 169 0>; /* gpio PV1 */
+		};
+
+		vddio_sdmmc_reg: regulator@2 {
+			compatible = "regulator-fixed";
+			reg = <2>;
+			regulator-name  = "vddio_sdmmc";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+		};
 	};
 
 	sound {
diff --git a/arch/arm/boot/dts/tegra20-seaboard.dts b/arch/arm/boot/dts/tegra20-seaboard.dts
index eafeca6..1b7d692 100644
--- a/arch/arm/boot/dts/tegra20-seaboard.dts
+++ b/arch/arm/boot/dts/tegra20-seaboard.dts
@@ -450,7 +450,7 @@
 					regulator-always-on;
 				};
 
-				ldo5 {
+				ldo5_reg: ldo5 {
 					regulator-name = "vdd_ldo5,vcore_mmc";
 					regulator-min-microvolt = <2850000>;
 					regulator-max-microvolt = <2850000>;
@@ -565,6 +565,9 @@
 		status = "okay";
 		power-gpios = <&gpio 86 0>; /* gpio PK6 */
 		bus-width = <4>;
+		vmmc-supply = <&vddio_sdmmc_reg>;
+		vqmmc-supply = <&vddio_sdmmc_reg>;
+
 	};
 
 	sdhci@c8000400 {
@@ -573,11 +576,15 @@
 		wp-gpios = <&gpio 57 0>; /* gpio PH1 */
 		power-gpios = <&gpio 70 0>; /* gpio PI6 */
 		bus-width = <4>;
+		vmmc-supply = <&vddio_sd_reg>;
+		vqmmc-supply = <&vddio_sd_reg>;
 	};
 
 	sdhci@c8000600 {
 		status = "okay";
 		bus-width = <8>;
+		vmmc-supply = <&ldo5_reg>;
+		vqmmc-supply = <&vddio_nand_reg>;
 	};
 
 	gpio-keys {
@@ -632,6 +639,32 @@
 			gpio = <&pmic 1 0>;
 			enable-active-high;
 		};
+
+		vddio_sd_reg: regulator@3 {
+			compatible = "regulator-fixed";
+			reg = <3>;
+			regulator-name = "vddio_sd";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			gpio = <&gpio 176 0>; /* gpio PW0 */
+			enable-active-high;
+		};
+
+		vddio_sdmmc_reg: regulator@4 {
+			compatible = "regulator-fixed";
+			reg = <4>;
+			regulator-name = "vddio_sdmmc";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+		};
+
+		vddio_nand_reg: regulator@5 {
+			compatible = "regulator-fixed";
+			reg = <5>;
+			regulator-name = "vddio_nand";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
 	};
 
 	sound {
diff --git a/arch/arm/boot/dts/tegra20-tamonten.dtsi b/arch/arm/boot/dts/tegra20-tamonten.dtsi
index 5b3d8b1..a60e828 100644
--- a/arch/arm/boot/dts/tegra20-tamonten.dtsi
+++ b/arch/arm/boot/dts/tegra20-tamonten.dtsi
@@ -396,6 +396,8 @@
 		wp-gpios = <&gpio 59 0>; /* gpio PH3 */
 		bus-width = <4>;
 		status = "okay";
+		vmmc-supply = <&vddio_sdmmc_reg>;
+		vqmmc-supply = <&vddio_sdmmc_reg>;
 	};
 
 	regulators {
@@ -412,5 +414,13 @@
 			regulator-max-microvolt = <5000000>;
 			regulator-always-on;
 		};
+
+		vddio_sdmmc_reg: regulator@1 {
+			compatible = "regulator-fixed";
+			reg = <1>;
+			regulator-name = "vddio_sdmmc";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+		};
 	};
 };
diff --git a/arch/arm/boot/dts/tegra20-ventana.dts b/arch/arm/boot/dts/tegra20-ventana.dts
index bec8bb2..0210670 100644
--- a/arch/arm/boot/dts/tegra20-ventana.dts
+++ b/arch/arm/boot/dts/tegra20-ventana.dts
@@ -376,7 +376,7 @@
 					regulator-always-on;
 				};
 
-				ldo5 {
+				ldo5_reg: ldo5 {
 					regulator-name = "vdd_ldo5,vcore_mmc";
 					regulator-min-microvolt = <2850000>;
 					regulator-max-microvolt = <2850000>;
@@ -439,19 +439,24 @@
 		status = "okay";
 		power-gpios = <&gpio 86 0>; /* gpio PK6 */
 		bus-width = <4>;
+		vmmc-supply = <&vddio_sdmmc_reg>;
+		vqmmc-supply = <&vddio_sdmmc_reg>;
 	};
 
 	sdhci@c8000400 {
 		status = "okay";
 		cd-gpios = <&gpio 69 0>; /* gpio PI5 */
 		wp-gpios = <&gpio 57 0>; /* gpio PH1 */
-		power-gpios = <&gpio 70 0>; /* gpio PI6 */
 		bus-width = <4>;
+		vmmc-supply = <&vddio_sd_reg>;
+		vqmmc-supply = <&vddio_sd_reg>;
 	};
 
 	sdhci@c8000600 {
 		status = "okay";
 		bus-width = <8>;
+		vmmc-supply = <&ldo5_reg>;
+		vqmmc-supply = <&vddio_nand_reg>;
 	};
 
 	regulators {
@@ -506,6 +511,33 @@
 			gpio = <&gpio 176 0>; /* gpio PW0 */
 			enable-active-high;
 		};
+
+		vddio_sd_reg: regulator@5 {
+			compatible = "regulator-fixed";
+			reg = <5>;
+			regulator-name = "vddio_sd";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			gpio = <&gpio 70 0>; /* gpio PW0 */
+			enable-active-high;
+		};
+
+		vddio_sdmmc_reg: regulator@6 {
+			compatible = "regulator-fixed";
+			reg = <6>;
+			regulator-name = "vddio_sdmmc";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+		};
+
+		vddio_nand_reg: regulator@7 {
+			compatible = "regulator-fixed";
+			reg = <7>;
+			regulator-name = "vddio_nand";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <1800000>;
+		};
+
 	};
 
 	sound {
diff --git a/arch/arm/boot/dts/tegra20-whistler.dts b/arch/arm/boot/dts/tegra20-whistler.dts
index 94a71c9..bdc4918 100644
--- a/arch/arm/boot/dts/tegra20-whistler.dts
+++ b/arch/arm/boot/dts/tegra20-whistler.dts
@@ -349,7 +349,7 @@
 					regulator-always-on;
 				};
 
-				ldo5 {
+				ldo5_reg: ldo5 {
 					regulator-name = "nvvdd_ldo5,vcore_mmc,avdd_lcd1,vddio_1wire";
 					regulator-min-microvolt = <2800000>;
 					regulator-max-microvolt = <2800000>;
@@ -394,7 +394,7 @@
 					regulator-max-microvolt = <3300000>;
 				};
 
-				ldo12 {
+				ldo12_reg: ldo12 {
 					regulator-name = "nvvdd_ldo12,vddio_sdio";
 					regulator-min-microvolt = <2800000>;
 					regulator-max-microvolt = <2800000>;
@@ -496,11 +496,16 @@
 		status = "okay";
 		wp-gpios = <&gpio 173 0>; /* gpio PV5 */
 		bus-width = <8>;
+		vmmc-supply = <&ldo12_reg>;
+		vqmmc-supply = <&ldo12_reg>;
 	};
 
 	sdhci@c8000600 {
 		status = "okay";
 		bus-width = <8>;
+		vmmc-supply = <&ldo5_reg>;
+		vqmmc-supply = <&ldo5_reg>;
+
 	};
 
 	regulators {
diff --git a/arch/arm/boot/dts/tegra30-cardhu-a02.dts b/arch/arm/boot/dts/tegra30-cardhu-a02.dts
index adc88aa..697effa 100644
--- a/arch/arm/boot/dts/tegra30-cardhu-a02.dts
+++ b/arch/arm/boot/dts/tegra30-cardhu-a02.dts
@@ -88,6 +88,8 @@
 		status = "okay";
 		power-gpios = <&gpio 28 0>; /* gpio PD4 */
 		bus-width = <4>;
+		vmmc-supply = <&vio_reg>;
+		vqmmc-supply = <&vio_reg>;
 	};
 };
 
diff --git a/arch/arm/boot/dts/tegra30-cardhu-a04.dts b/arch/arm/boot/dts/tegra30-cardhu-a04.dts
index 08163e1..ee4820a 100644
--- a/arch/arm/boot/dts/tegra30-cardhu-a04.dts
+++ b/arch/arm/boot/dts/tegra30-cardhu-a04.dts
@@ -100,5 +100,7 @@
 		status = "okay";
 		power-gpios = <&gpio 27 0>; /* gpio PD3 */
 		bus-width = <4>;
+		vmmc-supply = <&vio_reg>;
+		vqmmc-supply = <&vio_reg>;
 	};
 };
diff --git a/arch/arm/boot/dts/tegra30-cardhu.dtsi b/arch/arm/boot/dts/tegra30-cardhu.dtsi
index b245e6c..fbf0fae 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dtsi
+++ b/arch/arm/boot/dts/tegra30-cardhu.dtsi
@@ -247,7 +247,7 @@
 
 				ldo5_reg: ldo5 {
 					regulator-name = "vddio_sdmmc,avdd_vdac";
-					regulator-min-microvolt = <3300000>;
+					regulator-min-microvolt = <1800000>;
 					regulator-max-microvolt = <3300000>;
 					regulator-always-on;
 				};
@@ -290,13 +290,16 @@
 		status = "okay";
 		cd-gpios = <&gpio 69 0>; /* gpio PI5 */
 		wp-gpios = <&gpio 155 0>; /* gpio PT3 */
-		power-gpios = <&gpio 31 0>; /* gpio PD7 */
 		bus-width = <4>;
+		vmmc-supply = <&sdcard_3v3_reg>;
+		vqmmc-supply = <&ldo5_reg>;
 	};
 
 	sdhci@78000600 {
 		status = "okay";
 		bus-width = <8>;
+		vmmc-supply = <&emmc_3v3_reg>;
+		vqmmc-supply = <&vio_reg>;
 	};
 
 	regulators {
@@ -451,6 +454,18 @@
 			gpio-open-drain;
 			vin-supply = <&vdd_5v0_reg>;
 		};
+
+		sdcard_3v3_reg: regulator@13 {
+			compatible = "regulator-fixed";
+			reg = <13>;
+			regulator-name = "sdcard_3v3";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			enable-active-high;
+			gpio = <&gpio 31 0>; /* GPIO PD7 */
+			vin-supply = <&sys_3v3_reg>;
+		};
+
 	};
 
 	sound {
-- 
1.7.1.1

