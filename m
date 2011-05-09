Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326Ab1EIWIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:08:34 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:48607
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753165Ab1EIVoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:44 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 031/206] Staging: hv: Get rid of some unnecessary DPRINTS
Date: Mon,  9 May 2011 14:55:13 -0700
Message-Id: <1304978288-22999-31-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/storvsc.c |  116 ++++++------------------------------------
 1 files changed, 16 insertions(+), 100 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 5d5aec3..41361f5 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -113,11 +113,8 @@ static int storvsc_channel_init(struct hv_device *device)
 	int ret, t;
 
 	stor_device = get_stor_device(device);
-	if (!stor_device) {
-		DPRINT_ERR(STORVSC, "unable to get stor device..."
-			   "device being destroyed?");
+	if (!stor_device)
 		return -1;
-	}
 
 	request = &stor_device->init_request;
 	vstor_packet = &request->vstor_packet;
@@ -138,11 +135,8 @@ static int storvsc_channel_init(struct hv_device *device)
 			       (unsigned long)request,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-	if (ret != 0) {
-		DPRINT_ERR(STORVSC,
-			   "unable to send BEGIN_INITIALIZATION_OPERATION");
+	if (ret != 0)
 		goto cleanup;
-	}
 
 	t = wait_for_completion_timeout(&request->wait_event, HZ);
 	if (t == 0) {
@@ -151,12 +145,8 @@ static int storvsc_channel_init(struct hv_device *device)
 	}
 
 	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0) {
-		DPRINT_ERR(STORVSC, "BEGIN_INITIALIZATION_OPERATION failed "
-			   "(op %d status 0x%x)",
-			   vstor_packet->operation, vstor_packet->status);
+	    vstor_packet->status != 0)
 		goto cleanup;
-	}
 
 	DPRINT_INFO(STORVSC, "QUERY_PROTOCOL_VERSION_OPERATION...");
 
@@ -173,11 +163,8 @@ static int storvsc_channel_init(struct hv_device *device)
 			       (unsigned long)request,
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
-	if (ret != 0) {
-		DPRINT_ERR(STORVSC,
-			   "unable to send BEGIN_INITIALIZATION_OPERATION");
+	if (ret != 0)
 		goto cleanup;
-	}
 
 	t = wait_for_completion_timeout(&request->wait_event, HZ);
 	if (t == 0) {
@@ -187,12 +174,8 @@ static int storvsc_channel_init(struct hv_device *device)
 
 	/* TODO: Check returned version */
 	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0) {
-		DPRINT_ERR(STORVSC, "QUERY_PROTOCOL_VERSION_OPERATION failed "
-			   "(op %d status 0x%x)",
-			   vstor_packet->operation, vstor_packet->status);
+	    vstor_packet->status != 0)
 		goto cleanup;
-	}
 
 	/* Query channel properties */
 	DPRINT_INFO(STORVSC, "QUERY_PROPERTIES_OPERATION...");
@@ -209,11 +192,8 @@ static int storvsc_channel_init(struct hv_device *device)
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 
-	if (ret != 0) {
-		DPRINT_ERR(STORVSC,
-			   "unable to send QUERY_PROPERTIES_OPERATION");
+	if (ret != 0)
 		goto cleanup;
-	}
 
 	t = wait_for_completion_timeout(&request->wait_event, HZ);
 	if (t == 0) {
@@ -223,21 +203,13 @@ static int storvsc_channel_init(struct hv_device *device)
 
 	/* TODO: Check returned version */
 	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0) {
-		DPRINT_ERR(STORVSC, "QUERY_PROPERTIES_OPERATION failed "
-			   "(op %d status 0x%x)",
-			   vstor_packet->operation, vstor_packet->status);
+	    vstor_packet->status != 0)
 		goto cleanup;
-	}
 
 	stor_device->path_id = vstor_packet->storage_channel_properties.path_id;
 	stor_device->target_id
 		= vstor_packet->storage_channel_properties.target_id;
 
-	DPRINT_DBG(STORVSC, "channel flag 0x%x, max xfer len 0x%x",
-		   vstor_packet->storage_channel_properties.flags,
-		   vstor_packet->storage_channel_properties.max_transfer_bytes);
-
 	DPRINT_INFO(STORVSC, "END_INITIALIZATION_OPERATION...");
 
 	memset(vstor_packet, 0, sizeof(struct vstor_packet));
@@ -250,11 +222,8 @@ static int storvsc_channel_init(struct hv_device *device)
 			       VM_PKT_DATA_INBAND,
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 
-	if (ret != 0) {
-		DPRINT_ERR(STORVSC,
-			   "unable to send END_INITIALIZATION_OPERATION");
+	if (ret != 0)
 		goto cleanup;
-	}
 
 	t = wait_for_completion_timeout(&request->wait_event, HZ);
 	if (t == 0) {
@@ -263,12 +232,8 @@ static int storvsc_channel_init(struct hv_device *device)
 	}
 
 	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0) {
-		DPRINT_ERR(STORVSC, "END_INITIALIZATION_OPERATION failed "
-			   "(op %d status 0x%x)",
-			   vstor_packet->operation, vstor_packet->status);
+	    vstor_packet->status != 0)
 		goto cleanup;
-	}
 
 	DPRINT_INFO(STORVSC, "**** storage channel up and running!! ****");
 
