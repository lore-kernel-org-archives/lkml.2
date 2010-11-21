Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757382Ab0KUCnT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:43:19 -0500
Received: from mail.perches.com ([173.55.12.10]:1736 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757142Ab0KUCkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:40:39 -0500
From: Joe Perches <joe@perches.com>
To: Simon Kelley <simon@thekelleys.org.uk>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 54/62] atmel: Use static const
Date: Sat, 20 Nov 2010 18:38:55 -0800
Message-Id: <d9d7c32e0b5e38388ba25facf1350caa4abe8f3b.1290305776.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using static const generally increases object text and decreases data size.
It also generally decreases overall object size.

   text	   data	    bss	    dec	    hex	filename
  42578	    720	   8528	  51826	   ca72	drivers/net/wireless/atmel.o.old
  42578	    720	   8528	  51826	   ca72	drivers/net/wireless/atmel.o.new

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/atmel.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/atmel.c b/drivers/net/wireless/atmel.c
index c8f7090..46e382e 100644
--- a/drivers/net/wireless/atmel.c
+++ b/drivers/net/wireless/atmel.c
@@ -1161,7 +1161,7 @@ static irqreturn_t service_interrupt(int irq, void *dev_id)
 	struct atmel_private *priv = netdev_priv(dev);
 	u8 isr;
 	int i = -1;
-	static u8 irq_order[] = {
+	static const u8 irq_order[] = {
 		ISR_OUT_OF_RANGE,
 		ISR_RxCOMPLETE,
 		ISR_TxCOMPLETE,
@@ -3771,7 +3771,9 @@ static int probe_atmel_card(struct net_device *dev)
 
 	if (rc) {
 		if (dev->dev_addr[0] == 0xFF) {
-			u8 default_mac[] = {0x00, 0x04, 0x25, 0x00, 0x00, 0x00};
+			static const u8 default_mac[] = {
+				0x00, 0x04, 0x25, 0x00, 0x00, 0x00
+			};
 			printk(KERN_ALERT "%s: *** Invalid MAC address. UPGRADE Firmware ****\n", dev->name);
 			memcpy(dev->dev_addr, default_mac, 6);
 		}
-- 
1.7.3.2.245.g03276.dirty

