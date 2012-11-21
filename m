Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab2KUNQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:16:15 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:41709 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368Ab2KUNQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:16:11 -0500
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>, <paul@pwsan.com>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <b-cousson@ti.com>
CC: <hvaibhav@ti.com>, <anilkumar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <nsekhar@ti.com>, <gururaja.hebbar@ti.com>, <vaibhav.bedia@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH v4 11/11] ARM: dts: AM33XX: Add PWM backlight DT data to am335x-evmsk
Date: Wed, 21 Nov 2012 18:41:08 +0530
Message-ID: <1353503469-18634-12-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
References: <1353503469-18634-1-git-send-email-avinashphilip@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PWM output from ecap2 uses as backlight source. Also adds low threshold
value to have a uniform divisions in brightness-levels scales with
inverse polarity.

Signed-off-by: Philip, Avinash <avinashphilip@ti.com>
---
:100644 100644 f5a6162... 6f3de83... M	arch/arm/boot/dts/am335x-evmsk.dts
 arch/arm/boot/dts/am335x-evmsk.dts |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
index f5a6162..6f3de83 100644
--- a/arch/arm/boot/dts/am335x-evmsk.dts
+++ b/arch/arm/boot/dts/am335x-evmsk.dts
@@ -51,6 +51,12 @@
 				0x9c 0x27	/* gpmc_ben0_cle.gpio2_5, INPUT | MODE7 */
 			>;
 		};
+
+		ecap2_pins: backlight_pins {
+			pinctrl-single,pins = <
+				0x19c 0x4	/* mcasp0_ahclkr.ecap2_in_pwm2_out MODE4 */
+			>;
+		};
 	};
 
 	ocp {
@@ -94,6 +100,16 @@
 				st,max-limit-z = <750>;
 			};
 		};
+
+		epwmss2: epwmss@48304000 {
+			status = "okay";
+
+			ecap2: ecap@48304100 {
+				status = "okay";
+				pinctrl-names = "default";
+				pinctrl-0 = <&ecap2_pins>;
+			};
+		};
 	};
 
 	vbat: fixedregulator@0 {
@@ -170,6 +186,13 @@
 			gpios = <&gpio3 5 0>;
 		};
 	};
+
+	backlight {
+		compatible	= "pwm-backlight";
+		pwms = <&ecap2 0 50000 1>;
+		brightness-levels = <0 58 61 66 75 90 125 170 255>;
+		default-brightness-level = <8>;
+	};
 };
 
 /include/ "tps65910.dtsi"
-- 
1.7.0.4

