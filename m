Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932922Ab2GENIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:08:22 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52773 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932821Ab2GENGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:06:43 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 5/9] ARM: ux500: Remove temporary snowball_of_platform_devs enablement structure
Date: Thu,  5 Jul 2012 14:06:08 +0100
Message-Id: <1341493572-29735-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
References: <1341493572-29735-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All Device Tree enablement for Snowball's Platform  devices; LEDs, Keys,
Ethernet and all associated AB8500 Multi-Functional Devices are now
complete, so here we remove any trace of adding those devices when Device
Tree is enabled.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/mach-ux500/board-mop500.c |   17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 3b76115..c12cd97 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -745,10 +745,6 @@ MACHINE_END
 
 #ifdef CONFIG_MACH_UX500_DT
 
-static struct platform_device *snowball_of_platform_devs[] __initdata = {
-	&snowball_key_dev,
-};
-
 struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
 	/* Requires DMA and call-back bindings. */
 	OF_DEV_AUXDATA("arm,pl011", 0x80120000, "uart0", &uart0_plat),
@@ -802,8 +798,6 @@ static void __init u8500_init_machine(void)
 
 	for (i = 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
 		mop500_platform_devs[i]->dev.parent = parent;
-	for (i = 0; i < ARRAY_SIZE(snowball_platform_devs); i++)
-		snowball_platform_devs[i]->dev.parent = parent;
 
 	/* automatically probe child nodes of db8500 device */
 	of_platform_populate(NULL, u8500_local_bus_nodes, u8500_auxdata_lookup, parent);
@@ -822,17 +816,6 @@ static void __init u8500_init_machine(void)
 
 		mop500_uib_init();
 
-	} else if (of_machine_is_compatible("calaosystems,snowball-a9500")) {
-		/*
-		 * Devices to be DT:ed:
-		 *   snowball_led_dev   = done
-		 *   snowball_key_dev   = todo
-		 *   snowball_sbnet_dev = done
-		 *   ab8500_device      = done
-		 */
-		platform_add_devices(snowball_of_platform_devs,
-				ARRAY_SIZE(snowball_of_platform_devs));
-
 	} else if (of_machine_is_compatible("st-ericsson,hrefv60+")) {
 		/*
 		 * The HREFv60 board removed a GPIO expander and routed
-- 
1.7.9.5

