Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab2LLSVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:21:38 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:55086 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754503Ab2LLSVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:21:35 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 13/26] sh: Convert print_symbol to %pSR
Date: Wed, 12 Dec 2012 10:19:02 -0800
Message-Id: <ff4fd103eea2a7ae666e540053c7d824e173e57f.1355335228.git.joe@perches.com>
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
 arch/sh/kernel/process_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sh/kernel/process_32.c b/arch/sh/kernel/process_32.c
index 73eb66f..a0837ba 100644
--- a/arch/sh/kernel/process_32.c
+++ b/arch/sh/kernel/process_32.c
@@ -38,8 +38,8 @@ void show_regs(struct pt_regs * regs)
 	       (int)strcspn(init_utsname()->version, " "),
 	       init_utsname()->version);
 
-	print_symbol("PC is at %s\n", instruction_pointer(regs));
-	print_symbol("PR is at %s\n", regs->pr);
+	printk("PC is at %pSR\n", (void *)instruction_pointer(regs));
+	printk("PR is at %pSR\n", (void *)regs->pr);
 
 	printk("PC  : %08lx SP  : %08lx SR  : %08lx ",
 	       regs->pc, regs->regs[15], regs->sr);
-- 
1.7.8.112.g3fd21

