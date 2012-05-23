Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab2EWFk4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 01:40:56 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:57636 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab2EWFkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 01:40:55 -0400
Date: Wed, 23 May 2012 07:40:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/asm change for v3.5
Message-ID: <20120523054049.GA25872@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

Please pull the latest x86-asm-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-asm-for-linus

   HEAD: fba60c620a6a9ec11140c179e5d0fe0bc3c3ea29 x86-64: Eliminate dead ia32 syscall handlers

One small cleanup.

 Thanks,

	Ingo

------------------>
Jan Beulich (1):
      x86-64: Eliminate dead ia32 syscall handlers


 arch/x86/ia32/sys_ia32.c | 23 -----------------------
 1 file changed, 23 deletions(-)

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
