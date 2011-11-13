Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab1KMKY1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 05:24:27 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:56961 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab1KMKYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 05:24:25 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k/atari: Move declaration of atari_SCC_reset_done to header file
Date: Sun, 13 Nov 2011 11:24:19 +0100
Message-Id: <1321179859-22385-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/atari/ataints.c       |    2 --
 arch/m68k/atari/debug.c         |    1 -
 arch/m68k/include/asm/atarihw.h |    2 ++
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/atari/ataints.c b/arch/m68k/atari/ataints.c
index 6d196da..8048e1b 100644
--- a/arch/m68k/atari/ataints.c
+++ b/arch/m68k/atari/ataints.c
@@ -82,8 +82,6 @@ __ALIGN_STR "\n\t"
 
 extern void atari_microwire_cmd(int cmd);
 
-extern int atari_SCC_reset_done;
-
 static unsigned int atari_irq_startup(struct irq_data *data)
 {
 	unsigned int irq = data->irq;
diff --git a/arch/m68k/atari/debug.c b/arch/m68k/atari/debug.c
index 5a48424..a547ba9 100644
--- a/arch/m68k/atari/debug.c
+++ b/arch/m68k/atari/debug.c
@@ -202,7 +202,6 @@ static void __init atari_init_mfp_port(int cflag)
 
 static void __init atari_init_scc_port(int cflag)
 {
-	extern int atari_SCC_reset_done;
 	static int clksrc_table[9] =
 		/* reg 11: 0x50 = BRG, 0x00 = RTxC, 0x28 = TRxC */
 		{ 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x50, 0x00, 0x00 };
diff --git a/arch/m68k/include/asm/atarihw.h b/arch/m68k/include/asm/atarihw.h
index 0392b28..c0cb363 100644
--- a/arch/m68k/include/asm/atarihw.h
+++ b/arch/m68k/include/asm/atarihw.h
@@ -30,6 +30,8 @@ extern u_long atari_switches;
 extern int atari_rtc_year_offset;
 extern int atari_dont_touch_floppy_select;
 
+extern int atari_SCC_reset_done;
+
 /* convenience macros for testing machine type */
 #define MACH_IS_ST	((atari_mch_cookie >> 16) == ATARI_MCH_ST)
 #define MACH_IS_STE	((atari_mch_cookie >> 16) == ATARI_MCH_STE && \
-- 
1.7.0.4

