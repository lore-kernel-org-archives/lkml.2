Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab2DTWJJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:09:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34214 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab2DTWJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:09:03 -0400
Date: Fri, 20 Apr 2012 15:08:51 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-7a040a4384c7c4973deb4d58a76e1b0ee3c8aa39@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        suresh.b.siddha@intel.com, david.daney@cavium.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, suresh.b.siddha@intel.com, tglx@linutronix.de
In-Reply-To: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
References: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, extable:
  Remove open-coded exception table entries in arch/x86/include/asm/xsave.h
Git-Commit-ID: 7a040a4384c7c4973deb4d58a76e1b0ee3c8aa39
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Apr 2012 15:08:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7a040a4384c7c4973deb4d58a76e1b0ee3c8aa39
Gitweb:     http://git.kernel.org/tip/7a040a4384c7c4973deb4d58a76e1b0ee3c8aa39
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 20 Apr 2012 13:42:25 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Apr 2012 13:51:40 -0700

x86, extable: Remove open-coded exception table entries in arch/x86/include/asm/xsave.h

Remove open-coded exception table entries in arch/x86/include/asm/xsave.h,
and replace them with _ASM_EXTABLE() macros; this will allow us to
change the format and type of the exception table entries.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: David Daney <david.daney@cavium.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/CA%2B55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com
---
 arch/x86/include/asm/xsave.h |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/xsave.h b/arch/x86/include/asm/xsave.h
index c6ce245..8a1b6f9 100644
--- a/arch/x86/include/asm/xsave.h
+++ b/arch/x86/include/asm/xsave.h
@@ -80,10 +80,7 @@ static inline int xsave_user(struct xsave_struct __user *buf)
 			     "3:  movl $-1,%[err]\n"
 			     "    jmp  2b\n"
 			     ".previous\n"
-			     ".section __ex_table,\"a\"\n"
-			     _ASM_ALIGN "\n"
-			     _ASM_PTR "1b,3b\n"
-			     ".previous"
+			     _ASM_EXTABLE(1b,3b)
 			     : [err] "=r" (err)
 			     : "D" (buf), "a" (-1), "d" (-1), "0" (0)
 			     : "memory");
@@ -106,10 +103,7 @@ static inline int xrestore_user(struct xsave_struct __user *buf, u64 mask)
 			     "3:  movl $-1,%[err]\n"
 			     "    jmp  2b\n"
 			     ".previous\n"
-			     ".section __ex_table,\"a\"\n"
-			     _ASM_ALIGN "\n"
-			     _ASM_PTR "1b,3b\n"
-			     ".previous"
+			     _ASM_EXTABLE(1b,3b)
 			     : [err] "=r" (err)
 			     : "D" (xstate), "a" (lmask), "d" (hmask), "0" (0)
 			     : "memory");	/* memory required? */
