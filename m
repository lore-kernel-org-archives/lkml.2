Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2KSJlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 04:41:00 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64113 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab2KSJkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 04:40:16 -0500
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Axel Lin <axel.lin@ingics.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] ARM: Dove: Convert to DT GPIO and pinctrl
Date: Mon, 19 Nov 2012 10:39:55 +0100
Message-Id: <1353317996-20841-4-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1353317996-20841-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following the ongoing conversion of Orion SoCs to DT, make use of
gpio and pinctrl drivers through DT. The main dtsi for Dove is prepared
to allow board specific descriptors to make use of pinctrl muxing.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Axel Lin <axel.lin@ingics.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/Kconfig            |    2 ++
 arch/arm/boot/dts/dove.dtsi |   20 +++++++++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index d5a28da..bb9a85d 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -539,6 +539,8 @@ config ARCH_DOVE
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
 	select MIGHT_HAVE_PCI
+	select PINCTRL
+	select PINCTRL_DOVE
 	select PLAT_ORION_LEGACY
 	select USB_ARCH_HAS_EHCI
 	help
diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 8c8ab62..c457480 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -4,6 +4,12 @@
 	compatible = "marvell,dove";
 	model = "Marvell Armada 88AP510 SoC";
 
+	aliases {
+		gpio0 = &gpio0;
+		gpio1 = &gpio1;
+		gpio2 = &gpio2;
+	};
+
 	soc@f1000000 {
 		compatible = "simple-bus";
 		#address-cells = <1>;
@@ -85,7 +91,8 @@
 			#gpio-cells = <2>;
 			gpio-controller;
 			reg = <0xd0400 0x20>;
-			ngpio = <32>;
+			ngpios = <32>;
+			interrupt-controller;
 			interrupts = <12>, <13>, <14>, <60>;
 		};
 
@@ -94,7 +101,8 @@
 			#gpio-cells = <2>;
 			gpio-controller;
 			reg = <0xd0420 0x20>;
-			ngpio = <32>;
+			ngpios = <32>;
+			interrupt-controller;
 			interrupts = <61>;
 		};
 
@@ -103,7 +111,13 @@
 			#gpio-cells = <2>;
 			gpio-controller;
 			reg = <0xe8400 0x0c>;
-			ngpio = <8>;
+			ngpios = <8>;
+		};
+
+		pinctrl: pinctrl@d0200 {
+			compatible = "marvell,dove-pinctrl";
+			reg = <0xd0200 0x10>;
+			clocks = <&gate_clk 22>;
 		};
 
 		spi0: spi@10600 {
-- 
1.7.10.4

