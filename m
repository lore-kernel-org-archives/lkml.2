Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab2LTTOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:14:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21501 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab2LTTNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:13:51 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Josh Triplett <josh@freedesktop.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] rcutorture: don't compare ptr with 0
Date: Thu, 20 Dec 2012 14:11:28 -0500
Message-Id: <1356030701-16284-20-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
References: <1356030701-16284-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/rcutorture.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 31dea01..0249800 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -1749,7 +1749,7 @@ static int rcu_torture_barrier_init(void)
 	barrier_cbs_wq =
 		kzalloc(n_barrier_cbs * sizeof(barrier_cbs_wq[0]),
 			GFP_KERNEL);
-	if (barrier_cbs_tasks == NULL || barrier_cbs_wq == 0)
+	if (barrier_cbs_tasks == NULL || !barrier_cbs_wq)
 		return -ENOMEM;
 	for (i = 0; i < n_barrier_cbs; i++) {
 		init_waitqueue_head(&barrier_cbs_wq[i]);
-- 
1.8.0

