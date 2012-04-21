Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752338Ab2DUUEw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 16:04:52 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21381 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354Ab2DUUEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 16:04:31 -0400
Date: Sat, 21 Apr 2012 22:04:30 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: trivial@kernel.org, devel@driverdev.osuosl.org,
        Xi Wang <xi.wang@gmail.com>, Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>
Subject: [PATCH 1/3] staging: vt6656: Remove redundant casts from ioctl.c
In-Reply-To: <alpine.LNX.2.00.1204212156260.25551@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204212202090.25551@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204212156260.25551@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove some unneeded explicit casts from
drivers/staging/vt6656/ioctl.c

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/ioctl.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/vt6656/ioctl.c b/drivers/staging/vt6656/ioctl.c
index d59456c..8a918e9 100644
--- a/drivers/staging/vt6656/ioctl.c
+++ b/drivers/staging/vt6656/ioctl.c
@@ -90,18 +90,17 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 		spin_lock_irq(&pDevice->lock);
 
 		if (memcmp(pMgmt->abyCurrBSSID, &abyNullAddr[0], 6) == 0)
-			BSSvClearBSSList((void *)pDevice, FALSE);
+			BSSvClearBSSList(pDevice, FALSE);
 		else
-			BSSvClearBSSList((void *)pDevice, pDevice->bLinkPass);
+			BSSvClearBSSList(pDevice, pDevice->bLinkPass);
 
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_BSS_SCAN..begin\n");
 
 		if (pItemSSID->len != 0)
-			bScheduleCommand((void *)pDevice,
-					 WLAN_CMD_BSSID_SCAN,
+			bScheduleCommand(pDevice, WLAN_CMD_BSSID_SCAN,
 					 abyScanSSID);
 		else
-			bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, NULL);
+			bScheduleCommand(pDevice, WLAN_CMD_BSSID_SCAN, NULL);
 
 		spin_unlock_irq(&pDevice->lock);
 		break;
@@ -190,10 +189,9 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 		netif_stop_queue(pDevice->dev);
 		spin_lock_irq(&pDevice->lock);
 		pMgmt->eCurrState = WMAC_STATE_IDLE;
-		bScheduleCommand((void *) pDevice,
-				 WLAN_CMD_BSSID_SCAN,
+		bScheduleCommand(pDevice, WLAN_CMD_BSSID_SCAN,
 				 pMgmt->abyDesireSSID);
-		bScheduleCommand((void *) pDevice, WLAN_CMD_SSID, NULL);
+		bScheduleCommand(pDevice, WLAN_CMD_SSID, NULL);
 		spin_unlock_irq(&pDevice->lock);
 		break;
 
@@ -299,7 +297,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			result = -EINVAL;
 			break;
 		}
-		pList = (PSBSSIDList)kmalloc(sizeof(SBSSIDList) + (sList.uItem * sizeof(SBSSIDItem)), (int)GFP_ATOMIC);
+		pList = kmalloc(sizeof(SBSSIDList) + (sList.uItem * sizeof(SBSSIDItem)), GFP_ATOMIC);
 		if (pList == NULL) {
 			result = -ENOMEM;
 			break;
@@ -534,7 +532,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 
 		netif_stop_queue(pDevice->dev);
 		spin_lock_irq(&pDevice->lock);
-		bScheduleCommand((void *)pDevice, WLAN_CMD_RUN_AP, NULL);
+		bScheduleCommand(pDevice, WLAN_CMD_RUN_AP, NULL);
 		spin_unlock_irq(&pDevice->lock);
 		break;
 
@@ -565,7 +563,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			result = -ENOMEM;
 			break;
 		}
-		pNodeList = kmalloc(sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)), (int)GFP_ATOMIC);
+		pNodeList = kmalloc(sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)), GFP_ATOMIC);
 		if (pNodeList == NULL) {
 			result = -ENOMEM;
 			break;
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

