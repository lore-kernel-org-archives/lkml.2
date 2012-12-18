Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab2LRA3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 19:29:55 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:40824 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab2LRA3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 19:29:54 -0500
X-Greylist: delayed 310 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2012 19:29:54 EST
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ARM: Dove: add Cubox sdhci card detect gpio
Date: Tue, 18 Dec 2012 01:24:29 +0100
Message-Id: <1355790269-10596-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1355790269-10596-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1355790269-10596-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Card detect for sdhci on Cubox is connected to the wrong pin
(sdio1_cd instead of sdio0_cd). With support for cd-gpios and
pinctrl add the corresponding properties to DT for Cubox.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/dove-cubox.dts |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/dove-cubox.dts b/arch/arm/boot/dts/dove-cubox.dts
index fed7d3f..cdee96f 100644
--- a/arch/arm/boot/dts/dove-cubox.dts
+++ b/arch/arm/boot/dts/dove-cubox.dts
@@ -26,10 +26,15 @@
 };
 
 &uart0 { status = "okay"; };
-&sdio0 { status = "okay"; };
 &sata0 { status = "okay"; };
 &i2c0 { status = "okay"; };
 
+&sdio0 {
+	status = "okay";
+	/* sdio0 card detect is connected to wrong pin on CuBox */
+	cd-gpios = <&gpio0 12 1>;
+};
+
 &spi0 {
 	status = "okay";
 
@@ -42,9 +47,14 @@
 };
 
 &pinctrl {
-	pinctrl-0 = <&pmx_gpio_18>;
+	pinctrl-0 = <&pmx_gpio_12 &pmx_gpio_18>;
 	pinctrl-names = "default";
 
+	pmx_gpio_12: pmx-gpio-12 {
+		marvell,pins = "mpp12";
+		marvell,function = "gpio";
+	};
+
 	pmx_gpio_18: pmx-gpio-18 {
 		marvell,pins = "mpp18";
 		marvell,function = "gpio";
-- 
1.7.10.4

