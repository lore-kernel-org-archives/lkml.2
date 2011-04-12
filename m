Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab1DLUYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 16:24:53 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:49603 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062Ab1DLUYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 16:24:51 -0400
Date: Tue, 12 Apr 2011 22:24:45 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
cc: Greg Ungerer <gerg@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
Subject: [PATCH] m68k,m68knommu: Wire up name_to_handle_at, open_by_handle_at,
 clock_adjtime, syncfs
Message-ID: <alpine.DEB.2.00.1104122223020.28301@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Greg Ungerer <gerg@uclinux.org>
---
 arch/m68k/include/asm/unistd.h  |    6 +++++-
 arch/m68k/kernel/entry_mm.S     |    4 ++++
 arch/m68k/kernel/syscalltable.S |    4 ++++
 3 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
index 26d851d..29e1790 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -343,10 +343,14 @@
 #define __NR_fanotify_init	337
 #define __NR_fanotify_mark	338
 #define __NR_prlimit64		339
+#define __NR_name_to_handle_at	340
+#define __NR_open_by_handle_at	341
+#define __NR_clock_adjtime	342
+#define __NR_syncfs		343
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		340
+#define NR_syscalls		344
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/m68k/kernel/entry_mm.S b/arch/m68k/kernel/entry_mm.S
index 1559dea..1359ee6 100644
--- a/arch/m68k/kernel/entry_mm.S
+++ b/arch/m68k/kernel/entry_mm.S
@@ -750,4 +750,8 @@ sys_call_table:
 	.long sys_fanotify_init
 	.long sys_fanotify_mark
 	.long sys_prlimit64
+	.long sys_name_to_handle_at	/* 340 */
+	.long sys_open_by_handle_at
+	.long sys_clock_adjtime
+	.long sys_syncfs
 
diff --git a/arch/m68k/kernel/syscalltable.S b/arch/m68k/kernel/syscalltable.S
index 79b1ed1..9b8393d 100644
--- a/arch/m68k/kernel/syscalltable.S
+++ b/arch/m68k/kernel/syscalltable.S
@@ -358,6 +358,10 @@ ENTRY(sys_call_table)
 	.long sys_fanotify_init
 	.long sys_fanotify_mark
 	.long sys_prlimit64
+	.long sys_name_to_handle_at	/* 340 */
+	.long sys_open_by_handle_at
+	.long sys_clock_adjtime
+	.long sys_syncfs
 
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
