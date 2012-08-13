Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab2HMU00 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:26:26 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55329 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab2HMU0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:26:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Shawn Guo <shawn.guo@linaro.org>
Subject: [ 72/82] ARM: dts: imx53-ard: add regulators for lan9220
Date: Mon, 13 Aug 2012 13:19:48 -0700
Message-Id: <20120813201752.761456217@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawn.guo@linaro.org>

commit 1eec0c569523782392b5e6245effddb626213b8c upstream.

Since commit c7e963f (net/smsc911x: Add regulator support), the lan9220
device tree probe fails on imx53-ard board, because the commit makes
VDD33A and VDDVARIO supplies mandatory for the driver.

Add a fixed dummy 3V3 supplying lan9220 to fix the regression.

Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/imx53-ard.dts |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/arch/arm/boot/dts/imx53-ard.dts
+++ b/arch/arm/boot/dts/imx53-ard.dts
@@ -66,10 +66,30 @@
 			interrupt-parent = <&gpio2>;
 			interrupts = <31>;
 			reg-io-width = <4>;
+			/*
+			 * VDD33A and VDDVARIO of LAN9220 are supplied by
+			 * SW4_3V3 of LTC3589.  Before the regulator driver
+			 * for this PMIC is available, we use a fixed dummy
+			 * 3V3 regulator to get LAN9220 driver probing work.
+			 */
+			vdd33a-supply = <&reg_3p3v>;
+			vddvario-supply = <&reg_3p3v>;
 			smsc,irq-push-pull;
 		};
 	};
 
+	regulators {
+		compatible = "simple-bus";
+
+		reg_3p3v: 3p3v {
+			compatible = "regulator-fixed";
+			regulator-name = "3P3V";
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
+			regulator-always-on;
+		};
+	};
+
 	gpio-keys {
 		compatible = "gpio-keys";
 


