Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab1GNPE7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 11:04:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38328 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754911Ab1GNPES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 11:04:18 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>
Subject: [PATCH 5/6] hw_breakpoints: Only force perf events if breakpoints are selected
Date: Thu, 14 Jul 2011 17:03:56 +0200
Message-Id: <1310655837-328-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310655837-328-1-git-send-email-fweisbec@gmail.com>
References: <1310655837-328-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, arch were forced to always build perf events if they
supported hw_breakpoints.

Now that the user can choose not to build hw_breakpoints, let
only force perf events if hw_breakpoints are selected.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
---
 arch/sh/Kconfig  |    1 -
 arch/x86/Kconfig |    1 -
 init/Kconfig     |    1 +
 3 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 0a59a82..7130d4b 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -46,7 +46,6 @@ config SUPERH32
 	select HAVE_HW_BREAKPOINT
 	select HW_BREAKPOINT
 	select HAVE_MIXED_BREAKPOINTS_REGS
-	select PERF_EVENTS
 	select ARCH_HIBERNATION_POSSIBLE if MMU
 	select SPARSE_IRQ
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d7a255d..67979f4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -54,7 +54,6 @@ config X86
 	select HAVE_KERNEL_LZO
 	select HAVE_HW_BREAKPOINT
 	select HAVE_MIXED_BREAKPOINTS_REGS
-	select PERF_EVENTS
 	select HAVE_PERF_EVENTS_NMI
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
diff --git a/init/Kconfig b/init/Kconfig
index 9eec0df..3cf7855 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -926,6 +926,7 @@ menuconfig EXPERT
 config HW_BREAKPOINT
 	bool "Hardware breakpoints" if EXPERT
 	depends on HAVE_HW_BREAKPOINT
+	select PERF_EVENTS
 	default y
 	help
 	  Hardware breakpoints are a feature implemented by most CPUs
-- 
1.7.5.4

