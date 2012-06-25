Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab2FYMFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 08:05:23 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50375 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227Ab2FYMFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 08:05:18 -0400
From: AnilKumar Ch <anilkumar@ti.com>
To: <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <grant.likely@secretlab.ca>, AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH 2/3] ARM: OMAP2+: AM33XX: Add tps65217 device tree data
Date: Mon, 25 Jun 2012 17:34:37 +0530
Message-ID: <1340625878-32336-3-git-send-email-anilkumar@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1340625878-32336-1-git-send-email-anilkumar@ti.com>
References: <1340625878-32336-1-git-send-email-anilkumar@ti.com>
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

This patch also adds the I2C slave address of TPS65217 pmic to
am335x-bone.dts file.

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
---
These patches were tested along with these patches
* DT addition to AM33XX family
http://marc.info/?l=linux-omap&m=134035826700991&w=2

 arch/arm/boot/dts/am335x-bone.dts |   10 ++++++
 arch/arm/boot/dts/tps65217.dtsi   |   67 +++++++++++++++++++++++++++++++++++++
 2 files changed, 77 insertions(+)
 create mode 100644 arch/arm/boot/dts/tps65217.dtsi

diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
index a9af4db..a4d4415 100644
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone.dts
@@ -18,3 +18,13 @@
 		reg = <0x80000000 0x10000000>; /* 256 MB */
 	};
 };
+
+&i2c1 {
+	clock-frequency = <400000>;
+
+	tps: tps@24 {
+		reg = <0x24>;
+	};
+};
+
+/include/ "tps65217.dtsi"
diff --git a/arch/arm/boot/dts/tps65217.dtsi b/arch/arm/boot/dts/tps65217.dtsi
new file mode 100644
index 0000000..5b9850b
--- /dev/null
+++ b/arch/arm/boot/dts/tps65217.dtsi
@@ -0,0 +1,67 @@
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
+		dcdc1_reg: dcdc1 {
+			regulator-min-microvolt = <900000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		dcdc2_reg: dcdc2 {
+			regulator-min-microvolt = <900000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		dcdc3_reg: dcdc3 {
+			regulator-min-microvolt = <900000>;
+			regulator-max-microvolt = <1500000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		ldo1_reg: ldo1 {
+			regulator-min-microvolt = <1000000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		ldo2_reg: ldo2 {
+			regulator-min-microvolt = <900000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		ldo3_reg: ldo3 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		ldo4_reg: ldo4 {
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+	};
+};
-- 
1.7.9.5

