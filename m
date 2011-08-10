Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab1HJPP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 11:15:58 -0400
Received: from DMZ-MAILSEC-SCANNER-7.MIT.EDU ([18.7.68.36]:63262 "EHLO
	dmz-mailsec-scanner-7.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753062Ab1HJPPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 11:15:55 -0400
X-AuditID: 12074424-b7b0fae000000a08-b6-4e42a0cf6f49
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH 1/3] x86: Remove unnecessary compile flag tweaks for vsyscall code
Date: Wed, 10 Aug 2011 11:15:30 -0400
Message-Id: <835cd05a4c7740544d09723d6ba48f4406f9826c.1312988155.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1312988155.git.luto@mit.edu>
References: <cover.1312988155.git.luto@mit.edu>
In-Reply-To: <cover.1312988155.git.luto@mit.edu>
References: <cover.1312988155.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42IRYrdT0T2/wMnPYO0HUYu+K0fZLY5c+85u
	8XnDPzaLaRvFLV79Kbe4vGsOm8WK852sFlsuNbNaPOp7y27xY8NjVgcuj++tfSwet9r+MHvM
	3/mR0WPnrLvsHptWdbJ5nJjxm8Xj8yY5j1mzDjN5nGj5whrAGcVlk5Kak1mWWqRvl8CVsWzC
	adaCBr6K7ktuDYznubsYOTgkBEwkFs8X7GLkBDLFJC7cW8/WxcjFISSwj1Hi9aq/zBDOBkaJ
	w4/XsEI4z5gkZk7qYQVpYRNQkehY+oAJZJKIgJDE0rt1IDXMAhuZJBoWPGcEqREWCJL4970P
	rJ5FQFWis2kumM0LFP/SuokdYrWcxJHLz5lAbE4BA4npZ56C9QoJ6Eu8n3CHHZf4BEaBBYwM
	qxhlU3KrdHMTM3OKU5N1i5MT8/JSi3TN9XIzS/RSU0o3MYLD3UVlB2PzIaVDjAIcjEo8vDeW
	OfoJsSaWFVfmHmKU5GBSEuXtn+/kJ8SXlJ9SmZFYnBFfVJqTWnyIUYKDWUmEV2oeUI43JbGy
	KrUoHyYlzcGiJM5rs9PBT0ggPbEkNTs1tSC1CCYrw8GhJMF7E2SoYFFqempFWmZOCUKaiYMT
	ZDgP0PAJIDW8xQWJucWZ6RD5U4yKUuK8z0ESAiCJjNI8uF5YOnrFKA70ijBvKEgVDzCVwXW/
	AhrMBDS4/o4DyOCSRISUVAPjtO2SV2dsDk2PfSK6u2/rPdsDYozlCpztgsq/2iQvHTidHLx2
	T9bzF4nCoRmF73Pkar+0bJ6ve8rce+bNv/NmCiyQltz25hdz0yHr44pesk+XzH5X8Xm32/Lj
	Kbkb7OTLf/ROeeDzRr+4Y/7egzIHHJrkJ7DO/1v55sesK0x6yeW+3FxK79puK7EUZyQaajEX
	FScCANfTy2QiAwAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As of commit 98d0ac38ca7b1b7a552c9a2359174ff84decb600
Author: Andy Lutomirski <luto@mit.edu>
Date:   Thu Jul 14 06:47:22 2011 -0400

    x86-64: Move vread_tsc and vread_hpet into the vDSO

user code no longer directly calls into code in arch/x86/kernel/, so
we don't need compile flag hacks to make it safe.  All vdso code is
in the vdso directory now.

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---
 arch/x86/kernel/Makefile      |   13 -------------
 arch/x86/kernel/vsyscall_64.c |    3 ---
 2 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0410557..82f2912 100644
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
-- 
1.7.6

