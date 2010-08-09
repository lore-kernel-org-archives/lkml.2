Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0HIGqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 02:46:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:39998 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab0HIGqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 02:46:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=DoKX1qJorxFLGeVIfrfFF7qLKAqctLIQY7u1E2jFKGQ5UFtnpQqLRBHpgIUmpqxC7r
         DsY0QSz2kTYPrfm5DclwrTFgth6SVmO0upE/9fmhSBR3cB+IDIIgSTzAhNKOD5DLpc5S
         tuO6M8k6Y26z6rQKkzvj0jHtjZ3faj7wd7DCU=
Subject: [PATCH 1/4] mfd: max8998 - fix incorrect kfree(i2c) in i2c_driver
	probe callback handler
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain
Date: Mon, 09 Aug 2010 14:48:16 +0800
Message-Id: <1281336496.18804.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The i2c_client received in probe() should not be kfree()'d.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/max8998.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index 0d68de2..73e6f5c 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -89,10 +89,8 @@ static int max8998_i2c_probe(struct i2c_client *i2c,
 	int ret = 0;
 
 	max8998 = kzalloc(sizeof(struct max8998_dev), GFP_KERNEL);
-	if (max8998 == NULL) {
-		kfree(i2c);
+	if (max8998 == NULL)
 		return -ENOMEM;
-	}
 
 	i2c_set_clientdata(i2c, max8998);
 	max8998->dev = &i2c->dev;
-- 
1.5.4.3



