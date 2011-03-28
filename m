Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203Ab1C1QuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:50:16 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:58662
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754600Ab1C1QuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:50:10 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 02/22] Staging: hv: Get rid of the forward declaration of blkvsc_media_changed()
Date: Mon, 28 Mar 2011 10:00:33 -0700
Message-Id: <1301331653-26265-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301331653-26265-1-git-send-email-kys@microsoft.com>
References: <1301331615-26226-1-git-send-email-kys@microsoft.com>
 <1301331653-26265-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the forward declaration of blkvsc_media_changed() by moving the code
around.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index a931e4c..4b97348 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -242,6 +242,11 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 	return ret;
 }
 
+static int blkvsc_media_changed(struct gendisk *gd)
+{
+	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
+	return 1;
+}
 
 /* Static decl */
 static DEFINE_MUTEX(blkvsc_mutex);
@@ -251,7 +256,6 @@ static void blkvsc_shutdown(struct device *device);
 
 static int blkvsc_open(struct block_device *bdev,  fmode_t mode);
 static int blkvsc_release(struct gendisk *disk, fmode_t mode);
-static int blkvsc_media_changed(struct gendisk *gd);
 static int blkvsc_revalidate_disk(struct gendisk *gd);
 static int blkvsc_getgeo(struct block_device *bd, struct hd_geometry *hg);
 static int blkvsc_ioctl(struct block_device *bd, fmode_t mode,
@@ -1405,11 +1409,6 @@ static int blkvsc_release(struct gendisk *disk, fmode_t mode)
 	return 0;
 }
 
-static int blkvsc_media_changed(struct gendisk *gd)
-{
-	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
-	return 1;
-}
 
 static int blkvsc_revalidate_disk(struct gendisk *gd)
 {
-- 
1.7.4.1

