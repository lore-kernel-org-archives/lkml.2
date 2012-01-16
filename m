Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab2APU22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 15:28:28 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:11312 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756401Ab2APU20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 15:28:26 -0500
Date: Mon, 16 Jan 2012 21:28:23 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: devel@driverdev.osuosl.org
cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Forest Bond <forest@alittletooquiet.net>,
        Joe Perches <joe@perches.com>, Ilia Mirkin <imirkin@alum.mit.edu>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 1/2] staging, vt6656/wpactl.c: A basic style cleanup
Message-ID: <alpine.LNX.2.00.1201162123290.16712@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cleans up the coding style in
drivers/staging/vt6656/wpactl.c to closer match the generally accepted
kernel CodingStyle. It is by no means a "make it perfect" patch, but
it does get the file a fair bit closer to matching the accepted style
(whomever was involved in the evolution of this file seriously need to
configure their editors to maintain a consistent style - it was a
mess).

Besides pure style cleanups I also took the liberty of removing some 
pointless parens, some unneeded casts and removing some commented out code 
(it was obviously not used and git has it if it's ever needed in the 
future).

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/wpactl.c |  936 +++++++++++++++++----------------------
 1 files changed, 418 insertions(+), 518 deletions(-)

diff --git a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
index 2fa4f84..9d14868 100644
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -46,23 +46,18 @@
 
 #define VIAWGET_WPA_MAX_BUF_SIZE 1024
 
-
-
 static const int frequency_list[] = {
 	2412, 2417, 2422, 2427, 2432, 2437, 2442,
 	2447, 2452, 2457, 2462, 2467, 2472, 2484
 };
+
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
-//static int          msglevel                =MSG_LEVEL_DEBUG;
-static int          msglevel                =MSG_LEVEL_INFO;
+static int msglevel = MSG_LEVEL_INFO;
 
 /*---------------------  Static Functions  --------------------------*/
 
-
-
-
 /*---------------------  Export Variables  --------------------------*/
 static void wpadev_setup(struct net_device *dev)
 {
@@ -72,9 +67,9 @@ static void wpadev_setup(struct net_device *dev)
 	dev->addr_len           = ETH_ALEN;
 	dev->tx_queue_len       = 1000;
 
-	memset(dev->broadcast,0xFF, ETH_ALEN);
+	memset(dev->broadcast, 0xFF, ETH_ALEN);
 
-	dev->flags              = IFF_BROADCAST|IFF_MULTICAST;
+	dev->flags              = IFF_BROADCAST | IFF_MULTICAST;
 }
 
 /*
@@ -90,45 +85,43 @@ static void wpadev_setup(struct net_device *dev)
  * Return Value:
  *
  */
-
 static int wpa_init_wpadev(PSDevice pDevice)
 {
-    PSDevice wpadev_priv;
+	PSDevice wpadev_priv;
 	struct net_device *dev = pDevice->dev;
-         int ret=0;
+	int ret = 0;
 
 	pDevice->wpadev = alloc_netdev(sizeof(PSDevice), "vntwpa", wpadev_setup);
 	if (pDevice->wpadev == NULL)
 		return -ENOMEM;
 
-    wpadev_priv = netdev_priv(pDevice->wpadev);
-    *wpadev_priv = *pDevice;
+	wpadev_priv = netdev_priv(pDevice->wpadev);
+	*wpadev_priv = *pDevice;
 	memcpy(pDevice->wpadev->dev_addr, dev->dev_addr, ETH_ALEN);
-         pDevice->wpadev->base_addr = dev->base_addr;
+	pDevice->wpadev->base_addr = dev->base_addr;
 	pDevice->wpadev->irq = dev->irq;
 	pDevice->wpadev->mem_start = dev->mem_start;
 	pDevice->wpadev->mem_end = dev->mem_end;
 	ret = register_netdev(pDevice->wpadev);
 	if (ret) {
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: register_netdev(WPA) failed!\n",
-		       dev->name);
+			dev->name);
 		free_netdev(pDevice->wpadev);
 		return -1;
 	}
 
 	if (pDevice->skb == NULL) {
-        pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
-        if (pDevice->skb == NULL)
-		    return -ENOMEM;
-    }
+		pDevice->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
+		if (pDevice->skb == NULL)
+			return -ENOMEM;
+	}
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Registered netdev %s for WPA management\n",
-	       dev->name, pDevice->wpadev->name);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Registered netdev %s for WPA management\n",
+		dev->name, pDevice->wpadev->name);
 
 	return 0;
 }
 
-
 /*
  * Description:
  *      unregister net_device (wpadev)
@@ -141,29 +134,24 @@ static int wpa_init_wpadev(PSDevice pDevice)
  * Return Value:
  *
  */
-
 static int wpa_release_wpadev(PSDevice pDevice)
 {
-    if (pDevice->skb) {
-        dev_kfree_skb(pDevice->skb);
-        pDevice->skb = NULL;
-    }
+	if (pDevice->skb) {
+		dev_kfree_skb(pDevice->skb);
+		pDevice->skb = NULL;
+	}
 
-    if (pDevice->wpadev) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Netdevice %s unregistered\n",
-	       pDevice->dev->name, pDevice->wpadev->name);
-	unregister_netdev(pDevice->wpadev);
-	free_netdev(pDevice->wpadev);
-         pDevice->wpadev = NULL;
-    }
+	if (pDevice->wpadev) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Netdevice %s unregistered\n",
+			pDevice->dev->name, pDevice->wpadev->name);
+		unregister_netdev(pDevice->wpadev);
+		free_netdev(pDevice->wpadev);
+		pDevice->wpadev = NULL;
+	}
 
 	return 0;
 }
 
-
-
-
-
 /*
  * Description:
  *      Set enable/disable dev for wpa supplicant deamon
@@ -177,13 +165,11 @@ static int wpa_release_wpadev(PSDevice pDevice)
  * Return Value:
  *
  */
-
 int wpa_set_wpadev(PSDevice pDevice, int val)
 {
 	if (val)
 		return wpa_init_wpadev(pDevice);
-	else
-		return wpa_release_wpadev(pDevice);
+	return wpa_release_wpadev(pDevice);
 }
 
 /*
@@ -199,245 +185,217 @@ int wpa_set_wpadev(PSDevice pDevice, int val)
  * Return Value:
  *
  */
