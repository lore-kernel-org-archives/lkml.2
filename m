Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755738Ab2EHOVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 10:21:23 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:44504 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab2EHOVW convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 8 May 2012 10:21:22 -0400
Message-Id: <4FA947FE020000780008247F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 08 May 2012 15:21:18 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: eliminate dead ia32 syscall handlers
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of the three routines being removed here was actually hooked up
anywhere, so they all represented dead code.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 arch/x86/ia32/sys_ia32.c |   23 -----------------------
 1 file changed, 23 deletions(-)

--- 3.4-rc6/arch/x86/ia32/sys_ia32.c
+++ 3.4-rc6-x86_64-ia32-dead-syscall-handlers/arch/x86/ia32/sys_ia32.c
@@ -287,11 +287,6 @@ asmlinkage long sys32_sigaction(int sig,
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
@@ -300,11 +295,6 @@ asmlinkage long sys32_waitpid(compat_pid
 
 /* 32-bit timeval and related flotsam.  */
 
-asmlinkage long sys32_sysfs(int option, u32 arg1, u32 arg2)
-{
-	return sys_sysfs(option, arg1, arg2);
-}
-
 asmlinkage long sys32_sched_rr_get_interval(compat_pid_t pid,
 				    struct compat_timespec __user *interval)
 {
@@ -375,19 +365,6 @@ asmlinkage long sys32_pwrite(unsigned in
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



