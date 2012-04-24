Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166Ab2DXXgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:36:31 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16932 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab2DXXg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:36:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 24 Apr 2012 16:36:16 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 8/8 v2] ARM: Tegra: Add support for TPS65910 PMIC
Date: Tue, 24 Apr 2012 16:36:10 -0700
Message-ID: <1335310570-12455-9-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335310570-12455-1-git-send-email-rklein@nvidia.com>
References: <1335310570-12455-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the tps65910 pmic on cardhu.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 v2: updated to move the ext-sleep-control into the regulator nodes

 arch/arm/boot/dts/tegra-cardhu.dts |   91 ++++++++++++++++++++++++++++++++++++
 1 files changed, 91 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-cardhu.dts b/arch/arm/boot/dts/tegra-cardhu.dts
index ab8d901..ed02abb 100644
--- a/arch/arm/boot/dts/tegra-cardhu.dts
+++ b/arch/arm/boot/dts/tegra-cardhu.dts
@@ -115,6 +115,97 @@
 			micdet-delay = <100>;
 			gpio-cfg = <0xffffffff 0xffffffff 0 0xffffffff 0xffffffff>;
 		};
+
+		pmic: tps65911@2d {
+			compatible = "ti,tps65911";
+			reg = <0x2d>;
+			interrupts = < 0 118 0x04 >;
+
+			#gpio-cells = <2>;
+			gpio-controller;
+
+			#interrupt-cells = <2>;
+			interrupt-controller;
+
+			ti,vmbch-threshold = <0>;
+			ti,vmbch2-threshold = <0>;
+			ti,en-gpio-sleep = <0 0 1 0 0 0 0 0 0>;
+
+			regulators {
+				vdd1_reg: vdd1 {
+					regulator-min-microvolt = < 600000>;
+					regulator-max-microvolt = <1500000>;
+					regulator-always-on;
+					regulator-boot-on;
+					ti,regulator-ext-sleep-control = <4>;
+				};
+				vdd2_reg: vdd2 {
+					regulator-min-microvolt = < 600000>;
+					regulator-max-microvolt = <1500000>;
+					regulator-always-on;
+					regulator-boot-on;
+					ti,regulator-ext-sleep-control = <0>;
+				};
+				vddctrl_reg: vddctrl {
+					regulator-min-microvolt = < 600000>;
+					regulator-max-microvolt = <1400000>;
+					regulator-always-on;
+					regulator-boot-on;
+					ti,regulator-ext-sleep-control = <1>;
+				};
+				vio_reg: vio {
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+					regulator-boot-on;
+					ti,regulator-ext-sleep-control = <0>;
+				};
+				ldo1_reg: ldo1 {
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+					ti,regulator-ext-sleep-control = <0>;
+				};
+				ldo2_reg: ldo2 {
+					regulator-min-microvolt = <1050000>;
+					regulator-max-microvolt = <1050000>;
+					ti,regulator-ext-sleep-control = <0>;
+				};
+				ldo3_reg: ldo3 {
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+					ti,regulator-ext-sleep-control = <0>;
+				};
+				ldo4_reg: ldo4 {
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+					ti,regulator-ext-sleep-control = <0>;
+				};
+				ldo5_reg: ldo5 {
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+					ti,regulator-ext-sleep-control = <0>;
+				};
+				ldo6_reg: ldo6 {
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					ti,regulator-ext-sleep-control = <0>;
+				};
+				ldo7_reg: ldo7 {
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+					regulator-boot-on;
+					ti,regulator-ext-sleep-control = <1>;
+				};
+				ldo8_reg: ldo8 {
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+					ti,regulator-ext-sleep-control = <1>;
+				};
+			};
+		};
 	};
 
 	sdhci@78000000 {
-- 
1.7.0.4

