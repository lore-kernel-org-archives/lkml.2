Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2L0XVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 18:21:17 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:58986 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab2L0XVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 18:21:12 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 3/4] arm: vt8500: Convert debug-macro.S to be multiplatform friendly
Date: Fri, 28 Dec 2012 12:20:51 +1300
Message-Id: <1356650452-16559-4-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356650452-16559-1-git-send-email-linux@prisktech.co.nz>
References: <1356650452-16559-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves debug-macro.S from arm/mach-vt8500/include/mach to
arm/include/debug/vt8500.S to provide multiplatform support.

Minor style changes in code for readability.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 arch/arm/Kconfig.debug                          |    8 ++++++
 arch/arm/mach-vt8500/include/mach/debug-macro.S |   31 -----------------------
 2 files changed, 8 insertions(+), 31 deletions(-)
 delete mode 100644 arch/arm/mach-vt8500/include/mach/debug-macro.S

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 661030d..bbb0a67 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -412,6 +412,13 @@ choice
 		  of the tiles using the RS1 memory map, including all new A-class
 		  core tiles, FPGA-based SMMs and software models.
 
+	config DEBUG_VT8500_UART0
+		bool "Use UART0 on VIA/Wondermedia SoCs"
+		depends on ARCH_VT8500
+		help
+		  This option selects UART0 on VIA/Wondermedia System-on-a-chip
+		  devices, including VT8500, WM8505, WM8650 and WM8850.
+
 	config DEBUG_LL_UART_NONE
 		bool "No low-level debugging UART"
 		depends on !ARCH_MULTIPLATFORM
@@ -506,6 +513,7 @@ config DEBUG_LL_INCLUDE
 	default "debug/sunxi.S" if DEBUG_SUNXI_UART0 || DEBUG_SUNXI_UART1
 	default "debug/vexpress.S" if DEBUG_VEXPRESS_UART0_DETECT || \
 		DEBUG_VEXPRESS_UART0_CA9 || DEBUG_VEXPRESS_UART0_RS1
+	default "debug/vt8500.S" if DEBUG_VT8500_UART0
 	default "debug/tegra.S" if DEBUG_TEGRA_UART
 	default "debug/zynq.S" if DEBUG_ZYNQ_UART0 || DEBUG_ZYNQ_UART1
 	default "mach/debug-macro.S"
diff --git a/arch/arm/mach-vt8500/include/mach/debug-macro.S b/arch/arm/mach-vt8500/include/mach/debug-macro.S
deleted file mode 100644
index ca292f2..0000000
--- a/arch/arm/mach-vt8500/include/mach/debug-macro.S
+++ /dev/null
@@ -1,31 +0,0 @@
-/*
- * arch/arm/mach-vt8500/include/mach/debug-macro.S
- *
- *  Copyright (C) 2010 Alexey Charkov <alchark@gmail.com>
- *
- * Debugging macro include header
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
-*/
-
-	.macro	addruart, rp, rv, tmp
-	mov	\rp,      #0x00200000
-	orr	\rv, \rp, #0xf8000000
-	orr	\rp, \rp, #0xd8000000
-	.endm
-
-	.macro	senduart,rd,rx
-	strb	\rd, [\rx, #0]
-	.endm
-
-	.macro	busyuart,rd,rx
-1001:	ldr	\rd, [\rx, #0x1c]
-	ands	\rd, \rd, #0x2
-	bne	1001b
-	.endm
-
-	.macro	waituart,rd,rx
-	.endm
-- 
1.7.9.5

