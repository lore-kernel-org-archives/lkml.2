Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab1C2UsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 16:48:13 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:54070
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753242Ab1C2UsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 16:48:09 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, haiyangz@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 03/07] Remove all unneeded DPRINT from hv_utils
Date: Tue, 29 Mar 2011 13:58:46 -0700
Message-Id: <1301432330-1705-4-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301432330-1705-1-git-send-email-hjanssen@microsoft.com>
References: <1301432330-1705-1-git-send-email-hjanssen@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove all un-needed DPRINT calls from hv_utils.

This patch deals with hv_utils only.

Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

---
 drivers/staging/hv/hv_kvp.c  |    3 ---
 drivers/staging/hv/hv_util.c |   12 ------------
 2 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/hv/hv_kvp.c b/drivers/staging/hv/hv_kvp.c
index faf692e..7775820 100644
--- a/drivers/staging/hv/hv_kvp.c
+++ b/drivers/staging/hv/hv_kvp.c
@@ -259,9 +259,6 @@ void hv_kvp_onchannelcallback(void *context)
 	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE, &recvlen, &requestid);
 
 	if (recvlen > 0) {
-		DPRINT_DBG(VMBUS, "KVP packet: len=%d, requestid=%lld",
-			   recvlen, requestid);
-
 		icmsghdrp = (struct icmsg_hdr *)&recv_buffer[
 			sizeof(struct vmbuspipe_hdr)];
 
diff --git a/drivers/staging/hv/hv_util.c b/drivers/staging/hv/hv_util.c
index 4792f2c..3e74f79 100644
--- a/drivers/staging/hv/hv_util.c
+++ b/drivers/staging/hv/hv_util.c
@@ -59,9 +59,6 @@ static void shutdown_onchannelcallback(void *context)
 			 PAGE_SIZE, &recvlen, &requestid);
 
 	if (recvlen > 0) {
-		DPRINT_DBG(VMBUS, "shutdown packet: len=%d, requestid=%lld",
-			   recvlen, requestid);
-
 		icmsghdrp = (struct icmsg_hdr *)&shut_txf_buf[
 			sizeof(struct vmbuspipe_hdr)];
 
@@ -159,9 +156,6 @@ static void timesync_onchannelcallback(void *context)
 			 PAGE_SIZE, &recvlen, &requestid);
 
 	if (recvlen > 0) {
-		DPRINT_DBG(VMBUS, "timesync packet: recvlen=%d, requestid=%lld",
-			recvlen, requestid);
-
 		icmsghdrp = (struct icmsg_hdr *)&time_txf_buf[
 				sizeof(struct vmbuspipe_hdr)];
 
@@ -200,9 +194,6 @@ static void heartbeat_onchannelcallback(void *context)
 			 PAGE_SIZE, &recvlen, &requestid);
 
 	if (recvlen > 0) {
-		DPRINT_DBG(VMBUS, "heartbeat packet: len=%d, requestid=%lld",
-			   recvlen, requestid);
-
 		icmsghdrp = (struct icmsg_hdr *)&hbeat_txf_buf[
 				sizeof(struct vmbuspipe_hdr)];
 
@@ -214,9 +205,6 @@ static void heartbeat_onchannelcallback(void *context)
 					sizeof(struct vmbuspipe_hdr) +
 					sizeof(struct icmsg_hdr)];
 
-			DPRINT_DBG(VMBUS, "heartbeat seq = %lld",
-				   heartbeat_msg->seq_num);
-
 			heartbeat_msg->seq_num += 1;
 		}
 
-- 
1.6.0.2

