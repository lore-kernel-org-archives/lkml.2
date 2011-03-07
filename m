Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab1CGWHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 17:07:23 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:53361
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756285Ab1CGWHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 17:07:22 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: kys@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 09/16] Staging: hv: Eliminate mousevsc_driver_context
Date: Mon,  7 Mar 2011 14:16:46 -0800
Message-Id: <1299536206-23102-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the consolidation of all driver state into one data structure;
mousevsc_driver_context structure is not needed; get rid of it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   21 +++++++--------------
 1 files changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index f762a8a..6c5c00d 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -777,11 +777,8 @@ struct input_device_context {
 	int			connected;
 };
 
-struct mousevsc_driver_context {
-	struct mousevsc_drv_obj	drv_obj;
-};
 
-static struct mousevsc_driver_context g_mousevsc_drv;
+static struct  mousevsc_drv_obj g_mousevsc_drv;
 
 static void deviceinfo_callback(struct hv_device *dev, struct hv_input_dev_info *info)
 {
@@ -824,9 +821,7 @@ static int mousevsc_probe(struct device *device)
 
 	struct hv_driver *drv =
 		drv_to_hv_drv(device->driver);
-	struct mousevsc_driver_context *mousevsc_drv_ctx =
-		(struct mousevsc_driver_context *)drv->priv;
-	struct mousevsc_drv_obj *mousevsc_drv_obj = &mousevsc_drv_ctx->drv_obj;
+	struct mousevsc_drv_obj *mousevsc_drv_obj = drv->priv;
 
 	struct vm_device *device_ctx = device_to_vm_device(device);
 	struct hv_device *device_obj = &device_ctx->device_obj;
@@ -855,9 +850,7 @@ static int mousevsc_remove(struct device *device)
 
 	struct hv_driver *drv =
 		drv_to_hv_drv(device->driver);
-	struct mousevsc_driver_context *mousevsc_drv_ctx =
-		(struct mousevsc_driver_context *)drv->priv;
-	struct mousevsc_drv_obj *mousevsc_drv_obj = &mousevsc_drv_ctx->drv_obj;
+	struct mousevsc_drv_obj *mousevsc_drv_obj = drv->priv;
 
 	struct vm_device *device_ctx = device_to_vm_device(device);
 	struct hv_device *device_obj = &device_ctx->device_obj;
@@ -956,8 +949,8 @@ static int mousevsc_drv_exit_cb(struct device *dev, void *data)
 
 static void mousevsc_drv_exit(void)
 {
-	struct mousevsc_drv_obj *mousevsc_drv_obj = &g_mousevsc_drv.drv_obj;
-	struct hv_driver *drv = &g_mousevsc_drv.drv_obj.Base;
+	struct mousevsc_drv_obj *mousevsc_drv_obj = &g_mousevsc_drv;
+	struct hv_driver *drv = &g_mousevsc_drv.Base;
 	int ret;
 
 	struct device *current_dev = NULL;
@@ -1008,8 +1001,8 @@ static int mouse_vsc_initialize(struct hv_driver *Driver)
 
 static int __init mousevsc_init(void)
 {
-	struct mousevsc_drv_obj *input_drv_obj = &g_mousevsc_drv.drv_obj;
-	struct hv_driver *drv = &g_mousevsc_drv.drv_obj.Base;
+	struct mousevsc_drv_obj *input_drv_obj = &g_mousevsc_drv;
+	struct hv_driver *drv = &g_mousevsc_drv.Base;
 
 	DPRINT_INFO(INPUTVSC_DRV, "Hyper-V Mouse driver initializing.");
 
-- 
1.5.5.6

