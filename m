Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935456Ab1IOX3H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:29:07 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:62768 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935365Ab1IOX3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:29:04 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 03/13] staging: wlags49_h2: Fix macro termination
Date: Fri, 16 Sep 2011 00:20:47 +0100
Message-Id: <1316128857-9781-4-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
References: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Semi-colon terminate various macros (HCFASSERT, IF_PROT_TIME, IF_DMA,
PROT_CNT_INI, HCFLOGENTRY, HCFLOGEXIT, DAWA_ACK, DAWA_ZERO_FID) so
auto-indent will work correctly. Add appropriate do {} while
protection to the macros.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/hcf.c    |  350 +++++++++++++++++-----------------
 drivers/staging/wlags49_h2/hcfdef.h |   93 +++++-----
 2 files changed, 220 insertions(+), 223 deletions(-)

diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index a73317e..85950d7 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -703,19 +703,19 @@ hcf_action( IFBP ifbp, hcf_16 action )
 {
 int	rc = HCF_SUCCESS;
 
-	HCFASSERT( ifbp->IFB_Magic == HCF_MAGIC, ifbp->IFB_Magic )
+	HCFASSERT( ifbp->IFB_Magic == HCF_MAGIC, ifbp->IFB_Magic );
 #if HCF_INT_ON
-	HCFLOGENTRY( action == HCF_ACT_INT_FORCE_ON ? HCF_TRACE_ACTION_KLUDGE : HCF_TRACE_ACTION, action )														/* 0 */
+	HCFLOGENTRY( action == HCF_ACT_INT_FORCE_ON ? HCF_TRACE_ACTION_KLUDGE : HCF_TRACE_ACTION, action );														/* 0 */
 #if (HCF_SLEEP)
 	HCFASSERT( ifbp->IFB_IntOffCnt != 0xFFFE || action == HCF_ACT_INT_OFF,
-			   MERGE_2( action, ifbp->IFB_IntOffCnt ) )
+			   MERGE_2( action, ifbp->IFB_IntOffCnt ) );
 #else
-	HCFASSERT( ifbp->IFB_IntOffCnt != 0xFFFE, action )
+	HCFASSERT( ifbp->IFB_IntOffCnt != 0xFFFE, action );
 #endif // HCF_SLEEP
 	HCFASSERT( ifbp->IFB_IntOffCnt != 0xFFFF ||
-			   action == HCF_ACT_INT_OFF || action == HCF_ACT_INT_FORCE_ON,  action )
+			   action == HCF_ACT_INT_OFF || action == HCF_ACT_INT_FORCE_ON,  action );
 	HCFASSERT( ifbp->IFB_IntOffCnt <= 16 || ifbp->IFB_IntOffCnt >= 0xFFFE,
-			   MERGE_2( action, ifbp->IFB_IntOffCnt ) )	//nesting more than 16 deep seems unreasonable
+			   MERGE_2( action, ifbp->IFB_IntOffCnt ) );	//nesting more than 16 deep seems unreasonable
 #endif // HCF_INT_ON
 
 	switch (action) {
@@ -789,7 +789,7 @@ hcf_16	i;
 		cmd_exe( ifbp, HCMD_SLEEP, 0 );
 		break;
 // 	  case HCF_ACT_WAKEUP:						// DDS Wakeup request
-// 		HCFASSERT( ifbp->IFB_IntOffCnt == 0xFFFE, ifbp->IFB_IntOffCnt )
+// 		HCFASSERT( ifbp->IFB_IntOffCnt == 0xFFFE, ifbp->IFB_IntOffCnt );
 // 		ifbp->IFB_IntOffCnt++;					// restore conventional I/F
 // 		OPW( HREG_IO, HREG_IO_WAKEUP_ASYNC );
 // 		MSF_WAIT(800);							// MSF-defined function to wait n microseconds.
@@ -828,11 +828,11 @@ hcf_16	i;
 		break;
 
 	  default:
-		HCFASSERT( DO_ASSERT, action )
+		HCFASSERT( DO_ASSERT, action );
 		break;
 	}
 	//! do not HCFASSERT( rc == HCF_SUCCESS, rc )														/* 30*/
-	HCFLOGEXIT( HCF_TRACE_ACTION )
+	HCFLOGEXIT( HCF_TRACE_ACTION );
 	return rc;
 } // hcf_action
 #endif // HCF_DL_ONLY
@@ -959,13 +959,13 @@ int	rc = HCF_ERR_INCOMP_FW;
 		x &= ~HFS_TX_CNTL_PORT;
 	}
 	HCFASSERT( x==HCF_CNTL_ENABLE  || x==HCF_CNTL_DISABLE    || HCF_CNTL_CONTINUE ||
-			   x==HCF_CNTL_CONNECT || x==HCF_CNTL_DISCONNECT, cmd )
+			   x==HCF_CNTL_CONNECT || x==HCF_CNTL_DISCONNECT, cmd );
 }
 #endif // HCF_ASSERT
 // #if (HCF_SLEEP) & HCF_DDS
-// 	HCFASSERT( ifbp->IFB_IntOffCnt != 0xFFFE, cmd )
+// 	HCFASSERT( ifbp->IFB_IntOffCnt != 0xFFFE, cmd );
 // #endif // HCF_DDS
