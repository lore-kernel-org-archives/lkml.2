Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570Ab2IDStp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 14:49:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47898 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757477Ab2IDSto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 14:49:44 -0400
Date: Tue, 4 Sep 2012 11:49:28 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-d00535db42805e9ae5eadf1b4a86e01e85674b0c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <1345083330-19486-1-git-send-email-namhyung@kernel.org>
References: <1345083330-19486-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Add time unit suffix to sched sysctl knobs
Git-Commit-ID: d00535db42805e9ae5eadf1b4a86e01e85674b0c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 04 Sep 2012 11:49:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d00535db42805e9ae5eadf1b4a86e01e85674b0c
Gitweb:     http://git.kernel.org/tip/d00535db42805e9ae5eadf1b4a86e01e85674b0c
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 16 Aug 2012 11:15:30 +0900
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Sep 2012 14:31:34 +0200

sched: Add time unit suffix to sched sysctl knobs

Unlike others, sched_migration_cost, sched_time_avg and
sched_shares_window doesn't have time unit as suffix. Add them.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1345083330-19486-1-git-send-email-namhyung@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sysctl.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 87174ef..81c7b1a 100644
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
