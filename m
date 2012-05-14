Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab2ENKxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 06:53:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54745 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab2ENKxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 06:53:43 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: horms@verge.net.au, linux@arm.linux.org.uk, arnd@arndb.de,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        lethal@linux-sh.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Date: Mon, 14 May 2012 19:54:41 +0900
Message-Id: <20120514105441.8596.31776.sendpatchset@w520>
In-Reply-To: <20120514105424.8596.38355.sendpatchset@w520>
References: <20120514105424.8596.38355.sendpatchset@w520>
Subject: [PATCH 02/03] mach-shmobile: Use DT_MACHINE for armadillo 800 eva
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Use DT_MACHINE_START() on the r8a7740 based armadillo 800 eva board.

Also include a tiny DTS file to describe the board and update the
Kconfig dependencies to select CONFIG_USE_OF.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/boot/dts/r8a7740-armadillo800eva.dts  |   22 ++++++++++++++++++++++
 arch/arm/mach-shmobile/Kconfig                 |    1 +
 arch/arm/mach-shmobile/board-armadillo800eva.c |    8 +++++++-
 3 files changed, 30 insertions(+), 1 deletion(-)

--- /dev/null
+++ work/arch/arm/boot/dts/r8a7740-armadillo800eva.dts	2012-05-14 19:31:57.000000000 +0900
@@ -0,0 +1,22 @@
+/*
+ * Device Tree Source for the armadillo 800 eva board
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
+	model = "armadillo 800 eva";
+	compatible = "renesas,armadillo800eva";
+
+	memory {
+		device_type = "memory";
+		reg = <0x40000000 0x20000000>;
+	};
+};
--- 0002/arch/arm/mach-shmobile/Kconfig
+++ work/arch/arm/mach-shmobile/Kconfig	2012-05-14 19:32:21.000000000 +0900
@@ -99,6 +99,7 @@ config MACH_ARMADILLO800EVA
 	bool "Armadillo-800 EVA board"
 	depends on ARCH_R8A7740
 	select ARCH_REQUIRE_GPIOLIB
+	select USE_OF
 
 config MACH_MARZEN
 	bool "MARZEN board"
--- 0001/arch/arm/mach-shmobile/board-armadillo800eva.c
+++ work/arch/arm/mach-shmobile/board-armadillo800eva.c	2012-05-14 19:35:27.000000000 +0900
@@ -768,11 +768,17 @@ static void __init eva_add_early_devices
 	shmobile_timer.init = eva_earlytimer_init;
 }
 
-MACHINE_START(ARMADILLO800EVA, "armadillo800eva")
+static const char *eva_boards_compat_dt[] __initdata = {
+	"renesas,armadillo800eva",
+	NULL,
+};
+
+DT_MACHINE_START(ARMADILLO800EVA_DT, "armadillo800eva")
 	.map_io		= r8a7740_map_io,
 	.init_early	= eva_add_early_devices,
 	.init_irq	= r8a7740_init_irq,
 	.handle_irq	= shmobile_handle_irq_intc,
 	.init_machine	= eva_init,
 	.timer		= &shmobile_timer,
+	.dt_compat	= eva_boards_compat_dt,
 MACHINE_END