-
  int wpa_set_keys(PSDevice pDevice, void *ctx, BOOL  fcpfkernel)
 {
-    struct viawget_wpa_param *param=ctx;
-    PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
-    DWORD   dwKeyIndex = 0;
-    BYTE    abyKey[MAX_KEY_LEN];
-    BYTE    abySeq[MAX_KEY_LEN];
-    QWORD   KeyRSC;
-//    NDIS_802_11_KEY_RSC KeyRSC;
-    BYTE    byKeyDecMode = KEY_CTL_WEP;
+	struct viawget_wpa_param *param = ctx;
+	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
+	DWORD dwKeyIndex = 0;
+	BYTE abyKey[MAX_KEY_LEN];
+	BYTE abySeq[MAX_KEY_LEN];
+	QWORD KeyRSC;
+	BYTE byKeyDecMode = KEY_CTL_WEP;
 	int ret = 0;
-	int uu, ii;
-
+	int uu;
+	int ii;
 
 	if (param->u.wpa_key.alg_name > WPA_ALG_CCMP)
 		return -EINVAL;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "param->u.wpa_key.alg_name = %d \n", param->u.wpa_key.alg_name);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "param->u.wpa_key.alg_name = %d \n",
+		param->u.wpa_key.alg_name);
 	if (param->u.wpa_key.alg_name == WPA_ALG_NONE) {
-        pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
-        pDevice->bEncryptionEnable = FALSE;
-        pDevice->byKeyIndex = 0;
-        pDevice->bTransmitKey = FALSE;
-        for (uu=0; uu<MAX_KEY_TABLE; uu++) {
-            MACvDisableKeyEntry(pDevice, uu);
-        }
-        return ret;
-    }
+		pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
+		pDevice->bEncryptionEnable = FALSE;
+		pDevice->byKeyIndex = 0;
+		pDevice->bTransmitKey = FALSE;
+		for (uu=0; uu<MAX_KEY_TABLE; uu++) {
+			MACvDisableKeyEntry(pDevice, uu);
+		}
+		return ret;
+	}
 
 	if (param->u.wpa_key.key && param->u.wpa_key.key_len > sizeof(abyKey))
 		return -EINVAL;
 
-    spin_unlock_irq(&pDevice->lock);
-    if(param->u.wpa_key.key && fcpfkernel) {
-       memcpy(&abyKey[0], param->u.wpa_key.key, param->u.wpa_key.key_len);
-     }
-    else {
-	if (param->u.wpa_key.key &&
-	    copy_from_user(&abyKey[0], param->u.wpa_key.key, param->u.wpa_key.key_len)) {
-	    spin_lock_irq(&pDevice->lock);
-	    return -EINVAL;
+	spin_unlock_irq(&pDevice->lock);
+	if (param->u.wpa_key.key && fcpfkernel) {
+		memcpy(&abyKey[0], param->u.wpa_key.key, param->u.wpa_key.key_len);
+	} else {
+		if (param->u.wpa_key.key &&
+			copy_from_user(&abyKey[0], param->u.wpa_key.key,
+				param->u.wpa_key.key_len)) {
+			spin_lock_irq(&pDevice->lock);
+			return -EINVAL;
+		}
 	}
-     }
-    spin_lock_irq(&pDevice->lock);
+	spin_lock_irq(&pDevice->lock);
 
-    dwKeyIndex = (DWORD)(param->u.wpa_key.key_index);
+	dwKeyIndex = (DWORD)(param->u.wpa_key.key_index);
 
 	if (param->u.wpa_key.alg_name == WPA_ALG_WEP) {
-        if (dwKeyIndex > 3) {
-            return -EINVAL;
-        }
-        else {
-            if (param->u.wpa_key.set_tx) {
-                pDevice->byKeyIndex = (BYTE)dwKeyIndex;
-                pDevice->bTransmitKey = TRUE;
-		        dwKeyIndex |= (1 << 31);
-            }
-            KeybSetDefaultKey(  pDevice,
-                                &(pDevice->sKey),
-                                dwKeyIndex & ~(BIT30 | USE_KEYRSC),
-                                param->u.wpa_key.key_len,
-                                NULL,
-                                abyKey,
-                                KEY_CTL_WEP
-                              );
-
-        }
-        pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
-        pDevice->bEncryptionEnable = TRUE;
-        return ret;
+		if (dwKeyIndex > 3) {
+			return -EINVAL;
+		} else {
+			if (param->u.wpa_key.set_tx) {
+				pDevice->byKeyIndex = (BYTE)dwKeyIndex;
+				pDevice->bTransmitKey = TRUE;
+				dwKeyIndex |= (1 << 31);
+			}
+			KeybSetDefaultKey(  pDevice,
+					&(pDevice->sKey),
+					dwKeyIndex & ~(BIT30 | USE_KEYRSC),
+					param->u.wpa_key.key_len,
+					NULL,
+					abyKey,
+					KEY_CTL_WEP
+				);
+
+		}
+		pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
+		pDevice->bEncryptionEnable = TRUE;
+		return ret;
 	}
 
 
 	if (param->u.wpa_key.seq && param->u.wpa_key.seq_len > sizeof(abySeq))
 		return -EINVAL;
 
-    spin_unlock_irq(&pDevice->lock);
-        if(param->u.wpa_key.seq && fcpfkernel) {
-           memcpy(&abySeq[0], param->u.wpa_key.seq, param->u.wpa_key.seq_len);
-        	}
-       else {
-	if (param->u.wpa_key.seq &&
-	    copy_from_user(&abySeq[0], param->u.wpa_key.seq, param->u.wpa_key.seq_len)) {
-	    spin_lock_irq(&pDevice->lock);
-	    return -EINVAL;
-	}
+	spin_unlock_irq(&pDevice->lock);
+        if (param->u.wpa_key.seq && fcpfkernel) {
+		memcpy(&abySeq[0], param->u.wpa_key.seq, param->u.wpa_key.seq_len);
+	} else {
+		if (param->u.wpa_key.seq &&
+			copy_from_user(&abySeq[0], param->u.wpa_key.seq,
+				param->u.wpa_key.seq_len)) {
+			spin_lock_irq(&pDevice->lock);
+			return -EINVAL;
+		}
 	}
 	spin_lock_irq(&pDevice->lock);
 
 	if (param->u.wpa_key.seq_len > 0) {
 		for (ii = 0 ; ii < param->u.wpa_key.seq_len ; ii++) {
-		     if (ii < 4)
-			    LODWORD(KeyRSC) |= (abySeq[ii] << (ii * 8));
-			 else
-			    HIDWORD(KeyRSC) |= (abySeq[ii] << ((ii-4) * 8));
-	         //KeyRSC |= (abySeq[ii] << (ii * 8));
+			if (ii < 4)
+				LODWORD(KeyRSC) |= (abySeq[ii] << (ii * 8));
+			else
+				HIDWORD(KeyRSC) |= (abySeq[ii] << ((ii-4) * 8));
 		}
 		dwKeyIndex |= 1 << 29;
 	}
 
-    if (param->u.wpa_key.key_index >= MAX_GROUP_KEY) {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "return  dwKeyIndex > 3\n");
-        return -EINVAL;
-    }
+	if (param->u.wpa_key.key_index >= MAX_GROUP_KEY) {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "return  dwKeyIndex > 3\n");
+		return -EINVAL;
+	}
 
 	if (param->u.wpa_key.alg_name == WPA_ALG_TKIP) {
-        pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
-    }
+		pDevice->eEncryptionStatus = Ndis802_11Encryption2Enabled;
+	}
 
 	if (param->u.wpa_key.alg_name == WPA_ALG_CCMP) {
-        pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
-    }
+		pDevice->eEncryptionStatus = Ndis802_11Encryption3Enabled;
+	}
 
 	if (param->u.wpa_key.set_tx)
 		dwKeyIndex |= (1 << 31);
 
 
