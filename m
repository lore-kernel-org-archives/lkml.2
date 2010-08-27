Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab0H0Jmz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:42:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52511 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab0H0Jms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:42:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sy31U//7DElJuqrRnoRMvpY0iEVrO9zBgzY/SCJdWhnyR6dXXgYsf3IWgOnXhU1jCB
         C88GPWLi6P/XiDXTtSCqexErtKUaSir30t1AA4exJvAIWbti5W+ERg+ZcjCiAkvnAM5P
         PK5GQ6JctYQL1HV0VIIUBP9Oi7lGQ4QPbEwVE=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH 03/43] ptrace: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:41:49 +0900
Message-Id: <1282902149-12991-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long.

NOTE: This patch might break build if applied alone so should be used with
your arch counterpart.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 include/linux/ptrace.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 67a4cd7..092a04f 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -100,7 +100,8 @@
 #include <linux/sched.h>		/* For struct task_struct.  */
 
 
-extern long arch_ptrace(struct task_struct *child, long request, long addr, long data);
+extern long arch_ptrace(struct task_struct *child, long request,
+			unsigned long addr, unsigned long data);
 extern int ptrace_traceme(void);
 extern int ptrace_readdata(struct task_struct *tsk, unsigned long src, char __user *dst, int len);
 extern int ptrace_writedata(struct task_struct *tsk, char __user *src, unsigned long dst, int len);
-- 
1.7.2.2

