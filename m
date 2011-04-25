Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab1DYPzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 11:55:38 -0400
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:48948 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750828Ab1DYPzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 11:55:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:X-Identified-User;
	b=DtNotTe9MDNZ7bhZrjDxP56vAdbHpCNuJl1UTMCJe8IKzK9sL/QsSqgsiY/sbQS+0pd0eaJ6n54rhbrIyusD46kNzJrCJFOQA4aaYjFO3znVjef4C+pXGxfzzR+yjEQd;
From: Tao Ma <tm@tao.ma>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk
Subject: [PATCH] block: Remove 'plug/unplug' comment in blk_execute_rq_nowait.
Date: Mon, 25 Apr 2011 23:55:18 +0800
Message-Id: <1303746918-11097-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 221.217.59.73 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

unplug is replaced with blk_run_queue now in blk_execute_rq_nowait,
so change the comment accordingly.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 block/blk-exec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index 81e3181..d36bfbb 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -56,7 +56,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	spin_lock_irq(q->queue_lock);
 	__elv_add_request(q, rq, where);
 	__blk_run_queue(q);
-	/* the queue is stopped so it won't be plugged+unplugged */
+	/* the queue is stopped so it won't be runned */
 	if (rq->cmd_type == REQ_TYPE_PM_RESUME)
 		q->request_fn(q);
 	spin_unlock_irq(q->queue_lock);
-- 
1.7.1