-	HCFLOGENTRY( HCF_TRACE_CNTL, cmd )
+	HCFLOGENTRY( HCF_TRACE_CNTL, cmd );
 	if ( ifbp->IFB_CardStat == 0 ) {																 /*2*/
 /*6*/	rc = cmd_exe( ifbp, cmd, 0 );
 #if (HCF_SLEEP) & HCF_DDS
@@ -989,12 +989,12 @@ int	rc = HCF_ERR_INCOMP_FW;
 			 * as additional beneficiary side effect, the SOP and EOP bits will also be cleared
 			 */
 			ifbp->IFB_CntlOpt |= DMA_ENABLED;
-			HCFASSERT( NT_ASSERT, NEVER_TESTED )
+			HCFASSERT( NT_ASSERT, NEVER_TESTED );
 			// make the entire rx descriptor chain DMA-owned, so the DMA engine can (re-)use it.
 			p = ifbp->IFB_FirstDesc[DMA_RX];
 			if (p != NULL) {   //;? Think this over again in the light of the new chaining strategy
 				if ( 1 ) 	{ //begin alternative
-					HCFASSERT( NT_ASSERT, NEVER_TESTED )
+					HCFASSERT( NT_ASSERT, NEVER_TESTED );
 					put_frame_lst( ifbp, ifbp->IFB_FirstDesc[DMA_RX], DMA_RX );
 					if ( ifbp->IFB_FirstDesc[DMA_RX] ) {
 						put_frame_lst( ifbp, ifbp->IFB_FirstDesc[DMA_RX]->next_desc_addr, DMA_RX );
@@ -1013,8 +1013,8 @@ int	rc = HCF_ERR_INCOMP_FW;
 		}
 	}
 #endif // HCF_DMA
-	HCFASSERT( rc == HCF_SUCCESS, rc )
-	HCFLOGEXIT( HCF_TRACE_CNTL )
+	HCFASSERT( rc == HCF_SUCCESS, rc );
+	HCFLOGEXIT( HCF_TRACE_CNTL );
 	return rc;
 } // hcf_cntl
 
@@ -1217,19 +1217,19 @@ LTV_STRCT	x;
 	ifbp->IFB_AssertStrct.frag_buf[0].frag_addr = &ifbp->IFB_AssertLine;
 #endif // HCF_ASSERT_MB
 #endif // HCF_ASSERT
-	IF_PROT_TIME( prot_cnt = ifbp->IFB_TickIni = INI_TICK_INI; )
+	IF_PROT_TIME( prot_cnt = ifbp->IFB_TickIni = INI_TICK_INI );
 #if ( (HCF_TYPE) & HCF_TYPE_PRELOADED ) == 0
 	//!! No asserts before Reset-bit in HREG_IO is cleared
 	OPW( HREG_IO, 0x0000 );						//OPW useable										/* 2b*/
 	HCF_WAIT_WHILE( (IPW( HREG_EV_STAT) & HREG_EV_CMD) == 0 );
-	IF_PROT_TIME( HCFASSERT( prot_cnt, IPW( HREG_EV_STAT) ) )
-	IF_PROT_TIME( if ( prot_cnt ) prot_cnt = ifbp->IFB_TickIni; )
+	IF_PROT_TIME( HCFASSERT( prot_cnt, IPW( HREG_EV_STAT) ) );
+	IF_PROT_TIME( if ( prot_cnt ) prot_cnt = ifbp->IFB_TickIni );
 #endif // HCF_TYPE_PRELOADED
 	//!! No asserts before Reset-bit in HREG_IO is cleared
-	HCFASSERT( DO_ASSERT, MERGE_2( HCF_ASSERT, 0xCAF0 )	) //just to proof that the complete assert machinery is working
-	HCFASSERT( xa != CFG_FW_IDENTITY, 0 )		// assert if hcf_connect is called without intervening hcf_disconnect.
-	HCFASSERT( ((hcf_32)(void*)ifbp & (HCF_ALIGN-1) ) == 0, (hcf_32)(void*)ifbp )
-	HCFASSERT( (io_addr & 0x003F) == 0, io_addr )
+	HCFASSERT( DO_ASSERT, MERGE_2( HCF_ASSERT, 0xCAF0 )	); //just to proof that the complete assert machinery is working
+	HCFASSERT( xa != CFG_FW_IDENTITY, 0 );		// assert if hcf_connect is called without intervening hcf_disconnect.
+	HCFASSERT( ((hcf_32)(void*)ifbp & (HCF_ALIGN-1) ) == 0, (hcf_32)(void*)ifbp );
+	HCFASSERT( (io_addr & 0x003F) == 0, io_addr );
 												//if Busy bit in Cmd register
 	if (IPW( HREG_CMD ) & HCMD_BUSY ) {																/* 8 */
 												//.  Ack all to unblock a (possibly) blocked cmd pipe line
@@ -1237,7 +1237,7 @@ LTV_STRCT	x;
 												//.  Wait for Busy bit drop  in Cmd register
 												//.  Wait for Cmd  bit raise in Ev  register
 		HCF_WAIT_WHILE( ( IPW( HREG_CMD ) & HCMD_BUSY ) && (IPW( HREG_EV_STAT) & HREG_EV_CMD) == 0 );
-		IF_PROT_TIME( HCFASSERT( prot_cnt, IPW( HREG_EV_STAT) ) ) /* if prot_cnt == 0, cmd_exe will fail, causing DEFUNCT */
+		IF_PROT_TIME( HCFASSERT( prot_cnt, IPW( HREG_EV_STAT) ) ); /* if prot_cnt == 0, cmd_exe will fail, causing DEFUNCT */
 	}
 	OPW( HREG_EV_ACK, ~HREG_EV_SLEEP_REQ );
 #if ( (HCF_TYPE) & HCF_TYPE_PRELOADED ) == 0														/*12*/
@@ -1307,7 +1307,7 @@ get_frame_lst( IFBP ifbp, int tx_rx_flag )
 DESC_STRCT *head = ifbp->IFB_FirstDesc[tx_rx_flag];
 DESC_STRCT *copy, *p, *prev;
 
-	HCFASSERT( tx_rx_flag == DMA_RX || tx_rx_flag == DMA_TX, tx_rx_flag )
+	HCFASSERT( tx_rx_flag == DMA_RX || tx_rx_flag == DMA_TX, tx_rx_flag );
 								//if FrameList
 	if ( head ) {
 								//.  search for last descriptor of first FrameList
@@ -1407,27 +1407,27 @@ put_frame_lst( IFBP ifbp, DESC_STRCT *descp, int tx_rx_flag )
 	DESC_STRCT	*p = descp;
 	hcf_16 port;
 
-	HCFASSERT( ifbp->IFB_CntlOpt & USE_DMA, ifbp->IFB_CntlOpt) //only hcf_dma_tx_put must also be DMA_ENABLED
-	HCFASSERT( tx_rx_flag == DMA_RX || tx_rx_flag == DMA_TX, tx_rx_flag )
-	HCFASSERT( p , 0 )
+	HCFASSERT( ifbp->IFB_CntlOpt & USE_DMA, ifbp->IFB_CntlOpt); //only hcf_dma_tx_put must also be DMA_ENABLED
+	HCFASSERT( tx_rx_flag == DMA_RX || tx_rx_flag == DMA_TX, tx_rx_flag );
+	HCFASSERT( p , 0 );
 
 	while ( p ) {
-		HCFASSERT( ((hcf_32)p & 3 ) == 0, (hcf_32)p )
-		HCFASSERT( (p->BUF_CNT & ~DESC_CNT_MASK) == 0, p->BUF_CNT )
-		HCFASSERT( (p->BUF_SIZE & ~DESC_CNT_MASK) == 0, p->BUF_SIZE )
+		HCFASSERT( ((hcf_32)p & 3 ) == 0, (hcf_32)p );
+		HCFASSERT( (p->BUF_CNT & ~DESC_CNT_MASK) == 0, p->BUF_CNT );
+		HCFASSERT( (p->BUF_SIZE & ~DESC_CNT_MASK) == 0, p->BUF_SIZE );
 		p->BUF_SIZE &= DESC_CNT_MASK;					//!!this SHOULD be superfluous in case of correct MSF
 		p->BUF_CNT &= tx_rx_flag == DMA_RX ? 0 : DESC_CNT_MASK;	//!!this SHOULD be superfluous in case of correct MSF
 		p->BUF_CNT |= DESC_DMA_OWNED;
 		if ( p->next_desc_addr ) {
-//			HCFASSERT( p->buf_addr && p->buf_phys_addr  && p->BUF_SIZE && +/- p->BUF_SIZE, ... )
-			HCFASSERT( p->next_desc_addr->desc_phys_addr, (hcf_32)p->next_desc_addr )
+//			HCFASSERT( p->buf_addr && p->buf_phys_addr  && p->BUF_SIZE && +/- p->BUF_SIZE, ... );
+			HCFASSERT( p->next_desc_addr->desc_phys_addr, (hcf_32)p->next_desc_addr );
 			p->next_desc_phys_addr = p->next_desc_addr->desc_phys_addr;
 		} else {									//
 			p->next_desc_phys_addr = 0;
 			if ( p->buf_addr == NULL ) {			// DELWA Descriptor
-				HCFASSERT( descp == p, (hcf_32)descp )	//singleton DescriptorList
-				HCFASSERT( ifbp->IFB_FirstDesc[tx_rx_flag] == NULL, (hcf_32)ifbp->IFB_FirstDesc[tx_rx_flag])
-				HCFASSERT( ifbp->IFB_LastDesc[tx_rx_flag] == NULL, (hcf_32)ifbp->IFB_LastDesc[tx_rx_flag])
+				HCFASSERT( descp == p, (hcf_32)descp );	//singleton DescriptorList
+				HCFASSERT( ifbp->IFB_FirstDesc[tx_rx_flag] == NULL, (hcf_32)ifbp->IFB_FirstDesc[tx_rx_flag]);
+				HCFASSERT( ifbp->IFB_LastDesc[tx_rx_flag] == NULL, (hcf_32)ifbp->IFB_LastDesc[tx_rx_flag]);
 				descp->BUF_CNT = 0; //&= ~DESC_DMA_OWNED;
 				ifbp->IFB_FirstDesc[tx_rx_flag] = descp;
 // part of alternative ifbp->IFB_LastDesc[tx_rx_flag] = ifbp->IFB_FirstDesc[tx_rx_flag] = descp;
@@ -1436,10 +1436,10 @@ put_frame_lst( IFBP ifbp, DESC_STRCT *descp, int tx_rx_flag )
 													// .  prepare for activation DMA controller
 // part of alternative descp = descp->next_desc_addr;
 			} else {								//a "real" FrameList, hand it over to the DMA engine
-				HCFASSERT( ifbp->IFB_FirstDesc[tx_rx_flag], (hcf_32)descp )
-				HCFASSERT( ifbp->IFB_LastDesc[tx_rx_flag], (hcf_32)descp )
+				HCFASSERT( ifbp->IFB_FirstDesc[tx_rx_flag], (hcf_32)descp );
+				HCFASSERT( ifbp->IFB_LastDesc[tx_rx_flag], (hcf_32)descp );
 				HCFASSERT( ifbp->IFB_LastDesc[tx_rx_flag]->next_desc_addr == NULL,
-						   (hcf_32)ifbp->IFB_LastDesc[tx_rx_flag]->next_desc_addr)
+						   (hcf_32)ifbp->IFB_LastDesc[tx_rx_flag]->next_desc_addr);
 //				p->buf_cntl.cntl_stat |= DESC_DMA_OWNED;
 				ifbp->IFB_LastDesc[tx_rx_flag]->next_desc_addr = descp;
 				ifbp->IFB_LastDesc[tx_rx_flag]->next_desc_phys_addr = descp->desc_phys_addr;
@@ -1522,16 +1522,16 @@ DESC_STRCT *descp;	// pointer to start of FrameList
     {
 int i;
 DESC_STRCT *p = descp->next_desc_addr;	//pointer to 2nd descriptor of frame
-		HCFASSERT(p, 0)
+		HCFASSERT(p, 0);
 		// The 2nd descriptor contains (maybe) a SNAP header plus part or whole of the payload.
 		//determine decapsulation sub-flag in RxFS
 		i = *(wci_recordp)&descp->buf_addr[HFS_STAT] & ( HFS_STAT_MSG_TYPE | HFS_STAT_ERR );
 		if ( i == HFS_STAT_TUNNEL ||
 			 ( i == HFS_STAT_1042 && hcf_encap( (wci_bufp)&p->buf_addr[HCF_DASA_SIZE] ) != ENC_TUNNEL )) {
 			// The 2nd descriptor contains a SNAP header plus part or whole of the payload.
-			HCFASSERT( p->BUF_CNT == (p->buf_addr[5] + (p->buf_addr[4]<<8) + 2*6 + 2 - 8), p->BUF_CNT )
+			HCFASSERT( p->BUF_CNT == (p->buf_addr[5] + (p->buf_addr[4]<<8) + 2*6 + 2 - 8), p->BUF_CNT );
 			// perform decapsulation
-			HCFASSERT(p->BUF_SIZE >=8, p->BUF_SIZE)
+			HCFASSERT(p->BUF_SIZE >=8, p->BUF_SIZE);
 			// move SA[2:5] in the second buffer to replace part of the SNAP header
 			for ( i=3; i >= 0; i--) p->buf_addr[i+8] = p->buf_addr[i];
 			// copy DA[0:5], SA[0:1] from first buffer to second buffer
@@ -1542,7 +1542,7 @@ DESC_STRCT *p = descp->next_desc_addr;	//pointer to 2nd descriptor of frame
 	}
 #endif // HCF_ENC
 	if ( descp == NULL ) ifbp->IFB_DmaPackets &= (hcf_16)~HREG_EV_RDMAD;  //;?could be integrated into get_frame_lst
-	HCFLOGEXIT( HCF_TRACE_DMA_RX_GET )
+	HCFLOGEXIT( HCF_TRACE_DMA_RX_GET );
 	return descp;
 } // hcf_dma_rx_get
 
@@ -1596,20 +1596,20 @@ void
 hcf_dma_rx_put( IFBP ifbp, DESC_STRCT *descp )
 {
 
-	HCFLOGENTRY( HCF_TRACE_DMA_RX_PUT, 0xDA01 )
-	HCFASSERT( ifbp->IFB_Magic == HCF_MAGIC, ifbp->IFB_Magic )
-	HCFASSERT_INT
+	HCFLOGENTRY( HCF_TRACE_DMA_RX_PUT, 0xDA01 );
+	HCFASSERT( ifbp->IFB_Magic == HCF_MAGIC, ifbp->IFB_Magic );
+	HCFASSERT_INT;
 
 	put_frame_lst( ifbp, descp, DMA_RX );
 #if HCF_ASSERT && (HCF_ENCAP) == HCF_ENC
 	if ( descp->buf_addr ) {
-		HCFASSERT( descp->BUF_SIZE == HCF_DMA_RX_BUF1_SIZE, descp->BUF_SIZE )
-		HCFASSERT( descp->next_desc_addr, 0 ) // first descriptor should be followed by another descriptor
+		HCFASSERT( descp->BUF_SIZE == HCF_DMA_RX_BUF1_SIZE, descp->BUF_SIZE );
+		HCFASSERT( descp->next_desc_addr, 0 ); // first descriptor should be followed by another descriptor
 		// The second DB is for SNAP and payload purposes. It should be a minimum of 12 bytes in size.
-		HCFASSERT( descp->next_desc_addr->BUF_SIZE >= 12, descp->next_desc_addr->BUF_SIZE )
+		HCFASSERT( descp->next_desc_addr->BUF_SIZE >= 12, descp->next_desc_addr->BUF_SIZE );
 	}
 #endif // HCFASSERT / HCF_ENC
-	HCFLOGEXIT( HCF_TRACE_DMA_RX_PUT )
+	HCFLOGEXIT( HCF_TRACE_DMA_RX_PUT );
 } // hcf_dma_rx_put
 
 
@@ -1660,7 +1660,7 @@ DESC_STRCT *descp;	// pointer to start of FrameList
 	if ( descp == NULL ) {  //;?could be integrated into get_frame_lst
 		ifbp->IFB_DmaPackets &= (hcf_16)~HREG_EV_TDMAD;
 	}
-	HCFLOGEXIT( HCF_TRACE_DMA_TX_GET )
+	HCFLOGEXIT( HCF_TRACE_DMA_TX_GET );
 	return descp;
 } // hcf_dma_tx_get
 
@@ -1788,19 +1788,19 @@ int			i;
 
 #if HCF_ASSERT
 	int x = ifbp->IFB_FWIdentity.comp_id == COMP_ID_FW_AP ? tx_cntl & ~HFS_TX_CNTL_PORT : tx_cntl;
-	HCFASSERT( (x & ~HCF_TX_CNTL_MASK ) == 0, tx_cntl )
+	HCFASSERT( (x & ~HCF_TX_CNTL_MASK ) == 0, tx_cntl );
 #endif // HCF_ASSERT
-	HCFLOGENTRY( HCF_TRACE_DMA_TX_PUT, 0xDA03 )
-	HCFASSERT( ifbp->IFB_Magic == HCF_MAGIC, ifbp->IFB_Magic )
-	HCFASSERT_INT
-	HCFASSERT( ( ifbp->IFB_CntlOpt & (USE_DMA|DMA_ENABLED) ) == (USE_DMA|DMA_ENABLED), ifbp->IFB_CntlOpt)
+	HCFLOGENTRY( HCF_TRACE_DMA_TX_PUT, 0xDA03 );
+	HCFASSERT( ifbp->IFB_Magic == HCF_MAGIC, ifbp->IFB_Magic );
+	HCFASSERT_INT;
+	HCFASSERT( ( ifbp->IFB_CntlOpt & (USE_DMA|DMA_ENABLED) ) == (USE_DMA|DMA_ENABLED), ifbp->IFB_CntlOpt);
 
 	if ( descp->buf_addr ) {
 		*(hcf_16*)(descp->buf_addr + HFS_TX_CNTL) = tx_cntl;											/*1*/
 #if (HCF_ENCAP) == HCF_ENC
-		HCFASSERT( descp->next_desc_addr, 0 )									//at least 2 descripors
-		HCFASSERT( descp->BUF_CNT == HFS_ADDR_DEST, descp->BUF_CNT )	//exact length required for 1st buffer
-		HCFASSERT( descp->BUF_SIZE >= HCF_DMA_TX_BUF1_SIZE, descp->BUF_SIZE )	//minimal storage for encapsulation
+		HCFASSERT( descp->next_desc_addr, 0 );									//at least 2 descripors
+		HCFASSERT( descp->BUF_CNT == HFS_ADDR_DEST, descp->BUF_CNT );	//exact length required for 1st buffer
+		HCFASSERT( descp->BUF_SIZE >= HCF_DMA_TX_BUF1_SIZE, descp->BUF_SIZE );	//minimal storage for encapsulation
 		HCFASSERT( p->BUF_CNT >= 14, p->BUF_CNT );					//at least DA, SA and 'type' in 2nd buffer
 
 #if (HCF_TYPE) & HCF_TYPE_CCX
@@ -1850,7 +1850,7 @@ int			i;
 #endif // HCF_ENC
     }
 	put_frame_lst( ifbp, descp, DMA_TX );
-	HCFLOGEXIT( HCF_TRACE_DMA_TX_PUT )
+	HCFLOGEXIT( HCF_TRACE_DMA_TX_PUT );
 } // hcf_dma_tx_put
 
 #endif // HCF_DMA
@@ -2035,11 +2035,11 @@ hcf_16		*q = NULL;				/* source word pointer  Note!! DOS COM can't cope with FAR
 									 */
 int			i;
 
-	HCFLOGENTRY( HCF_TRACE_GET_INFO, ltvp->typ )
-	HCFASSERT( ifbp->IFB_Magic == HCF_MAGIC, ifbp->IFB_Magic )
-	HCFASSERT_INT
-	HCFASSERT( ltvp, 0 )
-	HCFASSERT( 1 < ltvp->len && ltvp->len <= HCF_MAX_LTV + 1, MERGE_2( ltvp->typ, ltvp->len ) )
+	HCFLOGENTRY( HCF_TRACE_GET_INFO, ltvp->typ );
+	HCFASSERT( ifbp->IFB_Magic == HCF_MAGIC, ifbp->IFB_Magic );
+	HCFASSERT_INT;
+	HCFASSERT( ltvp, 0 );
+	HCFASSERT( 1 < ltvp->len && ltvp->len <= HCF_MAX_LTV + 1, MERGE_2( ltvp->typ, ltvp->len ) );
 
 	ltvp->len = 0;								//default to: No Info Available
 #if defined MSF_COMPONENT_ID || (HCF_EXT) & HCF_EXT_MB //filter out all specials
@@ -2096,9 +2096,9 @@ wci_bufp	pt;					//pointer with the "right" type, just to help ease writing macr
 			}
 		} else if ( type == CFG_CMD_HCF ) {
 #define P ((CFG_CMD_HCF_STRCT FAR *)ltvp)
-			HCFASSERT( P->cmd == CFG_CMD_HCF_REG_ACCESS, P->cmd )		//only Hermes register access supported
+			HCFASSERT( P->cmd == CFG_CMD_HCF_REG_ACCESS, P->cmd );		//only Hermes register access supported
 			if ( P->cmd == CFG_CMD_HCF_REG_ACCESS ) {
-				HCFASSERT( P->mode < ifbp->IFB_IOBase, P->mode )		//Check Register space
+				HCFASSERT( P->mode < ifbp->IFB_IOBase, P->mode );		//Check Register space
 				ltvp->len = min( len, 4 );								//RESTORE ltv length
 				P->add_info = IPW( P->mode );
 			}
@@ -2117,7 +2117,7 @@ wci_bufp	pt;					//pointer with the "right" type, just to help ease writing macr
 				get_frag( ifbp, (wci_bufp)&ltvp->len, 2*len+2 BE_PAR(2) );
 				if ( IPW( HREG_STAT ) == 0xFFFF ) {					//NIC removal test
 					ltvp->len = 0;
-					HCFASSERT( DO_ASSERT, type )
+					HCFASSERT( DO_ASSERT, type );
 				}
 			}
 /*12*/	} else HCFASSERT( DO_ASSERT, type ) /*NOP*/; //NOP in case HCFASSERT is dummy
