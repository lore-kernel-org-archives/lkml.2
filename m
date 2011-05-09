Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1EJJhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 05:37:32 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:42293
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752644Ab1EJJha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 05:37:30 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 187/206] Staging: hv: Get rid of channel.h
Date: Mon,  9 May 2011 14:57:49 -0700
Message-Id: <1304978288-22999-187-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, get rid of channel.h.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/channel.h |  112 ------------------------------------------
 1 files changed, 0 insertions(+), 112 deletions(-)
 delete mode 100644 drivers/staging/hv/channel.h

diff --git a/drivers/staging/hv/channel.h b/drivers/staging/hv/channel.h
deleted file mode 100644
index de4f867..0000000
--- a/drivers/staging/hv/channel.h
+++ /dev/null
@@ -1,112 +0,0 @@
-/*
- *
- * Copyright (c) 2009, Microsoft Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc., 59 Temple
- * Place - Suite 330, Boston, MA 02111-1307 USA.
- *
- * Authors:
- *   Haiyang Zhang <haiyangz@microsoft.com>
- *   Hank Janssen  <hjanssen@microsoft.com>
- *
- */
-
-
-#ifndef _CHANNEL_H_
-#define _CHANNEL_H_
-
-#include "channel_mgmt.h"
-
-/* The format must be the same as struct vmdata_gpa_direct */
-struct vmbus_channel_packet_page_buffer {
-	u16 type;
-	u16 dataoffset8;
-	u16 length8;
-	u16 flags;
-	u64 transactionid;
-	u32 reserved;
-	u32 rangecount;
-	struct hv_page_buffer range[MAX_PAGE_BUFFER_COUNT];
-} __packed;
-
-/* The format must be the same as struct vmdata_gpa_direct */
-struct vmbus_channel_packet_multipage_buffer {
-	u16 type;
-	u16 dataoffset8;
-	u16 length8;
-	u16 flags;
-	u64 transactionid;
-	u32 reserved;
-	u32 rangecount;		/* Always 1 in this case */
-	struct hv_multipage_buffer range;
-} __packed;
-
-
-extern int vmbus_open(struct vmbus_channel *channel,
-			    u32 send_ringbuffersize,
-			    u32 recv_ringbuffersize,
-			    void *userdata,
-			    u32 userdatalen,
-			    void(*onchannel_callback)(void *context),
-			    void *context);
-
-extern void vmbus_close(struct vmbus_channel *channel);
-
-extern int vmbus_sendpacket(struct vmbus_channel *channel,
-				  const void *buffer,
-				  u32 bufferLen,
-				  u64 requestid,
-				  enum vmbus_packet_type type,
-				  u32 flags);
-
-extern int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
-					    struct hv_page_buffer pagebuffers[],
-					    u32 pagecount,
-					    void *buffer,
-					    u32 bufferlen,
-					    u64 requestid);
-
-extern int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
-					struct hv_multipage_buffer *mpb,
-					void *buffer,
-					u32 bufferlen,
-					u64 requestid);
-
-extern int vmbus_establish_gpadl(struct vmbus_channel *channel,
-				      void *kbuffer,
-				      u32 size,
-				      u32 *gpadl_handle);
-
-extern int vmbus_teardown_gpadl(struct vmbus_channel *channel,
-				     u32 gpadl_handle);
-
-extern int vmbus_recvpacket(struct vmbus_channel *channel,
-				  void *buffer,
-				  u32 bufferlen,
-				  u32 *buffer_actual_len,
-				  u64 *requestid);
-
-extern int vmbus_recvpacket_raw(struct vmbus_channel *channel,
-				     void *buffer,
-				     u32 bufferlen,
-				     u32 *buffer_actual_len,
-				     u64 *requestid);
-
-extern void vmbus_onchannel_event(struct vmbus_channel *channel);
-
-extern void vmbus_get_debug_info(struct vmbus_channel *channel,
-				     struct vmbus_channel_debug_info *debug);
-
-extern void vmbus_ontimer(unsigned long data);
-
-#endif /* _CHANNEL_H_ */
-- 
1.7.4.1

