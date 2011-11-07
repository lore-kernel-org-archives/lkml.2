Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544Ab1KGU1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 15:27:07 -0500
Received: from brigitte.telenet-ops.be ([195.130.137.66]:52119 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab1KGU1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 15:27:04 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Philip Blundell <philb@gnu.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k/hp300: Export hp300_ledstate
Date: Mon,  7 Nov 2011 21:27:00 +0100
Message-Id: <1320697620-16385-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The accidental loss of CONFIG_DIO in commit
0e152d80507b75c00aac60f2ffc586360687cd52 ("m68k: reorganize Kconfig options
to improve mmu/non-mmu selections") exposed a missing symbol export in
m68k allmodconfig.  If CONFIG_HP300=y but CONFIG_HPLANCE (which is bool,
and depends on CONFIG_DIO) is not set, and CONFIG_MVME147=y and
CONFIG_MVME147_NET=m, 7990.c is compiled as a module, giving:

ERROR: "ledstate" [drivers/net/ethernet/amd/7990.ko] undefined!

Add the missing export, and rename ledstate to hp300_ledstate while we're
at it, as it's a too generic name.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/hp300/config.c        |    3 ++-
 arch/m68k/include/asm/blinken.h |    8 ++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/m68k/hp300/config.c b/arch/m68k/hp300/config.c
index 1c05a62..bf16af1 100644
--- a/arch/m68k/hp300/config.c
+++ b/arch/m68k/hp300/config.c
@@ -24,7 +24,8 @@
 
 unsigned long hp300_model;
 unsigned long hp300_uart_scode = -1;
-unsigned char ledstate;
+unsigned char hp300_ledstate;
+EXPORT_SYMBOL(hp300_ledstate);
 
 static char s_hp330[] __initdata = "330";
 static char s_hp340[] __initdata = "340";
diff --git a/arch/m68k/include/asm/blinken.h b/arch/m68k/include/asm/blinken.h
index 1a749cf..0626582 100644
--- a/arch/m68k/include/asm/blinken.h
+++ b/arch/m68k/include/asm/blinken.h
@@ -17,15 +17,15 @@
 
 #define HP300_LEDS		0xf001ffff
 
-extern unsigned char ledstate;
+extern unsigned char hp300_ledstate;
 
 static __inline__ void blinken_leds(int on, int off)
 {
 	if (MACH_IS_HP300)
 	{
-		ledstate |= on;
-		ledstate &= ~off;
-		out_8(HP300_LEDS, ~ledstate);
+		hp300_ledstate |= on;
+		hp300_ledstate &= ~off;
+		out_8(HP300_LEDS, ~hp300_ledstate);
 	}
 }
 
-- 
1.7.0.4

