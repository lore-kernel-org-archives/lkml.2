Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324Ab2K2Ise (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 03:48:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51210 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2K2Isd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 03:48:33 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "ldewangan@nvidia.com" <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] mfd: tps65910: remove unused data
Thread-Topic: [PATCH 1/2] mfd: tps65910: remove unused data
Thread-Index: Ac3ODkr2q32Ec4t2SJaKQuSVaE+YrA==
Date: Thu, 29 Nov 2012 08:48:26 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F6418F1BB@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.123]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The 'io_mutex' is not used anywhere.
 The regmap API supports the mutex internally, so no additional mutex required.

 And 'domain' private data is unnecessary because the irq domain is
 already registered by using regmap_add_irq_chip().

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/mfd/tps65910.c       |    1 -
 include/linux/mfd/tps65910.h |    2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
index fdb3027..d5ef3a5 100644
--- a/drivers/mfd/tps65910.c
+++ b/drivers/mfd/tps65910.c
@@ -486,7 +486,6 @@ static __devinit int tps65910_i2c_probe(struct i2c_client *i2c,
 	tps65910->dev = &i2c->dev;
 	tps65910->i2c_client = i2c;
 	tps65910->id = chip_id;
-	mutex_init(&tps65910->io_mutex);
 
 	tps65910->regmap = devm_regmap_init_i2c(i2c, &tps65910_regmap_config);
 	if (IS_ERR(tps65910->regmap)) {
diff --git a/include/linux/mfd/tps65910.h b/include/linux/mfd/tps65910.h
index 0b16903..20e433e 100644
--- a/include/linux/mfd/tps65910.h
+++ b/include/linux/mfd/tps65910.h
@@ -893,7 +893,6 @@ struct tps65910 {
 	struct device *dev;
 	struct i2c_client *i2c_client;
 	struct regmap *regmap;
-	struct mutex io_mutex;
 	unsigned int id;
 
 	/* Client devices */
@@ -907,7 +906,6 @@ struct tps65910 {
 	/* IRQ Handling */
 	int chip_irq;
 	struct regmap_irq_chip_data *irq_data;
-	struct irq_domain *domain;
 };
 
 struct tps65910_platform_data {
-- 
1.7.9.5


Best Regards,
Milo


