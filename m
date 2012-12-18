Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754577Ab2LRJS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 04:18:27 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:50491 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab2LRJSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 04:18:25 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH 2/2] ARM: ux500: add pinctrl address resources
Date: Tue, 18 Dec 2012 10:12:12 +0100
Message-Id: <1355821932-15799-2-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1355821932-15799-1-git-send-email-fabio.baltieri@linaro.org>
References: <1355821932-15799-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current nmk_pinctrl driver is not PRCMU dependent anymore, so it needs
its own DT address resources to work properly, as done for
platform_device in:

f482833 ARM: ux500: add PRCM register base for pinctrl

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi    | 3 ++-
 arch/arm/mach-ux500/cpu-db8500.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 2efd9c8..16552d4 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -170,7 +170,8 @@
 			gpio-bank = <8>;
 		};
 
-		pinctrl {
+		pinctrl@80157000 {
+			reg = <0x80157000 0x2000>;
 			compatible = "stericsson,nmk_pinctrl";
 		};
 
diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
index db0bb75..5b286e0 100644
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@ -285,7 +285,8 @@ static struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("st,nomadik-i2c", 0x80110000, "nmk-i2c.3", NULL),
 	OF_DEV_AUXDATA("st,nomadik-i2c", 0x8012a000, "nmk-i2c.4", NULL),
 	/* Requires device name bindings. */
-	OF_DEV_AUXDATA("stericsson,nmk_pinctrl", 0, "pinctrl-db8500", NULL),
+	OF_DEV_AUXDATA("stericsson,nmk_pinctrl", U8500_PRCMU_BASE,
+		"pinctrl-db8500", NULL),
 	/* Requires clock name and DMA bindings. */
 	OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80123000,
 		"ux500-msp-i2s.0", &msp0_platform_data),
-- 
1.7.12.1

