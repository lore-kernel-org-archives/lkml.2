Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965Ab1D1ED1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 00:03:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41412 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1D1EDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 00:03:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=B4/PBgSyqp8rP7AO6ECILvvNNTNnjn+P+V6FCUeUW5+Dw807mXPu7+5tfmaE+AMrbH
         uvQAzYO9eAm9MyqdvX0VAxvk9EB7vNt8w4gfOMu/508+sgbI5WiN8cxV8/9czKMEN9c+
         Zp77BRd52mr5T/iHaXpSLoGQqXAFy5gzU6x6I=
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: haojian.zhuang@marvell.com, eric.y.miao@gmail.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, ben-linux@fluff.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: [PATCH 2/3] i2c: pxa: support hardware lock
Date: Thu, 28 Apr 2011 12:02:37 +0800
Message-Id: <1303963358-4652-2-git-send-email-haojian.zhuang@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <2011042801>
References: <2011042801>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Append hardware lock support since it's required by Marvell PXA910.

Signed-off-by: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>
---
 drivers/i2c/busses/i2c-pxa.c |    3 +++
 include/linux/i2c/pxa-i2c.h  |    3 +++
 2 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index cab529d..e9a5dd8 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -1120,6 +1120,9 @@ static int i2c_pxa_probe(struct platform_device *dev)
 
 	if (plat) {
 		i2c->adap.class = plat->class;
+		i2c->adap.hardware_lock = plat->hardware_lock;
+		i2c->adap.hardware_unlock = plat->hardware_unlock;
+		i2c->adap.hardware_trylock = plat->hardware_trylock;
 		i2c->use_pio = plat->use_pio;
 		i2c->fast_mode = plat->fast_mode;
 	}
diff --git a/include/linux/i2c/pxa-i2c.h b/include/linux/i2c/pxa-i2c.h
index 1a9f65e..eec9954 100644
--- a/include/linux/i2c/pxa-i2c.h
+++ b/include/linux/i2c/pxa-i2c.h
@@ -67,6 +67,9 @@ struct i2c_pxa_platform_data {
 	unsigned int		class;
 	unsigned int		use_pio :1;
 	unsigned int		fast_mode :1;
+	void			(*hardware_lock)(void);
+	void			(*hardware_unlock)(void);
+	int			(*hardware_trylock)(void);
 };
 
 extern void pxa_set_i2c_info(struct i2c_pxa_platform_data *info);
-- 
1.7.1

