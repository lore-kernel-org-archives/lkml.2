Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab2GJBgB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 21:36:01 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:43138 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952Ab2GJBfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 21:35:54 -0400
From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        klmckinney1@gmail.com, dan.carpenter@oracle.com, standby24x7@gmail.com,
        Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH 1/3] staging: bcm: Remove code that will never execute
Date: Mon,  9 Jul 2012 22:32:38 -0300
Message-Id: <1341883960-21635-2-git-send-email-marcos.souza.org@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341883960-21635-1-git-send-email-marcos.souza.org@gmail.com>
References: <1341883960-21635-1-git-send-email-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes all references of "if 0" blocks in the bcm drivers.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 drivers/staging/bcm/Misc.c |   63 --------------------------------------------
 1 file changed, 63 deletions(-)

diff --git a/drivers/staging/bcm/Misc.c b/drivers/staging/bcm/Misc.c
index c36fd76..d7c662d 100644
--- a/drivers/staging/bcm/Misc.c
+++ b/drivers/staging/bcm/Misc.c
@@ -402,30 +402,6 @@ INT CopyBufferToControlPacket(struct bcm_mini_adapter *Adapter, PVOID ioBuffer)
 	return Status;
 }
 
-#if 0
-/*****************************************************************
-* Function    - SendStatisticsPointerRequest()
-*
-* Description - This function builds and forwards the Statistics
-* Pointer Request control Packet.
-*
-* Parameters  - Adapter					: Pointer to Adapter structure.
-* - pstStatisticsPtrRequest : Pointer to link request.
-*
-* Returns     - None.
-*****************************************************************/
-static VOID SendStatisticsPointerRequest(struct bcm_mini_adapter *Adapter, struct bcm_link_request *pstStatisticsPtrRequest)
-{
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "======>");
-	pstStatisticsPtrRequest->Leader.Status = STATS_POINTER_REQ_STATUS;
-	pstStatisticsPtrRequest->Leader.PLength = sizeof(ULONG); /* minimum 4 bytes */
-	pstStatisticsPtrRequest->szData[0] = STATISTICS_POINTER_REQ;
-	CopyBufferToControlPacket(Adapter, pstStatisticsPtrRequest);
-	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_RX, RX_DPC, DBG_LVL_ALL, "<=====");
-	return;
-}
-#endif
-
 /******************************************************************
 * Function    - LinkMessage()
 *
@@ -1217,45 +1193,6 @@ static VOID doPowerAutoCorrection(struct bcm_mini_adapter *psAdapter)
 	}
 }
 
-#if 0
-static unsigned char *ReadMacAddrEEPROM(struct bcm_mini_adapter *Adapter, ulong dwAddress)
-{
-	int status = 0, i = 0;
-	unsigned int temp = 0;
-	unsigned char *pucmacaddr = kmalloc(MAC_ADDRESS_SIZE, GFP_KERNEL);
-	int bytes;
-
-	if (!pucmacaddr) {
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "No Buffers to Read the EEPROM Address\n");
-		return NULL;
-	}
-
-	dwAddress |= 0x5b000000;
-	status = wrmalt(Adapter, EEPROM_COMMAND_Q_REG, (PUINT)&dwAddress, sizeof(UINT));
-	if (status != STATUS_SUCCESS) {
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "wrm Failed..\n");
-		kfree(pucmacaddr);
-		pucmacaddr = NULL;
-		goto OUT;
-	}
-
-	for (i = 0; i < MAC_ADDRESS_SIZE; i++) {
-		bytes = rdmalt(Adapter, EEPROM_READ_DATA_Q_REG, &temp, sizeof(temp));
-		if (bytes < 0) {
-			status = bytes;
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "rdm Failed..\n");
-			kfree(pucmacaddr);
-			pucmacaddr = NULL;
-			goto OUT;
-		}
-		pucmacaddr[i] = temp & 0xff;
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_INITEXIT, DRV_ENTRY, DBG_LVL_ALL, "%x\n", pucmacaddr[i]);
-	}
-OUT:
-	return pucmacaddr;
-}
-#endif
-
 static void convertEndian(B_UINT8 rwFlag, PUINT puiBuffer, UINT uiByteCount)
 {
 	UINT uiIndex = 0;
-- 
1.7.10.4

