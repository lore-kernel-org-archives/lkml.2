Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477Ab1LJN7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 08:59:39 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:60172 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab1LJN7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 08:59:38 -0500
Date: Sat, 10 Dec 2011 19:29:25 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Turner <pjt@google.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH tip] sched/trivial: Remove cfs bandwidth period check in
 tg_set_cfs_period()
Message-ID: <20111210135925.GA14593@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11121013-8878-0000-0000-000000870E54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sched: Remove cfs bandwidth period check in tg_set_cfs_period()

Remove cfs bandwidth period check from tg_set_cfs_period.
Invalid bandwidth period's lower/upper limits are denoted
by min_cfs_quota_period/max_cfs_quota_period repsectively,
and are checked against valid period in tg_set_cfs_bandwidth().

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
-- 
 kernel/sched/core.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3c5b21e..57cf3ab 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7689,9 +7689,6 @@ int tg_set_cfs_period(struct task_group *tg, long cfs_period_us)
 	period = (u64)cfs_period_us * NSEC_PER_USEC;
 	quota = tg->cfs_bandwidth.quota;
 
-	if (period <= 0)
-		return -EINVAL;
-
 	return tg_set_cfs_bandwidth(tg, period, quota);
 }
 

