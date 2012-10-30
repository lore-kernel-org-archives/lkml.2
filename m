Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965757Ab2J3USa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 16:18:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab2J3UPS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 16:15:18 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Miller <mike.miller@hp.com>, iss_storagedev@hp.com
Subject: [patch 10/10] cciss: use blk_init_queue_node
Date: Tue, 30 Oct 2012 16:14:44 -0400
Message-Id: <1351628084-29358-13-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
References: <1351628084-29358-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 drivers/block/cciss.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b0f553b..5fe5546 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1930,7 +1930,8 @@ static void cciss_get_serial_no(ctlr_info_t *h, int logvol,
 static int cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 				int drv_index)
 {
-	disk->queue = blk_init_queue(do_cciss_request, &h->lock);
+	disk->queue = blk_init_queue_node(do_cciss_request, &h->lock,
+					  dev_to_node(&h->dev));
 	if (!disk->queue)
 		goto init_queue_failure;
 	sprintf(disk->disk_name, "cciss/c%dd%d", h->ctlr, drv_index);
-- 
1.7.1

