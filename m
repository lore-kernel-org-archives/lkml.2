Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab1GSU6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 16:58:36 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:4630 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1GSU6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 16:58:34 -0400
Message-ID: <4E25F006.2010205@hp.com>
Date: Tue, 19 Jul 2011 14:58:46 -0600
From: Terry Loftin <terry.loftin@hp.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>
CC: Bob Montgomery <bob.montgomery@hp.com>
Subject: [PATCH 1/2] sched: Fix "divide error: 0000" in find_busiest_group
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct the protection expression in update_cpu_power() to avoid setting
rq->cpu_power to zero.

Signed-off-by: Terry Loftin <terry.loftin@hp.com>
Signed-off-by: Bob Montgomery <bob.montgomery@hp.com>
---
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 0c26e2d..9c50020 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -2549,7 +2549,7 @@ static void update_cpu_power(struct sched_domain *sd, int cpu)
 	power *= scale_rt_power(cpu);
 	power >>= SCHED_LOAD_SHIFT;

-	if (!power)
+	if ((u32)power == 0)
 		power = 1;

 	cpu_rq(cpu)->cpu_power = power;
