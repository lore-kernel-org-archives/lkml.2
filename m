Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab1DLOtt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:49:49 -0400
Received: from kroah.org ([198.145.64.141]:57639 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932259Ab1DLOiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:19 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:54 2011
Message-Id: <20110412143554.073137612@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [057/105] staging: IIO: IMU: ADIS16400: Add delay after self test
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Hennerich <michael.hennerich@analog.com>

commit c59c95ce6ace6d256401fc3a3648a95375ef4e63 upstream.

Add delay after self test to satisfy timing requirements.
Increase start-up delay.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/iio/imu/adis16400.h      |    3 ++-
 drivers/staging/iio/imu/adis16400_core.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/staging/iio/imu/adis16400.h
+++ b/drivers/staging/iio/imu/adis16400.h
@@ -17,7 +17,8 @@
 #ifndef SPI_ADIS16400_H_
 #define SPI_ADIS16400_H_
 
-#define ADIS16400_STARTUP_DELAY	220 /* ms */
+#define ADIS16400_STARTUP_DELAY	290 /* ms */
+#define ADIS16400_MTEST_DELAY 90 /* ms */
 
 #define ADIS16400_READ_REG(a)    a
 #define ADIS16400_WRITE_REG(a) ((a) | 0x80)
--- a/drivers/staging/iio/imu/adis16400_core.c
+++ b/drivers/staging/iio/imu/adis16400_core.c
@@ -373,7 +373,7 @@ static int adis16400_self_test(struct de
 		dev_err(dev, "problem starting self test");
 		goto err_ret;
 	}
-
+	msleep(ADIS16400_MTEST_DELAY);
 	adis16400_check_status(dev);
 
 err_ret:


