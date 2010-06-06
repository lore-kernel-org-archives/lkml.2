Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab0FFXHY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 19:07:24 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:47556 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab0FFXHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 19:07:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=A9BzGQEpRuymB4qBpPpN28g3/3krZeFo4d0MMs4scERsrG9Kqz/udZFaeXeuTvquZE
         UmsmYLh1kTPC/e+pnQDyhLL8oM3MuaQg94/PhRPC31ATST1W99nN5qHVAE1sRya9/o6a
         J+9dKauJIPoeX9ZhDqEoKIh9Q2Auqeg+8IZ6U=
From: Neil Munro <neilmunro@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Niadh <neilmunro@gmail.com>
Subject: [PATCH] Staging: RT2860 Fixed all errors in mlme.h and all but one in rtmp.h.
Date: Mon,  7 Jun 2010 00:09:18 +0100
Message-Id: <1275865758-7840-1-git-send-email-neilmunro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Niadh <neilmunro@gmail.com>

I have fixed all errors in mlme.h and fixed all bar one in rtmp.h.
I think I can fix rtmp.h too by moving a brace up two lines, I just dont know if it will work.
If someone can confirm it will work I will change it.

Signed-off-by: Neil Munro <neilmunro@gmail.com>
---
 drivers/staging/rt2860/mlme.h |   21 ++++++++++-----------
 drivers/staging/rt2860/rtmp.h |    4 ++--
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/rt2860/mlme.h b/drivers/staging/rt2860/mlme.h
index 99c9362..01414c3 100644
--- a/drivers/staging/rt2860/mlme.h
+++ b/drivers/staging/rt2860/mlme.h
@@ -31,7 +31,7 @@

 	Revision History:
 	Who			When			What
-	--------	----------		----------------------------------------------
+	--------	----------		------------------------------
 	John Chang	2003-08-28		Created
 	John Chang  2004-09-06      modified for RT2600

@@ -50,7 +50,7 @@
 #define MLME_TASK_EXEC_INTV         100/*200*/	/* */
 #define LEAD_TIME                   5
 #define MLME_TASK_EXEC_MULTIPLE       10  /*5*/	/* MLME_TASK_EXEC_MULTIPLE * MLME_TASK_EXEC_INTV = 1 sec */
-#define REORDER_EXEC_INTV         	100	/* 0.1 sec */
+#define REORDER_EXEC_INTV		100	/* 0.1 sec */

 /* The definition of Radar detection duration region */
 #define CE		0
@@ -60,7 +60,7 @@
 #define JAP_W56	4
 #define MAX_RD_REGION 5

-#define BEACON_LOST_TIME            4 * OS_HZ	/* 2048 msec = 2 sec */
+#define BEACON_LOST_TIME            (4 * OS_HZ)	/* 2048 msec = 2 sec */

 #define DLS_TIMEOUT                 1200	/* unit: msec */
 #define AUTH_TIMEOUT                300	/* unit: msec */
@@ -119,8 +119,8 @@
 #define MAC_ADDR_IS_GROUP(Addr)       (((Addr[0]) & 0x01))
 #define MAC_ADDR_HASH(Addr)            (Addr[0] ^ Addr[1] ^ Addr[2] ^ Addr[3] ^ Addr[4] ^ Addr[5])
 #define MAC_ADDR_HASH_INDEX(Addr)      (MAC_ADDR_HASH(Addr) % HASH_TABLE_SIZE)
-#define TID_MAC_HASH(Addr,TID)            (TID^Addr[0] ^ Addr[1] ^ Addr[2] ^ Addr[3] ^ Addr[4] ^ Addr[5])
-#define TID_MAC_HASH_INDEX(Addr,TID)      (TID_MAC_HASH(Addr,TID) % HASH_TABLE_SIZE)
+#define TID_MAC_HASH(Addr, TID)            (TID^Addr[0] ^ Addr[1] ^ Addr[2] ^ Addr[3] ^ Addr[4] ^ Addr[5])
+#define TID_MAC_HASH_INDEX(Addr, TID)      (TID_MAC_HASH(Addr, TID) % HASH_TABLE_SIZE)

 /* LED Control */
 /* assoiation ON. one LED ON. another blinking when TX, OFF when idle */
