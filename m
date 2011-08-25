Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab1HYPUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:20:00 -0400
Received: from mail09.linbit.com ([212.69.161.110]:34374 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab1HYPJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:49 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 080/118] drbd: Converted drbd_recv_fp() from mdev to tconn
Date: Thu, 25 Aug 2011 17:08:16 +0200
Message-Id: <1314284934-17999-81-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 2e1972e..080c91b 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -704,9 +704,9 @@ static int drbd_send_fp(struct drbd_tconn *tconn, struct socket *sock, enum drbd
 	return _conn_send_cmd(tconn, 0, sock, cmd, h, sizeof(*h), 0);
 }
 
-static enum drbd_packet drbd_recv_fp(struct drbd_conf *mdev, struct socket *sock)
+static enum drbd_packet drbd_recv_fp(struct drbd_tconn *tconn, struct socket *sock)
 {
-	struct p_header80 *h = &mdev->tconn->data.rbuf.header.h80;
+	struct p_header80 *h = &tconn->data.rbuf.header.h80;
 	int rr;
 
 	rr = drbd_recv_short(sock, h, sizeof(*h), 0);
@@ -802,7 +802,7 @@ static int drbd_connect(struct drbd_conf *mdev)
 retry:
 		s = drbd_wait_for_connect(mdev->tconn);
 		if (s) {
-			try = drbd_recv_fp(mdev, s);
+			try = drbd_recv_fp(mdev->tconn, s);
 			drbd_socket_okay(&sock);
 			drbd_socket_okay(&msock);
 			switch (try) {
-- 
1.7.4.1

