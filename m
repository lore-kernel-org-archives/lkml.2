Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab1EJIr2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:47:28 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:53145
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756026Ab1EJIau (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:30:50 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 155/206] Staging: hv: Include the contents of ring_buffer.h
Date: Mon,  9 May 2011 14:57:17 -0700
Message-Id: <1304978288-22999-155-git-send-email-kys@microsoft.com>
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
 include/linux/hyperv.h |   45 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 44 insertions(+), 1 deletions(-)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 932aafa..d0eec1d 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -30,7 +30,50 @@
 #include <linux/timer.h>
 #include <linux/workqueue.h>
 #include <linux/completion.h>
-#include "ring_buffer.h"
+#include <linux/scatterlist.h>
+
+struct hv_ring_buffer {
+	/* Offset in bytes from the start of ring data below */
+	u32 write_index;
+
+	/* Offset in bytes from the start of ring data below */
+	u32 read_index;
+
+	u32 interrupt_mask;
+
+	/* Pad it to PAGE_SIZE so that data starts on page boundary */
+	u8	reserved[4084];
+
+	/* NOTE:
+	 * The interrupt_mask field is used only for channels but since our
+	 * vmbus connection also uses this data structure and its data starts
+	 * here, we commented out this field.
+	 */
+
+	/*
+	 * Ring data starts here + RingDataStartOffset
+	 * !!! DO NOT place any fields below this !!!
+	 */
+	u8 buffer[0];
+} __packed;
+
+struct hv_ring_buffer_info {
+	struct hv_ring_buffer *ring_buffer;
+	u32 ring_size;			/* Include the shared header */
+	spinlock_t ring_lock;
+
+	u32 ring_datasize;		/* < ring_size */
+	u32 ring_data_startoffset;
+};
+
+struct hv_ring_buffer_debug_info {
+	u32 current_interrupt_mask;
+	u32 current_read_index;
+	u32 current_write_index;
+	u32 bytes_avail_toread;
+	u32 bytes_avail_towrite;
+};
+
 #include "vmbus_channel_interface.h"
 #include "vmbus_packet_format.h"
 
-- 
1.7.4.1

