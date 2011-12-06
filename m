Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933097Ab1LFJnQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:43:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34783 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933045Ab1LFJnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:43:09 -0500
Date: Tue, 6 Dec 2011 01:42:46 -0800
From: tip-bot for Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Message-ID: <tip-cc3a1bf52a9d2808c7cd6e8f413b02b650b6b84b@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        ananth@in.ibm.com, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: ananth@in.ibm.com, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111025142159.GB21225@linux.vnet.ibm.com>
References: <20111025142159.GB21225@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Clean up and extend do_int3()
Git-Commit-ID: cc3a1bf52a9d2808c7cd6e8f413b02b650b6b84b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:42:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc3a1bf52a9d2808c7cd6e8f413b02b650b6b84b
Gitweb:     http://git.kernel.org/tip/cc3a1bf52a9d2808c7cd6e8f413b02b650b6b84b
Author:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
AuthorDate: Tue, 25 Oct 2011 19:51:59 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 08:20:37 +0100

x86: Clean up and extend do_int3()

Since there is a possibility of !KPROBES int3 listeners
(such as kgdb) and since DIE_TRAP is currently not being
used by anybody, notify all listeners with DIE_INT3.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20111025142159.GB21225@linux.vnet.ibm.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/traps.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a8e3eb8..fa1191f 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -306,15 +306,10 @@ dotraplinkage void __kprobes do_int3(struct pt_regs *regs, long error_code)
 			== NOTIFY_STOP)
 		return;
 #endif /* CONFIG_KGDB_LOW_LEVEL_TRAP */
-#ifdef CONFIG_KPROBES
+
 	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)
 			== NOTIFY_STOP)
 		return;
-#else
-	if (notify_die(DIE_TRAP, "int3", regs, error_code, 3, SIGTRAP)
-			== NOTIFY_STOP)
-		return;
-#endif
 
 	preempt_conditional_sti(regs);
 	do_trap(3, SIGTRAP, "int3", regs, error_code, NULL);
