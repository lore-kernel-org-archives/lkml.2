Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112Ab1LBRuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 12:50:54 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:60583 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab1LBRux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 12:50:53 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: robherring2@gmail.com, devicetree-discuss@lists.ozlabs.org,
        netdev@vger.kernel.org, plagnioj@jcrosoft.com
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, jamie@jamieiles.com,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] ARM: at91/net: add macb ethernet controller in 9g45 DT
Date: Fri,  2 Dec 2011 18:50:37 +0100
Message-Id: <1322848237-23154-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1322847782-22650-1-git-send-email-nicolas.ferre@atmel.com>
References: <1322847782-22650-1-git-send-email-nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the Cadence macb ethernet controller in at91sam9g45 .dtsi and
enable it in at91sam9m10g45ek board device tree file.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/boot/dts/at91sam9g45.dtsi     |    7 +++++++
 arch/arm/boot/dts/at91sam9m10g45ek.dts |    6 ++++++
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/at91sam9g45.dtsi b/arch/arm/boot/dts/at91sam9g45.dtsi
index e89b1d7..67f94d3 100644
--- a/arch/arm/boot/dts/at91sam9g45.dtsi
+++ b/arch/arm/boot/dts/at91sam9g45.dtsi
@@ -101,6 +101,13 @@
 				atmel,use-dma-tx;
 				status = "disabled";
 			};
+
+			macb0: ethernet@fffbc000 {
+				compatible = "cdns,at32ap7000-macb", "cdns,macb";
+				reg = <0xfffbc000 0x100>;
+				interrupts = <25 4>;
+				status = "disabled";
+			};
 		};
 	};
 };
diff --git a/arch/arm/boot/dts/at91sam9m10g45ek.dts b/arch/arm/boot/dts/at91sam9m10g45ek.dts
index 85b34f5..17377a2 100644
--- a/arch/arm/boot/dts/at91sam9m10g45ek.dts
+++ b/arch/arm/boot/dts/at91sam9m10g45ek.dts
@@ -30,6 +30,12 @@
 			usart1: serial@fff90000 {
 				status = "okay";
 			};
+
+			macb0: ethernet@fffbc000 {
+				local-mac-address = [3a 0e 03 04 05 06];
+				phy-mode = "rmii";
+				status = "okay";
+			};
 		};
 	};
 };
-- 
1.7.5.4

