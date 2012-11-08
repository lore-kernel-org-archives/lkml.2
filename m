Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab2KHID4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 03:03:56 -0500
Received: from service87.mimecast.com ([91.220.42.44]:55211 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab2KHIDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 03:03:52 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linaro-dev@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] sched/fair: Set se->vruntime directly in place_entity()
Date: Thu,  8 Nov 2012 13:33:46 +0530
Message-Id: <ae59db1945518d6f6250920d46eb1f1a9cc0024e.1352361704.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 08 Nov 2012 08:03:49.0045 (UTC) FILETIME=[95863E50:01CDBD87]
X-MC-Unique: 112110808035002401
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id qA883wuo024814

We are first storing the new vruntime in a variable and then storing it in
se->vruntime. Simply update se->vruntime directly.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 kernel/sched/fair.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a319d56c..820a2f1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1454,9 +1454,7 @@ place_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int initial)
 	}
 
 	/* ensure we never gain time by being placed backwards. */
-	vruntime = max_vruntime(se->vruntime, vruntime);
-
-	se->vruntime = vruntime;
+	se->vruntime = max_vruntime(se->vruntime, vruntime);
 }
 
 static void check_enqueue_throttle(struct cfs_rq *cfs_rq);
-- 
1.7.12.rc2.18.g61b472e


