Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1FGMjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 08:39:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45399 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab1FGMjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 08:39:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=OPp0HpV6JvCAl5j7tD9/b3aqnw+Hg4gaPXTEjMJEAR2ssTmRw/vcd4pLi95JNEFngT
         nprEB0ucLy/zxRCoeIQiF86itocLipqDO5hbyzbRa0ZlfXo6r/9G1H009LX3xUiNy24F
         e9KFOLRemB/wo1RipCc2mno2wPPzTRUZIg1+E=
Subject: [PATCH] staging iio: Replace kmalloc with local variable
From: anish <anish198519851985@gmail.com>
To: gregkh@suse.de, jic23@cam.ac.uk, manuel.stahl@iis.fraunhofer.de,
        lucas.demarchi@profusion.mobi
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Jun 2011 18:09:14 +0530
Message-ID: <1307450354.1516.23.camel@anish-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: anish kumar <anish198519851985@gmail.com>

replaced kmalloc with local variable as I2C(in this case) doesn't require
kmalloc memory it can do with stack memory.

Signed-off-by: anish kumar <anish198519851985@gmail.com>
---
 drivers/staging/iio/adc/max1363_core.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/iio/adc/max1363_core.c b/drivers/staging/iio/adc/max1363_core.c
index 1037087..9462230 100644
--- a/drivers/staging/iio/adc/max1363_core.c
+++ b/drivers/staging/iio/adc/max1363_core.c
@@ -207,15 +207,12 @@ static int max1363_write_basic_config(struct i2c_client *client,
 				      unsigned char d2)
 {
 	int ret;
-	u8 *tx_buf = kmalloc(2, GFP_KERNEL);
+	u8 tx_buf[2];
 
-	if (!tx_buf)
-		return -ENOMEM;
 	tx_buf[0] = d1;
 	tx_buf[1] = d2;
 
 	ret = i2c_master_send(client, tx_buf, 2);
-	kfree(tx_buf);
 
 	return (ret > 0) ? 0 : ret;
 }
-- 
1.7.0.4


