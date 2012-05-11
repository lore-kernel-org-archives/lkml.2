Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242Ab2EKTlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:41:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38427 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946136Ab2EKTlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:41:16 -0400
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: horms@verge.net.au, linux@arm.linux.org.uk, arnd@arndb.de,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        lethal@linux-sh.org, olof@lixom.net,
        Magnus Damm <magnus.damm@gmail.com>
Date: Sat, 12 May 2012 04:42:11 +0900
Message-Id: <20120511194211.6567.51663.sendpatchset@w520>
In-Reply-To: <20120511194151.6567.53888.sendpatchset@w520>
References: <20120511194151.6567.53888.sendpatchset@w520>
Subject: [PATCH 02/06] mach-shmobile: KZM9D board support V2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Magnus Damm <damm@opensource.se>

V2 of basic KZM9D board support. At this point a quite
thin layer that makes use of the Emma Mobile EV2 SoC code.

Signed-off-by: Magnus Damm <damm@opensource.se>
---

 Changes since V1:
 - removed now unnecessary ->map_io() callback
 - reworked includes to use new broken out header file
 - reworked to fit on top of linux-next

 arch/arm/mach-shmobile/Kconfig       |    4 +++
 arch/arm/mach-shmobile/Makefile      |    1 
 arch/arm/mach-shmobile/board-kzm9d.c |   36 ++++++++++++++++++++++++++++++++++
 3 files changed, 41 insertions(+)

--- 0007/arch/arm/mach-shmobile/Kconfig
+++ work/arch/arm/mach-shmobile/Kconfig	2012-05-12 02:45:51.000000000 +0900
@@ -115,6 +115,10 @@ config MACH_KZM9G
 	depends on ARCH_SH73A0
 	select ARCH_REQUIRE_GPIOLIB
 
+config MACH_KZM9D
+	bool "KZM9D board"
+	depends on ARCH_EMEV2
+
 comment "SH-Mobile System Configuration"
 
 config CPU_HAS_INTEVT
--- 0007/arch/arm/mach-shmobile/Makefile
+++ work/arch/arm/mach-shmobile/Makefile	2012-05-12 02:45:51.000000000 +0900
@@ -52,6 +52,7 @@ obj-$(CONFIG_MACH_BONITO)	+= board-bonit
 obj-$(CONFIG_MACH_MARZEN)	+= board-marzen.o
 obj-$(CONFIG_MACH_ARMADILLO800EVA)	+= board-armadillo800eva.o
 obj-$(CONFIG_MACH_KZM9G)	+= board-kzm9g.o
+obj-$(CONFIG_MACH_KZM9D)	+= board-kzm9d.o
 
 # Framework support
 obj-$(CONFIG_SMP)		+= $(smp-y)
--- /dev/null
+++ work/arch/arm/mach-shmobile/board-kzm9d.c	2012-05-12 02:45:52.000000000 +0900
@@ -0,0 +1,36 @@
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
+#include <linux/interrupt.h>
+#include <mach/common.h>
+#include <mach/emev2.h>
+#include <asm/mach-types.h>
+#include <asm/mach/arch.h>
+#include <asm/hardware/gic.h>
+
+MACHINE_START(KZM9D, "kzm9d")
+	.init_early	= emev2_add_early_devices,
+	.nr_irqs	= NR_IRQS_LEGACY,
+	.init_irq	= emev2_init_irq,
+	.handle_irq	= gic_handle_irq,
+	.init_machine	= emev2_add_standard_devices,
+	.timer		= &shmobile_timer,
+MACHINE_END
