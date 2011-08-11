Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab1HKABn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 20:01:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:41304 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577Ab1HKABl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 20:01:41 -0400
Date: Thu, 11 Aug 2011 00:01:25 GMT
From: tip-bot for Andy Lutomirski <luto@mit.edu>
Message-ID: <tip-f3fb5b7bb70d6e679c15fef85707810a067f5fb6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        luto@mit.edu, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <835cd05a4c7740544d09723d6ba48f4406f9826c.1312988155.git.luto@mit.edu>
References: <835cd05a4c7740544d09723d6ba48f4406f9826c.1312988155.git.luto@mit.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] x86: Remove unnecessary compile flag tweaks for vsyscall code
Git-Commit-ID: f3fb5b7bb70d6e679c15fef85707810a067f5fb6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Aug 2011 00:01:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3fb5b7bb70d6e679c15fef85707810a067f5fb6
Gitweb:     http://git.kernel.org/tip/f3fb5b7bb70d6e679c15fef85707810a067f5fb6
Author:     Andy Lutomirski <luto@mit.edu>
AuthorDate: Wed, 10 Aug 2011 11:15:30 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 10 Aug 2011 18:55:29 -0500

x86: Remove unnecessary compile flag tweaks for vsyscall code

As of commit 98d0ac38ca7b1b7a552c9a2359174ff84decb600
Author: Andy Lutomirski <luto@mit.edu>
Date:   Thu Jul 14 06:47:22 2011 -0400

    x86-64: Move vread_tsc and vread_hpet into the vDSO

user code no longer directly calls into code in arch/x86/kernel/, so
we don't need compile flag hacks to make it safe.  All vdso code is
in the vdso directory now.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
Link: http://lkml.kernel.org/r/835cd05a4c7740544d09723d6ba48f4406f9826c.1312988155.git.luto@mit.edu
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/Makefile      |   13 -------------
 arch/x86/kernel/vsyscall_64.c |    3 ---
 2 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 2deef3d..3d1ac39 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -17,19 +17,6 @@ CFLAGS_REMOVE_ftrace.o = -pg
 CFLAGS_REMOVE_early_printk.o = -pg
 endif
 
-#
-# vsyscalls (which work on the user stack) should have
-# no stack-protector checks:
-#
-nostackp := $(call cc-option, -fno-stack-protector)
-CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0 $(nostackp)
-CFLAGS_hpet.o		:= $(nostackp)
-CFLAGS_paravirt.o	:= $(nostackp)
-GCOV_PROFILE_vsyscall_64.o	:= n
-GCOV_PROFILE_hpet.o		:= n
-GCOV_PROFILE_tsc.o		:= n
-GCOV_PROFILE_paravirt.o		:= n
-
 obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o ldt.o dumpstack.o
diff --git a/arch/x86/kernel/vsyscall_64.c b/arch/x86/kernel/vsyscall_64.c
index 93a0d46..bf8e9ff 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -18,9 +18,6 @@
  *  use the vDSO.
  */
 
-/* Disable profiling for userspace code: */
-#define DISABLE_BRANCH_PROFILING
-
 #include <linux/time.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
