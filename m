Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab1LFUYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:24:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38288 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab1LFUYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:24:32 -0500
Date: Tue, 6 Dec 2011 12:24:09 -0800
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-8a6d42d1b32ad239c28f445138ea9c19aa52dd20@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1323199177.1984.12.camel@sbsiddha-desk.sc.intel.com>
References: <1323199177.1984.12.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, nohz: Fix the idle cpu check in nohz_idle_balance
Git-Commit-ID: 8a6d42d1b32ad239c28f445138ea9c19aa52dd20
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 12:24:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8a6d42d1b32ad239c28f445138ea9c19aa52dd20
Gitweb:     http://git.kernel.org/tip/8a6d42d1b32ad239c28f445138ea9c19aa52dd20
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 6 Dec 2011 11:19:37 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 20:51:27 +0100

sched, nohz: Fix the idle cpu check in nohz_idle_balance

cpu bit in the nohz.idle_cpu_mask are reset in the first busy tick after
exiting idle. So during nohz_idle_balance(), intention is to double
check if the cpu that is part of the idle_cpu_mask is indeed idle before
going ahead in performing idle balance for that cpu.

Fix the cpu typo in the idle_cpu() check during nohz_idle_balance().

Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1323199177.1984.12.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 4174338..8be45ed 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5020,7 +5020,7 @@ static void nohz_idle_balance(int this_cpu, enum cpu_idle_type idle)
 		goto end;
 
 	for_each_cpu(balance_cpu, nohz.idle_cpus_mask) {
-		if (balance_cpu == this_cpu || !idle_cpu(this_cpu))
+		if (balance_cpu == this_cpu || !idle_cpu(balance_cpu))
 			continue;
 
 		/*
