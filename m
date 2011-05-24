Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab1EXDTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 23:19:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41823 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab1EXDTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 23:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=s/8nFW9ptGFogjHIhZvK+Ze0mgZ64EDw3gEawn3IaDgOg1qYIIYAuA7tDALd8HeHmS
         H1vVk2zhK13t9jp+OBeMLyOb2XgAAEt7V+BNip/BLd1YX5SHzu+By8WkXt9OaGOkqHn0
         o/rSSSLBYOvbuM1m+JyBKBTIknK/b5Ua3p54k=
From: Namhyung Kim <namhyung@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Justin TerAvest <teravest@google.com>
Subject: [PATCH 3/4] cfq-iosched: remove unused 'group_changed' in cfq_service_tree_add()
Date: Tue, 24 May 2011 12:18:50 +0900
Message-Id: <1306207131-2296-3-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.5.2
In-Reply-To: <1306207131-2296-1-git-send-email-namhyung@gmail.com>
References: <1306207131-2296-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The 'group_changed' variable is initialized to 0 and never changed, so
checking the variable is meaningless.

It is a leftover from 0bbfeb832042 ("cfq-iosched: Always provide group
iosolation."). Let's get rid of it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Justin TerAvest <teravest@google.com>
---
 block/cfq-iosched.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index a79e62063144..4ceebd346710 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1206,7 +1206,6 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	struct cfq_rb_root *service_tree;
 	int left;
 	int new_cfqq = 1;
-	int group_changed = 0;
 
 	service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
 						cfqq_type(cfqq));
@@ -1277,7 +1276,7 @@ static void cfq_service_tree_add(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	rb_link_node(&cfqq->rb_node, parent, p);
 	rb_insert_color(&cfqq->rb_node, &service_tree->rb);
 	service_tree->count++;
-	if ((add_front || !new_cfqq) && !group_changed)
+	if (add_front || !new_cfqq)
 		return;
 	cfq_group_notify_queue_add(cfqd, cfqq->cfqg);
 }
-- 
1.7.5.2

