Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab2J0Oxn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 10:53:43 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53836 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436Ab2J0Oxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 10:53:41 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] staging: csr: Fix typo in csr/netdev.c
Date: Sat, 27 Oct 2012 23:53:36 +0900
Message-Id: <1351349616-22974-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.0.rc3.16.g8ead1bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in trace message.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/csr/netdev.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/csr/netdev.c b/drivers/staging/csr/netdev.c
index 0e34020..878c3df 100644
--- a/drivers/staging/csr/netdev.c
+++ b/drivers/staging/csr/netdev.c
@@ -100,7 +100,7 @@
 #endif /* LINUX_VERSION_CODE */
 
 
-/* Wext handler is suported only if CSR_SUPPORT_WEXT is defined */
+/* Wext handler is supported only if CSR_SUPPORT_WEXT is defined */
 #ifdef CSR_SUPPORT_WEXT
 extern struct iw_handler_def unifi_iw_handler_def;
 #endif /* CSR_SUPPORT_WEXT */
@@ -146,7 +146,7 @@ typedef int (*tx_signal_handler)(unifi_priv_t *priv, struct sk_buff *skb, const
 /*
  * The driver uses the qdisc interface to buffer and control all
  * outgoing traffic. We create a root qdisc, register our qdisc operations
- * and later we create two subsiduary pfifo queues for the uncontrolled
+ * and later we create two subsidiary pfifo queues for the uncontrolled
  * and controlled ports.
  *
  * The network stack delivers all outgoing packets in our enqueue handler.
@@ -1748,7 +1748,7 @@ send_ma_pkt_request(unifi_priv_t *priv, struct sk_buff *skb, const struct ethhdr
         return -1;
     }
 
-    /* RA adrress must contain the immediate destination MAC address that is similiar to
+    /* RA adrress must contain the immediate destination MAC address that is similar to
      * the Address 1 field of 802.11 Mac header here 4 is: (sizeof(framecontrol) + sizeof (durationID))
      * which is address 1 field
      */
@@ -2782,7 +2782,7 @@ static void process_ma_packet_ind(unifi_priv_t *priv, CSR_SIGNAL *signal, bulk_d
         return;
     }
     /* For monitor mode we need to pass this indication to the registered application
-    handle this seperately*/
+    handle this separately*/
     /* MIC failure is already taken care of so no need to send the PDUs which are not successfully received in non-monitor mode*/
     if(pkt_ind->ReceptionStatus != CSR_RX_SUCCESS)
     {
@@ -3717,13 +3717,13 @@ static void update_expected_sn(unifi_priv_t *priv,
     u16 gap;
 
     gap = (sn - ba_session->expected_sn) & 0xFFF;
-    unifi_trace(priv, UDBG6, "%s: proccess the frames up to new_expected_sn = %d gap = %d\n", __FUNCTION__, sn, gap);
+    unifi_trace(priv, UDBG6, "%s: process the frames up to new_expected_sn = %d gap = %d\n", __FUNCTION__, sn, gap);
     for(j = 0; j < gap && j < ba_session->wind_size; j++) {
         i = SN_TO_INDEX(ba_session, ba_session->expected_sn);
-        unifi_trace(priv, UDBG6, "%s: proccess the slot index = %d\n", __FUNCTION__, i);
+        unifi_trace(priv, UDBG6, "%s: process the slot index = %d\n", __FUNCTION__, i);
         if(ba_session->buffer[i].active) {
             add_frame_to_ba_complete(priv, interfacePriv, &ba_session->buffer[i]);
-            unifi_trace(priv, UDBG6, "%s: proccess the frame at index = %d expected_sn = %d\n", __FUNCTION__, i, ba_session->expected_sn);
+            unifi_trace(priv, UDBG6, "%s: process the frame at index = %d expected_sn = %d\n", __FUNCTION__, i, ba_session->expected_sn);
             FREE_BUFFER_SLOT(ba_session, i);
         } else {
             unifi_trace(priv, UDBG6, "%s: empty slot at index = %d\n", __FUNCTION__, i);
-- 
1.8.0.rc3.16.g8ead1bf

