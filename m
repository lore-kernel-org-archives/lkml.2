Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268Ab0JRUgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 16:36:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50990 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933151Ab0JRUgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 16:36:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=r5jBoj6dPSGAsVoQJGLS3KRCrY7//yeZPtqFqI9aMXvweuqLD80fALdvjRpv0NUWDt
         Ouylq/h8hIckLVvg7TyJ/AWjWRHvCAMjPhhXoBgQmNnEfPmYiuQ3zxUWQK6OQvJCWP4o
         /bsuNCpv74s3d5t9i+ARuK5+7C9HbEFieR5xk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/2] x86: Cleanup TIF value gaps in shift range
Date: Mon, 18 Oct 2010 22:35:57 +0200
Message-Id: <1287434158-24362-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

9, 19 and 26 values are missing from the TIF shift range, probably
due to flags that were removed by the past. Now repack the range
so that we can quickly retrieve the remaining free shift slots.

But take care of keeping the seperation between high and low bits
as some masks are created on top of this boundary.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/thread_info.h |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index f0b6e5d..0bbf6f9 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -82,19 +82,19 @@ struct thread_info {
 #define TIF_SYSCALL_EMU		6	/* syscall emulation active */
 #define TIF_SYSCALL_AUDIT	7	/* syscall auditing active */
 #define TIF_SECCOMP		8	/* secure computing */
-#define TIF_MCE_NOTIFY		10	/* notify userspace of an MCE */
-#define TIF_USER_RETURN_NOTIFY	11	/* notify kernel of userspace return */
+#define TIF_MCE_NOTIFY		9	/* notify userspace of an MCE */
+#define TIF_USER_RETURN_NOTIFY	10	/* notify kernel of userspace return */
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* 32bit process */
 #define TIF_FORK		18	/* ret_from_fork */
-#define TIF_MEMDIE		20	/* is terminating due to OOM killer */
-#define TIF_DEBUG		21	/* uses debug registers */
-#define TIF_IO_BITMAP		22	/* uses I/O bitmap */
-#define TIF_FREEZE		23	/* is freezing for suspend */
-#define TIF_FORCED_TF		24	/* true if TF in eflags artificially */
-#define TIF_BLOCKSTEP		25	/* set when we want DEBUGCTLMSR_BTF */
-#define TIF_LAZY_MMU_UPDATES	27	/* task is updating the mmu lazily */
-#define TIF_SYSCALL_TRACEPOINT	28	/* syscall tracepoint instrumentation */
+#define TIF_MEMDIE		19	/* is terminating due to OOM killer */
+#define TIF_DEBUG		20	/* uses debug registers */
+#define TIF_IO_BITMAP		21	/* uses I/O bitmap */
+#define TIF_FREEZE		22	/* is freezing for suspend */
+#define TIF_FORCED_TF		23	/* true if TF in eflags artificially */
+#define TIF_BLOCKSTEP		24	/* set when we want DEBUGCTLMSR_BTF */
+#define TIF_LAZY_MMU_UPDATES	25	/* task is updating the mmu lazily */
+#define TIF_SYSCALL_TRACEPOINT	26	/* syscall tracepoint instrumentation */
 
 #define _TIF_SYSCALL_TRACE	(1 << TIF_SYSCALL_TRACE)
 #define _TIF_NOTIFY_RESUME	(1 << TIF_NOTIFY_RESUME)
-- 
1.6.2.3

