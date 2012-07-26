Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab2GZK33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:29:29 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36172 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab2GZK31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:29:27 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, olalilja@yahoo.se, ola.o.lilja@stericsson.com,
        alsa-devel@alsa-project.org, lrg@ti.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 09/21] ARM: ux500: Add MSP devices to DB8500 Device Tree
Date: Thu, 26 Jul 2012 11:28:42 +0100
Message-Id: <1343298534-13611-10-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
References: <1343298534-13611-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

List all four MSP devices which exist on all DB8500 based platforms,
to ensure correct device probing and configuration passing when booting
with DT.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/db8500.dtsi |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm/boot/dts/db8500.dtsi b/arch/arm/boot/dts/db8500.dtsi
index a3bee0a..5a72be6 100644
--- a/arch/arm/boot/dts/db8500.dtsi
+++ b/arch/arm/boot/dts/db8500.dtsi
@@ -591,6 +591,36 @@
 			status = "disabled";
 		};
 
+		msp0: msp@80123000 {
+			compatible = "stericsson,ux500-msp-i2s";
+			reg = <0x80123000 0x1000>;
+			interrupts = <0 31 0x4>;
+			v-ape-supply = <&db8500_vape_reg>;
+		};
+
+		msp1: msp@80124000 {
+			compatible = "stericsson,ux500-msp-i2s";
+			reg = <0x80124000 0x1000>;
+			interrupts = <0 62 0x4>;
+			v-ape-supply = <&db8500_vape_reg>;
+			stericcson,use-pinctrl;
+		};
+
+		// HDMI sound
+		msp2: msp@80117000 {
+			compatible = "stericsson,ux500-msp-i2s";
+			reg = <0x80117000 0x1000>;
+			interrupts = <0 98 0x4>;
+			v-ape-supply = <&db8500_vape_reg>;
+		};
+
+		msp3: msp@80125000 {
+			compatible = "stericsson,ux500-msp-i2s";
+			reg = <0x80125000 0x1000>;
+			interrupts = <0 62 0x4>;
+			v-ape-supply = <&db8500_vape_reg>;
+		};
+
 		external-bus@50000000 {
 			compatible = "simple-bus";
 			reg = <0x50000000 0x4000000>;
-- 
1.7.9.5

