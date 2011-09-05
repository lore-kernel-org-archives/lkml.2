Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1IELsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:48:15 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59865 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1IELqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:14 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 53/54] drbd: Get rid of typedef drbd_work_cb
Date: Mon,  5 Sep 2011 13:45:44 +0200
Message-Id: <1315223145-20640-54-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

This type is not used anywhere else.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 72835f8..72df107 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -643,11 +643,9 @@ static inline enum drbd_thread_state get_t_state(struct drbd_thread *thi)
 	return thi->t_state;
 }
 
-struct drbd_work;
-typedef int (*drbd_work_cb)(struct drbd_work *, int cancel);
 struct drbd_work {
 	struct list_head list;
-	drbd_work_cb cb;
+	int (*cb)(struct drbd_work *, int cancel);
 	union {
 		struct drbd_conf *mdev;
 		struct drbd_tconn *tconn;
-- 
1.7.4.1

