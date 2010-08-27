Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab0H0Jnf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:43:35 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42423 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502Ab0H0Jnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:43:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=NkYlg+gQ9gvfPfMrzYLOSV+GD2I17yY5sSugceMJ03rHsuOqOVgoOxPEL5QHaRSHOq
         0ZIWI838IGKdN2k7NPbPcvosoEV4GCbe0dWWThogCRdufJHqWwv90Wa8WC5q61HVc7Ej
         HQUM/bInfFfKqhCoS7xuKTCsRz8Jkz0eopfLE=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [RFC PATCH 13/43] ptrace, cris-v32: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:41:59 +0900
Message-Id: <1282902149-12991-14-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/kernel/ptrace.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/ptrace.c b/arch/cris/arch-v32/kernel/ptrace.c
index f4ebd1e..b50da61 100644
--- a/arch/cris/arch-v32/kernel/ptrace.c
+++ b/arch/cris/arch-v32/kernel/ptrace.c
@@ -126,7 +126,8 @@ ptrace_disable(struct task_struct *child)
 }
 
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
@@ -163,7 +164,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			unsigned long tmp;
 
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 || addr > PT_MAX << 2)
+			if ((addr & 3) || addr > PT_MAX << 2)
 				break;
 
 			tmp = get_reg(child, addr >> 2);
@@ -180,7 +181,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		/* Write the word at location address in the USER area. */
 		case PTRACE_POKEUSR:
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 || addr > PT_MAX << 2)
+			if ((addr & 3) || addr > PT_MAX << 2)
 				break;
 
 			addr >>= 2;
-- 
1.7.2.2

