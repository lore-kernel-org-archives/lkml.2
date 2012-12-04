Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab2LDH74 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 02:59:56 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:4601 "EHLO sjogate2.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab2LDH7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 02:59:54 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, linux@arm.linux.org.uk
Subject: [v2 PATCH 14/14] ARM: dts: add spi nodes for atmel boards
Date: Tue,  4 Dec 2012 15:54:00 +0800
Message-Id: <1354607640-13229-15-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354607640-13229-1-git-send-email-wenyou.yang@atmel.com>
References: <1354607640-13229-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 04 Dec 2012 07:59:46.0733 (UTC) FILETIME=[53D5DDD0:01CDD1F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Genoud <richard.genoud@gmail.com>

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
[wenyou.yang@atmel.com: added spi nodes for other atmel boards]
[wenyou.yang@atmel.com: remove the cs-gpios property for sam9x5ek boards]
Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux@arm.linux.org.uk
---
 arch/arm/boot/dts/at91sam9263ek.dts         |    9 +++++++++
 arch/arm/boot/dts/at91sam9g20ek_common.dtsi |    9 +++++++++
 arch/arm/boot/dts/at91sam9g25ek.dts         |    9 +++++++++
 arch/arm/boot/dts/at91sam9m10g45ek.dts      |    9 +++++++++
 arch/arm/boot/dts/at91sam9n12ek.dts         |    9 +++++++++
 5 files changed, 45 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9263ek.dts b/arch/arm/boot/dts/at91sam9263ek.dts
index f86ac4b..11e274d 100644
--- a/arch/arm/boot/dts/at91sam9263ek.dts
+++ b/arch/arm/boot/dts/at91sam9263ek.dts
@@ -50,6 +50,15 @@
 				atmel,vbus-gpio = <&pioA 25 0>;
 				status = "okay";
 			};
+
+			spi0: spi@fffa4000 {
+				status = "okay";
+				mtd_dataflash@0 {
+					compatible = "atmel,at45", "atmel,dataflash";
+					spi-max-frequency = <50000000>;
+					reg = <0>;
+				};
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
index e6391a4..3c3b63d 100644
--- a/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20ek_common.dtsi
@@ -51,6 +51,15 @@
 				atmel,vbus-gpio = <&pioC 5 0>;
 				status = "okay";
 			};
+
+			spi0: spi@fffc8000 {
+				status = "okay";
+				mtd_dataflash@0 {
+					compatible = "atmel,at45", "atmel,dataflash";
+					spi-max-frequency = <50000000>;
+					reg = <1>;
+				};
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9g25ek.dts b/arch/arm/boot/dts/at91sam9g25ek.dts
index 877c08f..3b84bc9 100644
--- a/arch/arm/boot/dts/at91sam9g25ek.dts
+++ b/arch/arm/boot/dts/at91sam9g25ek.dts
@@ -44,6 +44,15 @@
 			i2c2: i2c@f8018000 {
 				status = "okay";
 			};
+
+			spi0: spi@f0000000 {
+				status = "okay";
+				m25p80@0 {
+					compatible = "atmel,at25df321a";
+					spi-max-frequency = <50000000>;
+					reg = <0>;
+				};
+			};
 		};
 
 		usb0: ohci@00600000 {
diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts b/arch/arm/boot/dts/at91sam9m10g45ek.dts
index 15e1dd4..a23ac6e 100644
--- a/arch/arm/boot/dts/at91sam9m10g45ek.dts
+++ b/arch/arm/boot/dts/at91sam9m10g45ek.dts
@@ -54,6 +54,15 @@
 			i2c1: i2c@fff88000 {
 				status = "okay";
 			};
+
+			spi0: spi@fffa4000{
+				status = "okay";
+				mtd_dataflash@0 {
+					compatible = "atmel,at45", "atmel,dataflash";
+					spi-max-frequency = <13000000>;
+					reg = <0>;
+				};
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9n12ek.dts b/arch/arm/boot/dts/at91sam9n12ek.dts
index 912b2c2..706bd00 100644
--- a/arch/arm/boot/dts/at91sam9n12ek.dts
+++ b/arch/arm/boot/dts/at91sam9n12ek.dts
@@ -45,6 +45,15 @@
 			i2c1: i2c@f8014000 {
 				status = "okay";
 			};
+
+			spi0: spi@f0000000 {
+				status = "okay";
+				m25p80@0 {
+					compatible = "atmel,at25df321a";
+					spi-max-frequency = <50000000>;
+					reg = <0>;
+				};
+			};
 		};
 
 		nand0: nand@40000000 {
-- 
1.7.9.5

