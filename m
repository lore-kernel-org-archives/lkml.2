Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276Ab3ACG3L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 01:29:11 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:39044 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885Ab3ACG3I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 01:29:08 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] iio: lp8788_adc: fix parent device in kernel message
Thread-Topic: [PATCH 2/2] iio: lp8788_adc: fix parent device in kernel
 message
Thread-Index: Ac3pe5xL0ZMqNNpkSFeRF9pgUB905g==
Date: Thu, 3 Jan 2013 06:28:58 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E10FD3@DQHE02.ent.ti.com>
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

Use 'dev' of iio device in a kernel message rather than i2c client device node.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/iio/adc/lp8788_adc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/lp8788_adc.c b/drivers/iio/adc/lp8788_adc.c
index 4c9b0f7..f8bcb1f 100644
--- a/drivers/iio/adc/lp8788_adc.c
+++ b/drivers/iio/adc/lp8788_adc.c
@@ -179,7 +179,7 @@ static int lp8788_iio_map_register(struct iio_dev *indio_dev,
 
 	ret = iio_map_array_register(indio_dev, map);
 	if (ret) {
-		dev_err(adc->lp->dev, "iio map err: %d\n", ret);
+		dev_err(&indio_dev->dev, "iio map err: %d\n", ret);
 		return ret;
 	}
 
-- 
1.7.9.5


Best Regards,
Milo


