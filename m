Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab2LCMmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 07:42:20 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39870 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab2LCMmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 07:42:17 -0500
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
Subject: [PATCH v3 3/3] ARM/dts: omap3: Add support for IGEP COM Module
Date: Mon,  3 Dec 2012 13:41:43 +0100
Message-Id: <1354538503-22671-4-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354538503-22671-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1354538503-22671-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ISEE IGEP COM Module is an TI OMAP3 SoC computer on module.

This patch adds an initial device tree support to boot an
IGEP COM Module from the MMC/SD.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Acked-by: Matthias Brugger <matthias.bgg@gmail.com>
Tested-by: Enric Balletbo i Serra <eballetbo@gmail.com>
---

Changes since v1:
    - Use default-state = "on" instead default-trigger = "default-on" for LED
    - Update GPIO mapping according to latest IGEP COM Module rev.E instead D

 arch/arm/boot/dts/Makefile           |    1 +
 arch/arm/boot/dts/omap3-igep0030.dts |   44 ++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/omap3-igep0030.dts

diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
index 1dc0f39..78c99bc 100644
--- a/arch/arm/boot/dts/Makefile
+++ b/arch/arm/boot/dts/Makefile
@@ -67,6 +67,7 @@ dtb-$(CONFIG_ARCH_OMAP2PLUS) += omap2420-h4.dtb \
 	omap3-evm.dtb \
 	omap3-tobi.dtb \
 	omap3-igep0020.dtb \
+	omap3-igep0030.dtb \
 	omap4-panda.dtb \
 	omap4-pandaES.dtb \
 	omap4-var_som.dtb \
diff --git a/arch/arm/boot/dts/omap3-igep0030.dts b/arch/arm/boot/dts/omap3-igep0030.dts
new file mode 100644
index 0000000..9dc48d2
--- /dev/null
+++ b/arch/arm/boot/dts/omap3-igep0030.dts
@@ -0,0 +1,44 @@
+/*
+ * Device Tree Source for IGEP COM Module
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
+	model = "IGEP COM Module";
+	compatible = "isee,omap3-igep0030", "ti,omap3";
+
+	leds {
+		compatible = "gpio-leds";
+		boot {
+			 label = "omap3:green:boot";
+			 gpios = <&twl_gpio 13 1>;
+			 default-state = "on";
+		};
+
+		user0 {
+			 label = "omap3:red:user0";
+			 gpios = <&twl_gpio 18 1>; /* LEDA */
+			 default-state = "off";
+		};
+
+		user1 {
+			 label = "omap3:green:user1";
+			 gpios = <&twl_gpio 19 1>; /* LEDB */
+			 default-state = "off";
+		};
+
+		user2 {
+			 label = "omap3:red:user1";
+			 gpios = <&gpio1 16 1>;
+			 default-state = "off";
+		};
+	};
+};
-- 
1.7.7.6