-    if (pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled)
-        byKeyDecMode = KEY_CTL_CCMP;
-    else if (pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled)
-        byKeyDecMode = KEY_CTL_TKIP;
-    else
-        byKeyDecMode = KEY_CTL_WEP;
-
-    // Fix HCT test that set 256 bits KEY and Ndis802_11Encryption3Enabled
-    if (pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled) {
-        if (param->u.wpa_key.key_len == MAX_KEY_LEN)
-            byKeyDecMode = KEY_CTL_TKIP;
-        else if (param->u.wpa_key.key_len == WLAN_WEP40_KEYLEN)
-            byKeyDecMode = KEY_CTL_WEP;
-        else if (param->u.wpa_key.key_len == WLAN_WEP104_KEYLEN)
-            byKeyDecMode = KEY_CTL_WEP;
-    } else if (pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled) {
-        if (param->u.wpa_key.key_len == WLAN_WEP40_KEYLEN)
-            byKeyDecMode = KEY_CTL_WEP;
-        else if (param->u.wpa_key.key_len == WLAN_WEP104_KEYLEN)
-            byKeyDecMode = KEY_CTL_WEP;
-    }
-
-    // Check TKIP key length
-    if ((byKeyDecMode == KEY_CTL_TKIP) &&
-        (param->u.wpa_key.key_len != MAX_KEY_LEN)) {
-        // TKIP Key must be 256 bits
-        //DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA - TKIP Key must be 256 bits\n"));
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "return- TKIP Key must be 256 bits!\n");
-        return -EINVAL;
-    }
-    // Check AES key length
-    if ((byKeyDecMode == KEY_CTL_CCMP) &&
-        (param->u.wpa_key.key_len != AES_KEY_LEN)) {
-        // AES Key must be 128 bits
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "return - AES Key must be 128 bits\n");
-        return -EINVAL;
-    }
+	if (pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled)
+		byKeyDecMode = KEY_CTL_CCMP;
+	else if (pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled)
+		byKeyDecMode = KEY_CTL_TKIP;
+	else
+		byKeyDecMode = KEY_CTL_WEP;
+
+	// Fix HCT test that set 256 bits KEY and Ndis802_11Encryption3Enabled
+	if (pDevice->eEncryptionStatus == Ndis802_11Encryption3Enabled) {
+		if (param->u.wpa_key.key_len == MAX_KEY_LEN)
+			byKeyDecMode = KEY_CTL_TKIP;
+		else if (param->u.wpa_key.key_len == WLAN_WEP40_KEYLEN)
+			byKeyDecMode = KEY_CTL_WEP;
+		else if (param->u.wpa_key.key_len == WLAN_WEP104_KEYLEN)
+			byKeyDecMode = KEY_CTL_WEP;
+	} else if (pDevice->eEncryptionStatus == Ndis802_11Encryption2Enabled) {
+		if (param->u.wpa_key.key_len == WLAN_WEP40_KEYLEN)
+			byKeyDecMode = KEY_CTL_WEP;
+		else if (param->u.wpa_key.key_len == WLAN_WEP104_KEYLEN)
+			byKeyDecMode = KEY_CTL_WEP;
+	}
 
-    if (is_broadcast_ether_addr(&param->addr[0]) || (param->addr == NULL)) {
-	/* if broadcast, set the key as every key entry's group key */
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Groupe Key Assign.\n");
-
-        if ((KeybSetAllGroupKey(pDevice,
-                            &(pDevice->sKey),
-                            dwKeyIndex,
-                            param->u.wpa_key.key_len,
-                            (PQWORD) &(KeyRSC),
-                            (PBYTE)abyKey,
-                            byKeyDecMode
-                            ) == TRUE) &&
-            (KeybSetDefaultKey(pDevice,
-                            &(pDevice->sKey),
-                            dwKeyIndex,
-                            param->u.wpa_key.key_len,
-                            (PQWORD) &(KeyRSC),
-                            (PBYTE)abyKey,
-                            byKeyDecMode
-                            ) == TRUE) ) {
-             DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "GROUP Key Assign.\n");
-
-        } else {
-            //DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA -KeybSetDefaultKey Fail.0\n"));
-            return -EINVAL;
-        }
-
-    } else {
-        DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key Assign.\n");
-        // BSSID not 0xffffffffffff
-        // Pairwise Key can't be WEP
-        if (byKeyDecMode == KEY_CTL_WEP) {
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key can't be WEP\n");
-            return -EINVAL;
-        }
-
-        dwKeyIndex |= (1 << 30); // set pairwise key
-        if (pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) {
-            //DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA - WMAC_CONFIG_IBSS_STA\n"));
-            return -EINVAL;
-        }
-        if (KeybSetKey(pDevice,
-                       &(pDevice->sKey),
-                       &param->addr[0],
-                       dwKeyIndex,
-                       param->u.wpa_key.key_len,
-                       (PQWORD) &(KeyRSC),
-                       (PBYTE)abyKey,
-                        byKeyDecMode
-                       ) == TRUE) {
-            DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key Set\n");
-
-        } else {
-            // Key Table Full
-	    if (!compare_ether_addr(&param->addr[0], pDevice->abyBSSID)) {
-                //DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA -Key Table Full.2\n"));
-                return -EINVAL;
-
-            } else {
-                // Save Key and configure just before associate/reassociate to BSSID
-                // we do not implement now
-                return -EINVAL;
-            }
-        }
-    } // BSSID not 0xffffffffffff
-    if ((ret == 0) && ((param->u.wpa_key.set_tx) != 0)) {
-        pDevice->byKeyIndex = (BYTE)param->u.wpa_key.key_index;
-        pDevice->bTransmitKey = TRUE;
+	// Check TKIP key length
+	if ((byKeyDecMode == KEY_CTL_TKIP) &&
+		(param->u.wpa_key.key_len != MAX_KEY_LEN)) {
+		// TKIP Key must be 256 bits
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "return- TKIP Key must be 256 bits!\n");
+		return -EINVAL;
     }
-    pDevice->bEncryptionEnable = TRUE;
+	// Check AES key length
+	if ((byKeyDecMode == KEY_CTL_CCMP) &&
+		(param->u.wpa_key.key_len != AES_KEY_LEN)) {
+		// AES Key must be 128 bits
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "return - AES Key must be 128 bits\n");
+		return -EINVAL;
+	}
 
