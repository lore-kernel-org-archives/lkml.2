Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab2GNPf2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 11:35:28 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55263 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab2GNPfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 11:35:20 -0400
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: fengxj325@gmail.com, eparis@redhat.com, keescook@chromium.org,
        james.l.morris@oracle.com, hpa@zytor.com, cevans@chromium.org,
        luto@mit.edu, rob@landley.net, linux-doc@vger.kernel.org,
        Will Drewry <wad@chromium.org>
Subject: [PATCH 1/3] vsyscall_64: add missing ifdef CONFIG_SECCOMP
Date: Sat, 14 Jul 2012 10:32:52 -0500
Message-Id: <1342279974-26917-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vsyscall_seccomp introduced a dependency on __secure_computing.  On
configurations with CONFIG_SECCOMP disabled, compilation will fail.

Reported-by: feng xiangjun <fengxj325@gmail.com>
Signed-off-by: Will Drewry <wad@chromium.org>
---
 arch/x86/kernel/vsyscall_64.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 08a18d0..5db36ca 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -139,6 +139,7 @@ static int addr_to_vsyscall_nr(unsigned long addr)
 	return nr;
 }
 
+#ifdef CONFIG_SECCOMP
 static int vsyscall_seccomp(struct task_struct *tsk, int syscall_nr)
 {
 	if (!seccomp_mode(&tsk->seccomp))
@@ -147,6 +148,9 @@ static int vsyscall_seccomp(struct task_struct *tsk, int syscall_nr)
 	task_pt_regs(tsk)->ax = syscall_nr;
 	return __secure_computing(syscall_nr);
 }
+#else
+#define vsyscall_seccomp(_tsk, _nr) 0
+#endif
 
 static bool write_ok_or_segv(unsigned long ptr, size_t size)
 {
-- 
1.7.9.5

