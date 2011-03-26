Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab1CZMw5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 08:52:57 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63327 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1CZMw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 08:52:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Vm9h+lmdwUt1HymeykwKWorS5CONj0x91qLVGDHQEIndJbiKVimpBBNP99brH3BUqY
         /c2z4DmLXFbmDj1KkD6uKNQ00zFM2R6DZK47RqDMJgdfYaGo99t5CgMdt8lAC3J1Ugun
         9hsQBDe2KQDfIrgAu2IRd3khMcBwbSCjtA//g=
MIME-Version: 1.0
Date: Sat, 26 Mar 2011 18:22:55 +0530
Message-ID: <AANLkTikqHWid2Q93F5U5Qw5snJH8C5PXoa7J6=6hYO94@mail.gmail.com>
Subject: [PATCH] sched: Replace NR_CPUS with num_online_cpus()
From: Sisir Koppaka <sisir.koppaka@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The interval for checking scheduling domains if they are due to be
balanced currently depends on boot state NR_CPUS, which may not
accurately reflect the number of online CPUs at the time of check.

Signed-off-by: Sisir Koppaka <sisir.koppaka@gmail.com>
---
 kernel/sched_fair.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 3f7ec9e..c7ec5c8 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -22,6 +22,7 @@

 #include <linux/latencytop.h>
 #include <linux/sched.h>
+#include <linux/cpumask.h>

 /*
  * Targeted preemption latency for CPU-bound tasks:
@@ -3850,8 +3851,8 @@ static void rebalance_domains(int cpu, enum
cpu_idle_type idle)
 		interval = msecs_to_jiffies(interval);
 		if (unlikely(!interval))
 			interval = 1;
-		if (interval > HZ*NR_CPUS/10)
-			interval = HZ*NR_CPUS/10;
+		if (interval > HZ*num_online_cpus()/10)
+			interval = HZ*num_online_cpus()/10;

 		need_serialize = sd->flags & SD_SERIALIZE;

-- 
1.7.0.4

Sisir
