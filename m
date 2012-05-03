Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099Ab2ECOqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 10:46:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36809 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209Ab2ECOqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 10:46:15 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: horms@verge.net.au, linux@arm.linux.org.uk, arnd@arndb.de,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        lethal@linux-sh.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Date: Thu, 03 May 2012 23:47:03 +0900
Message-Id: <20120503144703.6390.20689.sendpatchset@w520>
In-Reply-To: <20120503144645.6390.62303.sendpatchset@w520>
References: <20120503144645.6390.62303.sendpatchset@w520>
Subject: [PATCH 02/02] mach-shmobile: KZM9D board prototype support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

Add experimental KZM9D board support that makes
use of the Emma Mobile EV2 SoC code.

Nothing except serial ports and timer are supported
at this point. On-board ethernet support can be
added after proper GPIO bindings are implemented.
Without GPIO we cannot make use of external IRQs.

Not-yet-signed-off-by: Magnus Damm <damm@opensource.se>
---

 arch/arm/mach-shmobile/Kconfig       |    4 +++
 arch/arm/mach-shmobile/Makefile      |    1 
 arch/arm/mach-shmobile/board-kzm9d.c |   44 ++++++++++++++++++++++++++++++++++
 3 files changed, 49 insertions(+)

--- 0011/arch/arm/mach-shmobile/Kconfig
+++ work/arch/arm/mach-shmobile/Kconfig	2012-05-03 20:50:52.000000000 +0900
@@ -103,6 +103,10 @@ config MACH_MARZEN
 	depends on ARCH_R8A7779
 	select ARCH_REQUIRE_GPIOLIB
 
+config MACH_KZM9D
+	bool "KZM9D board"
+	depends on ARCH_EMEV2
+
 comment "SH-Mobile System Configuration"
 
 config CPU_HAS_INTEVT
--- 0011/arch/arm/mach-shmobile/Makefile
+++ work/arch/arm/mach-shmobile/Makefile	2012-05-03 20:50:52.000000000 +0900
@@ -50,6 +50,7 @@ obj-$(CONFIG_MACH_MACKEREL)	+= board-mac
 obj-$(CONFIG_MACH_KOTA2)	+= board-kota2.o
 obj-$(CONFIG_MACH_BONITO)	+= board-bonito.o
 obj-$(CONFIG_MACH_MARZEN)	+= board-marzen.o
+obj-$(CONFIG_MACH_KZM9D)	+= board-kzm9d.o
 
 # Framework support
 obj-$(CONFIG_SMP)		+= $(smp-y)
--- /dev/null
+++ work/arch/arm/mach-shmobile/board-kzm9d.c	2012-05-03 20:51:20.000000000 +0900
@@ -0,0 +1,44 @@
+/*
+ * kzm9d board support
+ *
+ * Copyright (C) 2012  Renesas Solutions Corp.
+ * Copyright (C) 2012  Magnus Damm
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <mach/hardware.h>
+#include <mach/common.h>
+#include <mach/irqs.h>
+#include <asm/mach-types.h>
+#include <asm/mach/map.h>
+#include <asm/mach/arch.h>
+#include <asm/mach/time.h>
+#include <asm/hardware/gic.h>
+#include <asm/traps.h>
+
+MACHINE_START(KZM9D, "kzm9d")
+	.map_io		= emev2_map_io,
+	.init_early	= emev2_add_early_devices,
+	.nr_irqs	= NR_IRQS_LEGACY,
+	.init_irq	= emev2_init_irq,
+	.handle_irq	= gic_handle_irq,
+	.init_machine	= emev2_add_standard_devices,
+	.timer		= &shmobile_timer,
+MACHINE_END
