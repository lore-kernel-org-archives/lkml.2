Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081Ab1AZUFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 15:05:25 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:44563
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753447Ab1AZUFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 15:05:24 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 3/8] staging: hv: Convert camel cased variables in vmbus_drv.c to lower cases
Date: Wed, 26 Jan 2011 12:12:09 -0800
Message-Id: <1296072734-11963-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1296072734-11963-2-git-send-email-haiyangz@microsoft.com>
References: <1296072734-11963-1-git-send-email-haiyangz@microsoft.com>
 <1296072734-11963-2-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/vmbus_drv.c |   50 ++++++++++++++++++++--------------------
 1 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index b33f497..99686f0 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -113,7 +113,7 @@ static struct device_attribute vmbus_device_attrs[] = {
 };
 
 /* The one and only one */
-static struct vmbus_driver_context g_vmbus_drv = {
+static struct vmbus_driver_context vmbus_drv = {
 	.bus.name =		"vmbus",
 	.bus.match =		vmbus_match,
 	.bus.shutdown =		vmbus_shutdown,
@@ -123,14 +123,14 @@ static struct vmbus_driver_context g_vmbus_drv = {
 	.bus.dev_attrs =	vmbus_device_attrs,
 };
 
-static const char *gDriverName = "hyperv";
+static const char *driver_name = "hyperv";
 
 /*
  * Windows vmbus does not defined this.
  * We defined this to be consistent with other devices
  */
 /* {c5295816-f63a-4d5f-8d1a-4daf999ca185} */
-static const struct hv_guid gVmbusDeviceType = {
+static const struct hv_guid device_type = {
 	.data = {
 		0x16, 0x58, 0x29, 0xc5, 0x3a, 0xf6, 0x5f, 0x4d,
 		0x8d, 0x1a, 0x4d, 0xaf, 0x99, 0x9c, 0xa1, 0x85
@@ -138,35 +138,35 @@ static const struct hv_guid gVmbusDeviceType = {
 };
 
 /* {ac3760fc-9adf-40aa-9427-a70ed6de95c5} */
-static const struct hv_guid gVmbusDeviceId = {
+static const struct hv_guid device_id = {
 	.data = {
 		0xfc, 0x60, 0x37, 0xac, 0xdf, 0x9a, 0xaa, 0x40,
 		0x94, 0x27, 0xa7, 0x0e, 0xd6, 0xde, 0x95, 0xc5
 	}
 };
 
-static struct hv_device *gDevice; /* vmbus root device */
+static struct hv_device *vmbus_device; /* vmbus root device */
 
 /*
  * VmbusChildDeviceAdd - Registers the child device with the vmbus
  */
-int VmbusChildDeviceAdd(struct hv_device *ChildDevice)
+int VmbusChildDeviceAdd(struct hv_device *child_dev)
 {
-	return vmbus_child_device_register(gDevice, ChildDevice);
+	return vmbus_child_device_register(vmbus_device, child_dev);
 }
 
 /*
  * VmbusOnDeviceAdd - Callback when the root bus device is added
  */
-static int VmbusOnDeviceAdd(struct hv_device *dev, void *AdditionalInfo)
+static int VmbusOnDeviceAdd(struct hv_device *dev, void *info)
 {
-	u32 *irqvector = AdditionalInfo;
+	u32 *irqvector = info;
 	int ret;
 
-	gDevice = dev;
+	vmbus_device = dev;
 
-	memcpy(&gDevice->deviceType, &gVmbusDeviceType, sizeof(struct hv_guid));
-	memcpy(&gDevice->deviceInstance, &gVmbusDeviceId,
+	memcpy(&vmbus_device->deviceType, &device_type, sizeof(struct hv_guid));
+	memcpy(&vmbus_device->deviceInstance, &device_id,
 	       sizeof(struct hv_guid));
 
 	/* strcpy(dev->name, "vmbus"); */
@@ -461,9 +461,9 @@ static ssize_t vmbus_show_device_attr(struct device *dev,
  */
 static int vmbus_bus_init(void)
 {
-	struct vmbus_driver_context *vmbus_drv_ctx = &g_vmbus_drv;
-	struct hv_driver *driver = &g_vmbus_drv.drv_obj;
-	struct vm_device *dev_ctx = &g_vmbus_drv.device_ctx;
+	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
+	struct hv_driver *driver = &vmbus_drv.drv_obj;
+	struct vm_device *dev_ctx = &vmbus_drv.device_ctx;
 	int ret;
 	unsigned int vector;
 
@@ -478,8 +478,8 @@ static int vmbus_bus_init(void)
 			sizeof(struct vmbus_channel_packet_page_buffer),
 			sizeof(struct vmbus_channel_packet_multipage_buffer));
 
-	driver->name = gDriverName;
-	memcpy(&driver->deviceType, &gVmbusDeviceType, sizeof(struct hv_guid));
+	driver->name = driver_name;
+	memcpy(&driver->deviceType, &device_type, sizeof(struct hv_guid));
 
 	/* Setup dispatch table */
 	driver->OnDeviceAdd	= VmbusOnDeviceAdd;
@@ -590,10 +590,10 @@ cleanup:
  */
 static void vmbus_bus_exit(void)
 {
-	struct hv_driver *driver = &g_vmbus_drv.drv_obj;
-	struct vmbus_driver_context *vmbus_drv_ctx = &g_vmbus_drv;
+	struct hv_driver *driver = &vmbus_drv.drv_obj;
+	struct vmbus_driver_context *vmbus_drv_ctx = &vmbus_drv;
 
-	struct vm_device *dev_ctx = &g_vmbus_drv.device_ctx;
+	struct vm_device *dev_ctx = &vmbus_drv.device_ctx;
 
 	/* Remove the root device */
 	if (driver->OnDeviceRemove)
@@ -634,7 +634,7 @@ int vmbus_child_driver_register(struct driver_context *driver_ctx)
 		    driver_ctx, driver_ctx->driver.name);
 
 	/* The child driver on this vmbus */
-	driver_ctx->driver.bus = &g_vmbus_drv.bus;
+	driver_ctx->driver.bus = &vmbus_drv.bus;
 
 	ret = driver_register(&driver_ctx->driver);
 
@@ -737,7 +737,7 @@ int vmbus_child_device_register(struct hv_device *root_device_obj,
 		     atomic_inc_return(&device_num));
 
 	/* The new device belongs to this bus */
-	child_device_ctx->device.bus = &g_vmbus_drv.bus; /* device->dev.bus; */
+	child_device_ctx->device.bus = &vmbus_drv.bus; /* device->dev.bus; */
 	child_device_ctx->device.parent = &root_device_ctx->device;
 	child_device_ctx->device.release = vmbus_device_release;
 
@@ -1050,7 +1050,7 @@ static void vmbus_event_dpc(unsigned long data)
 
 static irqreturn_t vmbus_isr(int irq, void *dev_id)
 {
-	struct hv_driver *driver = &g_vmbus_drv.drv_obj;
+	struct hv_driver *driver = &vmbus_drv.drv_obj;
 	int ret;
 
 	/* Call to bus driver to handle interrupt */
@@ -1059,10 +1059,10 @@ static irqreturn_t vmbus_isr(int irq, void *dev_id)
 	/* Schedules a dpc if necessary */
 	if (ret > 0) {
 		if (test_bit(0, (unsigned long *)&ret))
-			tasklet_schedule(&g_vmbus_drv.msg_dpc);
+			tasklet_schedule(&vmbus_drv.msg_dpc);
 
 		if (test_bit(1, (unsigned long *)&ret))
-			tasklet_schedule(&g_vmbus_drv.event_dpc);
+			tasklet_schedule(&vmbus_drv.event_dpc);
 
 		return IRQ_HANDLED;
 	} else {
-- 
1.6.3.2

