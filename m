Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab0H1QGK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 12:06:10 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60829 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882Ab0H1QGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 12:06:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=vYE4+nE03SWY3epJZeSda0C3Zw6D/CFh17DSJzhuNKVXgvz6uciapY9VixApHx7M03
         b9+83wP8JE426VUReT/sXe39S/ySBzl+Jnz1x352OxnhRuTg1+n3Sd6sERqgNrpzDwl3
         5l+zvKXXPpyULVRxheM61VX6oWB9qKdCpnZ1E=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 04/11] x86: Merge __save_init_fpu()
Date: Sat, 28 Aug 2010 12:04:31 -0400
Message-Id: <1283011478-27237-5-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
References: <1283011478-27237-1-git-send-email-brgerst@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__save_init_fpu() is identical for 32-bit and 64-bit.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
---
 arch/x86/include/asm/i387.h |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 5d8f9a7..88065e3 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -197,12 +197,6 @@ static inline void fpu_save_init(struct fpu *fpu)
 	fpu_clear(fpu);
 }
 
-static inline void __save_init_fpu(struct task_struct *tsk)
-{
-	fpu_save_init(&tsk->thread.fpu);
-	task_thread_info(tsk)->status &= ~TS_USEDFPU;
-}
-
 #else  /* CONFIG_X86_32 */
 
 #ifdef CONFIG_MATH_EMULATION
@@ -285,15 +279,14 @@ end:
 	;
 }
 
+#endif	/* CONFIG_X86_64 */
+
 static inline void __save_init_fpu(struct task_struct *tsk)
 {
 	fpu_save_init(&tsk->thread.fpu);
 	task_thread_info(tsk)->status &= ~TS_USEDFPU;
 }
 
-
-#endif	/* CONFIG_X86_64 */
-
 static inline int fpu_fxrstor_checking(struct fpu *fpu)
 {
 	return fxrstor_checking(&fpu->state->fxsave);
-- 
1.7.2.2

