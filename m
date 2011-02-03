Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab1BCEBp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:01:45 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:48068 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab1BCEBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:01:44 -0500
Date: Wed, 2 Feb 2011 20:01:39 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-arm-kernel@lists.infradead.org,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH 03/19] ab3550: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110202200139.7391044f@queued.net>
In-Reply-To: <20110202195417.228e2656@queued.net>
References: <20110202195417.228e2656@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No need to explicitly set the cell's platform_data/data_size.

This wasn't actually used anywhere by the ab3550 stuff; dev_data
in mach-u300's i2c code was empty.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 arch/arm/mach-u300/i2c.c   |    2 --
 drivers/mfd/ab3550-core.c  |    6 ------
 include/linux/mfd/abx500.h |    2 --
 3 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/arch/arm/mach-u300/i2c.c b/arch/arm/mach-u300/i2c.c
index f0394ba..1ff7a82 100644
--- a/arch/arm/mach-u300/i2c.c
+++ b/arch/arm/mach-u300/i2c.c
@@ -291,8 +291,6 @@ static struct ab3550_platform_data ab3550_plf_data = {
 		.base = IRQ_AB3550_BASE,
 		.count = (IRQ_AB3550_END - IRQ_AB3550_BASE + 1),
 	},
-	.dev_data = {
-	},
 	.init_settings = ab3550_init_settings,
 	.init_settings_sz = ARRAY_SIZE(ab3550_init_settings),
 };
diff --git a/drivers/mfd/ab3550-core.c b/drivers/mfd/ab3550-core.c
index 5fbca34..47625b9 100644
--- a/drivers/mfd/ab3550-core.c
+++ b/drivers/mfd/ab3550-core.c
@@ -1319,12 +1319,6 @@ static int __init ab3550_probe(struct i2c_client *client,
 	if (err)
 		goto exit_no_ops;
 
-	/* Set up and register the platform devices. */
-	for (i = 0; i < AB3550_NUM_DEVICES; i++) {
-		ab3550_devs[i].platform_data = ab3550_plf_data->dev_data[i];
-		ab3550_devs[i].data_size = ab3550_plf_data->dev_data_sz[i];
-	}
-
 	err = mfd_add_devices(&client->dev, 0, ab3550_devs,
 		ARRAY_SIZE(ab3550_devs), NULL,
 		ab3550_plf_data->irq.base);
diff --git a/include/linux/mfd/abx500.h b/include/linux/mfd/abx500.h
index 67bd6f7..a735210 100644
--- a/include/linux/mfd/abx500.h
+++ b/include/linux/mfd/abx500.h
@@ -185,8 +185,6 @@ struct abx500_init_settings {
  */
 struct ab3550_platform_data {
 	struct {unsigned int base; unsigned int count; } irq;
-	void *dev_data[AB3550_NUM_DEVICES];
-	size_t dev_data_sz[AB3550_NUM_DEVICES];
 	struct abx500_init_settings *init_settings;
 	unsigned int init_settings_sz;
 };
-- 
1.7.2.3

