Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab2LQLXk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 06:23:40 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:43471 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab2LQLXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 06:23:38 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <broonie@opensource.wolfsonmicro.com>, <voice.shen@atmel.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Olof Johansson <olof@lixom.net>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <linux-sound@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/3] ARM: at91/dts: add pinctrl support for SSC peripheral
Date: Mon, 17 Dec 2012 12:23:25 +0100
Message-ID: <a9fb46d9acac93aefdf6c25d846f05abbcae5704.1355742707.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <cover.1355742707.git.nicolas.ferre@atmel.com>
References: <cover.1355742707.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bo Shen <voice.shen@atmel.com>

Add pinctrl support for SSC on AT91 dtsi files.

Signed-off-by: Bo Shen <voice.shen@atmel.com>
[nicolas.ferre@atmel.com: split dtsi and driver changes]
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9260.dtsi | 18 ++++++++++++++++++
 arch/arm/boot/dts/at91sam9263.dtsi | 36 ++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9g45.dtsi | 36 ++++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9n12.dtsi | 26 ++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9x5.dtsi  | 32 +++++++++++++++++++++++++-------
 5 files changed, 141 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index 68bccf4..cb7bcc5 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -306,6 +306,22 @@
 					};
 				};
 
+				ssc0 {
+					pinctrl_ssc0_tx: ssc0_tx-0 {
+						atmel,pins =
+							<1 16 0x1 0x0	/* PB16 periph A */
+							 1 17 0x1 0x0	/* PB17 periph A */
+							 1 18 0x1 0x0>;	/* PB18 periph A */
+					};
+
+					pinctrl_ssc0_rx: ssc0_rx-0 {
+						atmel,pins =
+							<1 19 0x1 0x0	/* PB19 periph A */
+							 1 20 0x1 0x0	/* PB20 periph A */
+							 1 21 0x1 0x0>;	/* PB21 periph A */
+					};
+				};
+
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
@@ -450,6 +466,8 @@
 				compatible = "atmel,at91rm9200-ssc";
 				reg = <0xfffbc000 0x4000>;
 				interrupts = <14 4 5>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/at91sam9263.dtsi b/arch/arm/boot/dts/at91sam9263.dtsi
index 32ec62c..271d4de 100644
--- a/arch/arm/boot/dts/at91sam9263.dtsi
+++ b/arch/arm/boot/dts/at91sam9263.dtsi
@@ -271,6 +271,38 @@
 					};
 				};
 
+				ssc0 {
+					pinctrl_ssc0_tx: ssc0_tx-0 {
+						atmel,pins =
+							<1 0 0x2 0x0	/* PB0 periph B */
+							 1 1 0x2 0x0	/* PB1 periph B */
+							 1 2 0x2 0x0>;	/* PB2 periph B */
+					};
+
+					pinctrl_ssc0_rx: ssc0_rx-0 {
+						atmel,pins =
+							<1 3 0x2 0x0	/* PB3 periph B */
+							 1 4 0x2 0x0	/* PB4 periph B */
+							 1 5 0x2 0x0>;	/* PB5 periph B */
+					};
+				};
+
+				ssc1 {
+					pinctrl_ssc1_tx: ssc1_tx-0 {
+						atmel,pins =
+							<1 6 0x1 0x0	/* PB6 periph A */
+							 1 7 0x1 0x0	/* PB7 periph A */
+							 1 8 0x1 0x0>;	/* PB8 periph A */
+					};
+
+					pinctrl_ssc1_rx: ssc1_rx-0 {
+						atmel,pins =
+							<1 9 0x1 0x0	/* PB9 periph A */
+							 1 10 0x1 0x0	/* PB10 periph A */
+							 1 11 0x1 0x0>;	/* PB11 periph A */
+					};
+				};
+
 				pioA: gpio@fffff200 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff200 0x200>;
@@ -368,6 +400,8 @@
 				compatible = "atmel,at91rm9200-ssc";
 				reg = <0xfff98000 0x4000>;
 				interrupts = <16 4 5>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
 				status = "disabled";
 			};
 
@@ -375,6 +409,8 @@
 				compatible = "atmel,at91rm9200-ssc";
 				reg = <0xfff9c000 0x4000>;
 				interrupts = <17 4 5>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_ssc1_tx &pinctrl_ssc1_rx>;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index 231858f..6b1d4ca 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -290,6 +290,38 @@
 					};
 				};
 
