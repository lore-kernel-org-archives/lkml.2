Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2FEPwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:52:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56919 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab2FEPwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:52:12 -0400
Date: Tue, 5 Jun 2012 08:50:34 -0700
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Message-ID: <tip-72ec61a9e8347375e37c05e23511173d8451c3d4@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, benh@kernel.crashing.org,
        tglx@linutronix.de, yong.zhang0@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, benh@kernel.crashing.org,
        yong.zhang0@gmail.com, tglx@linutronix.de
In-Reply-To: <1338275765-3217-10-git-send-email-yong.zhang0@gmail.com>
References: <1338275765-3217-10-git-send-email-yong.zhang0@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] POWERPC: Smp: remove call to ipi_call_lock()/
 ipi_call_unlock()
Git-Commit-ID: 72ec61a9e8347375e37c05e23511173d8451c3d4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 05 Jun 2012 08:50:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  72ec61a9e8347375e37c05e23511173d8451c3d4
Gitweb:     http://git.kernel.org/tip/72ec61a9e8347375e37c05e23511173d8451c3d4
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Tue, 29 May 2012 15:16:04 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 5 Jun 2012 17:27:13 +0200

POWERPC: Smp: remove call to ipi_call_lock()/ipi_call_unlock()

ipi_call_lock/unlock() lock resp. unlock call_function.lock. This lock
protects only the call_function data structure itself, but it's
completely unrelated to cpu_online_mask. The mask to which the IPIs
are sent is calculated before call_function.lock is taken in
smp_call_function_many(), so the locking around set_cpu_online() is
pointless and can be removed.

[ tglx: Massaged changelog ]

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: ralf@linux-mips.org
Cc: sshtylyov@mvista.com
Cc: david.daney@cavium.com
Cc: nikunj@linux.vnet.ibm.com
Cc: paulmck@linux.vnet.ibm.com
Cc: axboe@kernel.dk
Cc: peterz@infradead.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/r/1338275765-3217-10-git-send-email-yong.zhang0@gmail.com
Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/powerpc/kernel/smp.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index e4cb343..e1417c4 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -571,7 +571,6 @@ void __devinit start_secondary(void *unused)
 	if (system_state == SYSTEM_RUNNING)
 		vdso_data->processorCount++;
 #endif
-	ipi_call_lock();
 	notify_cpu_starting(cpu);
 	set_cpu_online(cpu, true);
 	/* Update sibling maps */
@@ -601,7 +600,6 @@ void __devinit start_secondary(void *unused)
 		of_node_put(np);
 	}
 	of_node_put(l2_cache);
-	ipi_call_unlock();
 
 	local_irq_enable();
 
