Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab0H0Jom (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 05:44:42 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44231 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658Ab0H0Joj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 05:44:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YitmD3aTdAOeyLbhRuqGP/lSfkLiQKVmExABx9Et2+sG7q/K1e5OVPvQiynnPx7ogM
         v5KJ/xbTqFUU9Pbs7royJV+MLccQ9KK+G3EVBaBALgM+7sK6uFp/XLe9vH1DZ0+rXwSj
         VVqVUP+GL5k3mCwlSFPcT6bepB4JQVUia1c84=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Chen Liqin <liqin.chen@sunplusct.com>,
        Lennox Wu <lennox.wu@gmail.com>
Subject: [RFC PATCH 34/43] ptrace, score: change signature of arch_ptrace()
Date: Fri, 27 Aug 2010 18:42:20 +0900
Message-Id: <1282902149-12991-35-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
References: <1282902149-12991-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change type of @addr and @data into unsigned long according to commit
f76671df26ef06321480e702770f88f61272be29 [PATCH 03/43]

And removes unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
---
 arch/score/kernel/ptrace.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/score/kernel/ptrace.c b/arch/score/kernel/ptrace.c
index 174c642..5583618 100644
--- a/arch/score/kernel/ptrace.c
+++ b/arch/score/kernel/ptrace.c
@@ -325,7 +325,8 @@ void ptrace_disable(struct task_struct *child)
 }
 
 long
-arch_ptrace(struct task_struct *child, long request, long addr, long data)
+arch_ptrace(struct task_struct *child, long request,
+	    unsigned long addr, unsigned long data)
 {
 	int ret;
 	unsigned long __user *datap = (void __user *)data;
@@ -335,14 +336,14 @@ arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		ret = copy_regset_to_user(child, &user_score_native_view,
 						REGSET_GENERAL,
 						0, sizeof(struct pt_regs),
-						(void __user *)datap);
+						datap);
 		break;
 
 	case PTRACE_SETREGS:
 		ret = copy_regset_from_user(child, &user_score_native_view,
 						REGSET_GENERAL,
 						0, sizeof(struct pt_regs),
-						(const void __user *)datap);
+						datap);
 		break;
 
 	default:
-- 
1.7.2.2

