Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab0LLX7J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:59:09 -0500
Received: from 232.Red-88-26-245.staticIP.rima-tde.net ([88.26.245.232]:48021
	"HELO sysvalve.homelinux.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755193Ab0LLX7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:59:03 -0500
From: =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
To: linux-kernel@vger.kernel.org
Cc: devel@linuxdriverproject.org, Greg Kroah-Hartman <gregkh@suse.de>,
        =?UTF-8?q?L=2E=20Alberto=20Gim=C3=A9nez?= <agimenez@sysvalve.es>
Subject: [PATCH v2] Staging: rt2860: include KERN_* in printk
Date: Mon, 13 Dec 2010 00:58:44 +0100
Message-Id: <1292198324-12072-1-git-send-email-agimenez@sysvalve.es>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1292176591-26081-4-git-send-email-agimenez@sysvalve.es>
References: <1292176591-26081-4-git-send-email-agimenez@sysvalve.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch complains.

The change of the DBGPRINT_ERR macro causes the change on the callers.

Signed-off-by: L. Alberto Giménez <agimenez@sysvalve.es>
---
 drivers/staging/rt2860/chip/rtmp_phy.h      |   14 ++++++------
 drivers/staging/rt2860/common/ba_action.c   |    6 ++--
 drivers/staging/rt2860/common/cmm_data.c    |    2 +-
 drivers/staging/rt2860/common/cmm_mac_pci.c |   10 ++++----
 drivers/staging/rt2860/common/cmm_mac_usb.c |    2 +-
 drivers/staging/rt2860/common/cmm_wpa.c     |   22 +++++++-----------
 drivers/staging/rt2860/common/ee_efuse.c    |   15 +++++++++---
 drivers/staging/rt2860/common/mlme.c        |   13 +++++------
 drivers/staging/rt2860/common/rt_rf.c       |    3 +-
 drivers/staging/rt2860/common/rtmp_init.c   |   24 ++++++++-----------
 drivers/staging/rt2860/common/rtmp_mcu.c    |    4 +-
 drivers/staging/rt2860/common/spectrum.c    |    2 +-
 drivers/staging/rt2860/pci_main_dev.c       |    2 +-
 drivers/staging/rt2860/rt_linux.c           |   21 ++++++++---------
 drivers/staging/rt2860/rt_linux.h           |    6 +----
 drivers/staging/rt2860/rt_main_dev.c        |    2 +-
 drivers/staging/rt2860/rt_usb.c             |   32 +++++++++++++-------------
 drivers/staging/rt2860/sta/assoc.c          |    2 +-
 drivers/staging/rt2860/sta/auth.c           |    3 +-
 drivers/staging/rt2860/sta/connect.c        |    3 +-
 drivers/staging/rt2860/sta/rtmp_data.c      |    2 +-
 drivers/staging/rt2860/sta/sync.c           |    6 ++--
 drivers/staging/rt2860/usb_main_dev.c       |   12 +++++-----
 23 files changed, 99 insertions(+), 109 deletions(-)

diff --git a/drivers/staging/rt2860/chip/rtmp_phy.h b/drivers/staging/rt2860/chip/rtmp_phy.h
index 9f924ea..98454df 100644
--- a/drivers/staging/rt2860/chip/rtmp_phy.h
+++ b/drivers/staging/rt2860/chip/rtmp_phy.h
@@ -247,7 +247,7 @@
 			}						\
 		}							\
 		if (BbpCsr.field.Busy == BUSY) {			\
-			DBGPRINT_ERR(("BBP(viaMCU=%d) read R%d fail\n", (_bViaMCU), _bbpID));	\
+			DBGPRINT_ERR("BBP(viaMCU=%d) read R%d fail\n", (_bViaMCU), _bbpID);	\
 			*(_pV) = (_pAd)->BbpWriteLatch[_bbpID];               \
 			if ((_bViaMCU) == TRUE) {			\
 				RTMP_IO_READ32(_pAd, _regID, &BbpCsr.word);				\
@@ -336,11 +336,11 @@
 			}						\
 		}							\
 	} else {							\
-		DBGPRINT_ERR((" , brt30xxBanMcuCmd = %d, Read BBP %d \n", (_A)->brt30xxBanMcuCmd, (_I)));	\
+		DBGPRINT_ERR(" , brt30xxBanMcuCmd = %d, Read BBP %d \n", (_A)->brt30xxBanMcuCmd, (_I));	\
 		*(_pV) = (_A)->BbpWriteLatch[_I];			\
 	}								\
 	if ((BbpCsr.field.Busy == BUSY) || ((_A)->bPCIclkOff == TRUE)) { \
-		DBGPRINT_ERR(("BBP read R%d=0x%x fail\n", _I, BbpCsr.word)); \
+		DBGPRINT_ERR("BBP read R%d=0x%x fail\n", _I, BbpCsr.word); \
 		*(_pV) = (_A)->BbpWriteLatch[_I];			\
 	}								\
 }
@@ -378,7 +378,7 @@
 			break;						\
 		}							\
 		if (_busyCnt == MAX_BUSY_COUNT) {			\
-			DBGPRINT_ERR(("BBP write R%d fail\n", _bbpID));	\
+			DBGPRINT_ERR("BBP write R%d fail\n", _bbpID);	\
 			if ((_bViaMCU) == TRUE) {			\
 				RTMP_IO_READ32(_pAd, H2M_BBP_AGENT, &BbpCsr.word);	\
 				BbpCsr.field.Busy = 0;			\
@@ -459,15 +459,15 @@
 				break;															\
 			}																	\
 		} else {						\
-			DBGPRINT_ERR(("  brt30xxBanMcuCmd = %d. Write BBP %d \n",  (_A)->brt30xxBanMcuCmd, (_I)));	\
+			DBGPRINT_ERR("  brt30xxBanMcuCmd = %d. Write BBP %d \n",  (_A)->brt30xxBanMcuCmd, (_I));	\
 		}																	\
 		if ((BusyCnt == MAX_BUSY_COUNT) || ((_A)->bPCIclkOff == TRUE)) { \
 			if (BusyCnt == MAX_BUSY_COUNT)				\
 				(_A)->AccessBBPFailCount++;					\
-			DBGPRINT_ERR(("BBP write R%d=0x%x fail. BusyCnt= %d.bPCIclkOff = %d. \n", _I, BbpCsr.word, BusyCnt, (_A)->bPCIclkOff));	\
+			DBGPRINT_ERR("BBP write R%d=0x%x fail. BusyCnt= %d.bPCIclkOff = %d. \n", _I, BbpCsr.word, BusyCnt, (_A)->bPCIclkOff);	\
 		}																	\
 	} else {							\
-		DBGPRINT_ERR(("****** BBP_Write_Latch Buffer exceeds max boundry ****** \n"));	\
+		DBGPRINT_ERR("****** BBP_Write_Latch Buffer exceeds max boundry ****** \n");	\
 	}																		\
 }
 #endif /* RTMP_MAC_PCI // */
