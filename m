Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab1AWPRc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 10:17:32 -0500
Received: from www.tglx.de ([62.245.132.106]:58664 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab1AWPRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 10:17:16 -0500
Message-Id: <20110123143837.128260362@linutronix.de>
User-Agent: quilt/0.48-1
Date: Sun, 23 Jan 2011 15:17:00 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: [patch 3/9] mips: Replace deprecated spinlock initialization
References: <20110123143631.392446736@linutronix.de>
Content-Disposition: inline;
	filename=mips-replace-deprecated-spinlock-initialization.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SPIN_LOCK_UNLOCK is deprecated. Use the lockdep capable variant
instead.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
---
 arch/mips/kernel/vpe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/mips/kernel/vpe.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/vpe.c
+++ linux-2.6/arch/mips/kernel/vpe.c
@@ -148,9 +148,9 @@ struct {
 	spinlock_t tc_list_lock;
 	struct list_head tc_list;	/* Thread contexts */
 } vpecontrol = {
-	.vpe_list_lock	= SPIN_LOCK_UNLOCKED,
+	.vpe_list_lock	= __SPIN_LOCK_UNLOCKED(vpe_list_lock),
 	.vpe_list	= LIST_HEAD_INIT(vpecontrol.vpe_list),
-	.tc_list_lock	= SPIN_LOCK_UNLOCKED,
+	.tc_list_lock	= __SPIN_LOCK_UNLOCKED(tc_list_lock),
 	.tc_list	= LIST_HEAD_INIT(vpecontrol.tc_list)
 };
 


