Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945936Ab2K1XOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 18:14:54 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:57074 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485Ab2K1XOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 18:14:51 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Benoit Cousson <b-cousson@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, grant.likely@secretlab.ca,
        Enric Balletbo i Serra <eballetbo@gmail.com>,
        Ezequiel Garcia <elezegarcia@gmail.com>,
        Enrico Butera <ebutera@gmail.com>,
        Matthias Brugger <matthias.bgg@googlemail.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH 2/3] ARM/dts: omap3: Add support for IGEPv2 board
Date: Thu, 29 Nov 2012 00:14:25 +0100
Message-Id: <1354144466-750-3-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354144466-750-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1354144466-750-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ISEE IGEPv2 is an TI OMAP3 SoC based embedded board.

This patch adds an initial device tree support to boot
an IGEPv2 from the MMC/SD.

Currently is working everything that is supported by DT
on OMAP3 SoCs (MMC/SD, GPIO LEDs, EEPROM, TWL4030 audio).

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
---
 arch/arm/boot/dts/Makefile           |    1 +
 arch/arm/boot/dts/omap3-igep0020.dts |   56 ++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/omap3-igep0020.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index f37cf9f..1dc0f39 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -66,6 +66,7 @@ dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
 	omap3-beagle-xm.dtb \
 	omap3-evm.dtb \
 	omap3-tobi.dtb \
+	omap3-igep0020.dtb \
 	omap4-panda.dtb \
 	omap4-pandaES.dtb \
 	omap4-var_som.dtb \
diff --git a/arch/arm/boot/dts/omap3-igep0020.dts b/arch/arm/boot/dts/omap3-igep0020.dts
new file mode 100644
index 0000000..9dd4d22
--- /dev/null
+++ b/arch/arm/boot/dts/omap3-igep0020.dts
@@ -0,0 +1,56 @@
+/*
+ * Device Tree Source for IGEPv2 board
+ *
+ * Copyright (C) 2012 Javier Martinez Canillas <javier@collabora.co.uk>
+ * Copyright (C) 2012 Enric Balletbo i Serra <eballetbo@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+/include/ "omap3-igep.dtsi"
+
+/ {
+	model = "IGEPv2";
+	compatible = "isee,omap3-igep0020", "ti,omap3";
+
+	leds {
+		compatible = "gpio-leds";
+		boot {
+			 label = "omap3:green:boot";
+			 gpios = <&gpio1 26 0>;
+			 linux,default-trigger = "default-on";
+		};
+
+		user0 {
+			 label = "omap3:red:user0";
+			 gpios = <&gpio1 27 0>;
+			 default-state = "off";
+		};
+
+		user1 {
+			 label = "omap3:red:user1";
+			 gpios = <&gpio1 28 0>;
+			 default-state = "off";
+		};
+
+		user2 {
+			label = "omap3:green:user1";
+			gpios = <&twl_gpio 19 1>;
+		};
+	};
+};
+
+&i2c3 {
+	clock-frequency = <100000>;
+
+	/*
+	 * Display monitor features are burnt in the EEPROM
+	 * as EDID data.
+	 */
+	eeprom@50 {
+		compatible = "ti,eeprom";
+		reg = <0x50>;
+	};
+};
-- 
1.7.7.6

