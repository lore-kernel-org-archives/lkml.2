Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934441Ab1JELch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 07:32:37 -0400
Received: from www.linutronix.de ([62.245.132.108]:60661 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934221Ab1JELcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 07:32:36 -0400
Date: Wed, 5 Oct 2011 13:32:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>
Subject: sched: Warn on rt throttling
Message-ID: <alpine.LFD.2.02.1110051331480.18778@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The default rt-throttling is a source of never ending questions. Warn
once when we go into throttling so folks have that info in dmesg.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 kernel/sched_rt.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/kernel/sched_rt.c
===================================================================
--- linux-2.6.orig/kernel/sched_rt.c
+++ linux-2.6/kernel/sched_rt.c
@@ -631,6 +631,7 @@ static int sched_rt_runtime_exceeded(str
 
 	if (rt_rq->rt_time > runtime) {
 		rt_rq->rt_throttled = 1;
+		printk_once(KERN_WARNING "sched: RT throttling activated\n");
 		if (rt_rq_throttled(rt_rq)) {
 			sched_rt_rq_dequeue(rt_rq);
 			return 1;
