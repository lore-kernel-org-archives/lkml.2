Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab2IUU7W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 16:59:22 -0400
Received: from mga09.intel.com ([134.134.136.24]:17548 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152Ab2IUU7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 16:59:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,464,1344236400"; 
   d="scan'208";a="210025022"
From: Andi Kleen <andi@firstfloor.org>
To: jason.wessel@windriver.com
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] kgdb: Fix warning with !CONFIG_DEBUG_RODATA
Date: Fri, 21 Sep 2012 13:59:10 -0700
Message-Id: <1348261150-12423-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Fixes

arch/x86/kernel/kgdb.c: In function ‘kgdb_arch_set_breakpoint’:
arch/x86/kernel/kgdb.c:749:7: warning: unused variable ‘opc’ [-Wunused-variable]

when CONFIG_DEBUG_RODATA is not defined.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/kgdb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 3f61904..0e4badd 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -746,7 +746,9 @@ void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
 int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 {
 	int err;
+#ifdef CONFIG_DEBUG_RODATA
 	char opc[BREAK_INSTR_SIZE];
+#endif
 
 	bpt->type = BP_BREAKPOINT;
 	err = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,
-- 
1.7.7.6

