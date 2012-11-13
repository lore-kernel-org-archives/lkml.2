Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab2KMOHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:07:32 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9848 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab2KMOHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:07:07 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 13 Nov 2012 06:07:03 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <broonie@opensource.wolfsonmicro.com>, <swarren@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V3 RESEND 4/4] mfd: tps65910: pass irq_domain when adding mfd sub devices
Date: Tue, 13 Nov 2012 19:33:59 +0530
Message-ID: <1352815439-26040-5-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1352815439-26040-1-git-send-email-ldewangan@nvidia.com>
References: <1352815439-26040-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When adding the sub device "tps65910-rtc", is it passed the
IO resource IRQ for the interrupt number. This interrupt needs
to map in the device irq domain. Pass the irq domain of device
in mfd_add_devices() so that proper irq mapping can be done when
adding the sub device RTC.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
- Remove older patch 4 and make this as 4th patch.
- Added reviwed by Mark as he already reviewed it.

 drivers/mfd/tps65910.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index d4d4eb5..ca37833 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -509,7 +509,8 @@ static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
 
 	ret = mfd_add_devices(tps65910->dev, -1,
 			      tps65910s, ARRAY_SIZE(tps65910s),
-			      NULL, 0, NULL);
+			      NULL, 0,
+			      regmap_irq_get_domain(tps65910->irq_data));
 	if (ret < 0) {
 		dev_err(&i2c->dev, "mfd_add_devices failed: %d\n", ret);
 		return ret;
-- 
1.7.1.1