@@ -285,15 +250,8 @@ static void storvsc_on_io_completion(struct hv_device *device,
 	struct vstor_packet *stor_pkt;
 
 	stor_device = must_get_stor_device(device);
-	if (!stor_device) {
-		DPRINT_ERR(STORVSC, "unable to get stor device..."
-			   "device being destroyed?");
+	if (!stor_device)
 		return;
-	}
-
-	DPRINT_DBG(STORVSC, "IO_COMPLETE_OPERATION - request %p "
-		   "completed bytes xfer %u", request,
-		   vstor_packet->vm_srb.data_transfer_length);
 
 	stor_pkt = &request->vstor_packet;
 
@@ -305,7 +263,7 @@ static void storvsc_on_io_completion(struct hv_device *device,
 	vstor_packet->vm_srb.sense_info_length;
 
 	if (vstor_packet->vm_srb.scsi_status != 0 ||
-		vstor_packet->vm_srb.srb_status != 1) {
+		vstor_packet->vm_srb.srb_status != 1){
 		DPRINT_WARN(STORVSC,
 			    "cmd 0x%x scsi status 0x%x srb status 0x%x\n",
 			    stor_pkt->vm_srb.cdb[0],
@@ -347,7 +305,6 @@ static void storvsc_on_receive(struct hv_device *device,
 {
 	switch (vstor_packet->operation) {
 	case VSTOR_OPERATION_COMPLETE_IO:
-		DPRINT_DBG(STORVSC, "IO_COMPLETE_OPERATION");
 		storvsc_on_io_completion(device, vstor_packet, request);
 		break;
 	case VSTOR_OPERATION_REMOVE_DEVICE:
@@ -374,20 +331,14 @@ static void storvsc_on_channel_callback(void *context)
 
 
 	stor_device = must_get_stor_device(device);
-	if (!stor_device) {
-		DPRINT_ERR(STORVSC, "unable to get stor device..."
-			   "device being destroyed?");
+	if (!stor_device)
 		return;
-	}
 
 	do {
 		ret = vmbus_recvpacket(device->channel, packet,
 				       ALIGN(sizeof(struct vstor_packet), 8),
 				       &bytes_recvd, &request_id);
 		if (ret == 0 && bytes_recvd > 0) {
-			DPRINT_DBG(STORVSC, "receive %d bytes - tid %llx",
-				   bytes_recvd, request_id);
-
 
 			request = (struct hv_storvsc_request *)
 					(unsigned long)request_id;
@@ -429,13 +380,8 @@ static int storvsc_connect_to_vsp(struct hv_device *device)
 			 sizeof(struct vmstorage_channel_properties),
 			 storvsc_on_channel_callback, device);
 
-	DPRINT_DBG(STORVSC, "storage props: path id %d, tgt id %d, max xfer %d",
-		   props.path_id, props.target_id, props.max_transfer_bytes);
-
-	if (ret != 0) {
-		DPRINT_ERR(STORVSC, "unable to open channel: %d", ret);
+	if (ret != 0)
 		return -1;
-	}
 
 	ret = storvsc_channel_init(device);
 
@@ -472,10 +418,6 @@ int storvsc_dev_add(struct hv_device *device,
 	device_info->path_id = stor_device->path_id;
 	device_info->target_id = stor_device->target_id;
 
-	DPRINT_DBG(STORVSC, "assigned port %u, path %u target %u\n",
-		   stor_device->port_number, stor_device->path_id,
-		   stor_device->target_id);
-
 cleanup:
 	return ret;
 }
@@ -497,13 +439,8 @@ int storvsc_dev_remove(struct hv_device *device)
 
 	storvsc_wait_to_drain(stor_device);
 
-	DPRINT_INFO(STORVSC, "removing storage device (%p)...",
-		    device->ext);
-
 	stor_device = final_release_stor_device(device);
 
-	DPRINT_INFO(STORVSC, "storage device (%p) safe to remove", stor_device);
-
 	/* Close the channel */
 	vmbus_close(device->channel);
 
@@ -521,17 +458,8 @@ int storvsc_do_io(struct hv_device *device,
 	vstor_packet = &request->vstor_packet;
 	stor_device = get_stor_device(device);
 
-	DPRINT_DBG(STORVSC, "enter - Device %p, DeviceExt %p, Request %p, "
-		   , device, stor_device, request);
-
-	DPRINT_DBG(STORVSC, "req %p len %d",
-		   request, request->data_buffer.len);
-
-	if (!stor_device) {
-		DPRINT_ERR(STORVSC, "unable to get stor device..."
-			   "device being destroyed?");
+	if (!stor_device)
 		return -2;
-	}
 
 
 	request->device  = device;
@@ -550,16 +478,6 @@ int storvsc_do_io(struct hv_device *device,
 
 	vstor_packet->operation = VSTOR_OPERATION_EXECUTE_SRB;
 
-	DPRINT_DBG(STORVSC, "srb - len %d port %d, path %d, target %d, "
-		   "lun %d senselen %d cdblen %d",
-		   vstor_packet->vm_srb.length,
-		   vstor_packet->vm_srb.port_number,
-		   vstor_packet->vm_srb.path_id,
-		   vstor_packet->vm_srb.target_id,
-		   vstor_packet->vm_srb.lun,
-		   vstor_packet->vm_srb.sense_info_length,
-		   vstor_packet->vm_srb.cdb_length);
-
 	if (request->data_buffer.len) {
 		ret = vmbus_sendpacket_multipagebuffer(device->channel,
 				&request->data_buffer,
@@ -574,10 +492,8 @@ int storvsc_do_io(struct hv_device *device,
 				       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	}
 
-	if (ret != 0) {
-		DPRINT_DBG(STORVSC, "Unable to send packet %p ret %d",
-			   vstor_packet, ret);
-	}
+	if (ret != 0)
+		return ret;
 
 	atomic_inc(&stor_device->num_outstanding_req);
 
-- 
1.7.4.1

