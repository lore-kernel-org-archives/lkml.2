Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758791Ab0HEDld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 23:41:33 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:59555 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758684Ab0HEDla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 23:41:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=r35e5ozvdeun9res32gJh2IPxtsQBYeW2FOKRyVamxgdMZecDRMGxDZBQXsqjqeJc5
         i90FXqfvAdMYoNaVZxjblMy6nJO/7cfCqDtTnxgUQ/8QBACwInvKR2DSenSyOVl/ULks
         fcsLPDRn54XFO6pDI3z+Dxd/LxRDsB3eyWnT8=
Subject: [PATCH 2/2] lp3971: remove redundant checking for count in
	lp3971_i2c_read()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain
Date: Thu, 05 Aug 2010 11:42:53 +0800
Message-Id: <1280979773.1238.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We already check count value before calling i2c_smbus_read_byte_data(),
no need to check it again.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/lp3971.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/lp3971.c b/drivers/regulator/lp3971.c
index d4d9822..3bb82b6 100644
--- a/drivers/regulator/lp3971.c
+++ b/drivers/regulator/lp3971.c
@@ -377,7 +377,7 @@ static int lp3971_i2c_read(struct i2c_client *i2c, char reg, int count,
 	if (count != 1)
 		return -EIO;
 	ret = i2c_smbus_read_byte_data(i2c, reg);
-	if (ret < 0 || count != 1)
+	if (ret < 0)
 		return -EIO;
 
 	*dest = ret;
-- 
1.5.4.3



