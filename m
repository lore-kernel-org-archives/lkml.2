Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab1LULn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:43:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33983 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab1LULnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:43:53 -0500
Date: Wed, 21 Dec 2011 03:43:27 -0800
From: tip-bot for Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Message-ID: <tip-11534ec5b6cea13ae38d31799d2a5290c5d724af@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        kamalesh@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kamalesh@linux.vnet.ibm.com, a.p.zijlstra@chello.nl, pjt@google.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111210135925.GA14593@linux.vnet.ibm.com>
References: <20111210135925.GA14593@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Remove cfs bandwidth period check in tg_set_cfs_period()
Git-Commit-ID: 11534ec5b6cea13ae38d31799d2a5290c5d724af
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 03:43:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11534ec5b6cea13ae38d31799d2a5290c5d724af
Gitweb:     http://git.kernel.org/tip/11534ec5b6cea13ae38d31799d2a5290c5d724af
Author:     Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
AuthorDate: Sat, 10 Dec 2011 19:29:25 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Dec 2011 10:34:48 +0100

sched: Remove cfs bandwidth period check in tg_set_cfs_period()

Remove cfs bandwidth period check from tg_set_cfs_period.
Invalid bandwidth period's lower/upper limits are denoted
by min_cfs_quota_period/max_cfs_quota_period repsectively,
and are checked against valid period in tg_set_cfs_bandwidth().

As pjt pointed out, negative input will result in very large unsigned
numbers and will be caught by the max allowed period test.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Acked-by: Paul Turner <pjt@google.com>
[ammended changelog to mention negative values]
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20111210135925.GA14593@linux.vnet.ibm.com
--
 kernel/sched/core.c |    3 ---
 1 file changed, 3 deletions(-)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index dba878c..081ece2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -7714,9 +7714,6 @@ int tg_set_cfs_period(struct task_group *tg, long cfs_period_us)
 	period = (u64)cfs_period_us * NSEC_PER_USEC;
 	quota = tg->cfs_bandwidth.quota;
 
-	if (period <= 0)
-		return -EINVAL;
-
 	return tg_set_cfs_bandwidth(tg, period, quota);
 }
 
