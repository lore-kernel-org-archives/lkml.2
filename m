Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686Ab2GFP3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 11:29:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:57629 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757558Ab2GFP2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 11:28:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="167955923"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Lauri Hintsala <lauri.hintsala@bluegiga.com>
Subject: [PATCH 2/6] staging: csr: print MAC addresses via %pM
Date: Fri,  6 Jul 2012 18:28:14 +0300
Message-Id: <1341588498-21689-2-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341588498-21689-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1341588498-21689-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Lauri Hintsala <lauri.hintsala@bluegiga.com>
---
 drivers/staging/csr/sme_mgt.c              |   10 ++--------
 drivers/staging/csr/sme_sys.c              |   29 ++++++++++++----------------
 drivers/staging/csr/sme_wext.c             |   27 ++++++--------------------
 drivers/staging/csr/unifi_pdu_processing.c |    8 ++++++--
 drivers/staging/csr/unifi_priv.h           |   13 -------------
 drivers/staging/csr/unifi_sme.c            |    3 ++-
 6 files changed, 28 insertions(+), 62 deletions(-)

diff --git a/drivers/staging/csr/sme_mgt.c b/drivers/staging/csr/sme_mgt.c
index ab70216..c27c0a7 100644
--- a/drivers/staging/csr/sme_mgt.c
+++ b/drivers/staging/csr/sme_mgt.c
@@ -838,14 +838,8 @@ void CsrWifiSmeMediaStatusIndHandler(void* drvpriv, CsrWifiFsmEvent* msg)
                               (unsigned char *)ind->connectionInfo.assocScanInfoElements,
                               ind->connectionInfo.assocScanInfoElementsLength);
 
-        unifi_trace(priv, UDBG2,
-                    "CsrWifiSmeMediaStatusIndSend: IBSS=%02X:%02X:%02X:%02X:%02X:%02X\n",
-                    ind->connectionInfo.bssid.a[0],
-                    ind->connectionInfo.bssid.a[1],
-                    ind->connectionInfo.bssid.a[2],
-                    ind->connectionInfo.bssid.a[3],
-                    ind->connectionInfo.bssid.a[4],
-                    ind->connectionInfo.bssid.a[5]);
+	unifi_trace(priv, UDBG2, "CsrWifiSmeMediaStatusIndSend: IBSS=%pM\n",
+				 ind->connectionInfo.bssid.a);
 
         sme_mgt_packet_filter_set(priv);
 
diff --git a/drivers/staging/csr/sme_sys.c b/drivers/staging/csr/sme_sys.c
index 283e302..9c3aa74 100644
--- a/drivers/staging/csr/sme_sys.c
+++ b/drivers/staging/csr/sme_sys.c
@@ -527,11 +527,9 @@ configure_data_port(unifi_priv_t *priv,
         controlled_string = "uncontrolled";
     }
 
-    unifi_trace(priv, UDBG2, "port config request %02x:%02x:%02x:%02x:%02x:%02x %s with port_action %d.\n",
-                macAddress->a[0], macAddress->a[1], macAddress->a[2],
-                macAddress->a[3], macAddress->a[4], macAddress->a[5],
-                controlled_string, port_action);
-
+	unifi_trace(priv, UDBG2,
+		"port config request %pM %s with port_action %d.\n",
+		macAddress->a, controlled_string, port_action);
 
     /* If the new configuration has the broadcast MAC address or if we are in infrastructure mode then clear the list first and set port overide mode */
     if ((CSR_WIFI_ROUTER_CTRL_MODE_STA == interfacePriv->interfaceMode ||
@@ -653,10 +651,9 @@ configure_data_port(unifi_priv_t *priv,
             uf_free_pending_rx_packets(priv, queue, *macAddress,interfaceTag);
         }
 
-        unifi_trace(priv, UDBG2, "port config %02x:%02x:%02x:%02x:%02x:%02x with port_action %d.\n",
-                    *(macAddress->a+0), *(macAddress->a+1), *(macAddress->a+2),
-                    *(macAddress->a+3), *(macAddress->a+4), *(macAddress->a+5),
-                    port_action);
+	unifi_trace(priv, UDBG2,
+		"port config %pM with port_action %d.\n",
+		macAddress->a, port_action);
     }
     return 0;
 } /* configure_data_port() */
@@ -2649,11 +2646,9 @@ CsrBool blockack_session_stop(unifi_priv_t *priv,
         return FALSE;
         }
 
