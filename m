Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab0H0JoD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:44:03 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42423 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab0H0Jn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:43:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=L/BaZIM2uIhSoHijhsNl1YxkbbVKUmnnc3+IPZdezPk2eNrjWKNLkJroopNQPBB8zy
         t3r5d48oStOkdH76UzHG7dIL9+EMLNgN0qMzaNlEAYIzZ/idsJBmg8e0tPu37thZJAqu
         fOm50z5qaYC9LD2m4iiHgGcskz29xu5T/zZUE=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Roman Zippel <zippel@linux-m68k.org>
Subject: [RFC PATCH 21/43] ptrace, m68k: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:07 +0900
Message-Id: <1282902149-12991-22-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
---
 arch/m68k/kernel/ptrace.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/m68k/kernel/ptrace.c b/arch/m68k/kernel/ptrace.c
index 616e597..583f59f 100644
--- a/arch/m68k/kernel/ptrace.c
+++ b/arch/m68k/kernel/ptrace.c
@@ -156,7 +156,8 @@ void user_disable_single_step(struct task_struct *child)
 	singlestep_disable(child);
 }
 
-long arch_ptrace(struct task_struct *child, long request, long addr, long data)
+long arch_ptrace(struct task_struct *child, long request,
+		 unsigned long addr, unsigned long data)
 {
 	unsigned long tmp;
 	int i, ret = 0;
@@ -200,7 +201,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			 * into internal fpu reg representation
 			 */
 			if (FPU_IS_EMU && (addr < 45) && !(addr % 3)) {
-				data = (unsigned long)data << 15;
+				data <<= 15;
 				data = (data & 0xffff0000) |
 				       ((data & 0x0000ffff) >> 1);
 			}
@@ -215,7 +216,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 			ret = put_user(tmp, (unsigned long *)data);
 			if (ret)
 				break;
-			data += sizeof(long);
+			data += sizeof(unsigned long);
 		}
 		break;
 
@@ -229,7 +230,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 				tmp |= get_reg(child, PT_SR) & ~SR_MASK;
 			}
 			put_reg(child, i, tmp);
-			data += sizeof(long);
+			data += sizeof(unsigned long);
 		}
 		break;
 
-- 
1.7.2.2

