Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab1EIWMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:12:46 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:48560
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751626Ab1EIVon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:43 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 017/206] Staging: hv: Get rid of the indirection for invoking io request
Date: Mon,  9 May 2011 14:54:59 -0700
Message-Id: <1304978288-22999-17-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index bfec15c..9de7df7a 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -195,8 +195,6 @@ static int blk_vsc_initialize(struct hv_driver *driver)
 	DPRINT_INFO(BLKVSC, "max io outstd %u",
 		    stor_driver->max_outstanding_req_per_channel);
 
-	/* Setup the dispatch table */
-	stor_driver->on_io_request = storvsc_do_io;
 
 	return ret;
 }
@@ -206,9 +204,6 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 			void (*request_completion)(struct hv_storvsc_request *))
 {
 	struct block_device_context *blkdev = blkvsc_req->dev;
-	struct hv_device *device_ctx = blkdev->device_ctx;
-	struct storvsc_driver *storvsc_drv =
-			drv_to_stordrv(device_ctx->device.driver);
 	struct hv_storvsc_request *storvsc_req;
 	struct vmscsi_request *vm_srb;
 	int ret;
@@ -233,7 +228,7 @@ static int blkvsc_submit_request(struct blkvsc_request *blkvsc_req,
 
 	storvsc_req->sense_buffer = blkvsc_req->sense_buffer;
 
-	ret = storvsc_drv->on_io_request(blkdev->device_ctx,
+	ret =  storvsc_do_io(blkdev->device_ctx,
 					   &blkvsc_req->request);
 	if (ret == 0)
 		blkdev->num_outstanding_reqs++;
-- 
1.7.4.1

