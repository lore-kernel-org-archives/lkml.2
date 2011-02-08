Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1BHOwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 09:52:47 -0500
Received: from miraculix-out.informatik.uni-kiel.de ([134.245.248.209]:53600
	"EHLO miraculix.informatik.uni-kiel.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752519Ab1BHOwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 09:52:45 -0500
From: Timo von Holtz <tvh@informatik.uni-kiel.de>
To: gregkh@suse.de
Cc: hjanssen@microsoft.com, haiyangz@microsoft.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Timo von Holtz <tvh@informatik.uni-kiel.de>
Subject: [PATCH 1/2] Staging: hv: replaced __attribute((packed)) with __packed
Date: Tue,  8 Feb 2011 15:52:21 +0100
Message-Id: <1297176742-9329-1-git-send-email-tvh@informatik.uni-kiel.de>
X-Mailer: git-send-email 1.7.4
X-Null-Tag: 2d185b9561a4ee6de1d42437bbf42602
X-Authenticated-Sender: user tvh from 86.103.149.108
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replaced __attribute((packed)) with __packed as it's preferred

Signed-off-by: Timo von Holtz <tvh@informatik.uni-kiel.de>
---
 drivers/staging/hv/channel.h                 |    4 +-
 drivers/staging/hv/channel_mgmt.h            |   36 +++++++++++++-------------
 drivers/staging/hv/netvsc.h                  |   26 +++++++++---------
 drivers/staging/hv/ring_buffer.h             |    2 +-
 drivers/staging/hv/utils.h                   |   14 +++++-----
 drivers/staging/hv/vmbus_channel_interface.h |    2 +-
 drivers/staging/hv/vmbus_packet_format.h     |   20 +++++++-------
 drivers/staging/hv/vstorage.h                |    6 ++--
 8 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/staging/hv/channel.h b/drivers/staging/hv/channel.h
index 7997056..de4f867 100644
--- a/drivers/staging/hv/channel.h
+++ b/drivers/staging/hv/channel.h
@@ -37,7 +37,7 @@ struct vmbus_channel_packet_page_buffer {
 	u32 reserved;
 	u32 rangecount;
 	struct hv_page_buffer range[MAX_PAGE_BUFFER_COUNT];
-} __attribute__((packed));
+} __packed;
 
 /* The format must be the same as struct vmdata_gpa_direct */
 struct vmbus_channel_packet_multipage_buffer {
@@ -49,7 +49,7 @@ struct vmbus_channel_packet_multipage_buffer {
 	u32 reserved;
 	u32 rangecount;		/* Always 1 in this case */
 	struct hv_multipage_buffer range;
-} __attribute__((packed));
+} __packed;
 
 
 extern int vmbus_open(struct vmbus_channel *channel,
diff --git a/drivers/staging/hv/channel_mgmt.h b/drivers/staging/hv/channel_mgmt.h
index de6b2a0..fe40bf2 100644
--- a/drivers/staging/hv/channel_mgmt.h
+++ b/drivers/staging/hv/channel_mgmt.h
@@ -60,19 +60,19 @@ enum vmbus_channel_message_type {
 struct vmbus_channel_message_header {
 	enum vmbus_channel_message_type msgtype;
 	u32 padding;
-} __attribute__((packed));
+} __packed;
 
 /* Query VMBus Version parameters */
 struct vmbus_channel_query_vmbus_version {
 	struct vmbus_channel_message_header header;
 	u32 version;
-} __attribute__((packed));
+} __packed;
 
 /* VMBus Version Supported parameters */
 struct vmbus_channel_version_supported {
 	struct vmbus_channel_message_header header;
 	bool version_supported;
-} __attribute__((packed));
+} __packed;
 
 /* Offer Channel parameters */
 struct vmbus_channel_offer_channel {
@@ -81,13 +81,13 @@ struct vmbus_channel_offer_channel {
 	u32 child_relid;
 	u8 monitorid;
 	bool monitor_allocated;
-} __attribute__((packed));
+} __packed;
 
 /* Rescind Offer parameters */
 struct vmbus_channel_rescind_offer {
 	struct vmbus_channel_message_header header;
 	u32 child_relid;
-} __attribute__((packed));
+} __packed;
 
 /*
  * Request Offer -- no parameters, SynIC message contains the partition ID
@@ -123,7 +123,7 @@ struct vmbus_channel_open_channel {
 
 	/* User-specific data to be passed along to the server endpoint. */
 	unsigned char userdata[MAX_USER_DEFINED_BYTES];