@@ -145,7 +145,7 @@
 #define CAP_IS_DSSS_OFDM(x)              (((x) & 0x2000) != 0)
 #define CAP_IS_DELAY_BA(x)               (((x) & 0x4000) != 0)	/* 802.11e d9 */

-#define CAP_GENERATE(ess,ibss,priv,s_pre,s_slot,spectrum)  (((ess) ? 0x0001 : 0x0000) | ((ibss) ? 0x0002 : 0x0000) | ((priv) ? 0x0010 : 0x0000) | ((s_pre) ? 0x0020 : 0x0000) | ((s_slot) ? 0x0400 : 0x0000) | ((spectrum) ? 0x0100 : 0x0000))
+#define CAP_GENERATE(ess, ibss, priv, s_pre, s_slot, spectrum)  (((ess) ? 0x0001 : 0x0000) | ((ibss) ? 0x0002 : 0x0000) | ((priv) ? 0x0010 : 0x0000) | ((s_pre) ? 0x0020 : 0x0000) | ((s_slot) ? 0x0400 : 0x0000) | ((spectrum) ? 0x0100 : 0x0000))

 #define ERP_IS_NON_ERP_PRESENT(x)        (((x) & 0x01) != 0)	/* 802.11g */
 #define ERP_IS_USE_PROTECTION(x)         (((x) & 0x02) != 0)	/* 802.11g */
@@ -154,9 +154,9 @@
 #define DRS_TX_QUALITY_WORST_BOUND       8	/* 3  // just test by gary */
 #define DRS_PENALTY                      8

-#define BA_NOTUSE 	2
+#define BA_NOTUSE	2
 /*BA Policy subfiled value in ADDBA frame */
-#define IMMED_BA 	1
+#define IMMED_BA	1
 #define DELAY_BA	0

 /* BA Initiator subfield in DELBA frame */
@@ -176,8 +176,7 @@

 /* reset all OneSecTx counters */
 #define RESET_ONE_SEC_TX_CNT(__pEntry) \
-if (((__pEntry)) != NULL) \
-{ \
+if (((__pEntry)) != NULL) { \
 	(__pEntry)->OneSecTxRetryOkCount = 0; \
 	(__pEntry)->OneSecTxFailCount = 0; \
 	(__pEntry)->OneSecTxNoRetryOkCount = 0; \
@@ -846,7 +845,7 @@ struct rt_mlme_queue {
 	struct rt_mlme_queue_elem Entry[MAX_LEN_OF_MLME_QUEUE];
 };

-typedef void(*STATE_MACHINE_FUNC) (void * Adaptor, struct rt_mlme_queue_elem *Elem);
+typedef void(*STATE_MACHINE_FUNC) (void *Adaptor, struct rt_mlme_queue_elem *Elem);

 struct rt_state_machine {
 	unsigned long Base;
diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index 82b6e78..282935c 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -2511,7 +2511,7 @@ void RTMPWriteTxWI(struct rt_rtmp_adapter *pAd, struct rt_txwi * pTxWI, IN BOOLE
 		   u8 TID,
 		   u8 TxRate,
 		   u8 Txopmode,
-		   IN BOOLEAN CfAck, IN HTTRANSMIT_SETTING * pTransmit);
+		   IN BOOLEAN CfAck, IN HTTRANSMIT_SETTING *pTransmit);

 void RTMPWriteTxWI_Data(struct rt_rtmp_adapter *pAd,
 			struct rt_txwi *pTxWI, struct rt_tx_blk *pTxBlk);
@@ -3059,7 +3059,7 @@ BOOLEAN PeerBeaconAndProbeRspSanity(struct rt_rtmp_adapter *pAd,
 				    u16 *pBeaconPeriod,
 				    u8 *pChannel,
 				    u8 *pNewChannel,
-				    OUT LARGE_INTEGER * pTimestamp,
+				    OUT LARGE_INTEGER *pTimestamp,
 				    struct rt_cf_parm *pCfParm,
 				    u16 *pAtimWin,
 				    u16 *pCapabilityInfo,
--
1.7.1

