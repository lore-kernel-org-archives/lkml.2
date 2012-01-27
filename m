Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab2A0Ezo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 23:55:44 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40661 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab2A0Ezk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:55:40 -0500
Message-ID: <1327640128.9868.1.camel@phoenix>
Subject: [PATCH] regulator: Add empty devm_regulator_bulk_get for
 !CONFIG_REGULATOR
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 27 Jan 2012 12:55:28 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes below build error if CONFIG_REGULATOR is disabled.

  CC      sound/soc/codecs/wm5100.o
sound/soc/codecs/wm5100.c: In function ‘wm5100_i2c_probe’:
sound/soc/codecs/wm5100.c:2462: error: implicit declaration of function ‘devm_regulator_bulk_get’
make[3]: *** [sound/soc/codecs/wm5100.o] Error 1
make[2]: *** [sound/soc/codecs] Error 2
make[1]: *** [sound/soc] Error 2
make: *** [sound] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 include/linux/regulator/consumer.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 35c4283..cef8f04 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -249,6 +249,12 @@ static inline int regulator_bulk_get(struct device *dev,
 	return 0;
 }
 
+static inline int devm_regulator_bulk_get(struct device *dev, int num_consumers,
+					  struct regulator_bulk_data *consumers)
+{
+	return 0;
+}
+
 static inline int regulator_bulk_enable(int num_consumers,
 					struct regulator_bulk_data *consumers)
 {
-- 
1.7.5.4



