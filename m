Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757563Ab2HHHEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 03:04:09 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17758 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757118Ab2HHHEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 03:04:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 08 Aug 2012 00:03:54 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <swarren@wwwdotorg.org>, <olof@lixom.net>
CC: <linux@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 1/3] ARM: dt: tegra: cardhu: add entry for PMIC TPS65911.
Date: Wed, 8 Aug 2012 12:18:45 +0530
Message-ID: <1344408527-32051-2-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1344408527-32051-1-git-send-email-ldewangan@nvidia.com>
References: <1344408527-32051-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tegra30 based platform "cardhu" have the power management
IC TPS65911 for the regulator.
Adding DT entry for this device.
Data are chosen from downstream kernel and making the
voltage output as require by default for device to
operate.
The default interrupt line is HIGH from PMIC device and so
inverting the interrupt detection line of PMU interrupt
through configuring PMC.
In this patch, do not registering LDO5 because the input
supply for this rail is different for different version of
cardhu i..e A02 and A04. The registration will be done once
the dts file for cardhu A02 and A04 are added in follow on
patches.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 arch/arm/boot/dts/tegra30-cardhu.dts |  134 ++++++++++++++++++++++++++++++++++
 1 files changed, 134 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-cardhu.dts b/arch/arm/boot/dts/tegra30-cardhu.dts
index c169bce..6f9daae 100644
--- a/arch/arm/boot/dts/tegra30-cardhu.dts
+++ b/arch/arm/boot/dts/tegra30-cardhu.dts
@@ -126,6 +126,120 @@
 			ti,vsel0-state-high;
 			ti,vsel1-state-high;
 		};
+
+		pmic: tps65911@2d {
+			compatible = "ti,tps65911";
+			reg = <0x2d>;
+
+			interrupts = <0 86 0x4>;
+			#interrupt-cells = <2>;
+			interrupt-controller;
+
+			#gpio-cells = <2>;
+			gpio-controller;
+
+			vcc1-supply = <&vdd_ac_bat_reg>;
+			vcc2-supply = <&vdd_ac_bat_reg>;
+			vcc3-supply = <&vio_reg>;
+			vcc5-supply = <&vdd_ac_bat_reg>;
+			vcc6-supply = <&vdd2_reg>;
+			vcc7-supply = <&vdd_ac_bat_reg>;
+			vccio-supply = <&vdd_ac_bat_reg>;
+
+			regulators {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				vdd1_reg: regulator@0 {
+					reg = <0>;
+					regulator-compatible = "vdd1";
+					regulator-name = "vddio_ddr_1v2";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+				};
+
+				vdd2_reg: regulator@1 {
+					reg = <1>;
+					regulator-compatible = "vdd2";
+					regulator-name = "vdd_1v5_gen";
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <1500000>;
+					regulator-always-on;
+				};
+
+				vddctrl_reg: regulator@2 {
+					reg = <2>;
+					regulator-compatible = "vddctrl";
+					regulator-name = "vdd_cpu,vdd_sys";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <1000000>;
+					regulator-always-on;
+				};
+
+				vio_reg: regulator@3 {
+					reg = <3>;
+					regulator-compatible = "vio";
+					regulator-name = "vdd_1v8_gen";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+				};
+
+				ldo1_reg: regulator@4 {
+					reg = <4>;
+					regulator-compatible = "ldo1";
+					regulator-name = "vdd_pexa,vdd_pexb";
+					regulator-min-microvolt = <1050000>;
+					regulator-max-microvolt = <1050000>;
+				};
+
+				ldo2_reg: regulator@5 {
+					reg = <5>;
+					regulator-compatible = "ldo2";
+					regulator-name = "vdd_sata,avdd_plle";
+					regulator-min-microvolt = <1050000>;
+					regulator-max-microvolt = <1050000>;
+				};
+
+				/* LDO3 is not connected to anything */
+
+				ldo4_reg: regulator@7 {
+					reg = <7>;
+					regulator-compatible = "ldo4";
+					regulator-name = "vdd_rtc";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+				};
+
+				ldo6_reg: regulator@9 {
+					reg = <9>;
+					regulator-compatible = "ldo6";
+					regulator-name = "avdd_dsi_csi,pwrdet_mipi";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+				};
+
+				ldo7_reg: regulator@10 {
+					reg = <10>;
+					regulator-compatible = "ldo7";
+					regulator-name = "vdd_pllm,x,u,a_p_c_s";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+				};
+
+				ldo8_reg: regulator@11 {
+					reg = <11>;
+					regulator-compatible = "ldo8";
+					regulator-name = "vdd_ddr_hs";
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <1000000>;
+					regulator-always-on;
+				};
+			};
+		};
 	};
 
 	ahub {
@@ -134,6 +248,11 @@
 		};
 	};
 
+	pmc {
+		status = "okay";
+		nvidia,invert-interrupt;
+	};
+
 	sdhci@78000000 {
 		status = "okay";
 		cd-gpios = <&gpio 69 0>; /* gpio PI5 */
@@ -147,6 +266,21 @@
 		bus-width = <8>;
 	};
 
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vdd_ac_bat_reg: regulator@0 {
+			compatible = "regulator-fixed";
+			reg = <0>;
+			regulator-name = "vdd_ac_bat";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			regulator-always-on;
+		};
+	};
+
 	sound {
 		compatible = "nvidia,tegra-audio-wm8903-cardhu",
 			     "nvidia,tegra-audio-wm8903";
-- 
1.7.1.1