diff --git a/drivers/staging/rt2860/common/ba_action.c b/drivers/staging/rt2860/common/ba_action.c
index 8eef82d..d432b7e 100644
--- a/drivers/staging/rt2860/common/ba_action.c
+++ b/drivers/staging/rt2860/common/ba_action.c
@@ -1270,13 +1270,13 @@ BOOLEAN CntlEnqueueForRecv(struct rt_rtmp_adapter *pAd,
 
 	/* First check the size, it MUST not exceed the mlme queue size */
 	if (MsgLen > MGMT_DMA_BUFFER_SIZE) {
-		DBGPRINT_ERR(("CntlEnqueueForRecv: frame too large, size = %ld \n", MsgLen));
+		DBGPRINT_ERR("CntlEnqueueForRecv: frame too large, size = %ld \n", MsgLen);
 		return FALSE;
 	} else if (MsgLen != sizeof(struct rt_frame_ba_req)) {
-		DBGPRINT_ERR(("CntlEnqueueForRecv: BlockAck Request frame length size = %ld incorrect\n", MsgLen));
+		DBGPRINT_ERR("CntlEnqueueForRecv: BlockAck Request frame length size = %ld incorrect\n", MsgLen);
 		return FALSE;
 	} else if (MsgLen != sizeof(struct rt_frame_ba_req)) {
-		DBGPRINT_ERR(("CntlEnqueueForRecv: BlockAck Request frame length size = %ld incorrect\n", MsgLen));
+		DBGPRINT_ERR("CntlEnqueueForRecv: BlockAck Request frame length size = %ld incorrect\n", MsgLen);
 		return FALSE;
 	}
 
diff --git a/drivers/staging/rt2860/common/cmm_data.c b/drivers/staging/rt2860/common/cmm_data.c
index 93a5347..2204c2b 100644
--- a/drivers/staging/rt2860/common/cmm_data.c
+++ b/drivers/staging/rt2860/common/cmm_data.c
@@ -1366,7 +1366,7 @@ void RTMPResumeMsduTransmission(struct rt_rtmp_adapter *pAd)
 	/* R66 should not be 0 */
 	if (pAd->BbpTuning.R66CurrentValue == 0) {
 		pAd->BbpTuning.R66CurrentValue = 0x38;
-		DBGPRINT_ERR(("RTMPResumeMsduTransmission, R66CurrentValue=0...\n"));
+		DBGPRINT_ERR("RTMPResumeMsduTransmission, R66CurrentValue=0...\n");
 	}
 
 	RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R66,
diff --git a/drivers/staging/rt2860/common/cmm_mac_pci.c b/drivers/staging/rt2860/common/cmm_mac_pci.c
index e26ba49..850f0fb 100644
--- a/drivers/staging/rt2860/common/cmm_mac_pci.c
+++ b/drivers/staging/rt2860/common/cmm_mac_pci.c
@@ -89,7 +89,7 @@ int RTMPAllocTxRxRingMemory(struct rt_rtmp_adapter *pAd)
 
 			if (pAd->TxDescRing[num].AllocVa == NULL) {
 				ErrorValue = ERRLOG_OUT_OF_SHARED_MEMORY;
-				DBGPRINT_ERR(("Failed to allocate a big buffer\n"));
+				DBGPRINT_ERR("Failed to allocate a big buffer\n");
 				Status = NDIS_STATUS_RESOURCES;
 				break;
 			}
@@ -121,7 +121,7 @@ int RTMPAllocTxRxRingMemory(struct rt_rtmp_adapter *pAd)
 
 			if (pAd->TxBufSpace[num].AllocVa == NULL) {
 				ErrorValue = ERRLOG_OUT_OF_SHARED_MEMORY;
-				DBGPRINT_ERR(("Failed to allocate a big buffer\n"));
+				DBGPRINT_ERR("Failed to allocate a big buffer\n");
 				Status = NDIS_STATUS_RESOURCES;
 				break;
 			}
@@ -197,7 +197,7 @@ int RTMPAllocTxRxRingMemory(struct rt_rtmp_adapter *pAd)
 
 		if (pAd->MgmtDescRing.AllocVa == NULL) {
 			ErrorValue = ERRLOG_OUT_OF_SHARED_MEMORY;
-			DBGPRINT_ERR(("Failed to allocate a big buffer\n"));
+			DBGPRINT_ERR("Failed to allocate a big buffer\n");
 			Status = NDIS_STATUS_RESOURCES;
 			break;
 		}
@@ -251,7 +251,7 @@ int RTMPAllocTxRxRingMemory(struct rt_rtmp_adapter *pAd)
 
 		if (pAd->RxDescRing.AllocVa == NULL) {
 			ErrorValue = ERRLOG_OUT_OF_SHARED_MEMORY;
-			DBGPRINT_ERR(("Failed to allocate a big buffer\n"));
+			DBGPRINT_ERR("Failed to allocate a big buffer\n");
 			Status = NDIS_STATUS_RESOURCES;
 			break;
 		}
@@ -304,7 +304,7 @@ int RTMPAllocTxRxRingMemory(struct rt_rtmp_adapter *pAd)
 			/* Error handling */
 			if (pDmaBuf->AllocVa == NULL) {
 				ErrorValue = ERRLOG_OUT_OF_SHARED_MEMORY;
-				DBGPRINT_ERR(("Failed to allocate RxRing's 1st buffer\n"));
+				DBGPRINT_ERR("Failed to allocate RxRing's 1st buffer\n");
 				Status = NDIS_STATUS_RESOURCES;
 				break;
 			}
diff --git a/drivers/staging/rt2860/common/cmm_mac_usb.c b/drivers/staging/rt2860/common/cmm_mac_usb.c
index 72731cb..64a65a4 100644
--- a/drivers/staging/rt2860/common/cmm_mac_usb.c
+++ b/drivers/staging/rt2860/common/cmm_mac_usb.c
@@ -236,7 +236,7 @@ int NICInitTransmit(struct rt_rtmp_adapter *pAd)
 		os_alloc_mem(pAd, (u8 **) (&pAd->MgmtDescRing.AllocVa),
 			     pAd->MgmtDescRing.AllocSize);
 		if (pAd->MgmtDescRing.AllocVa == NULL) {
-			DBGPRINT_ERR(("Failed to allocate a big buffer for MgmtDescRing!\n"));
+			DBGPRINT_ERR("Failed to allocate a big buffer for MgmtDescRing!\n");
 			Status = NDIS_STATUS_RESOURCES;
 			goto out1;
 		}
diff --git a/drivers/staging/rt2860/common/cmm_wpa.c b/drivers/staging/rt2860/common/cmm_wpa.c
index e37b64b..0040f45 100644
--- a/drivers/staging/rt2860/common/cmm_wpa.c
+++ b/drivers/staging/rt2860/common/cmm_wpa.c
@@ -2794,7 +2794,7 @@ u8 *GetSuiteFromRSNIE(u8 *rsnie,
 
 	/* Check length */
 	if ((len <= 0) || (pEid->Len != len)) {
-		DBGPRINT_ERR(("%s : The length is invalid\n", __func__));
+		DBGPRINT_ERR("%s : The length is invalid\n", __func__);
 		return NULL;
 	}
 	/* Check WPA or WPA2 */
@@ -2803,14 +2803,13 @@ u8 *GetSuiteFromRSNIE(u8 *rsnie,
 		u16 ucount;
 
 		if (len < sizeof(struct rt_rsnie)) {
-			DBGPRINT_ERR(("%s : The length is too short for WPA\n",
-				      __func__));
+			DBGPRINT_ERR("%s : The length is too short for WPA\n", __func__);
 			return NULL;
 		}
 		/* Get the count of pairwise cipher */
 		ucount = cpu2le16(pRsnie->ucount);
 		if (ucount > 2) {
-			DBGPRINT_ERR(("%s : The count(%d) of pairwise cipher is invlaid\n", __func__, ucount));
+			DBGPRINT_ERR("%s : The count(%d) of pairwise cipher is invlaid\n", __func__, ucount);
 			return NULL;
 		}
 		/* Get the group cipher */
@@ -2836,14 +2835,13 @@ u8 *GetSuiteFromRSNIE(u8 *rsnie,
 		isWPA2 = TRUE;
 
 		if (len < sizeof(struct rt_rsnie2)) {
-			DBGPRINT_ERR(("%s : The length is too short for WPA2\n",
-				      __func__));
+			DBGPRINT_ERR("%s : The length is too short for WPA2\n", __func__);
 			return NULL;
 		}
 		/* Get the count of pairwise cipher */
 		ucount = cpu2le16(pRsnie->ucount);
 		if (ucount > 2) {
-			DBGPRINT_ERR(("%s : The count(%d) of pairwise cipher is invlaid\n", __func__, ucount));
+			DBGPRINT_ERR("%s : The count(%d) of pairwise cipher is invlaid\n", __func__, ucount);
 			return NULL;
 		}
 		/* Get the group cipher */
@@ -2863,7 +2861,7 @@ u8 *GetSuiteFromRSNIE(u8 *rsnie,
 		offset = sizeof(struct rt_rsnie2) + (4 * (ucount - 1));
 
 	} else {
-		DBGPRINT_ERR(("%s : Unknown IE (%d)\n", __func__, pEid->Eid));
+		DBGPRINT_ERR("%s : Unknown IE (%d)\n", __func__, pEid->Eid);
 		return NULL;
 	}
 
@@ -2872,8 +2870,7 @@ u8 *GetSuiteFromRSNIE(u8 *rsnie,
 	len -= offset;
 
 	if (len < sizeof(struct rt_rsnie_auth)) {
-		DBGPRINT_ERR(("%s : The length of RSNIE is too short\n",
-			      __func__));
+		DBGPRINT_ERR("%s : The length of RSNIE is too short\n", __func__);
 		return NULL;
 	}
 	/* pointer to AKM count */
@@ -2882,8 +2879,7 @@ u8 *GetSuiteFromRSNIE(u8 *rsnie,
 	/* Get the count of pairwise cipher */
 	acount = cpu2le16(pAkm->acount);
 	if (acount > 2) {
-		DBGPRINT_ERR(("%s : The count(%d) of AKM is invlaid\n",
-			      __func__, acount));
+		DBGPRINT_ERR("%s : The count(%d) of AKM is invlaid\n", __func__, acount);
 		return NULL;
 	}
 	/* Get the AKM suite */
@@ -2910,7 +2906,7 @@ u8 *GetSuiteFromRSNIE(u8 *rsnie,
 			return pBuf;
 		}
 	} else {
-		DBGPRINT_ERR(("%s : it can't get any more information beyond AKM \n", __func__));
+		DBGPRINT_ERR("%s : it can't get any more information beyond AKM \n", __func__);
 		return NULL;
 	}
 
diff --git a/drivers/staging/rt2860/common/ee_efuse.c b/drivers/staging/rt2860/common/ee_efuse.c
index 03412f5..fed0ba4 100644
--- a/drivers/staging/rt2860/common/ee_efuse.c
+++ b/drivers/staging/rt2860/common/ee_efuse.c
@@ -264,7 +264,7 @@ int set_eFuseGetFreeBlockCount_Proc(struct rt_rtmp_adapter *pAd, char *arg)
 		if (i == EFUSE_USAGE_MAP_END)
 			efusefreenum = 0;
 	}
-	printk("efuseFreeNumber is %d\n", efusefreenum);
+	printk(KERN_DEBUG "efuseFreeNumber is %d\n", efusefreenum);
 	return TRUE;
 }
 
@@ -274,16 +274,23 @@ int set_eFusedump_Proc(struct rt_rtmp_adapter *pAd, char *arg)
 	int i = 0;
 	if (!pAd->bUseEfuse)
 		return FALSE;
+
+	printk(KERN_DEBUG "Block 0: ");
+
 	for (i = 0; i < EFUSE_USAGE_MAP_END / 2; i++) {
 		InBuf[0] = 2 * i;
 		InBuf[1] = 2;
 		InBuf[2] = 0x0;
 
 		eFuseReadPhysical(pAd, &InBuf[0], 4, &InBuf[2], 2);
-		if (i % 4 == 0)
-			printk("\nBlock %x:", i / 8);
-		printk("%04x ", InBuf[2]);
+		if (i && i % 4 == 0) {
+			printk(KERN_CONT "\n");
+			printk(KERN_DEBUG "Block %x:", i / 8);
+		}
+		printk(KERN_CONT "%04x ", InBuf[2]);
 	}
+	printk(KERN_CONT "\n");
+
 	return TRUE;
 }
 
diff --git a/drivers/staging/rt2860/common/mlme.c b/drivers/staging/rt2860/common/mlme.c
index 7300c6e..d9c3fd5 100644
--- a/drivers/staging/rt2860/common/mlme.c
+++ b/drivers/staging/rt2860/common/mlme.c
@@ -550,7 +550,7 @@ void MlmeHandler(struct rt_rtmp_adapter *pAd)
 			Elem->MsgLen = 0;
 
 		} else {
-			DBGPRINT_ERR(("MlmeHandler: MlmeQueue empty\n"));
+			DBGPRINT_ERR("MlmeHandler: MlmeQueue empty\n");
 		}
 	}
 
