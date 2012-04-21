Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537Ab2DUUFS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 16:05:18 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:21410 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab2DUUEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 16:04:38 -0400
Date: Sat, 21 Apr 2012 22:04:37 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: trivial@kernel.org, devel@driverdev.osuosl.org,
        Xi Wang <xi.wang@gmail.com>, Joe Perches <joe@perches.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Forest Bond <forest@alittletooquiet.net>
Subject: [PATCH 2/3] staging: vt6656: remove redundant parentheses from
 ioctl.c
In-Reply-To: <alpine.LNX.2.00.1204212156260.25551@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1204212203030.25551@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204212156260.25551@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I seriously doubt that anyone is confused about the precedence rules
for "*" and "+" - remove redundant extra parentheses.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/staging/vt6656/ioctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6656/ioctl.c b/drivers/staging/vt6656/ioctl.c
index 8a918e9..deea69b 100644
--- a/drivers/staging/vt6656/ioctl.c
+++ b/drivers/staging/vt6656/ioctl.c
@@ -297,7 +297,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			result = -EINVAL;
 			break;
 		}
-		pList = kmalloc(sizeof(SBSSIDList) + (sList.uItem * sizeof(SBSSIDItem)), GFP_ATOMIC);
+		pList = kmalloc(sizeof(SBSSIDList) + sList.uItem * sizeof(SBSSIDItem), GFP_ATOMIC);
 		if (pList == NULL) {
 			result = -ENOMEM;
 			break;
@@ -333,7 +333,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			}
 		}
 
-		if (copy_to_user(pReq->data, pList, sizeof(SBSSIDList) + (sList.uItem * sizeof(SBSSIDItem)))) {
+		if (copy_to_user(pReq->data, pList, sizeof(SBSSIDList) + sList.uItem * sizeof(SBSSIDItem))) {
 			result = -EFAULT;
 			break;
 		}
@@ -563,7 +563,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 			result = -ENOMEM;
 			break;
 		}
-		pNodeList = kmalloc(sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)), GFP_ATOMIC);
+		pNodeList = kmalloc(sizeof(SNodeList) + sNodeList.uItem * sizeof(SNodeItem), GFP_ATOMIC);
 		if (pNodeList == NULL) {
 			result = -ENOMEM;
 			break;
@@ -598,7 +598,7 @@ int private_ioctl(PSDevice pDevice, struct ifreq *rq)
 					break;
 			}
 		}
-		if (copy_to_user(pReq->data, pNodeList, sizeof(SNodeList) + (sNodeList.uItem * sizeof(SNodeItem)))) {
+		if (copy_to_user(pReq->data, pNodeList, sizeof(SNodeList) + sNodeList.uItem * sizeof(SNodeItem))) {
 			kfree(pNodeList);
 			result = -EFAULT;
 			break;
-- 
1.7.10


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

