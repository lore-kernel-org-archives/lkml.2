Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab1KSCUR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 21:20:17 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:49248 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab1KSCUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 21:20:15 -0500
From: "Ken O'Brien" <kernel@kenobrien.org>
To: gregkh@suse.de, lucas.demarchi@profusion.mobi
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Ken O'Brien" <kernel@kenobrien.org>
Subject: [PATCH 2/2] Staging: bcm: Adapter.h Checkpatch cleaning.
Date: Sat, 19 Nov 2011 02:19:54 +0000
Message-Id: <1321669194-4365-1-git-send-email-kernel@kenobrien.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed all checkpatch errors.

Checkpatch status before: total: 131 errors, 200 warnings, 648 lines checked
Checkpatch status after:  total: 0 errors, 194 warnings, 620 lines checked

Signed-off-by: Ken O'Brien <kernel@kenobrien.org>
---
 drivers/staging/bcm/Adapter.h |  294 +++++++++++++++++++----------------------
 1 files changed, 133 insertions(+), 161 deletions(-)

diff --git a/drivers/staging/bcm/Adapter.h b/drivers/staging/bcm/Adapter.h
index 20cca24..e405453 100644
--- a/drivers/staging/bcm/Adapter.h
+++ b/drivers/staging/bcm/Adapter.h
@@ -7,43 +7,38 @@
 #define MAX_FRAGMENTEDIP_CLASSIFICATION_ENTRIES 256
 #include "Debug.h"
 
-struct _LEADER
-{
+struct _LEADER {
 	USHORT 	Vcid;
 	USHORT 	PLength;
 	UCHAR  	Status;
 	UCHAR	Unused[3];
-}__attribute__((packed));
-typedef struct _LEADER LEADER,*PLEADER;
+} __attribute__((packed));
+typedef struct _LEADER LEADER, *PLEADER;
 
-struct _PACKETTOSEND
-{
+struct _PACKETTOSEND {
 	LEADER	Leader;
 	UCHAR	ucPayload;
-}__attribute__((packed));
+} __attribute__((packed));
 typedef struct _PACKETTOSEND PACKETTOSEND, *PPACKETTOSEND;
 
 
-struct _CONTROL_PACKET
-{
+struct _CONTROL_PACKET {
 	PVOID	ControlBuff;
 	UINT	ControlBuffLen;
-	struct _CONTROL_PACKET* next;
-}__attribute__((packed));
-typedef struct _CONTROL_PACKET CONTROL_PACKET,*PCONTROL_PACKET;
+	struct _CONTROL_PACKET *next;
+} __attribute__((packed));
+typedef struct _CONTROL_PACKET CONTROL_PACKET, *PCONTROL_PACKET;
 
 
-struct link_request
-{
+struct link_request {
 	LEADER	Leader;
 	UCHAR	szData[4];
-}__attribute__((packed));
+} __attribute__((packed));
 typedef struct link_request LINK_REQUEST, *PLINK_REQUEST;
 
 
-//classification extension is added
-typedef struct _ADD_CONNECTION
-{
+/* classification extension is added */
+typedef struct _ADD_CONNECTION {
     ULONG 		SrcIpAddressCount;
     ULONG 		SrcIpAddress[MAX_CONNECTIONS];
     ULONG 		SrcIpMask[MAX_CONNECTIONS];
@@ -60,11 +55,10 @@ typedef struct _ADD_CONNECTION
 
     UCHAR 		SrcTOS;
     UCHAR 		SrcProtocol;
-} ADD_CONNECTION,*PADD_CONNECTION;
+} ADD_CONNECTION, *PADD_CONNECTION;
 
 
-typedef struct _CLASSIFICATION_RULE
-{
+typedef struct _CLASSIFICATION_RULE {
 	UCHAR		ucIPSrcAddrLen;
 	UCHAR       ucIPSrcAddr[32];
 	UCHAR		ucIPDestAddrLen;
@@ -74,10 +68,9 @@ typedef struct _CLASSIFICATION_RULE
 	UCHAR		ucDestPortRangeLen;
 	UCHAR		ucDestPortRange[4];
 	USHORT		usVcid;
-} CLASSIFICATION_RULE,*PCLASSIFICATION_RULE;
+} CLASSIFICATION_RULE, *PCLASSIFICATION_RULE;
 
