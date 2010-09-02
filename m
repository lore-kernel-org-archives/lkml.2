Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab0IBPr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:47:27 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45037 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015Ab0IBPrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:47:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=h0OaHI0g2d6lSZp02jU6vKfoL+VvfYLQaRYJ++3Jes5Aa1APu0XjByl0iC0x1NJI1w
         hVHUn3xlKr/ZW1yxJ/fZ0KODbze0d7fcJ4NsZ8jxuPGxFeC0zHEJFQ0waQ/eaPftvwQx
         q8hIqEEES3UWQDdFDEiMyber2gsC1H/7YERQQ=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/24] ptrace: cleanup arch_ptrace() on avr32
Date: Fri,  3 Sep 2010 00:46:13 +0900
Message-Id: <1283442391-23612-7-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
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

