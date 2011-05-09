Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332Ab1EIVvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:51:39 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:47663
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755055Ab1EIVox (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:44:53 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>,
        Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 104/206] Staging: hv: Cleanup comments in ring_buffer.c
Date: Mon,  9 May 2011 14:56:26 -0700
Message-Id: <1304978288-22999-104-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1304978288-22999-1-git-send-email-kys@microsoft.com>
References: <1304978242-22958-1-git-send-email-kys@microsoft.com>
 <1304978288-22999-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup comments in ring_buffer.c

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
---
 drivers/staging/hv/ring_buffer.c |  323 +++++++++++++++-----------------------
 1 files changed, 129 insertions(+), 194 deletions(-)

diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
index f4707f8..8544516 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -18,6 +18,7 @@
  * Authors:
  *   Haiyang Zhang <haiyangz@microsoft.com>
  *   Hank Janssen  <hjanssen@microsoft.com>
+ *   K. Y. Srinivasan <kys@microsoft.com>
  *
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -35,16 +36,13 @@
 #define BYTES_AVAIL_TO_WRITE(r, w, z) ((w) >= (r)) ? ((z) - ((w) - (r))) : ((r) - (w))
 
 
-/*++
-
-Name:
-	hv_get_ringbuffer_availbytes()
-
-Description:
-	Get number of bytes available to read and to write to
-	for the specified ring buffer
-
---*/
+/*
+ *
+ * hv_get_ringbuffer_availbytes()
+ *
+ * Get number of bytes available to read and to write to
+ * for the specified ring buffer
+ */
 static inline void
 hv_get_ringbuffer_availbytes(struct hv_ring_buffer_info *rbi,
 			  u32 *read, u32 *write)
@@ -59,34 +57,26 @@ hv_get_ringbuffer_availbytes(struct hv_ring_buffer_info *rbi,
 	*read = rbi->ring_datasize - *write;
 }
 
-/*++
-
-Name:
-	hv_get_next_write_location()
-
-Description:
-	Get the next write location for the specified ring buffer
-
---*/
+/*
+ * hv_get_next_write_location()
+ *
+ * Get the next write location for the specified ring buffer
+ *
+ */
 static inline u32
 hv_get_next_write_location(struct hv_ring_buffer_info *ring_info)
 {
 	u32 next = ring_info->ring_buffer->write_index;
 
-	/* ASSERT(next < ring_info->RingDataSize); */
-
 	return next;
 }
 
-/*++
-
-Name:
-	hv_set_next_write_location()
-
-Description:
-	Set the next write location for the specified ring buffer
-
---*/
+/*
+ * hv_set_next_write_location()
+ *
+ * Set the next write location for the specified ring buffer
+ *
+ */
 static inline void
 hv_set_next_write_location(struct hv_ring_buffer_info *ring_info,
 		     u32 next_write_location)
@@ -94,57 +84,44 @@ hv_set_next_write_location(struct hv_ring_buffer_info *ring_info,
 	ring_info->ring_buffer->write_index = next_write_location;
 }
 
-/*++
-
-Name:
-	hv_get_next_read_location()
-
-Description:
-	Get the next read location for the specified ring buffer
-
---*/
+/*
+ * hv_get_next_read_location()
+ *
+ * Get the next read location for the specified ring buffer
+ */
 static inline u32
 hv_get_next_read_location(struct hv_ring_buffer_info *ring_info)
 {
 	u32 next = ring_info->ring_buffer->read_index;
 
-	/* ASSERT(next < ring_info->RingDataSize); */
-
 	return next;
 }
 
-/*++
-
-Name:
-	hv_get_next_readlocation_withoffset()
-
-Description:
-	Get the next read location + offset for the specified ring buffer.
-	This allows the caller to skip
-
---*/
+/*
+ * hv_get_next_readlocation_withoffset()
+ *
+ * Get the next read location + offset for the specified ring buffer.
+ * This allows the caller to skip
+ */
 static inline u32
 hv_get_next_readlocation_withoffset(struct hv_ring_buffer_info *ring_info,
 				 u32 offset)
 {
 	u32 next = ring_info->ring_buffer->read_index;
 
-	/* ASSERT(next < ring_info->RingDataSize); */
 	next += offset;
 	next %= ring_info->ring_datasize;
 
 	return next;
 }
 
