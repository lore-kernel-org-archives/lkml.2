Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab0H0JsY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:48:24 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57960 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab0H0Jny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=JWuUhpbAHdcy9MdQkLw1JUjRdxHNAwUc6SeekYSRnY/K66MU/zN3n2Pr8JAoBqRBjd
         GrmJQvNIWuXrl65GQ6eLv+Yl1+0uPGe/6g2f4ke/BCaiR4cRC9HdJt0ac7+NMQkPH2vp
         fFzjSI+El0tWe8T7likq/PJKLFZp/dB7nf2dQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Hirokazu Takata <takata@linux-m32r.org>
Subject: [RFC PATCH 20/43] ptrace, m32r: cleanup arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:06 +0900
Message-Id: <1282902149-12991-21-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use new 'datap' variable in order to remove duplicated castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/kernel/ptrace.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/m32r/kernel/ptrace.c b/arch/m32r/kernel/ptrace.c
index 69bbf7a..fc93e8d 100644
--- a/arch/m32r/kernel/ptrace.c
+++ b/arch/m32r/kernel/ptrace.c
@@ -625,6 +625,7 @@ arch_ptrace(struct task_struct *child, long request,
 	    unsigned long addr, unsigned long data)
 {
 	int ret;
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
 	/*
@@ -639,8 +640,7 @@ arch_ptrace(struct task_struct *child, long request,
 	 * read the word at location addr in the USER area.
 	 */
 	case PTRACE_PEEKUSR:
-		ret = ptrace_read_user(child, addr,
-				       (unsigned long __user *)data);
+		ret = ptrace_read_user(child, addr, datap);
 		break;
 
 	/*
@@ -661,11 +661,11 @@ arch_ptrace(struct task_struct *child, long request,
 		break;
 
 	case PTRACE_GETREGS:
-		ret = ptrace_getregs(child, (void __user *)data);
+		ret = ptrace_getregs(child, datap);
 		break;
 
 	case PTRACE_SETREGS:
-		ret = ptrace_setregs(child, (void __user *)data);
+		ret = ptrace_setregs(child, datap);
 		break;
 
 	default:
-- 
1.7.2.2

