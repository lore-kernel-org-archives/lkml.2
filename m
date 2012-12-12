Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab2LLSUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:20:51 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:57893 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754926Ab2LLSUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:20:49 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Hirokazu Takata <takata@linux-m32r.org>, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org, linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 08/26] m32r: Convert print_symbol to %pSR
Date: Wed, 12 Dec 2012 10:18:57 -0800
Message-Id: <df548c6911e1b46a73b9a417efb800d08e0ecf8f.1355335228.git.joe@perches.com>
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
 arch/m32r/kernel/traps.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/m32r/kernel/traps.c b/arch/m32r/kernel/traps.c
index 3bcb207..9fe3467 100644
--- a/arch/m32r/kernel/traps.c
+++ b/arch/m32r/kernel/traps.c
@@ -132,10 +132,8 @@ static void show_trace(struct task_struct *task, unsigned long *stack)
 	printk("Call Trace: ");
 	while (!kstack_end(stack)) {
 		addr = *stack++;
-		if (__kernel_text_address(addr)) {
-			printk("[<%08lx>] ", addr);
-			print_symbol("%s\n", addr);
-		}
+		if (__kernel_text_address(addr))
+			printk("[<%08lx>] %pSR\n", addr, (void *)addr);
 	}
 	printk("\n");
 }
-- 
1.7.8.112.g3fd21

