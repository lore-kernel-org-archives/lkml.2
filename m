Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0KHWEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:04:11 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:46001
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755774Ab0KHWDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:03:01 -0500
From: Haiyang Zhang <haiyangz@linuxonhyperv.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 08/10] staging: hv: Convert camel cased struct fields in ring_buffer.h to lower cases
Date: Mon,  8 Nov 2010 14:04:45 -0800
Message-Id: <1289253887-2596-8-git-send-email-haiyangz@linuxonhyperv.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1289253887-2596-7-git-send-email-haiyangz@linuxonhyperv.com>
References: <1289253887-2596-1-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-2-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-3-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-4-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-5-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-6-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-7-git-send-email-haiyangz@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

staging: hv: Convert camel cased struct fields in ring_buffer.h to lower cases

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel.c     |   10 +++---
 drivers/staging/hv/ring_buffer.c |   58 ++++++++++++++++++++-----------------
 drivers/staging/hv/ring_buffer.h |   30 ++++++++++----------
 drivers/staging/hv/vmbus_drv.c   |   25 +++++++++-------
 4 files changed, 65 insertions(+), 58 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index abc2988..0e554e9 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -213,7 +213,7 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	newchannel->ringbuffer_gpadlhandle = 0;
 
 	ret = vmbus_establish_gpadl(newchannel,
-					 newchannel->outbound.RingBuffer,
+					 newchannel->outbound.ring_buffer,
 					 send_ringbuffer_size +
 					 recv_ringbuffer_size,
 					 &newchannel->ringbuffer_gpadlhandle);
@@ -227,10 +227,10 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 		   "size %d recv ring %p size %d, downstreamoffset %d>",
 		   newchannel, newchannel->offermsg.child_relid,
 		   newchannel->ringbuffer_gpadlhandle,
-		   newchannel->outbound.RingBuffer,
-		   newchannel->outbound.RingSize,
-		   newchannel->inbound.RingBuffer,
-		   newchannel->inbound.RingSize,
+		   newchannel->outbound.ring_buffer,
+		   newchannel->outbound.ring_size,
+		   newchannel->inbound.ring_buffer,
+		   newchannel->inbound.ring_size,
 		   send_ringbuffer_size);
 
 	/* Create and init the channel open message */
diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
index d78c569..6095cc5 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -51,11 +51,11 @@ GetRingBufferAvailBytes(struct hv_ring_buffer_info *rbi, u32 *read, u32 *write)
 	u32 read_loc, write_loc;
 
 	/* Capture the read/write indices before they changed */
-	read_loc = rbi->RingBuffer->ReadIndex;
-	write_loc = rbi->RingBuffer->WriteIndex;
+	read_loc = rbi->ring_buffer->read_index;
+	write_loc = rbi->ring_buffer->write_index;
 
-	*write = BYTES_AVAIL_TO_WRITE(read_loc, write_loc, rbi->RingDataSize);
-	*read = rbi->RingDataSize - *write;
+	*write = BYTES_AVAIL_TO_WRITE(read_loc, write_loc, rbi->ring_datasize);
+	*read = rbi->ring_datasize - *write;
 }
 
 /*++
@@ -70,7 +70,7 @@ Description:
 static inline u32
 GetNextWriteLocation(struct hv_ring_buffer_info *RingInfo)
 {
-	u32 next = RingInfo->RingBuffer->WriteIndex;
+	u32 next = RingInfo->ring_buffer->write_index;
 
 	/* ASSERT(next < RingInfo->RingDataSize); */
 
@@ -90,7 +90,7 @@ static inline void
 SetNextWriteLocation(struct hv_ring_buffer_info *RingInfo,
 		     u32 NextWriteLocation)
 {
-	RingInfo->RingBuffer->WriteIndex = NextWriteLocation;
+	RingInfo->ring_buffer->write_index = NextWriteLocation;
 }
 
 /*++
@@ -105,7 +105,7 @@ Description:
 static inline u32
 GetNextReadLocation(struct hv_ring_buffer_info *RingInfo)
 {
-	u32 next = RingInfo->RingBuffer->ReadIndex;
+	u32 next = RingInfo->ring_buffer->read_index;
 
 	/* ASSERT(next < RingInfo->RingDataSize); */
 
@@ -125,11 +125,11 @@ Description:
 static inline u32
 GetNextReadLocationWithOffset(struct hv_ring_buffer_info *RingInfo, u32 Offset)
 {
-	u32 next = RingInfo->RingBuffer->ReadIndex;
+	u32 next = RingInfo->ring_buffer->read_index;
 
 	/* ASSERT(next < RingInfo->RingDataSize); */
 	next += Offset;
-	next %= RingInfo->RingDataSize;
+	next %= RingInfo->ring_datasize;
 
 	return next;
 }
