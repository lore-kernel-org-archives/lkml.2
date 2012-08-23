Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759028Ab2HWPBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 11:01:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52191 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab2HWPBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 11:01:40 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, w.sang@pengutronix.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/3] ARM: ux500: Add i2c configurations to the Device Tree for DB8500 based devices
Date: Thu, 23 Aug 2012 16:01:25 +0100
Message-Id: <1345734087-21803-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since initial support was provided for the Nomadik I2C driver, it
has been converted to an AMBA device. AMBA devices are probed in
a slightly different way to other devices, so we have to identify
them using an "arm,primecell" compatible string. As well as doing
just that, this patch specifies which regulators the controller
should use and requests a clock-speed. The latter is provided as
more of an example, as it's the same as the recently changed
default configuration.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 51209a8..3708a6b 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -480,43 +480,58 @@
 		};
 
 		i2c@80004000 {
-			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c";
+			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c", "arm,primecell";
 			reg = <0x80004000 0x1000>;
 			interrupts = <0 21 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			v-i2c-supply = <&db8500_vape_reg>;
+
+			clock-frequency = <400000>;
 		};
 
 		i2c@80122000 {
-			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c";
+			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c", "arm,primecell";
 			reg = <0x80122000 0x1000>;
 			interrupts = <0 22 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			v-i2c-supply = <&db8500_vape_reg>;
+
+			clock-frequency = <400000>;
 		};
 
 		i2c@80128000 {
-			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c";
+			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c", "arm,primecell";
 			reg = <0x80128000 0x1000>;
 			interrupts = <0 55 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			v-i2c-supply = <&db8500_vape_reg>;
+
+			clock-frequency = <400000>;
 		};
 
 		i2c@80110000 {
-			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c";
+			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c", "arm,primecell";
 			reg = <0x80110000 0x1000>;
 			interrupts = <0 12 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			v-i2c-supply = <&db8500_vape_reg>;
+
+			clock-frequency = <400000>;
 		};
 
 		i2c@8012a000 {
-			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c";
+			compatible = "stericsson,db8500-i2c", "st,nomadik-i2c", "arm,primecell";
 			reg = <0x8012a000 0x1000>;
 			interrupts = <0 51 0x4>;
 			#address-cells = <1>;
 			#size-cells = <0>;
+			v-i2c-supply = <&db8500_vape_reg>;
+
+			clock-frequency = <400000>;
 		};
 
 		ssp@80002000 {
-- 
1.7.9.5