@@ -2129,8 +2129,8 @@ wci_bufp	pt;					//pointer with the "right" type, just to help ease writing macr
 		}
 	}
 	HCFASSERT( rc == HCF_SUCCESS || ( rc == HCF_ERR_LEN && ifbp->IFB_AssertTrace & 1<<HCF_TRACE_PUT_INFO ),
-			   MERGE_2( type, rc ) )																/*20*/
-	HCFLOGEXIT( HCF_TRACE_GET_INFO )
+			   MERGE_2( type, rc ) );																/*20*/
+	HCFLOGEXIT( HCF_TRACE_GET_INFO );
 	return rc;
 } // hcf_get_info
 
@@ -2210,11 +2210,11 @@ hcf_put_info( IFBP ifbp, LTVP ltvp )
 {
 int rc = HCF_SUCCESS;
 
-	HCFLOGENTRY( HCF_TRACE_PUT_INFO, ltvp->typ )
-	HCFASSERT( ifbp->IFB_Magic == HCF_MAGIC, ifbp->IFB_Magic )
-	HCFASSERT_INT
-	HCFASSERT( ltvp, 0 )
-	HCFASSERT( 1 < ltvp->len && ltvp->len <= HCF_MAX_LTV + 1, ltvp->len )
+	HCFLOGENTRY( HCF_TRACE_PUT_INFO, ltvp->typ );
+	HCFASSERT( ifbp->IFB_Magic == HCF_MAGIC, ifbp->IFB_Magic );
+	HCFASSERT_INT;
+	HCFASSERT( ltvp, 0 );
+	HCFASSERT( 1 < ltvp->len && ltvp->len <= HCF_MAX_LTV + 1, ltvp->len );
 
 											//all codes between 0xFA00 and 0xFCFF are passed to Hermes
 #if (HCF_TYPE) & HCF_TYPE_WPA
@@ -2256,7 +2256,7 @@ int rc = HCF_SUCCESS;
 #define P ((CFG_REG_ASSERT_RTNP_STRCT FAR *)ltvp)
 		ifbp->IFB_AssertRtn = P->rtnp;
 //		ifbp->IFB_AssertLvl = P->lvl;		//TODO not yet supported so default is set in hcf_connect
-		HCFASSERT( DO_ASSERT, MERGE_2( HCF_ASSERT, 0xCAF1 ) )	//just to proof that the complete assert machinery is working
+		HCFASSERT( DO_ASSERT, MERGE_2( HCF_ASSERT, 0xCAF1 ) );	//just to proof that the complete assert machinery is working
 #undef P
 		break;
 #endif // HCF_ASSERT_RT_MSF_RTN
@@ -2266,22 +2266,22 @@ int rc = HCF_SUCCESS;
 		break;
 #endif // HCF_EXT_INFO_LOG
 	  case CFG_CNTL_OPT:												//overrule option
-		HCFASSERT( ( ltvp->val[0] & ~(USE_DMA | USE_16BIT) ) == 0, ltvp->val[0] )
+		HCFASSERT( ( ltvp->val[0] & ~(USE_DMA | USE_16BIT) ) == 0, ltvp->val[0] );
 		if ( ( ltvp->val[0] & USE_DMA ) == 0 ) ifbp->IFB_CntlOpt &= ~USE_DMA;
 		ifbp->IFB_CntlOpt |=  ltvp->val[0] & USE_16BIT;
 		break;
 #if (HCF_EXT) & HCF_EXT_MB
 	  case CFG_REG_MB:													//Register MailBox
 #define P ((CFG_REG_MB_STRCT FAR *)ltvp)
-		HCFASSERT( ( (hcf_32)P->mb_addr & 0x0001 ) == 0, (hcf_32)P->mb_addr )
-		HCFASSERT( (P)->mb_size >= 60, (P)->mb_size )
+		HCFASSERT( ( (hcf_32)P->mb_addr & 0x0001 ) == 0, (hcf_32)P->mb_addr );
+		HCFASSERT( (P)->mb_size >= 60, (P)->mb_size );
 		ifbp->IFB_MBp = P->mb_addr;
 		/* if no MB present, size must be 0 for ;?the old;? put_info_mb to work correctly */
 		ifbp->IFB_MBSize = ifbp->IFB_MBp == NULL ? 0 : P->mb_size;
 		ifbp->IFB_MBWp = ifbp->IFB_MBRp	= 0;
 		ifbp->IFB_MBp[0] = 0;											//flag the MailBox as empty
 		ifbp->IFB_MBInfoLen = 0;
-		HCFASSERT( ifbp->IFB_MBSize >= 60 || ifbp->IFB_MBp == NULL, ifbp->IFB_MBSize )
+		HCFASSERT( ifbp->IFB_MBSize >= 60 || ifbp->IFB_MBp == NULL, ifbp->IFB_MBSize );
 #undef P
 		break;
 	  case CFG_MB_INFO:													//store MailBoxInfoBlock
@@ -2306,9 +2306,9 @@ int rc = HCF_SUCCESS;
 		break;
 	  case CFG_CMD_HCF:
 #define P ((CFG_CMD_HCF_STRCT FAR *)ltvp)
-		HCFASSERT( P->cmd == CFG_CMD_HCF_REG_ACCESS, P->cmd )		//only Hermes register access supported
+		HCFASSERT( P->cmd == CFG_CMD_HCF_REG_ACCESS, P->cmd );		//only Hermes register access supported
 		if ( P->cmd == CFG_CMD_HCF_REG_ACCESS ) {
-			HCFASSERT( P->mode < ifbp->IFB_IOBase, P->mode )		//Check Register space
+			HCFASSERT( P->mode < ifbp->IFB_IOBase, P->mode );		//Check Register space
 			OPW( P->mode, P->add_info);
 		}
 #undef P
@@ -2325,7 +2325,7 @@ int rc = HCF_SUCCESS;
 		rc = put_info( ifbp, ltvp );
 	}
 	//DO NOT !!! HCFASSERT( rc == HCF_SUCCESS, rc )												/* 20 */
