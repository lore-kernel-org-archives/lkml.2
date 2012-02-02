Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754334Ab2BBIMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 03:12:24 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52059 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754048Ab2BBIMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 03:12:23 -0500
Message-ID: <1328170333.11502.1.camel@phoenix>
Subject: [PATCH 1/2] backlight: lp855x_bl: Checking platform data in
 lp855x_probe
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Purdie <rpurdie@rpsys.net>, "Milo(Woogyom) Kim" <milo.kim@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 02 Feb 2012 16:12:13 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The reset of the code assumes pdata is not NULL.
Add checking for pdata in lp855x_probe, this prevents NULL dereference if pdata
is NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/video/backlight/lp855x_bl.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/lp855x_bl.c b/drivers/video/backlight/lp855x_bl.c
index 8f628b8..5ab9ec8 100644
--- a/drivers/video/backlight/lp855x_bl.c
+++ b/drivers/video/backlight/lp855x_bl.c
@@ -230,9 +230,14 @@ static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 {
 	struct lp855x *lp;
 	struct lp855x_platform_data *pdata = cl->dev.platform_data;
-	enum lp855x_brightness_ctrl_mode mode = pdata->mode;
+	enum lp855x_brightness_ctrl_mode mode;
 	int ret;
 
+	if (!pdata) {
+		dev_err(&cl->dev, "no platform data supplied\n");
+		return -EINVAL;
+	}
+
 	if (!i2c_check_functionality(cl->adapter, I2C_FUNC_SMBUS_I2C_BLOCK))
 		return -EIO;
 
@@ -240,6 +245,7 @@ static int lp855x_probe(struct i2c_client *cl, const struct i2c_device_id *id)
 	if (!lp)
 		return -ENOMEM;
 
+	mode = pdata->mode;
 	lp->client = cl;
 	lp->dev = &cl->dev;
 	lp->pdata = pdata;
-- 
1.7.5.4



