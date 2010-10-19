Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243Ab0JSK5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:57:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:39430 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757935Ab0JSK5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:57:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=cn7pXktHTvFCPKv+X1ACww/gDmtRgItp5wRVQbUwuu30EpPmMSlGUgIO1pAo8kS7/R
         RuNqNw1WKQjjQUdCrrk99S0zrGnKZE+BxPy0+7BNgkw+2hHMkS6h5LDc9Q3FclrRffe8
         8n9LKV8CYYO9TagQDJq/XIF8AG11+5a5kNOOc=
MIME-Version: 1.0
Date: Tue, 19 Oct 2010 16:57:39 +0600
Message-ID: <AANLkTinoaJX3M2zU_zZOpmFm9Ekxpw-LUVUf_TU8yuSq@mail.gmail.com>
Subject: [PATCH] sched_rt: Removes extra checking for nr_cpus_allowed when
 calling find_lowest_rq
From: Rakib Mullick <rakib.mullick@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 sched_rt: Removes extra checking for nr_cpus_allowed when calling
find_lowest_rq

Remove the check for nr_cpus_allowed of an RT task before calling
find_lowest_cpu() from select_task_rq_rt function. Cause
find_lowest_cpu checks for rt.nr_cpus_allowed of a process.
It would've been nice, if we make the check before calling
find_lowest_cpu. But its called from other places, so keep the
nr_cpus_allowed check into find_lowest_cpu().


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

--- linus-rc8/kernel/sched_rt.c	2010-10-15 05:26:43.000000000 +0600
+++ rakib-rc8/kernel/sched_rt.c	2010-10-19 16:22:30.000000000 +0600
@@ -971,8 +971,7 @@ select_task_rq_rt(struct rq *rq, struct
 	 * that is just being woken and probably will have
 	 * cold cache anyway.
 	 */
-	if (unlikely(rt_task(rq->curr)) &&
-	    (p->rt.nr_cpus_allowed > 1)) {
+	if (unlikely(rt_task(rq->curr))) {
 		int cpu = find_lowest_rq(p);

 		return (cpu == -1) ? task_cpu(p) : cpu;
