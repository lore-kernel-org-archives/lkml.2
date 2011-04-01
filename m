Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab1DAVVe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 17:21:34 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:43516
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756217Ab1DAVVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 17:21:33 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, hjanssen@linuxonhyperv.com, haiyangz@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/5] staging: hv: change camel case funct names to lower case funct in hv_mouse
Date: Fri,  1 Apr 2011 14:32:10 -0700
Message-Id: <1301693534-14629-1-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change all camelcase function names to lower case in hv_mouse

Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/staging/hv/hv_mouse.c |   92 ++++++++++++++++++++++-------------------
 1 files changed, 49 insertions(+), 43 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 50147f8..084ba3b 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -200,7 +200,7 @@ static void deviceinfo_callback(struct hv_device *dev, struct hv_input_dev_info
 static void inputreport_callback(struct hv_device *dev, void *packet, u32 len);
 static void reportdesc_callback(struct hv_device *dev, void *packet, u32 len);
 
-static struct mousevsc_dev *AllocInputDevice(struct hv_device *Device)
+static struct mousevsc_dev *alloc_input_device(struct hv_device *Device)
 {
 	struct mousevsc_dev *inputDevice;
 
@@ -211,7 +211,7 @@ static struct mousevsc_dev *AllocInputDevice(struct hv_device *Device)
 
 	/*
 	 * Set to 2 to allow both inbound and outbound traffics
-	 * (ie GetInputDevice() and MustGetInputDevice()) to proceed.
+	 * (ie get_input_device() and must_get_input_device()) to proceed.
 	 */
 	atomic_cmpxchg(&inputDevice->RefCount, 0, 2);
 
@@ -221,7 +221,7 @@ static struct mousevsc_dev *AllocInputDevice(struct hv_device *Device)
 	return inputDevice;
 }
 
-static void FreeInputDevice(struct mousevsc_dev *Device)
+static void free_input_device(struct mousevsc_dev *Device)
 {
 	WARN_ON(atomic_read(&Device->RefCount) == 0);
 	kfree(Device);
@@ -230,7 +230,7 @@ static void FreeInputDevice(struct mousevsc_dev *Device)
 /*
  * Get the inputdevice object if exists and its refcount > 1
  */
-static struct mousevsc_dev *GetInputDevice(struct hv_device *Device)
+static struct mousevsc_dev *get_input_device(struct hv_device *Device)
 {
 	struct mousevsc_dev *inputDevice;
 
@@ -256,7 +256,7 @@ static struct mousevsc_dev *GetInputDevice(struct hv_device *Device)
 /*
  * Get the inputdevice object iff exists and its refcount > 0
  */
-static struct mousevsc_dev *MustGetInputDevice(struct hv_device *Device)
+static struct mousevsc_dev *must_get_input_device(struct hv_device *Device)
 {
 	struct mousevsc_dev *inputDevice;
 
@@ -270,7 +270,7 @@ static struct mousevsc_dev *MustGetInputDevice(struct hv_device *Device)
 	return inputDevice;
 }
 
-static void PutInputDevice(struct hv_device *Device)
+static void put_input_device(struct hv_device *Device)
 {
 	struct mousevsc_dev *inputDevice;
 
@@ -280,9 +280,9 @@ static void PutInputDevice(struct hv_device *Device)
 }
 
 /*
- * Drop ref count to 1 to effectively disable GetInputDevice()
+ * Drop ref count to 1 to effectively disable get_input_device()
  */
-static struct mousevsc_dev *ReleaseInputDevice(struct hv_device *Device)
+static struct mousevsc_dev *release_input_device(struct hv_device *Device)
 {
 	struct mousevsc_dev *inputDevice;
 
@@ -298,7 +298,7 @@ static struct mousevsc_dev *ReleaseInputDevice(struct hv_device *Device)
 /*
  * Drop ref count to 0. No one can use InputDevice object.
  */
-static struct mousevsc_dev *FinalReleaseInputDevice(struct hv_device *Device)
+static struct mousevsc_dev *final_release_input_device(struct hv_device *Device)
 {
 	struct mousevsc_dev *inputDevice;
 
@@ -312,12 +312,13 @@ static struct mousevsc_dev *FinalReleaseInputDevice(struct hv_device *Device)
 	return inputDevice;
 }
 
-static void MousevscOnSendCompletion(struct hv_device *Device, struct vmpacket_descriptor *Packet)
+static void mousevsc_on_send_completion(struct hv_device *Device,
+					struct vmpacket_descriptor *Packet)
 {
 	struct mousevsc_dev *inputDevice;
 	void *request;
 
-	inputDevice = MustGetInputDevice(Device);
+	inputDevice = must_get_input_device(Device);
 	if (!inputDevice) {
 		pr_err("unable to get input device...device being destroyed?");
 		return;
@@ -330,10 +331,11 @@ static void MousevscOnSendCompletion(struct hv_device *Device, struct vmpacket_d
 		/* Shouldn't we be doing something here? */
 	}
 
-	PutInputDevice(Device);
+	put_input_device(Device);
 }
 
-static void MousevscOnReceiveDeviceInfo(struct mousevsc_dev *InputDevice, struct synthhid_device_info *DeviceInfo)
+static void mousevsc_on_receive_device_info(struct mousevsc_dev *InputDevice,
+					struct synthhid_device_info *DeviceInfo)
 {
 	int ret = 0;
 	struct hid_descriptor *desc;
@@ -413,7 +415,8 @@ Cleanup:
 	wake_up(&InputDevice->DeviceInfoWaitEvent);
 }
 
-static void MousevscOnReceiveInputReport(struct mousevsc_dev *InputDevice, struct synthhid_input_report *InputReport)
+static void mousevsc_on_receive_input_report(struct mousevsc_dev *InputDevice,
+				struct synthhid_input_report *InputReport)
 {
 	struct mousevsc_drv_obj *inputDriver;
 
@@ -429,13 +432,14 @@ static void MousevscOnReceiveInputReport(struct mousevsc_dev *InputDevice, struc
 			     InputReport->header.size);
 }
 
-static void MousevscOnReceive(struct hv_device *Device, struct vmpacket_descriptor *Packet)
+static void mousevsc_on_receive(struct hv_device *Device,
+				struct vmpacket_descriptor *Packet)
 {
 	struct pipe_prt_msg *pipeMsg;
 	struct synthhid_msg *hidMsg;
 	struct mousevsc_dev *inputDevice;
 
-	inputDevice = MustGetInputDevice(Device);
+	inputDevice = must_get_input_device(Device);
 	if (!inputDevice) {
 		pr_err("unable to get input device...device being destroyed?");
 		return;
@@ -446,7 +450,7 @@ static void MousevscOnReceive(struct hv_device *Device, struct vmpacket_descript
 	if (pipeMsg->type != PipeMessageData) {
 		pr_err("unknown pipe msg type - type %d len %d",
 			   pipeMsg->type, pipeMsg->size);
-		PutInputDevice(Device);
+		put_input_device(Device);
 		return ;
 	}
 
@@ -468,11 +472,11 @@ static void MousevscOnReceive(struct hv_device *Device, struct vmpacket_descript
 		 * Parse out the device info into device attr,
 		 * hid desc and report desc
 		 */
-		MousevscOnReceiveDeviceInfo(inputDevice,
+		mousevsc_on_receive_device_info(inputDevice,
 					    (struct synthhid_device_info *)&pipeMsg->data[0]);
 		break;
 	case SynthHidInputReport:
-		MousevscOnReceiveInputReport(inputDevice,
+		mousevsc_on_receive_input_report(inputDevice,
 					     (struct synthhid_input_report *)&pipeMsg->data[0]);
 
 		break;
@@ -482,10 +486,10 @@ static void MousevscOnReceive(struct hv_device *Device, struct vmpacket_descript
 		break;
 	}
 
-	PutInputDevice(Device);
+	put_input_device(Device);
 }
 
-static void MousevscOnChannelCallback(void *Context)
+static void mousevsc_on_channel_callback(void *Context)
 {
 	const int packetSize = 0x100;
 	int ret = 0;
@@ -499,7 +503,7 @@ static void MousevscOnChannelCallback(void *Context)
 	unsigned char	*buffer = packet;
 	int	bufferlen = packetSize;
 
-	inputDevice = MustGetInputDevice(device);
+	inputDevice = must_get_input_device(device);
 
 	if (!inputDevice) {
 		pr_err("unable to get input device...device being destroyed?");
@@ -515,12 +519,13 @@ static void MousevscOnChannelCallback(void *Context)
 
 				switch (desc->type) {
 					case VM_PKT_COMP:
-						MousevscOnSendCompletion(device,
-									 desc);
+						mousevsc_on_send_completion(
+							device, desc);
 						break;
 
 					case VM_PKT_DATA_INBAND:
-						MousevscOnReceive(device, desc);
+						mousevsc_on_receive(
+							device, desc);
 						break;
 
 					default:
@@ -568,19 +573,19 @@ static void MousevscOnChannelCallback(void *Context)
 		}
 	} while (1);
 
-	PutInputDevice(device);
+	put_input_device(device);
 
 	return;
 }
 
-static int MousevscConnectToVsp(struct hv_device *Device)
+static int mousevsc_connect_to_vsp(struct hv_device *Device)
 {
 	int ret = 0;
 	struct mousevsc_dev *inputDevice;
 	struct mousevsc_prt_msg *request;
 	struct mousevsc_prt_msg *response;
 
-	inputDevice = GetInputDevice(Device);
+	inputDevice = get_input_device(Device);
 
 	if (!inputDevice) {
 		pr_err("unable to get input device...device being destroyed?");
@@ -651,19 +656,20 @@ static int MousevscConnectToVsp(struct hv_device *Device)
 		ret = -1;
 
 Cleanup:
-	PutInputDevice(Device);
+	put_input_device(Device);
 
 	return ret;
 }
 
-static int MousevscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
+static int mousevsc_on_device_add(struct hv_device *Device,
+					void *AdditionalInfo)
 {
 	int ret = 0;
 	struct mousevsc_dev *inputDevice;
 	struct mousevsc_drv_obj *inputDriver;
 	struct hv_input_dev_info dev_info;
 
-	inputDevice = AllocInputDevice(Device);
+	inputDevice = alloc_input_device(Device);
 
 	if (!inputDevice) {
 		ret = -1;
@@ -678,25 +684,25 @@ static int MousevscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
 		INPUTVSC_RECV_RING_BUFFER_SIZE,
 		NULL,
 		0,
-		MousevscOnChannelCallback,
+		mousevsc_on_channel_callback,
 		Device
 		);
 
 	if (ret != 0) {
 		pr_err("unable to open channel: %d", ret);
-		FreeInputDevice(inputDevice);
+		free_input_device(inputDevice);
 		return -1;
 	}
 
 	pr_info("InputVsc channel open: %d", ret);
 
-	ret = MousevscConnectToVsp(Device);
+	ret = mousevsc_connect_to_vsp(Device);
 
 	if (ret != 0) {
 		pr_err("unable to connect channel: %d", ret);
 
 		vmbus_close(Device->channel);
-		FreeInputDevice(inputDevice);
+		free_input_device(inputDevice);
 		return ret;
 	}
 
@@ -724,7 +730,7 @@ Cleanup:
 	return ret;
 }
 
-static int MousevscOnDeviceRemove(struct hv_device *Device)
+static int mousevsc_on_device_remove(struct hv_device *Device)
 {
 	struct mousevsc_dev *inputDevice;
 	int ret = 0;
@@ -732,7 +738,7 @@ static int MousevscOnDeviceRemove(struct hv_device *Device)
 	pr_info("disabling input device (%p)...",
 		    Device->ext);
 
-	inputDevice = ReleaseInputDevice(Device);
+	inputDevice = release_input_device(Device);
 
 
 	/*
@@ -749,19 +755,19 @@ static int MousevscOnDeviceRemove(struct hv_device *Device)
 
 	pr_info("removing input device (%p)...", Device->ext);
 
-	inputDevice = FinalReleaseInputDevice(Device);
+	inputDevice = final_release_input_device(Device);
 
 	pr_info("input device (%p) safe to remove", inputDevice);
 
 	/* Close the channel */
 	vmbus_close(Device->channel);
 
-	FreeInputDevice(inputDevice);
+	free_input_device(inputDevice);
 
 	return ret;
 }
 
-static void MousevscOnCleanup(struct hv_driver *drv)
+static void mousevsc_on_cleanup(struct hv_driver *drv)
 {
 }
 
@@ -984,9 +990,9 @@ static int mouse_vsc_initialize(struct hv_driver *Driver)
 	       sizeof(struct hv_guid));
 
 	/* Setup the dispatch table */
-	inputDriver->Base.dev_add = MousevscOnDeviceAdd;
-	inputDriver->Base.dev_rm = MousevscOnDeviceRemove;
-	inputDriver->Base.cleanup = MousevscOnCleanup;
+	inputDriver->Base.dev_add = mousevsc_on_device_add;
+	inputDriver->Base.dev_rm = mousevsc_on_device_remove;
+	inputDriver->Base.cleanup = mousevsc_on_cleanup;
 
 	return ret;
 }
-- 
1.7.1

