Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab2GJLKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 07:10:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50401 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab2GJLKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 07:10:06 -0400
From: AnilKumar Ch <anilkumar@ti.com>
To: <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>, <linux-kernel@vger.kernel.org>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <grant.likely@secretlab.ca>, AnilKumar Ch <anilkumar@ti.com>
Subject: [PATCH v2 2/3] ARM: OMAP2+: AM33XX: Add tps65910 device tree data
Date: Tue, 10 Jul 2012 16:39:43 +0530
Message-ID: <1341918584-28004-3-git-send-email-anilkumar@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1341918584-28004-1-git-send-email-anilkumar@ti.com>
References: <1341918584-28004-1-git-send-email-anilkumar@ti.com>
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

This patch is tested by adding the I2C slave address of TPS65910
pmic to am335x-evm.dts file (Not included in this, I2C slave
addition patch will be submitted to linux-omap, where am335x-evm.dts
binding file is available).

Signed-off-by: AnilKumar Ch <anilkumar@ti.com>
---
 arch/arm/boot/dts/tps65910.dtsi |  123 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)
 create mode 100644 arch/arm/boot/dts/tps65910.dtsi

diff --git a/arch/arm/boot/dts/tps65910.dtsi b/arch/arm/boot/dts/tps65910.dtsi
new file mode 100644
index 0000000..b185235
--- /dev/null
+++ b/arch/arm/boot/dts/tps65910.dtsi
@@ -0,0 +1,123 @@
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
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		vrtc_reg: regulator@0 {
+			reg = <0>;
+			regulator-compatible = "vrtc";
+			regulator-always-on;
+		};
+
+		vio_reg: regulator@1 {
+			reg = <1>;
+			regulator-compatible = "vio";
+			regulator-min-microvolt = <1500000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+		};
+
+		vdd1_reg: regulator@2 {
+			reg = <2>;
+			regulator-compatible = "vdd1";
+			regulator-min-microvolt = <600000>;
+			regulator-max-microvolt = <1500000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		vdd2_reg: regulator@3 {
+			reg = <3>;
+			regulator-compatible = "vdd2";
+			regulator-min-microvolt = <600000>;
+			regulator-max-microvolt = <1500000>;
+			regulator-boot-on;
+			regulator-always-on;
+		};
+
+		vdd3_reg: regulator@4 {
+			reg = <4>;
+			regulator-compatible = "vdd3";
+			regulator-always-on;
+		};
+
+		vdig1_reg: regulator@5 {
+			reg = <5>;
+			regulator-compatible = "vdig1";
+			regulator-min-microvolt = <1200000>;
+			regulator-max-microvolt = <2700000>;
+			regulator-always-on;
+		};
+
+		vdig2_reg: regulator@6 {
+			reg = <6>;
+			regulator-compatible = "vdig2";
+			regulator-min-microvolt = <1000000>;
+			regulator-max-microvolt = <1800000>;
+			regulator-always-on;
+		};
+
+		vpll_reg: regulator@7 {
+			reg = <7>;
+			regulator-compatible = "vpll";
+			regulator-min-microvolt = <1000000>;
+			regulator-max-microvolt = <2500000>;
+			regulator-always-on;
+		};
+
+		vdac_reg: regulator@8 {
+			reg = <8>;
+			regulator-compatible = "vdac";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <2850000>;
+			regulator-always-on;
+		};
+
+		vaux1_reg: regulator@9 {
+			reg = <9>;
+			regulator-compatible = "vaux1";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <2850000>;
+			regulator-always-on;
+		};
+
+		vaux2_reg: regulator@10 {
+			reg = <10>;
+			regulator-compatible = "vaux2";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+		};
+
+		vaux33_reg: regulator@11 {
+			reg = <11>;
+			regulator-compatible = "vaux33";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+		};
+
+		vmmc_reg: regulator@12 {
+			reg = <12>;
+			regulator-compatible = "vmmc";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+		};
+	};
+};
-- 
1.7.9.5

