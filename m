Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab2IJICt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 04:02:49 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53089 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab2IJICd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 04:02:33 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Lars-Peter Clausen <lars@metafoo.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] iio: inkern: clear allocated memory
Thread-Topic: [PATCH 1/2] iio: inkern: clear allocated memory
Thread-Index: Ac2PKpn0Vk/LYmMIRWu04wIaEZFoBw==
Date: Mon, 10 Sep 2012 08:02:20 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF45DC@DQHE02.ent.ti.com>
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

 Use kzalloc() rathern than kmalloc() for initializing iio_dev and
 iio_chan_spec.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 drivers/iio/inkern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/inkern.c b/drivers/iio/inkern.c
index b5afc2f..1faa240 100644
--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -130,7 +130,7 @@ struct iio_channel *iio_channel_get(const char *name, const char *channel_name)
 	if (c == NULL)
 		return ERR_PTR(-ENODEV);
 
-	channel = kmalloc(sizeof(*channel), GFP_KERNEL);
+	channel = kzalloc(sizeof(*channel), GFP_KERNEL);
 	if (channel == NULL)
 		return ERR_PTR(-ENOMEM);
 
-- 
1.7.9.5


Best Regards,
Milo


