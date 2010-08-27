Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab0H0JnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:43:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52511 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab0H0JnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:43:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DuE/XX33vfxJosGYRHN9sNMPhlnLdmc6Y5kXOFjrdhC+ctm7P7V9JLHuu+sC8sEXV2
         12YFsfqUgeYPB0xAhb2GDjApGhTedtOqip9hdQvbelgMamdEcOI6Umtt9Z37VKMQHdpo
         ZxJ7vskaFY9X3nkCL/LYYjV8wxLFVi6WA61e4=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: [RFC PATCH 06/43] ptrace, alpha: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:41:52 +0900
Message-Id: <1282902149-12991-7-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/kernel/ptrace.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/alpha/kernel/ptrace.c b/arch/alpha/kernel/ptrace.c
index baa9036..e2af5eb 100644
--- a/arch/alpha/kernel/ptrace.c
+++ b/arch/alpha/kernel/ptrace.c
@@ -269,7 +269,8 @@ void ptrace_disable(struct task_struct *child)
 	user_disable_single_step(child);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long tmp;
 	size_t copied;
@@ -292,7 +293,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 	case PTRACE_PEEKUSR:
 		force_successful_syscall_return();
 		ret = get_reg(child, addr);
-		DBG(DBG_MEM, ("peek $%ld->%#lx\n", addr, ret));
+		DBG(DBG_MEM, ("peek $%lu->%#lx\n", addr, ret));
 		break;
 
 	/* When I and D space are separate, this will have to be fixed.  */
@@ -302,7 +303,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 
 	case PTRACE_POKEUSR: /* write the specified register */
-		DBG(DBG_MEM, ("poke $%ld<-%#lx\n", addr, data));
+		DBG(DBG_MEM, ("poke $%lu<-%#lx\n", addr, data));
 		ret = put_reg(child, addr, data);
 		break;
 	default:
-- 
1.7.2.2