-typedef struct _CLASSIFICATION_ONLY
-{
+typedef struct _CLASSIFICATION_ONLY {
     USHORT 		usVcid;
     ULONG  		DestIpAddress;
     ULONG  		DestIpMask;
@@ -93,61 +86,53 @@ typedef struct _CLASSIFICATION_ONLY
 #define MAX_PROTOCOL_LENGTH   32
 #define IPV6_ADDRESS_SIZEINBYTES 0x10
 
-typedef union _U_IP_ADDRESS
-{
-    struct
-	{
-		ULONG				ulIpv4Addr[MAX_IP_RANGE_LENGTH];//Source Ip Address Range
-		ULONG               ulIpv4Mask[MAX_IP_RANGE_LENGTH];//Source Ip Mask Address Range
+typedef union _U_IP_ADDRESS {
+  struct {
+		ULONG				ulIpv4Addr[MAX_IP_RANGE_LENGTH];/*Source Ip Address Range */
+		ULONG               ulIpv4Mask[MAX_IP_RANGE_LENGTH];/*Source Ip Mask Address Range */
 	};
-	struct
-	{
-		ULONG				ulIpv6Addr[MAX_IP_RANGE_LENGTH * 4];//Source Ip Address Range
-		ULONG               ulIpv6Mask[MAX_IP_RANGE_LENGTH * 4];//Source Ip Mask Address Range
-
+	struct {
+		ULONG				ulIpv6Addr[MAX_IP_RANGE_LENGTH * 4];/*Source Ip Address Range */
+		ULONG               ulIpv6Mask[MAX_IP_RANGE_LENGTH * 4];/*Source Ip Mask Address Range */
 	};
-	struct
-	{
+	struct {
 		UCHAR				ucIpv4Address[MAX_IP_RANGE_LENGTH * IP_LENGTH_OF_ADDRESS];
 		UCHAR				ucIpv4Mask[MAX_IP_RANGE_LENGTH * IP_LENGTH_OF_ADDRESS];
 	};
-	struct
-	{
+	struct {
 		UCHAR				ucIpv6Address[MAX_IP_RANGE_LENGTH * IPV6_ADDRESS_SIZEINBYTES];
 		UCHAR				ucIpv6Mask[MAX_IP_RANGE_LENGTH * IPV6_ADDRESS_SIZEINBYTES];
 	};
-}U_IP_ADDRESS;
+} U_IP_ADDRESS;
 struct _packet_info;
 
-typedef struct _S_HDR_SUPRESSION_CONTEXTINFO
-{
+typedef struct _S_HDR_SUPRESSION_CONTEXTINFO {
 
-	UCHAR      ucaHdrSupressionInBuf[MAX_PHS_LENGTHS]; //Intermediate buffer to accumulate pkt Header for PHS
-	UCHAR      ucaHdrSupressionOutBuf[MAX_PHS_LENGTHS + PHSI_LEN]; //Intermediate buffer containing pkt Header after PHS
+	UCHAR      ucaHdrSupressionInBuf[MAX_PHS_LENGTHS]; /* Intermediate buffer to accumulate pkt Header for PHS */
+	UCHAR      ucaHdrSupressionOutBuf[MAX_PHS_LENGTHS + PHSI_LEN]; /* Intermediate buffer containing pkt Header after PHS */
 
-}S_HDR_SUPRESSION_CONTEXTINFO;
+} S_HDR_SUPRESSION_CONTEXTINFO;
 
 
-typedef struct _S_CLASSIFIER_RULE
-{
+typedef struct _S_CLASSIFIER_RULE {
 	ULONG			ulSFID;
 	UCHAR           ucReserved[2];
 	B_UINT16        uiClassifierRuleIndex;
 	BOOLEAN			bUsed;
 	USHORT			usVCID_Value;
-	B_UINT8         u8ClassifierRulePriority; //This field detemines the Classifier Priority
+	B_UINT8         u8ClassifierRulePriority; /*This field detemines the Classifier Priority */
 	U_IP_ADDRESS	stSrcIpAddress;
-	UCHAR           ucIPSourceAddressLength;//Ip Source Address Length
+	UCHAR           ucIPSourceAddressLength; /*Ip Source Address Length */
 
 	U_IP_ADDRESS    stDestIpAddress;
-    UCHAR           ucIPDestinationAddressLength;//Ip Destination Address Length
-    UCHAR           ucIPTypeOfServiceLength;//Type of service Length
-    UCHAR           ucTosLow;//Tos Low
-    UCHAR           ucTosHigh;//Tos High
-	UCHAR           ucTosMask;//Tos Mask
-
-    UCHAR           ucProtocolLength;//protocol Length
-    UCHAR           ucProtocol[MAX_PROTOCOL_LENGTH];//protocol Length
+    UCHAR           ucIPDestinationAddressLength; /* Ip Destination Address Length */
+    UCHAR           ucIPTypeOfServiceLength; /* Type of service Length */
+    UCHAR           ucTosLow; /* Tos Low */
+    UCHAR           ucTosHigh; /*Tos High */
+	UCHAR           ucTosMask; /* Tos Mask */
+
+    UCHAR           ucProtocolLength; /* protocol Length */
+    UCHAR           ucProtocol[MAX_PROTOCOL_LENGTH]; /* protocol Length */
     USHORT			usSrcPortRangeLo[MAX_PORT_RANGE];
 	USHORT			usSrcPortRangeHi[MAX_PORT_RANGE];
     UCHAR           ucSrcPortRangeLength;
@@ -161,14 +146,14 @@ typedef struct _S_CLASSIFIER_RULE
 	BOOLEAN			bDestIpValid;
 	BOOLEAN			bSrcIpValid;
 
-	//For IPv6 Addressing
+	/* For IPv6 Addressing */
 	UCHAR			ucDirection;
 	BOOLEAN         bIpv6Protocol;
 	UINT32          u32PHSRuleID;
 	S_PHS_RULE 	    sPhsRule;
 	UCHAR			u8AssociatedPHSI;
 
-	//Classification fields for ETH CS
+	/* Classification fields for ETH CS */
 	UCHAR		ucEthCSSrcMACLen;
 	UCHAR		au8EThCSSrcMAC[MAC_ADDRESS_SIZE];
 	UCHAR		au8EThCSSrcMACMask[MAC_ADDRESS_SIZE];
@@ -180,34 +165,32 @@ typedef struct _S_CLASSIFIER_RULE
 	UCHAR		usUserPriority[2];
 	USHORT		usVLANID;
 	USHORT		usValidityBitMap;
-}S_CLASSIFIER_RULE;
-//typedef struct _S_CLASSIFIER_RULE S_CLASSIFIER_RULE;
+} S_CLASSIFIER_RULE;
+/* typedef struct _S_CLASSIFIER_RULE S_CLASSIFIER_RULE; */
 
-typedef struct _S_FRAGMENTED_PACKET_INFO
-{
+typedef struct _S_FRAGMENTED_PACKET_INFO {
 	BOOLEAN				bUsed;
 	ULONG		        ulSrcIpAddress;
 	USHORT 				usIpIdentification;
 	S_CLASSIFIER_RULE 	*pstMatchedClassifierEntry;
 	BOOLEAN				bOutOfOrderFragment;
-}S_FRAGMENTED_PACKET_INFO,*PS_FRAGMENTED_PACKET_INFO;
-
-struct _packet_info
-{
-	//classification extension Rule
-   	ULONG			ulSFID;
-   	USHORT			usVCID_Value;
-	UINT			uiThreshold;
-	// This field determines the priority of the SF Queues
+} S_FRAGMENTED_PACKET_INFO, *PS_FRAGMENTED_PACKET_INFO;
+
+struct _packet_info {
+	/* classification extension Rule */
+  ULONG			ulSFID;
+  USHORT			usVCID_Value;
+  UINT			uiThreshold;
+	/* This field determines the priority of the SF Queues */
 	B_UINT8     	u8TrafficPriority;
 
 	BOOLEAN			bValid;
-   	BOOLEAN     	bActive;
+  BOOLEAN     	bActive;
 	BOOLEAN			bActivateRequestSent;
 
-	B_UINT8			u8QueueType;//BE or rtPS
+	B_UINT8			u8QueueType;/* BE or rtPS */
 
-	UINT			uiMaxBucketSize;//maximum size of the bucket for the queue
+	UINT			uiMaxBucketSize; /*maximum size of the bucket for the queue */
 	UINT			uiCurrentQueueDepthOnTarget;
 	UINT			uiCurrentBytesOnHost;
 	UINT			uiCurrentPacketsOnHost;
@@ -232,17 +215,14 @@ struct _packet_info
 	UINT			uiPendedLast;
 	UCHAR			ucIpVersion;
 
-	union
-	{
-		struct
-		{
-			struct sk_buff*	   FirstTxQueue;
-			struct sk_buff*	   LastTxQueue;
+	union {
+		struct {
+			struct sk_buff *FirstTxQueue;
+			struct sk_buff *LastTxQueue;
 		};
-		struct
-		{
-			struct sk_buff*	   ControlHead;
-			struct sk_buff*	   ControlTail;
+		struct {
+			struct sk_buff *ControlHead;
+			struct sk_buff *ControlTail;
 		};
 	};
 	BOOLEAN		bProtocolValid;
@@ -267,12 +247,11 @@ struct _packet_info
 typedef struct _packet_info PacketInfo;
 
 
-typedef struct _PER_TARANG_DATA
-{
-    struct _PER_TARANG_DATA * next;
-    struct _MINI_ADAPTER * Adapter;
-    struct sk_buff*     RxAppControlHead;
-    struct sk_buff*     RxAppControlTail;
+typedef struct _PER_TARANG_DATA {
+    struct _PER_TARANG_DATA *next;
+    struct _MINI_ADAPTER *Adapter;
+    struct sk_buff *RxAppControlHead;
+    struct sk_buff *RxAppControlTail;
     volatile INT        AppCtrlQueueLen;
     BOOLEAN             MacTracingEnabled;
 	BOOLEAN				bApplicationToExit;
@@ -282,50 +261,48 @@ typedef struct _PER_TARANG_DATA
 
 
 #ifdef REL_4_1
-typedef struct _TARGET_PARAMS
-{
+typedef struct _TARGET_PARAMS {
       B_UINT32 m_u32CfgVersion;
 
-      // Scanning Related Params
+      /* Scanning Related Params */
       B_UINT32 m_u32CenterFrequency;
       B_UINT32 m_u32BandAScan;
       B_UINT32 m_u32BandBScan;
       B_UINT32 m_u32BandCScan;
 
-      // QoS Params
-      B_UINT32 m_u32minGrantsize;	// size of minimum grant is 0 or 6
+      /* QoS Params */
+      B_UINT32 m_u32minGrantsize;	/* size of minimum grant is 0 or 6 */
       B_UINT32 m_u32PHSEnable;
 
-      // HO Params
+      /* HO Params */
       B_UINT32 m_u32HoEnable;
       B_UINT32 m_u32HoReserved1;
       B_UINT32 m_u32HoReserved2;
 
-	// Power Control Params
+	    /* Power Control Params */
       B_UINT32 m_u32MimoEnable;
       B_UINT32 m_u32SecurityEnable;
-	/*
-     * bit 1: 1 Idlemode enable;
-     * bit 2: 1 Sleepmode Enable
-     */
+      /*
+      * bit 1: 1 Idlemode enable;
+      * bit 2: 1 Sleepmode Enable
+      */
       B_UINT32 m_u32PowerSavingModesEnable;
 	  /* PowerSaving Mode Options:
 	     bit 0 = 1: CPE mode - to keep pcmcia if alive;
 	     bit 1 = 1: CINR reporing in Idlemode Msg
 	     bit 2 = 1: Default PSC Enable in sleepmode*/
       B_UINT32 m_u32PowerSavingModeOptions;
-
       B_UINT32 m_u32ArqEnable;
 
-      // From Version #3, the HARQ section renamed as general
+      /* From Version #3, the HARQ section renamed as general */
       B_UINT32 m_u32HarqEnable;
-       // EEPROM Param Location
-       B_UINT32  m_u32EEPROMFlag;
-       /* BINARY TYPE - 4th MSByte:
-        * Interface Type -  3rd MSByte:
-        * Vendor Type - 2nd MSByte
-        */
-       // Unused - LSByte
+      /* EEPROM Param Location */
+      B_UINT32  m_u32EEPROMFlag;
+      /* BINARY TYPE - 4th MSByte:
+      * Interface Type -  3rd MSByte:
+      * Vendor Type - 2nd MSByte
+      */
+      /* Unused - LSByte */
       B_UINT32   m_u32Customize;
       B_UINT32   m_u32ConfigBW;  /* In Hz */
       B_UINT32   m_u32ShutDownTimer;
@@ -350,7 +327,7 @@ typedef struct _TARGET_PARAMS
 
 	B_UINT32 m_u32Corr2MacFlags;
 
-    //adding driver params.
+    /* adding driver params. */
     B_UINT32 HostDrvrConfig1;
     B_UINT32 HostDrvrConfig2;
     B_UINT32 HostDrvrConfig3;
@@ -359,28 +336,26 @@ typedef struct _TARGET_PARAMS
     B_UINT32 HostDrvrConfig6;
     B_UINT32 m_u32SegmentedPUSCenable;
 
-	//	BAMC enable - but 4.x does not support this feature
-	//	This is added just to sync 4.x and 5.x CFGs
+	/*	BAMC enable - but 4.x does not support this feature */
+	/*	This is added just to sync 4.x and 5.x CFGs */
 	B_UINT32 m_u32BandAMCEnable;
 } STARGETPARAMS, *PSTARGETPARAMS;
 #endif
 
-typedef struct _STTARGETDSXBUFFER
-{
+typedef struct _STTARGETDSXBUFFER {
     ULONG ulTargetDsxBuffer;
     B_UINT16 tid;
     BOOLEAN valid;
-}STTARGETDSXBUFFER, *PSTTARGETDSXBUFFER;
+} STTARGETDSXBUFFER, *PSTTARGETDSXBUFFER;
 
-typedef INT (*FP_FLASH_WRITE)(struct _MINI_ADAPTER*,UINT,PVOID);
+typedef INT (*FP_FLASH_WRITE)(struct _MINI_ADAPTER*, UINT, PVOID);
 
-typedef INT (*FP_FLASH_WRITE_STATUS)(struct _MINI_ADAPTER*,UINT,PVOID);
+typedef INT (*FP_FLASH_WRITE_STATUS)(struct _MINI_ADAPTER *, UINT, PVOID);
 
-/**
+/*
 Driver adapter data structure
 */
-struct _MINI_ADAPTER
-{
+struct _MINI_ADAPTER {
 	struct _MINI_ADAPTER *next;
 	struct net_device	*dev;
 	u32			msg_enable;
@@ -405,14 +380,14 @@ struct _MINI_ADAPTER
 	spinlock_t			control_queue_lock;
 	wait_queue_head_t	process_read_wait_queue;
 
-	// the pointer to the first packet we have queued in send
-	// deserialized miniport support variables
+	/* the pointer to the first packet we have queued in send */
+	/* deserialized miniport support variables */
 	atomic_t		    TotalPacketCount;
 	atomic_t		    TxPktAvail;
 
-	// this to keep track of the Tx and Rx MailBox Registers.
+	/* this to keep track of the Tx and Rx MailBox Registers. */
 	atomic_t		    CurrNumFreeTxDesc;
-	// to keep track the no of byte received
+	/* to keep track the no of byte received */
 	USHORT				PrevNumRecvDescs;
 	USHORT				CurrNumRecvDescs;
 	UINT				u32TotalDSD;
@@ -483,12 +458,12 @@ struct _MINI_ADAPTER
 	LedEventInfo_t		DriverState;
 	/* Interface Specific */
 	PVOID				pvInterfaceAdapter;
-	int (*bcm_file_download)( PVOID,
-                        struct file *,
-                        unsigned int);
-	int (*bcm_file_readback_from_chip)( PVOID,
-                        struct file *,
-                        unsigned int);
+	int (*bcm_file_download)(PVOID,
+      struct file *,
+      unsigned int);
+	int (*bcm_file_readback_from_chip)(PVOID,
+      struct file *,
+      unsigned int);
 	INT (*interface_rdm)(PVOID,
 			UINT ,
 			PVOID ,
@@ -504,7 +479,7 @@ struct _MINI_ADAPTER
 	BOOLEAN			bShutStatus;
 	BOOLEAN			bWakeUpDevice;
 	unsigned int	usIdleModePattern;
-	//BOOLEAN			bTriedToWakeUpFromShutdown;
+	/*BOOLEAN			bTriedToWakeUpFromShutdown; */
 	BOOLEAN			bLinkDownRequested;
 
 	int 			downloadDDR;
@@ -527,8 +502,8 @@ struct _MINI_ADAPTER
 	BOOLEAN			bStatusWrite;
 	UINT			uiNVMDSDSize;
 	UINT			uiVendorExtnFlag;
-	 //it will always represent chosen DSD at any point of time.
-	 // Generally it is Active DSD but in case of NVM RD/WR it might be different.
+	/* it will always represent chosen DSD at any point of time. */
+	/* Generally it is Active DSD but in case of NVM RD/WR it might be different.*/
 	UINT			ulFlashCalStart;
 	ULONG                   ulFlashControlSectionStart;
 	ULONG                   ulFlashWriteSize;
@@ -541,30 +516,30 @@ struct _MINI_ADAPTER
 
 	struct device *pstCreatedClassDevice;
 
-//	BOOLEAN				InterfaceUpStatus;
+  /*	BOOLEAN				InterfaceUpStatus; */
 	PFLASH2X_CS_INFO psFlash2xCSInfo;
 	PFLASH_CS_INFO psFlashCSInfo ;
 	PFLASH2X_VENDORSPECIFIC_INFO psFlash2xVendorInfo;
-	UINT uiFlashBaseAdd; //Flash start address
-	UINT uiActiveISOOffset; //Active ISO offset chosen before f/w download
-	FLASH2X_SECTION_VAL eActiveISO; //Active ISO section val
-	FLASH2X_SECTION_VAL eActiveDSD;	//Active DSD val chosen before f/w download
-	UINT uiActiveDSDOffsetAtFwDld;  //For accessing Active DSD chosen before f/w download
+	UINT uiFlashBaseAdd; /* Flash start address */
+	UINT uiActiveISOOffset; /* Active ISO offset chosen before f/w download */
+	FLASH2X_SECTION_VAL eActiveISO; /* Active ISO section val */
+	FLASH2X_SECTION_VAL eActiveDSD;	/* Active DSD val chosen before f/w download */
+	UINT uiActiveDSDOffsetAtFwDld;  /* For accessing Active DSD chosen before f/w download */
 	UINT uiFlashLayoutMajorVersion ;
 	UINT uiFlashLayoutMinorVersion;
 	BOOLEAN bAllDSDWriteAllow ;
 	BOOLEAN bSigCorrupted ;
-	//this should be set who so ever want to change the Headers. after Wrtie it should be reset immediately.
+	/* this should be set who so ever want to change the Headers. after Wrtie it should be reset immediately. */
 	BOOLEAN bHeaderChangeAllowed ;
 	INT SelectedChip ;
 	BOOLEAN bEndPointHalted;
-	//while bFlashRawRead will be true, Driver  ignore map lay out and consider flash as of without any map.
+	/* while bFlashRawRead will be true, Driver  ignore map lay out and consider flash as of without any map. */
 	BOOLEAN bFlashRawRead;
 	BOOLEAN			bPreparingForLowPowerMode ;
 	BOOLEAN bDoSuspend ;
 	UINT syscfgBefFwDld ;
 	BOOLEAN StopAllXaction ;
-	UINT32	liTimeSinceLastNetEntry; //Used to Support extended CAPI requirements from
+	UINT32	liTimeSinceLastNetEntry; /* Used to Support extended CAPI requirements from */
 	struct semaphore	LowPowerModeSync;
 	ULONG	liDrainCalculated;
 	UINT gpioBitMap;
@@ -580,37 +555,35 @@ struct _ETH_HEADER_STRUC {
     UCHAR       au8DestinationAddress[6];
     UCHAR       au8SourceAddress[6];
     USHORT      u16Etype;
-}__attribute__((packed));
+} __attribute__((packed));
 typedef struct _ETH_HEADER_STRUC ETH_HEADER_STRUC, *PETH_HEADER_STRUC;
 
 
-typedef struct FirmwareInfo
-{
-	void __user *	pvMappedFirmwareAddress;
+typedef struct FirmwareInfo {
+	void __user *pvMappedFirmwareAddress;
 	ULONG		u32FirmwareLength;
 	ULONG		u32StartingAddress;
-}__attribute__((packed)) FIRMWARE_INFO, *PFIRMWARE_INFO;
+} __attribute__((packed)) FIRMWARE_INFO, *PFIRMWARE_INFO;
 
-// holds the value of net_device structure..
+/* holds the value of net_device structure.. */
 extern struct net_device *gblpnetdev;
 typedef struct _cntl_pkt{
 	PMINI_ADAPTER 	Adapter;
 	PLEADER 		PLeader;
-}cntl_pkt;
+} cntl_pkt;
 typedef LINK_REQUEST CONTROL_MESSAGE;
 
-typedef struct _DDR_SETTING
-{
+typedef struct _DDR_SETTING {
 	UINT ulRegAddress;
 	UINT ulRegValue;
-}DDR_SETTING, *PDDR_SETTING;
+} DDR_SETTING, *PDDR_SETTING;
 typedef DDR_SETTING DDR_SET_NODE, *PDDR_SET_NODE;
 INT
 InitAdapter(PMINI_ADAPTER psAdapter);
 
-// =====================================================================
-// Beceem vendor request codes for EP0
-// =====================================================================
+/* =====================================================================
+ Beceem vendor request codes for EP0
+ =======================================================================*/
 
 #define BCM_REQUEST_READ  0x2
 #define BCM_REQUEST_WRITE 0x1
@@ -638,11 +611,10 @@ InitAdapter(PMINI_ADAPTER psAdapter);
 #define EP6 5
 
 
-typedef enum eInterface_setting
-{
+typedef enum eInterface_setting {
 	DEFAULT_SETTING_0  = 0,
 	ALTERNATE_SETTING_1 = 1,
-}INTERFACE_SETTING;
+} INTERFACE_SETTING;
 
-#endif	//__ADAPTER_H__
+#endif	/* __ADAPTER_H__ */
 
-- 
1.7.5.4

