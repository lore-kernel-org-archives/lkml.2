Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab0HZSuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:50:09 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:43279 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab0HZSuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:50:04 -0400
Subject: [PATCH 08/13] cciss: factor out cciss_getfirmver
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Thu, 26 Aug 2010 13:56:10 -0500
Message-ID: <20100826185610.9067.23132.stgit@beardog.cce.hp.com>
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
 drivers/block/cciss.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 013d023..c4790ba 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1359,6 +1359,20 @@ static int cciss_getbustypes(ctlr_info_t *h, void __user *argp)
 	return 0;
 }
 
+static int cciss_getfirmver(ctlr_info_t *h, void __user *argp)
+{
+	FirmwareVer_type firmware;
+
+	if (!argp)
+		return -EINVAL;
+	memcpy(firmware, h->firm_ver, 4);
+
+	if (copy_to_user
+	    (argp, firmware, sizeof(FirmwareVer_type)))
+		return -EFAULT;
+	return 0;
+}
+
 static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 		       unsigned int cmd, unsigned long arg)
 {
@@ -1385,18 +1399,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 	case CCISS_GETBUSTYPES:
 		return cciss_getbustypes(h, argp);
 	case CCISS_GETFIRMVER:
-		{
-			FirmwareVer_type firmware;
-
-			if (!arg)
-				return -EINVAL;
-			memcpy(firmware, h->firm_ver, 4);
-
-			if (copy_to_user
-			    (argp, firmware, sizeof(FirmwareVer_type)))
-				return -EFAULT;
-			return 0;
-		}
+		return cciss_getfirmver(h, argp);
 	case CCISS_GETDRIVVER:
 		{
 			DriverVer_type DriverVer = DRIVER_VERSION;

