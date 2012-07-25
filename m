Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab2GYQxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:53:36 -0400
Received: from mail.tpi.com ([70.99.223.143]:2673 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756519Ab2GYQxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:53:34 -0400
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Subject: [PATCH] lgs8gxx: Declare MODULE_FIRMWARE usage
Date: Wed, 25 Jul 2012 10:54:02 -0600
Message-Id: <1343235242-115805-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/media/dvb/frontends/lgs8gxx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb/frontends/lgs8gxx.c b/drivers/media/dvb/frontends/lgs8gxx.c
index 568363a..c2ea274 100644
--- a/drivers/media/dvb/frontends/lgs8gxx.c
+++ b/drivers/media/dvb/frontends/lgs8gxx.c
@@ -40,6 +40,8 @@
 static int debug;
 static int fake_signal_str = 1;
 
+#define LGS8GXX_FIRMWARE "lgs8g75.fw"
+
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Turn on/off frontend debugging (default:off).");
 
@@ -592,7 +594,7 @@ static int lgs8g75_init_data(struct lgs8gxx_state *priv)
 	int rc;
 	int i;
 
-	rc = request_firmware(&fw, "lgs8g75.fw", &priv->i2c->dev);
+	rc = request_firmware(&fw, LGS8GXX_FIRMWARE, &priv->i2c->dev);
 	if (rc)
 		return rc;
 
@@ -1070,3 +1072,4 @@ EXPORT_SYMBOL(lgs8gxx_attach);
 MODULE_DESCRIPTION("Legend Silicon LGS8913/LGS8GXX DMB-TH demodulator driver");
 MODULE_AUTHOR("David T. L. Wong <davidtlwong@gmail.com>");
 MODULE_LICENSE("GPL");
+MODULE_FIRMWARE(LGS8GXX_FIRMWARE);
-- 
1.7.9.5

