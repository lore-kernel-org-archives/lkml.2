Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507Ab0HZSuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:50:12 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:35310 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab0HZSuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:50:07 -0400
Subject: [PATCH 09/13] cciss: factor out cciss_getdrivver
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Thu, 26 Aug 2010 13:56:15 -0500
Message-ID: <20100826185615.9067.7742.stgit@beardog.cce.hp.com>
In-Reply-To: <20100826185315.9067.25060.stgit@beardog.cce.hp.com>
References: <20100826185315.9067.25060.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index c4790ba..6e915de 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1373,8 +1373,19 @@ static int cciss_getfirmver(ctlr_info_t *h, void __user *argp)
 	return 0;
 }
 
+static int cciss_getdrivver(ctlr_info_t *h, void __user *argp)
+{
+	DriverVer_type DriverVer = DRIVER_VERSION;
+
+	if (!argp)
+		return -EINVAL;
+	if (copy_to_user(argp, &DriverVer, sizeof(DriverVer_type)))
+		return -EFAULT;
+	return 0;
+}
+
 static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
-		       unsigned int cmd, unsigned long arg)
+	unsigned int cmd, unsigned long arg)
 {
 	struct gendisk *disk = bdev->bd_disk;
 	ctlr_info_t *h = get_host(disk);
@@ -1401,18 +1412,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 	case CCISS_GETFIRMVER:
 		return cciss_getfirmver(h, argp);
 	case CCISS_GETDRIVVER:
-		{
-			DriverVer_type DriverVer = DRIVER_VERSION;
-
-			if (!arg)
-				return -EINVAL;
-
-			if (copy_to_user
-			    (argp, &DriverVer, sizeof(DriverVer_type)))
-				return -EFAULT;
-			return 0;
-		}
-
+		return cciss_getdrivver(h, argp);
 	case CCISS_DEREGDISK:
 	case CCISS_REGNEWD:
 	case CCISS_REVALIDVOLS:

