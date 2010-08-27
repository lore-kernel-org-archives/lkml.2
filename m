Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754561Ab0H0Jnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:43:31 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52511 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab0H0JnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:43:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Y1alJRkNJ0+6hadj2uzXAaPrEllmRwyLC+jPHJjZTpMjuNDMnZaFuy+O9vWlQXuBGt
         vPH7CH5DfEVcsXCtaupqJsPufksUqK4uj/STuz/PxNOFDLGpxtqSgV+gTuN9lwBgnAfk
         tiF9QYwD6XzJRN/G7IMupQrZrkuXfmIRtZppA=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [RFC PATCH 10/43] ptrace, avr32: cleanup arch_ptrace()
Date: Fri, 27 Aug 2010 18:41:56 +0900
Message-Id: <1282902149-12991-11-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

use new 'datap' variable type of void pointer in order to remove unnecessary
castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
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

