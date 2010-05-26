Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934882Ab0EZXky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:40:54 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56342 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932401Ab0EZXks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:40:48 -0400
From: Mike Sheldon <mike@mikeasoft.com>
To: greg@kroah.com, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Sheldon <mike@mikeasoft.com>
Subject: [PATCH 03/15] Staging: winbond: Fix spacing around brackets, braces, etc.
Date: Thu, 27 May 2010 00:39:40 +0100
Message-Id: <1274917192-16962-3-git-send-email-mike@mikeasoft.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
References: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches mds.c to correct the spacing around brackets, braces, less than/greater than, equals as reported by checkpatch.pl

Signed-off-by: Mike Sheldon <mike@mikeasoft.com>
---
 drivers/staging/winbond/mds.c |  153 ++++++++++++++++++-----------------------
 1 files changed, 66 insertions(+), 87 deletions(-)

diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index e8320a6..477dff4 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -14,7 +14,7 @@ Mds_initial(struct wbsoft_priv *adapter)
 	pMds->TxRTSThreshold = DEFAULT_RTSThreshold;
 	pMds->TxFragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;
 
-	return hal_get_tx_buffer( &adapter->sHwData, &pMds->pTxBuffer );
+	return hal_get_tx_buffer(&adapter->sHwData, &pMds->pTxBuffer);
 }
 
 void
@@ -43,14 +43,13 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 	pT01 = (PT01_DESCRIPTOR)(buffer+4);
 	pNextT00 = (PT00_DESCRIPTOR)(buffer+OffsetSize);
 
-	if( buffer[ DOT_11_DA_OFFSET+8 ] & 0x1 ) /* +8 for USB hdr */
+	if (buffer[DOT_11_DA_OFFSET+8] & 0x1) /* +8 for USB hdr */
 		boGroupAddr = true;
 
 	/******************************************
 	 * Set RTS/CTS mechanism
 	 ******************************************/
