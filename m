Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab1KTVK1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 16:10:27 -0500
Received: from brigitte.telenet-ops.be ([195.130.137.66]:60298 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab1KTVKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 16:10:24 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: Wire up process_vm_{read,write}v
Date: Sun, 20 Nov 2011 22:10:20 +0100
Message-Id: <1321823420-14893-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/unistd.h  |    4 +++-
 arch/m68k/kernel/syscalltable.S |    2 ++
 2 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
index d97234b..ea0b502 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -350,10 +350,12 @@
 #define __NR_clock_adjtime	342
 #define __NR_syncfs		343
 #define __NR_setns		344
+#define __NR_process_vm_readv	345
+#define __NR_process_vm_writev	346
 
 #ifdef __KERNEL__
 
-#define NR_syscalls		345
+#define NR_syscalls		347
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/m68k/kernel/syscalltable.S b/arch/m68k/kernel/syscalltable.S
index c468f2e..ce827b3 100644
--- a/arch/m68k/kernel/syscalltable.S
+++ b/arch/m68k/kernel/syscalltable.S
@@ -365,4 +365,6 @@ ENTRY(sys_call_table)
 	.long sys_clock_adjtime
 	.long sys_syncfs
 	.long sys_setns
+	.long sys_process_vm_readv	/* 345 */
+	.long sys_process_vm_writev
 
-- 
1.7.0.4

