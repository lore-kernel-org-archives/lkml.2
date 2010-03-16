Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965985Ab0CPDnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 23:43:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43300 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932902Ab0CPDnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 23:43:15 -0400
From: NeilBrown <neilb@suse.de>
To: Jens Axboe <jens.axboe@oracle.com>
Date: Tue, 16 Mar 2010 14:43:08 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19358.65100.93577.71546@notabene.brown>
Subject: [PATCH] Remove GENHD_FL_DRIVERFS
Cc: linux-kernel@vger.kernel.org
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



This flag is not used, so best discarded.

Signed-off-by: NeilBrown <neilb@suse.de>
--
Hi Jens,
 I came across this recently - these are the only two occurances
 of "GENHD_FL_DRIVERFS" in the kernel, so it cannot be needed.
NeilBrown


diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 83881df..a82ab3e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2185,7 +2185,7 @@ static void sd_probe_async(void *data, async_cookie_t cookie)
 	blk_queue_prep_rq(sdp->request_queue, sd_prep_fn);
 
 	gd->driverfs_dev = &sdp->sdev_gendev;
-	gd->flags = GENHD_FL_EXT_DEVT | GENHD_FL_DRIVERFS;
+	gd->flags = GENHD_FL_EXT_DEVT;
 	if (sdp->removable)
 		gd->flags |= GENHD_FL_REMOVABLE;
 
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 56b5051..5f2f4c4 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -109,7 +109,7 @@ struct hd_struct {
 };
 
 #define GENHD_FL_REMOVABLE			1
-#define GENHD_FL_DRIVERFS			2
+/* 2 is unused */
 #define GENHD_FL_MEDIA_CHANGE_NOTIFY		4
 #define GENHD_FL_CD				8
 #define GENHD_FL_UP				16
