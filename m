Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab1DGTUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 15:20:53 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13691 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756723Ab1DGTUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 15:20:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6309"; a="84569883"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] lib: Consolidate DEBUG_PER_CPU_MAPS
Date: Thu,  7 Apr 2011 12:20:46 -0700
Message-Id: <1302204046-2481-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DEBUG_PER_CPU_MAPS is used in lib/cpumask.c as well as in
inlcude/linux/cpumask.h and thus it has outgrown its use within x86
and powerpc alone. Any arch with SMP support may want to get some
more debugging, so make this option generic.

Cc: linux-arch@vger.kernel.org
Cc: x86@kernel.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

I don't know what tree to send this through, so I'm sending it to
Andrew. I suppose mm is as good as anything.

 arch/powerpc/Kconfig.debug |   12 ------------
 arch/x86/Kconfig.debug     |   11 -----------
 lib/Kconfig.debug          |   11 +++++++++++
 3 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
index 2d38a50..12a8d18 100644
--- a/arch/powerpc/Kconfig.debug
+++ b/arch/powerpc/Kconfig.debug
@@ -44,18 +44,6 @@ config DEBUG_STACK_USAGE
 
 	  This option will slow down process creation somewhat.
 
-config DEBUG_PER_CPU_MAPS
-	bool "Debug access to per_cpu maps"
-	depends on DEBUG_KERNEL
-	depends on SMP
-	default n
-	---help---
-	  Say Y to verify that the per_cpu map being accessed has
-	  been setup.  Adds a fair amount of code to kernel memory
-	  and decreases performance.
-
-	  Say N if unsure.
-
 config HCALL_STATS
 	bool "Hypervisor call instrumentation"
 	depends on PPC_PSERIES && DEBUG_FS && TRACEPOINTS
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 615e188..1bf8839 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -75,17 +75,6 @@ config DEBUG_STACK_USAGE
 
 	  This option will slow down process creation somewhat.
 
-config DEBUG_PER_CPU_MAPS
-	bool "Debug access to per_cpu maps"
-	depends on DEBUG_KERNEL
-	depends on SMP
-	---help---
-	  Say Y to verify that the per_cpu map being accessed has
-	  been setup.  Adds a fair amount of code to kernel memory
-	  and decreases performance.
-
-	  Say N if unsure.
-
 config X86_PTDUMP
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index c768bcd..c792431 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -993,6 +993,17 @@ config DEBUG_FORCE_WEAK_PER_CPU
 	  To ensure that generic code follows the above rules, this
 	  option forces all percpu variables to be defined as weak.
 
+config DEBUG_PER_CPU_MAPS
+	bool "Debug access to per_cpu maps"
+	depends on DEBUG_KERNEL
+	depends on SMP
+	help
+	  Say Y to verify that the per_cpu map being accessed has
+	  been set up. This adds a fair amount of code to kernel memory
+	  and decreases performance.
+
+	  Say N if unsure.
+
 config LKDTM
 	tristate "Linux Kernel Dump Test Tool Module"
 	depends on DEBUG_FS
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

