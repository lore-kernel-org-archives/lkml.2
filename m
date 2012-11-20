Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab2KTUQp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 15:16:45 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47017 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab2KTUQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 15:16:44 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/2] staging/rtl8187se: Use netdev_ printks in r8185b_init.c
Date: Wed, 21 Nov 2012 05:16:37 +0900
Message-Id: <1353442597-26859-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following warnings fixed.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/rtl8187se/r8185b_init.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 5c454fa..28611c2 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -223,9 +223,10 @@ static bool HwHSSIThreeWire(struct net_device *dev,
 		udelay(10);
 	}
 	if (TryCnt == TC_3W_POLL_MAX_TRY_CNT) {
-		printk(KERN_ERR "rtl8187se: HwThreeWire(): CmdReg:"
-		       " %#X RE|WE bits are not clear!!\n", u1bTmp);
-		return false;
+		netdev_err(dev,
+			   "HwThreeWire(): CmdReg: %#X RE|WE bits are not clear!!\n",
+			   u1bTmp);
+	return false;
 	}
 
 	/* RTL8187S HSSI Read/Write Function */
@@ -419,7 +420,7 @@ void ZEBRA_Config_85BASIC_HardCode(struct net_device *dev)
 
 	if (u4bRF23 == 0x818 && u4bRF24 == 0x70C) {
 		d_cut = 1;
-		printk(KERN_INFO "rtl8187se: card type changed from C- to D-cut\n");
+		netdev_info(dev, "card type changed from C- to D-cut\n");
 	}
 
 	/* Page0 : reg0-reg15 */
-- 
1.7.9.5

