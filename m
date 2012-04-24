Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab2DXXg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:36:26 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16921 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756636Ab2DXXgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 19:36:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 24 Apr 2012 16:36:13 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 4/8 v2] regulator: tps65910: Add device tree bindings
Date: Tue, 24 Apr 2012 16:36:06 -0700
Message-ID: <1335310570-12455-5-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1335310570-12455-1-git-send-email-rklein@nvidia.com>
References: <1335310570-12455-1-git-send-email-rklein@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree bindings for TI's tps65910 pmic.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 v2: Moved ext-sleep-control into regulator nodes

 Documentation/devicetree/bindings/mfd/tps65910.txt |  133 ++++++++++++++++++++
 1 files changed, 133 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/mfd/tps65910.txt

diff --git a/Documentation/devicetree/bindings/mfd/tps65910.txt b/Documentation/devicetree/bindings/mfd/tps65910.txt
new file mode 100644
index 0000000..645f5ea
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/tps65910.txt
@@ -0,0 +1,133 @@
+TPS65910 Power Management Integrated Circuit
+
+Required properties:
+- compatible: "ti,tps65910" or "ti,tps65911"
+- reg: I2C slave address
+- interrupts: the interrupt outputs of the controller
+- #gpio-cells: number of cells to describe a GPIO, this should be 2.
+  The first cell is the GPIO number.
+  The second cell is used to specify additional options <unused>.
+- gpio-controller: mark the device as a GPIO controller
+- #interrupt-cells: the number of cells to describe an IRQ, this should be 2.
+  The first cell is the IRQ number.
+  The second cell is the flags, encoded as the trigger masks from
+  Documentation/devicetree/bindings/interrupts.txt
+- regulators: This is the list of child nodes that specify the regulator
+  initialization data for defined regulators. Not all regulators for the given
+  device need to be present. The definition for each of these nodes is defined
+  using the standard binding for regulators found at
+  Documentation/devicetree/bindings/regulator/regulator.txt.
+
+  The valid names for regulators are:
+  tps65910: vrtc, vio, vdd1, vdd2, vdd3, vdig1, vdig2, vpll, vdac, vaux1,
+            vaux2, vaux33, vmmc
+  tps65911: vrtc, vio, vdd1, vdd3, vddctrl, ldo1, ldo2, ldo3, ldo4, ldo5,
+            ldo6, ldo7, ldo8
+
+Optional properties:
+- ti,vmbch-threshold: (tps65911) main battery charged threshold
+  comparator. (see VMBCH_VSEL in TPS65910 datasheet)
+- ti,vmbch2-threshold: (tps65911) main battery discharged threshold
+  comparator. (see VMBCH_VSEL in TPS65910 datasheet)
+- ti,en-gpio-sleep: enable sleep control for gpios
+  There should be 9 entries here, one for each gpio.
+
+Regulator Optional properties:
+- ti,regulator-ext-sleep-control: enable external sleep
+  control through external inputs [0 (not enabled), 1 (EN1), 2 (EN2) or 4(EN3)]
+  If this property is not defined, it defaults to 0 (not enabled).
+
+Example:
+
+	pmu: tps65910@d2 {
+		compatible = "ti,tps65910";
+		reg = <0xd2>;
+		interrupt-parent = <&intc>;
+		interrupts = < 0 118 0x04 >;
+
+		#gpio-cells = <2>;
+		gpio-controller;
+
+		#interrupt-cells = <2>;
+		interrupt-controller;
+
+		ti,vmbch-threshold = 0;
+		ti,vmbch2-threshold = 0;
+
+		ti,en-gpio-sleep = <0 0 1 0 0 0 0 0 0>;
+
+		regulators {
+			vdd1_reg: vdd1 {
+				regulator-min-microvolt = < 600000>;
+				regulator-max-microvolt = <1500000>;
+				regulator-always-on;
+				regulator-boot-on;
+				ti,regulator-ext-sleep-control = <0>;
+			};
+			vdd2_reg: vdd2 {
+				regulator-min-microvolt = < 600000>;
+				regulator-max-microvolt = <1500000>;
+				regulator-always-on;
+				regulator-boot-on;
+				ti,regulator-ext-sleep-control = <4>;
+			};
+			vddctrl_reg: vddctrl {
+				regulator-min-microvolt = < 600000>;
+				regulator-max-microvolt = <1400000>;
+				regulator-always-on;
+				regulator-boot-on;
+				ti,regulator-ext-sleep-control = <0>;
+			};
+			vio_reg: vio {
+				regulator-min-microvolt = <1500000>;
+				regulator-max-microvolt = <1800000>;
+				regulator-always-on;
+				regulator-boot-on;
+				ti,regulator-ext-sleep-control = <1>;
+			};
+			ldo1_reg: ldo1 {
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <3300000>;
+				ti,regulator-ext-sleep-control = <0>;
+			};
+			ldo2_reg: ldo2 {
+				regulator-min-microvolt = <1050000>;
+				regulator-max-microvolt = <1050000>;
+				ti,regulator-ext-sleep-control = <0>;
+			};
+			ldo3_reg: ldo3 {
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <3300000>;
+				ti,regulator-ext-sleep-control = <0>;
+			};
+			ldo4_reg: ldo4 {
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-always-on;
+				ti,regulator-ext-sleep-control = <0>;
+			};
+			ldo5_reg: ldo5 {
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <3300000>;
+				ti,regulator-ext-sleep-control = <0>;
+			};
+			ldo6_reg: ldo6 {
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+				ti,regulator-ext-sleep-control = <0>;
+			};
+			ldo7_reg: ldo7 {
+				regulator-min-microvolt = <1200000>;
+				regulator-max-microvolt = <1200000>;
+				regulator-always-on;
+				regulator-boot-on;
+				ti,regulator-ext-sleep-control = <1>;
+			};
+			ldo8_reg: ldo8 {
+				regulator-min-microvolt = <1000000>;
+				regulator-max-microvolt = <3300000>;
+				regulator-always-on;
+				ti,regulator-ext-sleep-control = <1>;
+			};
+		};
+	};
-- 
1.7.0.4

