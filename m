Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab0HIGuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 02:50:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47232 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754922Ab0HIGub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 02:50:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=MS79qC21hjE0PSvE3Hobx9lPRykfowkxtJG42ToH7J7PADQPdnVb5S6Zy/y2N8/zAD
         18VEUB1qqoIujEEgatAOhs51SKHErDvR1ApLdMjB75dqjGX7xtjfttpH/yOYt1BkJbfs
         U79mcN+f4UoLr8LOjM4jZjmgmylFFp66d//wU=
Subject: [PATCH 4/4] mfd: wm8994-core - fix incorrect kfree(i2c) in
	i2c_driver probe callback handler
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Mon, 09 Aug 2010 14:52:16 +0800
Message-Id: <1281336736.18804.7.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c_client received in probe() should not be kfree()'d.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/wm8994-core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/wm8994-core.c b/drivers/mfd/wm8994-core.c
index 69533f5..b3b2aaf 100644
--- a/drivers/mfd/wm8994-core.c
+++ b/drivers/mfd/wm8994-core.c
@@ -497,10 +497,8 @@ static int wm8994_i2c_probe(struct i2c_client *i2c,
 	struct wm8994 *wm8994;
 
 	wm8994 = kzalloc(sizeof(struct wm8994), GFP_KERNEL);
-	if (wm8994 == NULL) {
-		kfree(i2c);
+	if (wm8994 == NULL)
 		return -ENOMEM;
-	}
 
 	i2c_set_clientdata(i2c, wm8994);
 	wm8994->dev = &i2c->dev;
-- 
1.5.4.3



