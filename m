Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab0ITVHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 17:07:54 -0400
Received: from mail1.microsoft.com ([131.107.115.212]:51107 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab0ITVHx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 17:07:53 -0400
From: Haiyang Zhang <haiyangz@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>,
        "'gregkh@suse.de'" <gregkh@suse.de>
CC: Hank Janssen <hjanssen@microsoft.com>
Subject: [PATCH 1/2] staging: hv: Remove camel cases of vmbus packet buffer
 structures
Thread-Topic: [PATCH 1/2] staging: hv: Remove camel cases of vmbus packet
 buffer structures
Thread-Index: AQHLWQfiS36W6XvdqE6/0vYsEr4QKw==
Date: Mon, 20 Sep 2010 21:07:51 +0000
Message-ID: <1FB5E1D5CA062146B38059374562DF7289E499C5@TK5EX14MBXC121.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

Remove camel cases of vmbus packet buffer structures
 Remove camel cases of:
 struct VMBUS_CHANNEL_PACKET_PAGE_BUFFER
 struct VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER

Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/blkvsc.c  |    2 +-
 drivers/staging/hv/channel.c |   48 +++++++++++++++++++++---------------------
 drivers/staging/hv/channel.h |   36 +++++++++++++++---------------
 drivers/staging/hv/storvsc.c |    2 +-
 drivers/staging/hv/vmbus.c   |    6 ++--
 5 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/staging/hv/blkvsc.c b/drivers/staging/hv/blkvsc.c
index 929238a..d5b0abd 100644
--- a/drivers/staging/hv/blkvsc.c
+++ b/drivers/staging/hv/blkvsc.c
@@ -81,7 +81,7 @@ int BlkVscInitialize(struct hv_driver *Driver)
 	 * Divide the ring buffer data size (which is 1 page less than the ring
 	 * buffer size since that page is reserved for the ring buffer indices)
 	 * by the max request size (which is
-	 * VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER + struct vstor_packet + u64)
+	 * vmbus_channel_packet_multipage_buffer + struct vstor_packet + u64)
 	 */
 	storDriver->MaxOutstandingRequestsPerChannel =
 		((storDriver->RingBufferSize - PAGE_SIZE) /
diff --git a/drivers/staging/hv/channel.c b/drivers/staging/hv/channel.c
index fece30c..37b7b4c 100644
--- a/drivers/staging/hv/channel.c
+++ b/drivers/staging/hv/channel.c
@@ -765,7 +765,7 @@ int VmbusChannelSendPacketPageBuffer(struct vmbus_channel *Channel,
 {
 	int ret;
 	int i;
-	struct VMBUS_CHANNEL_PACKET_PAGE_BUFFER desc;
+	struct vmbus_channel_packet_page_buffer desc;
 	u32 descSize;
 	u32 packetLen;
 	u32 packetLenAligned;
@@ -778,10 +778,10 @@ int VmbusChannelSendPacketPageBuffer(struct vmbus_channel *Channel,
 	DumpVmbusChannel(Channel);
 
 	/*
-	 * Adjust the size down since VMBUS_CHANNEL_PACKET_PAGE_BUFFER is the
+	 * Adjust the size down since vmbus_channel_packet_page_buffer is the
 	 * largest size we support
 	 */
-	descSize = sizeof(struct VMBUS_CHANNEL_PACKET_PAGE_BUFFER) -
+	descSize = sizeof(struct vmbus_channel_packet_page_buffer) -
 			  ((MAX_PAGE_BUFFER_COUNT - PageCount) *
 			  sizeof(struct hv_page_buffer));
 	packetLen = descSize + BufferLen;
@@ -790,17 +790,17 @@ int VmbusChannelSendPacketPageBuffer(struct vmbus_channel *Channel,
 	/* ASSERT((packetLenAligned - packetLen) < sizeof(u64)); */
 
 	/* Setup the descriptor */
-	desc.Type = VmbusPacketTypeDataUsingGpaDirect;
-	desc.Flags = VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED;
-	desc.DataOffset8 = descSize >> 3; /* in 8-bytes grandularity */
-	desc.Length8 = (u16)(packetLenAligned >> 3);
-	desc.TransactionId = RequestId;
-	desc.RangeCount = PageCount;
+	desc.type = VmbusPacketTypeDataUsingGpaDirect;
+	desc.flags = VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED;
+	desc.dataoffset8 = descSize >> 3; /* in 8-bytes grandularity */
+	desc.length8 = (u16)(packetLenAligned >> 3);
+	desc.transactionid = RequestId;
+	desc.rangecount = PageCount;
 
 	for (i = 0; i < PageCount; i++) {
-		desc.Range[i].Length = PageBuffers[i].Length;
-		desc.Range[i].Offset = PageBuffers[i].Offset;
-		desc.Range[i].Pfn	 = PageBuffers[i].Pfn;
+		desc.range[i].Length = PageBuffers[i].Length;
+		desc.range[i].Offset = PageBuffers[i].Offset;
+		desc.range[i].Pfn	 = PageBuffers[i].Pfn;
 	}
 
 	sg_init_table(bufferList, 3);
@@ -826,7 +826,7 @@ int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *Channel,
 				void *Buffer, u32 BufferLen, u64 RequestId)
 {
 	int ret;
-	struct VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER desc;
+	struct vmbus_channel_packet_multipage_buffer desc;
 	u32 descSize;
 	u32 packetLen;
 	u32 packetLenAligned;
@@ -844,10 +844,10 @@ int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *Channel,
 		return -EINVAL;
 
 	/*
-	 * Adjust the size down since VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER is
+	 * Adjust the size down since vmbus_channel_packet_multipage_buffer is
 	 * the largest size we support
 	 */
-	descSize = sizeof(struct VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER) -
+	descSize = sizeof(struct vmbus_channel_packet_multipage_buffer) -
 			  ((MAX_MULTIPAGE_BUFFER_COUNT - PfnCount) *
 			  sizeof(u64));
 	packetLen = descSize + BufferLen;
@@ -856,17 +856,17 @@ int VmbusChannelSendPacketMultiPageBuffer(struct vmbus_channel *Channel,
 	/* ASSERT((packetLenAligned - packetLen) < sizeof(u64)); */
 
 	/* Setup the descriptor */
-	desc.Type = VmbusPacketTypeDataUsingGpaDirect;
-	desc.Flags = VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED;
-	desc.DataOffset8 = descSize >> 3; /* in 8-bytes grandularity */
-	desc.Length8 = (u16)(packetLenAligned >> 3);
-	desc.TransactionId = RequestId;
-	desc.RangeCount = 1;
+	desc.type = VmbusPacketTypeDataUsingGpaDirect;
+	desc.flags = VMBUS_DATA_PACKET_FLAG_COMPLETION_REQUESTED;
+	desc.dataoffset8 = descSize >> 3; /* in 8-bytes grandularity */
+	desc.length8 = (u16)(packetLenAligned >> 3);
+	desc.transactionid = RequestId;
+	desc.rangecount = 1;
 
-	desc.Range.Length = MultiPageBuffer->Length;
-	desc.Range.Offset = MultiPageBuffer->Offset;
+	desc.range.Length = MultiPageBuffer->Length;
+	desc.range.Offset = MultiPageBuffer->Offset;
 
-	memcpy(desc.Range.PfnArray, MultiPageBuffer->PfnArray,
+	memcpy(desc.range.PfnArray, MultiPageBuffer->PfnArray,
 	       PfnCount * sizeof(u64));
 
 	sg_init_table(bufferList, 3);
diff --git a/drivers/staging/hv/channel.h b/drivers/staging/hv/channel.h
index acb2c55..85c5079 100644
--- a/drivers/staging/hv/channel.h
+++ b/drivers/staging/hv/channel.h
@@ -28,27 +28,27 @@
 #include "channel_mgmt.h"
 
 /* The format must be the same as struct vmdata_gpa_direct */
-struct VMBUS_CHANNEL_PACKET_PAGE_BUFFER {
-	u16 Type;
-	u16 DataOffset8;
-	u16 Length8;
-	u16 Flags;
-	u64 TransactionId;
-	u32 Reserved;
-	u32 RangeCount;
-	struct hv_page_buffer Range[MAX_PAGE_BUFFER_COUNT];
+struct vmbus_channel_packet_page_buffer {
+	u16 type;
+	u16 dataoffset8;
+	u16 length8;
+	u16 flags;
+	u64 transactionid;
+	u32 reserved;
+	u32 rangecount;
+	struct hv_page_buffer range[MAX_PAGE_BUFFER_COUNT];
 } __attribute__((packed));
 
 /* The format must be the same as struct vmdata_gpa_direct */
-struct VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER {
-	u16 Type;
-	u16 DataOffset8;
-	u16 Length8;
-	u16 Flags;
-	u64 TransactionId;
-	u32 Reserved;
-	u32 RangeCount;		/* Always 1 in this case */
-	struct hv_multipage_buffer Range;
+struct vmbus_channel_packet_multipage_buffer {
+	u16 type;
+	u16 dataoffset8;
+	u16 length8;
+	u16 flags;
+	u64 transactionid;
+	u32 reserved;
+	u32 rangecount;		/* Always 1 in this case */
+	struct hv_multipage_buffer range;
 } __attribute__((packed));
 
 
diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 6bd2ff1..6821a8f 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -799,7 +799,7 @@ int StorVscInitialize(struct hv_driver *Driver)
 	 * Divide the ring buffer data size (which is 1 page less
 	 * than the ring buffer size since that page is reserved for
 	 * the ring buffer indices) by the max request size (which is
-	 * VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER + struct vstor_packet + u64)
+	 * vmbus_channel_packet_multipage_buffer + struct vstor_packet + u64)
 	 */
 	storDriver->MaxOutstandingRequestsPerChannel =
 		((storDriver->RingBufferSize - PAGE_SIZE) /
diff --git a/drivers/staging/hv/vmbus.c b/drivers/staging/hv/vmbus.c
index db2afa3..ea2698c 100644
--- a/drivers/staging/hv/vmbus.c
+++ b/drivers/staging/hv/vmbus.c
@@ -255,10 +255,10 @@ int VmbusInitialize(struct hv_driver *drv)
 			VMBUS_REVISION_NUMBER);
 	DPRINT_INFO(VMBUS, "+++++++ Vmbus using SINT %d +++++++",
 			VMBUS_MESSAGE_SINT);
-	DPRINT_DBG(VMBUS, "sizeof(VMBUS_CHANNEL_PACKET_PAGE_BUFFER)=%zd, "
+	DPRINT_DBG(VMBUS, "sizeof(vmbus_channel_packet_page_buffer)=%zd, "
 			"sizeof(VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER)=%zd",
-			sizeof(struct VMBUS_CHANNEL_PACKET_PAGE_BUFFER),
-			sizeof(struct VMBUS_CHANNEL_PACKET_MULITPAGE_BUFFER));
+			sizeof(struct vmbus_channel_packet_page_buffer),
+			sizeof(struct vmbus_channel_packet_multipage_buffer));
 
 	drv->name = gDriverName;
 	memcpy(&drv->deviceType, &gVmbusDeviceType, sizeof(struct hv_guid));
-- 
1.6.3.2

