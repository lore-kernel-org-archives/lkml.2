Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab1AASgk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jan 2011 13:36:40 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44338 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab1AASgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jan 2011 13:36:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=SAgWOWUp57iLIzh+/NsolLLAczRCm0+pNQn/+sRdkT7huC76FZl1gECuPc0tSJnRUt
         EFyZaMcZUC0U4HJNxRtBrroGaCPdcAgOpz5AySCWii3sv8oqTbeGihT8NR+IXkp1nTRQ
         TR7uka03UczdWBX8tb+fkwjHCz7UANujQOYtg=
Message-ID: <4D1F7434.4090108@gmail.com>
Date: Sat, 01 Jan 2011 19:36:36 +0100
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, lethal@linux-sh.org,
        linux-sh@vger.kernel.org
Subject: [PATCH] sh: correct definitions to access stack pointers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A definition like:

#define regs_return_value(regs)	((regs)->regs[0])

called with regs_return_value(foo) will be preprocessed to:

((foo)->foo[0])
        ^^^
So to fix this to ensure the preprocessor compiles such calls correctly.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/sh/include/asm/ptrace.h    |    4 ++--
 arch/sh/include/asm/ptrace_32.h |    2 +-
 arch/sh/include/asm/ptrace_64.h |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/sh/include/asm/ptrace.h b/arch/sh/include/asm/ptrace.h
index f6edc10..de167d3 100644
--- a/arch/sh/include/asm/ptrace.h
+++ b/arch/sh/include/asm/ptrace.h
@@ -40,8 +40,8 @@
 #include <asm/system.h>
 
 #define user_mode(regs)			(((regs)->sr & 0x40000000)==0)
-#define user_stack_pointer(regs)	((unsigned long)(regs)->regs[15])
-#define kernel_stack_pointer(regs)	((unsigned long)(regs)->regs[15])
+#define user_stack_pointer(_regs)	((unsigned long)(_regs)->regs[15])
+#define kernel_stack_pointer(_regs)	((unsigned long)(_regs)->regs[15])
 #define instruction_pointer(regs)	((unsigned long)(regs)->pc)
 
 extern void show_regs(struct pt_regs *);
diff --git a/arch/sh/include/asm/ptrace_32.h b/arch/sh/include/asm/ptrace_32.h
index 35d9e25..6c2239c 100644
--- a/arch/sh/include/asm/ptrace_32.h
+++ b/arch/sh/include/asm/ptrace_32.h
@@ -76,7 +76,7 @@ struct pt_dspregs {
 #ifdef __KERNEL__
 
 #define MAX_REG_OFFSET		offsetof(struct pt_regs, tra)
-#define regs_return_value(regs)	((regs)->regs[0])
+#define regs_return_value(_regs)	((_regs)->regs[0])
 
 #endif /* __KERNEL__ */
 
diff --git a/arch/sh/include/asm/ptrace_64.h b/arch/sh/include/asm/ptrace_64.h
index d43c1cb..bf9be77 100644
--- a/arch/sh/include/asm/ptrace_64.h
+++ b/arch/sh/include/asm/ptrace_64.h
@@ -13,7 +13,7 @@ struct pt_regs {
 #ifdef __KERNEL__
 
 #define MAX_REG_OFFSET		offsetof(struct pt_regs, tregs[7])
-#define regs_return_value(regs)	((regs)->regs[3])
+#define regs_return_value(_regs)	((_regs)->regs[3])
 
 #endif /* __KERNEL__ */
 
