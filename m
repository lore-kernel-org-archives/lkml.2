Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab2HPCWL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 22:22:11 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47699 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab2HPCWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 22:22:09 -0400
X-AuditID: 9c93016f-b7cc0ae000000e9f-49-502c594f111b
From: Namhyung Kim <namhyung@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH] sched: Add time unit suffix to sched sysctl knobs
Date: Thu, 16 Aug 2012 11:15:30 +0900
Message-Id: <1345083330-19486-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.2
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Unlike others, sched_migration_cost, sched_time_avg and
sched_shares_window doesn't have time unit as suffix. Add them.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/sysctl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 87174ef59161..81c7b1a1a307 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -307,7 +307,7 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &max_sched_tunable_scaling,
 	},
 	{
-		.procname	= "sched_migration_cost",
+		.procname	= "sched_migration_cost_ns",
 		.data		= &sysctl_sched_migration_cost,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
@@ -321,14 +321,14 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 	{
-		.procname	= "sched_time_avg",
+		.procname	= "sched_time_avg_ms",
 		.data		= &sysctl_sched_time_avg,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
 	{
-		.procname	= "sched_shares_window",
+		.procname	= "sched_shares_window_ns",
 		.data		= &sysctl_sched_shares_window,
 		.maxlen		= sizeof(unsigned int),
 		.mode		= 0644,
-- 
1.7.11.2

