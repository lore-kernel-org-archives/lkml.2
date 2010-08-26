Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280Ab0HZStz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 14:49:55 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:38648 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab0HZStv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 14:49:51 -0400
Subject: [PATCH 06/13] cciss: factor out cciss_getheartbeat
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Date: Thu, 26 Aug 2010 13:55:59 -0500
Message-ID: <20100826185559.9067.19048.stgit@beardog.cce.hp.com>
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
index 90c1906..d9d2e5a 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1335,6 +1335,18 @@ static int cciss_setnodename(ctlr_info_t *h, void __user *argp)
 	return 0;
 }
 
+static int cciss_getheartbeat(ctlr_info_t *h, void __user *argp)
+{
+	Heartbeat_type heartbeat;
+
+	if (!argp)
+		return -EINVAL;
+	heartbeat = readl(&h->cfgtable->HeartBeat);
+	if (copy_to_user(argp, &heartbeat, sizeof(Heartbeat_type)))
+		return -EFAULT;
+	return 0;
+}
+
 static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 		       unsigned int cmd, unsigned long arg)
 {
@@ -1357,17 +1369,7 @@ static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 	case CCISS_SETNODENAME:
 		return cciss_setnodename(h, argp);
 	case CCISS_GETHEARTBEAT:
-		{
-			Heartbeat_type heartbeat;
-
-			if (!arg)
-				return -EINVAL;
-			heartbeat = readl(&h->cfgtable->HeartBeat);
-			if (copy_to_user
-			    (argp, &heartbeat, sizeof(Heartbeat_type)))
-				return -EFAULT;
-			return 0;
-		}
+		return cciss_getheartbeat(h, argp);
 	case CCISS_GETBUSTYPES:
 		{
 			BusTypes_type BusTypes;

