Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab2ENNoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:44:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56566 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab2ENNoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:44:18 -0400
Date: Mon, 14 May 2012 06:43:47 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-0sqhrht34phowgclj12dgk8h@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, a.p.zijlstra@chello.nl, greg.pearson@hp.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, a.p.zijlstra@chello.nl, greg.pearson@hp.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/numa: Fix the new NUMA topology bits
Git-Commit-ID: dd7d8634e619b715a537402672d1383535ff4c54
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 14 May 2012 06:43:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd7d8634e619b715a537402672d1383535ff4c54
Gitweb:     http://git.kernel.org/tip/dd7d8634e619b715a537402672d1383535ff4c54
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 11 May 2012 00:56:20 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 14 May 2012 15:05:25 +0200

sched/numa: Fix the new NUMA topology bits

There's no need to convert a node number to a node number by
pretending its a cpu number..

Reported-by: Yinghai Lu <yinghai@kernel.org>
Reported-and-Tested-by: Greg Pearson <greg.pearson@hp.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-0sqhrht34phowgclj12dgk8h@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b4f2096..0738036 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6395,8 +6395,7 @@ static void sched_init_numa(void)
 			sched_domains_numa_masks[i][j] = mask;
 
 			for (k = 0; k < nr_node_ids; k++) {
-				if (node_distance(cpu_to_node(j), k) >
-						sched_domains_numa_distance[i])
+				if (node_distance(j, k) > sched_domains_numa_distance[i])
 					continue;
 
 				cpumask_or(mask, mask, cpumask_of_node(k));
