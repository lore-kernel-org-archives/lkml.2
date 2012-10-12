Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715Ab2JLUCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 16:02:37 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:49634
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562Ab2JLUCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:02:34 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3/3] Drivers: hv: Get rid of hv_ringbuffer_cleanup()
Date: Fri, 12 Oct 2012 13:22:43 -0700
Message-Id: <1350073363-10614-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1350073363-10614-1-git-send-email-kys@microsoft.com>
References: <1350073335-10575-1-git-send-email-kys@microsoft.com>
 <1350073363-10614-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hv_ringbuffer_cleanup() is an empty function; get rid of it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Reported-by: Jason Wang <jasowang@redhat.com>
---
 drivers/hv/channel.c      |    4 ----
 drivers/hv/hyperv_vmbus.h |    1 -
 drivers/hv/ring_buffer.c  |   11 -----------
 3 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 773a2f2..2edb440 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -529,10 +529,6 @@ void vmbus_close(struct vmbus_channel *channel)
 		vmbus_teardown_gpadl(channel,
 					  channel->ringbuffer_gpadlhandle);
 
-	/* Cleanup the ring buffers for this channel */
-	hv_ringbuffer_cleanup(&channel->outbound);
-	hv_ringbuffer_cleanup(&channel->inbound);
-
 	free_pages((unsigned long)channel->ringbuffer_pages,
 		get_order(channel->ringbuffer_pagecount * PAGE_SIZE));
 
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index d8d1fad..d46f88e 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -551,7 +551,6 @@ extern void hv_synic_cleanup(void *arg);
 int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info, void *buffer,
 		   u32 buflen);
 
-void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info);
 
 int hv_ringbuffer_write(struct hv_ring_buffer_info *ring_info,
 		    struct scatterlist *sglist,
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 7233c88..25caf42 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -281,17 +281,6 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 
 /*
  *
- * hv_ringbuffer_cleanup()
- *
- * Cleanup the ring buffer
- *
- */
-void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info)
-{
-}
-
-/*
- *
  * hv_ringbuffer_write()
  *
  * Write to the ring buffer
-- 
1.7.4.1

