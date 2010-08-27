Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab0H0JoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:44:13 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52511 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab0H0JoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:44:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Mh5MYSC4L0h2RC3nee/fG7YtILfS4bmEmrD61FH0zhiYsWsnWAbZ0rj/UoyAcEn41v
         4rXhtvd//kkMk8NoQYxXq3+Rh5CnXQtJ5EKvHz34GULfw83bxdLg9EiExMoEWiyCx/7u
         7QYjEquaBesKv/BcTunnXPegezqp6U4Skp2Oo=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>
Subject: [RFC PATCH 25/43] ptrace, microblaze: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:11 +0900
Message-Id: <1282902149-12991-26-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/kernel/ptrace.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/microblaze/kernel/ptrace.c b/arch/microblaze/kernel/ptrace.c
index dc03ffc..2d6b4cf 100644
--- a/arch/microblaze/kernel/ptrace.c
+++ b/arch/microblaze/kernel/ptrace.c
@@ -73,7 +73,8 @@ static microblaze_reg_t *reg_save_addr(unsigned reg_offs,
 	return (microblaze_reg_t *)((char *)regs + reg_offs);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int rval;
 	unsigned long val = 0;
@@ -99,7 +100,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			} else {
 				rval = -EIO;
 			}
-		} else if (addr >= 0 && addr < PT_SIZE && (addr & 0x3) == 0) {
+		} else if (addr < PT_SIZE && (addr & 0x3) == 0) {
 			microblaze_reg_t *reg_addr = reg_save_addr(addr, child);
 			if (request == PTRACE_PEEKUSR)
 				val = *reg_addr;
@@ -122,7 +123,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			rval = -EIO;
 
 		if (rval == 0 && request == PTRACE_PEEKUSR)
-			rval = put_user(val, (unsigned long *)data);
+			rval = put_user(val, (unsigned long __user *)data);
 		break;
 	default:
 		rval = ptrace_request(child, request, addr, data);
-- 
1.7.2.2