-	HCFLOGEXIT( HCF_TRACE_PUT_INFO )
+	HCFLOGEXIT( HCF_TRACE_PUT_INFO );
 	return rc;
 } // hcf_put_info
 
@@ -2448,21 +2448,21 @@ wci_bufp	lap = ifbp->IFB_lap + offset;			//start address in LookAhead Buffer
 hcf_16		lal = ifbp->IFB_lal - offset;			//available data within LookAhead Buffer
 hcf_16		j;
 
-	HCFLOGENTRY( HCF_TRACE_RCV_MSG, offset )
-	HCFASSERT( ifbp->IFB_Magic == HCF_MAGIC, ifbp->IFB_Magic )
-	HCFASSERT_INT
-	HCFASSERT( descp, HCF_TRACE_RCV_MSG )
-	HCFASSERT( ifbp->IFB_RxLen, HCF_TRACE_RCV_MSG )
-	HCFASSERT( ifbp->IFB_RxLen >= offset, MERGE_2( offset, ifbp->IFB_RxLen ) )
-	HCFASSERT( ifbp->IFB_lal >= offset, offset )
-	HCFASSERT( (ifbp->IFB_CntlOpt & USE_DMA) == 0, 0xDADA )
+	HCFLOGENTRY( HCF_TRACE_RCV_MSG, offset );
+	HCFASSERT( ifbp->IFB_Magic == HCF_MAGIC, ifbp->IFB_Magic );
+	HCFASSERT_INT;
+	HCFASSERT( descp, HCF_TRACE_RCV_MSG );
+	HCFASSERT( ifbp->IFB_RxLen, HCF_TRACE_RCV_MSG );
+	HCFASSERT( ifbp->IFB_RxLen >= offset, MERGE_2( offset, ifbp->IFB_RxLen ) );
+	HCFASSERT( ifbp->IFB_lal >= offset, offset );
+	HCFASSERT( (ifbp->IFB_CntlOpt & USE_DMA) == 0, 0xDADA );
 
 	if ( tot_len < 0 ) {
 		lal = 0; tot_len = 0;				//suppress all copying activity in the do--while loop
 	}
 	do {									//loop over all available fragments
 		// obnoxious hcf.c(1480) : warning C4769: conversion of near pointer to long integer
-		HCFASSERT( ((hcf_32)descp & 3 ) == 0, (hcf_32)descp )
+		HCFASSERT( ((hcf_32)descp & 3 ) == 0, (hcf_32)descp );
 		cp = descp->buf_addr;
 		j = min( (hcf_16)tot_len, descp->BUF_SIZE );	//minimum of "what's` available" and fragment size
 		descp->BUF_CNT = j;
@@ -2486,8 +2486,8 @@ hcf_16		j;
 	}
 #endif // HCF_TYPE_WPA
 	(void)hcf_action( ifbp, HCF_ACT_RX_ACK );		//only 1 shot to get the data, so free the resources in the NIC
-	HCFASSERT( rc == HCF_SUCCESS, rc )
-	HCFLOGEXIT( HCF_TRACE_RCV_MSG )
+	HCFASSERT( rc == HCF_SUCCESS, rc );
+	HCFLOGEXIT( HCF_TRACE_RCV_MSG );
 	return rc;
 } // hcf_rcv_msg
 #endif // HCF_DL_ONLY
@@ -2658,18 +2658,18 @@ hcf_16		i;
 
 hcf_16		fid = 0;
 
-	HCFASSERT( ifbp->IFB_RscInd || descp == NULL, ifbp->IFB_RscInd )
-	HCFASSERT( (ifbp->IFB_CntlOpt & USE_DMA) == 0, 0xDADB )
+	HCFASSERT( ifbp->IFB_RscInd || descp == NULL, ifbp->IFB_RscInd );
+	HCFASSERT( (ifbp->IFB_CntlOpt & USE_DMA) == 0, 0xDADB );
 
-	HCFLOGENTRY( HCF_TRACE_SEND_MSG, tx_cntl )
-	HCFASSERT( ifbp->IFB_Magic == HCF_MAGIC, ifbp->IFB_Magic )
-	HCFASSERT_INT
+	HCFLOGENTRY( HCF_TRACE_SEND_MSG, tx_cntl );
+	HCFASSERT( ifbp->IFB_Magic == HCF_MAGIC, ifbp->IFB_Magic );
+	HCFASSERT_INT;
 	/* obnoxious c:/hcf/hcf.c(1480) : warning C4769: conversion of near pointer to long integer,
 	 * so skip */
-	HCFASSERT( ((hcf_32)descp & 3 ) == 0, (hcf_32)descp )
+	HCFASSERT( ((hcf_32)descp & 3 ) == 0, (hcf_32)descp );
 #if HCF_ASSERT
 {	int x = ifbp->IFB_FWIdentity.comp_id == COMP_ID_FW_AP ? tx_cntl & ~HFS_TX_CNTL_PORT : tx_cntl;
-	HCFASSERT( (x & ~HCF_TX_CNTL_MASK ) == 0, tx_cntl )
+	HCFASSERT( (x & ~HCF_TX_CNTL_MASK ) == 0, tx_cntl );
 }
 #endif // HCF_ASSERT
 
@@ -2684,7 +2684,7 @@ hcf_16		fid = 0;
 											//copy all the fragments in a transparent fashion
 		 	for ( p = descp; p; p = p->next_desc_addr ) {
 			/* obnoxious warning C4769: conversion of near pointer to long integer */
-				HCFASSERT( ((hcf_32)p & 3 ) == 0, (hcf_32)p )
+				HCFASSERT( ((hcf_32)p & 3 ) == 0, (hcf_32)p );
 				put_frag( ifbp, p->buf_addr, p->BUF_CNT BE_PAR(0) );
 			}
 			rc = cmd_exe( ifbp, HCMD_THESEUS | HCMD_BUSY | HCMD_STARTPREAMBLE, fid );
@@ -2693,7 +2693,7 @@ hcf_16		fid = 0;
 			}
 		}
 											// een slecht voorbeeld doet goed volgen ;?
-		HCFLOGEXIT( HCF_TRACE_SEND_MSG )
+		HCFLOGEXIT( HCF_TRACE_SEND_MSG );
 		return rc;
 	}
 #endif // HCF_EXT_TX_CONT
@@ -2716,10 +2716,10 @@ hcf_16		fid = 0;
 		p = descp;
 		do len += p->BUF_CNT; while ( ( p = p->next_desc_addr ) != NULL );
 		p = descp;
