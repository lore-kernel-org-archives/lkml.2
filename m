Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab0JXUgH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 16:36:07 -0400
Received: from igloo.linux.gr ([62.1.205.36]:33390 "EHLO igloo.linux.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932698Ab0JXUgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 16:36:03 -0400
X-Hellug-MailScanner-From: serzan@hellug.gr
X-Hellug-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-2.9, required 5, autolearn=not spam, ALL_TRUSTED -1.00,
	BAYES_00 -1.90)
X-Hellug-MailScanner: Found to be clean
X-Hellug-MailScanner-ID: o9OKWI5D003670
From: Serafeim Zanikolas <sez@debian.org>
To: herton@mandriva.com.br, htl10@users.sourceforge.net,
        Larry.Finger@lwfinger.net, linville@tuxdriver.com, joe@perches.com,
        davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Serafeim Zanikolas <sez@debian.org>
Subject: [PATCH] drivers: rtl818x: request DMA-able memory
Date: Sun, 24 Oct 2010 22:32:07 +0200
Message-Id: <1287952327-9924-1-git-send-email-sez@debian.org>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Despite the indicated intention in comment, the kmalloc() call was not
explicitly requesting memory from ZONE_DMA.

Signed-off-by: Serafeim Zanikolas <sez@debian.org>
---
 drivers/net/wireless/rtl818x/rtl8187_dev.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8187_dev.c b/drivers/net/wireless/rtl818x/rtl8187_dev.c
index 38fa824..771794d 100644
--- a/drivers/net/wireless/rtl818x/rtl8187_dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8187_dev.c
@@ -1343,7 +1343,8 @@ static int __devinit rtl8187_probe(struct usb_interface *intf,
 	priv->is_rtl8187b = (id->driver_info == DEVICE_RTL8187B);
 
 	/* allocate "DMA aware" buffer for register accesses */
-	priv->io_dmabuf = kmalloc(sizeof(*priv->io_dmabuf), GFP_KERNEL);
+	priv->io_dmabuf = kmalloc(sizeof(*priv->io_dmabuf),
+				  GFP_DMA | GFP_KERNEL);
 	if (!priv->io_dmabuf) {
 		err = -ENOMEM;
 		goto err_free_dev;
-- 
1.7.1

