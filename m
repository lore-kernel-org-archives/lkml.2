Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab1H0SMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 14:12:24 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54889
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751580Ab1H0SLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 14:11:13 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 40/46] Staging: hv: vmbus: Get rid of some dated/redundant comments
Date: Sat, 27 Aug 2011 11:31:39 -0700
Message-Id: <1314469905-7058-40-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314469905-7058-1-git-send-email-kys@microsoft.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of some dated/redundant comments in vmbus_drv.c

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   11 +----------
 1 files changed, 1 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index d50fa89..02edb11 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -391,9 +391,6 @@ static void vmbus_onmessage_work(struct work_struct *work)
 	kfree(ctx);
 }
 
-/*
- * vmbus_on_msg_dpc - DPC routine to handle messages from the hypervisior
- */
 static void vmbus_on_msg_dpc(unsigned long data)
 {
 	int cpu = smp_processor_id();
@@ -490,16 +487,13 @@ static int vmbus_bus_init(int irq)
 		return ret;
 	}
 
-	/* Initialize the bus context */
 	tasklet_init(&msg_dpc, vmbus_on_msg_dpc, 0);
 	tasklet_init(&event_dpc, vmbus_on_event, 0);
 
-	/* Now, register the bus  with LDM */
 	ret = bus_register(&hv_bus);
 	if (ret)
 		return ret;
 
-	/* Get the interrupt resource */
 	ret = request_irq(irq, vmbus_isr, IRQF_SAMPLE_RANDOM,
 			driver_name, hv_acpi_dev);
 
@@ -588,7 +582,6 @@ struct hv_device *vmbus_child_device_create(uuid_le *type,
 {
 	struct hv_device *child_device_obj;
 
-	/* Allocate the new child device */
 	child_device_obj = kzalloc(sizeof(struct hv_device), GFP_KERNEL);
 	if (!child_device_obj) {
 		pr_err("Unable to allocate device object for child device\n");
@@ -613,12 +606,10 @@ int vmbus_child_device_register(struct hv_device *child_device_obj)
 
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

