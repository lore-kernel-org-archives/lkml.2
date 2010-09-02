Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab0IBPsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 11:48:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33413 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756297Ab0IBPse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 11:48:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=bGqjnwYAAyhqPYinDEjaYvTX1A6u19D1hPuE+60pnpc6r4aQNiHCrLr1x1eNXHk05d
         0DDaOyBLO0O0E9LN9UCsqTylS1omJlMJXGgOLCVliOa7zBjTu2CBR2wASFzrQ4EBNdZ+
         tHKosRuD/Ube4+e8VFlToaZ5wEg4UAgqJM1Qk=
From: Namhyung Kim <namhyung@gmail.com>
To: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Chen Liqin <liqin.chen@sunplusct.com>, Lennox Wu <lennox.wu@gmail.com>
Subject: [PATCH v2 19/24] ptrace: cleanup arch_ptrace() on score
Date: Fri,  3 Sep 2010 00:46:26 +0900
Message-Id: <1283442391-23612-20-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
References: <1283442391-23612-1-git-send-email-namhyung@gmail.com>
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

