Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199Ab1EIVo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:44:57 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47611
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755039Ab1EIVow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 096/206] Staging: hv: Rename ringbuffer_cleanup
Date: Mon,  9 May 2011 14:56:18 -0700
Message-Id: <1304978288-22999-96-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename ringbuffer_cleanup.


Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/channel.c     |    8 ++++----
 drivers/staging/hv/ring_buffer.c |    4 ++--
 drivers/staging/hv/ring_buffer.h |    2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 43e54b5..44b81e8 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -292,8 +292,8 @@ Cleanup:
 	return err;
 
 errorout:
-	ringbuffer_cleanup(&newchannel->outbound);
-	ringbuffer_cleanup(&newchannel->inbound);
+	hv_ringbuffer_cleanup(&newchannel->outbound);
+	hv_ringbuffer_cleanup(&newchannel->inbound);
 	free_pages((unsigned long)out,
 		get_order(send_ringbuffer_size + recv_ringbuffer_size));
 	kfree(openInfo);
@@ -651,8 +651,8 @@ void vmbus_close(struct vmbus_channel *channel)
 	/* TODO: Send a msg to release the childRelId */
 
 	/* Cleanup the ring buffers for this channel */
-	ringbuffer_cleanup(&channel->outbound);
-	ringbuffer_cleanup(&channel->inbound);
+	hv_ringbuffer_cleanup(&channel->outbound);
+	hv_ringbuffer_cleanup(&channel->inbound);
 
 	free_pages((unsigned long)channel->ringbuffer_pages,
 		get_order(channel->ringbuffer_pagecount * PAGE_SIZE));
diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
index 9653ab5..9bab40c 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -328,13 +328,13 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 /*++
 
 Name:
-	ringbuffer_cleanup()
+	hv_ringbuffer_cleanup()
 
 Description:
 	Cleanup the ring buffer
 
 --*/
-void ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info)
+void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info)
 {
 }
 
diff --git a/drivers/staging/hv/ring_buffer.h b/drivers/staging/hv/ring_buffer.h
index 3c66dc0..66d9a2d 100644
--- a/drivers/staging/hv/ring_buffer.h
+++ b/drivers/staging/hv/ring_buffer.h
@@ -79,7 +79,7 @@ struct hv_ring_buffer_debug_info {
 int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info, void *buffer,
 		   u32 buflen);
 
-void ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info);
+void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info);
 
 int ringbuffer_write(struct hv_ring_buffer_info *ring_info,
 		    struct scatterlist *sglist,
-- 
1.7.4.1

