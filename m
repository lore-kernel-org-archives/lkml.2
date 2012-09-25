Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab2IYADj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 20:03:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:48393 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab2IYAC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 20:02:58 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] ARM: dove: Restructure SoC device tree descriptor
Date: Tue, 25 Sep 2012 02:02:16 +0200
Message-Id: <1348531338-16624-5-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds proper ranges for all mapped addresses within
dove SoC and moves the interrupt controller node inside the simple-bus
node.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/dove.dtsi |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 3f41f50..792bab0 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -4,27 +4,33 @@
 	compatible = "marvell,dove";
 	model = "Marvell Armada 88AP510 SoC";
 
-	interrupt-parent = <&intc>;
-
-	intc: interrupt-controller {
-		compatible = "marvell,orion-intc";
-		interrupt-controller;
-		#interrupt-cells = <1>;
-		reg = <0xf1020204 0x04>,
-		      <0xf1020214 0x04>;
-	};
-
-	mbus@f1000000 {
+	soc@f1000000 {
 		compatible = "simple-bus";
-		ranges = <0 0xf1000000 0x4000000>;
 		#address-cells = <1>;
 		#size-cells = <1>;
+		interrupt-parent = <&intc>;
+
+		ranges = <0xc8000000 0xc8000000 0x0100000   /* CESA SRAM   1M */
+		          0xe0000000 0xe0000000 0x8000000   /* PCIe0 Mem 128M */
+		          0xe8000000 0xe8000000 0x8000000   /* PCIe1 Mem 128M */
+		          0xf0000000 0xf0000000 0x0100000   /* ScratchPad  1M */
+		          0x00000000 0xf1000000 0x1000000   /* SB/NB regs 16M */
+		          0xf2000000 0xf2000000 0x0100000   /* PCIe0 I/O   1M */
+		          0xf2100000 0xf2100000 0x0100000   /* PCIe0 I/O   1M */
+		          0xf8000000 0xf8000000 0x8000000>; /* BootROM   128M */
 
 		l2: l2-cache {
 			compatible = "marvell,tauros2-cache";
 			marvell,tauros2-cache-features = <0>;
 		};
 
+		intc: interrupt-controller {
+			compatible = "marvell,orion-intc";
+			interrupt-controller;
+			#interrupt-cells = <1>;
+			reg = <0x20204 0x04>, <0x20214 0x04>;
+		};
+
 		uart0: serial@12000 {
 			compatible = "ns16550a";
 			reg = <0x12000 0x100>;
-- 
1.7.10.4