@@ -146,7 +146,7 @@ Description:
 static inline void
 SetNextReadLocation(struct hv_ring_buffer_info *RingInfo, u32 NextReadLocation)
 {
-	RingInfo->RingBuffer->ReadIndex = NextReadLocation;
+	RingInfo->ring_buffer->read_index = NextReadLocation;
 }
 
 
@@ -162,7 +162,7 @@ Description:
 static inline void *
 GetRingBuffer(struct hv_ring_buffer_info *RingInfo)
 {
-	return (void *)RingInfo->RingBuffer->Buffer;
+	return (void *)RingInfo->ring_buffer->buffer;
 }
 
 
@@ -178,7 +178,7 @@ Description:
 static inline u32
 GetRingBufferSize(struct hv_ring_buffer_info *RingInfo)
 {
-	return RingInfo->RingDataSize;
+	return RingInfo->ring_datasize;
 }
 
 /*++
@@ -193,7 +193,7 @@ Description:
 static inline u64
 GetRingBufferIndices(struct hv_ring_buffer_info *RingInfo)
 {
-	return (u64)RingInfo->RingBuffer->WriteIndex << 32;
+	return (u64)RingInfo->ring_buffer->write_index << 32;
 }
 
 
@@ -221,11 +221,11 @@ void DumpRingInfo(struct hv_ring_buffer_info *RingInfo, char *Prefix)
 		"avail read %u read idx %u write idx %u>>",
 		Prefix,
 		RingInfo,
-		RingInfo->RingBuffer->Buffer,
+		RingInfo->ring_buffer->buffer,
 		bytesAvailToWrite,
 		bytesAvailToRead,
-		RingInfo->RingBuffer->ReadIndex,
-		RingInfo->RingBuffer->WriteIndex);
+		RingInfo->ring_buffer->read_index,
+		RingInfo->ring_buffer->write_index);
 }
 
 
@@ -262,16 +262,19 @@ void RingBufferGetDebugInfo(struct hv_ring_buffer_info *RingInfo,
 	u32 bytesAvailToWrite;
 	u32 bytesAvailToRead;
 
-	if (RingInfo->RingBuffer) {
+	if (RingInfo->ring_buffer) {
 		GetRingBufferAvailBytes(RingInfo,
 					&bytesAvailToRead,
 					&bytesAvailToWrite);
 
-		debug_info->BytesAvailToRead = bytesAvailToRead;
-		debug_info->BytesAvailToWrite = bytesAvailToWrite;
-		debug_info->CurrentReadIndex = RingInfo->RingBuffer->ReadIndex;
-		debug_info->CurrentWriteIndex = RingInfo->RingBuffer->WriteIndex;
-		debug_info->CurrentInterruptMask = RingInfo->RingBuffer->InterruptMask;
+		debug_info->bytes_avail_toread = bytesAvailToRead;
+		debug_info->bytes_avail_towrite = bytesAvailToWrite;
+		debug_info->current_read_index =
+			RingInfo->ring_buffer->read_index;
+		debug_info->current_write_index =
+			RingInfo->ring_buffer->write_index;
+		debug_info->current_interrupt_mask =
+			RingInfo->ring_buffer->interrupt_mask;
 	}
 }
 
@@ -287,7 +290,7 @@ Description:
 --*/
 u32 GetRingBufferInterruptMask(struct hv_ring_buffer_info *rbi)
 {
-	return rbi->RingBuffer->InterruptMask;
+	return rbi->ring_buffer->interrupt_mask;
 }
 
 /*++
@@ -306,11 +309,12 @@ int RingBufferInit(struct hv_ring_buffer_info *RingInfo, void *Buffer, u32 Buffe
 
 	memset(RingInfo, 0, sizeof(struct hv_ring_buffer_info));
 
-	RingInfo->RingBuffer = (struct hv_ring_buffer *)Buffer;
-	RingInfo->RingBuffer->ReadIndex = RingInfo->RingBuffer->WriteIndex = 0;
+	RingInfo->ring_buffer = (struct hv_ring_buffer *)Buffer;
+	RingInfo->ring_buffer->read_index =
+		RingInfo->ring_buffer->write_index = 0;
 
-	RingInfo->RingSize = BufferLen;
-	RingInfo->RingDataSize = BufferLen - sizeof(struct hv_ring_buffer);
+	RingInfo->ring_size = BufferLen;
+	RingInfo->ring_datasize = BufferLen - sizeof(struct hv_ring_buffer);
 
 	spin_lock_init(&RingInfo->ring_lock);
 
diff --git a/drivers/staging/hv/ring_buffer.h b/drivers/staging/hv/ring_buffer.h
index a7f1717..bb4c5bc 100644
--- a/drivers/staging/hv/ring_buffer.h
+++ b/drivers/staging/hv/ring_buffer.h
@@ -29,18 +29,18 @@
 
 struct hv_ring_buffer {
 	/* Offset in bytes from the start of ring data below */
