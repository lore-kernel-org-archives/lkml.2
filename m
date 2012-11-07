Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189Ab2KGTYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 14:24:13 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:43354 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2KGTYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 14:24:11 -0500
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Devendra Naga <develkernel412222@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH] Staging/media: Use dev_ printks in cxd2099/cxd2099.h
Date: Thu,  8 Nov 2012 04:24:04 +0900
Message-Id: <1352316245-8009-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warning.
- WARNING: Prefer netdev_warn(netdev, ... then dev_warn(dev, ... then pr_warn(...  to printk(KERN_WARNING ...

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/media/cxd2099/cxd2099.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.h b/drivers/staging/media/cxd2099/cxd2099.h
index 19c588a..0eb607c 100644
--- a/drivers/staging/media/cxd2099/cxd2099.h
+++ b/drivers/staging/media/cxd2099/cxd2099.h
@@ -43,7 +43,7 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
 static inline struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
 					void *priv, struct i2c_adapter *i2c)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	dev_warn(&i2c->dev, "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
 }
 #endif
-- 
1.7.9.5

