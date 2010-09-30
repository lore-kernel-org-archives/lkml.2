Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab0I3Jao (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 05:30:44 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33384 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab0I3J3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:29:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ph7OyEIopperCZUvhOvMuWR30twEkm5B97hG58ALZlY7a40W5ngmW/lm5C6JjBEb0d
         2+1dQpaJmIEiV/E+4ts1sZYk7uHhFjsxgpck5VWSXxcRy9DGRCsFdSg5tdQBC3kXkkW5
         LL+Jv7pTQU5P0ZJzIzf0kXrMXxNVWpf8U5O0I=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, Chen Liqin <liqin.chen@sunplusct.com>,
        Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH RESEND v3 19/24] ptrace: cleanup arch_ptrace() on score
Date: Thu, 30 Sep 2010 18:27:54 +0900
Message-Id: <1285838880-4977-20-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary castings.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Chen Liqin <liqin.chen@sunplusct.com>
Cc: Lennox Wu <lennox.wu@gmail.com>
---
 arch/score/kernel/ptrace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/score/kernel/ptrace.c b/arch/score/kernel/ptrace.c
index 894dcbf..5583618 100644
--- a/arch/score/kernel/ptrace.c
+++ b/arch/score/kernel/ptrace.c
@@ -336,14 +336,14 @@ arch_ptrace(struct task_struct *child, long request,
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

