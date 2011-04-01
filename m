Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab1DAVVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 17:21:54 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:43474
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756572Ab1DAVVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 17:21:41 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, hjanssen@linuxonhyperv.com, haiyangz@microsoft.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 5/5] staging: hv: Convert camel case in in all functions to lower case in hv_mouse
Date: Fri,  1 Apr 2011 14:32:14 -0700
Message-Id: <1301693534-14629-5-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301693534-14629-1-git-send-email-hjanssen@microsoft.com>
References: <1301693534-14629-1-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all camelcase variables inside of all remaining functions to lower 
case in hv_mouse.

Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/staging/hv/hv_mouse.c |  225 +++++++++++++++++++++--------------------
 1 files changed, 113 insertions(+), 112 deletions(-)

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 1edcdf7..23b69c1 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -202,23 +202,23 @@ static void reportdesc_callback(struct hv_device *dev, void *packet, u32 len);
 
 static struct mousevsc_dev *alloc_input_device(struct hv_device *device)
 {
-	struct mousevsc_dev *inputDevice;
+	struct mousevsc_dev *input_dev;
 
-	inputDevice = kzalloc(sizeof(struct mousevsc_dev), GFP_KERNEL);
+	input_dev = kzalloc(sizeof(struct mousevsc_dev), GFP_KERNEL);
 
-	if (!inputDevice)
+	if (!input_dev)
 		return NULL;
 
 	/*
 	 * Set to 2 to allow both inbound and outbound traffics
 	 * (ie get_input_device() and must_get_input_device()) to proceed.
 	 */
-	atomic_cmpxchg(&inputDevice->ref_count, 0, 2);
+	atomic_cmpxchg(&input_dev->ref_count, 0, 2);
 
-	inputDevice->device = device;
-	device->ext = inputDevice;
+	input_dev->device = device;
+	device->ext = input_dev;
 
-	return inputDevice;
+	return input_dev;
 }
 
 static void free_input_device(struct mousevsc_dev *device)
