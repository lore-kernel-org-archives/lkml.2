Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab0FADZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:25:09 -0400
Received: from mail.perches.com ([173.55.12.10]:2482 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab0FADXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:23:32 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 15/21] drivers/s390: Remove unnecessary kmalloc casts
Date: Mon, 31 May 2010 20:23:17 -0700
Message-Id: <6ea4f7b0d1e18e54856e8bbefd8b7eeb9d5fa068.1275360951.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <cover.1275360951.git.joe@perches.com>
References: <cover.1275360951.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/s390/block/dasd_devmap.c |    3 +--
 drivers/s390/char/con3215.c      |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
index 34d51dd..8c962dc 100644
--- a/drivers/s390/block/dasd_devmap.c
+++ b/drivers/s390/block/dasd_devmap.c
@@ -409,8 +409,7 @@ dasd_add_busid(const char *bus_id, int features)
 	struct dasd_devmap *devmap, *new, *tmp;
 	int hash;
 
-	new = (struct dasd_devmap *)
-		kzalloc(sizeof(struct dasd_devmap), GFP_KERNEL);
+	new = kzalloc(sizeof(struct dasd_devmap), GFP_KERNEL);
 	if (!new)
 		return ERR_PTR(-ENOMEM);
 	spin_lock(&dasd_devmap_lock);
diff --git a/drivers/s390/char/con3215.c b/drivers/s390/char/con3215.c
index 59ec073..6752c42 100644
--- a/drivers/s390/char/con3215.c
+++ b/drivers/s390/char/con3215.c
@@ -888,8 +888,8 @@ static int __init con3215_init(void)
 	if (IS_ERR(cdev))
 		return -ENODEV;
 
-	raw3215[0] = raw = (struct raw3215_info *)
-		kzalloc(sizeof(struct raw3215_info), GFP_KERNEL | GFP_DMA);
+	raw3215[0] = raw = kzalloc(sizeof(struct raw3215_info),
+				   GFP_KERNEL | GFP_DMA);
 	raw->buffer = kzalloc(RAW3215_BUFFER_SIZE, GFP_KERNEL | GFP_DMA);
 	raw->inbuf = kzalloc(RAW3215_INBUF_SIZE, GFP_KERNEL | GFP_DMA);
 	raw->cdev = cdev;
-- 
1.7.0.3.311.g6a6955

