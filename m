Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384Ab2GTBFC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 21:05:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49427 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab2GTBE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 21:04:59 -0400
From: Joe Millenbach <jmillenbach@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org
Cc: team-fjord@googlegroups.com
Subject: [PATCH 1/7] x86/boot: Removed quiet flag and switched quiet output to debug flag
Date: Thu, 19 Jul 2012 18:04:36 -0700
Message-Id: <1342746282-28497-2-git-send-email-jmillenbach@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342746282-28497-1-git-send-email-jmillenbach@gmail.com>
References: <1342746282-28497-1-git-send-email-jmillenbach@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are only 3 uses of the quiet flag and they all protect output that
is only useful for debugging the stub, therefore we switched to using the
debug flag for all extra output.

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Signed-off-by: Gokul Caushik <caushik1@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/boot/compressed/misc.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 7116dcb..8f2355d 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -108,7 +108,6 @@ static void error(char *m);
  * This is set up by the setup-routine at boot-time
  */
 struct boot_params *real_mode;		/* Pointer to real-mode data */
-static int quiet;
 static int debug;
 
 void *memset(void *s, int c, size_t n);
@@ -294,7 +293,7 @@ static void parse_elf(void *output)
 		return;
 	}
 
-	if (!quiet)
+	if (debug)
 		putstr("Parsing ELF... ");
 
 	phdrs = malloc(sizeof(*phdrs) * ehdr.e_phnum);
@@ -332,8 +331,6 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 {
 	real_mode = rmode;
 
-	if (cmdline_find_option_bool("quiet"))
-		quiet = 1;
 	if (cmdline_find_option_bool("debug"))
 		debug = 1;
 
@@ -369,11 +366,11 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 		error("Wrong destination address");
 #endif
 
-	if (!quiet)
+	if (debug)
 		putstr("\nDecompressing Linux... ");
 	decompress(input_data, input_len, NULL, NULL, output, NULL, error);
 	parse_elf(output);
-	if (!quiet)
+	if (debug)
 		putstr("done.\nBooting the kernel.\n");
 	return;
 }
-- 
1.7.9.5

