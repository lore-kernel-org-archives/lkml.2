Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2IRSMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:12:42 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:56265 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753330Ab2IRSMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:12:35 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Porter <mporter@ti.com>, Koen Kooi <koen@dominion.thruhere.net>,
        Benoit Cousson <b-cousson@ti.com>, Tony Lindgren <tony@atomide.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 1/2] arm/dts: AM33XX: I2C DT bindings for the bone.
Date: Wed, 19 Sep 2012 19:07:59 +0300
Message-Id: <1348070880-23390-2-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1348070880-23390-1-git-send-email-panto@antoniou-consulting.com>
References: <1348070880-23390-1-git-send-email-panto@antoniou-consulting.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add I2C DT bindings for the beaglebone.
This includes bindings for the EEPROMs on both I2C busses.

Note that this requires a pinmux node in am33xx.dtsi,
introduced from 47acae37fa0d11dd8fba58f8825ac3a2baeab903
"arm/dts: AM33XX: Add basic pinctrl device tree data"

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 arch/arm/boot/dts/am335x-bone.dts | 43 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
index 91eee97..ce19ea0 100644
--- a/arch/arm/boot/dts/am335x-bone.dts
+++ b/arch/arm/boot/dts/am335x-bone.dts
@@ -24,7 +24,17 @@
 		reg = <0x80000000 0x10000000>; /* 256 MB */
 	};
 
+	am3358_pinmux: pinmux@44e10800 {
+		i2c3_pins: pinmux_i2c3_pins {
+			pinctrl-single,pins = <
+				0x178 0x73 	/* uart1_ctsn.i2c2_sda, SLEWCTRL_SLOW | INPUT_PULLUP | MODE3 */
+				0x17c 0x73	/* uart1_rtsn.i2c2_scl, SLEWCTRL_SLOW | INPUT_PULLUP | MODE3 */
+			>;
+		};
+	};
+
 	ocp {
+
 		uart1: serial@44e09000 {
 			status = "okay";
 		};
@@ -37,6 +47,39 @@
 				reg = <0x24>;
 			};
 
+			baseboard_eeprom: baseboard_eeprom@50 {
+				compatible = "at,24c256";
+				reg = <0x50>;
+			};
+
+		};
+
+		i2c3: i2c@4819c000 {
+			status = "okay";
+			pinctrl-names = "default";
+			pinctrl-0 = <&i2c3_pins>;
+
+			clock-frequency = <100000>;
+
+			cape_eeprom_0: cape_eeprom_0@54 {
+				compatible = "at,24c256";
+				reg = <0x54>;
+			};
+
+			cape_eeprom_1: cape_eeprom_1@55 {
+				compatible = "at,24c256";
+				reg = <0x55>;
+			};
+
+			cape_eeprom_2: cape_eeprom_2@56 {
+				compatible = "at,24c256";
+				reg = <0x56>;
+			};
+
+			cape_eeprom_3: cape_eeprom_3@57 {
+				compatible = "at,24c256";
+				reg = <0x57>;
+			};
 		};
 	};
 };
-- 
1.7.12

