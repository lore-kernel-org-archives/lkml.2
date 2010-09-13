Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab0IMUPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 16:15:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:51550 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804Ab0IMUOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 16:14:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,360,1280732400"; 
   d="scan'208";a="656856274"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: Florian Mickler <florian@mickler.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH 2/5] x86, gcc: Disallow building Linux/x86 with gcc 3.x/4.0
Date: Mon, 13 Sep 2010 13:14:37 -0700
Message-Id: <1284408880-14414-3-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284408880-14414-1-git-send-email-hpa@linux.intel.com>
References: <1284408880-14414-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are starting to get "straggler problems" with people compiling
current Linux kernels with now-ancient versions of gcc.  All the
development is being done against gcc 4.x; this simply disallows gcc
4.0 or earlier.

We disallow 4.0 as well as 3.x because 4.0 had a fair share of bugs
especially around asm() statements; this allows us to remove those
workarounds.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/Makefile   |    3 ++-
 arch/x86/kernel/compiler.c |    5 +++++
 2 files changed, 7 insertions(+), 1 deletions(-)
 create mode 100644 arch/x86/kernel/compiler.c

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 0925676..a6459b7 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -29,7 +29,8 @@ GCOV_PROFILE_hpet.o		:= n
 GCOV_PROFILE_tsc.o		:= n
 GCOV_PROFILE_paravirt.o		:= n
 
-obj-y			:= process_$(BITS).o signal.o entry_$(BITS).o
+obj-y			:= compiler.o
+obj-y			+= process_$(BITS).o signal.o entry_$(BITS).o
 obj-y			+= traps.o irq.o irq_$(BITS).o dumpstack_$(BITS).o
 obj-y			+= time.o ioport.o ldt.o dumpstack.o
 obj-y			+= setup.o x86_init.o i8259.o irqinit.o
diff --git a/arch/x86/kernel/compiler.c b/arch/x86/kernel/compiler.c
new file mode 100644
index 0000000..8914974
--- /dev/null
+++ b/arch/x86/kernel/compiler.c
@@ -0,0 +1,5 @@
+#if __GNUC__ < 4
+#error "Compiling Linux/x86 with gcc 3.x is no longer supported"
+#elif __GNUC__ == 4 && __GNUC_MINOR__ < 1
+#error "Compiling Linux/x86 with gcc 4.0 is not supported"
+#endif
-- 
1.7.2.1

