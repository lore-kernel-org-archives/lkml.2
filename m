Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030Ab2GYNPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 09:15:00 -0400
Received: from mail.tpi.com ([70.99.223.143]:2452 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932731Ab2GYNO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 09:14:58 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Michael Krufky <mkrufky@kernellabs.com>,
        Eddi De Pieri <eddi@depieri.net>, linux-media@vger.kernel.org
Subject: [PATCH] xc5000: Add MODULE_FIRMWARE statements
Date: Wed, 25 Jul 2012 07:15:19 -0600
Message-Id: <1343222119-82246-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will make modinfo more useful with regard
to discovering necessary firmware files.

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Michael Krufky <mkrufky@kernellabs.com>
Cc: Eddi De Pieri <eddi@depieri.net>
Cc: linux-media@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/media/common/tuners/xc5000.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index dcca42c..4d33f86 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -210,13 +210,15 @@ struct xc5000_fw_cfg {
 	u16 size;
 };
 
+#define XC5000A_FIRMWARE "dvb-fe-xc5000-1.6.114.fw"
 static const struct xc5000_fw_cfg xc5000a_1_6_114 = {
-	.name = "dvb-fe-xc5000-1.6.114.fw",
+	.name = XC5000A_FIRMWARE,
 	.size = 12401,
 };
 
+#define XC5000C_FIRMWARE "dvb-fe-xc5000c-41.024.5.fw"
 static const struct xc5000_fw_cfg xc5000c_41_024_5 = {
-	.name = "dvb-fe-xc5000c-41.024.5.fw",
+	.name = XC5000C_FIRMWARE,
 	.size = 16497,
 };
 
@@ -1253,3 +1255,5 @@ EXPORT_SYMBOL(xc5000_attach);
 MODULE_AUTHOR("Steven Toth");
 MODULE_DESCRIPTION("Xceive xc5000 silicon tuner driver");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(XC5000A_FIRMWARE);
+MODULE_FIRMWARE(XC5000C_FIRMWARE);
-- 
1.7.9.5

