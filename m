Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1HYPK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:10:28 -0400
Received: from mail09.linbit.com ([212.69.161.110]:33273 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100Ab1HYPKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:10:21 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 114/118] drbd: Global_state_lock not necessary here...
Date: Thu, 25 Aug 2011 17:08:50 +0200
Message-Id: <1314284934-17999-115-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_state.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index db2aee9..81f66b3 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1375,8 +1375,6 @@ _conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_
 	struct after_conn_state_chg_work *acscw;
 	enum drbd_conns oc = tconn->cstate;
 
-	read_lock(&global_state_lock);
-
 	rv = is_valid_conn_transition(oc, val.conn);
 	if (rv < SS_SUCCESS)
 		goto abort;
@@ -1418,8 +1416,6 @@ _conn_request_state(struct drbd_tconn *tconn, union drbd_state mask, union drbd_
 	}
 
 abort:
-	read_unlock(&global_state_lock);
-
 	return rv;
 }
 
-- 
1.7.4.1

