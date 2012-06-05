Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2FEPvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:51:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56910 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab2FEPve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:51:34 -0400
Date: Tue, 5 Jun 2012 08:46:10 -0700
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Message-ID: <tip-46ce7fbfdbe0be6aaf0e816331aac08a74a00e5a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, schwidefsky@de.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, heiko.carstens@de.ibm.com,
        tglx@linutronix.de, yong.zhang0@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, heiko.carstens@de.ibm.com,
        yong.zhang0@gmail.com, tglx@linutronix.de
In-Reply-To: <1338275765-3217-5-git-send-email-yong.zhang0@gmail.com>
References: <1338275765-3217-5-git-send-email-yong.zhang0@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] S390: Smp: remove call to ipi_call_lock()/
 ipi_call_unlock()
Git-Commit-ID: 46ce7fbfdbe0be6aaf0e816331aac08a74a00e5a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 05 Jun 2012 08:46:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  46ce7fbfdbe0be6aaf0e816331aac08a74a00e5a
Gitweb:     http://git.kernel.org/tip/46ce7fbfdbe0be6aaf0e816331aac08a74a00e5a
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Tue, 29 May 2012 15:15:59 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 5 Jun 2012 17:27:12 +0200

S390: Smp: remove call to ipi_call_lock()/ipi_call_unlock()

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
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
Cc: linux-s390@vger.kernel.org
Link: http://lkml.kernel.org/r/1338275765-3217-5-git-send-email-yong.zhang0@gmail.com
Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/s390/kernel/smp.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 15cca26..8dca9c2 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -717,9 +717,7 @@ static void __cpuinit smp_start_secondary(void *cpuvoid)
 	init_cpu_vtimer();
 	pfault_init();
 	notify_cpu_starting(smp_processor_id());
-	ipi_call_lock();
 	set_cpu_online(smp_processor_id(), true);
-	ipi_call_unlock();
 	local_irq_enable();
 	/* cpu_idle will call schedule for us */
 	cpu_idle();
