Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965396Ab0COQgb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 12:36:31 -0400
Received: from smtprelay-h12.telenor.se ([62.127.194.5]:57799 "EHLO
	smtprelay-h12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964955Ab0COQga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 12:36:30 -0400
X-SENDER-IP: [83.226.250.22]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApFDAIL/nUtT4voWPGdsb2JhbACHYZMODAEBAQE3La0GjGaEewQ
X-IronPort-AV: E=Sophos;i="4.49,644,1262559600"; 
   d="scan'208";a="50598680"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz,
       diegoliz@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: mds.c whitspace, indentation etc.
Date: Mon, 15 Mar 2010 17:36:13 +0100
Message-Id: <1268670973-6223-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed most of the problems found by checkpatch.pl.
Some long lines are left and some KERN_..
This is a new revised patch against master with changes
after comments from Stefan Richter and Dan Carpenter.
Forget the old one.

Signed-off-by: Lars Lindley <lindley@coyote.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
---
 drivers/staging/winbond/mds.c |  652 ++++++++++++++++++++++-------------------
 1 files changed, 351 insertions(+), 301 deletions(-)

diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 37e0c18..ef08b51 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -5,8 +5,7 @@
 #include "wbhal_f.h"
 #include "wblinux_f.h"
 
-unsigned char
-Mds_initial(struct wbsoft_priv * adapter)
+unsigned char Mds_initial(struct wbsoft_priv *adapter)
 {
 	struct wb35_mds *pMds = &adapter->Mds;
 
@@ -14,24 +13,24 @@ Mds_initial(struct wbsoft_priv * adapter)
 	pMds->TxRTSThreshold = DEFAULT_RTSThreshold;
 	pMds->TxFragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;
 
-	return hal_get_tx_buffer( &adapter->sHwData, &pMds->pTxBuffer );
+	return hal_get_tx_buffer(&adapter->sHwData, &pMds->pTxBuffer);
 }
 
-void
-Mds_Destroy(struct wbsoft_priv * adapter)
+void Mds_Destroy(struct wbsoft_priv *adapter)
 {
 }
 
-static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor *pDes,  u8 *buffer)
+static void Mds_DurationSet(struct wbsoft_priv *adapter,
+		struct wb35_descriptor *pDes, u8 *buffer)
 {
 	PT00_DESCRIPTOR	pT00;
 	PT01_DESCRIPTOR	pT01;
-	u16	Duration, NextBodyLen, OffsetSize;
-	u8	Rate, i;
+	u16		Duration, NextBodyLen, OffsetSize;
+	u8		Rate, i;
 	unsigned char	CTS_on = false, RTS_on = false;
 	PT00_DESCRIPTOR pNextT00;
-	u16 BodyLen = 0;
-	unsigned char boGroupAddr = false;
+	u16		BodyLen = 0;
+	unsigned char	boGroupAddr = false;
 
 	OffsetSize = pDes->FragmentThreshold + 32 + 3;
 	OffsetSize &= ~0x03;
@@ -40,197 +39,202 @@ static void Mds_DurationSet(struct wbsoft_priv *adapter,  struct wb35_descriptor
 		Rate = 1;
 
 	pT00 = (PT00_DESCRIPTOR)buffer;
-	pT01 = (PT01_DESCRIPTOR)(buffer+4);
-	pNextT00 = (PT00_DESCRIPTOR)(buffer+OffsetSize);
+	pT01 = (PT01_DESCRIPTOR)(buffer + 4);
+	pNextT00 = (PT00_DESCRIPTOR)(buffer + OffsetSize);
 
-	if( buffer[ DOT_11_DA_OFFSET+8 ] & 0x1 ) // +8 for USB hdr
+	if (buffer[DOT_11_DA_OFFSET + 8] & 0x1) /* +8 for USB hdr */
 		boGroupAddr = true;
 
-	//========================================
-	// Set RTS/CTS mechanism
-	//========================================
-	if (!boGroupAddr)
-	{
-		//NOTE : If the protection mode is enabled and the MSDU will be fragmented,
-		//		 the tx rates of MPDUs will all be DSSS rates. So it will not use
-		//		 CTS-to-self in this case. CTS-To-self will only be used when without
-		//		 fragmentation. -- 20050112
-		BodyLen = (u16)pT00->T00_frame_length;	//include 802.11 header
-		BodyLen += 4;	//CRC
-
-		if( BodyLen >= CURRENT_RTS_THRESHOLD )
-			RTS_on = true; // Using RTS
-		else
-		{
-			if( pT01->T01_modulation_type ) // Is using OFDM
-			{
-				if( CURRENT_PROTECT_MECHANISM ) // Is using protect
-					CTS_on = true; // Using CTS
+	/* ========================================
+	 * Set RTS/CTS mechanism
+	 * ========================================
+	 */
+	if (!boGroupAddr) {
+		/*NOTE : If the protection mode is enabled and the MSDU will be
+		 *	 fragmented, the tx rates of MPDUs will all be DSSS
+		 *	 rates. So it will not use CTS-to-self in this case.
+		 *	 CTS-To-self will only be used when without
+		 *	 fragmentation. -- 20050112
+		 */
+		BodyLen = (u16)pT00->T00_frame_length; /*include 802.11 header*/
+		BodyLen += 4;	/*CRC*/
+
+		if (BodyLen >= CURRENT_RTS_THRESHOLD)
+			RTS_on = true; /* Using RTS */
+		else {
+			if (pT01->T01_modulation_type) { /* Is using OFDM */
+				if (CURRENT_PROTECT_MECHANISM) /* Is using
+								* protect
+								*/
+					CTS_on = true; /* Using CTS */
 			}
 		}
 	}
 
-	if( RTS_on || CTS_on )
-	{
-		if( pT01->T01_modulation_type) // Is using OFDM
-		{
-			//CTS duration
-			// 2 SIFS + DATA transmit time + 1 ACK
-			// ACK Rate : 24 Mega bps
-			// ACK frame length = 14 bytes
-			Duration = 2*DEFAULT_SIFSTIME +
-					   2*PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION +
-					   ((BodyLen*8 + 22 + Rate*4 - 1)/(Rate*4))*Tsym +
-					   ((112 + 22 + 95)/96)*Tsym;
-		}
-		else	//DSSS
-		{
-			//CTS duration
-			// 2 SIFS + DATA transmit time + 1 ACK
-			// Rate : ?? Mega bps
-			// ACK frame length = 14 bytes
-			if( pT01->T01_plcp_header_length ) //long preamble
-				Duration = LONG_PREAMBLE_PLUS_PLCPHEADER_TIME*2;
+	if (RTS_on || CTS_on) {
+		if (pT01->T01_modulation_type) { /* Is using OFDM */
+			/* CTS duration
+			 * 2 SIFS + DATA transmit time + 1 ACK
+			 * ACK Rate : 24 Mega bps
+			 * ACK frame length = 14 bytes
+			 */
+			Duration = 2 * DEFAULT_SIFSTIME +
+				2 * PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION +
+				((BodyLen * 8 + 22 + Rate * 4 - 1)/(Rate * 4))
+				* Tsym + ((112 + 22 + 95)/96) * Tsym;
+		} else { /* DSSS
+			  * CTS duration
+			  * 2 SIFS + DATA transmit time + 1 ACK
+			  * Rate : ?? Mega bps
+			  * ACK frame length = 14 bytes
+			  */
+			if (pT01->T01_plcp_header_length) /* long preamble */
+				Duration = LONG_PREAMBLE_PLUS_PLCPHEADER_TIME * 2;
 			else
-				Duration = SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME*2;
+				Duration = SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME * 2;
 
-			Duration += ( ((BodyLen + 14)*8 + Rate-1) / Rate +
-						DEFAULT_SIFSTIME*2 );
+			Duration += (((BodyLen + 14) * 8 + Rate - 1) / Rate +
+						DEFAULT_SIFSTIME * 2);
 		}
 
-		if( RTS_on )
-		{
-			if( pT01->T01_modulation_type ) // Is using OFDM
-			{
-				//CTS + 1 SIFS + CTS duration
-				//CTS Rate : 24 Mega bps
-				//CTS frame length = 14 bytes
+		if (RTS_on) {
+			if (pT01->T01_modulation_type) { /* Is using OFDM */
+				/* CTS + 1 SIFS + CTS duration
+				 * CTS Rate : 24 Mega bps
+				 * CTS frame length = 14 bytes
+				 */
 				Duration += (DEFAULT_SIFSTIME +
-								PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION +
-								((112 + 22 + 95)/96)*Tsym);
-			}
-			else
-			{
-				//CTS + 1 SIFS + CTS duration
-				//CTS Rate : ?? Mega bps
-				//CTS frame length = 14 bytes
-				if( pT01->T01_plcp_header_length ) //long preamble
-					Duration += LONG_PREAMBLE_PLUS_PLCPHEADER_TIME;
-				else
-					Duration += SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME;
-
-				Duration += ( ((112 + Rate-1) / Rate) + DEFAULT_SIFSTIME );
+				PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION +
+				((112 + 22 + 95) / 96) * Tsym);
+			} else {
+				/* CTS + 1 SIFS + CTS duration
+				 * CTS Rate : ?? Mega bps
+				 * CTS frame length = 14 bytes
+				 */
+			    if (pT01->T01_plcp_header_length) /*long preamble*/
+				Duration += LONG_PREAMBLE_PLUS_PLCPHEADER_TIME;
+			    else
+				Duration += SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME;
+
+				Duration += (((112 + Rate - 1) / Rate)
+						+ DEFAULT_SIFSTIME);
 			}
 		}
 
-		// Set the value into USB descriptor
+		/* Set the value into USB descriptor */
 		pT01->T01_add_rts = RTS_on ? 1 : 0;
 		pT01->T01_add_cts = CTS_on ? 1 : 0;
 		pT01->T01_rts_cts_duration = Duration;
 	}
 
-	//=====================================
-	// Fill the more fragment descriptor
-	//=====================================
-	if( boGroupAddr )
+	/* =====================================
+	 * Fill the more fragment descriptor
+	 * =====================================
+	 */
+	if (boGroupAddr)
 		Duration = 0;
-	else
-	{
-		for( i=pDes->FragmentCount-1; i>0; i-- )
-		{
+	else {
+		for (i = pDes->FragmentCount-1; i > 0; i--) {
 			NextBodyLen = (u16)pNextT00->T00_frame_length;
-			NextBodyLen += 4;	//CRC
-
-			if( pT01->T01_modulation_type )
-			{
-				//OFDM
-				// data transmit time + 3 SIFS + 2 ACK
-				// Rate : ??Mega bps
-				// ACK frame length = 14 bytes, tx rate = 24M
+			NextBodyLen += 4;	/* CRC */
+
+			if (pT01->T01_modulation_type) {
+				/* OFDM
+				 * data transmit time + 3 SIFS + 2 ACK
+				 * Rate : ??Mega bps
+				 * ACK frame length = 14 bytes, tx rate = 24M
+				 */
 				Duration = PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION * 3;
-				Duration += (((NextBodyLen*8 + 22 + Rate*4 - 1)/(Rate*4)) * Tsym +
-							(((2*14)*8 + 22 + 95)/96)*Tsym +
-							DEFAULT_SIFSTIME*3);
-			}
-			else
-			{
-				//DSSS
-				// data transmit time + 2 ACK + 3 SIFS
-				// Rate : ??Mega bps
-				// ACK frame length = 14 bytes
-				//TODO :
-				if( pT01->T01_plcp_header_length ) //long preamble
-					Duration = LONG_PREAMBLE_PLUS_PLCPHEADER_TIME*3;
+				Duration += (((NextBodyLen * 8 + 22 + Rate *
+						4 - 1) / (Rate * 4)) * Tsym +
+						(((2 * 14) * 8 + 22 + 95) / 96)
+						* Tsym + DEFAULT_SIFSTIME * 3);
+			} else {
+				/* DSSS
+				 * data transmit time + 2 ACK + 3 SIFS
+				 * Rate : ??Mega bps
+				 * ACK frame length = 14 bytes
+				 * TODO :
+				 */
+				if (pT01->T01_plcp_header_length) /* long preamble */
+					Duration = LONG_PREAMBLE_PLUS_PLCPHEADER_TIME * 3;
 				else
-					Duration = SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME*3;
+					Duration = SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME * 3;
 
-				Duration += ( ((NextBodyLen + (2*14))*8 + Rate-1) / Rate +
-							DEFAULT_SIFSTIME*3 );
+				Duration += (((NextBodyLen + (2 * 14)) * 8 +
+						Rate - 1) / Rate +
+						DEFAULT_SIFSTIME * 3);
 			}
 
-			((u16 *)buffer)[5] = cpu_to_le16(Duration);// 4 USHOR for skip 8B USB, 2USHORT=FC + Duration
+			((u16 *)buffer)[5] = cpu_to_le16(Duration);/* 4 USHOR for skip 8B USB, 2USHORT=FC + Duration */
 
-			//----20061009 add by anson's endian
+			/* ----20061009 add by anson's endian */
 			pNextT00->value = cpu_to_le32(pNextT00->value);
-			pT01->value = cpu_to_le32( pT01->value );
-			//----end 20061009 add by anson's endian
+			pT01->value = cpu_to_le32(pT01->value);
+			/* ----end 20061009 add by anson's endian */
 
 			buffer += OffsetSize;
-			pT01 = (PT01_DESCRIPTOR)(buffer+4);
-			if (i != 1)	//The last fragment will not have the next fragment
-				pNextT00 = (PT00_DESCRIPTOR)(buffer+OffsetSize);
+			pT01 = (PT01_DESCRIPTOR)(buffer + 4);
+			if (i != 1)	/* The last fragment will not have the
+					 * next fragment
+					 */
+				pNextT00 = (PT00_DESCRIPTOR)(buffer + OffsetSize);
 		}
 
-		//=====================================
-		// Fill the last fragment descriptor
-		//=====================================
-		if( pT01->T01_modulation_type )
-		{
-			//OFDM
-			// 1 SIFS + 1 ACK
-			// Rate : 24 Mega bps
-			// ACK frame length = 14 bytes
+		/* =====================================
+		 * Fill the last fragment descriptor
+		 * =====================================
+		 */
+		if (pT01->T01_modulation_type) {
+			/* OFDM
+			 * 1 SIFS + 1 ACK
+			 * Rate : 24 Mega bps
+			 * ACK frame length = 14 bytes
+			 */
 			Duration = PREAMBLE_PLUS_SIGNAL_PLUS_SIGNALEXTENSION;
-			//The Tx rate of ACK use 24M
-			Duration += (((112 + 22 + 95)/96)*Tsym + DEFAULT_SIFSTIME );
-		}
-		else
-		{
-			// DSSS
-			// 1 ACK + 1 SIFS
-			// Rate : ?? Mega bps
-			// ACK frame length = 14 bytes(112 bits)
-			if( pT01->T01_plcp_header_length ) //long preamble
+			/* The Tx rate of ACK use 24M */
+			Duration += (((112 + 22 + 95) / 96) * Tsym +
+					DEFAULT_SIFSTIME);
+		} else {
+			/* DSSS
+			 * 1 ACK + 1 SIFS
+			 * Rate : ?? Mega bps
+			 * ACK frame length = 14 bytes(112 bits)
+			 */
+			if (pT01->T01_plcp_header_length) /* long preamble */
 				Duration = LONG_PREAMBLE_PLUS_PLCPHEADER_TIME;
 			else
 				Duration = SHORT_PREAMBLE_PLUS_PLCPHEADER_TIME;
 
-			Duration += ( (112 + Rate-1)/Rate +	DEFAULT_SIFSTIME );
+			Duration += ((112 + Rate - 1) / Rate + DEFAULT_SIFSTIME);
 		}
 	}
 
-	((u16 *)buffer)[5] = cpu_to_le16(Duration);// 4 USHOR for skip 8B USB, 2USHORT=FC + Duration
+	((u16 *)buffer)[5] = cpu_to_le16(Duration);/* 4 USHOR for skip 8B USB,
+						    * 2USHORT=FC + Duration
+						    */
 	pT00->value = cpu_to_le32(pT00->value);
 	pT01->value = cpu_to_le32(pT01->value);
-	//--end 20061009 add
+	/* --end 20061009 add */
 
 }
 
-// The function return the 4n size of usb pk
-static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDes, u8 *TargetBuffer)
+/* The function return the 4n size of usb pk */
+static u16 Mds_BodyCopy(struct wbsoft_priv *adapter,
+			struct wb35_descriptor *pDes, u8 *TargetBuffer)
 {
 	PT00_DESCRIPTOR	pT00;
 	struct wb35_mds *pMds = &adapter->Mds;
-	u8	*buffer;
-	u8	*src_buffer;
-	u8	*pctmp;
-	u16	Size = 0;
-	u16	SizeLeft, CopySize, CopyLeft, stmp;
-	u8	buf_index, FragmentCount = 0;
+	u8		*buffer;
+	u8		*src_buffer;
+	u8		*pctmp;
+	u16		Size = 0;
+	u16		SizeLeft, CopySize, CopyLeft, stmp;
+	u8		buf_index, FragmentCount = 0;
 
 
-	// Copy fragment body
-	buffer = TargetBuffer; // shift 8B usb + 24B 802.11
+	/* Copy fragment body */
+	buffer = TargetBuffer; /* shift 8B usb + 24B 802.11 */
 	SizeLeft = pDes->buffer_total_size;
 	buf_index = pDes->buffer_start_index;
 
@@ -240,39 +244,40 @@ static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDe
 		CopySize = SizeLeft;
 		if (SizeLeft > pDes->FragmentThreshold) {
 			CopySize = pDes->FragmentThreshold;
-			pT00->T00_frame_length = 24 + CopySize;//Set USB length
-		} else
-			pT00->T00_frame_length = 24 + SizeLeft;//Set USB length
+			pT00->T00_frame_length = 24 + CopySize;/*Set USBlength*/
+		} else {
+			pT00->T00_frame_length = 24 + SizeLeft;/*Set USBlength*/
+		}
 
 		SizeLeft -= CopySize;
 
-		// 1 Byte operation
-		pctmp = (u8 *)( buffer + 8 + DOT_11_SEQUENCE_OFFSET );
+		/* 1 Byte operation */
+		pctmp = (u8 *)(buffer + 8 + DOT_11_SEQUENCE_OFFSET);
 		*pctmp &= 0xf0;
-		*pctmp |= FragmentCount;//931130.5.m
-		if( !FragmentCount )
+		*pctmp |= FragmentCount;/* 931130.5.m */
+		if (!FragmentCount)
 			pT00->T00_first_mpdu = 1;
 
-		buffer += 32; // 8B usb + 24B 802.11 header
+		buffer += 32; /* 8B usb + 24B 802.11 header */
 		Size += 32;
 
-		// Copy into buffer
+		/* Copy into buffer */
 		stmp = CopySize + 3;
-		stmp &= ~0x03;//4n Alignment
-		Size += stmp;// Current 4n offset of mpdu
+		stmp &= ~0x03;	/* 4n Alignment */
+		Size += stmp;	/* Current 4n offset of mpdu */
 
 		while (CopySize) {
-			// Copy body
+			/* Copy body */
 			src_buffer = pDes->buffer_address[buf_index];
 			CopyLeft = CopySize;
 			if (CopySize >= pDes->buffer_size[buf_index]) {
 				CopyLeft = pDes->buffer_size[buf_index];
 
-				// Get the next buffer of descriptor
+				/* Get the next buffer of descriptor */
 				buf_index++;
 				buf_index %= MAX_DESCRIPTOR_BUFFER_INDEX;
 			} else {
-				u8	*pctmp = pDes->buffer_address[buf_index];
+				u8    *pctmp = pDes->buffer_address[buf_index];
 				pctmp += CopySize;
 				pDes->buffer_address[buf_index] = pctmp;
 				pDes->buffer_size[buf_index] -= CopySize;
@@ -283,26 +288,32 @@ static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDe
 			CopySize -= CopyLeft;
 		}
 
-		// 931130.5.n
+		/* 931130.5.n */
 		if (pMds->MicAdd) {
 			if (!SizeLeft) {
-				pMds->MicWriteAddress[ pMds->MicWriteIndex ] = buffer - pMds->MicAdd;
-				pMds->MicWriteSize[ pMds->MicWriteIndex ] = pMds->MicAdd;
+				pMds->MicWriteAddress[pMds->MicWriteIndex] =
+							buffer - pMds->MicAdd;
+				pMds->MicWriteSize[pMds->MicWriteIndex] =
+							pMds->MicAdd;
 				pMds->MicAdd = 0;
-			}
-			else if( SizeLeft < 8 ) //931130.5.p
-			{
+			} else if (SizeLeft < 8) { /* 931130.5.p */
 				pMds->MicAdd = SizeLeft;
-				pMds->MicWriteAddress[ pMds->MicWriteIndex ] = buffer - ( 8 - SizeLeft );
-				pMds->MicWriteSize[ pMds->MicWriteIndex ] = 8 - SizeLeft;
+				pMds->MicWriteAddress[pMds->MicWriteIndex] =
+							buffer - (8 - SizeLeft);
+				pMds->MicWriteSize[pMds->MicWriteIndex] =
+							8 - SizeLeft;
 				pMds->MicWriteIndex++;
 			}
 		}
 
-		// Does it need to generate the new header for next mpdu?
+		/* Does it need to generate the new header for next mpdu? */
 		if (SizeLeft) {
-			buffer = TargetBuffer + Size; // Get the next 4n start address
-			memcpy( buffer, TargetBuffer, 32 );//Copy 8B USB +24B 802.11
+			buffer = TargetBuffer + Size;	/* Get the next 4n
+							 * start address
+							 */
+			memcpy(buffer, TargetBuffer, 32);/* Copy 8B USB
+							  * +24B 802.11
+							  */
 			pT00 = (PT00_DESCRIPTOR)buffer;
 			pT00->T00_first_mpdu = 0;
 		}
@@ -312,62 +323,65 @@ static u16 Mds_BodyCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *pDe
 
 	pT00->T00_last_mpdu = 1;
 	pT00->T00_IsLastMpdu = 1;
-	buffer = (u8 *)pT00 + 8; // +8 for USB hdr
-	buffer[1] &= ~0x04; // Clear more frag bit of 802.11 frame control
-	pDes->FragmentCount = FragmentCount; // Update the correct fragment number
+	buffer = (u8 *)pT00 + 8; /* +8 for USB hdr */
+	buffer[1] &= ~0x04; /* Clear more frag bit of 802.11 frame control */
+	pDes->FragmentCount = FragmentCount; /* Update the correct
+					      *	fragment number
+					      */
 	return Size;
 }
 
-static void Mds_HeaderCopy(struct wbsoft_priv * adapter, struct wb35_descriptor *pDes, u8 *TargetBuffer)
+static void Mds_HeaderCopy(struct wbsoft_priv *adapter,
+				struct wb35_descriptor *pDes, u8 *TargetBuffer)
 {
 	struct wb35_mds *pMds = &adapter->Mds;
-	u8	*src_buffer = pDes->buffer_address[0];//931130.5.g
+	u8		*src_buffer = pDes->buffer_address[0];/* 931130.5.g */
 	PT00_DESCRIPTOR	pT00;
 	PT01_DESCRIPTOR	pT01;
-	u16	stmp;
-	u8	i, ctmp1, ctmp2, ctmpf;
-	u16	FragmentThreshold = CURRENT_FRAGMENT_THRESHOLD;
+	u16		stmp;
+	u8		i, ctmp1, ctmp2, ctmpf;
+	u16		FragmentThreshold = CURRENT_FRAGMENT_THRESHOLD;
 
 
 	stmp = pDes->buffer_total_size;
-	//
-	// Set USB header 8 byte
-	//
+	/*
+	 * Set USB header 8 byte
+	 */
 	pT00 = (PT00_DESCRIPTOR)TargetBuffer;
 	TargetBuffer += 4;
 	pT01 = (PT01_DESCRIPTOR)TargetBuffer;
 	TargetBuffer += 4;
 
-	pT00->value = 0;// Clear
-	pT01->value = 0;// Clear
+	pT00->value = 0;/* Clear */
+	pT01->value = 0;/* Clear */
 
-	pT00->T00_tx_packet_id = pDes->Descriptor_ID;// Set packet ID
-	pT00->T00_header_length = 24;// Set header length
-	pT01->T01_retry_abort_ebable = 1;//921013 931130.5.h
+	pT00->T00_tx_packet_id = pDes->Descriptor_ID;/* Set packet ID */
+	pT00->T00_header_length = 24;/* Set header length */
+	pT01->T01_retry_abort_ebable = 1;/* 921013 931130.5.h */
 
-	// Key ID setup
+	/* Key ID setup */
 	pT01->T01_wep_id = 0;
 
-	FragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;	//Do not fragment
-	// Copy full data, the 1'st buffer contain all the data 931130.5.j
-	memcpy( TargetBuffer, src_buffer, DOT_11_MAC_HEADER_SIZE );// Copy header
+	FragmentThreshold = DEFAULT_FRAGMENT_THRESHOLD;	/* Do not fragment */
+	/* Copy full data, the 1'st buffer contain all the data 931130.5.j */
+	memcpy(TargetBuffer, src_buffer, DOT_11_MAC_HEADER_SIZE);/*Copy header*/
 	pDes->buffer_address[0] = src_buffer + DOT_11_MAC_HEADER_SIZE;
 	pDes->buffer_total_size -= DOT_11_MAC_HEADER_SIZE;
 	pDes->buffer_size[0] = pDes->buffer_total_size;
 
-	// Set fragment threshold
+	/* Set fragment threshold */
 	FragmentThreshold -= (DOT_11_MAC_HEADER_SIZE + 4);
 	pDes->FragmentThreshold = FragmentThreshold;
 
-	// Set more frag bit
-	TargetBuffer[1] |= 0x04;// Set more frag bit
+	/* Set more frag bit */
+	TargetBuffer[1] |= 0x04;/* Set more frag bit*/
 
-	//
-	// Set tx rate
-	//
-	stmp = *(u16 *)(TargetBuffer+30); // 2n alignment address
+	/*
+	 * Set tx rate
+	 */
+	stmp = *(u16 *)(TargetBuffer+30); /* 2n alignment address */
 
-	//Use basic rate
+	/* Use basic rate */
 	ctmp1 = ctmpf = CURRENT_TX_RATE_FOR_MNG;
 
 	pDes->TxRate = ctmp1;
@@ -377,53 +391,67 @@ static void Mds_HeaderCopy(struct wbsoft_priv * adapter, struct wb35_descriptor
 
 	pT01->T01_modulation_type = (ctmp1%3) ? 0 : 1;
 
-	for( i=0; i<2; i++ ) {
-		if( i == 1 )
+	for (i = 0; i < 2; i++) {
+		if (i == 1)
 			ctmp1 = ctmpf;
 
-		pMds->TxRate[pDes->Descriptor_ID][i] = ctmp1; // backup the ta rate and fall back rate
-
-		if( ctmp1 == 108) ctmp2 = 7;
-		else if( ctmp1 == 96 ) ctmp2 = 6; // Rate convert for USB
-		else if( ctmp1 == 72 ) ctmp2 = 5;
-		else if( ctmp1 == 48 ) ctmp2 = 4;
-		else if( ctmp1 == 36 ) ctmp2 = 3;
-		else if( ctmp1 == 24 ) ctmp2 = 2;
-		else if( ctmp1 == 18 ) ctmp2 = 1;
-		else if( ctmp1 == 12 ) ctmp2 = 0;
-		else if( ctmp1 == 22 ) ctmp2 = 3;
-		else if( ctmp1 == 11 ) ctmp2 = 2;
-		else if( ctmp1 == 4  ) ctmp2 = 1;
-		else ctmp2 = 0; // if( ctmp1 == 2  ) or default
-
-		if( i == 0 )
+		pMds->TxRate[pDes->Descriptor_ID][i] = ctmp1; /* backup the ta
+							       * rate and fall
+							       * back rate
+							       */
+
+		if (ctmp1 == 108)
+			ctmp2 = 7;
+		else if (ctmp1 == 96)
+			ctmp2 = 6;	/* Rate convert for USB */
+		else if (ctmp1 == 72)
+			ctmp2 = 5;
+		else if (ctmp1 == 48)
+			ctmp2 = 4;
+		else if (ctmp1 == 36)
+			ctmp2 = 3;
+		else if (ctmp1 == 24)
+			ctmp2 = 2;
+		else if (ctmp1 == 18)
+			ctmp2 = 1;
+		else if (ctmp1 == 12)
+			ctmp2 = 0;
+		else if (ctmp1 == 22)
+			ctmp2 = 3;
+		else if (ctmp1 == 11)
+			ctmp2 = 2;
+		else if (ctmp1 == 4)
+			ctmp2 = 1;
+		else
+			ctmp2 = 0;	/* if (ctmp1 == 2) or default */
+
+		if (i == 0)
 			pT01->T01_transmit_rate = ctmp2;
 		else
 			pT01->T01_fall_back_rate = ctmp2;
 	}
 
-	//
-	// Set preamble type
-	//
-	if ((pT01->T01_modulation_type == 0) && (pT01->T01_transmit_rate == 0))	// RATE_1M
-		pDes->PreambleMode =  WLAN_PREAMBLE_TYPE_LONG;
+	/*
+	 * Set preamble type
+	 */
+	if ((pT01->T01_modulation_type == 0) && (pT01->T01_transmit_rate == 0))
+		/* RATE_1M */
+		pDes->PreambleMode = WLAN_PREAMBLE_TYPE_LONG;
 	else
-		pDes->PreambleMode =  CURRENT_PREAMBLE_MODE;
-	pT01->T01_plcp_header_length = pDes->PreambleMode;	// Set preamble
-
+		pDes->PreambleMode = CURRENT_PREAMBLE_MODE;
+	pT01->T01_plcp_header_length = pDes->PreambleMode;/* Set preamble */
 }
 
-void
-Mds_Tx(struct wbsoft_priv * adapter)
+void Mds_Tx(struct wbsoft_priv *adapter)
 {
-	struct hw_data *	pHwData = &adapter->sHwData;
-	struct wb35_mds *pMds = &adapter->Mds;
+	struct hw_data		*pHwData = &adapter->sHwData;
+	struct wb35_mds		*pMds = &adapter->Mds;
 	struct wb35_descriptor	TxDes;
-	struct wb35_descriptor *pTxDes = &TxDes;
-	u8		*XmitBufAddress;
-	u16		XmitBufSize, PacketSize, stmp, CurrentSize, FragmentThreshold;
-	u8		FillIndex, TxDesIndex, FragmentCount, FillCount;
-	unsigned char	BufferFilled = false;
+	struct wb35_descriptor	*pTxDes = &TxDes;
+	u8	*XmitBufAddress;
+	u16	XmitBufSize, PacketSize, stmp, CurrentSize, FragmentThreshold;
+	u8	FillIndex, TxDesIndex, FragmentCount, FillCount;
+	unsigned char		BufferFilled = false;
 
 
 	if (pMds->TxPause)
@@ -431,21 +459,24 @@ Mds_Tx(struct wbsoft_priv * adapter)
 	if (!hal_driver_init_OK(pHwData))
 		return;
 
-	//Only one thread can be run here
+	/* Only one thread can be run here */
 	if (atomic_inc_return(&pMds->TxThreadCount) != 1)
 		goto cleanup;
 
-	// Start to fill the data
+	/* Start to fill the data */
 	do {
 		FillIndex = pMds->TxFillIndex;
-		if (pMds->TxOwner[FillIndex]) { // Is owned by software 0:Yes 1:No
-#ifdef _PE_TX_DUMP_
+		if (pMds->TxOwner[FillIndex]) { /* Is owned by
+						 * software 0:Yes 1:No
+						 */
+		#ifdef _PE_TX_DUMP_
 			printk("[Mds_Tx] Tx Owner is H/W.\n");
-#endif
+		#endif
 			break;
 		}
 
-		XmitBufAddress = pMds->pTxBuffer + (MAX_USB_TX_BUFFER * FillIndex); //Get buffer
+		XmitBufAddress = pMds->pTxBuffer +
+				(MAX_USB_TX_BUFFER * FillIndex); /*Get buffer*/
 		XmitBufSize = 0;
 		FillCount = 0;
 		do {
@@ -453,79 +484,96 @@ Mds_Tx(struct wbsoft_priv * adapter)
 			if (!PacketSize)
 				break;
 
-			//For Check the buffer resource
+			/* For Check the buffer resource */
 			FragmentThreshold = CURRENT_FRAGMENT_THRESHOLD;
-			//931130.5.b
-			FragmentCount = PacketSize/FragmentThreshold + 1;
-			stmp = PacketSize + FragmentCount*32 + 8;//931130.5.c 8:MIC
+			/* 931130.5.b */
+			FragmentCount = PacketSize / FragmentThreshold + 1;
+			stmp = PacketSize +
+				FragmentCount * 32 + 8;/* 931130.5.c 8:MIC */
 			if ((XmitBufSize + stmp) >= MAX_USB_TX_BUFFER) {
 				printk("[Mds_Tx] Excess max tx buffer.\n");
-				break; // buffer is not enough
+				break; /* buffer is not enough */
 			}
 
-
-			//
-			// Start transmitting
-			//
+			/*
+			 * Start transmitting
+			 */
 			BufferFilled = true;
 
 			/* Leaves first u8 intact */
-			memset((u8 *)pTxDes + 1, 0, sizeof(struct wb35_descriptor) - 1);
+			memset((u8 *)pTxDes + 1, 0,
+					sizeof(struct wb35_descriptor) - 1);
 
-			TxDesIndex = pMds->TxDesIndex;//Get the current ID
+			TxDesIndex = pMds->TxDesIndex; /* Get the current ID */
 			pTxDes->Descriptor_ID = TxDesIndex;
-			pMds->TxDesFrom[ TxDesIndex ] = 2;//Storing the information of source comming from
+			pMds->TxDesFrom[TxDesIndex] = 2; /* Storing the
+							  * information of
+							  * source comming
+							  * from
+							  */
 			pMds->TxDesIndex++;
 			pMds->TxDesIndex %= MAX_USB_TX_DESCRIPTOR;
 
-			MLME_GetNextPacket( adapter, pTxDes );
+			MLME_GetNextPacket(adapter, pTxDes);
 
-			// Copy header. 8byte USB + 24byte 802.11Hdr. Set TxRate, Preamble type
-			Mds_HeaderCopy( adapter, pTxDes, XmitBufAddress );
+			/* Copy header. 8byte USB + 24byte 802.11Hdr.
+			 * Set TxRate, Preamble type
+			 */
+			Mds_HeaderCopy(adapter, pTxDes, XmitBufAddress);
 
-			// For speed up Key setting
+			/* For speed up Key setting */
 			if (pTxDes->EapFix) {
 #ifdef _PE_TX_DUMP_
-				printk("35: EPA 4th frame detected. Size = %d\n", PacketSize);
+				printk("35: EPA 4th frame detected. Size = %d\n"
+					, PacketSize);
 #endif
 				pHwData->IsKeyPreSet = 1;
 			}
 
-			// Copy (fragment) frame body, and set USB, 802.11 hdr flag
-			CurrentSize = Mds_BodyCopy(adapter, pTxDes, XmitBufAddress);
+			/* Copy (fragment) frame body,
+			 * and set USB, 802.11 hdr flag
+			 */
+			CurrentSize = Mds_BodyCopy(adapter,
+							pTxDes, XmitBufAddress);
 
-			// Set RTS/CTS and Normal duration field into buffer
+			/* Set RTS/CTS and Normal duration field into buffer */
 			Mds_DurationSet(adapter, pTxDes, XmitBufAddress);
 
-			//Shift to the next address
+			/* Shift to the next address */
 			XmitBufSize += CurrentSize;
 			XmitBufAddress += CurrentSize;
 
 #ifdef _IBSS_BEACON_SEQ_STICK_
-			if ((XmitBufAddress[ DOT_11_DA_OFFSET+8 ] & 0xfc) != MAC_SUBTYPE_MNGMNT_PROBE_REQUEST) // +8 for USB hdr
+	if ((XmitBufAddress[DOT_11_DA_OFFSET+8] & 0xfc) !=
+			MAC_SUBTYPE_MNGMNT_PROBE_REQUEST) /* +8 for USB hdr */
 #endif
 				pMds->TxToggle = true;
 
-			// Get packet to transmit completed, 1:TESTSTA 2:MLME 3: Ndis data
+			/* Get packet to transmit completed,
+			 * 1:TESTSTA 2:MLME 3: Ndis data
+			 */
 			MLME_SendComplete(adapter, 0, true);
 
-			// Software TSC count 20060214
+			/* Software TSC count 20060214 */
 			pMds->TxTsc++;
 			if (pMds->TxTsc == 0)
 				pMds->TxTsc_2++;
 
-			FillCount++; // 20060928
-		} while (HAL_USB_MODE_BURST(pHwData)); // End of multiple MSDU copy loop. false = single true = multiple sending
+			FillCount++; /* 20060928 */
+		/* End of multiple MSDU copy loop. false = single sending
+		 *				   true = multiple sending
+		 */
+		} while (HAL_USB_MODE_BURST(pHwData));
 
-		// Move to the next one, if necessary
+		/* Move to the next one, if necessary */
 		if (BufferFilled) {
-			// size setting
-			pMds->TxBufferSize[ FillIndex ] = XmitBufSize;
+			/* size setting */
+			pMds->TxBufferSize[FillIndex] = XmitBufSize;
 
-			// 20060928 set Tx count
+			/* 20060928 set Tx count */
 			pMds->TxCountInBuffer[FillIndex] = FillCount;
 
-			// Set owner flag
+			/* Set owner flag */
 			pMds->TxOwner[FillIndex] = 1;
 
 			pMds->TxFillIndex++;
@@ -534,14 +582,14 @@ Mds_Tx(struct wbsoft_priv * adapter)
 		} else
 			break;
 
-		if (!PacketSize) // No more pk for transmitting
+		if (!PacketSize) /* No more pk for transmitting */
 			break;
 
-	} while(true);
+	} while (true);
 
-	//
-	// Start to send by lower module
-	//
+	/*
+	 * Start to send by lower module
+	 */
 	if (!pHwData->IsKeyPreSet)
 		Wb35Tx_start(adapter);
 
@@ -549,41 +597,43 @@ Mds_Tx(struct wbsoft_priv * adapter)
 	atomic_dec(&pMds->TxThreadCount);
 }
 
-void
-Mds_SendComplete(struct wbsoft_priv * adapter, PT02_DESCRIPTOR pT02)
+void Mds_SendComplete(struct wbsoft_priv *adapter, PT02_DESCRIPTOR pT02)
 {
-	struct wb35_mds *pMds = &adapter->Mds;
-	struct hw_data *	pHwData = &adapter->sHwData;
-	u8	PacketId = (u8)pT02->T02_Tx_PktID;
+	struct wb35_mds	*pMds = &adapter->Mds;
+	struct hw_data	*pHwData = &adapter->sHwData;
+	u8		PacketId = (u8)pT02->T02_Tx_PktID;
 	unsigned char	SendOK = true;
-	u8	RetryCount, TxRate;
+	u8		RetryCount, TxRate;
 
-	if (pT02->T02_IgnoreResult) // Don't care the result
+	if (pT02->T02_IgnoreResult) /* Don't care the result */
 		return;
 	if (pT02->T02_IsLastMpdu) {
-		//TODO: DTO -- get the retry count and fragment count
-		// Tx rate
-		TxRate = pMds->TxRate[ PacketId ][ 0 ];
+		/* TODO: DTO - get the retry count and fragment count Tx rate */
+		TxRate = pMds->TxRate[PacketId][0];
 		RetryCount = (u8)pT02->T02_MPDU_Cnt;
 		if (pT02->value & FLAG_ERROR_TX_MASK) {
 			SendOK = false;
 
-			if (pT02->T02_transmit_abort || pT02->T02_out_of_MaxTxMSDULiftTime) {
-				//retry error
+			if (pT02->T02_transmit_abort ||
+				pT02->T02_out_of_MaxTxMSDULiftTime) {
+				/* retry error */
 				pHwData->dto_tx_retry_count += (RetryCount+1);
-				//[for tx debug]
-				if (RetryCount<7)
-					pHwData->tx_retry_count[RetryCount] += RetryCount;
+				/* [for tx debug] */
+				if (RetryCount < 7)
+					pHwData->tx_retry_count[RetryCount] +=
+								RetryCount;
 				else
-					pHwData->tx_retry_count[7] += RetryCount;
+					pHwData->tx_retry_count[7] +=
+								RetryCount;
 				#ifdef _PE_STATE_DUMP_
-				printk("dto_tx_retry_count =%d\n", pHwData->dto_tx_retry_count);
+				printk("dto_tx_retry_count =%d\n",
+						pHwData->dto_tx_retry_count);
 				#endif
 				MTO_SetTxCount(adapter, TxRate, RetryCount);
 			}
 			pHwData->dto_tx_frag_count += (RetryCount+1);
 
-			//[for tx debug]
+			/* [for tx debug] */
 			if (pT02->T02_transmit_abort_due_to_TBTT)
 				pHwData->tx_TBTT_start_count++;
 			if (pT02->T02_transmit_without_encryption_due_to_wep_on_false)
@@ -596,8 +646,8 @@ Mds_SendComplete(struct wbsoft_priv * adapter, PT02_DESCRIPTOR pT02)
 			MTO_SetTxCount(adapter, TxRate, RetryCount);
 		}
 
-		// Clear send result buffer
-		pMds->TxResult[ PacketId ] = 0;
+		/* Clear send result buffer */
+		pMds->TxResult[PacketId] = 0;
 	} else
-		pMds->TxResult[ PacketId ] |= ((u16)(pT02->value & 0x0ffff));
+		pMds->TxResult[PacketId] |= ((u16)(pT02->value & 0x0ffff));
 }
-- 
1.7.0.2

