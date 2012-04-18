Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab2DRBER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 21:04:17 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13450 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214Ab2DRBEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 21:04:14 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 17 Apr 2012 18:04:09 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Samuel Ortiz <sameo@linux.intel.com>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 4/4] ARM: Tegra: Add support for TPS65910 PMIC
Date: Tue, 17 Apr 2012 18:00:29 -0700
Message-ID: <1334710829-22777-5-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1334710829-22777-1-git-send-email-rklein@nvidia.com>
References: <1334710829-22777-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for the tps65910 pmic on cardhu.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 arch/arm/boot/dts/tegra-cardhu.dts |   92 ++++++++++++++++++++++++++++++++++++
 1 files changed, 92 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/tegra-cardhu.dts b/arch/arm/boot/dts/tegra-cardhu.dts
index ab8d901..7db4fac 100644
--- a/arch/arm/boot/dts/tegra-cardhu.dts
+++ b/arch/arm/boot/dts/tegra-cardhu.dts
@@ -115,6 +115,98 @@
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
+			ti,regulator-ext-sleep-control = < 0
+						0
+						0x4     /* input EN3 */
+						0
+						0x1     /* input EN1 */
+						0
+						0
+						0
+						0
+						0
+						0
+						0x1     /* input EN1 */
+						0x1>;   /* input EN1 */
+			ti,en-gpio-sleep = <0 0 1 0 0 0 0 0 0>;
+
+			regulators {
+				vdd1_reg: vdd1 {
+					regulator-min-microvolt = < 600000>;
+					regulator-max-microvolt = <1500000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+				vdd2_reg: vdd2 {
+					regulator-min-microvolt = < 600000>;
+					regulator-max-microvolt = <1500000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+				vddctrl_reg: vddctrl {
+					regulator-min-microvolt = < 600000>;
+					regulator-max-microvolt = <1400000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+				vio_reg: vio {
+					regulator-min-microvolt = <1500000>;
+					regulator-max-microvolt = <1800000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+				ldo1_reg: ldo1 {
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+				};
+				ldo2_reg: ldo2 {
+					regulator-min-microvolt = <1050000>;
+					regulator-max-microvolt = <1050000>;
+				};
+				ldo3_reg: ldo3 {
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+				};
+				ldo4_reg: ldo4 {
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+				ldo5_reg: ldo5 {
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+				};
+				ldo6_reg: ldo6 {
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+				};
+				ldo7_reg: ldo7 {
+					regulator-min-microvolt = <1200000>;
+					regulator-max-microvolt = <1200000>;
+					regulator-always-on;
+					regulator-boot-on;
+				};
+				ldo8_reg: ldo8 {
+					regulator-min-microvolt = <1000000>;
+					regulator-max-microvolt = <3300000>;
+					regulator-always-on;
+				};
+			};
+		};
 	};
 
 	sdhci@78000000 {
-- 
1.7.0.4

