Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab0KBNto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 09:49:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53736 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab0KBNtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 09:49:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PwkDZGcdlsgM1GdfGQtw74x4sNUbcm4EAfv5XLZHd8PGEY9+O98BvqdR7eo99P8zCG
         5esHBxLc9+1y6P9U5FFpBRxvLcOS0IK9Yusm56vYxbV3XcrVZyyOr7kUCwSdQ/CUhOE+
         tCXukjYigj8y8vbJN6tJVYlm86abJTwPEl9BA=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 1/4] staging: ft1000: Use specific error codes instead self defined.
Date: Tue,  2 Nov 2010 14:51:44 +0100
Message-Id: <1288705907-30725-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   27 +++++++++---------------
 1 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 90394e1..9bb5377 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1025,7 +1025,7 @@ static int ft1000_copy_down_pkt (struct net_device *netdev, u8 *packet, u16 len)
     {
 
         DEBUG("ft1000_copy_down_pkt::Card Not Ready\n");
-    	return STATUS_FAILURE;
+	return -ENODEV;
 
     }
 
@@ -1037,7 +1037,7 @@ static int ft1000_copy_down_pkt (struct net_device *netdev, u8 *packet, u16 len)
     {
         DEBUG("Error:ft1000_copy_down_pkt:Message Size Overflow!\n");
     	DEBUG("size = %d\n", count);
-    	return STATUS_FAILURE;
+	return -EINVAL;
     }
 
     if ( count % 4)
@@ -1080,25 +1080,18 @@ static int ft1000_copy_down_pkt (struct net_device *netdev, u8 *packet, u16 len)
     }*/
 
 
-    ret = usb_submit_urb(pFt1000Dev->tx_urb, GFP_ATOMIC);
-    if(ret)
-    {
+	ret = usb_submit_urb(pFt1000Dev->tx_urb, GFP_ATOMIC);
+	if (ret) {
 		DEBUG("ft1000 failed tx_urb %d\n", ret);
-
-		return STATUS_FAILURE;
-
-    }
-    else
-    {
-        //DEBUG("ft1000 sucess tx_urb %d\n", ret);
-
-        pInfo->stats.tx_packets++;
-        pInfo->stats.tx_bytes += (len+14);
-    }
+		return ret;
+	} else {
+		pInfo->stats.tx_packets++;
+		pInfo->stats.tx_bytes += (len+14);
+	}
 
     //DEBUG("ft1000_copy_down_pkt() exit\n");
 
-    return STATUS_SUCCESS;
+	return 0;
 }
 
 //---------------------------------------------------------------------------
-- 
1.7.1

