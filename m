Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab0KHWDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:03:40 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:46116
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755828Ab0KHWDD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:03:03 -0500
From: Haiyang Zhang <haiyangz@linuxonhyperv.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 07/10] staging: hv: Convert camel cased functions in osd.c to lower cases
Date: Mon,  8 Nov 2010 14:04:44 -0800
Message-Id: <1289253887-2596-7-git-send-email-haiyangz@linuxonhyperv.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1289253887-2596-6-git-send-email-haiyangz@linuxonhyperv.com>
References: <1289253887-2596-1-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-2-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-3-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-4-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-5-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-6-git-send-email-haiyangz@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

staging: hv: Convert camel cased functions in osd.c to lower cases

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel.c      |   20 +++++++++---------
 drivers/staging/hv/channel_mgmt.c |   12 +++++-----
 drivers/staging/hv/connection.c   |   14 ++++++------
 drivers/staging/hv/hv.c           |   12 +++++-----
 drivers/staging/hv/netvsc.c       |   24 +++++++++++-----------
 drivers/staging/hv/osd.c          |   40 ++++++++++++++++++------------------
 drivers/staging/hv/osd.h          |   18 ++++++++--------
 drivers/staging/hv/rndis_filter.c |   10 ++++----
 drivers/staging/hv/storvsc.c      |   16 +++++++-------
 9 files changed, 83 insertions(+), 83 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 7c15c40..abc2988 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -180,7 +180,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	newchannel->channel_callback_context = context;
 
 	/* Allocate the ring buffer */
-	out = osd_PageAlloc((send_ringbuffer_size + recv_ringbuffer_size)
+	out = osd_page_alloc((send_ringbuffer_size + recv_ringbuffer_size)
 			     >> PAGE_SHIFT);
 	if (!out)
 		return -ENOMEM;
@@ -242,7 +242,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 		goto errorout;
 	}
 
-	openInfo->waitevent = osd_WaitEventCreate();
+	openInfo->waitevent = osd_waitevent_create();
 	if (!openInfo->waitevent) {
 		err = -ENOMEM;
 		goto errorout;
@@ -280,7 +280,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	}
 
 	/* FIXME: Need to time-out here */
-	osd_WaitEventWait(openInfo->waitevent);
+	osd_waitevent_wait(openInfo->waitevent);
 
 	if (openInfo->response.open_result.status == 0)
 		DPRINT_INFO(VMBUS, "channel <%p> open success!!", newchannel);
@@ -300,7 +300,7 @@ Cleanup:
 errorout:
 	RingBufferCleanup(&newchannel->outbound);
 	RingBufferCleanup(&newchannel->inbound);
-	osd_PageFree(out, (send_ringbuffer_size + recv_ringbuffer_size)
+	osd_page_free(out, (send_ringbuffer_size + recv_ringbuffer_size)
 		     >> PAGE_SHIFT);
 	kfree(openInfo);
 	return err;
@@ -508,7 +508,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	if (ret)
 		return ret;
 
-	msginfo->waitevent = osd_WaitEventCreate();
+	msginfo->waitevent = osd_waitevent_create();
 	if (!msginfo->waitevent) {
 		ret = -ENOMEM;
 		goto Cleanup;
@@ -565,7 +565,7 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 
 		}
 	}
