Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab2LAO1l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 09:27:41 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:46237
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab2LAOXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 09:23:39 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 06/28] Drivers: hv: Get rid of hv_get_ringbuffer_interrupt_mask()
Date: Sat,  1 Dec 2012 06:46:37 -0800
Message-Id: <1354373219-31374-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1354373219-31374-1-git-send-email-kys@microsoft.com>
References: <1354373160-31332-1-git-send-email-kys@microsoft.com>
 <1354373219-31374-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is no longer used; get rid of it.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hyperv_vmbus.h |    1 -
 drivers/hv/ring_buffer.c  |   13 -------------
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index 895c898..ac1e419 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -565,7 +565,6 @@ int hv_ringbuffer_read(struct hv_ring_buffer_info *ring_info,
 		   u32 buflen,
 		   u32 offset);
 
-u32 hv_get_ringbuffer_interrupt_mask(struct hv_ring_buffer_info *ring_info);
 
 void hv_ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
 			    struct hv_ring_buffer_debug_info *debug_info);
diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 9bc55f0..2a0babc 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -294,19 +294,6 @@ void hv_ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
 	}
 }
 
-
-/*
- *
- * hv_get_ringbuffer_interrupt_mask()
- *
- * Get the interrupt mask for the specified ring buffer
- *
- */
-u32 hv_get_ringbuffer_interrupt_mask(struct hv_ring_buffer_info *rbi)
-{
-	return rbi->ring_buffer->interrupt_mask;
-}
-
 /*
  *
  * hv_ringbuffer_init()
-- 
1.7.4.1

