Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab3ABN07 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 08:26:59 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46038 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab3ABN0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 08:26:53 -0500
From: Philip Avinash <avinashphilip@ti.com>
To: <tony@atomide.com>, <paul@pwsan.com>, <linux@arm.linux.org.uk>,
        <b-cousson@ti.com>
CC: <hvaibhav@ti.com>, <anilkumar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <vaibhav.bedia@ti.com>,
        Philip Avinash <avinashphilip@ti.com>
Subject: [PATCH 6/7] ARM: dts: AM33XX: Add PWM backlight DT data to  am335x-evm
Date: Wed, 2 Jan 2013 18:54:53 +0530
Message-ID: <1357133094-30806-7-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357133094-30806-1-git-send-email-avinashphilip@ti.com>
References: <1357133094-30806-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PWM output from ecap0 uses as backlight source. Also adds low threshold
value to have a uniform divisions in brightness-levels scales.

Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 arch/arm/boot/dts/am335x-evm.dts |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
index d649644..fd3b691 100644
--- a/arch/arm/boot/dts/am335x-evm.dts
+++ b/arch/arm/boot/dts/am335x-evm.dts
@@ -44,6 +44,12 @@
 				0x154 0x27	/* spi0_d0.gpio0_3, INPUT | MODE7 */
 			>;
 		};
+
+		ecap0_pins: backlight_pins {
+			pinctrl-single,pins = <
+				0x164 0x0	/* eCAP0_in_PWM0_out.eCAP0_in_PWM0_out MODE0 */
+			>;
+		};
 	};
 
 	ocp {
@@ -102,6 +108,16 @@
 				reg = <0x48>;
 			};
 		};
+
+		epwmss0: epwmss@48300000 {
+			status = "okay";
+
+			ecap0: ecap@48300100 {
+				status = "okay";
+				pinctrl-names = "default";
+				pinctrl-0 = <&ecap0_pins>;
+			};
+		};
 	};
 
 	vbat: fixedregulator@0 {
@@ -158,6 +174,13 @@
 			gpio-key,wakeup;
 		};
 	};
+
+	backlight {
+		compatible = "pwm-backlight";
+		pwms = <&ecap0 0 50000 0>;
+		brightness-levels = <0 51 53 56 62 75 101 152 255>;
+		default-brightness-level = <8>;
+	};
 };
 
 /include/ "tps65910.dtsi"
-- 
1.7.9.5

