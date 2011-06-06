Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab1FFWfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 18:35:10 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:57980
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757339Ab1FFWe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 18:34:58 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: [PATCH 06/49] Staging: hv: stor: Get rid of unnecessary DPRINTs in stor vsc_drv.c
Date: Mon,  6 Jun 2011 15:49:30 -0700
Message-Id: <1307400613-13234-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1307400613-13234-1-git-send-email-kys@microsoft.com>
References: <1307400540-13193-1-git-send-email-kys@microsoft.com>
 <1307400613-13234-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of unnecessary DPRINTs in stor vsc_drv.c.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 499e1d7..73fbded 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -92,12 +92,8 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 	scsi_adjust_queue_depth(sdevice, MSG_SIMPLE_TAG,
 				STORVSC_MAX_IO_REQUESTS);
 
-	DPRINT_INFO(STORVSC_DRV, "sdev (%p) - setting max segment size to %ld",
-		    sdevice, PAGE_SIZE);
 	blk_queue_max_segment_size(sdevice->request_queue, PAGE_SIZE);
 
-	DPRINT_INFO(STORVSC_DRV, "sdev (%p) - adding merge bio vec routine",
-		    sdevice);
 	blk_queue_merge_bvec(sdevice->request_queue, storvsc_merge_bvec);
 
 	blk_queue_bounce_limit(sdevice->request_queue, BLK_BOUNCE_ANY);
@@ -314,10 +310,8 @@ static int storvsc_remove(struct hv_device *dev)
 	struct hv_host_device *host_dev =
 			(struct hv_host_device *)host->hostdata;
 
-	DPRINT_INFO(STORVSC, "removing host adapter (%p)...", host);
 	scsi_remove_host(host);
 
-	DPRINT_INFO(STORVSC, "releasing host adapter (%p)...", host);
 	scsi_host_put(host);
 
 	storvsc_dev_remove(dev);
@@ -349,9 +343,6 @@ static int storvsc_get_chs(struct scsi_device *sdev, struct block_device * bdev,
 	info[1] = sectors_pt;
 	info[2] = (int)cylinders;
 
-	DPRINT_INFO(STORVSC_DRV, "CHS (%d, %d, %d)", (int)cylinders, heads,
-			sectors_pt);
-
 	return 0;
 }
 
@@ -362,7 +353,6 @@ static int storvsc_host_reset(struct hv_device *device)
 	struct vstor_packet *vstor_packet;
 	int ret, t;
 
-	DPRINT_INFO(STORVSC, "resetting host adapter...");
 
 	stor_device = get_stor_device(device);
 	if (!stor_device)
@@ -391,7 +381,6 @@ static int storvsc_host_reset(struct hv_device *device)
 		goto cleanup;
 	}
 
-	DPRINT_INFO(STORVSC, "host adapter reset completed");
 
 	/*
 	 * At this point, all outstanding requests in the adapter
@@ -414,16 +403,10 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 		(struct hv_host_device *)scmnd->device->host->hostdata;
 	struct hv_device *dev = host_dev->dev;
 
-	DPRINT_INFO(STORVSC_DRV, "sdev (%p) dev obj (%p) - host resetting...",
-		    scmnd->device, dev);
-
 	ret = storvsc_host_reset(dev);
 	if (ret != 0)
 		return ret;
 
-	DPRINT_INFO(STORVSC_DRV, "sdev (%p) dev obj (%p) - host reseted",
-		    scmnd->device, dev);
-
 	return ret;
 }
 
@@ -500,8 +483,6 @@ static int storvsc_queuecommand_lck(struct scsi_cmnd *scmnd,
 
 		cmd_request =
 			(struct storvsc_cmd_request *)scmnd->host_scribble;
-		DPRINT_INFO(STORVSC_DRV, "retrying scmnd %p cmd_request %p",
-			    scmnd, cmd_request);
 
 		goto retry_request;
 	}
-- 
1.7.4.1

