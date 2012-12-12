Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347Ab2LLSWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:22:16 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33581 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753966Ab2LLSWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:22:13 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Chris Zankel <chris@zankel.net>, Max Filippov <jcmvbkbc@gmail.com>,
        linux-xtensa@linux-xtensa.org, linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 17/26] xtensa: Convert print_symbol to %pSR
Date: Wed, 12 Dec 2012 10:19:06 -0800
Message-Id: <4b763f52701ebf73f9140a946bb8f8f287489fde.1355335228.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1355335227.git.joe@perches.com>
References: <cover.1355335227.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new vsprintf extension to avoid any possible
message interleaving.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/xtensa/kernel/traps.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index 691a792..bf57478 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -441,10 +441,8 @@ void show_trace(struct task_struct *task, unsigned long *sp)
 
 		pc = MAKE_PC_FROM_RA(a0, a1);
 
-		if (kernel_text_address(pc)) {
-			printk(" [<%08lx>] ", pc);
-			print_symbol("%s\n", pc);
-		}
+		if (kernel_text_address(pc))
+			printk(" [<%08lx>] %pSR\n", pc, (void *)pc);
 	}
 	printk("\n");
 }
-- 
1.7.8.112.g3fd21

