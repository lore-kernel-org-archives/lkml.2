Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab0KXX5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:57:22 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10589 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab0KXX5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:57:20 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6177"; a="64247788"
From: Stephen Boyd <sboyd@codeaurora.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/2] Make OPTIMIZE_INLINING a generic option
Date: Wed, 24 Nov 2010 15:56:59 -0800
Message-Id: <1290643020-24558-2-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.3.2.245.g03276
In-Reply-To: <1290643020-24558-1-git-send-email-sboyd@codeaurora.org>
References: <1290643020-24558-1-git-send-email-sboyd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This option is useful on more architectures than just x86. When
this option was introduced Ingo deliberately made it x86
specific since he was uncertain of the amount of testing other
architectures had (see http://lkml.org/lkml/2008/3/4/285).

This option has been tested on ARM v7 with no ill effects observed.
Therefore make it generic so ARM can choose it in the next patch.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/x86/Kconfig       |    4 +---
 arch/x86/Kconfig.debug |   14 --------------
 init/Kconfig           |   18 ++++++++++++++++++
 3 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e832768..292b64c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -65,6 +65,7 @@ config X86
 	select HAVE_SPARSE_IRQ
 	select GENERIC_IRQ_PROBE
 	select GENERIC_PENDING_IRQ if SMP
+	select ARCH_SUPPORTS_OPTIMIZED_INLINING
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
@@ -193,9 +194,6 @@ config AUDIT_ARCH
 	bool
 	default X86_64
 
-config ARCH_SUPPORTS_OPTIMIZED_INLINING
-	def_bool y
-
 config ARCH_SUPPORTS_DEBUG_PAGEALLOC
 	def_bool y
 
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index b59ee76..5e714f3 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -265,20 +265,6 @@ config CPA_DEBUG
 	---help---
 	  Do change_page_attr() self-tests every 30 seconds.
 
-config OPTIMIZE_INLINING
-	bool "Allow gcc to uninline functions marked 'inline'"
-	---help---
-	  This option determines if the kernel forces gcc to inline the functions
-	  developers have marked 'inline'. Doing so takes away freedom from gcc to
-	  do what it thinks is best, which is desirable for the gcc 3.x series of
-	  compilers. The gcc 4.x series have a rewritten inlining algorithm and
-	  enabling this option will generate a smaller kernel there. Hopefully
-	  this algorithm is so good that allowing gcc 4.x and above to make the
-	  decision will become the default in the future. Until then this option
-	  is there to test gcc for this.
-
-	  If unsure, say N.
-
 config DEBUG_STRICT_USER_COPY_CHECKS
 	bool "Strict copy size checks"
 	depends on DEBUG_KERNEL && !TRACE_BRANCH_PROFILING
diff --git a/init/Kconfig b/init/Kconfig
index 88c1046..d8b2c50 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -811,6 +811,24 @@ config CC_OPTIMIZE_FOR_SIZE
 
 	  If unsure, say Y.
 
+config ARCH_SUPPORTS_OPTIMIZED_INLINING
+	bool
+
+config OPTIMIZE_INLINING
+	bool "Allow gcc to uninline functions marked 'inline'"
+	depends on ARCH_SUPPORTS_OPTIMIZED_INLINING
+	---help---
+	  This option determines if the kernel forces gcc to inline the
+	  functions developers have marked 'inline'. Doing so takes away
+	  freedom from gcc to do what it thinks is best, which is desirable for
+	  the gcc 3.x series of compilers. The gcc 4.x series have a rewritten
+	  inlining algorithm and enabling this option will generate a smaller
+	  kernel there. Hopefully this algorithm is so good that allowing gcc
+	  4.x and above to make the decision will become the default in the
+	  future. Until then this option is there to test gcc for this.
+
+	  If unsure, say N.
+
 config SYSCTL
 	bool
 
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

