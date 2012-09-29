Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab2I2Kg2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 06:36:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44848 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab2I2Kfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 06:35:54 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <thierry.reding@avionic-design.de>
CC: <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <omap@vger.kernel.org>, <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH 2/2] ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evm
Date: Sat, 29 Sep 2012 16:05:20 +0530
Message-ID: <1348914920-30737-3-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1348914920-30737-1-git-send-email-avinashphilip@ti.com>
References: <1348914920-30737-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PWM output from ecap0 uses as backlight source. Also adds low threshold
value to have a uniform divisions in brightness-levels scales.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
:100644 100644 a5c4c62... 5516098... M	arch/arm/boot/dts/am335x-evm.dts
 arch/arm/boot/dts/am335x-evm.dts |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index a5c4c62..5516098 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -24,6 +24,14 @@
 		reg = <0x80000000 0x10000000>; /* 256 MB */
 	};
 
+	am33xx_pinmux: pinmux@44e10800 {
+		ecap0_pins: backlight_pins {
+			pinctrl-single,pins = <
+				0x164 0x0	/* eCAP0_in_PWM0_out.eCAP0_in_PWM0_out MODE0 */
+			>;
+		};
+	};
+
 	ocp {
 		uart1: serial@44e09000 {
 			status = "okay";
@@ -75,6 +83,12 @@
 				reg = <0x48>;
 			};
 		};
+
+		ecap0: ecap@48300100 {
+			status = "okay";
+			pinctrl-names = "default";
+			pinctrl-0 = <&ecap0_pins>;
+		};
 	};
 
 	vbat: fixedregulator@0 {
@@ -90,6 +104,13 @@
 		regulator-name = "lis3_reg";
 		regulator-boot-on;
 	};
+
+	backlight {
+		compatible	= "pwm-backlight";
+		pwms = <&ecap0 0 50000 0>;
+		brightness-levels = <0 51 53 56 62 75 101 152 255>;
+		default-brightness-level = <8>;
+	};
 };
 
 /include/ "tps65910.dtsi"
-- 
1.7.0.4

