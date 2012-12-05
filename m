Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964777Ab2LEUvp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 15:51:45 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:37434 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754057Ab2LEUvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 15:51:31 -0500
From: Sebastian Hahn <snsehahn@cip.cs.fau.de>
To: gregkh@linuxfoundation.org
Cc: Jennifer.Naumann@informatik.stud.uni-erlangen.de, dan.carpenter@oracle.com,
        standby24x7@gmail.com, Julia.Lawall@lip6.fr, jkosina@suse.cz,
        joe@perches.com, yongjun_wei@trendmicro.com.cn,
        adam.buchbinder@gmail.com, amwang@redhat.com, justinmattock@gmail.com,
        wfp5p@virginia.edu, jim.cromie@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        linux-kernel@i4.informatik.uni-erlangen.de,
        Sebastian Hahn <snsehahn@cip.cs.fau.de>
Subject: [PATCH 1/6] staging/rtl8192u: cleanfile run
Date: Wed,  5 Dec 2012 21:40:18 +0100
Message-Id: <1354740023-30849-2-git-send-email-snsehahn@cip.cs.fau.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354740023-30849-1-git-send-email-snsehahn@cip.cs.fau.de>
References: <1354740023-30849-1-git-send-email-snsehahn@cip.cs.fau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Run cleanfile on all files inside drivers/staging/rtl819u

Signed-off-by: Sebastian Hahn <snsehahn@cip.cs.fau.de>
Signed-off-by: Jennifer Naumann <Jennifer.Naumann@informatik.stud.uni-erlangen.de>
---
 drivers/staging/rtl8192u/changes                   |    1 -
 drivers/staging/rtl8192u/ieee80211/Makefile        |    1 -
 drivers/staging/rtl8192u/ieee80211/aes.c           |    3 +-
 drivers/staging/rtl8192u/ieee80211/arc4.c          |    2 +-
 drivers/staging/rtl8192u/ieee80211/crypto_compat.h |    2 -
 drivers/staging/rtl8192u/ieee80211/dot11d.c        |    1 -
 drivers/staging/rtl8192u/ieee80211/ieee80211.h     |   76 +-
 .../staging/rtl8192u/ieee80211/ieee80211_module.c  |    4 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |   24 +-
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c  |    8 +-
 drivers/staging/rtl8192u/ieee80211/internal.h      |    1 -
 drivers/staging/rtl8192u/ieee80211/rtl819x_BA.h    |    3 +-
 .../staging/rtl8192u/ieee80211/rtl819x_BAProc.c    |   63 +-
 drivers/staging/rtl8192u/ieee80211/rtl819x_HT.h    |   13 +-
 .../staging/rtl8192u/ieee80211/rtl819x_HTProc.c    |  124 +--
 drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h   |   32 +-
 drivers/staging/rtl8192u/ieee80211/rtl819x_TS.h    |    3 +-
 .../staging/rtl8192u/ieee80211/rtl819x_TSProc.c    |   18 +-
 drivers/staging/rtl8192u/ieee80211/rtl_crypto.h    |    9 +-
 drivers/staging/rtl8192u/r8190_rtl8256.c           |   13 +-
 drivers/staging/rtl8192u/r8192U.h                  |   74 +-
 drivers/staging/rtl8192u/r8192U_core.c             |   74 +-
 drivers/staging/rtl8192u/r8192U_dm.c               |  161 ++-
 drivers/staging/rtl8192u/r8192U_dm.h               |   15 +-
 drivers/staging/rtl8192u/r8192U_hw.h               |   16 +-
 drivers/staging/rtl8192u/r8192U_wx.c               |   22 +-
 drivers/staging/rtl8192u/r819xU_HTGen.h            |    1 -
 drivers/staging/rtl8192u/r819xU_HTType.h           |    9 +-
 drivers/staging/rtl8192u/r819xU_cmdpkt.c           |   38 +-
 drivers/staging/rtl8192u/r819xU_cmdpkt.h           |   26 +-
 drivers/staging/rtl8192u/r819xU_firmware.c         |   13 +-
 drivers/staging/rtl8192u/r819xU_firmware.h         |    1 -
 drivers/staging/rtl8192u/r819xU_phy.c              |   49 +-
 drivers/staging/rtl8192u/r819xU_phyreg.h           | 1044 ++++++++++----------
 35 files changed, 963 insertions(+), 983 deletions(-)

diff --git a/drivers/staging/rtl8192u/changes b/drivers/staging/rtl8192u/changes
index 87c33fd..0485d6e 100644
--- a/drivers/staging/rtl8192u/changes
+++ b/drivers/staging/rtl8192u/changes
@@ -2,4 +2,3 @@ v 0.1
 
 First version.
 This is based on the rtl8180-sa2400 pre-0.22-CVS code..
-
diff --git a/drivers/staging/rtl8192u/ieee80211/Makefile b/drivers/staging/rtl8192u/ieee80211/Makefile
index 51effd6..b5d0c2e 100644
--- a/drivers/staging/rtl8192u/ieee80211/Makefile
+++ b/drivers/staging/rtl8192u/ieee80211/Makefile
@@ -25,4 +25,3 @@ obj-m +=ieee80211_crypt-rsl.o
 obj-m +=ieee80211_crypt_wep-rsl.o
 obj-m +=ieee80211_crypt_tkip-rsl.o
 obj-m +=ieee80211_crypt_ccmp-rsl.o
