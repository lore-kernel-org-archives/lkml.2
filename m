Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab1DFVZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:25:43 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:55813
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932197Ab1DFVYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:24:05 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 02/22] Staging: hv: Get rid of the forward declaration of blkvsc_check_events()
Date: Wed,  6 Apr 2011 14:35:00 -0700
Message-Id: <1302125720-10808-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302125720-10808-1-git-send-email-kys@microsoft.com>
References: <1302125655-10741-1-git-send-email-kys@microsoft.com>
 <1302125720-10808-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of  blkvsc_check_events()  
by moving the code around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index efcc916..4452700 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -243,6 +243,14 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 }
 
 
+static unsigned int blkvsc_check_events(struct gendisk *gd,
+					unsigned int clearing)
+{
+	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
+	return DISK_EVENT_MEDIA_CHANGE;
+}
+
+
 /* Static decl */
 static DEFINE_MUTEX(blkvsc_mutex);
 static int blkvsc_probe(struct device *dev);
@@ -251,8 +259,6 @@ static void blkvsc_shutdown(struct device *device);
 
 static int blkvsc_open(struct block_device *bdev,  fmode_t mode);
 static int blkvsc_release(struct gendisk *disk, fmode_t mode);
-static unsigned int blkvsc_check_events(struct gendisk *gd,
-					unsigned int clearing);
 static int blkvsc_revalidate_disk(struct gendisk *gd);
 static int blkvsc_getgeo(struct block_device *bd, struct hd_geometry *hg);
 static int blkvsc_ioctl(struct block_device *bd, fmode_t mode,
@@ -1407,13 +1413,6 @@ static int blkvsc_release(struct gendisk *disk, fmode_t mode)
 	return 0;
 }
 
-static unsigned int blkvsc_check_events(struct gendisk *gd,
-					unsigned int clearing)
-{
-	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
-	return DISK_EVENT_MEDIA_CHANGE;
-}
-
 static int blkvsc_revalidate_disk(struct gendisk *gd)
 {
 	struct block_device_context *blkdev = gd->private_data;
-- 
1.7.4.1

