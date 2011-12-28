Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751347Ab1L1XDJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 18:03:09 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62316 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab1L1XDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 18:03:06 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 1/7] staging: vt6656: iwctl.c: Remove commented code
Date: Wed, 28 Dec 2011 21:03:15 +0000
Message-Id: <1325106195-2304-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 drivers/staging/vt6656/iwctl.c |  172 ----------------------------------------
 1 files changed, 0 insertions(+), 172 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index ecfda52..480e07f 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -46,9 +46,6 @@
 
 #include <net/iw_handler.h>
 
-
-/*---------------------  Static Definitions -------------------------*/
-
 #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
 #define SUPPORTED_WIRELESS_EXT                  18
 #else
@@ -63,19 +60,8 @@ static const long frequency_list[] = {
     5700, 5745, 5765, 5785, 5805, 5825
 	};
 
-
-/*---------------------  Static Classes  ----------------------------*/
-
-
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 static int          msglevel                =MSG_LEVEL_INFO;
 
-
-/*---------------------  Static Variables  --------------------------*/
-/*---------------------  Static Functions  --------------------------*/
-
-/*---------------------  Export Variables  --------------------------*/
-
 struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 {
 	PSDevice pDevice = netdev_priv(dev);
@@ -87,7 +73,6 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
                pDevice->wstats.qual.qual =(BYTE) pDevice->scStatistic.LinkQuality;
 	RFvRSSITodBm(pDevice, (BYTE)(pDevice->uCurrRSSI), &ldBm);
 	pDevice->wstats.qual.level = ldBm;
-	//pDevice->wstats.qual.level = 0x100 - pDevice->uCurrRSSI;
 	pDevice->wstats.qual.noise = 0;
 	pDevice->wstats.qual.updated = 1;
 	pDevice->wstats.discard.nwid = 0;
@@ -100,11 +85,6 @@ struct iw_statistics *iwctl_get_wireless_stats(struct net_device *dev)
 	return &pDevice->wstats;
 }
 
-
-
-/*------------------------------------------------------------------*/
-
-
 static int iwctl_commit(struct net_device *dev,
 			      struct iw_request_info *info,
 			      void *wrq,
@@ -197,14 +177,12 @@ if(pDevice->byReAssocCount > 0) {   //reject scan when re-associating!
  }
 
 	 pMgmt->eScanType = WMAC_SCAN_PASSIVE;
-         //printk("SIOCSIWSCAN:WLAN_CMD_BSSID_SCAN\n");
 	bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, NULL);
 	spin_unlock_irq(&pDevice->lock);
 
 	return 0;
 }
 
-
 /*
  * Wireless Handler : get scan results
  */
