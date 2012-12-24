Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab2LXCOy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 21:14:54 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:64624 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab2LXCOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 21:14:48 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, drbd-dev@lists.linbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/29] drbd: rename random32() to prandom_u32()
Date: Mon, 24 Dec 2012 11:13:55 +0900
Message-Id: <1356315256-6572-9-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356315256-6572-1-git-send-email-akinobu.mita@gmail.com>
References: <1356315256-6572-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use more preferable function name which implies using a pseudo-random
number generator.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: drbd-dev@lists.linbit.com
Cc: Jens Axboe <axboe@kernel.dk>
---
 drivers/block/drbd/drbd_receiver.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index a9eccfc..83c5ae0 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -757,7 +757,8 @@ static struct socket *drbd_wait_for_connect(struct drbd_tconn *tconn, struct acc
 	rcu_read_unlock();
 
 	timeo = connect_int * HZ;
-	timeo += (random32() & 1) ? timeo / 7 : -timeo / 7; /* 28.5% random jitter */
+	/* 28.5% random jitter */
+	timeo += (prandom_u32() & 1) ? timeo / 7 : -timeo / 7;
 
 	err = wait_for_completion_interruptible_timeout(&ad->door_bell, timeo);
 	if (err <= 0)
@@ -953,7 +954,7 @@ retry:
 				conn_warn(tconn, "Error receiving initial packet\n");
 				sock_release(s);
 randomize:
-				if (random32() & 1)
+				if (prandom_u32() & 1)
 					goto retry;
 			}
 		}
-- 
1.7.11.7

