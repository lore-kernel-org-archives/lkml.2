Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab3ADIbz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 03:31:55 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:47988 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab3ADIbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 03:31:53 -0500
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: thomas.abraham@linaro.org, kgene.kim@samsung.com, linux@arm.linux.org.uk,
        patches@linaro.org
Subject: [PATCH] ARM: DTS: exynos4210-origen: Add MAX8997 node entry
Date: Fri,  4 Jan 2013 13:53:49 +0530
Message-Id: <1357287829-21701-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The node entry is added as per documentation and legacy board file.

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
The patch is rebased on v3.8-rc1.

 arch/arm/boot/dts/exynos4210-origen.dts |  150 +++++++++++++++++++++++++++++++
 1 files changed, 150 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/exynos4210-origen.dts b/arch/arm/boot/dts/exynos4210-origen.dts
index f271001..362ef58 100644
--- a/arch/arm/boot/dts/exynos4210-origen.dts
+++ b/arch/arm/boot/dts/exynos4210-origen.dts
@@ -121,4 +121,154 @@
 			linux,default-trigger = "heartbeat";
 		};
 	};
+
+	i2c@13860000 {
+		#address-cells = <1>;
+		#size-cells = <0>;
+		samsung,i2c-sda-delay = <100>;
+		samsung,i2c-max-bus-freq = <20000>;
+		pinctrl-0 = <&i2c0_bus>;
+		pinctrl-names = "default";
+		status = "okay";
+
+		max8997_pmic@66 {
+			compatible = "maxim,max8997-pmic";
+			reg = <0x66>;
+			interrupt-parent = <&gpx0>;
+			interrupts = <4 0>, <3 0>;
+
+			max8997,pmic-ignore-gpiodvs-side-effect;
+			max8997,pmic-buck125-default-dvs-idx = <0>;
+			max8997,pmic-buck125-dvs-gpios = <&gpx0 0 0>,
+							 <&gpx0 1 0>,
+							 <&gpx0 2 0>;
+			max8997,pmic-buck1-dvs-voltage = <1350000>, <1300000>,
+							 <1250000>, <1200000>,
+							 <1150000>, <1100000>,
+							 <1000000>, <950000>;
+			max8997,pmic-buck2-dvs-voltage = <1100000>, <1100000>,
+							 <1100000>, <1100000>,
+							 <1000000>, <1000000>,
+							 <1000000>, <1000000>;
+			max8997,pmic-buck5-dvs-voltage = <1200000>, <1200000>,
+							 <1200000>, <1200000>,
+							 <1200000>, <1200000>,
+							 <1200000>, <1200000>;
+
+			regulators {
+				ldo1_reg: LDO1 {
+					regulator-name = "VDD_ABB_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+				};
+
+				ldo2_reg: LDO2 {
+					regulator-name = "VDD_ALIVE_1.1V";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <1100000>;
+					regulator-always-on;
+				};
+
+				ldo3_reg: LDO3 {
+					regulator-name = "VMIPI_1.1V";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <1100000>;
+					regulator-always-on;
+				};
+
+				ldo4_reg: LDO4 {
+					regulator-name = "VDD_RTC_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt	= <1800000>;
+					regulator-always-on;
+				};
+
+				ldo6_reg: LDO6 {
+					regulator-name = "VMIPI_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt	= <1800000>;
+					regulator-always-on;
+				};
+
+				ldo7_reg: LDO7 {
+					regulator-name = "VDD_AUD_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt	= <1800000>;
+					regulator-always-on;
+				};
+
+				ldo8_reg: LDO8 {
+					regulator-name = "VADC_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+
+				ldo9_reg: LDO9 {
+					regulator-name = "DVDD_SWB_2.8V";
+					regulator-min-microvolt = <2800000>;
+					regulator-max-microvolt = <2800000>;
+					regulator-always-on;
+				};
+
+				ldo10_reg: LDO10 {
+					regulator-name = "VDD_PLL_1.1V";
+					regulator-min-microvolt = <1100000>;
+					regulator-max-microvolt = <1100000>;
+					regulator-always-on;
+				};
+
+				ldo11_reg: LDO11 {
+					regulator-name = "VDD_AUD_3V";
+					regulator-min-microvolt = <3000000>;
+					regulator-max-microvolt = <3000000>;
+				};
+
+				ldo14_reg: LDO14 {
+					regulator-name = "AVDD18_SWB_1.8V";
+					regulator-min-microvolt = <1800000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+				};
+
+				ldo17_reg: LDO17 {
+					regulator-name = "VDD_SWB_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+
+				buck1_reg: BUCK1 {
+					regulator-name = "vdd_arm";
+					regulator-min-microvolt = <950000>;
+					regulator-max-microvolt = <1350000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				buck2_reg: BUCK2 {
+					regulator-name = "vdd_int";
+					regulator-min-microvolt = <900000>;
+					regulator-max-microvolt = <1100000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+
+				buck5_reg: BUCK5 {
+					regulator-name = "VDDQ_M1M2_1.2V";
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+				};
+
+				buck7_reg: BUCK7 {
+					regulator-name = "VDD_LCD_3.3V";
+					regulator-min-microvolt = <3300000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-boot-on;
+				};
+			};
+		};
+	};
+
 };
-- 
1.7.4.1

