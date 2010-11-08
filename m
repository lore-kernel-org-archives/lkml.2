Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab0KHWEM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:04:12 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:46359
	"HELO p3plsmtps2ded01-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755739Ab0KHWDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:03:01 -0500
From: Haiyang Zhang <haiyangz@linuxonhyperv.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 09/10] staging: hv: Convert camel cased local variables in ring_buffer.c to lower cases
Date: Mon,  8 Nov 2010 14:04:46 -0800
Message-Id: <1289253887-2596-9-git-send-email-haiyangz@linuxonhyperv.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1289253887-2596-8-git-send-email-haiyangz@linuxonhyperv.com>
References: <1289253887-2596-1-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-2-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-3-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-4-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-5-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-6-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-7-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-8-git-send-email-haiyangz@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

staging: hv: Convert camel cased local variables in ring_buffer.c to lower cases

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel.c     |    4 +-
 drivers/staging/hv/ring_buffer.c |  337 +++++++++++++++++++-------------------
 drivers/staging/hv/ring_buffer.h |   26 ++--
 3 files changed, 185 insertions(+), 182 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 0e554e9..97db545 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -1052,6 +1052,6 @@ void vmbus_ontimer(unsigned long data)
 static void dump_vmbus_channel(struct vmbus_channel *channel)
 {
 	DPRINT_DBG(VMBUS, "Channel (%d)", channel->offermsg.child_relid);
-	DumpRingInfo(&channel->outbound, "Outbound ");
-	DumpRingInfo(&channel->inbound, "Inbound ");
+	Dumpring_info(&channel->outbound, "Outbound ");
+	Dumpring_info(&channel->inbound, "Inbound ");
 }
diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
index 6095cc5..705d95f 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -68,11 +68,11 @@ Description:
 
 --*/
 static inline u32
-GetNextWriteLocation(struct hv_ring_buffer_info *RingInfo)
+GetNextWriteLocation(struct hv_ring_buffer_info *ring_info)
 {
-	u32 next = RingInfo->ring_buffer->write_index;
+	u32 next = ring_info->ring_buffer->write_index;
 
-	/* ASSERT(next < RingInfo->RingDataSize); */
+	/* ASSERT(next < ring_info->RingDataSize); */
 
 	return next;
 }
@@ -87,10 +87,10 @@ Description:
 
 --*/
 static inline void
-SetNextWriteLocation(struct hv_ring_buffer_info *RingInfo,
-		     u32 NextWriteLocation)
+SetNextWriteLocation(struct hv_ring_buffer_info *ring_info,
+		     u32 next_write_location)
 {
-	RingInfo->ring_buffer->write_index = NextWriteLocation;
+	ring_info->ring_buffer->write_index = next_write_location;
 }
 
 /*++
@@ -103,11 +103,11 @@ Description:
 
 --*/
 static inline u32
-GetNextReadLocation(struct hv_ring_buffer_info *RingInfo)
+GetNextReadLocation(struct hv_ring_buffer_info *ring_info)
 {
-	u32 next = RingInfo->ring_buffer->read_index;
+	u32 next = ring_info->ring_buffer->read_index;
 
-	/* ASSERT(next < RingInfo->RingDataSize); */
+	/* ASSERT(next < ring_info->RingDataSize); */
 
 	return next;
 }
@@ -123,13 +123,13 @@ Description:
 
 --*/
 static inline u32
-GetNextReadLocationWithOffset(struct hv_ring_buffer_info *RingInfo, u32 Offset)
+GetNextReadLocationWithOffset(struct hv_ring_buffer_info *ring_info, u32 offset)
 {
-	u32 next = RingInfo->ring_buffer->read_index;
+	u32 next = ring_info->ring_buffer->read_index;
 
-	/* ASSERT(next < RingInfo->RingDataSize); */
-	next += Offset;
-	next %= RingInfo->ring_datasize;
+	/* ASSERT(next < ring_info->RingDataSize); */
+	next += offset;
+	next %= ring_info->ring_datasize;
 
 	return next;
 }
