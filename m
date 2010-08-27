Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab0H0JpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:45:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33242 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754908Ab0H0JpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:45:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=giW9US10a2eNPruzzPoyYeEhLqw25ztiKdNwBgWdEfDOGRcVlXq6+puqd0v+mBgRWg
         0A918xw0VyIBNxbltdKJP9WQbj5TXsa3MJCDvwgOKf6QEkmsZSwhKrxGVqHXaaGuWM2Y
         Fql2K5XPI8s6FKHs2G4fGMwhzFT6y1Sr5hQ5Q=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Chris Zankel <chris@zankel.net>
Subject: [RFC PATCH 43/43] ptrace, xtensa: cleanup arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:29 +0900
Message-Id: <1282902149-12991-44-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use new 'datap' variable in order to remove unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Chris Zankel <chris@zankel.net>
---
 arch/xtensa/kernel/ptrace.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/xtensa/kernel/ptrace.c b/arch/xtensa/kernel/ptrace.c
index af9ba80..c72c947 100644
--- a/arch/xtensa/kernel/ptrace.c
+++ b/arch/xtensa/kernel/ptrace.c
@@ -260,6 +260,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	int ret = -EPERM;
+	void __user *datap = (void __user *) data;
 
 	switch (request) {
 	case PTRACE_PEEKTEXT:	/* read word at location addr. */
@@ -268,7 +269,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		break;
 
 	case PTRACE_PEEKUSR:	/* read register specified by addr. */
-		ret = ptrace_peekusr(child, addr, (void __user *) data);
+		ret = ptrace_peekusr(child, addr, datap);
 		break;
 
 	case PTRACE_POKETEXT:	/* write the word at location addr. */
@@ -281,19 +282,19 @@ long arch_ptrace(struct task_struct *child, long request,
 		break;
 
 	case PTRACE_GETREGS:
-		ret = ptrace_getregs(child, (void __user *) data);
+		ret = ptrace_getregs(child, datap);
 		break;
 
 	case PTRACE_SETREGS:
-		ret = ptrace_setregs(child, (void __user *) data);
+		ret = ptrace_setregs(child, datap);
 		break;
 
 	case PTRACE_GETXTREGS:
-		ret = ptrace_getxregs(child, (void __user *) data);
+		ret = ptrace_getxregs(child, datap);
 		break;
 
 	case PTRACE_SETXTREGS:
-		ret = ptrace_setxregs(child, (void __user *) data);
+		ret = ptrace_setxregs(child, datap);
 		break;
 
 	default:
-- 
1.7.2.2

