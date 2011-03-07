Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab1CGIWS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:22:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49168 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab1CGIWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:22:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=J5ynZJTVprZ/wkH8N6hxZgEIe1JDyzqzkQrR4pIw8PB8NtLGR0+GV3hOvjhviRR2pH
         u44m7094vG4pso6vcQG5Oj51fVR9AD3ngBJxxkXWqqY7OMJ4Xiv4TmvhVYyZ032h7OQC
         F/7U9l8Oxf5OaJ3n7hbQNGsQRwfNDZXwPKc+8=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 17/21] staging: ft1000: Fix coding style in ft1000_close function.
Date: Mon,  7 Mar 2011 09:21:22 +0100
Message-Id: <1299486086-7325-18-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299486086-7325-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 0b2acec..a76e380 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1281,24 +1281,23 @@ static int ft1000_open(struct net_device *dev)
 int ft1000_close(struct net_device *net)
 {
 	struct ft1000_info *pInfo = netdev_priv(net);
-    struct ft1000_device *ft1000dev = pInfo->pFt1000Dev;
+	struct ft1000_device *ft1000dev = pInfo->pFt1000Dev;
 
-    //DEBUG ("ft1000_close: netdev->refcnt=%d\n", net->refcnt);
+	//DEBUG ("ft1000_close: netdev->refcnt=%d\n", net->refcnt);
 
-    ft1000dev->status |= FT1000_STATUS_CLOSING;
-    
-    //DEBUG("ft1000_close: calling usb_kill_urb \n");
+	ft1000dev->status |= FT1000_STATUS_CLOSING;
 
-    DEBUG("ft1000_close: pInfo=%p, ft1000dev=%p\n", pInfo, ft1000dev);
-    netif_carrier_off(net);//mbelian
-    netif_stop_queue(net);
-    //DEBUG("ft1000_close: netif_stop_queue called\n");
-    ft1000dev->status &= ~FT1000_STATUS_CLOSING;
+	//DEBUG("ft1000_close: calling usb_kill_urb \n");
 
-   pInfo->ProgConStat = 0xff; //mbelian
+	DEBUG("ft1000_close: pInfo=%p, ft1000dev=%p\n", pInfo, ft1000dev);
+	netif_carrier_off(net);	//mbelian
+	netif_stop_queue(net);
+	//DEBUG("ft1000_close: netif_stop_queue called\n");
+	ft1000dev->status &= ~FT1000_STATUS_CLOSING;
 
+	pInfo->ProgConStat = 0xff;	//mbelian
 
-    return 0;
+	return 0;
 }
 
 static struct net_device_stats *ft1000_netdev_stats(struct net_device *dev)
-- 
1.7.1

