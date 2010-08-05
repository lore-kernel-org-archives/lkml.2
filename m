Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758793Ab0HEDjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 23:39:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62209 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758684Ab0HEDjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 23:39:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Hv7ibOdkTFUUq+y4f2U0M4IHidiCw8/BImayHDtyLnhPVdu6eNwHlmkT6Db4rDmhAi
         +jkOwepyjojfN2x29ToWnEsf+Gt8zxtGvzexsOF690jY2PIgoJQXGjZGuE0kFV0hNXpW
         celGYIyXkIfOJOj0xkTO0DNBvxTRRiwzeKYBU=
Subject: [PATCH 1/2] lp3971: remove unnecessary ret value checking in
	lp3971_i2c_write()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain
Date: Thu, 05 Aug 2010 11:40:38 +0800
Message-Id: <1280979638.1238.2.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i2c_smbus_write_byte_data() returns zero or negative value,
therefore no need to check if ret is greater than zero or not.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
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



