Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab1EIVo6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:44:58 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:54355
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755045Ab1EIVow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 099/206] Staging: hv: Rename ringbuffer_read
Date: Mon,  9 May 2011 14:56:21 -0700
Message-Id: <1304978288-22999-99-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject line says it all.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/channel.c     |    4 ++--
 drivers/staging/hv/ring_buffer.c |    4 ++--
 drivers/staging/hv/ring_buffer.h |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index d625517..9f8bed2 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -911,7 +911,7 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 	*requestid = desc.trans_id;
 
 	/* Copy over the packet to the user buffer */
-	ret = ringbuffer_read(&channel->inbound, buffer, userlen,
+	ret = hv_ringbuffer_read(&channel->inbound, buffer, userlen,
 			     (desc.offset8 << 3));
 
 	spin_unlock_irqrestore(&channel->inbound_lock, flags);
@@ -964,7 +964,7 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 	*requestid = desc.trans_id;
 
 	/* Copy over the entire packet to the user buffer */
-	ret = ringbuffer_read(&channel->inbound, buffer, packetlen, 0);
+	ret = hv_ringbuffer_read(&channel->inbound, buffer, packetlen, 0);
 
 	spin_unlock_irqrestore(&channel->inbound_lock, flags);
 	return 0;
diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
index bf04397..2a05059 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -468,13 +468,13 @@ int hv_ringbuffer_peek(struct hv_ring_buffer_info *Inring_info,
 /*++
 
 Name:
-	ringbuffer_read()
+	hv_ringbuffer_read()
 
 Description:
 	Read and advance the read index
 
 --*/
-int ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
+int hv_ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
 		   u32 buflen, u32 offset)
 {
 	u32 bytes_avail_towrite;
diff --git a/drivers/staging/hv/ring_buffer.h b/drivers/staging/hv/ring_buffer.h
index c684d97..0ebf3be 100644
--- a/drivers/staging/hv/ring_buffer.h
+++ b/drivers/staging/hv/ring_buffer.h
@@ -88,7 +88,7 @@ int hv_ringbuffer_write(struct hv_ring_buffer_info *ring_info,
 int hv_ringbuffer_peek(struct hv_ring_buffer_info *ring_info, void *buffer,
 		   u32 buflen);
 
-int ringbuffer_read(struct hv_ring_buffer_info *ring_info,
+int hv_ringbuffer_read(struct hv_ring_buffer_info *ring_info,
 		   void *buffer,
 		   u32 buflen,
 		   u32 offset);
-- 
1.7.4.1

