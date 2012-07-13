Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab2GMUVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 16:21:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37429 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2GMUVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 16:21:16 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 1/3] staging/vt6656: coding style fix in BSSvSecondTxData
Date: Sat, 14 Jul 2012 02:06:07 +0545
Message-Id: <1342210867-9074-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this function seemed bit more coding style fix...

The following fixes:

remove spaces at start of line and use tabs
use space between if and (
give a space in a multiplication operation
use space after = and another variable/constant

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/vt6656/wcmd.c |   56 ++++++++++++++++++++---------------------
 1 file changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index 78ea121..cecfdb6 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -1273,32 +1273,32 @@ void vResetCommandTimer(void *hDeviceContext)
 
 void BSSvSecondTxData(void *hDeviceContext)
 {
-  PSDevice        pDevice = (PSDevice)hDeviceContext;
-  PSMgmtObject  pMgmt = &(pDevice->sMgmtObj);
-
-  pDevice->nTxDataTimeCout++;
-
-  if(pDevice->nTxDataTimeCout<4)     //don't tx data if timer less than 40s
-    {
-     // printk("mike:%s-->no data Tx not exceed the desired Time as %d\n",__FUNCTION__,
-	//  	(int)pDevice->nTxDataTimeCout);
-     pDevice->sTimerTxData.expires = RUN_AT(10*HZ);      //10s callback
-     add_timer(&pDevice->sTimerTxData);
-      return;
-    }
-
-  spin_lock_irq(&pDevice->lock);
-  //is wap_supplicant running successful OR only open && sharekey mode!
-  if(((pDevice->bLinkPass ==TRUE)&&(pMgmt->eAuthenMode < WMAC_AUTH_WPA)) ||  //open && sharekey linking
-      (pDevice->fWPA_Authened == TRUE)) {   //wpa linking
-        //   printk("mike:%s-->InSleep Tx Data Procedure\n",__FUNCTION__);
-	  pDevice->fTxDataInSleep = TRUE;
-	  PSbSendNullPacket(pDevice);      //send null packet
-	  pDevice->fTxDataInSleep = FALSE;
-  	}
-  spin_unlock_irq(&pDevice->lock);
-
-  pDevice->sTimerTxData.expires = RUN_AT(10*HZ);      //10s callback
-  add_timer(&pDevice->sTimerTxData);
-  return;
+	PSDevice pDevice = (PSDevice)hDeviceContext;
+	PSMgmtObject pMgmt = &(pDevice->sMgmtObj);
+
+	pDevice->nTxDataTimeCout++;
+
+	if (pDevice->nTxDataTimeCout < 4) {   //don't tx data if timer less than 40s
+		// printk("mike:%s-->no data Tx not exceed the desired Time as %d\n",__FUNCTION__,
+		//  	(int)pDevice->nTxDataTimeCout);
+		pDevice->sTimerTxData.expires = RUN_AT(10 * HZ);      //10s callback
+		add_timer(&pDevice->sTimerTxData);
+		return;
+	}
+
+	spin_lock_irq(&pDevice->lock);
+	//is wap_supplicant running successful OR only open && sharekey mode!
+	if (((pDevice->bLinkPass == TRUE) &&
+		(pMgmt->eAuthenMode < WMAC_AUTH_WPA)) ||  //open && sharekey linking
+		(pDevice->fWPA_Authened == TRUE)) {   //wpa linking
+		//   printk("mike:%s-->InSleep Tx Data Procedure\n",__FUNCTION__);
+		pDevice->fTxDataInSleep = TRUE;
+		PSbSendNullPacket(pDevice);      //send null packet
+		pDevice->fTxDataInSleep = FALSE;
+	}
+	spin_unlock_irq(&pDevice->lock);
+
+	pDevice->sTimerTxData.expires = RUN_AT(10 * HZ);      //10s callback
+	add_timer(&pDevice->sTimerTxData);
+	return;
 }
-- 
1.7.9.5

