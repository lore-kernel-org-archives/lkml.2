Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760655Ab2EPU0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 16:26:45 -0400
Received: from mail.work-microwave.de ([62.245.205.51]:56435 "EHLO
	work-microwave.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760630Ab2EPU0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 16:26:43 -0400
From: Roland Stigge <stigge@antcom.de>
To: dmitry.torokhov@gmail.com, axel.lin@gmail.com, riyer@nvidia.com,
        michael.hennerich@analog.com, grant.likely@secretlab.ca,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, devicetree-discuss@lists.ozlabs.org,
        rob.herring@calxeda.com
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH RESEND v3 2/2] ARM: LPC32xx: Make platform use key driver
Date: Wed, 16 May 2012 22:25:55 +0200
Message-Id: <1337199955-26441-2-git-send-email-stigge@antcom.de>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1337199955-26441-1-git-send-email-stigge@antcom.de>
References: <1337199955-26441-1-git-send-email-stigge@antcom.de>
X-FEAS-SYSTEM-WL: rst@work-microwave.de, 192.168.11.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch connects the lpc32xx-key driver to the LPC32xx platform (via
lpc32xx.dtsi), and more specifically to the reference board via its dts file.
The clock.c file needs to be changed to match the automatic device name to its
clock.

Signed-off-by: Roland Stigge <stigge@antcom.de>

---
Applies to v3.4-rc7 + LPC32xx DT patches

Please pick this patch for the arm-soc subsystem.

Changes since v2:
* DT: Use "keypad,num-rows", "keypad,num-columns" and "linux,keymap" properties

 arch/arm/boot/dts/lpc32xx.dtsi |    2 ++
 arch/arm/boot/dts/phy3250.dts  |    9 +++++++++
 arch/arm/mach-lpc32xx/clock.c  |    2 +-
 3 files changed, 12 insertions(+), 1 deletion(-)

--- linux-2.6.orig/arch/arm/boot/dts/lpc32xx.dtsi
+++ linux-2.6/arch/arm/boot/dts/lpc32xx.dtsi
@@ -249,6 +249,8 @@
 			key@40050000 {
 				compatible = "nxp,lpc3220-key";
 				reg = <0x40050000 0x1000>;
+				interrupts = <54 0>;
+				status = "disable";
 			};
 
 		};
--- linux-2.6.orig/arch/arm/boot/dts/phy3250.dts
+++ linux-2.6/arch/arm/boot/dts/phy3250.dts
@@ -135,6 +135,15 @@
 			tsc@40048000 {
 				status = "okay";
 			};
+
+			key@40050000 {
+				status = "okay";
+				keypad,num-rows = <1>;
+				keypad,num-columns = <1>;
+				nxp,debounce-delay-ms = <3>;
+				nxp,scan-delay-ms = <34>;
+				linux,keymap = <0x00000002>;
+			};
 		};
 	};
 
--- linux-2.6.orig/arch/arm/mach-lpc32xx/clock.c
+++ linux-2.6/arch/arm/mach-lpc32xx/clock.c
@@ -1134,7 +1134,7 @@ static struct clk_lookup lookups[] = {
 	CLKDEV_INIT("31020300.i2c", NULL, &clk_i2c2),
 	CLKDEV_INIT("dev:ssp0", NULL, &clk_ssp0),
 	CLKDEV_INIT("dev:ssp1", NULL, &clk_ssp1),
-	CLKDEV_INIT("lpc32xx_keys.0", NULL, &clk_kscan),
+	CLKDEV_INIT("40050000.key", NULL, &clk_kscan),
 	CLKDEV_INIT("20020000.flash", NULL, &clk_nand),
 	CLKDEV_INIT("200a8000.flash", NULL, &clk_nand_mlc),
 	CLKDEV_INIT("40048000.adc", NULL, &clk_adc),
