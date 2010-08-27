Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab0H0JrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:47:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33242 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646Ab0H0JoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:44:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=BXqwabgeDMQJBlxXMtZASoiSvaLfJB/H3QoOKNJHL+AFarzz3wWUE2W59ODrVzckPt
         jIvAzS1D6hXED3XwInZBQDIYHByQOCaLD+2zynEuyGytHqYFmQeF8dZeWmQROmQEbQjW
         5+KTfEMB8tkN2FJV/68mkZsbesUk1nnUFUNTs=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: [RFC PATCH 29/43] ptrace, mn10300: cleanup arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:15 +0900
Message-Id: <1282902149-12991-30-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use new 'datap' variable in order to remove unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
---
 arch/mn10300/kernel/ptrace.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/mn10300/kernel/ptrace.c b/arch/mn10300/kernel/ptrace.c
index 4261810..5c0b07e 100644
--- a/arch/mn10300/kernel/ptrace.c
+++ b/arch/mn10300/kernel/ptrace.c
@@ -300,6 +300,7 @@ long arch_ptrace(struct task_struct *child, long request,
 {
 	unsigned long tmp;
 	int ret;
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
 	/* read the word at location addr in the USER area. */
@@ -312,7 +313,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		if (addr < NR_PTREGS << 2)
 			tmp = get_stack_long(child,
 					     ptrace_regid_to_frame[addr]);
-		ret = put_user(tmp, (unsigned long *) data);
+		ret = put_user(tmp, datap);
 		break;
 
 		/* write the word at location addr in the USER area */
@@ -331,25 +332,25 @@ long arch_ptrace(struct task_struct *child, long request,
 		return copy_regset_to_user(child, &user_mn10300_native_view,
 					   REGSET_GENERAL,
 					   0, NR_PTREGS * sizeof(long),
-					   (void __user *)data);
+					   datap);
 
 	case PTRACE_SETREGS:	/* Set all integer regs in the child. */
 		return copy_regset_from_user(child, &user_mn10300_native_view,
 					     REGSET_GENERAL,
 					     0, NR_PTREGS * sizeof(long),
-					     (const void __user *)data);
+					     datap);
 
 	case PTRACE_GETFPREGS:	/* Get the child FPU state. */
 		return copy_regset_to_user(child, &user_mn10300_native_view,
 					   REGSET_FPU,
 					   0, sizeof(struct fpu_state_struct),
-					   (void __user *)data);
+					   datap);
 
 	case PTRACE_SETFPREGS:	/* Set the child FPU state. */
 		return copy_regset_from_user(child, &user_mn10300_native_view,
 					     REGSET_FPU,
 					     0, sizeof(struct fpu_state_struct),
-					     (const void __user *)data);
+					     datap);
 
 	default:
 		ret = ptrace_request(child, request, addr, data);
-- 
1.7.2.2