@@ -144,9 +144,10 @@ Description:
 
 --*/
 static inline void
-SetNextReadLocation(struct hv_ring_buffer_info *RingInfo, u32 NextReadLocation)
+SetNextReadLocation(struct hv_ring_buffer_info *ring_info,
+		    u32 next_read_location)
 {
-	RingInfo->ring_buffer->read_index = NextReadLocation;
+	ring_info->ring_buffer->read_index = next_read_location;
 }
 
 
@@ -160,9 +161,9 @@ Description:
 
 --*/
 static inline void *
-GetRingBuffer(struct hv_ring_buffer_info *RingInfo)
+GetRingBuffer(struct hv_ring_buffer_info *ring_info)
 {
-	return (void *)RingInfo->ring_buffer->buffer;
+	return (void *)ring_info->ring_buffer->buffer;
 }
 
 
@@ -176,9 +177,9 @@ Description:
 
 --*/
 static inline u32
-GetRingBufferSize(struct hv_ring_buffer_info *RingInfo)
+GetRingBufferSize(struct hv_ring_buffer_info *ring_info)
 {
-	return RingInfo->ring_datasize;
+	return ring_info->ring_datasize;
 }
 
 /*++
@@ -191,41 +192,41 @@ Description:
 
 --*/
 static inline u64
-GetRingBufferIndices(struct hv_ring_buffer_info *RingInfo)
+GetRingBufferIndices(struct hv_ring_buffer_info *ring_info)
 {
-	return (u64)RingInfo->ring_buffer->write_index << 32;
+	return (u64)ring_info->ring_buffer->write_index << 32;
 }
 
 
 /*++
 
 Name:
-	DumpRingInfo()
+	Dumpring_info()
 
 Description:
 	Dump out to console the ring buffer info
 
 --*/
-void DumpRingInfo(struct hv_ring_buffer_info *RingInfo, char *Prefix)
+void Dumpring_info(struct hv_ring_buffer_info *ring_info, char *prefix)
 {
-	u32 bytesAvailToWrite;
-	u32 bytesAvailToRead;
+	u32 bytes_avail_towrite;
+	u32 bytes_avail_toread;
 
-	GetRingBufferAvailBytes(RingInfo,
-	&bytesAvailToRead,
-	&bytesAvailToWrite);
+	GetRingBufferAvailBytes(ring_info,
+	&bytes_avail_toread,
+	&bytes_avail_towrite);
 
 	DPRINT(VMBUS,
 		DEBUG_RING_LVL,
 		"%s <<ringinfo %p buffer %p avail write %u "
 		"avail read %u read idx %u write idx %u>>",
-		Prefix,
-		RingInfo,
-		RingInfo->ring_buffer->buffer,
-		bytesAvailToWrite,
-		bytesAvailToRead,
-		RingInfo->ring_buffer->read_index,
-		RingInfo->ring_buffer->write_index);
+		prefix,
+		ring_info,
+		ring_info->ring_buffer->buffer,
+		bytes_avail_towrite,
+		bytes_avail_toread,
+		ring_info->ring_buffer->read_index,
+		ring_info->ring_buffer->write_index);
 }
 
 
@@ -233,17 +234,17 @@ void DumpRingInfo(struct hv_ring_buffer_info *RingInfo, char *Prefix)
 
 static u32
 CopyToRingBuffer(
-	struct hv_ring_buffer_info	*RingInfo,
-	u32				StartWriteOffset,
-	void				*Src,
-	u32				SrcLen);
+	struct hv_ring_buffer_info	*ring_info,
+	u32				start_write_offset,
+	void				*src,
+	u32				srclen);
 
 static u32
 CopyFromRingBuffer(
-	struct hv_ring_buffer_info	*RingInfo,
-	void				*Dest,
-	u32				DestLen,
-	u32				StartReadOffset);
+	struct hv_ring_buffer_info	*ring_info,
+	void				*dest,
+	u32				destlen,
+	u32				start_read_offset);
 
 
 
