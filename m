Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab2INBYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 21:24:40 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39768 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412Ab2INBYi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 21:24:38 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: Jonathan Cameron <jic23@cam.ac.uk>, Lars-Peter Clausen <lars@metafoo.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND] iio: inkern: allocate zeroed memory
Thread-Topic: [PATCH RESEND] iio: inkern: allocate zeroed memory
Thread-Index: Ac2SF6jOvP1py7UKRG+HhpSbtK+KQQ==
Date: Fri, 14 Sep 2012 01:24:19 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF4C3E@DQHE02.ent.ti.com>
Accept-Language: en-US
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

 Use kzalloc() rather than kmalloc() for initializing the iio_channel structure.
 This patch enables the iio_dev and iio_chan_spec are set to NULL.
 This may prevent the page fault problem because the pointer of iio_chan_spec
 is initialized as NULL.

 The iio_chan_spec is updated only in case that the IIO map has
 specific channel label.
 When the map has no ADC channel label, then the value of iio_chan_spec
 remains as invalid pointer.
 To prevent this problem, the pointer should be initialized as NULL.

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


