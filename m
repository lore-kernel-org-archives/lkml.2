Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab2LBCri (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 21:47:38 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:64715 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab2LBCrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 21:47:35 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>,
        Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        gregkh@linuxfoundation.org, paul.gortmaker@windriver.com,
        dan.carpenter@oracle.com, yongjun_wei@trendmicro.com.cn,
        justinmattock@gmail.com, devel@driverdev.osuosl.org
Subject: [PATCH 5/6] rtl8712: remove useless calls to memset().
Date: Sun,  2 Dec 2012 03:40:21 +0100
Message-Id: <1354416022-20189-6-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354416022-20189-1-git-send-email-tipecaml@gmail.com>
References: <1354416022-20189-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These calls are followed by calls to memcpy() on the same memory area, so they
can be safely removed.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/staging/rtl8712/mlme_linux.c        |    2 --
 drivers/staging/rtl8712/rtl871x_cmd.c       |    1 -
 drivers/staging/rtl8712/rtl871x_ioctl_set.c |    2 --
 drivers/staging/rtl8712/rtl871x_mlme.c      |    5 -----
 4 files changed, 10 deletions(-)

diff --git a/drivers/staging/rtl8712/mlme_linux.c b/drivers/staging/rtl8712/mlme_linux.c
index 7279854..f569a70 100644
--- a/drivers/staging/rtl8712/mlme_linux.c
+++ b/drivers/staging/rtl8712/mlme_linux.c
@@ -106,8 +106,6 @@ void r8712_os_indicate_disconnect(struct _adapter *adapter)
 		 * disconnect with AP for 60 seconds.
 		 */
 
-		memset(&backupPMKIDList[0], 0x00, sizeof(
-			struct RT_PMKID_LIST) *	NUM_PMKID_CACHE);
 		memcpy(&backupPMKIDList[0], &adapter->securitypriv.
 			PMKIDList[0], sizeof(struct RT_PMKID_LIST) *
 			NUM_PMKID_CACHE);
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index 31f31dbf..f16307f 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -525,7 +525,6 @@ u8 r8712_joinbss_cmd(struct _adapter  *padapter, struct wlan_network *pnetwork)
 		kfree(pcmd);
 		return _FAIL;
 	}
-	memset(psecnetwork, 0, t_len);
 	memcpy(psecnetwork, &pnetwork->network, t_len);
 	auth = &psecuritypriv->authenticator_ie[0];
 	psecuritypriv->authenticator_ie[0] = (unsigned char)
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_set.c b/drivers/staging/rtl8712/rtl871x_ioctl_set.c
index d3ab24e..53a7c8c 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_set.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_set.c
@@ -97,8 +97,6 @@ static u8 do_join(struct _adapter *padapter)
 				pmlmepriv->fw_state = WIFI_ADHOC_MASTER_STATE;
 				pibss = padapter->registrypriv.dev_network.
 					MacAddress;
-				memset(&pdev_network->Ssid, 0,
-					sizeof(struct ndis_802_11_ssid));
 				memcpy(&pdev_network->Ssid,
 					&pmlmepriv->assoc_ssid,
 					sizeof(struct ndis_802_11_ssid));
diff --git a/drivers/staging/rtl8712/rtl871x_mlme.c b/drivers/staging/rtl8712/rtl871x_mlme.c
index c51ad9e..e52f04d 100644
--- a/drivers/staging/rtl8712/rtl871x_mlme.c
+++ b/drivers/staging/rtl8712/rtl871x_mlme.c
@@ -604,9 +604,6 @@ void r8712_surveydone_event_callback(struct _adapter *adapter, u8 *pbuf)
 						 adapter->registrypriv.
 							dev_network.MacAddress;
 					pmlmepriv->fw_state ^= _FW_UNDER_SURVEY;
-					memset(&pdev_network->Ssid, 0,
-						sizeof(struct
-						       ndis_802_11_ssid));
 					memcpy(&pdev_network->Ssid,
 						&pmlmepriv->assoc_ssid,
 						sizeof(struct
@@ -1006,8 +1003,6 @@ void r8712_stadel_event_callback(struct _adapter *adapter, u8 *pbuf)
 			memcpy(pdev_network, &tgt_network->network,
 				r8712_get_ndis_wlan_bssid_ex_sz(&tgt_network->
 							network));
-			memset(&pdev_network->Ssid, 0,
-				sizeof(struct ndis_802_11_ssid));
 			memcpy(&pdev_network->Ssid,
 				&pmlmepriv->assoc_ssid,
 				sizeof(struct ndis_802_11_ssid));
-- 
1.7.10.4

