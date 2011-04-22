Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860Ab1DVVnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:43:20 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:58239
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756741Ab1DVVnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:43:08 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 17/21] Staging: hv: Cleanup blkvsc_open()
Date: Fri, 22 Apr 2011 14:55:22 -0700
Message-Id: <1303509326-3094-17-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303509326-3094-1-git-send-email-kys@microsoft.com>
References: <1303509246-3053-1-git-send-email-kys@microsoft.com>
 <1303509326-3094-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Given that we don't support removable media, cleanup blkvsc_open().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 3060bab..bf8647e 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -255,20 +255,12 @@ static int blkvsc_open(struct block_device *bdev, fmode_t mode)
 {
 	struct block_device_context *blkdev = bdev->bd_disk->private_data;
 
-
-	mutex_lock(&blkvsc_mutex);
 	spin_lock(&blkdev->lock);
 
-	if (!blkdev->users && blkdev->device_type == DVD_TYPE) {
-		spin_unlock(&blkdev->lock);
-		check_disk_change(bdev);
-		spin_lock(&blkdev->lock);
-	}
-
 	blkdev->users++;
 
 	spin_unlock(&blkdev->lock);
-	mutex_unlock(&blkvsc_mutex);
+
 	return 0;
 }
 
-- 
1.7.4.1

