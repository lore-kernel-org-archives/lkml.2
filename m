Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab2HPHkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 03:40:05 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45295 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006Ab2HPHkC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 03:40:02 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: Lars-Peter Clausen <lars@metafoo.de>, "jic23@cam.ac.uk" <jic23@cam.ac.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
Subject: [PATCH 2/3] iio: use IIO_CHAN_INFO_RAW rather than 0
Thread-Topic: [PATCH 2/3] iio: use IIO_CHAN_INFO_RAW rather than 0
Thread-Index: Ac17gkSyfPlv7UpLRZS0p+4wa8BnkA==
Date: Thu, 16 Aug 2012 07:39:29 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EEFD76@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.87.185.52]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(a) For better readability, replace 0 with IIO_CHAN_INFO_RAW.
(b) Make same line-format as other apis()
    : iio_read_channel_scale() and iio_read_channel_offset()

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/iio/inkern.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index bd09245..5103337 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -239,8 +239,10 @@ int iio_read_channel_raw(struct iio_channel *chan, int *val)
 		goto err_unlock;
 	}
 
-	ret = chan->indio_dev->info->read_raw(chan->indio_dev, chan->channel,
-					      val, &val2, 0);
+	ret = chan->indio_dev->info->read_raw(chan->indio_dev,
+					      chan->channel,
+					      val, &val2,
+					      IIO_CHAN_INFO_RAW);
 err_unlock:
 	mutex_unlock(&chan->indio_dev->info_exist_lock);
 
-- 
1.7.2.5


Best Regards,
Milo