-/*
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " key=%x-%x-%x-%x-%x-xxxxx \n",
-               pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[byKeyIndex][0],
-               pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[byKeyIndex][1],
-               pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[byKeyIndex][2],
-               pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[byKeyIndex][3],
-               pMgmt->sNodeDBTable[iNodeIndex].abyWepKey[byKeyIndex][4]
-              );
-*/
+	if (is_broadcast_ether_addr(&param->addr[0]) || (param->addr == NULL)) {
+		/* if broadcast, set the key as every key entry's group key */
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Groupe Key Assign.\n");
+
+		if ((KeybSetAllGroupKey(pDevice, &(pDevice->sKey), dwKeyIndex,
+							param->u.wpa_key.key_len,
+							(PQWORD) &(KeyRSC),
+							(PBYTE)abyKey,
+							byKeyDecMode
+					) == TRUE) &&
+			(KeybSetDefaultKey(pDevice,
+					&(pDevice->sKey),
+					dwKeyIndex,
+					param->u.wpa_key.key_len,
+					(PQWORD) &(KeyRSC),
+					(PBYTE)abyKey,
+					byKeyDecMode
+				) == TRUE) ) {
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "GROUP Key Assign.\n");
+		} else {
+			return -EINVAL;
+		}
+	} else {
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key Assign.\n");
+		// BSSID not 0xffffffffffff
+		// Pairwise Key can't be WEP
+		if (byKeyDecMode == KEY_CTL_WEP) {
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key can't be WEP\n");
+			return -EINVAL;
+		}
+		dwKeyIndex |= (1 << 30); // set pairwise key
+		if (pMgmt->eConfigMode == WMAC_CONFIG_IBSS_STA) {
+			//DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA - WMAC_CONFIG_IBSS_STA\n"));
+			return -EINVAL;
+		}
+		if (KeybSetKey(pDevice, &(pDevice->sKey), &param->addr[0],
+				dwKeyIndex, param->u.wpa_key.key_len,
+				(PQWORD) &(KeyRSC), (PBYTE)abyKey, byKeyDecMode
+				) == TRUE) {
+			DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Pairwise Key Set\n");
+		} else {
+			// Key Table Full
+			if (!compare_ether_addr(&param->addr[0], pDevice->abyBSSID)) {
+				//DBG_PRN_WLAN03(("return NDIS_STATUS_INVALID_DATA -Key Table Full.2\n"));
+				return -EINVAL;
+			} else {
+				// Save Key and configure just before associate/reassociate to BSSID
+				// we do not implement now
+				return -EINVAL;
+			}
+		}
+	} // BSSID not 0xffffffffffff
+	if ((ret == 0) && ((param->u.wpa_key.set_tx) != 0)) {
+		pDevice->byKeyIndex = (BYTE)param->u.wpa_key.key_index;
+		pDevice->bTransmitKey = TRUE;
+	}
+	pDevice->bEncryptionEnable = TRUE;
 
 	return ret;
-
 }
 
 
@@ -454,23 +412,17 @@ int wpa_set_wpadev(PSDevice pDevice, int val)
  * Return Value:
  *
  */
-
-static int wpa_set_wpa(PSDevice pDevice,
-				     struct viawget_wpa_param *param)
+static int wpa_set_wpa(PSDevice pDevice, struct viawget_wpa_param *param)
 {
-
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
+	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
 	int ret = 0;
 
-    pMgmt->eAuthenMode = WMAC_AUTH_OPEN;
-    pMgmt->bShareKeyAlgorithm = FALSE;
+	pMgmt->eAuthenMode = WMAC_AUTH_OPEN;
+	pMgmt->bShareKeyAlgorithm = FALSE;
 
-    return ret;
+	return ret;
 }
 
-
-
-
  /*
  * Description:
  *      set disassociate
@@ -484,25 +436,21 @@ static int wpa_set_wpa(PSDevice pDevice,
  * Return Value:
  *
  */
-
-static int wpa_set_disassociate(PSDevice pDevice,
-				     struct viawget_wpa_param *param)
+static int wpa_set_disassociate(PSDevice pDevice, struct viawget_wpa_param *param)
 {
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
+	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
 	int ret = 0;
 
-    spin_lock_irq(&pDevice->lock);
-    if (pDevice->bLinkPass) {
-        if (!memcmp(param->addr, pMgmt->abyCurrBSSID, 6))
-		bScheduleCommand((void *) pDevice, WLAN_CMD_DISASSOCIATE, NULL);
-    }
-    spin_unlock_irq(&pDevice->lock);
+	spin_lock_irq(&pDevice->lock);
+	if (pDevice->bLinkPass) {
+		if (!memcmp(param->addr, pMgmt->abyCurrBSSID, 6))
+			bScheduleCommand((void *)pDevice, WLAN_CMD_DISASSOCIATE, NULL);
+	}
+	spin_unlock_irq(&pDevice->lock);
 
-    return ret;
+	return ret;
 }
 
-
-
 /*
  * Description:
  *      enable scan process
@@ -516,36 +464,30 @@ static int wpa_set_disassociate(PSDevice pDevice,
  * Return Value:
  *
  */
-
-static int wpa_set_scan(PSDevice pDevice,
-			struct viawget_wpa_param *param)
+static int wpa_set_scan(PSDevice pDevice, struct viawget_wpa_param *param)
 {
 	int ret = 0;
 
 /**set ap_scan=1&&scan_ssid=1 under hidden ssid mode**/
-        PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-        PWLAN_IE_SSID       pItemSSID;
-printk("wpa_set_scan-->desired [ssid=%s,ssid_len=%d]\n",
-	     param->u.scan_req.ssid,param->u.scan_req.ssid_len);
+        PSMgmtObject pMgmt = &pDevice->sMgmtObj;
+        PWLAN_IE_SSID pItemSSID;
+	printk("wpa_set_scan-->desired [ssid=%s,ssid_len=%d]\n",
+		param->u.scan_req.ssid,param->u.scan_req.ssid_len);
 // Set the SSID
-memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
-pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
-pItemSSID->byElementID = WLAN_EID_SSID;
-memcpy(pItemSSID->abySSID, param->u.scan_req.ssid, param->u.scan_req.ssid_len);
-pItemSSID->len = param->u.scan_req.ssid_len;
-
-    spin_lock_irq(&pDevice->lock);
-    BSSvClearBSSList((void *) pDevice, pDevice->bLinkPass);
-    /* bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, NULL); */
-    bScheduleCommand((void *) pDevice,
-		     WLAN_CMD_BSSID_SCAN,
-		     pMgmt->abyDesireSSID);
-    spin_unlock_irq(&pDevice->lock);
-
-    return ret;
-}
+	memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
+	pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
+	pItemSSID->byElementID = WLAN_EID_SSID;
+	memcpy(pItemSSID->abySSID, param->u.scan_req.ssid, param->u.scan_req.ssid_len);
+	pItemSSID->len = param->u.scan_req.ssid_len;
 
