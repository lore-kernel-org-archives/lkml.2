Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab0LFUbF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:31:05 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:52454
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754487Ab0LFU36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:29:58 -0500
From: Hank Janssen <hjanssen@microsoft.com>
To: hjanssen@microsoft.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org
Cc: Abhishek Kane <v-abkane@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/8] staging: hv: Convert camel case struct fields in vstorage.h to lowercase
Date: Mon,  6 Dec 2010 12:26:44 -0800
Message-Id: <1291667211-1865-1-git-send-email-hjanssen@microsoft.com>
X-Mailer: git-send-email 1.5.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hank Janssen <hjanssen@microsoft.com>

Convert camel case struct fields in vstorage.h to lowercase

Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Hank Janssen <hjanssen@microsoft.com>

---
 drivers/staging/hv/storvsc.c  |  133 +++++++++++++++++++++--------------------
 drivers/staging/hv/vstorage.h |  106 ++++++++++++++++----------------
 2 files changed, 120 insertions(+), 119 deletions(-)

diff --git a/drivers/staging/hv/storvsc.c b/drivers/staging/hv/storvsc.c
index 525c8ee..96b4ed9 100644
--- a/drivers/staging/hv/storvsc.c
+++ b/drivers/staging/hv/storvsc.c
@@ -204,8 +204,8 @@ static int StorVscChannelInit(struct hv_device *Device)
 		goto nomem;
 	}
 
-	vstorPacket->Operation = VStorOperationBeginInitialization;
-	vstorPacket->Flags = REQUEST_COMPLETION_FLAG;
+	vstorPacket->operation = VSTOR_OPERATION_BEGIN_INITIALIZATION;
+	vstorPacket->flags = REQUEST_COMPLETION_FLAG;
 
 	/*SpinlockAcquire(gDriverExt.packetListLock);
 	INSERT_TAIL_LIST(&gDriverExt.packetList, &packet->listEntry.entry);
@@ -226,11 +226,11 @@ static int StorVscChannelInit(struct hv_device *Device)
 
 	osd_waitevent_wait(request->WaitEvent);
 
-	if (vstorPacket->Operation != VStorOperationCompleteIo ||
-	    vstorPacket->Status != 0) {
+	if (vstorPacket->operation != VSTOR_OPERATION_COMPLETE_IO ||
+	    vstorPacket->status != 0) {
 		DPRINT_ERR(STORVSC, "BEGIN_INITIALIZATION_OPERATION failed "
 			   "(op %d status 0x%x)",
-			   vstorPacket->Operation, vstorPacket->Status);
+			   vstorPacket->operation, vstorPacket->status);
 		goto Cleanup;
 	}
 
@@ -238,11 +238,11 @@ static int StorVscChannelInit(struct hv_device *Device)
 
 	/* reuse the packet for version range supported */
 	memset(vstorPacket, 0, sizeof(struct vstor_packet));
-	vstorPacket->Operation = VStorOperationQueryProtocolVersion;
-	vstorPacket->Flags = REQUEST_COMPLETION_FLAG;
+	vstorPacket->operation = VSTOR_OPERATION_QUERY_PROTOCOL_VERSION;
+	vstorPacket->flags = REQUEST_COMPLETION_FLAG;
 
