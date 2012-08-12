Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab2HLMRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 08:17:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:47738 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab2HLMRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 08:17:20 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <kgdb-bugreport@lists.sourceforge.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 3/4] kgdb,x86: fix warning about unused variable
Date: Sun, 12 Aug 2012 07:16:44 -0500
Message-ID: <1344773805-12844-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344773805-12844-1-git-send-email-jason.wessel@windriver.com>
References: <1344773805-12844-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling without CONFIG_DEBUG_RODATA the following
compiler warning is generated:

arch/x86/kernel/kgdb.c: In function 'kgdb_arch_set_breakpoint':
arch/x86/kernel/kgdb.c:749: warning: unused variable 'opc'

The variable instantiation needs to be inside the #ifdef to
make the warning go away.

Reported-by: Thiago Rafael Becker <trbecker@trbecker.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 arch/x86/kernel/kgdb.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 3f61904..836f832 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -746,7 +746,9 @@ void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
 int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 {
 	int err;
+#ifdef CONFIG_DEBUG_RODATA
 	char opc[BREAK_INSTR_SIZE];
+#endif /* CONFIG_DEBUG_RODATA */
 
 	bpt->type = BP_BREAKPOINT;
 	err = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,
-- 
1.7.9.5

