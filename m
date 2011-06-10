Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab1FJNL4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:11:56 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:43688 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757442Ab1FJNKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:10:17 -0400
From: Mathias Krause <minipli@googlemail.com>
To: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>
Subject: [PATCH] parisc, exec: remove redundant set_fs(USER_DS)
Date: Fri, 10 Jun 2011 15:10:16 +0200
Message-Id: <1307711416-14119-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
References: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
References: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com> <1307642718-22257-1-git-send-email-minipli@googlemail.com> <20110609155630.0f734351.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address limit is already set in flush_old_exec() so those calls to
set_fs(USER_DS) are redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
---
 arch/parisc/include/asm/processor.h |    2 --
 arch/parisc/kernel/process.c        |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/arch/parisc/include/asm/processor.h b/arch/parisc/include/asm/processor.h
index 9ce66e9..7213ec9 100644
--- a/arch/parisc/include/asm/processor.h
+++ b/arch/parisc/include/asm/processor.h
@@ -196,7 +196,6 @@ typedef unsigned int elf_caddr_t;
 	/* offset pc for priv. level */			\
 	pc |= 3;					\
 							\
-	set_fs(USER_DS);				\
 	regs->iasq[0] = spaceid;			\
 	regs->iasq[1] = spaceid;			\
 	regs->iaoq[0] = pc;				\
@@ -299,7 +298,6 @@ on downward growing arches, it looks like this:
 	elf_addr_t pc = (elf_addr_t)new_pc | 3;		\
 	elf_caddr_t *argv = (elf_caddr_t *)bprm->exec + 1;	\
 							\
-	set_fs(USER_DS);				\
 	regs->iasq[0] = spaceid;			\
 	regs->iasq[1] = spaceid;			\
 	regs->iaoq[0] = pc;				\
diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index 4b4b918..62c60b8 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -192,7 +192,6 @@ void flush_thread(void)
 	/* Only needs to handle fpu stuff or perf monitors.
 	** REVISIT: several arches implement a "lazy fpu state".
 	*/
-	set_fs(USER_DS);
 }
 
 void release_thread(struct task_struct *dead_task)
-- 
1.5.6.5

