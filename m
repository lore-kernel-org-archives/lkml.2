Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab1GNPEo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 11:04:44 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34156 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab1GNPET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 11:04:19 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 6/6] hw_breakpoints: Drop remaining misplaced dependency on perf
Date: Thu, 14 Jul 2011 17:03:57 +0200
Message-Id: <1310655837-328-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1310655837-328-1-git-send-email-fweisbec@gmail.com>
References: <1310655837-328-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Powerpc and Arm select breakpoint support ability only if
Perf is built. This is not necessary anymore now that we
enable perf once breakpoints support is selected.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/arm/Kconfig     |    2 +-
 arch/powerpc/Kconfig |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 9adc278..0739521 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -24,7 +24,7 @@ config ARM
 	select HAVE_PERF_EVENTS
 	select PERF_USE_VMALLOC
 	select HAVE_REGS_AND_STACK_ACCESS_API
-	select HAVE_HW_BREAKPOINT if (PERF_EVENTS && (CPU_V6 || CPU_V6K || CPU_V7))
+	select HAVE_HW_BREAKPOINT if (CPU_V6 || CPU_V6K || CPU_V7)
 	select HAVE_C_RECORDMCOUNT
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 2729c66..26beb98 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -126,7 +126,7 @@ config PPC
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
-	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
+	select HAVE_HW_BREAKPOINT if PPC_BOOK3S_64
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
 	select IRQ_PER_CPU
-- 
1.7.5.4

