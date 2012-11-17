Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab2KQFT4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 00:19:56 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35611 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab2KQFTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 00:19:54 -0500
MIME-Version: 1.0
Date: Sat, 17 Nov 2012 13:19:53 +0800
Message-ID: <CAJd=RBCGTiU9wwKCfH1wwcLLtxEB1AW4DUfRjJiRD8WaJiG4wg@mail.gmail.com>
Subject: [PATCH 4/5] balancenuma: check mem node in finding placement
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No point to migrate task from node A to node A.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched/fair.c	Sat Nov 17 12:25:44 2012
+++ b/kernel/sched/fair.c	Sat Nov 17 12:25:54 2012
@@ -891,6 +891,8 @@ static void task_numa_find_placement(str
 	/* Examine a task on every other node */
 	for_each_online_node(nid) {
 		int cpu;
+		if (nid == this_nid)
+			continue;
 		for_each_cpu_and(cpu, cpumask_of_node(nid), allowed) {
 			struct rq *rq;
 			struct mm_struct *other_mm;
--
