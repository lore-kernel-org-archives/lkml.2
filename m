Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab1EIV4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:56:09 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54300
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755005Ab1EIVou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:50 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 086/206] Staging: hv: Cleanup calls to cleanup in storvsc_drv.c
Date: Mon,  9 May 2011 14:56:08 -0700
Message-Id: <1304978288-22999-86-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cleanup() is an empty function; get rid of calls to this.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 5624d26..0d7e43b 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -833,7 +833,6 @@ static int storvsc_drv_exit_cb(struct device *dev, void *data)
 
 static void storvsc_drv_exit(void)
 {
-	struct storvsc_driver *storvsc_drv_obj = &storvsc_drv;
 	struct hv_driver *drv = &storvsc_drv.base;
 	struct device *current_dev = NULL;
 	int ret;
@@ -854,9 +853,6 @@ static void storvsc_drv_exit(void)
 		device_unregister(current_dev);
 	}
 
-	if (storvsc_drv_obj->base.cleanup)
-		storvsc_drv_obj->base.cleanup(&storvsc_drv_obj->base);
-
 	vmbus_child_driver_unregister(&drv->driver);
 	return;
 }
-- 
1.7.4.1

