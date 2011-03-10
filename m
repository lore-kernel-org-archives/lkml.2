Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1CJKwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 05:52:21 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49636 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab1CJKwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 05:52:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=U/gzbadOTVpYRs6Rz2hxxrArXpm0GsjSVzzXsNJsxJYonY+0M4esuI0qbdpP587BpL
         G83bJwwTzhYVEW4e95V0MTTjl8GVe4Zr1FD0RfefPqjIYEZjwfjpcJwfbGRn7ApkM4XL
         5Gi5RdmI11YynT2xA6P9pW1DOES1eX9P9JvMs=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH v2 17/21] staging: ft1000: Fix coding style in ft1000_close function.
Date: Thu, 10 Mar 2011 11:51:31 +0100
Message-Id: <1299754295-8493-18-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
References: <1299754295-8493-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index b578630..8f38b08 100644
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

