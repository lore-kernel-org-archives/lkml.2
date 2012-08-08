Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362Ab2HHOtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 10:49:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65208 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758321Ab2HHOrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 10:47:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 04/11] ARM: ux500: really kill snowball_of_platform_devs
Date: Wed,  8 Aug 2012 16:47:21 +0200
Message-Id: <1344437248-20560-5-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1344437248-20560-1-git-send-email-arnd@arndb.de>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:/35aJrBAerbmOJVHp2aioz0J14iTcLHw5wxZIPLeanu
 lYU+jM6Df25SNWpQZdCAJMQDM7QmJbGNAyjPrhJi23TmybmQQE
 IbaEdspVUU8iLh60dn5dvW4aOZWsio9Pa/XBZdrxnbBLYD9+9Z
 JX65HEgPCJSRvUgC5eHYzec37zSoaje/i0x+4IKiIBaOULT/TY
 TvlBY9TCs7AsdKKsx/hJZPu3aoWLEcH9qQ4uzK9bAkEnCIaCB6
 5D6cBCug7toZqSMDOe0sUyEakz4hotrdjc6cvPW0CG6Y+PqPtk
 U6xS8f1wfW1t4lMWIpKAIytSiTksxun77MlIkWYsUGf8OtZBLe
 Chga9St3wI93Xdit1iD4dFhSBAMTCgrVKa4Pn6BIy/z2LrTfHA
 qZu3Vc3W+usupqLlONKPRmWbKYKqvWMTeY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit fc67a597a "ARM: ux500: Remove temporary snowball_of_platform_devs
enablement structure" removed the only user of this variable, but did
not actually remove the array itself.

Without this patch, building u8500_defconfig results in:

arch/arm/mach-ux500/board-mop500.c:729:32: warning: 'snowball_of_platform_devs' defined but not used [-Wunused-variable]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 8674a89..2a732f7 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -726,11 +726,6 @@ MACHINE_END
 
 #ifdef CONFIG_MACH_UX500_DT
 
-static struct platform_device *snowball_of_platform_devs[] __initdata = {
-	&snowball_led_dev,
-	&snowball_key_dev,
-};
-
 struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	/* Requires DMA and call-back bindings. */
 	OF_DEV_AUXDATA("arm,pl011", 0x80120000, "uart0", &uart0_plat),
-- 
1.7.10

