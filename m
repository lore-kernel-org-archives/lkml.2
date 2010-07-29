Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099Ab0G2UNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 16:13:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:40566 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755971Ab0G2UNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 16:13:16 -0400
Date: Thu, 29 Jul 2010 20:12:57 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <AANLkTikAmaDPji-TVDarmG1yD=fwbffcsmEU=YEuP+8r@mail.gmail.com>
References: <AANLkTikAmaDPji-TVDarmG1yD=fwbffcsmEU=YEuP+8r@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, asm: Move cmpxchg emulation code to arch/x86/lib
Message-ID: <tip-90c8f92f5c807807ca74d5f2f313794925174e6b@git.kernel.org>
Git-Commit-ID: 90c8f92f5c807807ca74d5f2f313794925174e6b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 29 Jul 2010 20:12:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  90c8f92f5c807807ca74d5f2f313794925174e6b
Gitweb:     http://git.kernel.org/tip/90c8f92f5c807807ca74d5f2f313794925174e6b
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 28 Jul 2010 16:53:49 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 28 Jul 2010 16:53:49 -0700

x86, asm: Move cmpxchg emulation code to arch/x86/lib

Move cmpxchg emulation code from arch/x86/kernel/cpu (which is
otherwise CPU identification) to arch/x86/lib, where other emulation
code lives already.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
LKML-Reference: <AANLkTikAmaDPji-TVDarmG1yD=fwbffcsmEU=YEuP+8r@mail.gmail.com>
---
 arch/x86/kernel/cpu/Makefile           |    2 +-
 arch/x86/lib/Makefile                  |    1 +
 arch/x86/{kernel/cpu => lib}/cmpxchg.c |    0
 3 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 3a785da..c47c439 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -16,7 +16,7 @@ obj-y			:= intel_cacheinfo.o addon_cpuid_features.o
 obj-y			+= proc.o capflags.o powerflags.o common.o
 obj-y			+= vmware.o hypervisor.o sched.o mshyperv.o
 
-obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
+obj-$(CONFIG_X86_32)	+= bugs.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
 
 obj-$(CONFIG_CPU_SUP_INTEL)		+= intel.o
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index f871e04..e10cf07 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -30,6 +30,7 @@ ifeq ($(CONFIG_X86_32),y)
         lib-y += checksum_32.o
         lib-y += strstr_32.o
         lib-y += semaphore_32.o string_32.o
+        lib-y += cmpxchg.o
 ifneq ($(CONFIG_X86_CMPXCHG64),y)
         lib-y += cmpxchg8b_emu.o atomic64_386_32.o
 endif
diff --git a/arch/x86/kernel/cpu/cmpxchg.c b/arch/x86/lib/cmpxchg.c
similarity index 100%
rename from arch/x86/kernel/cpu/cmpxchg.c
rename to arch/x86/lib/cmpxchg.c
