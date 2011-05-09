Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab1EIVx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:53:57 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47629
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755027Ab1EIVov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:51 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 097/206] Staging: hv: Rename ringbuffer_write
Date: Mon,  9 May 2011 14:56:19 -0700
Message-Id: <1304978288-22999-97-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename ringbuffer_write.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/channel.c     |    6 +++---
 drivers/staging/hv/ring_buffer.c |    4 ++--
 drivers/staging/hv/ring_buffer.h |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 44b81e8..859771c 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -718,7 +718,7 @@ int vmbus_sendpacket(struct vmbus_channel *channel, const void *buffer,
 	sg_set_buf(&bufferlist[2], &aligned_data,
 		   packetlen_aligned - packetlen);
 
-	ret = ringbuffer_write(&channel->outbound, bufferlist, 3);
+	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3);
 
 	/* TODO: We should determine if this is optional */
 	if (ret == 0 && !get_ringbuffer_interrupt_mask(&channel->outbound))
@@ -783,7 +783,7 @@ int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
 	sg_set_buf(&bufferlist[2], &aligned_data,
 		packetlen_aligned - packetlen);
 
-	ret = ringbuffer_write(&channel->outbound, bufferlist, 3);
+	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3);
 
 	/* TODO: We should determine if this is optional */
 	if (ret == 0 && !get_ringbuffer_interrupt_mask(&channel->outbound))
@@ -848,7 +848,7 @@ int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 	sg_set_buf(&bufferlist[2], &aligned_data,
 		packetlen_aligned - packetlen);
 
-	ret = ringbuffer_write(&channel->outbound, bufferlist, 3);
+	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3);
 
 	/* TODO: We should determine if this is optional */
 	if (ret == 0 && !get_ringbuffer_interrupt_mask(&channel->outbound))
diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
index 9bab40c..483678c 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -341,13 +341,13 @@ void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info)
 /*++
 
 Name:
-	ringbuffer_write()
+	hv_ringbuffer_write()
 
 Description:
 	Write to the ring buffer
 
 --*/
-int ringbuffer_write(struct hv_ring_buffer_info *outring_info,
+int hv_ringbuffer_write(struct hv_ring_buffer_info *outring_info,
 		    struct scatterlist *sglist, u32 sgcount)
 {
 	int i = 0;
diff --git a/drivers/staging/hv/ring_buffer.h b/drivers/staging/hv/ring_buffer.h
index 66d9a2d..5c17288 100644
--- a/drivers/staging/hv/ring_buffer.h
+++ b/drivers/staging/hv/ring_buffer.h
@@ -81,7 +81,7 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info, void *buffer,
 
 void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info);
 
-int ringbuffer_write(struct hv_ring_buffer_info *ring_info,
+int hv_ringbuffer_write(struct hv_ring_buffer_info *ring_info,
 		    struct scatterlist *sglist,
 		    u32 sgcount);
 
-- 
1.7.4.1

