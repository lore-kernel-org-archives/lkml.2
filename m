Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2FSQXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 12:23:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49832 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005Ab2FSQXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 12:23:39 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Marek Belisko <marek.belisko@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 3/3] staging/ft1000: remove usage of ret in ft1000_open
Date: Tue, 19 Jun 2012 21:53:32 +0530
Message-Id: <1340123012-8715-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove the ret and do a simple  "return ft1000_submit_rx_urb"

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 43b1d36..c1f4f13 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1178,7 +1178,6 @@ static int ft1000_open(struct net_device *dev)
 {
 	struct ft1000_info *pInfo = netdev_priv(dev);
 	struct timeval tv;
-	int ret;
 
 	DEBUG("ft1000_open is called for card %d\n", pInfo->CardNumber);
 
@@ -1194,9 +1193,7 @@ static int ft1000_open(struct net_device *dev)
 
 	netif_carrier_on(dev);
 
-	ret = ft1000_submit_rx_urb(pInfo);
-
-	return ret;
+	return ft1000_submit_rx_urb(pInfo);
 }
 
 //---------------------------------------------------------------------------
-- 
1.7.9.5

