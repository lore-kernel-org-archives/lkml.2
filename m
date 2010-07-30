Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681Ab0G3TSd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 15:18:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:33867 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab0G3TSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 15:18:06 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
        Michal Simek <monstr@monstr.eu>,
        Jason Wessel <jason.wessel@windriver.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@ozlabs.org
Subject: [PATCH 10/15] powerpc: Replace hardcoded offset by BREAK_INSTR_SIZE
Date: Fri, 30 Jul 2010 14:17:31 -0500
Message-Id: <1280517456-1167-11-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1280517456-1167-1-git-send-email-jason.wessel@windriver.com>
References: <1280517456-1167-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 30 Jul 2010 19:17:47.0939 (UTC) FILETIME=[E54BC730:01CB301B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

kgdb_handle_breakpoint checks the first arch_kgdb_breakpoint
which is not known by gdb that's why is necessary jump over
it. The jump lenght is equal to BREAK_INSTR_SIZE that's
why is cleaner to use defined macro instead of hardcoded
non-described offset.

Signed-off-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org
---
 arch/powerpc/kernel/kgdb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 82a7b22..7f61a3a 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -129,7 +129,7 @@ static int kgdb_handle_breakpoint(struct pt_regs *regs)
 		return 0;
 
 	if (*(u32 *) (regs->nip) == *(u32 *) (&arch_kgdb_ops.gdb_bpt_instr))
-		regs->nip += 4;
+		regs->nip += BREAK_INSTR_SIZE;
 
 	return 1;
 }
-- 
1.6.4.rc1

