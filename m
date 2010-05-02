Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab0EBIkM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 04:40:12 -0400
Received: from smtprelay-h11.telenor.se ([62.127.194.4]:34184 "EHLO
	smtprelay-h11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab0EBIkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 04:40:09 -0400
X-SENDER-IP: [83.226.250.226]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvdEAMfW3EtT4vriPGdsb2JhbACBN4YylU0BAQEBNbhwhRIE
X-IronPort-AV: E=Sophos;i="4.52,311,1270418400"; 
   d="scan'208";a="69666885"
Message-ID: <4BDD3A62.3070502@coyote.org>
Date: Sun, 02 May 2010 10:40:02 +0200
From: Lars Lindley <lindley@coyote.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100428 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Pavel Machek <pavel@ucw.cz>,
       gregkh@suse.de, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mlmetxrx.c Coding style fixes.
References: <1269018531-18891-1-git-send-email-lindley@coyote.org> <20100320001048.GA1477@ucw.cz> <4BA4829D.3060600@coyote.org> <4BA61437.5080303@cs.helsinki.fi> <20100428225747.GF24604@kroah.com>
In-Reply-To: <20100428225747.GF24604@kroah.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2010-04-29 00:57, Greg KH wrote:
> On Sun, Mar 21, 2010 at 02:42:31PM +0200, Pekka Enberg wrote:
>> Lars Lindley wrote:
>>> [PATCH] staging: winbond: mlmetxrx.c func. argument name change.
>>>
>>> I changed some function argument names to make them more readable.
>>>
>>> Signed-off-by: Lars Lindley <lindley@coyote.org>
>>
>> I'd much rather see a new version of the patch that squashes the fixlet but:
>>
>> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>a
> 
> Yes, can you merge both of these together into one patch?
> 
> thanks,
> 
> greg k-h
> 


OK, same thing here. Rebase doesnt work for med but here's a diff of mlmetxrx.c that includes
both patches.


diff --git a/drivers/staging/winbond/mlmetxrx.c b/drivers/staging/winbond/mlmetxrx.c
index f856b94..a8f4b8b 100644
--- a/drivers/staging/winbond/mlmetxrx.c
+++ b/drivers/staging/winbond/mlmetxrx.c
@@ -1,28 +1,25 @@
-//============================================================================
-//  Module Name:
-//    MLMETxRx.C
-//
-//  Description:
-//    The interface between MDS (MAC Data Service) and MLME.
-//
-//  Revision History:
-//  --------------------------------------------------------------------------
-//          200209      UN20 Jennifer Xu
-//                      Initial Release
-//          20021108    PD43 Austin Liu
-//          20030117    PD43 Austin Liu
-//                      Deleted MLMEReturnPacket and MLMEProcThread()
-//
-//  Copyright (c) 1996-2002 Winbond Electronics Corp. All Rights Reserved.
-//============================================================================
+/*
+ * ============================================================================
+ * Module Name:
+ *    MLMETxRx.C
+ *
+ *  Description:
+ *    The interface between MDS (MAC Data Service) and MLME.
+ *
+ *  Copyright (c) 1996-2002 Winbond Electronics Corp. All Rights Reserved.
+ * ============================================================================
+ */
 #include "sysdef.h"
 
 #include "mds_f.h"
 
-//=============================================================================
-u8 MLMESendFrame(struct wbsoft_priv * adapter, u8 *pMMPDU, u16 len, u8 DataType)
-/*	DataType : FRAME_TYPE_802_11_MANAGEMENT, FRAME_TYPE_802_11_MANAGEMENT_CHALLENGE,
-				FRAME_TYPE_802_11_DATA */
+/*
+ * ============================================================================
+ * DataType:	FRAME_TYPE_802_11_MANAGEMENT,
+ *		FRAME_TYPE_802_11_MANAGEMENT_CHALLENGE,
+ *		FRAME_TYPE_802_11_DATA
+ */
+u8 MLMESendFrame(struct wbsoft_priv *adapter, u8 *mmpdu, u16 len, u8 data_type)
 {
 	if (adapter->sMlmeFrame.IsInUsed != PACKET_FREE_TO_USE) {
 		adapter->sMlmeFrame.wNumTxMMPDUDiscarded++;
@@ -30,17 +27,19 @@ u8 MLMESendFrame(struct wbsoft_priv * adapter, u8 *pMMPDU, u16 len, u8 DataType)
 	}
 	adapter->sMlmeFrame.IsInUsed = PACKET_COME_FROM_MLME;
 
-	// Keep information for sending
-	adapter->sMlmeFrame.pMMPDU = pMMPDU;
-	adapter->sMlmeFrame.DataType = DataType;
-	// len must be the last setting due to QUERY_SIZE_SECOND of Mds
+	/* Keep information for sending */
+	adapter->sMlmeFrame.pMMPDU = mmpdu;
+	adapter->sMlmeFrame.DataType = data_type;
+	/* len must be the last setting due to QUERY_SIZE_SECOND of Mds */
 	adapter->sMlmeFrame.len = len;
 	adapter->sMlmeFrame.wNumTxMMPDU++;
 
-	// H/W will enter power save by set the register. S/W don't send null frame
-	//with PWRMgt bit enbled to enter power save now.
+	/*
+	 * H/W will enter power save by set the register. S/W don't send null
+	 * frame with PWRMgt bit enbled to enter power save now.
+	 */
 
-	// Transmit NDIS packet
+	/* Transmit NDIS packet */
 	Mds_Tx(adapter);
 	return true;
 }
@@ -56,38 +55,34 @@ void MLME_GetNextPacket(struct wbsoft_priv *adapter, struct wb35_descriptor *des
 	desc->Type = adapter->sMlmeFrame.DataType;
 }
 
-static void MLMEfreeMMPDUBuffer(struct wbsoft_priv *adapter, s8 *pData)
+static void MLMEfreeMMPDUBuffer(struct wbsoft_priv *adapter, s8 *data)
 {
 	int i;
 
-	// Reclaim the data buffer
+	/* Reclaim the data buffer */
 	for (i = 0; i < MAX_NUM_TX_MMPDU; i++) {
-		if (pData == (s8 *)&(adapter->sMlmeFrame.TxMMPDU[i]))
+		if (data == (s8 *)&(adapter->sMlmeFrame.TxMMPDU[i]))
 			break;
 	}
 	if (adapter->sMlmeFrame.TxMMPDUInUse[i])
 		adapter->sMlmeFrame.TxMMPDUInUse[i] = false;
-	else  {
-		// Something wrong
-		// PD43 Add debug code here???
+	else {
+		/* Something wrong */
+		/* PD43 Add debug code here??? */
 	}
 }
 
-void
-MLME_SendComplete(struct wbsoft_priv * adapter, u8 PacketID, unsigned char SendOK)
+void MLME_SendComplete(struct wbsoft_priv *adapter, u8 packet_id, unsigned char send_ok)
 {
 	MLME_TXCALLBACK	TxCallback;
 
-    // Reclaim the data buffer
+	/* Reclaim the data buffer */
 	adapter->sMlmeFrame.len = 0;
-	MLMEfreeMMPDUBuffer( adapter, adapter->sMlmeFrame.pMMPDU );
-
+	MLMEfreeMMPDUBuffer(adapter, adapter->sMlmeFrame.pMMPDU);
 
 	TxCallback.bResult = MLME_SUCCESS;
 
-	// Return resource
+	/* Return resource */
 	adapter->sMlmeFrame.IsInUsed = PACKET_FREE_TO_USE;
 }
 
-
-
