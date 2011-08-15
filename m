Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab1HOVwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 17:52:20 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:57469
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752938Ab1HOVwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 17:52:16 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 6/8] Staging: hv: vmbus: Get rid of some dated/redundant comments
Date: Mon, 15 Aug 2011 15:12:05 -0700
Message-Id: <1313446327-10650-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1313446327-10650-1-git-send-email-kys@microsoft.com>
References: <1313446210-10611-1-git-send-email-kys@microsoft.com>
 <1313446327-10650-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Get rid of some dated/redundant comments.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 275c4ef..f20ab9a 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -364,9 +364,6 @@ static void vmbus_onmessage_work(struct work_struct *work)
 	kfree(ctx);
 }
 
-/*
- * vmbus_on_msg_dpc - DPC routine to handle messages from the hypervisior
- */
 static void vmbus_on_msg_dpc(unsigned long data)
 {
 	int cpu = smp_processor_id();
@@ -463,15 +460,12 @@ static int vmbus_bus_init(int irq)
 		return ret;
 	}
 
-	/* Initialize the bus context */
 	tasklet_init(&event_dpc, vmbus_on_event, 0);
 
-	/* Now, register the bus  with LDM */
 	ret = bus_register(&hv_bus);
 	if (ret)
 		return ret;
 
-	/* Get the interrupt resource */
 	ret = request_irq(irq, vmbus_isr, IRQF_SAMPLE_RANDOM,
 			driver_name, hv_acpi_dev);
 
@@ -522,7 +516,6 @@ int vmbus_child_driver_register(struct hv_driver *hv_drv)
 
 	pr_info("child driver registering - name %s\n", drv->name);
 
-	/* The child driver on this vmbus */
 	drv->bus = &hv_bus;
 
 	ret = driver_register(drv);
@@ -563,7 +556,6 @@ struct hv_device *vmbus_child_device_create(uuid_le *type,
 {
 	struct hv_device *child_device_obj;
 
-	/* Allocate the new child device */
 	child_device_obj = kzalloc(sizeof(struct hv_device), GFP_KERNEL);
 	if (!child_device_obj) {
 		pr_err("Unable to allocate device object for child device\n");
@@ -589,12 +581,10 @@ int vmbus_child_device_register(struct hv_device *child_device_obj)
 
 	static atomic_t device_num = ATOMIC_INIT(0);
 
-	/* Set the device name. Otherwise, device_register() will fail. */
 	dev_set_name(&child_device_obj->device, "vmbus_0_%d",
 		     atomic_inc_return(&device_num));
 
-	/* The new device belongs to this bus */
-	child_device_obj->device.bus = &hv_bus; /* device->dev.bus; */
+	child_device_obj->device.bus = &hv_bus;
 	child_device_obj->device.parent = &hv_acpi_dev->dev;
 	child_device_obj->device.release = vmbus_device_release;
 
-- 
1.7.4.1

