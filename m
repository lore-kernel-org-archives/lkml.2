Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab1EJIvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:51:05 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42579
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755740Ab1EJIat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:49 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 010/206] Staging: hv: Get rid of the indirection for invoking device_add
Date: Mon,  9 May 2011 14:54:52 -0700
Message-Id: <1304978288-22999-10-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the indirection for invoking device_add.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/blkvsc_drv.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 0005e33..434c2a9 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -197,7 +197,6 @@ static int blk_vsc_initialize(struct hv_driver *driver)
 		    stor_driver->max_outstanding_req_per_channel);
 
 	/* Setup the dispatch table */
-	stor_driver->base.dev_add = blkvsc_device_add;
 	stor_driver->base.dev_rm = stor_vsc_on_device_remove;
 	stor_driver->base.cleanup = stor_vsc_on_cleanup;
 	stor_driver->on_io_request = stor_vsc_on_io_request;
@@ -964,8 +963,7 @@ static int blkvsc_probe(struct hv_device *dev)
 	}
 
 
-	/* Call to the vsc driver to add the device */
-	ret = storvsc_drv->base.dev_add(dev, &device_info);
+	ret =  blkvsc_device_add(dev, &device_info);
 	if (ret != 0)
 		goto cleanup;
 
-- 
1.7.4.1

