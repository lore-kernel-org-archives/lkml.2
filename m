Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab1EJIvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:51:03 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:42587
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755961Ab1EJIat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:49 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 140/206] Staging: hv: Inline the copying of the dev_type information
Date: Mon,  9 May 2011 14:57:02 -0700
Message-Id: <1304978288-22999-140-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preperation to eliminate the function storvsc_initialize()
move the copying of dev_type info.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 9447130..3be4f1a 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -83,12 +83,6 @@ static int storvsc_initialize(struct hv_driver *driver)
 
 	stor_driver = hvdr_to_stordr(driver);
 
-
-	/* Make sure we are at least 2 pages since 1 page is used for control */
-
-	memcpy(&driver->dev_type, &gStorVscDeviceType,
-	       sizeof(struct hv_guid));
-
 	return 0;
 }
 
@@ -801,6 +795,9 @@ static int storvsc_drv_init(void)
 	/* Callback to client driver to complete the initialization */
 	storvsc_initialize(&storvsc_drv_obj->base);
 
+	memcpy(&drv->dev_type, &gStorVscDeviceType,
+	       sizeof(struct hv_guid));
+
 	if (max_outstanding_req_per_channel <
 	    STORVSC_MAX_IO_REQUESTS)
 		return -1;
-- 
1.7.4.1

