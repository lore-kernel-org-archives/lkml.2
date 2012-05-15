Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab2EOGTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 02:19:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:43482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754519Ab2EOGTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 02:19:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="140717308"
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: [PATCH] md: check the return of mddev_find()
Date: Tue, 15 May 2012 14:26:40 +0800
Message-Id: <1337063200-11174-1-git-send-email-yuanhan.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the return of mddev_find(), since it may fail due to out of
memeory or out of usable minor number.

The reason I chose -ENODEV instead of -ENOMEM or something else is
md_alloc() function chose that ;)

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
---
 drivers/md/md.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 477eb2e..0bd44e3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6371,6 +6371,9 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 	struct mddev *mddev = mddev_find(bdev->bd_dev);
 	int err;
 
+	if (!mddev)
+		return -ENODEV;
+
 	if (mddev->gendisk != bdev->bd_disk) {
 		/* we are racing with mddev_put which is discarding this
 		 * bd_disk.
-- 
1.7.7.6

