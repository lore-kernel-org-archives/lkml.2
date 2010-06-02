Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab0FBJrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 05:47:48 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:17611 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab0FBJrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 05:47:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SFCvWIiQXuu9jZp8tGNbQPTJGV46RTAbuz3f7Vd3P7Yl1guK4NoxQXvIZ19q/CA26O
         dy/EOMQfQFjhUZoKxR7Nu7GfNR+Ck3MW0owokXEKYCDdbtaac4eXnF4CW1p/0P5qs9KZ
         Z046qRd9QEH8rwA+ChbZR/cmMQTTolMtflj9E=
From: Vitaly Mayatskikh <v.mayatskih@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Vivek Goyal <vgoyal@redhat.com>,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 1/5] x86: Introduce ELF_CORE_EXTRACT_REGS
Date: Wed,  2 Jun 2010 09:39:15 +0200
Message-Id: <1275464359-1566-2-git-send-email-v.mayatskih@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com>
References: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is macro ELF_CORE_COPY_REGS_COMMON, which packs registers into
elf_gregset_t. ELF_CORE_EXTRACT_REGS does contrary action: unpacks
elf_gregset_t.

Signed-off-by: Vitaly Mayatskikh <v.mayatskih@gmail.com>
---
 arch/x86/include/asm/elf.h |   46 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index f2ad216..5e3decb 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -144,6 +144,27 @@ do {						\
 	savesegment(gs, pr_reg[10]);		\
 } while (0);
 
+#define ELF_CORE_EXTRACT_REGS(pr_reg, regs)	\
+do {						\
+	(regs)->bx = (pr_reg)[0];		\
+	(regs)->cx = (pr_reg)[1];		\
+	(regs)->dx = (pr_reg)[2];		\
+	(regs)->si = (pr_reg)[3];		\
+	(regs)->di = (pr_reg)[4];		\
+	(regs)->bp = (pr_reg)[5];		\
+	(regs)->ax = (pr_reg)[6];		\
+	(regs)->ds = (pr_reg)[7];		\
+	(regs)->es = (pr_reg)[8];		\
+	(regs)->fs = (pr_reg)[9];		\
+	(regs)->gs = (pr_reg)[10];		\
+	(regs)->orig_ax = (pr_reg)[11];		\
+	(regs)->ip = (pr_reg)[12];		\
+	(regs)->cs = (pr_reg)[13];		\
+	(regs)->flags = (pr_reg)[14];		\
+	(regs)->sp = (pr_reg)[15];		\
+	(regs)->ss = (pr_reg)[16];		\
+} while (0);
+
 #define ELF_PLATFORM	(utsname()->machine)
 #define set_personality_64bit()	do { } while (0)
 
@@ -221,6 +242,31 @@ do {								\
 	asm("movl %%gs,%0" : "=r" (v)); (pr_reg)[26] = v;	\
 } while (0);
 
+#define ELF_CORE_EXTRACT_REGS(pr_reg, regs)			\
+do {								\
+	(regs)->r15 = (pr_reg)[0];			\
+	(regs)->r14 = (pr_reg)[1];				\
+	(regs)->r13 = (pr_reg)[2];				\
+	(regs)->r12 = (pr_reg)[3];				\
+	(regs)->bp  = (pr_reg)[4];				\
+	(regs)->bx  = (pr_reg)[5];				\
+	(regs)->r11 = (pr_reg)[6];				\
+	(regs)->r10 = (pr_reg)[7];				\
+	(regs)->r9  = (pr_reg)[8];				\
+	(regs)->r8  = (pr_reg)[9];				\
+	(regs)->ax  = (pr_reg)[10];				\
+	(regs)->cx  = (pr_reg)[11];				\
+	(regs)->dx  = (pr_reg)[12];				\
+	(regs)->si  = (pr_reg)[13];				\
+	(regs)->di  = (pr_reg)[14];				\
+	(regs)->orig_ax = (pr_reg)[15];				\
+	(regs)->ip  = (pr_reg)[16];				\
+	(regs)->cs  = (pr_reg)[17];				\
+	(regs)->flags = (pr_reg)[18];				\
+	(regs)->sp  = (pr_reg)[19];				\
+	(regs)->ss  = (pr_reg)[20];				\
+} while (0);
+
 /* I'm not sure if we can use '-' here */
 #define ELF_PLATFORM       ("x86_64")
 extern void set_personality_64bit(void);
-- 
1.7.1