-} __attribute__((packed));
+} __packed;
 
 /* Open Channel Result parameters */
 struct vmbus_channel_open_result {
@@ -131,13 +131,13 @@ struct vmbus_channel_open_result {
 	u32 child_relid;
 	u32 openid;
 	u32 status;
-} __attribute__((packed));
+} __packed;
 
 /* Close channel parameters; */
 struct vmbus_channel_close_channel {
 	struct vmbus_channel_message_header header;
 	u32 child_relid;
-} __attribute__((packed));
+} __packed;
 
 /* Channel Message GPADL */
 #define GPADL_TYPE_RING_BUFFER		1
@@ -157,7 +157,7 @@ struct vmbus_channel_gpadl_header {
 	u16 range_buflen;
 	u16 rangecount;
 	struct gpa_range range[0];
-} __attribute__((packed));
+} __packed;
 
 /* This is the followup packet that contains more PFNs. */
 struct vmbus_channel_gpadl_body {
@@ -165,25 +165,25 @@ struct vmbus_channel_gpadl_body {
 	u32 msgnumber;
 	u32 gpadl;
 	u64 pfn[0];
-} __attribute__((packed));
+} __packed;
 
 struct vmbus_channel_gpadl_created {
 	struct vmbus_channel_message_header header;
 	u32 child_relid;
 	u32 gpadl;
 	u32 creation_status;
-} __attribute__((packed));
+} __packed;
 
 struct vmbus_channel_gpadl_teardown {
 	struct vmbus_channel_message_header header;
 	u32 child_relid;
 	u32 gpadl;
-} __attribute__((packed));
+} __packed;
 
 struct vmbus_channel_gpadl_torndown {
 	struct vmbus_channel_message_header header;
 	u32 gpadl;
-} __attribute__((packed));
+} __packed;
 
 #ifdef VMBUS_FEATURE_PARENT_OR_PEER_MEMORY_MAPPED_INTO_A_CHILD
 struct vmbus_channel_view_range_add {
@@ -191,19 +191,19 @@ struct vmbus_channel_view_range_add {
 	PHYSICAL_ADDRESS viewrange_base;
 	u64 viewrange_length;
 	u32 child_relid;
-} __attribute__((packed));
+} __packed;
 
 struct vmbus_channel_view_range_remove {
 	struct vmbus_channel_message_header header;
 	PHYSICAL_ADDRESS viewrange_base;
 	u32 child_relid;
-} __attribute__((packed));
+} __packed;
 #endif
 
 struct vmbus_channel_relid_released {
 	struct vmbus_channel_message_header header;
 	u32 child_relid;
-} __attribute__((packed));
+} __packed;
 
 struct vmbus_channel_initiate_contact {
 	struct vmbus_channel_message_header header;
@@ -212,12 +212,12 @@ struct vmbus_channel_initiate_contact {
 	u64 interrupt_page;
 	u64 monitor_page1;
 	u64 monitor_page2;
-} __attribute__((packed));
+} __packed;
 
 struct vmbus_channel_version_response {
 	struct vmbus_channel_message_header header;
 	bool version_supported;
-} __attribute__((packed));
+} __packed;
 
 enum vmbus_channel_state {
 	CHANNEL_OFFER_STATE,
diff --git a/drivers/staging/hv/netvsc.h b/drivers/staging/hv/netvsc.h
index 932a77c..5f6dcf1 100644
--- a/drivers/staging/hv/netvsc.h
+++ b/drivers/staging/hv/netvsc.h
@@ -92,7 +92,7 @@ struct nvsp_message_header {
 struct nvsp_message_init {
 	u32 min_protocol_ver;
 	u32 max_protocol_ver;
-} __attribute__((packed));
+} __packed;
 
 /*
  * This message is used by the VSP to complete the initialization of the
@@ -103,12 +103,12 @@ struct nvsp_message_init_complete {
 	u32 negotiated_protocol_ver;
 	u32 max_mdl_chain_len;
 	u32 status;
-} __attribute__((packed));
+} __packed;
 
 union nvsp_message_init_uber {
 	struct nvsp_message_init init;
 	struct nvsp_message_init_complete init_complete;
-} __attribute__((packed));
+} __packed;
 
 /* Version 1 Messages */
 
@@ -119,7 +119,7 @@ union nvsp_message_init_uber {
 struct nvsp_1_message_send_ndis_version {
 	u32 ndis_major_ver;
 	u32 ndis_minor_ver;
-} __attribute__((packed));
+} __packed;
 
 /*
  * This message is used by the VSC to send a receive buffer to the VSP. The VSP
@@ -128,14 +128,14 @@ struct nvsp_1_message_send_ndis_version {
 struct nvsp_1_message_send_receive_buffer {
 	u32 gpadl_handle;
 	u16 id;
-} __attribute__((packed));
+} __packed;
 
 struct nvsp_1_receive_buffer_section {
 	u32 offset;
 	u32 sub_alloc_size;
 	u32 num_sub_allocs;
 	u32 end_offset;
-} __attribute__((packed));
+} __packed;
 
 /*
  * This message is used by the VSP to acknowledge a receive buffer send by the
@@ -166,7 +166,7 @@ struct nvsp_1_message_send_receive_buffer_complete {
 	 */
 
 	struct nvsp_1_receive_buffer_section sections[1];
-} __attribute__((packed));
+} __packed;
 
 /*
  * This message is sent by the VSC to revoke the receive buffer.  After the VSP
@@ -184,7 +184,7 @@ struct nvsp_1_message_revoke_receive_buffer {
 struct nvsp_1_message_send_send_buffer {
 	u32 gpadl_handle;
 	u16 id;
-} __attribute__((packed));
+} __packed;
 
 /*
  * This message is used by the VSP to acknowledge a send buffer sent by the
@@ -201,7 +201,7 @@ struct nvsp_1_message_send_send_buffer_complete {
 	 * decreases.
 	 */
 	u32 section_size;