-	vstorPacket->Version.MajorMinor = VMSTOR_PROTOCOL_VERSION_CURRENT;
-	FILL_VMSTOR_REVISION(vstorPacket->Version.Revision);
+	vstorPacket->version.major_minor = VMSTOR_PROTOCOL_VERSION_CURRENT;
+	FILL_VMSTOR_REVISION(vstorPacket->version.revision);
 
 	ret = vmbus_sendpacket(Device->channel, vstorPacket,
 			       sizeof(struct vstor_packet),
@@ -258,11 +258,11 @@ static int StorVscChannelInit(struct hv_device *Device)
 	osd_waitevent_wait(request->WaitEvent);
 
 	/* TODO: Check returned version */
-	if (vstorPacket->Operation != VStorOperationCompleteIo ||
-	    vstorPacket->Status != 0) {
+	if (vstorPacket->operation != VSTOR_OPERATION_COMPLETE_IO ||
+	    vstorPacket->status != 0) {
 		DPRINT_ERR(STORVSC, "QUERY_PROTOCOL_VERSION_OPERATION failed "
 			   "(op %d status 0x%x)",
-			   vstorPacket->Operation, vstorPacket->Status);
+			   vstorPacket->operation, vstorPacket->status);
 		goto Cleanup;
 	}
 
@@ -270,9 +270,9 @@ static int StorVscChannelInit(struct hv_device *Device)
 	DPRINT_INFO(STORVSC, "QUERY_PROPERTIES_OPERATION...");
 
 	memset(vstorPacket, 0, sizeof(struct vstor_packet));
-	vstorPacket->Operation = VStorOperationQueryProperties;
-	vstorPacket->Flags = REQUEST_COMPLETION_FLAG;
-	vstorPacket->StorageChannelProperties.PortNumber =
+	vstorPacket->operation = VSTOR_OPERATION_QUERY_PROPERTIES;
+	vstorPacket->flags = REQUEST_COMPLETION_FLAG;
+	vstorPacket->storage_channel_properties.port_number =
 					storDevice->PortNumber;
 
 	ret = vmbus_sendpacket(Device->channel, vstorPacket,
@@ -290,26 +290,27 @@ static int StorVscChannelInit(struct hv_device *Device)
 	osd_waitevent_wait(request->WaitEvent);
 
 	/* TODO: Check returned version */
-	if (vstorPacket->Operation != VStorOperationCompleteIo ||
-	    vstorPacket->Status != 0) {
+	if (vstorPacket->operation != VSTOR_OPERATION_COMPLETE_IO ||
+	    vstorPacket->status != 0) {
 		DPRINT_ERR(STORVSC, "QUERY_PROPERTIES_OPERATION failed "
 			   "(op %d status 0x%x)",
-			   vstorPacket->Operation, vstorPacket->Status);
+			   vstorPacket->operation, vstorPacket->status);
 		goto Cleanup;
 	}
 
-	storDevice->PathId = vstorPacket->StorageChannelProperties.PathId;
-	storDevice->TargetId = vstorPacket->StorageChannelProperties.TargetId;
+	storDevice->PathId = vstorPacket->storage_channel_properties.path_id;
+	storDevice->TargetId
+		= vstorPacket->storage_channel_properties.target_id;
 
 	DPRINT_DBG(STORVSC, "channel flag 0x%x, max xfer len 0x%x",
-		   vstorPacket->StorageChannelProperties.Flags,
-		   vstorPacket->StorageChannelProperties.MaxTransferBytes);
+		   vstorPacket->storage_channel_properties.flags,
+		   vstorPacket->storage_channel_properties.max_transfer_bytes);
 
 	DPRINT_INFO(STORVSC, "END_INITIALIZATION_OPERATION...");
 
 	memset(vstorPacket, 0, sizeof(struct vstor_packet));
-	vstorPacket->Operation = VStorOperationEndInitialization;
-	vstorPacket->Flags = REQUEST_COMPLETION_FLAG;
+	vstorPacket->operation = VSTOR_OPERATION_END_INITIALIZATION;
+	vstorPacket->flags = REQUEST_COMPLETION_FLAG;
 
 	ret = vmbus_sendpacket(Device->channel, vstorPacket,
 			       sizeof(struct vstor_packet),
@@ -325,11 +326,11 @@ static int StorVscChannelInit(struct hv_device *Device)
 
 	osd_waitevent_wait(request->WaitEvent);
 
-	if (vstorPacket->Operation != VStorOperationCompleteIo ||
-	    vstorPacket->Status != 0) {
+	if (vstorPacket->operation != VSTOR_OPERATION_COMPLETE_IO ||
+	    vstorPacket->status != 0) {
 		DPRINT_ERR(STORVSC, "END_INITIALIZATION_OPERATION failed "
 			   "(op %d status 0x%x)",
-			   vstorPacket->Operation, vstorPacket->Status);
+			   vstorPacket->operation, vstorPacket->status);
 		goto Cleanup;
 	}
 
@@ -359,7 +360,7 @@ static void StorVscOnIOCompletion(struct hv_device *Device,
 
 	DPRINT_DBG(STORVSC, "IO_COMPLETE_OPERATION - request extension %p "
 		   "completed bytes xfer %u", RequestExt,
-		   VStorPacket->VmSrb.DataTransferLength);
+		   VStorPacket->vm_srb.data_transfer_length);
 
 	/* ASSERT(RequestExt != NULL); */
 	/* ASSERT(RequestExt->Request != NULL); */
@@ -369,36 +370,36 @@ static void StorVscOnIOCompletion(struct hv_device *Device,
 	/* ASSERT(request->OnIOCompletion != NULL); */
 
 	/* Copy over the status...etc */
-	request->Status = VStorPacket->VmSrb.ScsiStatus;
+	request->Status = VStorPacket->vm_srb.scsi_status;
 
-	if (request->Status != 0 || VStorPacket->VmSrb.SrbStatus != 1) {
+	if (request->Status != 0 || VStorPacket->vm_srb.srb_status != 1) {
 		DPRINT_WARN(STORVSC,
 			    "cmd 0x%x scsi status 0x%x srb status 0x%x\n",
-			    request->Cdb[0], VStorPacket->VmSrb.ScsiStatus,
-			    VStorPacket->VmSrb.SrbStatus);
+			    request->Cdb[0], VStorPacket->vm_srb.scsi_status,
+			    VStorPacket->vm_srb.srb_status);
 	}
 
 	if ((request->Status & 0xFF) == 0x02) {
 		/* CHECK_CONDITION */
-		if (VStorPacket->VmSrb.SrbStatus & 0x80) {
+		if (VStorPacket->vm_srb.srb_status & 0x80) {
 			/* autosense data available */
 			DPRINT_WARN(STORVSC, "storvsc pkt %p autosense data "
 				    "valid - len %d\n", RequestExt,
-				    VStorPacket->VmSrb.SenseInfoLength);
+				    VStorPacket->vm_srb.sense_info_length);
 
-			/* ASSERT(VStorPacket->VmSrb.SenseInfoLength <= */
+			/* ASSERT(VStorPacket->vm_srb.sense_info_length <= */
 			/* 	request->SenseBufferSize); */
 			memcpy(request->SenseBuffer,
-			       VStorPacket->VmSrb.SenseData,
-			       VStorPacket->VmSrb.SenseInfoLength);
+			       VStorPacket->vm_srb.sense_data,
+			       VStorPacket->vm_srb.sense_info_length);
 
 			request->SenseBufferSize =
-					VStorPacket->VmSrb.SenseInfoLength;
+					VStorPacket->vm_srb.sense_info_length;
 		}
 	}
 
 	/* TODO: */
-	request->BytesXfer = VStorPacket->VmSrb.DataTransferLength;
+	request->BytesXfer = VStorPacket->vm_srb.data_transfer_length;
 
 	request->OnIOCompletion(request);
 
@@ -411,19 +412,19 @@ static void StorVscOnReceive(struct hv_device *Device,
 			     struct vstor_packet *VStorPacket,
 			     struct storvsc_request_extension *RequestExt)
 {
-	switch (VStorPacket->Operation) {
-	case VStorOperationCompleteIo:
+	switch (VStorPacket->operation) {
+	case VSTOR_OPERATION_COMPLETE_IO:
 		DPRINT_DBG(STORVSC, "IO_COMPLETE_OPERATION");
 		StorVscOnIOCompletion(Device, VStorPacket, RequestExt);
 		break;
-	case VStorOperationRemoveDevice:
+	case VSTOR_OPERATION_REMOVE_DEVICE:
 		DPRINT_INFO(STORVSC, "REMOVE_DEVICE_OPERATION");
 		/* TODO: */
 		break;
 
 	default:
 		DPRINT_INFO(STORVSC, "Unknown operation received - %d",
-			    VStorPacket->Operation);
+			    VStorPacket->operation);
 		break;
 	}
 }
@@ -506,7 +507,7 @@ static int StorVscConnectToVsp(struct hv_device *Device)
 			 StorVscOnChannelCallback, Device);
 
 	DPRINT_DBG(STORVSC, "storage props: path id %d, tgt id %d, max xfer %d",
-		   props.PathId, props.TargetId, props.MaxTransferBytes);
+		   props.path_id, props.target_id, props.max_transfer_bytes);
 
 	if (ret != 0) {
 		DPRINT_ERR(STORVSC, "unable to open channel: %d", ret);
@@ -628,9 +629,9 @@ int StorVscOnHostReset(struct hv_device *Device)
 		goto Cleanup;
 	}
 
