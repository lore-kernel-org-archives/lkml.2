Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab2IBVeQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:34:16 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65319 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab2IBVdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:33:01 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Jaswinder Singh Rajput <jaswinder@infradead.org>
Subject: [PATCH 1/7] x86: fix __user annotations in asm/sys_ia32.h
Date: Sun,  2 Sep 2012 23:31:40 +0200
Message-Id: <1346621506-30857-2-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346621506-30857-1-git-send-email-minipli@googlemail.com>
References: <1346621506-30857-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following sparse warning:

sys_ia32.c:293:38: warning: incorrect type in argument 2 (different address spaces)
sys_ia32.c:293:38:    expected unsigned int [noderef] [usertype] <asn:1>*stat_addr
sys_ia32.c:293:38:    got unsigned int *stat_addr

Ironically, sys_ia32.h was introduced to fix sparse warnings but missed that
one.

Cc: Jaswinder Singh Rajput <jaswinder@infradead.org>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/ia32/sys_ia32.c        |    2 +-
 arch/x86/include/asm/sys_ia32.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 4540bec..c5b938d 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -287,7 +287,7 @@ asmlinkage long sys32_sigaction(int sig, struct old_sigaction32 __user *act,
 	return ret;
 }
 
-asmlinkage long sys32_waitpid(compat_pid_t pid, unsigned int *stat_addr,
+asmlinkage long sys32_waitpid(compat_pid_t pid, unsigned int __user *stat_addr,
 			      int options)
 {
 	return compat_sys_wait4(pid, stat_addr, options, NULL);
diff --git a/arch/x86/include/asm/sys_ia32.h b/arch/x86/include/asm/sys_ia32.h
index 3fda9db4..4ca1c61 100644
--- a/arch/x86/include/asm/sys_ia32.h
+++ b/arch/x86/include/asm/sys_ia32.h
@@ -40,7 +40,7 @@ asmlinkage long sys32_sigaction(int, struct old_sigaction32 __user *,
 				struct old_sigaction32 __user *);
 asmlinkage long sys32_alarm(unsigned int);
 
-asmlinkage long sys32_waitpid(compat_pid_t, unsigned int *, int);
+asmlinkage long sys32_waitpid(compat_pid_t, unsigned int __user *, int);
 asmlinkage long sys32_sysfs(int, u32, u32);
 
 asmlinkage long sys32_sched_rr_get_interval(compat_pid_t,
-- 
1.7.10.4

