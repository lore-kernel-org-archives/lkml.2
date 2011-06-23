Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933Ab1FWSk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:40:26 -0400
Received: from mail.perches.com ([173.55.12.10]:3176 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759825Ab1FWSkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:40:24 -0400
From: Joe Perches <joe@perches.com>
To: devel@driverdev.osuosl.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] staging: Fix recieve/receive typos
Date: Thu, 23 Jun 2011 11:40:18 -0700
Message-Id: <3449aeaeff79540bbe60c1323a28c528e3083507.1308854062.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just spelling fixes.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/bcm/Debug.h                        |    2 +-
 drivers/staging/bcm/InterfaceRx.c                  |    4 +-
 drivers/staging/bcm/Macros.h                       |    4 +-
 drivers/staging/bcm/PHSModule.c                    |   24 ++++++++++----------
 drivers/staging/bcm/PHSModule.h                    |    2 +-
 drivers/staging/iio/gyro/adxrs450.h                |    2 +-
 drivers/staging/usbip/userspace/src/usbip_attach.c |    2 +-
 drivers/staging/usbip/userspace/src/usbipd.c       |    2 +-
 8 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/bcm/Debug.h b/drivers/staging/bcm/Debug.h
index 3138729..420382d 100644
--- a/drivers/staging/bcm/Debug.h
+++ b/drivers/staging/bcm/Debug.h
@@ -131,7 +131,7 @@ DriverEntry.c, bcmfwup.c, ChipDetectTask.c, HaltnReset.c, InterfaceDDR.c */
 
 // TODO - put PHS_SEND in Tx PHS_RECEIVE in Rx path ?
 #define PHS_SEND    	(OTHERS<<16)
-#define PHS_RECIEVE 	(OTHERS<<17)
+#define PHS_RECEIVE 	(OTHERS<<17)
 #define PHS_MODULE 	    (OTHERS<<18)
 
 #define INTF_INIT    	(OTHERS<<19)
