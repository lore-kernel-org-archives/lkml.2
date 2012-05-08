Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab2EHPNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:13:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57092 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab2EHPNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:13:52 -0400
Date: Tue, 8 May 2012 08:13:34 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-fba60c620a6a9ec11140c179e5d0fe0bc3c3ea29@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        jbeulich@suse.com, akpm@linux-foundation.org, JBeulich@suse.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        jbeulich@suse.com, akpm@linux-foundation.org, JBeulich@suse.com,
        tglx@linutronix.de
In-Reply-To: <4FA947FE020000780008247F@nat28.tlf.novell.com>
References: <4FA947FE020000780008247F@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86-64: Eliminate dead ia32 syscall handlers
Git-Commit-ID: fba60c620a6a9ec11140c179e5d0fe0bc3c3ea29
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 08:13:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fba60c620a6a9ec11140c179e5d0fe0bc3c3ea29
Gitweb:     http://git.kernel.org/tip/fba60c620a6a9ec11140c179e5d0fe0bc3c3ea29
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Tue, 8 May 2012 15:21:18 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 8 May 2012 16:43:01 +0200

x86-64: Eliminate dead ia32 syscall handlers

None of the three routines being removed here was actually
hooked up anywhere, so they all represented dead code.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4FA947FE020000780008247F@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/ia32/sys_ia32.c |   23 -----------------------
 1 files changed, 0 insertions(+), 23 deletions(-)

diff --git a/arch/x86/ia32/sys_ia32.c b/arch/x86/ia32/sys_ia32.c
index aec2202..edca9c0 100644
--- a/arch/x86/ia32/sys_ia32.c
+++ b/arch/x86/ia32/sys_ia32.c
@@ -287,11 +287,6 @@ asmlinkage long sys32_sigaction(int sig, struct old_sigaction32 __user *act,
 	return ret;
 }
 
-asmlinkage long sys32_alarm(unsigned int seconds)
-{
-	return alarm_setitimer(seconds);
-}
-
 asmlinkage long sys32_waitpid(compat_pid_t pid, unsigned int *stat_addr,
 			      int options)
 {
@@ -300,11 +295,6 @@ asmlinkage long sys32_waitpid(compat_pid_t pid, unsigned int *stat_addr,
 
 /* 32-bit timeval and related flotsam.  */
 
-asmlinkage long sys32_sysfs(int option, u32 arg1, u32 arg2)
-{
-	return sys_sysfs(option, arg1, arg2);
-}
-
 asmlinkage long sys32_sched_rr_get_interval(compat_pid_t pid,
 				    struct compat_timespec __user *interval)
 {
@@ -375,19 +365,6 @@ asmlinkage long sys32_pwrite(unsigned int fd, const char __user *ubuf,
 }
 
 
-asmlinkage long sys32_personality(unsigned long personality)
-{
-	int ret;
-
-	if (personality(current->personality) == PER_LINUX32 &&
-		personality == PER_LINUX)
-		personality = PER_LINUX32;
-	ret = sys_personality(personality);
-	if (ret == PER_LINUX32)
-		ret = PER_LINUX;
-	return ret;
-}
-
 asmlinkage long sys32_sendfile(int out_fd, int in_fd,
 			       compat_off_t __user *offset, s32 count)
 {
