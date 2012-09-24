Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab2IXTZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 15:25:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:56794 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab2IXTZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 15:25:17 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        AnilKumar Ch <anilkumar@ti.com>, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 4/4] mfd: max8907: remove regulator-compatible from DT docs
Date: Mon, 24 Sep 2012 13:25:03 -0600
Message-Id: <1348514703-10152-5-git-send-email-swarren@wwwdotorg.org>
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
the MAX8907 binding documentation to reflect this.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
This commit is based on the MFD branch.
---
 .../devicetree/bindings/regulator/max8907.txt      |   24 ++++++-------------
 1 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/Documentation/devicetree/bindings/regulator/max8907.txt b/Documentation/devicetree/bindings/regulator/max8907.txt
index 51e683b..371eccd 100644
--- a/Documentation/devicetree/bindings/regulator/max8907.txt
+++ b/Documentation/devicetree/bindings/regulator/max8907.txt
@@ -12,15 +12,16 @@ Required properties:
 ...
 - in20-supply: The input supply for LDO20.
 - regulators: A node that houses a sub-node for each regulator within the
-  device. Each sub-node is identified using the regulator-compatible
-  property, with valid values listed below. The content of each sub-node
-  is defined by the standard binding for regulators; see regulator.txt.
+  device. Each sub-node is identified using the node's name (or the deprecated
+  regulator-compatible property if present), with valid values listed below.
+  The content of each sub-node is defined by the standard binding for
+  regulators; see regulator.txt.
 
 Optional properties:
 - maxim,system-power-controller: Boolean property indicating that the PMIC
   controls the overall system power.
 
-Valid regulator-compatible values are:
+The valid names for regulators are:
 
   sd1, sd2, sd3, ldo1, ldo2, ldo3, ldo4, ldo5, ldo6, ldo7, ldo8, ldo9, ldo10,
   ldo11, ldo12, ldo13, ldo14, ldo15, ldo16, ldo17, ldo18, ldo19, ldo20, out5v,
@@ -42,30 +43,21 @@ Example:
 			...
 
 			regulators {
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				mbatt_reg: regulator@0 {
-					reg = <0>;
-					regulator-compatible = "mbatt";
+				mbatt_reg: mbatt {
 					regulator-name = "vbat_pmu";
 					regulator-min-microvolt = <5000000>;
 					regulator-max-microvolt = <5000000>;
 					regulator-always-on;
 				};
 
-				regulator@1 {
-					reg = <1>;
-					regulator-compatible = "sd1";
+				sd1 {
 					regulator-name = "nvvdd_sv1,vdd_cpu_pmu";
 					regulator-min-microvolt = <1000000>;
 					regulator-max-microvolt = <1000000>;
 					regulator-always-on;
 				};
 
-				regulator@2 {
-					reg = <2>;
-					regulator-compatible = "sd2";
+				sd2 {
 					regulator-name = "nvvdd_sv2,vdd_core";
 					regulator-min-microvolt = <1200000>;
 					regulator-max-microvolt = <1200000>;
-- 
1.7.0.4

