Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817Ab1FWS3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:29:13 -0400
Received: from mail.windriver.com ([147.11.1.11]:63019 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932671Ab1FWRWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:17 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ky Srinivasan <ksrinivasan@novell.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 027/247] Staging: hv: fix sysfs symlink on hv block device
Date: Thu, 23 Jun 2011 13:17:50 -0400
Message-Id: <1308849690-14530-28-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ky Srinivasan <ksrinivasan@novell.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 268eff909afaca93188d2d14554cbf824f6a0e41 upstream.

The block device does not create the proper symlink in sysfs because we
forgot to set up the gendisk structure properly.  This patch fixes the
issue.

Signed-off-by: K. Y. Srinivasan <ksrinivasan@novell.com>
Cc: Hank Janssen <hjanssen@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/staging/hv/blkvsc_drv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 8f1fda3..e917a46 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -377,6 +377,7 @@ static int blkvsc_probe(struct device *device)
 		blkdev->gd->first_minor = 0;
 	blkdev->gd->fops = &block_ops;
 	blkdev->gd->private_data = blkdev;
+	blkdev->gd->driverfs_dev = &(blkdev->device_ctx->device);
 	sprintf(blkdev->gd->disk_name, "hd%c", 'a' + devnum);
 
 	blkvsc_do_inquiry(blkdev);
-- 
1.7.4.4

