Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab2IXTZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:25:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:46260 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757907Ab2IXTZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:25:16 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        AnilKumar Ch <anilkumar@ti.com>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 3/4] regulator: tps6586x: remove regulator-compatible from DT docs
Date: Mon, 24 Sep 2012 13:25:02 -0600
Message-Id: <1348514703-10152-4-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1348514703-10152-1-git-send-email-swarren@wwwdotorg.org>
References: <1348514703-10152-1-git-send-email-swarren@wwwdotorg.org>
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Commit "regulator: deprecate regulator-compatible DT property" deprecated
the use of the regulator-compatible DT property. Update the DT example in
the TPS6586x binding documentation to reflect this.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
This commit is based on regulator's topic/tps6586x branch.
---
 .../devicetree/bindings/regulator/tps6586x.txt     |   66 ++++++--------------
 1 files changed, 19 insertions(+), 47 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/tps6586x.txt b/Documentation/devicetree/bindings/regulator/tps6586x.txt
index 9b05e24..8b40cac 100644
--- a/Documentation/devicetree/bindings/regulator/tps6586x.txt
+++ b/Documentation/devicetree/bindings/regulator/tps6586x.txt
@@ -6,8 +6,11 @@ Required properties:
 - interrupts: the interrupt outputs of the controller
 - #gpio-cells: number of cells to describe a GPIO
 - gpio-controller: mark the device as a GPIO controller
-- regulators: list of regulators provided by this controller, must have
-  property "regulator-compatible" to match their hardware counterparts:
+- regulators: A node that houses a sub-node for each regulator within the
+  device. Each sub-node is identified using the node's name (or the deprecated
+  regulator-compatible property if present), with valid values listed below.
+  The content of each sub-node is defined by the standard binding for
+  regulators; see regulator.txt.
   sys, sm[0-2], ldo[0-9] and ldo_rtc
 - sys-supply: The input supply for SYS.
 - vin-sm0-supply: The input supply for the SM0.
@@ -51,111 +54,80 @@ Example:
 		vinldo9-supply = <...>;
 
 		regulators {
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			sys_reg: regulator@0 {
-				reg = <0>;
-				regulator-compatible = "sys";
+			sys_reg: sys {
 				regulator-name = "vdd_sys";
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			sm0_reg: regulator@1 {
-				reg = <1>;
-				regulator-compatible = "sm0";
+			sm0_reg: sm0 {
 				regulator-min-microvolt = < 725000>;
 				regulator-max-microvolt = <1500000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			sm1_reg: regulator@2 {
-				reg = <2>;
-				regulator-compatible = "sm1";
+			sm1_reg: sm1 {
 				regulator-min-microvolt = < 725000>;
 				regulator-max-microvolt = <1500000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			sm2_reg: regulator@3 {
-				reg = <3>;
-				regulator-compatible = "sm2";
+			sm2_reg: sm2 {
 				regulator-min-microvolt = <3000000>;
 				regulator-max-microvolt = <4550000>;
 				regulator-boot-on;
 				regulator-always-on;
 			};
 
-			ldo0_reg: regulator@4 {
-				reg = <4>;
-				regulator-compatible = "ldo0";
+			ldo0_reg: ldo0 {
 				regulator-name = "PCIE CLK";
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo1_reg: regulator@5 {
-				reg = <5>;
-				regulator-compatible = "ldo1";
+			ldo1_reg: ldo1 {
 				regulator-min-microvolt = < 725000>;
 				regulator-max-microvolt = <1500000>;
 			};
 
-			ldo2_reg: regulator@6 {
-				reg = <6>;
-				regulator-compatible = "ldo2";
+			ldo2_reg: ldo2 {
 				regulator-min-microvolt = < 725000>;
 				regulator-max-microvolt = <1500000>;
 			};
 
-			ldo3_reg: regulator@7 {
-				reg = <7>;
-				regulator-compatible = "ldo3";
+			ldo3_reg: ldo3 {
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo4_reg: regulator@8 {
-				reg = <8>;
-				regulator-compatible = "ldo4";
+			ldo4_reg: ldo4 {
 				regulator-min-microvolt = <1700000>;
 				regulator-max-microvolt = <2475000>;
 			};
 
-			ldo5_reg: regulator@9 {
-				reg = <9>;
-				regulator-compatible = "ldo5";
+			ldo5_reg: ldo5 {
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo6_reg: regulator@10 {
-				reg = <10>;
-				regulator-compatible = "ldo6";
+			ldo6_reg: ldo6 {
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo7_reg: regulator@11 {
-				reg = <11>;
-				regulator-compatible = "ldo7";
+			ldo7_reg: ldo7 {
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo8_reg: regulator@12 {
-				reg = <12>;
-				regulator-compatible = "ldo8";
+			ldo8_reg: ldo8 {
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
 
-			ldo9_reg: regulator@13 {
-				reg = <13>;
-				regulator-compatible = "ldo9";
+			ldo9_reg: ldo9 {
 				regulator-min-microvolt = <1250000>;
 				regulator-max-microvolt = <3300000>;
 			};
-- 
1.7.0.4

