Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab1IELrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 07:47:00 -0400
Received: from mail09.linbit.com ([212.69.161.110]:60338 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752826Ab1IELqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 07:46:08 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 44/54] drbd: Add drbd_recv_all(): Receive an entire buffer
Date: Mon,  5 Sep 2011 13:45:35 +0200
Message-Id: <1315223145-20640-45-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
References: <1315223145-20640-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 87f03ca..e6b6e01 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -565,6 +565,18 @@ static int drbd_recv(struct drbd_tconn *tconn, void *buf, size_t size)
 	return rv;
 }
 
+static int drbd_recv_all(struct drbd_tconn *tconn, void *buf, size_t size)
+{
+	int err;
+
+	err = drbd_recv(tconn, buf, size);
+	if (err != size) {
+		if (err >= 0)
+			err = -EIO;
+	}
+	return err;
+}
+
 /* quoting tcp(7):
  *   On individual connections, the socket buffer size must be set prior to the
  *   listen(2) or connect(2) calls in order to have it take effect.
-- 
1.7.4.1

