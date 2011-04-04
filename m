Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894Ab1DDWhC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 18:37:02 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:34882
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753920Ab1DDWhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 18:37:00 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 01/22] Staging: hv: Get rid of blkvsc_media_changed()
Date: Mon,  4 Apr 2011 15:47:50 -0700
Message-Id: <1301957291-8035-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301957186-7853-1-git-send-email-kys@microsoft.com>
References: <1301957186-7853-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't support removable media in Hyper-V block driver.
Get rid of blkvsc_media_changed() as it is efectively "dead code".

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 9faccbe..1203049 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -251,12 +251,6 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 	return ret;
 }
 
-static int blkvsc_media_changed(struct gendisk *gd)
-{
-	DPRINT_DBG(BLKVSC_DRV, "- enter\n");
-	return 1;
-}
-
 static int blkvsc_open(struct block_device *bdev, fmode_t mode)
 {
 	struct block_device_context *blkdev = bdev->bd_disk->private_data;
@@ -1206,7 +1200,6 @@ static const struct block_device_operations block_ops = {
 	.owner = THIS_MODULE,
 	.open = blkvsc_open,
 	.release = blkvsc_release,
-	.media_changed = blkvsc_media_changed,
 	.revalidate_disk = blkvsc_revalidate_disk,
 	.getgeo = blkvsc_getgeo,
 	.ioctl  = blkvsc_ioctl,
-- 
1.7.4.1

