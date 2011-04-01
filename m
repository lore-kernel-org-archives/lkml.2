Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab1DAVVm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 17:21:42 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:43377
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756393Ab1DAVVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 17:21:37 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, hjanssen@linuxonhyperv.com, haiyangz@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/5] staging: hv: Convert camel case func params to lower case in hv_mouse
Date: Fri,  1 Apr 2011 14:32:11 -0700
Message-Id: <1301693534-14629-2-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301693534-14629-1-git-send-email-hjanssen@microsoft.com>
References: <1301693534-14629-1-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change all camelcase function params to lower case in hv_mouse

Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/staging/hv/hv_mouse.c |  172 +++++++++++++++++++++--------------------
 1 files changed, 87 insertions(+), 85 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 084ba3b..3b0390d 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -200,7 +200,7 @@ static void deviceinfo_callback(struct hv_device *dev, struct hv_input_dev_info
 static void inputreport_callback(struct hv_device *dev, void *packet, u32 len);
 static void reportdesc_callback(struct hv_device *dev, void *packet, u32 len);
 
-static struct mousevsc_dev *alloc_input_device(struct hv_device *Device)
+static struct mousevsc_dev *alloc_input_device(struct hv_device *device)
 {
 	struct mousevsc_dev *inputDevice;
 
@@ -215,26 +215,26 @@ static struct mousevsc_dev *alloc_input_device(struct hv_device *Device)
 	 */
 	atomic_cmpxchg(&inputDevice->RefCount, 0, 2);
 
-	inputDevice->Device = Device;
-	Device->ext = inputDevice;
+	inputDevice->Device = device;
+	device->ext = inputDevice;
 
 	return inputDevice;
 }
 
-static void free_input_device(struct mousevsc_dev *Device)
+static void free_input_device(struct mousevsc_dev *device)
 {
-	WARN_ON(atomic_read(&Device->RefCount) == 0);
-	kfree(Device);
+	WARN_ON(atomic_read(&device->RefCount) == 0);
+	kfree(device);
 }
 
 /*
  * Get the inputdevice object if exists and its refcount > 1
  */
-static struct mousevsc_dev *get_input_device(struct hv_device *Device)
+static struct mousevsc_dev *get_input_device(struct hv_device *device)
 {
 	struct mousevsc_dev *inputDevice;
 
-	inputDevice = (struct mousevsc_dev *)Device->ext;
+	inputDevice = (struct mousevsc_dev *)device->ext;
 
 /*
  *	FIXME
@@ -256,11 +256,11 @@ static struct mousevsc_dev *get_input_device(struct hv_device *Device)
 /*
  * Get the inputdevice object iff exists and its refcount > 0
  */
-static struct mousevsc_dev *must_get_input_device(struct hv_device *Device)
+static struct mousevsc_dev *must_get_input_device(struct hv_device *device)
 {
 	struct mousevsc_dev *inputDevice;
 
-	inputDevice = (struct mousevsc_dev *)Device->ext;
+	inputDevice = (struct mousevsc_dev *)device->ext;
 
 	if (inputDevice && atomic_read(&inputDevice->RefCount))
 		atomic_inc(&inputDevice->RefCount);
@@ -270,11 +270,11 @@ static struct mousevsc_dev *must_get_input_device(struct hv_device *Device)
 	return inputDevice;
 }
 
-static void put_input_device(struct hv_device *Device)
+static void put_input_device(struct hv_device *device)
 {
 	struct mousevsc_dev *inputDevice;
 
-	inputDevice = (struct mousevsc_dev *)Device->ext;
+	inputDevice = (struct mousevsc_dev *)device->ext;
 
 	atomic_dec(&inputDevice->RefCount);
 }
@@ -282,11 +282,11 @@ static void put_input_device(struct hv_device *Device)
 /*
  * Drop ref count to 1 to effectively disable get_input_device()
  */
-static struct mousevsc_dev *release_input_device(struct hv_device *Device)
+static struct mousevsc_dev *release_input_device(struct hv_device *device)
 {
 	struct mousevsc_dev *inputDevice;
 
-	inputDevice = (struct mousevsc_dev *)Device->ext;
+	inputDevice = (struct mousevsc_dev *)device->ext;
 
 	/* Busy wait until the ref drop to 2, then set it to 1  */
 	while (atomic_cmpxchg(&inputDevice->RefCount, 2, 1) != 2)
@@ -296,82 +296,83 @@ static struct mousevsc_dev *release_input_device(struct hv_device *Device)
 }
 
 /*
- * Drop ref count to 0. No one can use InputDevice object.
+ * Drop ref count to 0. No one can use input_device object.
  */
-static struct mousevsc_dev *final_release_input_device(struct hv_device *Device)
+static struct mousevsc_dev *final_release_input_device(struct hv_device *device)
 {
 	struct mousevsc_dev *inputDevice;
 
-	inputDevice = (struct mousevsc_dev *)Device->ext;
+	inputDevice = (struct mousevsc_dev *)device->ext;
 
 	/* Busy wait until the ref drop to 1, then set it to 0  */
 	while (atomic_cmpxchg(&inputDevice->RefCount, 1, 0) != 1)
 		udelay(100);
 
-	Device->ext = NULL;
+	device->ext = NULL;
 	return inputDevice;
 }
 
-static void mousevsc_on_send_completion(struct hv_device *Device,
-					struct vmpacket_descriptor *Packet)
+static void mousevsc_on_send_completion(struct hv_device *device,
+					struct vmpacket_descriptor *packet)
 {
 	struct mousevsc_dev *inputDevice;
 	void *request;
 
-	inputDevice = must_get_input_device(Device);
+	inputDevice = must_get_input_device(device);
 	if (!inputDevice) {
 		pr_err("unable to get input device...device being destroyed?");
 		return;
 	}
 
-	request = (void *)(unsigned long)Packet->trans_id;
+	request = (void *)(unsigned long)packet->trans_id;
 
 	if (request == &inputDevice->ProtocolReq) {
 		/* FIXME */
 		/* Shouldn't we be doing something here? */
 	}
 
-	put_input_device(Device);
+	put_input_device(device);
 }
 
-static void mousevsc_on_receive_device_info(struct mousevsc_dev *InputDevice,
-					struct synthhid_device_info *DeviceInfo)
+static void mousevsc_on_receive_device_info(struct mousevsc_dev *input_device,
+				struct synthhid_device_info *device_info)
 {
 	int ret = 0;
 	struct hid_descriptor *desc;
 	struct mousevsc_prt_msg ack;
 
 	/* Assume success for now */
-	InputDevice->DeviceInfoStatus = 0;
+	input_device->DeviceInfoStatus = 0;
 
 	/* Save the device attr */
-	memcpy(&InputDevice->hid_dev_info, &DeviceInfo->hid_dev_info, sizeof(struct hv_input_dev_info));
+	memcpy(&input_device->hid_dev_info, &device_info->hid_dev_info,
+		sizeof(struct hv_input_dev_info));
 
 	/* Save the hid desc */
-	desc = &DeviceInfo->hid_descriptor;
+	desc = &device_info->hid_descriptor;
 	WARN_ON(desc->bLength > 0);
 
-	InputDevice->HidDesc = kzalloc(desc->bLength, GFP_KERNEL);
+	input_device->HidDesc = kzalloc(desc->bLength, GFP_KERNEL);
 
-	if (!InputDevice->HidDesc) {
+	if (!input_device->HidDesc) {
 		pr_err("unable to allocate hid descriptor - size %d", desc->bLength);
 		goto Cleanup;
 	}
 
-	memcpy(InputDevice->HidDesc, desc, desc->bLength);
+	memcpy(input_device->HidDesc, desc, desc->bLength);
 
 	/* Save the report desc */
-	InputDevice->ReportDescSize = desc->desc[0].wDescriptorLength;
-	InputDevice->ReportDesc = kzalloc(InputDevice->ReportDescSize,
+	input_device->ReportDescSize = desc->desc[0].wDescriptorLength;
+	input_device->ReportDesc = kzalloc(input_device->ReportDescSize,
 					  GFP_KERNEL);
 
-	if (!InputDevice->ReportDesc) {
+	if (!input_device->ReportDesc) {
 		pr_err("unable to allocate report descriptor - size %d",
-			   InputDevice->ReportDescSize);
+			   input_device->ReportDescSize);
 		goto Cleanup;
 	}
 
-	memcpy(InputDevice->ReportDesc,
+	memcpy(input_device->ReportDesc,
 	       ((unsigned char *)desc) + desc->bLength,
 	       desc->desc[0].wDescriptorLength);
 
@@ -385,7 +386,7 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *InputDevice,
 	ack.ack.header.size = 1;
 	ack.ack.reserved = 0;
 
-	ret = vmbus_sendpacket(InputDevice->Device->channel,
+	ret = vmbus_sendpacket(input_device->Device->channel,
 			&ack,
 			sizeof(struct pipe_prt_msg) - sizeof(unsigned char) +
 			sizeof(struct synthhid_device_info_ack),
@@ -398,59 +399,60 @@ static void mousevsc_on_receive_device_info(struct mousevsc_dev *InputDevice,
 		goto Cleanup;
 	}
 
-	InputDevice->device_wait_condition = 1;
-	wake_up(&InputDevice->DeviceInfoWaitEvent);
+	input_device->device_wait_condition = 1;
+	wake_up(&input_device->DeviceInfoWaitEvent);
 
 	return;
 
 Cleanup:
-	kfree(InputDevice->HidDesc);
-	InputDevice->HidDesc = NULL;
+	kfree(input_device->HidDesc);
+	input_device->HidDesc = NULL;
 
-	kfree(InputDevice->ReportDesc);
-	InputDevice->ReportDesc = NULL;
+	kfree(input_device->ReportDesc);
+	input_device->ReportDesc = NULL;
 
-	InputDevice->DeviceInfoStatus = -1;
-	InputDevice->device_wait_condition = 1;
-	wake_up(&InputDevice->DeviceInfoWaitEvent);
+	input_device->DeviceInfoStatus = -1;
+	input_device->device_wait_condition = 1;
+	wake_up(&input_device->DeviceInfoWaitEvent);
 }
 
-static void mousevsc_on_receive_input_report(struct mousevsc_dev *InputDevice,
-				struct synthhid_input_report *InputReport)
+static void mousevsc_on_receive_input_report(struct mousevsc_dev *input_device,
+				struct synthhid_input_report *input_report)
 {
 	struct mousevsc_drv_obj *inputDriver;
 
-	if (!InputDevice->bInitializeComplete) {
-		pr_info("Initialization incomplete...ignoring InputReport msg");
+	if (!input_device->bInitializeComplete) {
+		pr_info("Initialization incomplete...ignoring input_report msg");
 		return;
 	}
 
-	inputDriver = (struct mousevsc_drv_obj *)InputDevice->Device->drv;
+	inputDriver = (struct mousevsc_drv_obj *)input_device->Device->drv;
 
-	inputreport_callback(InputDevice->Device,
-			     InputReport->buffer,
-			     InputReport->header.size);
+	inputreport_callback(input_device->Device,
+			     input_report->buffer,
+			     input_report->header.size);
 }
 
-static void mousevsc_on_receive(struct hv_device *Device,
-				struct vmpacket_descriptor *Packet)
+static void mousevsc_on_receive(struct hv_device *device,
+				struct vmpacket_descriptor *packet)
 {
 	struct pipe_prt_msg *pipeMsg;
 	struct synthhid_msg *hidMsg;
 	struct mousevsc_dev *inputDevice;
 
-	inputDevice = must_get_input_device(Device);
+	inputDevice = must_get_input_device(device);
 	if (!inputDevice) {
 		pr_err("unable to get input device...device being destroyed?");
 		return;
 	}
 
-	pipeMsg = (struct pipe_prt_msg *)((unsigned long)Packet + (Packet->offset8 << 3));
+	pipeMsg = (struct pipe_prt_msg *)((unsigned long)packet +
+						(packet->offset8 << 3));
 
 	if (pipeMsg->type != PipeMessageData) {
 		pr_err("unknown pipe msg type - type %d len %d",
 			   pipeMsg->type, pipeMsg->size);
-		put_input_device(Device);
+		put_input_device(device);
 		return ;
 	}
 
@@ -486,14 +488,14 @@ static void mousevsc_on_receive(struct hv_device *Device,
 		break;
 	}
 
-	put_input_device(Device);
+	put_input_device(device);
 }
 
-static void mousevsc_on_channel_callback(void *Context)
+static void mousevsc_on_channel_callback(void *context)
 {
 	const int packetSize = 0x100;
 	int ret = 0;
-	struct hv_device *device = (struct hv_device *)Context;
+	struct hv_device *device = (struct hv_device *)context;
 	struct mousevsc_dev *inputDevice;
 
 	u32 bytesRecvd;
@@ -578,14 +580,14 @@ static void mousevsc_on_channel_callback(void *Context)
 	return;
 }
 
-static int mousevsc_connect_to_vsp(struct hv_device *Device)
+static int mousevsc_connect_to_vsp(struct hv_device *device)
 {
 	int ret = 0;
 	struct mousevsc_dev *inputDevice;
 	struct mousevsc_prt_msg *request;
 	struct mousevsc_prt_msg *response;
 
-	inputDevice = get_input_device(Device);
+	inputDevice = get_input_device(device);
 
 	if (!inputDevice) {
 		pr_err("unable to get input device...device being destroyed?");
@@ -611,7 +613,7 @@ static int mousevsc_connect_to_vsp(struct hv_device *Device)
 
 	pr_info("synthhid protocol request...");
 
-	ret = vmbus_sendpacket(Device->channel, request,
+	ret = vmbus_sendpacket(device->channel, request,
 					sizeof(struct pipe_prt_msg) -
 					sizeof(unsigned char) +
 					sizeof(struct synthhid_protocol_request),
@@ -656,20 +658,20 @@ static int mousevsc_connect_to_vsp(struct hv_device *Device)
 		ret = -1;
 
 Cleanup:
-	put_input_device(Device);
+	put_input_device(device);
 
 	return ret;
 }
 
-static int mousevsc_on_device_add(struct hv_device *Device,
-					void *AdditionalInfo)
+static int mousevsc_on_device_add(struct hv_device *device,
+					void *additional_info)
 {
 	int ret = 0;
 	struct mousevsc_dev *inputDevice;
 	struct mousevsc_drv_obj *inputDriver;
 	struct hv_input_dev_info dev_info;
 
-	inputDevice = alloc_input_device(Device);
+	inputDevice = alloc_input_device(device);
 
 	if (!inputDevice) {
 		ret = -1;
@@ -679,13 +681,13 @@ static int mousevsc_on_device_add(struct hv_device *Device,
 	inputDevice->bInitializeComplete = false;
 
 	/* Open the channel */
-	ret = vmbus_open(Device->channel,
+	ret = vmbus_open(device->channel,
 		INPUTVSC_SEND_RING_BUFFER_SIZE,
 		INPUTVSC_RECV_RING_BUFFER_SIZE,
 		NULL,
 		0,
 		mousevsc_on_channel_callback,
-		Device
+		device
 		);
 
 	if (ret != 0) {
@@ -696,12 +698,12 @@ static int mousevsc_on_device_add(struct hv_device *Device,
 
 	pr_info("InputVsc channel open: %d", ret);
 
-	ret = mousevsc_connect_to_vsp(Device);
+	ret = mousevsc_connect_to_vsp(device);
 
 	if (ret != 0) {
 		pr_err("unable to connect channel: %d", ret);
 
-		vmbus_close(Device->channel);
+		vmbus_close(device->channel);
 		free_input_device(inputDevice);
 		return ret;
 	}
@@ -714,14 +716,14 @@ static int mousevsc_on_device_add(struct hv_device *Device,
 	strcpy(dev_info.name, "Microsoft Vmbus HID-compliant Mouse");
 
 	/* Send the device info back up */
-	deviceinfo_callback(Device, &dev_info);
+	deviceinfo_callback(device, &dev_info);
 
 	/* Send the report desc back up */
 	/* workaround SA-167 */
 	if (inputDevice->ReportDesc[14] == 0x25)
 		inputDevice->ReportDesc[14] = 0x29;
 
-	reportdesc_callback(Device, inputDevice->ReportDesc,
+	reportdesc_callback(device, inputDevice->ReportDesc,
 			    inputDevice->ReportDescSize);
 
 	inputDevice->bInitializeComplete = true;
@@ -730,15 +732,15 @@ Cleanup:
 	return ret;
 }
 
-static int mousevsc_on_device_remove(struct hv_device *Device)
+static int mousevsc_on_device_remove(struct hv_device *device)
 {
 	struct mousevsc_dev *inputDevice;
 	int ret = 0;
 
 	pr_info("disabling input device (%p)...",
-		    Device->ext);
+		    device->ext);
 
-	inputDevice = release_input_device(Device);
+	inputDevice = release_input_device(device);
 
 
 	/*
@@ -753,14 +755,14 @@ static int mousevsc_on_device_remove(struct hv_device *Device)
 		udelay(100);
 	}
 
-	pr_info("removing input device (%p)...", Device->ext);
+	pr_info("removing input device (%p)...", device->ext);
 
-	inputDevice = final_release_input_device(Device);
+	inputDevice = final_release_input_device(device);
 
 	pr_info("input device (%p) safe to remove", inputDevice);
 
 	/* Close the channel */
-	vmbus_close(Device->channel);
+	vmbus_close(device->channel);
 
 	free_input_device(inputDevice);
 
@@ -979,14 +981,14 @@ static void mousevsc_drv_exit(void)
 	return;
 }
 
-static int mouse_vsc_initialize(struct hv_driver *Driver)
+static int mouse_vsc_initialize(struct hv_driver *driver)
 {
 	struct mousevsc_drv_obj *inputDriver =
-		(struct mousevsc_drv_obj *)Driver;
+		(struct mousevsc_drv_obj *)driver;
 	int ret = 0;
 
-	Driver->name = driver_name;
-	memcpy(&Driver->dev_type, &mouse_guid,
+	driver->name = driver_name;
+	memcpy(&driver->dev_type, &mouse_guid,
 	       sizeof(struct hv_guid));
 
 	/* Setup the dispatch table */
-- 
1.7.1

