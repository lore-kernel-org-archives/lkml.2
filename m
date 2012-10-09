Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab2JIMDK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:03:10 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:7543 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab2JIMC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:02:56 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 09 Oct 2012 04:52:04 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <broonie@opensource.wolfsonmicro.com>, <gregkh@linuxfoundation.org>,
        <sameo@linux.intel.com>
CC: <swarren@nvidia.com>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH 5/5] mfd: tps65910: pass irq_domain when adding mfd sub devices
Date: Tue, 9 Oct 2012 16:58:36 +0530
Message-ID: <1349782116-9757-6-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
In-Reply-To: <1349782116-9757-1-git-send-email-ldewangan@nvidia.com>
References: <1349782116-9757-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When adding the sub device "tps65910-rtc", is it passed the
IO resource IRQ for the interrupt number.
This interrupt needs to map in the device irq domain. Pass
the irq domain of device in mfd_add_devices() so that proper
irq mapping can be done when adding the sub device RTC.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/tps65910.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index f7f9d3a..8ca91dd 100644
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

