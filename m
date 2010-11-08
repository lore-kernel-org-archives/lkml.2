Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab0KHWDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 17:03:03 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:45977
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755410Ab0KHWDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 17:03:01 -0500
From: Haiyang Zhang <haiyangz@linuxonhyperv.com>
To: haiyangz@microsoft.com, hjanssen@microsoft.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Subject: [PATCH 10/10] staging: hv: Convert camel cased functions in ring_buffer.c to lower cases
Date: Mon,  8 Nov 2010 14:04:47 -0800
Message-Id: <1289253887-2596-10-git-send-email-haiyangz@linuxonhyperv.com>
X-Mailer: git-send-email 1.5.5.6
In-Reply-To: <1289253887-2596-9-git-send-email-haiyangz@linuxonhyperv.com>
References: <1289253887-2596-1-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-2-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-3-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-4-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-5-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-6-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-7-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-8-git-send-email-haiyangz@linuxonhyperv.com>
 <1289253887-2596-9-git-send-email-haiyangz@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

staging: hv: Convert camel cased functions in ring_buffer.c to lower cases

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/channel.c     |   40 ++++++------
 drivers/staging/hv/ring_buffer.c |  123 +++++++++++++++++++------------------
 drivers/staging/hv/ring_buffer.h |   16 +++---
 3 files changed, 91 insertions(+), 88 deletions(-)

diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index 97db545..45a627d 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -155,8 +155,8 @@ void vmbus_get_debug_info(struct vmbus_channel *channel,
 			monitorpage->parameter[monitor_group]
 					[monitor_offset].connectionid.u.id;
 
-	RingBufferGetDebugInfo(&channel->inbound, &debuginfo->inbound);
-	RingBufferGetDebugInfo(&channel->outbound, &debuginfo->outbound);
+	ringbuffer_get_debuginfo(&channel->inbound, &debuginfo->inbound);
+	ringbuffer_get_debuginfo(&channel->outbound, &debuginfo->outbound);
 }
 
 /*
@@ -193,13 +193,13 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	newchannel->ringbuffer_pagecount = (send_ringbuffer_size +
 					   recv_ringbuffer_size) >> PAGE_SHIFT;
 
-	ret = RingBufferInit(&newchannel->outbound, out, send_ringbuffer_size);
+	ret = ringbuffer_init(&newchannel->outbound, out, send_ringbuffer_size);
 	if (ret != 0) {
 		err = ret;
 		goto errorout;
 	}
 
-	ret = RingBufferInit(&newchannel->inbound, in, recv_ringbuffer_size);
+	ret = ringbuffer_init(&newchannel->inbound, in, recv_ringbuffer_size);
 	if (ret != 0) {
 		err = ret;
 		goto errorout;
@@ -298,8 +298,8 @@ Cleanup:
 	return 0;
 
 errorout:
-	RingBufferCleanup(&newchannel->outbound);
-	RingBufferCleanup(&newchannel->inbound);
+	ringbuffer_cleanup(&newchannel->outbound);
+	ringbuffer_cleanup(&newchannel->inbound);
 	osd_page_free(out, (send_ringbuffer_size + recv_ringbuffer_size)
 		     >> PAGE_SHIFT);
 	kfree(openInfo);
@@ -683,8 +683,8 @@ void vmbus_close(struct vmbus_channel *channel)
 	/* TODO: Send a msg to release the childRelId */
 
 	/* Cleanup the ring buffers for this channel */
-	RingBufferCleanup(&channel->outbound);
-	RingBufferCleanup(&channel->inbound);
+	ringbuffer_cleanup(&channel->outbound);
+	ringbuffer_cleanup(&channel->inbound);
 
 	osd_page_free(channel->ringbuffer_pages, channel->ringbuffer_pagecount);
 
