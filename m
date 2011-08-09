Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696Ab1HIO2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:28:49 -0400
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:62219 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752142Ab1HIO2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:28:23 -0400
X-AuditID: 12074422-b7ba7ae000000a14-c4-4e4143f829a9
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: Andy Lutomirski <luto@MIT.EDU>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, lueckintel@yahoo.com,
        kimwooyoung@gmail.com, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@alien8.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 2/4] x86: Remove unnecessary compile flag tweaks for vsyscall code
Date: Tue,  9 Aug 2011 10:27:48 -0400
Message-Id: <67d2df2c1ef4914ca7be2d2a058ef1100922da48.1312899174.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1312899174.git.luto@mit.edu>
References: <cover.1312899174.git.luto@mit.edu>
In-Reply-To: <cover.1312899174.git.luto@mit.edu>
References: <cover.1312899174.git.luto@mit.edu>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsUixG6novvD2dHPYPVKC4u+K0fZLY5c+85u
	8XnDPzaLaRvFLV79Kbe4vGsOm8WK852sFlsuNbNa/Gu6xWLxqO8tu8WPDY9ZHbg9vrf2sXjc
	avvD7DF/50dGj52z7rJ7LN7zkslj06pONo8TM36zeHzeJOcxa9ZhJo8TLV9YA7iiuGxSUnMy
	y1KL9O0SuDJ2PutgLGjgq7i+4zhjA+N57i5GTg4JAROJbR9fs0LYYhIX7q1n62Lk4hAS2Mco
	ceDMa2YIZz2jxLEdt1kgnKdMEnvOzWMBaWETUJHoWPqAqYuRg0NEQEhi6d06kBpmkJrmObuZ
	QWqEBYIkpp66D7aCRUBVor3xOSOIzQsU//R+BzPEajmJI5efM4HYnAIGEj8+3wWzhQT0Jdaf
	uIhTfAKjwAJGhlWMsim5Vbq5iZk5xanJusXJiXl5qUW6pnq5mSV6qSmlmxjBceCitIPx50Gl
	Q4wCHIxKPLyc/A5+QqyJZcWVuYcYJTmYlER5zYBRJMSXlJ9SmZFYnBFfVJqTWnyIUYKDWUmE
	N10DKMebklhZlVqUD5OS5mBREufl2gk0SSA9sSQ1OzW1ILUIJivDwaEkwesHMlSwKDU9tSIt
	M6cEIc3EwQkynAdoeJUTyPDigsTc4sx0iPwpRkUpcd4okGYBkERGaR5cLyxNvWIUB3pFmFcf
	pIoHmOLgul8BDWYCGlx/xwFkcEkiQkqqgVFs0pc7PrZzdT3NDu1fuu3BTf8nMTs0dk84rjXr
	76U3e6/zcgeavvQTODY1oXmacNwT1X9+L/XYpwgznPOVUa4+73X13JVlB6UfvJTjLd/2L9gv
	79xOq/WsnB11n79cFPk58+gnZTnZTQ6LL6/7s/j7U/WzaQ79ylquMv32vDeSp1bN28t867ao
	EktxRqKhFnNRcSIAugzewy4DAAA=
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
index 36259be..ee5c495 100644
--- a/arch/x86/kernel/vsyscall_64.c
+++ b/arch/x86/kernel/vsyscall_64.c
@@ -16,9 +16,6 @@
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