-} __attribute__((packed));
+} __packed;
 
 /*
  * This message is sent by the VSC to revoke the send buffer.  After the VSP
@@ -231,7 +231,7 @@ struct nvsp_1_message_send_rndis_packet {
 	 */
 	u32 send_buf_section_index;
 	u32 send_buf_section_size;
-} __attribute__((packed));
+} __packed;
 
 /*
  * This message is used by both the VSP and the VSC to complete a RNDIS message
@@ -257,18 +257,18 @@ union nvsp_1_message_uber {
 	struct nvsp_1_message_send_rndis_packet send_rndis_pkt;
 	struct nvsp_1_message_send_rndis_packet_complete
 						send_rndis_pkt_complete;
-} __attribute__((packed));
+} __packed;
 
 union nvsp_all_messages {
 	union nvsp_message_init_uber init_msg;
 	union nvsp_1_message_uber v1_msg;
-} __attribute__((packed));
+} __packed;
 
 /* ALL Messages */
 struct nvsp_message {
 	struct nvsp_message_header hdr;
 	union nvsp_all_messages msg;
-} __attribute__((packed));
+} __packed;
 
 
 
diff --git a/drivers/staging/hv/ring_buffer.h b/drivers/staging/hv/ring_buffer.h
index 7bd6ecf..7bf20d6 100644
--- a/drivers/staging/hv/ring_buffer.h
+++ b/drivers/staging/hv/ring_buffer.h
@@ -51,7 +51,7 @@ struct hv_ring_buffer {
 	 * !!! DO NOT place any fields below this !!!
 	 */
 	u8 buffer[0];
-} __attribute__((packed));
+} __packed;
 
 struct hv_ring_buffer_info {
 	struct hv_ring_buffer *ring_buffer;
diff --git a/drivers/staging/hv/utils.h b/drivers/staging/hv/utils.h
index 6d27d15..acebbbf 100644
--- a/drivers/staging/hv/utils.h
+++ b/drivers/staging/hv/utils.h
@@ -43,12 +43,12 @@
 struct vmbuspipe_hdr {
 	u32 flags;
 	u32 msgsize;
-} __attribute__((packed));
+} __packed;
 
 struct ic_version {
 	u16 major;
 	u16 minor;
-} __attribute__((packed));
+} __packed;
 
 struct icmsg_hdr {
 	struct ic_version icverframe;
@@ -59,26 +59,26 @@ struct icmsg_hdr {
 	u8 ictransaction_id;
 	u8 icflags;
 	u8 reserved[2];
-} __attribute__((packed));
+} __packed;
 
 struct icmsg_negotiate {
 	u16 icframe_vercnt;
 	u16 icmsg_vercnt;
 	u32 reserved;
 	struct ic_version icversion_data[1]; /* any size array */
-} __attribute__((packed));
+} __packed;
 
 struct shutdown_msg_data {
 	u32 reason_code;
 	u32 timeout_seconds;
 	u32 flags;
 	u8  display_message[2048];
-} __attribute__((packed));
+} __packed;
 
 struct heartbeat_msg_data {
 	u64 seq_num;
 	u32 reserved[8];
-} __attribute__((packed));
+} __packed;
 
 /* Time Sync IC defs */
 #define ICTIMESYNCFLAG_PROBE	0
@@ -96,7 +96,7 @@ struct ictimesync_data{
 	u64 childtime;
 	u64 roundtriptime;
 	u8 flags;
-} __attribute__((packed));
+} __packed;
 
 /* Index for each IC struct in array hv_cb_utils[] */
 #define HV_SHUTDOWN_MSG		0
