Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848Ab2KSF2y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:28:54 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46956 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab2KSF2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:28:53 -0500
X-Originating-IP: 217.70.178.146
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 03/58] sched: Mark scale_rt_power static
Date: Sun, 18 Nov 2012 21:27:42 -0800
Message-Id: <1353302917-13995-4-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nothing outside of kernel/sched/fair.c references scale_rt_power, so
mark it static.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6b800a1..7e29e80 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3508,7 +3508,7 @@ unsigned long __weak arch_scale_smt_power(struct sched_domain *sd, int cpu)
 	return default_scale_smt_power(sd, cpu);
 }
 
-unsigned long scale_rt_power(int cpu)
+static unsigned long scale_rt_power(int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 	u64 total, available, age_stamp, avg;
-- 
1.7.10.4

