Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1LFUZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 15:25:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38302 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab1LFUZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 15:25:24 -0500
Date: Tue, 6 Dec 2011 12:24:55 -0800
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-cd490c5b285544dc1319cf79c2ca0528a6447f61@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        suresh.b.siddha@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1323199594.1984.18.camel@sbsiddha-desk.sc.intel.com>
References: <1323199594.1984.18.camel@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched, nohz: Set the NOHZ_BALANCE_KICK flag for idle load balancer
Git-Commit-ID: cd490c5b285544dc1319cf79c2ca0528a6447f61
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 12:25:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cd490c5b285544dc1319cf79c2ca0528a6447f61
Gitweb:     http://git.kernel.org/tip/cd490c5b285544dc1319cf79c2ca0528a6447f61
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Tue, 6 Dec 2011 11:26:34 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 20:51:29 +0100

sched, nohz: Set the NOHZ_BALANCE_KICK flag for idle load balancer

Intention is to set the NOHZ_BALANCE_KICK flag for the 'ilb_cpu'. Not
for the 'cpu' which is the local cpu. Fix the typo.

Reported-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1323199594.1984.18.camel@sbsiddha-desk.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 8be45ed..6482136 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4853,7 +4853,7 @@ static void nohz_balancer_kick(int cpu)
 	if (ilb_cpu >= nr_cpu_ids)
 		return;
 
-	if (test_and_set_bit(NOHZ_BALANCE_KICK, nohz_flags(cpu)))
+	if (test_and_set_bit(NOHZ_BALANCE_KICK, nohz_flags(ilb_cpu)))
 		return;
 	/*
 	 * Use smp_send_reschedule() instead of resched_cpu().
