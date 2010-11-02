Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130Ab0KBNuC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 09:50:02 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50829 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab0KBNtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 09:49:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YhR+ofQ0qXPLuGc/ZcR2IcRixSq2w6yLN0WkWBMgQJt35cyQ49VEcZxrJio4kBDE3l
         yVkHf/OLb1eEIlykbt9Yx51gSXLBfUkXWQZ/z0T7GbQKYO05Le7XQ+wGUertGX7d/698
         e8Eo3SpwA7JVGhhwHc8I3e/G5zjbmj6QQQ9Oc=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 4/4] staging: ft1000: Check return value.
Date: Tue,  2 Nov 2010 14:51:47 +0100
Message-Id: <1288705907-30725-4-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288705907-30725-1-git-send-email-marek.belisko@gmail.com>
References: <1288705907-30725-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function ft1000_submit_rx_urb() could fail so add checking
for return value.

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 30a8475..1fa1f81 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -1347,6 +1347,7 @@ static int ft1000_open (struct net_device *dev)
 {
 	struct ft1000_info *pInfo = (struct ft1000_info *)netdev_priv(dev);
     struct timeval tv; //mbelian
+	int ret;
 
     DEBUG("ft1000_open is called for card %d\n", pInfo->CardNumber);
     //DEBUG("ft1000_open: dev->addr=%x, dev->addr_len=%d\n", dev->addr, dev->addr_len);
@@ -1364,8 +1365,9 @@ static int ft1000_open (struct net_device *dev)
 
     netif_carrier_on(dev); //mbelian
 
-    ft1000_submit_rx_urb(pInfo);
-    return 0;
+	ret = ft1000_submit_rx_urb(pInfo);
+
+	return ret;
 }
 
 //---------------------------------------------------------------------------
-- 
1.7.1