-    unifi_warning(priv, "%s: stopping ba_session for peer = %02x:%02x:%02x:%02x:%02x:%02x role = %d tID = %d\n", __FUNCTION__,
-                  macAddress.a[0], macAddress.a[1], macAddress.a[2],
-                  macAddress.a[3], macAddress.a[4], macAddress.a[5],
-                  role,
-                  tID);
+	unifi_warning(priv,
+		"%s: stopping ba_session for peer = %pM role = %d tID = %d\n",
+		__func__, macAddress.a, role, tID);
 
     /* find out the appropriate ba session (/station /tid /role) for which stop is requested */
     if (role == CSR_WIFI_ROUTER_CTRL_BLOCK_ACK_RECIPIENT){
@@ -2781,9 +2776,9 @@ CsrBool blockack_session_start(unifi_priv_t *priv,
         return FALSE;
     }
 
-    unifi_warning(priv, "%s: ba session with peer= (%02x:%02x:%02x:%02x:%02x:%02x)\n", __FUNCTION__,
-                  macAddress.a[0], macAddress.a[1], macAddress.a[2],
-                  macAddress.a[3], macAddress.a[4], macAddress.a[5]);
+	unifi_warning(priv,
+		"%s: ba session with peer= (%pM)\n", __func__,
+		macAddress.a);
 
     unifi_warning(priv, "%s: ba session for tID=%d timeout=%d role=%d wind_size=%d start_sn=%d\n", __FUNCTION__,
                   tID,
diff --git a/drivers/staging/csr/sme_wext.c b/drivers/staging/csr/sme_wext.c
index 3ba7b4c..cdc72db 100644
--- a/drivers/staging/csr/sme_wext.c
+++ b/drivers/staging/csr/sme_wext.c
@@ -1210,13 +1210,8 @@ unifi_siwap(struct net_device *dev, struct iw_request_info *info,
         return -EINVAL;
     }
 
-    unifi_trace(priv, UDBG1, "unifi_siwap: asked for %02X:%02X:%02X:%02X:%02X:%02X\n",
-                (u8)wrqu->ap_addr.sa_data[0],
-                (u8)wrqu->ap_addr.sa_data[1],
-                (u8)wrqu->ap_addr.sa_data[2],
-                (u8)wrqu->ap_addr.sa_data[3],
-                (u8)wrqu->ap_addr.sa_data[4],
-                (u8)wrqu->ap_addr.sa_data[5]);
+	unifi_trace(priv, UDBG1, "unifi_siwap: asked for %pM\n",
+		wrqu->ap_addr.sa_data);
 
     if (!memcmp(wrqu->ap_addr.sa_data, zero_bssid, ETH_ALEN)) {
         priv->ignore_bssid_join = FALSE;
@@ -1281,10 +1276,7 @@ unifi_giwap(struct net_device *dev, struct iw_request_info *info,
     if (r == 0) {
         bssid = connectionInfo.bssid.a;
         wrqu->ap_addr.sa_family = ARPHRD_ETHER;
-        unifi_trace(priv, UDBG4,
-                    "unifi_giwap: BSSID = %02X:%02X:%02X:%02X:%02X:%02X\n",
-                    bssid[0], bssid[1], bssid[2],
-                    bssid[3], bssid[4], bssid[5]);
+		unifi_trace(priv, UDBG4, "unifi_giwap: BSSID = %pM\n", bssid);
 
         memcpy(wrqu->ap_addr.sa_data, bssid, ETH_ALEN);
     } else {
@@ -2936,8 +2928,7 @@ _unifi_siwencodeext(struct net_device *dev, struct iw_request_info *info,
     unifi_trace(priv, UDBG1, "siwencodeext: flags=0x%X, alg=%d, ext_flags=0x%X, len=%d, index=%d,\n",
                 wrqu->encoding.flags, ext->alg, ext->ext_flags,
                 ext->key_len, (wrqu->encoding.flags & IW_ENCODE_INDEX));
-    unifi_trace(priv, UDBG3, "              addr=%02X:%02X:%02X:%02X:%02X:%02X\n",
-                a[0], a[1], a[2], a[3], a[4], a[5]);
+	unifi_trace(priv, UDBG3, "              addr=%pM\n", a);
 
     if ((ext->key_len == 0) && (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY)) {
         /* This means use a different key (given by key_idx) for Tx. */
@@ -3140,14 +3131,8 @@ unifi_siwpmksa(struct net_device *dev, struct iw_request_info *info,
     }
 
 
-    unifi_trace(priv, UDBG1, "SIWPMKSA: cmd %d, %02x:%02x:%02x:%02x:%02x:%02x\n",
-                pmksa->cmd,
-                pmksa->bssid.sa_data[0],
-                pmksa->bssid.sa_data[1],
-                pmksa->bssid.sa_data[2],
-                pmksa->bssid.sa_data[3],
-                pmksa->bssid.sa_data[4],
-                pmksa->bssid.sa_data[5]);
+	unifi_trace(priv, UDBG1, "SIWPMKSA: cmd %d, %pM\n", pmksa->cmd,
+		pmksa->bssid.sa_data);
 
     pmkid_list.pmkids = NULL;
     switch (pmksa->cmd) {
diff --git a/drivers/staging/csr/unifi_pdu_processing.c b/drivers/staging/csr/unifi_pdu_processing.c
index e35747c..45c69a9 100644
--- a/drivers/staging/csr/unifi_pdu_processing.c
+++ b/drivers/staging/csr/unifi_pdu_processing.c
@@ -68,7 +68,9 @@ unifi_frame_ma_packet_req(unifi_priv_t *priv, CSR_PRIORITY priority,
 
     interfacePriv = priv->interfacePriv[interfaceTag];
 
-    UF_TRACE_MAC(priv, UDBG5, "In unifi_frame_ma_packet_req, Frame for Peer:", peerMacAddress);
+	unifi_trace(priv, UDBG5,
+		"In unifi_frame_ma_packet_req, Frame for Peer: %pMF\n",
+		peerMacAddress);
     signal->SignalPrimitiveHeader.SignalId = CSR_MA_PACKET_REQUEST_ID;
     signal->SignalPrimitiveHeader.ReceiverProcessId = 0;
     signal->SignalPrimitiveHeader.SenderProcessId = leSenderProcessId;
@@ -1668,7 +1670,9 @@ CsrResult uf_process_ma_packet_req(unifi_priv_t *priv,
     CsrUint32 handle = 0xFFFFFFFF;
     unsigned long lock_flags;
 
-    UF_TRACE_MAC(priv, UDBG5, "entering uf_process_ma_packet_req, peer: ", peerMacAddress);
+	unifi_trace(priv, UDBG5,
+		"entering uf_process_ma_packet_req, peer: %pMF\n",
+		peerMacAddress);
 
     if (interfaceTag >= CSR_WIFI_NUM_INTERFACES) {
         unifi_error(priv, "interfaceTag >= CSR_WIFI_NUM_INTERFACES, interfacetag = %d\n", interfaceTag);
diff --git a/drivers/staging/csr/unifi_priv.h b/drivers/staging/csr/unifi_priv.h
index b23c844..7e940ef 100644
--- a/drivers/staging/csr/unifi_priv.h
+++ b/drivers/staging/csr/unifi_priv.h
@@ -1174,17 +1174,4 @@ int unifi_putest_gp_write16(unifi_priv_t *priv, unsigned char *arg);
 int unifi_putest_dl_fw(unifi_priv_t *priv, unsigned char *arg);
 int unifi_putest_dl_fw_buff(unifi_priv_t *priv, unsigned char *arg);
 
-
-/* Macro for formatting a MAC address with a prefix string */
-#define UF_TRACE_MAC(priv, lvl, msg, addr) \
-        unifi_trace(priv, lvl, \
-                                "%s %02x-%02x-%02x-%02x-%02x-%02x\n", \
-                                msg,    \
-                                *(((CsrUint8 *)addr)+0),  \
-                                *(((CsrUint8 *)addr)+1),  \
-                                *(((CsrUint8 *)addr)+2),  \
-                                *(((CsrUint8 *)addr)+3),  \
-                                *(((CsrUint8 *)addr)+4),  \
-                                *(((CsrUint8 *)addr)+5))
-
 #endif /* __LINUX_UNIFI_PRIV_H__ */
diff --git a/drivers/staging/csr/unifi_sme.c b/drivers/staging/csr/unifi_sme.c
index 54414ed..6e7cbbf 100644
--- a/drivers/staging/csr/unifi_sme.c
+++ b/drivers/staging/csr/unifi_sme.c
@@ -1174,7 +1174,8 @@ uf_send_m4_ready_wq(struct work_struct *work)
     /* Send a signal to SME */
     CsrWifiRouterCtrlM4ReadyToSendIndSend(priv->CSR_WIFI_SME_IFACEQUEUE, 0, iface, peer);
 
-    UF_TRACE_MAC(priv, UDBG1, "M4ReadyToSendInd sent for peer", peer.a);
+	unifi_trace(priv, UDBG1, "M4ReadyToSendInd sent for peer %pMF\n",
+		peer.a);
 
     func_exit();
 
-- 
1.7.10.4

