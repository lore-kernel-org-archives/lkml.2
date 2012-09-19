Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab2IRSNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:13:05 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:56271 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753408Ab2IRSMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:12:37 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 2/2] am33xx: DT convert I2C from OMAP to am33xx names
Date: Wed, 19 Sep 2012 19:08:00 +0300
Message-Id: <1348070880-23390-3-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1348070880-23390-1-git-send-email-panto@antoniou-consulting.com>
References: <1348070880-23390-1-git-send-email-panto@antoniou-consulting.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On OMAP the TRM names I2C instances as i2c1, i2c2, etc.
On the am33xx's it is i2c0, i2c1, etc.

Use am33xx naming everywhere; the only exception is the hwmod names,
which we don't want to mess with right now.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 arch/arm/boot/dts/am335x-bone.dts | 8 ++++----
 arch/arm/boot/dts/am335x-evm.dts  | 2 +-
 arch/arm/boot/dts/am33xx.dtsi     | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
index ce19ea0..553b901 100644
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone.dts
@@ -25,7 +25,7 @@
 	};
 
 	am3358_pinmux: pinmux@44e10800 {
-		i2c3_pins: pinmux_i2c3_pins {
+		i2c2_pins: pinmux_i2c2_pins {
 			pinctrl-single,pins = <
 				0x178 0x73 	/* uart1_ctsn.i2c2_sda, SLEWCTRL_SLOW | INPUT_PULLUP | MODE3 */
 				0x17c 0x73	/* uart1_rtsn.i2c2_scl, SLEWCTRL_SLOW | INPUT_PULLUP | MODE3 */
@@ -39,7 +39,7 @@
 			status = "okay";
 		};
 
-		i2c1: i2c@44e0b000 {
+		i2c0: i2c@44e0b000 {
 			status = "okay";
 			clock-frequency = <400000>;
 
@@ -54,10 +54,10 @@
 
 		};
 
-		i2c3: i2c@4819c000 {
+		i2c2: i2c@4819c000 {
 			status = "okay";
 			pinctrl-names = "default";
-			pinctrl-0 = <&i2c3_pins>;
+			pinctrl-0 = <&i2c2_pins>;
 
 			clock-frequency = <100000>;
 
diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index 4707cda..19706bc 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -29,7 +29,7 @@
 			status = "okay";
 		};
 
-		i2c1: i2c@44e0b000 {
+		i2c0: i2c@44e0b000 {
 			status = "okay";
 			clock-frequency = <400000>;
 
diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index 2c18d31..5ed9287 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -194,7 +194,7 @@
 			status = "disabled";
 		};
 
-		i2c1: i2c@44e0b000 {
+		i2c0: i2c@44e0b000 {
 			compatible = "ti,omap4-i2c";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -205,7 +205,7 @@
 			status = "disabled";
 		};
 
-		i2c2: i2c@4802a000 {
+		i2c1: i2c@4802a000 {
 			compatible = "ti,omap4-i2c";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -216,7 +216,7 @@
 			status = "disabled";
 		};
 
-		i2c3: i2c@4819c000 {
+		i2c2: i2c@4819c000 {
 			compatible = "ti,omap4-i2c";
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
1.7.12

