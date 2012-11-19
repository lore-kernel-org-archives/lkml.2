Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab2KSFdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:33:13 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37158 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab2KSFdK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:33:10 -0500
X-Originating-IP: 217.70.178.151
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Josh Triplett <josh@joshtriplett.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 53/58] linux/syscalls.h: Add prototypes for sys_rt_sigaction and sys_rt_sigsuspend
Date: Sun, 18 Nov 2012 21:28:32 -0800
Message-Id: <1353302917-13995-54-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include/linux/syscalls.h contains prototypes for most syscall functions;
however, it lacked the prototypes for sys_rt_sigaction and
sys_rt_sigsuspend.  Add them.  This eliminates warnings from GCC
(-Wmissing-prototypes) and Sparse (-Wdecl).

kernel/signal.c:3183:2: warning: no previous prototype for ‘sys_rt_sigaction’ [-Wmissing-prototypes]
kernel/signal.c:3280:7: warning: no previous prototype for ‘sys_rt_sigsuspend’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/syscalls.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 727f0cd..4ec00c1 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -371,9 +371,12 @@ asmlinkage long sys_init_module(void __user *umod, unsigned long len,
 asmlinkage long sys_delete_module(const char __user *name_user,
 				unsigned int flags);
 
+asmlinkage long sys_rt_sigaction(int sig, const struct sigaction __user *act,
+				struct sigaction __user *oact, size_t sigsetsize);
 asmlinkage long sys_rt_sigprocmask(int how, sigset_t __user *set,
 				sigset_t __user *oset, size_t sigsetsize);
 asmlinkage long sys_rt_sigpending(sigset_t __user *set, size_t sigsetsize);
+asmlinkage long sys_rt_sigsuspend(sigset_t __user *unewset, size_t sigsetsize);
 asmlinkage long sys_rt_sigtimedwait(const sigset_t __user *uthese,
 				siginfo_t __user *uinfo,
 				const struct timespec __user *uts,
-- 
1.7.10.4

