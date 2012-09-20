Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab2ITMOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 08:14:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56078 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab2ITMN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 08:13:57 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, olof.johansson@gmail.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 31/32] ARM: ux500: Apply tc3589x's GPIO/IRQ properties to HREF's DT
Date: Thu, 20 Sep 2012 14:12:49 +0200
Message-Id: <1348143170-2130-32-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
References: <1348143170-2130-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ensures the tc3589x and tc3598x-gpio devices are
rightfully given interrupt controller status. We also describe
the tc3598x-gpio GPIO expander in full and specify it as a GPIO
controller. Finally we reference that the external MMC slot's
Card Detection GPIO on the HREF is located on the tc3598x-gpio
expander.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/hrefv60plus.dts |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
index e853882..2131d77 100644
--- a/arch/arm/boot/dts/hrefv60plus.dts
+++ b/arch/arm/boot/dts/hrefv60plus.dts
@@ -37,6 +37,21 @@
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
-- 
1.7.9.5

