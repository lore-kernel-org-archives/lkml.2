Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab0JORUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 13:20:37 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:34975
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756617Ab0JORUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 13:20:32 -0400
From: Haiyang Zhang <haiyangz@linuxonhyperv.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        virtualization@lists.osdl.org
Subject: [PATCH 5/5] staging: hv: Convert camel cased functions in channel_mgmt.c to lower case
Date: Fri, 15 Oct 2010 10:14:07 -0700
Message-Id: <1287162847-27536-5-git-send-email-haiyangz@linuxonhyperv.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1287162847-27536-4-git-send-email-haiyangz@linuxonhyperv.com>
References: <1287162847-27536-1-git-send-email-haiyangz@linuxonhyperv.com>
 <1287162847-27536-2-git-send-email-haiyangz@linuxonhyperv.com>
 <1287162847-27536-3-git-send-email-haiyangz@linuxonhyperv.com>
 <1287162847-27536-4-git-send-email-haiyangz@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

Convert camel cased functions in channel_mgmt.c to lower case

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel.c      |    2 +-
 drivers/staging/hv/channel_mgmt.c |   90 +++++++++++++++++++------------------
 drivers/staging/hv/channel_mgmt.h |   10 ++--
 drivers/staging/hv/vmbus.c        |    6 +-
 4 files changed, 55 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 39b8fd3..45dda9b 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -698,7 +698,7 @@ void vmbus_close(struct vmbus_channel *channel)
 		list_del(&channel->ListEntry);
 		spin_unlock_irqrestore(&gVmbusConnection.channel_lock, flags);
 
