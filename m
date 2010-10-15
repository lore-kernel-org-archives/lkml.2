Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab0JORUf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 13:20:35 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:34976
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756618Ab0JORUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 13:20:32 -0400
From: Haiyang Zhang <haiyangz@linuxonhyperv.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        virtualization@lists.osdl.org
Subject: [PATCH 4/5] staging: hv: Convert camel cased local variable names in channel_mgmt.c to lower case
Date: Fri, 15 Oct 2010 10:14:06 -0700
Message-Id: <1287162847-27536-4-git-send-email-haiyangz@linuxonhyperv.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1287162847-27536-3-git-send-email-haiyangz@linuxonhyperv.com>
References: <1287162847-27536-1-git-send-email-haiyangz@linuxonhyperv.com>
 <1287162847-27536-2-git-send-email-haiyangz@linuxonhyperv.com>
 <1287162847-27536-3-git-send-email-haiyangz@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

Convert camel cased local variable names in channel_mgmt.c to lower case

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel_mgmt.c |  258 +++++++++++++++++++------------------
 1 files changed, 133 insertions(+), 125 deletions(-)

diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index bdfd5af..7522cfd 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -277,9 +277,9 @@ static inline void ReleaseVmbusChannel(void *context)
 /*
  * FreeVmbusChannel - Release the resources used by the vmbus channel object
  */
-void FreeVmbusChannel(struct vmbus_channel *Channel)
+void FreeVmbusChannel(struct vmbus_channel *channel)
 {
-	del_timer_sync(&Channel->poll_timer);
+	del_timer_sync(&channel->poll_timer);
 
 	/*
 	 * We have to release the channel's workqueue/thread in the vmbus's
@@ -287,7 +287,7 @@ void FreeVmbusChannel(struct vmbus_channel *Channel)
 	 * ie we can't destroy ourselves.
 	 */
 	osd_schedule_callback(gVmbusConnection.WorkQueue, ReleaseVmbusChannel,
-			      Channel);
+			      channel);
 }
 
 
