Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab2H0MdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 08:33:16 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56906 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab2H0McX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 08:32:23 -0400
From: Vaibhav Hiremath <hvaibhav@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Vaibhav Hiremath <hvaibhav@ti.com>, Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <b-cousson@ti.com>
Subject: [PATCH 2/2] arm/dts: AM33XX: Specify reg and interrupt property for all nodes
Date: Mon, 27 Aug 2012 18:01:54 +0530
Message-ID: <1346070714-6122-3-git-send-email-hvaibhav@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1346070714-6122-1-git-send-email-hvaibhav@ti.com>
References: <1346070714-6122-1-git-send-email-hvaibhav@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device/node resources (like, IORESOURCE_MEM and IORESOURCE_IRQ)
are overwritten by hwmod resources, due to all known reasons but
that should not be the reason for not providing all the information
in the DTS blob. Ideally we should use DTS resource and use HWMOD
framework wherever required and for only specific things.

Newer platforms like, OMAP5 and AM33XX, we only support DT boot mode,
so this patch is preparation for the future where we supposed to get
rid of hwmod dependency anyway.

Signed-off-by: Vaibhav Hiremath <hvaibhav@ti.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Benoit Cousson <b-cousson@ti.com>
---
 arch/arm/boot/dts/am33xx.dtsi |   42 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 42 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index be43511..f0642e1 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -69,6 +69,9 @@
 			#gpio-cells = <2>;
 			interrupt-controller;
 			#interrupt-cells = <1>;
+			reg = <0x44e07000 0x1000>;
+			interrupt-parent = <&intc>;
+			interrupts = <96>;
 		};
 
 		gpio2: gpio@4804c000 {
@@ -78,6 +81,9 @@
 			#gpio-cells = <2>;
 			interrupt-controller;
 			#interrupt-cells = <1>;
+			reg = <0x4804c000 0x1000>;
+			interrupt-parent = <&intc>;
+			interrupts = <98>;
 		};
 
 		gpio3: gpio@481ac000 {
@@ -87,6 +93,9 @@
 			#gpio-cells = <2>;
 			interrupt-controller;
 			#interrupt-cells = <1>;
+			reg = <0x481ac000 0x1000>;
+			interrupt-parent = <&intc>;
+			interrupts = <32>;
 		};
 
 		gpio4: gpio@481ae000 {
@@ -96,12 +105,18 @@
 			#gpio-cells = <2>;
 			interrupt-controller;
 			#interrupt-cells = <1>;
+			reg = <0x481ae000 0x1000>;
+			interrupt-parent = <&intc>;
+			interrupts = <62>;
 		};
 
 		uart1: serial@44e09000 {
 			compatible = "ti,omap3-uart";
 			ti,hwmods = "uart1";
 			clock-frequency = <48000000>;
+			reg = <0x44e09000 0x2000>;
+ 			interrupt-parent = <&intc>;
+ 			interrupts = <72>;
 			status = "disabled";
 		};
 
@@ -109,6 +124,9 @@
 			compatible = "ti,omap3-uart";
 			ti,hwmods = "uart2";
 			clock-frequency = <48000000>;
+			reg = <0x48022000 0x2000>;
+ 			interrupt-parent = <&intc>;
+ 			interrupts = <73>;
 			status = "disabled";
 		};
 
@@ -116,6 +134,9 @@
 			compatible = "ti,omap3-uart";
 			ti,hwmods = "uart3";
 			clock-frequency = <48000000>;
+			reg = <0x48024000 0x2000>;
+ 			interrupt-parent = <&intc>;
+ 			interrupts = <74>;
 			status = "disabled";
 		};
 
@@ -123,6 +144,9 @@
 			compatible = "ti,omap3-uart";
 			ti,hwmods = "uart4";
 			clock-frequency = <48000000>;
+			reg = <0x481a6000 0x2000>;
+ 			interrupt-parent = <&intc>;
+ 			interrupts = <44>;
 			status = "disabled";
 		};
 
@@ -130,6 +154,9 @@
 			compatible = "ti,omap3-uart";
 			ti,hwmods = "uart5";
 			clock-frequency = <48000000>;
+			reg = <0x481a8000 0x2000>;
+ 			interrupt-parent = <&intc>;
+ 			interrupts = <45>;
 			status = "disabled";
 		};
 
@@ -137,6 +164,9 @@
 			compatible = "ti,omap3-uart";
 			ti,hwmods = "uart6";
 			clock-frequency = <48000000>;
+			reg = <0x481aa000 0x2000>;
+ 			interrupt-parent = <&intc>;
+ 			interrupts = <46>;
 			status = "disabled";
 		};
 
@@ -145,6 +175,9 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c1";
+			reg = <0x44e0b000 0x1000>;
+			interrupt-parent = <&intc>;
+			interrupts = <70>;
 			status = "disabled";
 		};
 
@@ -153,6 +186,9 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c2";
+			reg = <0x4802a000 0x1000>;
+			interrupt-parent = <&intc>;
+			interrupts = <71>;
 			status = "disabled";
 		};
 
@@ -161,12 +197,18 @@
 			#address-cells = <1>;
 			#size-cells = <0>;
 			ti,hwmods = "i2c3";
+			reg = <0x4819c000 0x1000>;
+			interrupt-parent = <&intc>;
+			interrupts = <30>;
 			status = "disabled";
 		};
 
 		wdt2: wdt@44e35000 {
 			compatible = "ti,omap3-wdt";
 			ti,hwmods = "wd_timer2";
+			reg = <0x44e35000 0x1000>;
+			interrupt-parent = <&intc>;
+			interrupts = <91>;
 		};
 	};
 };
-- 
1.7.0.4

