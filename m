Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950Ab0FRKTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 06:19:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:46952 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab0FRKTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 06:19:31 -0400
Date: Fri, 18 Jun 2010 10:18:51 GMT
From: tip-bot for Michael Neuling <mikey@neuling.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu,
       mikey@neuling.org
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mikey@neuling.org,
       mingo@elte.hu
In-Reply-To: <12629.1276124617@neuling.org>
References: <12629.1276124617@neuling.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix fix_small_capacity
Message-ID: <tip-694f5a1112959a6996cabdb6f8d3003e87dac8a7@git.kernel.org>
Git-Commit-ID: 694f5a1112959a6996cabdb6f8d3003e87dac8a7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 18 Jun 2010 10:18:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  694f5a1112959a6996cabdb6f8d3003e87dac8a7
Gitweb:     http://git.kernel.org/tip/694f5a1112959a6996cabdb6f8d3003e87dac8a7
Author:     Michael Neuling <mikey@neuling.org>
AuthorDate: Thu, 10 Jun 2010 09:03:37 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 18 Jun 2010 10:46:54 +0200

sched: Fix fix_small_capacity

The CPU power test is the wrong way around in fix_small_capacity.

This was due to a small changes made in the posted patch on lkml to what
was was taken upstream.

This patch fixes asymmetric packing for POWER7.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <12629.1276124617@neuling.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 593424f..e82c572 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2354,7 +2354,7 @@ fix_small_capacity(struct sched_domain *sd, struct sched_group *group)
 	/*
 	 * If ~90% of the cpu_power is still there, we're good.
 	 */
-	if (group->cpu_power * 32 < group->cpu_power_orig * 29)
+	if (group->cpu_power * 32 > group->cpu_power_orig * 29)
 		return 1;
 
 	return 0;
