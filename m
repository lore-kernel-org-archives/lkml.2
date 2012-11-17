Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2KQFLG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 00:11:06 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:56778 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174Ab2KQFLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 00:11:04 -0500
MIME-Version: 1.0
Date: Sat, 17 Nov 2012 13:11:03 +0800
Message-ID: <CAJd=RBAHsyFmU-XArPt9WPnbktUQ9mNn3N6voM1BFKgOiHpXJg@mail.gmail.com>
Subject: [PATCH 2/5] balancenuma: fix numa fault statistics
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simply use @pages as we handle both pte and pmd numa faults.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched/fair.c	Sat Nov 17 11:40:36 2012
+++ b/kernel/sched/fair.c	Sat Nov 17 12:05:06 2012
@@ -1112,10 +1112,10 @@ void task_numa_fault(int node, int pages
 	}

 	/* Record fault statistics */
-	p->task_balancenuma->task_numa_fault_tot++;
-	p->task_balancenuma->task_numa_fault[node]++;
-	p->mm->mm_balancenuma->mm_numa_fault_tot++;
-	p->mm->mm_balancenuma->mm_numa_fault[node]++;
+	p->task_balancenuma->task_numa_fault_tot	+= pages;
+	p->task_balancenuma->task_numa_fault[node]	+= pages;
+	p->mm->mm_balancenuma->mm_numa_fault_tot	+= pages;
+	p->mm->mm_balancenuma->mm_numa_fault[node]	+= pages;

 	task_numa_placement(p);
 }
--
