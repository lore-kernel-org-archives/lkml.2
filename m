Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757594Ab0IJBsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 21:48:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:40179 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757351Ab0IJBs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 21:48:28 -0400
Date: Fri, 10 Sep 2010 01:47:12 GMT
From: tip-bot for Brian Gerst <brgerst@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        brgerst@gmail.com, penberg@kernel.org, suresh.b.siddha@intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1283563039-3466-5-git-send-email-brgerst@gmail.com>
References: <1283563039-3466-5-git-send-email-brgerst@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] x86, fpu: Merge __save_init_fpu()
Message-ID: <tip-bfd946cb891800d408decaae268a3480775178a3@git.kernel.org>
Git-Commit-ID: bfd946cb891800d408decaae268a3480775178a3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 01:47:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bfd946cb891800d408decaae268a3480775178a3
Gitweb:     http://git.kernel.org/tip/bfd946cb891800d408decaae268a3480775178a3
Author:     Brian Gerst <brgerst@gmail.com>
AuthorDate: Fri, 3 Sep 2010 21:17:11 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 9 Sep 2010 14:16:30 -0700

x86, fpu: Merge __save_init_fpu()

__save_init_fpu() is identical for 32-bit and 64-bit.

Signed-off-by: Brian Gerst <brgerst@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>
LKML-Reference: <1283563039-3466-5-git-send-email-brgerst@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
