Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab0DCKsO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 06:48:14 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:50148 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab0DCKrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 06:47:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gVYduXjF5hxPXevIRgzhFmgw/yt+Xs+Qy/pBkfVHwUSg5VjpGjebMjUjOUfaLhI6Zi
         TT7difO6kzSM4X16WfKoUaR82nDeg/4ajHZKQybBd8xmf9nxCGuzADT8S/V++d76PkkE
         bnNb5548O3krA/PHdleGkL8Gt3SqyLFQsPYc8=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Michael Ellerman <michael@ellerman.id.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] perf: Always build the powerpc perf_arch_fetch_caller_regs version
Date: Sat,  3 Apr 2010 12:47:39 +0200
Message-Id: <1270291659-6299-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1270291659-6299-1-git-send-regression-fweisbec@gmail.com>
References: <1270291659-6299-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that software events use perf_arch_fetch_caller_regs() too, we
need the powerpc version to be always built.

Fixes the following build error:

	(.text+0x3210): undefined reference to `perf_arch_fetch_caller_regs'
	(.text+0x3324): undefined reference to `perf_arch_fetch_caller_regs'
	(.text+0x33bc): undefined reference to `perf_arch_fetch_caller_regs'
	(.text+0x33ec): undefined reference to `perf_arch_fetch_caller_regs'
	(.text+0xd4a0): undefined reference to `perf_arch_fetch_caller_regs'
	arch/powerpc/kernel/built-in.o:(.text+0xd528): more undefined references to `perf_arch_fetch_caller_regs' follow
	make[1]: *** [.tmp_vmlinux1] Error 1
	make: *** [sub-make] Error 2

Reported-by: Michael Ellerman <michael@ellerman.id.au>
Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/kernel/misc.S |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/misc.S b/arch/powerpc/kernel/misc.S
index b485a87..22e507c 100644
--- a/arch/powerpc/kernel/misc.S
+++ b/arch/powerpc/kernel/misc.S
@@ -128,7 +128,6 @@ _GLOBAL(__restore_cpu_power7)
 	/* place holder */
 	blr
 
-#ifdef CONFIG_EVENT_TRACING
 /*
  * Get a minimal set of registers for our caller's nth caller.
  * r3 = regs pointer, r5 = n.
@@ -154,4 +153,3 @@ _GLOBAL(perf_arch_fetch_caller_regs)
 	PPC_STL	r4,_NIP-STACK_FRAME_OVERHEAD(r3)
 	PPC_STL	r7,_LINK-STACK_FRAME_OVERHEAD(r3)
 	blr
-#endif /* CONFIG_EVENT_TRACING */
-- 
1.6.2.3