@@ -232,9 +232,9 @@ static void free_input_device(struct mousevsc_dev *device)
  */
 static struct mousevsc_dev *get_input_device(struct hv_device *device)
 {
-	struct mousevsc_dev *inputDevice;
+	struct mousevsc_dev *input_dev;
 
-	inputDevice = (struct mousevsc_dev *)device->ext;
+	input_dev = (struct mousevsc_dev *)device->ext;
 
 /*
  *	FIXME
@@ -242,15 +242,15 @@ static struct mousevsc_dev *get_input_device(struct hv_device *device)
  *	what the intention is...
  *
  *	printk(KERN_ERR "-------------------------> REFCOUNT = %d",
- *	       inputDevice->ref_count);
+ *	       input_dev->ref_count);
  */
 
-	if (inputDevice && atomic_read(&inputDevice->ref_count) > 1)
-		atomic_inc(&inputDevice->ref_count);
+	if (input_dev && atomic_read(&input_dev->ref_count) > 1)
+		atomic_inc(&input_dev->ref_count);
 	else
-		inputDevice = NULL;
+		input_dev = NULL;
 
-	return inputDevice;
+	return input_dev;
 }
 
 /*
@@ -258,25 +258,25 @@ static struct mousevsc_dev *get_input_device(struct hv_device *device)
  */
 static struct mousevsc_dev *must_get_input_device(struct hv_device *device)
 {
-	struct mousevsc_dev *inputDevice;
+	struct mousevsc_dev *input_dev;
 
-	inputDevice = (struct mousevsc_dev *)device->ext;
+	input_dev = (struct mousevsc_dev *)device->ext;
 
-	if (inputDevice && atomic_read(&inputDevice->ref_count))
-		atomic_inc(&inputDevice->ref_count);
+	if (input_dev && atomic_read(&input_dev->ref_count))
+		atomic_inc(&input_dev->ref_count);
 	else
-		inputDevice = NULL;
+		input_dev = NULL;
 
-	return inputDevice;
+	return input_dev;
 }
 
 static void put_input_device(struct hv_device *device)
 {
-	struct mousevsc_dev *inputDevice;
+	struct mousevsc_dev *input_dev;
 
-	inputDevice = (struct mousevsc_dev *)device->ext;
+	input_dev = (struct mousevsc_dev *)device->ext;
 
-	atomic_dec(&inputDevice->ref_count);
+	atomic_dec(&input_dev->ref_count);
 }
 
 /*
@@ -284,15 +284,15 @@ static void put_input_device(struct hv_device *device)
  */
 static struct mousevsc_dev *release_input_device(struct hv_device *device)
 {
-	struct mousevsc_dev *inputDevice;
+	struct mousevsc_dev *input_dev;
 
-	inputDevice = (struct mousevsc_dev *)device->ext;
+	input_dev = (struct mousevsc_dev *)device->ext;
 
 	/* Busy wait until the ref drop to 2, then set it to 1  */
-	while (atomic_cmpxchg(&inputDevice->ref_count, 2, 1) != 2)
+	while (atomic_cmpxchg(&input_dev->ref_count, 2, 1) != 2)
 		udelay(100);
 
-	return inputDevice;
+	return input_dev;
 }
 
 /*
@@ -300,33 +300,33 @@ static struct mousevsc_dev *release_input_device(struct hv_device *device)
  */
 static struct mousevsc_dev *final_release_input_device(struct hv_device *device)
 {
-	struct mousevsc_dev *inputDevice;
+	struct mousevsc_dev *input_dev;
 
-	inputDevice = (struct mousevsc_dev *)device->ext;
+	input_dev = (struct mousevsc_dev *)device->ext;
 
 	/* Busy wait until the ref drop to 1, then set it to 0  */
-	while (atomic_cmpxchg(&inputDevice->ref_count, 1, 0) != 1)
+	while (atomic_cmpxchg(&input_dev->ref_count, 1, 0) != 1)
 		udelay(100);
 
 	device->ext = NULL;
-	return inputDevice;
+	return input_dev;
 }
 
 static void mousevsc_on_send_completion(struct hv_device *device,
 					struct vmpacket_descriptor *packet)
 {
-	struct mousevsc_dev *inputDevice;
+	struct mousevsc_dev *input_dev;
 	void *request;
 
-	inputDevice = must_get_input_device(device);
-	if (!inputDevice) {
+	input_dev = must_get_input_device(device);
+	if (!input_dev) {
 		pr_err("unable to get input device...device being destroyed?");
 		return;
 	}
 
 	request = (void *)(unsigned long)packet->trans_id;
 
-	if (request == &inputDevice->protocol_req) {
+	if (request == &input_dev->protocol_req) {
 		/* FIXME */
 		/* Shouldn't we be doing something here? */
 	}
@@ -419,14 +419,14 @@ Cleanup:
 static void mousevsc_on_receive_input_report(struct mousevsc_dev *input_device,
 				struct synthhid_input_report *input_report)
 {
-	struct mousevsc_drv_obj *inputDriver;
+	struct mousevsc_drv_obj *input_drv;
 
 	if (!input_device->init_complete) {
 		pr_info("Initialization incomplete...ignoring input_report msg");
 		return;
 	}
 
-	inputDriver = (struct mousevsc_drv_obj *)input_device->device->drv;
+	input_drv = (struct mousevsc_drv_obj *)input_device->device->drv;
 
 	inputreport_callback(input_device->device,
 			     input_report->buffer,
@@ -436,55 +436,55 @@ static void mousevsc_on_receive_input_report(struct mousevsc_dev *input_device,
 static void mousevsc_on_receive(struct hv_device *device,
 				struct vmpacket_descriptor *packet)
 {
-	struct pipe_prt_msg *pipeMsg;
-	struct synthhid_msg *hidMsg;
-	struct mousevsc_dev *inputDevice;
+	struct pipe_prt_msg *pipe_msg;
+	struct synthhid_msg *hid_msg;
+	struct mousevsc_dev *input_dev;
 
-	inputDevice = must_get_input_device(device);
-	if (!inputDevice) {
+	input_dev = must_get_input_device(device);
+	if (!input_dev) {
 		pr_err("unable to get input device...device being destroyed?");
 		return;
 	}
 
-	pipeMsg = (struct pipe_prt_msg *)((unsigned long)packet +
+	pipe_msg = (struct pipe_prt_msg *)((unsigned long)packet +
 						(packet->offset8 << 3));
 
-	if (pipeMsg->type != PipeMessageData) {
+	if (pipe_msg->type != PipeMessageData) {
 		pr_err("unknown pipe msg type - type %d len %d",
-			   pipeMsg->type, pipeMsg->size);
+			   pipe_msg->type, pipe_msg->size);
 		put_input_device(device);
 		return ;
 	}
 
-	hidMsg = (struct synthhid_msg *)&pipeMsg->data[0];
+	hid_msg = (struct synthhid_msg *)&pipe_msg->data[0];
 
-	switch (hidMsg->header.type) {
+	switch (hid_msg->header.type) {
 	case SynthHidProtocolResponse:
-		memcpy(&inputDevice->protocol_resp, pipeMsg,
-		       pipeMsg->size + sizeof(struct pipe_prt_msg) -
+		memcpy(&input_dev->protocol_resp, pipe_msg,
+		       pipe_msg->size + sizeof(struct pipe_prt_msg) -
 		       sizeof(unsigned char));
-		inputDevice->protocol_wait_condition = 1;
-		wake_up(&inputDevice->protocol_wait_event);
+		input_dev->protocol_wait_condition = 1;
+		wake_up(&input_dev->protocol_wait_event);
 		break;
 
 	case SynthHidInitialDeviceInfo:
-		WARN_ON(pipeMsg->size >= sizeof(struct hv_input_dev_info));
+		WARN_ON(pipe_msg->size >= sizeof(struct hv_input_dev_info));
 
 		/*
 		 * Parse out the device info into device attr,
 		 * hid desc and report desc
 		 */
-		mousevsc_on_receive_device_info(inputDevice,
-					    (struct synthhid_device_info *)&pipeMsg->data[0]);
+		mousevsc_on_receive_device_info(input_dev,
+			(struct synthhid_device_info *)&pipe_msg->data[0]);
 		break;
 	case SynthHidInputReport:
-		mousevsc_on_receive_input_report(inputDevice,
-					     (struct synthhid_input_report *)&pipeMsg->data[0]);
+		mousevsc_on_receive_input_report(input_dev,
+			(struct synthhid_input_report *)&pipe_msg->data[0]);
 
 		break;
 	default:
 		pr_err("unsupported hid msg type - type %d len %d",
-		       hidMsg->header.type, hidMsg->header.size);
+		       hid_msg->header.type, hid_msg->header.size);
 		break;
 	}
 
@@ -496,27 +496,28 @@ static void mousevsc_on_channel_callback(void *context)
 	const int packetSize = 0x100;
 	int ret = 0;
 	struct hv_device *device = (struct hv_device *)context;
-	struct mousevsc_dev *inputDevice;
+	struct mousevsc_dev *input_dev;
 
-	u32 bytesRecvd;
-	u64 requestId;
+	u32 bytes_recvd;
+	u64 req_id;
 	unsigned char packet[packetSize];
 	struct vmpacket_descriptor *desc;
 	unsigned char	*buffer = packet;
 	int	bufferlen = packetSize;
 
-	inputDevice = must_get_input_device(device);
+	input_dev = must_get_input_device(device);
 
-	if (!inputDevice) {
+	if (!input_dev) {
 		pr_err("unable to get input device...device being destroyed?");
 		return;
 	}
 
 	do {
-		ret = vmbus_recvpacket_raw(device->channel, buffer, bufferlen, &bytesRecvd, &requestId);
+		ret = vmbus_recvpacket_raw(device->channel, buffer,
+					bufferlen, &bytes_recvd, &req_id);
 
 		if (ret == 0) {
-			if (bytesRecvd > 0) {
+			if (bytes_recvd > 0) {
 				desc = (struct vmpacket_descriptor *)buffer;
 
 				switch (desc->type) {
@@ -533,8 +534,8 @@ static void mousevsc_on_channel_callback(void *context)
 					default:
 						pr_err("unhandled packet type %d, tid %llx len %d\n",
 							   desc->type,
-							   requestId,
-							   bytesRecvd);
+							   req_id,
+							   bytes_recvd);
 						break;
 				}
 
@@ -560,8 +561,8 @@ static void mousevsc_on_channel_callback(void *context)
 			}
 		} else if (ret == -2) {
 			/* Handle large packet */
-			bufferlen = bytesRecvd;
-			buffer = kzalloc(bytesRecvd, GFP_KERNEL);
+			bufferlen = bytes_recvd;
+			buffer = kzalloc(bytes_recvd, GFP_KERNEL);
 
 			if (buffer == NULL) {
 				buffer = packet;
@@ -569,7 +570,7 @@ static void mousevsc_on_channel_callback(void *context)
 
 				/* Try again next time around */
 				pr_err("unable to allocate buffer of size %d!",
-				       bytesRecvd);
+				       bytes_recvd);
 				break;
 			}
 		}
@@ -583,21 +584,21 @@ static void mousevsc_on_channel_callback(void *context)
 static int mousevsc_connect_to_vsp(struct hv_device *device)
 {
 	int ret = 0;
-	struct mousevsc_dev *inputDevice;
+	struct mousevsc_dev *input_dev;
 	struct mousevsc_prt_msg *request;
 	struct mousevsc_prt_msg *response;
 
-	inputDevice = get_input_device(device);
+	input_dev = get_input_device(device);
 
-	if (!inputDevice) {
+	if (!input_dev) {
 		pr_err("unable to get input device...device being destroyed?");
 		return -1;
 	}
 
-	init_waitqueue_head(&inputDevice->protocol_wait_event);
-	init_waitqueue_head(&inputDevice->dev_info_wait_event);
+	init_waitqueue_head(&input_dev->protocol_wait_event);
+	init_waitqueue_head(&input_dev->dev_info_wait_event);
 
-	request = &inputDevice->protocol_req;
+	request = &input_dev->protocol_req;
 
 	/*
 	 * Now, initiate the vsc/vsp initialization protocol on the open channel
@@ -625,15 +626,15 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 		goto Cleanup;
 	}
 
-	inputDevice->protocol_wait_condition = 0;
-	wait_event_timeout(inputDevice->protocol_wait_event,
-		inputDevice->protocol_wait_condition, msecs_to_jiffies(1000));
-	if (inputDevice->protocol_wait_condition == 0) {
+	input_dev->protocol_wait_condition = 0;
+	wait_event_timeout(input_dev->protocol_wait_event,
+		input_dev->protocol_wait_condition, msecs_to_jiffies(1000));
+	if (input_dev->protocol_wait_condition == 0) {
 		ret = -ETIMEDOUT;
 		goto Cleanup;
 	}
 
-	response = &inputDevice->protocol_resp;
+	response = &input_dev->protocol_resp;
 
 	if (!response->response.approved) {
 		pr_err("synthhid protocol request failed (version %d)",
@@ -642,10 +643,10 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 		goto Cleanup;
 	}
 
-	inputDevice->device_wait_condition = 0;
-	wait_event_timeout(inputDevice->dev_info_wait_event,
-		inputDevice->device_wait_condition, msecs_to_jiffies(1000));
-	if (inputDevice->device_wait_condition == 0) {
+	input_dev->device_wait_condition = 0;
+	wait_event_timeout(input_dev->dev_info_wait_event,
+		input_dev->device_wait_condition, msecs_to_jiffies(1000));
+	if (input_dev->device_wait_condition == 0) {
 		ret = -ETIMEDOUT;
 		goto Cleanup;
 	}
@@ -654,7 +655,7 @@ static int mousevsc_connect_to_vsp(struct hv_device *device)
 	 * We should have gotten the device attr, hid desc and report
 	 * desc at this point
 	 */
-	if (!inputDevice->dev_info_status)
+	if (!input_dev->dev_info_status)
 		pr_info("**** input channel up and running!! ****");
 	else
 		ret = -1;
@@ -669,18 +670,18 @@ static int mousevsc_on_device_add(struct hv_device *device,
 					void *additional_info)
 {
 	int ret = 0;
-	struct mousevsc_dev *inputDevice;
-	struct mousevsc_drv_obj *inputDriver;
+	struct mousevsc_dev *input_dev;
+	struct mousevsc_drv_obj *input_drv;
 	struct hv_input_dev_info dev_info;
 
-	inputDevice = alloc_input_device(device);
+	input_dev = alloc_input_device(device);
 
-	if (!inputDevice) {
+	if (!input_dev) {
 		ret = -1;
 		goto Cleanup;
 	}
 
-	inputDevice->init_complete = false;
+	input_dev->init_complete = false;
 
 	/* Open the channel */
 	ret = vmbus_open(device->channel,
@@ -694,7 +695,7 @@ static int mousevsc_on_device_add(struct hv_device *device,
 
 	if (ret != 0) {
 		pr_err("unable to open channel: %d", ret);
-		free_input_device(inputDevice);
+		free_input_device(input_dev);
 		return -1;
 	}
 
@@ -706,15 +707,15 @@ static int mousevsc_on_device_add(struct hv_device *device,
 		pr_err("unable to connect channel: %d", ret);
 
 		vmbus_close(device->channel);
-		free_input_device(inputDevice);
+		free_input_device(input_dev);
 		return ret;
 	}
 
-	inputDriver = (struct mousevsc_drv_obj *)inputDevice->device->drv;
+	input_drv = (struct mousevsc_drv_obj *)input_dev->device->drv;
 
-	dev_info.vendor = inputDevice->hid_dev_info.vendor;
-	dev_info.product = inputDevice->hid_dev_info.product;
-	dev_info.version = inputDevice->hid_dev_info.version;
+	dev_info.vendor = input_dev->hid_dev_info.vendor;
+	dev_info.product = input_dev->hid_dev_info.product;
+	dev_info.version = input_dev->hid_dev_info.version;
 	strcpy(dev_info.name, "Microsoft Vmbus HID-compliant Mouse");
 
 	/* Send the device info back up */
@@ -722,13 +723,13 @@ static int mousevsc_on_device_add(struct hv_device *device,
 
 	/* Send the report desc back up */
 	/* workaround SA-167 */
-	if (inputDevice->report_desc[14] == 0x25)
-		inputDevice->report_desc[14] = 0x29;
+	if (input_dev->report_desc[14] == 0x25)
+		input_dev->report_desc[14] = 0x29;
 
-	reportdesc_callback(device, inputDevice->report_desc,
-			    inputDevice->report_desc_size);
+	reportdesc_callback(device, input_dev->report_desc,
+			    input_dev->report_desc_size);
 
-	inputDevice->init_complete = true;
+	input_dev->init_complete = true;
 
 Cleanup:
 	return ret;
@@ -736,13 +737,13 @@ Cleanup:
 
 static int mousevsc_on_device_remove(struct hv_device *device)
 {
-	struct mousevsc_dev *inputDevice;
+	struct mousevsc_dev *input_dev;
 	int ret = 0;
 
 	pr_info("disabling input device (%p)...",
 		    device->ext);
 
-	inputDevice = release_input_device(device);
+	input_dev = release_input_device(device);
 
 
 	/*
@@ -751,23 +752,23 @@ static int mousevsc_on_device_remove(struct hv_device *device)
 	 *
 	 * so that outstanding requests can be completed.
 	 */
-	while (inputDevice->num_outstanding_req) {
+	while (input_dev->num_outstanding_req) {
 		pr_info("waiting for %d requests to complete...",
-			inputDevice->num_outstanding_req);
+			input_dev->num_outstanding_req);
 
 		udelay(100);
 	}
 
 	pr_info("removing input device (%p)...", device->ext);
 
-	inputDevice = final_release_input_device(device);
+	input_dev = final_release_input_device(device);
 
-	pr_info("input device (%p) safe to remove", inputDevice);
+	pr_info("input device (%p) safe to remove", input_dev);
 
 	/* Close the channel */
 	vmbus_close(device->channel);
 
-	free_input_device(inputDevice);
+	free_input_device(input_dev);
 
 	return ret;
 }
@@ -986,7 +987,7 @@ static void mousevsc_drv_exit(void)
 
 static int mouse_vsc_initialize(struct hv_driver *driver)
 {
-	struct mousevsc_drv_obj *inputDriver =
+	struct mousevsc_drv_obj *input_drv =
 		(struct mousevsc_drv_obj *)driver;
 	int ret = 0;
 
@@ -995,9 +996,9 @@ static int mouse_vsc_initialize(struct hv_driver *driver)
 	       sizeof(struct hv_guid));
 
 	/* Setup the dispatch table */
-	inputDriver->base.dev_add = mousevsc_on_device_add;
-	inputDriver->base.dev_rm = mousevsc_on_device_remove;
-	inputDriver->base.cleanup = mousevsc_on_cleanup;
+	input_drv->base.dev_add = mousevsc_on_device_add;
+	input_drv->base.dev_rm = mousevsc_on_device_remove;
+	input_drv->base.cleanup = mousevsc_on_cleanup;
 
 	return ret;
 }
-- 
1.7.1

