Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab0H0JuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:50:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55188 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab0H0Jn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:43:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SkDZ8aBnXgZfXqIvGCqjjIiCFBlaQbBcpoNZeLDWVC96mKnC5M+SYw9zPqEy23ZSqI
         mUUjpeeYewlr+z+BYAvb0r+0QNP9PjbLEbfBOctV7wmWbMRhiF8P+s9nd0ZkTUOKvSRb
         q3DkPOZw2a5Bk6lStGNmA3zkyzVzahFsaetP8=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>
Subject: [RFC PATCH 12/43] ptrace, cris-v10: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:41:58 +0900
Message-Id: <1282902149-12991-13-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Also fix misc bug on datap.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v10/kernel/ptrace.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/ptrace.c b/arch/cris/arch-v10/kernel/ptrace.c
index e70c804..9f02416 100644
--- a/arch/cris/arch-v10/kernel/ptrace.c
+++ b/arch/cris/arch-v10/kernel/ptrace.c
@@ -76,7 +76,8 @@ ptrace_disable(struct task_struct *child)
  * (in user space) where the result of the ptrace call is written (instead of
  * being returned).
  */
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	int ret;
 	unsigned long __user *datap = (unsigned long __user *)data;
@@ -93,7 +94,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			unsigned long tmp;
 
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 || addr > PT_MAX << 2)
+			if ((addr & 3) || addr > PT_MAX << 2)
 				break;
 
 			tmp = get_reg(child, addr >> 2);
@@ -110,7 +111,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
  		/* Write the word at location address in the USER area. */
 		case PTRACE_POKEUSR:
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 || addr > PT_MAX << 2)
+			if ((addr & 3) || addr > PT_MAX << 2)
 				break;
 
 			addr >>= 2;
@@ -141,7 +142,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 					break;
 				}
 				
-				data += sizeof(long);
+				datap++;
 			}
 
 			break;
@@ -165,7 +166,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 				}
 				
 				put_reg(child, i, tmp);
-				data += sizeof(long);
+				datap++;
 			}
 			
 			break;
-- 
1.7.2.2

