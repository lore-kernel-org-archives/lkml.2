Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab1FQOnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:43:16 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:54724
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1759091Ab1FQOmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:42:45 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Subject: [PATCH 3/5] staging: hv: add newline to log messages in netvsc
Date: Fri, 17 Jun 2011 07:58:06 -0700
Message-Id: <1308322688-9796-3-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308322688-9796-1-git-send-email-haiyangz@microsoft.com>
References: <1308322688-9796-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/netvsc.c     |   60 +++++++++++++++++++-------------------
 drivers/staging/hv/netvsc_drv.c |    2 +-
 2 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index ed9b8af..68ed3b4 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -158,7 +158,7 @@ static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 		 */
 		if (ret != 0) {
 			dev_err(&net_device->dev->device, "unable to send "
-				"revoke receive buffer to netvsp");
+				"revoke receive buffer to netvsp\n");
 			return ret;
 		}
 	}
@@ -173,7 +173,7 @@ static int netvsc_destroy_recv_buf(struct netvsc_device *net_device)
 		 */
 		if (ret != 0) {
 			dev_err(&net_device->dev->device,
-				   "unable to teardown receive buffer's gpadl");
+				   "unable to teardown receive buffer's gpadl\n");
 			return -ret;
 		}
 		net_device->recv_buf_gpadl_handle = 0;
@@ -205,7 +205,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 	net_device = get_outbound_net_device(device);
 	if (!net_device) {
 		dev_err(&device->device, "unable to get net device..."
-			   "device being destroyed?");
+			   "device being destroyed?\n");
 		return -ENODEV;
 	}
 
@@ -214,7 +214,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 				get_order(net_device->recv_buf_size));
 	if (!net_device->recv_buf) {
 		dev_err(&device->device, "unable to allocate receive "
-			"buffer of size %d", net_device->recv_buf_size);
+			"buffer of size %d\n", net_device->recv_buf_size);
 		ret = -ENOMEM;
 		goto cleanup;
 	}
@@ -229,7 +229,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 				    &net_device->recv_buf_gpadl_handle);
 	if (ret != 0) {
 		dev_err(&device->device,
-			"unable to establish receive buffer's gpadl");
+			"unable to establish receive buffer's gpadl\n");
 		goto cleanup;
 	}
 
@@ -253,7 +253,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 			       VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED);
 	if (ret != 0) {
 		dev_err(&device->device,
-			"unable to send receive buffer's gpadl to netvsp");
+			"unable to send receive buffer's gpadl to netvsp\n");
 		goto cleanup;
 	}
 
@@ -265,7 +265,7 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 	if (init_packet->msg.v1_msg.
 	    send_recv_buf_complete.status != NVSP_STAT_SUCCESS) {
 		dev_err(&device->device, "Unable to complete receive buffer "
-			   "initialzation with NetVsp - status %d",
+			   "initialzation with NetVsp - status %d\n",
 			   init_packet->msg.v1_msg.
 			   send_recv_buf_complete.status);
 		ret = -EINVAL;
@@ -321,7 +321,7 @@ static int netvsc_connect_vsp(struct hv_device *device)
 	net_device = get_outbound_net_device(device);
 	if (!net_device) {
 		dev_err(&device->device, "unable to get net device..."
-			   "device being destroyed?");
+			   "device being destroyed?\n");
 		return -ENODEV;
 	}
 
@@ -407,14 +407,14 @@ int netvsc_device_remove(struct hv_device *device)
 	/* Stop outbound traffic ie sends and receives completions */
 	net_device = release_outbound_net_device(device);
 	if (!net_device) {
-		dev_err(&device->device, "No net device present!!");
+		dev_err(&device->device, "No net device present!!\n");
 		return -ENODEV;
 	}
 
 	/* Wait for all send completions */
 	while (atomic_read(&net_device->num_outstanding_sends)) {
 		dev_err(&device->device,
-			"waiting for %d requests to complete...",
+			"waiting for %d requests to complete...\n",
 			atomic_read(&net_device->num_outstanding_sends));
 		udelay(100);
 	}
