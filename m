Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab1FPURM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 16:17:12 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:32832
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758682Ab1FPUB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 16:01:58 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 27/77] Staging: hv: vmbus: Cleanup vmbus_match() function
Date: Thu, 16 Jun 2011 13:17:00 -0700
Message-Id: <1308255470-3826-27-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308255470-3826-1-git-send-email-kys@microsoft.com>
References: <1308255393-3785-1-git-send-email-kys@microsoft.com>
 <1308255470-3826-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, based on the newly introduved id_table, cleanup the 
vmbus_match function. This mechanism will also permit us to handle
multiple device types using a common driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index cbb80ec..0e1a13c 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -250,16 +250,16 @@ static int vmbus_uevent(struct device *device, struct kobj_uevent_env *env)
  */
 static int vmbus_match(struct device *device, struct device_driver *driver)
 {
-	int match = 0;
 	struct hv_driver *drv = drv_to_hv_drv(driver);
 	struct hv_device *hv_dev = device_to_hv_device(device);
+	const struct hv_vmbus_device_id *id_array = drv->id_table;
 
-	/* We found our driver ? */
-	if (memcmp(&hv_dev->dev_type, &drv->dev_type,
-		   sizeof(struct hv_guid)) == 0)
-		match = 1;
+	for (; *id_array->device_type != '\0'; id_array++) {
+		if (!strcmp(id_array->device_type, hv_dev->device_type))
+			return 1;
+	}
 
-	return match;
+	return 0;
 }
 
 /*
-- 
1.7.4.1

