Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab1E1RhG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 13:37:06 -0400
Received: from mail.perches.com ([173.55.12.10]:2204 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab1E1RhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 13:37:02 -0400
From: Joe Perches <joe@perches.com>
To: David Airlie <airlied@linux.ie>, Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [TRIVIAL PATCH next 05/15] char: Convert vmalloc/memset to vzalloc
Date: Sat, 28 May 2011 10:36:25 -0700
Message-Id: <31b0632dcc5917cda767ad9ffafaa8bc9a95ee02.1306603968.git.joe@perches.com>
X-Mailer: git-send-email 1.7.5.rc3.dirty
In-Reply-To: <cover.1306603968.git.joe@perches.com>
References: <cover.1306603968.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/char/agp/backend.c |    3 +--
 drivers/char/raw.c         |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/char/agp/backend.c b/drivers/char/agp/backend.c
index f27d0d0..4b71647 100644
--- a/drivers/char/agp/backend.c
+++ b/drivers/char/agp/backend.c
@@ -171,7 +171,7 @@ static int agp_backend_initialize(struct agp_bridge_data *bridge)
 	}
 	got_gatt = 1;
 
-	bridge->key_list = vmalloc(PAGE_SIZE * 4);
+	bridge->key_list = vzalloc(PAGE_SIZE * 4);
 	if (bridge->key_list == NULL) {
 		dev_err(&bridge->dev->dev,
 			"can't allocate memory for key lists\n");
@@ -181,7 +181,6 @@ static int agp_backend_initialize(struct agp_bridge_data *bridge)
 	got_keylist = 1;
 
 	/* FIXME vmalloc'd memory not guaranteed contiguous */
-	memset(bridge->key_list, 0, PAGE_SIZE * 4);
 
 	if (bridge->driver->configure()) {
 		dev_err(&bridge->dev->dev, "error configuring host chipset\n");
diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index b33e8ea..b6de2c0 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -324,13 +324,12 @@ static int __init raw_init(void)
 		max_raw_minors = MAX_RAW_MINORS;
 	}
 
-	raw_devices = vmalloc(sizeof(struct raw_device_data) * max_raw_minors);
+	raw_devices = vzalloc(sizeof(struct raw_device_data) * max_raw_minors);
 	if (!raw_devices) {
 		printk(KERN_ERR "Not enough memory for raw device structures\n");
 		ret = -ENOMEM;
 		goto error;
 	}
-	memset(raw_devices, 0, sizeof(struct raw_device_data) * max_raw_minors);
 
 	ret = register_chrdev_region(dev, max_raw_minors, "raw");
 	if (ret)
-- 
1.7.5.rc3.dirty

