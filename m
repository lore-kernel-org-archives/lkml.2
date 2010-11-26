Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab0KZCUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 21:20:09 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:61840 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab0KZCUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 21:20:07 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
        h.mitake@gmail.com, Arjan van de Ven <arjan@linux.intel.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH] workqueue: check the allocation of system_unbound_wq
Date: Fri, 26 Nov 2010 11:19:51 +0900
Message-Id: <1290737991-23163-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a trivial bug on initialization of workqueue.
Current init_workqueues doesn't check the result of
allocation of system_unbound_wq, this should be checked
like other queues.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Howells <dhowells@redhat.com>
---
 kernel/workqueue.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 90db1bd..b60374d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3692,7 +3692,8 @@ static int __init init_workqueues(void)
 	system_nrt_wq = alloc_workqueue("events_nrt", WQ_NON_REENTRANT, 0);
 	system_unbound_wq = alloc_workqueue("events_unbound", WQ_UNBOUND,
 					    WQ_UNBOUND_MAX_ACTIVE);
-	BUG_ON(!system_wq || !system_long_wq || !system_nrt_wq);
+	BUG_ON(!system_wq || !system_long_wq ||
+		!system_nrt_wq || !system_unbound_wq);
 	return 0;
 }
 early_initcall(init_workqueues);
-- 
1.6.5.2

