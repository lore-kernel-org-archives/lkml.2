Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985Ab2ECWXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 18:23:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51180 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758920Ab2ECWWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 18:22:38 -0400
From: mathieu.poirier@linaro.org
To: mchehab@infradead.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
        mathieu.poirier@linaro.org
Subject: [PATCH 5/6] dvb/drxd: stub out drxd_attach when not built
Date: Thu,  3 May 2012 16:22:26 -0600
Message-Id: <1336083747-3142-6-git-send-email-mathieu.poirier@linaro.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1336083747-3142-1-git-send-email-mathieu.poirier@linaro.org>
References: <1336083747-3142-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This avoids getting
drivers/media/video/em28xx/em28xx-dvb.c:721: \
                       undefined reference to `drxd_attach'

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/media/dvb/frontends/drxd.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxd.h b/drivers/media/dvb/frontends/drxd.h
index 3439873..216c8c3 100644
--- a/drivers/media/dvb/frontends/drxd.h
+++ b/drivers/media/dvb/frontends/drxd.h
@@ -51,9 +51,23 @@ struct drxd_config {
 	 s16(*osc_deviation) (void *priv, s16 dev, int flag);
 };
 
+#if defined(CONFIG_DVB_DRXD) || \
+			(defined(CONFIG_DVB_DRXD_MODULE) && defined(MODULE))
 extern
 struct dvb_frontend *drxd_attach(const struct drxd_config *config,
 				 void *priv, struct i2c_adapter *i2c,
 				 struct device *dev);
+#else
+static inline
+struct dvb_frontend *drxd_attach(const struct drxd_config *config,
+				 void *priv, struct i2c_adapter *i2c,
+				 struct device *dev)
+{
+	printk(KERN_INFO "%s: not probed - driver disabled by Kconfig\n",
+	       __func__);
+	return NULL;
+}
+#endif
+
 extern int drxd_config_i2c(struct dvb_frontend *, int);
 #endif
-- 
1.7.5.4

