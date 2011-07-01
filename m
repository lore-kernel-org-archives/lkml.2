Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082Ab1GAP1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:27:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:42718 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833Ab1GAP1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:27:08 -0400
Date: Fri, 1 Jul 2011 15:26:50 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-09pfip95g88s70iwkxu6nnbt@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@samba.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, emunson@mgebm.net,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        emunson@mgebm.net, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, powerpc: Fix build borkage
Git-Commit-ID: 29dfc4fd7e792854b30d771d4e299fbdd2adb763
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:26:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29dfc4fd7e792854b30d771d4e299fbdd2adb763
Gitweb:     http://git.kernel.org/tip/29dfc4fd7e792854b30d771d4e299fbdd2adb763
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 1 Jul 2011 15:24:53 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 16:20:04 +0200

perf, powerpc: Fix build borkage

The patch a8b0ca17b80e ("perf: Remove the nmi parameter from the swevent
and overflow interface") missed a spot in the ppc hw_breakpoint code,
fix this up so things compile again.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: Anton Blanchard <anton@samba.org>
Cc: Eric B Munson <emunson@mgebm.net>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-09pfip95g88s70iwkxu6nnbt@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/powerpc/include/asm/hw_breakpoint.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/hw_breakpoint.h b/arch/powerpc/include/asm/hw_breakpoint.h
index 1c33ec1..80fd4d2 100644
--- a/arch/powerpc/include/asm/hw_breakpoint.h
+++ b/arch/powerpc/include/asm/hw_breakpoint.h
@@ -57,7 +57,7 @@ void hw_breakpoint_pmu_read(struct perf_event *bp);
 extern void flush_ptrace_hw_breakpoint(struct task_struct *tsk);
 
 extern struct pmu perf_ops_bp;
-extern void ptrace_triggered(struct perf_event *bp, int nmi,
+extern void ptrace_triggered(struct perf_event *bp,
 			struct perf_sample_data *data, struct pt_regs *regs);
 static inline void hw_breakpoint_disable(void)
 {
