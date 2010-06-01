Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab0FAD0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:26:53 -0400
Received: from mail.perches.com ([173.55.12.10]:2475 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab0FADX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:23:28 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Luca Risolia <luca.risolia@studio.unibo.it>, linux-usb@vger.kernel.org,
       linux-media@vger.kernel.org
Subject: [PATCH 08/21] drivers/media: Remove unnecesary kmalloc casts
Date: Mon, 31 May 2010 20:23:10 -0700
Message-Id: <895ae027d1e7e1165f887cf923c30511bb3654e4.1275360951.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <cover.1275360951.git.joe@perches.com>
References: <cover.1275360951.git.joe@perches.com>
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
1.7.0.3.311.g6a6955