-	osd_WaitEventWait(msginfo->waitevent);
+	osd_waitevent_wait(msginfo->waitevent);
 
 	/* At this point, we received the gpadl created msg */
 	DPRINT_DBG(VMBUS, "Received GPADL created "
@@ -604,7 +604,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 	if (!info)
 		return -ENOMEM;
 
-	info->waitevent = osd_WaitEventCreate();
+	info->waitevent = osd_waitevent_create();
 	if (!info->waitevent) {
 		kfree(info);
 		return -ENOMEM;
@@ -628,7 +628,7 @@ int vmbus_teardown_gpadl(struct vmbus_channel *channel, u32 gpadl_handle)
 		/* something... */
 	}
 
-	osd_WaitEventWait(info->waitevent);
+	osd_waitevent_wait(info->waitevent);
 
 	/* Received a torndown response */
 	spin_lock_irqsave(&gVmbusConnection.channelmsg_lock, flags);
@@ -663,7 +663,7 @@ void vmbus_close(struct vmbus_channel *channel)
 	if (!info)
 		return;
 
-	/* info->waitEvent = osd_WaitEventCreate(); */
+	/* info->waitEvent = osd_waitevent_create(); */
 
 	msg = (struct vmbus_channel_close_channel *)info->msg;
 	msg->header.msgtype = CHANNELMSG_CLOSECHANNEL;
@@ -686,7 +686,7 @@ void vmbus_close(struct vmbus_channel *channel)
 	RingBufferCleanup(&channel->outbound);
 	RingBufferCleanup(&channel->inbound);
 
-	osd_PageFree(channel->ringbuffer_pages, channel->ringbuffer_pagecount);
+	osd_page_free(channel->ringbuffer_pages, channel->ringbuffer_pagecount);
 
 	kfree(info);
 
diff --git a/drivers/staging/hv/channel_mgmt.c b/drivers/staging/hv/channel_mgmt.c
index be34e38..ae830f2 100644
--- a/drivers/staging/hv/channel_mgmt.c
+++ b/drivers/staging/hv/channel_mgmt.c
@@ -566,7 +566,7 @@ static void vmbus_onopen_result(struct vmbus_channel_message_header *hdr)
 				memcpy(&msginfo->response.open_result,
 				       result,
 				       sizeof(struct vmbus_channel_open_result));
-				osd_WaitEventSet(msginfo->waitevent);
+				osd_waitevent_set(msginfo->waitevent);
 				break;
 			}
 		}
@@ -616,7 +616,7 @@ static void vmbus_ongpadl_created(struct vmbus_channel_message_header *hdr)
 				memcpy(&msginfo->response.gpadl_created,
 				       gpadlcreated,
 				       sizeof(struct vmbus_channel_gpadl_created));
-				osd_WaitEventSet(msginfo->waitevent);
+				osd_waitevent_set(msginfo->waitevent);
 				break;
 			}
 		}
@@ -662,7 +662,7 @@ static void vmbus_ongpadl_torndown(
 				memcpy(&msginfo->response.gpadl_torndown,
 				       gpadl_torndown,
 				       sizeof(struct vmbus_channel_gpadl_torndown));
-				osd_WaitEventSet(msginfo->waitevent);
+				osd_waitevent_set(msginfo->waitevent);
 				break;
 			}
 		}
@@ -703,7 +703,7 @@ static void vmbus_onversion_response(
 			memcpy(&msginfo->response.version_response,
 			      version_response,
 			      sizeof(struct vmbus_channel_version_response));
-			osd_WaitEventSet(msginfo->waitevent);
+			osd_waitevent_set(msginfo->waitevent);
 		}
 	}
 	spin_unlock_irqrestore(&gVmbusConnection.channelmsg_lock, flags);
@@ -782,7 +782,7 @@ int vmbus_request_offers(void)
 	if (!msginfo)
 		return -ENOMEM;
 
-	msginfo->waitevent = osd_WaitEventCreate();
+	msginfo->waitevent = osd_waitevent_create();
 	if (!msginfo->waitevent) {
 		kfree(msginfo);
 		return -ENOMEM;
@@ -808,7 +808,7 @@ int vmbus_request_offers(void)
 
 		goto Cleanup;
 	}
-	/* osd_WaitEventWait(msgInfo->waitEvent); */
+	/* osd_waitevent_wait(msgInfo->waitEvent); */
 
 	/*SpinlockAcquire(gVmbusConnection.channelMsgLock);
 	REMOVE_ENTRY_LIST(&msgInfo->msgListEntry);
diff --git a/drivers/staging/hv/connection.c b/drivers/staging/hv/connection.c
index 97321d1..c2e298f 100644
--- a/drivers/staging/hv/connection.c
+++ b/drivers/staging/hv/connection.c
@@ -66,7 +66,7 @@ int VmbusConnect(void)
 	 * Setup the vmbus event connection for channel interrupt
 	 * abstraction stuff
 	 */