+	spin_lock_irq(&pDevice->lock);
+	BSSvClearBSSList((void *) pDevice, pDevice->bLinkPass);
+	bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN,
+			pMgmt->abyDesireSSID);
+	spin_unlock_irq(&pDevice->lock);
 
+	return ret;
+}
 
 /*
  * Description:
@@ -560,19 +502,15 @@ pItemSSID->len = param->u.scan_req.ssid_len;
  * Return Value:
  *
  */
-
-static int wpa_get_bssid(PSDevice pDevice,
-				     struct viawget_wpa_param *param)
+static int wpa_get_bssid(PSDevice pDevice, struct viawget_wpa_param *param)
 {
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-	int ret = 0;
-	memcpy(param->u.wpa_associate.bssid, pMgmt->abyCurrBSSID , 6);
+    PSMgmtObject pMgmt = &pDevice->sMgmtObj;
+    int ret = 0;
+    memcpy(param->u.wpa_associate.bssid, pMgmt->abyCurrBSSID, 6);
 
     return ret;
-
 }
 
-
 /*
  * Description:
  *      get bssid
@@ -586,24 +524,20 @@ static int wpa_get_bssid(PSDevice pDevice,
  * Return Value:
  *
  */
-
-static int wpa_get_ssid(PSDevice pDevice,
-				     struct viawget_wpa_param *param)
+static int wpa_get_ssid(PSDevice pDevice, struct viawget_wpa_param *param)
 {
-    PSMgmtObject        pMgmt = &(pDevice->sMgmtObj);
-	PWLAN_IE_SSID       pItemSSID;
+	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
+	PWLAN_IE_SSID pItemSSID;
 	int ret = 0;
 
-    pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
+	pItemSSID = (PWLAN_IE_SSID)pMgmt->abyCurrSSID;
 
-	memcpy(param->u.wpa_associate.ssid, pItemSSID->abySSID , pItemSSID->len);
+	memcpy(param->u.wpa_associate.ssid, pItemSSID->abySSID, pItemSSID->len);
 	param->u.wpa_associate.ssid_len = pItemSSID->len;
 
-    return ret;
+	return ret;
 }
 
-
-
 /*
  * Description:
  *      get scan results
@@ -617,135 +551,114 @@ static int wpa_get_ssid(PSDevice pDevice,
  * Return Value:
  *
  */
