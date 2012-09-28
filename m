Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946296Ab2I1VhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:37:11 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:63816 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946284Ab2I1VhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:37:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Peter Boonstoppel <pboonstoppel@nvidia.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 06/12] sched: warnings in kernel/sched/fair.c
Date: Fri, 28 Sep 2012 23:36:11 +0200
Message-Id: <1348868177-21205-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1348868177-21205-1-git-send-email-arnd@arndb.de>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:BHKeKtOq4R3m/22RztqFL5Qg5W/R+pEO7G8qS2DgudS
 Lnd1uO35N8Hnb0vHSdoj6RSaqS1x6OHYy6pq3EuqLKVzLMPdhC
 K59mmJWuww1Hi19Cb1B16IUMO/cwKyDz9Yecpz9i1wgd2cl2gG
 DPgz1OMu8SLtv5pwmOQqL8+vggt2drD7zhuyoK+UFZ2OA8xBtp
 mY9xRxxZQrqT3ZFmkBhVSomcgIlr/MfSTTOPHAX18s4WC2jXMS
 N3OPd9gdBuWz1yi5Z5EjsY8ZcRv+nqjlKP5qJgSHK0qxC/7d8H
 EtY9lYmESCvn5F1btxlgRnafo2g3HBCDf0BUA4wuMgs/y7EIs1
 24MT81d7M5Y7zF2NAtCel8T7VUUl1veMH3bA96kZTuIViGOhsU
 AjFISerASYjbA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a4c96ae319 "sched: Unthrottle rt runqueues in __disable_runtime()"
turned the unthrottle_offline_cfs_rqs function into a static symbol,
which now triggers a warning about it being potentially unused:

kernel/sched/fair.c:2055:13: warning: 'unthrottle_offline_cfs_rqs' defined but not used [-Wunused-function]

Marking it __maybe_unused shuts up the gcc warning and lets the
compiler safely drop the function body when it's not being used.

To reproduce, build the ARM bcm2835_defconfig.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Peter Boonstoppel <pboonstoppel@nvidia.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Turner <pjt@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/fair.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 6b800a1..9f52728 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2052,7 +2052,7 @@ static void destroy_cfs_bandwidth(struct cfs_bandwidth *cfs_b)
 	hrtimer_cancel(&cfs_b->slack_timer);
 }
 
-static void unthrottle_offline_cfs_rqs(struct rq *rq)
+static void __maybe_unused unthrottle_offline_cfs_rqs(struct rq *rq)
 {
 	struct cfs_rq *cfs_rq;
 
-- 
1.7.10