@@ -256,25 +257,25 @@ Description:
 	Get various debug metrics for the specified ring buffer
 
 --*/
-void RingBufferGetDebugInfo(struct hv_ring_buffer_info *RingInfo,
+void RingBufferGetDebugInfo(struct hv_ring_buffer_info *ring_info,
 			    struct hv_ring_buffer_debug_info *debug_info)
 {
-	u32 bytesAvailToWrite;
-	u32 bytesAvailToRead;
+	u32 bytes_avail_towrite;
+	u32 bytes_avail_toread;
 
-	if (RingInfo->ring_buffer) {
-		GetRingBufferAvailBytes(RingInfo,
-					&bytesAvailToRead,
-					&bytesAvailToWrite);
+	if (ring_info->ring_buffer) {
+		GetRingBufferAvailBytes(ring_info,
+					&bytes_avail_toread,
+					&bytes_avail_towrite);
 
-		debug_info->bytes_avail_toread = bytesAvailToRead;
-		debug_info->bytes_avail_towrite = bytesAvailToWrite;
+		debug_info->bytes_avail_toread = bytes_avail_toread;
+		debug_info->bytes_avail_towrite = bytes_avail_towrite;
 		debug_info->current_read_index =
-			RingInfo->ring_buffer->read_index;
+			ring_info->ring_buffer->read_index;
 		debug_info->current_write_index =
-			RingInfo->ring_buffer->write_index;
+			ring_info->ring_buffer->write_index;
 		debug_info->current_interrupt_mask =
-			RingInfo->ring_buffer->interrupt_mask;
+			ring_info->ring_buffer->interrupt_mask;
 	}
 }
 
@@ -302,21 +303,22 @@ Description:
 	Initialize the ring buffer
 
 --*/
-int RingBufferInit(struct hv_ring_buffer_info *RingInfo, void *Buffer, u32 BufferLen)
+int RingBufferInit(struct hv_ring_buffer_info *ring_info,
+		   void *buffer, u32 buflen)
 {
 	if (sizeof(struct hv_ring_buffer) != PAGE_SIZE)
 		return -EINVAL;
 
-	memset(RingInfo, 0, sizeof(struct hv_ring_buffer_info));
+	memset(ring_info, 0, sizeof(struct hv_ring_buffer_info));
 
-	RingInfo->ring_buffer = (struct hv_ring_buffer *)Buffer;
-	RingInfo->ring_buffer->read_index =
-		RingInfo->ring_buffer->write_index = 0;
+	ring_info->ring_buffer = (struct hv_ring_buffer *)buffer;
+	ring_info->ring_buffer->read_index =
+		ring_info->ring_buffer->write_index = 0;
 
-	RingInfo->ring_size = BufferLen;
-	RingInfo->ring_datasize = BufferLen - sizeof(struct hv_ring_buffer);
+	ring_info->ring_size = buflen;
+	ring_info->ring_datasize = buflen - sizeof(struct hv_ring_buffer);
 
-	spin_lock_init(&RingInfo->ring_lock);
+	spin_lock_init(&ring_info->ring_lock);
 
 	return 0;
 }
@@ -330,7 +332,7 @@ Description:
 	Cleanup the ring buffer
 
 --*/
-void RingBufferCleanup(struct hv_ring_buffer_info *RingInfo)
+void RingBufferCleanup(struct hv_ring_buffer_info *ring_info)
 {
 }
 
@@ -343,78 +345,78 @@ Description:
 	Write to the ring buffer
 
 --*/
-int RingBufferWrite(struct hv_ring_buffer_info *OutRingInfo,
+int RingBufferWrite(struct hv_ring_buffer_info *outring_info,
 		    struct scatterlist *sglist, u32 sgcount)
 {
 	int i = 0;
-	u32 byteAvailToWrite;
-	u32 byteAvailToRead;
-	u32 totalBytesToWrite = 0;
+	u32 bytes_avail_towrite;
+	u32 bytes_avail_toread;
+	u32 totalbytes_towrite = 0;
 
 	struct scatterlist *sg;
-	volatile u32 nextWriteLocation;
-	u64 prevIndices = 0;
+	volatile u32 next_write_location;
+	u64 prev_indices = 0;
 	unsigned long flags;
 
 	for_each_sg(sglist, sg, sgcount, i)
 	{
-		totalBytesToWrite += sg->length;
+		totalbytes_towrite += sg->length;
 	}
 
-	totalBytesToWrite += sizeof(u64);
+	totalbytes_towrite += sizeof(u64);
 
-	spin_lock_irqsave(&OutRingInfo->ring_lock, flags);
+	spin_lock_irqsave(&outring_info->ring_lock, flags);
 
-	GetRingBufferAvailBytes(OutRingInfo,
-				&byteAvailToRead,
-				&byteAvailToWrite);
+	GetRingBufferAvailBytes(outring_info,
+				&bytes_avail_toread,
+				&bytes_avail_towrite);
 
-	DPRINT_DBG(VMBUS, "Writing %u bytes...", totalBytesToWrite);
+	DPRINT_DBG(VMBUS, "Writing %u bytes...", totalbytes_towrite);
 
-	/* DumpRingInfo(OutRingInfo, "BEFORE "); */
+	/* Dumpring_info(Outring_info, "BEFORE "); */
 
 	/* If there is only room for the packet, assume it is full. */
 	/* Otherwise, the next time around, we think the ring buffer */
 	/* is empty since the read index == write index */
-	if (byteAvailToWrite <= totalBytesToWrite) {
+	if (bytes_avail_towrite <= totalbytes_towrite) {
 		DPRINT_DBG(VMBUS,
 			"No more space left on outbound ring buffer "
 			"(needed %u, avail %u)",
-			totalBytesToWrite,
-			byteAvailToWrite);
+			totalbytes_towrite,
+			bytes_avail_towrite);
 
-		spin_unlock_irqrestore(&OutRingInfo->ring_lock, flags);
+		spin_unlock_irqrestore(&outring_info->ring_lock, flags);
 		return -1;
 	}
 
 	/* Write to the ring buffer */
-	nextWriteLocation = GetNextWriteLocation(OutRingInfo);
+	next_write_location = GetNextWriteLocation(outring_info);
 
 	for_each_sg(sglist, sg, sgcount, i)
 	{
-		nextWriteLocation = CopyToRingBuffer(OutRingInfo,
-						     nextWriteLocation,
+		next_write_location = CopyToRingBuffer(outring_info,
+						     next_write_location,
 						     sg_virt(sg),
 						     sg->length);
 	}
 
 	/* Set previous packet start */
-	prevIndices = GetRingBufferIndices(OutRingInfo);
+	prev_indices = GetRingBufferIndices(outring_info);
 
-	nextWriteLocation = CopyToRingBuffer(OutRingInfo,
-					     nextWriteLocation,
-					     &prevIndices,
+	next_write_location = CopyToRingBuffer(outring_info,
+					     next_write_location,
+					     &prev_indices,
 					     sizeof(u64));
 
 	/* Make sure we flush all writes before updating the writeIndex */
 	mb();
 
 	/* Now, update the write location */
-	SetNextWriteLocation(OutRingInfo, nextWriteLocation);
+	SetNextWriteLocation(outring_info, next_write_location);
 
-	/* DumpRingInfo(OutRingInfo, "AFTER "); */
+	/* Dumpring_info(Outring_info, "AFTER "); */
 
-	spin_unlock_irqrestore(&OutRingInfo->ring_lock, flags);
+	spin_unlock_irqrestore(&outring_info->ring_lock, flags);
 	return 0;
 }
 
@@ -428,41 +430,42 @@ Description:
 	Read without advancing the read index
 
 --*/
-int RingBufferPeek(struct hv_ring_buffer_info *InRingInfo, void *Buffer, u32 BufferLen)
+int RingBufferPeek(struct hv_ring_buffer_info *Inring_info,
+		   void *Buffer, u32 buflen)
 {
-	u32 bytesAvailToWrite;
-	u32 bytesAvailToRead;
-	u32 nextReadLocation = 0;
+	u32 bytes_avail_towrite;
+	u32 bytes_avail_toread;
+	u32 next_read_location = 0;
 	unsigned long flags;
 
-	spin_lock_irqsave(&InRingInfo->ring_lock, flags);
+	spin_lock_irqsave(&Inring_info->ring_lock, flags);
 
-	GetRingBufferAvailBytes(InRingInfo,
-				&bytesAvailToRead,
-				&bytesAvailToWrite);
+	GetRingBufferAvailBytes(Inring_info,
+				&bytes_avail_toread,
+				&bytes_avail_towrite);
 
 	/* Make sure there is something to read */
-	if (bytesAvailToRead < BufferLen) {
+	if (bytes_avail_toread < buflen) {
 		/* DPRINT_DBG(VMBUS,
 			"got callback but not enough to read "
 			"<avail to read %d read size %d>!!",
-			bytesAvailToRead,
+			bytes_avail_toread,
 			BufferLen); */
 
-		spin_unlock_irqrestore(&InRingInfo->ring_lock, flags);
+		spin_unlock_irqrestore(&Inring_info->ring_lock, flags);
 
 		return -1;
 	}
 
 	/* Convert to byte offset */
-	nextReadLocation = GetNextReadLocation(InRingInfo);
+	next_read_location = GetNextReadLocation(Inring_info);
 
-	nextReadLocation = CopyFromRingBuffer(InRingInfo,
+	next_read_location = CopyFromRingBuffer(Inring_info,
 						Buffer,
-						BufferLen,
-						nextReadLocation);
+						buflen,
+						next_read_location);
 
-	spin_unlock_irqrestore(&InRingInfo->ring_lock, flags);
+	spin_unlock_irqrestore(&Inring_info->ring_lock, flags);
 
 	return 0;
 }
@@ -477,52 +480,52 @@ Description:
 	Read and advance the read index
 
 --*/
-int RingBufferRead(struct hv_ring_buffer_info *InRingInfo, void *Buffer,
-		   u32 BufferLen, u32 Offset)
+int RingBufferRead(struct hv_ring_buffer_info *inring_info, void *buffer,
+		   u32 buflen, u32 offset)
 {
-	u32 bytesAvailToWrite;
-	u32 bytesAvailToRead;
-	u32 nextReadLocation = 0;
-	u64 prevIndices = 0;
+	u32 bytes_avail_towrite;
+	u32 bytes_avail_toread;
+	u32 next_read_location = 0;
+	u64 prev_indices = 0;
 	unsigned long flags;
 
-	if (BufferLen <= 0)
+	if (buflen <= 0)
 		return -EINVAL;
 
-	spin_lock_irqsave(&InRingInfo->ring_lock, flags);
+	spin_lock_irqsave(&inring_info->ring_lock, flags);
 
-	GetRingBufferAvailBytes(InRingInfo,
-				&bytesAvailToRead,
-				&bytesAvailToWrite);
+	GetRingBufferAvailBytes(inring_info,
+				&bytes_avail_toread,
+				&bytes_avail_towrite);
 
-	DPRINT_DBG(VMBUS, "Reading %u bytes...", BufferLen);
+	DPRINT_DBG(VMBUS, "Reading %u bytes...", buflen);
 
-	/* DumpRingInfo(InRingInfo, "BEFORE "); */
+	/* Dumpring_info(Inring_info, "BEFORE "); */
 
 	/* Make sure there is something to read */
-	if (bytesAvailToRead < BufferLen) {
+	if (bytes_avail_toread < buflen) {
 		DPRINT_DBG(VMBUS,
 			"got callback but not enough to read "
 			"<avail to read %d read size %d>!!",
-			bytesAvailToRead,
-			BufferLen);
+			bytes_avail_toread,
+			buflen);
 
-		spin_unlock_irqrestore(&InRingInfo->ring_lock, flags);
+		spin_unlock_irqrestore(&inring_info->ring_lock, flags);
 
 		return -1;
 	}
 
-	nextReadLocation = GetNextReadLocationWithOffset(InRingInfo, Offset);
+	next_read_location = GetNextReadLocationWithOffset(inring_info, offset);
 
-	nextReadLocation = CopyFromRingBuffer(InRingInfo,
-						Buffer,
-						BufferLen,
-						nextReadLocation);
+	next_read_location = CopyFromRingBuffer(inring_info,
+						buffer,
+						buflen,
+						next_read_location);
 
-	nextReadLocation = CopyFromRingBuffer(InRingInfo,
-						&prevIndices,
+	next_read_location = CopyFromRingBuffer(inring_info,
+						&prev_indices,
 						sizeof(u64),
-						nextReadLocation);
+						next_read_location);
 
 	/* Make sure all reads are done before we update the read index since */
 	/* the writer may start writing to the read area once the read index */
@@ -530,11 +533,11 @@ int RingBufferRead(struct hv_ring_buffer_info *InRingInfo, void *Buffer,
 	mb();
 
 	/* Update the read index */
-	SetNextReadLocation(InRingInfo, nextReadLocation);
+	SetNextReadLocation(inring_info, next_read_location);
 
-	/* DumpRingInfo(InRingInfo, "AFTER "); */
+	/* Dumpring_info(Inring_info, "AFTER "); */
 
-	spin_unlock_irqrestore(&InRingInfo->ring_lock, flags);
+	spin_unlock_irqrestore(&inring_info->ring_lock, flags);
 
 	return 0;
 }
@@ -552,29 +555,29 @@ Description:
 --*/
 static u32
 CopyToRingBuffer(
-	struct hv_ring_buffer_info	*RingInfo,
-	u32				StartWriteOffset,
-	void				*Src,
-	u32				SrcLen)
+	struct hv_ring_buffer_info	*ring_info,
+	u32				start_write_offset,
+	void				*src,
+	u32				srclen)
 {
-	void *ringBuffer = GetRingBuffer(RingInfo);
-	u32 ringBufferSize = GetRingBufferSize(RingInfo);
-	u32 fragLen;
+	void *ring_buffer = GetRingBuffer(ring_info);
+	u32 ring_buffer_size = GetRingBufferSize(ring_info);
+	u32 frag_len;
 
 	/* wrap-around detected! */
-	if (SrcLen > ringBufferSize - StartWriteOffset) {
+	if (srclen > ring_buffer_size - start_write_offset) {
 		DPRINT_DBG(VMBUS, "wrap-around detected!");
 
-		fragLen = ringBufferSize - StartWriteOffset;
-		memcpy(ringBuffer + StartWriteOffset, Src, fragLen);
-		memcpy(ringBuffer, Src + fragLen, SrcLen - fragLen);
+		frag_len = ring_buffer_size - start_write_offset;
+		memcpy(ring_buffer + start_write_offset, src, frag_len);
+		memcpy(ring_buffer, src + frag_len, srclen - frag_len);
 	} else
-		memcpy(ringBuffer + StartWriteOffset, Src, SrcLen);
+		memcpy(ring_buffer + start_write_offset, src, srclen);
 
-	StartWriteOffset += SrcLen;
-	StartWriteOffset %= ringBufferSize;
+	start_write_offset += srclen;
+	start_write_offset %= ring_buffer_size;
 
-	return StartWriteOffset;
+	return start_write_offset;
 }
 
 
@@ -590,33 +593,33 @@ Description:
 --*/
 static u32
 CopyFromRingBuffer(
-	struct hv_ring_buffer_info	*RingInfo,
-	void				*Dest,
-	u32				DestLen,
-	u32				StartReadOffset)
+	struct hv_ring_buffer_info	*ring_info,
+	void				*dest,
+	u32				destlen,
+	u32				start_read_offset)
 {
-	void *ringBuffer = GetRingBuffer(RingInfo);
-	u32 ringBufferSize = GetRingBufferSize(RingInfo);
+	void *ring_buffer = GetRingBuffer(ring_info);
+	u32 ring_buffer_size = GetRingBufferSize(ring_info);
 
-	u32 fragLen;
+	u32 frag_len;
 
 	/* wrap-around detected at the src */
-	if (DestLen > ringBufferSize - StartReadOffset) {
+	if (destlen > ring_buffer_size - start_read_offset) {
 		DPRINT_DBG(VMBUS, "src wrap-around detected!");
 
-		fragLen = ringBufferSize - StartReadOffset;
+		frag_len = ring_buffer_size - start_read_offset;
 
-		memcpy(Dest, ringBuffer + StartReadOffset, fragLen);
-		memcpy(Dest + fragLen, ringBuffer, DestLen - fragLen);
+		memcpy(dest, ring_buffer + start_read_offset, frag_len);
+		memcpy(dest + frag_len, ring_buffer, destlen - frag_len);
 	} else
 
-		memcpy(Dest, ringBuffer + StartReadOffset, DestLen);
+		memcpy(dest, ring_buffer + start_read_offset, destlen);
 
 
-	StartReadOffset += DestLen;
-	StartReadOffset %= ringBufferSize;
+	start_read_offset += destlen;
+	start_read_offset %= ring_buffer_size;
 
-	return StartReadOffset;
+	return start_read_offset;
 }
 
 
diff --git a/drivers/staging/hv/ring_buffer.h b/drivers/staging/hv/ring_buffer.h
index bb4c5bc..f30be1f 100644
--- a/drivers/staging/hv/ring_buffer.h
+++ b/drivers/staging/hv/ring_buffer.h
@@ -75,28 +75,28 @@ struct hv_ring_buffer_debug_info {
 /* Interface */
 
 
-int RingBufferInit(struct hv_ring_buffer_info *RingInfo, void *Buffer,
-		   u32 BufferLen);
+int RingBufferInit(struct hv_ring_buffer_info *ring_info, void *buffer,
+		   u32 buflen);
 
-void RingBufferCleanup(struct hv_ring_buffer_info *RingInfo);
+void RingBufferCleanup(struct hv_ring_buffer_info *ring_info);
 
-int RingBufferWrite(struct hv_ring_buffer_info *RingInfo,
+int RingBufferWrite(struct hv_ring_buffer_info *ring_info,
 		    struct scatterlist *sglist,
 		    u32 sgcount);
 
-int RingBufferPeek(struct hv_ring_buffer_info *RingInfo, void *Buffer,
-		   u32 BufferLen);
+int RingBufferPeek(struct hv_ring_buffer_info *ring_info, void *buffer,
+		   u32 buflen);
 
-int RingBufferRead(struct hv_ring_buffer_info *RingInfo,
-		   void *Buffer,
-		   u32 BufferLen,
-		   u32 Offset);
+int RingBufferRead(struct hv_ring_buffer_info *ring_info,
+		   void *buffer,
+		   u32 buflen,
+		   u32 offset);
 
-u32 GetRingBufferInterruptMask(struct hv_ring_buffer_info *RingInfo);
+u32 GetRingBufferInterruptMask(struct hv_ring_buffer_info *ring_info);
 
-void DumpRingInfo(struct hv_ring_buffer_info *RingInfo, char *Prefix);
+void Dumpring_info(struct hv_ring_buffer_info *ring_info, char *prefix);
 
-void RingBufferGetDebugInfo(struct hv_ring_buffer_info *RingInfo,
+void RingBufferGetDebugInfo(struct hv_ring_buffer_info *ring_info,
 			    struct hv_ring_buffer_debug_info *debug_info);
 
 #endif /* _RING_BUFFER_H_ */
-- 
1.6.3.2

