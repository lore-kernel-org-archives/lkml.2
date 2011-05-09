Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab1EJIr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:47:29 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:53126
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756023Ab1EJIau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:50 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 150/206] Staging: hv: Make mousevsc_drv an instance of struct hv_driver
Date: Mon,  9 May 2011 14:57:12 -0700
Message-Id: <1304978288-22999-150-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation to eliminate struct mousevsc_drv_obj,
make struct mousevsc_drv an instance of struct
hv_driver.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/hv_mouse.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 6dc2761..0eca451 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -428,14 +428,14 @@ Cleanup:
 static void mousevsc_on_receive_input_report(struct mousevsc_dev *input_device,
 				struct synthhid_input_report *input_report)
 {
-	struct mousevsc_drv_obj *input_drv;
+	struct hv_driver *input_drv;
 
 	if (!input_device->init_complete) {
 		pr_info("Initialization incomplete...ignoring input_report msg");
 		return;
 	}
 
-	input_drv = drv_to_mousedrv(input_device->device->device.driver);
+	input_drv = drv_to_hv_drv(input_device->device->device.driver);
 
 	inputreport_callback(input_device->device,
 			     input_report->buffer,
@@ -680,7 +680,7 @@ static int mousevsc_on_device_add(struct hv_device *device,
 {
 	int ret = 0;
 	struct mousevsc_dev *input_dev;
-	struct mousevsc_drv_obj *input_drv;
+	struct hv_driver *input_drv;
 	struct hv_input_dev_info dev_info;
 
 	input_dev = alloc_input_device(device);
@@ -720,7 +720,7 @@ static int mousevsc_on_device_add(struct hv_device *device,
 		return ret;
 	}
 
-	input_drv = drv_to_mousedrv(input_dev->device->device.driver);
+	input_drv = drv_to_hv_drv(input_dev->device->device.driver);
 
 	dev_info.vendor = input_dev->hid_dev_info.vendor;
 	dev_info.product = input_dev->hid_dev_info.product;
@@ -943,14 +943,14 @@ static int mousevsc_drv_exit_cb(struct device *dev, void *data)
 	return 1;
 }
 
-static struct  mousevsc_drv_obj mousevsc_drv = {
-	.base.probe = mousevsc_probe,
-	.base.remove = mousevsc_remove,
+static struct  hv_driver mousevsc_drv = {
+	.probe = mousevsc_probe,
+	.remove = mousevsc_remove,
 };
 
 static void mousevsc_drv_exit(void)
 {
-	struct hv_driver *drv = &mousevsc_drv.base;
+	struct hv_driver *drv = &mousevsc_drv;
 	int ret;
 
 	struct device *current_dev = NULL;
@@ -979,7 +979,7 @@ static void mousevsc_drv_exit(void)
 
 static int __init mousevsc_init(void)
 {
-	struct hv_driver *drv = &mousevsc_drv.base;
+	struct hv_driver *drv = &mousevsc_drv;
 
 	DPRINT_INFO(INPUTVSC_DRV, "Hyper-V Mouse driver initializing.");
 
-- 
1.7.4.1

