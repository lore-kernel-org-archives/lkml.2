Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab1IIDNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 23:13:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54748 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab1IIDNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 23:13:33 -0400
Date: Fri, 9 Sep 2011 11:13:23 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: werner <w.landgraf@ru.ru>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.1-rc5 dont boot
Message-ID: <20110909031323.GE18249@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <web-603681984@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <web-603681984@zbackend1.aha.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 05:54:09PM -0400, werner wrote:
> Thank you.
> At the moment, kernel.org don't open here. And by google for "git
> cherry-pick b4ca46e4e82a" I dont find it somewhere else. Perhaps you
> could e-mail me the patch. Then I apply it, and recompile -rc1 and
> try to boot again with that.

Fortunately it residents on my local PC

---
commit b4ca46e4e82a0a5976fe5eab85be585d75f8202f
Author: Andy Lutomirski <luto@mit.edu>
Date:   Thu Aug 25 16:10:33 2011 -0400

    x86-32: Fix boot with CONFIG_X86_INVD_BUG
    
    entry_32.S contained a hardcoded alternative instruction entry, and the
    format changed in commit 59e97e4d6fbc ("x86: Make alternative
    instruction pointers relative").
    
    Replace the hardcoded entry with the altinstruction_entry macro.  This
    fixes the 32-bit boot with CONFIG_X86_INVD_BUG=y.
    
    Reported-and-tested-by: Arnaud Lacombe <lacombar@gmail.com>
    Signed-off-by: Andy Lutomirski <luto@mit.edu>
    Cc: Peter Anvin <hpa@zytor.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 5c1a9197..f3f6f53 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -54,6 +54,7 @@
 #include <asm/ftrace.h>
 #include <asm/irq_vectors.h>
 #include <asm/cpufeature.h>
+#include <asm/alternative-asm.h>
 
 /* Avoid __ASSEMBLER__'ifying <linux/audit.h> just for this.  */
 #include <linux/elf-em.h>
@@ -873,12 +874,7 @@ ENTRY(simd_coprocessor_error)
 661:	pushl_cfi $do_general_protection
 662:
 .section .altinstructions,"a"
-	.balign 4
-	.long 661b
-	.long 663f
-	.word X86_FEATURE_XMM
-	.byte 662b-661b
-	.byte 664f-663f
+	altinstruction_entry 661b, 663f, X86_FEATURE_XMM, 662b-661b, 664f-663f
 .previous
 .section .altinstr_replacement,"ax"
 663:	pushl $do_simd_coprocessor_error
