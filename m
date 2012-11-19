Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab2KSFaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:30:55 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:40655 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab2KSFav convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:30:51 -0500
X-Originating-IP: 217.70.178.149
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 30/58] block: Eliminate unused function kblockd_schedule_delayed_work
Date: Sun, 18 Nov 2012 21:28:09 -0800
Message-Id: <1353302917-13995-31-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit e43473b7f223ec866f7db273697e76c337c390f9 in September 2010
("blkio: Core implementation of throttle policy") re-added the
previously removed function kblockd_schedule_delayed_work, and added a
single call from throtl_schedule_delayed_work in block/blk-throttle.c.

Commit 450adcbe518ab3a3953d8475309525d22de77cba in March 2011
("blk-throttle: Do not use kblockd workqueue for throtl work")
eliminated that one and only call from throtl_schedule_delayed_work in
favor of a separate workqueue.

No other callers have come into existence since then.

Eliminate kblockd_schedule_delayed_work once again.

This also eliminates a warning from gcc (-Wmissing-prototypes) and from
Sparse (-Wdecl).

block/blk-core.c:2820:5: warning: no previous prototype for ‘kblockd_schedule_delayed_work’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 block/blk-core.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a33870b..f338553 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2817,13 +2817,6 @@ int kblockd_schedule_work(struct request_queue *q, struct work_struct *work)
 }
 EXPORT_SYMBOL(kblockd_schedule_work);
 
-int kblockd_schedule_delayed_work(struct request_queue *q,
-			struct delayed_work *dwork, unsigned long delay)
-{
-	return queue_delayed_work(kblockd_workqueue, dwork, delay);
-}
-EXPORT_SYMBOL(kblockd_schedule_delayed_work);
-
 #define PLUG_MAGIC	0x91827364
 
 /**
-- 
1.7.10.4

