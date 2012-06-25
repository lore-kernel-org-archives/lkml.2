Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab2FYMF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 08:05:29 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:48095 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab2FYMF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 08:05:26 -0400
From: AnilKumar Ch <anilkumar@ti.com>
To: <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <grant.likely@secretlab.ca>, AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH 3/3] ARM: OMAP2+: AM33XX: Add tps65910 device tree data
Date: Mon, 25 Jun 2012 17:34:38 +0530
Message-ID: <1340625878-32336-4-git-send-email-anilkumar@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1340625878-32336-1-git-send-email-anilkumar@ti.com>
References: <1340625878-32336-1-git-send-email-anilkumar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree data for tps65910 regulator by adding all the
consumers necessary for AM335X-EVM. The data will be map to a
regulator constraints which is required for regulator set_voltage
and get_voltage calls.

All tps65910 PMIC regulator constraints are placed in a seperate
device tree include file (tps65910.dtsi).

This patch also adds the I2C slave address of TPS65910 pmic to
am335x-evm.dts file.

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
---
These patches were tested along with these patches
* DT addition to AM33XX family
http://marc.info/?l=linux-omap&m=134035826700991&w=2

 arch/arm/boot/dts/am335x-evm.dts |   10 +++++
 arch/arm/boot/dts/tps65910.dtsi  |   76 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)
 create mode 100644 arch/arm/boot/dts/tps65910.dtsi

diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index d6a97d9..15d03ba 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -18,3 +18,13 @@
 		reg = <0x80000000 0x10000000>; /* 256 MB */
 	};
 };
+
+&i2c1 {
+	clock-frequency = <400000>;
+
+	tps: tps@2D {
+		reg = <0x2D>;
+	};
+};
+
+/include/ "tps65910.dtsi"
diff --git a/arch/arm/boot/dts/tps65910.dtsi b/arch/arm/boot/dts/tps65910.dtsi
new file mode 100644
index 0000000..c4f5d85
--- /dev/null
+++ b/arch/arm/boot/dts/tps65910.dtsi
@@ -0,0 +1,76 @@
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
+ * http://www.ti.com/lit/ds/symlink/tps65910.pdf
+ */
+
+&tps {
+	compatible = "ti,tps65910";
+
+	regulators {
+		vrtc_reg: vrtc {
+			regulator-always-on;
+		};
+
+		vio_reg: vio {
+			regulator-always-on;
+		};
+
+		vdd1_reg: vdd1 {
+			regulator-min-microvolt = <600000>;
+			regulator-max-microvolt = <1500000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		vdd2_reg: vdd2 {
+			regulator-min-microvolt = <600000>;
+			regulator-max-microvolt = <1500000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		vdd3_reg: vdd3 {
+			regulator-always-on;
+		};
+
+		vdig1_reg: vdig1 {
+			regulator-always-on;
+		};
+
+		vdig2_reg: vdig2 {
+			regulator-always-on;
+		};
+
+		vpll_reg: vpll {
+			regulator-always-on;
+		};
+
+		vdac_reg: vdac {
+			regulator-always-on;
+		};
+
+		vaux1_reg: vaux1 {
+			regulator-always-on;
+		};
+
+		vaux2_reg: vaux2 {
+			regulator-always-on;
+		};
+
+		vaux33_reg: vaux33 {
+			regulator-always-on;
+		};
+
+		vmmc_reg: vmmc {
+			regulator-always-on;
+		};
+	};
+};
-- 
1.7.9.5

