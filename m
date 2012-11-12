Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752344Ab2KLJJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 04:09:03 -0500
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:14969
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751974Ab2KLJJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 04:09:01 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zcb8kzzz1de0h1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah107ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14afh1504h1537h1155h)
From: Liu Ying <Ying.Liu@freescale.com>
To: <shawn.guo@linaro.org>
CC: <liu.y.victor@gmail.com>, <fabio.estevam@freescale.com>,
        <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Liu Ying <Ying.Liu@freescale.com>
Subject: [PATCH 1/1] ARM: dts: imx6q-sabresd: add volume up/down gpio keys
Date: Mon, 12 Nov 2012 16:26:18 +0800
Message-ID: <1352708778-25570-1-git-send-email-Ying.Liu@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add volume up/down gpio keys support in imx6q-sabresd.dts.

Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
---
 arch/arm/boot/dts/imx6q-sabresd.dts |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-sabresd.dts b/arch/arm/boot/dts/imx6q-sabresd.dts
index e596c28..a424025 100644
--- a/arch/arm/boot/dts/imx6q-sabresd.dts
+++ b/arch/arm/boot/dts/imx6q-sabresd.dts
@@ -38,6 +38,8 @@
 				hog {
 					pinctrl_hog: hoggrp {
 						fsl,pins = <
+							1004 0x80000000 /* MX6Q_PAD_GPIO_4__GPIO_1_4 */
+							1012 0x80000000 /* MX6Q_PAD_GPIO_5__GPIO_1_5 */
 							1402 0x80000000	/* MX6Q_PAD_NANDF_D0__GPIO_2_0 */
 							1410 0x80000000	/* MX6Q_PAD_NANDF_D1__GPIO_2_1 */
 							1418 0x80000000	/* MX6Q_PAD_NANDF_D2__GPIO_2_2 */
@@ -73,4 +75,20 @@
 			};
 		};
 	};
+
+	gpio-keys {
+		compatible = "gpio-keys";
+
+		volume-up {
+			label = "Volume Up";
+			gpios = <&gpio1 4 0>;
+			linux,code = <115>; /* KEY_VOLUMEUP */
+		};
+
+		volume-down {
+			label = "Volume Down";
+			gpios = <&gpio1 5 0>;
+			linux,code = <114>; /* KEY_VOLUMEDOWN */
+		};
+	};
 };
-- 
1.7.1


