Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab2J1IKe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 04:10:34 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49997 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751058Ab2J1IKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 04:10:25 -0400
From: Joe Perches <joe@perches.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/16] virtio: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
Date: Sun, 28 Oct 2012 01:05:52 -0700
Message-Id: <a32fa314ea4f0318869f62d0942d3f1f936219d6.1351411048.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351411047.git.joe@perches.com>
References: <cover.1351411047.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
and reducing object size is good.
Convert if (printk_ratelimit()) dev_printk to dev_<level>_ratelimited.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/virtio/virtio_balloon.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 0908e60..586395c 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -130,10 +130,9 @@ static void fill_balloon(struct virtio_balloon *vb, size_t num)
 		struct page *page = alloc_page(GFP_HIGHUSER | __GFP_NORETRY |
 					__GFP_NOMEMALLOC | __GFP_NOWARN);
 		if (!page) {
-			if (printk_ratelimit())
-				dev_printk(KERN_INFO, &vb->vdev->dev,
-					   "Out of puff! Can't get %zu pages\n",
-					   num);
+			dev_info_ratelimited(&vb->vdev->dev,
+					     "Out of puff! Can't get %zu pages\n",
+					     num);
 			/* Sleep for at least 1/5 of a second before retry. */
 			msleep(200);
 			break;
-- 
1.7.8.112.g3fd21

