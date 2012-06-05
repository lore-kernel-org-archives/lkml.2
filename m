Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab2FEPqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:46:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56807 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab2FEPqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:46:19 -0400
Date: Tue, 5 Jun 2012 08:45:18 -0700
From: tip-bot for Yong Zhang <yong.zhang0@gmail.com>
Message-ID: <tip-ac4216d6922f90c459d531e051c832dadde3a8f7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        jejb@parisc-linux.org, tglx@linutronix.de, yong.zhang0@gmail.com,
        deller@gmx.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, srivatsa.bhat@linux.vnet.ibm.com,
        jejb@parisc-linux.org, tglx@linutronix.de, yong.zhang0@gmail.com,
        deller@gmx.de
In-Reply-To: <1338275765-3217-4-git-send-email-yong.zhang0@gmail.com>
References: <1338275765-3217-4-git-send-email-yong.zhang0@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] parisc: Smp: remove call to ipi_call_lock()/
 ipi_call_unlock()
Git-Commit-ID: ac4216d6922f90c459d531e051c832dadde3a8f7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 05 Jun 2012 08:45:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ac4216d6922f90c459d531e051c832dadde3a8f7
Gitweb:     http://git.kernel.org/tip/ac4216d6922f90c459d531e051c832dadde3a8f7
Author:     Yong Zhang <yong.zhang0@gmail.com>
AuthorDate: Tue, 29 May 2012 15:15:58 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 5 Jun 2012 17:27:12 +0200

parisc: Smp: remove call to ipi_call_lock()/ipi_call_unlock()

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
Cc: James E.J. Bottomley <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Link: http://lkml.kernel.org/r/1338275765-3217-4-git-send-email-yong.zhang0@gmail.com
Acked-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/parisc/kernel/smp.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/kernel/smp.c b/arch/parisc/kernel/smp.c
index a47828d..6266730 100644
--- a/arch/parisc/kernel/smp.c
+++ b/arch/parisc/kernel/smp.c
@@ -300,9 +300,7 @@ smp_cpu_init(int cpunum)
 
 	notify_cpu_starting(cpunum);
 
-	ipi_call_lock();
 	set_cpu_online(cpunum, true);
-	ipi_call_unlock();
 
 	/* Initialise the idle task for this CPU */
 	atomic_inc(&init_mm.mm_count);
