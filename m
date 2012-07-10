Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab2GJLKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:10:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50399 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab2GJLKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:10:06 -0400
From: AnilKumar Ch <anilkumar@ti.com>
To: <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <grant.likely@secretlab.ca>, AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH v2 3/3] ARM: OMAP2+: AM33XX: Add tps65217 device tree data
Date: Tue, 10 Jul 2012 16:39:44 +0530
Message-ID: <1341918584-28004-4-git-send-email-anilkumar@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1341918584-28004-1-git-send-email-anilkumar@ti.com>
References: <1341918584-28004-1-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree data for tps65217 regulator by adding all the consumers
necessary for AM335X-BeagleBone. The data will be map to a regulator
constraints which is required for regulator set_voltage and get_voltage
calls.

All tps65217 PMIC regulator constraints are placed in a seperate device
tree include file (tps65217.dtsi).

This patch is tested by adding the I2C slave address of TPS65217
pmic to am335x-bone.dts file (Not included in this, I2C slave
addition patch will be submitted to linux-omap, where am335x-bone.dts
binding file is available).

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
---
 arch/arm/boot/dts/tps65217.dtsi |   84 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)
 create mode 100644 arch/arm/boot/dts/tps65217.dtsi

diff --git a/arch/arm/boot/dts/tps65217.dtsi b/arch/arm/boot/dts/tps65217.dtsi
new file mode 100644
index 0000000..cbb9e5d
--- /dev/null
+++ b/arch/arm/boot/dts/tps65217.dtsi
@@ -0,0 +1,84 @@
+/*
+ * Copyright (C) 2012 Texas Instruments Incorporated - http://www.ti.com/
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/*
+ * Integrated Power Management Chip
+ * http://www.ti.com/lit/ds/symlink/tps65217.pdf
+ */
+
+&tps {
+	compatible = "ti,tps65217";
+
+	regulators {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		dcdc1_reg: regulator@0 {
+			reg = <0>;
+			regulator-compatible = "dcdc1";
+			regulator-min-microvolt = <900000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		dcdc2_reg: regulator@1 {
+			reg = <1>;
+			regulator-compatible = "dcdc2";
+			regulator-min-microvolt = <900000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		dcdc3_reg: regulator@2 {
+			reg = <2>;
+			regulator-compatible = "dcdc3";
+			regulator-min-microvolt = <900000>;
+			regulator-max-microvolt = <1500000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		ldo1_reg: regulator@3 {
+			reg = <3>;
+			regulator-compatible = "ldo1";
+			regulator-min-microvolt = <1000000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		ldo2_reg: regulator@4 {
+			reg = <4>;
+			regulator-compatible = "ldo2";
+			regulator-min-microvolt = <900000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		ldo3_reg: regulator@5 {
+			reg = <5>;
+			regulator-compatible = "ldo3";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		ldo4_reg: regulator@6 {
+			reg = <6>;
+			regulator-compatible = "ldo4";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+	};
+};
-- 
1.7.9.5

