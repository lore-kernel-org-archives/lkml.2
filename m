Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab2FOIke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 04:40:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:32863 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab2FOIkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 04:40:31 -0400
Message-ID: <1339749621.7253.1.camel@phoenix>
Subject: [PATCH] iio: dac: Convert ad5380 to devm_regmap_* APIs
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Fri, 15 Jun 2012 16:40:21 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/iio/dac/ad5380.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/iio/dac/ad5380.c b/drivers/iio/dac/ad5380.c
index 5dfb445..14991ac 100644
--- a/drivers/iio/dac/ad5380.c
+++ b/drivers/iio/dac/ad5380.c
@@ -373,7 +373,7 @@ static int __devinit ad5380_probe(struct device *dev, struct regmap *regmap,
 	if (indio_dev == NULL) {
 		dev_err(dev, "Failed to allocate iio device\n");
 		ret = -ENOMEM;
-		goto error_regmap_exit;
+		goto error_out;
 	}
 
 	st = iio_priv(indio_dev);
@@ -436,8 +436,7 @@ error_free_reg:
 	kfree(indio_dev->channels);
 error_free:
 	iio_device_free(indio_dev);
-error_regmap_exit:
-	regmap_exit(regmap);
+error_out:
 
 	return ret;
 }
@@ -456,7 +455,6 @@ static int __devexit ad5380_remove(struct device *dev)
 		regulator_put(st->vref_reg);
 	}
 
-	regmap_exit(st->regmap);
 	iio_device_free(indio_dev);
 
 	return 0;
@@ -485,7 +483,7 @@ static int __devinit ad5380_spi_probe(struct spi_device *spi)
 	const struct spi_device_id *id = spi_get_device_id(spi);
 	struct regmap *regmap;
 
-	regmap = regmap_init_spi(spi, &ad5380_regmap_config);
+	regmap = devm_regmap_init_spi(spi, &ad5380_regmap_config);
 
 	if (IS_ERR(regmap))
 		return PTR_ERR(regmap);
@@ -559,7 +557,7 @@ static int __devinit ad5380_i2c_probe(struct i2c_client *i2c,
 {
 	struct regmap *regmap;
 
-	regmap = regmap_init_i2c(i2c, &ad5380_regmap_config);
+	regmap = devm_regmap_init_i2c(i2c, &ad5380_regmap_config);
 
 	if (IS_ERR(regmap))
 		return PTR_ERR(regmap);
-- 
1.7.9.5