@@ -4698,8 +4698,7 @@ BOOLEAN MlmeEnqueue(struct rt_rtmp_adapter *pAd,
 
 	/* First check the size, it MUST not exceed the mlme queue size */
 	if (MsgLen > MGMT_DMA_BUFFER_SIZE) {
-		DBGPRINT_ERR(("MlmeEnqueue: msg too large, size = %ld \n",
-			      MsgLen));
+		DBGPRINT_ERR("MlmeEnqueue: msg too large, size = %ld \n", MsgLen);
 		return FALSE;
 	}
 
@@ -4762,12 +4761,12 @@ BOOLEAN MlmeEnqueueForRecv(struct rt_rtmp_adapter *pAd,
 	if (RTMP_TEST_FLAG
 	    (pAd,
 	     fRTMP_ADAPTER_HALT_IN_PROGRESS | fRTMP_ADAPTER_NIC_NOT_EXIST)) {
-		DBGPRINT_ERR(("MlmeEnqueueForRecv: fRTMP_ADAPTER_HALT_IN_PROGRESS\n"));
+		DBGPRINT_ERR("MlmeEnqueueForRecv: fRTMP_ADAPTER_HALT_IN_PROGRESS\n");
 		return FALSE;
 	}
 	/* First check the size, it MUST not exceed the mlme queue size */
 	if (MsgLen > MGMT_DMA_BUFFER_SIZE) {
-		DBGPRINT_ERR(("MlmeEnqueueForRecv: frame too large, size = %ld \n", MsgLen));
+		DBGPRINT_ERR("MlmeEnqueueForRecv: frame too large, size = %ld \n", MsgLen);
 		return FALSE;
 	}
 
@@ -4777,7 +4776,7 @@ BOOLEAN MlmeEnqueueForRecv(struct rt_rtmp_adapter *pAd,
 
 	{
 		if (!MsgTypeSubst(pAd, pFrame, &Machine, &MsgType)) {
-			DBGPRINT_ERR(("MlmeEnqueueForRecv: un-recongnized mgmt->subtype=%d\n", pFrame->Hdr.FC.SubType));
+			DBGPRINT_ERR("MlmeEnqueueForRecv: un-recongnized mgmt->subtype=%d\n", pFrame->Hdr.FC.SubType);
 			return FALSE;
 		}
 	}
@@ -4867,7 +4866,7 @@ void MlmeRestartStateMachine(struct rt_rtmp_adapter *pAd)
 			Elem->MsgLen = 0;
 
 		} else {
-			DBGPRINT_ERR(("MlmeRestartStateMachine: MlmeQueue empty\n"));
+			DBGPRINT_ERR("MlmeRestartStateMachine: MlmeQueue empty\n");
 		}
 	}
 #endif /* RTMP_MAC_PCI // */
diff --git a/drivers/staging/rt2860/common/rt_rf.c b/drivers/staging/rt2860/common/rt_rf.c
index 519121d..2895447 100644
--- a/drivers/staging/rt2860/common/rt_rf.c
+++ b/drivers/staging/rt2860/common/rt_rf.c
@@ -131,8 +131,7 @@ int RT30xxReadRFRegister(struct rt_rtmp_adapter *pAd,
 		}
 	}
 	if (rfcsr.field.RF_CSR_KICK == BUSY) {
-		DBGPRINT_ERR(("RF read R%d=0x%x fail, i[%d], k[%d]\n", regID,
-			      rfcsr.word, i, k));
+		DBGPRINT_ERR("RF read R%d=0x%x fail, i[%d], k[%d]\n", regID, rfcsr.word, i, k);
 		return STATUS_UNSUCCESSFUL;
 	}
 
