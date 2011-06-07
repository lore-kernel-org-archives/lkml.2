Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1FGJsy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 05:48:54 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:55434 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab1FGJsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 05:48:53 -0400
Subject: [PATCH] sched: remove redundant check in select_task_rq_fair
To: peterz@infradead.org, mingo@elte.hu
From: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Date: Tue, 07 Jun 2011 15:18:47 +0530
Message-ID: <20110607094821.29969.50197.stgit@IBM-009124035060.in.ibm.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When balancing for wakeup affinity, a redundant check can removed.

Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
---
 kernel/sched_fair.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 433491c..b9e5701 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1753,7 +1753,7 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	}
 
 	if (affine_sd) {
-		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
+		if (wake_affine(affine_sd, p, sync))
 			prev_cpu = cpu;
 
 		new_cpu = select_idle_sibling(p, prev_cpu);

