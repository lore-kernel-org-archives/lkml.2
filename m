Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab1EIVyT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:54:19 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47599
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755024Ab1EIVov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:51 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 095/206] Staging: hv: Rename the function ringbuffer_init
Date: Mon,  9 May 2011 14:56:17 -0700
Message-Id: <1304978288-22999-95-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the function ringbuffer_init to not pollute the
namespace.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/channel.c     |    7 +++++--
 drivers/staging/hv/ring_buffer.c |    4 ++--
 drivers/staging/hv/ring_buffer.h |    3 ++-
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index b53be58..43e54b5 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -201,13 +201,16 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	newchannel->ringbuffer_pagecount = (send_ringbuffer_size +
 					   recv_ringbuffer_size) >> PAGE_SHIFT;
 
-	ret = ringbuffer_init(&newchannel->outbound, out, send_ringbuffer_size);
+	ret = hv_ringbuffer_init(
+		&newchannel->outbound, out, send_ringbuffer_size);
+
 	if (ret != 0) {
 		err = ret;
 		goto errorout;
 	}
 
-	ret = ringbuffer_init(&newchannel->inbound, in, recv_ringbuffer_size);
+	ret = hv_ringbuffer_init(
+		&newchannel->inbound, in, recv_ringbuffer_size);
 	if (ret != 0) {
 		err = ret;
 		goto errorout;
diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
index 66e1b3f..9653ab5 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -299,13 +299,13 @@ u32 get_ringbuffer_interrupt_mask(struct hv_ring_buffer_info *rbi)
 /*++
 
 Name:
-	ringbuffer_init()
+	hv_ringbuffer_init()
 
 Description:
 	Initialize the ring buffer
 
 --*/
-int ringbuffer_init(struct hv_ring_buffer_info *ring_info,
+int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 		   void *buffer, u32 buflen)
 {
 	if (sizeof(struct hv_ring_buffer) != PAGE_SIZE)
diff --git a/drivers/staging/hv/ring_buffer.h b/drivers/staging/hv/ring_buffer.h
index 7bf20d6..3c66dc0 100644
--- a/drivers/staging/hv/ring_buffer.h
+++ b/drivers/staging/hv/ring_buffer.h
@@ -18,6 +18,7 @@
  * Authors:
  *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
+ *   K. Y. Srinivasan <kys@microsoft.com>
  *
  */
 
@@ -75,7 +76,7 @@ struct hv_ring_buffer_debug_info {
 /* Interface */
 
 
-int ringbuffer_init(struct hv_ring_buffer_info *ring_info, void *buffer,
+int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info, void *buffer,
 		   u32 buflen);
 
 void ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info);
-- 
1.7.4.1

