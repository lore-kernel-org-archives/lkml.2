Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab1EIVwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:52:04 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47647
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755048Ab1EIVow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 102/206] Staging: hv: Rename ringbuffer_get_debuginfo
Date: Mon,  9 May 2011 14:56:24 -0700
Message-Id: <1304978288-22999-102-git-send-email-kys@microsoft.com>
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
index be4e004..5fcf9d3 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -162,8 +162,8 @@ void vmbus_get_debug_info(struct vmbus_channel *channel,
 			monitorpage->parameter[monitor_group]
 					[monitor_offset].connectionid.u.id;
 
-	ringbuffer_get_debuginfo(&channel->inbound, &debuginfo->inbound);
-	ringbuffer_get_debuginfo(&channel->outbound, &debuginfo->outbound);
+	hv_ringbuffer_get_debuginfo(&channel->inbound, &debuginfo->inbound);
+	hv_ringbuffer_get_debuginfo(&channel->outbound, &debuginfo->outbound);
 }
 
 /*
diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
index abf0091..7fbadb1 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -253,13 +253,13 @@ copyfrom_ringbuffer(
 /*++
 
 Name:
-	ringbuffer_get_debuginfo()
+	hv_ringbuffer_get_debuginfo()
 
 Description:
 	Get various debug metrics for the specified ring buffer
 
 --*/
-void ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
+void hv_ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
 			    struct hv_ring_buffer_debug_info *debug_info)
 {
 	u32 bytes_avail_towrite;
diff --git a/drivers/staging/hv/ring_buffer.h b/drivers/staging/hv/ring_buffer.h
index 61470a3..1bc0b8a 100644
--- a/drivers/staging/hv/ring_buffer.h
+++ b/drivers/staging/hv/ring_buffer.h
@@ -97,7 +97,7 @@ u32 hv_get_ringbuffer_interrupt_mask(struct hv_ring_buffer_info *ring_info);
 
 void hv_dump_ring_info(struct hv_ring_buffer_info *ring_info, char *prefix);
 
-void ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
+void hv_ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
 			    struct hv_ring_buffer_debug_info *debug_info);
 
 #endif /* _RING_BUFFER_H_ */
-- 
1.7.4.1

