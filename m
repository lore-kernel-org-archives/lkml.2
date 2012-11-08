Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab2KHH7s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 02:59:48 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:53754 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124Ab2KHH7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 02:59:43 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>
CC: <hvaibhav@ti.com>, <anilkumar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <vaibhav.bedia@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH v2 10/10] ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evm
Date: Thu, 8 Nov 2012 13:23:17 +0530
Message-ID: <1352361197-27442-11-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1352361197-27442-1-git-send-email-avinashphilip@ti.com>
References: <1352361197-27442-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PWM output from ecap0 uses as backlight source. Also adds low threshold
value to have a uniform divisions in brightness-levels scales.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
:100644 100644 185d632... 9857050... M	arch/arm/boot/dts/am335x-evm.dts
 arch/arm/boot/dts/am335x-evm.dts |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index 185d632..9857050 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -18,6 +18,14 @@
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
@@ -31,6 +39,12 @@
 				reg = <0x2d>;
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
@@ -40,6 +54,13 @@
 		regulator-max-microvolt = <5000000>;
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