-	gVmbusConnection.InterruptPage = osd_PageAlloc(1);
+	gVmbusConnection.InterruptPage = osd_page_alloc(1);
 	if (gVmbusConnection.InterruptPage == NULL) {
 		ret = -1;
 		goto Cleanup;
@@ -81,7 +81,7 @@ int VmbusConnect(void)
 	 * Setup the monitor notification facility. The 1st page for
 	 * parent->child and the 2nd page for child->parent
 	 */
-	gVmbusConnection.MonitorPages = osd_PageAlloc(2);
+	gVmbusConnection.MonitorPages = osd_page_alloc(2);
 	if (gVmbusConnection.MonitorPages == NULL) {
 		ret = -1;
 		goto Cleanup;
@@ -95,7 +95,7 @@ int VmbusConnect(void)
 		goto Cleanup;
 	}
 
-	msgInfo->waitevent = osd_WaitEventCreate();
+	msgInfo->waitevent = osd_waitevent_create();
 	if (!msgInfo->waitevent) {
 		ret = -ENOMEM;
 		goto Cleanup;
@@ -134,7 +134,7 @@ int VmbusConnect(void)
 	}
 
 	/* Wait for the connection response */
-	osd_WaitEventWait(msgInfo->waitevent);
+	osd_waitevent_wait(msgInfo->waitevent);
 
 	list_del(&msgInfo->msglistentry);
 
@@ -162,12 +162,12 @@ Cleanup:
 		destroy_workqueue(gVmbusConnection.WorkQueue);
 
 	if (gVmbusConnection.InterruptPage) {
-		osd_PageFree(gVmbusConnection.InterruptPage, 1);
+		osd_page_free(gVmbusConnection.InterruptPage, 1);
 		gVmbusConnection.InterruptPage = NULL;
 	}
 
 	if (gVmbusConnection.MonitorPages) {
-		osd_PageFree(gVmbusConnection.MonitorPages, 2);
+		osd_page_free(gVmbusConnection.MonitorPages, 2);
 		gVmbusConnection.MonitorPages = NULL;
 	}
 
@@ -202,7 +202,7 @@ int VmbusDisconnect(void)
 	if (ret != 0)
 		goto Cleanup;
 
-	osd_PageFree(gVmbusConnection.InterruptPage, 1);
+	osd_page_free(gVmbusConnection.InterruptPage, 1);
 
 	/* TODO: iterate thru the msg list and free up */
 	destroy_workqueue(gVmbusConnection.WorkQueue);
diff --git a/drivers/staging/hv/hv.c b/drivers/staging/hv/hv.c
index 66f04d8..a34d713 100644
--- a/drivers/staging/hv/hv.c
+++ b/drivers/staging/hv/hv.c
@@ -228,9 +228,9 @@ int hv_init(void)
 
 	/*
 	* Allocate the hypercall page memory
-	* virtaddr = osd_PageAlloc(1);
+	* virtaddr = osd_page_alloc(1);
 	*/
-	virtaddr = osd_VirtualAllocExec(PAGE_SIZE);
+	virtaddr = osd_virtual_alloc_exec(PAGE_SIZE);
 
 	if (!virtaddr) {
 		DPRINT_ERR(VMBUS,
@@ -462,10 +462,10 @@ void hv_synic_init(void *irqarg)
 
 Cleanup:
 	if (hv_context.synic_event_page[cpu])
-		osd_PageFree(hv_context.synic_event_page[cpu], 1);
+		osd_page_free(hv_context.synic_event_page[cpu], 1);
 
 	if (hv_context.synic_message_page[cpu])
-		osd_PageFree(hv_context.synic_message_page[cpu], 1);
+		osd_page_free(hv_context.synic_message_page[cpu], 1);
 	return;
 }
 
@@ -502,6 +502,6 @@ void hv_synic_cleanup(void *arg)
 
 	wrmsrl(HV_X64_MSR_SIEFP, siefp.as_uint64);
 
-	osd_PageFree(hv_context.synic_message_page[cpu], 1);
-	osd_PageFree(hv_context.synic_event_page[cpu], 1);
+	osd_page_free(hv_context.synic_message_page[cpu], 1);
+	osd_page_free(hv_context.synic_event_page[cpu], 1);
 }
diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index 4c2632c..8022781 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -221,7 +221,7 @@ static int NetVscInitializeReceiveBufferWithNetVsp(struct hv_device *Device)
 	/* ASSERT((netDevice->ReceiveBufferSize & (PAGE_SIZE - 1)) == 0); */
 
 	netDevice->ReceiveBuffer =
-		osd_PageAlloc(netDevice->ReceiveBufferSize >> PAGE_SHIFT);
+		osd_page_alloc(netDevice->ReceiveBufferSize >> PAGE_SHIFT);
 	if (!netDevice->ReceiveBuffer) {
 		DPRINT_ERR(NETVSC,
 			   "unable to allocate receive buffer of size %d",
@@ -249,7 +249,7 @@ static int NetVscInitializeReceiveBufferWithNetVsp(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	/* osd_WaitEventWait(ext->ChannelInitEvent); */
+	/* osd_waitevent_wait(ext->ChannelInitEvent); */
 
 	/* Notify the NetVsp of the gpadl handle */
 	DPRINT_INFO(NETVSC, "Sending NvspMessage1TypeSendReceiveBuffer...");
@@ -274,7 +274,7 @@ static int NetVscInitializeReceiveBufferWithNetVsp(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	osd_WaitEventWait(netDevice->ChannelInitEvent);
+	osd_waitevent_wait(netDevice->ChannelInitEvent);
 
 	/* Check the response */
 	if (initPacket->Messages.Version1Messages.SendReceiveBufferComplete.Status != NvspStatusSuccess) {
@@ -350,7 +350,7 @@ static int NetVscInitializeSendBufferWithNetVsp(struct hv_device *Device)
 	/* ASSERT((netDevice->SendBufferSize & (PAGE_SIZE - 1)) == 0); */
 
 	netDevice->SendBuffer =
-		osd_PageAlloc(netDevice->SendBufferSize >> PAGE_SHIFT);
+		osd_page_alloc(netDevice->SendBufferSize >> PAGE_SHIFT);
 	if (!netDevice->SendBuffer) {
 		DPRINT_ERR(NETVSC, "unable to allocate send buffer of size %d",
 			   netDevice->SendBufferSize);
@@ -375,7 +375,7 @@ static int NetVscInitializeSendBufferWithNetVsp(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	/* osd_WaitEventWait(ext->ChannelInitEvent); */
+	/* osd_waitevent_wait(ext->ChannelInitEvent); */
 
 	/* Notify the NetVsp of the gpadl handle */
 	DPRINT_INFO(NETVSC, "Sending NvspMessage1TypeSendSendBuffer...");
@@ -400,7 +400,7 @@ static int NetVscInitializeSendBufferWithNetVsp(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	osd_WaitEventWait(netDevice->ChannelInitEvent);
+	osd_waitevent_wait(netDevice->ChannelInitEvent);
 
 	/* Check the response */
 	if (initPacket->Messages.Version1Messages.SendSendBufferComplete.Status != NvspStatusSuccess) {
@@ -480,7 +480,7 @@ static int NetVscDestroyReceiveBuffer(struct netvsc_device *NetDevice)
 		DPRINT_INFO(NETVSC, "Freeing up receive buffer...");
 
 		/* Free up the receive buffer */
-		osd_PageFree(NetDevice->ReceiveBuffer,
+		osd_page_free(NetDevice->ReceiveBuffer,
 			     NetDevice->ReceiveBufferSize >> PAGE_SHIFT);
 		NetDevice->ReceiveBuffer = NULL;
 	}
@@ -553,7 +553,7 @@ static int NetVscDestroySendBuffer(struct netvsc_device *NetDevice)
 		DPRINT_INFO(NETVSC, "Freeing up send buffer...");
 
 		/* Free up the receive buffer */
-		osd_PageFree(NetDevice->SendBuffer,
+		osd_page_free(NetDevice->SendBuffer,
 			     NetDevice->SendBufferSize >> PAGE_SHIFT);
 		NetDevice->SendBuffer = NULL;
 	}
@@ -597,7 +597,7 @@ static int NetVscConnectToVsp(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	osd_WaitEventWait(netDevice->ChannelInitEvent);
+	osd_waitevent_wait(netDevice->ChannelInitEvent);
 
 	/* Now, check the response */
 	/* ASSERT(initPacket->Messages.InitMessages.InitComplete.MaximumMdlChainLength <= MAX_MULTIPAGE_BUFFER_COUNT); */
@@ -651,7 +651,7 @@ static int NetVscConnectToVsp(struct hv_device *Device)
 	 * packet) since our Vmbus always set the
 	 * VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED flag
 	 */
-	 /* osd_WaitEventWait(NetVscChannel->ChannelInitEvent); */
+	 /* osd_waitevent_wait(NetVscChannel->ChannelInitEvent); */
 
 	/* Post the big receive buffer to NetVSP */
 	ret = NetVscInitializeReceiveBufferWithNetVsp(Device);
@@ -710,7 +710,7 @@ static int NetVscOnDeviceAdd(struct hv_device *Device, void *AdditionalInfo)
 		list_add_tail(&packet->ListEntry,
 			      &netDevice->ReceivePacketList);
 	}
-	netDevice->ChannelInitEvent = osd_WaitEventCreate();
+	netDevice->ChannelInitEvent = osd_waitevent_create();
 	if (!netDevice->ChannelInitEvent) {
 		ret = -ENOMEM;
 		goto Cleanup;
@@ -855,7 +855,7 @@ static void NetVscOnSendCompletion(struct hv_device *Device,
 		/* Copy the response back */
 		memcpy(&netDevice->ChannelInitPacket, nvspPacket,
 		       sizeof(struct nvsp_message));
-		osd_WaitEventSet(netDevice->ChannelInitEvent);
+		osd_waitevent_set(netDevice->ChannelInitEvent);
 	} else if (nvspPacket->Header.MessageType ==
 		   NvspMessage1TypeSendRNDISPacketComplete) {
 		/* Get the send context */
diff --git a/drivers/staging/hv/osd.c b/drivers/staging/hv/osd.c
index b39ec25..b699ee2 100644
--- a/drivers/staging/hv/osd.c
+++ b/drivers/staging/hv/osd.c
@@ -49,7 +49,7 @@ struct osd_callback_struct {
 	void *data;
 };
 
-void *osd_VirtualAllocExec(unsigned int size)
+void *osd_virtual_alloc_exec(unsigned int size)
 {
 #ifdef __x86_64__
 	return __vmalloc(size, GFP_KERNEL, PAGE_KERNEL_EXEC);
@@ -60,7 +60,7 @@ void *osd_VirtualAllocExec(unsigned int size)
 }
 
 /**
- * osd_PageAlloc() - Allocate pages
+ * osd_page_alloc() - Allocate pages
  * @count:      Total number of Kernel pages you want to allocate
  *
  * Tries to allocate @count number of consecutive free kernel pages.
@@ -68,7 +68,7 @@ void *osd_VirtualAllocExec(unsigned int size)
  * If successfull it will return pointer to the @count pages.
  * Mainly used by Hyper-V drivers.
  */
-void *osd_PageAlloc(unsigned int count)
+void *osd_page_alloc(unsigned int count)
 {
 	void *p;
 
@@ -85,26 +85,26 @@ void *osd_PageAlloc(unsigned int count)
 	/* if (p) memset(p, 0, PAGE_SIZE); */
 	/* return p; */
 }
-EXPORT_SYMBOL_GPL(osd_PageAlloc);
+EXPORT_SYMBOL_GPL(osd_page_alloc);
 
 /**
- * osd_PageFree() - Free pages
+ * osd_page_free() - Free pages
  * @page:       Pointer to the first page to be freed
  * @count:      Total number of Kernel pages you free
  *
- * Frees the pages allocated by osd_PageAlloc()
+ * Frees the pages allocated by osd_page_alloc()
  * Mainly used by Hyper-V drivers.
  */
-void osd_PageFree(void *page, unsigned int count)
+void osd_page_free(void *page, unsigned int count)
 {
 	free_pages((unsigned long)page, get_order(count * PAGE_SIZE));
 	/*struct page* p = virt_to_page(page);
 	__free_page(p);*/
 }
-EXPORT_SYMBOL_GPL(osd_PageFree);
+EXPORT_SYMBOL_GPL(osd_page_free);
 
 /**
- * osd_WaitEventCreate() - Create the event queue
+ * osd_waitevent_create() - Create the event queue
  *
  * Allocates memory for a &struct osd_waitevent. And then calls
  * init_waitqueue_head to set up the wait queue for the event.
@@ -114,7 +114,7 @@ EXPORT_SYMBOL_GPL(osd_PageFree);
  * Returns pointer to &struct osd_waitevent
  * Mainly used by Hyper-V drivers.
  */
-struct osd_waitevent *osd_WaitEventCreate(void)
+struct osd_waitevent *osd_waitevent_create(void)
 {
 	struct osd_waitevent *wait = kmalloc(sizeof(struct osd_waitevent),
 					     GFP_KERNEL);
@@ -125,11 +125,11 @@ struct osd_waitevent *osd_WaitEventCreate(void)
 	init_waitqueue_head(&wait->event);
 	return wait;
 }
-EXPORT_SYMBOL_GPL(osd_WaitEventCreate);
+EXPORT_SYMBOL_GPL(osd_waitevent_create);
 
 
 /**
- * osd_WaitEventSet() - Wake up the process
+ * osd_waitevent_set() - Wake up the process
  * @wait_event: Structure to event to be woken up
  *
  * @wait_event is of type &struct osd_waitevent
@@ -140,15 +140,15 @@ EXPORT_SYMBOL_GPL(osd_WaitEventCreate);
  *
  * Only used by Network and Storage Hyper-V drivers.
  */
-void osd_WaitEventSet(struct osd_waitevent *wait_event)
+void osd_waitevent_set(struct osd_waitevent *wait_event)
 {
 	wait_event->condition = 1;
 	wake_up_interruptible(&wait_event->event);
 }
-EXPORT_SYMBOL_GPL(osd_WaitEventSet);
+EXPORT_SYMBOL_GPL(osd_waitevent_set);
 
 /**
- * osd_WaitEventWait() - Wait for event till condition is true
+ * osd_waitevent_wait() - Wait for event till condition is true
  * @wait_event: Structure to event to be put to sleep
  *
  * @wait_event is of type &struct osd_waitevent
@@ -161,7 +161,7 @@ EXPORT_SYMBOL_GPL(osd_WaitEventSet);
  *
  * Mainly used by Hyper-V drivers.
  */
-int osd_WaitEventWait(struct osd_waitevent *wait_event)
+int osd_waitevent_wait(struct osd_waitevent *wait_event)
 {
 	int ret = 0;
 
@@ -170,10 +170,10 @@ int osd_WaitEventWait(struct osd_waitevent *wait_event)
 	wait_event->condition = 0;
 	return ret;
 }
-EXPORT_SYMBOL_GPL(osd_WaitEventWait);
+EXPORT_SYMBOL_GPL(osd_waitevent_wait);
 
 /**
- * osd_WaitEventWaitEx() - Wait for event or timeout for process wakeup
+ * osd_waitevent_waitex() - Wait for event or timeout for process wakeup
  * @wait_event: Structure to event to be put to sleep
  * @timeout_in_ms:       Total number of Milliseconds to wait before waking up
  *
@@ -187,7 +187,7 @@ EXPORT_SYMBOL_GPL(osd_WaitEventWait);
  *
  * Mainly used by Hyper-V drivers.
  */
-int osd_WaitEventWaitEx(struct osd_waitevent *wait_event, u32 timeout_in_ms)
+int osd_waitevent_waitex(struct osd_waitevent *wait_event, u32 timeout_in_ms)
 {
 	int ret = 0;
 
@@ -197,7 +197,7 @@ int osd_WaitEventWaitEx(struct osd_waitevent *wait_event, u32 timeout_in_ms)
 	wait_event->condition = 0;
 	return ret;
 }
-EXPORT_SYMBOL_GPL(osd_WaitEventWaitEx);
+EXPORT_SYMBOL_GPL(osd_waitevent_waitex);
 
 static void osd_callback_work(struct work_struct *work)
 {
diff --git a/drivers/staging/hv/osd.h b/drivers/staging/hv/osd.h
index ce064e8..cae126f 100644
--- a/drivers/staging/hv/osd.h
+++ b/drivers/staging/hv/osd.h
@@ -50,18 +50,18 @@ struct osd_waitevent {
 
 /* Osd routines */
 
-extern void *osd_VirtualAllocExec(unsigned int size);
+extern void *osd_virtual_alloc_exec(unsigned int size);
 
-extern void *osd_PageAlloc(unsigned int count);
-extern void osd_PageFree(void *page, unsigned int count);
+extern void *osd_page_alloc(unsigned int count);
+extern void osd_page_free(void *page, unsigned int count);
 
-extern struct osd_waitevent *osd_WaitEventCreate(void);
-extern void osd_WaitEventSet(struct osd_waitevent *waitEvent);
-extern int osd_WaitEventWait(struct osd_waitevent *waitEvent);
+extern struct osd_waitevent *osd_waitevent_create(void);
+extern void osd_waitevent_set(struct osd_waitevent *wait_event);
+extern int osd_waitevent_wait(struct osd_waitevent *wait_event);
 
-/* If >0, waitEvent got signaled. If ==0, timeout. If < 0, error */
-extern int osd_WaitEventWaitEx(struct osd_waitevent *waitEvent,
-			       u32 TimeoutInMs);
+/* If >0, wait_event got signaled. If ==0, timeout. If < 0, error */
+extern int osd_waitevent_waitex(struct osd_waitevent *wait_event,
+			       u32 timeout_in_ms);
 
 int osd_schedule_callback(struct workqueue_struct *wq,
 			  void (*func)(void *),
diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index fa2141f..b85c825 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -129,7 +129,7 @@ static struct rndis_request *GetRndisRequest(struct rndis_device *Device,
 	if (!request)
 		return NULL;
 
-	request->WaitEvent = osd_WaitEventCreate();
+	request->WaitEvent = osd_waitevent_create();
 	if (!request->WaitEvent) {
 		kfree(request);
 		return NULL;
@@ -313,7 +313,7 @@ static void RndisFilterReceiveResponse(struct rndis_device *Device,
 			}
 		}
 
-		osd_WaitEventSet(request->WaitEvent);
+		osd_waitevent_set(request->WaitEvent);
 	} else {
 		DPRINT_ERR(NETVSC, "no rndis request found for this response "
 			   "(id 0x%x res type 0x%x)",
@@ -497,7 +497,7 @@ static int RndisFilterQueryDevice(struct rndis_device *Device, u32 Oid,
 	if (ret != 0)
 		goto Cleanup;
 
-	osd_WaitEventWait(request->WaitEvent);
+	osd_waitevent_wait(request->WaitEvent);
 
 	/* Copy the response back */
 	queryComplete = &request->ResponseMessage.Message.QueryComplete;
@@ -572,7 +572,7 @@ static int RndisFilterSetPacketFilter(struct rndis_device *Device,
 	if (ret != 0)
 		goto Cleanup;
 
-	ret = osd_WaitEventWaitEx(request->WaitEvent, 2000/*2sec*/);
+	ret = osd_waitevent_waitex(request->WaitEvent, 2000/*2sec*/);
 	if (!ret) {
 		ret = -1;
 		DPRINT_ERR(NETVSC, "timeout before we got a set response...");
@@ -665,7 +665,7 @@ static int RndisFilterInitDevice(struct rndis_device *Device)
 		goto Cleanup;
 	}
 
-	osd_WaitEventWait(request->WaitEvent);
+	osd_waitevent_wait(request->WaitEvent);
 
 	initComplete = &request->ResponseMessage.Message.InitializeComplete;
 	status = initComplete->Status;
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 19e87f6..525c8ee 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -198,7 +198,7 @@ static int StorVscChannelInit(struct hv_device *Device)
 	 * channel
 	 */
 	memset(request, 0, sizeof(struct storvsc_request_extension));
-	request->WaitEvent = osd_WaitEventCreate();
+	request->WaitEvent = osd_waitevent_create();
 	if (!request->WaitEvent) {
 		ret = -ENOMEM;
 		goto nomem;
@@ -224,7 +224,7 @@ static int StorVscChannelInit(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	osd_WaitEventWait(request->WaitEvent);
+	osd_waitevent_wait(request->WaitEvent);
 
 	if (vstorPacket->Operation != VStorOperationCompleteIo ||
 	    vstorPacket->Status != 0) {
@@ -255,7 +255,7 @@ static int StorVscChannelInit(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	osd_WaitEventWait(request->WaitEvent);
+	osd_waitevent_wait(request->WaitEvent);
 
 	/* TODO: Check returned version */
 	if (vstorPacket->Operation != VStorOperationCompleteIo ||
@@ -287,7 +287,7 @@ static int StorVscChannelInit(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	osd_WaitEventWait(request->WaitEvent);
+	osd_waitevent_wait(request->WaitEvent);
 
 	/* TODO: Check returned version */
 	if (vstorPacket->Operation != VStorOperationCompleteIo ||
@@ -323,7 +323,7 @@ static int StorVscChannelInit(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	osd_WaitEventWait(request->WaitEvent);
+	osd_waitevent_wait(request->WaitEvent);
 
 	if (vstorPacket->Operation != VStorOperationCompleteIo ||
 	    vstorPacket->Status != 0) {
@@ -473,7 +473,7 @@ static void StorVscOnChannelCallback(void *context)
 				memcpy(&request->VStorPacket, packet,
 				       sizeof(struct vstor_packet));
 
-				osd_WaitEventSet(request->WaitEvent);
+				osd_waitevent_set(request->WaitEvent);
 			} else {
 				StorVscOnReceive(device,
 						(struct vstor_packet *)packet,
@@ -622,7 +622,7 @@ int StorVscOnHostReset(struct hv_device *Device)
 	request = &storDevice->ResetRequest;
 	vstorPacket = &request->VStorPacket;
 
-	request->WaitEvent = osd_WaitEventCreate();
+	request->WaitEvent = osd_waitevent_create();
 	if (!request->WaitEvent) {
 		ret = -ENOMEM;
 		goto Cleanup;
@@ -644,7 +644,7 @@ int StorVscOnHostReset(struct hv_device *Device)
 	}
 
 	/* FIXME: Add a timeout */
-	osd_WaitEventWait(request->WaitEvent);
+	osd_waitevent_wait(request->WaitEvent);
 
 	kfree(request->WaitEvent);
 	DPRINT_INFO(STORVSC, "host adapter reset completed");
-- 
1.6.3.2

