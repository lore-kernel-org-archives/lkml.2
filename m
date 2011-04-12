Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab1DLOuK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:50:10 -0400
Received: from kroah.org ([198.145.64.141]:57627 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246Ab1DLOiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:18 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:54 2011
Message-Id: <20110412143553.966357799@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:34:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jonathan Cameron <jic23@cam.ac.uk>
Subject: [056/105] staging: IIO: IMU: ADIS16400: Fix up SPI messages cs_change behavior
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Hennerich <michael.hennerich@analog.com>

commit fc5b85b0ad1f9da948e4d683710081a9bda357cb upstream.

cs_change must not be set in the last transfer of a spi message

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/iio/imu/adis16400_core.c |    2 --
 drivers/staging/iio/imu/adis16400_ring.c |    2 --
 2 files changed, 4 deletions(-)

--- a/drivers/staging/iio/imu/adis16400_core.c
+++ b/drivers/staging/iio/imu/adis16400_core.c
@@ -93,7 +93,6 @@ static int adis16400_spi_write_reg_16(st
 			.tx_buf = st->tx + 2,
 			.bits_per_word = 8,
 			.len = 2,
-			.cs_change = 1,
 		},
 	};
 
@@ -137,7 +136,6 @@ static int adis16400_spi_read_reg_16(str
 			.rx_buf = st->rx,
 			.bits_per_word = 8,
 			.len = 2,
-			.cs_change = 1,
 		},
 	};
 
--- a/drivers/staging/iio/imu/adis16400_ring.c
+++ b/drivers/staging/iio/imu/adis16400_ring.c
@@ -122,12 +122,10 @@ static int adis16400_spi_read_burst(stru
 			.tx_buf = st->tx,
 			.bits_per_word = 8,
 			.len = 2,
-			.cs_change = 0,
 		}, {
 			.rx_buf = rx,
 			.bits_per_word = 8,
 			.len = 24,
-			.cs_change = 1,
 		},
 	};
 


