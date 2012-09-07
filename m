Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760541Ab2IGLRP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:17:15 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50655 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760416Ab2IGLPf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:15:35 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 14/19] ARM: ux500: Apply tc3589x's GPIO/IRQ properties to HREF's DT
Date: Fri,  7 Sep 2012 12:14:54 +0100
Message-Id: <1347016499-29354-15-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ensures the tc3589x and tc3598x-gpio devices are
rightfully given interrupt controller status. We also describe
the tc3598x-gpio GPIO expander in full and specify it as a GPIO
controller. Finally we reference that the external MMC slot's
Card Detection GPIO on the HREF is located on the tc3598x-gpio
expander.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/hrefv60plus.dts |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
index ec9ec4f..b3290c7 100644
--- a/arch/arm/boot/dts/hrefv60plus.dts
+++ b/arch/arm/boot/dts/hrefv60plus.dts
@@ -42,7 +42,7 @@
 			mmc-cap-mmc-highspeed;
 			vmmc-supply = <&ab8500_ldo_aux3_reg>;
 
-			cd-gpios  = <&gpio2 31 0x4>; // 95
+			cd-gpios  = <&tc3589x_gpio 3 0x4>;
 
 			status = "okay";
 		};
@@ -100,6 +100,21 @@
 			tc3589x@42 {
 				compatible = "tc3589x";
 				reg = <0x42>;
+				interrupt-parent = <&gpio6>;
+				interrupts = <25 0x1>;
+
+				interrupt-controller;
+				#interrupt-cells = <2>;
+
+				tc3589x_gpio: tc3589x_gpio {
+					compatible = "tc3589x-gpio";
+					interrupts = <0 0x1>;
+
+					interrupt-controller;
+					#interrupt-cells = <2>;
+					gpio-controller;
+					#gpio-cells = <2>;
+				};
 			};
 			tps61052@33 {
 				compatible = "tps61052";
-- 
1.7.9.5

