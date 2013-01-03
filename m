Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab3ACG2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 01:28:55 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38725 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab3ACG2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 01:28:53 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] iio: lp8788_adc: fix a parent device in _probe()
Thread-Topic: [PATCH 1/2] iio: lp8788_adc: fix a parent device in _probe()
Thread-Index: Ac3pe5TWD9NCYm6wSZOFs8pfpceF4g==
Date: Thu, 3 Jan 2013 06:28:45 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E10FCB@DQHE02.ent.ti.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The lp8788-adc is a platform driver of lp8788-mfd.
 The platform device is allocated when mfd_add_devices() is called
 in lp8788-mfd.
 On the other hand, 'lp->dev' is the i2c client device.

 Therefore, this 'platform_device' is a proper parent device of
 iio device and device kernel message.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/iio/adc/lp8788_adc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/adc/lp8788_adc.c b/drivers/iio/adc/lp8788_adc.c
index 72955e4..4c9b0f7 100644
--- a/drivers/iio/adc/lp8788_adc.c
+++ b/drivers/iio/adc/lp8788_adc.c
@@ -214,7 +214,7 @@ static int lp8788_adc_probe(struct platform_device *pdev)
 
 	mutex_init(&adc->lock);
 
-	indio_dev->dev.parent = lp->dev;
+	indio_dev->dev.parent = &pdev->dev;
 	indio_dev->name = pdev->name;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &lp8788_adc_info;
@@ -223,7 +223,7 @@ static int lp8788_adc_probe(struct platform_device *pdev)
 
 	ret = iio_device_register(indio_dev);
 	if (ret) {
-		dev_err(lp->dev, "iio dev register err: %d\n", ret);
+		dev_err(&pdev->dev, "iio dev register err: %d\n", ret);
 		goto err_iio_device;
 	}
 
-- 
1.7.9.5


Best Regards,
Milo