+				ssc0 {
+					pinctrl_ssc0_tx: ssc0_tx-0 {
+						atmel,pins =
+							<3 0 0x1 0x0	/* PD0 periph A */
+							 3 1 0x1 0x0	/* PD1 periph A */
+							 3 2 0x1 0x0>;	/* PD2 periph A */
+					};
+
+					pinctrl_ssc0_rx: ssc0_rx-0 {
+						atmel,pins =
+							<3 3 0x1 0x0	/* PD3 periph A */
+							 3 4 0x1 0x0	/* PD4 periph A */
+							 3 5 0x1 0x0>;	/* PD5 periph A */
+					};
+				};
+
+				ssc1 {
+					pinctrl_ssc1_tx: ssc1_tx-0 {
+						atmel,pins =
+							<3 10 0x1 0x0	/* PD10 periph A */
+							 3 11 0x1 0x0	/* PD11 periph A */
+							 3 12 0x1 0x0>;	/* PD12 periph A */
+					};
+
+					pinctrl_ssc1_rx: ssc1_rx-0 {
+						atmel,pins =
+							<3 13 0x1 0x0	/* PD13 periph A */
+							 3 14 0x1 0x0	/* PD14 periph A */
+							 3 15 0x1 0x0>;	/* PD15 periph A */
+					};
+				};
+
 				pioA: gpio@fffff200 {
 					compatible = "atmel,at91rm9200-gpio";
 					reg = <0xfffff200 0x200>;
@@ -425,6 +457,8 @@
 				compatible = "atmel,at91sam9g45-ssc";
 				reg = <0xfff9c000 0x4000>;
 				interrupts = <16 4 5>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
 				status = "disabled";
 			};
 
@@ -432,6 +466,8 @@
 				compatible = "atmel,at91sam9g45-ssc";
 				reg = <0xfffa0000 0x4000>;
 				interrupts = <17 4 5>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_ssc1_tx &pinctrl_ssc1_rx>;
 				status = "disabled";
 			};
 
diff --git a/arch/arm/boot/dts/at91sam9n12.dtsi b/arch/arm/boot/dts/at91sam9n12.dtsi
index e9efb34..80e29c6 100644
--- a/arch/arm/boot/dts/at91sam9n12.dtsi
+++ b/arch/arm/boot/dts/at91sam9n12.dtsi
@@ -28,6 +28,7 @@
 		tcb1 = &tcb1;
 		i2c0 = &i2c0;
 		i2c1 = &i2c1;
+		ssc0 = &ssc0;
 	};
 	cpus {
 		cpu@0 {
@@ -244,6 +245,22 @@
 					};
 				};
 
+				ssc0 {
+					pinctrl_ssc0_tx: ssc0_tx-0 {
+						atmel,pins =
+							<0 24 0x2 0x0	/* PA24 periph B */
+							 0 25 0x2 0x0	/* PA25 periph B */
+							 0 26 0x2 0x0>;	/* PA26 periph B */
+					};
+
+					pinctrl_ssc0_rx: ssc0_rx-0 {
+						atmel,pins =
+							<0 27 0x2 0x0	/* PA27 periph B */
+							 0 28 0x2 0x0	/* PA28 periph B */
+							 0 29 0x2 0x0>;	/* PA29 periph B */
+					};
+				};
+
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
@@ -294,6 +311,15 @@
 				status = "disabled";
 			};
 
+			ssc0: ssc@f0010000 {
+				compatible = "atmel,at91sam9g45-ssc";
+				reg = <0xf0010000 0x4000>;
+				interrupts = <28 4 5>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
+				status = "disabled";
+			};
+
 			usart0: serial@f801c000 {
 				compatible = "atmel,at91sam9260-usart";
 				reg = <0xf801c000 0x4000>;
diff --git a/arch/arm/boot/dts/at91sam9x5.dtsi b/arch/arm/boot/dts/at91sam9x5.dtsi
index 40ac3a4..3a47cf9 100644
--- a/arch/arm/boot/dts/at91sam9x5.dtsi
+++ b/arch/arm/boot/dts/at91sam9x5.dtsi
@@ -88,13 +88,6 @@
 				interrupts = <1 4 7>;
 			};
 
-			ssc0: ssc@f0010000 {
-				compatible = "atmel,at91sam9g45-ssc";
-				reg = <0xf0010000 0x4000>;
-				interrupts = <28 4 5>;
-				status = "disabled";
-			};
-
 			tcb0: timer@f8008000 {
 				compatible = "atmel,at91sam9x5-tcb";
 				reg = <0xf8008000 0x100>;
@@ -290,6 +283,22 @@
 					};
 				};
 
+				ssc0 {
+					pinctrl_ssc0_tx: ssc0_tx-0 {
+						atmel,pins =
+							<0 24 0x2 0x0	/* PA24 periph B */
+							 0 25 0x2 0x0	/* PA25 periph B */
+							 0 26 0x2 0x0>;	/* PA26 periph B */
+					};
+
+					pinctrl_ssc0_rx: ssc0_rx-0 {
+						atmel,pins =
+							<0 27 0x2 0x0	/* PA27 periph B */
+							 0 28 0x2 0x0	/* PA28 periph B */
+							 0 29 0x2 0x0>;	/* PA29 periph B */
+					};
+				};
+
 				pioA: gpio@fffff400 {
 					compatible = "atmel,at91sam9x5-gpio", "atmel,at91rm9200-gpio";
 					reg = <0xfffff400 0x200>;
@@ -333,6 +342,15 @@
 				};
 			};
 
+			ssc0: ssc@f0010000 {
+				compatible = "atmel,at91sam9g45-ssc";
+				reg = <0xf0010000 0x4000>;
+				interrupts = <28 4 5>;
+				pinctrl-names = "default";
+				pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
+				status = "disabled";
+			};
+
 			mmc0: mmc@f0008000 {
 				compatible = "atmel,hsmci";
 				reg = <0xf0008000 0x600>;
-- 
1.8.0

