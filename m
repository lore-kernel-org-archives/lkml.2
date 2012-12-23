Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab2LWJaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 04:30:13 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:57015 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab2LWJaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 04:30:06 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: Wire up finit_module
Date: Sun, 23 Dec 2012 10:29:58 +0100
Message-Id: <1356254998-13380-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/unistd.h      |    2 +-
 arch/m68k/include/uapi/asm/unistd.h |    1 +
 arch/m68k/kernel/syscalltable.S     |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/m68k/include/asm/unistd.h b/arch/m68k/include/asm/unistd.h
index 847994c..f9337f6 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -4,7 +4,7 @@
 #include <uapi/asm/unistd.h>
 
 
-#define NR_syscalls		348
+#define NR_syscalls		349
 
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
diff --git a/arch/m68k/include/uapi/asm/unistd.h b/arch/m68k/include/uapi/asm/unistd.h
index b94bfbf..625f321 100644
--- a/arch/m68k/include/uapi/asm/unistd.h
+++ b/arch/m68k/include/uapi/asm/unistd.h
@@ -353,5 +353,6 @@
 #define __NR_process_vm_readv	345
 #define __NR_process_vm_writev	346
 #define __NR_kcmp		347
+#define __NR_finit_module	348
 
 #endif /* _UAPI_ASM_M68K_UNISTD_H_ */
diff --git a/arch/m68k/kernel/syscalltable.S b/arch/m68k/kernel/syscalltable.S
index c30da5b..3f04ea0 100644
--- a/arch/m68k/kernel/syscalltable.S
+++ b/arch/m68k/kernel/syscalltable.S
@@ -368,4 +368,5 @@ ENTRY(sys_call_table)
 	.long sys_process_vm_readv	/* 345 */
 	.long sys_process_vm_writev
 	.long sys_kcmp
+	.long sys_finit_module
 
-- 
1.7.0.4