-//;?	HCFASSERT( len <= HCF_MAX_MSG, len )
+//;?	HCFASSERT( len <= HCF_MAX_MSG, len );
 /*7*/	(void)setup_bap( ifbp, fid, HFS_TX_CNTL, IO_OUT );
 #if (HCF_TYPE) & HCF_TYPE_TX_DELAY
-		HCFASSERT( ( descp != NULL ) ^ ( tx_cntl & HFS_TX_CNTL_TX_DELAY ), tx_cntl )
+		HCFASSERT( ( descp != NULL ) ^ ( tx_cntl & HFS_TX_CNTL_TX_DELAY ), tx_cntl );
 		if ( tx_cntl & HFS_TX_CNTL_TX_DELAY ) {
 			tx_cntl &= ~HFS_TX_CNTL_TX_DELAY;		//!!HFS_TX_CNTL_TX_DELAY no longer available
 			ifbp->IFB_TxFID = fid;
@@ -2729,7 +2729,7 @@ hcf_16		fid = 0;
 		OPW( HREG_DATA_1, tx_cntl ) ;
 		OPW( HREG_DATA_1, 0 );
 #if ! ( (HCF_TYPE) & HCF_TYPE_CCX )
-		HCFASSERT( p->BUF_CNT >= 14, p->BUF_CNT )
+		HCFASSERT( p->BUF_CNT >= 14, p->BUF_CNT );
 											/* assume DestAddr/SrcAddr/Len/Type ALWAYS contained in 1st fragment
 											 * otherwise life gets too cumbersome for MIC and Encapsulation !!!!!!!!
 		if ( p->BUF_CNT >= 14 ) {	alternatively: add a safety escape !!!!!!!!!!!! }	*/
@@ -2780,7 +2780,7 @@ hcf_16		fid = 0;
 		while ( ( p = p->next_desc_addr ) != NULL ) {
 			/* obnoxious c:/hcf/hcf.c(1480) : warning C4769: conversion of near pointer to long integer,
 			 * so skip */
-			HCFASSERT( ((hcf_32)p & 3 ) == 0, (hcf_32)p )
+			HCFASSERT( ((hcf_32)p & 3 ) == 0, (hcf_32)p );
 			put_frag( ifbp, p->buf_addr, p->BUF_CNT BE_PAR(0) );
 			CALC_TX_MIC( p->buf_addr, p->BUF_CNT );
 		}
@@ -2800,8 +2800,8 @@ hcf_16		fid = 0;
 		}
 // #endif // ALLOC_15
 	}
-//	HCFASSERT( level::ifbp->IFB_RscInd, ifbp->IFB_RscInd )
-	HCFLOGEXIT( HCF_TRACE_SEND_MSG )
+//	HCFASSERT( level::ifbp->IFB_RscInd, ifbp->IFB_RscInd );
+	HCFLOGEXIT( HCF_TRACE_SEND_MSG );
 	return rc;
 } // hcf_send_msg
 #endif // HCF_DL_ONLY
@@ -3068,9 +3068,9 @@ hcf_16		stat;
 wci_bufp	buf_addr;
 hcf_16 		i;
 
-	HCFLOGENTRY( HCF_TRACE_SERVICE_NIC, ifbp->IFB_IntOffCnt )
-	HCFASSERT( ifbp->IFB_Magic == HCF_MAGIC, ifbp->IFB_Magic )
-	HCFASSERT_INT
+	HCFLOGENTRY( HCF_TRACE_SERVICE_NIC, ifbp->IFB_IntOffCnt );
+	HCFASSERT( ifbp->IFB_Magic == HCF_MAGIC, ifbp->IFB_Magic );
+	HCFASSERT_INT;
 
 	ifbp->IFB_LinkStat = 0; // ;? to be obsoleted ASAP												/* 1*/
 	ifbp->IFB_DSLinkStat &= ~CFG_LINK_STAT_CHANGE;													/* 1*/
@@ -3084,7 +3084,7 @@ hcf_16 		i;
 		if ( ifbp->IFB_RscInd == 0 && stat & HREG_EV_ALLOC ) { //Note: IFB_RscInd is ALWAYS 1 for DMA
 			ifbp->IFB_RscInd = 1;
 		}
-		IF_TALLY( if ( stat & HREG_EV_INFO_DROP ) ifbp->IFB_HCF_Tallies.NoBufInfo++; )
+		IF_TALLY( if ( stat & HREG_EV_INFO_DROP ) { ifbp->IFB_HCF_Tallies.NoBufInfo++; } );
 #if (HCF_EXT) & HCF_EXT_INT_TICK
 		if ( stat & HREG_EV_TICK ) {
 			ifbp->IFB_TickCnt++;
@@ -3112,7 +3112,7 @@ CFG_DDS_TICK_TIME_STRCT ltv;
 		}
 #if (HCF_EXT) & HCF_EXT_INT_TX_EX
 		if ( stat & HREG_EV_TX_EXT && ( i = IPW( HREG_TX_COMPL_FID ) ) != 0 /*DAWA*/ ) {
-			DAWA_ZERO_FID( HREG_TX_COMPL_FID )
+			DAWA_ZERO_FID( HREG_TX_COMPL_FID );
 			(void)setup_bap( ifbp, i, 0, IO_IN );
 			get_frag( ifbp, &ifbp->IFB_TxFsStat, HFS_SWSUP BE_PAR(1) );
 		}
@@ -3122,10 +3122,10 @@ CFG_DDS_TICK_TIME_STRCT ltv;
 		if ( !( ifbp->IFB_CntlOpt & USE_DMA ) ) //!! be aware of the logical indentations
 #endif // HCF_DMA
 /*16*/	  if ( stat & HREG_EV_RX && ( ifbp->IFB_RxFID = IPW( HREG_RX_FID ) ) != 0 ) { //if 0 then DAWA_ACK
-			HCFASSERT( bufp, len )
-			HCFASSERT( len >= HFS_DAT + 2, len )
-			DAWA_ZERO_FID( HREG_RX_FID )
-			HCFASSERT( ifbp->IFB_RxFID < CFG_PROD_DATA, ifbp->IFB_RxFID)
+			HCFASSERT( bufp, len );
+			HCFASSERT( len >= HFS_DAT + 2, len );
+			DAWA_ZERO_FID( HREG_RX_FID );
+			HCFASSERT( ifbp->IFB_RxFID < CFG_PROD_DATA, ifbp->IFB_RxFID);
 			(void)setup_bap( ifbp, ifbp->IFB_RxFID, 0, IO_IN );
 			get_frag( ifbp, bufp, HFS_ADDR_DEST BE_PAR(1) );
 			ifbp->IFB_lap = buf_addr = bufp + HFS_ADDR_DEST;
@@ -3144,7 +3144,7 @@ CFG_DDS_TICK_TIME_STRCT ltv;
 #endif // HCF_TYPE_CCX
 				{
 #if (HCF_ENCAP) == HCF_ENC
-					HCFASSERT( len >= HFS_DAT + 2 + sizeof(snap_header), len )
+					HCFASSERT( len >= HFS_DAT + 2 + sizeof(snap_header), len );
 /*34*/ 				i = *(wci_recordp)&bufp[HFS_STAT] & ( HFS_STAT_MSG_TYPE | HFS_STAT_ERR );
 					if ( i == HFS_STAT_TUNNEL ||
 						 ( i == HFS_STAT_1042 && hcf_encap( (wci_bufp)&bufp[HFS_TYPE] ) != ENC_TUNNEL ) ) {
@@ -3174,16 +3174,16 @@ CFG_DDS_TICK_TIME_STRCT ltv;
 			}
 		}
 		// in case of DMA: signal availability of rx and/or tx packets to MSF
-		IF_USE_DMA( ifbp->IFB_DmaPackets |= stat & ( HREG_EV_RDMAD | HREG_EV_TDMAD ); )
+		IF_USE_DMA( ifbp->IFB_DmaPackets |= stat & ( HREG_EV_RDMAD | HREG_EV_TDMAD ) );
 		// rlav : pending HREG_EV_RDMAD or HREG_EV_TDMAD events get acknowledged here.
 /*54*/	stat &= (hcf_16)~( HREG_EV_SLEEP_REQ | HREG_EV_CMD | HREG_EV_ACK_REG_READY | HREG_EV_ALLOC | HREG_EV_FW_DMA );
 //a positive mask would be easier to understand /*54*/	stat &= (hcf_16)~( HREG_EV_SLEEP_REQ | HREG_EV_CMD | HREG_EV_ACK_REG_READY | HREG_EV_ALLOC | HREG_EV_FW_DMA );
-		IF_USE_DMA( stat &= (hcf_16)~HREG_EV_RX; )
+		IF_USE_DMA( stat &= (hcf_16)~HREG_EV_RX );
 		if ( stat ) {
 			DAWA_ACK( stat );	/*DAWA*/
 		}
 	}
-	HCFLOGEXIT( HCF_TRACE_SERVICE_NIC )
+	HCFLOGEXIT( HCF_TRACE_SERVICE_NIC );
 	return rc;
 } // hcf_service_nic
 #endif // HCF_DL_ONLY
@@ -3507,7 +3507,7 @@ hcf_32	prot_cnt;
 					ifbp->IFB_TickIni = INI_TICK_INI;
 					ifbp->IFB_DefunctStat = HCF_ERR_DEFUNCT_TIMER;
 					ifbp->IFB_CardStat |= CARD_STAT_DEFUNCT;
-					HCFASSERT( DO_ASSERT, prot_cnt )
+					HCFASSERT( DO_ASSERT, prot_cnt );
 				}
 			}
 		ifbp->IFB_TickIni <<= HCF_PROT_TIME_SHFT;												/*8*/
