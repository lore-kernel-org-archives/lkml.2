Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855Ab2LVB6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 20:58:51 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:63688 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab2LVB6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 20:58:47 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 25/25] ipc: don't use [delayed_]work_pending()
Date: Fri, 21 Dec 2012 17:57:15 -0800
Message-Id: <1356141435-17340-26-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1356141435-17340-1-git-send-email-tj@kernel.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to test whether a (delayed) work item in pending
before queueing, flushing or cancelling it.  Most uses are unnecessary
and quite a few of them are buggy.

Remove unnecessary pending tests from ipc.  Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Please let me know how this patch should be routed.  I can take it
through the workqueue tree if necessary.

Thanks.

 ipc/util.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/ipc/util.c b/ipc/util.c
index 72fd078..add2776 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -71,8 +71,7 @@ static int ipc_memory_callback(struct notifier_block *self,
 		 * activate the ipcns notification chain.
 		 * No need to keep several ipc work items on the queue.
 		 */
-		if (!work_pending(&ipc_memory_wq))
-			schedule_work(&ipc_memory_wq);
+		schedule_work(&ipc_memory_wq);
 		break;
 	case MEM_GOING_ONLINE:
 	case MEM_GOING_OFFLINE:
-- 
1.8.0.2

