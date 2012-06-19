Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab2FSOix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 10:38:53 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13311 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab2FSOi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 10:38:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 19 Jun 2012 07:38:22 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <arnd@arndb.de>, <linus.walleij@linaro.org>,
        <lrg@ti.com>, <lee.jones@linaro.org>, <swarren@wwwdotorg.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 2/3] regulator: dt: add policy to have property "regulator-compatible"
Date: Tue, 19 Jun 2012 19:58:18 +0530
Message-ID: <1340116099-17629-3-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com>
References: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the policy for regulator DT such that each regulator child node
must have the property "regulator-compatible" which matches with
regulator name of their hardware counterparts.
Modify the dt documentation of regulator devices to reflect this
policy.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Changes from V1:
Add the doc change for the DT binding of tps6586x.

 Documentation/devicetree/bindings/mfd/tps65910.txt |   54 +++++++++++++----
 .../devicetree/bindings/regulator/tps6586x.txt     |   60 +++++++++++++++-----
 2 files changed, 86 insertions(+), 28 deletions(-)

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
diff --git a/Documentation/devicetree/bindings/regulator/tps6586x.txt b/Documentation/devicetree/bindings/regulator/tps6586x.txt
index 0fcabaa..ab17ef6 100644
--- a/Documentation/devicetree/bindings/regulator/tps6586x.txt
+++ b/Documentation/devicetree/bindings/regulator/tps6586x.txt
@@ -6,8 +6,9 @@ Required properties:
 - interrupts: the interrupt outputs of the controller
 - #gpio-cells: number of cells to describe a GPIO
 - gpio-controller: mark the device as a GPIO controller
-- regulators: list of regulators provided by this controller, must be named
-  after their hardware counterparts: sm[0-2], ldo[0-9] and ldo_rtc
+- regulators: list of regulators provided by this controller, must have
+  property "regulator-compatible" to match their hardware counterparts:
+  sm[0-2], ldo[0-9] and ldo_rtc
 
 Each regulator is defined using the standard binding for regulators.
 
@@ -22,74 +23,103 @@ Example:
 		gpio-controller;
 
 		regulators {
-			sm0_reg: sm0 {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			sm0_reg: regulator@0 {
+				reg = <0>;
+				regulator-compatible = "sm0";
 				regulator-min-microvolt = < 725000>;
 				regulator-max-microvolt = <1500000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			sm1_reg: sm1 {
+			sm1_reg: regulator@1 {
+				reg = <1>;
+				regulator-compatible = "sm1";
 				regulator-min-microvolt = < 725000>;
 				regulator-max-microvolt = <1500000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			sm2_reg: sm2 {
+			sm2_reg: regulator@2 {
+				reg = <2>;
+				regulator-compatible = "sm2";
 				regulator-min-microvolt = <3000000>;
 				regulator-max-microvolt = <4550000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			ldo0_reg: ldo0 {
+			ldo0_reg: regulator@3 {
+				reg = <3>;
+				regulator-compatible = "ldo0";
 				regulator-name = "PCIE CLK";
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo1_reg: ldo1 {
+			ldo1_reg: regulator@4 {
+				reg = <4>;
+				regulator-compatible = "ldo1";
 				regulator-min-microvolt = < 725000>;
 				regulator-max-microvolt = <1500000>;
 			};
 
-			ldo2_reg: ldo2 {
+			ldo2_reg: regulator@5 {
+				reg = <5>;
+				regulator-compatible = "ldo2";
 				regulator-min-microvolt = < 725000>;
 				regulator-max-microvolt = <1500000>;
 			};
 
-			ldo3_reg: ldo3 {
+			ldo3_reg: regulator@6 {
+				reg = <6>;
+				regulator-compatible = "ldo3";
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo4_reg: ldo4 {
+			ldo4_reg: regulator@7 {
+				reg = <7>;
+				regulator-compatible = "ldo4";
 				regulator-min-microvolt = <1700000>;
 				regulator-max-microvolt = <2475000>;
 			};
 
-			ldo5_reg: ldo5 {
+			ldo5_reg: regulator@8 {
+				reg = <8>;
+				regulator-compatible = "ldo5";
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo6_reg: ldo6 {
+			ldo6_reg: regulator@9 {
+				reg = <9>;
+				regulator-compatible = "ldo6";
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo7_reg: ldo7 {
+			ldo7_reg: regulator@10 {
+				reg = <10>;
+				regulator-compatible = "ldo7";
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo8_reg: ldo8 {
+			ldo8_reg: regulator@11 {
+				reg = <11>;
+				regulator-compatible = "ldo8";
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo9_reg: ldo9 {
+			ldo9_reg: regulator@12 {
+				reg = <12>;
+				regulator-compatible = "ldo9";
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
-- 
1.7.1.1

