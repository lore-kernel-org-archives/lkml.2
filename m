Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab2LJXXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 18:23:17 -0500
Received: from wren.arvixe.com ([50.97.138.99]:55114 "EHLO wren.arvixe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533Ab2LJXWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 18:22:35 -0500
From: Przemo Firszt <przemo@firszt.eu>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 6/9] rtl8712: remove all NDIS_* definitions and use rndis.h instead
Date: Mon, 10 Dec 2012 23:21:24 +0000
Message-Id: <1355181685-4444-6-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1355181685-4444-1-git-send-email-przemo@firszt.eu>
References: <1355181685-4444-1-git-send-email-przemo@firszt.eu>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - wren.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
X-Get-Message-Sender-Via: wren.arvixe.com: authenticated_id: przemo@firszt.eu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove duplicate code.The definitions are already in
include/linux/rndis.h

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/staging/rtl8712/rtl871x_ioctl_rtl.c | 181 ++++++-------
 drivers/staging/rtl8712/rtl871x_mp.h        |  56 ----
 drivers/staging/rtl8712/rtl871x_mp_ioctl.c  | 393 ++++++++++++++--------------
 3 files changed, 288 insertions(+), 342 deletions(-)

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_rtl.c b/drivers/staging/rtl8712/rtl871x_ioctl_rtl.c
index 9a33eae..5d6d55e 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_rtl.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_rtl.c
@@ -28,6 +28,7 @@
 
 #define  _RTL871X_IOCTL_RTL_C_
 
+#include <linux/rndis.h>
 #include "osdep_service.h"
 #include "drv_types.h"
 #include "wlan_bssdef.h"
