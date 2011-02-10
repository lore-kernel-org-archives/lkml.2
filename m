Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1BJMZg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 07:25:36 -0500
Received: from cantor.suse.de ([195.135.220.2]:33819 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755287Ab1BJMZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 07:25:33 -0500
From: stable-bot for Nikhil Rao <ncrao@google.com>
Date: Thu, 10 Feb 2011 10:23:29 +0100
Subject: [PATCH 27/28] sched: Fix idle balancing
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>
Message-ID: <1297340644.5512.27.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit: d5ad140bc1505a98c0f040937125bfcbb508078f upstream
Author: Nikhil Rao <ncrao@google.com>
AuthorDate: Wed Nov 17 11:42:04 2010 -0800

An earlier commit reverts idle balancing throttling reset to fix a 30%
regression in volanomark throughput. We still need to reset idle_stamp
when we pull a task in newidle balance.

Reported-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Nikhil Rao <ncrao@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1290022924-3548-1-git-send-email-ncrao@google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index ffd4f57..f4e1f4e 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4692,8 +4692,10 @@ static void idle_balance(int this_cpu, struct rq *this_rq)
 		interval = msecs_to_jiffies(sd->balance_interval);
 		if (time_after(next_balance, sd->last_balance + interval))
 			next_balance = sd->last_balance + interval;
-		if (pulled_task)
+		if (pulled_task) {
+			this_rq->idle_stamp = 0;
 			break;
+		}
 	}
 	if (pulled_task || time_after(jiffies, this_rq->next_balance)) {
 		/*
-- 
1.7.4


