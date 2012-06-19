Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab2FSGBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:01:44 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4042 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753305Ab2FSGBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:01:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 18 Jun 2012 22:58:59 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <lrg@ti.com>,
        <rob.herring@calxeda.com>, <grant.likely@secretlab.ca>,
        <swarren@wwwdotorg.org>
CC: <sameo@linux.intel.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 2/2] regulator: tps65910: dt: identify regulator by regulator-compatible
Date: Tue, 19 Jun 2012 11:21:27 +0530
Message-ID: <1340085087-6608-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1340085087-6608-1-git-send-email-ldewangan@nvidia.com>
References: <1340085087-6608-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the property of "regulator-compatible" for each
regulator to match with the device regulators.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 Documentation/devicetree/bindings/mfd/tps65910.txt |   54 +++++++++++++++-----
 drivers/regulator/tps65910-regulator.c             |    3 +-
 2 files changed, 43 insertions(+), 14 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/tps65910.txt b/Documentation/devicetree/bindings/mfd/tps65910.txt
index 645f5ea..5407a10 100644
--- a/Documentation/devicetree/bindings/mfd/tps65910.txt
+++ b/Documentation/devicetree/bindings/mfd/tps65910.txt
@@ -17,8 +17,9 @@ Required properties:
   device need to be present. The definition for each of these nodes is defined
   using the standard binding for regulators found at
   Documentation/devicetree/bindings/regulator/regulator.txt.
+  The regulator is matched with the regulator-compatible.
 
-  The valid names for regulators are:
+  The valid regulator-compatible for regulators are:
   tps65910: vrtc, vio, vdd1, vdd2, vdd3, vdig1, vdig2, vpll, vdac, vaux1,
             vaux2, vaux33, vmmc
   tps65911: vrtc, vio, vdd1, vdd3, vddctrl, ldo1, ldo2, ldo3, ldo4, ldo5,
@@ -57,73 +58,100 @@ Example:
 		ti,en-gpio-sleep = <0 0 1 0 0 0 0 0 0>;
 
 		regulators {
-			vdd1_reg: vdd1 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			vdd1_reg: regulator@0 {
+				regulator-compatible = "vdd1";
+				reg = <0>;
 				regulator-min-microvolt = < 600000>;
 				regulator-max-microvolt = <1500000>;
 				regulator-always-on;
 				regulator-boot-on;
 				ti,regulator-ext-sleep-control = <0>;
 			};
-			vdd2_reg: vdd2 {
+			vdd2_reg: regulator@1 {
+				regulator-compatible = "vdd2";
+				reg = <1>;
 				regulator-min-microvolt = < 600000>;
 				regulator-max-microvolt = <1500000>;
 				regulator-always-on;
 				regulator-boot-on;
 				ti,regulator-ext-sleep-control = <4>;
 			};
-			vddctrl_reg: vddctrl {
+			vddctrl_reg: regulator@2 {
+				regulator-compatible = "vddctrl";
+				reg = <2>;
 				regulator-min-microvolt = < 600000>;
 				regulator-max-microvolt = <1400000>;
 				regulator-always-on;
 				regulator-boot-on;
 				ti,regulator-ext-sleep-control = <0>;
 			};
-			vio_reg: vio {
+			vio_reg: regulator@3 {
+				regulator-compatible = "vio";
+				reg = <3>;
 				regulator-min-microvolt = <1500000>;
 				regulator-max-microvolt = <1800000>;
 				regulator-always-on;
 				regulator-boot-on;
 				ti,regulator-ext-sleep-control = <1>;
 			};
-			ldo1_reg: ldo1 {
+			ldo1_reg: regulator@4 {
+				regulator-compatible = "ldo1";
+				reg = <4>;
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <3300000>;
 				ti,regulator-ext-sleep-control = <0>;
 			};
-			ldo2_reg: ldo2 {
+			ldo2_reg: regulator@5 {
+				regulator-compatible = "ldo2";
+				reg = <5>;
 				regulator-min-microvolt = <1050000>;
 				regulator-max-microvolt = <1050000>;
 				ti,regulator-ext-sleep-control = <0>;
 			};
-			ldo3_reg: ldo3 {
+			ldo3_reg: regulator@6 {
+				regulator-compatible = "ldo3";
+				reg = <6>;
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <3300000>;
 				ti,regulator-ext-sleep-control = <0>;
 			};
-			ldo4_reg: ldo4 {
+			ldo4_reg: regulator@7 {
+				regulator-compatible = "ldo4";
+				reg = <7>;
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-always-on;
 				ti,regulator-ext-sleep-control = <0>;
 			};
-			ldo5_reg: ldo5 {
+			ldo5_reg: regulator@8 {
+				regulator-compatible = "ldo5";
+				reg = <8>;
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <3300000>;
 				ti,regulator-ext-sleep-control = <0>;
 			};
-			ldo6_reg: ldo6 {
+			ldo6_reg: regulator@9 {
+				regulator-compatible = "ldo6";
+				reg = <9>;
 				regulator-min-microvolt = <1200000>;
 				regulator-max-microvolt = <1200000>;
 				ti,regulator-ext-sleep-control = <0>;
 			};
-			ldo7_reg: ldo7 {
+			ldo7_reg: regulator@10 {
+				regulator-compatible = "ldo7";
+				reg = <10>;
 				regulator-min-microvolt = <1200000>;
 				regulator-max-microvolt = <1200000>;
 				regulator-always-on;
 				regulator-boot-on;
 				ti,regulator-ext-sleep-control = <1>;
 			};
-			ldo8_reg: ldo8 {
+			ldo8_reg: regulator@11 {
+				regulator-compatible = "ldo8";
+				reg = <11>;
 				regulator-min-microvolt = <1000000>;
 				regulator-max-microvolt = <3300000>;
 				regulator-always-on;
diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
index 6bf864b..c2ee450 100644
--- a/drivers/regulator/tps65910-regulator.c
+++ b/drivers/regulator/tps65910-regulator.c
@@ -1106,7 +1106,8 @@ static struct tps65910_board *tps65910_parse_dt_reg_data(
 		return NULL;
 	}
 
-	ret = of_regulator_match(pdev->dev.parent, regulators, matches, count);
+	ret = of_regulator_match_by_compatible(pdev->dev.parent, regulators,
+			matches, count);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Error parsing regulator init data: %d\n",
 			ret);
-- 
1.7.1.1

