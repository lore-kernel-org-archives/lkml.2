Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751504Ab1BNWnm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:43:42 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:32863
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751025Ab1BNWnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:43:40 -0500
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/2] staging: hv: Remove dead code from rndis_filter.c
Date: Mon, 14 Feb 2011 14:51:42 -0800
Message-Id: <1297723902-18176-2-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1297723902-18176-1-git-send-email-haiyangz@microsoft.com>
References: <1297723902-18176-1-git-send-email-haiyangz@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/rndis_filter.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index 9dde936..e7189cd 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -355,10 +355,6 @@ static void rndis_filter_receive_data(struct rndis_device *dev,
 	struct rndis_packet *rndis_pkt;
 	u32 data_offset;
 
-	/* empty ethernet frame ?? */
-	/* ASSERT(Packet->PageBuffers[0].Length > */
-	/* 	RNDIS_MESSAGE_SIZE(struct rndis_packet)); */
-
 	rndis_pkt = &msg->msg.pkt;
 
 	/*
@@ -455,8 +451,6 @@ static int rndis_filter_receive(struct hv_device *dev,
 	case REMOTE_NDIS_INITIALIZE_CMPLT:
 	case REMOTE_NDIS_QUERY_CMPLT:
 	case REMOTE_NDIS_SET_CMPLT:
-	/* case REMOTE_NDIS_RESET_CMPLT: */
-	/* case REMOTE_NDIS_KEEPALIVE_CMPLT: */
 		/* completion msgs */
 		rndis_filter_receive_response(rndis_dev, &rndis_msg);
 		break;
@@ -563,9 +557,6 @@ static int rndis_filter_set_packet_filter(struct rndis_device *dev,
 	u32 status;
 	int ret;
 
-	/* ASSERT(RNDIS_MESSAGE_SIZE(struct rndis_set_request) + sizeof(u32) <= */
-	/* 	sizeof(struct rndis_message)); */
-
 	request = get_rndis_request(dev, REMOTE_NDIS_SET_MSG,
 			RNDIS_MESSAGE_SIZE(struct rndis_set_request) +
 			sizeof(u32));
@@ -634,8 +625,6 @@ int rndis_filter_init(struct netvsc_driver *drv)
 					drv->base.dev_rm;
 	rndis_filter.inner_drv.base.cleanup = drv->base.cleanup;
 
-	/* ASSERT(Driver->OnSend); */
-	/* ASSERT(Driver->OnReceiveCallback); */
 	rndis_filter.inner_drv.send = drv->send;
 	rndis_filter.inner_drv.recv_cb = drv->recv_cb;
 	rndis_filter.inner_drv.link_status_change =
@@ -646,7 +635,6 @@ int rndis_filter_init(struct netvsc_driver *drv)
 	drv->base.dev_rm = rndis_filter_device_remove;
 	drv->base.cleanup = rndis_filter_cleanup;
 	drv->send = rndis_filter_send;
-	/* Driver->QueryLinkStatus = RndisFilterQueryDeviceLinkStatus; */
 	drv->recv_cb = rndis_filter_receive;
 
 	return 0;
@@ -793,8 +781,6 @@ static int rndis_filte_device_add(struct hv_device *dev,
 
 	/* Initialize the rndis device */
 	netDevice = dev->ext;
-	/* ASSERT(netDevice); */
-	/* ASSERT(netDevice->Device); */
 
 	netDevice->extension = rndisDevice;
 	rndisDevice->net_dev = netDevice;
@@ -882,7 +868,6 @@ static int rndis_filter_send(struct hv_device *dev,
 
 	/* Add the rndis header */
 	filterPacket = (struct rndis_filter_packet *)pkt->extension;
-	/* ASSERT(filterPacket); */
 
 	memset(filterPacket, 0, sizeof(struct rndis_filter_packet));
 
-- 
1.6.3.2

