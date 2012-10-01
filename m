Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab2JAKoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:44:13 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51230 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab2JAKoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:44:07 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/7] ARM: ux500: Add SDI (MMC) support to the HREF Device Tree
Date: Mon,  1 Oct 2012 11:43:43 +0100
Message-Id: <1349088228-8582-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1349088228-8582-1-git-send-email-lee.jones@linaro.org>
References: <1349088228-8582-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here we add the Device Tree nodes which are required to successfully
probe the MMCI driver which will enable the four cards available on
ST-Ericsson's HREF hardware development platform.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/hrefv60plus.dts  |   44 ++++++++++++++++++++++++++++++++++++
 arch/arm/mach-ux500/board-mop500.c |    1 -
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/hrefv60plus.dts b/arch/arm/boot/dts/hrefv60plus.dts
index e2213204..3fd83c6 100644
--- a/arch/arm/boot/dts/hrefv60plus.dts
+++ b/arch/arm/boot/dts/hrefv60plus.dts
@@ -77,6 +77,50 @@
 			};
 		};
 
+		// External Micro SD slot
+		sdi0_per1@80126000 {
+			arm,primecell-periphid = <0x10480180>;
+			max-frequency = <50000000>;
+			bus-width = <4>;
+			mmc-cap-sd-highspeed;
+			mmc-cap-mmc-highspeed;
+			vmmc-supply = <&ab8500_ldo_aux3_reg>;
+
+			cd-gpios  = <&tc3589x_gpio 3 0x4>;
+
+			status = "okay";
+		};
+
+		// WLAN SDIO channel
+		sdi1_per2@80118000 {
+			arm,primecell-periphid = <0x10480180>;
+			max-frequency = <50000000>;
+			bus-width = <4>;
+
+			status = "okay";
+		};
+
+		// PoP:ed eMMC
+		sdi2_per3@80005000 {
+			arm,primecell-periphid = <0x10480180>;
+			max-frequency = <50000000>;
+			bus-width = <8>;
+			mmc-cap-mmc-highspeed;
+
+			status = "okay";
+		};
+
+		// On-board eMMC
+		sdi4_per2@80114000 {
+			arm,primecell-periphid = <0x10480180>;
+		        max-frequency = <50000000>;
+			bus-width = <8>;
+			mmc-cap-mmc-highspeed;
+			vmmc-supply = <&ab8500_ldo_aux2_reg>;
+
+			status = "okay";
+		};
+
 		sound {
 			compatible = "stericsson,snd-soc-mop500";
 
diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 4eedf1c..38e53b2 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -818,7 +818,6 @@ static void __init u8500_init_machine(void)
 		platform_add_devices(mop500_platform_devs,
 				ARRAY_SIZE(mop500_platform_devs));
 
-		mop500_sdi_init(parent);
 		mop500_audio_init(parent);
 		i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
 		i2c_register_board_info(0, mop500_i2c0_devices, i2c0_devs);
-- 
1.7.9.5

