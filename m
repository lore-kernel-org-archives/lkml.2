Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab2FEPqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:46:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56801 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2FEPqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:46:04 -0400
Date: Tue, 5 Jun 2012 08:44:25 -0700
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Message-ID: <tip-4cbd19fcf9d49f28766415b96eb6201bc263d817@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        yasutake.koichi@jp.panasonic.com, dhowells@redhat.com,
        tglx@linutronix.de, yong.zhang0@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        yasutake.koichi@jp.panasonic.com, dhowells@redhat.com,
        yong.zhang0@gmail.com, tglx@linutronix.de
In-Reply-To: <1338275765-3217-3-git-send-email-yong.zhang0@gmail.com>
References: <1338275765-3217-3-git-send-email-yong.zhang0@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] mn10300: SMP: Remove call to ipi_call_lock()/
 ipi_call_unlock()
Git-Commit-ID: 4cbd19fcf9d49f28766415b96eb6201bc263d817
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 05 Jun 2012 08:44:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4cbd19fcf9d49f28766415b96eb6201bc263d817
Gitweb:     http://git.kernel.org/tip/4cbd19fcf9d49f28766415b96eb6201bc263d817
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Tue, 29 May 2012 15:15:57 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 5 Jun 2012 17:27:12 +0200

mn10300: SMP: Remove call to ipi_call_lock()/ipi_call_unlock()

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
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-am33-list@redhat.com
Link: http://lkml.kernel.org/r/1338275765-3217-3-git-send-email-yong.zhang0@gmail.com
Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/mn10300/kernel/smp.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/mn10300/kernel/smp.c b/arch/mn10300/kernel/smp.c
index 090d35d..e62c223 100644
--- a/arch/mn10300/kernel/smp.c
+++ b/arch/mn10300/kernel/smp.c
@@ -876,9 +876,7 @@ static void __init smp_online(void)
 
 	notify_cpu_starting(cpu);
 
-	ipi_call_lock();
 	set_cpu_online(cpu, true);
-	ipi_call_unlock();
 
 	local_irq_enable();
 }
