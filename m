Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769Ab1EXVwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:52:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43933 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab1EXVwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:52:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XIKFoz06cCWZBNEupy2nAjbACABv03WZLmgsrGon1WffhIYG99cngXCTsG58iERmB9
         i3fy1P5lP1V4hg8pL6noxKWaAgcLqNnyPrYHaK2x8WabPmbekf+CZqBvd4eTZE34ulQq
         JkklR1+0NqaaxB4RJh3wUBSDY/f71ca8esnIM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 5/6] hw_breakpoints: Only force perf events if breakpoints are selected
Date: Tue, 24 May 2011 23:52:26 +0200
Message-Id: <1306273947-8410-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1306273947-8410-1-git-send-email-fweisbec@gmail.com>
References: <1306273947-8410-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, arch were forced to always build perf events if they
supported hw_breakpoints.

Now that the user can choose not to build hw_breakpoints, let
only force perf events if hw_breakpoints are selected.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/Kconfig  |    1 -
 arch/x86/Kconfig |    1 -
 init/Kconfig     |    1 +
 3 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index 0d4d124..d59e6c2 100644
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
index fb28dd9..5317f42 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -55,7 +55,6 @@ config X86
 	select HAVE_KERNEL_LZO
 	select HAVE_HW_BREAKPOINT
 	select HAVE_MIXED_BREAKPOINTS_REGS
-	select PERF_EVENTS
 	select HAVE_PERF_EVENTS_NMI
 	select ANON_INODES
 	select HAVE_ARCH_KMEMCHECK
diff --git a/init/Kconfig b/init/Kconfig
index 76ae53e..9ae3555 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -927,6 +927,7 @@ menuconfig EXPERT
 config HW_BREAKPOINT
 	bool "Hardware breakpoints" if EXPERT
 	depends on HAVE_HW_BREAKPOINT
+	select PERF_EVENTS
 	default y
 	help
 	  Hardware breakpoints are a feature implemented by most CPUs
-- 
1.7.3.2