-/*++
-
-Name:
-	hv_set_next_read_location()
-
-Description:
-	Set the next read location for the specified ring buffer
-
---*/
+/*
+ *
+ * hv_set_next_read_location()
+ *
+ * Set the next read location for the specified ring buffer
+ *
+ */
 static inline void
 hv_set_next_read_location(struct hv_ring_buffer_info *ring_info,
 		    u32 next_read_location)
@@ -153,15 +130,12 @@ hv_set_next_read_location(struct hv_ring_buffer_info *ring_info,
 }
 
 
-/*++
-
-Name:
-	hv_get_ring_buffer()
-
-Description:
-	Get the start of the ring buffer
-
---*/
+/*
+ *
+ * hv_get_ring_buffer()
+ *
+ * Get the start of the ring buffer
+ */
 static inline void *
 hv_get_ring_buffer(struct hv_ring_buffer_info *ring_info)
 {
@@ -169,30 +143,25 @@ hv_get_ring_buffer(struct hv_ring_buffer_info *ring_info)
 }
 
 
-/*++
-
-Name:
-	hv_get_ring_buffersize()
-
-Description:
-	Get the size of the ring buffer
-
---*/
+/*
+ *
+ * hv_get_ring_buffersize()
+ *
+ * Get the size of the ring buffer
+ */
 static inline u32
 hv_get_ring_buffersize(struct hv_ring_buffer_info *ring_info)
 {
 	return ring_info->ring_datasize;
 }
 
-/*++
-
-Name:
-	hv_get_ring_bufferindices()
-
-Description:
-	Get the read and write indices as u64 of the specified ring buffer
-
---*/
+/*
+ *
+ * hv_get_ring_bufferindices()
+ *
+ * Get the read and write indices as u64 of the specified ring buffer
+ *
+ */
 static inline u64
 hv_get_ring_bufferindices(struct hv_ring_buffer_info *ring_info)
 {
@@ -200,15 +169,13 @@ hv_get_ring_bufferindices(struct hv_ring_buffer_info *ring_info)
 }
 
 
-/*++
-
-Name:
-	hv_dump_ring_info()
-
-Description:
-	Dump out to console the ring buffer info
-
---*/
+/*
+ *
+ * hv_dump_ring_info()
+ *
+ * Dump out to console the ring buffer info
+ *
+ */
 void hv_dump_ring_info(struct hv_ring_buffer_info *ring_info, char *prefix)
 {
 	u32 bytes_avail_towrite;
@@ -232,7 +199,6 @@ void hv_dump_ring_info(struct hv_ring_buffer_info *ring_info, char *prefix)
 }
 
 
-/* Internal routines */
 
 static u32
 hv_copyto_ringbuffer(
@@ -250,15 +216,13 @@ hv_copyfrom_ringbuffer(
 
 
 
-/*++
-
-Name:
-	hv_ringbuffer_get_debuginfo()
-
-Description:
-	Get various debug metrics for the specified ring buffer
-
---*/
+/*
+ *
+ * hv_ringbuffer_get_debuginfo()
+ *
+ * Get various debug metrics for the specified ring buffer
+ *
+ */
 void hv_ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
 			    struct hv_ring_buffer_debug_info *debug_info)
 {
@@ -282,29 +246,25 @@ void hv_ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
 }
 
 
-/*++
-
-Name:
-	hv_get_ringbuffer_interrupt_mask()
-
-Description:
-	Get the interrupt mask for the specified ring buffer
-
---*/
+/*
+ *
+ * hv_get_ringbuffer_interrupt_mask()
+ *
+ * Get the interrupt mask for the specified ring buffer
+ *
+ */
 u32 hv_get_ringbuffer_interrupt_mask(struct hv_ring_buffer_info *rbi)
 {
 	return rbi->ring_buffer->interrupt_mask;
 }
 
-/*++
-
-Name:
-	hv_ringbuffer_init()
-
-Description:
-	Initialize the ring buffer
-
---*/
+/*
+ *
+ * hv_ringbuffer_init()
+ *
+ *Initialize the ring buffer
+ *
+ */
 int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 		   void *buffer, u32 buflen)
 {
@@ -325,28 +285,24 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 	return 0;
 }
 
-/*++
-
-Name:
-	hv_ringbuffer_cleanup()
-
-Description:
-	Cleanup the ring buffer
-
---*/
+/*
+ *
+ * hv_ringbuffer_cleanup()
+ *
+ * Cleanup the ring buffer
+ *
+ */
 void hv_ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info)
 {
 }
 
