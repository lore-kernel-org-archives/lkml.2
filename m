Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab1EJIii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:38:38 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:35445
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756080Ab1EJIaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:52 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 194/206] Staging: hv: Get rid of ring_buffer.h
Date: Mon,  9 May 2011 14:57:56 -0700
Message-Id: <1304978288-22999-194-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now get rid of ring_buffer.h.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/ring_buffer.h |  102 --------------------------------------
 1 files changed, 0 insertions(+), 102 deletions(-)
 delete mode 100644 drivers/staging/hv/ring_buffer.h

diff --git a/drivers/staging/hv/ring_buffer.h b/drivers/staging/hv/ring_buffer.h
deleted file mode 100644
index 089c536..0000000
--- a/drivers/staging/hv/ring_buffer.h
+++ /dev/null
@@ -1,102 +0,0 @@
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
- *   K. Y. Srinivasan <kys@microsoft.com>
- *
- */
-
-
-#ifndef _RING_BUFFER_H_
-#define _RING_BUFFER_H_
-
-#include <linux/scatterlist.h>
-
-struct hv_ring_buffer {
-	/* Offset in bytes from the start of ring data below */
-	u32 write_index;
-
-	/* Offset in bytes from the start of ring data below */
-	u32 read_index;
-
-	u32 interrupt_mask;
-
-	/* Pad it to PAGE_SIZE so that data starts on page boundary */
-	u8	reserved[4084];
-
-	/* NOTE:
-	 * The interrupt_mask field is used only for channels but since our
-	 * vmbus connection also uses this data structure and its data starts
-	 * here, we commented out this field.
-	 */
-
-	/*
-	 * Ring data starts here + RingDataStartOffset
-	 * !!! DO NOT place any fields below this !!!
-	 */
-	u8 buffer[0];
-} __packed;
-
-struct hv_ring_buffer_info {
-	struct hv_ring_buffer *ring_buffer;
-	u32 ring_size;			/* Include the shared header */
-	spinlock_t ring_lock;
-
-	u32 ring_datasize;		/* < ring_size */
-	u32 ring_data_startoffset;
-};
-
-struct hv_ring_buffer_debug_info {
-	u32 current_interrupt_mask;
-	u32 current_read_index;
-	u32 current_write_index;
-	u32 bytes_avail_toread;
-	u32 bytes_avail_towrite;
-};
-
-
-
-/* Interface */
-
-
-int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info, void *buffer,
-		   u32 buflen);
-
-void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info);
-
-int hv_ringbuffer_write(struct hv_ring_buffer_info *ring_info,
-		    struct scatterlist *sglist,
-		    u32 sgcount);
-
-int hv_ringbuffer_peek(struct hv_ring_buffer_info *ring_info, void *buffer,
-		   u32 buflen);
-
-int hv_ringbuffer_read(struct hv_ring_buffer_info *ring_info,
-		   void *buffer,
-		   u32 buflen,
-		   u32 offset);
-
-u32 hv_get_ringbuffer_interrupt_mask(struct hv_ring_buffer_info *ring_info);
-
-void hv_dump_ring_info(struct hv_ring_buffer_info *ring_info, char *prefix);
-
-void hv_ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
-			    struct hv_ring_buffer_debug_info *debug_info);
-
-#endif /* _RING_BUFFER_H_ */
-- 
1.7.4.1

