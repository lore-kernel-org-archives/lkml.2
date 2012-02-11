Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405Ab2BKBA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 20:00:59 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34756 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab2BKBA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 20:00:57 -0500
Message-ID: <1328922048.2787.1.camel@phoenix>
Subject: [PATCH] staging:iio:dac: Fix kcalloc parameters swapped
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org
Date: Sat, 11 Feb 2012 09:00:48 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first parameter should be "number of elements" and the second parameter
should be "element size".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/staging/iio/dac/ad5360.c |    4 ++--
 drivers/staging/iio/dac/ad5380.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/iio/dac/ad5360.c b/drivers/staging/iio/dac/ad5360.c
index 710b256..cec3693 100644
--- a/drivers/staging/iio/dac/ad5360.c
+++ b/drivers/staging/iio/dac/ad5360.c
@@ -439,8 +439,8 @@ static int __devinit ad5360_alloc_channels(struct iio_dev *indio_dev)
 	struct iio_chan_spec *channels;
 	unsigned int i;
 
-	channels = kcalloc(sizeof(struct iio_chan_spec),
-			st->chip_info->num_channels, GFP_KERNEL);
+	channels = kcalloc(st->chip_info->num_channels,
+			   sizeof(struct iio_chan_spec), GFP_KERNEL);
 
 	if (!channels)
 		return -ENOMEM;
diff --git a/drivers/staging/iio/dac/ad5380.c b/drivers/staging/iio/dac/ad5380.c
index eff97ae0..4c50716 100644
--- a/drivers/staging/iio/dac/ad5380.c
+++ b/drivers/staging/iio/dac/ad5380.c
@@ -363,8 +363,8 @@ static int __devinit ad5380_alloc_channels(struct iio_dev *indio_dev)
 	struct iio_chan_spec *channels;
 	unsigned int i;
 
-	channels = kcalloc(sizeof(struct iio_chan_spec),
-			st->chip_info->num_channels, GFP_KERNEL);
+	channels = kcalloc(st->chip_info->num_channels,
+			   sizeof(struct iio_chan_spec), GFP_KERNEL);
 
 	if (!channels)
 		return -ENOMEM;
-- 
1.7.5.4



