Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1FWF6E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 01:58:04 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37608 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab1FWF6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 01:58:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=Rsq3UjFaaYbdraQx/HJmnO7HgpfSRjBlU7aYnCQrZOesRkNw1S7SvtEmEiqj11y6Zu
         GEHmD8ekd/M4UWWKG2X5N7q3B4crCYOjAFi8zDOnwHvVFK9s+xSJKrn6FseR1W2Pt/q+
         hk7jkM281yUlkTYQ2ncfnTbG+d4uxT/FUnleQ=
Date: Thu, 23 Jun 2011 08:57:15 +0300
From: Dan Carpenter <error27@gmail.com>
To: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        open list <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: [patch] regulator/tps65912: storing error codes in u8
Message-ID: <20110623055715.GM14591@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_ctrl_reg() returns -EINVAL so the error handling won't work here
if reg is a u8.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/regulator/tps65912-regulator.c b/drivers/regulator/tps65912-regulator.c
index d2c6542..3a9313e 100644
--- a/drivers/regulator/tps65912-regulator.c
+++ b/drivers/regulator/tps65912-regulator.c
@@ -417,7 +417,7 @@ static int tps65912_reg_enable(struct regulator_dev *dev)
 	struct tps65912_reg *pmic = rdev_get_drvdata(dev);
 	struct tps65912 *mfd = pmic->mfd;
 	int id = rdev_get_id(dev);
-	u8 reg;
+	int reg;
 
 	if (id < TPS65912_REG_DCDC1 || id > TPS65912_REG_LDO10)
 		return -EINVAL;
