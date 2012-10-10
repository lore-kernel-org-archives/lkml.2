Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab2JJRxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 13:53:43 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2383 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756593Ab2JJRxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 13:53:39 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 10 Oct 2012 10:42:39 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <gregkh@linuxfoundation.org>,
        <sameo@linux.intel.com>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH V2 5/5] mfd: tps65910: pass irq_domain when adding mfd sub devices
Date: Wed, 10 Oct 2012 22:49:05 +0530
Message-ID: <1349889545-21517-6-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1349889545-21517-1-git-send-email-ldewangan@nvidia.com>
References: <1349889545-21517-1-git-send-email-ldewangan@nvidia.com>
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
---
No change from V1.

 drivers/mfd/tps65910.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index d4d4eb5..4c4fc53 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -509,7 +509,8 @@ static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
 
 	ret = mfd_add_devices(tps65910->dev, -1,
 			      tps65910s, ARRAY_SIZE(tps65910s),
-			      NULL, 0, NULL);
+			      NULL, 0,
+			      regmap_irq_get_irq_domain(tps65910->irq_data));
 	if (ret < 0) {
 		dev_err(&i2c->dev, "mfd_add_devices failed: %d\n", ret);
 		return ret;
-- 
1.7.1.1