diff --git a/drivers/staging/hv/vmbus_channel_interface.h b/drivers/staging/hv/vmbus_channel_interface.h
index fbfad5e..20ae258 100644
--- a/drivers/staging/hv/vmbus_channel_interface.h
+++ b/drivers/staging/hv/vmbus_channel_interface.h
@@ -75,7 +75,7 @@ struct vmbus_channel_offer {
 		} pipe;
 	} u;
 	u32 padding;
-} __attribute__((packed));
+} __packed;
 
 /* Server Flags */
 #define VMBUS_CHANNEL_ENUMERATE_DEVICE_INTERFACE	1
diff --git a/drivers/staging/hv/vmbus_packet_format.h b/drivers/staging/hv/vmbus_packet_format.h
index 5cb13e5..c0b2c2b 100644
--- a/drivers/staging/hv/vmbus_packet_format.h
+++ b/drivers/staging/hv/vmbus_packet_format.h
@@ -30,17 +30,17 @@ struct vmpacket_descriptor {
 	u16 len8;
 	u16 flags;
 	u64 trans_id;
-} __attribute__((packed));
+} __packed;
 
 struct vmpacket_header {
 	u32 prev_pkt_start_offset;
 	struct vmpacket_descriptor descriptor;
-} __attribute__((packed));
+} __packed;
 
 struct vmtransfer_page_range {
 	u32 byte_count;
 	u32 byte_offset;
-} __attribute__((packed));
+} __packed;
 
 struct vmtransfer_page_packet_header {
 	struct vmpacket_descriptor d;
@@ -49,20 +49,20 @@ struct vmtransfer_page_packet_header {
 	u8 reserved;
 	u32 range_cnt;
 	struct vmtransfer_page_range ranges[1];
-} __attribute__((packed));
+} __packed;
 
 struct vmgpadl_packet_header {
 	struct vmpacket_descriptor d;
 	u32 gpadl;
 	u32 reserved;
-} __attribute__((packed));
+} __packed;
 
 struct vmadd_remove_transfer_page_set {
 	struct vmpacket_descriptor d;
 	u32 gpadl;
 	u16 xfer_pageset_id;
 	u16 reserved;
-} __attribute__((packed));
+} __packed;
 
 /*
  * This structure defines a range in guest physical space that can be made to
@@ -86,7 +86,7 @@ struct vmestablish_gpadl {
 	u32 gpadl;
 	u32 range_cnt;
 	struct gpa_range range[1];
-} __attribute__((packed));
+} __packed;
 
 /*
  * This is the format for a Teardown Gpadl packet, which indicates that the
@@ -96,7 +96,7 @@ struct vmteardown_gpadl {
 	struct vmpacket_descriptor d;
 	u32 gpadl;
 	u32 reserved;	/* for alignment to a 8-byte boundary */
-} __attribute__((packed));
+} __packed;
 
 /*
  * This is the format for a GPA-Direct packet, which contains a set of GPA
@@ -107,7 +107,7 @@ struct vmdata_gpa_direct {
 	u32 reserved;
 	u32 range_cnt;
 	struct gpa_range range[1];
-} __attribute__((packed));
+} __packed;
 
 /* This is the format for a Additional Data Packet. */
 struct vmadditional_data {
@@ -116,7 +116,7 @@ struct vmadditional_data {
 	u32 offset;
 	u32 byte_cnt;
 	unsigned char data[1];
-} __attribute__((packed));
+} __packed;
 
 union vmpacket_largest_possible_header {
 	struct vmpacket_descriptor simple_hdr;
diff --git a/drivers/staging/hv/vstorage.h b/drivers/staging/hv/vstorage.h
index ae8be84..ebb4d67 100644
--- a/drivers/staging/hv/vstorage.h
+++ b/drivers/staging/hv/vstorage.h
@@ -135,7 +135,7 @@ struct vmstorage_channel_properties {
 	/*  This id is unique for each channel and will correspond with */
 	/*  vendor specific data in the inquirydata */
 	unsigned long long unique_id;
-} __attribute__((packed));
+} __packed;
 
 /*  This structure is sent during the storage protocol negotiations. */
 struct vmstorage_protocol_version {
@@ -149,7 +149,7 @@ struct vmstorage_protocol_version {
 	 * builds.
 	 */
 	unsigned short revision;
-} __attribute__((packed));
+} __packed;
 
 /* Channel Property Flags */
 #define STORAGE_CHANNEL_REMOVABLE_FLAG		0x1
@@ -179,7 +179,7 @@ struct vstor_packet {
 		/* Used during version negotiations. */
 		struct vmstorage_protocol_version version;
 	};
-} __attribute__((packed));
+} __packed;
 
 /* Packet flags */
 /*
-- 
1.7.4

