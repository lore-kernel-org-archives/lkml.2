Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab2DTV7J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:59:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34035 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058Ab2DTV7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:59:02 -0400
Date: Fri, 20 Apr 2012 14:58:51 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-5d6f8d77ede50417dcca4c31a74f0d40a1ee537a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
In-Reply-To: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
References: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, extable:
  Remove open-coded exception table entries in arch/x86/kernel/test_rodata.c
Git-Commit-ID: 5d6f8d77ede50417dcca4c31a74f0d40a1ee537a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Apr 2012 14:58:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5d6f8d77ede50417dcca4c31a74f0d40a1ee537a
Gitweb:     http://git.kernel.org/tip/5d6f8d77ede50417dcca4c31a74f0d40a1ee537a
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 20 Apr 2012 12:19:50 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Apr 2012 13:51:38 -0700

x86, extable: Remove open-coded exception table entries in arch/x86/kernel/test_rodata.c

Remove open-coded exception table entries in arch/x86/kernel/test_rodata.c,
and replace them with _ASM_EXTABLE() macros; this will allow us to
change the format and type of the exception table entries.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: David Daney <david.daney@cavium.com>
Link: http://lkml.kernel.org/r/CA%2B55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com
---
 arch/x86/kernel/test_rodata.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/test_rodata.c b/arch/x86/kernel/test_rodata.c
index c29e235..b79133a 100644
--- a/arch/x86/kernel/test_rodata.c
+++ b/arch/x86/kernel/test_rodata.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <asm/cacheflush.h>
 #include <asm/sections.h>
+#include <asm/asm.h>
 
 int rodata_test(void)
 {
@@ -42,14 +43,7 @@ int rodata_test(void)
 		".section .fixup,\"ax\"\n"
 		"2:	jmp 1b\n"
 		".previous\n"
-		".section __ex_table,\"a\"\n"
-		"       .align 16\n"
-#ifdef CONFIG_X86_32
-		"	.long 0b,2b\n"
-#else
-		"	.quad 0b,2b\n"
-#endif
-		".previous"
+		_ASM_EXTABLE(0b,2b)
 		: [rslt] "=r" (result)
 		: [rodata_test] "r" (&rodata_test_data), [zero] "r" (0UL)
 	);