diff --git a/drivers/staging/rt2860/common/rtmp_init.c b/drivers/staging/rt2860/common/rtmp_init.c
index 3628e85..d359a14 100644
--- a/drivers/staging/rt2860/common/rtmp_init.c
+++ b/drivers/staging/rt2860/common/rtmp_init.c
@@ -169,14 +169,14 @@ int RTMPAllocAdapterBlock(void *handle,
 		pBeaconBuf = kmalloc(MAX_BEACON_SIZE, MEM_ALLOC_FLAG);
 		if (pBeaconBuf == NULL) {
 			Status = NDIS_STATUS_FAILURE;
-			DBGPRINT_ERR(("Failed to allocate memory - BeaconBuf!\n"));
+			DBGPRINT_ERR("Failed to allocate memory - BeaconBuf!\n");
 			break;
 		}
 		NdisZeroMemory(pBeaconBuf, MAX_BEACON_SIZE);
 
 		Status = AdapterBlockAllocateMemory(handle, (void **) & pAd);
 		if (Status != NDIS_STATUS_SUCCESS) {
-			DBGPRINT_ERR(("Failed to allocate memory - ADAPTER\n"));
+			DBGPRINT_ERR("Failed to allocate memory - ADAPTER\n");
 			break;
 		}
 		pAd->BeaconBuf = pBeaconBuf;
@@ -785,8 +785,7 @@ void NICReadEEPROMParameters(struct rt_rtmp_adapter *pAd, u8 *mac_addr)
 		  Version.field.Version, Version.field.FaeReleaseNumber));
 
 	if (Version.field.Version > VALID_EEPROM_VERSION) {
-		DBGPRINT_ERR(("E2PROM: WRONG VERSION 0x%x, should be %d\n",
-			      Version.field.Version, VALID_EEPROM_VERSION));
+		DBGPRINT_ERR("E2PROM: WRONG VERSION 0x%x, should be %d\n", Version.field.Version, VALID_EEPROM_VERSION);
 		/*pAd->SystemErrorBitmap |= 0x00000001;
 
 		   // hard-code default value when no proper E2PROM installed
@@ -2911,7 +2910,7 @@ void RTMPSetTimer(struct rt_ralink_timer *pTimer, unsigned long Value)
 			RTMP_OS_Add_Timer(&pTimer->TimerObj, Value);
 		}
 	} else {
-		DBGPRINT_ERR(("RTMPSetTimer failed, Timer hasn't been initialize!\n"));
+		DBGPRINT_ERR("RTMPSetTimer failed, Timer hasn't been initialize!\n");
 	}
 }
 
@@ -2947,7 +2946,7 @@ void RTMPModTimer(struct rt_ralink_timer *pTimer, unsigned long Value)
 			RTMP_OS_Mod_Timer(&pTimer->TimerObj, Value);
 		}
 	} else {
-		DBGPRINT_ERR(("RTMPModTimer failed, Timer hasn't been initialize!\n"));
+		DBGPRINT_ERR("RTMPModTimer failed, Timer hasn't been initialize!\n");
 	}
 }
 
@@ -2989,7 +2988,7 @@ void RTMPCancelTimer(struct rt_ralink_timer *pTimer, OUT BOOLEAN * pCancelled)
 		RtmpTimerQRemove(pTimer->pAd, pTimer);
 #endif /* RTMP_TIMER_TASK_SUPPORT // */
 	} else {
-		DBGPRINT_ERR(("RTMPCancelTimer failed, Timer hasn't been initialize!\n"));
+		DBGPRINT_ERR("RTMPCancelTimer failed, Timer hasn't been initialize!\n");
 	}
 }
 
