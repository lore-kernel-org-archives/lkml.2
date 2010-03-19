Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab0CSRLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 13:11:09 -0400
Received: from smtprelay-h11.telenor.se ([62.127.194.4]:43093 "EHLO
	smtprelay-h11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab0CSRLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 13:11:08 -0400
X-SENDER-IP: [83.226.249.136]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al9HAItMo0tT4vmIPGdsb2JhbACBPIQsgXeTZgEBAQE3unmEegQ
X-IronPort-AV: E=Sophos;i="4.51,275,1267398000"; 
   d="scan'208";a="53430738"
Message-ID: <4BA3B029.7070403@coyote.org>
Date: Fri, 19 Mar 2010 18:11:05 +0100
From: Lars Lindley <lindley@coyote.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100308 Thunderbird/3.0.3
MIME-Version: 1.0
To: Lars Lindley <lindley@coyote.org>
CC: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: mlmetxrx.c Coding style fixes.
References: <1269018531-18891-1-git-send-email-lindley@coyote.org>
In-Reply-To: <1269018531-18891-1-git-send-email-lindley@coyote.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It builds fine and generated .o file is identical to the one from a clean tree.

/Lars

On 2010-03-19 18:08, Lars Lindley wrote:
> I fixed all coding style issues found by checkpatch.pl
> and converted argument names away from CamelCase and
> hungarian notation.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>
> ---
>  drivers/staging/winbond/mlmetxrx.c |   79 +++++++++++++++++-------------------
>  1 files changed, 37 insertions(+), 42 deletions(-)
> 
> diff --git a/drivers/staging/winbond/mlmetxrx.c b/drivers/staging/winbond/mlmetxrx.c
> index f856b94..76b79f0 100644
> --- a/drivers/staging/winbond/mlmetxrx.c
> +++ b/drivers/staging/winbond/mlmetxrx.c
> @@ -1,28 +1,25 @@
> -//============================================================================
> -//  Module Name:
> -//    MLMETxRx.C
> -//
> -//  Description:
> -//    The interface between MDS (MAC Data Service) and MLME.
> -//
> -//  Revision History:
> -//  --------------------------------------------------------------------------
> -//          200209      UN20 Jennifer Xu
> -//                      Initial Release
> -//          20021108    PD43 Austin Liu
> -//          20030117    PD43 Austin Liu
> -//                      Deleted MLMEReturnPacket and MLMEProcThread()
> -//
> -//  Copyright (c) 1996-2002 Winbond Electronics Corp. All Rights Reserved.
> -//============================================================================
> +/*
> + * ============================================================================
> + * Module Name:
> + *    MLMETxRx.C
> + *
> + *  Description:
> + *    The interface between MDS (MAC Data Service) and MLME.
> + *
> + *  Copyright (c) 1996-2002 Winbond Electronics Corp. All Rights Reserved.
> + * ============================================================================
> + */
>  #include "sysdef.h"
>  
>  #include "mds_f.h"
>  
> -//=============================================================================
> -u8 MLMESendFrame(struct wbsoft_priv * adapter, u8 *pMMPDU, u16 len, u8 DataType)
> -/*	DataType : FRAME_TYPE_802_11_MANAGEMENT, FRAME_TYPE_802_11_MANAGEMENT_CHALLENGE,
> -				FRAME_TYPE_802_11_DATA */
> +/*
> + * ============================================================================
> + * DataType:	FRAME_TYPE_802_11_MANAGEMENT,
> + *		FRAME_TYPE_802_11_MANAGEMENT_CHALLENGE,
> + *		FRAME_TYPE_802_11_DATA
> + */
> +u8 MLMESendFrame(struct wbsoft_priv *adapter, u8 *mmpdu, u16 len, u8 datatype)
>  {
>  	if (adapter->sMlmeFrame.IsInUsed != PACKET_FREE_TO_USE) {
>  		adapter->sMlmeFrame.wNumTxMMPDUDiscarded++;
> @@ -30,17 +27,19 @@ u8 MLMESendFrame(struct wbsoft_priv * adapter, u8 *pMMPDU, u16 len, u8 DataType)
>  	}
>  	adapter->sMlmeFrame.IsInUsed = PACKET_COME_FROM_MLME;
>  
> -	// Keep information for sending
> -	adapter->sMlmeFrame.pMMPDU = pMMPDU;
> -	adapter->sMlmeFrame.DataType = DataType;
> -	// len must be the last setting due to QUERY_SIZE_SECOND of Mds
> +	/* Keep information for sending */
> +	adapter->sMlmeFrame.pMMPDU = mmpdu;
> +	adapter->sMlmeFrame.DataType = datatype;
> +	/* len must be the last setting due to QUERY_SIZE_SECOND of Mds */
>  	adapter->sMlmeFrame.len = len;
>  	adapter->sMlmeFrame.wNumTxMMPDU++;
>  
> -	// H/W will enter power save by set the register. S/W don't send null frame
> -	//with PWRMgt bit enbled to enter power save now.
> +	/*
> +	 * H/W will enter power save by set the register. S/W don't send null
> +	 * frame with PWRMgt bit enbled to enter power save now.
> +	 */
>  
> -	// Transmit NDIS packet
> +	/* Transmit NDIS packet */
>  	Mds_Tx(adapter);
>  	return true;
>  }
> @@ -56,38 +55,34 @@ void MLME_GetNextPacket(struct wbsoft_priv *adapter, struct wb35_descriptor *des
>  	desc->Type = adapter->sMlmeFrame.DataType;
>  }
>  
> -static void MLMEfreeMMPDUBuffer(struct wbsoft_priv *adapter, s8 *pData)
> +static void MLMEfreeMMPDUBuffer(struct wbsoft_priv *adapter, s8 *data)
>  {
>  	int i;
>  
> -	// Reclaim the data buffer
> +	/* Reclaim the data buffer */
>  	for (i = 0; i < MAX_NUM_TX_MMPDU; i++) {
> -		if (pData == (s8 *)&(adapter->sMlmeFrame.TxMMPDU[i]))
> +		if (data == (s8 *)&(adapter->sMlmeFrame.TxMMPDU[i]))
>  			break;
>  	}
>  	if (adapter->sMlmeFrame.TxMMPDUInUse[i])
>  		adapter->sMlmeFrame.TxMMPDUInUse[i] = false;
> -	else  {
> -		// Something wrong
> -		// PD43 Add debug code here???
> +	else {
> +		/* Something wrong */
> +		/* PD43 Add debug code here??? */
>  	}
>  }
>  
> -void
> -MLME_SendComplete(struct wbsoft_priv * adapter, u8 PacketID, unsigned char SendOK)
> +void MLME_SendComplete(struct wbsoft_priv *adapter, u8 packetid, unsigned char sendok)
>  {
>  	MLME_TXCALLBACK	TxCallback;
>  
> -    // Reclaim the data buffer
> +	/* Reclaim the data buffer */
>  	adapter->sMlmeFrame.len = 0;
> -	MLMEfreeMMPDUBuffer( adapter, adapter->sMlmeFrame.pMMPDU );
> -
> +	MLMEfreeMMPDUBuffer(adapter, adapter->sMlmeFrame.pMMPDU);
>  
>  	TxCallback.bResult = MLME_SUCCESS;
>  
> -	// Return resource
> +	/* Return resource */
>  	adapter->sMlmeFrame.IsInUsed = PACKET_FREE_TO_USE;
>  }
>  
> -
> -