@@ -3617,19 +3617,19 @@ HCF_STATIC int
 cmd_cmpl( IFBP ifbp )
 {
 
-PROT_CNT_INI
+PROT_CNT_INI;
 int		rc = HCF_SUCCESS;
 hcf_16	stat;
 
-	HCFLOGENTRY( HCF_TRACE_CMD_CPL, ifbp->IFB_Cmd )
+	HCFLOGENTRY( HCF_TRACE_CMD_CPL, ifbp->IFB_Cmd );
 	ifbp->IFB_Cmd &= ~HCMD_BUSY;												/* 2 */
 	HCF_WAIT_WHILE( (IPW( HREG_EV_STAT) & HREG_EV_CMD) == 0 );					/* 4 */
 	stat = IPW( HREG_STAT );
 #if HCF_PROT_TIME
 	if ( prot_cnt == 0 ) {
-		IF_TALLY( ifbp->IFB_HCF_Tallies.MiscErr++; )
+		IF_TALLY( ifbp->IFB_HCF_Tallies.MiscErr++ );
 		rc = HCF_ERR_TIME_OUT;
-		HCFASSERT( DO_ASSERT, ifbp->IFB_Cmd )
+		HCFASSERT( DO_ASSERT, ifbp->IFB_Cmd );
 	} else
 #endif // HCF_PROT_TIME
 	{
@@ -3639,15 +3639,15 @@ hcf_16	stat;
 				rc = ifbp->IFB_DefunctStat = HCF_ERR_DEFUNCT_CMD_SEQ;
 				ifbp->IFB_CardStat |= CARD_STAT_DEFUNCT;
 			}
-			IF_TALLY( ifbp->IFB_HCF_Tallies.MiscErr++; )
+			IF_TALLY( ifbp->IFB_HCF_Tallies.MiscErr++ );
 			ifbp->IFB_ErrCmd = stat;
 			ifbp->IFB_ErrQualifier = IPW( HREG_RESP_0 );
-			HCFASSERT( DO_ASSERT, MERGE_2( IPW( HREG_PARAM_0 ), ifbp->IFB_Cmd ) )
-			HCFASSERT( DO_ASSERT, MERGE_2( ifbp->IFB_ErrQualifier, ifbp->IFB_ErrCmd ) )
+			HCFASSERT( DO_ASSERT, MERGE_2( IPW( HREG_PARAM_0 ), ifbp->IFB_Cmd ) );
+			HCFASSERT( DO_ASSERT, MERGE_2( ifbp->IFB_ErrQualifier, ifbp->IFB_ErrCmd ) );
 		}
 	}
-	HCFASSERT( rc == HCF_SUCCESS, rc)
-	HCFLOGEXIT( HCF_TRACE_CMD_CPL )
+	HCFASSERT( rc == HCF_SUCCESS, rc);
+	HCFLOGEXIT( HCF_TRACE_CMD_CPL );
 	return rc;
 } // cmd_cmpl
 
@@ -3706,8 +3706,8 @@ cmd_exe( IFBP ifbp, hcf_16 cmd_code, hcf_16 par_0 )	//if HCMD_BUSY of cmd_code s
 {
 int rc;
 
-	HCFLOGENTRY( HCF_TRACE_CMD_EXE, cmd_code )
-	HCFASSERT( (cmd_code & HCMD_CMD_CODE) != HCMD_TX || cmd_code & HCMD_BUSY, cmd_code ) //Tx must have Busy bit set
+	HCFLOGENTRY( HCF_TRACE_CMD_EXE, cmd_code );
+	HCFASSERT( (cmd_code & HCMD_CMD_CODE) != HCMD_TX || cmd_code & HCMD_BUSY, cmd_code ); //Tx must have Busy bit set
 	OPW( HREG_SW_0, HCF_MAGIC );
 	if ( IPW( HREG_SW_0 ) == HCF_MAGIC ) {														/* 1 */
 		rc = ifbp->IFB_DefunctStat;
@@ -3725,8 +3725,8 @@ int rc;
 			rc = cmd_cmpl( ifbp );
 		}
 	}
-	HCFASSERT( rc == HCF_SUCCESS, MERGE_2( rc, cmd_code ) )
-	HCFLOGEXIT( HCF_TRACE_CMD_EXE )
+	HCFASSERT( rc == HCF_SUCCESS, MERGE_2( rc, cmd_code ) );
+	HCFLOGEXIT( HCF_TRACE_CMD_EXE );
 	return rc;
 } // cmd_exe
 
@@ -3764,9 +3764,9 @@ int					rc = HCF_SUCCESS;
 wci_bufp			cp;
 hcf_io				io_port = ifbp->IFB_IOBase + HREG_AUX_DATA;
 
-	HCFLOGENTRY( HCF_TRACE_DL, ltvp->typ )
+	HCFLOGENTRY( HCF_TRACE_DL, ltvp->typ );
 #if (HCF_TYPE) & HCF_TYPE_PRELOADED
-	HCFASSERT( DO_ASSERT, ltvp->mode )
+	HCFASSERT( DO_ASSERT, ltvp->mode );
 #else
 													//if initial "program" LTV
 	if ( ifbp->IFB_DLMode == CFG_PROG_STOP && ltvp->mode == CFG_PROG_VOLATILE) {
@@ -3818,7 +3818,7 @@ hcf_io				io_port = ifbp->IFB_IOBase + HREG_AUX_DATA;
 		} else
 #endif //;? as long as the above if contains a hard coded 0, might as well leave it out even more obvious
 		{											//.  .  get number of words to program
-			HCFASSERT( ltvp->segment_size, *ltvp->host_addr )
+			HCFASSERT( ltvp->segment_size, *ltvp->host_addr );
 			i = ltvp->segment_size/2;
 													//.  .  copy data (words) from LTV via AUX port to NIC
 			cp = (wci_bufp)ltvp->host_addr;						//OUT_PORT_STRING_8_16 macro may modify its parameters
@@ -3833,8 +3833,8 @@ hcf_io				io_port = ifbp->IFB_IOBase + HREG_AUX_DATA;
 	}
 	ifbp->IFB_DLMode = ltvp->mode;					//save state in IFB_DLMode
 #endif // HCF_TYPE_PRELOADED
-	HCFASSERT( rc == HCF_SUCCESS, rc )
-	HCFLOGEXIT( HCF_TRACE_DL )
+	HCFASSERT( rc == HCF_SUCCESS, rc );
+	HCFLOGEXIT( HCF_TRACE_DL );
 	return rc;
 } // download
 
@@ -3916,18 +3916,18 @@ get_fid( IFBP ifbp )
 
 hcf_16 fid = 0;
 #if ( (HCF_TYPE) & HCF_TYPE_HII5 ) == 0
-PROT_CNT_INI
+PROT_CNT_INI;
 #endif // HCF_TYPE_HII5
 
-	IF_DMA( HCFASSERT(!(ifbp->IFB_CntlOpt & USE_DMA), ifbp->IFB_CntlOpt) )
+	IF_DMA( HCFASSERT(!(ifbp->IFB_CntlOpt & USE_DMA), ifbp->IFB_CntlOpt) );
 
 	if ( IPW( HREG_EV_STAT) & HREG_EV_ALLOC) {
 		fid = IPW( HREG_ALLOC_FID );
-		HCFASSERT( fid, ifbp->IFB_RscInd )
-		DAWA_ZERO_FID( HREG_ALLOC_FID )
+		HCFASSERT( fid, ifbp->IFB_RscInd );
+		DAWA_ZERO_FID( HREG_ALLOC_FID );
 #if ( (HCF_TYPE) & HCF_TYPE_HII5 ) == 0
 		HCF_WAIT_WHILE( ( IPW( HREG_EV_STAT ) & HREG_EV_ACK_REG_READY ) == 0 );
-		HCFASSERT( prot_cnt, IPW( HREG_EV_STAT ) )
+		HCFASSERT( prot_cnt, IPW( HREG_EV_STAT ) );
 #endif // HCF_TYPE_HII5
 		DAWA_ACK( HREG_EV_ALLOC );			//!!note that HREG_EV_ALLOC is written only once
 // 180 degree error in logic ;? #if ALLOC_15
@@ -3989,7 +3989,7 @@ wci_bufp	p = bufp;									//working pointer
 int			i;											//prevent side effects from macro
 int			j;
 
-	HCFASSERT( ((hcf_32)bufp & (HCF_ALIGN-1) ) == 0, (hcf_32)bufp )
+	HCFASSERT( ((hcf_32)bufp & (HCF_ALIGN-1) ) == 0, (hcf_32)bufp );
 
 /*1:	here recovery logic for intervening BAP access between hcf_service_nic and hcf_rcv_msg COULD be added
  * 	if current access is RxInitial
@@ -4045,9 +4045,9 @@ hcf_32 FAR	*p4; //prevent side effects from macro
 		}
 	}
 #if HCF_BIG_ENDIAN
-	HCFASSERT( word_len == 0 || word_len == 2 || word_len == 4, word_len )
-	HCFASSERT( word_len == 0 || ((hcf_32)bufp & 1 ) == 0, (hcf_32)bufp )
-	HCFASSERT( word_len <= len, MERGE2( word_len, len ) )
+	HCFASSERT( word_len == 0 || word_len == 2 || word_len == 4, word_len );
+	HCFASSERT( word_len == 0 || ((hcf_32)bufp & 1 ) == 0, (hcf_32)bufp );
+	HCFASSERT( word_len <= len, MERGE2( word_len, len ) );
 	//see put_frag for an alternative implementation, but be careful about what are int's and what are
 	//hcf_16's
 	if ( word_len ) {								//.  if there is anything to convert
@@ -4158,11 +4158,11 @@ init( IFBP ifbp )
 
 int	rc = HCF_SUCCESS;
 
-	HCFLOGENTRY( HCF_TRACE_INIT, 0 )
+	HCFLOGENTRY( HCF_TRACE_INIT, 0 );
 
 	ifbp->IFB_CardStat = 0;																			/* 2*/
 	OPW( HREG_EV_ACK, ~HREG_EV_SLEEP_REQ ); 											/* 4*/
-	IF_PROT_TIME( calibrate( ifbp ); ) 													/*10*/
+	IF_PROT_TIME( calibrate( ifbp ) ); 													/*10*/
 #if 0 // OOR
 	ifbp->IFB_FWIdentity.len = 2;							//misuse the IFB space for a put
 	ifbp->IFB_FWIdentity.typ = CFG_TICK_TIME;
@@ -4234,7 +4234,7 @@ int i = sizeof( CFG_FW_IDENTITY_STRCT) + sizeof(CFG_SUP_RANGE_STRCT );
 #endif // MSF_COMPONENT_ID
 #if (HCF_DL_ONLY) == 0																			/* 28 */
 	if ( rc == HCF_SUCCESS && ifbp->IFB_FWIdentity.comp_id >= COMP_ID_FW_STA ) {
-PROT_CNT_INI
+PROT_CNT_INI;
 		/**************************************************************************************
 		* rlav: the DMA engine needs the host to cause a 'hanging alloc event' for it to consume.
 		* not sure if this is the right spot in the HCF, thinking about hcf_enable...
@@ -4245,22 +4245,22 @@ PROT_CNT_INI
 //#else
 		if ( rc == HCF_SUCCESS ) {
 			HCF_WAIT_WHILE( (IPW( HREG_EV_STAT ) & HREG_EV_ALLOC) == 0 );
-			IF_PROT_TIME( HCFASSERT(prot_cnt, IPW( HREG_EV_STAT ) ) /*NOP*/;)
+			IF_PROT_TIME( HCFASSERT(prot_cnt, IPW( HREG_EV_STAT )) );
 #if HCF_DMA
 			if ( ! ( ifbp->IFB_CntlOpt & USE_DMA ) )
 #endif // HCF_DMA
 			{
 				ifbp->IFB_RscInd = get_fid( ifbp );
-				HCFASSERT( ifbp->IFB_RscInd, 0 )
+				HCFASSERT( ifbp->IFB_RscInd, 0 );
 				cmd_exe( ifbp, HCMD_ALLOC, 0 );
-				IF_PROT_TIME( if ( prot_cnt == 0 ) rc = HCF_ERR_TIME_OUT; )
+				IF_PROT_TIME( if ( prot_cnt == 0 ) rc = HCF_ERR_TIME_OUT );
 			}
 		}
 //#endif // ALLOC_15
 	}
 #endif // HCF_DL_ONLY