@@ -3251,8 +3250,7 @@ int rt28xx_init(struct rt_rtmp_adapter *pAd,
 	/* Load 8051 firmware */
 	Status = NICLoadFirmware(pAd);
 	if (Status != NDIS_STATUS_SUCCESS) {
-		DBGPRINT_ERR(("NICLoadFirmware failed, Status[=0x%08x]\n",
-			      Status));
+		DBGPRINT_ERR("NICLoadFirmware failed, Status[=0x%08x]\n", Status);
 		goto err1;
 	}
 
@@ -3268,8 +3266,7 @@ int rt28xx_init(struct rt_rtmp_adapter *pAd,
 
 	Status = RTMPAllocTxRxRingMemory(pAd);
 	if (Status != NDIS_STATUS_SUCCESS) {
-		DBGPRINT_ERR(("RTMPAllocDMAMemory failed, Status[=0x%08x]\n",
-			      Status));
+		DBGPRINT_ERR("RTMPAllocDMAMemory failed, Status[=0x%08x]\n", Status);
 		goto err1;
 	}
 
@@ -3284,7 +3281,7 @@ int rt28xx_init(struct rt_rtmp_adapter *pAd,
 
 	Status = MlmeInit(pAd);
 	if (Status != NDIS_STATUS_SUCCESS) {
-		DBGPRINT_ERR(("MlmeInit failed, Status[=0x%08x]\n", Status));
+		DBGPRINT_ERR("MlmeInit failed, Status[=0x%08x]\n", Status);
 		goto err2;
 	}
 	/* Initialize pAd->StaCfg, pAd->ApCfg, pAd->CommonCfg to manufacture default */
@@ -3309,8 +3306,7 @@ int rt28xx_init(struct rt_rtmp_adapter *pAd,
 	/* */
 	Status = NICInitializeAdapter(pAd, TRUE);
 	if (Status != NDIS_STATUS_SUCCESS) {
-		DBGPRINT_ERR(("NICInitializeAdapter failed, Status[=0x%08x]\n",
-			      Status));
+		DBGPRINT_ERR("NICInitializeAdapter failed, Status[=0x%08x]\n", Status);
 		if (Status != NDIS_STATUS_SUCCESS)
 			goto err3;
 	}
diff --git a/drivers/staging/rt2860/common/rtmp_mcu.c b/drivers/staging/rt2860/common/rtmp_mcu.c
index 844d4b9..80fa416 100644
--- a/drivers/staging/rt2860/common/rtmp_mcu.c
+++ b/drivers/staging/rt2860/common/rtmp_mcu.c
@@ -267,7 +267,7 @@ int RtmpAsicSendCommandToMcu(struct rt_rtmp_adapter *pAd,
 		} while (i++ < 100);
 
 		if (i > 100) {
-			DBGPRINT_ERR(("H2M_MAILBOX still hold by MCU. command fail\n"));
+			DBGPRINT_ERR("H2M_MAILBOX still hold by MCU. command fail\n");
 			return FALSE;
 		}
 
@@ -296,7 +296,7 @@ int RtmpAsicSendCommandToMcu(struct rt_rtmp_adapter *pAd,
 #ifdef RTMP_MAC_PCI
 #endif /* RTMP_MAC_PCI // */
 			{
-				DBGPRINT_ERR(("H2M_MAILBOX still hold by MCU. command fail\n"));
+				DBGPRINT_ERR("H2M_MAILBOX still hold by MCU. command fail\n");
 			}
 			return FALSE;
 		}
diff --git a/drivers/staging/rt2860/common/spectrum.c b/drivers/staging/rt2860/common/spectrum.c
index 2d5f847..1dfb802 100644
--- a/drivers/staging/rt2860/common/spectrum.c
+++ b/drivers/staging/rt2860/common/spectrum.c
@@ -1837,7 +1837,7 @@ static void PeerChSwAnnAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_
 			}
 
 			if (index >= pAd->ChannelListNum) {
-				DBGPRINT_ERR(("&&&&&&&&&&&&&&&&&&&&&&&&&&PeerChSwAnnAction(can not find New Channel=%d in ChannelList[%d]\n", pAd->CommonCfg.Channel, pAd->ChannelListNum));
+				DBGPRINT_ERR("&&&&&&&&&&&&&&&&&&&&&&&&&&PeerChSwAnnAction(can not find New Channel=%d in ChannelList[%d]\n", pAd->CommonCfg.Channel, pAd->ChannelListNum);
 			}
 		}
 	}
diff --git a/drivers/staging/rt2860/pci_main_dev.c b/drivers/staging/rt2860/pci_main_dev.c
index 628559d..1949acd 100644
--- a/drivers/staging/rt2860/pci_main_dev.c
+++ b/drivers/staging/rt2860/pci_main_dev.c
@@ -202,7 +202,7 @@ static int rt2860_resume(struct pci_dev *pci_dev)
 
 	/* initialize device before it's used by a driver */
 	if (pci_enable_device(pci_dev)) {
-		printk("pci enable fail!\n");
+		printk(KERN_ERR "rt2860: pci enable fail!\n");
 		return 0;
 	}
 
diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
index abfeea1..e95db46 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -321,7 +321,7 @@ int RTMPCloneNdisPacket(struct rt_rtmp_adapter *pAd,
 
 	RTMP_SET_PACKET_SOURCE(OSPKT_TO_RTPKT(pkt), PKTSRC_NDIS);
 
-	printk("###Clone###\n");
+	printk(KERN_DEBUG "###Clone###\n");
 
 	return NDIS_STATUS_SUCCESS;
 }
@@ -343,9 +343,8 @@ int RTMPAllocateNdisPacket(struct rt_rtmp_adapter *pAd,
 					   RTMP_PKT_TAIL_PADDING);
 	if (pPacket == NULL) {
 		*ppPacket = NULL;
-#ifdef DEBUG
-		printk("RTMPAllocateNdisPacket Fail\n");
-#endif
+		pr_devel("RTMPAllocateNdisPacket Fail\n");
+
 		return NDIS_STATUS_FAILURE;
 	}
 	/* 2. clone the frame content */
@@ -601,15 +600,15 @@ void hex_dump(char *str, unsigned char *pSrcBufVA, unsigned int SrcBufLen)
 		return;
 
 	pt = pSrcBufVA;
-	printk("%s: %p, len = %d\n", str, pSrcBufVA, SrcBufLen);
+	printk(KERN_DEBUG "%s: %p, len = %d\n", str, pSrcBufVA, SrcBufLen);
 	for (x = 0; x < SrcBufLen; x++) {
 		if (x % 16 == 0)
-			printk("0x%04x : ", x);
-		printk("%02x ", ((unsigned char)pt[x]));
+			printk(KERN_DEBUG "0x%04x : ", x);
+		printk(KERN_DEBUG "%02x ", ((unsigned char)pt[x]));
 		if (x % 16 == 15)
-			printk("\n");
+			printk(KERN_DEBUG "\n");
 	}
-	printk("\n");
+	printk(KERN_DEBUG "\n");
 }
 
 /*
@@ -926,7 +925,7 @@ int RtmpOSIRQRequest(struct net_device *pNetDev)
 		    request_irq(_pObj->pci_dev->irq, rt2860_interrupt, SA_SHIRQ,
 				(net_dev)->name, (net_dev));
 		if (retval != 0)
-			printk("RT2860: request_irq  ERROR(%d)\n", retval);
+			printk(KERN_ERR "rt2860: request_irq  ERROR(%d)\n", retval);
 	}
 
 	return retval;
@@ -1022,7 +1021,7 @@ int RtmpOSTaskKill(struct rt_rtmp_os_task *pTask)
 	}
 #else
 	CHECK_PID_LEGALITY(pTask->taskPID) {
-		printk("Terminate the task(%s) with pid(%d)!\n",
+		printk(KERN_INFO "Terminate the task(%s) with pid(%d)!\n",
 		       pTask->taskName, GET_PID_NUMBER(pTask->taskPID));
 		mb();
 		pTask->task_killed = 1;
diff --git a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_linux.h
index 5acedf1..3d10e56 100644
--- a/drivers/staging/rt2860/rt_linux.h
+++ b/drivers/staging/rt2860/rt_linux.h
@@ -422,11 +422,7 @@ do{                                   \
 
 #define DBGPRINT(Level, Fmt)    DBGPRINT_RAW(Level, Fmt)
 
-#define DBGPRINT_ERR(Fmt)           \
-{                                   \
-    printk("ERROR! ");          \
-    printk Fmt;                  \
-}
+#define DBGPRINT_ERR(fmt, args...) printk(KERN_ERR fmt, ##args)
 
 #define DBGPRINT_S(Status, Fmt)		\
 {									\
diff --git a/drivers/staging/rt2860/rt_main_dev.c b/drivers/staging/rt2860/rt_main_dev.c
index ad60cea..8f0ff94 100644
--- a/drivers/staging/rt2860/rt_main_dev.c
+++ b/drivers/staging/rt2860/rt_main_dev.c
@@ -420,7 +420,7 @@ int rt28xx_open(struct net_device *dev)
 	{
 		u32 reg = 0;
 		RTMP_IO_READ32(pAd, 0x1300, &reg);	/* clear garbage interrupts */
