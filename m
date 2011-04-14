Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850Ab1DNSf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:35:56 -0400
Received: from mail.windriver.com ([147.11.1.11]:37342 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932562Ab1DNRpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:45:31 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 012/209] drbd: Initialize all members of sync_conf to their defaults [Bugz 315]
Date: Thu, 14 Apr 2011 13:40:42 -0400
Message-Id: <1302803039-9400-13-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Philipp Reisner <philipp.reisner@linbit.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 85f4cc17a62c3ac9edeaf120cdae7261df458053 upstream.

[PG: remove fields volume, interval, throttle, hold_off; not in 34]

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/block/drbd/drbd_main.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 93d1f9b..6c79e02 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2567,9 +2567,20 @@ static void drbd_unplug_fn(struct request_queue *q)
 
 static void drbd_set_defaults(struct drbd_conf *mdev)
 {
-	mdev->sync_conf.after      = DRBD_AFTER_DEF;
-	mdev->sync_conf.rate       = DRBD_RATE_DEF;
-	mdev->sync_conf.al_extents = DRBD_AL_EXTENTS_DEF;
+	/* This way we get a compile error when sync_conf grows,
+	   and we forgot to initialize it here */
+	mdev->sync_conf = (struct syncer_conf) {
+		/* .rate = */		DRBD_RATE_DEF,
+		/* .after = */		DRBD_AFTER_DEF,
+		/* .al_extents = */	DRBD_AL_EXTENTS_DEF,
+		/* .verify_alg = */	{}, 0,
+		/* .cpu_mask = */	{}, 0,
+		/* .csums_alg = */	{}, 0,
+		/* .use_rle = */	0
+	};
+
+	/* Have to use that way, because the layout differs between
+	   big endian and little endian */
 	mdev->state = (union drbd_state) {
 		{ .role = R_SECONDARY,
 		  .peer = R_UNKNOWN,
-- 
1.7.4.4

