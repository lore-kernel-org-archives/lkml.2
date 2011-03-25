Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1CYVqB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 17:46:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:33719 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab1CYVpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 17:45:02 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/4] kgdb,x86_64: fix compile warning found with sparse
Date: Fri, 25 Mar 2011 16:44:19 -0500
Message-Id: <1301089460-1936-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301089460-1936-1-git-send-email-jason.wessel@windriver.com>
References: <1301089460-1936-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 25 Mar 2011 21:44:23.0426 (UTC) FILETIME=[CE211620:01CBEB35]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning:

arch/x86/kernel/kgdb.c:123:9: warning: switch with no cases

Reported-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index a413000..3c2fb0f 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -121,8 +121,8 @@ char *dbg_get_reg(int regno, void *mem, struct pt_regs *regs)
 		memcpy(mem, (void *)regs + dbg_reg_def[regno].offset,
 		       dbg_reg_def[regno].size);
 
-	switch (regno) {
 #ifdef CONFIG_X86_32
+	switch (regno) {
 	case GDB_SS:
 		if (!user_mode_vm(regs))
 			*(unsigned long *)mem = __KERNEL_DS;
@@ -135,8 +135,8 @@ char *dbg_get_reg(int regno, void *mem, struct pt_regs *regs)
 	case GDB_FS:
 		*(unsigned long *)mem = 0xFFFF;
 		break;
-#endif
 	}
+#endif
 	return dbg_reg_def[regno].name;
 }
 
-- 
1.7.1

