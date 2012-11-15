Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767769Ab2KONO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:14:58 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51856 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767726Ab2KONOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:14:55 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/2] ARM: ux500: Move board specific GPIO info out to subordinate DTS files
Date: Thu, 15 Nov 2012 13:14:48 +0000
Message-Id: <1352985288-29518-2-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1352985288-29518-1-git-send-email-lee.jones@linaro.org>
References: <1352985288-29518-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GPIO numbers for the newly created gpio-regulator will differ from
board to board. Therefore it's not sensible to leave this information
in the top level DTSI file. Let's move them out to the DTS files
where they can correctly vary.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi    |    2 --
 arch/arm/boot/dts/hrefprev60.dts |    7 +++++++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index d8ba489..9f55363 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -638,8 +638,6 @@
 			regulator-name = "mmci-reg";
 			regulator-type = "voltage";
 
-			gpios = <&tc3589x_gpio 18 0x4>;
-			gpio-enable = <&tc3589x_gpio 17 0x4>;
 			states = <1800000 0x1
 				  2900000 0x0>;
 
diff --git a/arch/arm/boot/dts/hrefprev60.dts b/arch/arm/boot/dts/hrefprev60.dts
index b398946..eec29c4 100644
--- a/arch/arm/boot/dts/hrefprev60.dts
+++ b/arch/arm/boot/dts/hrefprev60.dts
@@ -37,5 +37,12 @@
 				reset-gpio = <&tc3589x_gpio 13 0x4>;
 			};
 		};
+
+		vmmci: regulator-gpio {
+			gpios = <&tc3589x_gpio 18 0x4>;
+			gpio-enable = <&tc3589x_gpio 17 0x4>;
+
+			status = "okay";
+		};
 	};
 };
-- 
1.7.9.5

