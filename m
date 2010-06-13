Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab0FMPEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 11:04:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab0FMPEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 11:04:08 -0400
From: Avi Kivity <avi@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] x86, fpu: merge __save_init_fpu() implementations
Date: Sun, 13 Jun 2010 18:03:44 +0300
Message-Id: <1276441427-31514-2-git-send-email-avi@redhat.com>
In-Reply-To: <1276441427-31514-1-git-send-email-avi@redhat.com>
References: <1276441427-31514-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two __save_init_fpu() implementations are identical, merge them.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/i387.h |   11 ++---------
 1 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
index 815c5b2..df5badf 100644
--- a/arch/x86/include/asm/i387.h
+++ b/arch/x86/include/asm/i387.h
@@ -184,12 +184,6 @@ static inline void fpu_save_init(struct fpu *fpu)
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
@@ -277,15 +271,14 @@ end:
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
1.7.1

