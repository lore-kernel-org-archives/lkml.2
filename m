Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab1IMRjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 13:39:09 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:51305
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755857Ab1IMRiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 13:38:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 08/20] Staging: hv: vmbus: Cleanup vmbus_remove()
Date: Tue, 13 Sep 2011 10:59:44 -0700
Message-Id: <1315936796-20662-8-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1315936796-20662-1-git-send-email-kys@microsoft.com>
References: <1315936759-20623-1-git-send-email-kys@microsoft.com>
 <1315936796-20662-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vmbus_remove() cannot fail; clean it up accordingly.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   20 ++++++--------------
 1 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 2fccb1f..466425a 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -334,22 +334,14 @@ static int vmbus_probe(struct device *child_device)
  */
 static int vmbus_remove(struct device *child_device)
 {
-	int ret;
-	struct hv_driver *drv;
-
+	struct hv_driver *drv = drv_to_hv_drv(child_device->driver);
 	struct hv_device *dev = device_to_hv_device(child_device);
 
-	if (child_device->driver) {
-		drv = drv_to_hv_drv(child_device->driver);
-
-		if (drv->remove) {
-			ret = drv->remove(dev);
-		} else {
-			pr_err("remove not set for driver %s\n",
-				dev_name(child_device));
-			ret = -ENODEV;
-		}
-	}
+	if (drv->remove)
+		drv->remove(dev);
+	else
+		pr_err("remove not set for driver %s\n",
+			dev_name(child_device));
 
 	return 0;
 }
-- 
1.7.4.1