-	HCFASSERT( rc == HCF_SUCCESS, rc )
-	HCFLOGEXIT( HCF_TRACE_INIT )
+	HCFASSERT( rc == HCF_SUCCESS, rc );
+	HCFLOGEXIT( HCF_TRACE_INIT );
 	return rc;
 } // init
 
@@ -4307,11 +4307,11 @@ RID_LOGP	ridp = ifbp->IFB_RIDLogp;	//NULL or pointer to array of RID_LOG structu
 
 	HCFTRACE( ifbp, HCF_TRACE_ISR_INFO );																/* 1 */
 	fid = IPW( HREG_INFO_FID );
-	DAWA_ZERO_FID( HREG_INFO_FID )
+	DAWA_ZERO_FID( HREG_INFO_FID );
 	if ( fid ) {
 		(void)setup_bap( ifbp, fid, 0, IO_IN );
 		get_frag( ifbp, (wci_bufp)info, 4 BE_PAR(2) );
-		HCFASSERT( info[0] <= HCF_MAX_LTV + 1, MERGE_2( info[1], info[0] ) )  //;? a smaller value makes more sense
+		HCFASSERT( info[0] <= HCF_MAX_LTV + 1, MERGE_2( info[1], info[0] ) );  //;? a smaller value makes more sense
 #if (HCF_TALLIES) & HCF_TALLIES_NIC		//Hermes tally support
 		if ( info[1] == CFG_TALLIES ) {
 hcf_32	*p;
@@ -4331,7 +4331,7 @@ hcf_32	*p;
 /*6*/		while ( 1 ) {
 				if ( ridp->typ == 0 || ridp->typ == info[1] ) {
 					if ( ridp->bufp ) {
-						HCFASSERT( ridp->len >= 2, ridp->typ )
+						HCFASSERT( ridp->len >= 2, ridp->typ );
 						ridp->bufp[0] = min((hcf_16)(ridp->len - 1), info[0] ); 	//save L
 						ridp->bufp[1] = info[1];						//save T
 						get_frag( ifbp, (wci_bufp)&ridp->bufp[2], (ridp->bufp[0] - 1)*2 BE_PAR(0) );
@@ -4366,7 +4366,7 @@ hcf_32	*p;
 // /*6*/	while ( 1 ) {
 // 			if ( ridp->typ == 0 || ridp->typ == info[1] ) {
 // 				if ( ridp->bufp ) {
-// 					HCFASSERT( ridp->len >= 2, ridp->typ )
+// 					HCFASSERT( ridp->len >= 2, ridp->typ );
 // 					(void)setup_bap( ifbp, fid, 2, IO_IN );			//restore BAP for tallies, linkstat and specific type followed by wild card
 // 					ridp->bufp[0] = min( ridp->len - 1, info[0] ); 	//save L
 // 					get_frag( ifbp, (wci_bufp)&ridp->bufp[1], ridp->bufp[0]*2 BE_PAR(0) );
@@ -4483,11 +4483,11 @@ put_frag( IFBP ifbp, wci_bufp bufp, int len BE_PAR( int word_len ) )
 hcf_io		io_port = ifbp->IFB_IOBase + HREG_DATA_1;	//BAP data register
 int			i;											//prevent side effects from macro
 hcf_16		j;
-	HCFASSERT( ((hcf_32)bufp & (HCF_ALIGN-1) ) == 0, (hcf_32)bufp )
+	HCFASSERT( ((hcf_32)bufp & (HCF_ALIGN-1) ) == 0, (hcf_32)bufp );
 #if HCF_BIG_ENDIAN
-	HCFASSERT( word_len == 0 || word_len == 2 || word_len == 4, word_len )
-	HCFASSERT( word_len == 0 || ((hcf_32)bufp & 1 ) == 0, (hcf_32)bufp )
-	HCFASSERT( word_len <= len, MERGE_2( word_len, len ) )
+	HCFASSERT( word_len == 0 || word_len == 2 || word_len == 4, word_len );
+	HCFASSERT( word_len == 0 || ((hcf_32)bufp & 1 ) == 0, (hcf_32)bufp );
+	HCFASSERT( word_len <= len, MERGE_2( word_len, len ) );
 
 	if ( word_len ) {									//if there is anything to convert
  														//.  convert and write the 1st hcf_16
@@ -4635,8 +4635,8 @@ put_info( IFBP ifbp, LTVP ltvp	)
 
 int rc = HCF_SUCCESS;
 
-	HCFASSERT( ifbp->IFB_CardStat == 0, MERGE_2( ltvp->typ, ifbp->IFB_CardStat ) )
-	HCFASSERT( CFG_RID_CFG_MIN <= ltvp->typ && ltvp->typ <= CFG_RID_CFG_MAX, ltvp->typ )
+	HCFASSERT( ifbp->IFB_CardStat == 0, MERGE_2( ltvp->typ, ifbp->IFB_CardStat ) );
+	HCFASSERT( CFG_RID_CFG_MIN <= ltvp->typ && ltvp->typ <= CFG_RID_CFG_MAX, ltvp->typ );
 
 	if ( ifbp->IFB_CardStat == 0 &&																/* 20*/
 		 ( ( CFG_RID_CFG_MIN <= ltvp->typ    && ltvp->typ <= CFG_RID_CFG_MAX ) ||
@@ -4654,7 +4654,7 @@ int rc = HCF_SUCCESS;
 		   t != CFG_DEAUTHENTICATE_ADDR
 		 )
 		) {
-		HCFASSERT( DO_ASSERT, ltvp->typ )
+		HCFASSERT( DO_ASSERT, ltvp->typ );
 		}
  }
 #endif // HCF_ASSERT
@@ -4738,8 +4738,8 @@ hcf_16		len;					//total length to copy to MailBox
 hcf_16		tlen;					//free length/working length/offset in WMP frame
 
 	if ( ifbp->IFB_MBp == NULL ) return rc;  //;?not sufficient
-	HCFASSERT( ifbp->IFB_MBp != NULL, 0 )					//!!!be careful, don't get into an endless recursion
-	HCFASSERT( ifbp->IFB_MBSize, 0 )
+	HCFASSERT( ifbp->IFB_MBp != NULL, 0 );					//!!!be careful, don't get into an endless recursion
+	HCFASSERT( ifbp->IFB_MBSize, 0 );
 
 	len = 1;																							/* 1 */
 	for ( i = 0; i < ltvp->frag_cnt; i++ ) {
@@ -4765,7 +4765,7 @@ hcf_16		tlen;					//free length/working length/offset in WMP frame
 	}
 	if ( len + 2 >= tlen ){																				/* 6 */
 		//Do Not ASSERT, this is a normal condition
-		IF_TALLY( ifbp->IFB_HCF_Tallies.NoBufMB++; ) /*NOP to cover against analomies with empty compound*/;
+		IF_TALLY( ifbp->IFB_HCF_Tallies.NoBufMB++ );
 		rc = HCF_ERR_LEN;
 	} else {
 		*dp++ = len;									//write Len (= size of T+V in words to MB_Info block
@@ -4861,7 +4861,7 @@ hcf_16		tlen;					//free length/working length/offset in WMP frame
 HCF_STATIC int
 setup_bap( IFBP ifbp, hcf_16 fid, int offset, int type )
 {
-PROT_CNT_INI
+PROT_CNT_INI;
 int	rc;
 
 	HCFTRACE( ifbp, HCF_TRACE_STRIO );
@@ -4874,9 +4874,9 @@ int	rc;
 		}
 		else ifbp->IFB_CarryOut = 0;
 		HCF_WAIT_WHILE( IPW( HREG_OFFSET_1) & HCMD_BUSY );
-		HCFASSERT( !( IPW( HREG_OFFSET_1) & HREG_OFFSET_ERR ), MERGE_2( fid, offset ) )			/*8*/
+		HCFASSERT( !( IPW( HREG_OFFSET_1) & HREG_OFFSET_ERR ), MERGE_2( fid, offset ) );			/*8*/
 		if ( prot_cnt == 0 ) {
-			HCFASSERT( DO_ASSERT, MERGE_2( fid, offset ) )
+			HCFASSERT( DO_ASSERT, MERGE_2( fid, offset ) );
 			rc = ifbp->IFB_DefunctStat = HCF_ERR_DEFUNCT_TIME_OUT;
 			ifbp->IFB_CardStat |= CARD_STAT_DEFUNCT;
 		}
diff --git a/drivers/staging/wlags49_h2/hcfdef.h b/drivers/staging/wlags49_h2/hcfdef.h
index 0261c73..8e08d7b 100644
--- a/drivers/staging/wlags49_h2/hcfdef.h
+++ b/drivers/staging/wlags49_h2/hcfdef.h
@@ -557,17 +557,13 @@ err: ;
 /************************************************************************************************/
 
 #ifdef HCF_SLEEP
-#if defined MSF_WAIT
-err: MSF should no longer supply this macro;
+#define MSF_WAIT(x) do {						\
+		PROT_CNT_INI;						\
+		HCF_WAIT_WHILE((IPW(HREG_IO) & HREG_IO_WOKEN_UP) == 0); \
+		HCFASSERT( prot_cnt, IPW( HREG_IO ) );			\
+	} while (0)
 #else
-#define MSF_WAIT(x)							\
-	{ PROT_CNT_INI							\
-			HCF_WAIT_WHILE( ( IPW( HREG_IO ) & HREG_IO_WOKEN_UP ) == 0 ); \
-		HCFASSERT( prot_cnt, IPW( HREG_IO ) )			\
-			}
-#endif // MSF_WAIT
-#else
-#define MSF_WAIT(x) /*NOP*/
+#define MSF_WAIT(x) do { } while (0)
 #endif // HCF_SLEEP
 
 #define LOF(x)          (sizeof(x)/sizeof(hcf_16)-1)
@@ -583,13 +579,14 @@ err: MSF should no longer supply this macro;
 #endif //     HCF_STATIC
 
 #if ( (HCF_TYPE) & HCF_TYPE_HII5 ) == 0
-#define DAWA_ACK( mask) {						\
+#define DAWA_ACK( mask) do {						\
 		OPW( HREG_EV_ACK, mask | HREG_EV_ACK_REG_READY );	\
-		OPW( HREG_EV_ACK, (mask & ~HREG_EV_ALLOC) | HREG_EV_ACK_REG_READY );    }
-#define DAWA_ZERO_FID(reg) OPW( reg, 0 );
+		OPW( HREG_EV_ACK, (mask & ~HREG_EV_ALLOC) | HREG_EV_ACK_REG_READY ); \
+	} while (0)
+#define DAWA_ZERO_FID(reg) OPW( reg, 0 )
 #else
-#define DAWA_ACK( mask)   OPW( HREG_EV_ACK, mask );
-#define DAWA_ZERO_FID(reg)
+#define DAWA_ACK( mask)   OPW( HREG_EV_ACK, mask )
+#define DAWA_ZERO_FID(reg) do { } while (0)
 #endif // HCF_TYPE_HII5
 
 #if (HCF_TYPE) & HCF_TYPE_WPA
@@ -607,22 +604,22 @@ err: MSF should no longer supply this macro;
 #endif // HCF_TYPE_WPA
 
 #if HCF_TALLIES & HCF_TALLIES_HCF       //HCF tally support
-#define IF_TALLY(x)  x
+#define IF_TALLY(x) do { x; } while (0)
 #else
-#define IF_TALLY(x)
+#define IF_TALLY(x) do { } while (0)
 #endif // HCF_TALLIES_HCF
 
 
 #if HCF_DMA
-#define IF_DMA(x)           x
-#define IF_NOT_DMA(x)
-#define IF_USE_DMA(x)       if (   ifbp->IFB_CntlOpt & USE_DMA  ) x
-#define IF_NOT_USE_DMA(x)   if ( !(ifbp->IFB_CntlOpt & USE_DMA) ) x
+#define IF_DMA(x)           do { x; } while(0)
+#define IF_NOT_DMA(x)       do { } while(0)
+#define IF_USE_DMA(x)       if (   ifbp->IFB_CntlOpt & USE_DMA  ) { x; }
+#define IF_NOT_USE_DMA(x)   if ( !(ifbp->IFB_CntlOpt & USE_DMA) ) { x; }
 #else
-#define IF_DMA(x)
-#define IF_NOT_DMA(x)       x
-#define IF_USE_DMA(x)
-#define IF_NOT_USE_DMA(x)   x
+#define IF_DMA(x)           do { } while(0)
+#define IF_NOT_DMA(x)       do { x; } while(0)
+#define IF_USE_DMA(x)       do { } while(0)
+#define IF_NOT_USE_DMA(x)   do { x; } while(0)
 #endif // HCF_DMA
 
 
@@ -632,16 +629,16 @@ err: MSF should no longer supply this macro;
  * in a row and that when one fails all subsequent fail immediately without reinitialization of prot_cnt
  */
 #if HCF_PROT_TIME == 0
-#define PROT_CNT_INI
-#define IF_PROT_TIME(x)
+#define PROT_CNT_INI    do { } while(0)
+#define IF_PROT_TIME(x) do { } while(0)
 #if defined HCF_YIELD
-#define HCF_WAIT_WHILE( x ) while ( (x) && (HCF_YIELD) ) /*NOP*/;
+#define HCF_WAIT_WHILE( x ) do { } while( (x) && (HCF_YIELD) )
 #else
-#define HCF_WAIT_WHILE( x ) while ( x ) /*NOP*/;
+#define HCF_WAIT_WHILE( x ) do { } while ( x )
 #endif // HCF_YIELD
 #else
-#define PROT_CNT_INI    hcf_32 prot_cnt = ifbp->IFB_TickIni;
-#define IF_PROT_TIME(x) x
+#define PROT_CNT_INI    hcf_32 prot_cnt = ifbp->IFB_TickIni
+#define IF_PROT_TIME(x) do { x; } while(0)
 #if defined HCF_YIELD
 #define HCF_WAIT_WHILE( x ) while ( prot_cnt && (x) && (HCF_YIELD) ) prot_cnt--;
 #else
@@ -684,32 +681,32 @@ err: someone redefined these macros while the implemenation assumes they are equ
  * on the if-statement
  */
 #if HCF_ASSERT
-#define HCFASSERT(x,q) {if (!(x)) {mdd_assert(        ifbp, __LINE__                   , q );}}
+#define HCFASSERT(x,q) do { if (!(x)) {mdd_assert(ifbp, __LINE__, q );} } while(0)
 #define MMDASSERT(x,q) {if (!(x)) {mdd_assert( assert_ifbp, __LINE__ + FILE_NAME_OFFSET, q );}}
 
-#define HCFLOGENTRY( where, what )					\
-	{if ( (ifbp->IFB_AssertWhere = where) <= 15 ) {			\
+#define HCFLOGENTRY( where, what ) do {					\
+		if ( (ifbp->IFB_AssertWhere = where) <= 15 ) {		\
 			HCF_ENTRY( ifbp );				\
 			HCFASSERT( (ifbp->IFB_AssertTrace & 1<<((where)&0xF)) == 0, ifbp->IFB_AssertTrace ); \
 			ifbp->IFB_AssertTrace |= 1<<((where)&0xF);	\
 		}							\
-		HCFTRACE(ifbp, where )					\
-			HCFTRACEVALUE(ifbp, what )			\
-			}
+		HCFTRACE(ifbp, where );					\
+		HCFTRACEVALUE(ifbp, what );				\
+	} while (0)
 
-#define HCFLOGEXIT( where )						\
-	{if ( (ifbp->IFB_AssertWhere = where) <= 15 ) {			\
+#define HCFLOGEXIT( where ) do {					\
+		if ( (ifbp->IFB_AssertWhere = where) <= 15 ) {		\
 			HCF_EXIT( ifbp );				\
 			ifbp->IFB_AssertTrace &= ~(1<<((where)&0xF));	\
 		}							\
-		HCFTRACE(ifbp, (where)|HCF_TRACE_EXIT )			\
-			}
+		HCFTRACE(ifbp, (where)|HCF_TRACE_EXIT );		\
+	} while (0)
 
 #else // HCF_ASSERT
-#define HCFASSERT( x, q )
+#define HCFASSERT( x, q ) do { } while(0)
 #define MMDASSERT( x, q )
-#define HCFLOGENTRY( where, what )      {HCF_ENTRY( ifbp );}
-#define HCFLOGEXIT( where )             {HCF_EXIT( ifbp );}
+#define HCFLOGENTRY( where, what )      do {HCF_ENTRY( ifbp );} while (0)
+#define HCFLOGEXIT( where )             do {HCF_EXIT( ifbp );} while(0)
 #endif // HCF_ASSERT
 
 #if HCF_INT_ON
@@ -727,13 +724,13 @@ err: someone redefined these macros while the implemenation assumes they are equ
 
 
 #if defined HCF_TRACE
-#define HCFTRACE(ifbp, where )     {OPW( HREG_SW_1, where );}
+#define HCFTRACE(ifbp, where )     do {OPW( HREG_SW_1, where );} while(0)
 //#define HCFTRACE(ifbp, where )       {HCFASSERT( DO_ASSERT, where );}
-#define HCFTRACEVALUE(ifbp, what ) {OPW( HREG_SW_2, what  );}
+#define HCFTRACEVALUE(ifbp, what ) do {OPW( HREG_SW_2, what  );} while (0)
 //#define HCFTRACEVALUE(ifbp, what ) {HCFASSERT( DO_ASSERT, what  );}
 #else
-#define HCFTRACE(ifbp, where )
-#define HCFTRACEVALUE(ifbp, what )
+#define HCFTRACE(ifbp, where )     do { } while(0)
+#define HCFTRACEVALUE(ifbp, what ) do { } while(0)
 #endif // HCF_TRACE
 
 
-- 
1.7.4.1

