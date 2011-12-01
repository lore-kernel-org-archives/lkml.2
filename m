Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab1LALEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 06:04:54 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38690 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682Ab1LALEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 06:04:52 -0500
Message-ID: <1322737480.9622.5.camel@phoenix>
Subject: [RFC][PATCH] ARM: kirkwood: Remove eSATA SheevaPlug board support
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Lennert Buytenhek <kernel@wantstofly.org>,
        John Holland <john.holland@cellent-fs.de>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 01 Dec 2011 19:04:40 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit bb9b25f923 "ARM: Update mach-types" removes sheeva_esata entry
from mach-types, so current code in arch/arm/mach-kirkwood/sheevaplug-setup.c
always compile fail.

This patch removes sheeva_esata related code.

Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Lennert Buytenhek <kernel@wantstofly.org>
Cc: John Holland <john.holland@cellent-fs.de>
Cc: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Not really sure if we should remove all sheeva_esata related code or
just add it back to mach-types.
If nobody cares, maybe it is ok to remove it.

Note: 
I got the build error on linux-next tree (20111201).
So this patch is against linux-next tree.
Axel

 arch/arm/mach-kirkwood/Kconfig            |    6 ----
 arch/arm/mach-kirkwood/Makefile           |    1 -
 arch/arm/mach-kirkwood/sheevaplug-setup.c |   45 +---------------------------
 3 files changed, 2 insertions(+), 50 deletions(-)

diff --git a/arch/arm/mach-kirkwood/Kconfig b/arch/arm/mach-kirkwood/Kconfig
index 7fc603b..f5ba3aa 100644
--- a/arch/arm/mach-kirkwood/Kconfig
+++ b/arch/arm/mach-kirkwood/Kconfig
@@ -32,12 +32,6 @@ config MACH_SHEEVAPLUG
 	  Say 'Y' here if you want your kernel to support the
 	  Marvell SheevaPlug Reference Board.
 
-config MACH_ESATA_SHEEVAPLUG
-	bool "Marvell eSATA SheevaPlug Reference Board"
-	help
-	  Say 'Y' here if you want your kernel to support the
-	  Marvell eSATA SheevaPlug Reference Board.
-
 config MACH_GURUPLUG
 	bool "Marvell GuruPlug Reference Board"
 	help
diff --git a/arch/arm/mach-kirkwood/Makefile b/arch/arm/mach-kirkwood/Makefile
index 5dcaa81..1cd300c 100644
--- a/arch/arm/mach-kirkwood/Makefile
+++ b/arch/arm/mach-kirkwood/Makefile
@@ -5,7 +5,6 @@ obj-$(CONFIG_MACH_RD88F6192_NAS)	+= rd88f6192-nas-setup.o
 obj-$(CONFIG_MACH_RD88F6281)		+= rd88f6281-setup.o
 obj-$(CONFIG_MACH_MV88F6281GTW_GE)	+= mv88f6281gtw_ge-setup.o
 obj-$(CONFIG_MACH_SHEEVAPLUG)		+= sheevaplug-setup.o
-obj-$(CONFIG_MACH_ESATA_SHEEVAPLUG)	+= sheevaplug-setup.o
 obj-$(CONFIG_MACH_GURUPLUG)		+= guruplug-setup.o
 obj-$(CONFIG_MACH_DOCKSTAR)		+= dockstar-setup.o
 obj-$(CONFIG_MACH_TS219)		+= ts219-setup.o tsx1x-common.o
diff --git a/arch/arm/mach-kirkwood/sheevaplug-setup.c b/arch/arm/mach-kirkwood/sheevaplug-setup.c
index 85bff6b..346bb07 100644
--- a/arch/arm/mach-kirkwood/sheevaplug-setup.c
+++ b/arch/arm/mach-kirkwood/sheevaplug-setup.c
@@ -11,7 +11,6 @@
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/platform_device.h>
-#include <linux/ata_platform.h>
 #include <linux/mtd/partitions.h>
 #include <linux/mv643xx_eth.h>
 #include <linux/gpio.h>
@@ -43,19 +42,10 @@ static struct mv643xx_eth_platform_data sheevaplug_ge00_data = {
 	.phy_addr	= MV643XX_ETH_PHY_ADDR(0),
 };
 
-static struct mv_sata_platform_data sheeva_esata_sata_data = {
-	.n_ports	= 2,
-};
-
 static struct mvsdio_platform_data sheevaplug_mvsdio_data = {
 	/* unfortunately the CD signal has not been connected */
 };
 
-static struct mvsdio_platform_data sheeva_esata_mvsdio_data = {
-	.gpio_write_protect = 44, /* MPP44 used as SD write protect */
-	.gpio_card_detect = 47,	  /* MPP47 used as SD card detect */
-};
-
 static struct gpio_led sheevaplug_led_pins[] = {
 	{
 		.name			= "plug:red:misc",
@@ -91,14 +81,6 @@ static unsigned int sheevaplug_mpp_config[] __initdata = {
 	0
 };
 
-static unsigned int sheeva_esata_mpp_config[] __initdata = {
-	MPP29_GPIO,	/* USB Power Enable */
-	MPP44_GPIO,	/* SD Write Protect */
-	MPP47_GPIO,	/* SD Card Detect */
-	MPP49_GPIO,	/* LED Green */
-	0
-};
-
 static void __init sheevaplug_init(void)
 {
 	/*
@@ -107,10 +89,7 @@ static void __init sheevaplug_init(void)
 	kirkwood_init();
 
 	/* setup gpio pin select */
-	if (machine_is_sheeva_esata())
-		kirkwood_mpp_conf(sheeva_esata_mpp_config);
-	else
-		kirkwood_mpp_conf(sheevaplug_mpp_config);
+	kirkwood_mpp_conf(sheevaplug_mpp_config);
 
 	kirkwood_uart0_init();
 	kirkwood_nand_init(ARRAY_AND_SIZE(sheevaplug_nand_parts), 25);
@@ -122,15 +101,7 @@ static void __init sheevaplug_init(void)
 
 	kirkwood_ge00_init(&sheevaplug_ge00_data);
 
-	/* honor lower power consumption for plugs with out eSATA */
-	if (machine_is_sheeva_esata())
-		kirkwood_sata_init(&sheeva_esata_sata_data);
-
-	/* enable sd wp and sd cd on plugs with esata */
-	if (machine_is_sheeva_esata())
-		kirkwood_sdio_init(&sheeva_esata_mvsdio_data);
-	else
-		kirkwood_sdio_init(&sheevaplug_mvsdio_data);
+	kirkwood_sdio_init(&sheevaplug_mvsdio_data);
 
 	platform_device_register(&sheevaplug_leds);
 }
@@ -147,15 +118,3 @@ MACHINE_START(SHEEVAPLUG, "Marvell SheevaPlug Reference Board")
 	.restart	= kirkwood_restart,
 MACHINE_END
 #endif
-
-#ifdef CONFIG_MACH_ESATA_SHEEVAPLUG
-MACHINE_START(ESATA_SHEEVAPLUG, "Marvell eSATA SheevaPlug Reference Board")
-	.atag_offset	= 0x100,
-	.init_machine	= sheevaplug_init,
-	.map_io		= kirkwood_map_io,
-	.init_early	= kirkwood_init_early,
-	.init_irq	= kirkwood_init_irq,
-	.timer		= &kirkwood_timer,
-	.restart	= kirkwood_restart,
-MACHINE_END
-#endif
-- 
1.7.5.4



