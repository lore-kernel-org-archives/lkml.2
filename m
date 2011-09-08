Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601Ab1IHOjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 10:39:37 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:40989
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751211Ab1IHOjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 10:39:36 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 06/25] Staging: hv: storvsc: Use the driver_data to identify ide
Date: Thu,  8 Sep 2011 07:24:17 -0700
Message-Id: <1315491876-9554-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315491876-9554-1-git-send-email-kys@microsoft.com>
References: <1315491843-9513-1-git-send-email-kys@microsoft.com>
 <1315491876-9554-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the driver_data to identify ide devices in storvsc_probe().

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |   13 +++++--------
 1 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index fff1e5b..e2c63e5 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -1366,10 +1366,12 @@ static struct scsi_host_template scsi_driver = {
 static const struct hv_vmbus_device_id id_table[] = {
 	/* SCSI guid */
 	{ VMBUS_DEVICE(0xd9, 0x63, 0x61, 0xba, 0xa1, 0x04, 0x29, 0x4d,
-		       0xb6, 0x05, 0x72, 0xe2, 0xff, 0xb1, 0xdc, 0x7f) },
+		       0xb6, 0x05, 0x72, 0xe2, 0xff, 0xb1, 0xdc, 0x7f)
+	  .driver_data = 0 },
 	/* IDE guid */
 	{ VMBUS_DEVICE(0x32, 0x26, 0x41, 0x32, 0xcb, 0x86, 0xa2, 0x44,
-		       0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5) },
+		       0x9b, 0x5c, 0x50, 0xd1, 0x41, 0x73, 0x54, 0xf5)
+	  .driver_data = 1 },
 	{ },
 };
 
@@ -1387,15 +1389,10 @@ static int storvsc_probe(struct hv_device *device,
 	struct Scsi_Host *host;
 	struct hv_host_device *host_dev;
 	struct storvsc_device_info device_info;
-	bool dev_is_ide;
+	bool dev_is_ide = ((dev_id->driver_data == 1) ? true : false);
 	int path = 0;
 	int target = 0;
 
-	if (!memcmp(&device->dev_type.b, id_table[1].guid, sizeof(uuid_le)))
-		dev_is_ide = true;
-	else
-		dev_is_ide = false;
-
 	host = scsi_host_alloc(&scsi_driver,
 			       sizeof(struct hv_host_device));
 	if (!host)
-- 
1.7.4.1

