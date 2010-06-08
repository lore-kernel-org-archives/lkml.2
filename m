Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab0FHDwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 23:52:14 -0400
Received: from mail.perches.com ([173.55.12.10]:2763 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753170Ab0FHDus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 23:50:48 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 06/12] drivers/media: Remove unnecesary kmalloc casts
Date: Mon,  7 Jun 2010 20:50:38 -0700
Message-Id: <6ad759b1dd4addbbd94f045f4f05f3493f1443d4.1275968594.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1275968594.git.joe@perches.com>
References: <cover.1275968594.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/dvb/siano/smscoreapi.c |    4 +---
 drivers/media/video/w9968cf.c        |    3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/siano/smscoreapi.c b/drivers/media/dvb/siano/smscoreapi.c
index 0c87a3c..828bcc2 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -116,9 +116,7 @@ static struct smscore_registry_entry_t *smscore_find_registry(char *devpath)
 			return entry;
 		}
 	}
-	entry = (struct smscore_registry_entry_t *)
-			kmalloc(sizeof(struct smscore_registry_entry_t),
-				GFP_KERNEL);
+	entry = kmalloc(sizeof(struct smscore_registry_entry_t), GFP_KERNEL);
 	if (entry) {
 		entry->mode = default_mode;
 		strcpy(entry->devpath, devpath);
diff --git a/drivers/media/video/w9968cf.c b/drivers/media/video/w9968cf.c
index d807eea..591fc6d 100644
--- a/drivers/media/video/w9968cf.c
+++ b/drivers/media/video/w9968cf.c
@@ -3429,8 +3429,7 @@ w9968cf_usb_probe(struct usb_interface* intf, const struct usb_device_id* id)
 	else
 		return -ENODEV;
 
-	cam = (struct w9968cf_device*)
-		  kzalloc(sizeof(struct w9968cf_device), GFP_KERNEL);
+	cam = kzalloc(sizeof(struct w9968cf_device), GFP_KERNEL);
 	if (!cam)
 		return -ENOMEM;
 
-- 
1.7.1.244.gbdc4

