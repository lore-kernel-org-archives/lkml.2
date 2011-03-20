Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab1CTMLe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 08:11:34 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:50447 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab1CTMLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 08:11:31 -0400
Date: Sun, 20 Mar 2011 13:11:28 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>, Greg Ungerer <gerg@uclinux.org>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        uClinux list <uclinux-dev@uclinux.org>
Message-ID: <alpine.DEB.2.00.1103201310110.6574@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Followup-To: [PATCH] m68k,m68knommu: Wire up name_to_handle_at, open_by_handle_at, clock_adjtime
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
index 26d851d..f69f7ce 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -343,10 +343,13 @@
 #define __NR_fanotify_init	337
 #define __NR_fanotify_mark	338
 #define __NR_prlimit64		339
+#define __NR_name_to_handle_at	340
+#define __NR_open_by_handle_at	341
+#define __NR_clock_adjtime	342
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		340
+#define NR_syscalls		343
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
index 1559dea..8f9524a 100644
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -750,4 +750,7 @@ sys_call_table:
 	.long sys_fanotify_init
 	.long sys_fanotify_mark
 	.long sys_prlimit64
+	.long sys_name_to_handle_at	/* 340 */
+	.long sys_open_by_handle_at
+	.long sys_clock_adjtime
 
diff --git a/arch/m68knommu/kernel/syscalltable.S b/arch/m68knommu/kernel/syscalltable.S
index 79b1ed1..605bbbe 100644
--- a/arch/m68knommu/kernel/syscalltable.S
+++ b/arch/m68knommu/kernel/syscalltable.S
@@ -358,6 +358,9 @@ ENTRY(sys_call_table)
 	.long sys_fanotify_init
 	.long sys_fanotify_mark
 	.long sys_prlimit64
+	.long sys_name_to_handle_at	/* 340 */
+	.long sys_open_by_handle_at
+	.long sys_clock_adjtime
 
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
