Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab0H0Jnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:43:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55188 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab0H0Jnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:43:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=HQYeucnIxGSTKDZLRe8u1Dsl+C0ifUqzVvk+EmhLjLbWKtyvB141TYQ4eqC+Xc3r+7
         J7pZ1+wFRzQ6s6WD4aOd0J/WV6o6M/KZKj19kZPQSTth7SftVOZuZf+Hh9caV7yOqFR+
         8Rlq8bH1xMP/V/vAFnL2xVVZVr5nvEOVejmSc=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [RFC PATCH 16/43] ptrace, h8300: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:02 +0900
Message-Id: <1282902149-12991-17-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---
 arch/h8300/kernel/ptrace.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/h8300/kernel/ptrace.c b/arch/h8300/kernel/ptrace.c
index df11412..23a95f84 100644
--- a/arch/h8300/kernel/ptrace.c
+++ b/arch/h8300/kernel/ptrace.c
@@ -50,7 +50,8 @@ void ptrace_disable(struct task_struct *child)
 	user_disable_single_step(child);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 
@@ -59,7 +60,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		case PTRACE_PEEKUSR: {
 			unsigned long tmp = 0;
 			
-			if ((addr & 3) || addr < 0 || addr >= sizeof(struct user)) {
+			if ((addr & 3) || addr >= sizeof(struct user)) {
 				ret = -EIO;
 				break ;
 			}
@@ -94,7 +95,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
       /* when I and D space are separate, this will have to be fixed. */
 		case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
-			if ((addr & 3) || addr < 0 || addr >= sizeof(struct user)) {
+			if ((addr & 3) || addr >= sizeof(struct user)) {
 				ret = -EIO;
 				break ;
 			}
@@ -120,7 +121,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 				ret = -EFAULT;
 				break;
 			    }
-			    data += sizeof(long);
+			    data += sizeof(unsigned long);
 			}
 			ret = 0;
 			break;
@@ -135,7 +136,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 				break;
 			    }
 			    h8300_put_reg(child, i, tmp);
-			    data += sizeof(long);
+			    data += sizeof(unsigned long);
 			}
 			ret = 0;
 			break;
-- 
1.7.2.2