-	volatile u32 WriteIndex;
+	volatile u32 write_index;
 
 	/* Offset in bytes from the start of ring data below */
-	volatile u32 ReadIndex;
+	volatile u32 read_index;
 
-	volatile u32 InterruptMask;
+	volatile u32 interrupt_mask;
 
 	/* Pad it to PAGE_SIZE so that data starts on page boundary */
-	u8	Reserved[4084];
+	u8	reserved[4084];
 
 	/* NOTE:
-	 * The InterruptMask field is used only for channels but since our
+	 * The interrupt_mask field is used only for channels but since our
 	 * vmbus connection also uses this data structure and its data starts
 	 * here, we commented out this field.
 	 */
@@ -50,24 +50,24 @@ struct hv_ring_buffer {
 	 * Ring data starts here + RingDataStartOffset
 	 * !!! DO NOT place any fields below this !!!
 	 */
-	u8 Buffer[0];
+	u8 buffer[0];
 } __attribute__((packed));
 
 struct hv_ring_buffer_info {
-	struct hv_ring_buffer *RingBuffer;
-	u32 RingSize;			/* Include the shared header */
+	struct hv_ring_buffer *ring_buffer;
+	u32 ring_size;			/* Include the shared header */
 	spinlock_t ring_lock;
 
-	u32 RingDataSize;		/* < ringSize */
-	u32 RingDataStartOffset;
+	u32 ring_datasize;		/* < ring_size */
+	u32 ring_data_startoffset;
 };
 
 struct hv_ring_buffer_debug_info {
-	u32 CurrentInterruptMask;
-	u32 CurrentReadIndex;
-	u32 CurrentWriteIndex;
-	u32 BytesAvailToRead;
-	u32 BytesAvailToWrite;
+	u32 current_interrupt_mask;
+	u32 current_read_index;
+	u32 current_write_index;
+	u32 bytes_avail_toread;
+	u32 bytes_avail_towrite;
 };
 
 
diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
index 2bbf4ec..0965875 100644
--- a/drivers/staging/hv/vmbus_drv.c
+++ b/drivers/staging/hv/vmbus_drv.c
@@ -156,18 +156,21 @@ static void get_channel_info(struct hv_device *device,
 	info->ClientMonitorLatency = debug_info.clientmonitor_latency;
 	info->ClientMonitorConnectionId = debug_info.clientmonitor_connectionid;
 
-	info->Inbound.InterruptMask = debug_info.inbound.CurrentInterruptMask;
-	info->Inbound.ReadIndex = debug_info.inbound.CurrentReadIndex;
-	info->Inbound.WriteIndex = debug_info.inbound.CurrentWriteIndex;
-	info->Inbound.BytesAvailToRead = debug_info.inbound.BytesAvailToRead;
-	info->Inbound.BytesAvailToWrite = debug_info.inbound.BytesAvailToWrite;
-
-	info->Outbound.InterruptMask = debug_info.outbound.CurrentInterruptMask;
-	info->Outbound.ReadIndex = debug_info.outbound.CurrentReadIndex;
-	info->Outbound.WriteIndex = debug_info.outbound.CurrentWriteIndex;
-	info->Outbound.BytesAvailToRead = debug_info.outbound.BytesAvailToRead;
+	info->Inbound.InterruptMask = debug_info.inbound.current_interrupt_mask;
+	info->Inbound.ReadIndex = debug_info.inbound.current_read_index;
+	info->Inbound.WriteIndex = debug_info.inbound.current_write_index;
+	info->Inbound.BytesAvailToRead = debug_info.inbound.bytes_avail_toread;
+	info->Inbound.BytesAvailToWrite =
+		debug_info.inbound.bytes_avail_towrite;
+
+	info->Outbound.InterruptMask =
+		debug_info.outbound.current_interrupt_mask;
+	info->Outbound.ReadIndex = debug_info.outbound.current_read_index;
+	info->Outbound.WriteIndex = debug_info.outbound.current_write_index;
+	info->Outbound.BytesAvailToRead =
+		debug_info.outbound.bytes_avail_toread;
 	info->Outbound.BytesAvailToWrite =
-		debug_info.outbound.BytesAvailToWrite;
+		debug_info.outbound.bytes_avail_towrite;
 }
 
 /*
-- 
1.6.3.2

