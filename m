Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab0DSVx1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 17:53:27 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:45972 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab0DSVxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 17:53:22 -0400
From: Jan Kiszka <jan.kiszka@web.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
       Jeff Dike <jdike@addtoit.com>
Subject: [PATCH 4/5] uml: i386: Avoid redefinition of NR_syscalls
Date: Mon, 19 Apr 2010 23:53:07 +0200
Message-Id: <3e07ad1a38e88a22d7298deb88a8f3962b101998.1271713955.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1271713955.git.jan.kiszka@web.de>
References: <cover.1271713955.git.jan.kiszka@web.de>
In-Reply-To: <cover.1271713955.git.jan.kiszka@web.de>
References: <cover.1271713955.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX18kH+PHNixFwvODFWcBEj+OEezXsyGU/i6qu6sS
	uwBrUWGih889uXWkuNo/AQ356Kx0hOe86dhqcqkTYllfNoDEjz
	lir/VbDtI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i386 subarch happens to pull in original NR_syscalls. Maybe we can
make that work for all host arch, but for now just avoid the clash by
using an all-upper-case name.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 arch/um/kernel/skas/syscall.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/kernel/skas/syscall.c b/arch/um/kernel/skas/syscall.c
index 4e3b820..f5173e1 100644
--- a/arch/um/kernel/skas/syscall.c
+++ b/arch/um/kernel/skas/syscall.c
@@ -10,7 +10,7 @@
 #include "sysdep/syscalls.h"
 
 extern int syscall_table_size;
-#define NR_syscalls (syscall_table_size / sizeof(void *))
+#define NR_SYSCALLS (syscall_table_size / sizeof(void *))
 
 void handle_syscall(struct uml_pt_regs *r)
 {
@@ -30,7 +30,7 @@ void handle_syscall(struct uml_pt_regs *r)
 	 * in case it's a compiler bug.
 	 */
 	syscall = UPT_SYSCALL_NR(r);
-	if ((syscall >= NR_syscalls) || (syscall < 0))
+	if ((syscall >= NR_SYSCALLS) || (syscall < 0))
 		result = -ENOSYS;
 	else result = EXECUTE_SYSCALL(syscall, regs);
 
-- 
1.6.0.2

