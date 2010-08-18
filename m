Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604Ab0HRBlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 21:41:18 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46126 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab0HRBlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 21:41:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bofJq/n9cLVmmRCDqA38Ul5XWG9oG1PVR2J5tjmnwX1t1tRsSizerZoNIYW+mTjExa
         ysAWSyccxY/Do4tGBW1XDqA3BUzjIQiMbEEn6pVnBvehb37tWpKlyMacQNXJpSqSDVu8
         +Uo7QSo+m+GVpBZ68ebmknonfgO39ZK0kly+M=
From: Namhyung Kim <namhyung@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: add __user markup on sys32_waitpid()
Date: Wed, 18 Aug 2010 10:41:08 +0900
Message-Id: <1282095668-6147-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stat_addr, 2nd arg, is a user pointer but was missing __user markup.
Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/x86/ia32/sys_ia32.c        |    2 +-
 arch/x86/include/asm/sys_ia32.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index 3d09331..9677f8e 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -333,7 +333,7 @@ asmlinkage long sys32_alarm(unsigned int seconds)
 	return alarm_setitimer(seconds);
 }
 
-asmlinkage long sys32_waitpid(compat_pid_t pid, unsigned int *stat_addr,
+asmlinkage long sys32_waitpid(compat_pid_t pid, unsigned int __user *stat_addr,
 			      int options)
 {
 	return compat_sys_wait4(pid, stat_addr, options, NULL);
diff --git a/arch/x86/include/asm/sys_ia32.h b/arch/x86/include/asm/sys_ia32.h
index cf4e2e3..ce7095c 100644
--- a/arch/x86/include/asm/sys_ia32.h
+++ b/arch/x86/include/asm/sys_ia32.h
@@ -40,7 +40,7 @@ asmlinkage long sys32_rt_sigprocmask(int, compat_sigset_t __user *,
 				     compat_sigset_t __user *, unsigned int);
 asmlinkage long sys32_alarm(unsigned int);
 
-asmlinkage long sys32_waitpid(compat_pid_t, unsigned int *, int);
+asmlinkage long sys32_waitpid(compat_pid_t, unsigned int __user *, int);
 asmlinkage long sys32_sysfs(int, u32, u32);
 
 asmlinkage long sys32_sched_rr_get_interval(compat_pid_t,
-- 
1.7.0.4

