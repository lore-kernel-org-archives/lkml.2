Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791Ab1CWMfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:35:37 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:46297 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770Ab1CWMfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:35:33 -0400
Date: Wed, 23 Mar 2011 13:35:31 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@uclinux.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
        uClinux list <uclinux-dev@uclinux.org>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] m68k,m68knommu: Wire up syncfs
Message-ID: <alpine.DEB.2.00.1103231334450.21922@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
To be folded with the previous one.

 arch/m68k/include/asm/unistd.h       |    3 ++-
 arch/m68k/kernel/entry.S             |    1 +
 arch/m68knommu/kernel/syscalltable.S |    1 +
 3 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
index f69f7ce..29e1790 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -346,10 +346,11 @@
 #define __NR_name_to_handle_at	340
 #define __NR_open_by_handle_at	341
 #define __NR_clock_adjtime	342
+#define __NR_syncfs		343
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		343
+#define NR_syscalls		344
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
index 8f9524a..1359ee6 100644
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -753,4 +753,5 @@ sys_call_table:
 	.long sys_name_to_handle_at	/* 340 */
 	.long sys_open_by_handle_at
 	.long sys_clock_adjtime
+	.long sys_syncfs
 
diff --git a/arch/m68knommu/kernel/syscalltable.S b/arch/m68knommu/kernel/syscalltable.S
index 605bbbe..9b8393d 100644
--- a/arch/m68knommu/kernel/syscalltable.S
+++ b/arch/m68knommu/kernel/syscalltable.S
@@ -361,6 +361,7 @@ ENTRY(sys_call_table)
 	.long sys_name_to_handle_at	/* 340 */
 	.long sys_open_by_handle_at
 	.long sys_clock_adjtime
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
