Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab2K1PJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 10:09:19 -0500
Received: from relay.ams1.hosting.nl ([82.197.222.253]:51484 "EHLO
	relay.ams1.hosting.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab2K1PJR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 10:09:17 -0500
X-Greylist: delayed 2703 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2012 10:09:17 EST
X-Originating-IP: 127.0.0.1
Message-ID: <20121128152403.45224dvyaufb1j7n@62.129.139.42>
Date: Wed, 28 Nov 2012 15:24:03 +0100
From: "sander van ginkel" <sander@van-ginkel.eu>
To: linux-kernel@vger.kernel.org
Cc: kernel@pengutronix.de, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH] add hardware I2C support for ARM IMX23
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The I2C hardware in the IMX233 is currently not supported,
however the i2c-mxs driver seems to be suitable.
To use the i2c-mxs driver it has to be added to the devicetree
for the IMX23.


Signed-off-by: Sander van Ginkel <sander@van-ginkel.eu>
---
diff -Naur linux-3.7-rc6/arch/arm/boot/dts/imx23-olinuxino.dts  
linux-3.7-rc6-i2c/arch/arm/boot/dts/imx23-olinuxino.dts
--- linux-3.7-rc6/arch/arm/boot/dts/imx23-olinuxino.dts	2012-11-17  
01:42:40.000000000 +0000
+++ linux-3.7-rc6-i2c/arch/arm/boot/dts/imx23-olinuxino.dts	2012-11-24  
22:40:51.000000000 +0000
@@ -50,6 +50,13 @@
		};

		apbx@80040000 {
+
+			i2c0: i2c@80058000 {
+				pinctrl-names = "default";
+				pinctrl-0 = <&i2c0_pins_a>;
+				status = "okay";
+			};
+
			duart: serial@80070000 {
				pinctrl-names = "default";
				pinctrl-0 = <&duart_pins_a>;
diff -Naur linux-3.7-rc6/arch/arm/boot/dts/imx23.dtsi  
linux-3.7-rc6-i2c/arch/arm/boot/dts/imx23.dtsi
--- linux-3.7-rc6/arch/arm/boot/dts/imx23.dtsi	2012-11-17  
01:42:40.000000000 +0000
+++ linux-3.7-rc6-i2c/arch/arm/boot/dts/imx23.dtsi	2012-11-24  
22:40:51.000000000 +0000
@@ -144,6 +144,17 @@
					fsl,pull-up = <0>;
				};

+				i2c0_pins_a: i2c0@0 {
+					reg = <0>;
+					fsl,pinmux-ids = <
+						0x1171 /* MX23_PAD_LCD_ENABLE__I2C_SCL */
+						0x1181 /* MX23_PAD_LCD_HSYNC__I2C_SDA */
+					>;
+					fsl,drive-strength = <1>;
+					fsl,voltage = <1>;
+					fsl,pull-up = <1>;
+				};
+
				auart0_2pins_a: auart0-2pins@0 {
					reg = <0>;
					fsl,pinmux-ids = <
@@ -387,9 +398,15 @@
				status = "disabled";
			};

-			i2c@80058000 {
+			i2c0: i2c@80058000 {
+				#address-cells = <2>;
+				#size-cells = <1>;
+				compatible = "fsl,imx28-i2c";
				reg = <0x80058000 0x2000>;
+				interrupts = <26 27>;
+				clock-frequency = <100000>;
				status = "disabled";
+				fsl,i2c-dma-channel = <3>;
			};

			rtc@8005c000 {

