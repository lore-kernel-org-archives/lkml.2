Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab2DTVzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 17:55:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33984 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab2DTVzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 17:55:52 -0400
Date: Fri, 20 Apr 2012 14:55:31 -0700
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Message-ID: <tip-d4541805e812abb5110d5de83246488fa0aa9a8e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.daney@cavium.com, tglx@linutronix.de
In-Reply-To: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
References: <CA+55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/extable] x86, extable: Use .pushsection ... .
 popsection for _ASM_EXTABLE()
Git-Commit-ID: d4541805e812abb5110d5de83246488fa0aa9a8e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 20 Apr 2012 14:55:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d4541805e812abb5110d5de83246488fa0aa9a8e
Gitweb:     http://git.kernel.org/tip/d4541805e812abb5110d5de83246488fa0aa9a8e
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 20 Apr 2012 12:12:27 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 20 Apr 2012 13:51:38 -0700

x86, extable: Use .pushsection ... .popsection for _ASM_EXTABLE()

Instead of using .section ... .previous, use .pushsection
... .popsection; this is (hopefully) a bit more robust, especially in
complex assembly code.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: David Daney <david.daney@cavium.com>
Link: http://lkml.kernel.org/r/CA%2B55aFyijf43qSu3N9nWHEBwaGbb7T2Oq9A=9EyR=Jtyqfq_cQ@mail.gmail.com
---
 arch/x86/include/asm/asm.h |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 9412d65..ff3f6bf 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -42,17 +42,17 @@
 
 /* Exception table entry */
 #ifdef __ASSEMBLY__
-# define _ASM_EXTABLE(from,to)	    \
-	__ASM_EX_SEC ;		    \
-	_ASM_ALIGN ;		    \
-	_ASM_PTR from , to ;	    \
-	.previous
+# define _ASM_EXTABLE(from,to)			\
+	.pushsection "__ex_table","a" ;		\
+	_ASM_ALIGN ;				\
+	_ASM_PTR from , to ;			\
+	.popsection
 #else
-# define _ASM_EXTABLE(from,to) \
-	__ASM_EX_SEC	\
-	_ASM_ALIGN "\n" \
-	_ASM_PTR #from "," #to "\n" \
-	" .previous\n"
+# define _ASM_EXTABLE(from,to)			\
+	" .pushsection \"__ex_table\",\"a\"\n"	\
+	_ASM_ALIGN "\n" 			\
+	_ASM_PTR #from "," #to "\n" 		\
+	" .popsection\n"
 #endif
 
 #endif /* _ASM_X86_ASM_H */
