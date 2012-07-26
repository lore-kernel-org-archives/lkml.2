Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753222Ab2GZVos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:44:48 -0400
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:18087 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab2GZVoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:44:46 -0400
Date: Thu, 26 Jul 2012 23:44:45 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Forest Bond <forest@alittletooquiet.net>
Subject: [PATCH 5/5] staging: vt6656: remove commented out stuff from
 hostap.c
In-Reply-To: <alpine.LNX.2.00.1207262335340.14949@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1207262341510.14949@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1207262335340.14949@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Git has the code if we ever need it, so instead of having chunks of 
commented out code clutter up the file  get rid of it.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/hostap.c | 45 +----------------------------------------
 1 file changed, 1 insertion(+), 44 deletions(-)

diff --git a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
index 1f7a860..f6b42e1 100644
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -54,7 +54,6 @@
 /*---------------------  Static Classes  ----------------------------*/
 
 /*---------------------  Static Variables  --------------------------*/
-//static int          msglevel                =MSG_LEVEL_DEBUG;
 static int msglevel = MSG_LEVEL_INFO;
 
 /*---------------------  Static Functions  --------------------------*/
@@ -233,7 +232,7 @@ static int hostap_add_sta(PSDevice pDevice,
 	pMgmt->sNodeDBTable[uNodeIndex].eNodeState = NODE_ASSOC;
 	pMgmt->sNodeDBTable[uNodeIndex].wCapInfo = param->u.add_sta.capability;
 // TODO listenInterval
-//    pMgmt->sNodeDBTable[uNodeIndex].wListenInterval = 1;
+//	pMgmt->sNodeDBTable[uNodeIndex].wListenInterval = 1;
 	pMgmt->sNodeDBTable[uNodeIndex].bPSEnable = FALSE;
 	pMgmt->sNodeDBTable[uNodeIndex].bySuppRate = param->u.add_sta.tx_supp_rates;
 
@@ -295,36 +294,6 @@ static int hostap_get_info_sta(PSDevice pDevice,
 
 /*
  * Description:
- *      reset txexec
- *
- * Parameters:
- *  In:
- *      pDevice   -
- *      param     -
- *  Out:
- *      TURE, FALSE
- *
- * Return Value:
- *
- */
-/*
-static int hostap_reset_txexc_sta(PSDevice pDevice,
-			struct viawget_hostapd_param *param)
-{
-	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
-	unsigned int uNodeIndex;
-
-	if (BSSbIsSTAInNodeDB(pDevice, param->sta_addr, &uNodeIndex)) {
-		pMgmt->sNodeDBTable[uNodeIndex].uTxAttempts = 0;
-	} else {
-		return -ENOENT;
-	}
-	return 0;
-}
-*/
-
-/*
- * Description:
  *      set station flag
  *
  * Parameters:
@@ -445,12 +414,6 @@ static int hostap_set_encryption(PSDevice pDevice,
 	WORD wKeyCtl = 0;
 
 	param->u.crypt.err = 0;
-/*
-	if (param_len !=
-		(int)((char *)param->u.crypt.key - (char *)param) +
-		param->u.crypt.key_len)
-		return -EINVAL;
-*/
 
 	if (param->u.crypt.alg > WPA_ALG_CCMP)
 		return -EINVAL;
@@ -738,12 +701,6 @@ int vt6656_hostap_ioctl(PSDevice pDevice, struct iw_point *p)
 		ret = hostap_get_info_sta(pDevice, param);
 		ap_ioctl = 1;
 		break;
-/*
-	case VIAWGET_HOSTAPD_RESET_TXEXC_STA:
-		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_RESET_TXEXC_STA \n");
-		ret = hostap_reset_txexc_sta(pDevice, param);
-		break;
-*/
 	case VIAWGET_HOSTAPD_SET_FLAGS_STA:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "VIAWGET_HOSTAPD_SET_FLAGS_STA \n");
 		ret = hostap_set_flags_sta(pDevice, param);
-- 
1.7.11.3


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

