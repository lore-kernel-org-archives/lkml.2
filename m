Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935460Ab1IOXaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:30:05 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:62768 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935417Ab1IOXaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:30:03 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 11/13] staging: wlags49_h2: Remove HCF_EXT_MB from code.
Date: Fri, 16 Sep 2011 00:20:55 +0100
Message-Id: <1316128857-9781-12-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
References: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HII and HII.5 configurations both use the mailboxes.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/hcf.c |   28 ++++++++--------------------
 drivers/staging/wlags49_h2/hcf.h |    2 --
 2 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index 5935b42..67c138d 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -104,9 +104,7 @@
 HCF_STATIC int          cmd_exe( IFBP ifbp, hcf_16 cmd_code, hcf_16 par_0 );
 HCF_STATIC int          init( IFBP ifbp );
 HCF_STATIC int          put_info( IFBP ifbp, LTVP ltvp );
-#if (HCF_EXT) & HCF_EXT_MB
 HCF_STATIC int          put_info_mb( IFBP ifbp, CFG_MB_INFO_STRCT FAR * ltvp );
-#endif // HCF_EXT_MB
 #if (HCF_TYPE) & HCF_TYPE_WPA
 HCF_STATIC void         calc_mic( hcf_32* p, hcf_32 M );
 void                    calc_mic_rx_frag( IFBP ifbp, wci_bufp p, int len );
@@ -473,14 +471,10 @@ static struct /*CFG_HCF_OPT_STRCT*/ {
 }; // cfg_hcf_opt
 #endif // MSF_COMPONENT_ID
 
-#if defined MSF_COMPONENT_ID || (HCF_EXT) & HCF_EXT_MB
-#if (HCF_EXT) & HCF_EXT_MB
 HCF_STATIC LTV_STRCT BASED cfg_null = { 1, CFG_NULL, {0} };
