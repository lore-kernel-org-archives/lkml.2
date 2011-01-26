Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab1AZRt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:49:56 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:39509
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752610Ab1AZRty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:49:54 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 8/8] staging: hv: Convert camel cased struct fields in vmbus_private.h to lower cases
Date: Wed, 26 Jan 2011 09:50:06 -0800
Message-Id: <1296064206-11372-8-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1296064206-11372-7-git-send-email-haiyangz@microsoft.com>
References: <1296064206-11372-1-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-2-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-3-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-4-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-5-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-6-git-send-email-haiyangz@microsoft.com>
 <1296064206-11372-7-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/channel.c       |   22 +++++-----
 drivers/staging/hv/channel_mgmt.c  |   16 ++++----
 drivers/staging/hv/connection.c    |   74 ++++++++++++++++++------------------
 drivers/staging/hv/vmbus_drv.c     |    2 +-
 drivers/staging/hv/vmbus_private.h |   40 ++++++++++----------
 5 files changed, 77 insertions(+), 77 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index a8f5c38..ba9afda 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -77,10 +77,10 @@ static void vmbus_setevent(struct vmbus_channel *channel)
 	if (channel->offermsg.monitor_allocated) {
 		/* Each u32 represents 32 channels */
 		set_bit(channel->offermsg.child_relid & 31,
-			(unsigned long *) vmbus_connection.SendInterruptPage +
+			(unsigned long *) vmbus_connection.send_int_page +
 			(channel->offermsg.child_relid >> 5));
 
-		monitorpage = vmbus_connection.MonitorPages;
+		monitorpage = vmbus_connection.monitor_pages;
 		monitorpage++; /* Get the child to parent monitor page */
 
 		set_bit(channel->monitor_bit,
@@ -100,11 +100,11 @@ static void VmbusChannelClearEvent(struct vmbus_channel *channel)
 	if (Channel->offermsg.monitor_allocated) {
 		/* Each u32 represents 32 channels */
 		clear_bit(Channel->offermsg.child_relid & 31,
-			  (unsigned long *)vmbus_connection.SendInterruptPage +
+			  (unsigned long *)vmbus_connection.send_int_page +
 			  (Channel->offermsg.child_relid >> 5));
 
-		monitorPage =
-			(struct hv_monitor_page *)vmbus_connection.MonitorPages;
+		monitorPage = (struct hv_monitor_page *)
+			vmbus_connection.monitor_pages;
 		monitorPage++; /* Get the child to parent monitor page */
 
 		clear_bit(Channel->monitor_bit,
@@ -133,7 +133,7 @@ void vmbus_get_debug_info(struct vmbus_channel *channel,
 	       &channel->offermsg.offer.if_instance,
 	       sizeof(struct hv_guid));
 
-	monitorpage = (struct hv_monitor_page *)vmbus_connection.MonitorPages;
+	monitorpage = (struct hv_monitor_page *)vmbus_connection.monitor_pages;
 
 	debuginfo->monitorid = channel->offermsg.monitorid;
 
@@ -267,7 +267,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_add_tail(&openInfo->msglistentry,
-		      &vmbus_connection.ChannelMsgList);
+		      &vmbus_connection.chn_msg_list);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
 	DPRINT_DBG(VMBUS, "Sending channel open msg...");
@@ -501,8 +501,8 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	unsigned long flags;
 	int ret = 0;
 
-	next_gpadl_handle = atomic_read(&vmbus_connection.NextGpadlHandle);
-	atomic_inc(&vmbus_connection.NextGpadlHandle);
+	next_gpadl_handle = atomic_read(&vmbus_connection.next_gpadl_handle);
+	atomic_inc(&vmbus_connection.next_gpadl_handle);
 
 	ret = create_gpadl_header(kbuffer, size, &msginfo, &msgcount);
 	if (ret)
@@ -523,7 +523,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_add_tail(&msginfo->msglistentry,
-		      &vmbus_connection.ChannelMsgList);
+		      &vmbus_connection.chn_msg_list);
 
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 	DPRINT_DBG(VMBUS, "buffer %p, size %d msg cnt %d",
@@ -618,7 +618,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_add_tail(&info->msglistentry,
-		      &vmbus_connection.ChannelMsgList);
+		      &vmbus_connection.chn_msg_list);
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
 	ret = vmbus_post_msg(msg,
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index 78c4f10..a9c9d49 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -308,7 +308,7 @@ void free_channel(struct vmbus_channel *channel)
 	 * ie we can't destroy ourselves.
 	 */
 	INIT_WORK(&channel->work, release_channel);
-	queue_work(vmbus_connection.WorkQueue, &channel->work);
+	queue_work(vmbus_connection.work_queue, &channel->work);
 }
 
 
@@ -363,7 +363,7 @@ static void vmbus_process_offer(struct work_struct *work)
 	/* Make sure this is a new offer */
 	spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
 
-	list_for_each_entry(channel, &vmbus_connection.ChannelList, listentry) {
+	list_for_each_entry(channel, &vmbus_connection.chn_list, listentry) {
 		if (!memcmp(&channel->offermsg.offer.if_type,
 			    &newchannel->offermsg.offer.if_type,
 			    sizeof(struct hv_guid)) &&
@@ -377,7 +377,7 @@ static void vmbus_process_offer(struct work_struct *work)
 
 	if (fnew)
 		list_add_tail(&newchannel->listentry,
-			      &vmbus_connection.ChannelList);
+			      &vmbus_connection.chn_list);
 
 	spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
 
@@ -579,7 +579,7 @@ static void vmbus_onopen_result(struct vmbus_channel_message_header *hdr)
 	 */
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 
-	list_for_each(curr, &vmbus_connection.ChannelMsgList) {
+	list_for_each(curr, &vmbus_connection.chn_msg_list) {
 /* FIXME: this should probably use list_entry() instead */
 		msginfo = (struct vmbus_channel_msginfo *)curr;
 		requestheader =
@@ -627,7 +627,7 @@ static void vmbus_ongpadl_created(struct vmbus_channel_message_header *hdr)
 	 */
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 
-	list_for_each(curr, &vmbus_connection.ChannelMsgList) {
+	list_for_each(curr, &vmbus_connection.chn_msg_list) {
 /* FIXME: this should probably use list_entry() instead */
 		msginfo = (struct vmbus_channel_msginfo *)curr;
 		requestheader =
@@ -675,7 +675,7 @@ static void vmbus_ongpadl_torndown(
 	 */
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 
-	list_for_each(curr, &vmbus_connection.ChannelMsgList) {
+	list_for_each(curr, &vmbus_connection.chn_msg_list) {
 /* FIXME: this should probably use list_entry() instead */
 		msginfo = (struct vmbus_channel_msginfo *)curr;
 		requestheader =
@@ -717,7 +717,7 @@ static void vmbus_onversion_response(
 	version_response = (struct vmbus_channel_version_response *)hdr;
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 
-	list_for_each(curr, &vmbus_connection.ChannelMsgList) {
+	list_for_each(curr, &vmbus_connection.chn_msg_list) {
 /* FIXME: this should probably use list_entry() instead */
 		msginfo = (struct vmbus_channel_msginfo *)curr;
 		requestheader =
@@ -859,7 +859,7 @@ void vmbus_release_unattached_channels(void)
 
 	spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
 
-	list_for_each_entry_safe(channel, pos, &vmbus_connection.ChannelList,
+	list_for_each_entry_safe(channel, pos, &vmbus_connection.chn_list,
 				 listentry) {
 		if (channel == start)
 			break;
diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index 002e86c..b3ac66e 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -29,9 +29,9 @@
 #include "vmbus_private.h"
 
 
-struct VMBUS_CONNECTION vmbus_connection = {
-	.ConnectState		= Disconnected,
-	.NextGpadlHandle	= ATOMIC_INIT(0xE1E10),
+struct vmbus_connection vmbus_connection = {
+	.conn_state		= DISCONNECTED,
+	.next_gpadl_handle	= ATOMIC_INIT(0xE1E10),
 };
 
 /*
@@ -45,44 +45,44 @@ int vmbus_connect(void)
 	unsigned long flags;
 
 	/* Make sure we are not connecting or connected */
-	if (vmbus_connection.ConnectState != Disconnected)
+	if (vmbus_connection.conn_state != DISCONNECTED)
 		return -1;
 
 	/* Initialize the vmbus connection */
-	vmbus_connection.ConnectState = Connecting;
-	vmbus_connection.WorkQueue = create_workqueue("hv_vmbus_con");
-	if (!vmbus_connection.WorkQueue) {
+	vmbus_connection.conn_state = CONNECTING;
+	vmbus_connection.work_queue = create_workqueue("hv_vmbus_con");
+	if (!vmbus_connection.work_queue) {
 		ret = -1;
 		goto Cleanup;
 	}
 
-	INIT_LIST_HEAD(&vmbus_connection.ChannelMsgList);
+	INIT_LIST_HEAD(&vmbus_connection.chn_msg_list);
 	spin_lock_init(&vmbus_connection.channelmsg_lock);
 
-	INIT_LIST_HEAD(&vmbus_connection.ChannelList);
+	INIT_LIST_HEAD(&vmbus_connection.chn_list);
 	spin_lock_init(&vmbus_connection.channel_lock);
 
 	/*
 	 * Setup the vmbus event connection for channel interrupt
 	 * abstraction stuff
 	 */
-	vmbus_connection.InterruptPage = osd_page_alloc(1);
-	if (vmbus_connection.InterruptPage == NULL) {
+	vmbus_connection.int_page = osd_page_alloc(1);
+	if (vmbus_connection.int_page == NULL) {
 		ret = -1;
 		goto Cleanup;
 	}
 
-	vmbus_connection.RecvInterruptPage = vmbus_connection.InterruptPage;
-	vmbus_connection.SendInterruptPage =
-		(void *)((unsigned long)vmbus_connection.InterruptPage +
+	vmbus_connection.recv_int_page = vmbus_connection.int_page;
+	vmbus_connection.send_int_page =
+		(void *)((unsigned long)vmbus_connection.int_page +
 			(PAGE_SIZE >> 1));
 
 	/*
 	 * Setup the monitor notification facility. The 1st page for
 	 * parent->child and the 2nd page for child->parent
 	 */
-	vmbus_connection.MonitorPages = osd_page_alloc(2);
-	if (vmbus_connection.MonitorPages == NULL) {
+	vmbus_connection.monitor_pages = osd_page_alloc(2);
+	if (vmbus_connection.monitor_pages == NULL) {
 		ret = -1;
 		goto Cleanup;
 	}
@@ -105,10 +105,10 @@ int vmbus_connect(void)
 
 	msg->header.msgtype = CHANNELMSG_INITIATE_CONTACT;
 	msg->vmbus_version_requested = VMBUS_REVISION_NUMBER;
-	msg->interrupt_page = virt_to_phys(vmbus_connection.InterruptPage);
-	msg->monitor_page1 = virt_to_phys(vmbus_connection.MonitorPages);
+	msg->interrupt_page = virt_to_phys(vmbus_connection.int_page);
+	msg->monitor_page1 = virt_to_phys(vmbus_connection.monitor_pages);
 	msg->monitor_page2 = virt_to_phys(
-			(void *)((unsigned long)vmbus_connection.MonitorPages +
+			(void *)((unsigned long)vmbus_connection.monitor_pages +
 				 PAGE_SIZE));
 
 	/*
@@ -117,7 +117,7 @@ int vmbus_connect(void)
 	 */
 	spin_lock_irqsave(&vmbus_connection.channelmsg_lock, flags);
 	list_add_tail(&msginfo->msglistentry,
-		      &vmbus_connection.ChannelMsgList);
+		      &vmbus_connection.chn_msg_list);
 
 	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
 
@@ -141,7 +141,7 @@ int vmbus_connect(void)
 	/* Check if successful */
 	if (msginfo->response.version_response.version_supported) {
 		DPRINT_INFO(VMBUS, "Vmbus connected!!");
-		vmbus_connection.ConnectState = Connected;
+		vmbus_connection.conn_state = CONNECTED;
 
 	} else {
 		DPRINT_ERR(VMBUS, "Vmbus connection failed!!..."
@@ -156,19 +156,19 @@ int vmbus_connect(void)
 	return 0;
 
 Cleanup:
-	vmbus_connection.ConnectState = Disconnected;
+	vmbus_connection.conn_state = DISCONNECTED;
 
-	if (vmbus_connection.WorkQueue)
-		destroy_workqueue(vmbus_connection.WorkQueue);
+	if (vmbus_connection.work_queue)
+		destroy_workqueue(vmbus_connection.work_queue);
 
-	if (vmbus_connection.InterruptPage) {
-		osd_page_free(vmbus_connection.InterruptPage, 1);
-		vmbus_connection.InterruptPage = NULL;
+	if (vmbus_connection.int_page) {
+		osd_page_free(vmbus_connection.int_page, 1);
+		vmbus_connection.int_page = NULL;
 	}
 
-	if (vmbus_connection.MonitorPages) {
-		osd_page_free(vmbus_connection.MonitorPages, 2);
-		vmbus_connection.MonitorPages = NULL;
+	if (vmbus_connection.monitor_pages) {
+		osd_page_free(vmbus_connection.monitor_pages, 2);
+		vmbus_connection.monitor_pages = NULL;
 	}
 
 	if (msginfo) {
@@ -189,7 +189,7 @@ int vmbus_disconnect(void)
 	struct vmbus_channel_message_header *msg;
 
 	/* Make sure we are connected */
-	if (vmbus_connection.ConnectState != Connected)
+	if (vmbus_connection.conn_state != CONNECTED)
 		return -1;
 
 	msg = kzalloc(sizeof(struct vmbus_channel_message_header), GFP_KERNEL);
@@ -203,12 +203,12 @@ int vmbus_disconnect(void)
 	if (ret != 0)
 		goto Cleanup;
 
-	osd_page_free(vmbus_connection.InterruptPage, 1);
+	osd_page_free(vmbus_connection.int_page, 1);
 
 	/* TODO: iterate thru the msg list and free up */
-	destroy_workqueue(vmbus_connection.WorkQueue);
+	destroy_workqueue(vmbus_connection.work_queue);
 
-	vmbus_connection.ConnectState = Disconnected;
+	vmbus_connection.conn_state = DISCONNECTED;
 
 	DPRINT_INFO(VMBUS, "Vmbus disconnected!!");
 
@@ -228,7 +228,7 @@ struct vmbus_channel *relid2channel(u32 relid)
 	unsigned long flags;
 
 	spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
-	list_for_each_entry(channel, &vmbus_connection.ChannelList, listentry) {
+	list_for_each_entry(channel, &vmbus_connection.chn_list, listentry) {
 		if (channel->offermsg.child_relid == relid) {
 			found_channel = channel;
 			break;
@@ -276,7 +276,7 @@ void vmbus_on_event(void)
 	int maxdword = MAX_NUM_CHANNELS_SUPPORTED >> 5;
 	int bit;
 	int relid;
-	u32 *recv_int_page = vmbus_connection.RecvInterruptPage;
+	u32 *recv_int_page = vmbus_connection.recv_int_page;
 
 	/* Check events */
 	if (recv_int_page) {
@@ -326,7 +326,7 @@ int vmbus_set_event(u32 child_relid)
 {
 	/* Each u32 represents 32 channels */
 	set_bit(child_relid & 31,
-		(unsigned long *)vmbus_connection.SendInterruptPage +
+		(unsigned long *)vmbus_connection.send_int_page +
 		(child_relid >> 5));
 
 	return hv_signal_event();
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 4c56bea..dacaa54 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -239,7 +239,7 @@ static void vmbus_on_msg_dpc(struct hv_driver *drv)
 				continue;
 			INIT_WORK(&ctx->work, vmbus_onmessage_work);
 			memcpy(&ctx->msg, msg, sizeof(*msg));
-			queue_work(vmbus_connection.WorkQueue, &ctx->work);
+			queue_work(vmbus_connection.work_queue, &ctx->work);
 		}
 
 		msg->header.message_type = HVMSG_NONE;
diff --git a/drivers/staging/hv/vmbus_private.h b/drivers/staging/hv/vmbus_private.h
index 0ab404e..004d8de 100644
--- a/drivers/staging/hv/vmbus_private.h
+++ b/drivers/staging/hv/vmbus_private.h
@@ -45,19 +45,19 @@
 #define MAX_NUM_CHANNELS_SUPPORTED	256
 
 
-enum VMBUS_CONNECT_STATE {
-	Disconnected,
-	Connecting,
-	Connected,
-	Disconnecting
+enum vmbus_connect_state {
+	DISCONNECTED,
+	CONNECTING,
+	CONNECTED,
+	DISCONNECTING
 };
 
 #define MAX_SIZE_CHANNEL_MESSAGE	HV_MESSAGE_PAYLOAD_BYTE_COUNT
 
-struct VMBUS_CONNECTION {
-	enum VMBUS_CONNECT_STATE ConnectState;
+struct vmbus_connection {
+	enum vmbus_connect_state conn_state;
 
-	atomic_t NextGpadlHandle;
+	atomic_t next_gpadl_handle;
 
 	/*
 	 * Represents channel interrupts. Each bit position represents a
@@ -66,39 +66,39 @@ struct VMBUS_CONNECTION {
 	 * event. The other end receives the port event and parse the
 	 * recvInterruptPage to see which bit is set
 	 */
-	void *InterruptPage;
-	void *SendInterruptPage;
-	void *RecvInterruptPage;
+	void *int_page;
+	void *send_int_page;
+	void *recv_int_page;
 
 	/*
 	 * 2 pages - 1st page for parent->child notification and 2nd
 	 * is child->parent notification
 	 */
-	void *MonitorPages;
-	struct list_head ChannelMsgList;
+	void *monitor_pages;
+	struct list_head chn_msg_list;
 	spinlock_t channelmsg_lock;
 
 	/* List of channels */
-	struct list_head ChannelList;
+	struct list_head chn_list;
 	spinlock_t channel_lock;
 
-	struct workqueue_struct *WorkQueue;
+	struct workqueue_struct *work_queue;
 };
 
 
-struct VMBUS_MSGINFO {
+struct vmbus_msginfo {
 	/* Bookkeeping stuff */
-	struct list_head MsgListEntry;
+	struct list_head msglist_entry;
 
 	/* Synchronize the request/response if needed */
-	struct osd_waitevent *WaitEvent;
+	struct osd_waitevent *wait_event;
 
 	/* The message itself */
-	unsigned char Msg[0];
+	unsigned char msg[0];
 };
 
 
-extern struct VMBUS_CONNECTION vmbus_connection;
+extern struct vmbus_connection vmbus_connection;
 
 /* General vmbus interface */
 
-- 
1.6.3.2

