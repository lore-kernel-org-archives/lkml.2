Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab1FJNKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:10:11 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:43308 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757393Ab1FJNKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:10:05 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH] mips, exec: remove redundant addr_limit assignment
Date: Fri, 10 Jun 2011 15:10:04 +0200
Message-Id: <1307711404-9745-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
References: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
References: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com> <1307642718-22257-1-git-send-email-minipli@googlemail.com> <20110609155630.0f734351.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address limit is already set in flush_old_exec() via set_fs(USER_DS)
so this assignment is redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/mips/kernel/process.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/mips/kernel/process.c b/arch/mips/kernel/process.c
index d2112d3..a8d53e5 100644
--- a/arch/mips/kernel/process.c
+++ b/arch/mips/kernel/process.c
@@ -103,7 +103,6 @@ void start_thread(struct pt_regs * regs, unsigned long pc, unsigned long sp)
 		__init_dsp();
 	regs->cp0_epc = pc;
 	regs->regs[29] = sp;
-	current_thread_info()->addr_limit = USER_DS;
 }
 
 void exit_thread(void)
-- 
1.5.6.5

