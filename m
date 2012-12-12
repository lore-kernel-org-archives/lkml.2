Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab2LLSUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:20:16 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:58389 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753966Ab2LLSUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:20:12 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 04/26] arm64: Convert print_symbol to %pSR
Date: Wed, 12 Dec 2012 10:18:53 -0800
Message-Id: <c5cb06461153912fe383547a267aaea6e8b4976a.1355335227.git.joe@perches.com>
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
 arch/arm64/kernel/process.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index cb0956b..55fb84e 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -187,8 +187,8 @@ void __show_regs(struct pt_regs *regs)
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
-	print_symbol("PC is at %s\n", instruction_pointer(regs));
-	print_symbol("LR is at %s\n", regs->regs[30]);
+	printk("PC is at %pSR\n", (void *)instruction_pointer(regs));
+	printk("LR is at %pSR\n", (void *)regs->regs[30]);
 	printk("pc : [<%016llx>] lr : [<%016llx>] pstate: %08llx\n",
 	       regs->pc, regs->regs[30], regs->pstate);
 	printk("sp : %016llx\n", regs->sp);
-- 
1.7.8.112.g3fd21

