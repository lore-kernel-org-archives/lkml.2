Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab1EIVuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:50:08 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:48769
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755063Ab1EIVox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:53 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 100/206] Staging: hv: Rename get_ringbuffer_interrupt_mask
Date: Mon,  9 May 2011 14:56:22 -0700
Message-Id: <1304978288-22999-100-git-send-email-kys@microsoft.com>
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
 drivers/staging/hv/channel.c     |    6 +++---
 drivers/staging/hv/ring_buffer.c |    4 ++--
 drivers/staging/hv/ring_buffer.h |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 9f8bed2..3274b29 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -721,7 +721,7 @@ int vmbus_sendpacket(struct vmbus_channel *channel, const void *buffer,
 	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3);
 
 	/* TODO: We should determine if this is optional */
-	if (ret == 0 && !get_ringbuffer_interrupt_mask(&channel->outbound))
+	if (ret == 0 && !hv_get_ringbuffer_interrupt_mask(&channel->outbound))
 		vmbus_setevent(channel);
 
 	return ret;
@@ -786,7 +786,7 @@ int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
 	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3);
 
 	/* TODO: We should determine if this is optional */
-	if (ret == 0 && !get_ringbuffer_interrupt_mask(&channel->outbound))
+	if (ret == 0 && !hv_get_ringbuffer_interrupt_mask(&channel->outbound))
 		vmbus_setevent(channel);
 
 	return ret;
@@ -851,7 +851,7 @@ int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 	ret = hv_ringbuffer_write(&channel->outbound, bufferlist, 3);
 
 	/* TODO: We should determine if this is optional */
-	if (ret == 0 && !get_ringbuffer_interrupt_mask(&channel->outbound))
+	if (ret == 0 && !hv_get_ringbuffer_interrupt_mask(&channel->outbound))
 		vmbus_setevent(channel);
 
 	return ret;
diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
index 2a05059..013b7a5 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -285,13 +285,13 @@ void ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
 /*++
 
 Name:
-	get_ringbuffer_interrupt_mask()
+	hv_get_ringbuffer_interrupt_mask()
 
 Description:
 	Get the interrupt mask for the specified ring buffer
 
 --*/
-u32 get_ringbuffer_interrupt_mask(struct hv_ring_buffer_info *rbi)
+u32 hv_get_ringbuffer_interrupt_mask(struct hv_ring_buffer_info *rbi)
 {
 	return rbi->ring_buffer->interrupt_mask;
 }
diff --git a/drivers/staging/hv/ring_buffer.h b/drivers/staging/hv/ring_buffer.h
index 0ebf3be..6454105 100644
--- a/drivers/staging/hv/ring_buffer.h
+++ b/drivers/staging/hv/ring_buffer.h
@@ -93,7 +93,7 @@ int hv_ringbuffer_read(struct hv_ring_buffer_info *ring_info,
 		   u32 buflen,
 		   u32 offset);
 
-u32 get_ringbuffer_interrupt_mask(struct hv_ring_buffer_info *ring_info);
+u32 hv_get_ringbuffer_interrupt_mask(struct hv_ring_buffer_info *ring_info);
 
 void dump_ring_info(struct hv_ring_buffer_info *ring_info, char *prefix);
 
-- 
1.7.4.1

