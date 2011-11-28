Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab1K1Lgp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:36:45 -0500
Received: from bender.cm4all.net ([87.106.27.49]:40902 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519Ab1K1Lgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:36:44 -0500
Subject: [PATCH] sched: configure a lockdep class for rq->lock
To: linux-kernel@vger.kernel.org
From: Max Kellermann <mk@cm4all.com>
Date: Mon, 28 Nov 2011 12:38:52 +0100
Message-ID: <20111128113852.23015.88535.stgit@rabbit.intern.cm-ag>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the warning that disables lockdep at runtime:

 INFO: trying to register non-static key.
 the code is fine but needs lockdep annotation.
 turning off the locking correctness validator.

Signed-off-by: Max Kellermann <mk@cm4all.com>
---
 kernel/sched.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index b50b0f0..57f9b37 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -574,6 +574,8 @@ struct rq {
 #endif
 };
 
+static struct lock_class_key rq_lock_class;
+
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
 
@@ -8077,6 +8079,7 @@ void __init sched_init(void)
 
 		rq = cpu_rq(i);
 		raw_spin_lock_init(&rq->lock);
+		lockdep_set_class(&rq->lock, &rq_lock_class);
 		rq->nr_running = 0;
 		rq->calc_load_active = 0;
 		rq->calc_load_update = jiffies + LOAD_FREQ;