@@ -708,9 +686,7 @@ int iwctl_giwap(struct net_device *dev,
 
     memcpy(wrq->sa_data, pMgmt->abyCurrBSSID, 6);
 
-//20080123-02,<Modify> by Einsn Liu
  if ((pDevice->bLinkPass == FALSE) && (pMgmt->eCurrMode != WMAC_MODE_ESS_AP))
- //   if ((pDevice->bLinkPass == FALSE) && (pMgmt->eCurrMode == WMAC_MODE_ESS_STA))
         memset(wrq->sa_data, 0, 6);
 
     if (pMgmt->eCurrMode == WMAC_MODE_ESS_AP) {
@@ -913,7 +889,6 @@ int iwctl_giwessid(struct net_device *dev,
 
 	// Get the current SSID
     pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
-	//pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
 	memcpy(extra, pItemSSID->abySSID , pItemSSID->len);
 	extra[pItemSSID->len] = '\0';
 
@@ -1327,55 +1302,6 @@ int iwctl_siwencode(struct net_device *dev,
 	return rc;
 }
 
-/*
- * Wireless Handler : get encode mode
- */
-//2008-0409-06, <Mark> by Einsn Liu
- /*
-int iwctl_giwencode(struct net_device *dev,
-             struct iw_request_info *info,
-             struct iw_point *wrq,
-             char *extra)
-{
-    PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-    int rc = 0;
-    char abyKey[WLAN_WEP232_KEYLEN];
-	unsigned int index = (unsigned int)(wrq->flags & IW_ENCODE_INDEX);
-	PSKeyItem   pKey = NULL;
-
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCGIWENCODE\n");
-
-
-	memset(abyKey, 0, sizeof(abyKey));
-	// Check encryption mode
-	wrq->flags = IW_ENCODE_NOKEY;
-	// Is WEP enabled ???
-	if (pDevice->bEncryptionEnable)
-		wrq->flags |=  IW_ENCODE_ENABLED;
-    else
-		wrq->flags |=  IW_ENCODE_DISABLED;
-
-    if (pMgmt->bShareKeyAlgorithm)
-		wrq->flags |=  IW_ENCODE_RESTRICTED;
-	else
-		wrq->flags |=  IW_ENCODE_OPEN;
-
-	if (KeybGetKey(&(pDevice->sKey), pDevice->abyBroadcastAddr, (BYTE)index , &pKey)){
-        wrq->length = pKey->uKeyLength;
-        memcpy(abyKey, pKey->abyKey,  pKey->uKeyLength);
-    }
-    else {
-        rc = -EINVAL;
-        return rc;
-    }
-	wrq->flags |= index;
-	// Copy the key to the user buffer
-	memcpy(extra,  abyKey, WLAN_WEP232_KEYLEN);
-	return 0;
-}
-*/
-
 int iwctl_giwencode(struct net_device *dev,
 			struct iw_request_info *info,
 			struct iw_point *wrq,
@@ -1562,7 +1488,6 @@ int iwctl_siwauth(struct net_device *dev,
 		wpa_version = wrq->value;
 		if(wrq->value == IW_AUTH_WPA_VERSION_DISABLED) {
 		       PRINT_K("iwctl_siwauth:set WPADEV to disable at 1??????\n");
-			//pDevice->bWPADEVUp = FALSE;
 		}
 		else if(wrq->value == IW_AUTH_WPA_VERSION_WPA) {
                           PRINT_K("iwctl_siwauth:set WPADEV to WPA1******\n");
@@ -1570,7 +1495,6 @@ int iwctl_siwauth(struct net_device *dev,
 		else {
                           PRINT_K("iwctl_siwauth:set WPADEV to WPA2******\n");
 		}
-		//pDevice->bWPASuppWextEnabled =TRUE;
 		break;
 	case IW_AUTH_CIPHER_PAIRWISE:
 		pairwise = wrq->value;
@@ -1627,11 +1551,6 @@ int iwctl_siwauth(struct net_device *dev,
 		}
 		break;
 	case IW_AUTH_WPA_ENABLED:
-		//pDevice->bWPADEVUp = !! wrq->value;
-		//if(pDevice->bWPADEVUp==TRUE)
-		  // printk("iwctl_siwauth:set WPADEV to enable successful*******\n");
-		//else
-		 //  printk("iwctl_siwauth:set WPADEV to enable fail?????\n");
 		break;
 	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
 		break;
@@ -1646,7 +1565,6 @@ int iwctl_siwauth(struct net_device *dev,
 			pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 			pMgmt->bShareKeyAlgorithm = FALSE;
 			pMgmt->eAuthenMode = WMAC_AUTH_OPEN;
-			//pDevice->bWPADEVUp = FALSE;
 			 PRINT_K("iwctl_siwauth:set WPADEV to disaable at 2?????\n");
 		}
 
@@ -1655,15 +1573,6 @@ int iwctl_siwauth(struct net_device *dev,
 		ret = -EOPNOTSUPP;
 		break;
 	}
-/*
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wpa_version = %d\n",wpa_version);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pairwise = %d\n",pairwise);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->eEncryptionStatus = %d\n",pDevice->eEncryptionStatus);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pMgmt->eAuthenMode  = %d\n",pMgmt->eAuthenMode);
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pMgmt->bShareKeyAlgorithm = %s\n",pMgmt->bShareKeyAlgorithm?"TRUE":"FALSE");
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->bEncryptionEnable = %s\n",pDevice->bEncryptionEnable?"TRUE":"FALSE");
-	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pDevice->bWPADEVUp = %s\n",pDevice->bWPADEVUp?"TRUE":"FALSE");
-*/
    return ret;
 }
 
@@ -1752,8 +1661,6 @@ int iwctl_siwencodeext(struct net_device *dev,
     u8  seq[IW_ENCODE_SEQ_MAX_SIZE];
     u8 key[64];
     size_t seq_len=0,key_len=0;
-//
-   // int ii;
     u8 *buf;
     size_t blen;
     u8 key_array[64];
@@ -1883,7 +1790,6 @@ int iwctl_siwmlme(struct net_device *dev,
 	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
 	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
-	//u16 reason = cpu_to_le16(mlme->reason_code);
 	int ret = 0;
 
 	if(memcmp(pMgmt->abyCurrBSSID, mlme->addr.sa_data, ETH_ALEN)){
@@ -1892,12 +1798,6 @@ int iwctl_siwmlme(struct net_device *dev,
 	}
 	switch(mlme->cmd){
 	case IW_MLME_DEAUTH:
-		//this command seems to be not complete,please test it --einsnliu
-		//printk("iwctl_siwmlme--->send DEAUTH\n");
-		/* bScheduleCommand((void *) pDevice,
-		   WLAN_CMD_DEAUTH,
-		   (PBYTE)&reason); */
-		//break;
 	case IW_MLME_DISASSOC:
 		if(pDevice->bLinkPass == TRUE){
 		  PRINT_K("iwctl_siwmlme--->send DISASSOCIATE\n");
@@ -1916,74 +1816,6 @@ int iwctl_siwmlme(struct net_device *dev,
 
 #endif
 
-/*------------------------------------------------------------------*/
-/*
- * Structures to export the Wireless Handlers
- */
-
-
-/*
-static const iw_handler		iwctl_handler[] =
-{
-	(iw_handler) iwctl_commit,      // SIOCSIWCOMMIT
-	(iw_handler) iwctl_giwname,     // SIOCGIWNAME
-	(iw_handler) NULL,				// SIOCSIWNWID
-	(iw_handler) iwctl_siwfreq,		// SIOCSIWFREQ
-	(iw_handler) iwctl_giwfreq,		// SIOCGIWFREQ
-	(iw_handler) iwctl_siwmode,		// SIOCSIWMODE
-	(iw_handler) iwctl_giwmode,		// SIOCGIWMODE
-	(iw_handler) NULL,		        // SIOCSIWSENS
-	(iw_handler) iwctl_giwsens,		        // SIOCGIWSENS
-	(iw_handler) NULL, 		        // SIOCSIWRANGE
-	(iw_handler) iwctl_giwrange,		// SIOCGIWRANGE
-	(iw_handler) NULL,         		    // SIOCSIWPRIV
-	(iw_handler) NULL,             		// SIOCGIWPRIV
-	(iw_handler) NULL,             		// SIOCSIWSTATS
-	(iw_handler) NULL,                  // SIOCGIWSTATS
-    (iw_handler) NULL,                  // SIOCSIWSPY
-	(iw_handler) NULL,		            // SIOCGIWSPY
-	(iw_handler) NULL,				    // -- hole --
-	(iw_handler) NULL,				    // -- hole --
-	(iw_handler) iwctl_siwap,		    // SIOCSIWAP
-	(iw_handler) iwctl_giwap,		    // SIOCGIWAP
-	(iw_handler) NULL,				    // -- hole -- 0x16
-	(iw_handler) iwctl_giwaplist,       // SIOCGIWAPLIST
-	(iw_handler) iwctl_siwscan,         // SIOCSIWSCAN
-	(iw_handler) iwctl_giwscan,         // SIOCGIWSCAN
-	(iw_handler) iwctl_siwessid,		// SIOCSIWESSID
-	(iw_handler) iwctl_giwessid,		// SIOCGIWESSID
-	(iw_handler) NULL,		// SIOCSIWNICKN
-	(iw_handler) NULL,		// SIOCGIWNICKN
-	(iw_handler) NULL,				    // -- hole --
-	(iw_handler) NULL,				    // -- hole --
-	(iw_handler) iwctl_siwrate,		// SIOCSIWRATE 0x20
-	(iw_handler) iwctl_giwrate,		// SIOCGIWRATE
-	(iw_handler) iwctl_siwrts,		// SIOCSIWRTS
-	(iw_handler) iwctl_giwrts,		// SIOCGIWRTS
-	(iw_handler) iwctl_siwfrag,		// SIOCSIWFRAG
-	(iw_handler) iwctl_giwfrag,		// SIOCGIWFRAG
-	(iw_handler) NULL,		// SIOCSIWTXPOW
-	(iw_handler) NULL,		// SIOCGIWTXPOW
-	(iw_handler) iwctl_siwretry,		// SIOCSIWRETRY
-	(iw_handler) iwctl_giwretry,		// SIOCGIWRETRY
-	(iw_handler) iwctl_siwencode,		// SIOCSIWENCODE
-	(iw_handler) iwctl_giwencode,		// SIOCGIWENCODE
-	(iw_handler) iwctl_siwpower,		// SIOCSIWPOWER
-	(iw_handler) iwctl_giwpower,		// SIOCGIWPOWER
-	(iw_handler) NULL,			// -- hole --
-	(iw_handler) NULL,			// -- hole --
-	(iw_handler) iwctl_siwgenie,    // SIOCSIWGENIE
-	(iw_handler) iwctl_giwgenie,    // SIOCGIWGENIE
-	(iw_handler) iwctl_siwauth,		// SIOCSIWAUTH
-	(iw_handler) iwctl_giwauth,		// SIOCGIWAUTH
-	(iw_handler) iwctl_siwencodeext,		// SIOCSIWENCODEEXT
-	(iw_handler) iwctl_giwencodeext,		// SIOCGIWENCODEEXT
-	(iw_handler) NULL,				// SIOCSIWPMKSA
-	(iw_handler) NULL,				// -- hole --
-
-};
-*/
-
 static const iw_handler		iwctl_handler[] =
 {
 	(iw_handler) iwctl_commit,      // SIOCSIWCOMMIT
@@ -2063,13 +1895,9 @@ const struct iw_handler_def	iwctl_handler_def =
 {
 	.get_wireless_stats = &iwctl_get_wireless_stats,
 	.num_standard	= sizeof(iwctl_handler)/sizeof(iw_handler),
-//	.num_private	= sizeof(iwctl_private_handler)/sizeof(iw_handler),
-//	.num_private_args = sizeof(iwctl_private_args)/sizeof(struct iw_priv_args),
 	.num_private	= 0,
 	.num_private_args = 0,
 	.standard	= (iw_handler *) iwctl_handler,
-//	.private	= (iw_handler *) iwctl_private_handler,
-//	.private_args	= (struct iw_priv_args *)iwctl_private_args,
 	.private	= NULL,
 	.private_args	= NULL,
 };
-- 
1.7.4.4

