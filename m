Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698Ab2BNOgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 09:36:03 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:36605 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760679Ab2BNOfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 09:35:45 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] adis16080: fix compiler -Wuninitialized
Date: Tue, 14 Feb 2012 15:35:36 +0100
Message-Id: <1329230136-26576-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329230145;e31ed409;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix for:
drivers/staging/iio/gyro/adis16080_core.c: In function
  ‘adis16080_read_raw’:
drivers/staging/iio/gyro/adis16080_core.c:99:8: warning: ‘ut’
  may be used uninitialized in this function [-Wuninitialized]

Initialize ut and change error handling from adis16080_read_raw().

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/staging/iio/gyro/adis16080_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/gyro/adis16080_core.c b/drivers/staging/iio/gyro/adis16080_core.c
index 1815490..e0b2a29 100644
--- a/drivers/staging/iio/gyro/adis16080_core.c
+++ b/drivers/staging/iio/gyro/adis16080_core.c
@@ -82,7 +82,7 @@ static int adis16080_read_raw(struct iio_dev *indio_dev,
 			     long mask)
 {
 	int ret = -EINVAL;
-	u16 ut;
+	u16 ut = 0;
 	/* Take the iio_dev status lock */
 
 	mutex_lock(&indio_dev->mlock);
@@ -94,7 +94,7 @@ static int adis16080_read_raw(struct iio_dev *indio_dev,
 		if (ret < 0)
 			break;
 		ret = adis16080_spi_read(indio_dev, &ut);
-		if (ret < 0)
+		if (ret)
 			break;
 		*val = ut;
 		ret = IIO_VAL_INT;
-- 
1.7.7.3

