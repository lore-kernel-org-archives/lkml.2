Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab0I3J3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:29:01 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33384 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755660Ab0I3J27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:28:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=UThY0wO0OI9oh0jS8QopBlR242tEDRFydtwKc1HQUVJ7/RsFx9F73iuQ0AWljvVvPl
         EGjPK54CJAK0rrgrKvUxQVF4lWhePRGvBi+LlAs8pctL+uGvoy93IuWbMitJj5G6Pctl
         kOurjsKkcvuwHIrs70M3jlmtPGu720ROxK6ZA=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, Hirokazu Takata <takata@linux-m32r.org>
Subject: [PATCH RESEND v3 11/24] ptrace: cleanup arch_ptrace() on m32r
Date: Thu, 30 Sep 2010 18:27:46 +0900
Message-Id: <1285838880-4977-12-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new 'datap' variable in order to remove duplicated castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
---
 arch/m32r/kernel/ptrace.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/m32r/kernel/ptrace.c b/arch/m32r/kernel/ptrace.c
index 5e00e0a..2074375 100644
--- a/arch/m32r/kernel/ptrace.c
+++ b/arch/m32r/kernel/ptrace.c
@@ -626,6 +626,7 @@ arch_ptrace(struct task_struct *child, long request,
 	    unsigned long addr, unsigned long data)
 {
 	int ret;
+	unsigned long __user *datap = (unsigned long __user *) data;
 
 	switch (request) {
 	/*
@@ -640,8 +641,7 @@ arch_ptrace(struct task_struct *child, long request,
 	 * read the word at location addr in the USER area.
 	 */
 	case PTRACE_PEEKUSR:
-		ret = ptrace_read_user(child, addr,
-				       (unsigned long __user *)data);
+		ret = ptrace_read_user(child, addr, datap);
 		break;
 
 	/*
@@ -662,11 +662,11 @@ arch_ptrace(struct task_struct *child, long request,
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

