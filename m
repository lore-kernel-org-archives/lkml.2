Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab2LCMmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 07:42:17 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:39852 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab2LCMmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 07:42:12 -0500
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
Subject: [PATCH v3 1/3] ARM/dts: omap3: Add generic DT support for IGEP devices
Date: Mon,  3 Dec 2012 13:41:41 +0100
Message-Id: <1354538503-22671-2-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1354538503-22671-1-git-send-email-javier.martinez@collabora.co.uk>
References: <1354538503-22671-1-git-send-email-javier.martinez@collabora.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a generic .dtsi device tree source file for the
common characteristics across IGEP Technology devices.

Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Acked-by: Matthias Brugger <matthias.bgg@gmail.com>
Tested-by: Enric Balletbo i Serra <eballetbo@gmail.com>
---

Changes since v2:
    - Associate uart3_pins in uart3 device node.
    - Remove mcbsp2_ins for now until SMSC9221 Ethernet support is added.

 arch/arm/boot/dts/omap3-igep.dtsi |   87 +++++++++++++++++++++++++++++++++++++
 1 files changed, 87 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/boot/dts/omap3-igep.dtsi

diff --git a/arch/arm/boot/dts/omap3-igep.dtsi b/arch/arm/boot/dts/omap3-igep.dtsi
new file mode 100644
index 0000000..125fe00
--- /dev/null
+++ b/arch/arm/boot/dts/omap3-igep.dtsi
@@ -0,0 +1,87 @@
+/*
+ * Device Tree Source for IGEP Technology devices
+ *
+ * Copyright (C) 2012 Javier Martinez Canillas <javier@collabora.co.uk>
+ * Copyright (C) 2012 Enric Balletbo i Serra <eballetbo@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+/dts-v1/;
+
+/include/ "omap3.dtsi"
+
+/ {
+	memory {
+		device_type = "memory";
+		reg = <0x80000000 0x20000000>; /* 512 MB */
+	};
+
+	sound {
+		compatible = "ti,omap-twl4030";
+		ti,model = "igep2";
+		ti,mcbsp = <&mcbsp2>;
+		ti,codec = <&twl_audio>;
+	};
+};
+
+&omap3_pmx_core {
+	uart3_pins: pinmux_uart3_pins {
+		pinctrl-single,pins = <
+			0x16e 0x100	/* uart3_rx.uart3_rx INPUT | MODE0 */
+			0x170 0		/* uart3_tx.uart3_tx OUTPUT | MODE0 */
+		>;
+	};
+};
+
+&i2c1 {
+	clock-frequency = <2600000>;
+
+	twl: twl@48 {
+		reg = <0x48>;
+		interrupts = <7>; /* SYS_NIRQ cascaded to intc */
+		interrupt-parent = <&intc>;
+
+		vsim: regulator@10 {
+			compatible = "ti,twl4030-vsim";
+			regulator-min-microvolt = <1800000>;
+			regulator-max-microvolt = <3000000>;
+		};
+
+		twl_audio: audio {
+			compatible = "ti,twl4030-audio";
+			codec {
+			      };
+		};
+	};
+};
+
+/include/ "twl4030.dtsi"
+
+&i2c2 {
+	clock-frequency = <400000>;
+};
+
+&mmc1 {
+	vmmc-supply = <&vmmc1>;
+	vmmc_aux-supply = <&vsim>;
+	bus-width = <8>;
+};
+
+&mmc2 {
+	status = "disabled";
+};
+
+&mmc3 {
+	status = "disabled";
+};
+
+&uart3 {
+       pinctrl-names = "default";
+       pinctrl-0 = <&uart3_pins>;
+};
+
+&twl_gpio {
+	ti,use-leds;
+};
-- 
1.7.7.6

