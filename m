Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab2ENKxj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:53:39 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55599 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab2ENKxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:53:34 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, arnd@arndb.de, linux-sh@vger.kernel.org,
        lethal@linux-sh.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        horms@verge.net.au, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Date: Mon, 14 May 2012 19:54:33 +0900
Message-Id: <20120514105433.8596.1974.sendpatchset@w520>
In-Reply-To: <20120514105424.8596.38355.sendpatchset@w520>
References: <20120514105424.8596.38355.sendpatchset@w520>
Subject: [PATCH 01/03] mach-shmobile: Use DT_MACHINE for KZM9G
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Use DT_MACHINE_START() on the sh73a0 based KZM9G board.

Also include a tiny DTS file to describe the board and
update the Kconfig dependencies to select CONFIG_USE_OF.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/boot/dts/sh73a0-kzm9g.dts   |   22 ++++++++++++++++++++++
 arch/arm/mach-shmobile/Kconfig       |    1 +
 arch/arm/mach-shmobile/board-kzm9g.c |    8 +++++++-
 3 files changed, 30 insertions(+), 1 deletion(-)

--- /dev/null
+++ work/arch/arm/boot/dts/sh73a0-kzm9g.dts	2012-05-14 18:37:52.000000000 +0900
@@ -0,0 +1,22 @@
+/*
+ * Device Tree Source for the KZM-A9-GT board
+ *
+ * Copyright (C) 2012 Renesas Solutions Corp.
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2.  This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+/dts-v1/;
+/include/ "skeleton.dtsi"
+
+/ {
+	model = "KZM-A9-GT";
+	compatible = "renesas,kzm9g";
+
+	memory {
+		device_type = "memory";
+		reg = <0x41000000 0x1e800000>;
+	};
+};
--- 0001/arch/arm/mach-shmobile/Kconfig
+++ work/arch/arm/mach-shmobile/Kconfig	2012-05-14 18:54:57.000000000 +0900
@@ -109,6 +109,7 @@ config MACH_KZM9G
 	bool "KZM-A9-GT board"
 	depends on ARCH_SH73A0
 	select ARCH_REQUIRE_GPIOLIB
+	select USE_OF
 
 comment "SH-Mobile System Configuration"
 
--- 0001/arch/arm/mach-shmobile/board-kzm9g.c
+++ work/arch/arm/mach-shmobile/board-kzm9g.c	2012-05-14 18:33:43.000000000 +0900
@@ -443,7 +443,12 @@ static void __init kzm_init(void)
 	platform_add_devices(kzm_devices, ARRAY_SIZE(kzm_devices));
 }
 
-MACHINE_START(KZM9G, "kzm9g")
+static const char *kzm9g_boards_compat_dt[] __initdata = {
+	"renesas,kzm9g",
+	NULL,
+};
+
+DT_MACHINE_START(KZM9G_DT, "kzm9g")
 	.map_io		= sh73a0_map_io,
 	.init_early	= sh73a0_add_early_devices,
 	.nr_irqs	= NR_IRQS_LEGACY,
@@ -451,4 +456,5 @@ MACHINE_START(KZM9G, "kzm9g")
 	.handle_irq	= gic_handle_irq,
 	.init_machine	= kzm_init,
 	.timer		= &shmobile_timer,
+	.dt_compat	= kzm9g_boards_compat_dt,
 MACHINE_END
