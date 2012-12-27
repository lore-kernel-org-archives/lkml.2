Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062Ab2L0WWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 17:22:11 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:48861 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2L0WWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 17:22:08 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: Dove: add fixed regulator for CuBox USB power
Date: Thu, 27 Dec 2012 23:21:59 +0100
Message-Id: <1356646919-2974-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CuBox needs to enable USB power on a gpio pin. Add a fixed regulator
to always enable usb power on boot.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/dove-cubox.dts |   25 ++++++++++++++++++++++++-
 arch/arm/mach-dove/Kconfig       |    2 ++
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dts
index bed5b62..7e3065a 100644
--- a/arch/arm/boot/dts/dove-cubox.dts
+++ b/arch/arm/boot/dts/dove-cubox.dts
@@ -26,6 +26,24 @@
 			linux,default-trigger = "default-on";
 		};
 	};
+
+	regulators {
+		compatible = "simple-bus";
+		#address-cells = <1>;
+		#size-cells = <0>;
+
+		usb_power: regulator@1 {
+			compatible = "regulator-fixed";
+			reg = <1>;
+			regulator-name = "USB Power";
+			regulator-min-microvolt = <5000000>;
+			regulator-max-microvolt = <5000000>;
+			enable-active-high;
+			regulator-always-on;
+			regulator-boot-on;
+			gpio = <&gpio0 1 0>;
+		};
+	};
 };
 
 &uart0 { status = "okay"; };
@@ -50,9 +68,14 @@
 };
 
 &pinctrl {
-	pinctrl-0 = <&pmx_gpio_12>;
+	pinctrl-0 = <&pmx_gpio_1 &pmx_gpio_12>;
 	pinctrl-names = "default";
 
+	pmx_gpio_1: pmx-gpio-1 {
+		marvell,pins = "mpp1";
+		marvell,function = "gpio";
+	};
+
 	pmx_gpio_12: pmx-gpio-12 {
 		marvell,pins = "mpp12";
 		marvell,function = "gpio";
diff --git a/arch/arm/mach-dove/Kconfig b/arch/arm/mach-dove/Kconfig
index aedd0ba..36469d8 100644
--- a/arch/arm/mach-dove/Kconfig
+++ b/arch/arm/mach-dove/Kconfig
@@ -24,6 +24,8 @@ config MACH_DOVE_DT
 	bool "Marvell Dove Flattened Device Tree"
 	select MVEBU_CLK_CORE
 	select MVEBU_CLK_GATING
+	select REGULATOR
+	select REGULATOR_FIXED_VOLTAGE
 	select USE_OF
 	help
 	  Say 'Y' here if you want your kernel to support the
-- 
1.7.10.4