@@ -315,9 +315,9 @@ static void count_hv_channel(void)
  */
 static void VmbusChannelProcessOffer(void *context)
 {
-	struct vmbus_channel *newChannel = context;
+	struct vmbus_channel *newchannel = context;
 	struct vmbus_channel *channel;
-	bool fNew = true;
+	bool fnew = true;
 	int ret;
 	int cnt;
 	unsigned long flags;
@@ -327,26 +327,26 @@ static void VmbusChannelProcessOffer(void *context)
 
 	list_for_each_entry(channel, &gVmbusConnection.ChannelList, ListEntry) {
 		if (!memcmp(&channel->OfferMsg.Offer.InterfaceType,
-			    &newChannel->OfferMsg.Offer.InterfaceType,
+			    &newchannel->OfferMsg.Offer.InterfaceType,
 			    sizeof(struct hv_guid)) &&
 		    !memcmp(&channel->OfferMsg.Offer.InterfaceInstance,
-			    &newChannel->OfferMsg.Offer.InterfaceInstance,
+			    &newchannel->OfferMsg.Offer.InterfaceInstance,
 			    sizeof(struct hv_guid))) {
-			fNew = false;
+			fnew = false;
 			break;
 		}
 	}
 
-	if (fNew)
-		list_add_tail(&newChannel->ListEntry,
+	if (fnew)
+		list_add_tail(&newchannel->ListEntry,
 			      &gVmbusConnection.ChannelList);
 
 	spin_unlock_irqrestore(&gVmbusConnection.channel_lock, flags);
 
-	if (!fNew) {
+	if (!fnew) {
 		DPRINT_DBG(VMBUS, "Ignoring duplicate offer for relid (%d)",
-			   newChannel->OfferMsg.ChildRelId);
-		FreeVmbusChannel(newChannel);
+			   newchannel->OfferMsg.ChildRelId);
+		FreeVmbusChannel(newchannel);
 		return;
 	}
 
@@ -355,48 +355,48 @@ static void VmbusChannelProcessOffer(void *context)
 	 * We need to set the DeviceObject field before calling
 	 * VmbusChildDeviceAdd()
 	 */
-	newChannel->DeviceObject = VmbusChildDeviceCreate(
-		&newChannel->OfferMsg.Offer.InterfaceType,
-		&newChannel->OfferMsg.Offer.InterfaceInstance,
-		newChannel);
+	newchannel->DeviceObject = VmbusChildDeviceCreate(
+		&newchannel->OfferMsg.Offer.InterfaceType,
+		&newchannel->OfferMsg.Offer.InterfaceInstance,
+		newchannel);
 
 	DPRINT_DBG(VMBUS, "child device object allocated - %p",
-		   newChannel->DeviceObject);
+		   newchannel->DeviceObject);
 
 	/*
 	 * Add the new device to the bus. This will kick off device-driver
 	 * binding which eventually invokes the device driver's AddDevice()
 	 * method.
 	 */
-	ret = VmbusChildDeviceAdd(newChannel->DeviceObject);
+	ret = VmbusChildDeviceAdd(newchannel->DeviceObject);
 	if (ret != 0) {
 		DPRINT_ERR(VMBUS,
 			   "unable to add child device object (relid %d)",
-			   newChannel->OfferMsg.ChildRelId);
+			   newchannel->OfferMsg.ChildRelId);
 
 		spin_lock_irqsave(&gVmbusConnection.channel_lock, flags);
-		list_del(&newChannel->ListEntry);
+		list_del(&newchannel->ListEntry);
 		spin_unlock_irqrestore(&gVmbusConnection.channel_lock, flags);
 
-		FreeVmbusChannel(newChannel);
+		FreeVmbusChannel(newchannel);
 	} else {
 		/*
 		 * This state is used to indicate a successful open
 		 * so that when we do close the channel normally, we
 		 * can cleanup properly
 		 */
-		newChannel->State = CHANNEL_OPEN_STATE;
+		newchannel->State = CHANNEL_OPEN_STATE;
 
 		/* Open IC channels */
 		for (cnt = 0; cnt < MAX_MSG_TYPES; cnt++) {
-			if (memcmp(&newChannel->OfferMsg.Offer.InterfaceType,
+			if (memcmp(&newchannel->OfferMsg.Offer.InterfaceType,
 				   &hv_cb_utils[cnt].data,
 				   sizeof(struct hv_guid)) == 0 &&
-				vmbus_open(newChannel, 2 * PAGE_SIZE,
+				vmbus_open(newchannel, 2 * PAGE_SIZE,
 						 2 * PAGE_SIZE, NULL, 0,
 						 hv_cb_utils[cnt].callback,
-						 newChannel) == 0) {
-				hv_cb_utils[cnt].channel = newChannel;
+						 newchannel) == 0) {
+				hv_cb_utils[cnt].channel = newchannel;
 				DPRINT_INFO(VMBUS, "%s",
 						hv_cb_utils[cnt].log_msg);
 				count_hv_channel();
@@ -425,29 +425,29 @@ static void VmbusChannelProcessRescindOffer(void *context)
 static void VmbusChannelOnOffer(struct vmbus_channel_message_header *hdr)
 {
 	struct vmbus_channel_offer_channel *offer;
-	struct vmbus_channel *newChannel;
-	struct hv_guid *guidType;
-	struct hv_guid *guidInstance;
+	struct vmbus_channel *newchannel;
+	struct hv_guid *guidtype;
+	struct hv_guid *guidinstance;
 	int i;
-	int fSupported = 0;
+	int fsupported = 0;
 
 	offer = (struct vmbus_channel_offer_channel *)hdr;
 	for (i = 0; i < MAX_NUM_DEVICE_CLASSES_SUPPORTED; i++) {
 		if (memcmp(&offer->Offer.InterfaceType,
 		    &gSupportedDeviceClasses[i], sizeof(struct hv_guid)) == 0) {
-			fSupported = 1;
+			fsupported = 1;
 			break;
 		}
 	}
 
-	if (!fSupported) {
+	if (!fsupported) {
 		DPRINT_DBG(VMBUS, "Ignoring channel offer notification for "
 			   "child relid %d", offer->ChildRelId);
 		return;
 	}
 
-	guidType = &offer->Offer.InterfaceType;
-	guidInstance = &offer->Offer.InterfaceInstance;
+	guidtype = &offer->Offer.InterfaceType;
+	guidinstance = &offer->Offer.InterfaceInstance;
 
 	DPRINT_INFO(VMBUS, "Channel offer notification - "
 		    "child relid %d monitor id %d allocated %d, "
@@ -457,40 +457,40 @@ static void VmbusChannelOnOffer(struct vmbus_channel_message_header *hdr)
 		    "%02x%02x%02x%02x%02x%02x%02x%02x}",
 		    offer->ChildRelId, offer->MonitorId,
 		    offer->MonitorAllocated,
-		    guidType->data[3], guidType->data[2],
-		    guidType->data[1], guidType->data[0],
-		    guidType->data[5], guidType->data[4],
-		    guidType->data[7], guidType->data[6],
-		    guidType->data[8], guidType->data[9],
-		    guidType->data[10], guidType->data[11],
-		    guidType->data[12], guidType->data[13],
-		    guidType->data[14], guidType->data[15],
-		    guidInstance->data[3], guidInstance->data[2],
-		    guidInstance->data[1], guidInstance->data[0],
-		    guidInstance->data[5], guidInstance->data[4],
-		    guidInstance->data[7], guidInstance->data[6],
-		    guidInstance->data[8], guidInstance->data[9],
-		    guidInstance->data[10], guidInstance->data[11],
-		    guidInstance->data[12], guidInstance->data[13],
-		    guidInstance->data[14], guidInstance->data[15]);
+		    guidtype->data[3], guidtype->data[2],
+		    guidtype->data[1], guidtype->data[0],
+		    guidtype->data[5], guidtype->data[4],
+		    guidtype->data[7], guidtype->data[6],
+		    guidtype->data[8], guidtype->data[9],
+		    guidtype->data[10], guidtype->data[11],
+		    guidtype->data[12], guidtype->data[13],
+		    guidtype->data[14], guidtype->data[15],
+		    guidinstance->data[3], guidinstance->data[2],
+		    guidinstance->data[1], guidinstance->data[0],
+		    guidinstance->data[5], guidinstance->data[4],
+		    guidinstance->data[7], guidinstance->data[6],
+		    guidinstance->data[8], guidinstance->data[9],
+		    guidinstance->data[10], guidinstance->data[11],
+		    guidinstance->data[12], guidinstance->data[13],
+		    guidinstance->data[14], guidinstance->data[15]);
 
 	/* Allocate the channel object and save this offer. */
-	newChannel = AllocVmbusChannel();
-	if (!newChannel) {
+	newchannel = AllocVmbusChannel();
+	if (!newchannel) {
 		DPRINT_ERR(VMBUS, "unable to allocate channel object");
 		return;
 	}
 
-	DPRINT_DBG(VMBUS, "channel object allocated - %p", newChannel);
+	DPRINT_DBG(VMBUS, "channel object allocated - %p", newchannel);
 
-	memcpy(&newChannel->OfferMsg, offer,
+	memcpy(&newchannel->OfferMsg, offer,
 	       sizeof(struct vmbus_channel_offer_channel));
-	newChannel->MonitorGroup = (u8)offer->MonitorId / 32;
-	newChannel->MonitorBit = (u8)offer->MonitorId % 32;
+	newchannel->MonitorGroup = (u8)offer->MonitorId / 32;
+	newchannel->MonitorBit = (u8)offer->MonitorId % 32;
 
 	/* TODO: Make sure the offer comes from our parent partition */
-	osd_schedule_callback(newChannel->ControlWQ, VmbusChannelProcessOffer,
-			      newChannel);
+	osd_schedule_callback(newchannel->ControlWQ, VmbusChannelProcessOffer,
+			      newchannel);
 }
 
 /*
@@ -537,9 +537,9 @@ static void VmbusChannelOnOpenResult(struct vmbus_channel_message_header *hdr)
 {
 	struct vmbus_channel_open_result *result;
 	struct list_head *curr;
-	struct vmbus_channel_msginfo *msgInfo;
-	struct vmbus_channel_message_header *requestHeader;
-	struct vmbus_channel_open_channel *openMsg;
+	struct vmbus_channel_msginfo *msginfo;
+	struct vmbus_channel_message_header *requestheader;
+	struct vmbus_channel_open_channel *openmsg;
 	unsigned long flags;
 
 	result = (struct vmbus_channel_open_result *)hdr;
@@ -552,17 +552,19 @@ static void VmbusChannelOnOpenResult(struct vmbus_channel_message_header *hdr)
 
 	list_for_each(curr, &gVmbusConnection.ChannelMsgList) {
 /* FIXME: this should probably use list_entry() instead */
-		msgInfo = (struct vmbus_channel_msginfo *)curr;
-		requestHeader = (struct vmbus_channel_message_header *)msgInfo->Msg;
-
-		if (requestHeader->MessageType == ChannelMessageOpenChannel) {
-			openMsg = (struct vmbus_channel_open_channel *)msgInfo->Msg;
-			if (openMsg->ChildRelId == result->ChildRelId &&
-			    openMsg->OpenId == result->OpenId) {
-				memcpy(&msgInfo->Response.OpenResult,
+		msginfo = (struct vmbus_channel_msginfo *)curr;
+		requestheader =
+			(struct vmbus_channel_message_header *)msginfo->Msg;
+
+		if (requestheader->MessageType == ChannelMessageOpenChannel) {
+			openmsg =
+			(struct vmbus_channel_open_channel *)msginfo->Msg;
+			if (openmsg->ChildRelId == result->ChildRelId &&
+			    openmsg->OpenId == result->OpenId) {
+				memcpy(&msginfo->Response.OpenResult,
 				       result,
 				       sizeof(struct vmbus_channel_open_result));
-				osd_WaitEventSet(msgInfo->WaitEvent);
+				osd_WaitEventSet(msginfo->WaitEvent);
 				break;
 			}
 		}
@@ -579,16 +581,16 @@ static void VmbusChannelOnOpenResult(struct vmbus_channel_message_header *hdr)
  */
 static void VmbusChannelOnGpadlCreated(struct vmbus_channel_message_header *hdr)
 {
-	struct vmbus_channel_gpadl_created *gpadlCreated;
+	struct vmbus_channel_gpadl_created *gpadlcreated;
 	struct list_head *curr;
-	struct vmbus_channel_msginfo *msgInfo;
-	struct vmbus_channel_message_header *requestHeader;
-	struct vmbus_channel_gpadl_header *gpadlHeader;
+	struct vmbus_channel_msginfo *msginfo;
+	struct vmbus_channel_message_header *requestheader;
+	struct vmbus_channel_gpadl_header *gpadlheader;
 	unsigned long flags;
 
-	gpadlCreated = (struct vmbus_channel_gpadl_created *)hdr;
+	gpadlcreated = (struct vmbus_channel_gpadl_created *)hdr;
 	DPRINT_DBG(VMBUS, "vmbus gpadl created result - %d",
-		   gpadlCreated->CreationStatus);
+		   gpadlcreated->CreationStatus);
 
 	/*
 	 * Find the establish msg, copy the result and signal/unblock the wait
@@ -598,19 +600,21 @@ static void VmbusChannelOnGpadlCreated(struct vmbus_channel_message_header *hdr)
 
 	list_for_each(curr, &gVmbusConnection.ChannelMsgList) {
 /* FIXME: this should probably use list_entry() instead */
-		msgInfo = (struct vmbus_channel_msginfo *)curr;
-		requestHeader = (struct vmbus_channel_message_header *)msgInfo->Msg;
-
-		if (requestHeader->MessageType == ChannelMessageGpadlHeader) {
-			gpadlHeader = (struct vmbus_channel_gpadl_header *)requestHeader;
-
-			if ((gpadlCreated->ChildRelId ==
-			     gpadlHeader->ChildRelId) &&
-			    (gpadlCreated->Gpadl == gpadlHeader->Gpadl)) {
-				memcpy(&msgInfo->Response.GpadlCreated,
-				       gpadlCreated,
+		msginfo = (struct vmbus_channel_msginfo *)curr;
+		requestheader =
+			(struct vmbus_channel_message_header *)msginfo->Msg;
+
+		if (requestheader->MessageType == ChannelMessageGpadlHeader) {
+			gpadlheader =
+			(struct vmbus_channel_gpadl_header *)requestheader;
+
+			if ((gpadlcreated->ChildRelId ==
+			     gpadlheader->ChildRelId) &&
+			    (gpadlcreated->Gpadl == gpadlheader->Gpadl)) {
+				memcpy(&msginfo->Response.GpadlCreated,
+				       gpadlcreated,
 				       sizeof(struct vmbus_channel_gpadl_created));
-				osd_WaitEventSet(msgInfo->WaitEvent);
+				osd_WaitEventSet(msginfo->WaitEvent);
 				break;
 			}
 		}
@@ -628,14 +632,14 @@ static void VmbusChannelOnGpadlCreated(struct vmbus_channel_message_header *hdr)
 static void VmbusChannelOnGpadlTorndown(
 			struct vmbus_channel_message_header *hdr)
 {
-	struct vmbus_channel_gpadl_torndown *gpadlTorndown;
+	struct vmbus_channel_gpadl_torndown *gpadl_torndown;
 	struct list_head *curr;
-	struct vmbus_channel_msginfo *msgInfo;
-	struct vmbus_channel_message_header *requestHeader;
-	struct vmbus_channel_gpadl_teardown *gpadlTeardown;
+	struct vmbus_channel_msginfo *msginfo;
+	struct vmbus_channel_message_header *requestheader;
+	struct vmbus_channel_gpadl_teardown *gpadl_teardown;
 	unsigned long flags;
 
-	gpadlTorndown = (struct vmbus_channel_gpadl_torndown *)hdr;
+	gpadl_torndown = (struct vmbus_channel_gpadl_torndown *)hdr;
 
 	/*
 	 * Find the open msg, copy the result and signal/unblock the wait event
@@ -644,17 +648,19 @@ static void VmbusChannelOnGpadlTorndown(
 
 	list_for_each(curr, &gVmbusConnection.ChannelMsgList) {
 /* FIXME: this should probably use list_entry() instead */
-		msgInfo = (struct vmbus_channel_msginfo *)curr;
-		requestHeader = (struct vmbus_channel_message_header *)msgInfo->Msg;
+		msginfo = (struct vmbus_channel_msginfo *)curr;
+		requestheader =
+			(struct vmbus_channel_message_header *)msginfo->Msg;
 
-		if (requestHeader->MessageType == ChannelMessageGpadlTeardown) {
-			gpadlTeardown = (struct vmbus_channel_gpadl_teardown *)requestHeader;
+		if (requestheader->MessageType == ChannelMessageGpadlTeardown) {
+			gpadl_teardown =
+			(struct vmbus_channel_gpadl_teardown *)requestheader;
 
-			if (gpadlTorndown->Gpadl == gpadlTeardown->Gpadl) {
-				memcpy(&msgInfo->Response.GpadlTorndown,
-				       gpadlTorndown,
+			if (gpadl_torndown->Gpadl == gpadl_teardown->Gpadl) {
+				memcpy(&msginfo->Response.GpadlTorndown,
+				       gpadl_torndown,
 				       sizeof(struct vmbus_channel_gpadl_torndown));
-				osd_WaitEventSet(msgInfo->WaitEvent);
+				osd_WaitEventSet(msginfo->WaitEvent);
 				break;
 			}
 		}
@@ -673,27 +679,29 @@ static void VmbusChannelOnVersionResponse(
 		struct vmbus_channel_message_header *hdr)
 {
 	struct list_head *curr;
-	struct vmbus_channel_msginfo *msgInfo;
-	struct vmbus_channel_message_header *requestHeader;
+	struct vmbus_channel_msginfo *msginfo;
+	struct vmbus_channel_message_header *requestheader;
 	struct vmbus_channel_initiate_contact *initiate;
-	struct vmbus_channel_version_response *versionResponse;
+	struct vmbus_channel_version_response *version_response;
 	unsigned long flags;
 
-	versionResponse = (struct vmbus_channel_version_response *)hdr;
+	version_response = (struct vmbus_channel_version_response *)hdr;
 	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
 
 	list_for_each(curr, &gVmbusConnection.ChannelMsgList) {
 /* FIXME: this should probably use list_entry() instead */
-		msgInfo = (struct vmbus_channel_msginfo *)curr;
-		requestHeader = (struct vmbus_channel_message_header *)msgInfo->Msg;
+		msginfo = (struct vmbus_channel_msginfo *)curr;
+		requestheader =
+			(struct vmbus_channel_message_header *)msginfo->Msg;
 
-		if (requestHeader->MessageType ==
+		if (requestheader->MessageType ==
 		    ChannelMessageInitiateContact) {
-			initiate = (struct vmbus_channel_initiate_contact *)requestHeader;
-			memcpy(&msgInfo->Response.VersionResponse,
-			      versionResponse,
+			initiate =
+			(struct vmbus_channel_initiate_contact *)requestheader;
+			memcpy(&msginfo->Response.VersionResponse,
+			      version_response,
 			      sizeof(struct vmbus_channel_version_response));
-			osd_WaitEventSet(msgInfo->WaitEvent);
+			osd_WaitEventSet(msginfo->WaitEvent);
 		}
 	}
 	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
@@ -726,9 +734,9 @@ static struct vmbus_channel_message_table_entry
  *
  * This is invoked in the vmbus worker thread context.
  */
-void VmbusOnChannelMessage(void *Context)
+void VmbusOnChannelMessage(void *context)
 {
-	struct hv_message *msg = Context;
+	struct hv_message *msg = context;
 	struct vmbus_channel_message_header *hdr;
 	int size;
 
@@ -763,22 +771,22 @@ void VmbusOnChannelMessage(void *Context)
 int VmbusChannelRequestOffers(void)
 {
 	struct vmbus_channel_message_header *msg;
-	struct vmbus_channel_msginfo *msgInfo;
+	struct vmbus_channel_msginfo *msginfo;
 	int ret;
 
-	msgInfo = kmalloc(sizeof(*msgInfo) +
+	msginfo = kmalloc(sizeof(*msginfo) +
 			  sizeof(struct vmbus_channel_message_header),
 			  GFP_KERNEL);
-	if (!msgInfo)
+	if (!msginfo)
 		return -ENOMEM;
 
-	msgInfo->WaitEvent = osd_WaitEventCreate();
-	if (!msgInfo->WaitEvent) {
-		kfree(msgInfo);
+	msginfo->WaitEvent = osd_WaitEventCreate();
+	if (!msginfo->WaitEvent) {
+		kfree(msginfo);
 		return -ENOMEM;
 	}
 
-	msg = (struct vmbus_channel_message_header *)msgInfo->Msg;
+	msg = (struct vmbus_channel_message_header *)msginfo->Msg;
 
 	msg->MessageType = ChannelMessageRequestOffers;
 
@@ -806,9 +814,9 @@ int VmbusChannelRequestOffers(void)
 
 
 Cleanup:
-	if (msgInfo) {
-		kfree(msgInfo->WaitEvent);
-		kfree(msgInfo);
+	if (msginfo) {
+		kfree(msginfo->WaitEvent);
+		kfree(msginfo);
 	}
 
 	return ret;
-- 
1.6.3.2

