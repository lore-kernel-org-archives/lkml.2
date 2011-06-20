Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab1FTKsD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:48:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49149 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750758Ab1FTKsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:48:01 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Graeme Gregory <gg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] mfd: Implement tps65910 IRQ cleanup
Date: Mon, 20 Jun 2011 11:47:55 +0100
Message-Id: <1308566875-17441-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tps65910_irq_exit() cleanup function was generating a warning from
sparse due to the lack of a prototype. This wasn't causing GCC warnings
as the driver wasn't cleaning up its IRQs on exit at all so there was no
use of an unprototyped function.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/tps65910.c       |    1 +
 include/linux/mfd/tps65910.h |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index 2229e66..837f0e6 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -187,6 +187,7 @@ static int tps65910_i2c_remove(struct i2c_client *i2c)
 	struct tps65910 *tps65910 = i2c_get_clientdata(i2c);
 
 	mfd_remove_devices(tps65910->dev);
+	tps65910_irq_exit(tps65910);
 	kfree(tps65910);
 
 	return 0;
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 8bb85b9..efcdb29 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -791,6 +791,7 @@ int tps65910_clear_bits(struct tps65910 *tps65910, u8 reg, u8 mask);
 void tps65910_gpio_init(struct tps65910 *tps65910, int gpio_base);
 int tps65910_irq_init(struct tps65910 *tps65910, int irq,
 		struct tps65910_platform_data *pdata);
+int tps65910_irq_exit(struct tps65910 *tps65910);
 
 static inline int tps65910_chip_id(struct tps65910 *tps65910)
 {
-- 
1.7.5.4

