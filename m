Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab0I3J2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:28:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:32949 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366Ab0I3J2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:28:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aJoqgO2hhe9CGs8fP78tpSLauIKY0E9csJpowrpFZJ2C2i53wQ/la3/DEhuXUQPi/a
         mcaBRmY66Vnojw0gIn0lCdJbDh8pUZCHy0fAk5YHkHlhoy5fMSidQZmagUBGk1vz389C
         YIIy548t2Zt3JJuXNLZxXjVNexPd6XS2UdkWo=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND v3 06/24] ptrace: cleanup arch_ptrace() on avr32
Date: Thu, 30 Sep 2010 18:27:41 +0900
Message-Id: <1285838880-4977-7-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use new 'datap' variable type of void pointer in order to remove unnecessary
castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 arch/avr32/kernel/ptrace.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/avr32/kernel/ptrace.c b/arch/avr32/kernel/ptrace.c
index ecea9b6..4aedcab 100644
--- a/arch/avr32/kernel/ptrace.c
+++ b/arch/avr32/kernel/ptrace.c
@@ -150,6 +150,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	void __user *datap = (void __user *) data;
 
 	switch (request) {
 	/* Read the word at location addr in the child process */
@@ -159,8 +160,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		break;
 
 	case PTRACE_PEEKUSR:
-		ret = ptrace_read_user(child, addr,
-				       (unsigned long __user *)data);
+		ret = ptrace_read_user(child, addr, datap);
 		break;
 
 	/* Write the word in data at location addr */
@@ -174,11 +174,11 @@ long arch_ptrace(struct task_struct *child, long request,
 		break;
 
 	case PTRACE_GETREGS:
-		ret = ptrace_getregs(child, (void __user *)data);
+		ret = ptrace_getregs(child, datap);
 		break;
 
 	case PTRACE_SETREGS:
-		ret = ptrace_setregs(child, (const void __user *)data);
+		ret = ptrace_setregs(child, datap);
 		break;
 
 	default:
-- 
1.7.2.2