@@ -42,8 +43,8 @@
 uint oid_rt_get_signal_quality_hdl(struct oid_par_priv *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_small_packet_crc_hdl(struct oid_par_priv *poid_par_priv)
@@ -52,14 +53,14 @@ uint oid_rt_get_small_packet_crc_hdl(struct oid_par_priv *poid_par_priv)
 				    (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len >=  sizeof(u32)) {
 		*(u32 *)poid_par_priv->information_buf =
 				padapter->recvpriv.rx_smallpacket_crcerr;
 		*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
 	} else
-		return NDIS_STATUS_INVALID_LENGTH;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_INVALID_LENGTH;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_middle_packet_crc_hdl(struct oid_par_priv *poid_par_priv)
@@ -68,14 +69,14 @@ uint oid_rt_get_middle_packet_crc_hdl(struct oid_par_priv *poid_par_priv)
 				    (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len >=  sizeof(u32)) {
 		*(u32 *)poid_par_priv->information_buf =
 				padapter->recvpriv.rx_middlepacket_crcerr;
 		*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
 	} else
-		return NDIS_STATUS_INVALID_LENGTH;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_INVALID_LENGTH;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_large_packet_crc_hdl(struct oid_par_priv *poid_par_priv)
@@ -84,29 +85,29 @@ uint oid_rt_get_large_packet_crc_hdl(struct oid_par_priv *poid_par_priv)
 				    (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len >=  sizeof(u32)) {
 		*(u32 *)poid_par_priv->information_buf =
 				 padapter->recvpriv.rx_largepacket_crcerr;
 		*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
 	} else
-		return NDIS_STATUS_INVALID_LENGTH;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_INVALID_LENGTH;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_tx_retry_hdl(struct oid_par_priv *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_rx_retry_hdl(struct oid_par_priv *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_rx_total_packet_hdl(struct oid_par_priv *poid_par_priv)
@@ -115,29 +116,29 @@ uint oid_rt_get_rx_total_packet_hdl(struct oid_par_priv *poid_par_priv)
 				    (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len >=  sizeof(u32)) {
 		*(u32 *)poid_par_priv->information_buf =
 					 padapter->recvpriv.rx_pkts +
 					 padapter->recvpriv.rx_drop;
 		*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
 	} else
-		return NDIS_STATUS_INVALID_LENGTH;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_INVALID_LENGTH;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_tx_beacon_ok_hdl(struct oid_par_priv *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_tx_beacon_err_hdl(struct oid_par_priv *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_rx_icv_err_hdl(struct oid_par_priv *poid_par_priv)
@@ -146,22 +147,22 @@ uint oid_rt_get_rx_icv_err_hdl(struct oid_par_priv *poid_par_priv)
 				    (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len >= sizeof(u32)) {
 		*(uint *)poid_par_priv->information_buf =
 					 padapter->recvpriv.rx_icv_err;
 		*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
 	} else
-		return NDIS_STATUS_INVALID_LENGTH ;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_INVALID_LENGTH ;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_set_encryption_algorithm_hdl(struct oid_par_priv
 						*poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_preamble_mode_hdl(struct oid_par_priv *poid_par_priv)
@@ -171,7 +172,7 @@ uint oid_rt_get_preamble_mode_hdl(struct oid_par_priv *poid_par_priv)
 	u32 preamblemode = 0 ;
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len >= sizeof(u32)) {
 		if (padapter->registrypriv.preamble == PREAMBLE_LONG)
 			preamblemode = 0;
@@ -182,15 +183,15 @@ uint oid_rt_get_preamble_mode_hdl(struct oid_par_priv *poid_par_priv)
 		*(u32 *)poid_par_priv->information_buf = preamblemode;
 		*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
 	} else
-		return NDIS_STATUS_INVALID_LENGTH;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_INVALID_LENGTH;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_ap_ip_hdl(struct oid_par_priv *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_channelplan_hdl(struct oid_par_priv *poid_par_priv)
@@ -200,10 +201,10 @@ uint oid_rt_get_channelplan_hdl(struct oid_par_priv *poid_par_priv)
 	struct eeprom_priv *peeprompriv = &padapter->eeprompriv;
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
 	*(u16 *)poid_par_priv->information_buf = peeprompriv->channel_plan;
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_set_channelplan_hdl(struct oid_par_priv
@@ -214,9 +215,9 @@ uint oid_rt_set_channelplan_hdl(struct oid_par_priv
 	struct eeprom_priv *peeprompriv = &padapter->eeprompriv;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	peeprompriv->channel_plan = *(u16 *)poid_par_priv->information_buf;
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_set_preamble_mode_hdl(struct oid_par_priv
@@ -227,7 +228,7 @@ uint oid_rt_set_preamble_mode_hdl(struct oid_par_priv
 	u32 preamblemode = 0;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len >= sizeof(u32)) {
 		preamblemode = *(u32 *)poid_par_priv->information_buf;
 		if (preamblemode == 0)
@@ -239,21 +240,21 @@ uint oid_rt_set_preamble_mode_hdl(struct oid_par_priv
 		*(u32 *)poid_par_priv->information_buf = preamblemode;
 		*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
 	} else
-		return NDIS_STATUS_INVALID_LENGTH;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_INVALID_LENGTH;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_set_bcn_intvl_hdl(struct oid_par_priv *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_dedicate_probe_hdl(struct oid_par_priv
 				      *poid_par_priv)
 {
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_total_tx_bytes_hdl(struct oid_par_priv
@@ -263,14 +264,14 @@ uint oid_rt_get_total_tx_bytes_hdl(struct oid_par_priv
 				    (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len >= sizeof(u32)) {
 		*(u32 *)poid_par_priv->information_buf =
 						 padapter->xmitpriv.tx_bytes;
 		*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
 	} else
-		return NDIS_STATUS_INVALID_LENGTH;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_INVALID_LENGTH;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_total_rx_bytes_hdl(struct oid_par_priv
@@ -280,37 +281,37 @@ uint oid_rt_get_total_rx_bytes_hdl(struct oid_par_priv
 				    (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len >= sizeof(u32)) {
 		*(u32 *)poid_par_priv->information_buf =
 					   padapter->recvpriv.rx_bytes;
 		*poid_par_priv->bytes_rw = poid_par_priv->
 					   information_buf_len;
 	} else
-		return NDIS_STATUS_INVALID_LENGTH;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_INVALID_LENGTH;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_current_tx_power_level_hdl(struct oid_par_priv
 					      *poid_par_priv)
 {
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_enc_key_mismatch_count_hdl(struct oid_par_priv
 						  *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_enc_key_match_count_hdl(struct oid_par_priv
 					       *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_channel_hdl(struct oid_par_priv *poid_par_priv)
@@ -322,7 +323,7 @@ uint oid_rt_get_channel_hdl(struct oid_par_priv *poid_par_priv)
 	u32   channelnum;
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if ((check_fwstate(pmlmepriv, _FW_LINKED) == true) ||
 	    (check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE) == true))
 		pnic_Config = &pmlmepriv->cur_network.network.Configuration;
@@ -332,22 +333,22 @@ uint oid_rt_get_channel_hdl(struct oid_par_priv *poid_par_priv)
 	channelnum = pnic_Config->DSConfig;
 	*(u32 *)poid_par_priv->information_buf = channelnum;
 	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_hardware_radio_off_hdl(struct oid_par_priv
 			 *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_key_mismatch_hdl(struct oid_par_priv *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_supported_wireless_mode_hdl(struct oid_par_priv
@@ -356,7 +357,7 @@ uint oid_rt_supported_wireless_mode_hdl(struct oid_par_priv
 	u32 ulInfo = 0;
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len >= sizeof(u32)) {
 		ulInfo |= 0x0100; /* WIRELESS_MODE_B */
 		ulInfo |= 0x0200; /* WIRELESS_MODE_G */
@@ -364,108 +365,108 @@ uint oid_rt_supported_wireless_mode_hdl(struct oid_par_priv
 		*(u32 *) poid_par_priv->information_buf = ulInfo;
 		*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
 	} else
-		return NDIS_STATUS_INVALID_LENGTH;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_INVALID_LENGTH;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_channel_list_hdl(struct oid_par_priv *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_scan_in_progress_hdl(struct oid_par_priv *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 
 uint oid_rt_forced_data_rate_hdl(struct oid_par_priv *poid_par_priv)
 {
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_wireless_mode_for_scan_list_hdl(struct oid_par_priv
 						   *poid_par_priv)
 {
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_bss_wireless_mode_hdl(struct oid_par_priv
 					     *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_scan_with_magic_packet_hdl(struct oid_par_priv
 					      *poid_par_priv)
 {
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_ap_get_associated_station_list_hdl(struct oid_par_priv
 						      *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_ap_switch_into_ap_mode_hdl(struct oid_par_priv*
 					      poid_par_priv)
 {
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_ap_supported_hdl(struct oid_par_priv *poid_par_priv)
 {
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_ap_set_passphrase_hdl(struct oid_par_priv *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro_rf_write_registry_hdl(struct oid_par_priv*
 					     poid_par_priv)
 {
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	struct _adapter *Adapter = (struct _adapter *)
 			(poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != SET_OID) /* QUERY_OID */
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len ==
 	   (sizeof(unsigned long) * 3)) {
 		if (!r8712_setrfreg_cmd(Adapter,
 			*(unsigned char *)poid_par_priv->information_buf,
 			(unsigned long)(*((unsigned long *)
 					poid_par_priv->information_buf + 2))))
-			status = NDIS_STATUS_NOT_ACCEPTED;
+			status = RNDIS_STATUS_NOT_ACCEPTED;
 	} else
-		status = NDIS_STATUS_INVALID_LENGTH;
+		status = RNDIS_STATUS_INVALID_LENGTH;
 	return status;
 }
 
 uint oid_rt_pro_rf_read_registry_hdl(struct oid_par_priv *poid_par_priv)
 {
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	struct _adapter *Adapter = (struct _adapter *)
 			(poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != SET_OID) /* QUERY_OID */
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len == (sizeof(unsigned long)*3)) {
 		if (Adapter->mppriv.act_in_progress == true)
-			status = NDIS_STATUS_NOT_ACCEPTED;
+			status = RNDIS_STATUS_NOT_ACCEPTED;
 		else {
 			/* init workparam */
 			Adapter->mppriv.act_in_progress = true;
@@ -486,10 +487,10 @@ uint oid_rt_pro_rf_read_registry_hdl(struct oid_par_priv *poid_par_priv)
 			    *(unsigned char *)poid_par_priv->information_buf,
 			    (unsigned char *)&Adapter->mppriv.workparam.
 			    io_value))
-				status = NDIS_STATUS_NOT_ACCEPTED;
+				status = RNDIS_STATUS_NOT_ACCEPTED;
 		}
 	} else
-		status = NDIS_STATUS_INVALID_LENGTH;
+		status = RNDIS_STATUS_INVALID_LENGTH;
 	return status;
 }
 
@@ -508,7 +509,7 @@ uint oid_rt_get_connect_state_hdl(struct oid_par_priv *poid_par_priv)
 	u32 ulInfo;
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	/* nStatus==0	CheckingStatus
 	 * nStatus==1	Associated
 	 * nStatus==2	AdHocMode
@@ -524,12 +525,12 @@ uint oid_rt_get_connect_state_hdl(struct oid_par_priv *poid_par_priv)
 		ulInfo = NOTASSOCIATED ;
 	*(u32 *)poid_par_priv->information_buf = ulInfo;
 	*poid_par_priv->bytes_rw =  poid_par_priv->information_buf_len;
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_set_default_key_id_hdl(struct oid_par_priv *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
diff --git a/drivers/staging/rtl8712/rtl871x_mp.h b/drivers/staging/rtl8712/rtl871x_mp.h
index 255dc94..51395d1 100644
--- a/drivers/staging/rtl8712/rtl871x_mp.h
+++ b/drivers/staging/rtl8712/rtl871x_mp.h
@@ -26,62 +26,6 @@
 #ifndef __RTL871X_MP_H_
 #define __RTL871X_MP_H_
 
-/*	00 - Success */
-/*	11 - Error */
-#define STATUS_SUCCESS			(0x00000000L)
-#define STATUS_PENDING			(0x00000103L)
-#define STATUS_UNSUCCESSFUL		(0xC0000001L)
-#define STATUS_INSUFFICIENT_RESOURCES	(0xC000009AL)
-#define STATUS_NOT_SUPPORTED		(0xC00000BBL)
-#define NDIS_STATUS_SUCCESS		((uint)STATUS_SUCCESS)
-#define NDIS_STATUS_PENDING		((uint) STATUS_PENDING)
-#define NDIS_STATUS_NOT_RECOGNIZED	((uint)0x00010001L)
-#define NDIS_STATUS_NOT_COPIED		((uint)0x00010002L)
-#define NDIS_STATUS_NOT_ACCEPTED	((uint)0x00010003L)
-#define NDIS_STATUS_CALL_ACTIVE		((uint)0x00010007L)
-#define NDIS_STATUS_FAILURE		((uint) STATUS_UNSUCCESSFUL)
-#define NDIS_STATUS_RESOURCES		((uint)\
-					STATUS_INSUFFICIENT_RESOURCES)
-#define NDIS_STATUS_CLOSING		((uint)0xC0010002L)
-#define NDIS_STATUS_BAD_VERSION		((uint)0xC0010004L)
-#define NDIS_STATUS_BAD_CHARACTERISTICS	((uint)0xC0010005L)
-#define NDIS_STATUS_ADAPTER_NOT_FOUND	((uint)0xC0010006L)
-#define NDIS_STATUS_OPEN_FAILED		((uint)0xC0010007L)
-#define NDIS_STATUS_DEVICE_FAILED	((uint)0xC0010008L)
-#define NDIS_STATUS_MULTICAST_FULL	((uint)0xC0010009L)
-#define NDIS_STATUS_MULTICAST_EXISTS	((uint)0xC001000AL)
-#define NDIS_STATUS_MULTICAST_NOT_FOUND	((uint)0xC001000BL)
-#define NDIS_STATUS_REQUEST_ABORTED	((uint)0xC001000CL)
-#define NDIS_STATUS_RESET_IN_PROGRESS	((uint)0xC001000DL)
-#define NDIS_STATUS_CLOSING_INDICATING	((uint)0xC001000EL)
-#define NDIS_STATUS_NOT_SUPPORTED	((uint)STATUS_NOT_SUPPORTED)
-#define NDIS_STATUS_INVALID_PACKET	((uint)0xC001000FL)
-#define NDIS_STATUS_OPEN_LIST_FULL	((uint)0xC0010010L)
-#define NDIS_STATUS_ADAPTER_NOT_READY	((uint)0xC0010011L)
-#define NDIS_STATUS_ADAPTER_NOT_OPEN	((uint)0xC0010012L)
-#define NDIS_STATUS_NOT_INDICATING	((uint)0xC0010013L)
-#define NDIS_STATUS_INVALID_LENGTH	((uint)0xC0010014L)
-#define NDIS_STATUS_INVALID_DATA	((uint)0xC0010015L)
-#define NDIS_STATUS_BUFFER_TOO_SHORT	((uint)0xC0010016L)
-#define NDIS_STATUS_INVALID_OID		((uint)0xC0010017L)
-#define NDIS_STATUS_ADAPTER_REMOVED	((uint)0xC0010018L)
-#define NDIS_STATUS_UNSUPPORTED_MEDIA	((uint)0xC0010019L)
-#define NDIS_STATUS_GROUP_ADDRESS_IN_USE ((uint)0xC001001AL)
-#define NDIS_STATUS_FILE_NOT_FOUND	((uint)0xC001001BL)
-#define NDIS_STATUS_ERROR_READING_FILE	((uint)0xC001001CL)
-#define NDIS_STATUS_ALREADY_MAPPED	((uint)0xC001001DL)
-#define NDIS_STATUS_RESOURCE_CONFLICT	((uint)0xC001001EL)
-#define NDIS_STATUS_NO_CABLE		((uint)0xC001001FL)
-#define NDIS_STATUS_INVALID_SAP		((uint)0xC0010020L)
-#define NDIS_STATUS_SAP_IN_USE		((uint)0xC0010021L)
-#define NDIS_STATUS_INVALID_ADDRESS	((uint)0xC0010022L)
-#define NDIS_STATUS_VC_NOT_ACTIVATED	((uint)0xC0010023L)
-#define NDIS_STATUS_DEST_OUT_OF_ORDER	((uint)0xC0010024L) /* cause 27*/
-#define NDIS_STATUS_VC_NOT_AVAILABLE	((uint)0xC0010025L) /* 35,45*/
-#define NDIS_STATUS_CELLRATE_NOT_AVAILABLE ((uint)0xC0010026L) /* 37*/
-#define NDIS_STATUS_INCOMPATABLE_QOS	((uint)0xC0010027L)  /* 49*/
-#define NDIS_STATUS_AAL_PARAMS_UNSUPPORTED ((uint)0xC0010028L)  /*  93*/
-#define NDIS_STATUS_NO_ROUTE_TO_DESTINATION ((uint)0xC0010029L)  /*  3*/
 #define MPT_NOOP			0
 #define MPT_READ_MAC_1BYTE		1
 #define MPT_READ_MAC_2BYTE		2
diff --git a/drivers/staging/rtl8712/rtl871x_mp_ioctl.c b/drivers/staging/rtl8712/rtl871x_mp_ioctl.c
index 5eb461b..5bd4296 100644
--- a/drivers/staging/rtl8712/rtl871x_mp_ioctl.c
+++ b/drivers/staging/rtl8712/rtl871x_mp_ioctl.c
@@ -26,6 +26,7 @@
  *
  ******************************************************************************/
 
+#include <linux/rndis.h>
 #include "osdep_service.h"
 #include "drv_types.h"
 #include "mlme_osdep.h"
@@ -34,12 +35,12 @@
 
 uint oid_null_function(struct oid_par_priv *poid_par_priv)
 {
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_wireless_mode_hdl(struct oid_par_priv *poid_par_priv)
 {
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
 
@@ -48,7 +49,7 @@ uint oid_rt_wireless_mode_hdl(struct oid_par_priv *poid_par_priv)
 			Adapter->registrypriv.wireless_mode =
 					*(u8 *)poid_par_priv->information_buf;
 		else
-			status = NDIS_STATUS_INVALID_LENGTH;
+			status = RNDIS_STATUS_INVALID_LENGTH;
 	} else if (poid_par_priv->type_of_oid == QUERY_OID) {
 		if (poid_par_priv->information_buf_len >= sizeof(u8)) {
 			*(u8 *)poid_par_priv->information_buf =
@@ -56,16 +57,16 @@ uint oid_rt_wireless_mode_hdl(struct oid_par_priv *poid_par_priv)
 			*poid_par_priv->bytes_rw =
 					poid_par_priv->information_buf_len;
 		} else
-			status = NDIS_STATUS_INVALID_LENGTH;
+			status = RNDIS_STATUS_INVALID_LENGTH;
 	} else {
-		status = NDIS_STATUS_NOT_ACCEPTED;
+		status = RNDIS_STATUS_NOT_ACCEPTED;
 	}
 	return status;
 }
 
 uint oid_rt_pro_write_bb_reg_hdl(struct oid_par_priv *poid_par_priv)
 {
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
 	struct bb_reg_param *pbbreg;
@@ -73,9 +74,9 @@ uint oid_rt_pro_write_bb_reg_hdl(struct oid_par_priv *poid_par_priv)
 	u32 value;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len < sizeof(struct bb_reg_param))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	pbbreg = (struct bb_reg_param *)(poid_par_priv->information_buf);
 	offset = (u16)(pbbreg->offset) & 0xFFF; /*0ffset :0x800~0xfff*/
 	if (offset < BB_REG_BASE_ADDR)
@@ -87,7 +88,7 @@ uint oid_rt_pro_write_bb_reg_hdl(struct oid_par_priv *poid_par_priv)
 
 uint oid_rt_pro_read_bb_reg_hdl(struct oid_par_priv *poid_par_priv)
 {
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
 	struct bb_reg_param *pbbreg;
@@ -95,9 +96,9 @@ uint oid_rt_pro_read_bb_reg_hdl(struct oid_par_priv *poid_par_priv)
 	u32 value;
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len < sizeof(struct bb_reg_param))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	pbbreg = (struct bb_reg_param *)(poid_par_priv->information_buf);
 	offset = (u16)(pbbreg->offset) & 0xFFF; /*0ffset :0x800~0xfff*/
 	if (offset < BB_REG_BASE_ADDR)
@@ -110,7 +111,7 @@ uint oid_rt_pro_read_bb_reg_hdl(struct oid_par_priv *poid_par_priv)
 
 uint oid_rt_pro_write_rf_reg_hdl(struct oid_par_priv *poid_par_priv)
 {
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
 	struct rf_reg_param *pbbreg;
@@ -119,13 +120,13 @@ uint oid_rt_pro_write_rf_reg_hdl(struct oid_par_priv *poid_par_priv)
 	u32 value;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len < sizeof(struct rf_reg_param))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	pbbreg = (struct rf_reg_param *)(poid_par_priv->information_buf);
 	path = (u8)pbbreg->path;
 	if (path > RF_PATH_B)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	offset = (u8)pbbreg->offset;
 	value = pbbreg->value;
 	r8712_rf_reg_write(Adapter, path, offset, value);
@@ -136,20 +137,20 @@ uint oid_rt_pro_read_rf_reg_hdl(struct oid_par_priv *poid_par_priv)
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	struct rf_reg_param *pbbreg;
 	u8 path;
 	u8 offset;
 	u32 value;
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len < sizeof(struct rf_reg_param))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	pbbreg = (struct rf_reg_param *)(poid_par_priv->information_buf);
 	path = (u8)pbbreg->path;
 	if (path > RF_PATH_B) /* 1T2R  path_a /path_b */
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	offset = (u8)pbbreg->offset;
 	value = r8712_rf_reg_read(Adapter, path, offset);
 	pbbreg->value = value;
@@ -265,16 +266,16 @@ uint oid_rt_pro_set_data_rate_hdl(struct oid_par_priv
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	u32 ratevalue;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len != sizeof(u32))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	ratevalue = *((u32 *)poid_par_priv->information_buf);
 	if (ratevalue >= MPT_RATE_LAST)
-		return NDIS_STATUS_INVALID_DATA;
+		return RNDIS_STATUS_INVALID_DATA;
 	Adapter->mppriv.curr_rateidx = ratevalue;
 	r8712_SetDataRate(Adapter);
 	return status;
@@ -284,16 +285,16 @@ uint oid_rt_pro_start_test_hdl(struct oid_par_priv *poid_par_priv)
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	u32 mode;
 	u8 val8;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return  NDIS_STATUS_NOT_ACCEPTED;
+		return  RNDIS_STATUS_NOT_ACCEPTED;
 	mode = *((u32 *)poid_par_priv->information_buf);
 	Adapter->mppriv.mode = mode;/* 1 for loopback*/
 	if (mp_start_test(Adapter) == _FAIL)
-		status = NDIS_STATUS_NOT_ACCEPTED;
+		status = RNDIS_STATUS_NOT_ACCEPTED;
 	r8712_write8(Adapter, MSR, 1); /* Link in ad hoc network, 0x1025004C */
 	r8712_write8(Adapter, RCR, 0); /* RCR : disable all pkt, 0x10250048 */
 	/* RCR disable Check BSSID, 0x1025004a */
@@ -313,12 +314,12 @@ uint oid_rt_pro_stop_test_hdl(struct oid_par_priv *poid_par_priv)
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (mp_stop_test(Adapter) == _FAIL)
-		status = NDIS_STATUS_NOT_ACCEPTED;
+		status = RNDIS_STATUS_NOT_ACCEPTED;
 	return status;
 }
 
@@ -327,16 +328,16 @@ uint oid_rt_pro_set_channel_direct_call_hdl(struct oid_par_priv
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	u32		Channel;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len != sizeof(u32))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	Channel = *((u32 *)poid_par_priv->information_buf);
 	if (Channel > 14)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	Adapter->mppriv.curr_ch = Channel;
 	r8712_SetChannel(Adapter);
 	return status;
@@ -346,13 +347,13 @@ uint oid_rt_pro_set_antenna_bb_hdl(struct oid_par_priv *poid_par_priv)
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	u32 antenna;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len != sizeof(u32))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	antenna = *((u32 *)poid_par_priv->information_buf);
 	Adapter->mppriv.antenna_tx = (u16)((antenna & 0xFFFF0000) >> 16);
 	Adapter->mppriv.antenna_rx = (u16)(antenna & 0x0000FFFF);
@@ -365,16 +366,16 @@ uint oid_rt_pro_set_tx_power_control_hdl(
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	u32 tx_pwr_idx;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len != sizeof(u32))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	tx_pwr_idx = *((u32 *)poid_par_priv->information_buf);
 	if (tx_pwr_idx > MAX_TX_PWR_INDEX_N_MODE)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	Adapter->mppriv.curr_txpoweridx = (u8)tx_pwr_idx;
 	r8712_SetTxPower(Adapter);
 	return status;
@@ -383,12 +384,12 @@ uint oid_rt_pro_set_tx_power_control_hdl(
 uint oid_rt_pro_query_tx_packet_sent_hdl(
 					struct oid_par_priv *poid_par_priv)
 {
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != QUERY_OID) {
-		status = NDIS_STATUS_NOT_ACCEPTED;
+		status = RNDIS_STATUS_NOT_ACCEPTED;
 		return status;
 	}
 	if (poid_par_priv->information_buf_len == sizeof(u32)) {
@@ -396,19 +397,19 @@ uint oid_rt_pro_query_tx_packet_sent_hdl(
 					Adapter->mppriv.tx_pktcount;
 		*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
 	} else
-		status = NDIS_STATUS_INVALID_LENGTH;
+		status = RNDIS_STATUS_INVALID_LENGTH;
 	return status;
 }
 
 uint oid_rt_pro_query_rx_packet_received_hdl(
 					struct oid_par_priv *poid_par_priv)
 {
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != QUERY_OID) {
-		status = NDIS_STATUS_NOT_ACCEPTED;
+		status = RNDIS_STATUS_NOT_ACCEPTED;
 		return status;
 	}
 	if (poid_par_priv->information_buf_len == sizeof(u32)) {
@@ -416,19 +417,19 @@ uint oid_rt_pro_query_rx_packet_received_hdl(
 					Adapter->mppriv.rx_pktcount;
 		*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
 	} else
-		status = NDIS_STATUS_INVALID_LENGTH;
+		status = RNDIS_STATUS_INVALID_LENGTH;
 	return status;
 }
 
 uint oid_rt_pro_query_rx_packet_crc32_error_hdl(
 					struct oid_par_priv *poid_par_priv)
 {
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != QUERY_OID) {
-		status = NDIS_STATUS_NOT_ACCEPTED;
+		status = RNDIS_STATUS_NOT_ACCEPTED;
 		return status;
 	}
 	if (poid_par_priv->information_buf_len == sizeof(u32)) {
@@ -436,7 +437,7 @@ uint oid_rt_pro_query_rx_packet_crc32_error_hdl(
 					Adapter->mppriv.rx_crcerrpktcount;
 		*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
 	} else
-		status = NDIS_STATUS_INVALID_LENGTH;
+		status = RNDIS_STATUS_INVALID_LENGTH;
 	return status;
 }
 
@@ -447,25 +448,25 @@ uint oid_rt_pro_reset_tx_packet_sent_hdl(struct oid_par_priv
 				   (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	Adapter->mppriv.tx_pktcount = 0;
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro_reset_rx_packet_received_hdl(struct oid_par_priv
 						    *poid_par_priv)
 {
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len == sizeof(u32)) {
 		Adapter->mppriv.rx_pktcount = 0;
 		Adapter->mppriv.rx_crcerrpktcount = 0;
 	} else
-		status = NDIS_STATUS_INVALID_LENGTH;
+		status = RNDIS_STATUS_INVALID_LENGTH;
 	return status;
 }
 
@@ -476,9 +477,9 @@ uint oid_rt_reset_phy_rx_packet_count_hdl(struct oid_par_priv
 				   (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	r8712_ResetPhyRxPktCount(Adapter);
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_phy_rx_packet_received_hdl(struct oid_par_priv
@@ -488,13 +489,13 @@ uint oid_rt_get_phy_rx_packet_received_hdl(struct oid_par_priv
 				   (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len != sizeof(u32))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	*(u32 *)poid_par_priv->information_buf =
 					 r8712_GetPhyRxPktReceived(Adapter);
 	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_get_phy_rx_packet_crc32_error_hdl(struct oid_par_priv
@@ -504,13 +505,13 @@ uint oid_rt_get_phy_rx_packet_crc32_error_hdl(struct oid_par_priv
 				   (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len != sizeof(u32))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	*(u32 *)poid_par_priv->information_buf =
 					 r8712_GetPhyRxPktCRC32Error(Adapter);
 	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro_set_modulation_hdl(struct oid_par_priv
@@ -520,10 +521,10 @@ uint oid_rt_pro_set_modulation_hdl(struct oid_par_priv
 				   (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 
 	Adapter->mppriv.curr_modem = *((u8 *)poid_par_priv->information_buf);
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro_set_continuous_tx_hdl(struct oid_par_priv
@@ -534,10 +535,10 @@ uint oid_rt_pro_set_continuous_tx_hdl(struct oid_par_priv
 	u32		bStartTest;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	bStartTest = *((u32 *)poid_par_priv->information_buf);
 	r8712_SetContinuousTx(Adapter, (u8)bStartTest);
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro_set_single_carrier_tx_hdl(struct oid_par_priv
@@ -548,10 +549,10 @@ uint oid_rt_pro_set_single_carrier_tx_hdl(struct oid_par_priv
 	u32		bStartTest;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	bStartTest = *((u32 *)poid_par_priv->information_buf);
 	r8712_SetSingleCarrierTx(Adapter, (u8)bStartTest);
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro_set_carrier_suppression_tx_hdl(struct oid_par_priv
@@ -562,10 +563,10 @@ uint oid_rt_pro_set_carrier_suppression_tx_hdl(struct oid_par_priv
 	u32		bStartTest;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	bStartTest = *((u32 *)poid_par_priv->information_buf);
 	r8712_SetCarrierSuppressionTx(Adapter, (u8)bStartTest);
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro_set_single_tone_tx_hdl(struct oid_par_priv
@@ -576,28 +577,28 @@ uint oid_rt_pro_set_single_tone_tx_hdl(struct oid_par_priv
 	u32		bStartTest;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	bStartTest = *((u32 *)poid_par_priv->information_buf);
 	r8712_SetSingleToneTx(Adapter, (u8)bStartTest);
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro8711_join_bss_hdl(struct oid_par_priv *poid_par_priv)
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	struct ndis_802_11_ssid *pssid;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	*poid_par_priv->bytes_needed = (u32)sizeof(struct ndis_802_11_ssid);
 	*poid_par_priv->bytes_rw = 0;
 	if (poid_par_priv->information_buf_len < *poid_par_priv->bytes_needed)
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	pssid = (struct ndis_802_11_ssid *)poid_par_priv->information_buf;
 	if (mp_start_joinbss(Adapter, pssid) == _FAIL)
-		status = NDIS_STATUS_NOT_ACCEPTED;
+		status = RNDIS_STATUS_NOT_ACCEPTED;
 	*poid_par_priv->bytes_rw = sizeof(struct ndis_802_11_ssid);
 	return status;
 }
@@ -607,12 +608,12 @@ uint oid_rt_pro_read_register_hdl(struct oid_par_priv
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	struct mp_rw_reg *RegRWStruct;
 	u16		offset;
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	RegRWStruct = (struct mp_rw_reg *)poid_par_priv->information_buf;
 	if ((RegRWStruct->offset >= 0x10250800) &&
 	    (RegRWStruct->offset <= 0x10250FFF)) {
@@ -635,7 +636,7 @@ uint oid_rt_pro_read_register_hdl(struct oid_par_priv
 						    RegRWStruct->offset);
 			break;
 		default:
-			status = NDIS_STATUS_NOT_ACCEPTED;
+			status = RNDIS_STATUS_NOT_ACCEPTED;
 			break;
 		}
 	}
@@ -647,14 +648,14 @@ uint oid_rt_pro_write_register_hdl(struct oid_par_priv *poid_par_priv)
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	struct mp_rw_reg *RegRWStruct;
 	u16		offset;
 	u32		value;
 	u32 oldValue = 0;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	RegRWStruct = (struct mp_rw_reg *)poid_par_priv->information_buf;
 	if ((RegRWStruct->offset >= 0x10250800) &&
 	    (RegRWStruct->offset <= 0x10250FFF)) {
@@ -691,11 +692,11 @@ uint oid_rt_pro_write_register_hdl(struct oid_par_priv *poid_par_priv)
 				(unsigned int)RegRWStruct->value);
 			break;
 		default:
-			status = NDIS_STATUS_NOT_ACCEPTED;
+			status = RNDIS_STATUS_NOT_ACCEPTED;
 			break;
 		}
 
-		if ((status == NDIS_STATUS_SUCCESS) &&
+		if ((status == RNDIS_STATUS_SUCCESS) &&
 		    (RegRWStruct->offset == HIMR) &&
 		    (RegRWStruct->width == 4))
 			Adapter->ImrContent = RegRWStruct->value;
@@ -711,12 +712,12 @@ uint oid_rt_pro_burst_read_register_hdl(struct oid_par_priv
 	struct burst_rw_reg *pBstRwReg;
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	pBstRwReg = (struct burst_rw_reg *)poid_par_priv->information_buf;
 	r8712_read_mem(Adapter, pBstRwReg->offset, (u32)pBstRwReg->len,
 		 pBstRwReg->Data);
 	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro_burst_write_register_hdl(struct oid_par_priv
@@ -727,16 +728,16 @@ uint oid_rt_pro_burst_write_register_hdl(struct oid_par_priv
 	struct burst_rw_reg *pBstRwReg;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	pBstRwReg = (struct burst_rw_reg *)poid_par_priv->information_buf;
 	r8712_write_mem(Adapter, pBstRwReg->offset, (u32)pBstRwReg->len,
 		  pBstRwReg->Data);
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro_write_txcmd_hdl(struct oid_par_priv *poid_par_priv)
 {
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro_read16_eeprom_hdl(struct oid_par_priv *poid_par_priv)
@@ -746,12 +747,12 @@ uint oid_rt_pro_read16_eeprom_hdl(struct oid_par_priv *poid_par_priv)
 	struct eeprom_rw_param *pEEPROM;
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	pEEPROM = (struct eeprom_rw_param *)poid_par_priv->information_buf;
 	pEEPROM->value = r8712_eeprom_read16(Adapter,
 					     (u16)(pEEPROM->offset >> 1));
 	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro_write16_eeprom_hdl(struct oid_par_priv *poid_par_priv)
@@ -761,12 +762,12 @@ uint oid_rt_pro_write16_eeprom_hdl(struct oid_par_priv *poid_par_priv)
 	struct eeprom_rw_param *pEEPROM;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	pEEPROM = (struct eeprom_rw_param *)poid_par_priv->information_buf;
 	r8712_eeprom_write16(Adapter, (u16)(pEEPROM->offset >> 1),
 			     pEEPROM->value);
 	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro8711_wi_poll_hdl(struct oid_par_priv *poid_par_priv)
@@ -776,17 +777,17 @@ uint oid_rt_pro8711_wi_poll_hdl(struct oid_par_priv *poid_par_priv)
 	struct mp_wiparam *pwi_param;
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len < sizeof(struct mp_wiparam))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	if (Adapter->mppriv.workparam.bcompleted == false)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	pwi_param = (struct mp_wiparam *)poid_par_priv->information_buf;
 	memcpy(pwi_param, &Adapter->mppriv.workparam,
 		sizeof(struct mp_wiparam));
 	Adapter->mppriv.act_in_progress = false;
 	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro8711_pkt_loss_hdl(struct oid_par_priv *poid_par_priv)
@@ -795,42 +796,42 @@ uint oid_rt_pro8711_pkt_loss_hdl(struct oid_par_priv *poid_par_priv)
 				   (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len < sizeof(uint) * 2)
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	if (*(uint *)poid_par_priv->information_buf == 1)
 		Adapter->mppriv.rx_pktloss = 0;
 	*((uint *)poid_par_priv->information_buf+1) =
 					 Adapter->mppriv.rx_pktloss;
 	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_rd_attrib_mem_hdl(struct oid_par_priv *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_wr_attrib_mem_hdl(struct oid_par_priv *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro_set_rf_intfs_hdl(struct oid_par_priv *poid_par_priv)
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (r8712_setrfintfs_cmd(Adapter, *(unsigned char *)
 	    poid_par_priv->information_buf) == _FAIL)
-		status = NDIS_STATUS_NOT_ACCEPTED;
+		status = RNDIS_STATUS_NOT_ACCEPTED;
 	return status;
 }
 
@@ -838,10 +839,10 @@ uint oid_rt_poll_rx_status_hdl(struct oid_par_priv *poid_par_priv)
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	memcpy(poid_par_priv->information_buf,
 		(unsigned char *)&Adapter->mppriv.rxstat,
 		sizeof(struct recv_stat));
@@ -852,7 +853,7 @@ uint oid_rt_poll_rx_status_hdl(struct oid_par_priv *poid_par_priv)
 uint oid_rt_pro_cfg_debug_message_hdl(struct oid_par_priv
 					     *poid_par_priv)
 {
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro_set_data_rate_ex_hdl(struct oid_par_priv
@@ -860,13 +861,13 @@ uint oid_rt_pro_set_data_rate_ex_hdl(struct oid_par_priv
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (r8712_setdatarate_cmd(Adapter,
 	    poid_par_priv->information_buf) != _SUCCESS)
-		status = NDIS_STATUS_NOT_ACCEPTED;
+		status = RNDIS_STATUS_NOT_ACCEPTED;
 	return status;
 }
 
@@ -874,16 +875,16 @@ uint oid_rt_get_thermal_meter_hdl(struct oid_par_priv *poid_par_priv)
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 
 	if (Adapter->mppriv.act_in_progress == true)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 
 	if (poid_par_priv->information_buf_len < sizeof(u8))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	/*init workparam*/
 	Adapter->mppriv.act_in_progress = true;
 	Adapter->mppriv.workparam.bcompleted = false;
@@ -904,14 +905,14 @@ uint oid_rt_pro_set_power_tracking_hdl(struct oid_par_priv
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len < sizeof(u8))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	if (!r8712_setptm_cmd(Adapter, *((u8 *)poid_par_priv->information_buf)))
-		status = NDIS_STATUS_NOT_ACCEPTED;
+		status = RNDIS_STATUS_NOT_ACCEPTED;
 	return status;
 }
 
@@ -920,13 +921,13 @@ uint oid_rt_pro_set_basic_rate_hdl(struct oid_par_priv *poid_par_priv)
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
 	u8 mpdatarate[NumRates] = {11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0, 0xff};
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	u32 ratevalue;
 	u8 datarates[NumRates];
 	int i;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	ratevalue = *((u32 *)poid_par_priv->information_buf);
 	for (i = 0; i < NumRates; i++) {
 		if (ratevalue == mpdatarate[i])
@@ -935,7 +936,7 @@ uint oid_rt_pro_set_basic_rate_hdl(struct oid_par_priv *poid_par_priv)
 			datarates[i] = 0xff;
 	}
 	if (r8712_setbasicrate_cmd(Adapter, datarates) != _SUCCESS)
-		status = NDIS_STATUS_NOT_ACCEPTED;
+		status = RNDIS_STATUS_NOT_ACCEPTED;
 	return status;
 }
 
@@ -945,14 +946,14 @@ uint oid_rt_pro_qry_pwrstate_hdl(struct oid_par_priv *poid_par_priv)
 				   (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len < 8)
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	*poid_par_priv->bytes_rw = 8;
 	memcpy(poid_par_priv->information_buf,
 		&(Adapter->pwrctrlpriv.pwr_mode), 8);
 	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro_set_pwrstate_hdl(struct oid_par_priv *poid_par_priv)
@@ -962,18 +963,18 @@ uint oid_rt_pro_set_pwrstate_hdl(struct oid_par_priv *poid_par_priv)
 	uint pwr_mode, smart_ps;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	*poid_par_priv->bytes_rw = 0;
 	*poid_par_priv->bytes_needed = 8;
 	if (poid_par_priv->information_buf_len < 8)
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	pwr_mode = *(uint *)(poid_par_priv->information_buf);
 	smart_ps = *(uint *)((addr_t)poid_par_priv->information_buf + 4);
 	if (pwr_mode != Adapter->pwrctrlpriv.pwr_mode || smart_ps !=
 			Adapter->pwrctrlpriv.smart_ps)
 		r8712_set_ps_mode(Adapter, pwr_mode, smart_ps);
 	*poid_par_priv->bytes_rw = 8;
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro_h2c_set_rate_table_hdl(struct oid_par_priv
@@ -981,20 +982,20 @@ uint oid_rt_pro_h2c_set_rate_table_hdl(struct oid_par_priv
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	struct setratable_parm *prate_table;
 	u8 res;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	*poid_par_priv->bytes_needed  = sizeof(struct setratable_parm);
 	if (poid_par_priv->information_buf_len <
 	    sizeof(struct setratable_parm))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	prate_table = (struct setratable_parm *)poid_par_priv->information_buf;
 	res = r8712_setrttbl_cmd(Adapter, prate_table);
 	if (res == _FAIL)
-		status = NDIS_STATUS_FAILURE;
+		status = RNDIS_STATUS_FAILURE;
 	return status;
 }
 
@@ -1002,8 +1003,8 @@ uint oid_rt_pro_h2c_get_rate_table_hdl(struct oid_par_priv
 					      *poid_par_priv)
 {
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
-	return NDIS_STATUS_SUCCESS;
+		return RNDIS_STATUS_NOT_ACCEPTED;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro_encryption_ctrl_hdl(struct oid_par_priv
@@ -1016,7 +1017,7 @@ uint oid_rt_pro_encryption_ctrl_hdl(struct oid_par_priv
 
 	*poid_par_priv->bytes_needed = sizeof(u8);
 	if (poid_par_priv->information_buf_len < *poid_par_priv->bytes_needed)
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 
 	if (poid_par_priv->type_of_oid == SET_OID) {
 		encry_mode = *((u8 *)poid_par_priv->information_buf);
@@ -1054,7 +1055,7 @@ uint oid_rt_pro_encryption_ctrl_hdl(struct oid_par_priv
 		*(u8 *)poid_par_priv->information_buf =  encry_mode;
 		*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
 	}
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 /*----------------------------------------------------------------------*/
 uint oid_rt_pro_add_sta_info_hdl(struct oid_par_priv *poid_par_priv)
@@ -1062,24 +1063,24 @@ uint oid_rt_pro_add_sta_info_hdl(struct oid_par_priv *poid_par_priv)
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
 
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 
 	struct sta_info	*psta = NULL;
 	u8	*macaddr;
 
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 
 	*poid_par_priv->bytes_needed = ETH_ALEN;
 	if (poid_par_priv->information_buf_len < *poid_par_priv->bytes_needed)
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	macaddr = (u8 *) poid_par_priv->information_buf;
 	psta = r8712_get_stainfo(&Adapter->stapriv, macaddr);
 	if (psta == NULL) { /* the sta in sta_info_queue => do nothing*/
 		psta = r8712_alloc_stainfo(&Adapter->stapriv, macaddr);
 		if (psta == NULL)
-			status = NDIS_STATUS_FAILURE;
+			status = RNDIS_STATUS_FAILURE;
 	}
 	return status;
 }
@@ -1090,18 +1091,18 @@ uint oid_rt_pro_dele_sta_info_hdl(struct oid_par_priv *poid_par_priv)
 				   (poid_par_priv->adapter_context);
 
 	unsigned long			irqL;
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 
 	struct sta_info		*psta = NULL;
 	u8			*macaddr;
 
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 
 	*poid_par_priv->bytes_needed = ETH_ALEN;
 	if (poid_par_priv->information_buf_len < *poid_par_priv->bytes_needed)
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 
 	macaddr = (u8 *)poid_par_priv->information_buf;
 
@@ -1125,15 +1126,15 @@ uint oid_rt_pro_query_dr_variable_hdl(struct oid_par_priv *poid_par_priv)
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
 
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 
 	struct DR_VARIABLE_STRUCT *pdrv_var;
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	*poid_par_priv->bytes_needed = sizeof(struct DR_VARIABLE_STRUCT);
 	if (poid_par_priv->information_buf_len < *poid_par_priv->bytes_needed)
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	pdrv_var = (struct DR_VARIABLE_STRUCT *)poid_par_priv->information_buf;
 	pdrv_var->variable = mp_query_drv_var(Adapter, pdrv_var->offset,
 					      pdrv_var->variable);
@@ -1144,7 +1145,7 @@ uint oid_rt_pro_query_dr_variable_hdl(struct oid_par_priv *poid_par_priv)
 /*--------------------------------------------------------------------------*/
 uint oid_rt_pro_rx_packet_type_hdl(struct oid_par_priv *poid_par_priv)
 {
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 /*------------------------------------------------------------------------*/
 uint oid_rt_pro_read_efuse_hdl(struct oid_par_priv *poid_par_priv)
@@ -1152,17 +1153,17 @@ uint oid_rt_pro_read_efuse_hdl(struct oid_par_priv *poid_par_priv)
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
 
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 
 	struct EFUSE_ACCESS_STRUCT *pefuse;
 	u8 *data;
 	u16 addr = 0, cnts = 0;
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len <
 	    sizeof(struct EFUSE_ACCESS_STRUCT))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	pefuse = (struct EFUSE_ACCESS_STRUCT *)poid_par_priv->information_buf;
 	addr = pefuse->start_addr;
 	cnts = pefuse->cnts;
@@ -1170,9 +1171,9 @@ uint oid_rt_pro_read_efuse_hdl(struct oid_par_priv *poid_par_priv)
 	memset(data, 0xFF, cnts);
 	if ((addr > 511) || (cnts < 1) || (cnts > 512) || (addr + cnts) >
 	     EFUSE_MAX_SIZE)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (r8712_efuse_access(Adapter, true, addr, cnts, data) == false)
-		status = NDIS_STATUS_FAILURE;
+		status = RNDIS_STATUS_FAILURE;
 	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
 	return status;
 }
@@ -1182,14 +1183,14 @@ uint oid_rt_pro_write_efuse_hdl(struct oid_par_priv *poid_par_priv)
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
 
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 
 	struct EFUSE_ACCESS_STRUCT *pefuse;
 	u8 *data;
 	u16 addr = 0, cnts = 0;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 
 	pefuse = (struct EFUSE_ACCESS_STRUCT *)poid_par_priv->information_buf;
 	addr = pefuse->start_addr;
@@ -1198,9 +1199,9 @@ uint oid_rt_pro_write_efuse_hdl(struct oid_par_priv *poid_par_priv)
 
 	if ((addr > 511) || (cnts < 1) || (cnts > 512) ||
 	    (addr + cnts) > r8712_efuse_get_max_size(Adapter))
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (r8712_efuse_access(Adapter, false, addr, cnts, data) == false)
-		status = NDIS_STATUS_FAILURE;
+		status = RNDIS_STATUS_FAILURE;
 	return status;
 }
 /*----------------------------------------------------------------------*/
@@ -1208,12 +1209,12 @@ uint oid_rt_pro_rw_efuse_pgpkt_hdl(struct oid_par_priv *poid_par_priv)
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	struct PGPKT_STRUCT	*ppgpkt;
 
 	*poid_par_priv->bytes_rw = 0;
 	if (poid_par_priv->information_buf_len < sizeof(struct PGPKT_STRUCT))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	ppgpkt = (struct PGPKT_STRUCT *)poid_par_priv->information_buf;
 	if (poid_par_priv->type_of_oid == QUERY_OID) {
 		if (r8712_efuse_pg_packet_read(Adapter, ppgpkt->offset,
@@ -1221,7 +1222,7 @@ uint oid_rt_pro_rw_efuse_pgpkt_hdl(struct oid_par_priv *poid_par_priv)
 			*poid_par_priv->bytes_rw =
 				 poid_par_priv->information_buf_len;
 		else
-			status = NDIS_STATUS_FAILURE;
+			status = RNDIS_STATUS_FAILURE;
 	} else {
 		if (r8712_efuse_reg_init(Adapter) == true) {
 			if (r8712_efuse_pg_packet_write(Adapter, ppgpkt->offset,
@@ -1229,10 +1230,10 @@ uint oid_rt_pro_rw_efuse_pgpkt_hdl(struct oid_par_priv *poid_par_priv)
 				*poid_par_priv->bytes_rw =
 					 poid_par_priv->information_buf_len;
 			else
-				status = NDIS_STATUS_FAILURE;
+				status = RNDIS_STATUS_FAILURE;
 			r8712_efuse_reg_uninit(Adapter);
 		} else
-			status = NDIS_STATUS_FAILURE;
+			status = RNDIS_STATUS_FAILURE;
 	}
 	return status;
 }
@@ -1242,12 +1243,12 @@ uint oid_rt_get_efuse_current_size_hdl(struct oid_par_priv
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len < sizeof(int))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	r8712_efuse_reg_init(Adapter);
 	*(int *)poid_par_priv->information_buf =
 				 r8712_efuse_get_current_size(Adapter);
@@ -1260,12 +1261,12 @@ uint oid_rt_get_efuse_max_size_hdl(struct oid_par_priv *poid_par_priv)
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len < sizeof(u32))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	*(int *)poid_par_priv->information_buf =
 					 r8712_efuse_get_max_size(Adapter);
 	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
@@ -1274,7 +1275,7 @@ uint oid_rt_get_efuse_max_size_hdl(struct oid_par_priv *poid_par_priv)
 
 uint oid_rt_pro_efuse_hdl(struct oid_par_priv *poid_par_priv)
 {
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 
 	if (poid_par_priv->type_of_oid == QUERY_OID)
 		status = oid_rt_pro_read_efuse_hdl(poid_par_priv);
@@ -1287,18 +1288,18 @@ uint oid_rt_pro_efuse_map_hdl(struct oid_par_priv *poid_par_priv)
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	u8		*data;
 
 	*poid_par_priv->bytes_rw = 0;
 	if (poid_par_priv->information_buf_len < EFUSE_MAP_MAX_SIZE)
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	data = (u8 *)poid_par_priv->information_buf;
 	if (poid_par_priv->type_of_oid == QUERY_OID) {
 		if (r8712_efuse_map_read(Adapter, 0, EFUSE_MAP_MAX_SIZE, data))
 			*poid_par_priv->bytes_rw = EFUSE_MAP_MAX_SIZE;
 		else
-			status = NDIS_STATUS_FAILURE;
+			status = RNDIS_STATUS_FAILURE;
 	} else {
 		/* SET_OID */
 		if (r8712_efuse_reg_init(Adapter) == true) {
@@ -1306,10 +1307,10 @@ uint oid_rt_pro_efuse_map_hdl(struct oid_par_priv *poid_par_priv)
 			    EFUSE_MAP_MAX_SIZE, data))
 				*poid_par_priv->bytes_rw = EFUSE_MAP_MAX_SIZE;
 			else
-				status = NDIS_STATUS_FAILURE;
+				status = RNDIS_STATUS_FAILURE;
 			r8712_efuse_reg_uninit(Adapter);
 		} else {
-			status = NDIS_STATUS_FAILURE;
+			status = RNDIS_STATUS_FAILURE;
 		}
 	}
 	return status;
@@ -1319,13 +1320,13 @@ uint oid_rt_set_bandwidth_hdl(struct oid_par_priv *poid_par_priv)
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	u32		bandwidth;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len < sizeof(u32))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	bandwidth = *((u32 *)poid_par_priv->information_buf);/*4*/
 	if (bandwidth != HT_CHANNEL_WIDTH_20)
 		bandwidth = HT_CHANNEL_WIDTH_40;
@@ -1338,16 +1339,16 @@ uint oid_rt_set_crystal_cap_hdl(struct oid_par_priv *poid_par_priv)
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	u32		crystal_cap = 0;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len < sizeof(u32))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	crystal_cap = *((u32 *)poid_par_priv->information_buf);/*4*/
 	if (crystal_cap > 0xf)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	Adapter->mppriv.curr_crystalcap = crystal_cap;
 	r8712_SetCrystalCap(Adapter);
 	return status;
@@ -1362,9 +1363,9 @@ uint oid_rt_set_rx_packet_type_hdl(struct oid_par_priv
 	u32		rcr_val32;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len < sizeof(u8))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	rx_pkt_type = *((u8 *)poid_par_priv->information_buf);/*4*/
 	rcr_val32 = r8712_read32(Adapter, RCR);/*RCR = 0x10250048*/
 	rcr_val32 &= ~(RCR_CBSSID | RCR_AB | RCR_AM | RCR_APM | RCR_AAP);
@@ -1391,7 +1392,7 @@ uint oid_rt_set_rx_packet_type_hdl(struct oid_par_priv
 	else
 		Adapter->mppriv.check_mp_pkt = 0;
 	r8712_write32(Adapter, RCR, rcr_val32);
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro_set_tx_agc_offset_hdl(struct oid_par_priv
@@ -1402,12 +1403,12 @@ uint oid_rt_pro_set_tx_agc_offset_hdl(struct oid_par_priv
 	u32 txagc;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len < sizeof(u32))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	txagc = *(u32 *)poid_par_priv->information_buf;
 	r8712_SetTxAGCOffset(Adapter, txagc);
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 uint oid_rt_pro_set_pkt_test_mode_hdl(struct oid_par_priv
@@ -1415,16 +1416,16 @@ uint oid_rt_pro_set_pkt_test_mode_hdl(struct oid_par_priv
 {
 	struct _adapter *Adapter = (struct _adapter *)
 				   (poid_par_priv->adapter_context);
-	uint status = NDIS_STATUS_SUCCESS;
+	uint status = RNDIS_STATUS_SUCCESS;
 	struct mlme_priv	*pmlmepriv = &Adapter->mlmepriv;
 	struct mp_priv		*pmppriv = &Adapter->mppriv;
 	u32			type;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 
 	if (poid_par_priv->information_buf_len < sizeof(u32))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 
 	type = *(u32 *)poid_par_priv->information_buf;
 
@@ -1435,7 +1436,7 @@ uint oid_rt_pro_set_pkt_test_mode_hdl(struct oid_par_priv
 		pmppriv->mode = type;
 		_clr_fwstate_(pmlmepriv, WIFI_MP_LPBK_STATE);
 	} else
-		status = NDIS_STATUS_NOT_ACCEPTED;
+		status = RNDIS_STATUS_NOT_ACCEPTED;
 	return status;
 }
 /*--------------------------------------------------------------------------*/
@@ -1450,10 +1451,10 @@ uint oid_rt_set_power_down_hdl(struct oid_par_priv *poid_par_priv)
 	u8	bpwrup;
 
 	if (poid_par_priv->type_of_oid != SET_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	bpwrup = *(u8 *)poid_par_priv->information_buf;
 	/*CALL  the power_down function*/
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
 
 /*-------------------------------------------------------------------------- */
@@ -1463,11 +1464,11 @@ uint oid_rt_get_power_mode_hdl(struct oid_par_priv *poid_par_priv)
 				   (poid_par_priv->adapter_context);
 
 	if (poid_par_priv->type_of_oid != QUERY_OID)
-		return NDIS_STATUS_NOT_ACCEPTED;
+		return RNDIS_STATUS_NOT_ACCEPTED;
 	if (poid_par_priv->information_buf_len < sizeof(u32))
-		return NDIS_STATUS_INVALID_LENGTH;
+		return RNDIS_STATUS_INVALID_LENGTH;
 	*(int *)poid_par_priv->information_buf =
 		 Adapter->registrypriv.low_power ? POWER_LOW : POWER_NORMAL;
 	*poid_par_priv->bytes_rw = poid_par_priv->information_buf_len;
-	return NDIS_STATUS_SUCCESS;
+	return RNDIS_STATUS_SUCCESS;
 }
-- 
1.8.0.1

