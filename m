Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab2GTBFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 21:05:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49427 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab2GTBFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 21:05:06 -0400
From: Joe Millenbach <jmillenbach@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>, Jesper Juhl <jj@chaosbits.net>,
        linux-kernel@vger.kernel.org
Cc: team-fjord@googlegroups.com
Subject: [PATCH 3/7] x86/boot: Changed error putstr path to match new debug_putstr format
Date: Thu, 19 Jul 2012 18:04:38 -0700
Message-Id: <1342746282-28497-4-git-send-email-jmillenbach@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342746282-28497-1-git-send-email-jmillenbach@gmail.com>
References: <1342746282-28497-1-git-send-email-jmillenbach@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For consistency we changed the error output path to match the new debug path.

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Signed-off-by: Gokul Caushik <caushik1@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 arch/x86/boot/compressed/misc.c |    6 +++---
 arch/x86/boot/compressed/misc.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 49c6d56..de1d54d 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -270,9 +270,9 @@ void *memcpy(void *dest, const void *src, size_t n)
 
 static void error(char *x)
 {
-	__putstr(1, "\n\n");
-	__putstr(1, x);
-	__putstr(1, "\n\n -- System halted");
+	error_putstr("\n\n");
+	error_putstr(x);
+	error_putstr("\n\n -- System halted");
 
 	while (1)
 		asm("hlt");
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 3f19c81..4c1bfb6 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -26,6 +26,7 @@
 extern struct boot_params *real_mode;		/* Pointer to real-mode data */
 void __putstr(int error, const char *s);
 #define putstr(__x)  __putstr(0, __x)
+#define error_putstr(__x)  __putstr(1, __x)
 #define puts(__x)  __putstr(0, __x)
 
 /* cmdline.c */
-- 
1.7.9.5