-		FreeVmbusChannel(channel);
+		free_channel(channel);
 	}
 }
 
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 7522cfd..0d5dbf3 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -235,9 +235,9 @@ struct hyperv_service_callback hv_cb_utils[MAX_MSG_TYPES] = {
 EXPORT_SYMBOL(hv_cb_utils);
 
 /*
- * AllocVmbusChannel - Allocate and initialize a vmbus channel object
+ * alloc_channel - Allocate and initialize a vmbus channel object
  */
-struct vmbus_channel *AllocVmbusChannel(void)
+struct vmbus_channel *alloc_channel(void)
 {
 	struct vmbus_channel *channel;
 
@@ -261,9 +261,9 @@ struct vmbus_channel *AllocVmbusChannel(void)
 }
 
 /*
- * ReleaseVmbusChannel - Release the vmbus channel object itself
+ * release_hannel - Release the vmbus channel object itself
  */
-static inline void ReleaseVmbusChannel(void *context)
+static inline void release_channel(void *context)
 {
 	struct vmbus_channel *channel = context;
 
@@ -275,9 +275,9 @@ static inline void ReleaseVmbusChannel(void *context)
 }
 
 /*
- * FreeVmbusChannel - Release the resources used by the vmbus channel object
+ * free_channel - Release the resources used by the vmbus channel object
  */
-void FreeVmbusChannel(struct vmbus_channel *channel)
+void free_channel(struct vmbus_channel *channel)
 {
 	del_timer_sync(&channel->poll_timer);
 
@@ -286,7 +286,7 @@ void FreeVmbusChannel(struct vmbus_channel *channel)
 	 * workqueue/thread context
 	 * ie we can't destroy ourselves.
 	 */
-	osd_schedule_callback(gVmbusConnection.WorkQueue, ReleaseVmbusChannel,
+	osd_schedule_callback(gVmbusConnection.WorkQueue, release_channel,
 			      channel);
 }
 
@@ -310,10 +310,10 @@ static void count_hv_channel(void)
 
 
 /*
- * VmbusChannelProcessOffer - Process the offer by creating a channel/device
+ * vmbus_process_offer - Process the offer by creating a channel/device
  * associated with this offer
  */
-static void VmbusChannelProcessOffer(void *context)
+static void vmbus_process_offer(void *context)
 {
 	struct vmbus_channel *newchannel = context;
 	struct vmbus_channel *channel;
@@ -346,7 +346,7 @@ static void VmbusChannelProcessOffer(void *context)
 	if (!fnew) {
 		DPRINT_DBG(VMBUS, "Ignoring duplicate offer for relid (%d)",
 			   newchannel->OfferMsg.ChildRelId);
-		FreeVmbusChannel(newchannel);
+		free_channel(newchannel);
 		return;
 	}
 
@@ -378,7 +378,7 @@ static void VmbusChannelProcessOffer(void *context)
 		list_del(&newchannel->ListEntry);
 		spin_unlock_irqrestore(&gVmbusConnection.channel_lock, flags);
 
-		FreeVmbusChannel(newchannel);
+		free_channel(newchannel);
 	} else {
 		/*
 		 * This state is used to indicate a successful open
@@ -406,9 +406,10 @@ static void VmbusChannelProcessOffer(void *context)
 }
 
 /*
- * VmbusChannelProcessRescindOffer - Rescind the offer by initiating a device removal
+ * vmbus_process_rescind_offer -
+ * Rescind the offer by initiating a device removal
  */
-static void VmbusChannelProcessRescindOffer(void *context)
+static void vmbus_process_rescind_offer(void *context)
 {
 	struct vmbus_channel *channel = context;
 
@@ -416,13 +417,13 @@ static void VmbusChannelProcessRescindOffer(void *context)
 }
 
 /*
- * VmbusChannelOnOffer - Handler for channel offers from vmbus in parent partition.
+ * vmbus_onoffer - Handler for channel offers from vmbus in parent partition.
  *
  * We ignore all offers except network and storage offers. For each network and
  * storage offers, we create a channel object and queue a work item to the
  * channel object to process the offer synchronously
  */
-static void VmbusChannelOnOffer(struct vmbus_channel_message_header *hdr)
+static void vmbus_onoffer(struct vmbus_channel_message_header *hdr)
 {
 	struct vmbus_channel_offer_channel *offer;
 	struct vmbus_channel *newchannel;
@@ -475,7 +476,7 @@ static void VmbusChannelOnOffer(struct vmbus_channel_message_header *hdr)
 		    guidinstance->data[14], guidinstance->data[15]);
 
 	/* Allocate the channel object and save this offer. */
-	newchannel = AllocVmbusChannel();
+	newchannel = alloc_channel();
 	if (!newchannel) {
 		DPRINT_ERR(VMBUS, "unable to allocate channel object");
 		return;
@@ -489,16 +490,16 @@ static void VmbusChannelOnOffer(struct vmbus_channel_message_header *hdr)
 	newchannel->MonitorBit = (u8)offer->MonitorId % 32;
 
 	/* TODO: Make sure the offer comes from our parent partition */
-	osd_schedule_callback(newchannel->ControlWQ, VmbusChannelProcessOffer,
+	osd_schedule_callback(newchannel->ControlWQ, vmbus_process_offer,
 			      newchannel);
 }
 
 /*
- * VmbusChannelOnOfferRescind - Rescind offer handler.
+ * vmbus_onoffer_rescind - Rescind offer handler.
  *
  * We queue a work item to process this offer synchronously
  */
-static void VmbusChannelOnOfferRescind(struct vmbus_channel_message_header *hdr)
+static void vmbus_onoffer_rescind(struct vmbus_channel_message_header *hdr)
 {
 	struct vmbus_channel_rescind_offer *rescind;
 	struct vmbus_channel *channel;
@@ -512,28 +513,29 @@ static void VmbusChannelOnOfferRescind(struct vmbus_channel_message_header *hdr)
 	}
 
 	osd_schedule_callback(channel->ControlWQ,
-			      VmbusChannelProcessRescindOffer,
+			      vmbus_process_rescind_offer,
 			      channel);
 }
 
 /*
- * VmbusChannelOnOffersDelivered - This is invoked when all offers have been delivered.
+ * vmbus_onoffers_delivered -
+ * This is invoked when all offers have been delivered.
  *
  * Nothing to do here.
  */
-static void VmbusChannelOnOffersDelivered(
+static void vmbus_onoffers_delivered(
 			struct vmbus_channel_message_header *hdr)
 {
 }
 
 /*
- * VmbusChannelOnOpenResult - Open result handler.
+ * vmbus_onopen_result - Open result handler.
  *
  * This is invoked when we received a response to our channel open request.
  * Find the matching request, copy the response and signal the requesting
  * thread.
  */
-static void VmbusChannelOnOpenResult(struct vmbus_channel_message_header *hdr)
+static void vmbus_onopen_result(struct vmbus_channel_message_header *hdr)
 {
 	struct vmbus_channel_open_result *result;
 	struct list_head *curr;
@@ -573,13 +575,13 @@ static void VmbusChannelOnOpenResult(struct vmbus_channel_message_header *hdr)
 }
 
 /*
- * VmbusChannelOnGpadlCreated - GPADL created handler.
+ * vmbus_ongpadl_created - GPADL created handler.
  *
  * This is invoked when we received a response to our gpadl create request.
  * Find the matching request, copy the response and signal the requesting
  * thread.
  */
-static void VmbusChannelOnGpadlCreated(struct vmbus_channel_message_header *hdr)
+static void vmbus_ongpadl_created(struct vmbus_channel_message_header *hdr)
 {
 	struct vmbus_channel_gpadl_created *gpadlcreated;
 	struct list_head *curr;
@@ -623,13 +625,13 @@ static void VmbusChannelOnGpadlCreated(struct vmbus_channel_message_header *hdr)
 }
 
 /*
- * VmbusChannelOnGpadlTorndown - GPADL torndown handler.
+ * vmbus_ongpadl_torndown - GPADL torndown handler.
  *
  * This is invoked when we received a response to our gpadl teardown request.
  * Find the matching request, copy the response and signal the requesting
  * thread.
  */
-static void VmbusChannelOnGpadlTorndown(
+static void vmbus_ongpadl_torndown(
 			struct vmbus_channel_message_header *hdr)
 {
 	struct vmbus_channel_gpadl_torndown *gpadl_torndown;
@@ -669,13 +671,13 @@ static void VmbusChannelOnGpadlTorndown(
 }
 
 /*
- * VmbusChannelOnVersionResponse - Version response handler
+ * vmbus_onversion_response - Version response handler
  *
  * This is invoked when we received a response to our initiate contact request.
  * Find the matching request, copy the response and signal the requesting
  * thread.
  */
-static void VmbusChannelOnVersionResponse(
+static void vmbus_onversion_response(
 		struct vmbus_channel_message_header *hdr)
 {
 	struct list_head *curr;
@@ -711,30 +713,30 @@ static void VmbusChannelOnVersionResponse(
 static struct vmbus_channel_message_table_entry
 	gChannelMessageTable[ChannelMessageCount] = {
 	{ChannelMessageInvalid,			NULL},
-	{ChannelMessageOfferChannel,		VmbusChannelOnOffer},
-	{ChannelMessageRescindChannelOffer,	VmbusChannelOnOfferRescind},
+	{ChannelMessageOfferChannel,		vmbus_onoffer},
+	{ChannelMessageRescindChannelOffer,	vmbus_onoffer_rescind},
 	{ChannelMessageRequestOffers,		NULL},
-	{ChannelMessageAllOffersDelivered,	VmbusChannelOnOffersDelivered},
+	{ChannelMessageAllOffersDelivered,	vmbus_onoffers_delivered},
 	{ChannelMessageOpenChannel,		NULL},
-	{ChannelMessageOpenChannelResult,	VmbusChannelOnOpenResult},
+	{ChannelMessageOpenChannelResult,	vmbus_onopen_result},
 	{ChannelMessageCloseChannel,		NULL},
 	{ChannelMessageGpadlHeader,		NULL},
 	{ChannelMessageGpadlBody,		NULL},
-	{ChannelMessageGpadlCreated,		VmbusChannelOnGpadlCreated},
+	{ChannelMessageGpadlCreated,		vmbus_ongpadl_created},
 	{ChannelMessageGpadlTeardown,		NULL},
-	{ChannelMessageGpadlTorndown,		VmbusChannelOnGpadlTorndown},
+	{ChannelMessageGpadlTorndown,		vmbus_ongpadl_torndown},
 	{ChannelMessageRelIdReleased,		NULL},
 	{ChannelMessageInitiateContact,		NULL},
-	{ChannelMessageVersionResponse,		VmbusChannelOnVersionResponse},
+	{ChannelMessageVersionResponse,		vmbus_onversion_response},
 	{ChannelMessageUnload,			NULL},
 };
 
 /*
- * VmbusOnChannelMessage - Handler for channel protocol messages.
+ * vmbus_onmessage - Handler for channel protocol messages.
  *
  * This is invoked in the vmbus worker thread context.
  */
-void VmbusOnChannelMessage(void *context)
+void vmbus_onmessage(void *context)
 {
 	struct hv_message *msg = context;
 	struct vmbus_channel_message_header *hdr;
@@ -766,9 +768,9 @@ void VmbusOnChannelMessage(void *context)
 }
 
 /*
- * VmbusChannelRequestOffers - Send a request to get all our pending offers.
+ * vmbus_request_offers - Send a request to get all our pending offers.
  */
-int VmbusChannelRequestOffers(void)
+int vmbus_request_offers(void)
 {
 	struct vmbus_channel_message_header *msg;
 	struct vmbus_channel_msginfo *msginfo;
@@ -823,10 +825,10 @@ Cleanup:
 }
 
 /*
- * VmbusChannelReleaseUnattachedChannels - Release channels that are
+ * vmbus_release_unattached_channels - Release channels that are
  * unattached/unconnected ie (no drivers associated)
  */
-void VmbusChannelReleaseUnattachedChannels(void)
+void vmbus_release_unattached_channels(void)
 {
 	struct vmbus_channel *channel, *pos;
 	struct vmbus_channel *start = NULL;
@@ -846,7 +848,7 @@ void VmbusChannelReleaseUnattachedChannels(void)
 				    channel->DeviceObject);
 
 			VmbusChildDeviceRemove(channel->DeviceObject);
-			FreeVmbusChannel(channel);
+			free_channel(channel);
 		} else {
 			if (!start)
 				start = channel;
diff --git a/drivers/staging/hv/channel_mgmt.h b/drivers/staging/hv/channel_mgmt.h
index f969267..b0ed31f 100644
--- a/drivers/staging/hv/channel_mgmt.h
+++ b/drivers/staging/hv/channel_mgmt.h
@@ -307,14 +307,14 @@ struct vmbus_channel_msginfo {
 };
 
 
-struct vmbus_channel *AllocVmbusChannel(void);
+struct vmbus_channel *alloc_channel(void);
 
-void FreeVmbusChannel(struct vmbus_channel *Channel);
+void free_channel(struct vmbus_channel *channel);
 
-void VmbusOnChannelMessage(void *Context);
+void vmbus_onmessage(void *context);
 
-int VmbusChannelRequestOffers(void);
+int vmbus_request_offers(void);
 
-void VmbusChannelReleaseUnattachedChannels(void);
+void vmbus_release_unattached_channels(void);
 
 #endif /* _CHANNEL_MGMT_H_ */
diff --git a/drivers/staging/hv/vmbus.c b/drivers/staging/hv/vmbus.c
index 0f2e1be..b385e6f 100644
--- a/drivers/staging/hv/vmbus.c
+++ b/drivers/staging/hv/vmbus.c
@@ -57,7 +57,7 @@ static struct hv_device *gDevice; /* vmbus root device */
  */
 static void VmbusGetChannelOffers(void)
 {
-	VmbusChannelRequestOffers();
+	vmbus_request_offers();
 }
 
 /*
@@ -134,7 +134,7 @@ static int VmbusOnDeviceRemove(struct hv_device *dev)
 {
 	int ret = 0;
 
-	VmbusChannelReleaseUnattachedChannels();
+	vmbus_release_unattached_channels();
 	VmbusDisconnect();
 	on_each_cpu(HvSynicCleanup, NULL, 1);
 	return ret;
@@ -171,7 +171,7 @@ static void VmbusOnMsgDPC(struct hv_driver *drv)
 				continue;
 
 			osd_schedule_callback(gVmbusConnection.WorkQueue,
-					      VmbusOnChannelMessage,
+					      vmbus_onmessage,
 					      (void *)copied);
 		}
 
-- 
1.6.3.2

