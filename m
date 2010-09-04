Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075Ab0IDBSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 21:18:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59457 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400Ab0IDBR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 21:17:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ojy3Mrd2lV/U2XYIBQyA4NULOD1HIzG8DKiRkpgbRfG+RVsdvEuk5t9iuL1d0Xl8qR
         yZ6EF530ukFZ+fkP72LSRd2POPVnG+/KMhuRvEU2sM6i43kx5oQyg+xKBwK6zHMezFyi
         6Lbj7FsmjErAmEyZbX4cwfeKus7gdkt4Cm4aA=
From: Brian Gerst <brgerst@gmail.com>
To: hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, penberg@kernel.org
Subject: [PATCH 04/12] x86: Merge __save_init_fpu()
Date: Fri,  3 Sep 2010 21:17:11 -0400
Message-Id: <1283563039-3466-5-git-send-email-brgerst@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283563039-3466-1-git-send-email-brgerst@gmail.com>
References: <1283563039-3466-1-git-send-email-brgerst@gmail.com>
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

