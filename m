Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab1BPBSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:18:41 -0500
Received: from kroah.org ([198.145.64.141]:45310 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838Ab1BPAsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:48:18 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:03 2011
Message-Id: <20110216002102.942506046@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:20:06 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "K. Y. Srinivasan" <ksrinivasan@novell.com>,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [patch 038/176] Staging: hv: fix sysfs symlink on hv block device
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ky Srinivasan <ksrinivasan@novell.com>

commit 268eff909afaca93188d2d14554cbf824f6a0e41 upstream.

The block device does not create the proper symlink in sysfs because we
forgot to set up the gendisk structure properly.  This patch fixes the
issue.

Signed-off-by: K. Y. Srinivasan <ksrinivasan@novell.com>
Cc: Hank Janssen <hjanssen@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/blkvsc_drv.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -369,6 +369,7 @@ static int blkvsc_probe(struct device *d
 		blkdev->gd->first_minor = 0;
 	blkdev->gd->fops = &block_ops;
 	blkdev->gd->private_data = blkdev;
+	blkdev->gd->driverfs_dev = &(blkdev->device_ctx->device);
 	sprintf(blkdev->gd->disk_name, "hd%c", 'a' + devnum);
 
 	blkvsc_do_inquiry(blkdev);


