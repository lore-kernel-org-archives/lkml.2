Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab2A3Qgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:36:50 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:33847
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752980Ab2A3Qgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:36:49 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jan 2012 11:36:49 EST
From: Haiyang Zhang <haiyangz@microsoft.com>
To: haiyangz@microsoft.com, kys@microsoft.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] net/hyperv: Convert camel cased variables in rndis_filter.c to lower cases
Date: Mon, 30 Jan 2012 08:33:34 -0800
Message-Id: <1327941218-12547-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/net/hyperv/rndis_filter.c |   54 ++++++++++++++++++------------------
 1 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index da181f9..129e696 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -739,53 +739,53 @@ int rndis_filter_open(struct hv_device *dev)
 
 int rndis_filter_close(struct hv_device *dev)
 {
-	struct netvsc_device *netDevice = hv_get_drvdata(dev);
+	struct netvsc_device *nvdev = hv_get_drvdata(dev);
 
-	if (!netDevice)
+	if (!nvdev)
 		return -EINVAL;
 
-	return rndis_filter_close_device(netDevice->extension);
+	return rndis_filter_close_device(nvdev->extension);
 }
 
 int rndis_filter_send(struct hv_device *dev,
 			     struct hv_netvsc_packet *pkt)
 {
 	int ret;
-	struct rndis_filter_packet *filterPacket;
-	struct rndis_message *rndisMessage;
-	struct rndis_packet *rndisPacket;
-	u32 rndisMessageSize;
+	struct rndis_filter_packet *filter_pkt;
+	struct rndis_message *rndis_msg;
+	struct rndis_packet *rndis_pkt;
+	u32 rndis_msg_size;
 
 	/* Add the rndis header */
-	filterPacket = (struct rndis_filter_packet *)pkt->extension;
+	filter_pkt = (struct rndis_filter_packet *)pkt->extension;
 
-	memset(filterPacket, 0, sizeof(struct rndis_filter_packet));
+	memset(filter_pkt, 0, sizeof(struct rndis_filter_packet));
 
-	rndisMessage = &filterPacket->msg;
-	rndisMessageSize = RNDIS_MESSAGE_SIZE(struct rndis_packet);
+	rndis_msg = &filter_pkt->msg;
+	rndis_msg_size = RNDIS_MESSAGE_SIZE(struct rndis_packet);
 
-	rndisMessage->ndis_msg_type = REMOTE_NDIS_PACKET_MSG;
-	rndisMessage->msg_len = pkt->total_data_buflen +
-				      rndisMessageSize;
+	rndis_msg->ndis_msg_type = REMOTE_NDIS_PACKET_MSG;
+	rndis_msg->msg_len = pkt->total_data_buflen +
+				      rndis_msg_size;
 
-	rndisPacket = &rndisMessage->msg.pkt;
-	rndisPacket->data_offset = sizeof(struct rndis_packet);
-	rndisPacket->data_len = pkt->total_data_buflen;
+	rndis_pkt = &rndis_msg->msg.pkt;
+	rndis_pkt->data_offset = sizeof(struct rndis_packet);
+	rndis_pkt->data_len = pkt->total_data_buflen;
 
 	pkt->is_data_pkt = true;
-	pkt->page_buf[0].pfn = virt_to_phys(rndisMessage) >> PAGE_SHIFT;
+	pkt->page_buf[0].pfn = virt_to_phys(rndis_msg) >> PAGE_SHIFT;
 	pkt->page_buf[0].offset =
-			(unsigned long)rndisMessage & (PAGE_SIZE-1);
-	pkt->page_buf[0].len = rndisMessageSize;
+			(unsigned long)rndis_msg & (PAGE_SIZE-1);
+	pkt->page_buf[0].len = rndis_msg_size;
 
 	/* Save the packet send completion and context */
-	filterPacket->completion = pkt->completion.send.send_completion;
-	filterPacket->completion_ctx =
+	filter_pkt->completion = pkt->completion.send.send_completion;
+	filter_pkt->completion_ctx =
 				pkt->completion.send.send_completion_ctx;
 
 	/* Use ours */
 	pkt->completion.send.send_completion = rndis_filter_send_completion;
-	pkt->completion.send.send_completion_ctx = filterPacket;
+	pkt->completion.send.send_completion_ctx = filter_pkt;
 
 	ret = netvsc_send(dev, pkt);
 	if (ret != 0) {
@@ -794,9 +794,9 @@ int rndis_filter_send(struct hv_device *dev,
 		 * above
 		 */
 		pkt->completion.send.send_completion =
-				filterPacket->completion;
+				filter_pkt->completion;
 		pkt->completion.send.send_completion_ctx =
-				filterPacket->completion_ctx;
+				filter_pkt->completion_ctx;
 	}
 
 	return ret;
@@ -804,10 +804,10 @@ int rndis_filter_send(struct hv_device *dev,
 
 static void rndis_filter_send_completion(void *ctx)
 {
-	struct rndis_filter_packet *filterPacket = ctx;
+	struct rndis_filter_packet *filter_pkt = ctx;
 
 	/* Pass it back to the original handler */
-	filterPacket->completion(filterPacket->completion_ctx);
+	filter_pkt->completion(filter_pkt->completion_ctx);
 }
 
 
-- 
1.7.7

