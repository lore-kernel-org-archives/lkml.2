Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab2GVAyS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 20:54:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44230 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab2GVAyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 20:54:16 -0400
Date: Sat, 21 Jul 2012 17:53:57 -0700
From: tip-bot for Joe Millenbach <jmillenbach@gmail.com>
Message-ID: <tip-9f4e4392cbf72d731a489a3217fe810820b8ba96@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        caushik1@gmail.com, jmillenbach@gmail.com, josh@joshtriplett.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jmillenbach@gmail.com, caushik1@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org
In-Reply-To: <1342746282-28497-2-git-send-email-jmillenbach@gmail.com>
References: <1342746282-28497-2-git-send-email-jmillenbach@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86, boot:
  Removed quiet flag and switched quiet output to debug flag
Git-Commit-ID: 9f4e4392cbf72d731a489a3217fe810820b8ba96
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 21 Jul 2012 17:54:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f4e4392cbf72d731a489a3217fe810820b8ba96
Gitweb:     http://git.kernel.org/tip/9f4e4392cbf72d731a489a3217fe810820b8ba96
Author:     Joe Millenbach <jmillenbach@gmail.com>
AuthorDate: Thu, 19 Jul 2012 18:04:36 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 21 Jul 2012 11:07:15 -0700

x86, boot: Removed quiet flag and switched quiet output to debug flag

There are only 3 uses of the quiet flag and they all protect output that
is only useful for debugging the stub, therefore we switched to using the
debug flag for all extra output.

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Link: http://lkml.kernel.org/r/1342746282-28497-2-git-send-email-jmillenbach@gmail.com
Signed-off-by: Gokul Caushik <caushik1@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/misc.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

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
