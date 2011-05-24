Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835Ab1EXVxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:53:41 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48960 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933697Ab1EXVwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:52:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=T1bccwZylN2ebv6SAWmZjBF8kL2k1fmofwVTMkCYaIY4H7y5VuZDYAa/KhUScIk+Ss
         qd9r1LOag7QNi+1mv7Vu8TqJJB1YCt/kEKz/YXm1t+FUYQ72Rh6j4/kltbOSD5Up1CJr
         YvDrE/r7pxRtPn9Ew9hoCRF9v1sFAzcSwhOKc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 6/6] hw_breakpoints: Drop remaining misplaced dependency on perf
Date: Tue, 24 May 2011 23:52:27 +0200
Message-Id: <1306273947-8410-7-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1306273947-8410-1-git-send-email-fweisbec@gmail.com>
References: <1306273947-8410-1-git-send-email-fweisbec@gmail.com>
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
index 377a7a5..1d3a0b4 100644
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
index 8f4d50b..e944eb8 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -134,7 +134,7 @@ config PPC
 	select HAVE_IRQ_WORK
 	select HAVE_PERF_EVENTS
 	select HAVE_REGS_AND_STACK_ACCESS_API
-	select HAVE_HW_BREAKPOINT if PERF_EVENTS && PPC_BOOK3S_64
+	select HAVE_HW_BREAKPOINT if PPC_BOOK3S_64
 	select HAVE_GENERIC_HARDIRQS
 	select HAVE_SPARSE_IRQ
 	select IRQ_PER_CPU
-- 
1.7.3.2

