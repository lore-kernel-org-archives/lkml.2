Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab1CPRLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 13:11:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766Ab1CPRLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:11:21 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] dlm: use alloc_workqueue function
Date: Wed, 16 Mar 2011 11:42:03 -0500
Message-Id: <1300293723-29693-4-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaces deprecated create_singlethread_workqueue().

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lowcomms.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 2d8c87b..bffa1e7 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1468,13 +1468,15 @@ static void work_stop(void)
 
 static int work_start(void)
 {
-	recv_workqueue = create_singlethread_workqueue("dlm_recv");
+	recv_workqueue = alloc_workqueue("dlm_recv",
+					 WQ_UNBOUND | WQ_MEM_RECLAIM, 1);
 	if (!recv_workqueue) {
 		log_print("can't start dlm_recv");
 		return -ENOMEM;
 	}
 
-	send_workqueue = create_singlethread_workqueue("dlm_send");
+	send_workqueue = alloc_workqueue("dlm_send",
+					 WQ_UNBOUND | WQ_MEM_RECLAIM, 1);
 	if (!send_workqueue) {
 		log_print("can't start dlm_send");
 		destroy_workqueue(recv_workqueue);
-- 
1.7.1.1

