Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab2HGHSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 03:18:46 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41336 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab2HGHSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 03:18:44 -0400
From: Balaji T K <balajitk@ti.com>
To: <arnd@arndb.de>, <tony@atomide.com>, <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rob.herring@calxeda.com>
CC: <linux-mmc@vger.kernel.org>, <balbi@ti.com>, Balaji T K <balajitk@ti.com>
Subject: [PATCH] arm/dts: omap5: Add mmc controller nodes and board data
Date: Tue, 7 Aug 2012 12:48:21 +0530
Message-ID: <1344323901-20342-1-git-send-email-balajitk@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OMAP MMC related device tree data for OMAP5.

Signed-off-by: Balaji T K <balajitk@ti.com>
---
 arch/arm/boot/dts/omap5-evm.dts |   31 +++++++++++++++++++++++++++++++
 arch/arm/boot/dts/omap5.dtsi    |   31 +++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap5-evm.dts b/arch/arm/boot/dts/omap5-evm.dts
index 200c39a..7bb0c9d 100644
--- a/arch/arm/boot/dts/omap5-evm.dts
+++ b/arch/arm/boot/dts/omap5-evm.dts
@@ -17,4 +17,35 @@
 		device_type = "memory";
 		reg = <0x80000000 0x40000000>; /* 1 GB */
 	};
+
+	vmmcsd_fixed: fixedregulator-mmcsd {
+		compatible = "regulator-fixed";
+		regulator-name = "vmmcsd_fixed";
+		regulator-min-microvolt = <3000000>;
+		regulator-max-microvolt = <3000000>;
+	};
+};
+
+&mmc1 {
+	vmmc-supply = <&vmmcsd_fixed>;
+	bus-width = <4>;
+};
+
+&mmc2 {
+	vmmc-supply = <&vmmcsd_fixed>;
+	bus-width = <8>;
+	ti,non-removable;
+};
+
+&mmc3 {
+	bus-width = <4>;
+	ti,non-removable;
+};
+
+&mmc4 {
+	status = "disabled";
+};
+
+&mmc5 {
+	status = "disabled";
 };
diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 57e5270..881d60c 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -180,5 +180,36 @@
 			ti,hwmods = "uart6";
 			clock-frequency = <48000000>;
 		};
+
+		mmc1: mmc@4809c000 {
+			compatible = "ti,omap4-hsmmc";
+			ti,hwmods = "mmc1";
+			ti,dual-volt;
+			ti,needs-special-reset;
+		};
+
+		mmc2: mmc@480b4000 {
+			compatible = "ti,omap4-hsmmc";
+			ti,hwmods = "mmc2";
+			ti,needs-special-reset;
+		};
+
+		mmc3: mmc@480ad000 {
+			compatible = "ti,omap4-hsmmc";
+			ti,hwmods = "mmc3";
+			ti,needs-special-reset;
+		};
+
+		mmc4: mmc@480d1000 {
+			compatible = "ti,omap4-hsmmc";
+			ti,hwmods = "mmc4";
+			ti,needs-special-reset;
+		};
+
+		mmc5: mmc@480d5000 {
+			compatible = "ti,omap4-hsmmc";
+			ti,hwmods = "mmc5";
+			ti,needs-special-reset;
+		};
 	};
 };
-- 
1.7.5.4