-#endif // HCF_EXT_MB
+
 HCF_STATIC hcf_16* BASED xxxx[ ] = {
-#if (HCF_EXT) & HCF_EXT_MB
 	&cfg_null.len,                          //CFG_NULL                      0x0820
-#endif // HCF_EXT_MB
 #if defined MSF_COMPONENT_ID
 	&cfg_drv_identity.len,                  //CFG_DRV_IDENTITY              0x0826
 	&cfg_drv_sup_range.len,                 //CFG_DRV_SUP_RANGE             0x0827
@@ -496,8 +490,6 @@ HCF_STATIC hcf_16* BASED xxxx[ ] = {
 };
 #define xxxx_PRI_IDENTITY_OFFSET    (ARRAY_SIZE(xxxx) - 3)
 
-#endif // MSF_COMPONENT_ID / HCF_EXT_MB
-
 
 /************************************************************************************************************
  ************************** T O P   L E V E L   H C F   R O U T I N E S **************************************
@@ -1974,16 +1966,16 @@ hcf_get_info( IFBP ifbp, LTVP ltvp )
 	HCFASSERT( 1 < ltvp->len && ltvp->len <= HCF_MAX_LTV + 1, MERGE_2( ltvp->typ, ltvp->len ) );
 
 	ltvp->len = 0;                              //default to: No Info Available
-#if defined MSF_COMPONENT_ID || (HCF_EXT) & HCF_EXT_MB //filter out all specials
+	//filter out all specials
 	for ( i = 0; ( q = xxxx[i] ) != NULL && q[1] != type; i++ ) /*NOP*/;
-#endif // MSF_COMPONENT_ID / HCF_EXT_MB
+
 #if HCF_TALLIES
 	if ( type == CFG_TALLIES ) {                                                    /*3*/
 		(void)hcf_action( ifbp, HCF_ACT_TALLIES );
 		q = (hcf_16*)&ifbp->IFB_TallyLen;
 	}
 #endif // HCF_TALLIES
-#if (HCF_EXT) & HCF_EXT_MB
+
 	if ( type == CFG_MB_INFO ) {
 		if ( ifbp->IFB_MBInfoLen ) {
 			if ( ifbp->IFB_MBp[ifbp->IFB_MBRp] == 0xFFFF ) {
@@ -1997,7 +1989,7 @@ hcf_get_info( IFBP ifbp, LTVP ltvp )
 			ifbp->IFB_MBInfoLen = ifbp->IFB_MBp[ifbp->IFB_MBRp];
 		}
 	}
-#endif // HCF_EXT_MB
+
 	if ( q != NULL ) {                      //a special or CFG_TALLIES or CFG_MB_INFO
 		i = min( len, *q ) + 1;             //total size of destination (including T-field)
 		while ( i-- ) {
@@ -2203,7 +2195,7 @@ hcf_put_info( IFBP ifbp, LTVP ltvp )
 			if ( ( ltvp->val[0] & USE_DMA ) == 0 ) ifbp->IFB_CntlOpt &= ~USE_DMA;
 			ifbp->IFB_CntlOpt |=  ltvp->val[0] & USE_16BIT;
 			break;
-#if (HCF_EXT) & HCF_EXT_MB
+
 		case CFG_REG_MB:                                                  //Register MailBox
 #define P ((CFG_REG_MB_STRCT FAR *)ltvp)
 			HCFASSERT( ( (hcf_32)P->mb_addr & 0x0001 ) == 0, (hcf_32)P->mb_addr );
@@ -2220,7 +2212,6 @@ hcf_put_info( IFBP ifbp, LTVP ltvp )
 		case CFG_MB_INFO:                                                 //store MailBoxInfoBlock
 			rc = put_info_mb( ifbp, (CFG_MB_INFO_STRCT FAR *)ltvp );
 			break;
-#endif // HCF_EXT_MB
 
 #if (HCF_EXT) & HCF_EXT_NIC_ACCESS
 		case CFG_CMD_NIC:
@@ -4336,11 +4327,11 @@ mdd_assert( IFBP ifbp, unsigned int line_number, hcf_32 q )
 		OPW( HREG_SW_2, (hcf_16)(q >> 16 ) );
 #endif // HCF_ASSERT_SW_SUP
 
-#if (HCF_EXT) & HCF_EXT_MB && (HCF_ASSERT) & HCF_ASSERT_MB
+#if (HCF_ASSERT) & HCF_ASSERT_MB
 		ifbp->IFB_AssertLvl = 0;                                    // prevent recursive behavior
 		hcf_put_info( ifbp, (LTVP)&ifbp->IFB_AssertStrct );
 		ifbp->IFB_AssertLvl = run_time_flag;                        // restore appropriate filter level
-#endif // HCF_EXT_MB / HCF_ASSERT_MB
+#endif // HCF_ASSERT_MB
 	}
 } // mdd_assert
 #endif // HCF_ASSERT
@@ -4619,7 +4610,6 @@ put_info( IFBP ifbp, LTVP ltvp  )
  *.ENDDOC                END DOCUMENTATION
  *
  ************************************************************************************************************/
-#if (HCF_EXT) & HCF_EXT_MB
 
 HCF_STATIC int
 put_info_mb( IFBP ifbp, CFG_MB_INFO_STRCT FAR * ltvp )
@@ -4677,8 +4667,6 @@ put_info_mb( IFBP ifbp, CFG_MB_INFO_STRCT FAR * ltvp )
 	return rc;
 } // put_info_mb
 
-#endif // HCF_EXT_MB
-
 
 /************************************************************************************************************
  *
diff --git a/drivers/staging/wlags49_h2/hcf.h b/drivers/staging/wlags49_h2/hcf.h
index cf55e8e..0009947 100644
--- a/drivers/staging/wlags49_h2/hcf.h
+++ b/drivers/staging/wlags49_h2/hcf.h
@@ -301,13 +301,11 @@ typedef struct  {
 #if (HCF_EXT) & HCF_EXT_INT_TICK
   int			IFB_TickCnt;			// Hermes Timer Tick Counter
 #endif // HCF_EXT_INT_TICK
-#if (HCF_EXT) & HCF_EXT_MB
   hcf_16 	   *IFB_MBp;				// pointer to the MailBox
   hcf_16		IFB_MBSize;				// size of the MailBox
   hcf_16		IFB_MBWp;				// zero-based write index into the MailBox
   hcf_16		IFB_MBRp;				// zero-based read  index into the MailBox
   hcf_16		IFB_MBInfoLen;			// contents of L-field of the oldest available MailBoxInfoBlock
-#endif // HCF_EXT_MB
 #if (HCF_TYPE) & HCF_TYPE_WPA
   hcf_16		IFB_MICTxCntl;			// MIC bit and Key index in TxControl field of TxFS
   hcf_32		IFB_MICTxKey[2];		// calculating key
-- 
1.7.4.1

