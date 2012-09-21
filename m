Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066Ab2IUKHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 06:07:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48957 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999Ab2IUKHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 06:07:33 -0400
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH v2 4/4] ARM: dts: enable 88pm860x pmic
Date: Fri, 21 Sep 2012 18:06:54 +0800
Message-Id: <1348222014-15927-5-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348222014-15927-1-git-send-email-haojian.zhuang@gmail.com>
References: <1348222014-15927-1-git-send-email-haojian.zhuang@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
---
 arch/arm/boot/dts/pxa910-dkb.dts |  137 ++++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/pxa910.dtsi    |    4 ++
 2 files changed, 141 insertions(+)

diff --git a/arch/arm/boot/dts/pxa910-dkb.dts b/arch/arm/boot/dts/pxa910-dkb.dts
index e92be5a..595492a 100644
--- a/arch/arm/boot/dts/pxa910-dkb.dts
+++ b/arch/arm/boot/dts/pxa910-dkb.dts
@@ -29,6 +29,143 @@
 			};
 			twsi1: i2c@d4011000 {
 				status = "okay";
+
+				pmic: 88pm860x@34 {
+					compatible = "marvell,88pm860x";
+					reg = <0x34>;
+					interrupts = <4>;
+					interrupt-parent = <&intc>;
+					interrupt-controller;
+					#interrupt-cells = <1>;
+
+					marvell,88pm860x-irq-read-clr;
+					marvell,88pm860x-slave-addr = <0x11>;
+
+					regulators {
+						BUCK1 {
+							regulator-min-microvolt = <1000000>;
+							regulator-max-microvolt = <1500000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						BUCK2 {
+							regulator-min-microvolt = <1000000>;
+							regulator-max-microvolt = <1500000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						BUCK3 {
+							regulator-min-microvolt = <1000000>;
+							regulator-max-microvolt = <3000000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO1 {
+							regulator-min-microvolt = <1200000>;
+							regulator-max-microvolt = <2800000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO2 {
+							regulator-min-microvolt = <1800000>;
+							regulator-max-microvolt = <3300000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO3 {
+							regulator-min-microvolt = <1800000>;
+							regulator-max-microvolt = <3300000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO4 {
+							regulator-min-microvolt = <1800000>;
+							regulator-max-microvolt = <3300000>;
+							regulator-always-on;
+						};
+						LDO5 {
+							regulator-min-microvolt = <2900000>;
+							regulator-max-microvolt = <3300000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO6 {
+							regulator-min-microvolt = <1800000>;
+							regulator-max-microvolt = <3300000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO7 {
+							regulator-min-microvolt = <1800000>;
+							regulator-max-microvolt = <2900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO8 {
+							regulator-min-microvolt = <1800000>;
+							regulator-max-microvolt = <2900000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO9 {
+							regulator-min-microvolt = <1800000>;
+							regulator-max-microvolt = <3300000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO10 {
+							regulator-min-microvolt = <1200000>;
+							regulator-max-microvolt = <3300000>;
+							regulator-boot-on;
+							regulator-always-on;
+						};
+						LDO12 {
+							regulator-min-microvolt = <1200000>;
+							regulator-max-microvolt = <3300000>;
+							regulator-always-on;
+						};
+						LDO13 {
+							regulator-min-microvolt = <1200000>;
+							regulator-max-microvolt = <3300000>;
+							regulator-always-on;
+						};
+						LDO14 {
+							regulator-min-microvolt = <1800000>;
+							regulator-max-microvolt = <3300000>;
+							regulator-always-on;
+						};
+					};
+					rtc {
+						marvell,88pm860x-vrtc = <1>;
+					};
+					touch {
+						marvell,88pm860x-gpadc-prebias = <1>;
+						marvell,88pm860x-gpadc-slot-cycle = <1>;
+						marvell,88pm860x-tsi-prebias = <6>;
+						marvell,88pm860x-pen-prebias = <16>;
+						marvell,88pm860x-pen-prechg = <2>;
+						marvell,88pm860x-resistor-X = <300>;
+					};
+					backlights {
+						backlight-0 {
+							marvell,88pm860x-iset = <4>;
+							marvell,88pm860x-pwm = <3>;
+						};
+						backlight-2 {
+						};
+					};
+					leds {
+						led0-red {
+							marvell,88pm860x-iset = <12>;
+						};
+						led0-green {
+							marvell,88pm860x-iset = <12>;
+						};
+						led0-blue {
+							marvell,88pm860x-iset = <12>;
+						};
+					};
+				};
 			};
 			rtc: rtc@d4010000 {
 				status = "okay";
diff --git a/arch/arm/boot/dts/pxa910.dtsi b/arch/arm/boot/dts/pxa910.dtsi
index aebf32d..1942e54 100644
--- a/arch/arm/boot/dts/pxa910.dtsi
+++ b/arch/arm/boot/dts/pxa910.dtsi
@@ -115,6 +115,8 @@
 
 			twsi1: i2c@d4011000 {
 				compatible = "mrvl,mmp-twsi";
+				#address-cells = <1>;
+				#size-cells = <0>;
 				reg = <0xd4011000 0x1000>;
 				interrupts = <7>;
 				mrvl,i2c-fast-mode;
@@ -123,6 +125,8 @@
 
 			twsi2: i2c@d4037000 {
 				compatible = "mrvl,mmp-twsi";
+				#address-cells = <1>;
+				#size-cells = <0>;
 				reg = <0xd4037000 0x1000>;
 				interrupts = <54>;
 				status = "disabled";
-- 
1.7.9.5

