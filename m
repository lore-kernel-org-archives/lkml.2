Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab0KEDSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:18:24 -0400
Received: from mail.perches.com ([173.55.12.10]:4037 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753481Ab0KEDIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:39 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Lars Ellenberg <drbd-dev@lists.linbit.com>, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/49] drivers/block: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:32 -0700
Message-Id: <888ee71767447f484d9212b2bb13b9312724c126.1288925424.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/drbd/drbd_bitmap.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index fd42832..09e8cfc 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -250,15 +250,14 @@ static struct page **bm_realloc_pages(struct drbd_bitmap *b, unsigned long want)
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
1.7.3.1.g432b3.dirty

