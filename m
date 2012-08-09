Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031385Ab2HIPtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 11:49:21 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53997 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031287Ab2HIPsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 11:48:41 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 20/22] ARM: ux500: Add nodes for the MSP into Device Tree
Date: Thu,  9 Aug 2012 16:47:46 +0100
Message-Id: <1344527268-5964-21-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch inserts all known MSP devices into the DBx5x0 Device Tree
disabled and enables the two important ones for the Snowball low-cost
development board.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi  |   33 +++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/snowball.dts |    8 ++++++++
 2 files changed, 41 insertions(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 83ed692..32e063d 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -621,6 +621,39 @@
 			status = "disabled";
 		};
 
+		msp0: msp@80123000 {
+			compatible = "stericsson,ux500-msp-i2s";
+			reg = <0x80123000 0x1000>;
+			interrupts = <0 31 0x4>;
+			v-ape-supply = <&db8500_vape_reg>;
+			status = "disabled";
+		};
+
+		msp1: msp@80124000 {
+			compatible = "stericsson,ux500-msp-i2s";
+			reg = <0x80124000 0x1000>;
+			interrupts = <0 62 0x4>;
+			v-ape-supply = <&db8500_vape_reg>;
+			status = "disabled";
+		};
+
+		// HDMI sound
+		msp2: msp@80117000 {
+			compatible = "stericsson,ux500-msp-i2s";
+			reg = <0x80117000 0x1000>;
+			interrupts = <0 98 0x4>;
+			v-ape-supply = <&db8500_vape_reg>;
+			status = "disabled";
+		};
+
+		msp3: msp@80125000 {
+			compatible = "stericsson,ux500-msp-i2s";
+			reg = <0x80125000 0x1000>;
+			interrupts = <0 62 0x4>;
+			v-ape-supply = <&db8500_vape_reg>;
+			status = "disabled";
+		};
+
 		external-bus@50000000 {
 			compatible = "simple-bus";
 			reg = <0x50000000 0x4000000>;
diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/snowball.dts
index df6fc57..fce4a00 100644
--- a/arch/arm/boot/dts/snowball.dts
+++ b/arch/arm/boot/dts/snowball.dts
@@ -83,6 +83,14 @@
 	};
 
 	soc-u9500 {
+		msp1: msp@80124000 {
+			status = "okay";
+		};
+
+		msp3: msp@80125000 {
+			status = "okay";
+		};
+
 		external-bus@50000000 {
 			status = "okay";
 
-- 
1.7.9.5

