Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab1HYQ3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:29:00 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:42720
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752995Ab1HYQ2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:28:55 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 08/59] Staging: hv: netvsc: Use the newly introduced vmbus ID in netvsc driver
Date: Thu, 25 Aug 2011 09:48:34 -0700
Message-Id: <1314290965-2698-8-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314290965-2698-1-git-send-email-kys@microsoft.com>
References: <1314290866-2644-1-git-send-email-kys@microsoft.com>
 <1314290965-2698-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newly introduced vmbus ID in netvsc driver. Also, do the associated
cleanup.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/netvsc.c     |   10 ----------
 drivers/staging/hv/netvsc_drv.c |   16 ++++++++++++++++
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 1506b53..6f4541b 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -35,15 +35,6 @@
 /* Globals */
 static const char *driver_name = "netvsc";
 
-/* {F8615163-DF3E-46c5-913F-F2D2F965ED0E} */
-static const uuid_le netvsc_device_type = {
-	.b = {
-		0x63, 0x51, 0x61, 0xF8, 0x3E, 0xDF, 0xc5, 0x46,
-		0x91, 0x3F, 0xF2, 0xD2, 0xF9, 0x65, 0xED, 0x0E
-	}
-};
-
-
 static struct netvsc_device *alloc_net_device(struct hv_device *device)
 {
 	struct netvsc_device *net_device;
@@ -1009,7 +1000,6 @@ int netvsc_initialize(struct hv_driver *drv)
 {
 
 	drv->name = driver_name;
-	memcpy(&drv->dev_type, &netvsc_device_type, sizeof(uuid_le));
 
 	return 0;
 }
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 61989f0..2e25c95 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -413,8 +413,24 @@ static int netvsc_remove(struct hv_device *dev)
 	return 0;
 }
 
+static const struct hv_vmbus_device_id id_table[] = {
+	{
+		/* Network guid */
+		.guid = {
+			0x63, 0x51, 0x61, 0xF8, 0x3E, 0xDF, 0xc5, 0x46,
+			0x91, 0x3F, 0xF2, 0xD2, 0xF9, 0x65, 0xED, 0x0E
+		}
+	},
+	{
+		.guid = { }
+	},
+};
+
+MODULE_DEVICE_TABLE(vmbus, id_table);
+
 /* The one and only one */
 static struct  hv_driver netvsc_drv = {
+	.id_table = id_table,
 	.probe = netvsc_probe,
 	.remove = netvsc_remove,
 };
-- 
1.7.4.1

