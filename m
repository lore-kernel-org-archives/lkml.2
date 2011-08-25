Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab1HYPdA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:33:00 -0400
Received: from mail09.linbit.com ([212.69.161.110]:32956 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109Ab1HYPJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:09:07 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 026/118] drbd: Interval tree bugfix
Date: Thu, 25 Aug 2011 17:07:22 +0200
Message-Id: <1314284934-17999-27-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
References: <1314284934-17999-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_interval.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/block/drbd/drbd_interval.c b/drivers/block/drbd/drbd_interval.c
index 2511dd9..b77a9bd 100644
--- a/drivers/block/drbd/drbd_interval.c
+++ b/drivers/block/drbd/drbd_interval.c
@@ -58,8 +58,9 @@ drbd_insert_interval(struct rb_root *root, struct drbd_interval *this)
 			new = &(*new)->rb_right;
 		else if (this < here)
 			new = &(*new)->rb_left;
-		else if (this->sector > here->sector)
+		else if (this > here)
 			new = &(*new)->rb_right;
+		else
 			return false;
 	}
 
-- 
1.7.4.1

