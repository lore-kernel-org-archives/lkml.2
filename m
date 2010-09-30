Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab0I3J2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:28:42 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:32949 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab0I3J2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:28:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fVgdLIGYVDEk3OqlE1BXGYyM84ENyqj4tbAUtp+yL6dbdaep0a6dQZoVFZBRdjBBdv
         R9sIwh902b7ly7u+Zso7aqmKRGOOE/l3M5RMiYrFEKQH8exYDL6+YnbTIK2gVlUQEnFM
         pjM+bQyPczLnXauwptXjI9uxJ/PGGOV+UHcA0=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH RESEND v3 05/24] ptrace: cleanup arch_ptrace() on ARM
Date: Thu, 30 Sep 2010 18:27:40 +0900
Message-Id: <1285838880-4977-6-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use new 'datap' variable in order to remove unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
---
 arch/arm/kernel/ptrace.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 87ca2c7..9dfb40a 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -851,10 +851,11 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
 		case PTRACE_PEEKUSR:
-			ret = ptrace_read_user(child, addr, (unsigned long __user *)data);
+			ret = ptrace_read_user(child, addr, datap);
 			break;
 
 		case PTRACE_POKEUSR:
@@ -862,34 +863,34 @@ long arch_ptrace(struct task_struct *child, long request,
 			break;
 
 		case PTRACE_GETREGS:
-			ret = ptrace_getregs(child, (void __user *)data);
+			ret = ptrace_getregs(child, datap);
 			break;
 
 		case PTRACE_SETREGS:
-			ret = ptrace_setregs(child, (void __user *)data);
+			ret = ptrace_setregs(child, datap);
 			break;
 
 		case PTRACE_GETFPREGS:
-			ret = ptrace_getfpregs(child, (void __user *)data);
+			ret = ptrace_getfpregs(child, datap);
 			break;
 		
 		case PTRACE_SETFPREGS:
-			ret = ptrace_setfpregs(child, (void __user *)data);
+			ret = ptrace_setfpregs(child, datap);
 			break;
 
 #ifdef CONFIG_IWMMXT
 		case PTRACE_GETWMMXREGS:
-			ret = ptrace_getwmmxregs(child, (void __user *)data);
+			ret = ptrace_getwmmxregs(child, datap);
 			break;
 
 		case PTRACE_SETWMMXREGS:
-			ret = ptrace_setwmmxregs(child, (void __user *)data);
+			ret = ptrace_setwmmxregs(child, datap);
 			break;
 #endif
 
 		case PTRACE_GET_THREAD_AREA:
 			ret = put_user(task_thread_info(child)->tp_value,
-				       (unsigned long __user *) data);
+				       datap);
 			break;
 
 		case PTRACE_SET_SYSCALL:
@@ -899,21 +900,21 @@ long arch_ptrace(struct task_struct *child, long request,
 
 #ifdef CONFIG_CRUNCH
 		case PTRACE_GETCRUNCHREGS:
-			ret = ptrace_getcrunchregs(child, (void __user *)data);
+			ret = ptrace_getcrunchregs(child, datap);
 			break;
 
 		case PTRACE_SETCRUNCHREGS:
-			ret = ptrace_setcrunchregs(child, (void __user *)data);
+			ret = ptrace_setcrunchregs(child, datap);
 			break;
 #endif
 
 #ifdef CONFIG_VFP
 		case PTRACE_GETVFPREGS:
-			ret = ptrace_getvfpregs(child, (void __user *)data);
+			ret = ptrace_getvfpregs(child, datap);
 			break;
 
 		case PTRACE_SETVFPREGS:
-			ret = ptrace_setvfpregs(child, (void __user *)data);
+			ret = ptrace_setvfpregs(child, datap);
 			break;
 #endif
 
-- 
1.7.2.2

