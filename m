Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab0HZSuA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:50:00 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:38669 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab0HZSt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:49:57 -0400
Subject: [PATCH 07/13] cciss: factor out cciss_getbustypes
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Thu, 26 Aug 2010 13:56:05 -0500
Message-ID: <20100826185605.9067.57279.stgit@beardog.cce.hp.com>
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
 drivers/block/cciss.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index d9d2e5a..013d023 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1347,6 +1347,18 @@ static int cciss_getheartbeat(ctlr_info_t *h, void __user *argp)
 	return 0;
 }
 
+static int cciss_getbustypes(ctlr_info_t *h, void __user *argp)
+{
+	BusTypes_type BusTypes;
+
+	if (!argp)
+		return -EINVAL;
+	BusTypes = readl(&h->cfgtable->BusTypes);
+	if (copy_to_user(argp, &BusTypes, sizeof(BusTypes_type)))
+		return -EFAULT;
+	return 0;
+}
+
 static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 		       unsigned int cmd, unsigned long arg)
 {
@@ -1371,17 +1383,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 	case CCISS_GETHEARTBEAT:
 		return cciss_getheartbeat(h, argp);
 	case CCISS_GETBUSTYPES:
-		{
-			BusTypes_type BusTypes;
-
-			if (!arg)
-				return -EINVAL;
-			BusTypes = readl(&h->cfgtable->BusTypes);
-			if (copy_to_user
-			    (argp, &BusTypes, sizeof(BusTypes_type)))
-				return -EFAULT;
-			return 0;
-		}
+		return cciss_getbustypes(h, argp);
 	case CCISS_GETFIRMVER:
 		{
 			FirmwareVer_type firmware;

