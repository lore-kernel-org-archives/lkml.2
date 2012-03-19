Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758926Ab2CSNAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 09:00:01 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58296 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758520Ab2CSM77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 08:59:59 -0400
MIME-Version: 1.0
Date: Mon, 19 Mar 2012 20:59:59 +0800
Message-ID: <CAJd=RBAYQYCaUFUY1xNOFhjLyvoYWUAKJy5Xgk197Z1VH5Q8Tg@mail.gmail.com>
Subject: [PATCH 2/2] autonuma: fix typo in blind balance
From: Hillf Danton <dhillf@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since it is certain that nid is not online in each round of for-loop,
it is replaced with given node id.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched/numa.c	Sat Mar 17 11:01:40 2012
+++ b/kernel/sched/numa.c	Mon Mar 19 20:04:00 2012
@@ -34,7 +34,7 @@ static int autonuma_balance_blind(struct
 		selected_nid = cpu_nid;

 		nr_mm_max = 0;
-		for_each_cpu_and(cpu, cpumask_of_node(nid), allowed) {
+		for_each_cpu_and(cpu, cpumask_of_node(cpu_nid), allowed) {
 			struct rq *rq = cpu_rq(cpu);
 			if (rq->curr->mm == mm)
 				nr_mm_max++;
--
