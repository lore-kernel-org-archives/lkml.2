Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab2GVA5l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 20:57:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44293 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab2GVA5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 20:57:39 -0400
Date: Sat, 21 Jul 2012 17:57:26 -0700
From: tip-bot for Joe Millenbach <jmillenbach@gmail.com>
Message-ID: <tip-641a1cebfe2f05fa1a48503d816fc70cf707d033@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        caushik1@gmail.com, jmillenbach@gmail.com, josh@joshtriplett.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jmillenbach@gmail.com, caushik1@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org
In-Reply-To: <1342746282-28497-6-git-send-email-jmillenbach@gmail.com>
References: <1342746282-28497-6-git-send-email-jmillenbach@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86, boot: Removed unused debug flag and set code
Git-Commit-ID: 641a1cebfe2f05fa1a48503d816fc70cf707d033
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 21 Jul 2012 17:57:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  641a1cebfe2f05fa1a48503d816fc70cf707d033
Gitweb:     http://git.kernel.org/tip/641a1cebfe2f05fa1a48503d816fc70cf707d033
Author:     Joe Millenbach <jmillenbach@gmail.com>
AuthorDate: Thu, 19 Jul 2012 18:04:40 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 21 Jul 2012 11:07:29 -0700

x86, boot: Removed unused debug flag and set code

As we're no longer using the flag we don't need to extract the value from the
command line and store it. This is a step towards removing command line
parameter code.

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Link: http://lkml.kernel.org/r/1342746282-28497-6-git-send-email-jmillenbach@gmail.com
Signed-off-by: Gokul Caushik <caushik1@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/boot/compressed/misc.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 8c29f82..88f7ff6 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -108,7 +108,6 @@ static void error(char *m);
  * This is set up by the setup-routine at boot-time
  */
 struct boot_params *real_mode;		/* Pointer to real-mode data */
-static int debug;
 
 void *memset(void *s, int c, size_t n);
 void *memcpy(void *dest, const void *src, size_t n);
@@ -326,9 +325,6 @@ asmlinkage void decompress_kernel(void *rmode, memptr heap,
 {
 	real_mode = rmode;
 
-	if (cmdline_find_option_bool("debug"))
-		debug = 1;
-
 	if (real_mode->screen_info.orig_video_mode == 7) {
 		vidmem = (char *) 0xb0000;
 		vidport = 0x3b4;
