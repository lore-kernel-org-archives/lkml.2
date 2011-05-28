Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab1E1Rj7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 13:39:59 -0400
Received: from mail.perches.com ([173.55.12.10]:2201 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab1E1RhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 13:37:00 -0400
From: Joe Perches <joe@perches.com>
To: Lars Ellenberg <drbd-dev@lists.linbit.com>,
        Jiri Kosina <trivial@kernel.org>
Cc: drbd-user@lists.linbit.com, linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH next 04/15] drbd: Convert vmalloc/memset to vzalloc
Date: Sat, 28 May 2011 10:36:24 -0700
Message-Id: <c6d0069e093ffb3508c515aea7e301fac9c2cfc8.1306603968.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1306603968.git.joe@perches.com>
References: <cover.1306603968.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/drbd/drbd_bitmap.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index f440a02..9dd03b0 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -381,15 +381,14 @@ static struct page **bm_realloc_pages(struct drbd_bitmap *b, unsigned long want)
 	 * thread.  As we have no disk yet, we are not in the IO path,
 	 * not even the IO path of the peer. */
 	bytes = sizeof(struct page *)*want;
-	new_pages = kmalloc(bytes, GFP_KERNEL);
+	new_pages = kzalloc(bytes, GFP_KERNEL);
 	if (!new_pages) {
-		new_pages = vmalloc(bytes);
+		new_pages = vzalloc(bytes);
 		if (!new_pages)
 			return NULL;
 		vmalloced = 1;
 	}
 
-	memset(new_pages, 0, bytes);
 	if (want >= have) {
 		for (i = 0; i < have; i++)
 			new_pages[i] = old_pages[i];
-- 
1.7.5.rc3.dirty

