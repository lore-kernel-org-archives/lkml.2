Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab2FKPZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 11:25:48 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34353 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab2FKPZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 11:25:45 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: linus.walleij@stericsson.com, arnd@arndb.de, grant.likely@secretlab.ca,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 12/14] ARM: ux500: Correctly reference IRQs supplied by the AB8500 from Device Tree
Date: Mon, 11 Jun 2012 16:25:05 +0100
Message-Id: <1339428307-3850-13-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
References: <1339428307-3850-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The AB8500 driver has now been provided with IRQ domain support. This
means we can request IRQs from any of it's uses via Device Tree. This
patch advertises the AB8500 as an Interrupt Controller and provides the
correct calls in the format the driver expects.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/db8500.dtsi |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/arm/boot/dts/db8500.dtsi b/arch/arm/boot/dts/db8500.dtsi
index 01f9a9d..55a36ae 100644
--- a/arch/arm/boot/dts/db8500.dtsi
+++ b/arch/arm/boot/dts/db8500.dtsi
@@ -312,24 +312,26 @@
 				compatible = "stericsson,ab8500";
 				reg = <5>; /* mailbox 5 is i2c */
 				interrupts = <0 40 0x4>;
+				interrupt-controller;
+				#interrupt-cells = <2>;
 
 				ab8500-gpadc {
 					compatible = "stericsson,ab8500-gpadc";
-					interrupts = <0 32 0x4
-						      0 39 0x4>;
+					interrupts = <32 0x4
+						      39 0x4>;
 					interrupt-names = "HW_CONV_END", "SW_CONV_END";
 					vddadc-supply = <&ab8500_ldo_tvout_reg>;
 				};
 
 				ab8500-usb {
 					compatible = "stericsson,ab8500-usb";
-					interrupts = < 0 90 0x4
-						       0 96 0x4
-						       0 14 0x4
-						       0 15 0x4
-						       0 79 0x4
-						       0 74 0x4
-						       0 75 0x4>;
+					interrupts = < 90 0x4
+						       96 0x4
+						       14 0x4
+						       15 0x4
+						       79 0x4
+						       74 0x4
+						       75 0x4>;
 					interrupt-names = "ID_WAKEUP_R",
 							  "ID_WAKEUP_F",
 							  "VBUS_DET_F",
@@ -344,8 +346,8 @@
 
 				ab8500-ponkey {
 					compatible = "stericsson,ab8500-ponkey";
-					interrupts = <0 6 0x4
-						      0 7 0x4>;
+					interrupts = <6 0x4
+						      7 0x4>;
 					interrupt-names = "ONKEY_DBF", "ONKEY_DBR";
 				};
 
-- 
1.7.9.5

