Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758176Ab2IEKym (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 06:54:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56189 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab2IEKyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 06:54:40 -0400
Date: Wed, 5 Sep 2012 03:54:29 -0700
From: tip-bot for Mathias Krause <minipli@googlemail.com>
Message-ID: <tip-f00026276ace77dcad1cdf17f696ae4e56e12ee6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        minipli@googlemail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        minipli@googlemail.com, tglx@linutronix.de
In-Reply-To: <1346621506-30857-2-git-send-email-minipli@googlemail.com>
References: <1346621506-30857-2-git-send-email-minipli@googlemail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/debug] x86: Fix __user annotations in asm/sys_ia32.h
Git-Commit-ID: f00026276ace77dcad1cdf17f696ae4e56e12ee6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 05 Sep 2012 03:54:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f00026276ace77dcad1cdf17f696ae4e56e12ee6
Gitweb:     http://git.kernel.org/tip/f00026276ace77dcad1cdf17f696ae4e56e12ee6
Author:     Mathias Krause <minipli@googlemail.com>
AuthorDate: Sun, 2 Sep 2012 23:31:40 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 5 Sep 2012 10:52:23 +0200

x86: Fix __user annotations in asm/sys_ia32.h

Fix the following sparse warnings:

  sys_ia32.c:293:38: warning: incorrect type in argument 2 (different address spaces)
  sys_ia32.c:293:38:    expected unsigned int [noderef] [usertype] <asn:1>*stat_addr
  sys_ia32.c:293:38:    got unsigned int *stat_addr

Ironically, sys_ia32.h was introduced to fix sparse warnings but
missed that one.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Link: http://lkml.kernel.org/r/1346621506-30857-2-git-send-email-minipli@googlemail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
