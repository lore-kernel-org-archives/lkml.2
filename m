Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab2GVAz4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2012 20:55:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44264 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab2GVAzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2012 20:55:55 -0400
Date: Sat, 21 Jul 2012 17:55:42 -0700
From: tip-bot for Joe Millenbach <jmillenbach@gmail.com>
Message-ID: <tip-cb454fe10400566214ec690318a0167ff7f5b8ca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        caushik1@gmail.com, jmillenbach@gmail.com, josh@joshtriplett.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jmillenbach@gmail.com, caushik1@gmail.com, tglx@linutronix.de,
        josh@joshtriplett.org
In-Reply-To: <1342746282-28497-4-git-send-email-jmillenbach@gmail.com>
References: <1342746282-28497-4-git-send-email-jmillenbach@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/boot] x86, boot:
  Changed error putstr path to match new debug_putstr format
Git-Commit-ID: cb454fe10400566214ec690318a0167ff7f5b8ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 21 Jul 2012 17:55:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb454fe10400566214ec690318a0167ff7f5b8ca
Gitweb:     http://git.kernel.org/tip/cb454fe10400566214ec690318a0167ff7f5b8ca
Author:     Joe Millenbach <jmillenbach@gmail.com>
AuthorDate: Thu, 19 Jul 2012 18:04:38 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sat, 21 Jul 2012 11:07:22 -0700

x86, boot: Changed error putstr path to match new debug_putstr format

For consistency we changed the error output path to match the new debug path.

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Link: http://lkml.kernel.org/r/1342746282-28497-4-git-send-email-jmillenbach@gmail.com
Signed-off-by: Gokul Caushik <caushik1@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
