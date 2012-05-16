Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab2EPPhP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:37:15 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:17556 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab2EPPhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:37:13 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>, <sfr@canb.auug.org.au>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <plagnioj@jcrosoft.com>, <maxime.ripard@free-electrons.com>,
        <olof@lixom.net>, <linux-next@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91: Add ADC driver to at91sam9260/at91sam9g20 dtsi files
Date: Wed, 16 May 2012 17:37:06 +0200
Message-ID: <1337182626-13033-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <4FB3B1F3.6080102@atmel.com>
References: <4FB3B1F3.6080102@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.159.245.203]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the bulk of at91sam9g20-related nodes are located in at91sam9260.dtsi,
we have to re-create the path to this ADC node for SoC specific parts.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9260.dtsi |   35 +++++++++++++++++++++++++++++++++++
 arch/arm/boot/dts/at91sam9g20.dtsi |    8 ++++++++
 2 files changed, 43 insertions(+)

diff --git a/arch/arm/boot/dts/at91sam9260.dtsi b/arch/arm/boot/dts/at91sam9260.dtsi
index f4605ff..f449efc 100644
--- a/arch/arm/boot/dts/at91sam9260.dtsi
+++ b/arch/arm/boot/dts/at91sam9260.dtsi
@@ -197,6 +197,41 @@
 				interrupts = <10 4>;
 				status = "disabled";
 			};
+
+			adc0: adc@fffe0000 {
+				compatible = "atmel,at91sam9260-adc";
+				reg = <0xfffe0000 0x100>;
+				interrupts = <5 4>;
+				atmel,adc-use-external-triggers;
+				atmel,adc-channels-used = <0xf>;
+				atmel,adc-vref = <3300>;
+				atmel,adc-num-channels = <4>;
+				atmel,adc-startup-time = <15>;
+				atmel,adc-channel-base = <0x30>;
+				atmel,adc-drdy-mask = <0x10000>;
+				atmel,adc-status-register = <0x1c>;
+				atmel,adc-trigger-register = <0x04>;
+
+				trigger@0 {
+					trigger-name = "timer-counter-0";
+					trigger-value = <0x1>;
+				};
+				trigger@1 {
+					trigger-name = "timer-counter-1";
+					trigger-value = <0x3>;
+				};
+
+				trigger@2 {
+					trigger-name = "timer-counter-2";
+					trigger-value = <0x5>;
+				};
+
+				trigger@3 {
+					trigger-name = "external";
+					trigger-value = <0x13>;
+					trigger-external;
+				};
+			};
 		};
 
 		nand0: nand@40000000 {
diff --git a/arch/arm/boot/dts/at91sam9g20.dtsi b/arch/arm/boot/dts/at91sam9g20.dtsi
index 0eb1a75..2a1d1ca 100644
--- a/arch/arm/boot/dts/at91sam9g20.dtsi
+++ b/arch/arm/boot/dts/at91sam9g20.dtsi
@@ -15,4 +15,12 @@
 	memory {
 		reg = <0x20000000 0x08000000>;
 	};
+
+	ahb {
+		apb {
+			adc0: adc@fffe0000 {
+				atmel,adc-startup-time = <40>;
+			};
+		};
+	};
 };
-- 
1.7.10

