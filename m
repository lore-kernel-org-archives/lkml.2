Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab2GVAzR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 20:55:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44252 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab2GVAzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 20:55:05 -0400
Date: Sat, 21 Jul 2012 17:54:50 -0700
From: tip-bot for Joe Millenbach <jmillenbach@gmail.com>
Message-ID: <tip-e605a425975b073aafebbb2c09d3ae266be2fd3e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        caushik1@gmail.com, jmillenbach@gmail.com, josh@joshtriplett.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jmillenbach@gmail.com, caushik1@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org
In-Reply-To: <1342746282-28497-3-git-send-email-jmillenbach@gmail.com>
References: <1342746282-28497-3-git-send-email-jmillenbach@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86, boot:
  Wrap debug printing in a new debug_putstr function
Git-Commit-ID: e605a425975b073aafebbb2c09d3ae266be2fd3e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 21 Jul 2012 17:54:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e605a425975b073aafebbb2c09d3ae266be2fd3e
Gitweb:     http://git.kernel.org/tip/e605a425975b073aafebbb2c09d3ae266be2fd3e
Author:     Joe Millenbach <jmillenbach@gmail.com>
AuthorDate: Thu, 19 Jul 2012 18:04:37 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 21 Jul 2012 11:07:18 -0700

x86, boot: Wrap debug printing in a new debug_putstr function

Change all instances of if (debug) putstr(...) to a new debug_putstr(...).
This allows a future change to conditionally stub out debug_putstr to save
space.

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Link: http://lkml.kernel.org/r/1342746282-28497-3-git-send-email-jmillenbach@gmail.com
Signed-off-by: Gokul Caushik <caushik1@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/misc.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 8f2355d..49c6d56 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -223,6 +223,12 @@ void __putstr(int error, const char *s)
 	outb(0xff & (pos >> 1), vidport+1);
 }
 
+static void debug_putstr(const char *s)
+{
+	if (debug)
+		putstr(s);
+}
+
 void *memset(void *s, int c, size_t n)
 {
 	int i;
@@ -293,8 +299,7 @@ static void parse_elf(void *output)
 		return;
 	}
 
-	if (debug)
-		putstr("Parsing ELF... ");
+	debug_putstr("Parsing ELF... ");
 
 	phdrs = malloc(sizeof(*phdrs) * ehdr.e_phnum);
 	if (!phdrs)
@@ -346,8 +351,7 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 	cols = real_mode->screen_info.orig_video_cols;
 
 	console_init();
-	if (debug)
-		putstr("early console in decompress_kernel\n");
+	debug_putstr("early console in decompress_kernel\n");
 
 	free_mem_ptr     = heap;	/* Heap */
 	free_mem_end_ptr = heap + BOOT_HEAP_SIZE;
@@ -366,11 +370,9 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 		error("Wrong destination address");
 #endif
 
-	if (debug)
-		putstr("\nDecompressing Linux... ");
+	debug_putstr("\nDecompressing Linux... ");
 	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
 	parse_elf(output);
-	if (debug)
-		putstr("done.\nBooting the kernel.\n");
+	debug_putstr("done.\nBooting the kernel.\n");
 	return;
 }