-
diff --git a/drivers/staging/rtl8192u/ieee80211/aes.c b/drivers/staging/rtl8192u/ieee80211/aes.c
index a6bb6c9..abc1023 100644
--- a/drivers/staging/rtl8192u/ieee80211/aes.c
+++ b/drivers/staging/rtl8192u/ieee80211/aes.c
@@ -443,7 +443,7 @@ static struct crypto_alg aes_alg = {
 		.cipher = {
 			.cia_min_keysize	=	AES_MIN_KEY_SIZE,
 			.cia_max_keysize	=	AES_MAX_KEY_SIZE,
-			.cia_setkey		= 	aes_set_key,
+			.cia_setkey		=	aes_set_key,
 			.cia_encrypt		=	aes_encrypt,
 			.cia_decrypt		=	aes_decrypt
 		}
@@ -466,4 +466,3 @@ module_exit(aes_fini);
 
 MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm");
 MODULE_LICENSE("Dual BSD/GPL");
-
diff --git a/drivers/staging/rtl8192u/ieee80211/arc4.c b/drivers/staging/rtl8192u/ieee80211/arc4.c
index e3ad8d2..b790e9a 100644
--- a/drivers/staging/rtl8192u/ieee80211/arc4.c
+++ b/drivers/staging/rtl8192u/ieee80211/arc4.c
@@ -79,7 +79,7 @@ static struct crypto_alg arc4_alg = {
 	.cra_u			=	{ .cipher = {
 	.cia_min_keysize	=	ARC4_MIN_KEY_SIZE,
 	.cia_max_keysize	=	ARC4_MAX_KEY_SIZE,
-	.cia_setkey		= 	arc4_set_key,
+	.cia_setkey		=	arc4_set_key,
 	.cia_encrypt		=	arc4_crypt,
 	.cia_decrypt		=	arc4_crypt } }
 };
diff --git a/drivers/staging/rtl8192u/ieee80211/crypto_compat.h b/drivers/staging/rtl8192u/ieee80211/crypto_compat.h
index da48658..2ba374a 100644
--- a/drivers/staging/rtl8192u/ieee80211/crypto_compat.h
+++ b/drivers/staging/rtl8192u/ieee80211/crypto_compat.h
@@ -56,5 +56,3 @@ static inline int crypto_cipher_decrypt(struct crypto_tfm *tfm,
 }
 //EXPORT_SYMBOL_GPL(crypto_alloc_tfm);
 //EXPORT_SYMBOL_GPL(crypto_free_tfm);
-
-
diff --git a/drivers/staging/rtl8192u/ieee80211/dot11d.c b/drivers/staging/rtl8192u/ieee80211/dot11d.c
index ce63fc3..f10fd5a 100644
--- a/drivers/staging/rtl8192u/ieee80211/dot11d.c
+++ b/drivers/staging/rtl8192u/ieee80211/dot11d.c
@@ -218,4 +218,3 @@ EXPORT_SYMBOL(DOT11D_GetMaxTxPwrInDbm);
 EXPORT_SYMBOL(DOT11D_ScanComplete);
 EXPORT_SYMBOL(IsLegalChannel);
 EXPORT_SYMBOL(ToLegalChannel);
-
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211.h b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
index 502bfdb..bb0e4fe 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211.h
@@ -64,7 +64,7 @@
 #endif
 
 #define KEY_TYPE_NA		0x0
-#define KEY_TYPE_WEP40 		0x1
+#define KEY_TYPE_WEP40		0x1
 #define KEY_TYPE_TKIP		0x2
 #define KEY_TYPE_CCMP		0x4
 #define KEY_TYPE_WEP104		0x5
@@ -195,21 +195,21 @@ enum	_ReasonCode{
 	auth_not_valid	= 0x2,
 	deauth_lv_ss	= 0x3,
 	inactivity		= 0x4,
-	ap_overload 	= 0x5,
+	ap_overload	= 0x5,
 	class2_err		= 0x6,
 	class3_err		= 0x7,
-	disas_lv_ss 	= 0x8,
+	disas_lv_ss	= 0x8,
 	asoc_not_auth	= 0x9,
 
 	//----MIC_CHECK
-	mic_failure 	= 0xe,
+	mic_failure	= 0xe,
 	//----END MIC_CHECK
 
 	// Reason code defined in 802.11i D10.0 p.28.
 	invalid_IE		= 0x0d,
 	four_way_tmout	= 0x0f,
 	two_way_tmout	= 0x10,
-	IE_dismatch 	= 0x11,
+	IE_dismatch	= 0x11,
 	invalid_Gcipher = 0x12,
 	invalid_Pcipher = 0x13,
 	invalid_AKMP	= 0x14,
@@ -222,7 +222,7 @@ enum	_ReasonCode{
 	QoS_unspec		= 0x20, // 32
 	QAP_bandwidth	= 0x21, // 33
 	poor_condition	= 0x22, // 34
-	no_facility 	= 0x23, // 35
+	no_facility	= 0x23, // 35
 							// Where is 36???
 	req_declined	= 0x25, // 37
 	invalid_param	= 0x26, // 38
@@ -265,7 +265,7 @@ enum	_ReasonCode{
 #define IEEE_WPAX_USEGROUP			0
 #define IEEE_WPAX_WEP40				1
 #define IEEE_WPAX_TKIP				2
-#define IEEE_WPAX_WRAP   			3
+#define IEEE_WPAX_WRAP				3
 #define IEEE_WPAX_CCMP				4
 #define IEEE_WPAX_WEP104			5
 
@@ -289,12 +289,12 @@ enum	_ReasonCode{
 #define MAX_IE_LEN  0xff
 
 // added for kernel conflict
-#define ieee80211_crypt_deinit_entries 	ieee80211_crypt_deinit_entries_rsl
-#define ieee80211_crypt_deinit_handler 	ieee80211_crypt_deinit_handler_rsl
-#define ieee80211_crypt_delayed_deinit 	ieee80211_crypt_delayed_deinit_rsl
-#define ieee80211_register_crypto_ops  	ieee80211_register_crypto_ops_rsl
+#define ieee80211_crypt_deinit_entries	ieee80211_crypt_deinit_entries_rsl
+#define ieee80211_crypt_deinit_handler	ieee80211_crypt_deinit_handler_rsl
+#define ieee80211_crypt_delayed_deinit	ieee80211_crypt_delayed_deinit_rsl
+#define ieee80211_register_crypto_ops	ieee80211_register_crypto_ops_rsl
 #define ieee80211_unregister_crypto_ops ieee80211_unregister_crypto_ops_rsl
-#define ieee80211_get_crypto_ops 	ieee80211_get_crypto_ops_rsl
+#define ieee80211_get_crypto_ops	ieee80211_get_crypto_ops_rsl
 
 #define ieee80211_ccmp_null		ieee80211_ccmp_null_rsl
 
@@ -302,10 +302,10 @@ enum	_ReasonCode{
 
 #define ieee80211_wep_null		ieee80211_wep_null_rsl
 
-#define free_ieee80211          	free_ieee80211_rsl
-#define alloc_ieee80211        		alloc_ieee80211_rsl
+#define free_ieee80211			free_ieee80211_rsl
+#define alloc_ieee80211			alloc_ieee80211_rsl
 
-#define ieee80211_rx 			ieee80211_rx_rsl
+#define ieee80211_rx			ieee80211_rx_rsl
 #define ieee80211_rx_mgt		ieee80211_rx_mgt_rsl
 
 #define ieee80211_get_beacon		ieee80211_get_beacon_rsl
@@ -450,7 +450,7 @@ typedef struct ieee_param {
 
 /* management */
 #define IEEE80211_STYPE_ASSOC_REQ	0x0000
-#define IEEE80211_STYPE_ASSOC_RESP 	0x0010
+#define IEEE80211_STYPE_ASSOC_RESP	0x0010
 #define IEEE80211_STYPE_REASSOC_REQ	0x0020
 #define IEEE80211_STYPE_REASSOC_RESP	0x0030
 #define IEEE80211_STYPE_PROBE_REQ	0x0040
@@ -536,7 +536,7 @@ do { if (ieee80211_debug_level & (level)) \
 //if you want print DATA buffer related BA, please set ieee80211_debug_level to DATA|BA
 #define IEEE80211_DEBUG_DATA(level, data, datalen)	\
 	do{ if ((ieee80211_debug_level & (level)) == (level))	\
-		{ 	\
+		{	\
 			int i;					\
 			u8* pdata = (u8*) data;			\
 			printk(KERN_DEBUG "ieee80211: %s()\n", __FUNCTION__);	\
@@ -623,20 +623,20 @@ do { if (ieee80211_debug_level & (level)) \
 #define MAX_STR_LEN     64
 /* I want to see ASCII 33 to 126 only. Otherwise, I print '?'. Annie, 2005-11-22.*/
 #define PRINTABLE(_ch)  (_ch>'!' && _ch<'~')
-#define IEEE80211_PRINT_STR(_Comp, _TitleString, _Ptr, _Len)                            	\
-			if((_Comp) & level)   							\
+#define IEEE80211_PRINT_STR(_Comp, _TitleString, _Ptr, _Len)					\
+			if((_Comp) & level)							\
 			{                                                                       \
 				int             __i;                                            \
-				u8  buffer[MAX_STR_LEN];                                    	\
-				int length = (_Len<MAX_STR_LEN)? _Len : (MAX_STR_LEN-1) ;  	\
-				memset(buffer, 0, MAX_STR_LEN);                      		\
-				memcpy(buffer, (u8 *)_Ptr, length );            		\
+				u8  buffer[MAX_STR_LEN];					\
+				int length = (_Len<MAX_STR_LEN)? _Len : (MAX_STR_LEN-1) ;	\
+				memset(buffer, 0, MAX_STR_LEN);					\
+				memcpy(buffer, (u8 *)_Ptr, length );				\
 				for( __i=0; __i<MAX_STR_LEN; __i++ )                            \
 				{                                                               \
-				     if( !PRINTABLE(buffer[__i]) )   buffer[__i] = '?';     	\
+				     if( !PRINTABLE(buffer[__i]) )   buffer[__i] = '?';		\
 				}                                                               \
 				buffer[length] = '\0';                                          \
-				printk("Rtl819x: ");                                         	\
+				printk("Rtl819x: ");						\
 				printk(_TitleString);                                         \
 				printk(": %d, <%s>\n", _Len, buffer);                         \
 			}
@@ -785,12 +785,12 @@ enum ieee80211_reasoncode {
 #define IEEE80211_24GHZ_BAND     (1<<0)
 #define IEEE80211_52GHZ_BAND     (1<<1)
 
-#define IEEE80211_CCK_RATE_LEN  		4
+#define IEEE80211_CCK_RATE_LEN			4
 #define IEEE80211_CCK_RATE_1MB			0x02
 #define IEEE80211_CCK_RATE_2MB			0x04
 #define IEEE80211_CCK_RATE_5MB			0x0B
 #define IEEE80211_CCK_RATE_11MB			0x16
-#define IEEE80211_OFDM_RATE_LEN 		8
+#define IEEE80211_OFDM_RATE_LEN			8
 #define IEEE80211_OFDM_RATE_6MB			0x0C
 #define IEEE80211_OFDM_RATE_9MB			0x12
 #define IEEE80211_OFDM_RATE_12MB		0x18
@@ -919,10 +919,10 @@ struct ieee80211_rx_stats {
 	u16          fraglength;                        // FragLength should equal to PacketLength in non-fragment case
 	u16          fragoffset;                        // Data offset for this fragment
 	u16          ntotalfrag;
-	bool      	  bisrxaggrsubframe;
+	bool		  bisrxaggrsubframe;
 	bool		  bPacketBeacon;	//cosa add for rssi
 	bool		  bToSelfBA;		//cosa add for rssi
-	char 	  cck_adc_pwdb[4];	//cosa add for rx path selection
+	char	  cck_adc_pwdb[4];	//cosa add for rx path selection
 	u16		  Seq_Num;
 
 };
@@ -992,7 +992,7 @@ struct ieee80211_device;
 #define SEC_ALG_TKIP            2
 #define SEC_ALG_CCMP            3
 
-#define WEP_KEYS 		4
+#define WEP_KEYS		4
 #define WEP_KEY_LEN		13
 #define SCM_KEY_LEN             32
 #define SCM_TEMPORAL_KEY_LENGTH 16
@@ -1205,7 +1205,7 @@ struct ieee80211_drv_agg_txb {
 	struct sk_buff *tx_agg_frames[MAX_TX_AGG_COUNT];
 }__attribute__((packed));
 
-#define MAX_SUBFRAME_COUNT 		  64
+#define MAX_SUBFRAME_COUNT		  64
 struct ieee80211_rxb {
 	u8 nr_subframes;
 	struct sk_buff *subframes[MAX_SUBFRAME_COUNT];
@@ -1534,7 +1534,7 @@ struct ieee80211_network {
 	bool	bWithAironetIE;
 	bool	bCkipSupported;
 	bool	bCcxRmEnable;
-	u16 	CcxRmState[2];
+	u16	CcxRmState[2];
 	// CCXv4 S59, MBSSID.
 	bool	bMBssidValid;
 	u8	MBssidMask;
@@ -1726,7 +1726,7 @@ typedef struct _RT_POWER_SAVE_CONTROL
 	bool				bIPSModeBackup;
 	bool				bSwRfProcessing;
 	RT_RF_POWER_STATE	eInactivePowerState;
-	struct work_struct 	InactivePsWorkItem;
+	struct work_struct	InactivePsWorkItem;
 	struct timer_list	InactivePsTimer;
 
 	// Return point for join action
@@ -1837,11 +1837,11 @@ struct ieee80211_device {
 	u8				HTHighestOperaRate;
 	//wb added for rate operation mode to firmware
 	u8	bTxDisableRateFallBack;
-	u8 	bTxUseDriverAssingedRate;
+	u8	bTxUseDriverAssingedRate;
 	atomic_t	atm_chnlop;
 	atomic_t	atm_swbw;
 //	u8	HTHighestOperaRate;
-//	u8 	HTCurrentOperaRate;
+//	u8	HTCurrentOperaRate;
 
 	// 802.11e and WMM Traffic Stream Info (TX)
 	struct list_head		Tx_TS_Admit_List;
@@ -2055,9 +2055,9 @@ struct ieee80211_device {
 	bool	bdynamic_txpower_enable;
 
 	bool bCTSToSelfEnable;
-	u8 	CTSToSelfTH;
+	u8	CTSToSelfTH;
 
-	u32 	fsync_time_interval;
+	u32	fsync_time_interval;
 	u32	fsync_rate_bitmap;
 	u8	fsync_rssi_threshold;
 	bool	bfsync_enable;
@@ -2214,7 +2214,7 @@ struct ieee80211_device {
 #define IEEE_A            (1<<0)
 #define IEEE_B            (1<<1)
 #define IEEE_G            (1<<2)
-#define IEEE_N_24G 		  (1<<4)
+#define IEEE_N_24G		  (1<<4)
 #define	IEEE_N_5G		  (1<<5)
 #define IEEE_MODE_MASK    (IEEE_A|IEEE_B|IEEE_G)
 
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
index 82d4bf6..c673adc 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
@@ -233,9 +233,9 @@ static int debug = \
 	//		    IEEE80211_DL_TX	|
 	//		    IEEE80211_DL_RX	|
 			    //IEEE80211_DL_QOS    |
-	//		    IEEE80211_DL_HT 	|
+	//		    IEEE80211_DL_HT	|
 	//		    IEEE80211_DL_TS	|
-//			    IEEE80211_DL_BA 	|
+//			    IEEE80211_DL_BA	|
 	//		    IEEE80211_DL_REORDER|
 //			    IEEE80211_DL_TRACE  |
 			    //IEEE80211_DL_DATA	|
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index e3cf7a4..8e58647 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -608,7 +608,7 @@ void RxReorderIndicatePacket( struct ieee80211_device *ieee,
 		u16			SeqNum)
 {
 	PRT_HIGH_THROUGHPUT	pHTInfo = ieee->pHTInfo;
-	PRX_REORDER_ENTRY 	pReorderEntry = NULL;
+	PRX_REORDER_ENTRY	pReorderEntry = NULL;
 	struct ieee80211_rxb* prxbIndicateArray[REORDER_WIN_SIZE];
 	u8			WinSize = pHTInfo->RxReorderWinSize;
 	u16			WinEnd = (pTS->RxIndicateSeq + WinSize -1)%4096;
@@ -1043,7 +1043,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 		{
 
 		//	IEEE80211_DEBUG(IEEE80211_DL_REORDER,"%s(): pRxTS->RxLastFragNum is %d,frag is %d,pRxTS->RxLastSeqNum is %d,seq is %d\n",__FUNCTION__,pRxTS->RxLastFragNum,frag,pRxTS->RxLastSeqNum,WLAN_GET_SEQ_SEQ(sc));
-			if( 	(fc & (1<<11))  &&
+			if(	(fc & (1<<11))  &&
 					(frag == pRxTS->RxLastFragNum) &&
 					(WLAN_GET_SEQ_SEQ(sc) == pRxTS->RxLastSeqNum)	)
 			{
@@ -1839,12 +1839,12 @@ int ieee80211_parse_info_param(struct ieee80211_device *ieee,
 				   info_element->data[3] == 0x033){
 
 						tmp_htcap_len = min(info_element->len,(u8)MAX_IE_LEN);
-				   		if(tmp_htcap_len != 0){
-				   			network->bssht.bdHTSpecVer = HT_SPEC_VER_EWC;
+						if(tmp_htcap_len != 0){
+							network->bssht.bdHTSpecVer = HT_SPEC_VER_EWC;
 							network->bssht.bdHTCapLen = tmp_htcap_len > sizeof(network->bssht.bdHTCapBuf)?\
 								sizeof(network->bssht.bdHTCapBuf):tmp_htcap_len;
 							memcpy(network->bssht.bdHTCapBuf,info_element->data,network->bssht.bdHTCapLen);
-				   		}
+						}
 				}
 				if(tmp_htcap_len != 0)
 					network->bssht.bdSupportHT = true;
@@ -1856,9 +1856,9 @@ int ieee80211_parse_info_param(struct ieee80211_device *ieee,
 			if(tmp_htinfo_len == 0){
 				if(info_element->len >= 4 &&
 					info_element->data[0] == 0x00 &&
-				   	info_element->data[1] == 0x90 &&
-				   	info_element->data[2] == 0x4c &&
-				   	info_element->data[3] == 0x034){
+					info_element->data[1] == 0x90 &&
+					info_element->data[2] == 0x4c &&
+					info_element->data[3] == 0x034){
 
 						tmp_htinfo_len = min(info_element->len,(u8)MAX_IE_LEN);
 						if(tmp_htinfo_len != 0){
@@ -2060,7 +2060,7 @@ int ieee80211_parse_info_param(struct ieee80211_device *ieee,
 				if(	(info_element->data[IE_CISCO_FLAG_POSITION]&SUPPORT_CKIP_MIC)	||
 					(info_element->data[IE_CISCO_FLAG_POSITION]&SUPPORT_CKIP_PK)	)
 				{
-		 			network->bCkipSupported = true;
+					network->bCkipSupported = true;
 				}
 				else
 				{
@@ -2070,7 +2070,7 @@ int ieee80211_parse_info_param(struct ieee80211_device *ieee,
 			else
 			{
 				network->bWithAironetIE = false;
-		 		network->bCkipSupported = false;
+				network->bCkipSupported = false;
 			}
 			break;
 		case MFIE_TYPE_QOS_PARAMETER:
@@ -2230,8 +2230,8 @@ static inline int ieee80211_network_init(
 	} else
 		network->flags |= NETWORK_HAS_CCK;
 
- 	network->wpa_ie_len = 0;
- 	network->rsn_ie_len = 0;
+	network->wpa_ie_len = 0;
+	network->rsn_ie_len = 0;
 
         if (ieee80211_parse_info_param
             (ieee,beacon->info_element, stats->len - sizeof(*beacon), network, stats))
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index 7a07078..2c2bd00 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -3124,7 +3124,7 @@ inline struct sk_buff *ieee80211_disassociate_skb(
 void
 SendDisassociation(
 		struct ieee80211_device *ieee,
-		u8* 					asSta,
+		u8*					asSta,
 		u8						asRsn
 )
 {
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
index 3f5ceeb..918dee7 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
@@ -395,7 +395,7 @@ ieee80211_query_HTCapShortGI(struct ieee80211_device *ieee, cb_desc *tcb_desc)
 {
 	PRT_HIGH_THROUGHPUT		pHTInfo = ieee->pHTInfo;
 
-	tcb_desc->bUseShortGI 		= false;
+	tcb_desc->bUseShortGI		= false;
 
 	if(!pHTInfo->bCurrentHTSupport||!pHTInfo->bEnableHT)
 		return;
@@ -514,7 +514,7 @@ void ieee80211_query_protectionmode(struct ieee80211_device* ieee, cb_desc* tcb_
 			if(pHTInfo->IOTAction & HT_IOT_ACT_FORCED_CTS2SELF)
 			{
 				tcb_desc->bCTSEnable	= true;
-				tcb_desc->rts_rate  = 	MGN_24M;
+				tcb_desc->rts_rate  =	MGN_24M;
 				tcb_desc->bRTSEnable = true;
 				break;
 			}
@@ -527,7 +527,7 @@ void ieee80211_query_protectionmode(struct ieee80211_device* ieee, cb_desc* tcb_
 	{
 		tcb_desc->bCTSEnable	= true;
 		tcb_desc->rts_rate = MGN_24M;
-		tcb_desc->bRTSEnable 	= true;
+		tcb_desc->bRTSEnable	= true;
 	}
 	if (ieee->current_network.capability & WLAN_CAPABILITY_SHORT_PREAMBLE)
 		tcb_desc->bUseShortPreamble = true;
@@ -833,7 +833,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 		  else
 			ieee->seq_ctrl[UP2AC(skb->priority) + 1]++;
 		} else {
-  		  if (ieee->seq_ctrl[0] == 0xFFF)
+		  if (ieee->seq_ctrl[0] == 0xFFF)
 			ieee->seq_ctrl[0] = 0;
 		  else
 			ieee->seq_ctrl[0]++;
diff --git a/drivers/staging/rtl8192u/ieee80211/internal.h b/drivers/staging/rtl8192u/ieee80211/internal.h
index bebe13a..6f54cfe 100644
--- a/drivers/staging/rtl8192u/ieee80211/internal.h
+++ b/drivers/staging/rtl8192u/ieee80211/internal.h
@@ -79,4 +79,3 @@ void crypto_exit_cipher_ops(struct crypto_tfm *tfm);
 void crypto_exit_compress_ops(struct crypto_tfm *tfm);
 
 #endif	/* _CRYPTO_INTERNAL_H */
-
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_BA.h b/drivers/staging/rtl8192u/ieee80211/rtl819x_BA.h
index 8ddc8bf9..ffd1c0c 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_BA.h
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_BA.h
@@ -1,7 +1,7 @@
 #ifndef _BATYPE_H_
 #define _BATYPE_H_
 
-#define 	TOTAL_TXBA_NUM	16
+#define		TOTAL_TXBA_NUM	16
 #define	TOTAL_RXBA_NUM	16
 
 #define	BA_SETUP_TIMEOUT	200
@@ -66,4 +66,3 @@ typedef struct _BA_RECORD {
 } BA_RECORD, *PBA_RECORD;
 
 #endif //end _BATYPE_H_
-
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
index 1ebea3d..69735d3 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
@@ -9,8 +9,8 @@
 
 /********************************************************************************************************************
  *function:  Activate BA entry. And if Time is nozero, start timer.
- *   input:  PBA_RECORD 		pBA  //BA entry to be enabled
- *   	     u16 			Time //indicate time delay.
+ *   input:  PBA_RECORD			pBA  //BA entry to be enabled
+ *	     u16			Time //indicate time delay.
  *  output:  none
 ********************************************************************************************************************/
 void ActivateBAEntry(struct ieee80211_device* ieee, PBA_RECORD pBA, u16 Time)
@@ -22,7 +22,7 @@ void ActivateBAEntry(struct ieee80211_device* ieee, PBA_RECORD pBA, u16 Time)
 
 /********************************************************************************************************************
  *function:  deactivate BA entry, including its timer.
- *   input:  PBA_RECORD 		pBA  //BA entry to be disabled
+ *   input:  PBA_RECORD			pBA  //BA entry to be disabled
  *  output:  none
 ********************************************************************************************************************/
 void DeActivateBAEntry( struct ieee80211_device* ieee, PBA_RECORD pBA)
@@ -33,7 +33,7 @@ void DeActivateBAEntry( struct ieee80211_device* ieee, PBA_RECORD pBA)
 /********************************************************************************************************************
  *function: deactivete BA entry in Tx Ts, and send DELBA.
  *   input:
- *   	     PTX_TS_RECORD		pTxTs //Tx Ts which is to deactivate BA entry.
+ *	     PTX_TS_RECORD		pTxTs //Tx Ts which is to deactivate BA entry.
  *  output:  none
  *  notice:  As PTX_TS_RECORD structure will be defined in QOS, so wait to be merged. //FIXME
 ********************************************************************************************************************/
@@ -63,7 +63,7 @@ u8 TxTsDeleteBA( struct ieee80211_device* ieee, PTX_TS_RECORD	pTxTs)
 /********************************************************************************************************************
  *function: deactivete BA entry in Tx Ts, and send DELBA.
  *   input:
- *   	     PRX_TS_RECORD		pRxTs //Rx Ts which is to deactivate BA entry.
+ *	     PRX_TS_RECORD		pRxTs //Rx Ts which is to deactivate BA entry.
  *  output:  none
  *  notice:  As PRX_TS_RECORD structure will be defined in QOS, so wait to be merged. //FIXME, same with above
 ********************************************************************************************************************/
@@ -84,7 +84,7 @@ u8 RxTsDeleteBA( struct ieee80211_device* ieee, PRX_TS_RECORD	pRxTs)
 /********************************************************************************************************************
  *function: reset BA entry
  *   input:
- *   	     PBA_RECORD		pBA //entry to be reset
+ *	     PBA_RECORD		pBA //entry to be reset
  *  output:  none
 ********************************************************************************************************************/
 void ResetBaEntry( PBA_RECORD pBA)
@@ -98,12 +98,12 @@ void ResetBaEntry( PBA_RECORD pBA)
 //These functions need porting here or not?
 /*******************************************************************************************************************************
  *function:  construct ADDBAREQ and ADDBARSP frame here together.
- *   input:  u8* 		Dst 	//ADDBA frame's destination
- *   	     PBA_RECORD 	pBA	//BA_RECORD entry which stores the necessary information for BA.
- *   	     u16 		StatusCode  //status code in RSP and I will use it to indicate whether it's RSP or REQ(will I?)
- *   	     u8			type	//indicate whether it's RSP(ACT_ADDBARSP) ow REQ(ACT_ADDBAREQ)
+ *   input:  u8*		Dst	//ADDBA frame's destination
+ *	     PBA_RECORD		pBA	//BA_RECORD entry which stores the necessary information for BA.
+ *	     u16		StatusCode  //status code in RSP and I will use it to indicate whether it's RSP or REQ(will I?)
+ *	     u8			type	//indicate whether it's RSP(ACT_ADDBARSP) ow REQ(ACT_ADDBAREQ)
  *  output:  none
- *  return:  sk_buff* 		skb     //return constructed skb to xmit
+ *  return:  sk_buff*		skb     //return constructed skb to xmit
 *******************************************************************************************************************************/
 static struct sk_buff* ieee80211_ADDBA(struct ieee80211_device* ieee, u8* Dst, PBA_RECORD pBA, u16 StatusCode, u8 type)
 {
@@ -126,7 +126,7 @@ static struct sk_buff* ieee80211_ADDBA(struct ieee80211_device* ieee, u8* Dst, P
 		return NULL;
 	}
 
-	memset(skb->data, 0, sizeof( struct ieee80211_hdr_3addr));  	//I wonder whether it's necessary. Apparently kernel will not do it when alloc a skb.
+	memset(skb->data, 0, sizeof( struct ieee80211_hdr_3addr));	//I wonder whether it's necessary. Apparently kernel will not do it when alloc a skb.
 	skb_reserve(skb, ieee->tx_headroom);
 
 	BAReq = ( struct ieee80211_hdr_3addr *) skb_put(skb,sizeof( struct ieee80211_hdr_3addr));
@@ -177,12 +177,12 @@ static struct sk_buff* ieee80211_ADDBA(struct ieee80211_device* ieee, u8* Dst, P
 
 /********************************************************************************************************************
  *function:  construct DELBA frame
- *   input:  u8* 		dst 	//DELBA frame's destination
- *   	     PBA_RECORD 	pBA	//BA_RECORD entry which stores the necessary information for BA
- *   	     TR_SELECT	        TxRxSelect  //TX RX direction
- *   	     u16 		ReasonCode  //status code.
+ *   input:  u8*		dst	//DELBA frame's destination
+ *	     PBA_RECORD		pBA	//BA_RECORD entry which stores the necessary information for BA
+ *	     TR_SELECT	        TxRxSelect  //TX RX direction
+ *	     u16		ReasonCode  //status code.
  *  output:  none
- *  return:  sk_buff* 		skb     //return constructed skb to xmit
+ *  return:  sk_buff*		skb     //return constructed skb to xmit
 ********************************************************************************************************************/
 static struct sk_buff* ieee80211_DELBA(
 	struct ieee80211_device* ieee,
@@ -246,8 +246,8 @@ static struct sk_buff* ieee80211_DELBA(
 
 /********************************************************************************************************************
  *function: send ADDBAReq frame out
- *   input:  u8* 		dst 	//ADDBAReq frame's destination
- *   	     PBA_RECORD 	pBA	//BA_RECORD entry which stores the necessary information for BA
+ *   input:  u8*		dst	//ADDBAReq frame's destination
+ *	     PBA_RECORD		pBA	//BA_RECORD entry which stores the necessary information for BA
  *  output:  none
  *  notice: If any possible, please hide pBA in ieee. And temporarily use Manage Queue as softmac_mgmt_xmit() usually does
 ********************************************************************************************************************/
@@ -272,9 +272,9 @@ void ieee80211_send_ADDBAReq(struct ieee80211_device* ieee, u8*	dst, PBA_RECORD
 
 /********************************************************************************************************************
  *function: send ADDBARSP frame out
- *   input:  u8* 		dst 	//DELBA frame's destination
- *   	     PBA_RECORD 	pBA	//BA_RECORD entry which stores the necessary information for BA
- *   	     u16		StatusCode //RSP StatusCode
+ *   input:  u8*		dst	//DELBA frame's destination
+ *	     PBA_RECORD		pBA	//BA_RECORD entry which stores the necessary information for BA
+ *	     u16		StatusCode //RSP StatusCode
  *  output:  none
  *  notice: If any possible, please hide pBA in ieee. And temporarily use Manage Queue as softmac_mgmt_xmit() usually does
 ********************************************************************************************************************/
@@ -297,10 +297,10 @@ void ieee80211_send_ADDBARsp(struct ieee80211_device* ieee, u8* dst, PBA_RECORD
 }
 /********************************************************************************************************************
  *function: send ADDBARSP frame out
- *   input:  u8* 		dst 	//DELBA frame's destination
- *   	     PBA_RECORD 	pBA	//BA_RECORD entry which stores the necessary information for BA
- *   	     TR_SELECT          TxRxSelect //TX or RX
- *   	     u16		ReasonCode //DEL ReasonCode
+ *   input:  u8*		dst	//DELBA frame's destination
+ *	     PBA_RECORD		pBA	//BA_RECORD entry which stores the necessary information for BA
+ *	     TR_SELECT          TxRxSelect //TX or RX
+ *	     u16		ReasonCode //DEL ReasonCode
  *  output:  none
  *  notice: If any possible, please hide pBA in ieee. And temporarily use Manage Queue as softmac_mgmt_xmit() usually does
 ********************************************************************************************************************/
@@ -340,7 +340,7 @@ int ieee80211_rx_ADDBAReq( struct ieee80211_device* ieee, struct sk_buff *skb)
 
 	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 9)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BAREQ(%d / %zu)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 9));
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BAREQ(%d / %zu)\n", skb->len,	(sizeof( struct ieee80211_hdr_3addr) + 9));
 		return -1;
 	}
 
@@ -439,7 +439,7 @@ int ieee80211_rx_ADDBARsp( struct ieee80211_device* ieee, struct sk_buff *skb)
 
 	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 9)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BARSP(%d / %zu)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 9));
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in BARSP(%d / %zu)\n", skb->len,	(sizeof( struct ieee80211_hdr_3addr) + 9));
 		return -1;
 	}
 	rsp = ( struct ieee80211_hdr_3addr*)skb->data;
@@ -569,7 +569,7 @@ int ieee80211_rx_DELBA(struct ieee80211_device* ieee,struct sk_buff *skb)
 
 	if (skb->len < sizeof( struct ieee80211_hdr_3addr) + 6)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in DELBA(%d / %zu)\n", skb->len, 	(sizeof( struct ieee80211_hdr_3addr) + 6));
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, " Invalid skb len in DELBA(%d / %zu)\n", skb->len,	(sizeof( struct ieee80211_hdr_3addr) + 6));
 		return -1;
 	}
 
@@ -589,7 +589,7 @@ int ieee80211_rx_DELBA(struct ieee80211_device* ieee,struct sk_buff *skb)
 
 	if(pDelBaParamSet->field.Initiator == 1)
 	{
-		PRX_TS_RECORD 	pRxTs;
+		PRX_TS_RECORD	pRxTs;
 
 		if( !GetTs(
 				ieee,
@@ -657,7 +657,7 @@ TsInitAddBA(
 	// BufferSize: This need to be set according to A-MPDU vector
 	pBA->BaParamSet.field.BufferSize = 32;		// BufferSize: This need to be set according to A-MPDU vector
 	pBA->BaTimeoutValue = 0;					// Timeout value: Set 0 to disable Timer
-	pBA->BaStartSeqCtrl.field.SeqNum = (pTS->TxCurSeq + 3) % 4096; 	// Block Ack will start after 3 packets later.
+	pBA->BaStartSeqCtrl.field.SeqNum = (pTS->TxCurSeq + 3) % 4096;	// Block Ack will start after 3 packets later.
 
 	ActivateBAEntry(ieee, pBA, BA_SETUP_TIMEOUT);
 
@@ -734,4 +734,3 @@ void RxBaInactTimeout(unsigned long data)
 		DELBA_REASON_TIMEOUT);
 	return ;
 }
-
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_HT.h b/drivers/staging/rtl8192u/ieee80211/rtl819x_HT.h
index a60b39c..2b82835 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_HT.h
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_HT.h
@@ -121,7 +121,7 @@ typedef	union _HT_CAPABILITY_MACPARA{
 
 typedef enum _HT_ACTION{
 	ACT_RECOMMAND_WIDTH		= 0,
-	ACT_MIMO_PWR_SAVE 		= 1,
+	ACT_MIMO_PWR_SAVE		= 1,
 	ACT_PSMP					= 2,
 	ACT_SET_PCO_PHASE		= 3,
 	ACT_MIMO_CHL_MEASURE	= 4,
@@ -398,9 +398,9 @@ typedef struct _BSS_HT{
 typedef struct _MIMO_RSSI{
 	u32	EnableAntenna;
 	u32	AntennaA;
-	u32 	AntennaB;
-	u32 	AntennaC;
-	u32 	AntennaD;
+	u32	AntennaB;
+	u32	AntennaC;
+	u32	AntennaD;
 	u32	Average;
 }MIMO_RSSI, *PMIMO_RSSI;
 
@@ -436,11 +436,11 @@ extern u8 MCS_FILTER_1SS[16];
 
 
 // MCS Bw 40 {1~7, 12~15,32}
-#define	RATE_ADPT_1SS_MASK 		0xFF
+#define	RATE_ADPT_1SS_MASK		0xFF
 #define	RATE_ADPT_2SS_MASK		0xF0 //Skip MCS8~11 because mcs7 > mcs6, 9, 10, 11. 2007.01.16 by Emily
 #define	RATE_ADPT_MCS32_MASK		0x01
 
-#define 	IS_11N_MCS_RATE(rate)		(rate&0x80)
+#define		IS_11N_MCS_RATE(rate)		(rate&0x80)
 
 typedef enum _HT_AGGRE_SIZE{
 	HT_AGG_SIZE_8K = 0,
@@ -478,4 +478,3 @@ typedef enum _HT_IOT_ACTION{
 }HT_IOT_ACTION_E, *PHT_IOT_ACTION_E;
 
 #endif //_RTL819XU_HTTYPE_H_
-
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
index ebb5239..268b270 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_HTProc.c
@@ -21,7 +21,7 @@ u16 MCS_DATA_RATE[2][2][77] =
 			81, 162, 243, 324, 486, 648, 729, 810, 108, 216, 324, 432, 648, 864, 972, 1080,
 			12, 162, 216, 270, 243, 324, 405, 216, 270, 270, 324, 378, 378, 432, 324, 405,
 			405, 486, 567, 567, 648, 270, 324, 378, 324, 378, 432, 486, 432, 486, 540, 540,
-			594, 405, 486, 567, 486, 567, 648, 729, 648, 729, 810, 810, 891}, 	// Long GI, 40MHz
+			594, 405, 486, 567, 486, 567, 648, 729, 648, 729, 810, 810, 891},	// Long GI, 40MHz
 			{30, 60, 90, 120, 180, 240, 270, 300, 60, 120, 180, 240, 360, 480, 540, 600,
 			90, 180, 270, 360, 540, 720, 810, 900, 120, 240, 360, 480, 720, 960, 1080, 1200,
 			13, 180, 240, 300, 270, 360, 450, 240, 300, 300, 360, 420, 420, 480, 360, 450,
@@ -88,7 +88,7 @@ void HTUpdateDefaultSetting(struct ieee80211_device* ieee)
 	ieee->bTxDisableRateFallBack = 0;
 	ieee->bTxUseDriverAssingedRate = 0;
 
-#ifdef 	TO_DO_LIST
+#ifdef	TO_DO_LIST
 	// 8190 only. Assign duration operation mode to firmware
 	pMgntInfo->bTxEnableFwCalcDur = (BOOLEAN)pNdisCommon->bRegTxEnableFwCalcDur;
 #endif
@@ -116,7 +116,7 @@ void HTUpdateDefaultSetting(struct ieee80211_device* ieee)
 /********************************************************************************************************************
  *function:  This function print out each field on HT capability IE mainly from (Beacon/ProbeRsp/AssocReq)
  *   input:  u8*	CapIE       //Capability IE to be printed out
- *   	     u8* 	TitleString //mainly print out caller function
+ *	     u8*	TitleString //mainly print out caller function
  *  output:  none
  *  return:  none
  *  notice:  Driver should not print out this message by default.
@@ -125,7 +125,7 @@ void HTDebugHTCapability(u8* CapIE, u8* TitleString )
 {
 
 	static u8	EWC11NHTCap[] = {0x00, 0x90, 0x4c, 0x33};	// For 11n EWC definition, 2007.07.17, by Emily
-	PHT_CAPABILITY_ELE 		pCapELE;
+	PHT_CAPABILITY_ELE		pCapELE;
 
 	if(!memcmp(CapIE, EWC11NHTCap, sizeof(EWC11NHTCap)))
 	{
@@ -153,7 +153,7 @@ void HTDebugHTCapability(u8* CapIE, u8* TitleString )
 /********************************************************************************************************************
  *function:  This function print out each field on HT Information IE mainly from (Beacon/ProbeRsp)
  *   input:  u8*	InfoIE       //Capability IE to be printed out
- *   	     u8* 	TitleString //mainly print out caller function
+ *	     u8*	TitleString //mainly print out caller function
  *  output:  none
  *  return:  none
  *  notice:  Driver should not print out this message by default.
@@ -217,7 +217,7 @@ void HTDebugHTInfo(u8*	InfoIE, u8* TitleString)
 }
 
 /*
-*	Return:     	true if station in half n mode and AP supports 40 bw
+*	Return:		true if station in half n mode and AP supports 40 bw
 */
 bool IsHTHalfNmode40Bandwidth(struct ieee80211_device* ieee)
 {
@@ -228,7 +228,7 @@ bool IsHTHalfNmode40Bandwidth(struct ieee80211_device* ieee)
 		retValue = false;
 	else if(pHTInfo->bRegBW40MHz == false)	// station supports 40 bw
 		retValue = false;
-	else if(!ieee->GetHalfNmodeSupportByAPsHandler(ieee->dev)) 	// station in half n mode
+	else if(!ieee->GetHalfNmodeSupportByAPsHandler(ieee->dev))	// station in half n mode
 		retValue = false;
 	else if(((PHT_CAPABILITY_ELE)(pHTInfo->PeerHTCapBuf))->ChlWidth) // ap support 40 bw
 		retValue = true;
@@ -245,7 +245,7 @@ bool IsHTHalfNmodeSGI(struct ieee80211_device* ieee, bool is40MHz)
 
 	if(pHTInfo->bCurrentHTSupport == false )	// wireless is n mode
 		retValue = false;
-	else if(!ieee->GetHalfNmodeSupportByAPsHandler(ieee->dev)) 	// station in half n mode
+	else if(!ieee->GetHalfNmodeSupportByAPsHandler(ieee->dev))	// station in half n mode
 		retValue = false;
 	else if(is40MHz) // ap support 40 bw
 	{
@@ -265,7 +265,7 @@ bool IsHTHalfNmodeSGI(struct ieee80211_device* ieee, bool is40MHz)
 	return retValue;
 }
 
-u16 HTHalfMcsToDataRate(struct ieee80211_device* ieee, 	u8	nMcsRate)
+u16 HTHalfMcsToDataRate(struct ieee80211_device* ieee,	u8	nMcsRate)
 {
 
 	u8	is40MHz;
@@ -291,8 +291,8 @@ u16 HTMcsToDataRate( struct ieee80211_device* ieee, u8 nMcsRate)
 
 /********************************************************************************************************************
  *function:  This function returns current datarate.
- *   input:  struct ieee80211_device* 	ieee
- *   	     u8 			nDataRate
+ *   input:  struct ieee80211_device*	ieee
+ *	     u8				nDataRate
  *  output:  none
  *  return:  tx rate
  *  notice:  quite unsure about how to use this function //wb
@@ -371,7 +371,7 @@ bool IsHTHalfNmodeAPs(struct ieee80211_device* ieee)
 
 /********************************************************************************************************************
  *function:  This function returns peer IOT.
- *   input:  struct ieee80211_device* 	ieee
+ *   input:  struct ieee80211_device*	ieee
  *  output:  none
  *  return:
  *  notice:
@@ -408,8 +408,8 @@ void HTIOTPeerDetermine(struct ieee80211_device* ieee)
 /********************************************************************************************************************
  *function:  Check whether driver should declare received rate up to MCS13 only since some chipset is not good
  *	     at receiving MCS14~15 frame from some AP.
- *   input:  struct ieee80211_device* 	ieee
- *   	     u8 *			PeerMacAddr
+ *   input:  struct ieee80211_device*	ieee
+ *	     u8 *			PeerMacAddr
  *  output:  none
  *  return:  return 1 if driver should declare MCS13 only(otherwise return 0)
   * *****************************************************************************************************************/
@@ -429,7 +429,7 @@ u8 HTIOTActIsDisableMCS14(struct ieee80211_device* ieee, u8* PeerMacAddr)
 *			PADAPTER		Adapter,
 *
 * Output:		None
-* Return:     	true if driver should disable MCS15
+* Return:	true if driver should disable MCS15
 * 2008.04.15	Emily
 */
 bool HTIOTActIsDisableMCS15(struct ieee80211_device* ieee)
@@ -466,7 +466,7 @@ bool HTIOTActIsDisableMCS15(struct ieee80211_device* ieee)
 *			PADAPTER		Adapter,
 *
 * Output:		None
-* Return:     	true if driver should disable all two spatial stream packet
+* Return:	true if driver should disable all two spatial stream packet
 * 2008.04.21	Emily
 */
 bool HTIOTActIsDisableMCSTwoSpatialStream(struct ieee80211_device* ieee, u8 *PeerMacAddr)
@@ -481,12 +481,12 @@ bool HTIOTActIsDisableMCSTwoSpatialStream(struct ieee80211_device* ieee, u8 *Pee
 
 /********************************************************************************************************************
  *function:  Check whether driver should disable EDCA turbo mode
- *   input:  struct ieee80211_device* 	ieee
- *   	     u8* 			PeerMacAddr
+ *   input:  struct ieee80211_device*	ieee
+ *	     u8*			PeerMacAddr
  *  output:  none
  *  return:  return 1 if driver should disable EDCA turbo mode(otherwise return 0)
   * *****************************************************************************************************************/
-u8 HTIOTActIsDisableEDCATurbo(struct ieee80211_device* 	ieee, u8* PeerMacAddr)
+u8 HTIOTActIsDisableEDCATurbo(struct ieee80211_device*	ieee, u8* PeerMacAddr)
 {
 	u8	retValue = false;	// default enable EDCA Turbo mode.
 	// Set specific EDCA parameter for different AP in DM handler.
@@ -539,10 +539,10 @@ void HTResetIOTSetting(
 
 /********************************************************************************************************************
  *function:  Construct Capablility Element in Beacon... if HTEnable is turned on
- *   input:  struct ieee80211_device* 	ieee
- *   	     u8* 			posHTCap //pointer to store Capability Ele
- *   	     u8*			len //store length of CE
- *   	     u8				IsEncrypt //whether encrypt, needed further
+ *   input:  struct ieee80211_device*	ieee
+ *	     u8*			posHTCap //pointer to store Capability Ele
+ *	     u8*			len //store length of CE
+ *	     u8				IsEncrypt //whether encrypt, needed further
  *  output:  none
  *  return:  none
  *  notice:  posHTCap can't be null and should be initialized before.
@@ -550,7 +550,7 @@ void HTResetIOTSetting(
 void HTConstructCapabilityElement(struct ieee80211_device* ieee, u8* posHTCap, u8* len, u8 IsEncrypt)
 {
 	PRT_HIGH_THROUGHPUT	pHT = ieee->pHTInfo;
-	PHT_CAPABILITY_ELE 	pCapELE = NULL;
+	PHT_CAPABILITY_ELE	pCapELE = NULL;
 	//u8 bIsDeclareMCS13;
 
 	if ((posHTCap == NULL) || (pHT == NULL))
@@ -571,7 +571,7 @@ void HTConstructCapabilityElement(struct ieee80211_device* ieee, u8* posHTCap, u
 
 
 	//HT capability info
-	pCapELE->AdvCoding 		= 0; // This feature is not supported now!!
+	pCapELE->AdvCoding		= 0; // This feature is not supported now!!
 	if(ieee->GetHalfNmodeSupportByAPsHandler(ieee->dev))
 	{
 		pCapELE->ChlWidth = 0;
@@ -581,18 +581,18 @@ void HTConstructCapabilityElement(struct ieee80211_device* ieee, u8* posHTCap, u
 		pCapELE->ChlWidth = (pHT->bRegBW40MHz?1:0);
 	}
 
-//	pCapELE->ChlWidth 		= (pHT->bRegBW40MHz?1:0);
-	pCapELE->MimoPwrSave 		= pHT->SelfMimoPs;
+//	pCapELE->ChlWidth		= (pHT->bRegBW40MHz?1:0);
+	pCapELE->MimoPwrSave		= pHT->SelfMimoPs;
 	pCapELE->GreenField		= 0; // This feature is not supported now!!
 	pCapELE->ShortGI20Mhz		= 1; // We can receive Short GI!!
 	pCapELE->ShortGI40Mhz		= 1; // We can receive Short GI!!
 	//DbgPrint("TX HT cap/info ele BW=%d SG20=%d SG40=%d\n\r",
 		//pCapELE->ChlWidth, pCapELE->ShortGI20Mhz, pCapELE->ShortGI40Mhz);
-	pCapELE->TxSTBC 		= 1;
-	pCapELE->RxSTBC 		= 0;
+	pCapELE->TxSTBC			= 1;
+	pCapELE->RxSTBC			= 0;
 	pCapELE->DelayBA		= 0;	// Do not support now!!
 	pCapELE->MaxAMSDUSize	= (MAX_RECEIVE_BUFFER_SIZE>=7935)?1:0;
-	pCapELE->DssCCk 		= ((pHT->bRegBW40MHz)?(pHT->bRegSuppCCK?1:0):0);
+	pCapELE->DssCCk			= ((pHT->bRegBW40MHz)?(pHT->bRegSuppCCK?1:0):0);
 	pCapELE->PSMP			= 0; // Do not support now!!
 	pCapELE->LSigTxopProtect	= 0; // Do not support now!!
 
@@ -603,13 +603,13 @@ void HTConstructCapabilityElement(struct ieee80211_device* ieee, u8* posHTCap, u
 
 	if( IsEncrypt)
 	{
-		pCapELE->MPDUDensity 	= 7; // 8us
-		pCapELE->MaxRxAMPDUFactor 	= 2; // 2 is for 32 K and 3 is 64K
+		pCapELE->MPDUDensity	= 7; // 8us
+		pCapELE->MaxRxAMPDUFactor	= 2; // 2 is for 32 K and 3 is 64K
 	}
 	else
 	{
-		pCapELE->MaxRxAMPDUFactor 	= 3; // 2 is for 32 K and 3 is 64K
-		pCapELE->MPDUDensity 	= 0; // no density
+		pCapELE->MaxRxAMPDUFactor	= 3; // 2 is for 32 K and 3 is 64K
+		pCapELE->MPDUDensity	= 0; // no density
 	}
 
 	//Supported MCS set
@@ -658,10 +658,10 @@ void HTConstructCapabilityElement(struct ieee80211_device* ieee, u8* posHTCap, u
 }
 /********************************************************************************************************************
  *function:  Construct  Information Element in Beacon... if HTEnable is turned on
- *   input:  struct ieee80211_device* 	ieee
- *   	     u8* 			posHTCap //pointer to store Information Ele
- *   	     u8*			len   //store len of
- *   	     u8				IsEncrypt //whether encrypt, needed further
+ *   input:  struct ieee80211_device*	ieee
+ *	     u8*			posHTCap //pointer to store Information Ele
+ *	     u8*			len   //store len of
+ *	     u8				IsEncrypt //whether encrypt, needed further
  *  output:  none
  *  return:  none
  *  notice:  posHTCap can't be null and be initialized before. only AP and IBSS sta should do this
@@ -679,12 +679,12 @@ void HTConstructInfoElement(struct ieee80211_device* ieee, u8* posHTInfo, u8* le
 	memset(posHTInfo, 0, *len);
 	if ( (ieee->iw_mode == IW_MODE_ADHOC) || (ieee->iw_mode == IW_MODE_MASTER)) //ap mode is not currently supported
 	{
-		pHTInfoEle->ControlChl 			= ieee->current_network.channel;
-		pHTInfoEle->ExtChlOffset 			= ((pHT->bRegBW40MHz == false)?HT_EXTCHNL_OFFSET_NO_EXT:
+		pHTInfoEle->ControlChl			= ieee->current_network.channel;
+		pHTInfoEle->ExtChlOffset			= ((pHT->bRegBW40MHz == false)?HT_EXTCHNL_OFFSET_NO_EXT:
 											(ieee->current_network.channel<=6)?
 												HT_EXTCHNL_OFFSET_UPPER:HT_EXTCHNL_OFFSET_LOWER);
 		pHTInfoEle->RecommemdedTxWidth	= pHT->bRegBW40MHz;
-		pHTInfoEle->RIFS 					= 0;
+		pHTInfoEle->RIFS					= 0;
 		pHTInfoEle->PSMPAccessOnly		= 0;
 		pHTInfoEle->SrvIntGranularity		= 0;
 		pHTInfoEle->OptMode				= pHT->CurrentOpMode;
@@ -723,17 +723,17 @@ void HTConstructInfoElement(struct ieee80211_device* ieee, u8* posHTInfo, u8* le
   *  Element ID		Length		OUI			Type1		Reserved
   *  1 byte			1 byte		3 bytes		1 byte		1 byte
   *
-  *  OUI 		= 0x00, 0xe0, 0x4c,
-  *  Type 	= 0x02
-  *  Reserved 	= 0x00
+  *  OUI		= 0x00, 0xe0, 0x4c,
+  *  Type	= 0x02
+  *  Reserved	= 0x00
   *
   *  2007.8.21 by Emily
 */
 /********************************************************************************************************************
  *function:  Construct  Information Element in Beacon... in RT2RT condition
- *   input:  struct ieee80211_device* 	ieee
- *   	     u8* 			posRT2RTAgg //pointer to store Information Ele
- *   	     u8*			len   //store len
+ *   input:  struct ieee80211_device*	ieee
+ *	     u8*			posRT2RTAgg //pointer to store Information Ele
+ *	     u8*			len   //store len
  *  output:  none
  *  return:  none
  *  notice:
@@ -787,8 +787,8 @@ void HTConstructRT2RTAggElement(struct ieee80211_device* ieee, u8* posRT2RTAgg,
 
 /********************************************************************************************************************
  *function:  Pick the right Rate Adaptive table to use
- *   input:  struct ieee80211_device* 	ieee
- *   	     u8* 			pOperateMCS //A pointer to MCS rate bitmap
+ *   input:  struct ieee80211_device*	ieee
+ *	     u8*			pOperateMCS //A pointer to MCS rate bitmap
  *  return:  always we return true
  *  notice:
   * *****************************************************************************************************************/
@@ -840,7 +840,7 @@ u8 HT_PickMCSRate(struct ieee80211_device* ieee, u8* pOperateMCS)
 *	Description:
 *		This function will get the highest speed rate in input MCS set.
 *
-*	/param 	Adapter			Pionter to Adapter entity
+*	/param	Adapter			Pionter to Adapter entity
 *			pMCSRateSet		Pointer to MCS rate bitmap
 *			pMCSFilter		Pointer to MCS rate filter
 *
@@ -849,9 +849,9 @@ u8 HT_PickMCSRate(struct ieee80211_device* ieee, u8* pOperateMCS)
 */
 /********************************************************************************************************************
  *function:  This function will get the highest speed rate in input MCS set.
- *   input:  struct ieee80211_device* 	ieee
- *   	     u8* 			pMCSRateSet //Pointer to MCS rate bitmap
- *   	     u8*			pMCSFilter //Pointer to MCS rate filter
+ *   input:  struct ieee80211_device*	ieee
+ *	     u8*			pMCSRateSet //Pointer to MCS rate bitmap
+ *	     u8*			pMCSFilter //Pointer to MCS rate filter
  *  return:  Highest MCS rate included in pMCSRateSet and filtered by pMCSFilter
  *  notice:
   * *****************************************************************************************************************/
@@ -1062,7 +1062,7 @@ void HTOnAssocRsp(struct ieee80211_device *ieee)
 	else
 		pHTInfo->CurrentMPDUDensity = pPeerHTCap->MPDUDensity;
 	if(ieee->pairwise_key_type != KEY_TYPE_NA )
-		pHTInfo->CurrentMPDUDensity 	= 7; // 8us
+		pHTInfo->CurrentMPDUDensity	= 7; // 8us
 	// Force TX AMSDU
 
 	// Lanhsin: mark for tmp to avoid deauth by ap from  s3
@@ -1118,7 +1118,7 @@ void HTOnAssocRsp(struct ieee80211_device *ieee)
 void HTSetConnectBwModeCallback(struct ieee80211_device* ieee);
 /********************************************************************************************************************
  *function:  initialize HT info(struct PRT_HIGH_THROUGHPUT)
- *   input:  struct ieee80211_device* 	ieee
+ *   input:  struct ieee80211_device*	ieee
  *  output:  none
  *  return:  none
  *  notice: This function is called when *  (1) MPInitialization Phase *  (2) Receiving of Deauthentication from AP
@@ -1208,13 +1208,13 @@ void HTInitializeBssDesc(PBSS_HT pBssHT)
 }
 /********************************************************************************************************************
  *function:  initialize Bss HT structure(struct PBSS_HT)
- *   input:  struct ieee80211_device 	*ieee
- *   	     struct ieee80211_network 	*pNetwork //usually current network we are live in
+ *   input:  struct ieee80211_device	*ieee
+ *	     struct ieee80211_network	*pNetwork //usually current network we are live in
  *  output:  none
  *  return:  none
  *  notice: This function should ONLY be called before association
 ********************************************************************************************************************/
-void HTResetSelfAndSavePeerSetting(struct ieee80211_device* ieee, 	struct ieee80211_network * pNetwork)
+void HTResetSelfAndSavePeerSetting(struct ieee80211_device* ieee,	struct ieee80211_network * pNetwork)
 {
 	PRT_HIGH_THROUGHPUT		pHTInfo = ieee->pHTInfo;
 //	u16						nMaxAMSDUSize;
@@ -1235,7 +1235,7 @@ void HTResetSelfAndSavePeerSetting(struct ieee80211_device* ieee, 	struct ieee80
 		pHTInfo->ePeerHTSpecVer = pNetwork->bssht.bdHTSpecVer;
 
 		// Save HTCap and HTInfo information Element
-		if(pNetwork->bssht.bdHTCapLen > 0 && 	pNetwork->bssht.bdHTCapLen <= sizeof(pHTInfo->PeerHTCapBuf))
+		if(pNetwork->bssht.bdHTCapLen > 0 &&	pNetwork->bssht.bdHTCapLen <= sizeof(pHTInfo->PeerHTCapBuf))
 			memcpy(pHTInfo->PeerHTCapBuf, pNetwork->bssht.bdHTCapBuf, pNetwork->bssht.bdHTCapLen);
 
 		if(pNetwork->bssht.bdHTInfoLen > 0 && pNetwork->bssht.bdHTInfoLen <= sizeof(pHTInfo->PeerHTInfoBuf))
@@ -1297,7 +1297,7 @@ void HTResetSelfAndSavePeerSetting(struct ieee80211_device* ieee, 	struct ieee80
 
 }
 
-void HTUpdateSelfAndPeerSetting(struct ieee80211_device* ieee, 	struct ieee80211_network * pNetwork)
+void HTUpdateSelfAndPeerSetting(struct ieee80211_device* ieee,	struct ieee80211_network * pNetwork)
 {
 	PRT_HIGH_THROUGHPUT	pHTInfo = ieee->pHTInfo;
 //	PHT_CAPABILITY_ELE		pPeerHTCap = (PHT_CAPABILITY_ELE)pNetwork->bssht.bdHTCapBuf;
@@ -1364,8 +1364,8 @@ void HTUseDefaultSetting(struct ieee80211_device* ieee)
 }
 /********************************************************************************************************************
  *function:  check whether HT control field exists
- *   input:  struct ieee80211_device 	*ieee
- *   	     u8*			pFrame //coming skb->data
+ *   input:  struct ieee80211_device	*ieee
+ *	     u8*			pFrame //coming skb->data
  *  output:  none
  *  return:  return true if HT control field exists(false otherwise)
  *  notice:
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h b/drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h
index 9e4ced1..2625cde 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_Qos.h
@@ -412,14 +412,14 @@ typedef union _QOS_TCLAS{
 
 	struct _TYPE_GENERAL{
 		u8		Priority;
-		u8 		ClassifierType;
-		u8 		Mask;
+		u8		ClassifierType;
+		u8		Mask;
 	} TYPE_GENERAL;
 
 	struct _TYPE0_ETH{
 		u8		Priority;
-		u8 		ClassifierType;
-		u8 		Mask;
+		u8		ClassifierType;
+		u8		Mask;
 		u8		SrcAddr[6];
 		u8		DstAddr[6];
 		u16		Type;
@@ -427,9 +427,9 @@ typedef union _QOS_TCLAS{
 
 	struct _TYPE1_IPV4{
 		u8		Priority;
-		u8 		ClassifierType;
-		u8 		Mask;
-		u8 		Version;
+		u8		ClassifierType;
+		u8		Mask;
+		u8		Version;
 		u8		SrcIP[4];
 		u8		DstIP[4];
 		u16		SrcPort;
@@ -441,9 +441,9 @@ typedef union _QOS_TCLAS{
 
 	struct _TYPE1_IPV6{
 		u8		Priority;
-		u8 		ClassifierType;
-		u8 		Mask;
-		u8 		Version;
+		u8		ClassifierType;
+		u8		Mask;
+		u8		Version;
 		u8		SrcIP[16];
 		u8		DstIP[16];
 		u16		SrcPort;
@@ -453,8 +453,8 @@ typedef union _QOS_TCLAS{
 
 	struct _TYPE2_8021Q{
 		u8		Priority;
-		u8 		ClassifierType;
-		u8 		Mask;
+		u8		ClassifierType;
+		u8		Mask;
 		u16		TagType;
 	} TYPE2_8021Q;
 } QOS_TCLAS, *PQOS_TCLAS;
@@ -481,7 +481,7 @@ typedef struct _QOS_TSTREAM{
 //	"Qos control field" and "Qos info field"
 //typedef struct _QOS_UAPSD{
 //	u8			bTriggerEnable[4];
-//	u8 			MaxSPLength;
+//	u8			MaxSPLength;
 //	u8			HighestBufAC;
 //} QOS_UAPSD, *PQOS_APSD;
 
@@ -489,7 +489,7 @@ typedef struct _QOS_TSTREAM{
 //      802.11 Management frame Status Code field
 //----------------------------------------------------------------------------
 typedef struct _OCTET_STRING{
-	u8        	*Octet;
+	u8		*Octet;
 	u16             Length;
 }OCTET_STRING, *POCTET_STRING;
 
@@ -512,7 +512,7 @@ typedef struct _STA_QOS{
 	AC_UAPSD			Curr4acUapsd;
 	u8				bInServicePeriod;
 	u8				MaxSPLength;
-	int 				NumBcnBeforeTrigger;
+	int				NumBcnBeforeTrigger;
 
 	// Part 2. EDCA Parameter (perAC)
 	u8 *				pWMMInfoEle;
@@ -523,7 +523,7 @@ typedef struct _STA_QOS{
 	//2 ToDo: remove the Qos Info Field and replace it by the above WMM Info element.
 	// By Bruce, 2008-01-30.
 	// Part 2. EDCA Parameter (perAC)
-	QOS_INFO_FIELD			QosInfoField_STA; 	// Maintained by STA
+	QOS_INFO_FIELD			QosInfoField_STA;	// Maintained by STA
 	QOS_INFO_FIELD			QosInfoField_AP;	// Retrieved from AP
 
 	AC_PARAM			CurAcParameters[4];
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_TS.h b/drivers/staging/rtl8192u/ieee80211/rtl819x_TS.h
index e7e26fd..7ed7243 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_TS.h
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_TS.h
@@ -28,7 +28,7 @@ typedef struct _TS_COMMON_INFO{
 typedef struct _TX_TS_RECORD{
 	TS_COMMON_INFO		TsCommonInfo;
 	u16				TxCurSeq;
-	BA_RECORD			TxPendingBARecord;  	// For BA Originator
+	BA_RECORD			TxPendingBARecord;	// For BA Originator
 	BA_RECORD			TxAdmittedBARecord;	// For BA Originator
 //	QOS_DL_RECORD		DLRecord;
 	u8				bAddBaReqInProgress;
@@ -53,4 +53,3 @@ typedef struct _RX_TS_RECORD {
 
 
 #endif
-
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
index 06a9824..0310d07 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_TSProc.c
@@ -27,7 +27,7 @@ void RxPktPendingTimeout(unsigned long data)
 	PRX_TS_RECORD	pRxTs = (PRX_TS_RECORD)data;
 	struct ieee80211_device *ieee = container_of(pRxTs, struct ieee80211_device, RxTsRecord[pRxTs->num]);
 
-	PRX_REORDER_ENTRY 	pReorderEntry = NULL;
+	PRX_REORDER_ENTRY	pReorderEntry = NULL;
 
 	//u32 flags = 0;
 	unsigned long flags = 0;
@@ -236,8 +236,8 @@ void AdmitTS(struct ieee80211_device *ieee, PTS_COMMON_INFO pTsCommonInfo, u32 I
 
 PTS_COMMON_INFO SearchAdmitTRStream(struct ieee80211_device *ieee, u8*	Addr, u8 TID, TR_SELECT	TxRxSelect)
 {
-	//DIRECTION_VALUE 	dir;
-	u8 	dir;
+	//DIRECTION_VALUE	dir;
+	u8	dir;
 	bool				search_dir[4] = {0, 0, 0, 0};
 	struct list_head*		psearch_list; //FIXME
 	PTS_COMMON_INFO	pRet = NULL;
@@ -250,14 +250,14 @@ PTS_COMMON_INFO SearchAdmitTRStream(struct ieee80211_device *ieee, u8*	Addr, u8
 		}
 		else
 		{
-			search_dir[DIR_UP] 	= true;
+			search_dir[DIR_UP]	= true;
 			search_dir[DIR_BI_DIR]= true;
 		}
 	}
 	else if(ieee->iw_mode == IW_MODE_ADHOC)
 	{
 		if(TxRxSelect == TX_DIR)
-			search_dir[DIR_UP] 	= true;
+			search_dir[DIR_UP]	= true;
 		else
 			search_dir[DIR_DOWN] = true;
 	}
@@ -265,7 +265,7 @@ PTS_COMMON_INFO SearchAdmitTRStream(struct ieee80211_device *ieee, u8*	Addr, u8
 	{
 		if(TxRxSelect == TX_DIR)
 		{
-			search_dir[DIR_UP] 	= true;
+			search_dir[DIR_UP]	= true;
 			search_dir[DIR_BI_DIR]= true;
 			search_dir[DIR_DIRECT]= true;
 		}
@@ -450,8 +450,8 @@ bool GetTs(
 				pTSInfo->field.ucTSID = UP;			// TSID
 				pTSInfo->field.ucDirection = Dir;			// Direction: if there is DirectLink, this need additional consideration.
 				pTSInfo->field.ucAccessPolicy = 1;		// Access policy
-				pTSInfo->field.ucAggregation = 0; 		// Aggregation
-				pTSInfo->field.ucPSB = 0; 				// Aggregation
+				pTSInfo->field.ucAggregation = 0;		// Aggregation
+				pTSInfo->field.ucPSB = 0;				// Aggregation
 				pTSInfo->field.ucUP = UP;				// User priority
 				pTSInfo->field.ucTSInfoAckPolicy = 0;		// Ack policy
 				pTSInfo->field.ucSchedule = 0;			// Schedule
@@ -488,7 +488,7 @@ void RemoveTsEntry(
 	{
 //#ifdef TO_DO_LIST
 		PRX_REORDER_ENTRY	pRxReorderEntry;
-		PRX_TS_RECORD 		pRxTS = (PRX_TS_RECORD)pTs;
+		PRX_TS_RECORD		pRxTS = (PRX_TS_RECORD)pTs;
 		if(timer_pending(&pRxTS->RxPktPendingTimer))
 			del_timer_sync(&pRxTS->RxPktPendingTimer);
 
diff --git a/drivers/staging/rtl8192u/ieee80211/rtl_crypto.h b/drivers/staging/rtl8192u/ieee80211/rtl_crypto.h
index ccf6ae7..a8df410 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl_crypto.h
+++ b/drivers/staging/rtl8192u/ieee80211/rtl_crypto.h
@@ -52,10 +52,10 @@
 
 #define CRYPTO_TFM_REQ_WEAK_KEY		0x00000100
 #define CRYPTO_TFM_RES_WEAK_KEY		0x00100000
-#define CRYPTO_TFM_RES_BAD_KEY_LEN   	0x00200000
-#define CRYPTO_TFM_RES_BAD_KEY_SCHED 	0x00400000
-#define CRYPTO_TFM_RES_BAD_BLOCK_LEN 	0x00800000
-#define CRYPTO_TFM_RES_BAD_FLAGS 	0x01000000
+#define CRYPTO_TFM_RES_BAD_KEY_LEN	0x00200000
+#define CRYPTO_TFM_RES_BAD_KEY_SCHED	0x00400000
+#define CRYPTO_TFM_RES_BAD_BLOCK_LEN	0x00800000
+#define CRYPTO_TFM_RES_BAD_FLAGS	0x01000000
 
 /*
  * Miscellaneous stuff.
@@ -396,4 +396,3 @@ void crypto_hmac(struct crypto_tfm *tfm, u8 *key, unsigned int *keylen,
 #endif	/* CONFIG_CRYPTO_HMAC */
 
 #endif	/* _LINUX_CRYPTO_H */
-
diff --git a/drivers/staging/rtl8192u/r8190_rtl8256.c b/drivers/staging/rtl8192u/r8190_rtl8256.c
index 74ff337..cf9713f 100644
--- a/drivers/staging/rtl8192u/r8190_rtl8256.c
+++ b/drivers/staging/rtl8192u/r8190_rtl8256.c
@@ -16,9 +16,9 @@
 #include "r8190_rtl8256.h"
 
 /*--------------------------------------------------------------------------
- * Overview:   	set RF band width (20M or 40M)
+ * Overview:	set RF band width (20M or 40M)
  * Input:       struct net_device*	dev
- * 		WIRELESS_BANDWIDTH_E	Bandwidth	//20M or 40M
+ *		WIRELESS_BANDWIDTH_E	Bandwidth	//20M or 40M
  * Output:      NONE
  * Return:      NONE
  * Note:	8226 support both 20M  and 40 MHz
@@ -106,16 +106,16 @@ void PHY_RF8256_Config(struct net_device* dev)
  *---------------------------------------------------------------------------*/
 void phy_RF8256_Config_ParaFile(struct net_device* dev)
 {
-	u32 	u4RegValue = 0;
+	u32	u4RegValue = 0;
 	//static s1Byte				szRadioAFile[] = RTL819X_PHY_RADIO_A;
 	//static s1Byte				szRadioBFile[] = RTL819X_PHY_RADIO_B;
 	//static s1Byte				szRadioCFile[] = RTL819X_PHY_RADIO_C;
 	//static s1Byte				szRadioDFile[] = RTL819X_PHY_RADIO_D;
-	u8 	eRFPath;
+	u8	eRFPath;
 	BB_REGISTER_DEFINITION_T	*pPhyReg;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	u32	RegOffSetToBeCheck = 0x3;
-	u32 	RegValueToBeCheck = 0x7f1;
+	u32	RegValueToBeCheck = 0x7f1;
 	u32	RF3_Final_Value = 0;
 	u8	ConstRetryTimes = 5, RetryTimes = 5;
 	u8 ret = 0;
@@ -152,7 +152,7 @@ void phy_RF8256_Config_ParaFile(struct net_device* dev)
 		rtl8192_setBBreg(dev, pPhyReg->rfintfo, bRFSI_RFENV, 0x1);
 
 		/* Set bit number of Address and Data for RF register */
-		rtl8192_setBBreg(dev, pPhyReg->rfHSSIPara2, b3WireAddressLength, 0x0); 	// Set 0 to 4 bits for Z-serial and set 1 to 6 bits for 8258
+		rtl8192_setBBreg(dev, pPhyReg->rfHSSIPara2, b3WireAddressLength, 0x0);	// Set 0 to 4 bits for Z-serial and set 1 to 6 bits for 8258
 		rtl8192_setBBreg(dev, pPhyReg->rfHSSIPara2, b3WireDataLength, 0x0);	// Set 0 to 12 bits for Z-serial and 8258, and set 1 to 14 bits for ???
 
 		rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E) eRFPath, 0x0, bMask12Bits, 0xbf);
@@ -309,4 +309,3 @@ void PHY_SetRF8256OFDMTxPower(struct net_device* dev, u8 powerlevel)
 	return;
 
 }
-
diff --git a/drivers/staging/rtl8192u/r8192U.h b/drivers/staging/rtl8192u/r8192U.h
index 57e3383..80ab937 100644
--- a/drivers/staging/rtl8192u/r8192U.h
+++ b/drivers/staging/rtl8192u/r8192U.h
@@ -110,7 +110,7 @@ do { if(rt_global_debug_component & component) \
 #define COMP_RATE				BIT12	// For Rate Adaptive mechanism, 2006.07.02, by rcnjko.
 #define COMP_RM					BIT13	// For Radio Measurement.
 #define COMP_DIG				BIT14	// For DIG, 2006.09.25, by rcnjko.
-#define COMP_PHY	 			BIT15
+#define COMP_PHY				BIT15
 #define COMP_CH					BIT16	//channel setting debug
 #define COMP_TXAGC				BIT17	// For Tx power, 060928, by rcnjko.
 #define COMP_HIPWR				BIT18	// For High Power Mechanism, 060928, by rcnjko.
@@ -209,7 +209,7 @@ do { if(rt_global_debug_component & component) \
 #define IEEE80211_WATCH_DOG_TIME    2000
 #define		PHY_Beacon_RSSI_SLID_WIN_MAX		10
 //for txpowertracking by amy
-#define 	OFDM_Table_Length	19
+#define		OFDM_Table_Length	19
 #define	CCK_Table_length	12
 
 /* for rtl819x */
@@ -298,7 +298,7 @@ typedef struct _tx_desc_cmd_819x_usb {
 	u8	Reserved4;
 
         //DOWRD 2
-	u16 	TxBufferSize;
+	u16	TxBufferSize;
 	u16	Reserved5;
 
        //DWORD 3,4,5
@@ -391,7 +391,7 @@ typedef struct _rx_desc_819x_usb_aggr_subframe{
 	//DWORD 2
 	//u4Byte		Reserved3;
 	//DWORD 3
-	//u4Byte           	BufferAddress;
+	//u4Byte		BufferAddress;
 }rx_desc_819x_usb_aggr_subframe, *prx_desc_819x_usb_aggr_subframe;
 #endif
 
@@ -424,7 +424,7 @@ typedef struct rx_drvinfo_819x_usb{
 #define MAX_802_11_HEADER_LENGTH        (40 + MAX_FIRMWARE_INFORMATION_SIZE)
 #define ENCRYPTION_MAX_OVERHEAD		128
 #define	USB_HWDESC_HEADER_LEN		sizeof(tx_desc_819x_usb)
-#define TX_PACKET_SHIFT_BYTES 	  	(USB_HWDESC_HEADER_LEN + sizeof(tx_fwinfo_819x_usb))
+#define TX_PACKET_SHIFT_BYTES		(USB_HWDESC_HEADER_LEN + sizeof(tx_fwinfo_819x_usb))
 #define MAX_FRAGMENT_COUNT		8
 #ifdef RTL8192U
 #ifdef USB_TX_DRIVER_AGGREGATION_ENABLE
@@ -433,7 +433,7 @@ typedef struct rx_drvinfo_819x_usb{
 #define MAX_TRANSMIT_BUFFER_SIZE			8000
 #endif
 #else
-#define MAX_TRANSMIT_BUFFER_SIZE  	(1600+(MAX_802_11_HEADER_LENGTH+ENCRYPTION_MAX_OVERHEAD)*MAX_FRAGMENT_COUNT)
+#define MAX_TRANSMIT_BUFFER_SIZE	(1600+(MAX_802_11_HEADER_LENGTH+ENCRYPTION_MAX_OVERHEAD)*MAX_FRAGMENT_COUNT)
 #endif
 #ifdef USB_TX_DRIVER_AGGREGATION_ENABLE
 #define TX_PACKET_DRVAGGR_SUBFRAME_SHIFT_BYTES (sizeof(tx_desc_819x_usb_aggr_subframe) + sizeof(tx_fwinfo_819x_usb))
@@ -711,7 +711,7 @@ typedef struct Stats
 
 //+by amy 080507
 
-typedef struct 	ChnlAccessSetting {
+typedef struct	ChnlAccessSetting {
 	u16 SIFS_Timer;
 	u16 DIFS_Timer;
 	u16 SlotTimeTimer;
@@ -721,23 +721,23 @@ typedef struct 	ChnlAccessSetting {
 }*PCHANNEL_ACCESS_SETTING,CHANNEL_ACCESS_SETTING;
 
 typedef struct _BB_REGISTER_DEFINITION{
-	u32 rfintfs; 			// set software control: //		0x870~0x877[8 bytes]
-	u32 rfintfi; 			// readback data: //		0x8e0~0x8e7[8 bytes]
-	u32 rfintfo; 			// output data: //		0x860~0x86f [16 bytes]
-	u32 rfintfe; 			// output enable: //		0x860~0x86f [16 bytes]
-	u32 rf3wireOffset; 		// LSSI data: //		0x840~0x84f [16 bytes]
-	u32 rfLSSI_Select; 		// BB Band Select: //		0x878~0x87f [8 bytes]
+	u32 rfintfs;			// set software control: //		0x870~0x877[8 bytes]
+	u32 rfintfi;			// readback data: //		0x8e0~0x8e7[8 bytes]
+	u32 rfintfo;			// output data: //		0x860~0x86f [16 bytes]
+	u32 rfintfe;			// output enable: //		0x860~0x86f [16 bytes]
+	u32 rf3wireOffset;		// LSSI data: //		0x840~0x84f [16 bytes]
+	u32 rfLSSI_Select;		// BB Band Select: //		0x878~0x87f [8 bytes]
 	u32 rfTxGainStage;		// Tx gain stage: //		0x80c~0x80f [4 bytes]
-	u32 rfHSSIPara1; 		// wire parameter control1 : //		0x820~0x823,0x828~0x82b, 0x830~0x833, 0x838~0x83b [16 bytes]
-	u32 rfHSSIPara2; 		// wire parameter control2 : //		0x824~0x827,0x82c~0x82f, 0x834~0x837, 0x83c~0x83f [16 bytes]
-	u32 rfSwitchControl; 	//Tx Rx antenna control : //		0x858~0x85f [16 bytes]
-	u32 rfAGCControl1; 	//AGC parameter control1 : //		0xc50~0xc53,0xc58~0xc5b, 0xc60~0xc63, 0xc68~0xc6b [16 bytes]
-	u32 rfAGCControl2; 	//AGC parameter control2 : //		0xc54~0xc57,0xc5c~0xc5f, 0xc64~0xc67, 0xc6c~0xc6f [16 bytes]
-	u32 rfRxIQImbalance; 	//OFDM Rx IQ imbalance matrix : //		0xc14~0xc17,0xc1c~0xc1f, 0xc24~0xc27, 0xc2c~0xc2f [16 bytes]
-	u32 rfRxAFE;  			//Rx IQ DC ofset and Rx digital filter, Rx DC notch filter : //		0xc10~0xc13,0xc18~0xc1b, 0xc20~0xc23, 0xc28~0xc2b [16 bytes]
-	u32 rfTxIQImbalance; 	//OFDM Tx IQ imbalance matrix //		0xc80~0xc83,0xc88~0xc8b, 0xc90~0xc93, 0xc98~0xc9b [16 bytes]
-	u32 rfTxAFE; 			//Tx IQ DC Offset and Tx DFIR type //		0xc84~0xc87,0xc8c~0xc8f, 0xc94~0xc97, 0xc9c~0xc9f [16 bytes]
-	u32 rfLSSIReadBack; 	//LSSI RF readback data //		0x8a0~0x8af [16 bytes]
+	u32 rfHSSIPara1;		// wire parameter control1 : //		0x820~0x823,0x828~0x82b, 0x830~0x833, 0x838~0x83b [16 bytes]
+	u32 rfHSSIPara2;		// wire parameter control2 : //		0x824~0x827,0x82c~0x82f, 0x834~0x837, 0x83c~0x83f [16 bytes]
+	u32 rfSwitchControl;	//Tx Rx antenna control : //		0x858~0x85f [16 bytes]
+	u32 rfAGCControl1;	//AGC parameter control1 : //		0xc50~0xc53,0xc58~0xc5b, 0xc60~0xc63, 0xc68~0xc6b [16 bytes]
+	u32 rfAGCControl2;	//AGC parameter control2 : //		0xc54~0xc57,0xc5c~0xc5f, 0xc64~0xc67, 0xc6c~0xc6f [16 bytes]
+	u32 rfRxIQImbalance;	//OFDM Rx IQ imbalance matrix : //		0xc14~0xc17,0xc1c~0xc1f, 0xc24~0xc27, 0xc2c~0xc2f [16 bytes]
+	u32 rfRxAFE;			//Rx IQ DC ofset and Rx digital filter, Rx DC notch filter : //		0xc10~0xc13,0xc18~0xc1b, 0xc20~0xc23, 0xc28~0xc2b [16 bytes]
+	u32 rfTxIQImbalance;	//OFDM Tx IQ imbalance matrix //		0xc80~0xc83,0xc88~0xc8b, 0xc90~0xc93, 0xc98~0xc9b [16 bytes]
+	u32 rfTxAFE;			//Tx IQ DC Offset and Tx DFIR type //		0xc84~0xc87,0xc8c~0xc8f, 0xc94~0xc97, 0xc9c~0xc9f [16 bytes]
+	u32 rfLSSIReadBack;	//LSSI RF readback data //		0x8a0~0x8af [16 bytes]
 }BB_REGISTER_DEFINITION_T, *PBB_REGISTER_DEFINITION_T;
 
 typedef enum _RT_RF_TYPE_819xU{
@@ -1006,7 +1006,7 @@ typedef struct r8192_priv
 	u8 retry_rts;
 	u16 rts;
 
-	struct 	ChnlAccessSetting  ChannelAccessSetting;
+	struct	ChnlAccessSetting  ChannelAccessSetting;
 	struct work_struct reset_wq;
 
 /**********************************************************/
@@ -1014,7 +1014,7 @@ typedef struct r8192_priv
 	u16     basic_rate;
 	u8      short_preamble;
 	u8      slot_time;
-	bool 	bDcut;
+	bool	bDcut;
 	bool bCurrentRxAggrEnable;
 	u8 Rf_Mode; //add for Firmware RF -R/W switch
 	prt_firmware		pFirmware;
@@ -1050,7 +1050,7 @@ typedef struct r8192_priv
 
 	//for set channel
 	u8	SwChnlInProgress;
-	u8 	SwChnlStage;
+	u8	SwChnlStage;
 	u8	SwChnlStep;
 	u8	SetBWModeInProgress;
 	HT_CHANNEL_WIDTH		CurrentChannelBW;
@@ -1062,8 +1062,8 @@ typedef struct r8192_priv
 	// We save RF reg0 in this variable to reduce RF reading.
 	//
 	u32					RfReg0Value[4];
-	u8 					NumTotalRFPath;
-	bool 				brfpath_rxenable[4];
+	u8					NumTotalRFPath;
+	bool				brfpath_rxenable[4];
 	//RF set related
 	bool				SetRFPowerStateInProgress;
 //+by amy 080507
@@ -1104,7 +1104,7 @@ typedef struct r8192_priv
 	bool btxpower_tracking;
 	bool bcck_in_ch14;
 	bool btxpowerdata_readfromEEPORM;
-	u16 	TSSI_13dBm;
+	u16	TSSI_13dBm;
 	//For Backup Initial Gain
 	init_gain initgain_backup;
 	u8 DefaultInitialGain[4];
@@ -1114,17 +1114,17 @@ typedef struct r8192_priv
 	bool		bis_cur_rdlstate;
 	struct timer_list fsync_timer;
 	bool bfsync_processing;	// 500ms Fsync timer is active or not
-	u32 	rate_record;
-	u32 	rateCountDiffRecord;
+	u32	rate_record;
+	u32	rateCountDiffRecord;
 	u32	ContinueDiffCount;
 	bool bswitch_fsync;
 
 	u8	framesync;
-	u32 	framesyncC34;
-	u8   	framesyncMonitor;
-        	//Added by amy 080516  for RX related
-	u16 	nrxAMPDU_size;
-	u8 	nrxAMPDU_aggr_num;
+	u32	framesyncC34;
+	u8	framesyncMonitor;
+		//Added by amy 080516  for RX related
+	u16	nrxAMPDU_size;
+	u8	nrxAMPDU_aggr_num;
 
 	//by amy for gpio
 	 bool bHwRadioOff;
@@ -1204,7 +1204,7 @@ typedef enum{
 #ifdef JOHN_HWSEC
 struct ssid_thread {
 	struct net_device *dev;
-       	u8 name[IW_ESSID_MAX_SIZE + 1];
+	u8 name[IW_ESSID_MAX_SIZE + 1];
 };
 #endif
 
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 56367f2..1887dde 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -80,9 +80,9 @@ double __extendsfdf2(float a) {return a;}
 #include "dot11d.h"
 //set here to open your trace code. //WB
 u32 rt_global_debug_component = \
-			//	COMP_INIT    	|
+			//	COMP_INIT	|
 //				COMP_DBG	|
-			//	COMP_EPROM   	|
+			//	COMP_EPROM	|
 //				COMP_PHY	|
 			//	COMP_RF		|
 //				COMP_FIRMWARE	|
@@ -159,7 +159,7 @@ static struct usb_driver rtl8192_usb_driver = {
 	.resume		= rtl8192_resume,                 /* PM resume fn  */
 #else
 	.suspend	= NULL,				  /* PM suspend fn */
-	.resume      	= NULL,				  /* PM resume fn  */
+	.resume		= NULL,				  /* PM resume fn  */
 #endif
 };
 
@@ -171,11 +171,11 @@ typedef struct _CHANNEL_LIST
 }CHANNEL_LIST, *PCHANNEL_LIST;
 
 static CHANNEL_LIST ChannelPlan[] = {
-	{{1,2,3,4,5,6,7,8,9,10,11,36,40,44,48,52,56,60,64,149,153,157,161,165},24},  		//FCC
-	{{1,2,3,4,5,6,7,8,9,10,11},11},                    				//IC
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},  	//ETSI
+	{{1,2,3,4,5,6,7,8,9,10,11,36,40,44,48,52,56,60,64,149,153,157,161,165},24},		//FCC
+	{{1,2,3,4,5,6,7,8,9,10,11},11},							//IC
+	{{1,2,3,4,5,6,7,8,9,10,11,12,13,36,40,44,48,52,56,60,64},21},	//ETSI
 	{{1,2,3,4,5,6,7,8,9,10,11,12,13},13},    //Spain. Change to ETSI.
-	{{1,2,3,4,5,6,7,8,9,10,11,12,13},13},  	//France. Change to ETSI.
+	{{1,2,3,4,5,6,7,8,9,10,11,12,13},13},	//France. Change to ETSI.
 	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14,36,40,44,48,52,56,60,64},22},	//MKK					//MKK
 	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14,36,40,44,48,52,56,60,64},22},//MKK1
 	{{1,2,3,4,5,6,7,8,9,10,11,12,13},13},	//Israel.
@@ -240,7 +240,7 @@ static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv* priv)
 }
 
 
-#define 	rx_hal_is_cck_rate(_pdrvinfo)\
+#define		rx_hal_is_cck_rate(_pdrvinfo)\
 			(_pdrvinfo->RxRate == DESC90_RATE1M ||\
 			_pdrvinfo->RxRate == DESC90_RATE2M ||\
 			_pdrvinfo->RxRate == DESC90_RATE5_5M ||\
@@ -1272,8 +1272,8 @@ struct sk_buff *DrvAggr_Aggregation(struct net_device *dev, struct ieee80211_drv
 {
 	struct ieee80211_device *ieee = netdev_priv(dev);
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	cb_desc 	*tcb_desc = NULL;
-	u8 		i;
+	cb_desc		*tcb_desc = NULL;
+	u8		i;
 	u32		TotalLength;
 	struct sk_buff	*skb;
 	struct sk_buff  *agg_skb;
@@ -1444,7 +1444,7 @@ u8 DrvAggr_GetAggregatibleList(struct net_device *dev, struct sk_buff *skb,
 	struct ieee80211_device *ieee = netdev_priv(dev);
 	PRT_HIGH_THROUGHPUT	pHTInfo = ieee->pHTInfo;
 	u16		nMaxAggrNum = pHTInfo->UsbTxAggrNum;
-	cb_desc 	*tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
+	cb_desc		*tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 	u8		QueueID = tcb_desc->queue_index;
 
 	do {
@@ -1812,7 +1812,7 @@ short rtl819xU_tx_cmd(struct net_device *dev, struct sk_buff *skb)
 	int			status;
 	struct urb		*tx_urb;
 	//int			urb_buf_len;
-	unsigned int 		idx_pipe;
+	unsigned int		idx_pipe;
 	tx_desc_cmd_819x_usb *pdesc = (tx_desc_cmd_819x_usb *)skb->data;
 	cb_desc *tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 	u8 queue_index = tcb_desc->queue_index;
@@ -2346,7 +2346,7 @@ void rtl8192_update_beacon(struct work_struct * work)
 {
         struct r8192_priv *priv = container_of(work, struct r8192_priv, update_beacon_wq.work);
         struct net_device *dev = priv->ieee80211->dev;
- 	struct ieee80211_device* ieee = priv->ieee80211;
+	struct ieee80211_device* ieee = priv->ieee80211;
 	struct ieee80211_network* net = &ieee->current_network;
 
 	if (ieee->pHTInfo->bCurrentHTSupport)
@@ -2717,7 +2717,7 @@ static void rtl8192_init_priv_variable(struct net_device* dev)
 	priv->bDisableNormalResetCheck = false;
 	priv->force_reset = false;
 
-	priv->ieee80211->FwRWRF = 0; 	//we don't use FW read/write RF until stable firmware is available.
+	priv->ieee80211->FwRWRF = 0;	//we don't use FW read/write RF until stable firmware is available.
 	priv->ieee80211->current_network.beacon_interval = DEFAULT_BEACONINTERVAL;
 	priv->ieee80211->iw_mode = IW_MODE_INFRA;
 	priv->ieee80211->softmac_features  = IEEE_SOFTMAC_SCAN |
@@ -2778,11 +2778,11 @@ static void rtl8192_init_priv_variable(struct net_device* dev)
 #ifdef TO_DO_LIST
 	if(Adapter->bInHctTest)
 		pHalData->ReceiveConfig	=	pHalData->CSMethod |
-						RCR_AMF | RCR_ADF |	//RCR_AAP | 	//accept management/data
+						RCR_AMF | RCR_ADF |	//RCR_AAP |	//accept management/data
 						//guangan200710
 						RCR_ACF |	//accept control frame for SW AP needs PS-poll, 2005.07.07, by rcnjko.
 						RCR_AB | RCR_AM | RCR_APM |		//accept BC/MC/UC
-						RCR_AICV | RCR_ACRC32 | 		//accept ICV/CRC error packet
+						RCR_AICV | RCR_ACRC32 |			//accept ICV/CRC error packet
 						((u32)7<<RCR_MXDMA_OFFSET) | // Max DMA Burst Size per Rx DMA Burst, 7: unlimited.
 						(pHalData->EarlyRxThreshold<<RCR_FIFO_OFFSET) | // Rx FIFO Threshold, 7: No Rx threshold.
 						(pHalData->EarlyRxThreshold == 7 ? RCR_OnlyErlPkt:0);
@@ -2793,7 +2793,7 @@ static void rtl8192_init_priv_variable(struct net_device* dev)
 		RCR_AMF | RCR_ADF |		//accept management/data
 		RCR_ACF |			//accept control frame for SW AP needs PS-poll, 2005.07.07, by rcnjko.
 		RCR_AB | RCR_AM | RCR_APM |	//accept BC/MC/UC
-		//RCR_AICV | RCR_ACRC32 | 	//accept ICV/CRC error packet
+		//RCR_AICV | RCR_ACRC32 |	//accept ICV/CRC error packet
 		((u32)7<<RCR_MXDMA_OFFSET)| // Max DMA Burst Size per Rx DMA Burst, 7: unlimited.
 		(priv->EarlyRxThreshold<<RX_FIFO_THRESHOLD_SHIFT) | // Rx FIFO Threshold, 7: No Rx threshold.
 		(priv->EarlyRxThreshold == 7 ? RCR_ONLYERLPKT:0);
@@ -3549,7 +3549,7 @@ HalTxCheckStuck819xUsb(
 	)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	u16 		RegTxCounter = read_nic_word(dev, 0x128);
+	u16		RegTxCounter = read_nic_word(dev, 0x128);
 	bool		bStuck = FALSE;
 	RT_TRACE(COMP_RESET,"%s():RegTxCounter is %d,TxCounter is %d\n",__FUNCTION__,RegTxCounter,priv->TxCounter);
 	if(priv->TxCounter==RegTxCounter)
@@ -3583,14 +3583,14 @@ TxCheckStuck(struct net_device *dev)
 //	     spin_lock_irqsave(&priv->ieee80211->lock,flags);
 	     for (QueueID = 0; QueueID<=BEACON_QUEUE;QueueID ++)
 	     {
-	     		if(QueueID == TXCMD_QUEUE)
+			if(QueueID == TXCMD_QUEUE)
 		         continue;
 #ifdef USB_TX_DRIVER_AGGREGATION_ENABLE
 			if((skb_queue_len(&priv->ieee80211->skb_waitQ[QueueID]) == 0) && (skb_queue_len(&priv->ieee80211->skb_aggQ[QueueID]) == 0) && (skb_queue_len(&priv->ieee80211->skb_drv_aggQ[QueueID]) == 0))
 #else
-		     	if((skb_queue_len(&priv->ieee80211->skb_waitQ[QueueID]) == 0)  && (skb_queue_len(&priv->ieee80211->skb_aggQ[QueueID]) == 0))
+			if((skb_queue_len(&priv->ieee80211->skb_waitQ[QueueID]) == 0)  && (skb_queue_len(&priv->ieee80211->skb_aggQ[QueueID]) == 0))
 #endif
-			 	continue;
+				continue;
 
 	             bCheckFwTxCnt = true;
 	     }
@@ -3611,7 +3611,7 @@ TxCheckStuck(struct net_device *dev)
 bool
 HalRxCheckStuck819xUsb(struct net_device *dev)
 {
-	u16 	RegRxCounter = read_nic_word(dev, 0x130);
+	u16	RegRxCounter = read_nic_word(dev, 0x130);
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	bool bStuck = FALSE;
 	static u8	rx_chk_cnt = 0;
@@ -3718,7 +3718,7 @@ rtl819x_ifcheck_resetornot(struct net_device *dev)
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	RESET_TYPE	TxResetType = RESET_TYPE_NORESET;
 	RESET_TYPE	RxResetType = RESET_TYPE_NORESET;
-	RT_RF_POWER_STATE 	rfState;
+	RT_RF_POWER_STATE	rfState;
 
 	rfState = priv->ieee80211->eRFPowerState;
 
@@ -4006,18 +4006,18 @@ RESET_START:
 
 void CAM_read_entry(
 	struct net_device *dev,
-	u32	 		iIndex
+	u32			iIndex
 )
 {
- 	u32 target_command=0;
+	u32 target_command=0;
 	 u32 target_content=0;
 	 u8 entry_i=0;
 	 u32 ulStatus;
 	s32 i=100;
 //	printk("=======>start read CAM\n");
- 	for(entry_i=0;entry_i<CAM_CONTENT_COUNT;entry_i++)
- 	{
-   	// polling bit, and No Write enable, and address
+	for(entry_i=0;entry_i<CAM_CONTENT_COUNT;entry_i++)
+	{
+	// polling bit, and No Write enable, and address
 		target_command= entry_i+CAM_CONTENT_COUNT*iIndex;
 		target_command= target_command | BIT31;
 
@@ -4049,7 +4049,7 @@ void rtl819x_update_rxcounts(
 	u32* TotalRxDataNum
 )
 {
-	u16 			SlotIndex;
+	u16			SlotIndex;
 	u8			i;
 
 	*TotalRxBcnNum = 0;
@@ -4122,7 +4122,7 @@ extern	void	rtl819x_watchdog_wqcallback(struct work_struct *work)
 	//check if reset the driver
 	if(check_reset_cnt++ >= 3)
 	{
-    		ResetType = rtl819x_ifcheck_resetornot(dev);
+		ResetType = rtl819x_ifcheck_resetornot(dev);
 		check_reset_cnt = 3;
 		//DbgPrint("Start to check silent reset\n");
 	}
@@ -4418,10 +4418,10 @@ int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 							setKey(	dev,
 								ipw->u.crypt.idx,
 								ipw->u.crypt.idx,		//KeyIndex
-						     		ieee->group_key_type,	//KeyType
-						            	broadcast_addr,	//MacAddr
+								ieee->group_key_type,	//KeyType
+								broadcast_addr,	//MacAddr
 								0,		//DefaultKey
-							      	key);		//KeyContent
+								key);		//KeyContent
 					}
 				}
 			}
@@ -4819,7 +4819,7 @@ rtl819x_evm_dbtopercentage(
 }
 //
 //	Description:
-// 	We want good-looking for signal strength/quality
+//	We want good-looking for signal strength/quality
 //	2007/7/19 01:09, by cosa.
 //
 long
@@ -5203,7 +5203,7 @@ void TranslateRxSignalStuff819xUsb(struct sk_buff *skb,
 * Overview:	Record the received data rate
 *
 * Input:
-* 	struct net_device *dev
+*	struct net_device *dev
 *	struct ieee80211_rx_stats *stats
 *
 * Output:
@@ -5581,7 +5581,7 @@ rtl819xusb_process_received_packet(
 	)
 {
 //	bool bfreerfd=false, bqueued=false;
-	u8* 	frame;
+	u8*	frame;
 	u16     frame_len=0;
 	struct r8192_priv *priv = ieee80211_priv(dev);
 //	u8			index = 0;
@@ -6007,7 +6007,7 @@ void setKey(	struct net_device *dev,
 	//		printk("setkey cam =%8x\n", read_cam(dev, i+6*EntryNo));
 		}
 		else if(i==1){//MAC
-			TargetContent = (u32)(*(MacAddr+2)) 	 |
+			TargetContent = (u32)(*(MacAddr+2))	 |
 					(u32)(*(MacAddr+3)) <<  8|
 					(u32)(*(MacAddr+4)) << 16|
 					(u32)(*(MacAddr+5)) << 24;
diff --git a/drivers/staging/rtl8192u/r8192U_dm.c b/drivers/staging/rtl8192u/r8192U_dm.c
index cd8dc85..7e2918f 100644
--- a/drivers/staging/rtl8192u/r8192U_dm.c
+++ b/drivers/staging/rtl8192u/r8192U_dm.c
@@ -8,7 +8,7 @@ Abstract:
 	HW dynamic mechanism.
 
 Major Change History:
-	When      	Who				What
+	When		Who				What
 	----------	--------------- -------------------------------
 	2008-05-14	amy                     create version 0 porting from windows code.
 
@@ -25,9 +25,9 @@ Major Change History:
 // Indicate different AP vendor for IOT issue.
 //
 static u32 edca_setting_DL[HT_IOT_PEER_MAX] =
-		{ 0x5e4322, 	0x5e4322, 	0x5e4322, 	0x604322, 	0xa44f, 	0x5ea44f};
+		{ 0x5e4322,	0x5e4322,	0x5e4322,	0x604322,	0xa44f,		0x5ea44f};
 static u32 edca_setting_UL[HT_IOT_PEER_MAX] =
-		{ 0x5e4322, 	0xa44f, 	0x5e4322, 	0x604322, 	0x5ea44f, 	0x5ea44f};
+		{ 0x5e4322,	0xa44f,		0x5e4322,	0x604322,	0x5ea44f,	0x5ea44f};
 
 
 #define RTK_UL_EDCA 0xa44f
@@ -134,7 +134,7 @@ static	void dm_check_pbc_gpio(struct net_device *dev);
 
 // DM --> Check current RX RF path state
 static	void	dm_check_rx_path_selection(struct net_device *dev);
-static 	void dm_init_rxpath_selection(struct net_device *dev);
+static	void dm_init_rxpath_selection(struct net_device *dev);
 static	void dm_rxpath_sel_byrssi(struct net_device *dev);
 
 
@@ -259,7 +259,7 @@ extern  void    hal_dm_watchdog(struct net_device *dev)
 {
 	//struct r8192_priv *priv = ieee80211_priv(dev);
 
-	//static u8 	previous_bssid[6] ={0};
+	//static u8	previous_bssid[6] ={0};
 
 	/*Add by amy 2008/05/15 ,porting from windows code.*/
 	dm_check_rate_adaptive(dev);
@@ -315,21 +315,21 @@ extern void init_rate_adaptive(struct net_device * dev)
 	{
 		// 07/10/08 MH Modify for RA smooth scheme.
 		/* 2008/01/11 MH Modify 2T RATR table for different RSSI. 080515 porting by amy from windows code.*/
-		pra->upper_rssi_threshold_ratr		= 	0x8f0f0000;
-		pra->middle_rssi_threshold_ratr		= 	0x8f0ff000;
-		pra->low_rssi_threshold_ratr		= 	0x8f0ff001;
-		pra->low_rssi_threshold_ratr_40M	= 	0x8f0ff005;
-		pra->low_rssi_threshold_ratr_20M	= 	0x8f0ff001;
-		pra->ping_rssi_ratr	= 	0x0000000d;//cosa add for test
+		pra->upper_rssi_threshold_ratr		=	0x8f0f0000;
+		pra->middle_rssi_threshold_ratr		=	0x8f0ff000;
+		pra->low_rssi_threshold_ratr		=	0x8f0ff001;
+		pra->low_rssi_threshold_ratr_40M	=	0x8f0ff005;
+		pra->low_rssi_threshold_ratr_20M	=	0x8f0ff001;
+		pra->ping_rssi_ratr	=	0x0000000d;//cosa add for test
 	}
 	else if (priv->rf_type == RF_1T2R)
 	{
-		pra->upper_rssi_threshold_ratr		= 	0x000f0000;
-		pra->middle_rssi_threshold_ratr		= 	0x000ff000;
-		pra->low_rssi_threshold_ratr		= 	0x000ff001;
-		pra->low_rssi_threshold_ratr_40M	= 	0x000ff005;
-		pra->low_rssi_threshold_ratr_20M	= 	0x000ff001;
-		pra->ping_rssi_ratr	= 	0x0000000d;//cosa add for test
+		pra->upper_rssi_threshold_ratr		=	0x000f0000;
+		pra->middle_rssi_threshold_ratr		=	0x000ff000;
+		pra->low_rssi_threshold_ratr		=	0x000ff001;
+		pra->low_rssi_threshold_ratr_40M	=	0x000ff005;
+		pra->low_rssi_threshold_ratr_20M	=	0x000ff001;
+		pra->ping_rssi_ratr	=	0x0000000d;//cosa add for test
 	}
 
 }	// InitRateAdaptive
@@ -348,7 +348,7 @@ extern void init_rate_adaptive(struct net_device * dev)
  *
  * Revised History:
  *	When		Who		Remark
- *	05/26/08	amy 	Create version 0 porting from windows code.
+ *	05/26/08	amy	Create version 0 porting from windows code.
  *
  *---------------------------------------------------------------------------*/
 static void dm_check_rate_adaptive(struct net_device * dev)
@@ -413,14 +413,14 @@ static void dm_check_rate_adaptive(struct net_device * dev)
 		   to prevent jumping frequently. */
 		if (pra->ratr_state == DM_RATR_STA_HIGH)
 		{
-			HighRSSIThreshForRA 	= pra->high2low_rssi_thresh_for_ra;
+			HighRSSIThreshForRA	= pra->high2low_rssi_thresh_for_ra;
 			LowRSSIThreshForRA	= (priv->CurrentChannelBW != HT_CHANNEL_WIDTH_20)?
 					(pra->low_rssi_thresh_for_ra40M):(pra->low_rssi_thresh_for_ra20M);
 		}
 		else if (pra->ratr_state == DM_RATR_STA_LOW)
 		{
 			HighRSSIThreshForRA	= pra->high_rssi_thresh_for_ra;
-			LowRSSIThreshForRA 	= (priv->CurrentChannelBW != HT_CHANNEL_WIDTH_20)?
+			LowRSSIThreshForRA	= (priv->CurrentChannelBW != HT_CHANNEL_WIDTH_20)?
 					(pra->low2high_rssi_thresh_for_ra40M):(pra->low2high_rssi_thresh_for_ra20M);
 		}
 		else
@@ -599,7 +599,7 @@ static void dm_TXPowerTrackingCallback_TSSI(struct net_device * dev)
 	u32						Value;
 	u8						Pwr_Flag;
 	u16						Avg_TSSI_Meas, TSSI_13dBm, Avg_TSSI_Meas_from_driver=0;
-	//RT_STATUS 				rtStatus = RT_STATUS_SUCCESS;
+	//RT_STATUS				rtStatus = RT_STATUS_SUCCESS;
 	bool rtStatus = true;
 	u32						delta=0;
 
@@ -954,79 +954,79 @@ static void dm_InitializeTXPowerTracking_TSSI(struct net_device *dev)
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
 	//Initial the Tx BB index and mapping value
-	priv->txbbgain_table[0].txbb_iq_amplifygain = 			12;
+	priv->txbbgain_table[0].txbb_iq_amplifygain =			12;
 	priv->txbbgain_table[0].txbbgain_value=0x7f8001fe;
-	priv->txbbgain_table[1].txbb_iq_amplifygain = 			11;
+	priv->txbbgain_table[1].txbb_iq_amplifygain =			11;
 	priv->txbbgain_table[1].txbbgain_value=0x788001e2;
-	priv->txbbgain_table[2].txbb_iq_amplifygain = 			10;
+	priv->txbbgain_table[2].txbb_iq_amplifygain =			10;
 	priv->txbbgain_table[2].txbbgain_value=0x71c001c7;
-	priv->txbbgain_table[3].txbb_iq_amplifygain = 			9;
+	priv->txbbgain_table[3].txbb_iq_amplifygain =			9;
 	priv->txbbgain_table[3].txbbgain_value=0x6b8001ae;
-	priv->txbbgain_table[4].txbb_iq_amplifygain = 		       8;
+	priv->txbbgain_table[4].txbb_iq_amplifygain =		       8;
 	priv->txbbgain_table[4].txbbgain_value=0x65400195;
-	priv->txbbgain_table[5].txbb_iq_amplifygain = 		       7;
+	priv->txbbgain_table[5].txbb_iq_amplifygain =		       7;
 	priv->txbbgain_table[5].txbbgain_value=0x5fc0017f;
-	priv->txbbgain_table[6].txbb_iq_amplifygain = 		       6;
+	priv->txbbgain_table[6].txbb_iq_amplifygain =		       6;
 	priv->txbbgain_table[6].txbbgain_value=0x5a400169;
-	priv->txbbgain_table[7].txbb_iq_amplifygain = 		       5;
+	priv->txbbgain_table[7].txbb_iq_amplifygain =		       5;
 	priv->txbbgain_table[7].txbbgain_value=0x55400155;
-	priv->txbbgain_table[8].txbb_iq_amplifygain = 		       4;
+	priv->txbbgain_table[8].txbb_iq_amplifygain =		       4;
 	priv->txbbgain_table[8].txbbgain_value=0x50800142;
-	priv->txbbgain_table[9].txbb_iq_amplifygain = 		       3;
+	priv->txbbgain_table[9].txbb_iq_amplifygain =		       3;
 	priv->txbbgain_table[9].txbbgain_value=0x4c000130;
-	priv->txbbgain_table[10].txbb_iq_amplifygain = 		       2;
+	priv->txbbgain_table[10].txbb_iq_amplifygain =		       2;
 	priv->txbbgain_table[10].txbbgain_value=0x47c0011f;
-	priv->txbbgain_table[11].txbb_iq_amplifygain = 		       1;
+	priv->txbbgain_table[11].txbb_iq_amplifygain =		       1;
 	priv->txbbgain_table[11].txbbgain_value=0x43c0010f;
-	priv->txbbgain_table[12].txbb_iq_amplifygain = 		       0;
+	priv->txbbgain_table[12].txbb_iq_amplifygain =		       0;
 	priv->txbbgain_table[12].txbbgain_value=0x40000100;
-	priv->txbbgain_table[13].txbb_iq_amplifygain = 		       -1;
+	priv->txbbgain_table[13].txbb_iq_amplifygain =		       -1;
 	priv->txbbgain_table[13].txbbgain_value=0x3c8000f2;
-	priv->txbbgain_table[14].txbb_iq_amplifygain = 		     -2;
+	priv->txbbgain_table[14].txbb_iq_amplifygain =		     -2;
 	priv->txbbgain_table[14].txbbgain_value=0x390000e4;
-	priv->txbbgain_table[15].txbb_iq_amplifygain = 		     -3;
+	priv->txbbgain_table[15].txbb_iq_amplifygain =		     -3;
 	priv->txbbgain_table[15].txbbgain_value=0x35c000d7;
-	priv->txbbgain_table[16].txbb_iq_amplifygain = 		     -4;
+	priv->txbbgain_table[16].txbb_iq_amplifygain =		     -4;
 	priv->txbbgain_table[16].txbbgain_value=0x32c000cb;
-	priv->txbbgain_table[17].txbb_iq_amplifygain = 		     -5;
+	priv->txbbgain_table[17].txbb_iq_amplifygain =		     -5;
 	priv->txbbgain_table[17].txbbgain_value=0x300000c0;
-	priv->txbbgain_table[18].txbb_iq_amplifygain = 			    -6;
+	priv->txbbgain_table[18].txbb_iq_amplifygain =			    -6;
 	priv->txbbgain_table[18].txbbgain_value=0x2d4000b5;
-	priv->txbbgain_table[19].txbb_iq_amplifygain = 		     -7;
+	priv->txbbgain_table[19].txbb_iq_amplifygain =		     -7;
 	priv->txbbgain_table[19].txbbgain_value=0x2ac000ab;
-	priv->txbbgain_table[20].txbb_iq_amplifygain = 		     -8;
+	priv->txbbgain_table[20].txbb_iq_amplifygain =		     -8;
 	priv->txbbgain_table[20].txbbgain_value=0x288000a2;
-	priv->txbbgain_table[21].txbb_iq_amplifygain = 		     -9;
+	priv->txbbgain_table[21].txbb_iq_amplifygain =		     -9;
 	priv->txbbgain_table[21].txbbgain_value=0x26000098;
-	priv->txbbgain_table[22].txbb_iq_amplifygain = 		     -10;
+	priv->txbbgain_table[22].txbb_iq_amplifygain =		     -10;
 	priv->txbbgain_table[22].txbbgain_value=0x24000090;
-	priv->txbbgain_table[23].txbb_iq_amplifygain = 		     -11;
+	priv->txbbgain_table[23].txbb_iq_amplifygain =		     -11;
 	priv->txbbgain_table[23].txbbgain_value=0x22000088;
-	priv->txbbgain_table[24].txbb_iq_amplifygain = 		     -12;
+	priv->txbbgain_table[24].txbb_iq_amplifygain =		     -12;
 	priv->txbbgain_table[24].txbbgain_value=0x20000080;
-	priv->txbbgain_table[25].txbb_iq_amplifygain = 		     -13;
+	priv->txbbgain_table[25].txbb_iq_amplifygain =		     -13;
 	priv->txbbgain_table[25].txbbgain_value=0x1a00006c;
-	priv->txbbgain_table[26].txbb_iq_amplifygain = 		     -14;
+	priv->txbbgain_table[26].txbb_iq_amplifygain =		     -14;
 	priv->txbbgain_table[26].txbbgain_value=0x1c800072;
-	priv->txbbgain_table[27].txbb_iq_amplifygain = 		     -15;
+	priv->txbbgain_table[27].txbb_iq_amplifygain =		     -15;
 	priv->txbbgain_table[27].txbbgain_value=0x18000060;
-	priv->txbbgain_table[28].txbb_iq_amplifygain = 		     -16;
+	priv->txbbgain_table[28].txbb_iq_amplifygain =		     -16;
 	priv->txbbgain_table[28].txbbgain_value=0x19800066;
-	priv->txbbgain_table[29].txbb_iq_amplifygain = 		     -17;
+	priv->txbbgain_table[29].txbb_iq_amplifygain =		     -17;
 	priv->txbbgain_table[29].txbbgain_value=0x15800056;
-	priv->txbbgain_table[30].txbb_iq_amplifygain = 		     -18;
+	priv->txbbgain_table[30].txbb_iq_amplifygain =		     -18;
 	priv->txbbgain_table[30].txbbgain_value=0x26c0005b;
-	priv->txbbgain_table[31].txbb_iq_amplifygain = 		     -19;
+	priv->txbbgain_table[31].txbb_iq_amplifygain =		     -19;
 	priv->txbbgain_table[31].txbbgain_value=0x14400051;
-	priv->txbbgain_table[32].txbb_iq_amplifygain = 		     -20;
+	priv->txbbgain_table[32].txbb_iq_amplifygain =		     -20;
 	priv->txbbgain_table[32].txbbgain_value=0x24400051;
-	priv->txbbgain_table[33].txbb_iq_amplifygain = 		     -21;
+	priv->txbbgain_table[33].txbb_iq_amplifygain =		     -21;
 	priv->txbbgain_table[33].txbbgain_value=0x1300004c;
-	priv->txbbgain_table[34].txbb_iq_amplifygain = 		     -22;
+	priv->txbbgain_table[34].txbb_iq_amplifygain =		     -22;
 	priv->txbbgain_table[34].txbbgain_value=0x12000048;
-	priv->txbbgain_table[35].txbb_iq_amplifygain = 		     -23;
+	priv->txbbgain_table[35].txbb_iq_amplifygain =		     -23;
 	priv->txbbgain_table[35].txbbgain_value=0x11000044;
-	priv->txbbgain_table[36].txbb_iq_amplifygain = 		     -24;
+	priv->txbbgain_table[36].txbb_iq_amplifygain =		     -24;
 	priv->txbbgain_table[36].txbbgain_value=0x10000040;
 
 	//ccktxbb_valuearray[0] is 0xA22 [1] is 0xA24 ...[7] is 0xA29
@@ -1505,7 +1505,7 @@ static void dm_CheckTXPowerTracking_TSSI(struct net_device *dev)
 static void dm_CheckTXPowerTracking_ThermalMeter(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	static u8 	TM_Trigger=0;
+	static u8	TM_Trigger=0;
 	//DbgPrint("dm_CheckTXPowerTracking() \n");
 	if(!priv->btxpower_tracking)
 		return;
@@ -1564,40 +1564,40 @@ static void dm_CCKTxPowerAdjust_TSSI(struct net_device *dev, bool  bInCH14)
 	TempVal = 0;
 	if(!bInCH14){
 		//Write 0xa22 0xa23
-		TempVal = 	priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[0] +
+		TempVal =	priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[0] +
 					(priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[1]<<8) ;
 
 		rtl8192_setBBreg(dev, rCCK0_TxFilter1,bMaskHWord, TempVal);
 		//Write 0xa24 ~ 0xa27
 		TempVal = 0;
-		TempVal = 	priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[2] +
+		TempVal =	priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[2] +
 					(priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[3]<<8) +
 					(priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[4]<<16 )+
 					(priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[5]<<24);
 		rtl8192_setBBreg(dev, rCCK0_TxFilter2,bMaskDWord, TempVal);
 		//Write 0xa28  0xa29
 		TempVal = 0;
-		TempVal = 	priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[6] +
+		TempVal =	priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[6] +
 					(priv->cck_txbbgain_table[priv->cck_present_attentuation].ccktxbb_valuearray[7]<<8) ;
 
 		rtl8192_setBBreg(dev, rCCK0_DebugPort,bMaskLWord, TempVal);
 	}
 	else
 	{
-		TempVal = 	priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[0] +
+		TempVal =	priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[0] +
 					(priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[1]<<8) ;
 
 		rtl8192_setBBreg(dev, rCCK0_TxFilter1,bMaskHWord, TempVal);
 		//Write 0xa24 ~ 0xa27
 		TempVal = 0;
-		TempVal = 	priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[2] +
+		TempVal =	priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[2] +
 					(priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[3]<<8) +
 					(priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[4]<<16 )+
 					(priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[5]<<24);
 		rtl8192_setBBreg(dev, rCCK0_TxFilter2,bMaskDWord, TempVal);
 		//Write 0xa28  0xa29
 		TempVal = 0;
-		TempVal = 	priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[6] +
+		TempVal =	priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[6] +
 					(priv->cck_txbbgain_ch14_table[priv->cck_present_attentuation].ccktxbb_valuearray[7]<<8) ;
 
 		rtl8192_setBBreg(dev, rCCK0_DebugPort,bMaskLWord, TempVal);
@@ -1615,14 +1615,14 @@ static void dm_CCKTxPowerAdjust_ThermalMeter(struct net_device *dev,	bool  bInCH
 	if(!bInCH14)
 	{
 		//Write 0xa22 0xa23
-		TempVal = 	CCKSwingTable_Ch1_Ch13[priv->CCK_index][0] +
+		TempVal =	CCKSwingTable_Ch1_Ch13[priv->CCK_index][0] +
 					(CCKSwingTable_Ch1_Ch13[priv->CCK_index][1]<<8) ;
 		rtl8192_setBBreg(dev, rCCK0_TxFilter1, bMaskHWord, TempVal);
 		RT_TRACE(COMP_POWER_TRACKING, "CCK not chnl 14, reg 0x%x = 0x%x\n",
 			rCCK0_TxFilter1, TempVal);
 		//Write 0xa24 ~ 0xa27
 		TempVal = 0;
-		TempVal = 	CCKSwingTable_Ch1_Ch13[priv->CCK_index][2] +
+		TempVal =	CCKSwingTable_Ch1_Ch13[priv->CCK_index][2] +
 					(CCKSwingTable_Ch1_Ch13[priv->CCK_index][3]<<8) +
 					(CCKSwingTable_Ch1_Ch13[priv->CCK_index][4]<<16 )+
 					(CCKSwingTable_Ch1_Ch13[priv->CCK_index][5]<<24);
@@ -1631,7 +1631,7 @@ static void dm_CCKTxPowerAdjust_ThermalMeter(struct net_device *dev,	bool  bInCH
 			rCCK0_TxFilter2, TempVal);
 		//Write 0xa28  0xa29
 		TempVal = 0;
-		TempVal = 	CCKSwingTable_Ch1_Ch13[priv->CCK_index][6] +
+		TempVal =	CCKSwingTable_Ch1_Ch13[priv->CCK_index][6] +
 					(CCKSwingTable_Ch1_Ch13[priv->CCK_index][7]<<8) ;
 
 		rtl8192_setBBreg(dev, rCCK0_DebugPort, bMaskLWord, TempVal);
@@ -1642,7 +1642,7 @@ static void dm_CCKTxPowerAdjust_ThermalMeter(struct net_device *dev,	bool  bInCH
 	{
 //		priv->CCKTxPowerAdjustCntNotCh14++;	//cosa add for debug.
 		//Write 0xa22 0xa23
-		TempVal = 	CCKSwingTable_Ch14[priv->CCK_index][0] +
+		TempVal =	CCKSwingTable_Ch14[priv->CCK_index][0] +
 					(CCKSwingTable_Ch14[priv->CCK_index][1]<<8) ;
 
 		rtl8192_setBBreg(dev, rCCK0_TxFilter1, bMaskHWord, TempVal);
@@ -1650,7 +1650,7 @@ static void dm_CCKTxPowerAdjust_ThermalMeter(struct net_device *dev,	bool  bInCH
 			rCCK0_TxFilter1, TempVal);
 		//Write 0xa24 ~ 0xa27
 		TempVal = 0;
-		TempVal = 	CCKSwingTable_Ch14[priv->CCK_index][2] +
+		TempVal =	CCKSwingTable_Ch14[priv->CCK_index][2] +
 					(CCKSwingTable_Ch14[priv->CCK_index][3]<<8) +
 					(CCKSwingTable_Ch14[priv->CCK_index][4]<<16 )+
 					(CCKSwingTable_Ch14[priv->CCK_index][5]<<24);
@@ -1659,7 +1659,7 @@ static void dm_CCKTxPowerAdjust_ThermalMeter(struct net_device *dev,	bool  bInCH
 			rCCK0_TxFilter2, TempVal);
 		//Write 0xa28  0xa29
 		TempVal = 0;
-		TempVal = 	CCKSwingTable_Ch14[priv->CCK_index][6] +
+		TempVal =	CCKSwingTable_Ch14[priv->CCK_index][6] +
 					(CCKSwingTable_Ch14[priv->CCK_index][7]<<8) ;
 
 		rtl8192_setBBreg(dev, rCCK0_DebugPort, bMaskLWord, TempVal);
@@ -1713,7 +1713,7 @@ static void dm_txpower_reset_recovery(
 extern void dm_restore_dynamic_mechanism_state(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	u32 	reg_ratr = priv->rate_adaptive.last_ratr;
+	u32	reg_ratr = priv->rate_adaptive.last_ratr;
 
 	if(!priv->up)
 	{
@@ -1934,7 +1934,7 @@ dm_change_rxpath_selection_setting(
 	s32		DM_Value)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	prate_adaptive 	pRA = (prate_adaptive)&(priv->rate_adaptive);
+	prate_adaptive	pRA = (prate_adaptive)&(priv->rate_adaptive);
 
 
 	if(DM_Type == 0)
@@ -2036,8 +2036,8 @@ static void dm_dig_init(struct net_device *dev)
 	dm_digtable.dig_highpwr_state	= DM_STA_DIG_MAX;
 	dm_digtable.initialgain_lowerbound_state = false;
 
-	dm_digtable.rssi_low_thresh 	= DM_DIG_THRESH_LOW;
-	dm_digtable.rssi_high_thresh 	= DM_DIG_THRESH_HIGH;
+	dm_digtable.rssi_low_thresh	= DM_DIG_THRESH_LOW;
+	dm_digtable.rssi_high_thresh	= DM_DIG_THRESH_HIGH;
 
 	dm_digtable.rssi_high_power_lowthresh = DM_DIG_HIGH_PWR_THRESH_LOW;
 	dm_digtable.rssi_high_power_highthresh = DM_DIG_HIGH_PWR_THRESH_HIGH;
@@ -2091,7 +2091,7 @@ static void dm_ctrl_initgain_byrssi_by_driverrssi(
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 	u8 i;
-	static u8 	fw_dig=0;
+	static u8	fw_dig=0;
 
 	if (dm_digtable.dig_enable_flag == false)
 		return;
@@ -2871,7 +2871,7 @@ static void dm_check_rfctrl_gpio(struct net_device * dev)
  *
  * Revised History:
  *	When		Who		Remark
- *	05/28/2008	amy 	Create Version 0 porting from windows code.
+ *	05/28/2008	amy	Create Version 0 porting from windows code.
  *
  *---------------------------------------------------------------------------*/
 static	void	dm_check_pbc_gpio(struct net_device *dev)
@@ -3517,8 +3517,8 @@ static void dm_EndSWFsync(struct net_device *dev)
 static void dm_StartSWFsync(struct net_device *dev)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	u32 			rateIndex;
-	u32 			rateBitmap;
+	u32			rateIndex;
+	u32			rateBitmap;
 
 	RT_TRACE(COMP_HALDM,"%s\n", __FUNCTION__);
 	// Initial rate record to zero, start to record.
@@ -3569,7 +3569,7 @@ void dm_check_fsync(struct net_device *dev)
 #define	RegC38_NonFsync_Other_AP	1
 #define	RegC38_Fsync_AP_BCM		2
 	struct r8192_priv *priv = ieee80211_priv(dev);
-	//u32 			framesyncC34;
+	//u32			framesyncC34;
 	static u8		reg_c38_State=RegC38_Default;
 	static u32	reset_cnt=0;
 
@@ -3887,4 +3887,3 @@ static void dm_send_rssi_tofw(struct net_device *dev)
 }
 
 /*---------------------------Define function prototype------------------------*/
-
diff --git a/drivers/staging/rtl8192u/r8192U_dm.h b/drivers/staging/rtl8192u/r8192U_dm.h
index 3ceb59b..8a96e9f 100644
--- a/drivers/staging/rtl8192u/r8192U_dm.h
+++ b/drivers/staging/rtl8192u/r8192U_dm.h
@@ -13,7 +13,7 @@
  *
  * History:
  *	Data		Who		Remark
- *	10/04/2007  MHC    	Create initial version.
+ *	10/04/2007  MHC		Create initial version.
  *
  *****************************************************************************/
  /* Check to see if the file has been included already.  */
@@ -55,12 +55,12 @@
 #define		TX_POWER_NEAR_FIELD_THRESH_LOW		62
 //added by amy for atheros AP
 #define         TX_POWER_ATHEROAP_THRESH_HIGH           78
-#define 	TX_POWER_ATHEROAP_THRESH_LOW		72
+#define		TX_POWER_ATHEROAP_THRESH_LOW		72
 
 //defined by vivi, for showing on UI
-#define 		Current_Tx_Rate_Reg         0x1b8
-#define 		Initial_Tx_Rate_Reg         	  0x1b9
-#define 		Tx_Retry_Count_Reg         0x1ac
+#define			Current_Tx_Rate_Reg         0x1b8
+#define			Initial_Tx_Rate_Reg		  0x1b9
+#define			Tx_Retry_Count_Reg         0x1ac
 #define		RegC38_TH				 20
 /*--------------------------Define Parameters-------------------------------*/
 
@@ -132,8 +132,8 @@ typedef enum tag_dynamic_init_gain_operation_type_definition
 	DIG_TYPE_PWDB_FACTOR			= 8,
 	DIG_TYPE_RX_GAIN_MIN				= 9,
 	DIG_TYPE_RX_GAIN_MAX				= 10,
-	DIG_TYPE_ENABLE 		= 20,
-	DIG_TYPE_DISABLE 		= 30,
+	DIG_TYPE_ENABLE			= 20,
+	DIG_TYPE_DISABLE		= 30,
 	DIG_OP_TYPE_MAX
 }dm_dig_op_e;
 
@@ -251,4 +251,3 @@ extern void dm_initialize_txpower_tracking(struct net_device *dev);
 
 
 /* End of r8192U_dm.h */
-
diff --git a/drivers/staging/rtl8192u/r8192U_hw.h b/drivers/staging/rtl8192u/r8192U_hw.h
index 1bfe871..15b0423 100644
--- a/drivers/staging/rtl8192u/r8192U_hw.h
+++ b/drivers/staging/rtl8192u/r8192U_hw.h
@@ -122,7 +122,7 @@ enum _RTL8192Usb_HW {
 	SIFS			= 0x03E, // SIFS register
 	TCR			= 0x040, // Transmit Configuration Register
 
-#define TCR_MXDMA_2048 		7
+#define TCR_MXDMA_2048		7
 #define TCR_LRL_OFFSET		0
 #define TCR_SRL_OFFSET		8
 #define TCR_MXDMA_OFFSET	21
@@ -379,7 +379,7 @@ enum _RTL8192Usb_HW {
 //	IMR_POLL		= 0x360,
 	MacBlkCtrl		= 0x403, // Mac block on/off control register
 
-	EPROM_CMD 		= 0xfe58,
+	EPROM_CMD		= 0xfe58,
 #define Cmd9346CR_9356SEL	(1<<4)
 #define EPROM_CMD_RESERVED_MASK (1<<5)
 #define EPROM_CMD_OPERATING_MODE_SHIFT 6
@@ -392,12 +392,12 @@ enum _RTL8192Usb_HW {
 #define EPROM_CK_SHIFT 2
 #define EPROM_W_SHIFT 1
 #define EPROM_R_SHIFT 0
-	MAC0 			= 0x000,
-	MAC1 			= 0x001,
-	MAC2 			= 0x002,
-	MAC3 			= 0x003,
-	MAC4 			= 0x004,
-	MAC5 			= 0x005,
+	MAC0			= 0x000,
+	MAC1			= 0x001,
+	MAC2			= 0x002,
+	MAC3			= 0x003,
+	MAC4			= 0x004,
+	MAC5			= 0x005,
 
 };
 //----------------------------------------------------------------------------
diff --git a/drivers/staging/rtl8192u/r8192U_wx.c b/drivers/staging/rtl8192u/r8192U_wx.c
index 71f2d23..6df5f75 100644
--- a/drivers/staging/rtl8192u/r8192U_wx.c
+++ b/drivers/staging/rtl8192u/r8192U_wx.c
@@ -1021,7 +1021,7 @@ static int dummy(struct net_device *dev, struct iw_request_info *a,
 static iw_handler r8192_wx_handlers[] =
 {
 	NULL,                     /* SIOCSIWCOMMIT */
-	r8192_wx_get_name,   	  /* SIOCGIWNAME */
+	r8192_wx_get_name,	  /* SIOCGIWNAME */
 	dummy,                    /* SIOCSIWNWID */
 	dummy,                    /* SIOCGIWNWID */
 	r8192_wx_set_freq,        /* SIOCSIWFREQ */
@@ -1040,7 +1040,7 @@ static iw_handler r8192_wx_handlers[] =
 	dummy,                    /* SIOCGIWSPY */
 	NULL,                     /* SIOCGIWTHRSPY */
 	NULL,                     /* SIOCWIWTHRSPY */
-	r8192_wx_set_wap,      	  /* SIOCSIWAP */
+	r8192_wx_set_wap,	  /* SIOCSIWAP */
 	r8192_wx_get_wap,         /* SIOCGIWAP */
 #if (WIRELESS_EXT >= 18)
 	r8192_wx_set_mlme,                     /* MLME-- */
@@ -1071,23 +1071,23 @@ static iw_handler r8192_wx_handlers[] =
 	r8192_wx_set_power,                    /* SIOCSIWPOWER */
 	r8192_wx_get_power,                    /* SIOCGIWPOWER */
 	NULL,			/*---hole---*/
-	NULL, 			/*---hole---*/
-	r8192_wx_set_gen_ie,//NULL, 			/* SIOCSIWGENIE */
-	NULL, 			/* SIOCSIWGENIE */
+	NULL,			/*---hole---*/
+	r8192_wx_set_gen_ie,//NULL,			/* SIOCSIWGENIE */
+	NULL,			/* SIOCSIWGENIE */
 
 #if (WIRELESS_EXT >= 18)
-	r8192_wx_set_auth,//NULL, 			/* SIOCSIWAUTH */
-	NULL,//r8192_wx_get_auth,//NULL, 			/* SIOCSIWAUTH */
-	r8192_wx_set_enc_ext, 			/* SIOCSIWENCODEEXT */
-	NULL,//r8192_wx_get_enc_ext,//NULL, 			/* SIOCSIWENCODEEXT */
+	r8192_wx_set_auth,//NULL,			/* SIOCSIWAUTH */
+	NULL,//r8192_wx_get_auth,//NULL,			/* SIOCSIWAUTH */
+	r8192_wx_set_enc_ext,			/* SIOCSIWENCODEEXT */
+	NULL,//r8192_wx_get_enc_ext,//NULL,			/* SIOCSIWENCODEEXT */
 #else
 	NULL,
 	NULL,
 	NULL,
 	NULL,
 #endif
-	NULL, 			/* SIOCSIWPMKSA */
-	NULL, 			 /*---hole---*/
+	NULL,			/* SIOCSIWPMKSA */
+	NULL,			 /*---hole---*/
 
 };
 
diff --git a/drivers/staging/rtl8192u/r819xU_HTGen.h b/drivers/staging/rtl8192u/r819xU_HTGen.h
index f37b6d6..6a4678f 100644
--- a/drivers/staging/rtl8192u/r819xU_HTGen.h
+++ b/drivers/staging/rtl8192u/r819xU_HTGen.h
@@ -10,4 +10,3 @@ typedef enum _HT_IOT_ACTION{
 	HT_IOT_ACT_CDD_FSYNC = 0x00000020,
 	HT_IOT_ACT_PURE_N_MODE = 0x00000040,
 }HT_IOT_ACTION_E, *PHT_IOT_ACTION_E;
-
diff --git a/drivers/staging/rtl8192u/r819xU_HTType.h b/drivers/staging/rtl8192u/r819xU_HTType.h
index 6c1d05e..19a7bdd 100644
--- a/drivers/staging/rtl8192u/r819xU_HTType.h
+++ b/drivers/staging/rtl8192u/r819xU_HTType.h
@@ -89,7 +89,7 @@ typedef enum _CHNLOP{
 
 typedef enum _HT_ACTION{
 	ACT_RECOMMAND_WIDTH		= 0,
-	ACT_MIMO_PWR_SAVE 		= 1,
+	ACT_MIMO_PWR_SAVE		= 1,
 	ACT_PSMP					= 2,
 	ACT_SET_PCO_PHASE		= 3,
 	ACT_MIMO_CHL_MEASURE	= 4,
@@ -367,9 +367,9 @@ typedef struct _BSS_HT{
 typedef struct _MIMO_RSSI{
 	u32	EnableAntenna;
 	u32	AntennaA;
-	u32 	AntennaB;
-	u32 	AntennaC;
-	u32 	AntennaD;
+	u32	AntennaB;
+	u32	AntennaC;
+	u32	AntennaD;
 	u32	Average;
 }MIMO_RSSI, *PMIMO_RSSI;
 
@@ -388,4 +388,3 @@ typedef struct _FALSE_ALARM_STATISTICS{
 
 
 #endif //__INC_HTTYPE_H
-
diff --git a/drivers/staging/rtl8192u/r819xU_cmdpkt.c b/drivers/staging/rtl8192u/r819xU_cmdpkt.c
index a8a6dc2..b755eb4 100644
--- a/drivers/staging/rtl8192u/r819xU_cmdpkt.c
+++ b/drivers/staging/rtl8192u/r819xU_cmdpkt.c
@@ -18,7 +18,7 @@
  History:
 	Data		Who		Remark
 
-	05/06/2008  amy    	Create initial version porting from windows driver.
+	05/06/2008  amy		Create initial version porting from windows driver.
 
 ******************************************************************************/
 #include "r8192U.h"
@@ -41,7 +41,7 @@
 rt_status
 SendTxCommandPacket(
 	struct net_device *dev,
-	void* 			pData,
+	void*			pData,
 	u32				DataLen
 	)
 {
@@ -106,7 +106,7 @@ SendTxCommandPacket(
 	u32	buffer_len)
 {
 
-	bool 	    rt_status = true;
+	bool	    rt_status = true;
 #ifdef RTL8192U
 	return rt_status;
 #else
@@ -188,7 +188,7 @@ SendTxCommandPacket(
  *
  * Overview:
  *
- * Input:       PADAPTER 	pAdapter		-	.
+ * Input:       PADAPTER	pAdapter		-	.
  *				CMPK_TXFB_T *psTx_FB	-	.
  *
  * Output:      NONE
@@ -197,7 +197,7 @@ SendTxCommandPacket(
  *
  * Revised History:
  *  When		Who		Remark
- *  05/12/2008	amy 	Create Version 0 porting from windows code.
+ *  05/12/2008	amy	Create Version 0 porting from windows code.
  *
  *---------------------------------------------------------------------------*/
 static	void
@@ -289,7 +289,7 @@ cmpk_count_txstatistic(
  *				in the command packet.
  *
  * Input:       struct net_device *    dev
- *				u8 	*	pmsg		-	Msg Ptr of the command packet.
+ *				u8	*	pmsg		-	Msg Ptr of the command packet.
  *
  * Output:      NONE
  *
@@ -369,7 +369,7 @@ cmdpkt_beacontimerinterrupt_819xusb(
  * Overview:    The function is responsible for extract the message from
  *				firmware. It will contain dedicated info in
  *				ws-07-0063-v06-rtl819x-command-packet-specification-070315.doc.
- * 				Please refer to chapter "Interrupt Status Element".
+ *				Please refer to chapter "Interrupt Status Element".
  *
  * Input:       struct net_device *dev,
  *			u8*	pmsg		-	Message Pointer of the command packet.
@@ -400,8 +400,8 @@ cmpk_handle_interrupt_status(
 	/* It seems that FW use big endian(MIPS) and DRV use little endian in
 	   windows OS. So we have to read the content byte by byte or transfer
 	   endian type before copy the message copy. */
-	//rx_bcn_state.Element_ID 	= pMsg[0];
-	//rx_bcn_state.Length 		= pMsg[1];
+	//rx_bcn_state.Element_ID	= pMsg[0];
+	//rx_bcn_state.Length		= pMsg[1];
 	rx_intr_status.length = pmsg[1];
 	if (rx_intr_status.length != (sizeof(cmpk_intr_sta_t) - 2))
 	{
@@ -478,16 +478,16 @@ cmpk_handle_query_config_rx(
 	/* It seems that FW use big endian(MIPS) and DRV use little endian in
 	   windows OS. So we have to read the content byte by byte or transfer
 	   endian type before copy the message copy. */
-	//rx_query_cfg.Element_ID 	= pMsg[0];
-	//rx_query_cfg.Length 		= pMsg[1];
-	rx_query_cfg.cfg_action 	= (pmsg[4] & 0x80000000)>>31;
-	rx_query_cfg.cfg_type 		= (pmsg[4] & 0x60) >> 5;
-	rx_query_cfg.cfg_size 		= (pmsg[4] & 0x18) >> 3;
-	rx_query_cfg.cfg_page 		= (pmsg[6] & 0x0F) >> 0;
-	rx_query_cfg.cfg_offset 		= pmsg[7];
-	rx_query_cfg.value 			= (pmsg[8] << 24) | (pmsg[9] << 16) |
+	//rx_query_cfg.Element_ID	= pMsg[0];
+	//rx_query_cfg.Length		= pMsg[1];
+	rx_query_cfg.cfg_action		= (pmsg[4] & 0x80000000)>>31;
+	rx_query_cfg.cfg_type		= (pmsg[4] & 0x60) >> 5;
+	rx_query_cfg.cfg_size		= (pmsg[4] & 0x18) >> 3;
+	rx_query_cfg.cfg_page		= (pmsg[6] & 0x0F) >> 0;
+	rx_query_cfg.cfg_offset			= pmsg[7];
+	rx_query_cfg.value			= (pmsg[8] << 24) | (pmsg[9] << 16) |
 								  (pmsg[10] << 8) | (pmsg[11] << 0);
-	rx_query_cfg.mask 			= (pmsg[12] << 24) | (pmsg[13] << 16) |
+	rx_query_cfg.mask			= (pmsg[12] << 24) | (pmsg[13] << 16) |
 								  (pmsg[14] << 8) | (pmsg[15] << 0);
 
 }	/* cmpk_Handle_Query_Config_Rx */
@@ -511,7 +511,7 @@ cmpk_handle_query_config_rx(
  *
  *---------------------------------------------------------------------------*/
 static	void	cmpk_count_tx_status(	struct net_device *dev,
-									cmpk_tx_status_t 	*pstx_status)
+									cmpk_tx_status_t	*pstx_status)
 {
 	struct r8192_priv *priv = ieee80211_priv(dev);
 
diff --git a/drivers/staging/rtl8192u/r819xU_cmdpkt.h b/drivers/staging/rtl8192u/r819xU_cmdpkt.h
index a8855e6..fbbd270 100644
--- a/drivers/staging/rtl8192u/r819xU_cmdpkt.h
+++ b/drivers/staging/rtl8192u/r819xU_cmdpkt.h
@@ -72,7 +72,7 @@ typedef struct tag_cmd_pkt_set_configuration
 	u8	element_id;			/* Command packet type. */
 	u8	length;				/* Command packet length. */
 	u16	reserve1;			/* */
-	u8 	cfg_reserve1:3;
+	u8	cfg_reserve1:3;
 	u8	cfg_size:2;			/* Configuration info. */
 	u8	cfg_type:2;			/* Configuration info. */
 	u8	cfg_action:1;		/* Configuration info. */
@@ -94,20 +94,20 @@ typedef struct tag_tx_stats_feedback // PJ quick rxcmd 09042007
 	// For endian transfer --> Driver will not the same as firmware structure.
 	// DW 0
 	u16	reserve1;
-	u8 	length;				// Command packet length
-	u8 	element_id;			// Command packet type
+	u8	length;				// Command packet length
+	u8	element_id;			// Command packet type
 
 	// DW 1
 	u16	txfail;				// Tx Fail count
-	u16 	txok;				// Tx ok count
+	u16	txok;				// Tx ok count
 
 	// DW 2
-	u16	txmcok;  			// tx multicast
-	u16 	txretry;			// Tx Retry count
+	u16	txmcok;				// tx multicast
+	u16	txretry;			// Tx Retry count
 
 	// DW 3
 	u16  txucok;				// tx unicast
-	u16	txbcok;  			// tx broadcast
+	u16	txbcok;				// tx broadcast
 
 	// DW 4
 	u16	txbcfail;			//
@@ -135,8 +135,8 @@ typedef struct tag_rx_debug_message_feedback
 	// For endian transfer --> for driver
 	// DW 0
 	u16	reserve1;
-	u8 	length;				// Command packet length
-	u8 	element_id;			// Command packet type
+	u8	length;				// Command packet length
+	u8	element_id;			// Command packet type
 
 	// DW 1-??
 	// Variable debug message.
@@ -148,15 +148,15 @@ typedef struct tag_tx_rate_history
 {
 	// For endian transfer --> for driver
 	// DW 0
-	u8 	element_id;			// Command packet type
-	u8 	length;				// Command packet length
+	u8	element_id;			// Command packet type
+	u8	length;				// Command packet length
 	u16	reserved1;
 
 	// DW 1-2	CCK rate counter
-	u16 	cck[4];
+	u16	cck[4];
 
 	// DW 3-6
-	u16 	ofdm[8];
+	u16	ofdm[8];
 
 	// DW 7-14
 	//UINT16	MCS_BW0_SG0[16];
diff --git a/drivers/staging/rtl8192u/r819xU_firmware.c b/drivers/staging/rtl8192u/r819xU_firmware.c
index b12d190..46b8043 100644
--- a/drivers/staging/rtl8192u/r819xU_firmware.c
+++ b/drivers/staging/rtl8192u/r819xU_firmware.c
@@ -2,7 +2,7 @@
  * Procedure:    Init boot code/firmware code/data session
  *
  * Description: This routine will initialize firmware. If any error occurs during the initialization
- * 		process, the routine shall terminate immediately and return fail.
+ *		process, the routine shall terminate immediately and return fail.
  *		NIC driver should call NdisOpenFile only from MiniportInitialize.
  *
  * Arguments:   The pointer of the adapter
@@ -19,7 +19,7 @@
 #include <linux/firmware.h>
 void firmware_init_param(struct net_device *dev)
 {
-	struct r8192_priv 	*priv = ieee80211_priv(dev);
+	struct r8192_priv	*priv = ieee80211_priv(dev);
 	rt_firmware		*pfirmware = priv->pFirmware;
 
 	pfirmware->cmdpacket_frag_thresold = GET_COMMAND_PACKET_FRAG_THRESHOLD(MAX_TRANSMIT_BUFFER_SIZE);
@@ -32,7 +32,7 @@ void firmware_init_param(struct net_device *dev)
 bool fw_download_code(struct net_device *dev, u8 *code_virtual_address, u32 buffer_len)
 {
 	struct r8192_priv   *priv = ieee80211_priv(dev);
-	bool 		    rt_status = true;
+	bool		    rt_status = true;
 	u16		    frag_threshold;
 	u16		    frag_length, frag_offset = 0;
 	//u16		    total_size;
@@ -241,17 +241,17 @@ CPUCheckFirmwareReady_Fail:
 
 bool init_firmware(struct net_device *dev)
 {
-	struct r8192_priv 	*priv = ieee80211_priv(dev);
+	struct r8192_priv	*priv = ieee80211_priv(dev);
 	bool			rt_status = TRUE;
 
 	u32			file_length = 0;
 	u8			*mapped_file = NULL;
 	u32			init_step = 0;
 	opt_rst_type_e	rst_opt = OPT_SYSTEM_RESET;
-	firmware_init_step_e 	starting_state = FW_INIT_STEP0_BOOT;
+	firmware_init_step_e	starting_state = FW_INIT_STEP0_BOOT;
 
 	rt_firmware		*pfirmware = priv->pFirmware;
-	const struct firmware 	*fw_entry;
+	const struct firmware	*fw_entry;
 	const char *fw_name[3] = { "RTL8192U/boot.img",
 			   "RTL8192U/main.img",
 			   "RTL8192U/data.img"};
@@ -402,4 +402,3 @@ download_firmware_fail:
 MODULE_FIRMWARE("RTL8192U/boot.img");
 MODULE_FIRMWARE("RTL8192U/main.img");
 MODULE_FIRMWARE("RTL8192U/data.img");
-
diff --git a/drivers/staging/rtl8192u/r819xU_firmware.h b/drivers/staging/rtl8192u/r819xU_firmware.h
index a4bceeef..c48c884 100644
--- a/drivers/staging/rtl8192u/r819xU_firmware.h
+++ b/drivers/staging/rtl8192u/r819xU_firmware.h
@@ -24,4 +24,3 @@ typedef enum _opt_rst_type{
 }opt_rst_type_e;
 
 #endif
-
diff --git a/drivers/staging/rtl8192u/r819xU_phy.c b/drivers/staging/rtl8192u/r819xU_phy.c
index dd1954d..2ff851f 100644
--- a/drivers/staging/rtl8192u/r819xU_phy.c
+++ b/drivers/staging/rtl8192u/r819xU_phy.c
@@ -124,10 +124,10 @@ static void phy_FwRFSerialWrite( struct net_device* dev, RF90_RADIO_PATH_E
 /******************************************************************************
  *function:  This function read register from RF chip
  *   input:  net_device dev
- *   	     RF90_RADIO_PATH_E eRFPath //radio path of A/B/C/D
+ *	     RF90_RADIO_PATH_E eRFPath //radio path of A/B/C/D
  *           u32	Offset     //target address to be read
  *  output:  none
- *  return:  u32 	readback value
+ *  return:  u32	readback value
  *  notice:  There are three types of serial operations:(1) Software serial write.(2)Hardware LSSI-Low Speed Serial Interface.(3)Hardware HSSI-High speed serial write. Driver here need to implement (1) and (2)---need more spec for this information.
  * ****************************************************************************/
 u32 rtl8192_phy_RFSerialRead(struct net_device* dev, RF90_RADIO_PATH_E eRFPath, u32 Offset)
@@ -201,7 +201,7 @@ u32 rtl8192_phy_RFSerialRead(struct net_device* dev, RF90_RADIO_PATH_E eRFPath,
 /******************************************************************************
  *function:  This function write data to RF register
  *   input:  net_device dev
- *   	     RF90_RADIO_PATH_E eRFPath //radio path of A/B/C/D
+ *	     RF90_RADIO_PATH_E eRFPath //radio path of A/B/C/D
  *           u32	Offset     //target address to be written
  *           u32	Data	//The new register data to be written
  *  output:  none
@@ -283,7 +283,7 @@ void rtl8192_phy_RFSerialWrite(struct net_device* dev, RF90_RADIO_PATH_E eRFPath
 /******************************************************************************
  *function:  This function set specific bits to RF register
  *   input:  net_device dev
- *   	     RF90_RADIO_PATH_E eRFPath //radio path of A/B/C/D
+ *	     RF90_RADIO_PATH_E eRFPath //radio path of A/B/C/D
  *           u32	RegAddr  //target addr to be modified
  *           u32	BitMask  //taget bit pos in the addr to be modified
  *           u32	Data     //value to be write
@@ -684,8 +684,8 @@ void rtl8192_InitBBRFRegDef(struct net_device* dev)
 /******************************************************************************
  *function:  This function is to write register and then readback to make sure whether BB and RF is OK
  *   input:  net_device dev
- *   	     HW90_BLOCK_E CheckBlock
- *   	     RF90_RADIO_PATH_E eRFPath  //only used when checkblock is HW90_BLOCK_RF
+ *	     HW90_BLOCK_E CheckBlock
+ *	     RF90_RADIO_PATH_E eRFPath  //only used when checkblock is HW90_BLOCK_RF
  *  output:  none
  *  return:  return whether BB and RF is ok(0:OK; 1:Fail)
  *  notice:  This function may be removed in the ASIC
@@ -1015,7 +1015,7 @@ u8 rtl8192_phy_ConfigRFWithHeaderFile(struct net_device* dev, RF90_RADIO_PATH_E
 /******************************************************************************
  *function:  This function set Tx Power of the channel
  *   input:  struct net_device *dev
- *   	     u8 		channel
+ *	     u8			channel
  *  output:  none
  *  return:  none
  *    Note:
@@ -1052,7 +1052,7 @@ void rtl8192_SetTxPowerLevel(struct net_device *dev, u8 channel)
 /******************************************************************************
  *function:  This function set RF state on or off
  *   input:  struct net_device *dev
- *   	     RT_RF_POWER_STATE eRFPowerState  //Power State to set
+ *	     RT_RF_POWER_STATE eRFPowerState  //Power State to set
  *  output:  none
  *  return:  none
  *    Note:
@@ -1183,10 +1183,10 @@ bool rtl8192_SetRFPowerState(struct net_device *dev, RT_RF_POWER_STATE eRFPowerS
 
 /****************************************************************************************
  *function:  This function set command table variable(struct SwChnlCmd).
- *   input:  SwChnlCmd*		CmdTable 	//table to be set.
- *   	     u32		CmdTableIdx 	//variable index in table to be set
- *   	     u32		CmdTableSz	//table size.
- *   	     SwChnlCmdID	CmdID		//command ID to set.
+ *   input:  SwChnlCmd*		CmdTable	//table to be set.
+ *	     u32		CmdTableIdx	//variable index in table to be set
+ *	     u32		CmdTableSz	//table size.
+ *	     SwChnlCmdID	CmdID		//command ID to set.
  *	     u32		Para1
  *	     u32		Para2
  *	     u32		msDelay
@@ -1229,10 +1229,10 @@ u8 rtl8192_phy_SetSwChnlCmdArray(
 /******************************************************************************
  *function:  This function set channel step by step
  *   input:  struct net_device *dev
- *   	     u8 		channel
- *   	     u8* 		stage //3 stages
- *   	     u8* 		step  //
- *   	     u32* 		delay //whether need to delay
+ *	     u8			channel
+ *	     u8*		stage //3 stages
+ *	     u8*		step  //
+ *	     u32*		delay //whether need to delay
  *  output:  store new stage, step and delay for next step(combine with function above)
  *  return:  true if finished, false otherwise
  *    Note:  Wait for simpler function to replace it //wb
@@ -1386,7 +1386,7 @@ u8 rtl8192_phy_SwChnlStepByStep(struct net_device *dev, u8 channel, u8* stage, u
 /******************************************************************************
  *function:  This function does actually set channel work
  *   input:  struct net_device *dev
- *   	     u8 		channel
+ *	     u8			channel
  *  output:  none
  *  return:  noin
  *    Note:  We should not call this function directly
@@ -1427,7 +1427,7 @@ void rtl8192_SwChnl_WorkItem(struct net_device *dev)
 /******************************************************************************
  *function:  This function scheduled actual work item to set channel
  *   input:  net_device dev
- *   	     u8		channel //channel to set
+ *	     u8		channel //channel to set
  *  output:  none
  *  return:  return code show if workitem is scheduled(1:pass, 0:fail)
  *    Note:  Delay may be required for RF configuration
@@ -1501,12 +1501,12 @@ if (0) //to test current channel from RF reg 0x7.
 /******************************************************************************
  *function:  Callback routine of the work item for set bandwidth mode.
  *   input:  struct net_device *dev
- *   	     HT_CHANNEL_WIDTH	Bandwidth  //20M or 40M
- *   	     HT_EXTCHNL_OFFSET Offset 	   //Upper, Lower, or Don't care
+ *	     HT_CHANNEL_WIDTH	Bandwidth  //20M or 40M
+ *	     HT_EXTCHNL_OFFSET Offset	   //Upper, Lower, or Don't care
  *  output:  none
  *  return:  none
  *    Note:  I doubt whether SetBWModeInProgress flag is necessary as we can
- *    	     test whether current work in the queue or not.//do I?
+ *	     test whether current work in the queue or not.//do I?
  * ***************************************************************************/
 void rtl8192_SetBWModeWorkItem(struct net_device *dev)
 {
@@ -1649,12 +1649,12 @@ void rtl8192_SetBWModeWorkItem(struct net_device *dev)
 /******************************************************************************
  *function:  This function schedules bandwidth switch work.
  *   input:  struct net_device *dev
- *   	     HT_CHANNEL_WIDTH	Bandwidth  //20M or 40M
- *   	     HT_EXTCHNL_OFFSET Offset 	   //Upper, Lower, or Don't care
+ *	     HT_CHANNEL_WIDTH	Bandwidth  //20M or 40M
+ *	     HT_EXTCHNL_OFFSET Offset	   //Upper, Lower, or Don't care
  *  output:  none
  *  return:  none
  *    Note:  I doubt whether SetBWModeInProgress flag is necessary as we can
- *    	     test whether current work in the queue or not.//do I?
+ *	     test whether current work in the queue or not.//do I?
  * ***************************************************************************/
 void rtl8192_SetBWMode(struct net_device *dev, HT_CHANNEL_WIDTH	Bandwidth, HT_EXTCHNL_OFFSET Offset)
 {
@@ -1770,4 +1770,3 @@ extern void InitialGainOperateWorkItemCallBack(struct work_struct *work)
 			break;
 	}
 }
-
diff --git a/drivers/staging/rtl8192u/r819xU_phyreg.h b/drivers/staging/rtl8192u/r819xU_phyreg.h
index cca34c0..64285d6 100644
--- a/drivers/staging/rtl8192u/r819xU_phyreg.h
+++ b/drivers/staging/rtl8192u/r819xU_phyreg.h
@@ -6,185 +6,185 @@
 
 //Register   //duplicate register due to connection: RF_Mode, TRxRN, NumOf L-STF
 //page 1
-#define rPMAC_Reset               		0x100
-#define rPMAC_TxStart             		0x104
-#define rPMAC_TxLegacySIG         		0x108
-#define rPMAC_TxHTSIG1            		0x10c
-#define rPMAC_TxHTSIG2            		0x110
-#define rPMAC_PHYDebug            		0x114
-#define rPMAC_TxPacketNum         		0x118
-#define rPMAC_TxIdle              		0x11c
-#define rPMAC_TxMACHeader0       	0x120
-#define rPMAC_TxMACHeader1       	0x124
-#define rPMAC_TxMACHeader2       	0x128
-#define rPMAC_TxMACHeader3       	0x12c
-#define rPMAC_TxMACHeader4       	0x130
-#define rPMAC_TxMACHeader5       	0x134
-#define rPMAC_TxDataType          		0x138
-#define rPMAC_TxRandomSeed      		0x13c
-#define rPMAC_CCKPLCPPreamble  		0x140
-#define rPMAC_CCKPLCPHeader     		0x144
-#define rPMAC_CCKCRC16            		0x148
-#define rPMAC_OFDMRxCRC32OK  		0x170
-#define rPMAC_OFDMRxCRC32Er   		0x174
-#define rPMAC_OFDMRxParityEr    		0x178
-#define rPMAC_OFDMRxCRC8Er     		0x17c
-#define rPMAC_CCKCRxRC16Er       		0x180
-#define rPMAC_CCKCRxRC32Er       		0x184
-#define rPMAC_CCKCRxRC32OK      		0x188
-#define rPMAC_TxStatus            		0x18c
+#define rPMAC_Reset				0x100
+#define rPMAC_TxStart				0x104
+#define rPMAC_TxLegacySIG			0x108
+#define rPMAC_TxHTSIG1				0x10c
+#define rPMAC_TxHTSIG2				0x110
+#define rPMAC_PHYDebug				0x114
+#define rPMAC_TxPacketNum			0x118
+#define rPMAC_TxIdle				0x11c
+#define rPMAC_TxMACHeader0		0x120
+#define rPMAC_TxMACHeader1		0x124
+#define rPMAC_TxMACHeader2		0x128
+#define rPMAC_TxMACHeader3		0x12c
+#define rPMAC_TxMACHeader4		0x130
+#define rPMAC_TxMACHeader5		0x134
+#define rPMAC_TxDataType			0x138
+#define rPMAC_TxRandomSeed			0x13c
+#define rPMAC_CCKPLCPPreamble		0x140
+#define rPMAC_CCKPLCPHeader			0x144
+#define rPMAC_CCKCRC16				0x148
+#define rPMAC_OFDMRxCRC32OK		0x170
+#define rPMAC_OFDMRxCRC32Er		0x174
+#define rPMAC_OFDMRxParityEr			0x178
+#define rPMAC_OFDMRxCRC8Er		0x17c
+#define rPMAC_CCKCRxRC16Er			0x180
+#define rPMAC_CCKCRxRC32Er			0x184
+#define rPMAC_CCKCRxRC32OK			0x188
+#define rPMAC_TxStatus				0x18c
 
 //page8
-#define rFPGA0_RFMOD              		0x800  //RF mode & CCK TxSC
-#define rFPGA0_TxInfo             		0x804
-#define rFPGA0_PSDFunction        		0x808
-#define rFPGA0_TxGainStage        		0x80c
-#define rFPGA0_RFTiming1          		0x810
-#define rFPGA0_RFTiming2          		0x814
-//#define rFPGA0_XC_RFTiming        		0x818
-//#define rFPGA0_XD_RFTiming        		0x81c
-#define rFPGA0_XA_HSSIParameter1  	0x820
-#define rFPGA0_XA_HSSIParameter2  	0x824
-#define rFPGA0_XB_HSSIParameter1  	0x828
-#define rFPGA0_XB_HSSIParameter2  	0x82c
-#define rFPGA0_XC_HSSIParameter1  	0x830
-#define rFPGA0_XC_HSSIParameter2  	0x834
-#define rFPGA0_XD_HSSIParameter1  	0x838
-#define rFPGA0_XD_HSSIParameter2  	0x83c
-#define rFPGA0_XA_LSSIParameter   	0x840
-#define rFPGA0_XB_LSSIParameter   	0x844
-#define rFPGA0_XC_LSSIParameter   	0x848
-#define rFPGA0_XD_LSSIParameter   	0x84c
-#define rFPGA0_RFWakeUpParameter  	0x850
-#define rFPGA0_RFSleepUpParameter 	0x854
-#define rFPGA0_XAB_SwitchControl  	0x858
-#define rFPGA0_XCD_SwitchControl  	0x85c
-#define rFPGA0_XA_RFInterfaceOE   	0x860
-#define rFPGA0_XB_RFInterfaceOE   	0x864
-#define rFPGA0_XC_RFInterfaceOE   	0x868
-#define rFPGA0_XD_RFInterfaceOE   	0x86c
-#define rFPGA0_XAB_RFInterfaceSW  	0x870
-#define rFPGA0_XCD_RFInterfaceSW  	0x874
-#define rFPGA0_XAB_RFParameter    	0x878
-#define rFPGA0_XCD_RFParameter    	0x87c
-#define rFPGA0_AnalogParameter1   	0x880
-#define rFPGA0_AnalogParameter2   	0x884
-#define rFPGA0_AnalogParameter3   	0x888
-#define rFPGA0_AnalogParameter4   	0x88c
-#define rFPGA0_XA_LSSIReadBack    	0x8a0
-#define rFPGA0_XB_LSSIReadBack    	0x8a4
-#define rFPGA0_XC_LSSIReadBack    	0x8a8
-#define rFPGA0_XD_LSSIReadBack    	0x8ac
-#define rFPGA0_PSDReport          		0x8b4
-#define rFPGA0_XAB_RFInterfaceRB  	0x8e0
-#define rFPGA0_XCD_RFInterfaceRB  	0x8e4
+#define rFPGA0_RFMOD				0x800  //RF mode & CCK TxSC
+#define rFPGA0_TxInfo				0x804
+#define rFPGA0_PSDFunction			0x808
+#define rFPGA0_TxGainStage			0x80c
+#define rFPGA0_RFTiming1			0x810
+#define rFPGA0_RFTiming2			0x814
+//#define rFPGA0_XC_RFTiming			0x818
+//#define rFPGA0_XD_RFTiming			0x81c
+#define rFPGA0_XA_HSSIParameter1	0x820
+#define rFPGA0_XA_HSSIParameter2	0x824
+#define rFPGA0_XB_HSSIParameter1	0x828
+#define rFPGA0_XB_HSSIParameter2	0x82c
+#define rFPGA0_XC_HSSIParameter1	0x830
+#define rFPGA0_XC_HSSIParameter2	0x834
+#define rFPGA0_XD_HSSIParameter1	0x838
+#define rFPGA0_XD_HSSIParameter2	0x83c
+#define rFPGA0_XA_LSSIParameter		0x840
+#define rFPGA0_XB_LSSIParameter		0x844
+#define rFPGA0_XC_LSSIParameter		0x848
+#define rFPGA0_XD_LSSIParameter		0x84c
+#define rFPGA0_RFWakeUpParameter	0x850
+#define rFPGA0_RFSleepUpParameter	0x854
+#define rFPGA0_XAB_SwitchControl	0x858
+#define rFPGA0_XCD_SwitchControl	0x85c
+#define rFPGA0_XA_RFInterfaceOE		0x860
+#define rFPGA0_XB_RFInterfaceOE		0x864
+#define rFPGA0_XC_RFInterfaceOE		0x868
+#define rFPGA0_XD_RFInterfaceOE		0x86c
+#define rFPGA0_XAB_RFInterfaceSW	0x870
+#define rFPGA0_XCD_RFInterfaceSW	0x874
+#define rFPGA0_XAB_RFParameter		0x878
+#define rFPGA0_XCD_RFParameter		0x87c
+#define rFPGA0_AnalogParameter1		0x880
+#define rFPGA0_AnalogParameter2		0x884
+#define rFPGA0_AnalogParameter3		0x888
+#define rFPGA0_AnalogParameter4		0x88c
+#define rFPGA0_XA_LSSIReadBack		0x8a0
+#define rFPGA0_XB_LSSIReadBack		0x8a4
+#define rFPGA0_XC_LSSIReadBack		0x8a8
+#define rFPGA0_XD_LSSIReadBack		0x8ac
+#define rFPGA0_PSDReport			0x8b4
+#define rFPGA0_XAB_RFInterfaceRB	0x8e0
+#define rFPGA0_XCD_RFInterfaceRB	0x8e4
 
 //page 9
-#define rFPGA1_RFMOD              		0x900  //RF mode & OFDM TxSC
-#define rFPGA1_TxBlock            		0x904
-#define rFPGA1_DebugSelect        		0x908
-#define rFPGA1_TxInfo             		0x90c
+#define rFPGA1_RFMOD				0x900  //RF mode & OFDM TxSC
+#define rFPGA1_TxBlock				0x904
+#define rFPGA1_DebugSelect			0x908
+#define rFPGA1_TxInfo				0x90c
 
 //page a
-#define rCCK0_System              		0xa00
-#define rCCK0_AFESetting          		0xa04
-#define rCCK0_CCA                 			0xa08
-#define rCCK0_RxAGC1              		0xa0c  //AGC default value, saturation level
-#define rCCK0_RxAGC2              		0xa10  //AGC & DAGC
-#define rCCK0_RxHP                		0xa14
-#define rCCK0_DSPParameter1       	0xa18  //Timing recovery & Channel estimation threshold
-#define rCCK0_DSPParameter2       	0xa1c  //SQ threshold
-#define rCCK0_TxFilter1           		0xa20
-#define rCCK0_TxFilter2           		0xa24
-#define rCCK0_DebugPort           		0xa28  //debug port and Tx filter3
-#define rCCK0_FalseAlarmReport    	0xa2c  //0xa2d
-#define rCCK0_TRSSIReport         		0xa50
-#define rCCK0_RxReport            		0xa54  //0xa57
-#define rCCK0_FACounterLower      	0xa5c  //0xa5b
-#define rCCK0_FACounterUpper      	0xa58  //0xa5c
+#define rCCK0_System				0xa00
+#define rCCK0_AFESetting			0xa04
+#define rCCK0_CCA					0xa08
+#define rCCK0_RxAGC1				0xa0c  //AGC default value, saturation level
+#define rCCK0_RxAGC2				0xa10  //AGC & DAGC
+#define rCCK0_RxHP				0xa14
+#define rCCK0_DSPParameter1		0xa18  //Timing recovery & Channel estimation threshold
+#define rCCK0_DSPParameter2		0xa1c  //SQ threshold
+#define rCCK0_TxFilter1				0xa20
+#define rCCK0_TxFilter2				0xa24
+#define rCCK0_DebugPort				0xa28  //debug port and Tx filter3
+#define rCCK0_FalseAlarmReport		0xa2c  //0xa2d
+#define rCCK0_TRSSIReport			0xa50
+#define rCCK0_RxReport				0xa54  //0xa57
+#define rCCK0_FACounterLower		0xa5c  //0xa5b
+#define rCCK0_FACounterUpper		0xa58  //0xa5c
 
 //page c
-#define rOFDM0_LSTF               		0xc00
-#define rOFDM0_TRxPathEnable      	0xc04
-#define rOFDM0_TRMuxPar           		0xc08
-#define rOFDM0_TRSWIsolation      		0xc0c
-#define rOFDM0_XARxAFE            		0xc10  //RxIQ DC offset, Rx digital filter, DC notch filter
-#define rOFDM0_XARxIQImbalance    	0xc14  //RxIQ imblance matrix
-#define rOFDM0_XBRxAFE            		0xc18
-#define rOFDM0_XBRxIQImbalance    	0xc1c
-#define rOFDM0_XCRxAFE            		0xc20
-#define rOFDM0_XCRxIQImbalance    	0xc24
-#define rOFDM0_XDRxAFE            		0xc28
-#define rOFDM0_XDRxIQImbalance    	0xc2c
-#define rOFDM0_RxDetector1        		0xc30  //PD,BW & SBD
-#define rOFDM0_RxDetector2        		0xc34  //SBD & Fame Sync.
-#define rOFDM0_RxDetector3        		0xc38  //Frame Sync.
-#define rOFDM0_RxDetector4        		0xc3c  //PD, SBD, Frame Sync & Short-GI
-#define rOFDM0_RxDSP              		0xc40  //Rx Sync Path
-#define rOFDM0_CFOandDAGC         	0xc44  //CFO & DAGC
-#define rOFDM0_CCADropThreshold   	0xc48 //CCA Drop threshold
-#define rOFDM0_ECCAThreshold      	0xc4c // energy CCA
-#define rOFDM0_XAAGCCore1         	0xc50
-#define rOFDM0_XAAGCCore2         	0xc54
-#define rOFDM0_XBAGCCore1         	0xc58
-#define rOFDM0_XBAGCCore2         	0xc5c
-#define rOFDM0_XCAGCCore1         	0xc60
-#define rOFDM0_XCAGCCore2         	0xc64
-#define rOFDM0_XDAGCCore1         	0xc68
-#define rOFDM0_XDAGCCore2         	0xc6c
-#define rOFDM0_AGCParameter1      	0xc70
-#define rOFDM0_AGCParameter2      	0xc74
-#define rOFDM0_AGCRSSITable       	0xc78
-#define rOFDM0_HTSTFAGC           		0xc7c
-#define rOFDM0_XATxIQImbalance   	0xc80
-#define rOFDM0_XATxAFE            		0xc84
-#define rOFDM0_XBTxIQImbalance    	0xc88
-#define rOFDM0_XBTxAFE            		0xc8c
-#define rOFDM0_XCTxIQImbalance    	0xc90
-#define rOFDM0_XCTxAFE            		0xc94
-#define rOFDM0_XDTxIQImbalance    	0xc98
-#define rOFDM0_XDTxAFE            		0xc9c
-#define rOFDM0_RxHPParameter      	0xce0
-#define rOFDM0_TxPseudoNoiseWgt   	0xce4
-#define rOFDM0_FrameSync          		0xcf0
-#define rOFDM0_DFSReport          		0xcf4
-#define rOFDM0_TxCoeff1           		0xca4
-#define rOFDM0_TxCoeff2           		0xca8
-#define rOFDM0_TxCoeff3           		0xcac
-#define rOFDM0_TxCoeff4           		0xcb0
-#define rOFDM0_TxCoeff5           		0xcb4
-#define rOFDM0_TxCoeff6           		0xcb8
+#define rOFDM0_LSTF				0xc00
+#define rOFDM0_TRxPathEnable		0xc04
+#define rOFDM0_TRMuxPar				0xc08
+#define rOFDM0_TRSWIsolation			0xc0c
+#define rOFDM0_XARxAFE				0xc10  //RxIQ DC offset, Rx digital filter, DC notch filter
+#define rOFDM0_XARxIQImbalance		0xc14  //RxIQ imblance matrix
+#define rOFDM0_XBRxAFE				0xc18
+#define rOFDM0_XBRxIQImbalance		0xc1c
+#define rOFDM0_XCRxAFE				0xc20
+#define rOFDM0_XCRxIQImbalance		0xc24
+#define rOFDM0_XDRxAFE				0xc28
+#define rOFDM0_XDRxIQImbalance		0xc2c
+#define rOFDM0_RxDetector1			0xc30  //PD,BW & SBD
+#define rOFDM0_RxDetector2			0xc34  //SBD & Fame Sync.
+#define rOFDM0_RxDetector3			0xc38  //Frame Sync.
+#define rOFDM0_RxDetector4			0xc3c  //PD, SBD, Frame Sync & Short-GI
+#define rOFDM0_RxDSP				0xc40  //Rx Sync Path
+#define rOFDM0_CFOandDAGC		0xc44  //CFO & DAGC
+#define rOFDM0_CCADropThreshold		0xc48 //CCA Drop threshold
+#define rOFDM0_ECCAThreshold		0xc4c // energy CCA
+#define rOFDM0_XAAGCCore1		0xc50
+#define rOFDM0_XAAGCCore2		0xc54
+#define rOFDM0_XBAGCCore1		0xc58
+#define rOFDM0_XBAGCCore2		0xc5c
+#define rOFDM0_XCAGCCore1		0xc60
+#define rOFDM0_XCAGCCore2		0xc64
+#define rOFDM0_XDAGCCore1		0xc68
+#define rOFDM0_XDAGCCore2		0xc6c
+#define rOFDM0_AGCParameter1		0xc70
+#define rOFDM0_AGCParameter2		0xc74
+#define rOFDM0_AGCRSSITable		0xc78
+#define rOFDM0_HTSTFAGC				0xc7c
+#define rOFDM0_XATxIQImbalance		0xc80
+#define rOFDM0_XATxAFE				0xc84
+#define rOFDM0_XBTxIQImbalance		0xc88
+#define rOFDM0_XBTxAFE				0xc8c
+#define rOFDM0_XCTxIQImbalance		0xc90
+#define rOFDM0_XCTxAFE				0xc94
+#define rOFDM0_XDTxIQImbalance		0xc98
+#define rOFDM0_XDTxAFE				0xc9c
+#define rOFDM0_RxHPParameter		0xce0
+#define rOFDM0_TxPseudoNoiseWgt		0xce4
+#define rOFDM0_FrameSync			0xcf0
+#define rOFDM0_DFSReport			0xcf4
+#define rOFDM0_TxCoeff1				0xca4
+#define rOFDM0_TxCoeff2				0xca8
+#define rOFDM0_TxCoeff3				0xcac
+#define rOFDM0_TxCoeff4				0xcb0
+#define rOFDM0_TxCoeff5				0xcb4
+#define rOFDM0_TxCoeff6				0xcb8
 
 
 //page d
-#define rOFDM1_LSTF               		0xd00
-#define rOFDM1_TRxPathEnable      	0xd04
-#define rOFDM1_CFO                		0xd08
-#define rOFDM1_CSI1               		0xd10
-#define rOFDM1_SBD                		0xd14
-#define rOFDM1_CSI2               		0xd18
-#define rOFDM1_CFOTracking        		0xd2c
-#define rOFDM1_TRxMesaure1        	0xd34
-#define rOFDM1_IntfDet            		0xd3c
+#define rOFDM1_LSTF				0xd00
+#define rOFDM1_TRxPathEnable		0xd04
+#define rOFDM1_CFO				0xd08
+#define rOFDM1_CSI1				0xd10
+#define rOFDM1_SBD				0xd14
+#define rOFDM1_CSI2				0xd18
+#define rOFDM1_CFOTracking			0xd2c
+#define rOFDM1_TRxMesaure1		0xd34
+#define rOFDM1_IntfDet				0xd3c
 #define rOFDM1_PseudoNoiseStateAB 0xd50
 #define rOFDM1_PseudoNoiseStateCD 0xd54
 #define rOFDM1_RxPseudoNoiseWgt   0xd58
-#define rOFDM_PHYCounter1         		0xda0  //cca, parity fail
-#define rOFDM_PHYCounter2         		0xda4  //rate illegal, crc8 fail
-#define rOFDM_PHYCounter3         		0xda8  //MCS not support
-#define rOFDM_ShortCFOAB          		0xdac
-#define rOFDM_ShortCFOCD          		0xdb0
-#define rOFDM_LongCFOAB           		0xdb4
-#define rOFDM_LongCFOCD           		0xdb8
-#define rOFDM_TailCFOAB           		0xdbc
-#define rOFDM_TailCFOCD           		0xdc0
-#define rOFDM_PWMeasure1          	0xdc4
-#define rOFDM_PWMeasure2          	0xdc8
-#define rOFDM_BWReport            		0xdcc
-#define rOFDM_AGCReport           		0xdd0
-#define rOFDM_RxSNR               		0xdd4
-#define rOFDM_RxEVMCSI            		0xdd8
-#define rOFDM_SIGReport           		0xddc
+#define rOFDM_PHYCounter1			0xda0  //cca, parity fail
+#define rOFDM_PHYCounter2			0xda4  //rate illegal, crc8 fail
+#define rOFDM_PHYCounter3			0xda8  //MCS not support
+#define rOFDM_ShortCFOAB			0xdac
+#define rOFDM_ShortCFOCD			0xdb0
+#define rOFDM_LongCFOAB				0xdb4
+#define rOFDM_LongCFOCD				0xdb8
+#define rOFDM_TailCFOAB				0xdbc
+#define rOFDM_TailCFOCD				0xdc0
+#define rOFDM_PWMeasure1		0xdc4
+#define rOFDM_PWMeasure2		0xdc8
+#define rOFDM_BWReport				0xdcc
+#define rOFDM_AGCReport				0xdd0
+#define rOFDM_RxSNR				0xdd4
+#define rOFDM_RxEVMCSI				0xdd8
+#define rOFDM_SIGReport				0xddc
 
 //page e
 #define rTxAGC_Rate18_06			0xe00
@@ -198,373 +198,373 @@
 
 //RF
 //Zebra1
-#define rZebra1_HSSIEnable            	0x0
-#define rZebra1_TRxEnable1            	0x1
-#define rZebra1_TRxEnable2           	0x2
-#define rZebra1_AGC                   		0x4
-#define rZebra1_ChargePump            	0x5
-#define rZebra1_Channel               		0x7
-#define rZebra1_TxGain               		0x8
-#define rZebra1_TxLPF                 		0x9
-#define rZebra1_RxLPF                 		0xb
-#define rZebra1_RxHPFCorner           	0xc
+#define rZebra1_HSSIEnable		0x0
+#define rZebra1_TRxEnable1		0x1
+#define rZebra1_TRxEnable2		0x2
+#define rZebra1_AGC				0x4
+#define rZebra1_ChargePump		0x5
+#define rZebra1_Channel				0x7
+#define rZebra1_TxGain				0x8
+#define rZebra1_TxLPF				0x9
+#define rZebra1_RxLPF				0xb
+#define rZebra1_RxHPFCorner		0xc
 
 //Zebra4
-#define rGlobalCtrl                   		0
-#define rRTL8256_TxLPF                		19
-#define rRTL8256_RxLPF                		11
+#define rGlobalCtrl				0
+#define rRTL8256_TxLPF				19
+#define rRTL8256_RxLPF				11
 
 //RTL8258
-#define rRTL8258_TxLPF                		0x11
-#define rRTL8258_RxLPF                		0x13
-#define rRTL8258_RSSILPF              	0xa
+#define rRTL8258_TxLPF				0x11
+#define rRTL8258_RxLPF				0x13
+#define rRTL8258_RSSILPF		0xa
 
 //Bit Mask
 //page-1
-#define bBBResetB                 			0x100
-#define bGlobalResetB             		0x200
-#define bOFDMTxStart              		0x4
-#define bCCKTxStart               			0x8
-#define bCRC32Debug               		0x100
-#define bPMACLoopback             		0x10
-#define bTxLSIG                   			0xffffff
-#define bOFDMTxRate               		0xf
-#define bOFDMTxReserved           		0x10
-#define bOFDMTxLength             		0x1ffe0
-#define bOFDMTxParity             		0x20000
-#define bTxHTSIG1                 			0xffffff
-#define bTxHTMCSRate              		0x7f
-#define bTxHTBW                   			0x80
-#define bTxHTLength               		0xffff00
-#define bTxHTSIG2                 			0xffffff
-#define bTxHTSmoothing            		0x1
-#define bTxHTSounding             		0x2
-#define bTxHTReserved             		0x4
-#define bTxHTAggreation           		0x8
-#define bTxHTSTBC                 			0x30
-#define bTxHTAdvanceCoding        		0x40
-#define bTxHTShortGI              		0x80
-#define bTxHTNumberHT_LTF         		0x300
-#define bTxHTCRC8                 			0x3fc00
-#define bCounterReset             		0x10000
-#define bNumOfOFDMTx              		0xffff
-#define bNumOfCCKTx               		0xffff0000
-#define bTxIdleInterval           			0xffff
-#define bOFDMService              		0xffff0000
-#define bTxMACHeader              		0xffffffff
-#define bTxDataInit               			0xff
-#define bTxHTMode                 		0x100
-#define bTxDataType               		0x30000
-#define bTxRandomSeed             		0xffffffff
-#define bCCKTxPreamble           		0x1
-#define bCCKTxSFD                 			0xffff0000
-#define bCCKTxSIG                 			0xff
-#define bCCKTxService             		0xff00
-#define bCCKLengthExt             		0x8000
-#define bCCKTxLength              		0xffff0000
-#define bCCKTxCRC16               		0xffff
-#define bCCKTxStatus              		0x1
-#define bOFDMTxStatus             		0x2
+#define bBBResetB					0x100
+#define bGlobalResetB				0x200
+#define bOFDMTxStart				0x4
+#define bCCKTxStart					0x8
+#define bCRC32Debug				0x100
+#define bPMACLoopback				0x10
+#define bTxLSIG						0xffffff
+#define bOFDMTxRate				0xf
+#define bOFDMTxReserved				0x10
+#define bOFDMTxLength				0x1ffe0
+#define bOFDMTxParity				0x20000
+#define bTxHTSIG1					0xffffff
+#define bTxHTMCSRate				0x7f
+#define bTxHTBW						0x80
+#define bTxHTLength				0xffff00
+#define bTxHTSIG2					0xffffff
+#define bTxHTSmoothing				0x1
+#define bTxHTSounding				0x2
+#define bTxHTReserved				0x4
+#define bTxHTAggreation				0x8
+#define bTxHTSTBC					0x30
+#define bTxHTAdvanceCoding			0x40
+#define bTxHTShortGI				0x80
+#define bTxHTNumberHT_LTF			0x300
+#define bTxHTCRC8					0x3fc00
+#define bCounterReset				0x10000
+#define bNumOfOFDMTx				0xffff
+#define bNumOfCCKTx				0xffff0000
+#define bTxIdleInterval					0xffff
+#define bOFDMService				0xffff0000
+#define bTxMACHeader				0xffffffff
+#define bTxDataInit					0xff
+#define bTxHTMode				0x100
+#define bTxDataType				0x30000
+#define bTxRandomSeed				0xffffffff
+#define bCCKTxPreamble				0x1
+#define bCCKTxSFD					0xffff0000
+#define bCCKTxSIG					0xff
+#define bCCKTxService				0xff00
+#define bCCKLengthExt				0x8000
+#define bCCKTxLength				0xffff0000
+#define bCCKTxCRC16				0xffff
+#define bCCKTxStatus				0x1
+#define bOFDMTxStatus				0x2
 
 //page-8
-#define bRFMOD                    			0x1
-#define bJapanMode                		0x2
-#define bCCKTxSC                  			0x30
-#define bCCKEn                    			0x1000000
-#define bOFDMEn                   			0x2000000
-#define bOFDMRxADCPhase           		0x10000
-#define bOFDMTxDACPhase           		0x40000
-#define bXATxAGC                  			0x3f
-#define bXBTxAGC                  			0xf00
-#define bXCTxAGC                  			0xf000
-#define bXDTxAGC                  			0xf0000
-#define bPAStart                  			0xf0000000
-#define bTRStart                  			0x00f00000
-#define bRFStart                  			0x0000f000
-#define bBBStart                  			0x000000f0
-#define bBBCCKStart               		0x0000000f
-#define bPAEnd                    			0xf          //Reg0x814
-#define bTREnd                    			0x0f000000
-#define bRFEnd                    			0x000f0000
-#define bCCAMask                  			0x000000f0   //T2R
-#define bR2RCCAMask               		0x00000f00
-#define bHSSI_R2TDelay            		0xf8000000
-#define bHSSI_T2RDelay            		0xf80000
-#define bContTxHSSI               		0x400     //chane gain at continue Tx
-#define bIGFromCCK                		0x200
-#define bAGCAddress               		0x3f
-#define bRxHPTx                   			0x7000
-#define bRxHPT2R                  			0x38000
-#define bRxHPCCKIni               		0xc0000
-#define bAGCTxCode                		0xc00000
-#define bAGCRxCode                		0x300000
-#define b3WireDataLength          		0x800
-#define b3WireAddressLength       		0x400
-#define b3WireRFPowerDown         		0x1
-//#define bHWSISelect               		0x8
-#define b5GPAPEPolarity           		0x40000000
-#define b2GPAPEPolarity           		0x80000000
-#define bRFSW_TxDefaultAnt        		0x3
-#define bRFSW_TxOptionAnt         		0x30
-#define bRFSW_RxDefaultAnt        		0x300
-#define bRFSW_RxOptionAnt         		0x3000
-#define bRFSI_3WireData           		0x1
-#define bRFSI_3WireClock          		0x2
-#define bRFSI_3WireLoad           		0x4
-#define bRFSI_3WireRW             		0x8
-#define bRFSI_3Wire               			0xf  //3-wire total control
-#define bRFSI_RFENV               		0x10
-#define bRFSI_TRSW                		0x20
-#define bRFSI_TRSWB               		0x40
-#define bRFSI_ANTSW               		0x100
-#define bRFSI_ANTSWB              		0x200
-#define bRFSI_PAPE                			0x400
-#define bRFSI_PAPE5G              		0x800
-#define bBandSelect               			0x1
-#define bHTSIG2_GI                			0x80
-#define bHTSIG2_Smoothing         		0x01
-#define bHTSIG2_Sounding          		0x02
-#define bHTSIG2_Aggreaton         		0x08
-#define bHTSIG2_STBC              		0x30
-#define bHTSIG2_AdvCoding         		0x40
-#define bHTSIG2_NumOfHTLTF        	0x300
-#define bHTSIG2_CRC8              		0x3fc
-#define bHTSIG1_MCS               		0x7f
-#define bHTSIG1_BandWidth         		0x80
-#define bHTSIG1_HTLength          		0xffff
-#define bLSIG_Rate                			0xf
-#define bLSIG_Reserved            		0x10
-#define bLSIG_Length              		0x1fffe
-#define bLSIG_Parity              			0x20
-#define bCCKRxPhase               		0x4
-#define bLSSIReadAddress          		0x3f000000   //LSSI "Read" Address
-#define bLSSIReadEdge             		0x80000000   //LSSI "Read" edge signal
-#define bLSSIReadBackData         		0xfff
-#define bLSSIReadOKFlag           		0x1000
-#define bCCKSampleRate            		0x8       //0: 44MHz, 1:88MHz
-
-#define bRegulator0Standby        		0x1
-#define bRegulatorPLLStandby      		0x2
-#define bRegulator1Standby        		0x4
-#define bPLLPowerUp               		0x8
-#define bDPLLPowerUp              		0x10
-#define bDA10PowerUp              		0x20
-#define bAD7PowerUp               		0x200
-#define bDA6PowerUp               		0x2000
-#define bXtalPowerUp              		0x4000
-#define b40MDClkPowerUP           		0x8000
-#define bDA6DebugMode             		0x20000
-#define bDA6Swing                 			0x380000
-#define bADClkPhase               		0x4000000
-#define b80MClkDelay              		0x18000000
-#define bAFEWatchDogEnable        		0x20000000
-#define bXtalCap                			0x0f000000
-#define bIntDifClkEnable          		0x400
-#define bExtSigClkEnable         		0x800
-#define bBandgapMbiasPowerUp      	0x10000
-#define bAD11SHGain               		0xc0000
-#define bAD11InputRange           		0x700000
-#define bAD11OPCurrent            		0x3800000
-#define bIPathLoopback            		0x4000000
-#define bQPathLoopback            		0x8000000
-#define bAFELoopback              		0x10000000
-#define bDA10Swing                		0x7e0
-#define bDA10Reverse              		0x800
-#define bDAClkSource              		0x1000
-#define bAD7InputRange            		0x6000
-#define bAD7Gain                  			0x38000
-#define bAD7OutputCMMode          		0x40000
-#define bAD7InputCMMode           		0x380000
-#define bAD7Current               			0xc00000
-#define bRegulatorAdjust          		0x7000000
-#define bAD11PowerUpAtTx          		0x1
-#define bDA10PSAtTx               		0x10
-#define bAD11PowerUpAtRx          		0x100
-#define bDA10PSAtRx               		0x1000
-
-#define bCCKRxAGCFormat           		0x200
-
-#define bPSDFFTSamplepPoint       		0xc000
-#define bPSDAverageNum            		0x3000
-#define bIQPathControl            		0xc00
-#define bPSDFreq                  			0x3ff
-#define bPSDAntennaPath           		0x30
-#define bPSDIQSwitch              		0x40
-#define bPSDRxTrigger             		0x400000
-#define bPSDTxTrigger             		0x80000000
-#define bPSDSineToneScale        		0x7f000000
-#define bPSDReport                			0xffff
+#define bRFMOD						0x1
+#define bJapanMode				0x2
+#define bCCKTxSC					0x30
+#define bCCKEn						0x1000000
+#define bOFDMEn						0x2000000
+#define bOFDMRxADCPhase				0x10000
+#define bOFDMTxDACPhase				0x40000
+#define bXATxAGC					0x3f
+#define bXBTxAGC					0xf00
+#define bXCTxAGC					0xf000
+#define bXDTxAGC					0xf0000
+#define bPAStart					0xf0000000
+#define bTRStart					0x00f00000
+#define bRFStart					0x0000f000
+#define bBBStart					0x000000f0
+#define bBBCCKStart				0x0000000f
+#define bPAEnd						0xf          //Reg0x814
+#define bTREnd						0x0f000000
+#define bRFEnd						0x000f0000
+#define bCCAMask					0x000000f0   //T2R
+#define bR2RCCAMask				0x00000f00
+#define bHSSI_R2TDelay				0xf8000000
+#define bHSSI_T2RDelay				0xf80000
+#define bContTxHSSI				0x400     //chane gain at continue Tx
+#define bIGFromCCK				0x200
+#define bAGCAddress				0x3f
+#define bRxHPTx						0x7000
+#define bRxHPT2R					0x38000
+#define bRxHPCCKIni				0xc0000
+#define bAGCTxCode				0xc00000
+#define bAGCRxCode				0x300000
+#define b3WireDataLength			0x800
+#define b3WireAddressLength			0x400
+#define b3WireRFPowerDown			0x1
+//#define bHWSISelect				0x8
+#define b5GPAPEPolarity				0x40000000
+#define b2GPAPEPolarity				0x80000000
+#define bRFSW_TxDefaultAnt			0x3
+#define bRFSW_TxOptionAnt			0x30
+#define bRFSW_RxDefaultAnt			0x300
+#define bRFSW_RxOptionAnt			0x3000
+#define bRFSI_3WireData				0x1
+#define bRFSI_3WireClock			0x2
+#define bRFSI_3WireLoad				0x4
+#define bRFSI_3WireRW				0x8
+#define bRFSI_3Wire					0xf  //3-wire total control
+#define bRFSI_RFENV				0x10
+#define bRFSI_TRSW				0x20
+#define bRFSI_TRSWB				0x40
+#define bRFSI_ANTSW				0x100
+#define bRFSI_ANTSWB				0x200
+#define bRFSI_PAPE					0x400
+#define bRFSI_PAPE5G				0x800
+#define bBandSelect					0x1
+#define bHTSIG2_GI					0x80
+#define bHTSIG2_Smoothing			0x01
+#define bHTSIG2_Sounding			0x02
+#define bHTSIG2_Aggreaton			0x08
+#define bHTSIG2_STBC				0x30
+#define bHTSIG2_AdvCoding			0x40
+#define bHTSIG2_NumOfHTLTF		0x300
+#define bHTSIG2_CRC8				0x3fc
+#define bHTSIG1_MCS				0x7f
+#define bHTSIG1_BandWidth			0x80
+#define bHTSIG1_HTLength			0xffff
+#define bLSIG_Rate					0xf
+#define bLSIG_Reserved				0x10
+#define bLSIG_Length				0x1fffe
+#define bLSIG_Parity					0x20
+#define bCCKRxPhase				0x4
+#define bLSSIReadAddress			0x3f000000   //LSSI "Read" Address
+#define bLSSIReadEdge				0x80000000   //LSSI "Read" edge signal
+#define bLSSIReadBackData			0xfff
+#define bLSSIReadOKFlag				0x1000
+#define bCCKSampleRate				0x8       //0: 44MHz, 1:88MHz
+
+#define bRegulator0Standby			0x1
+#define bRegulatorPLLStandby			0x2
+#define bRegulator1Standby			0x4
+#define bPLLPowerUp				0x8
+#define bDPLLPowerUp				0x10
+#define bDA10PowerUp				0x20
+#define bAD7PowerUp				0x200
+#define bDA6PowerUp				0x2000
+#define bXtalPowerUp				0x4000
+#define b40MDClkPowerUP				0x8000
+#define bDA6DebugMode				0x20000
+#define bDA6Swing					0x380000
+#define bADClkPhase				0x4000000
+#define b80MClkDelay				0x18000000
+#define bAFEWatchDogEnable			0x20000000
+#define bXtalCap					0x0f000000
+#define bIntDifClkEnable			0x400
+#define bExtSigClkEnable			0x800
+#define bBandgapMbiasPowerUp		0x10000
+#define bAD11SHGain				0xc0000
+#define bAD11InputRange				0x700000
+#define bAD11OPCurrent				0x3800000
+#define bIPathLoopback				0x4000000
+#define bQPathLoopback				0x8000000
+#define bAFELoopback				0x10000000
+#define bDA10Swing				0x7e0
+#define bDA10Reverse				0x800
+#define bDAClkSource				0x1000
+#define bAD7InputRange				0x6000
+#define bAD7Gain					0x38000
+#define bAD7OutputCMMode			0x40000
+#define bAD7InputCMMode				0x380000
+#define bAD7Current					0xc00000
+#define bRegulatorAdjust			0x7000000
+#define bAD11PowerUpAtTx			0x1
+#define bDA10PSAtTx				0x10
+#define bAD11PowerUpAtRx			0x100
+#define bDA10PSAtRx				0x1000
+
+#define bCCKRxAGCFormat				0x200
+
+#define bPSDFFTSamplepPoint			0xc000
+#define bPSDAverageNum				0x3000
+#define bIQPathControl				0xc00
+#define bPSDFreq					0x3ff
+#define bPSDAntennaPath				0x30
+#define bPSDIQSwitch				0x40
+#define bPSDRxTrigger				0x400000
+#define bPSDTxTrigger				0x80000000
+#define bPSDSineToneScale			0x7f000000
+#define bPSDReport					0xffff
 
 //page-9
-#define bOFDMTxSC                 		0x30000000
-#define bCCKTxOn                  			0x1
-#define bOFDMTxOn                 		0x2
-#define bDebugPage                		0xfff  //reset debug page and also HWord, LWord
-#define bDebugItem                		0xff   //reset debug page and LWord
-#define bAntL              			0x10
-#define bAntNonHT           				0x100
-#define bAntHT1               			0x1000
-#define bAntHT2                   			0x10000
-#define bAntHT1S1                 			0x100000
-#define bAntNonHTS1               		0x1000000
+#define bOFDMTxSC				0x30000000
+#define bCCKTxOn					0x1
+#define bOFDMTxOn				0x2
+#define bDebugPage				0xfff  //reset debug page and also HWord, LWord
+#define bDebugItem				0xff   //reset debug page and LWord
+#define bAntL					0x10
+#define bAntNonHT					0x100
+#define bAntHT1					0x1000
+#define bAntHT2						0x10000
+#define bAntHT1S1					0x100000
+#define bAntNonHTS1				0x1000000
 
 //page-a
-#define bCCKBBMode                		0x3
-#define bCCKTxPowerSaving         		0x80
-#define bCCKRxPowerSaving         		0x40
-#define bCCKSideBand              		0x10
-#define bCCKScramble              		0x8
-#define bCCKAntDiversity    			0x8000
-#define bCCKCarrierRecovery   		0x4000
-#define bCCKTxRate           			0x3000
-#define bCCKDCCancel             		0x0800
-#define bCCKISICancel             		0x0400
-#define bCCKMatchFilter           		0x0200
-#define bCCKEqualizer             		0x0100
-#define bCCKPreambleDetect       		0x800000
-#define bCCKFastFalseCCA          		0x400000
-#define bCCKChEstStart            		0x300000
-#define bCCKCCACount              		0x080000
-#define bCCKcs_lim                			0x070000
-#define bCCKBistMode              		0x80000000
-#define bCCKCCAMask             		0x40000000
-#define bCCKTxDACPhase         		0x4
-#define bCCKRxADCPhase         		0x20000000   //r_rx_clk
-#define bCCKr_cp_mode0         		0x0100
-#define bCCKTxDCOffset           		0xf0
-#define bCCKRxDCOffset           		0xf
-#define bCCKCCAMode              		0xc000
-#define bCCKFalseCS_lim           		0x3f00
-#define bCCKCS_ratio              		0xc00000
-#define bCCKCorgBit_sel           		0x300000
-#define bCCKPD_lim                			0x0f0000
-#define bCCKNewCCA                		0x80000000
-#define bCCKRxHPofIG              		0x8000
-#define bCCKRxIG                  			0x7f00
-#define bCCKLNAPolarity           		0x800000
-#define bCCKRx1stGain             		0x7f0000
-#define bCCKRFExtend              		0x20000000 //CCK Rx initial gain polarity
-#define bCCKRxAGCSatLevel        		0x1f000000
-#define bCCKRxAGCSatCount       		0xe0
-#define bCCKRxRFSettle            		0x1f       //AGCsamp_dly
-#define bCCKFixedRxAGC           		0x8000
-//#define bCCKRxAGCFormat         		0x4000   //remove to HSSI register 0x824
-#define bCCKAntennaPolarity      		0x2000
-#define bCCKTxFilterType          		0x0c00
-#define bCCKRxAGCReportType   		0x0300
-#define bCCKRxDAGCEn              		0x80000000
-#define bCCKRxDAGCPeriod        		0x20000000
-#define bCCKRxDAGCSatLevel     		0x1f000000
-#define bCCKTimingRecovery       		0x800000
-#define bCCKTxC0                  			0x3f0000
-#define bCCKTxC1                  			0x3f000000
-#define bCCKTxC2                  			0x3f
-#define bCCKTxC3                  			0x3f00
-#define bCCKTxC4                  			0x3f0000
-#define bCCKTxC5                  			0x3f000000
-#define bCCKTxC6                  			0x3f
-#define bCCKTxC7                  			0x3f00
-#define bCCKDebugPort             		0xff0000
-#define bCCKDACDebug              		0x0f000000
-#define bCCKFalseAlarmEnable      		0x8000
-#define bCCKFalseAlarmRead        		0x4000
-#define bCCKTRSSI                 			0x7f
-#define bCCKRxAGCReport           		0xfe
-#define bCCKRxReport_AntSel       		0x80000000
-#define bCCKRxReport_MFOff        		0x40000000
-#define bCCKRxRxReport_SQLoss     	0x20000000
-#define bCCKRxReport_Pktloss      		0x10000000
-#define bCCKRxReport_Lockedbit    	0x08000000
-#define bCCKRxReport_RateError    	0x04000000
-#define bCCKRxReport_RxRate       		0x03000000
-#define bCCKRxFACounterLower      	0xff
-#define bCCKRxFACounterUpper      	0xff000000
-#define bCCKRxHPAGCStart          		0xe000
-#define bCCKRxHPAGCFinal          		0x1c00
-
-#define bCCKRxFalseAlarmEnable    	0x8000
-#define bCCKFACounterFreeze       		0x4000
-
-#define bCCKTxPathSel             		0x10000000
-#define bCCKDefaultRxPath         		0xc000000
-#define bCCKOptionRxPath          		0x3000000
+#define bCCKBBMode				0x3
+#define bCCKTxPowerSaving			0x80
+#define bCCKRxPowerSaving			0x40
+#define bCCKSideBand				0x10
+#define bCCKScramble				0x8
+#define bCCKAntDiversity			0x8000
+#define bCCKCarrierRecovery		0x4000
+#define bCCKTxRate				0x3000
+#define bCCKDCCancel				0x0800
+#define bCCKISICancel				0x0400
+#define bCCKMatchFilter				0x0200
+#define bCCKEqualizer				0x0100
+#define bCCKPreambleDetect			0x800000
+#define bCCKFastFalseCCA			0x400000
+#define bCCKChEstStart				0x300000
+#define bCCKCCACount				0x080000
+#define bCCKcs_lim					0x070000
+#define bCCKBistMode				0x80000000
+#define bCCKCCAMask				0x40000000
+#define bCCKTxDACPhase			0x4
+#define bCCKRxADCPhase			0x20000000   //r_rx_clk
+#define bCCKr_cp_mode0			0x0100
+#define bCCKTxDCOffset				0xf0
+#define bCCKRxDCOffset				0xf
+#define bCCKCCAMode				0xc000
+#define bCCKFalseCS_lim				0x3f00
+#define bCCKCS_ratio				0xc00000
+#define bCCKCorgBit_sel				0x300000
+#define bCCKPD_lim					0x0f0000
+#define bCCKNewCCA				0x80000000
+#define bCCKRxHPofIG				0x8000
+#define bCCKRxIG					0x7f00
+#define bCCKLNAPolarity				0x800000
+#define bCCKRx1stGain				0x7f0000
+#define bCCKRFExtend				0x20000000 //CCK Rx initial gain polarity
+#define bCCKRxAGCSatLevel			0x1f000000
+#define bCCKRxAGCSatCount			0xe0
+#define bCCKRxRFSettle				0x1f       //AGCsamp_dly
+#define bCCKFixedRxAGC				0x8000
+//#define bCCKRxAGCFormat			0x4000   //remove to HSSI register 0x824
+#define bCCKAntennaPolarity			0x2000
+#define bCCKTxFilterType			0x0c00
+#define bCCKRxAGCReportType		0x0300
+#define bCCKRxDAGCEn				0x80000000
+#define bCCKRxDAGCPeriod			0x20000000
+#define bCCKRxDAGCSatLevel		0x1f000000
+#define bCCKTimingRecovery			0x800000
+#define bCCKTxC0					0x3f0000
+#define bCCKTxC1					0x3f000000
+#define bCCKTxC2					0x3f
+#define bCCKTxC3					0x3f00
+#define bCCKTxC4					0x3f0000
+#define bCCKTxC5					0x3f000000
+#define bCCKTxC6					0x3f
+#define bCCKTxC7					0x3f00
+#define bCCKDebugPort				0xff0000
+#define bCCKDACDebug				0x0f000000
+#define bCCKFalseAlarmEnable			0x8000
+#define bCCKFalseAlarmRead			0x4000
+#define bCCKTRSSI					0x7f
+#define bCCKRxAGCReport				0xfe
+#define bCCKRxReport_AntSel			0x80000000
+#define bCCKRxReport_MFOff			0x40000000
+#define bCCKRxRxReport_SQLoss		0x20000000
+#define bCCKRxReport_Pktloss			0x10000000
+#define bCCKRxReport_Lockedbit		0x08000000
+#define bCCKRxReport_RateError		0x04000000
+#define bCCKRxReport_RxRate			0x03000000
+#define bCCKRxFACounterLower		0xff
+#define bCCKRxFACounterUpper		0xff000000
+#define bCCKRxHPAGCStart			0xe000
+#define bCCKRxHPAGCFinal			0x1c00
+
+#define bCCKRxFalseAlarmEnable		0x8000
+#define bCCKFACounterFreeze			0x4000
+
+#define bCCKTxPathSel				0x10000000
+#define bCCKDefaultRxPath			0xc000000
+#define bCCKOptionRxPath			0x3000000
 
 //page c
-#define bNumOfSTF                			0x3
-#define bShift_L                 			0xc0
-#define bGI_TH                   			0xc
-#define bRxPathA                 			0x1
-#define bRxPathB                 			0x2
-#define bRxPathC                 			0x4
-#define bRxPathD                 			0x8
-#define bTxPathA                 			0x1
-#define bTxPathB                 			0x2
-#define bTxPathC                 			0x4
-#define bTxPathD                 			0x8
-#define bTRSSIFreq               			0x200
-#define bADCBackoff              			0x3000
-#define bDFIRBackoff             			0xc000
-#define bTRSSILatchPhase         		0x10000
-#define bRxIDCOffset             			0xff
-#define bRxQDCOffset             			0xff00
-#define bRxDFIRMode              		0x1800000
-#define bRxDCNFType              		0xe000000
-#define bRXIQImb_A               			0x3ff
-#define bRXIQImb_B               			0xfc00
-#define bRXIQImb_C               			0x3f0000
-#define bRXIQImb_D               			0xffc00000
-#define bDC_dc_Notch             		0x60000
-#define bRxNBINotch              			0x1f000000
-#define bPD_TH                   			0xf
-#define bPD_TH_Opt2              		0xc000
-#define bPWED_TH                 			0x700
-#define bIfMF_Win_L              			0x800
-#define bPD_Option               			0x1000
-#define bMF_Win_L                			0xe000
-#define bBW_Search_L             		0x30000
-#define bwin_enh_L               			0xc0000
-#define bBW_TH                   			0x700000
-#define bED_TH2                  			0x3800000
-#define bBW_option               			0x4000000
-#define bRatio_TH                			0x18000000
-#define bWindow_L                			0xe0000000
-#define bSBD_Option              			0x1
-#define bFrame_TH                			0x1c
-#define bFS_Option               			0x60
-#define bDC_Slope_check          		0x80
-#define bFGuard_Counter_DC_L     		0xe00
-#define bFrame_Weight_Short      		0x7000
-#define bSub_Tune                			0xe00000
-#define bFrame_DC_Length         		0xe000000
-#define bSBD_start_offset        		0x30000000
-#define bFrame_TH_2              		0x7
-#define bFrame_GI2_TH            		0x38
-#define bGI2_Sync_en             		0x40
-#define bSarch_Short_Early       		0x300
-#define bSarch_Short_Late        		0xc00
-#define bSarch_GI2_Late          		0x70000
-#define bCFOAntSum               		0x1
-#define bCFOAcc                  			0x2
-#define bCFOStartOffset          		0xc
-#define bCFOLookBack             		0x70
-#define bCFOSumWeight            		0x80
-#define bDAGCEnable              			0x10000
-#define bTXIQImb_A               			0x3ff
-#define bTXIQImb_B               			0xfc00
-#define bTXIQImb_C               			0x3f0000
-#define bTXIQImb_D               			0xffc00000
-#define bTxIDCOffset             			0xff
-#define bTxQDCOffset             			0xff00
-#define bTxDFIRMode              		0x10000
-#define bTxPesudoNoiseOn         		0x4000000
-#define bTxPesudoNoise_A         		0xff
-#define bTxPesudoNoise_B         		0xff00
-#define bTxPesudoNoise_C         		0xff0000
-#define bTxPesudoNoise_D         		0xff000000
-#define bCCADropOption           		0x20000
-#define bCCADropThres            		0xfff00000
-#define bEDCCA_H                 			0xf
-#define bEDCCA_L                 			0xf0
+#define bNumOfSTF					0x3
+#define bShift_L					0xc0
+#define bGI_TH						0xc
+#define bRxPathA					0x1
+#define bRxPathB					0x2
+#define bRxPathC					0x4
+#define bRxPathD					0x8
+#define bTxPathA					0x1
+#define bTxPathB					0x2
+#define bTxPathC					0x4
+#define bTxPathD					0x8
+#define bTRSSIFreq					0x200
+#define bADCBackoff					0x3000
+#define bDFIRBackoff					0xc000
+#define bTRSSILatchPhase			0x10000
+#define bRxIDCOffset					0xff
+#define bRxQDCOffset					0xff00
+#define bRxDFIRMode				0x1800000
+#define bRxDCNFType				0xe000000
+#define bRXIQImb_A					0x3ff
+#define bRXIQImb_B					0xfc00
+#define bRXIQImb_C					0x3f0000
+#define bRXIQImb_D					0xffc00000
+#define bDC_dc_Notch				0x60000
+#define bRxNBINotch					0x1f000000
+#define bPD_TH						0xf
+#define bPD_TH_Opt2				0xc000
+#define bPWED_TH					0x700
+#define bIfMF_Win_L					0x800
+#define bPD_Option					0x1000
+#define bMF_Win_L					0xe000
+#define bBW_Search_L				0x30000
+#define bwin_enh_L					0xc0000
+#define bBW_TH						0x700000
+#define bED_TH2						0x3800000
+#define bBW_option					0x4000000
+#define bRatio_TH					0x18000000
+#define bWindow_L					0xe0000000
+#define bSBD_Option					0x1
+#define bFrame_TH					0x1c
+#define bFS_Option					0x60
+#define bDC_Slope_check				0x80
+#define bFGuard_Counter_DC_L			0xe00
+#define bFrame_Weight_Short			0x7000
+#define bSub_Tune					0xe00000
+#define bFrame_DC_Length			0xe000000
+#define bSBD_start_offset			0x30000000
+#define bFrame_TH_2				0x7
+#define bFrame_GI2_TH				0x38
+#define bGI2_Sync_en				0x40
+#define bSarch_Short_Early			0x300
+#define bSarch_Short_Late			0xc00
+#define bSarch_GI2_Late				0x70000
+#define bCFOAntSum				0x1
+#define bCFOAcc						0x2
+#define bCFOStartOffset				0xc
+#define bCFOLookBack				0x70
+#define bCFOSumWeight				0x80
+#define bDAGCEnable					0x10000
+#define bTXIQImb_A					0x3ff
+#define bTXIQImb_B					0xfc00
+#define bTXIQImb_C					0x3f0000
+#define bTXIQImb_D					0xffc00000
+#define bTxIDCOffset					0xff
+#define bTxQDCOffset					0xff00
+#define bTxDFIRMode				0x10000
+#define bTxPesudoNoiseOn			0x4000000
+#define bTxPesudoNoise_A			0xff
+#define bTxPesudoNoise_B			0xff00
+#define bTxPesudoNoise_C			0xff0000
+#define bTxPesudoNoise_D			0xff000000
+#define bCCADropOption				0x20000
+#define bCCADropThres				0xfff00000
+#define bEDCCA_H					0xf
+#define bEDCCA_L					0xf0
 #define bLambda_ED               0x300
 #define bRxInitialGain           0x7f
 #define bRxAntDivEn              0x80
@@ -862,10 +862,10 @@
 #define PathD                     0x3
 
 #define	rRTL8256RxMixerPole		0xb
-#define 	bZebraRxMixerPole		0x6
-#define 	rRTL8256TxBBOPBias        0x9
-#define 	bRTL8256TxBBOPBias       0x400
-#define 	rRTL8256TxBBBW             19
-#define 	bRTL8256TxBBBW            	0x18
+#define		bZebraRxMixerPole		0x6
+#define		rRTL8256TxBBOPBias        0x9
+#define		bRTL8256TxBBOPBias       0x400
+#define		rRTL8256TxBBBW             19
+#define		bRTL8256TxBBBW			0x18
 
 #endif	//__INC_HAL8190PCIPHYREG_H
-- 
1.7.10.4