-/*++
-
-Name:
-	hv_ringbuffer_write()
-
-Description:
-	Write to the ring buffer
-
---*/
+/*
+ *
+ * hv_ringbuffer_write()
+ *
+ * Write to the ring buffer
+ *
+ */
 int hv_ringbuffer_write(struct hv_ring_buffer_info *outring_info,
 		    struct scatterlist *sglist, u32 sgcount)
 {
@@ -373,7 +329,6 @@ int hv_ringbuffer_write(struct hv_ring_buffer_info *outring_info,
 				&bytes_avail_toread,
 				&bytes_avail_towrite);
 
-	/* Dumpring_info(Outring_info, "BEFORE "); */
 
 	/* If there is only room for the packet, assume it is full. */
 	/* Otherwise, the next time around, we think the ring buffer */
@@ -408,22 +363,19 @@ int hv_ringbuffer_write(struct hv_ring_buffer_info *outring_info,
 	/* Now, update the write location */
 	hv_set_next_write_location(outring_info, next_write_location);
 
-	/* Dumpring_info(Outring_info, "AFTER "); */
 
 	spin_unlock_irqrestore(&outring_info->ring_lock, flags);
 	return 0;
 }
 
 
-/*++
-
-Name:
-	hv_ringbuffer_peek()
-
-Description:
-	Read without advancing the read index
-
---*/
+/*
+ *
+ * hv_ringbuffer_peek()
+ *
+ * Read without advancing the read index
+ *
+ */
 int hv_ringbuffer_peek(struct hv_ring_buffer_info *Inring_info,
 		   void *Buffer, u32 buflen)
 {
@@ -440,11 +392,6 @@ int hv_ringbuffer_peek(struct hv_ring_buffer_info *Inring_info,
 
 	/* Make sure there is something to read */
 	if (bytes_avail_toread < buflen) {
-		/* DPRINT_DBG(VMBUS,
-			"got callback but not enough to read "
-			"<avail to read %d read size %d>!!",
-			bytes_avail_toread,
-			BufferLen); */
 
 		spin_unlock_irqrestore(&Inring_info->ring_lock, flags);
 
@@ -465,15 +412,13 @@ int hv_ringbuffer_peek(struct hv_ring_buffer_info *Inring_info,
 }
 
 
-/*++
-
-Name:
-	hv_ringbuffer_read()
-
-Description:
-	Read and advance the read index
-
---*/
+/*
+ *
+ * hv_ringbuffer_read()
+ *
+ * Read and advance the read index
+ *
+ */
 int hv_ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
 		   u32 buflen, u32 offset)
 {
@@ -492,8 +437,6 @@ int hv_ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
 				&bytes_avail_toread,
 				&bytes_avail_towrite);
 
-	/* Dumpring_info(Inring_info, "BEFORE "); */
-
 	/* Make sure there is something to read */
 	if (bytes_avail_toread < buflen) {
 		spin_unlock_irqrestore(&inring_info->ring_lock, flags);
@@ -522,24 +465,20 @@ int hv_ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
 	/* Update the read index */
 	hv_set_next_read_location(inring_info, next_read_location);
 
-	/* Dumpring_info(Inring_info, "AFTER "); */
-
 	spin_unlock_irqrestore(&inring_info->ring_lock, flags);
 
 	return 0;
 }
 
 
-/*++
-
-Name:
-	hv_copyto_ringbuffer()
-
-Description:
-	Helper routine to copy from source to ring buffer.
-	Assume there is enough room. Handles wrap-around in dest case only!!
-
---*/
+/*
+ *
+ * hv_copyto_ringbuffer()
+ *
+ * Helper routine to copy from source to ring buffer.
+ * Assume there is enough room. Handles wrap-around in dest case only!!
+ *
+ */
 static u32
 hv_copyto_ringbuffer(
 	struct hv_ring_buffer_info	*ring_info,
@@ -566,16 +505,14 @@ hv_copyto_ringbuffer(
 }
 
 
-/*++
-
-Name:
-	hv_copyfrom_ringbuffer()
-
-Description:
-	Helper routine to copy to source from ring buffer.
-	Assume there is enough room. Handles wrap-around in src case only!!
-
---*/
+/*
+ *
+ * hv_copyfrom_ringbuffer()
+ *
+ * Helper routine to copy to source from ring buffer.
+ * Assume there is enough room. Handles wrap-around in src case only!!
+ *
+ */
 static u32
 hv_copyfrom_ringbuffer(
 	struct hv_ring_buffer_info	*ring_info,
@@ -605,5 +542,3 @@ hv_copyfrom_ringbuffer(
 	return start_read_offset;
 }
 
-
-/* eof */
-- 
1.7.4.1

