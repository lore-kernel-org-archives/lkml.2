Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab0JVA2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 20:28:21 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47655 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0JVA2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 20:28:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=A3xwYCtuIp5RoDpXEZ36GAGbBz/wKc219Sw7UaM2UcM9jLJksd0QXL8q12dLeEOO1H
         bR2PWwaVf5Tm/rdF2zIF8wkdHSJnIszCzu22bL+JQFNl99/QmzVnZIpy9l+wMD9VFFu3
         rboUrp8GzEH3tKwUCgOI0/pU2dIGouQxIqEL8=
Subject: [PATCH 1/2] mfd: Remove unneeded ret value checking
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Content-Type: text/plain
Date: Fri, 22 Oct 2010 08:30:26 +0800
Message-Id: <1287707426.27802.3.camel@mola>
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
 drivers/mfd/max8998.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index a720f41..06ddf74 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -110,8 +110,6 @@ int max8998_update_reg(struct i2c_client *i2c, u8 reg, u8 val, u8 mask)
 		u8 old_val = ret & 0xff;
 		u8 new_val = (val & mask) | (old_val & (~mask));
 		ret = i2c_smbus_write_byte_data(i2c, reg, new_val);
-		if (ret >= 0)
-			ret = 0;
 	}
 	mutex_unlock(&max8998->iolock);
 	return ret;
-- 
1.7.2