@@ -425,7 +425,7 @@ int netvsc_device_remove(struct hv_device *device)
 	net_device = release_inbound_net_device(device);
 
 	/* At this point, no one should be accessing netDevice except in here */
-	dev_notice(&device->device, "net device safe to remove");
+	dev_notice(&device->device, "net device safe to remove\n");
 
 	/* Now, we can close the channel safely */
 	vmbus_close(device->channel);
@@ -451,7 +451,7 @@ static void netvsc_send_completion(struct hv_device *device,
 	net_device = get_inbound_net_device(device);
 	if (!net_device) {
 		dev_err(&device->device, "unable to get net device..."
-			   "device being destroyed?");
+			   "device being destroyed?\n");
 		return;
 	}
 
@@ -480,7 +480,7 @@ static void netvsc_send_completion(struct hv_device *device,
 		atomic_dec(&net_device->num_outstanding_sends);
 	} else {
 		dev_err(&device->device, "Unknown send completion packet type- "
-			   "%d received!!", nvsp_packet->hdr.msg_type);
+			   "%d received!!\n", nvsp_packet->hdr.msg_type);
 	}
 
 	put_net_device(device);
@@ -497,7 +497,7 @@ int netvsc_send(struct hv_device *device,
 	net_device = get_outbound_net_device(device);
 	if (!net_device) {
 		dev_err(&device->device, "net device (%p) shutting down..."
-			   "ignoring outbound packets", net_device);
+			   "ignoring outbound packets\n", net_device);
 		return -ENODEV;
 	}
 
@@ -532,7 +532,7 @@ int netvsc_send(struct hv_device *device,
 	}
 
 	if (ret != 0)
-		dev_err(&device->device, "Unable to send packet %p ret %d",
+		dev_err(&device->device, "Unable to send packet %p ret %d\n",
 			   packet, ret);
 
 	atomic_inc(&net_device->num_outstanding_sends);
@@ -566,19 +566,19 @@ retry_send_cmplt:
 		/* no more room...wait a bit and attempt to retry 3 times */
 		retries++;
 		dev_err(&device->device, "unable to send receive completion pkt"
-			" (tid %llx)...retrying %d", transaction_id, retries);
+			" (tid %llx)...retrying %d\n", transaction_id, retries);
 
 		if (retries < 4) {
 			udelay(100);
 			goto retry_send_cmplt;
 		} else {
 			dev_err(&device->device, "unable to send receive "
-				"completion pkt (tid %llx)...give up retrying",
+				"completion pkt (tid %llx)...give up retrying\n",
 				transaction_id);
 		}
 	} else {
 		dev_err(&device->device, "unable to send receive "
-			"completion pkt - %llx", transaction_id);
+			"completion pkt - %llx\n", transaction_id);
 	}
 }
 
@@ -600,7 +600,7 @@ static void netvsc_receive_completion(void *context)
 	net_device = get_inbound_net_device(device);
 	if (!net_device) {
 		dev_err(&device->device, "unable to get net device..."
-			   "device being destroyed?");
+			   "device being destroyed?\n");
 		return;
 	}
 
@@ -652,7 +652,7 @@ static void netvsc_receive(struct hv_device *device,
 	net_device = get_inbound_net_device(device);
 	if (!net_device) {
 		dev_err(&device->device, "unable to get net device..."
-			   "device being destroyed?");
+			   "device being destroyed?\n");
 		return;
 	}
 
