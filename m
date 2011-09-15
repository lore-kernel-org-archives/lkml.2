Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935489Ab1IOX3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:29:36 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:62768 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935477Ab1IOX3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:29:34 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 08/13] staging: wlags49_h2: Remove references to SSN
Date: Fri, 16 Sep 2011 00:20:52 +0100
Message-Id: <1316128857-9781-9-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
References: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SSN seems to be an old abbreviation for WPA. Remove all references.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/hcf.c    |   10 +++++-----
 drivers/staging/wlags49_h2/hcfdef.h |    4 ----
 drivers/staging/wlags49_h2/mdd.h    |    6 +++---
 3 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index 0ec0229..c46ad30 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -2329,7 +2329,7 @@ hcf_put_info( IFBP ifbp, LTVP ltvp )
  *               of frame).
  *
  *.RETURNS
- *   HCF_SUCCESS         No SSN error ( or HCF_ERR_MIC already reported by hcf_service_nic)
+ *   HCF_SUCCESS         No WPA error ( or HCF_ERR_MIC already reported by hcf_service_nic)
  *   HCF_ERR_MIC         message contains an erroneous MIC ( HCF_SUCCESS is reported if HCF_ERR_MIC is already
  *                       reported by hcf_service_nic)
  *   HCF_ERR_NO_NIC      NIC removed during data retrieval
@@ -2592,10 +2592,10 @@ hcf_rcv_msg( IFBP ifbp, DESC_STRCT *descp, unsigned int offset )
  *7: The ControlField of the TxFS is written.  Since put_frag can only return the fatal Defunct or "No NIC", the
  *   return status can be ignored because when it fails, cmd_wait will fail as well.  (see also the note on the
  *   need for a return code below).
- *   Note that HFS_TX_CNTL has different values for H-I, H-I/SSN and H-II and HFS_ADDR_DEST has different
- *   values for H-I (regardless of SSN) and H-II.
+ *   Note that HFS_TX_CNTL has different values for H-I, H-I/WPA and H-II and HFS_ADDR_DEST has different
+ *   values for H-I (regardless of WPA) and H-II.
  *   By writing 17, 1 or 2 ( implying 16, 0 or 1 garbage word after HFS_TX_CNTL) the BAP just gets to
- *   HFS_ADDR_DEST for H-I, H-I/SSN and H-II respectively.
+ *   HFS_ADDR_DEST for H-I, H-I/WPA and H-II respectively.
  *10: if neither encapsulation nor MIC calculation is needed, splitting the first fragment in two does not
  *   really help but it makes the flow easier to follow to do not optimize on this difference
  *
@@ -2985,7 +2985,7 @@ or
 *   compensated for the SNAP header length.
 *   The 22 bytes needed for decapsulation are (more than) sufficient for the exceptional handling of the
 *   MIC algorithm of the L-field (replacing the 2 byte L-field with 4 0x00 bytes).
-*30: The 12 in the no-SSN branch corresponds with the get_frag, the 2 with the IPW of the SSN branch
+*30: The 12 in the no-WPA branch corresponds with the get_frag, the 2 with the IPW of the WPA branch
 *32: If Hermes reported MIC-presence, than the MIC engine is initialized with the non-dummy MIC calculation
 *   routine address and appropriate key.
 *34: The 8 bytes after the DA, SA, L are read and it is checked whether decapsulation is needed i.e.:
diff --git a/drivers/staging/wlags49_h2/hcfdef.h b/drivers/staging/wlags49_h2/hcfdef.h
index fe003ed..8fb870dc 100644
--- a/drivers/staging/wlags49_h2/hcfdef.h
+++ b/drivers/staging/wlags49_h2/hcfdef.h
@@ -592,15 +592,11 @@ err: ;
 #if (HCF_TYPE) & HCF_TYPE_WPA
 #define CALC_RX_MIC( p, len ) calc_mic_rx_frag( ifbp, p, len )
 #define CALC_TX_MIC( p, len ) calc_mic_tx_frag( ifbp, p, len )
-#define IF_SSN(x)  x
-#define IF_NOT_SSN(x)
 #else
 #define CALC_RX_MIC( p, len )
 #define CALC_TX_MIC( p, len )
 #define MIC_RX_RTN( mic, dw )
 #define MIC_TX_RTN( mic, dw )
-#define IF_SSN(x)
-#define IF_NOT_SSN(x) x
 #endif // HCF_TYPE_WPA
 
 #if HCF_TALLIES & HCF_TALLIES_HCF       //HCF tally support
diff --git a/drivers/staging/wlags49_h2/mdd.h b/drivers/staging/wlags49_h2/mdd.h
index 5aa9eb8..acdeacd 100644
--- a/drivers/staging/wlags49_h2/mdd.h
+++ b/drivers/staging/wlags49_h2/mdd.h
@@ -444,7 +444,7 @@ XX1( CFG_DEFAULT_KEYS,			KEY_STRCT, key[4]			 )	/*defines set of encryption keys
 		 tx_mic_key[4], rx_mic_key[4] 						 )	/*										       		*/
  X6( CFG_ADD_TKIP_MAPPED_KEY,	bssid[3], tkip_key[8], 		 \
 		 tsc[4], rsc[4], tx_mic_key[4], rx_mic_key[4] 		 )	/*										       		*/
- X1( CFG_SET_SSN_AUTHENTICATION_SUITE, 						 \
+ X1( CFG_SET_WPA_AUTHENTICATION_SUITE, 						 \
 		 ssn_authentication_suite							 )	/*											   		*/
  X1( CFG_REMOVE_TKIP_DEFAULT_KEY,tkip_key_id				 )	/*											   		*/
  X1( CFG_TICK_TIME,				tick_time					 )	/*Auxiliary Timer tick interval						*/
@@ -525,7 +525,7 @@ X2( CFG_WOL_PATTERNS, nPatterns, buffer[WOL_BUF_SIZE]		 )  /*[STA] WakeOnLan pat
  X1( CFG_OWN_MAC_ADDR,			mac_addr[3]							 ) /*[AP] Unique local node MAC Address						*/
  X3( CFG_PCF_INFO,				medium_occupancy_limit, 			 \
 		 						cfp_period, cfp_max_duration 		 ) /*[AP] Point Coordination Function capability info		*/
- X1( CFG_CUR_SSN_INFO_ELEMENT, ssn_info_element[1]				 	 ) /*    													*/
+ X1( CFG_CUR_WPA_INFO_ELEMENT, ssn_info_element[1]				 	 ) /*    													*/
  X4( CFG_CUR_TKIP_IV_INFO, 											 \
 		 tkip_seq_cnt0[4], tkip_seq_cnt1[4], 						 \
 		 tkip_seq_cnt2[4], tkip_seq_cnt3[4]  						 ) /*    													*/
@@ -802,7 +802,7 @@ XX1( CFG_SCAN,					SCAN_RS_STRCT, scan_result[32]		 ) /*Scan results											*
 #define CFG_PCF_INFO					0xFD87	//[AP] Point Coordination Function capability info
 //*RESERVED* #define CFG_HIGHEST_BASIC_RATE			0xFD88	//
 #define CFG_CUR_COUNTRY_INFO			0xFD89	//
-#define CFG_CUR_SSN_INFO_ELEMENT		0xFD8A	//
+#define CFG_CUR_WPA_INFO_ELEMENT		0xFD8A	//
 #define CFG_CUR_TKIP_IV_INFO			0xFD8B	//
 #define CFG_CUR_ASSOC_REQ_INFO			0xFD8C	//
 #define CFG_CUR_ASSOC_RESP_INFO			0xFD8D	//
-- 
1.7.4.1

