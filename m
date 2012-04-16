Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab2DPRs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 13:48:26 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33682 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab2DPRsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 13:48:24 -0400
From: Will Drewry <wad@chromium.org>
To: jmorris@namei.org
Cc: linux-kernel@vger.kernel.org, sfr@canb.auug.org.au,
        linux-security-module@vger.kernel.org, Will Drewry <wad@chromium.org>
Subject: [PATCH] seccomp: ignore secure_computing return values
Date: Mon, 16 Apr 2012 12:47:41 -0500
Message-Id: <1334598461-3160-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unless an architecture selects CONFIG_HAVE_ARCH_SECCOMP_FILTER, it
is not required to respect the return value from secure_computing().

This change matches https://lkml.org/lkml/2012/4/16/14 exactly except
that it applies cleanly to security-next.  Because there is no
other difference than the alignment, I've kept Signed-off-by intact.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Will Drewry <wad@chromium.org>
---
 arch/microblaze/kernel/ptrace.c |    2 +-
 arch/mips/kernel/ptrace.c       |    2 +-
 arch/powerpc/kernel/ptrace.c    |    2 +-
 arch/s390/kernel/ptrace.c       |    2 +-
 arch/sh/kernel/ptrace_32.c      |    2 +-
 arch/sh/kernel/ptrace_64.c      |    2 +-
 arch/sparc/kernel/ptrace_64.c   |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/microblaze/kernel/ptrace.c b/arch/microblaze/kernel/ptrace.c
index 6eb2aa9..9e3ffc9 100644
--- a/arch/microblaze/kernel/ptrace.c
+++ b/arch/microblaze/kernel/ptrace.c
@@ -136,7 +136,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
-	secure_computing(regs->r12);
+	(void)secure_computing(regs->r12);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
 	    tracehook_report_syscall_entry(regs))
diff --git a/arch/mips/kernel/ptrace.c b/arch/mips/kernel/ptrace.c
index 7c24c29..4f83d73 100644
--- a/arch/mips/kernel/ptrace.c
+++ b/arch/mips/kernel/ptrace.c
@@ -535,7 +535,7 @@ static inline int audit_arch(void)
 asmlinkage void syscall_trace_enter(struct pt_regs *regs)
 {
 	/* do the secure computing check first */
-	secure_computing(regs->regs[2]);
+	(void)secure_computing(regs->regs[2]);
 
 	if (!(current->ptrace & PT_PTRACED))
 		goto out;
diff --git a/arch/powerpc/kernel/ptrace.c b/arch/powerpc/kernel/ptrace.c
index 8d8e028..53cebc4 100644
--- a/arch/powerpc/kernel/ptrace.c
+++ b/arch/powerpc/kernel/ptrace.c
@@ -1710,7 +1710,7 @@ long do_syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
-	secure_computing(regs->gpr[0]);
+	(void)secure_computing(regs->gpr[0]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
 	    tracehook_report_syscall_entry(regs))
diff --git a/arch/s390/kernel/ptrace.c b/arch/s390/kernel/ptrace.c
index 02f300f..96e0dea 100644
--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -719,7 +719,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 	long ret = 0;
 
 	/* Do the secure computing check first. */
-	secure_computing(regs->gprs[2]);
+	(void)secure_computing(regs->gprs[2]);
 
 	/*
 	 * The sysc_tracesys code in entry.S stored the system
diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index 9698671..cf55945 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -503,7 +503,7 @@ asmlinkage long do_syscall_trace_enter(struct pt_regs *regs)
 {
 	long ret = 0;
 
-	secure_computing(regs->regs[0]);
+	(void)secure_computing(regs->regs[0]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
 	    tracehook_report_syscall_entry(regs))
diff --git a/arch/sh/kernel/ptrace_64.c b/arch/sh/kernel/ptrace_64.c
index bc81e07..3d3600f 100644
--- a/arch/sh/kernel/ptrace_64.c
+++ b/arch/sh/kernel/ptrace_64.c
@@ -522,7 +522,7 @@ asmlinkage long long do_syscall_trace_enter(struct pt_regs *regs)
 {
 	long long ret = 0;
 
-	secure_computing(regs->regs[9]);
+	(void)secure_computing(regs->regs[9]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE) &&
 	    tracehook_report_syscall_entry(regs))
diff --git a/arch/sparc/kernel/ptrace_64.c b/arch/sparc/kernel/ptrace_64.c
index 6f97c07..6ddec1f 100644
--- a/arch/sparc/kernel/ptrace_64.c
+++ b/arch/sparc/kernel/ptrace_64.c
@@ -1062,7 +1062,7 @@ asmlinkage int syscall_trace_enter(struct pt_regs *regs)
 	int ret = 0;
 
 	/* do the secure computing check first */
-	secure_computing(regs->u_regs[UREG_G1]);
+	(void)secure_computing(regs->u_regs[UREG_G1]);
 
 	if (test_thread_flag(TIF_SYSCALL_TRACE))
 		ret = tracehook_report_syscall_entry(regs);
-- 
1.7.5.4

