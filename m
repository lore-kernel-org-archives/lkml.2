Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab0HLAOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:14:31 -0400
Received: from kroah.org ([198.145.64.141]:47863 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933157Ab0HLAId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 20:08:33 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 17:06:16 2010
Message-Id: <20100812000616.087298787@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 17:05:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [37/67] drbd: Initialize all members of sync_conf to their defaults [Bugz 315]
In-Reply-To: <20100812000641.GA6348@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Philipp Reisner <philipp.reisner@linbit.com>

commit 85f4cc17a62c3ac9edeaf120cdae7261df458053 upstream.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/drbd/drbd_main.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2660,9 +2660,24 @@ static void drbd_unplug_fn(struct reques
 
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
+		/* .dp_volume = */	DRBD_DP_VOLUME_DEF,
+		/* .dp_interval = */	DRBD_DP_INTERVAL_DEF,
+		/* .throttle_th = */	DRBD_RS_THROTTLE_TH_DEF,
+		/* .hold_off_th = */	DRBD_RS_HOLD_OFF_TH_DEF,
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


