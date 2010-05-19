Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385Ab0ESBnT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:43:19 -0400
Received: from mail.windriver.com ([147.11.1.11]:41214 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab0ESBkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:40:20 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 04/25] kgdb,sparc: Add in kgdb_arch_set_pc for sparc
Date: Tue, 18 May 2010 20:39:14 -0500
Message-Id: <1274233175-3675-5-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
References: <1274233175-3675-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 19 May 2010 01:39:44.0360 (UTC) FILETIME=[28645E80:01CAF6F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new debug core api requires all architectures that use to debug
core to implement a function to set the program counter.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Acked-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/kernel/kgdb_32.c |    6 ++++++
 arch/sparc/kernel/kgdb_64.c |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/kernel/kgdb_32.c b/arch/sparc/kernel/kgdb_32.c
index 04df4ed..539243b 100644
--- a/arch/sparc/kernel/kgdb_32.c
+++ b/arch/sparc/kernel/kgdb_32.c
@@ -158,6 +158,12 @@ void kgdb_arch_exit(void)
 {
 }
 
+void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
+{
+	regs->pc = ip;
+	regs->npc = regs->pc + 4;
+}
+
 struct kgdb_arch arch_kgdb_ops = {
 	/* Breakpoint instruction: ta 0x7d */
 	.gdb_bpt_instr		= { 0x91, 0xd0, 0x20, 0x7d },
diff --git a/arch/sparc/kernel/kgdb_64.c b/arch/sparc/kernel/kgdb_64.c
index 0a2bd0f..768290a 100644
--- a/arch/sparc/kernel/kgdb_64.c
+++ b/arch/sparc/kernel/kgdb_64.c
@@ -181,6 +181,12 @@ void kgdb_arch_exit(void)
 {
 }
 
+void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
+{
+	regs->tpc = ip;
+	regs->tnpc = regs->tpc + 4;
+}
+
 struct kgdb_arch arch_kgdb_ops = {
 	/* Breakpoint instruction: ta 0x72 */
 	.gdb_bpt_instr		= { 0x91, 0xd0, 0x20, 0x72 },
-- 
1.6.3.3

