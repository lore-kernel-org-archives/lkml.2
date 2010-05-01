Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab0EAOgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:36:18 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:63920 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab0EAOfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:35:21 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, Oren Laadan <orenl@cs.columbia.edu>,
       linux-s390@vger.kernel.org, Dan Smith <danms@us.ibm.com>
Subject: [PATCH v21 058/100] c/r: (s390): expose a constant for the number of words (CRs)
Date: Sat,  1 May 2010 10:15:40 -0400
Message-Id: <1272723382-19470-59-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to use this value in the checkpoint/restart code and would like to
have a constant instead of a magic '3'.

Changelog:
    Jan 20:
            . Define s390x sys_restart wrapper
    Mar 30:
            . Add CHECKPOINT_SUPPORT in Kconfig (Nathan Lynch)
    Mar 03:
            . Picked up additional use of magic '3' in ptrace.h

Cc: linux-s390@vger.kernel.org
Signed-off-by: Dan Smith <danms@us.ibm.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
---
 arch/s390/Kconfig          |    4 ++++
 arch/s390/kernel/process.c |    8 ++++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 0d8cd9b..b358e63 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -49,6 +49,10 @@ config GENERIC_TIME_VSYSCALL
 config GENERIC_CLOCKEVENTS
 	def_bool y
 
+config CHECKPOINT_SUPPORT
+	bool
+	default y if 64BIT
+
 config GENERIC_BUG
 	bool
 	depends on BUG
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 799cbb0..15f5719 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -240,6 +240,14 @@ SYSCALL_DEFINE4(clone, unsigned long, newsp, unsigned long, clone_flags,
 		       parent_tidptr, child_tidptr);
 }
 
+#ifdef CONFIG_CHECKPOINT
+SYSCALL_DEFINE4(restart, pid_t, pid, int, fd, unsigned long, flags,
+		int, logfd)
+{
+	return do_sys_restart(pid, fd, flags, logfd);
+}
+#endif
+
 SYSCALL_DEFINE4(eclone, unsigned int, flags_low, struct clone_args __user *,
 		uca, int, args_size, pid_t __user *, pids)
 {
-- 
1.6.3.3

