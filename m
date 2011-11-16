Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab1KPJNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 04:13:07 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:5631 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab1KPJND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 04:13:03 -0500
X-SpamScore: 0
X-BigFish: VS0(zzzz1202hzzz2dh87h2a8h668h839h)
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPVD:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
From: Lars-Peter Clausen <lars@metafoo.de>
To: Greg Kroah-Hartman <gregkh@suse.de>, Jean Delvare <khali@linux-fr.org>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Jonathan Cameron <jic23@kernel.org>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        <linux-iio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <spi-devel-general@lists.sourceforge.net>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 0/5] Generalize module_platform_driver
Date: Wed, 16 Nov 2011 10:13:34 +0100
Message-ID: <1321434819-23678-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely recently introduced the module_platform_driver macro which can be
used to eliminate a few lines on boilerplate code in platform driver modules.
The same approach can be used to do the same for other bus type drivers.

The first patch of this series generalizes the module_platform_driver macro and
introduces the module_driver macro. It is similar to module_platform_driver
macro but has two additional parameters to pass in the driver register and
unregister function. The intend is that this macro is used to construct bus
specific macros for generating the driver register/unregister boilerplate code.

The next two patches in this series add the module_i2c_driver and
module_spi_driver macro which use the module_driver macro to generate the I2C
and SPI driver boilerplate code.

The last two patches convert the driver found in the IIO framework to use the
new module_i2c_driver and module_spi_driver macros to demonstrate their
potential and remove over 700 lines of code.

While this series only introduces these kind of helper macros for I2C and SPI
bus drivers the same scheme should be applicable to most other bus driver types.
For example PCI and USB seem to be good candidates.

It probably makes sense to merge the first three patches together. The last two
can probably, since this is not urgent, wait until the first three have reached
mainline.

- Lars

Lars-Peter Clausen (5):
  drivercore: Generalize module_platform_driver
  I2C: Add helper macro for i2c_driver boilerplate
  SPI: Add helper macro for spi_driver boilerplate
  staging:iio: Use module_i2c_driver to register I2C drivers
  staging:iio: Use module_spi_driver to register SPI driver

 drivers/staging/iio/accel/adis16201_core.c      |   13 +------------
 drivers/staging/iio/accel/adis16203_core.c      |   13 +------------
 drivers/staging/iio/accel/adis16204_core.c      |   13 +------------
 drivers/staging/iio/accel/adis16209_core.c      |   13 +------------
 drivers/staging/iio/accel/adis16220_core.c      |   13 +------------
 drivers/staging/iio/accel/adis16240_core.c      |   13 +------------
 drivers/staging/iio/accel/kxsd9.c               |   13 +------------
 drivers/staging/iio/accel/lis3l02dq_core.c      |   13 +------------
 drivers/staging/iio/accel/sca3000_core.c        |   13 +------------
 drivers/staging/iio/adc/ad7192.c                |   13 +------------
 drivers/staging/iio/adc/ad7280a.c               |   13 +------------
 drivers/staging/iio/adc/ad7291.c                |   14 +-------------
 drivers/staging/iio/adc/ad7298_core.c           |   13 +------------
 drivers/staging/iio/adc/ad7476_core.c           |   13 +------------
 drivers/staging/iio/adc/ad7606_spi.c            |   13 +------------
 drivers/staging/iio/adc/ad7780.c                |   13 +------------
 drivers/staging/iio/adc/ad7793.c                |   13 +------------
 drivers/staging/iio/adc/ad7816.c                |   14 +-------------
 drivers/staging/iio/adc/ad7887_core.c           |   13 +------------
 drivers/staging/iio/adc/ad799x_core.c           |   14 +-------------
 drivers/staging/iio/adc/adt7310.c               |   14 +-------------
 drivers/staging/iio/adc/adt7410.c               |   14 +-------------
 drivers/staging/iio/adc/max1363_core.c          |   14 +-------------
 drivers/staging/iio/addac/adt7316-i2c.c         |   14 +-------------
 drivers/staging/iio/addac/adt7316-spi.c         |   14 +-------------
 drivers/staging/iio/cdc/ad7150.c                |   14 +-------------
 drivers/staging/iio/cdc/ad7152.c                |   14 +-------------
 drivers/staging/iio/cdc/ad7746.c                |   14 +-------------
 drivers/staging/iio/dac/ad5064.c                |   13 +------------
 drivers/staging/iio/dac/ad5360.c                |   13 +------------
 drivers/staging/iio/dac/ad5446.c                |   13 +------------
 drivers/staging/iio/dac/ad5504.c                |   13 +------------
 drivers/staging/iio/dac/ad5624r_spi.c           |   13 +------------
 drivers/staging/iio/dac/ad5686.c                |   13 +------------
 drivers/staging/iio/dac/ad5791.c                |   13 +------------
 drivers/staging/iio/dac/max517.c                |   14 +-------------
 drivers/staging/iio/dds/ad5930.c                |   13 +------------
 drivers/staging/iio/dds/ad9832.c                |   13 +------------
 drivers/staging/iio/dds/ad9834.c                |   13 +------------
 drivers/staging/iio/dds/ad9850.c                |   13 +------------
 drivers/staging/iio/dds/ad9852.c                |   13 +------------
 drivers/staging/iio/dds/ad9910.c                |   13 +------------
 drivers/staging/iio/dds/ad9951.c                |   13 +------------
 drivers/staging/iio/gyro/adis16080_core.c       |   13 +------------
 drivers/staging/iio/gyro/adis16130_core.c       |   13 +------------
 drivers/staging/iio/gyro/adis16260_core.c       |   13 +------------
 drivers/staging/iio/gyro/adxrs450_core.c        |   13 +------------
 drivers/staging/iio/impedance-analyzer/ad5933.c |   13 +------------
 drivers/staging/iio/imu/adis16400_core.c        |   13 +------------
 drivers/staging/iio/light/isl29018.c            |   14 +-------------
 drivers/staging/iio/light/tsl2563.c             |   14 +-------------
 drivers/staging/iio/light/tsl2583.c             |   14 +-------------
 drivers/staging/iio/magnetometer/ak8975.c       |   14 +-------------
 drivers/staging/iio/magnetometer/hmc5843.c      |   14 +-------------
 drivers/staging/iio/meter/ade7753.c             |   13 +------------
 drivers/staging/iio/meter/ade7754.c             |   13 +------------
 drivers/staging/iio/meter/ade7758_core.c        |   13 +------------
 drivers/staging/iio/meter/ade7759.c             |   13 +------------
 drivers/staging/iio/meter/ade7854-i2c.c         |   14 +-------------
 drivers/staging/iio/meter/ade7854-spi.c         |   13 +------------
 drivers/staging/iio/resolver/ad2s1200.c         |   13 +------------
 drivers/staging/iio/resolver/ad2s1210.c         |   13 +------------
 drivers/staging/iio/resolver/ad2s90.c           |   13 +------------
 include/linux/i2c.h                             |   13 +++++++++++++
 include/linux/init.h                            |   21 +++++++++++++++++++++
 include/linux/platform_device.h                 |   12 ++----------
 include/linux/spi/spi.h                         |   11 +++++++++++
 67 files changed, 110 insertions(+), 784 deletions(-)

-- 
1.7.7.1