@@ -661,7 +661,7 @@ static void netvsc_receive(struct hv_device *device,
 	 * packet
 	 */
 	if (packet->type != VM_PKT_DATA_USING_XFER_PAGES) {
-		dev_err(&device->device, "Unknown packet type received - %d",
+		dev_err(&device->device, "Unknown packet type received - %d\n",
 			   packet->type);
 		put_net_device(device);
 		return;
@@ -674,7 +674,7 @@ static void netvsc_receive(struct hv_device *device,
 	if (nvsp_packet->hdr.msg_type !=
 	    NVSP_MSG1_TYPE_SEND_RNDIS_PKT) {
 		dev_err(&device->device, "Unknown nvsp packet type received-"
-			" %d", nvsp_packet->hdr.msg_type);
+			" %d\n", nvsp_packet->hdr.msg_type);
 		put_net_device(device);
 		return;
 	}
@@ -683,7 +683,7 @@ static void netvsc_receive(struct hv_device *device,
 
 	if (vmxferpage_packet->xfer_pageset_id != NETVSC_RECEIVE_BUFFER_ID) {
 		dev_err(&device->device, "Invalid xfer page set id - "
-			   "expecting %x got %x", NETVSC_RECEIVE_BUFFER_ID,
+			   "expecting %x got %x\n", NETVSC_RECEIVE_BUFFER_ID,
 			   vmxferpage_packet->xfer_pageset_id);
 		put_net_device(device);
 		return;
@@ -710,7 +710,7 @@ static void netvsc_receive(struct hv_device *device,
 	 */
 	if (count < 2) {
 		dev_err(&device->device, "Got only %d netvsc pkt...needed "
-			"%d pkts. Dropping this xfer page packet completely!",
+			"%d pkts. Dropping this xfer page packet completely!\n",
 			count, vmxferpage_packet->range_cnt + 1);
 
 		/* Return it to the freelist */
@@ -738,7 +738,7 @@ static void netvsc_receive(struct hv_device *device,
 
 	if (xferpage_packet->count != vmxferpage_packet->range_cnt) {
 		dev_err(&device->device, "Needed %d netvsc pkts to satisy "
-			"this xfer page...got %d",
+			"this xfer page...got %d\n",
 			vmxferpage_packet->range_cnt, xferpage_packet->count);
 	}
 
@@ -837,7 +837,7 @@ static void netvsc_channel_cb(void *context)
 	net_device = get_inbound_net_device(device);
 	if (!net_device) {
 		dev_err(&device->device, "net device (%p) shutting down..."
-			   "ignoring inbound packets", net_device);
+			   "ignoring inbound packets\n", net_device);
 		goto out;
 	}
 
@@ -888,7 +888,7 @@ static void netvsc_channel_cb(void *context)
 				/* Try again next time around */
 				dev_err(&device->device,
 					   "unable to allocate buffer of size "
-					   "(%d)!!", bytes_recvd);
+					   "(%d)!!\n", bytes_recvd);
 				break;
 			}
 
@@ -945,18 +945,18 @@ int netvsc_device_add(struct hv_device *device, void *additional_info)
 			 netvsc_channel_cb, device);
 
 	if (ret != 0) {
-		dev_err(&device->device, "unable to open channel: %d", ret);
+		dev_err(&device->device, "unable to open channel: %d\n", ret);
 		goto cleanup;
 	}
 
 	/* Channel is opened */
-	pr_info("hv_netvsc channel opened successfully");
+	pr_info("hv_netvsc channel opened successfully\n");
 
 	/* Connect with the NetVsp */
 	ret = netvsc_connect_vsp(device);
 	if (ret != 0) {
 		dev_err(&device->device,
-			"unable to connect to NetVSP - %d", ret);
+			"unable to connect to NetVSP - %d\n", ret);
 		goto close;
 	}
 
diff --git a/drivers/staging/hv/netvsc_drv.c b/drivers/staging/hv/netvsc_drv.c
index e5aba38..c9ed19a 100644
--- a/drivers/staging/hv/netvsc_drv.c
+++ b/drivers/staging/hv/netvsc_drv.c
@@ -433,7 +433,7 @@ static int __init netvsc_drv_init(void)
 	struct hv_driver *drv = &netvsc_drv;
 	int ret;
 
-	pr_info("initializing....");
+	pr_info("initializing....\n");
 
 	drv->driver.name = driver_name;
 
-- 
1.6.3.2