-		printk("0x1300 = %08x\n", reg);
+		printk(KERN_DEBUG "0x1300 = %08x\n", reg);
 	}
 
 	{
diff --git a/drivers/staging/rt2860/rt_usb.c b/drivers/staging/rt2860/rt_usb.c
index bcfc0f5..f879a75 100644
--- a/drivers/staging/rt2860/rt_usb.c
+++ b/drivers/staging/rt2860/rt_usb.c
@@ -40,25 +40,25 @@
 
 void dump_urb(struct urb *purb)
 {
-	printk("urb                  :0x%08lx\n", (unsigned long)purb);
-	printk("\tdev                   :0x%08lx\n", (unsigned long)purb->dev);
-	printk("\t\tdev->state          :0x%d\n", purb->dev->state);
-	printk("\tpipe                  :0x%08x\n", purb->pipe);
-	printk("\tstatus                :%d\n", purb->status);
-	printk("\ttransfer_flags        :0x%08x\n", purb->transfer_flags);
-	printk("\ttransfer_buffer       :0x%08lx\n",
+	printk(KERN_DEBUG "urb                  :0x%08lx\n", (unsigned long)purb);
+	printk(KERN_DEBUG "\tdev                   :0x%08lx\n", (unsigned long)purb->dev);
+	printk(KERN_DEBUG "\t\tdev->state          :0x%d\n", purb->dev->state);
+	printk(KERN_DEBUG "\tpipe                  :0x%08x\n", purb->pipe);
+	printk(KERN_DEBUG "\tstatus                :%d\n", purb->status);
+	printk(KERN_DEBUG "\ttransfer_flags        :0x%08x\n", purb->transfer_flags);
+	printk(KERN_DEBUG "\ttransfer_buffer       :0x%08lx\n",
 	       (unsigned long)purb->transfer_buffer);
-	printk("\ttransfer_buffer_length:%d\n", purb->transfer_buffer_length);
-	printk("\tactual_length         :%d\n", purb->actual_length);
-	printk("\tsetup_packet          :0x%08lx\n",
+	printk(KERN_DEBUG "\ttransfer_buffer_length:%d\n", purb->transfer_buffer_length);
+	printk(KERN_DEBUG "\tactual_length         :%d\n", purb->actual_length);
+	printk(KERN_DEBUG "\tsetup_packet          :0x%08lx\n",
 	       (unsigned long)purb->setup_packet);
-	printk("\tstart_frame           :%d\n", purb->start_frame);
-	printk("\tnumber_of_packets     :%d\n", purb->number_of_packets);
-	printk("\tinterval              :%d\n", purb->interval);
-	printk("\terror_count           :%d\n", purb->error_count);
-	printk("\tcontext               :0x%08lx\n",
+	printk(KERN_DEBUG "\tstart_frame           :%d\n", purb->start_frame);
+	printk(KERN_DEBUG "\tnumber_of_packets     :%d\n", purb->number_of_packets);
+	printk(KERN_DEBUG "\tinterval              :%d\n", purb->interval);
+	printk(KERN_DEBUG "\terror_count           :%d\n", purb->error_count);
+	printk(KERN_DEBUG "\tcontext               :0x%08lx\n",
 	       (unsigned long)purb->context);
-	printk("\tcomplete              :0x%08lx\n\n",
+	printk(KERN_DEBUG "\tcomplete              :0x%08lx\n\n",
 	       (unsigned long)purb->complete);
 }
 
diff --git a/drivers/staging/rt2860/sta/assoc.c b/drivers/staging/rt2860/sta/assoc.c
index b7efb0b..e9ec6b6 100644
--- a/drivers/staging/rt2860/sta/assoc.c
+++ b/drivers/staging/rt2860/sta/assoc.c
@@ -1054,7 +1054,7 @@ void AssocPostProc(struct rt_rtmp_adapter *pAd, u8 *pAddr2, u16 CapabilityInfo,
 	/* Set New WPA information */
 	Idx = BssTableSearch(&pAd->ScanTab, pAddr2, pAd->MlmeAux.Channel);
 	if (Idx == BSS_NOT_FOUND) {
-		DBGPRINT_ERR(("ASSOC - Can't find BSS after receiving Assoc response\n"));
+		DBGPRINT_ERR("ASSOC - Can't find BSS after receiving Assoc response\n");
 	} else {
 		/* Init variable */
 		pAd->MacTab.Content[BSSID_WCID].RSNIE_Len = 0;
diff --git a/drivers/staging/rt2860/sta/auth.c b/drivers/staging/rt2860/sta/auth.c
index 404bd22..d00f774 100644
--- a/drivers/staging/rt2860/sta/auth.c
+++ b/drivers/staging/rt2860/sta/auth.c
@@ -508,8 +508,7 @@ BOOLEAN AUTH_ReqSend(struct rt_rtmp_adapter *pAd,
 		RTMPSetTimer(pAuthTimer, Timeout);
 		return TRUE;
 	} else {
-		DBGPRINT_ERR(("%s - MlmeAuthReqAction() sanity check failed\n",
-			      pSMName));
+		DBGPRINT_ERR("%s - MlmeAuthReqAction() sanity check failed\n", pSMName);
 		return FALSE;
 	}
 
diff --git a/drivers/staging/rt2860/sta/connect.c b/drivers/staging/rt2860/sta/connect.c
index c380551..9df7eda 100644
--- a/drivers/staging/rt2860/sta/connect.c
+++ b/drivers/staging/rt2860/sta/connect.c
@@ -214,8 +214,7 @@ void MlmeCntlMachinePerformAction(struct rt_rtmp_adapter *pAd,
 		break;
 #endif /* RTMP_MAC_USB // */
 	default:
-		DBGPRINT_ERR(("ERROR! CNTL - Illegal message type(=%ld)",
-			      Elem->MsgType));
+		DBGPRINT_ERR("ERROR! CNTL - Illegal message type(=%ld)", Elem->MsgType);
 		break;
 	}
 }
diff --git a/drivers/staging/rt2860/sta/rtmp_data.c b/drivers/staging/rt2860/sta/rtmp_data.c
index 23879b7..609930a 100644
--- a/drivers/staging/rt2860/sta/rtmp_data.c
+++ b/drivers/staging/rt2860/sta/rtmp_data.c
@@ -644,7 +644,7 @@ void STAHandleRxMgmtFrame(struct rt_rtmp_adapter *pAd, struct rt_rx_blk *pRxBlk)
 
 		/* First check the size, it MUST not exceed the mlme queue size */
 		if (pRxWI->MPDUtotalByteCount > MGMT_DMA_BUFFER_SIZE) {
-			DBGPRINT_ERR(("STAHandleRxMgmtFrame: frame too large, size = %d \n", pRxWI->MPDUtotalByteCount));
+			DBGPRINT_ERR("STAHandleRxMgmtFrame: frame too large, size = %d \n", pRxWI->MPDUtotalByteCount);
 			break;
 		}
 
diff --git a/drivers/staging/rt2860/sta/sync.c b/drivers/staging/rt2860/sta/sync.c
index 747d3c6..94a64d0 100644
--- a/drivers/staging/rt2860/sta/sync.c
+++ b/drivers/staging/rt2860/sta/sync.c
@@ -283,7 +283,7 @@ void MlmeScanReqAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *E
 		DBGPRINT(RT_DEBUG_TRACE, ("SYNC - BBP R4 to 20MHz.l\n"));
 		ScanNextChannel(pAd);
 	} else {
-		DBGPRINT_ERR(("SYNC - MlmeScanReqAction() sanity check fail\n"));
+		DBGPRINT_ERR("SYNC - MlmeScanReqAction() sanity check fail\n");
 		pAd->Mlme.SyncMachine.CurrState = SYNC_IDLE;
 		Status = MLME_INVALID_FORMAT;
 		MlmeEnqueue(pAd, MLME_CNTL_STATE_MACHINE, MT2_SCAN_CONF, 2,
@@ -535,7 +535,7 @@ void MlmeStartReqAction(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *
 		MlmeEnqueue(pAd, MLME_CNTL_STATE_MACHINE, MT2_START_CONF, 2,
 			    &Status);
 	} else {
-		DBGPRINT_ERR(("SYNC - MlmeStartReqAction() sanity check fail.\n"));
+		DBGPRINT_ERR("SYNC - MlmeStartReqAction() sanity check fail.\n");
 		pAd->Mlme.SyncMachine.CurrState = SYNC_IDLE;
 		Status = MLME_INVALID_FORMAT;
 		MlmeEnqueue(pAd, MLME_CNTL_STATE_MACHINE, MT2_START_CONF, 2,
@@ -1207,7 +1207,7 @@ void PeerBeacon(struct rt_rtmp_adapter *pAd, struct rt_mlme_queue_elem *Elem)
 			}
 
 			if (index >= pAd->ChannelListNum) {
-				DBGPRINT_ERR(("PeerBeacon(can not find New Channel=%d in ChannelList[%d]\n", pAd->CommonCfg.Channel, pAd->ChannelListNum));
+				DBGPRINT_ERR("PeerBeacon(can not find New Channel=%d in ChannelList[%d]\n", pAd->CommonCfg.Channel, pAd->ChannelListNum);
 			}
 		}
 		/* if the ssid matched & bssid unmatched, we should select the bssid with large value. */
diff --git a/drivers/staging/rt2860/usb_main_dev.c b/drivers/staging/rt2860/usb_main_dev.c
index cd15daa..1803267 100644
--- a/drivers/staging/rt2860/usb_main_dev.c
+++ b/drivers/staging/rt2860/usb_main_dev.c
@@ -233,7 +233,7 @@ BOOLEAN RT28XXChipsetCheck(IN void *_dev_p)
 	for (i = 0; i < rtusb_usb_id_len; i++) {
 		if (dev_p->descriptor.idVendor == rtusb_usb_id[i].idVendor &&
 		    dev_p->descriptor.idProduct == rtusb_usb_id[i].idProduct) {
-			printk("rt2870: idVendor = 0x%x, idProduct = 0x%x\n",
+			printk(KERN_INFO "rt2870: idVendor = 0x%x, idProduct = 0x%x\n",
 			       dev_p->descriptor.idVendor,
 			       dev_p->descriptor.idProduct);
 			break;
@@ -241,7 +241,7 @@ BOOLEAN RT28XXChipsetCheck(IN void *_dev_p)
 	}
 
 	if (i == rtusb_usb_id_len) {
-		printk("rt2870: Error! Device Descriptor not matching!\n");
+		printk(KERN_ERR "rt2870: Error! Device Descriptor not matching!\n");
 		return FALSE;
 	}
 
@@ -323,7 +323,7 @@ static BOOLEAN USBDevConfigInit(IN struct usb_device *dev,
 
 	if (!(pAd->BulkInEpAddr && pAd->BulkOutEpAddr[0])) {
 		printk
-		    ("%s: Could not find both bulk-in and bulk-out endpoints\n",
+		    (KERN_ERR "%s: Could not find both bulk-in and bulk-out endpoints\n",
 		     __FUNCTION__);
 		return FALSE;
 	}
@@ -423,7 +423,7 @@ static int rt2870_resume(struct usb_interface *intf)
 /* Init driver module */
 int __init rtusb_init(void)
 {
-	printk("rtusb init --->\n");
+	printk(KERN_DEBUG "rtusb init --->\n");
 	return usb_register(&rtusb_driver);
 }
 
@@ -431,7 +431,7 @@ int __init rtusb_init(void)
 void __exit rtusb_exit(void)
 {
 	usb_deregister(&rtusb_driver);
-	printk("<--- rtusb exit\n");
+	printk(KERN_DEBUG "<--- rtusb exit\n");
 }
 
 module_init(rtusb_init);
@@ -814,7 +814,7 @@ static void rt2870_disconnect(struct usb_device *dev, struct rt_rtmp_adapter *pA
 		  dev->bus->bus_name, dev->devpath));
 	if (!pAd) {
 		usb_put_dev(dev);
-		printk("rtusb_disconnect: pAd == NULL!\n");
+		printk(KERN_ERR "rtusb_disconnect: pAd == NULL!\n");
 		return;
 	}
 	RTMP_SET_FLAG(pAd, fRTMP_ADAPTER_NIC_NOT_EXIST);
-- 
1.7.2.3

