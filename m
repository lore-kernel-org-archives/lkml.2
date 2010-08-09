Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0HII7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 04:59:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:56856 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab0HII7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 04:59:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=rMoV62ewaxtEZdzaQ9m7Zz7xrloG/hpqiEw3OLNP8aRO3mVV9gSpEsm+00QlnW4JYD
         mwmpXo5EDbHJahS8dK1mMzIrmkVCkzYmeXnoV5+K82dYJfgF6wOXCq4NGBvaLzOP3IUf
         G/bbDmxu1eqmq9KOn6bZ27bX2YqJmiQ/0EqhM=
Subject: [PATCH RESEND again] regulator: lp3971 - remove unnecessary ret
	value checking in lp3971_i2c_write()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain
Date: Mon, 09 Aug 2010 17:01:21 +0800
Message-Id: <1281344481.22819.3.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_smbus_write_byte_data() returns zero or negative value,
therefore no need to check if ret is greater than zero or not.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/regulator/lp3971.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index 8ae3732..d4d9822 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -387,15 +387,9 @@ static int lp3971_i2c_read(struct i2c_client *i2c, char reg, int count,
 static int lp3971_i2c_write(struct i2c_client *i2c, char reg, int count,
 	const u16 *src)
 {
-	int ret;
-
 	if (count != 1)
 		return -EIO;
-	ret = i2c_smbus_write_byte_data(i2c, reg, *src);
-	if (ret >= 0)
-		return 0;
-
-	return ret;
+	return i2c_smbus_write_byte_data(i2c, reg, *src);
 }
 
 static u8 lp3971_reg_read(struct lp3971 *lp3971, u8 reg)
-- 
1.5.4.3



