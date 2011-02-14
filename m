Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab1BNWnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:43:46 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35742
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751047Ab1BNWnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:43:40 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/2] staging: hv: Remove dead code from netvsc.c
Date: Mon, 14 Feb 2011 14:51:41 -0800
Message-Id: <1297723902-18176-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/netvsc.c |   34 ----------------------------------
 1 files changed, 0 insertions(+), 34 deletions(-)

diff --git a/drivers/staging/hv/netvsc.c b/drivers/staging/hv/netvsc.c
index fa46a7e..8c6d4ae 100644
--- a/drivers/staging/hv/netvsc.c
+++ b/drivers/staging/hv/netvsc.c
@@ -134,7 +134,6 @@ static void put_net_device(struct hv_device *device)
 	struct netvsc_device *net_device;
 
 	net_device = device->ext;
-	/* ASSERT(netDevice); */
 
 	atomic_dec(&net_device->refcnt);
 }
@@ -186,9 +185,6 @@ int netvsc_initialize(struct hv_driver *drv)
 		   sizeof(struct nvsp_message),
 		   sizeof(struct vmtransfer_page_packet_header));
 
-	/* Make sure we are at least 2 pages since 1 page is used for control */
-	/* ASSERT(driver->RingBufferSize >= (PAGE_SIZE << 1)); */
-
 	drv->name = driver_name;
 	memcpy(&drv->dev_type, &netvsc_device_type, sizeof(struct hv_guid));
 
@@ -220,9 +216,6 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 			   "device being destroyed?");
 		return -1;
 	}
-	/* ASSERT(netDevice->ReceiveBufferSize > 0); */
-	/* page-size grandularity */
-	/* ASSERT((netDevice->ReceiveBufferSize & (PAGE_SIZE - 1)) == 0); */
 
 	net_device->recv_buf =
 		(void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
@@ -234,9 +227,6 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 		ret = -1;
 		goto cleanup;
 	}
-	/* page-aligned buffer */
-	/* ASSERT(((unsigned long)netDevice->ReceiveBuffer & (PAGE_SIZE - 1)) == */
-	/* 	0); */
 
 	DPRINT_INFO(NETVSC, "Establishing receive buffer's GPADL...");
 
@@ -299,8 +289,6 @@ static int netvsc_init_recv_buf(struct hv_device *device)
 	}
 
 	/* Parse the response */
-	/* ASSERT(netDevice->ReceiveSectionCount == 0); */
-	/* ASSERT(netDevice->ReceiveSections == NULL); */
 
 	net_device->recv_section_cnt = init_packet->msg.
 		v1_msg.send_recv_buf_complete.num_sections;
@@ -363,9 +351,6 @@ static int netvsc_init_send_buf(struct hv_device *device)
 		goto cleanup;
 	}
 
-	/* page-size grandularity */
-	/* ASSERT((netDevice->SendBufferSize & (PAGE_SIZE - 1)) == 0); */
-
 	net_device->send_buf =
 		(void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
 				get_order(net_device->send_buf_size));
@@ -375,8 +360,6 @@ static int netvsc_init_send_buf(struct hv_device *device)
 		ret = -1;
 		goto cleanup;
 	}
-	/* page-aligned buffer */
-	/* ASSERT(((unsigned long)netDevice->SendBuffer & (PAGE_SIZE - 1)) == 0); */
 
 	DPRINT_INFO(NETVSC, "Establishing send buffer's GPADL...");
 
@@ -639,8 +622,6 @@ static int netvsc_connect_vsp(struct hv_device *device)
 		goto cleanup;
 	}
 
-	/* Now, check the response */
-	/* ASSERT(initPacket->Messages.InitMessages.InitComplete.MaximumMdlChainLength <= MAX_MULTIPAGE_BUFFER_COUNT); */
 	DPRINT_INFO(NETVSC, "NvspMessageTypeInit status(%d) max mdl chain (%d)",
 		init_packet->msg.init_msg.init_complete.status,
 		init_packet->msg.init_msg.
@@ -895,7 +876,6 @@ static void netvsc_send_completion(struct hv_device *device,
 		/* Get the send context */
 		nvsc_packet = (struct hv_netvsc_packet *)(unsigned long)
 			packet->trans_id;
-		/* ASSERT(nvscPacket); */
 
 		/* Notify the layer above us */
 		nvsc_packet->completion.send.send_completion(
@@ -1072,8 +1052,6 @@ static void netvsc_receive(struct hv_device *device,
 
 	/* This is how much we can satisfy */
 	xferpage_packet->count = count - 1;
-	/* ASSERT(xferpagePacket->Count > 0 && xferpagePacket->Count <= */
-	/* 	vmxferpagePacket->RangeCount); */
 
 	if (xferpage_packet->count != vmxferpage_packet->range_cnt) {
 		DPRINT_INFO(NETVSC, "Needed %d netvsc pkts to satisy this xfer "
@@ -1101,10 +1079,6 @@ static void netvsc_receive(struct hv_device *device,
 					vmxferpage_packet->ranges[i].byte_count;
 		netvsc_packet->page_buf_cnt = 1;
 
-		/* ASSERT(vmxferpagePacket->Ranges[i].ByteOffset + */
-		/* 	vmxferpagePacket->Ranges[i].ByteCount < */
-		/* 	netDevice->ReceiveBufferSize); */
-
 		netvsc_packet->page_buf[0].len =
 					vmxferpage_packet->ranges[i].byte_count;
 
@@ -1147,7 +1121,6 @@ static void netvsc_receive(struct hv_device *device,
 				if (bytes_remain == 0)
 					break;
 			}
-			/* ASSERT(bytesRemain == 0); */
 		}
 		DPRINT_DBG(NETVSC, "[%d] - (abs offset %u len %u) => "
 			   "(pfn %llx, offset %u, len %u)", i,
@@ -1165,8 +1138,6 @@ static void netvsc_receive(struct hv_device *device,
 				completion.recv.recv_completion_ctx);
 	}
 
-	/* ASSERT(list_empty(&listHead)); */
-
 	put_net_device(device);
 }
 
@@ -1225,8 +1196,6 @@ static void netvsc_receive_completion(void *context)
 	bool fsend_receive_comp = false;
 	unsigned long flags;
 
-	/* ASSERT(packet->XferPagePacket); */
-
 	/*
 	 * Even though it seems logical to do a GetOutboundNetDevice() here to
 	 * send out receive completion, we are using GetInboundNetDevice()
@@ -1242,7 +1211,6 @@ static void netvsc_receive_completion(void *context)
 	/* Overloading use of the lock. */
 	spin_lock_irqsave(&net_device->recv_pkt_list_lock, flags);
 
-	/* ASSERT(packet->XferPagePacket->Count > 0); */
 	packet->xfer_page_pkt->count--;
 
 	/*
@@ -1280,8 +1248,6 @@ static void netvsc_channel_cb(void *context)
 	unsigned char *buffer;
 	int bufferlen = NETVSC_PACKET_SIZE;
 
-	/* ASSERT(device); */
-
 	packet = kzalloc(NETVSC_PACKET_SIZE * sizeof(unsigned char),
 			 GFP_ATOMIC);
 	if (!packet)
-- 
1.6.3.2