-	vstorPacket->Operation = VStorOperationResetBus;
-	vstorPacket->Flags = REQUEST_COMPLETION_FLAG;
-	vstorPacket->VmSrb.PathId = storDevice->PathId;
+	vstorPacket->operation = VSTOR_OPERATION_RESET_BUS;
+	vstorPacket->flags = REQUEST_COMPLETION_FLAG;
+	vstorPacket->vm_srb.path_id = storDevice->PathId;
 
 	ret = vmbus_sendpacket(Device->channel, vstorPacket,
 			       sizeof(struct vstor_packet),
@@ -697,35 +698,35 @@ static int StorVscOnIORequest(struct hv_device *Device,
 
 	memset(vstorPacket, 0 , sizeof(struct vstor_packet));
 
-	vstorPacket->Flags |= REQUEST_COMPLETION_FLAG;
+	vstorPacket->flags |= REQUEST_COMPLETION_FLAG;
 
-	vstorPacket->VmSrb.Length = sizeof(struct vmscsi_request);
+	vstorPacket->vm_srb.length = sizeof(struct vmscsi_request);
 
-	vstorPacket->VmSrb.PortNumber = Request->Host;
-	vstorPacket->VmSrb.PathId = Request->Bus;
-	vstorPacket->VmSrb.TargetId = Request->TargetId;
-	vstorPacket->VmSrb.Lun = Request->LunId;
+	vstorPacket->vm_srb.port_number = Request->Host;
+	vstorPacket->vm_srb.path_id = Request->Bus;
+	vstorPacket->vm_srb.target_id = Request->TargetId;
+	vstorPacket->vm_srb.lun = Request->LunId;
 
-	vstorPacket->VmSrb.SenseInfoLength = SENSE_BUFFER_SIZE;
+	vstorPacket->vm_srb.sense_info_length = SENSE_BUFFER_SIZE;
 
 	/* Copy over the scsi command descriptor block */
-	vstorPacket->VmSrb.CdbLength = Request->CdbLen;
-	memcpy(&vstorPacket->VmSrb.Cdb, Request->Cdb, Request->CdbLen);
+	vstorPacket->vm_srb.cdb_length = Request->CdbLen;
+	memcpy(&vstorPacket->vm_srb.cdb, Request->Cdb, Request->CdbLen);
 
-	vstorPacket->VmSrb.DataIn = Request->Type;
-	vstorPacket->VmSrb.DataTransferLength = Request->DataBuffer.Length;
+	vstorPacket->vm_srb.data_in = Request->Type;
+	vstorPacket->vm_srb.data_transfer_length = Request->DataBuffer.Length;
 
-	vstorPacket->Operation = VStorOperationExecuteSRB;
+	vstorPacket->operation = VSTOR_OPERATION_EXECUTE_SRB;
 
 	DPRINT_DBG(STORVSC, "srb - len %d port %d, path %d, target %d, "
 		   "lun %d senselen %d cdblen %d",
-		   vstorPacket->VmSrb.Length,
-		   vstorPacket->VmSrb.PortNumber,
-		   vstorPacket->VmSrb.PathId,
-		   vstorPacket->VmSrb.TargetId,
-		   vstorPacket->VmSrb.Lun,
-		   vstorPacket->VmSrb.SenseInfoLength,
-		   vstorPacket->VmSrb.CdbLength);
+		   vstorPacket->vm_srb.length,
+		   vstorPacket->vm_srb.port_number,
+		   vstorPacket->vm_srb.path_id,
+		   vstorPacket->vm_srb.target_id,
+		   vstorPacket->vm_srb.lun,
+		   vstorPacket->vm_srb.sense_info_length,
+		   vstorPacket->vm_srb.cdb_length);
 
 	if (requestExtension->Request->DataBuffer.Length) {
 		ret = vmbus_sendpacket_multipagebuffer(Device->channel,
diff --git a/drivers/staging/hv/vstorage.h b/drivers/staging/hv/vstorage.h
index 4ea597d..ae8be84 100644
--- a/drivers/staging/hv/vstorage.h
+++ b/drivers/staging/hv/vstorage.h
@@ -27,15 +27,17 @@
 
 #define REVISION_STRING(REVISION_) #REVISION_
 #define FILL_VMSTOR_REVISION(RESULT_LVALUE_)				\
-{									\
-	char *revisionString = REVISION_STRING($Revision : 6 $) + 11;	\
-	RESULT_LVALUE_ = 0;						\
-	while (*revisionString >= '0' && *revisionString <= '9') {	\
-		RESULT_LVALUE_ *= 10;					\
-		RESULT_LVALUE_ += *revisionString - '0';		\
-		revisionString++;					\
-	}								\
-}
+	do {								\
+		char *revision_string					\
+			= REVISION_STRING($Rev : 6 $) + 6;		\
+		RESULT_LVALUE_ = 0;					\
+		while (*revision_string >= '0'				\
+			&& *revision_string <= '9') {			\
+			RESULT_LVALUE_ *= 10;				\
+			RESULT_LVALUE_ += *revision_string - '0';	\
+			revision_string++;				\
+		}							\
+	} while (0)
 
 /* Major/minor macros.  Minor version is in LSB, meaning that earlier flat */
 /* version numbers will be interpreted as "0.x" (i.e., 1 becomes 0.1). */
@@ -65,17 +67,17 @@
 
 /*  Packet structure describing virtual storage requests. */
 enum vstor_packet_operation {
-	VStorOperationCompleteIo            = 1,
-	VStorOperationRemoveDevice          = 2,
-	VStorOperationExecuteSRB            = 3,
-	VStorOperationResetLun              = 4,
-	VStorOperationResetAdapter          = 5,
-	VStorOperationResetBus              = 6,
-	VStorOperationBeginInitialization   = 7,
-	VStorOperationEndInitialization     = 8,
-	VStorOperationQueryProtocolVersion  = 9,
-	VStorOperationQueryProperties       = 10,
-	VStorOperationMaximum               = 10
+	VSTOR_OPERATION_COMPLETE_IO		= 1,
+	VSTOR_OPERATION_REMOVE_DEVICE		= 2,
+	VSTOR_OPERATION_EXECUTE_SRB		= 3,
+	VSTOR_OPERATION_RESET_LUN		= 4,
+	VSTOR_OPERATION_RESET_ADAPTER		= 5,
+	VSTOR_OPERATION_RESET_BUS		= 6,
+	VSTOR_OPERATION_BEGIN_INITIALIZATION	= 7,
+	VSTOR_OPERATION_END_INITIALIZATION	= 8,
+	VSTOR_OPERATION_QUERY_PROTOCOL_VERSION	= 9,
+	VSTOR_OPERATION_QUERY_PROPERTIES	= 10,
+	VSTOR_OPERATION_MAXIMUM			= 10
 };
 
 /*
@@ -89,31 +91,29 @@ enum vstor_packet_operation {
 #define SENSE_BUFFER_SIZE			0x12
 #endif
 
-#define MAX_DATA_BUFFER_LENGTH_WITH_PADDING	0x14
+#define MAX_DATA_BUF_LEN_WITH_PADDING		0x14
 
 struct vmscsi_request {
-	unsigned short Length;
-	unsigned char SrbStatus;
-	unsigned char ScsiStatus;
+	unsigned short length;
+	unsigned char srb_status;
+	unsigned char scsi_status;
 
-	unsigned char PortNumber;
-	unsigned char PathId;
-	unsigned char TargetId;
-	unsigned char Lun;
+	unsigned char port_number;
+	unsigned char path_id;
+	unsigned char target_id;
+	unsigned char lun;
 
-	unsigned char CdbLength;
-	unsigned char SenseInfoLength;
-	unsigned char DataIn;
-	unsigned char Reserved;
+	unsigned char cdb_length;
+	unsigned char sense_info_length;
+	unsigned char data_in;
+	unsigned char reserved;
 
-	unsigned int DataTransferLength;
+	unsigned int data_transfer_length;
 
 	union {
-	unsigned char Cdb[CDB16GENERIC_LENGTH];
-
-	unsigned char SenseData[SENSE_BUFFER_SIZE];
-
-	unsigned char ReservedArray[MAX_DATA_BUFFER_LENGTH_WITH_PADDING];
+		unsigned char cdb[CDB16GENERIC_LENGTH];
+		unsigned char sense_data[SENSE_BUFFER_SIZE];
+		unsigned char reserved_array[MAX_DATA_BUF_LEN_WITH_PADDING];
 	};
 } __attribute((packed));
 
@@ -123,24 +123,24 @@ struct vmscsi_request {
  * properties of the channel.
  */
 struct vmstorage_channel_properties {
-	unsigned short ProtocolVersion;
-	unsigned char  PathId;
-	unsigned char  TargetId;
+	unsigned short protocol_version;
+	unsigned char path_id;
+	unsigned char target_id;
 
 	/* Note: port number is only really known on the client side */
-	unsigned int  PortNumber;
-	unsigned int  Flags;
-	unsigned int  MaxTransferBytes;
+	unsigned int port_number;
+	unsigned int flags;
+	unsigned int max_transfer_bytes;
 
 	/*  This id is unique for each channel and will correspond with */
 	/*  vendor specific data in the inquirydata */
-	unsigned long long UniqueId;
+	unsigned long long unique_id;
 } __attribute__((packed));
 
 /*  This structure is sent during the storage protocol negotiations. */
 struct vmstorage_protocol_version {
 	/* Major (MSW) and minor (LSW) version numbers. */
-	unsigned short MajorMinor;
+	unsigned short major_minor;
 
 	/*
 	 * Revision number is auto-incremented whenever this file is changed
@@ -148,7 +148,7 @@ struct vmstorage_protocol_version {
 	 * definitely indicate incompatibility--but it does indicate mismatched
 	 * builds.
 	 */
-	unsigned short Revision;
+	unsigned short revision;
 } __attribute__((packed));
 
 /* Channel Property Flags */
@@ -157,13 +157,13 @@ struct vmstorage_protocol_version {
 
 struct vstor_packet {
 	/* Requested operation type */
-	enum vstor_packet_operation Operation;
+	enum vstor_packet_operation operation;
 
 	/*  Flags - see below for values */
-	unsigned int     Flags;
+	unsigned int flags;
 
 	/* Status of the request returned from the server side. */
-	unsigned int     Status;
+	unsigned int status;
 
 	/* Data payload area */
 	union {
@@ -171,13 +171,13 @@ struct vstor_packet {
 		 * Structure used to forward SCSI commands from the
 		 * client to the server.
 		 */
-		struct vmscsi_request VmSrb;
+		struct vmscsi_request vm_srb;
 
 		/* Structure used to query channel properties. */
-		struct vmstorage_channel_properties StorageChannelProperties;
+		struct vmstorage_channel_properties storage_channel_properties;
 
 		/* Used during version negotiations. */
-		struct vmstorage_protocol_version Version;
+		struct vmstorage_protocol_version version;
 	};
 } __attribute__((packed));
 
-- 
1.6.0.2

