Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab2LLSVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:21:10 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39371 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754716Ab2LLSVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:21:07 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Jonas Bonn <jonas@southpole.se>, linux@openrisc.net,
        linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 10/26] openrisc: Convert print_symbol to %pSR
Date: Wed, 12 Dec 2012 10:18:59 -0800
Message-Id: <f20dd6ace734d0c64583cb2a52e1a983f3cb416d.1355335228.git.joe@perches.com>
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
 arch/openrisc/kernel/traps.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/openrisc/kernel/traps.c b/arch/openrisc/kernel/traps.c
index 5cce396..f5c1d0a 100644
--- a/arch/openrisc/kernel/traps.c
+++ b/arch/openrisc/kernel/traps.c
@@ -56,11 +56,8 @@ void show_trace(struct task_struct *task, unsigned long *stack)
 
 	while (valid_stack_ptr(context, stack)) {
 		addr = *stack++;
-		if (__kernel_text_address(addr)) {
-			printk(" [<%08lx>]", addr);
-			print_symbol(" %s", addr);
-			printk("\n");
-		}
+		if (__kernel_text_address(addr))
+			printk(" [<%08lx>] %pSR\n", addr, (void *)addr);
 	}
 	printk(" =======================\n");
 }
-- 
1.7.8.112.g3fd21

