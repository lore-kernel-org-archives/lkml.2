Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab2L0XVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 18:21:18 -0500
Received: from server.prisktech.co.nz ([115.188.14.127]:56973 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab2L0XVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 18:21:12 -0500
From: Tony Prisk <linux@prisktech.co.nz>
To: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 2/4] arm: vt8500: Remove single platform Kconfig options
Date: Fri, 28 Dec 2012 12:20:50 +1300
Message-Id: <1356650452-16559-3-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1356650452-16559-1-git-send-email-linux@prisktech.co.nz>
References: <1356650452-16559-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch completes the move of arch-vt8500 to multiplatform only.

The remaining single-image Kconfig options are removed from
arch/arm/Kconfig and the options in arch/arm/mach-vt8500/Kconfig
are updated.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 arch/arm/Kconfig             |   21 ---------------------
 arch/arm/mach-vt8500/Kconfig |   13 +++----------
 2 files changed, 3 insertions(+), 31 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index fbb9492..76efd43 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -950,27 +950,6 @@ config ARCH_OMAP
 	help
 	  Support for TI's OMAP platform (OMAP1/2/3/4).
 
-config ARCH_VT8500_SINGLE
-	bool "VIA/WonderMedia 85xx"
-	select ARCH_VT8500
-	select COMMON_CLK
-	select CPU_ARM926T
-	select MULTI_IRQ_HANDLER
-	select SPARSE_IRQ
-	select USE_OF
-	help
-	  Support for VIA/WonderMedia VT8500/WM85xx System-on-Chip.
-
-config ARCH_WM8750_SINGLE
-	bool "WonderMedia WM8750/WM8850"
-	select ARCH_VT8500
-	select COMMON_CLK
-	select MULTI_IRQ_HANDLER
-	select SPARSE_IRQ
-	select USE_OF
-	help
-	  Support for WonderMedia WM8750/WM8850 System-on-Chip.
-
 endchoice
 
 menu "Multiple platform selection"
diff --git a/arch/arm/mach-vt8500/Kconfig b/arch/arm/mach-vt8500/Kconfig
index d67c7fa..f466b58 100644
--- a/arch/arm/mach-vt8500/Kconfig
+++ b/arch/arm/mach-vt8500/Kconfig
@@ -8,9 +8,8 @@ config ARCH_VT8500
 	select HAVE_CLK
 
 config ARCH_WM8505
-	bool "VIA/WonderMedia 85xx" if !ARCH_VT8500_SINGLE
+	bool "VIA/WonderMedia 85xx"
 	depends on ARCH_MULTI_V5
-	default ARCH_VT8500_SINGLE
 	select ARCH_VT8500
 	select CPU_ARM926T
 	help
@@ -18,7 +17,7 @@ config ARCH_WM8505
 
 config ARCH_WM8750
 	bool "WonderMedia WM8750"
-	depends on ARCH_MULTI_V6 || ARCH_WM8750_SINGLE
+	depends on ARCH_MULTI_V6
 	select ARCH_VT8500
 	select CPU_V6
 	help
@@ -26,14 +25,8 @@ config ARCH_WM8750
 
 config ARCH_WM8850
 	bool "WonderMedia WM8850"
-	depends on ARCH_MULTI_V7 || ARCH_WM8750_SINGLE
+	depends on ARCH_MULTI_V7
 	select ARCH_VT8500
 	select CPU_V7
 	help
 	  Support for WonderMedia WM8850 System-on-Chip.
-
-# ensure that ARCH_WM8850 is on if ARCH_WM8750 is off
-config ARCH_WM8850_AUTO
-      def_bool y
-      depends on ARCH_WM8750_SINGLE && !ARCH_WM8750
-      select ARCH_WM8850
-- 
1.7.9.5

