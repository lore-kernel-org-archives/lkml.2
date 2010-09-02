Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab0IBPtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:49:04 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38427 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab0IBPtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:49:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=J/tCGNh1fzY1JVszjpr6zca+sT7YTCqyYjiGI3HeyDhp5uuRwJIuppRHwGzb+zk++t
         7xe1A42i8GxJefrTqMGBlU75HwceaguB+VsJXR1+dneaNSbcx0resboUl0atuSGMQpMd
         D0X3nDVwIiJ0GWo0POr2c9RXLVLvh38EUwDaM=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Chris Zankel <chris@zankel.net>
Subject: [PATCH v2 24/24] ptrace: cleanup arch_ptrace() on xtensa
Date: Fri,  3 Sep 2010 00:46:31 +0900
Message-Id: <1283442391-23612-25-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new 'datap' variable in order to remove unnecessary castings.

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

