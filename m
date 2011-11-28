Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab1K1QcD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:32:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab1K1QcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:32:00 -0500
Date: Mon, 28 Nov 2011 11:31:55 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [SCSI] sd: Lower printk level for drive cache information
Message-ID: <20111128163053.GA24618@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Numerous devices don't present cache data, particularly USB sticks.  The
devices operate correctly despite this, so lower the printk severity to
KERN_NOTICE.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>

---

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fa3a591..7cf9ec5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2119,7 +2119,7 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsigned char *buffer)
 		}
 
 		if (modepage == 0x3F) {
-			sd_printk(KERN_ERR, sdkp, "No Caching mode page "
+			sd_printk(KERN_NOTICE, sdkp, "No Caching mode page "
 				  "present\n");
 			goto defaults;
 		} else if ((buffer[offset] & 0x3f) != modepage) {
@@ -2164,7 +2164,7 @@ bad_sense:
 		sd_printk(KERN_ERR, sdkp, "Asking for cache data failed\n");
 
 defaults:
-	sd_printk(KERN_ERR, sdkp, "Assuming drive cache: write through\n");
+	sd_printk(KERN_NOTICE, sdkp, "Assuming drive cache: write through\n");
 	sdkp->WCE = 0;
 	sdkp->RCD = 0;
 	sdkp->DPOFUA = 0;
