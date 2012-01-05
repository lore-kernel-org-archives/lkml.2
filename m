Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab2AEBYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 20:24:01 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:40594 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518Ab2AEBXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 20:23:52 -0500
From: Jamie Iles <jamie@jamieiles.com>
To: linux-kernel@vger.kernel.org
Cc: devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com, robherring2@gmail.com,
        broonie@opensource.wolfsonmicro.com, Jamie Iles <jamie@jamieiles.com>
Subject: [PATCHv5 4/4] ARM: picoxcell: use new Synopsys Designware GPIO binding
Date: Thu,  5 Jan 2012 01:23:39 +0000
Message-Id: <1325726619-31796-5-git-send-email-jamie@jamieiles.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1325726619-31796-1-git-send-email-jamie@jamieiles.com>
References: <1325726619-31796-1-git-send-email-jamie@jamieiles.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the DesignWare specific binding rather than the generic binding
which isn't supported in mainline.

Signed-off-by: Jamie Iles <jamie@jamieiles.com>
---
 arch/arm/boot/dts/picoxcell-pc3x2.dtsi |   19 ++++++++-----------
 arch/arm/boot/dts/picoxcell-pc3x3.dtsi |   28 +++++++++++-----------------
 2 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/arch/arm/boot/dts/picoxcell-pc3x2.dtsi b/arch/arm/boot/dts/picoxcell-pc3x2.dtsi
index f0a8c20..a247812 100644
--- a/arch/arm/boot/dts/picoxcell-pc3x2.dtsi
+++ b/arch/arm/boot/dts/picoxcell-pc3x2.dtsi
@@ -169,28 +169,25 @@
 				reg = <0x20000 0x1000>;
 				#address-cells = <1>;
 				#size-cells = <0>;
-				reg-io-width = <4>;
 
 				banka: gpio-controller@0 {
 					compatible = "snps,dw-apb-gpio-bank";
 					gpio-controller;
 					#gpio-cells = <2>;
-					gpio-generic,nr-gpio = <8>;
-
-					regoffset-dat = <0x50>;
-					regoffset-set = <0x00>;
-					regoffset-dirout = <0x04>;
+					nr-gpio = <8>;
+					reg = <0>;
+					interrupt-controller;
+					#interrupt-cells = <2>;
+					interrupt-parent = <&vic1>;
+					interrupts = <0 1 2 3 4 5 6 7>;
 				};
 
 				bankb: gpio-controller@1 {
 					compatible = "snps,dw-apb-gpio-bank";
 					gpio-controller;
 					#gpio-cells = <2>;
-					gpio-generic,nr-gpio = <8>;
-
-					regoffset-dat = <0x54>;
-					regoffset-set = <0x0c>;
-					regoffset-dirout = <0x10>;
+					nr-gpio = <8>;
+					reg = <1>;
 				};
 			};
 
diff --git a/arch/arm/boot/dts/picoxcell-pc3x3.dtsi b/arch/arm/boot/dts/picoxcell-pc3x3.dtsi
index daa962d..96f049f 100644
--- a/arch/arm/boot/dts/picoxcell-pc3x3.dtsi
+++ b/arch/arm/boot/dts/picoxcell-pc3x3.dtsi
@@ -252,39 +252,33 @@
 				reg = <0x20000 0x1000>;
 				#address-cells = <1>;
 				#size-cells = <0>;
-				reg-io-width = <4>;
 
 				banka: gpio-controller@0 {
 					compatible = "snps,dw-apb-gpio-bank";
 					gpio-controller;
+					reg = <0>;
 					#gpio-cells = <2>;
-					gpio-generic,nr-gpio = <8>;
-
-					regoffset-dat = <0x50>;
-					regoffset-set = <0x00>;
-					regoffset-dirout = <0x04>;
+					nr-gpio = <8>;
+					interrupt-controller;
+					#interrupt-cells = <2>;
+					interrupt-parent = <&vic1>;
+					interrupts = <0 1 2 3 4 5 6 7>;
 				};
 
 				bankb: gpio-controller@1 {
 					compatible = "snps,dw-apb-gpio-bank";
 					gpio-controller;
+					reg = <1>;
 					#gpio-cells = <2>;
-					gpio-generic,nr-gpio = <16>;
-
-					regoffset-dat = <0x54>;
-					regoffset-set = <0x0c>;
-					regoffset-dirout = <0x10>;
+					nr-gpio = <16>;
 				};
 
-				bankd: gpio-controller@2 {
+				bankd: gpio-controller@3 {
 					compatible = "snps,dw-apb-gpio-bank";
 					gpio-controller;
+					reg = <3>;
 					#gpio-cells = <2>;
-					gpio-generic,nr-gpio = <30>;
-
-					regoffset-dat = <0x5c>;
-					regoffset-set = <0x24>;
-					regoffset-dirout = <0x28>;
+					nr-gpio = <30>;
 				};
 			};
 
-- 
1.7.5.4