-
-static int wpa_get_scan(PSDevice pDevice,
-				     struct viawget_wpa_param *param)
+static int wpa_get_scan(PSDevice pDevice, struct viawget_wpa_param *param)
 {
 	struct viawget_scan_result *scan_buf;
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    PWLAN_IE_SSID   pItemSSID;
-    PKnownBSS pBSS;
-	PBYTE  pBuf;
+	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
+	PWLAN_IE_SSID pItemSSID;
+	PKnownBSS pBSS;
+	PBYTE pBuf;
 	int ret = 0;
 	u16 count = 0;
-	u16 ii, jj;
-	long ldBm;//James //add
+	u16 ii;
+	u16 jj;
+	long ldBm; //James //add
 
 //******mike:bubble sort by stronger RSSI*****//
+	PBYTE ptempBSS;
 
-    PBYTE ptempBSS;
-
+	ptempBSS = kmalloc(sizeof(KnownBSS), GFP_ATOMIC);
 
+	if (ptempBSS == NULL) {
+		printk("bubble sort kmalloc memory fail@@@\n");
+		ret = -ENOMEM;
+		return ret;
+	}
 
-    ptempBSS = kmalloc(sizeof(KnownBSS), (int)GFP_ATOMIC);
-
-    if (ptempBSS == NULL) {
-
-       printk("bubble sort kmalloc memory fail@@@\n");
-
-        ret = -ENOMEM;
-
-        return ret;
-
-    }
-
-    for (ii = 0; ii < MAX_BSS_NUM; ii++) {
-
-	for (jj = 0; jj < MAX_BSS_NUM - ii - 1; jj++) {
-
-		if ((pMgmt->sBSSList[jj].bActive != TRUE) ||
-
-                ((pMgmt->sBSSList[jj].uRSSI>pMgmt->sBSSList[jj+1].uRSSI) &&(pMgmt->sBSSList[jj+1].bActive!=FALSE))) {
-
-                 memcpy(ptempBSS,&pMgmt->sBSSList[jj],sizeof(KnownBSS));
-
-                 memcpy(&pMgmt->sBSSList[jj],&pMgmt->sBSSList[jj+1],sizeof(KnownBSS));
-
-                 memcpy(&pMgmt->sBSSList[jj+1],ptempBSS,sizeof(KnownBSS));
-
-              }
-
-         }
-
-    }
-
-  kfree(ptempBSS);
-
- // printk("bubble sort result:\n");
+	for (ii = 0; ii < MAX_BSS_NUM; ii++) {
+		for (jj = 0; jj < MAX_BSS_NUM - ii - 1; jj++) {
+			if ((pMgmt->sBSSList[jj].bActive != TRUE)
+				|| ((pMgmt->sBSSList[jj].uRSSI > pMgmt->sBSSList[jj + 1].uRSSI)
+					&& (pMgmt->sBSSList[jj + 1].bActive != FALSE))) {
+				memcpy(ptempBSS,&pMgmt->sBSSList[jj], sizeof(KnownBSS));
+				memcpy(&pMgmt->sBSSList[jj], &pMgmt->sBSSList[jj + 1],
+					sizeof(KnownBSS));
+				memcpy(&pMgmt->sBSSList[jj + 1], ptempBSS, sizeof(KnownBSS));
+			}
+		}
+	}
+	kfree(ptempBSS);
 
 	count = 0;
 	pBSS = &(pMgmt->sBSSList[0]);
-    for (ii = 0; ii < MAX_BSS_NUM; ii++) {
-        pBSS = &(pMgmt->sBSSList[ii]);
-        if (!pBSS->bActive)
-            continue;
-        count++;
-    }
+	for (ii = 0; ii < MAX_BSS_NUM; ii++) {
+		pBSS = &(pMgmt->sBSSList[ii]);
+		if (!pBSS->bActive)
+			continue;
+		count++;
+	}
 
-    pBuf = kcalloc(count, sizeof(struct viawget_scan_result), (int)GFP_ATOMIC);
+	pBuf = kcalloc(count, sizeof(struct viawget_scan_result), GFP_ATOMIC);
 
-    if (pBuf == NULL) {
-        ret = -ENOMEM;
-        return ret;
-    }
-    scan_buf = (struct viawget_scan_result *)pBuf;
+	if (pBuf == NULL) {
+		ret = -ENOMEM;
+		return ret;
+	}
+	scan_buf = (struct viawget_scan_result *)pBuf;
 	pBSS = &(pMgmt->sBSSList[0]);
-    for (ii = 0, jj = 0; ii < MAX_BSS_NUM ; ii++) {
-        pBSS = &(pMgmt->sBSSList[ii]);
-        if (pBSS->bActive) {
-            if (jj >= count)
-                break;
-            memcpy(scan_buf->bssid, pBSS->abyBSSID, WLAN_BSSID_LEN);
-            pItemSSID = (PWLAN_IE_SSID)pBSS->abySSID;
-   		    memcpy(scan_buf->ssid, pItemSSID->abySSID, pItemSSID->len);
-   		    scan_buf->ssid_len = pItemSSID->len;
-            scan_buf->freq = frequency_list[pBSS->uChannel-1];
-            scan_buf->caps = pBSS->wCapInfo;    //DavidWang for sharemode
-
-	        RFvRSSITodBm(pDevice, (BYTE)(pBSS->uRSSI), &ldBm);
-			if(-ldBm<50){
+	for (ii = 0, jj = 0; ii < MAX_BSS_NUM; ii++) {
+		pBSS = &(pMgmt->sBSSList[ii]);
+		if (pBSS->bActive) {
+			if (jj >= count)
+				break;
+			memcpy(scan_buf->bssid, pBSS->abyBSSID, WLAN_BSSID_LEN);
+			pItemSSID = (PWLAN_IE_SSID)pBSS->abySSID;
+			memcpy(scan_buf->ssid, pItemSSID->abySSID, pItemSSID->len);
+			scan_buf->ssid_len = pItemSSID->len;
+			scan_buf->freq = frequency_list[pBSS->uChannel-1];
+			scan_buf->caps = pBSS->wCapInfo; // DavidWang for sharemode
+
+			RFvRSSITodBm(pDevice, (BYTE)(pBSS->uRSSI), &ldBm);
+			if (-ldBm < 50)
 				scan_buf->qual = 100;
-			}else  if(-ldBm > 90) {
-				 scan_buf->qual = 0;
-			}else {
+			else if (-ldBm > 90)
+				scan_buf->qual = 0;
+			else
 				scan_buf->qual=(40-(-ldBm-50))*100/40;
-			}
 
 			//James
-            //scan_buf->caps = pBSS->wCapInfo;
-            //scan_buf->qual =
-            scan_buf->noise = 0;
-            scan_buf->level = ldBm;
-
-            //scan_buf->maxrate =
-            if (pBSS->wWPALen != 0) {
-                scan_buf->wpa_ie_len = pBSS->wWPALen;
-                memcpy(scan_buf->wpa_ie, pBSS->byWPAIE, pBSS->wWPALen);
-            }
-            if (pBSS->wRSNLen != 0) {
-                scan_buf->rsn_ie_len = pBSS->wRSNLen;
-                memcpy(scan_buf->rsn_ie, pBSS->byRSNIE, pBSS->wRSNLen);
-            }
-            scan_buf = (struct viawget_scan_result *)((PBYTE)scan_buf + sizeof(struct viawget_scan_result));
-            jj ++;
-        }
-    }
+			//scan_buf->caps = pBSS->wCapInfo;
+			//scan_buf->qual =
+			scan_buf->noise = 0;
+			scan_buf->level = ldBm;
+
+			//scan_buf->maxrate =
+			if (pBSS->wWPALen != 0) {
+				scan_buf->wpa_ie_len = pBSS->wWPALen;
+				memcpy(scan_buf->wpa_ie, pBSS->byWPAIE, pBSS->wWPALen);
+			}
+			if (pBSS->wRSNLen != 0) {
+				scan_buf->rsn_ie_len = pBSS->wRSNLen;
+				memcpy(scan_buf->rsn_ie, pBSS->byRSNIE, pBSS->wRSNLen);
+			}
+			scan_buf = (struct viawget_scan_result *)((PBYTE)scan_buf + sizeof(struct viawget_scan_result));
+			jj ++;
+		}
+	}
 
-    if (jj < count)
-        count = jj;
+	if (jj < count)
+		count = jj;
 
-    if (copy_to_user(param->u.scan_results.buf, pBuf, sizeof(struct viawget_scan_result) * count)) {
+	if (copy_to_user(param->u.scan_results.buf, pBuf, sizeof(struct viawget_scan_result) * count))
 		ret = -EFAULT;
-	}
+
 	param->u.scan_results.scan_count = count;
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " param->u.scan_results.scan_count = %d\n", count)
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " param->u.scan_results.scan_count = %d\n", count);
 
-    kfree(pBuf);
-    return ret;
+	kfree(pBuf);
+	return ret;
 }
 
-
-
 /*
  * Description:
  *      set associate with AP
@@ -759,25 +672,23 @@ static int wpa_get_scan(PSDevice pDevice,
  * Return Value:
  *
  */
