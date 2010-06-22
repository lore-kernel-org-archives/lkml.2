Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104Ab0FVJQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 05:16:46 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46320 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754968Ab0FVJQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 05:16:45 -0400
From: "Datta, Shubhrajyoti" <shubhrajyoti@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Christoph Mair <christoph.mair@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Date: Tue, 22 Jun 2010 14:46:25 +0530
Subject: [RFC] [PATCH] BMP085 update
Thread-Topic: [RFC] [PATCH] BMP085 update
Thread-Index: AcsR5XV6ixOSpLtJTrSJcQAZmiWXVAABPjlA
Message-ID: <0680EC522D0CC943BC586913CF3768C003B35537F0@dbde02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updates for the BMP085 pressure sensor
- Optimizing the wait time for the pressure sensor
- Definition of long is arch dependent so making it u32.

Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/misc/bmp085.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index 16a2b2c..8af6f1b 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -60,7 +60,7 @@ struct bmp085_data {
 	u32 raw_temperature;
 	u32 raw_pressure;
 	unsigned char oversampling_setting;
-	unsigned long last_temp_measurement;
+	u32 last_temp_measurement;
 	s32 b6; /* calculated temperature correction coefficient */
 };
 
@@ -144,7 +144,7 @@ static s32 bmp085_update_raw_pressure(struct bmp085_data *data)
 	}
 
 	/* wait for the end of conversion */
-	msleep(2+(3 << data->oversampling_setting<<1));
+	msleep(2+(3 << data->oversampling_setting ));
 
 	/* copy data into a u32 (4 bytes), but skip the first byte. */
 	status = i2c_smbus_read_i2c_block_data(data->client,
-- 
1.5.4.7

