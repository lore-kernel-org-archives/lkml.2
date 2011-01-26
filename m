Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab1AZRu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:50:58 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:43973
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753469Ab1AZRtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:49:55 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 6/8] staging: hv: Convert camel cased struct fields in vmbus_channel_interface.h to lower cases
Date: Wed, 26 Jan 2011 09:50:04 -0800
Message-Id: <1296064206-11372-6-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1296064206-11372-5-git-send-email-haiyangz@microsoft.com>
References: <1296064206-11372-1-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-2-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-3-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-4-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-5-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/channel.c                 |    4 ++--
 drivers/staging/hv/channel_mgmt.c            |   20 ++++++++++----------
 drivers/staging/hv/vmbus_channel_interface.h |   26 +++++++++++++-------------
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 960e155..711548f 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -128,9 +128,9 @@ void vmbus_get_debug_info(struct vmbus_channel *channel,
 	debuginfo->relid = channel->offermsg.child_relid;
 	debuginfo->state = channel->state;
 	memcpy(&debuginfo->interfacetype,
-	       &channel->offermsg.offer.InterfaceType, sizeof(struct hv_guid));
+	       &channel->offermsg.offer.if_type, sizeof(struct hv_guid));
 	memcpy(&debuginfo->interface_instance,
-	       &channel->offermsg.offer.InterfaceInstance,
+	       &channel->offermsg.offer.if_instance,
 	       sizeof(struct hv_guid));
 
 	monitorpage = (struct hv_monitor_page *)vmbus_connection.MonitorPages;
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index b4a8561..3e229fa 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -364,11 +364,11 @@ static void vmbus_process_offer(struct work_struct *work)
 	spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
 
 	list_for_each_entry(channel, &vmbus_connection.ChannelList, listentry) {
-		if (!memcmp(&channel->offermsg.offer.InterfaceType,
-			    &newchannel->offermsg.offer.InterfaceType,
+		if (!memcmp(&channel->offermsg.offer.if_type,
+			    &newchannel->offermsg.offer.if_type,
 			    sizeof(struct hv_guid)) &&
-		    !memcmp(&channel->offermsg.offer.InterfaceInstance,
-			    &newchannel->offermsg.offer.InterfaceInstance,
+		    !memcmp(&channel->offermsg.offer.if_instance,
+			    &newchannel->offermsg.offer.if_instance,
 			    sizeof(struct hv_guid))) {
 			fnew = false;
 			break;
@@ -394,8 +394,8 @@ static void vmbus_process_offer(struct work_struct *work)
 	 * vmbus_child_dev_add()
 	 */
 	newchannel->device_obj = vmbus_child_device_create(
-		&newchannel->offermsg.offer.InterfaceType,
-		&newchannel->offermsg.offer.InterfaceInstance,
+		&newchannel->offermsg.offer.if_type,
+		&newchannel->offermsg.offer.if_instance,
 		newchannel);
 
 	DPRINT_DBG(VMBUS, "child device object allocated - %p",
@@ -427,7 +427,7 @@ static void vmbus_process_offer(struct work_struct *work)
 
 		/* Open IC channels */
 		for (cnt = 0; cnt < MAX_MSG_TYPES; cnt++) {
-			if (memcmp(&newchannel->offermsg.offer.InterfaceType,
+			if (memcmp(&newchannel->offermsg.offer.if_type,
 				   &hv_cb_utils[cnt].data,
 				   sizeof(struct hv_guid)) == 0 &&
 				vmbus_open(newchannel, 2 * PAGE_SIZE,
@@ -461,7 +461,7 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 
 	offer = (struct vmbus_channel_offer_channel *)hdr;
 	for (i = 0; i < MAX_NUM_DEVICE_CLASSES_SUPPORTED; i++) {
-		if (memcmp(&offer->offer.InterfaceType,
+		if (memcmp(&offer->offer.if_type,
 		    &gSupportedDeviceClasses[i], sizeof(struct hv_guid)) == 0) {
 			fsupported = 1;
 			break;
@@ -474,8 +474,8 @@ static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 		return;
 	}
 
-	guidtype = &offer->offer.InterfaceType;
-	guidinstance = &offer->offer.InterfaceInstance;
+	guidtype = &offer->offer.if_type;
+	guidinstance = &offer->offer.if_instance;
 
 	DPRINT_INFO(VMBUS, "Channel offer notification - "
 		    "child relid %d monitor id %d allocated %d, "
diff --git a/drivers/staging/hv/vmbus_channel_interface.h b/drivers/staging/hv/vmbus_channel_interface.h
index 2674282..fbfad5e 100644
--- a/drivers/staging/hv/vmbus_channel_interface.h
+++ b/drivers/staging/hv/vmbus_channel_interface.h
@@ -48,19 +48,19 @@
  * struct contains the fundamental information about an offer.
  */
 struct vmbus_channel_offer {
-	struct hv_guid InterfaceType;
-	struct hv_guid InterfaceInstance;
-	u64 InterruptLatencyIn100nsUnits;
-	u32 InterfaceRevision;
-	u32 ServerContextAreaSize;	/* in bytes */
-	u16 ChannelFlags;
-	u16 MmioMegabytes;		/* in bytes * 1024 * 1024 */
+	struct hv_guid if_type;
+	struct hv_guid if_instance;
+	u64 int_latency; /* in 100ns units */
+	u32 if_revision;
+	u32 server_ctx_size;	/* in bytes */
+	u16 chn_flags;
+	u16 mmio_megabytes;		/* in bytes * 1024 * 1024 */
 
 	union {
 		/* Non-pipes: The user has MAX_USER_DEFINED_BYTES bytes. */
 		struct {
-			unsigned char UserDefined[MAX_USER_DEFINED_BYTES];
-		} Standard;
+			unsigned char user_def[MAX_USER_DEFINED_BYTES];
+		} std;
 
 		/*
 		 * Pipes:
@@ -70,11 +70,11 @@ struct vmbus_channel_offer {
 		 * use.
 		 */
 		struct {
-			u32  PipeMode;
-			unsigned char UserDefined[MAX_PIPE_USER_DEFINED_BYTES];
-		} Pipe;
+			u32  pipe_mode;
+			unsigned char user_def[MAX_PIPE_USER_DEFINED_BYTES];
+		} pipe;
 	} u;
-	u32 Padding;
+	u32 padding;
 } __attribute__((packed));
 
 /* Server Flags */
-- 
1.6.3.2

