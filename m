Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab0HIGta (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 02:49:30 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35520 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab0HIGt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 02:49:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=hNIDcburJ38fRR6vyXvGXZNH5XpO30wIZyimr/nPbJ6o4snLcXESezouR8bDtscdm2
         EYm0LH9OV78QgqU5/NGw5ZJlUH5Ye1gfchzb43DB+Bzy8EId6aj9ybq5igers5niCtx4
         nDa+RnXL1n42GLaU+GabPTubG8O8TRrKonHgQ=
Subject: [PATCH 3/4] mfd: wm831x-core - fix incorrect kfree(i2c) in
	i2c_driver probe callback handler
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Mon, 09 Aug 2010 14:51:15 +0800
Message-Id: <1281336675.18804.6.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c_client received in probe() should not be kfree()'d.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/wm831x-core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index cb94e7e..1e7aaaf 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -1757,10 +1757,8 @@ static int wm831x_i2c_probe(struct i2c_client *i2c,
 	struct wm831x *wm831x;
 
 	wm831x = kzalloc(sizeof(struct wm831x), GFP_KERNEL);
-	if (wm831x == NULL) {
-		kfree(i2c);
+	if (wm831x == NULL)
 		return -ENOMEM;
-	}
 
 	i2c_set_clientdata(i2c, wm831x);
 	wm831x->dev = &i2c->dev;
-- 
1.5.4.3



