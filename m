Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0H0Jnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:43:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52511 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab0H0Jng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:43:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=nVhU5/ND1i5vSXu6DCvzW1FFXaMHpxibAuWBzSeNGfQrfgIWluR/o+s7TjIkTO9KAN
         Cg4L33auRsfLCGI8iocJrg9MG5fQmuBIeEMOA2pLpmk88AZNAxOye3pFoTlQs+ZVGAEm
         SwKrQjEt9nAuByJHxy6pveZ/N1Q+YQF/FnIng=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [RFC PATCH 14/43] ptrace, frv: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:00 +0900
Message-Id: <1282902149-12991-15-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: David Howells <dhowells@redhat.com>
---
 arch/frv/kernel/ptrace.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/frv/kernel/ptrace.c b/arch/frv/kernel/ptrace.c
index fac0289..3d87d1c 100644
--- a/arch/frv/kernel/ptrace.c
+++ b/arch/frv/kernel/ptrace.c
@@ -254,7 +254,8 @@ void ptrace_disable(struct task_struct *child)
 	user_disable_single_step(child);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long tmp;
 	int ret;
@@ -264,7 +265,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	case PTRACE_PEEKUSR: {
 		tmp = 0;
 		ret = -EIO;
-		if ((addr & 3) || addr < 0)
+		if (addr & 3)
 			break;
 
 		ret = 0;
@@ -305,7 +306,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 
 	case PTRACE_POKEUSR: /* write the word at location addr in the USER area */
 		ret = -EIO;
-		if ((addr & 3) || addr < 0)
+		if (addr & 3)
 			break;
 
 		ret = 0;
-- 
1.7.2.2

