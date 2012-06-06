Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900Ab2FFOPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:15:42 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:33760 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab2FFOPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:15:41 -0400
From: Chetan Loke <loke.chetan@gmail.com>
To: Paul.Clements@steeleye.com, axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, Chetan Loke <loke.chetan@gmail.com>
Subject: [PATCH 1/1] block/nbd: micro-optimization in nbd request completion
Date: Wed,  6 Jun 2012 10:15:16 -0400
Message-Id: <1338992116-28094-1-git-send-email-loke.chetan@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add in-flight cmds to the tail. That way while searching(during request completion),we will always get a hit on the first element.


Signed-off-by: Chetan Loke <loke.chetan@gmail.com>
---
 drivers/block/nbd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 061427a..8957b9f 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -481,7 +481,7 @@ static void nbd_handle_req(struct nbd_device *nbd, struct request *req)
 		nbd_end_request(req);
 	} else {
 		spin_lock(&nbd->queue_lock);
-		list_add(&req->queuelist, &nbd->queue_head);
+		list_add_tail(&req->queuelist, &nbd->queue_head);
 		spin_unlock(&nbd->queue_lock);
 	}
 
-- 
1.7.5.2

