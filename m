Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab0EQLpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 07:45:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52185 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab0EQLo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 07:44:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Fn9W7yqTLRmVUBYMN84rJgpWJ5w0DP4gC0A5bvFGRvafxvzEDVHBdhOvAZOVDeFq1l
         QHrB6SIaGqgVxtTgTTE4oxXPKxcdHA7y7bEhBtkaYEZJSnYRn1tPMgKKKv3C8eJzjQKl
         sDjoS7/LiFODk+vk7n0DbIFIPDDEnHQq1MXS0=
From: Neil Munro <neilmunro@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Niadh <neilmunro@gmail.com>
Subject: [PATCH 229/229] Staging: Rt2860: Fixed all but one error in mlme.h.
Date: Mon, 17 May 2010 12:44:26 +0100
Message-Id: <1274096666-3282-1-git-send-email-neilmunro@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Niadh <neilmunro@gmail.com>

Fixed all but error in mlme.h, I don't know how to fix the remaining error. It complains about parenthesis and do-while loops, maybe someone else can fix that?

Signed-off-by: Neil Munro <neilmunro@gmail.com>
---
 drivers/staging/rt2860/mlme.h |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rt2860/mlme.h b/drivers/staging/rt2860/mlme.h
index 1143413..63cada3 100644
--- a/drivers/staging/rt2860/mlme.h
+++ b/drivers/staging/rt2860/mlme.h
@@ -60,7 +60,7 @@
 #define JAP_W56	4
 #define MAX_RD_REGION 5
 
-#define BEACON_LOST_TIME            4 * OS_HZ	/* 2048 msec = 2 sec */
+#define BEACON_LOST_TIME            { 4 * OS_HZ }	/* 2048 msec = 2 sec */
 
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
+typedef void(*STATE_MACHINE_FUNC) (void *Adaptor, struct rt_mlme_queue_elem * Elem);
 
 struct rt_state_machine {
 	unsigned long Base;
-- 
1.7.1

