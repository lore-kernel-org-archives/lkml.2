Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab0HIGsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 02:48:01 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53472 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab0HIGsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 02:48:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=os8fCF6qb3P6ST2+5Nb0IMwZ28sFNov5q5Oen2Tld/o0uNBstFDY+b30vqmbEHtCR8
         Wq1y5k4/80xYusExHyYUdLgKM9jTxt3310DVzJnWhOuuaqgZD2GB/EXhTUWg8+MX5N9F
         z9NT6hzM90zZg2KgZ4SXeK0HWKZHHzVOLGTmQ=
Subject: [PATCH 2/4] mfd: tps6507x - fix incorrect kfree(i2c) in i2c_driver
	probe callback handler
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Todd Fischer <todd.fischer@ridgerun.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Mon, 09 Aug 2010 14:49:46 +0800
Message-Id: <1281336586.18804.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c_client received in probe() should not be kfree()'d.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/tps6507x.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/tps6507x.c b/drivers/mfd/tps6507x.c
index d859dff..fc01976 100644
--- a/drivers/mfd/tps6507x.c
+++ b/drivers/mfd/tps6507x.c
@@ -89,10 +89,8 @@ static int tps6507x_i2c_probe(struct i2c_client *i2c,
 	int ret = 0;
 
 	tps6507x = kzalloc(sizeof(struct tps6507x_dev), GFP_KERNEL);
-	if (tps6507x == NULL) {
-		kfree(i2c);
+	if (tps6507x == NULL)
 		return -ENOMEM;
-	}
 
 	i2c_set_clientdata(i2c, tps6507x);
 	tps6507x->dev = &i2c->dev;
-- 
1.5.4.3



