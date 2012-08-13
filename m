Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2HMQTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:19:36 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63093 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab2HMQTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:19:35 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 1/5] workqueue: use enum value to set array size of pools in gcwq
Date: Tue, 14 Aug 2012 01:17:48 +0900
Message-Id: <1344874672-6257-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <Yes>
References: <Yes>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3270476a6c0ce322354df8679652f060d66526dc ('workqueue: reimplement
WQ_HIGHPRI using a separate worker_pool') introduce separate worker_pool
for HIGHPRI. Although there is NR_WORKER_POOLS enum value which represent
size of pools, definition of worker_pool in gcwq doesn't use it.
Using it makes code robust and prevent future mistakes.
So change code to use this enum value.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 692d976..188eef8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -183,7 +183,8 @@ struct global_cwq {
 	struct hlist_head	busy_hash[BUSY_WORKER_HASH_SIZE];
 						/* L: hash of busy workers */
 
-	struct worker_pool	pools[2];	/* normal and highpri pools */
+	struct worker_pool	pools[NR_WORKER_POOLS];
+						/* normal and highpri pools */
 
 	wait_queue_head_t	rebind_hold;	/* rebind hold wait */
 } ____cacheline_aligned_in_smp;
-- 
1.7.9.5

