Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751Ab0HSQKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 12:10:49 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:57631 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab0HSQKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 12:10:46 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Aug 2010 12:10:45 EDT
Date: Thu, 19 Aug 2010 18:05:43 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        uClinux list <uclinux-dev@uclinux.org>
Subject: [PATCH] m68k,m68knommu: Wire up fanotify_init, fanotify_mark, and
 prlimit64
Message-ID: <alpine.DEB.2.00.1008191804480.16652@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/unistd.h       |    5 ++++-
 arch/m68k/kernel/entry.S             |    3 +++
 arch/m68knommu/kernel/syscalltable.S |    3 +++
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
index 60b15d0..b43b36b 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -340,10 +340,13 @@
 #define __NR_set_thread_area	334
 #define __NR_atomic_cmpxchg_32	335
 #define __NR_atomic_barrier	336
+#define __NR_fanotify_init	337
+#define __NR_fanotify_mark	338
+#define __NR_prlimit64		339
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		337
+#define NR_syscalls		340
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
index 2391bdf..6360c43 100644
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -765,4 +765,7 @@ sys_call_table:
 	.long sys_set_thread_area
 	.long sys_atomic_cmpxchg_32	/* 335 */
 	.long sys_atomic_barrier
+	.long sys_fanotify_init
+	.long sys_fanotify_mark
+	.long sys_prlimit64
 
diff --git a/arch/m68knommu/kernel/syscalltable.S b/arch/m68knommu/kernel/syscalltable.S
index b30b3eb..79b1ed1 100644
--- a/arch/m68knommu/kernel/syscalltable.S
+++ b/arch/m68knommu/kernel/syscalltable.S
@@ -355,6 +355,9 @@ ENTRY(sys_call_table)
 	.long sys_set_thread_area
 	.long sys_atomic_cmpxchg_32	/* 335 */
 	.long sys_atomic_barrier
+	.long sys_fanotify_init
+	.long sys_fanotify_mark
+	.long sys_prlimit64
 
 	.rept NR_syscalls-(.-sys_call_table)/4
 		.long sys_ni_syscall
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
