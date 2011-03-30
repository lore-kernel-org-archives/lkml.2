Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933233Ab1C3WJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:09:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:54022 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933173Ab1C3VGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621236041"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: ksrinivasan@novell.com, ak@linux.intel.com, hjanssen@microsoft.com,
        haiyangz@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [33/275] Staging: hv: fix sysfs symlink on hv block device
Message-Id: <20110330210428.6FF413E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Ky Srinivasan <ksrinivasan@novell.com>

commit 268eff909afaca93188d2d14554cbf824f6a0e41 upstream.

The block device does not create the proper symlink in sysfs because we
forgot to set up the gendisk structure properly.  This patch fixes the
issue.

Signed-off-by: K. Y. Srinivasan <ksrinivasan@novell.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Hank Janssen <hjanssen@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/blkvsc_drv.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/drivers/staging/hv/blkvsc_drv.c
===================================================================
--- linux-2.6.35.y.orig/drivers/staging/hv/blkvsc_drv.c	2011-03-29 22:51:55.596300598 -0700
+++ linux-2.6.35.y/drivers/staging/hv/blkvsc_drv.c	2011-03-29 23:02:58.880328819 -0700
@@ -378,6 +378,7 @@
 		blkdev->gd->first_minor = 0;
 	blkdev->gd->fops = &block_ops;
 	blkdev->gd->private_data = blkdev;
+	blkdev->gd->driverfs_dev = &(blkdev->device_ctx->device);
 	sprintf(blkdev->gd->disk_name, "hd%c", 'a' + devnum);
 
 	blkvsc_do_inquiry(blkdev);
