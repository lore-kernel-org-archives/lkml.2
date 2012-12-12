Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2LLSVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 13:21:55 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:59943 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755179Ab2LLSVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 13:21:53 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH 15/26] unicore32: Convert print_symbol to %pSR
Date: Wed, 12 Dec 2012 10:19:04 -0800
Message-Id: <19e6ea369e4455fc447c48f72bd433921bd0a703.1355335228.git.joe@perches.com>
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
 arch/unicore32/kernel/process.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/unicore32/kernel/process.c b/arch/unicore32/kernel/process.c
index 62bad9f..d17a893 100644
--- a/arch/unicore32/kernel/process.c
+++ b/arch/unicore32/kernel/process.c
@@ -169,8 +169,9 @@ void __show_regs(struct pt_regs *regs)
 		init_utsname()->release,
 		(int)strcspn(init_utsname()->version, " "),
 		init_utsname()->version);
-	print_symbol("PC is at %s\n", instruction_pointer(regs));
-	print_symbol("LR is at %s\n", regs->UCreg_lr);
+	printk(KERN_DEFAULT "PC is at %pSR\n",
+	       (void *)instruction_pointer(regs));
+	printk(KERN_DEFAULT "LR is at %pSR\n", (void *)regs->UCreg_lr);
 	printk(KERN_DEFAULT "pc : [<%08lx>]    lr : [<%08lx>]    psr: %08lx\n"
 	       "sp : %08lx  ip : %08lx  fp : %08lx\n",
 		regs->UCreg_pc, regs->UCreg_lr, regs->UCreg_asr,
-- 
1.7.8.112.g3fd21

