Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab1LFJwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 04:52:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34924 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933063Ab1LFJwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 04:52:30 -0500
Date: Tue, 6 Dec 2011 01:51:55 -0800
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-4d78a2239e393f09e0964a2f8da394cc91d75155@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, suresh.b.siddha@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20111118230554.164910950@sbsiddha-desk.sc.intel.com>
References: <20111118230554.164910950@sbsiddha-desk.sc.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix the sched group node allocation for SD_OVERLAP domains
Git-Commit-ID: 4d78a2239e393f09e0964a2f8da394cc91d75155
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 06 Dec 2011 01:52:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d78a2239e393f09e0964a2f8da394cc91d75155
Gitweb:     http://git.kernel.org/tip/4d78a2239e393f09e0964a2f8da394cc91d75155
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 18 Nov 2011 15:03:29 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 6 Dec 2011 09:06:26 +0100

sched: Fix the sched group node allocation for SD_OVERLAP domains

For the SD_OVERLAP domain, sched_groups for each CPU's sched_domain are
privately allocated and not shared with any other cpu. So the
sched group allocation should come from the cpu's node for which
SD_OVERLAP sched domain is being setup.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20111118230554.164910950@sbsiddha-desk.sc.intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index db313c3..07f1e99 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5885,7 +5885,7 @@ build_overlap_sched_groups(struct sched_domain *sd, int cpu)
 			continue;
 
 		sg = kzalloc_node(sizeof(struct sched_group) + cpumask_size(),
-				GFP_KERNEL, cpu_to_node(i));
+				GFP_KERNEL, cpu_to_node(cpu));
 
 		if (!sg)
 			goto fail;