diff --git a/drivers/staging/bcm/InterfaceRx.c b/drivers/staging/bcm/InterfaceRx.c
index 806ef5d..d495828 100644
--- a/drivers/staging/bcm/InterfaceRx.c
+++ b/drivers/staging/bcm/InterfaceRx.c
@@ -157,7 +157,7 @@ static void read_bulk_callback(struct urb *urb)
 		{
 			/* Moving ahead by ETH_HLEN to the data ptr as received from FW */
 			skb_pull(skb, ETH_HLEN);
-			PHSRecieve(Adapter, pLeader->Vcid, skb, &skb->len,
+			PHSReceive(Adapter, pLeader->Vcid, skb, &skb->len,
 					NULL,bHeaderSupressionEnabled);
 
 			if(!Adapter->PackInfo[QueueIndex].bEthCSSupport)
@@ -229,7 +229,7 @@ static int ReceiveRcb(PS_INTERFACE_ADAPTER psIntfAdapter, PUSB_RCB pRcb)
 /*
 Function:				InterfaceRx
 
-Description:			This is the hardware specific Function for Recieveing
+Description:			This is the hardware specific Function for Receiving
 						data packet/control packets from the device.
 
 Input parameters:		IN PMINI_ADAPTER Adapter   - Miniport Adapter Context
diff --git a/drivers/staging/bcm/Macros.h b/drivers/staging/bcm/Macros.h
index feb3515..916bebb 100644
--- a/drivers/staging/bcm/Macros.h
+++ b/drivers/staging/bcm/Macros.h
@@ -176,8 +176,8 @@ enum enLinkStatus {
     PHY_SYNC_ACHIVED = 	2,
     LINKUP_IN_PROGRESS = 3,
     LINKUP_DONE     = 	4,
-    DREG_RECIEVED =		5,
-    LINK_STATUS_RESET_RECIEVED = 6,
+    DREG_RECEIVED =		5,
+    LINK_STATUS_RESET_RECEIVED = 6,
     PERIODIC_WAKE_UP_NOTIFICATION_FRM_FW  = 7,
     LINK_SHUTDOWN_REQ_FROM_FIRMWARE = 8,
     COMPLETE_WAKE_UP_NOTIFICATION_FRM_FW =9
diff --git a/drivers/staging/bcm/PHSModule.c b/drivers/staging/bcm/PHSModule.c
index d1ca191..4aa2b71 100644
--- a/drivers/staging/bcm/PHSModule.c
+++ b/drivers/staging/bcm/PHSModule.c
@@ -209,7 +209,7 @@ int PHSTransmit(PMINI_ADAPTER Adapter,
 	return STATUS_SUCCESS;
 }
 
-int PHSRecieve(PMINI_ADAPTER Adapter,
+int PHSReceive(PMINI_ADAPTER Adapter,
 					USHORT usVcid,
 					struct sk_buff *packet,
 					UINT *punPacketLen,
@@ -223,7 +223,7 @@ int PHSRecieve(PMINI_ADAPTER Adapter,
 	UINT TotalBytesAdded = 0;
 	if(!bHeaderSuppressionEnabled)
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECIEVE,DBG_LVL_ALL,"\nPhs Disabled for incoming packet");
+		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECEIVE,DBG_LVL_ALL,"\nPhs Disabled for incoming packet");
 		return ulPhsStatus;
 	}
 
@@ -238,7 +238,7 @@ int PHSRecieve(PMINI_ADAPTER Adapter,
 		&nTotalsupressedPktHdrBytes,
 		&nStandardPktHdrLen);
 
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECIEVE,DBG_LVL_ALL,"\nSupressed PktHdrLen : 0x%x Restored PktHdrLen : 0x%x",
+	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECEIVE,DBG_LVL_ALL,"\nSupressed PktHdrLen : 0x%x Restored PktHdrLen : 0x%x",
 					nTotalsupressedPktHdrBytes,nStandardPktHdrLen);
 
 	if(ulPhsStatus != STATUS_PHS_COMPRESSED)
@@ -786,14 +786,14 @@ ULONG PhsDeCompress(IN void* pvContext,
 
 	if(pDeviceExtension == NULL)
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECIEVE,DBG_LVL_ALL,"Invalid Device Extension\n");
+		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECEIVE,DBG_LVL_ALL,"Invalid Device Extension\n");
 		return ERR_PHS_INVALID_DEVICE_EXETENSION;
 	}
 
-	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECIEVE,DBG_LVL_ALL,"Restoring header \n");
+	BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECEIVE,DBG_LVL_ALL,"Restoring header\n");
 
 	phsi = *((unsigned char *)(pvInputBuffer));
-    BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECIEVE,DBG_LVL_ALL,"PHSI To Be Used For restore : %x \n",phsi);
+    BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECEIVE,DBG_LVL_ALL,"PHSI To Be Used For restore : %x\n",phsi);
     if(phsi == UNCOMPRESSED_PACKET )
 	{
 		return STATUS_PHS_NOCOMPRESSION;
@@ -804,7 +804,7 @@ ULONG PhsDeCompress(IN void* pvContext,
 	      uiVcid,&pstServiceFlowEntry);
 	if(nSFIndex == PHS_INVALID_TABLE_INDEX)
 	{
-		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECIEVE,DBG_LVL_ALL,"SFID Match Failed During Lookup\n");
+		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECEIVE,DBG_LVL_ALL,"SFID Match Failed During Lookup\n");
 		return ERR_SF_MATCH_FAIL;
 	}
 
@@ -1417,7 +1417,7 @@ int phs_decompress(unsigned char *in_buf,unsigned char *out_buf,
 	int in_buf_len = *header_size-1;
     PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(gblpnetdev);
 	in_buf++;
-    BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECIEVE,DBG_LVL_ALL,"====>\n");
+    BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECEIVE,DBG_LVL_ALL,"====>\n");
 	*header_size = 0;
 
 	if((decomp_phs_rules == NULL ))
@@ -1425,7 +1425,7 @@ int phs_decompress(unsigned char *in_buf,unsigned char *out_buf,
 
 
 	tmp_memb = decomp_phs_rules;
-	//BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECIEVE,DBG_LVL_ALL,"\nDECOMP:In phs_decompress PHSI 1  %d",phsi));
+	//BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECEIVE,DBG_LVL_ALL,"\nDECOMP:In phs_decompress PHSI 1  %d",phsi));
 	//*header_size = tmp_memb->u8PHSFLength;
 	phss         = tmp_memb->u8PHSS;
 	phsf         = tmp_memb->u8PHSF;
@@ -1433,7 +1433,7 @@ int phs_decompress(unsigned char *in_buf,unsigned char *out_buf,
 
 	if(phss > MAX_PHS_LENGTHS)
 		phss = MAX_PHS_LENGTHS;
-	//BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECIEVE,DBG_LVL_ALL,"\nDECOMP:In phs_decompress PHSI  %d phss %d index %d",phsi,phss,index));
+	//BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECEIVE,DBG_LVL_ALL,"\nDECOMP:In phs_decompress PHSI  %d phss %d index %d",phsi,phss,index));
 	while((phss > 0) && (size < in_buf_len))
 	{
 		bit =  ((*phsm << i)& SUPPRESS);
@@ -1441,13 +1441,13 @@ int phs_decompress(unsigned char *in_buf,unsigned char *out_buf,
 		if(bit == SUPPRESS)
 		{
 			*out_buf = *phsf;
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECIEVE,DBG_LVL_ALL,"\nDECOMP:In phss  %d phsf %d ouput %d",
+			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECEIVE,DBG_LVL_ALL,"\nDECOMP:In phss  %d phsf %d ouput %d",
               phss,*phsf,*out_buf);
 		}
 		else
 		{
 			*out_buf = *in_buf;
-			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECIEVE,DBG_LVL_ALL,"\nDECOMP:In phss  %d input %d ouput %d",
+			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_OTHERS, PHS_RECEIVE,DBG_LVL_ALL,"\nDECOMP:In phss  %d input %d ouput %d",
             phss,*in_buf,*out_buf);
 			in_buf++;
 			size++;
diff --git a/drivers/staging/bcm/PHSModule.h b/drivers/staging/bcm/PHSModule.h
index 0dd05a7..c629585 100644
--- a/drivers/staging/bcm/PHSModule.h
+++ b/drivers/staging/bcm/PHSModule.h
@@ -9,7 +9,7 @@ int PHSTransmit(PMINI_ADAPTER Adapter,
 					 PUINT PacketLen,
 					 UCHAR bEthCSSupport);
 
-int PHSRecieve(PMINI_ADAPTER Adapter,
+int PHSReceive(PMINI_ADAPTER Adapter,
 					USHORT usVcid,
 					struct sk_buff *packet,
 					UINT *punPacketLen,
diff --git a/drivers/staging/iio/gyro/adxrs450.h b/drivers/staging/iio/gyro/adxrs450.h
index c92f694..aab8a3c 100644
--- a/drivers/staging/iio/gyro/adxrs450.h
+++ b/drivers/staging/iio/gyro/adxrs450.h
@@ -44,7 +44,7 @@
  * @us:			actual spi_device
  * @indio_dev:		industrial I/O device structure
  * @tx:			transmit buffer
- * @rx:			recieve buffer
+ * @rx:			receive buffer
  * @buf_lock:		mutex to protect tx and rx
  **/
 struct adxrs450_state {
diff --git a/drivers/staging/usbip/userspace/src/usbip_attach.c b/drivers/staging/usbip/userspace/src/usbip_attach.c
index 189238b..06640b2 100644
--- a/drivers/staging/usbip/userspace/src/usbip_attach.c
+++ b/drivers/staging/usbip/userspace/src/usbip_attach.c
@@ -131,7 +131,7 @@ static int query_import_device(int sockfd, char *busid)
 		return -1;
 	}
 
-	/* recieve a reply */
+	/* receive a reply */
 	rc = usbip_recv_op_common(sockfd, &code);
 	if (rc < 0) {
 		err("recv op_common");
diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index 332f9e6..521b44e 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -409,7 +409,7 @@ gboolean process_comming_request(GIOChannel *gio, GIOCondition condition,
 
 		ret = recv_pdu(csock);
 		if (ret < 0)
-			err("process recieved pdu");
+			err("process received pdu");
 
 		close(csock);
 	}
-- 
1.7.6.rc1

