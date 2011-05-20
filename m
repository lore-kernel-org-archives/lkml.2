Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934625Ab1ETOCj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 10:02:39 -0400
Received: from mail201c2.megamailservers.com ([69.49.111.102]:57976 "EHLO
	mail201c2.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933417Ab1ETOCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 10:02:35 -0400
X-POP-User: ekergarn.gaisler.com
From: Daniel Hellstrom <daniel@gaisler.com>
To: davem@davemloft.net
Cc: sparclinux@vger.kernel.org, sfr@canb.auug.org.au, peterz@infradead.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] SCHED_TTWU_QUEUE is not longer needed since sparc32 now implements IPI
Date: Fri, 20 May 2011 16:01:10 +0200
Message-Id: <1305900070-23492-2-git-send-email-daniel@gaisler.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1305900070-23492-1-git-send-email-daniel@gaisler.com>
References: <1305900070-23492-1-git-send-email-daniel@gaisler.com>
X-CSC: 0
X-CHA: v=1.1 cv=Ma2F9VxktdrohpwE1Ldo3j5zboDzDSax3kyf6Hawm04= c=1 sm=1
		a=TifMFHYAFKEA:10 a=U62ajLuCel8A:10 a=jXKJviUpWSOlMmIvGrHOfw==:17
		a=ebG-ZW-8AAAA:8 a=JfrnYn6hAAAA:8 a=bw3_O8cTzjzsYDiTHMUA:9
		a=cCYF7-FHeg4A:10 a=3Rfx1nUSh_UA:10 a=jXKJviUpWSOlMmIvGrHOfw==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Hellstrom <daniel@gaisler.com>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Peter Zijlstra <peterz@infradead.org>
---
 init/Kconfig   |    5 -----
 kernel/sched.c |    2 +-
 2 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index df64627..a66b656 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -827,11 +827,6 @@ config SCHED_AUTOGROUP
 	  desktop applications.  Task group autogeneration is currently based
 	  upon task session.
 
-config SCHED_TTWU_QUEUE
-	bool
-	depends on !SPARC32
-	default y
-
 config MM_OWNER
 	bool
 
diff --git a/kernel/sched.c b/kernel/sched.c
index c62acf4..0516af4 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2564,7 +2564,7 @@ static void ttwu_queue(struct task_struct *p, int cpu)
 {
 	struct rq *rq = cpu_rq(cpu);
 
-#if defined(CONFIG_SMP) && defined(CONFIG_SCHED_TTWU_QUEUE)
+#if defined(CONFIG_SMP)
 	if (sched_feat(TTWU_QUEUE) && cpu != smp_processor_id()) {
 		ttwu_queue_remote(p, cpu);
 		return;
-- 
1.6.0.3

