Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab2FGSsU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 14:48:20 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:34968 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932802Ab2FGSrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 14:47:17 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: Greg Ungerer <gerg@uclinux.org>, Philippe De Muyter <phdm@macqel.be>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/5] m68k: Introduce config option CPU_HAS_NO_UNALIGNED
Date: Thu,  7 Jun 2012 20:47:06 +0200
Message-Id: <1339094827-12349-4-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1339094827-12349-1-git-send-email-geert@linux-m68k.org>
References: <1339094827-12349-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use CONFIG_CPU_HAS_NO_UNALIGNED instead of open coding CONFIG_M68000 ||
CONFIG_COLDFIRE

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/Kconfig.cpu             |    5 +++++
 arch/m68k/include/asm/unaligned.h |    4 ++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/Kconfig.cpu b/arch/m68k/Kconfig.cpu
index 6cd8c1a..c4ed650 100644
--- a/arch/m68k/Kconfig.cpu
+++ b/arch/m68k/Kconfig.cpu
@@ -27,6 +27,7 @@ config COLDFIRE
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select CPU_HAS_NO_BITFIELDS
 	select CPU_HAS_NO_MULDIV64
+	select CPU_HAS_NO_UNALIGNED
 	select GENERIC_CSUM
 
 endchoice
@@ -37,6 +38,7 @@ config M68000
 	bool
 	select CPU_HAS_NO_BITFIELDS
 	select CPU_HAS_NO_MULDIV64
+	select CPU_HAS_NO_UNALIGNED
 	select GENERIC_CSUM
 	help
 	  The Freescale (was Motorola) 68000 CPU is the first generation of
@@ -366,6 +368,9 @@ config CPU_HAS_NO_BITFIELDS
 config CPU_HAS_NO_MULDIV64
 	bool
 
+config CPU_HAS_NO_UNALIGNED
+	bool
+
 config CPU_HAS_ADDRESS_SPACES
 	bool
 
diff --git a/arch/m68k/include/asm/unaligned.h b/arch/m68k/include/asm/unaligned.h
index f4043ae..2b3ca0b 100644
--- a/arch/m68k/include/asm/unaligned.h
+++ b/arch/m68k/include/asm/unaligned.h
@@ -2,7 +2,7 @@
 #define _ASM_M68K_UNALIGNED_H
 
 
-#if defined(CONFIG_COLDFIRE) || defined(CONFIG_M68000)
+#ifdef CONFIG_CPU_HAS_NO_UNALIGNED
 #include <linux/unaligned/be_struct.h>
 #include <linux/unaligned/le_byteshift.h>
 #include <linux/unaligned/generic.h>
@@ -12,7 +12,7 @@
 
 #else
 /*
- * The m68k can do unaligned accesses itself. 
+ * The m68k can do unaligned accesses itself.
  */
 #include <linux/unaligned/access_ok.h>
 #include <linux/unaligned/generic.h>
-- 
1.7.0.4