-
-static int wpa_set_associate(PSDevice pDevice,
-				     struct viawget_wpa_param *param)
+static int wpa_set_associate(PSDevice pDevice, struct viawget_wpa_param *param)
 {
-    PSMgmtObject    pMgmt = &(pDevice->sMgmtObj);
-    PWLAN_IE_SSID   pItemSSID;
-    BYTE    abyNullAddr[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
-    BYTE    abyWPAIE[64];
-    int ret = 0;
-    BOOL   bwepEnabled=FALSE;
+	PSMgmtObject pMgmt = &pDevice->sMgmtObj;
+	PWLAN_IE_SSID pItemSSID;
+	BYTE abyNullAddr[] = {0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
+	BYTE abyWPAIE[64];
+	int ret = 0;
+	BOOL bwepEnabled=FALSE;
 
 	// set key type & algorithm
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pairwise_suite = %d\n", param->u.wpa_associate.pairwise_suite);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "group_suite = %d\n", param->u.wpa_associate.group_suite);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "key_mgmt_suite = %d\n", param->u.wpa_associate.key_mgmt_suite);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "auth_alg = %d\n", param->u.wpa_associate.auth_alg);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "mode = %d\n", param->u.wpa_associate.mode);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wpa_ie_len = %d\n", param->u.wpa_associate.wpa_ie_len);
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Roaming dBm = %d\n", param->u.wpa_associate.roam_dbm);  //Davidwang
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "pairwise_suite = %d\n", param->u.wpa_associate.pairwise_suite);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "group_suite = %d\n", param->u.wpa_associate.group_suite);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "key_mgmt_suite = %d\n", param->u.wpa_associate.key_mgmt_suite);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "auth_alg = %d\n", param->u.wpa_associate.auth_alg);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "mode = %d\n", param->u.wpa_associate.mode);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wpa_ie_len = %d\n", param->u.wpa_associate.wpa_ie_len);
+	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "Roaming dBm = %d\n", param->u.wpa_associate.roam_dbm); // Davidwang
 
 	if (param->u.wpa_associate.wpa_ie) {
 		if (param->u.wpa_associate.wpa_ie_len > sizeof(abyWPAIE))
@@ -789,25 +700,25 @@ static int wpa_set_associate(PSDevice pDevice,
 	}
 
 	if (param->u.wpa_associate.mode == 1)
-	    pMgmt->eConfigMode = WMAC_CONFIG_IBSS_STA;
+		pMgmt->eConfigMode = WMAC_CONFIG_IBSS_STA;
 	else
-	    pMgmt->eConfigMode = WMAC_CONFIG_ESS_STA;
+		pMgmt->eConfigMode = WMAC_CONFIG_ESS_STA;
 
 	// set bssid
-    if (memcmp(param->u.wpa_associate.bssid, &abyNullAddr[0], 6) != 0)
-        memcpy(pMgmt->abyDesireBSSID, param->u.wpa_associate.bssid, 6);
-    // set ssid
+	if (memcmp(param->u.wpa_associate.bssid, &abyNullAddr[0], 6) != 0)
+		memcpy(pMgmt->abyDesireBSSID, param->u.wpa_associate.bssid, 6);
+	// set ssid
 	memset(pMgmt->abyDesireSSID, 0, WLAN_IEHDR_LEN + WLAN_SSID_MAXLEN + 1);
-    pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
-    pItemSSID->byElementID = WLAN_EID_SSID;
+	pItemSSID = (PWLAN_IE_SSID)pMgmt->abyDesireSSID;
+	pItemSSID->byElementID = WLAN_EID_SSID;
 	pItemSSID->len = param->u.wpa_associate.ssid_len;
 	memcpy(pItemSSID->abySSID, param->u.wpa_associate.ssid, pItemSSID->len);
 
-    if (param->u.wpa_associate.wpa_ie_len == 0) {
-	    if (param->u.wpa_associate.auth_alg & AUTH_ALG_SHARED_KEY)
-            pMgmt->eAuthenMode = WMAC_AUTH_SHAREKEY;
-	    else
-            pMgmt->eAuthenMode = WMAC_AUTH_OPEN;
+	if (param->u.wpa_associate.wpa_ie_len == 0) {
+		if (param->u.wpa_associate.auth_alg & AUTH_ALG_SHARED_KEY)
+			pMgmt->eAuthenMode = WMAC_AUTH_SHAREKEY;
+		else
+			pMgmt->eAuthenMode = WMAC_AUTH_OPEN;
 	} else if (abyWPAIE[0] == RSN_INFO_ELEM) {
 		if (param->u.wpa_associate.key_mgmt_suite == KEY_MGMT_PSK)
 			pMgmt->eAuthenMode = WMAC_AUTH_WPA2PSK;
@@ -817,9 +728,9 @@ static int wpa_set_associate(PSDevice pDevice,
 		if (param->u.wpa_associate.key_mgmt_suite == KEY_MGMT_WPA_NONE)
 			pMgmt->eAuthenMode = WMAC_AUTH_WPANONE;
 		else if (param->u.wpa_associate.key_mgmt_suite == KEY_MGMT_PSK)
-		    pMgmt->eAuthenMode = WMAC_AUTH_WPAPSK;
+			pMgmt->eAuthenMode = WMAC_AUTH_WPAPSK;
 		else
-		    pMgmt->eAuthenMode = WMAC_AUTH_WPA;
+			pMgmt->eAuthenMode = WMAC_AUTH_WPA;
 	}
 
 	switch (param->u.wpa_associate.pairwise_suite) {
@@ -833,7 +744,6 @@ static int wpa_set_associate(PSDevice pDevice,
 	case CIPHER_WEP104:
 		pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
 		bwepEnabled = TRUE;
-	//	printk("****************wpa_set_associate:set CIPHER_WEP40_104\n");
 		break;
 	case CIPHER_NONE:
 		if (param->u.wpa_associate.group_suite == CIPHER_CCMP)
@@ -845,70 +755,64 @@ static int wpa_set_associate(PSDevice pDevice,
 		pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 	}
 
-           pMgmt->Roam_dbm = param->u.wpa_associate.roam_dbm;
-         // if ((pMgmt->Roam_dbm > 40)&&(pMgmt->Roam_dbm<80))
-         //    pDevice->bEnableRoaming = TRUE;
-
-	    if (pMgmt->eAuthenMode == WMAC_AUTH_SHAREKEY) {   //@wep-sharekey
-            pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
-            pMgmt->bShareKeyAlgorithm = TRUE;
-             }
-	    else if (pMgmt->eAuthenMode == WMAC_AUTH_OPEN) {
-	       if(bwepEnabled==TRUE) {                                                         //@open-wep
-                       pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
-	   	}
-	      else {                                                                                                 //@only open
-            pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
+	pMgmt->Roam_dbm = param->u.wpa_associate.roam_dbm;
+	if (pMgmt->eAuthenMode == WMAC_AUTH_SHAREKEY) { // @wep-sharekey
+		pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
+		pMgmt->bShareKeyAlgorithm = TRUE;
+	} else if (pMgmt->eAuthenMode == WMAC_AUTH_OPEN) {
+		if(bwepEnabled==TRUE) { //@open-wep
+			pDevice->eEncryptionStatus = Ndis802_11Encryption1Enabled;
+	   	} else {
+			// @only open
+			pDevice->eEncryptionStatus = Ndis802_11EncryptionDisabled;
 	   	}
-           }
-//mike save old encryption status
+	}
+	// mike save old encryption status
 	pDevice->eOldEncryptionStatus = pDevice->eEncryptionStatus;
 
-    if (pDevice->eEncryptionStatus !=  Ndis802_11EncryptionDisabled)
-        pDevice->bEncryptionEnable = TRUE;
-    else
-        pDevice->bEncryptionEnable = FALSE;
-
- if ((pMgmt->eAuthenMode == WMAC_AUTH_SHAREKEY) ||
-      ((pMgmt->eAuthenMode == WMAC_AUTH_OPEN) && (bwepEnabled==TRUE)))  {
- //mike re-comment:open-wep && sharekey-wep needn't do initial key!!
-
-     }
- else
-    KeyvInitTable(pDevice,&pDevice->sKey);
+	if (pDevice->eEncryptionStatus !=  Ndis802_11EncryptionDisabled)
+		pDevice->bEncryptionEnable = TRUE;
+	else
+		pDevice->bEncryptionEnable = FALSE;
 
-    spin_lock_irq(&pDevice->lock);
-    pDevice->bLinkPass = FALSE;
-    ControlvMaskByte(pDevice,MESSAGE_REQUEST_MACREG,MAC_REG_PAPEDELAY,LEDSTS_STS,LEDSTS_SLOW);
-    memset(pMgmt->abyCurrBSSID, 0, 6);
-    pMgmt->eCurrState = WMAC_STATE_IDLE;
-    netif_stop_queue(pDevice->dev);
+	if ((pMgmt->eAuthenMode == WMAC_AUTH_SHAREKEY) ||
+		((pMgmt->eAuthenMode == WMAC_AUTH_OPEN) && (bwepEnabled==TRUE)))  {
+		// mike re-comment:open-wep && sharekey-wep needn't do initial key!!
+	} else {
+		KeyvInitTable(pDevice,&pDevice->sKey);
+	}
 
-/*******search if ap_scan=2 ,which is associating request in hidden ssid mode ****/
-{
-   PKnownBSS       pCurr = NULL;
-    pCurr = BSSpSearchBSSList(pDevice,
-                              pMgmt->abyDesireBSSID,
-                              pMgmt->abyDesireSSID,
-                              pDevice->eConfigPHYMode
-                              );
-
-    if (pCurr == NULL){
-    printk("wpa_set_associate---->hidden mode site survey before associate.......\n");
-    bScheduleCommand((void *) pDevice,
-		     WLAN_CMD_BSSID_SCAN,
-		     pMgmt->abyDesireSSID);
-  }
-}
+	spin_lock_irq(&pDevice->lock);
+	pDevice->bLinkPass = FALSE;
+	ControlvMaskByte(pDevice, MESSAGE_REQUEST_MACREG, MAC_REG_PAPEDELAY, LEDSTS_STS, LEDSTS_SLOW);
+	memset(pMgmt->abyCurrBSSID, 0, 6);
+	pMgmt->eCurrState = WMAC_STATE_IDLE;
+	netif_stop_queue(pDevice->dev);
+
+/******* search if ap_scan=2, which is associating request in hidden ssid mode ****/
+	{
+		PKnownBSS pCurr = NULL;
+		pCurr = BSSpSearchBSSList(pDevice,
+					pMgmt->abyDesireBSSID,
+					pMgmt->abyDesireSSID,
+					pDevice->eConfigPHYMode
+			);
+
+		if (pCurr == NULL){
+			printk("wpa_set_associate---->hidden mode site survey before associate.......\n");
+			bScheduleCommand((void *)pDevice,
+					WLAN_CMD_BSSID_SCAN,
+					pMgmt->abyDesireSSID);
+		}
+	}
 /****************************************************************/
 
-    bScheduleCommand((void *) pDevice, WLAN_CMD_SSID, NULL);
-    spin_unlock_irq(&pDevice->lock);
+	bScheduleCommand((void *)pDevice, WLAN_CMD_SSID, NULL);
+	spin_unlock_irq(&pDevice->lock);
 
-    return ret;
+	return ret;
 }
 
-
 /*
  * Description:
  *      wpa_ioctl main function supported for wpa supplicant
@@ -922,7 +826,6 @@ static int wpa_set_associate(PSDevice pDevice,
  * Return Value:
  *
  */
-
 int wpa_ioctl(PSDevice pDevice, struct iw_point *p)
 {
 	struct viawget_wpa_param *param;
@@ -930,10 +833,10 @@ int wpa_ioctl(PSDevice pDevice, struct iw_point *p)
 	int wpa_ioctl = 0;
 
 	if (p->length < sizeof(struct viawget_wpa_param) ||
-	    p->length > VIAWGET_WPA_MAX_BUF_SIZE || !p->pointer)
+		p->length > VIAWGET_WPA_MAX_BUF_SIZE || !p->pointer)
 		return -EINVAL;
 
-	param = kmalloc((int)p->length, (int)GFP_KERNEL);
+	param = kmalloc((int)p->length, GFP_KERNEL);
 	if (param == NULL)
 		return -ENOMEM;
 
@@ -944,63 +847,62 @@ int wpa_ioctl(PSDevice pDevice, struct iw_point *p)
 
 	switch (param->cmd) {
 	case VIAWGET_SET_WPA:
-        ret = wpa_set_wpa(pDevice, param);
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_WPA \n");
+		ret = wpa_set_wpa(pDevice, param);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_WPA \n");
 		break;
 
 	case VIAWGET_SET_KEY:
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_KEY \n");
-	    spin_lock_irq(&pDevice->lock);
-        ret = wpa_set_keys(pDevice, param, FALSE);
-        spin_unlock_irq(&pDevice->lock);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_KEY \n");
+		spin_lock_irq(&pDevice->lock);
+		ret = wpa_set_keys(pDevice, param, FALSE);
+		spin_unlock_irq(&pDevice->lock);
 		break;
 
 	case VIAWGET_SET_SCAN:
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_SCAN \n");
-        ret = wpa_set_scan(pDevice, param);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_SCAN \n");
+		ret = wpa_set_scan(pDevice, param);
 		break;
 
 	case VIAWGET_GET_SCAN:
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_SCAN\n");
-        ret = wpa_get_scan(pDevice, param);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_SCAN\n");
+		ret = wpa_get_scan(pDevice, param);
 		wpa_ioctl = 1;
 		break;
 
 	case VIAWGET_GET_SSID:
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_SSID \n");
-        ret = wpa_get_ssid(pDevice, param);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_SSID \n");
+		ret = wpa_get_ssid(pDevice, param);
 		wpa_ioctl = 1;
 		break;
 
 	case VIAWGET_GET_BSSID:
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_BSSID \n");
-        ret = wpa_get_bssid(pDevice, param);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_GET_BSSID \n");
+		ret = wpa_get_bssid(pDevice, param);
 		wpa_ioctl = 1;
 		break;
 
 	case VIAWGET_SET_ASSOCIATE:
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_ASSOCIATE \n");
-        ret = wpa_set_associate(pDevice, param);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_ASSOCIATE \n");
+		ret = wpa_set_associate(pDevice, param);
 		break;
 
 	case VIAWGET_SET_DISASSOCIATE:
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DISASSOCIATE \n");
-        ret = wpa_set_disassociate(pDevice, param);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DISASSOCIATE \n");
+		ret = wpa_set_disassociate(pDevice, param);
 		break;
 
 	case VIAWGET_SET_DROP_UNENCRYPT:
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DROP_UNENCRYPT \n");
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DROP_UNENCRYPT \n");
 		break;
 
-    case VIAWGET_SET_DEAUTHENTICATE:
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DEAUTHENTICATE \n");
+	case VIAWGET_SET_DEAUTHENTICATE:
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_SET_DEAUTHENTICATE \n");
 		break;
 
 	default:
-	    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wpa_ioctl: unknown cmd=%d\n",
-		       param->cmd);
+		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "wpa_ioctl: unknown cmd=%d\n",
+			param->cmd);
 		return -EOPNOTSUPP;
-		break;
 	}
 
 	if ((ret == 0) && wpa_ioctl) {
@@ -1012,7 +914,5 @@ int wpa_ioctl(PSDevice pDevice, struct iw_point *p)
 
 out:
 	kfree(param);
-
 	return ret;
 }
-
-- 
1.7.8.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

