Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760429Ab2IGLPg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:15:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41840 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928Ab2IGLPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:15:21 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 04/19] ARM: ux500: Add SDI (MMC) support to the HREF Device Tree
Date: Fri,  7 Sep 2012 12:14:44 +0100
Message-Id: <1347016499-29354-5-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we add the Device Tree nodes which are required to successfully
probe the MMCI driver which will enable the four cards available on
ST-Ericsson's HREF hardware development platform.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/hrefv60plus.dts |   45 +++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
index 32cd7a0..62b2ac1 100644
--- a/arch/arm/boot/dts/hrefv60plus.dts
+++ b/arch/arm/boot/dts/hrefv60plus.dts
@@ -32,5 +32,50 @@
 		uart@80007000 {
 			status = "okay";
 		};
+
+		// External Micro SD slot
+		sdi@80126000 {
+			arm,primecell-periphid = <0x10480180>;
+			max-frequency = <50000000>;
+			bus-width = <8>;
+			mmc-cap-sd-highspeed;
+			mmc-cap-mmc-highspeed;
+			vmmc-supply = <&ab8500_ldo_aux3_reg>;
+
+			#gpio-cells = <1>;
+			cd-gpios  = <&gpio2 31 0x4>; // 95
+
+			status = "okay";
+		};
+
+		// WLAN SDIO channel
+		sdi@80118000 {
+			arm,primecell-periphid = <0x10480180>;
+			max-frequency = <50000000>;
+			bus-width = <4>;
+
+			status = "okay";
+		};
+
+		// PoP:ed eMMC
+		sdi@80005000 {
+			arm,primecell-periphid = <0x10480180>;
+			max-frequency = <50000000>;
+			bus-width = <8>;
+			mmc-cap-mmc-highspeed;
+
+			status = "okay";
+		};
+
+		// On-board eMMC
+		sdi@80114000 {
+			arm,primecell-periphid = <0x10480180>;
+		        max-frequency = <50000000>;
+			bus-width = <8>;
+			mmc-cap-mmc-highspeed;
+			vmmc-supply = <&ab8500_ldo_aux2_reg>;
+
+			status = "okay";
+		};
 	};
 };
-- 
1.7.9.5

