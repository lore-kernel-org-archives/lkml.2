Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab2DPVUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 17:20:32 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21440 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755500Ab2DPVU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 17:20:27 -0400
Date: Mon, 16 Apr 2012 23:20:25 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, devel@driverdev.osuosl.org,
        Xi Wang <xi.wang@gmail.com>, Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Forest Bond <forest@alittletooquiet.net>
Subject: [PATCH][Trivial] staging: vt6656: Remove some redundant casts and
 parentheses + other style cleanups
Message-ID: <alpine.LNX.2.00.1204162314480.21898@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just a small/trivial cleanup patch. It makes the following
changes to drivers/staging/vt6656/ioctl.c:

1. Remove some redundant casts.

2. Remove some redundant parantheses.

3. Remove some whitespace between casts and variables.

4. Use a consistent style for whether or not switch statements have a
   empty line between break; and the next case:.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/ioctl.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vt6656/ioctl.c b/drivers/staging/vt6656/ioctl.c
index d59456c..8295335 100644
--- a/drivers/staging/vt6656/ioctl.c
+++ b/drivers/staging/vt6656/ioctl.c
@@ -101,7 +101,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 					 WLAN_CMD_BSSID_SCAN,
 					 abyScanSSID);
 		else
-			bScheduleCommand((void *) pDevice, WLAN_CMD_BSSID_SCAN, NULL);
+			bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN, NULL);
 
 		spin_unlock_irq(&pDevice->lock);
 		break;
@@ -150,6 +150,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			}
 		}
 		break;
+
 	case WLAN_CMD_BSS_JOIN:
 		if (copy_from_user(&sJoinCmd, pReq->data, sizeof(SCmdBSSJoin))) {
 			result = -EFAULT;
@@ -190,10 +191,9 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 		netif_stop_queue(pDevice->dev);
 		spin_lock_irq(&pDevice->lock);
 		pMgmt->eCurrState = WMAC_STATE_IDLE;
-		bScheduleCommand((void *) pDevice,
-				 WLAN_CMD_BSSID_SCAN,
+		bScheduleCommand((void *)pDevice, WLAN_CMD_BSSID_SCAN,
 				 pMgmt->abyDesireSSID);
-		bScheduleCommand((void *) pDevice, WLAN_CMD_SSID, NULL);
+		bScheduleCommand((void *)pDevice, WLAN_CMD_SSID, NULL);
 		spin_unlock_irq(&pDevice->lock);
 		break;
 
@@ -299,7 +299,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			result = -EINVAL;
 			break;
 		}
-		pList = (PSBSSIDList)kmalloc(sizeof(SBSSIDList) + (sList.uItem * sizeof(SBSSIDItem)), (int)GFP_ATOMIC);
+		pList = kmalloc(sizeof(SBSSIDList) + sList.uItem * sizeof(SBSSIDItem), GFP_ATOMIC);
 		if (pList == NULL) {
 			result = -ENOMEM;
 			break;
@@ -313,7 +313,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 				pList->sBSSIDList[ii].wBeaconInterval = pBSS->wBeaconInterval;
 				pList->sBSSIDList[ii].wCapInfo = pBSS->wCapInfo;
 				RFvRSSITodBm(pDevice, (BYTE)(pBSS->uRSSI), &ldBm);
-				pList->sBSSIDList[ii].uRSSI = (unsigned int) ldBm;
+				pList->sBSSIDList[ii].uRSSI = (unsigned int)ldBm;
 				/* pList->sBSSIDList[ii].uRSSI = pBSS->uRSSI; */
 				memcpy(pList->sBSSIDList[ii].abyBSSID, pBSS->abyBSSID, WLAN_BSSID_LEN);
 				pItemSSID = (PWLAN_IE_SSID)pBSS->abySSID;
@@ -335,7 +335,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			}
 		}
 
-		if (copy_to_user(pReq->data, pList, sizeof(SBSSIDList) + (sList.uItem * sizeof(SBSSIDItem)))) {
+		if (copy_to_user(pReq->data, pList, sizeof(SBSSIDList) + sList.uItem * sizeof(SBSSIDItem))) {
 			result = -EFAULT;
 			break;
 		}
@@ -356,6 +356,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			break;
 		}
 		break;
+
 	case WLAN_CMD_STOP_MAC:
 		DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "WLAN_CMD_STOP_MAC\n");
 		/* Todo xxxxxx */
@@ -565,7 +566,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			result = -ENOMEM;
 			break;
 		}
-		pNodeList = kmalloc(sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)), (int)GFP_ATOMIC);
+		pNodeList = kmalloc(sizeof(SNodeList) + sNodeList.uItem * sizeof(SNodeItem), GFP_ATOMIC);
 		if (pNodeList == NULL) {
 			result = -ENOMEM;
 			break;
-- 
1.7.10

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