@@ -752,10 +752,10 @@ int vmbus_sendpacket(struct vmbus_channel *channel, const void *buffer,
 	sg_set_buf(&bufferlist[2], &aligned_data,
 		   packetlen_aligned - packetlen);
 
-	ret = RingBufferWrite(&channel->outbound, bufferlist, 3);
+	ret = ringbuffer_write(&channel->outbound, bufferlist, 3);
 
 	/* TODO: We should determine if this is optional */
-	if (ret == 0 && !GetRingBufferInterruptMask(&channel->outbound))
+	if (ret == 0 && !get_ringbuffer_interrupt_mask(&channel->outbound))
 		vmbus_setevent(channel);
 
 	return ret;
@@ -817,10 +817,10 @@ int vmbus_sendpacket_pagebuffer(struct vmbus_channel *channel,
 	sg_set_buf(&bufferlist[2], &aligned_data,
 		packetlen_aligned - packetlen);
 
-	ret = RingBufferWrite(&channel->outbound, bufferlist, 3);
+	ret = ringbuffer_write(&channel->outbound, bufferlist, 3);
 
 	/* TODO: We should determine if this is optional */
-	if (ret == 0 && !GetRingBufferInterruptMask(&channel->outbound))
+	if (ret == 0 && !get_ringbuffer_interrupt_mask(&channel->outbound))
 		vmbus_setevent(channel);
 
 	return ret;
@@ -886,10 +886,10 @@ int vmbus_sendpacket_multipagebuffer(struct vmbus_channel *channel,
 	sg_set_buf(&bufferlist[2], &aligned_data,
 		packetlen_aligned - packetlen);
 
-	ret = RingBufferWrite(&channel->outbound, bufferlist, 3);
+	ret = ringbuffer_write(&channel->outbound, bufferlist, 3);
 
 	/* TODO: We should determine if this is optional */
-	if (ret == 0 && !GetRingBufferInterruptMask(&channel->outbound))
+	if (ret == 0 && !get_ringbuffer_interrupt_mask(&channel->outbound))
 		vmbus_setevent(channel);
 
 	return ret;
@@ -923,7 +923,7 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 
 	spin_lock_irqsave(&channel->inbound_lock, flags);
 
-	ret = RingBufferPeek(&channel->inbound, &desc,
+	ret = ringbuffer_peek(&channel->inbound, &desc,
 			     sizeof(struct vmpacket_descriptor));
 	if (ret != 0) {
 		spin_unlock_irqrestore(&channel->inbound_lock, flags);
@@ -956,7 +956,7 @@ int vmbus_recvpacket(struct vmbus_channel *channel, void *buffer,
 	*requestid = desc.TransactionId;
 
 	/* Copy over the packet to the user buffer */
-	ret = RingBufferRead(&channel->inbound, buffer, userlen,
+	ret = ringbuffer_read(&channel->inbound, buffer, userlen,
 			     (desc.DataOffset8 << 3));
 
 	spin_unlock_irqrestore(&channel->inbound_lock, flags);
@@ -983,7 +983,7 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 
 	spin_lock_irqsave(&channel->inbound_lock, flags);
 
-	ret = RingBufferPeek(&channel->inbound, &desc,
+	ret = ringbuffer_peek(&channel->inbound, &desc,
 			     sizeof(struct vmpacket_descriptor));
 	if (ret != 0) {
 		spin_unlock_irqrestore(&channel->inbound_lock, flags);
@@ -1015,7 +1015,7 @@ int vmbus_recvpacket_raw(struct vmbus_channel *channel, void *buffer,
 	*requestid = desc.TransactionId;
 
 	/* Copy over the entire packet to the user buffer */
-	ret = RingBufferRead(&channel->inbound, buffer, packetlen, 0);
+	ret = ringbuffer_read(&channel->inbound, buffer, packetlen, 0);
 
 	spin_unlock_irqrestore(&channel->inbound_lock, flags);
 	return 0;
@@ -1052,6 +1052,6 @@ void vmbus_ontimer(unsigned long data)
 static void dump_vmbus_channel(struct vmbus_channel *channel)
 {
 	DPRINT_DBG(VMBUS, "Channel (%d)", channel->offermsg.child_relid);
-	Dumpring_info(&channel->outbound, "Outbound ");
-	Dumpring_info(&channel->inbound, "Inbound ");
+	dump_ring_info(&channel->outbound, "Outbound ");
+	dump_ring_info(&channel->inbound, "Inbound ");
 }
diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
index 705d95f..4d53392 100644
--- a/drivers/staging/hv/ring_buffer.c
+++ b/drivers/staging/hv/ring_buffer.c
@@ -38,7 +38,7 @@
 /*++
 
 Name:
-	GetRingBufferAvailBytes()
+	get_ringbuffer_availbytes()
 
 Description:
 	Get number of bytes available to read and to write to
@@ -46,7 +46,8 @@ Description:
 
 --*/
 static inline void
-GetRingBufferAvailBytes(struct hv_ring_buffer_info *rbi, u32 *read, u32 *write)
+get_ringbuffer_availbytes(struct hv_ring_buffer_info *rbi,
+			  u32 *read, u32 *write)
 {
 	u32 read_loc, write_loc;
 
@@ -61,14 +62,14 @@ GetRingBufferAvailBytes(struct hv_ring_buffer_info *rbi, u32 *read, u32 *write)
 /*++
 
 Name:
-	GetNextWriteLocation()
+	get_next_write_location()
 
 Description:
 	Get the next write location for the specified ring buffer
 
 --*/
 static inline u32
-GetNextWriteLocation(struct hv_ring_buffer_info *ring_info)
+get_next_write_location(struct hv_ring_buffer_info *ring_info)
 {
 	u32 next = ring_info->ring_buffer->write_index;
 
@@ -80,14 +81,14 @@ GetNextWriteLocation(struct hv_ring_buffer_info *ring_info)
 /*++
 
 Name:
-	SetNextWriteLocation()
+	set_next_write_location()
 
 Description:
 	Set the next write location for the specified ring buffer
 
 --*/
 static inline void
-SetNextWriteLocation(struct hv_ring_buffer_info *ring_info,
+set_next_write_location(struct hv_ring_buffer_info *ring_info,
 		     u32 next_write_location)
 {
 	ring_info->ring_buffer->write_index = next_write_location;
@@ -96,14 +97,14 @@ SetNextWriteLocation(struct hv_ring_buffer_info *ring_info,
 /*++
 
 Name:
-	GetNextReadLocation()
+	get_next_read_location()
 
 Description:
 	Get the next read location for the specified ring buffer
 
 --*/
 static inline u32
-GetNextReadLocation(struct hv_ring_buffer_info *ring_info)
+get_next_read_location(struct hv_ring_buffer_info *ring_info)
 {
 	u32 next = ring_info->ring_buffer->read_index;
 
@@ -115,7 +116,7 @@ GetNextReadLocation(struct hv_ring_buffer_info *ring_info)
 /*++
 
 Name:
-	GetNextReadLocationWithOffset()
+	get_next_readlocation_withoffset()
 
 Description:
 	Get the next read location + offset for the specified ring buffer.
@@ -123,7 +124,8 @@ Description:
 
 --*/
 static inline u32
-GetNextReadLocationWithOffset(struct hv_ring_buffer_info *ring_info, u32 offset)
+get_next_readlocation_withoffset(struct hv_ring_buffer_info *ring_info,
+				 u32 offset)
 {
 	u32 next = ring_info->ring_buffer->read_index;
 
@@ -137,14 +139,14 @@ GetNextReadLocationWithOffset(struct hv_ring_buffer_info *ring_info, u32 offset)
 /*++
 
 Name:
-	SetNextReadLocation()
+	set_next_read_location()
 
 Description:
 	Set the next read location for the specified ring buffer
 
 --*/
 static inline void
-SetNextReadLocation(struct hv_ring_buffer_info *ring_info,
+set_next_read_location(struct hv_ring_buffer_info *ring_info,
 		    u32 next_read_location)
 {
 	ring_info->ring_buffer->read_index = next_read_location;
@@ -154,14 +156,14 @@ SetNextReadLocation(struct hv_ring_buffer_info *ring_info,
 /*++
 
 Name:
-	GetRingBuffer()
+	get_ring_buffer()
 
 Description:
 	Get the start of the ring buffer
 
 --*/
 static inline void *
-GetRingBuffer(struct hv_ring_buffer_info *ring_info)
+get_ring_buffer(struct hv_ring_buffer_info *ring_info)
 {
 	return (void *)ring_info->ring_buffer->buffer;
 }
@@ -170,14 +172,14 @@ GetRingBuffer(struct hv_ring_buffer_info *ring_info)
 /*++
 
 Name:
-	GetRingBufferSize()
+	get_ring_buffersize()
 
 Description:
 	Get the size of the ring buffer
 
 --*/
 static inline u32
-GetRingBufferSize(struct hv_ring_buffer_info *ring_info)
+get_ring_buffersize(struct hv_ring_buffer_info *ring_info)
 {
 	return ring_info->ring_datasize;
 }
@@ -185,14 +187,14 @@ GetRingBufferSize(struct hv_ring_buffer_info *ring_info)
 /*++
 
 Name:
-	GetRingBufferIndices()
+	get_ring_bufferindices()
 
 Description:
 	Get the read and write indices as u64 of the specified ring buffer
 
 --*/
 static inline u64
-GetRingBufferIndices(struct hv_ring_buffer_info *ring_info)
+get_ring_bufferindices(struct hv_ring_buffer_info *ring_info)
 {
 	return (u64)ring_info->ring_buffer->write_index << 32;
 }
@@ -201,18 +203,18 @@ GetRingBufferIndices(struct hv_ring_buffer_info *ring_info)
 /*++
 
 Name:
-	Dumpring_info()
+	dump_ring_info()
 
 Description:
 	Dump out to console the ring buffer info
 
 --*/
-void Dumpring_info(struct hv_ring_buffer_info *ring_info, char *prefix)
+void dump_ring_info(struct hv_ring_buffer_info *ring_info, char *prefix)
 {
 	u32 bytes_avail_towrite;
 	u32 bytes_avail_toread;
 
-	GetRingBufferAvailBytes(ring_info,
+	get_ringbuffer_availbytes(ring_info,
 	&bytes_avail_toread,
 	&bytes_avail_towrite);
 
@@ -233,14 +235,14 @@ void Dumpring_info(struct hv_ring_buffer_info *ring_info, char *prefix)
 /* Internal routines */
 
 static u32
-CopyToRingBuffer(
+copyto_ringbuffer(
 	struct hv_ring_buffer_info	*ring_info,
 	u32				start_write_offset,
 	void				*src,
 	u32				srclen);
 
 static u32
-CopyFromRingBuffer(
+copyfrom_ringbuffer(
 	struct hv_ring_buffer_info	*ring_info,
 	void				*dest,
 	u32				destlen,
@@ -251,20 +253,20 @@ CopyFromRingBuffer(
 /*++
 
 Name:
-	RingBufferGetDebugInfo()
+	ringbuffer_get_debuginfo()
 
 Description:
 	Get various debug metrics for the specified ring buffer
 
 --*/
-void RingBufferGetDebugInfo(struct hv_ring_buffer_info *ring_info,
+void ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
 			    struct hv_ring_buffer_debug_info *debug_info)
 {
 	u32 bytes_avail_towrite;
 	u32 bytes_avail_toread;
 
 	if (ring_info->ring_buffer) {
-		GetRingBufferAvailBytes(ring_info,
+		get_ringbuffer_availbytes(ring_info,
 					&bytes_avail_toread,
 					&bytes_avail_towrite);
 
@@ -283,13 +285,13 @@ void RingBufferGetDebugInfo(struct hv_ring_buffer_info *ring_info,
 /*++
 
 Name:
-	GetRingBufferInterruptMask()
+	get_ringbuffer_interrupt_mask()
 
 Description:
 	Get the interrupt mask for the specified ring buffer
 
 --*/
-u32 GetRingBufferInterruptMask(struct hv_ring_buffer_info *rbi)
+u32 get_ringbuffer_interrupt_mask(struct hv_ring_buffer_info *rbi)
 {
 	return rbi->ring_buffer->interrupt_mask;
 }
@@ -297,13 +299,13 @@ u32 GetRingBufferInterruptMask(struct hv_ring_buffer_info *rbi)
 /*++
 
 Name:
-	RingBufferInit()
+	ringbuffer_init()
 
 Description:
 	Initialize the ring buffer
 
 --*/
-int RingBufferInit(struct hv_ring_buffer_info *ring_info,
+int ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 		   void *buffer, u32 buflen)
 {
 	if (sizeof(struct hv_ring_buffer) != PAGE_SIZE)
@@ -326,26 +328,26 @@ int RingBufferInit(struct hv_ring_buffer_info *ring_info,
 /*++
 
 Name:
-	RingBufferCleanup()
+	ringbuffer_cleanup()
 
 Description:
 	Cleanup the ring buffer
 
 --*/
-void RingBufferCleanup(struct hv_ring_buffer_info *ring_info)
+void ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info)
 {
 }
 
 /*++
 
 Name:
-	RingBufferWrite()
+	ringbuffer_write()
 
 Description:
 	Write to the ring buffer
 
 --*/
-int RingBufferWrite(struct hv_ring_buffer_info *outring_info,
+int ringbuffer_write(struct hv_ring_buffer_info *outring_info,
 		    struct scatterlist *sglist, u32 sgcount)
 {
 	int i = 0;
@@ -367,7 +369,7 @@ int RingBufferWrite(struct hv_ring_buffer_info *outring_info,
 
 	spin_lock_irqsave(&outring_info->ring_lock, flags);
 
-	GetRingBufferAvailBytes(outring_info,
+	get_ringbuffer_availbytes(outring_info,
 				&bytes_avail_toread,
 				&bytes_avail_towrite);
 
@@ -390,20 +392,20 @@ int RingBufferWrite(struct hv_ring_buffer_info *outring_info,
 	}
 
 	/* Write to the ring buffer */
-	next_write_location = GetNextWriteLocation(outring_info);
+	next_write_location = get_next_write_location(outring_info);
 
 	for_each_sg(sglist, sg, sgcount, i)
 	{
-		next_write_location = CopyToRingBuffer(outring_info,
+		next_write_location = copyto_ringbuffer(outring_info,
 						     next_write_location,
 						     sg_virt(sg),
 						     sg->length);
 	}
 
 	/* Set previous packet start */
-	prev_indices = GetRingBufferIndices(outring_info);
+	prev_indices = get_ring_bufferindices(outring_info);
 
-	next_write_location = CopyToRingBuffer(outring_info,
+	next_write_location = copyto_ringbuffer(outring_info,
 					     next_write_location,
 					     &prev_indices,
 					     sizeof(u64));
@@ -412,7 +414,7 @@ int RingBufferWrite(struct hv_ring_buffer_info *outring_info,
 	mb();
 
 	/* Now, update the write location */
-	SetNextWriteLocation(outring_info, next_write_location);
+	set_next_write_location(outring_info, next_write_location);
 
 	/* Dumpring_info(Outring_info, "AFTER "); */
 
@@ -424,13 +426,13 @@ int RingBufferWrite(struct hv_ring_buffer_info *outring_info,
 /*++
 
 Name:
-	RingBufferPeek()
+	ringbuffer_peek()
 
 Description:
 	Read without advancing the read index
 
 --*/
-int RingBufferPeek(struct hv_ring_buffer_info *Inring_info,
+int ringbuffer_peek(struct hv_ring_buffer_info *Inring_info,
 		   void *Buffer, u32 buflen)
 {
 	u32 bytes_avail_towrite;
@@ -440,7 +442,7 @@ int RingBufferPeek(struct hv_ring_buffer_info *Inring_info,
 
 	spin_lock_irqsave(&Inring_info->ring_lock, flags);
 
-	GetRingBufferAvailBytes(Inring_info,
+	get_ringbuffer_availbytes(Inring_info,
 				&bytes_avail_toread,
 				&bytes_avail_towrite);
 
@@ -458,9 +460,9 @@ int RingBufferPeek(struct hv_ring_buffer_info *Inring_info,
 	}
 
 	/* Convert to byte offset */
-	next_read_location = GetNextReadLocation(Inring_info);
+	next_read_location = get_next_read_location(Inring_info);
 
-	next_read_location = CopyFromRingBuffer(Inring_info,
+	next_read_location = copyfrom_ringbuffer(Inring_info,
 						Buffer,
 						buflen,
 						next_read_location);
@@ -474,13 +476,13 @@ int RingBufferPeek(struct hv_ring_buffer_info *Inring_info,
 /*++
 
 Name:
-	RingBufferRead()
+	ringbuffer_read()
 
 Description:
 	Read and advance the read index
 
 --*/
-int RingBufferRead(struct hv_ring_buffer_info *inring_info, void *buffer,
+int ringbuffer_read(struct hv_ring_buffer_info *inring_info, void *buffer,
 		   u32 buflen, u32 offset)
 {
 	u32 bytes_avail_towrite;
@@ -494,7 +496,7 @@ int RingBufferRead(struct hv_ring_buffer_info *inring_info, void *buffer,
 
 	spin_lock_irqsave(&inring_info->ring_lock, flags);
 
-	GetRingBufferAvailBytes(inring_info,
+	get_ringbuffer_availbytes(inring_info,
 				&bytes_avail_toread,
 				&bytes_avail_towrite);
 
@@ -515,14 +517,15 @@ int RingBufferRead(struct hv_ring_buffer_info *inring_info, void *buffer,
 		return -1;
 	}
 
-	next_read_location = GetNextReadLocationWithOffset(inring_info, offset);
+	next_read_location =
+		get_next_readlocation_withoffset(inring_info, offset);
 
-	next_read_location = CopyFromRingBuffer(inring_info,
+	next_read_location = copyfrom_ringbuffer(inring_info,
 						buffer,
 						buflen,
 						next_read_location);
 
-	next_read_location = CopyFromRingBuffer(inring_info,
+	next_read_location = copyfrom_ringbuffer(inring_info,
 						&prev_indices,
 						sizeof(u64),
 						next_read_location);
@@ -533,7 +536,7 @@ int RingBufferRead(struct hv_ring_buffer_info *inring_info, void *buffer,
 	mb();
 
 	/* Update the read index */
-	SetNextReadLocation(inring_info, next_read_location);
+	set_next_read_location(inring_info, next_read_location);
 
 	/* Dumpring_info(Inring_info, "AFTER "); */
 
@@ -546,7 +549,7 @@ int RingBufferRead(struct hv_ring_buffer_info *inring_info, void *buffer,
 /*++
 
 Name:
-	CopyToRingBuffer()
+	copyto_ringbuffer()
 
 Description:
 	Helper routine to copy from source to ring buffer.
@@ -554,14 +557,14 @@ Description:
 
 --*/
 static u32
-CopyToRingBuffer(
+copyto_ringbuffer(
 	struct hv_ring_buffer_info	*ring_info,
 	u32				start_write_offset,
 	void				*src,
 	u32				srclen)
 {
-	void *ring_buffer = GetRingBuffer(ring_info);
-	u32 ring_buffer_size = GetRingBufferSize(ring_info);
+	void *ring_buffer = get_ring_buffer(ring_info);
+	u32 ring_buffer_size = get_ring_buffersize(ring_info);
 	u32 frag_len;
 
 	/* wrap-around detected! */
@@ -584,7 +587,7 @@ CopyToRingBuffer(
 /*++
 
 Name:
-	CopyFromRingBuffer()
+	copyfrom_ringbuffer()
 
 Description:
 	Helper routine to copy to source from ring buffer.
@@ -592,14 +595,14 @@ Description:
 
 --*/
 static u32
-CopyFromRingBuffer(
+copyfrom_ringbuffer(
 	struct hv_ring_buffer_info	*ring_info,
 	void				*dest,
 	u32				destlen,
 	u32				start_read_offset)
 {
-	void *ring_buffer = GetRingBuffer(ring_info);
-	u32 ring_buffer_size = GetRingBufferSize(ring_info);
+	void *ring_buffer = get_ring_buffer(ring_info);
+	u32 ring_buffer_size = get_ring_buffersize(ring_info);
 
 	u32 frag_len;
 
diff --git a/drivers/staging/hv/ring_buffer.h b/drivers/staging/hv/ring_buffer.h
index f30be1f..7bd6ecf 100644
--- a/drivers/staging/hv/ring_buffer.h
+++ b/drivers/staging/hv/ring_buffer.h
@@ -75,28 +75,28 @@ struct hv_ring_buffer_debug_info {
 /* Interface */
 
 
-int RingBufferInit(struct hv_ring_buffer_info *ring_info, void *buffer,
+int ringbuffer_init(struct hv_ring_buffer_info *ring_info, void *buffer,
 		   u32 buflen);
 
-void RingBufferCleanup(struct hv_ring_buffer_info *ring_info);
+void ringbuffer_cleanup(struct hv_ring_buffer_info *ring_info);
 
-int RingBufferWrite(struct hv_ring_buffer_info *ring_info,
+int ringbuffer_write(struct hv_ring_buffer_info *ring_info,
 		    struct scatterlist *sglist,
 		    u32 sgcount);
 
-int RingBufferPeek(struct hv_ring_buffer_info *ring_info, void *buffer,
+int ringbuffer_peek(struct hv_ring_buffer_info *ring_info, void *buffer,
 		   u32 buflen);
 
-int RingBufferRead(struct hv_ring_buffer_info *ring_info,
+int ringbuffer_read(struct hv_ring_buffer_info *ring_info,
 		   void *buffer,
 		   u32 buflen,
 		   u32 offset);
 
-u32 GetRingBufferInterruptMask(struct hv_ring_buffer_info *ring_info);
+u32 get_ringbuffer_interrupt_mask(struct hv_ring_buffer_info *ring_info);
 
-void Dumpring_info(struct hv_ring_buffer_info *ring_info, char *prefix);
+void dump_ring_info(struct hv_ring_buffer_info *ring_info, char *prefix);
 
-void RingBufferGetDebugInfo(struct hv_ring_buffer_info *ring_info,
+void ringbuffer_get_debuginfo(struct hv_ring_buffer_info *ring_info,
 			    struct hv_ring_buffer_debug_info *debug_info);
 
 #endif /* _RING_BUFFER_H_ */
-- 
1.6.3.2

