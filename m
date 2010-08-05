Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab0HEOo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 10:44:29 -0400
Received: from mail.windriver.com ([147.11.1.11]:41202 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760589Ab0HEOin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 10:38:43 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Michal Simek <monstr@monstr.eu>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 10/17] kgdb,powerpc: Replace hardcoded offset by BREAK_INSTR_SIZE
Date: Thu,  5 Aug 2010 09:37:51 -0500
Message-Id: <1281019078-6636-11-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1281019078-6636-10-git-send-email-jason.wessel@windriver.com>
References: <1281019078-6636-1-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-2-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-3-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-4-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-5-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-6-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-7-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-8-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-9-git-send-email-jason.wessel@windriver.com>
 <1281019078-6636-10-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 05 Aug 2010 14:38:19.0246 (UTC) FILETIME=[D8DAC8E0:01CB34AB]
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
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
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
1.6.3.3

