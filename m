Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab1BWWqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 17:46:46 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12586 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab1BWWqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 17:46:44 -0500
Date: Wed, 23 Feb 2011 23:45:55 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Yong Shen <yong.shen@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>
Subject: [PATCH] regulator, mc13xxx: Remove pointless test for unsigned less
 than zero
Message-ID: <alpine.LNX.2.00.1102232341030.28678@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The variable 'val' is a 'unsigned int', so it can never be less than zero. 
This fact makes the "val < 0" part of the test done in BUG_ON() in 
mc13xxx_regulator_get_voltage() rather pointles since it can never have 
any effect.
This patch removes the pointless test.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 mc13xxx-regulator-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/mc13xxx-regulator-core.c b/drivers/regulator/mc13xxx-regulator-core.c
index f53d31b..2bb5de1 100644
--- a/drivers/regulator/mc13xxx-regulator-core.c
+++ b/drivers/regulator/mc13xxx-regulator-core.c
@@ -174,7 +174,7 @@ static int mc13xxx_regulator_get_voltage(struct regulator_dev *rdev)
 
 	dev_dbg(rdev_get_dev(rdev), "%s id: %d val: %d\n", __func__, id, val);
 
-	BUG_ON(val < 0 || val > mc13xxx_regulators[id].desc.n_voltages);
+	BUG_ON(val > mc13xxx_regulators[id].desc.n_voltages);
 
 	return mc13xxx_regulators[id].voltages[val];
 }


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

