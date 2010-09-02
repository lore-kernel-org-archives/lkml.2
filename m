Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab0IBPrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:47:32 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57177 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab0IBPr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gaPTV5uHADfxsfqVJjCpBFlj585SD2Zm/ELc5L4MsQdP2lu3It0Xezvf7ByJh0XizY
         Sygk0jDmx2UzEZu976JhZMOQpBSG3El6qydKaz18ndGsOFlSC9TxAhIFkVWfpXa7n5jc
         ESY8ZuWtXFODPPiJT2E/2KEWDn2iG3Ljahaac=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH v2 07/24] ptrace: cleanup arch_ptrace() and friends on Blackfin
Date: Fri,  3 Sep 2010 00:46:14 +0900
Message-Id: <1283442391-23612-8-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change signature of get/put_reg() according to the change of arch_ptrace()
and remove unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/ptrace.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/blackfin/kernel/ptrace.c b/arch/blackfin/kernel/ptrace.c
index fb81620..545fc14 100644
--- a/arch/blackfin/kernel/ptrace.c
+++ b/arch/blackfin/kernel/ptrace.c
@@ -37,12 +37,13 @@
  * Get contents of register REGNO in task TASK.
  */
 static inline long
-get_reg(struct task_struct *task, long regno, unsigned long __user *datap)
+get_reg(struct task_struct *task, unsigned long regno,
+	unsigned long __user *datap)
 {
 	long tmp;
 	struct pt_regs *regs = task_pt_regs(task);
 
-	if (regno & 3 || regno > PT_LAST_PSEUDO || regno < 0)
+	if (regno & 3 || regno > PT_LAST_PSEUDO)
 		return -EIO;
 
 	switch (regno) {
@@ -73,11 +74,11 @@ get_reg(struct task_struct *task, long regno, unsigned long __user *datap)
  * Write contents of register REGNO in task TASK.
  */
 static inline int
-put_reg(struct task_struct *task, long regno, unsigned long data)
+put_reg(struct task_struct *task, unsigned long regno, unsigned long data)
 {
 	struct pt_regs *regs = task_pt_regs(task);
 
-	if (regno & 3 || regno > PT_LAST_PSEUDO || regno < 0)
+	if (regno & 3 || regno > PT_LAST_PSEUDO)
 		return -EIO;
 
 	switch (regno) {
@@ -361,14 +362,14 @@ long arch_ptrace(struct task_struct *child, long request,
 		return copy_regset_to_user(child, &user_bfin_native_view,
 					   REGSET_GENERAL,
 					   0, sizeof(struct pt_regs),
-					   (void __user *)data);
+					   datap);
 
 	case PTRACE_SETREGS:
 		pr_debug("ptrace: PTRACE_SETREGS\n");
 		return copy_regset_from_user(child, &user_bfin_native_view,
 					     REGSET_GENERAL,
 					     0, sizeof(struct pt_regs),
-					     (const void __user *)data);
+					     datap);
 
 	case_default:
 	default:
-- 
1.7.2.2

