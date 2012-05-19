Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab2ESK3Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 06:29:25 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:36457 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755345Ab2ESK3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 06:29:24 -0400
From: Roland Stigge <stigge@antcom.de>
To: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH] ARM: LPC32xx: Adjust dts files to gpio dt binding
Date: Sat, 19 May 2012 12:28:53 +0200
Message-Id: <1337423333-24356-1-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO devicetree binding in 3.5 doesn't register the various LPC32xx GPIO
banks via DT subnodes but always all at once, and changes the gpio referencing
to 3 cells (bank, gpio, flags). This patch adjusts the DTS files to this
binding that was just accepted to the gpio subsystem.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---

Applies to branch next/dt of arm-soc.git

You can also pull from

git://git.antcom.de/linux-2.6.git lpc32xx/dt

(where just this single commit is new)

 arch/arm/boot/dts/lpc32xx.dtsi |   41 ++---------------------------------------
 arch/arm/boot/dts/phy3250.dts  |    4 ++--
 2 files changed, 4 insertions(+), 41 deletions(-)

--- linux-2.6.orig/arch/arm/boot/dts/lpc32xx.dtsi
+++ linux-2.6/arch/arm/boot/dts/lpc32xx.dtsi
@@ -215,45 +215,8 @@
 			gpio: gpio@40028000 {
 				compatible = "nxp,lpc3220-gpio";
 				reg = <0x40028000 0x1000>;
-				/* create a private address space for enumeration */
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				gpio_p0: gpio-bank@0 {
-					gpio-controller;
-					#gpio-cells = <2>;
-					reg = <0>;
-				};
-
-				gpio_p1: gpio-bank@1 {
-					gpio-controller;
-					#gpio-cells = <2>;
-					reg = <1>;
-				};
-
-				gpio_p2: gpio-bank@2 {
-					gpio-controller;
-					#gpio-cells = <2>;
-					reg = <2>;
-				};
-
-				gpio_p3: gpio-bank@3 {
-					gpio-controller;
-					#gpio-cells = <2>;
-					reg = <3>;
-				};
-
-				gpi_p3: gpio-bank@4 {
-					gpio-controller;
-					#gpio-cells = <2>;
-					reg = <4>;
-				};
-
-				gpo_p3: gpio-bank@5 {
-					gpio-controller;
-					#gpio-cells = <2>;
-					reg = <5>;
-				};
+				gpio-controller;
+				#gpio-cells = <3>; /* bank, pin, flags */
 			};
 
 			watchdog@4003C000 {
--- linux-2.6.orig/arch/arm/boot/dts/phy3250.dts
+++ linux-2.6/arch/arm/boot/dts/phy3250.dts
@@ -131,13 +131,13 @@
 		compatible = "gpio-leds";
 
 		led0 {
-			gpios = <&gpo_p3 1 1>; /* GPO_P3 1, GPIO 80, active low */
+			gpios = <&gpio 5 1 1>; /* GPO_P3 1, GPIO 80, active low */
 			linux,default-trigger = "heartbeat";
 			default-state = "off";
 		};
 
 		led1 {
-			gpios = <&gpo_p3 14 1>; /* GPO_P3 14, GPIO 93, active low */
+			gpios = <&gpio 5 14 1>; /* GPO_P3 14, GPIO 93, active low */
 			linux,default-trigger = "timer";
 			default-state = "off";
 		};