-	if (!boGroupAddr)
-	{
+	if (!boGroupAddr) {
 		/* NOTE : If the protection mode is enabled and the MSDU will be fragmented,
 		 *		 the tx rates of MPDUs will all be DSSS rates. So it will not use
 		 *		 CTS-to-self in this case. CTS-To-self will only be used when without
@@ -58,23 +57,19 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 		BodyLen = (u16)pT00->T00_frame_length;	/* include 802.11 header */
 		BodyLen += 4;	/* CRC */
 
-		if( BodyLen >= CURRENT_RTS_THRESHOLD )
+		if (BodyLen >= CURRENT_RTS_THRESHOLD)
 			RTS_on = true; /* Using RTS */
-		else
-		{
-			if( pT01->T01_modulation_type ) /* Is using OFDM */
-			{
-				if( CURRENT_PROTECT_MECHANISM ) /* Is using protect */
+		else {
+			if (pT01->T01_modulation_type) { /* Is using OFDM */
+				if (CURRENT_PROTECT_MECHANISM) /* Is using protect */
 					CTS_on = true; /* Using CTS */
 			}
 		}
 	}
 
-	if( RTS_on || CTS_on )
-	{
-		if( pT01->T01_modulation_type) /* Is using OFDM */
-		{
-			/* CTS duration 
+	if (RTS_on || CTS_on) {
+		if (pT01->T01_modulation_type) { /* Is using OFDM */
+			/* CTS duration
 			 *  2 SIFS + DATA transmit time + 1 ACK
 			 *  ACK Rate : 24 Mega bps
 			 *  ACK frame length = 14 bytes */
@@ -82,44 +77,38 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 					   2*PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION +
 					   ((BodyLen*8 + 22 + Rate*4 - 1)/(Rate*4))*Tsym +
 					   ((112 + 22 + 95)/96)*Tsym;
-		}
-		else	/* DSSS */
-		{
+		} else { /* DSSS */
 			/* CTS duration
 			 *  2 SIFS + DATA transmit time + 1 ACK
 			 *  Rate : ?? Mega bps
 			 *  ACK frame length = 14 bytes */
-			if( pT01->T01_plcp_header_length ) /* long preamble */
+			if (pT01->T01_plcp_header_length) /* long preamble */
 				Duration = LONG_PREAMBLE_PLUS_PLCPHEADER_TIME*2;
 			else
 				Duration = SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME*2;
 
-			Duration += ( ((BodyLen + 14)*8 + Rate-1) / Rate +
-						DEFAULT_SIFSTIME*2 );
+			Duration += (((BodyLen + 14)*8 + Rate-1) / Rate +
+						DEFAULT_SIFSTIME*2);
 		}
 
-		if( RTS_on )
-		{
-			if( pT01->T01_modulation_type ) /* Is using OFDM */
-			{
+		if (RTS_on) {
+			if (pT01->T01_modulation_type) { /* Is using OFDM */
 				/* CTS + 1 SIFS + CTS duration
 				 * CTS Rate : 24 Mega bps
 				 * CTS frame length = 14 bytes */
 				Duration += (DEFAULT_SIFSTIME +
 								PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION +
 								((112 + 22 + 95)/96)*Tsym);
-			}
-			else
-			{
+			} else {
 				/* CTS + 1 SIFS + CTS duration
 				 * CTS Rate : ?? Mega bps
 				 * CTS frame length = 14 bytes */
-				if( pT01->T01_plcp_header_length ) /* long preamble */
+				if (pT01->T01_plcp_header_length) /* long preamble */
 					Duration += LONG_PREAMBLE_PLUS_PLCPHEADER_TIME;
 				else
 					Duration += SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME;
 
-				Duration += ( ((112 + Rate-1) / Rate) + DEFAULT_SIFSTIME );
+				Duration += (((112 + Rate-1) / Rate) + DEFAULT_SIFSTIME);
 			}
 		}
 
@@ -132,17 +121,14 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 	/******************************************
 	 * Fill the more fragment descriptor
 	 ******************************************/
-	if( boGroupAddr )
+	if (boGroupAddr)
 		Duration = 0;
-	else
-	{
-		for( i=pDes->FragmentCount-1; i>0; i-- )
-		{
+	else {
+		for (i = pDes->FragmentCount-1; i > 0; i--) {
 			NextBodyLen = (u16)pNextT00->T00_frame_length;
 			NextBodyLen += 4;	/* CRC */
 
-			if( pT01->T01_modulation_type )
-			{
+			if (pT01->T01_modulation_type) {
 				/* OFDM
 				 *  data transmit time + 3 SIFS + 2 ACK
 				 *  Rate : ??Mega bps
@@ -151,28 +137,26 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 				Duration += (((NextBodyLen*8 + 22 + Rate*4 - 1)/(Rate*4)) * Tsym +
 							(((2*14)*8 + 22 + 95)/96)*Tsym +
 							DEFAULT_SIFSTIME*3);
-			}
-			else
-			{
+			} else {
 				/* DSSS
 				 *  data transmit time + 2 ACK + 3 SIFS
 				 *  Rate : ??Mega bps
 				 *  ACK frame length = 14 bytes
 				 * TODO : */
-				if( pT01->T01_plcp_header_length ) /* long preamble */
+				if (pT01->T01_plcp_header_length) /* long preamble */
 					Duration = LONG_PREAMBLE_PLUS_PLCPHEADER_TIME*3;
 				else
 					Duration = SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME*3;
 
-				Duration += ( ((NextBodyLen + (2*14))*8 + Rate-1) / Rate +
-							DEFAULT_SIFSTIME*3 );
+				Duration += (((NextBodyLen + (2*14))*8 + Rate-1) / Rate +
+							DEFAULT_SIFSTIME*3);
 			}
 
 			((u16 *)buffer)[5] = cpu_to_le16(Duration); /* 4 USHOR for skip 8B USB, 2USHORT=FC + Duration */
 
 			/* ----20061009 add by anson's endian */
 			pNextT00->value = cpu_to_le32(pNextT00->value);
-			pT01->value = cpu_to_le32( pT01->value );
+			pT01->value = cpu_to_le32(pT01->value);
 			/* ----end 20061009 add by anson's endian */
 
 			buffer += OffsetSize;
@@ -184,28 +168,25 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 		/*******************************************
 		 * Fill the last fragment descriptor
 		 *******************************************/
-		if( pT01->T01_modulation_type )
-		{
+		if (pT01->T01_modulation_type) {
 			/* OFDM
 			 *  1 SIFS + 1 ACK
 			 *  Rate : 24 Mega bps
 			 * ACK frame length = 14 bytes */
 			Duration = PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION;
 			/* The Tx rate of ACK use 24M */
-			Duration += (((112 + 22 + 95)/96)*Tsym + DEFAULT_SIFSTIME );
-		}
-		else
-		{
+			Duration += (((112 + 22 + 95)/96)*Tsym + DEFAULT_SIFSTIME);
+		} else {
 			/* DSSS
 			 * 1 ACK + 1 SIFS
 			 * Rate : ?? Mega bps
 			 * ACK frame length = 14 bytes(112 bits) */
-			if( pT01->T01_plcp_header_length ) /* long preamble */
+			if (pT01->T01_plcp_header_length) /* long preamble */
 				Duration = LONG_PREAMBLE_PLUS_PLCPHEADER_TIME;
 			else
 				Duration = SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME;
 
-			Duration += ( (112 + Rate-1)/Rate +	DEFAULT_SIFSTIME );
+			Duration += ((112 + Rate-1)/Rate + DEFAULT_SIFSTIME);
 		}
 	}
 
@@ -247,10 +228,10 @@ static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDe
 		SizeLeft -= CopySize;
 
 		/* 1 Byte operation */
-		pctmp = (u8 *)( buffer + 8 + DOT_11_SEQUENCE_OFFSET );
+		pctmp = (u8 *)(buffer + 8 + DOT_11_SEQUENCE_OFFSET);
 		*pctmp &= 0xf0;
 		*pctmp |= FragmentCount; /* 931130.5.m */
-		if( !FragmentCount )
+		if (!FragmentCount)
 			pT00->T00_first_mpdu = 1;
 
 		buffer += 32; /* 8B usb + 24B 802.11 header */
@@ -286,15 +267,13 @@ static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDe
 		/* 931130.5.n */
 		if (pMds->MicAdd) {
 			if (!SizeLeft) {
-				pMds->MicWriteAddress[ pMds->MicWriteIndex ] = buffer - pMds->MicAdd;
-				pMds->MicWriteSize[ pMds->MicWriteIndex ] = pMds->MicAdd;
+				pMds->MicWriteAddress[pMds->MicWriteIndex] = buffer - pMds->MicAdd;
+				pMds->MicWriteSize[pMds->MicWriteIndex] = pMds->MicAdd;
 				pMds->MicAdd = 0;
-			}
-			else if( SizeLeft < 8 ) /* 931130.5.p */
-			{
+			} else if (SizeLeft < 8) { /* 931130.5.p */
 				pMds->MicAdd = SizeLeft;
-				pMds->MicWriteAddress[ pMds->MicWriteIndex ] = buffer - ( 8 - SizeLeft );
-				pMds->MicWriteSize[ pMds->MicWriteIndex ] = 8 - SizeLeft;
+				pMds->MicWriteAddress[pMds->MicWriteIndex] = buffer - (8 - SizeLeft);
+				pMds->MicWriteSize[pMds->MicWriteIndex] = 8 - SizeLeft;
 				pMds->MicWriteIndex++;
 			}
 		}
@@ -302,7 +281,7 @@ static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDe
 		/* Does it need to generate the new header for next mpdu? */
 		if (SizeLeft) {
 			buffer = TargetBuffer + Size; /* Get the next 4n start address */
-			memcpy( buffer, TargetBuffer, 32 ); /* Copy 8B USB +24B 802.11 */
+			memcpy(buffer, TargetBuffer, 32); /* Copy 8B USB +24B 802.11 */
 			pT00 = (PT00_DESCRIPTOR)buffer;
 			pT00->T00_first_mpdu = 0;
 		}
@@ -350,7 +329,7 @@ static void Mds_HeaderCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *
 
 	FragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;	/* Do not fragment */
 	/* Copy full data, the 1'st buffer contain all the data 931130.5.j */
-	memcpy( TargetBuffer, src_buffer, DOT_11_MAC_HEADER_SIZE ); /* Copy header */
+	memcpy(TargetBuffer, src_buffer, DOT_11_MAC_HEADER_SIZE); /* Copy header */
 	pDes->buffer_address[0] = src_buffer + DOT_11_MAC_HEADER_SIZE;
 	pDes->buffer_total_size -= DOT_11_MAC_HEADER_SIZE;
 	pDes->buffer_size[0] = pDes->buffer_total_size;
@@ -377,26 +356,26 @@ static void Mds_HeaderCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *
 
 	pT01->T01_modulation_type = (ctmp1%3) ? 0 : 1;
 
-	for( i=0; i<2; i++ ) {
-		if( i == 1 )
+	for (i = 0; i < 2; i++) {
+		if (i == 1)
 			ctmp1 = ctmpf;
 
 		pMds->TxRate[pDes->Descriptor_ID][i] = ctmp1; /* backup the ta rate and fall back rate */
 
-		if( ctmp1 == 108) ctmp2 = 7;
-		else if( ctmp1 == 96 ) ctmp2 = 6; /* Rate convert for USB */
-		else if( ctmp1 == 72 ) ctmp2 = 5;
-		else if( ctmp1 == 48 ) ctmp2 = 4;
-		else if( ctmp1 == 36 ) ctmp2 = 3;
-		else if( ctmp1 == 24 ) ctmp2 = 2;
-		else if( ctmp1 == 18 ) ctmp2 = 1;
-		else if( ctmp1 == 12 ) ctmp2 = 0;
-		else if( ctmp1 == 22 ) ctmp2 = 3;
-		else if( ctmp1 == 11 ) ctmp2 = 2;
-		else if( ctmp1 == 4  ) ctmp2 = 1;
+		if (ctmp1 == 108) ctmp2 = 7;
+		else if (ctmp1 == 96) ctmp2 = 6; /* Rate convert for USB */
+		else if (ctmp1 == 72) ctmp2 = 5;
+		else if (ctmp1 == 48) ctmp2 = 4;
+		else if (ctmp1 == 36) ctmp2 = 3;
+		else if (ctmp1 == 24) ctmp2 = 2;
+		else if (ctmp1 == 18) ctmp2 = 1;
+		else if (ctmp1 == 12) ctmp2 = 0;
+		else if (ctmp1 == 22) ctmp2 = 3;
+		else if (ctmp1 == 11) ctmp2 = 2;
+		else if (ctmp1 == 4) ctmp2 = 1;
 		else ctmp2 = 0; /* if( ctmp1 == 2  ) or default */
 
-		if( i == 0 )
+		if (i == 0)
 			pT01->T01_transmit_rate = ctmp2;
 		else
 			pT01->T01_fall_back_rate = ctmp2;
@@ -474,14 +453,14 @@ Mds_Tx(struct wbsoft_priv *adapter)
 
 			TxDesIndex = pMds->TxDesIndex; /* Get the current ID */
 			pTxDes->Descriptor_ID = TxDesIndex;
-			pMds->TxDesFrom[ TxDesIndex ] = 2; /* Storing the information of source comming from */
+			pMds->TxDesFrom[TxDesIndex] = 2; /* Storing the information of source comming from */
 			pMds->TxDesIndex++;
 			pMds->TxDesIndex %= MAX_USB_TX_DESCRIPTOR;
 
-			MLME_GetNextPacket( adapter, pTxDes );
+			MLME_GetNextPacket(adapter, pTxDes);
 
 			/* Copy header. 8byte USB + 24byte 802.11Hdr. Set TxRate, Preamble type */
-			Mds_HeaderCopy( adapter, pTxDes, XmitBufAddress );
+			Mds_HeaderCopy(adapter, pTxDes, XmitBufAddress);
 
 			/* For speed up Key setting */
 			if (pTxDes->EapFix) {
@@ -502,7 +481,7 @@ Mds_Tx(struct wbsoft_priv *adapter)
 			XmitBufAddress += CurrentSize;
 
 #ifdef _IBSS_BEACON_SEQ_STICK_
-			if ((XmitBufAddress[ DOT_11_DA_OFFSET+8 ] & 0xfc) != MAC_SUBTYPE_MNGMNT_PROBE_REQUEST) /* +8 for USB hdr */
+			if ((XmitBufAddress[DOT_11_DA_OFFSET+8] & 0xfc) != MAC_SUBTYPE_MNGMNT_PROBE_REQUEST) /* +8 for USB hdr */
 #endif
 				pMds->TxToggle = true;
 
@@ -520,7 +499,7 @@ Mds_Tx(struct wbsoft_priv *adapter)
 		/* Move to the next one, if necessary */
 		if (BufferFilled) {
 			/* size setting */
-			pMds->TxBufferSize[ FillIndex ] = XmitBufSize;
+			pMds->TxBufferSize[FillIndex] = XmitBufSize;
 
 			/* 20060928 set Tx count */
 			pMds->TxCountInBuffer[FillIndex] = FillCount;
@@ -537,7 +516,7 @@ Mds_Tx(struct wbsoft_priv *adapter)
 		if (!PacketSize) /* No more pk for transmitting */
 			break;
 
-	} while(true);
+	} while (true);
 
 	/*
 	 * Start to send by lower module
@@ -563,7 +542,7 @@ Mds_SendComplete(struct wbsoft_priv *adapter, PT02_DESCRIPTOR pT02)
 	if (pT02->T02_IsLastMpdu) {
 		/* TODO: DTO -- get the retry count and fragment count */
 		/* Tx rate */
-		TxRate = pMds->TxRate[ PacketId ][ 0 ];
+		TxRate = pMds->TxRate[PacketId][0];
 		RetryCount = (u8)pT02->T02_MPDU_Cnt;
 		if (pT02->value & FLAG_ERROR_TX_MASK) {
 			SendOK = false;
@@ -572,7 +551,7 @@ Mds_SendComplete(struct wbsoft_priv *adapter, PT02_DESCRIPTOR pT02)
 				/* retry error */
 				pHwData->dto_tx_retry_count += (RetryCount+1);
 				/* [for tx debug] */
-				if (RetryCount<7)
+				if (RetryCount < 7)
 					pHwData->tx_retry_count[RetryCount] += RetryCount;
 				else
 					pHwData->tx_retry_count[7] += RetryCount;
@@ -597,7 +576,7 @@ Mds_SendComplete(struct wbsoft_priv *adapter, PT02_DESCRIPTOR pT02)
 		}
 
 		/* Clear send result buffer */
-		pMds->TxResult[ PacketId ] = 0;
+		pMds->TxResult[PacketId] = 0;
 	} else
-		pMds->TxResult[ PacketId ] |= ((u16)(pT02->value & 0x0ffff));
+		pMds->TxResult[PacketId] |= ((u16)(pT02->value & 0x0ffff));
 }
-- 
1.7.0.4

