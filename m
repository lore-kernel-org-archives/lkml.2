Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab1E0NKH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:10:07 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:60874
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753688Ab1E0NKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:10:05 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, kys@microsoft.com,
        v-abkane@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Stephen Hemminger <shemminger@vyatta.com>
Subject: [PATCH 1/2] staging: hv: convert DPRINT_DBG() to netdev_dbg() in dump_rndis_message()
Date: Fri, 27 May 2011 06:21:54 -0700
Message-Id: <1306502515-18961-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>

---
 drivers/staging/hv/rndis_filter.c |   29 ++++++++++++++++-------------
 1 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/hv/rndis_filter.c b/drivers/staging/hv/rndis_filter.c
index 5a5bf64..5674a13 100644
--- a/drivers/staging/hv/rndis_filter.c
+++ b/drivers/staging/hv/rndis_filter.c
@@ -139,14 +139,17 @@ static void put_rndis_request(struct rndis_device *dev,
 	kfree(req);
 }
 
-static void dump_rndis_message(struct rndis_message *rndis_msg)
+static void dump_rndis_message(struct hv_device *hv_dev,
+			struct rndis_message *rndis_msg)
 {
+	struct net_device *netdev = dev_get_drvdata(&hv_dev->device);
+
 	switch (rndis_msg->ndis_msg_type) {
 	case REMOTE_NDIS_PACKET_MSG:
-		DPRINT_DBG(NETVSC, "REMOTE_NDIS_PACKET_MSG (len %u, "
+		netdev_dbg(netdev, "REMOTE_NDIS_PACKET_MSG (len %u, "
 			   "data offset %u data len %u, # oob %u, "
 			   "oob offset %u, oob len %u, pkt offset %u, "
-			   "pkt len %u",
+			   "pkt len %u\n",
 			   rndis_msg->msg_len,
 			   rndis_msg->msg.pkt.data_offset,
 			   rndis_msg->msg.pkt.data_len,
@@ -158,10 +161,10 @@ static void dump_rndis_message(struct rndis_message *rndis_msg)
 		break;
 
 	case REMOTE_NDIS_INITIALIZE_CMPLT:
-		DPRINT_DBG(NETVSC, "REMOTE_NDIS_INITIALIZE_CMPLT "
+		netdev_dbg(netdev, "REMOTE_NDIS_INITIALIZE_CMPLT "
 			"(len %u, id 0x%x, status 0x%x, major %d, minor %d, "
 			"device flags %d, max xfer size 0x%x, max pkts %u, "
-			"pkt aligned %u)",
+			"pkt aligned %u)\n",
 			rndis_msg->msg_len,
 			rndis_msg->msg.init_complete.req_id,
 			rndis_msg->msg.init_complete.status,
@@ -176,9 +179,9 @@ static void dump_rndis_message(struct rndis_message *rndis_msg)
 		break;
 
 	case REMOTE_NDIS_QUERY_CMPLT:
-		DPRINT_DBG(NETVSC, "REMOTE_NDIS_QUERY_CMPLT "
+		netdev_dbg(netdev, "REMOTE_NDIS_QUERY_CMPLT "
 			"(len %u, id 0x%x, status 0x%x, buf len %u, "
-			"buf offset %u)",
+			"buf offset %u)\n",
 			rndis_msg->msg_len,
 			rndis_msg->msg.query_complete.req_id,
 			rndis_msg->msg.query_complete.status,
@@ -189,16 +192,16 @@ static void dump_rndis_message(struct rndis_message *rndis_msg)
 		break;
 
 	case REMOTE_NDIS_SET_CMPLT:
-		DPRINT_DBG(NETVSC,
-			"REMOTE_NDIS_SET_CMPLT (len %u, id 0x%x, status 0x%x)",
+		netdev_dbg(netdev,
+			"REMOTE_NDIS_SET_CMPLT (len %u, id 0x%x, status 0x%x)\n",
 			rndis_msg->msg_len,
 			rndis_msg->msg.set_complete.req_id,
 			rndis_msg->msg.set_complete.status);
 		break;
 
 	case REMOTE_NDIS_INDICATE_STATUS_MSG:
-		DPRINT_DBG(NETVSC, "REMOTE_NDIS_INDICATE_STATUS_MSG "
-			"(len %u, status 0x%x, buf len %u, buf offset %u)",
+		netdev_dbg(netdev, "REMOTE_NDIS_INDICATE_STATUS_MSG "
+			"(len %u, status 0x%x, buf len %u, buf offset %u)\n",
 			rndis_msg->msg_len,
 			rndis_msg->msg.indicate_status.status,
 			rndis_msg->msg.indicate_status.status_buflen,
@@ -206,7 +209,7 @@ static void dump_rndis_message(struct rndis_message *rndis_msg)
 		break;
 
 	default:
-		DPRINT_DBG(NETVSC, "0x%x (len %u)",
+		netdev_dbg(netdev, "0x%x (len %u)\n",
 			rndis_msg->ndis_msg_type,
 			rndis_msg->msg_len);
 		break;
@@ -387,7 +390,7 @@ int rndis_filter_receive(struct hv_device *dev,
 
 	kunmap_atomic(rndis_hdr - pkt->page_buf[0].offset, KM_IRQ0);
 
-	dump_rndis_message(&rndis_msg);
+	dump_rndis_message(dev, &rndis_msg);
 
 	switch (rndis_msg.ndis_msg_type) {
 	case REMOTE_NDIS_PACKET_MSG:
-- 
1.6.3.2

