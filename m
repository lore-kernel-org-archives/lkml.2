Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab2JRRc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:32:27 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:52450 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab2JRRcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:32:25 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Greg Ungerer <gerg@uclinux.org>, linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: Wire up kcmp
Date: Thu, 18 Oct 2012 19:32:15 +0200
Message-Id: <1350581535-29428-1-git-send-email-geert@linux-m68k.org>
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
index c004dfd..5fc7f7b 100644
--- a/arch/m68k/include/asm/unistd.h
+++ b/arch/m68k/include/asm/unistd.h
@@ -4,7 +4,7 @@
 #include <uapi/asm/unistd.h>
 
 
-#define NR_syscalls		347
+#define NR_syscalls		348
 
 #define __ARCH_WANT_OLD_READDIR
 #define __ARCH_WANT_OLD_STAT
diff --git a/arch/m68k/include/uapi/asm/unistd.h b/arch/m68k/include/uapi/asm/unistd.h
index fdeb341..b94bfbf 100644
--- a/arch/m68k/include/uapi/asm/unistd.h
+++ b/arch/m68k/include/uapi/asm/unistd.h
@@ -352,5 +352,6 @@
 #define __NR_setns		344
 #define __NR_process_vm_readv	345
 #define __NR_process_vm_writev	346
+#define __NR_kcmp		347
 
 #endif /* _UAPI_ASM_M68K_UNISTD_H_ */
diff --git a/arch/m68k/kernel/syscalltable.S b/arch/m68k/kernel/syscalltable.S
index ce827b3..4fc2e29 100644
--- a/arch/m68k/kernel/syscalltable.S
+++ b/arch/m68k/kernel/syscalltable.S
@@ -367,4 +367,5 @@ ENTRY(sys_call_table)
 	.long sys_setns
 	.long sys_process_vm_readv	/* 345 */
 	.long sys_process_vm_writev
+	.long sys_kcmp
 
-- 
1.7.0.4

