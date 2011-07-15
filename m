Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab1GORcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 13:32:03 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:33405
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754261Ab1GORaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 13:30:12 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 110/117] Staging: hv: vmbus: Change the signature of vmbus_child_driver_register()
Date: Fri, 15 Jul 2011 10:47:38 -0700
Message-Id: <1310752065-27895-110-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310752065-27895-1-git-send-email-kys@microsoft.com>
References: <1310752024-27854-1-git-send-email-kys@microsoft.com>
 <1310752065-27895-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the signature of vmbus_child_driver_register() to conform to the
Linux driver model.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c    |    2 +-
 drivers/staging/hv/hv_util.c     |    2 +-
 drivers/staging/hv/hyperv.h      |    2 +-
 drivers/staging/hv/netvsc_drv.c  |    2 +-
 drivers/staging/hv/storvsc_drv.c |    2 +-
 drivers/staging/hv/vmbus_drv.c   |    3 ++-
 6 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 6e1c4ce..0dfaa6a 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -948,7 +948,7 @@ static int __init mousevsc_init(void)
 	drv->driver.name = driver_name;
 
 	/* The driver belongs to vmbus */
-	vmbus_child_driver_register(&drv->driver);
+	vmbus_child_driver_register(drv);
 
 	return 0;
 }
diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
index 26693dd..a4320dc 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -300,7 +300,7 @@ static int __init init_hyperv_utils(void)
 
 	util_drv.driver.name = driver_name;
 
-	return vmbus_child_driver_register(&util_drv.driver);
+	return vmbus_child_driver_register(&util_drv);
 }
 
 static void exit_hyperv_utils(void)
diff --git a/drivers/staging/hv/hyperv.h b/drivers/staging/hv/hyperv.h
index 82ba110..a760e89 100644
--- a/drivers/staging/hv/hyperv.h
+++ b/drivers/staging/hv/hyperv.h
@@ -846,7 +846,7 @@ static inline struct hv_driver *drv_to_hv_drv(struct device_driver *d)
 
 
 /* Vmbus interface */
-int vmbus_child_driver_register(struct device_driver *drv);
+int vmbus_child_driver_register(struct hv_driver *hv_drv);
 void vmbus_child_driver_unregister(struct device_driver *drv);
 
 /*
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index 94c5abc..a204ea7 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -452,7 +452,7 @@ static int __init netvsc_drv_init(void)
 	drv->driver.name = driver_name;
 
 	/* The driver belongs to vmbus */
-	ret = vmbus_child_driver_register(&drv->driver);
+	ret = vmbus_child_driver_register(drv);
 
 	return ret;
 }
diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index ba27b51..149ef00 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -1552,7 +1552,7 @@ static int __init storvsc_drv_init(void)
 
 
 	/* The driver belongs to vmbus */
-	ret = vmbus_child_driver_register(&drv->driver);
+	ret = vmbus_child_driver_register(drv);
 
 	return ret;
 }
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 29c1712..bd5a5a7 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -525,9 +525,10 @@ static int vmbus_bus_init(int irq)
  *
  * Mainly used by Hyper-V drivers.
  */
-int vmbus_child_driver_register(struct device_driver *drv)
+int vmbus_child_driver_register(struct hv_driver *hv_drv)
 {
 	int ret;
+	struct device_driver *drv = &hv_drv->driver;
 
 	pr_info("child driver registering - name %s\n", drv->name);
 
-- 
1.7.4.1

