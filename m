Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593Ab2FFVS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:18:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42323 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757128Ab2FFVSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:18:55 -0400
From: Leed Aguilar <leed.aguilar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <leed.aguilar@ti.com>,
        <linux-iio@vger.kernel.org>
Subject: [PATCH 1/3] staging:iio:magnetometer:ak8975: set power-down mode after reading fuse ROM data
Date: Wed, 6 Jun 2012 16:14:56 -0400
Message-ID: <1339013696-15436-1-git-send-email-leed.aguilar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fuse ROM data access mode is the only mode which does not
transition to power-down mode automatically.

As per the AK8975 data sheet, it is recomended to set the
power-down mode first before attempting to change into
another mode.

Signed-off-by: Leed Aguilar <leed.aguilar@ti.com>
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/staging/iio/magnetometer/ak8975.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/iio/magnetometer/ak8975.c b/drivers/staging/iio/magnetometer/ak8975.c
index 7562caf..001b3bf 100644
--- a/drivers/staging/iio/magnetometer/ak8975.c
+++ b/drivers/staging/iio/magnetometer/ak8975.c
@@ -194,6 +194,17 @@ static int ak8975_setup(struct i2c_client *client)
 		return ret;
 	}
 
+	/* After reading fuse ROM data set power-down mode */
+	ret = ak8975_write_data(client,
+				AK8975_REG_CNTL,
+				AK8975_REG_CNTL_MODE_POWER_DOWN,
+				AK8975_REG_CNTL_MODE_MASK,
+				AK8975_REG_CNTL_MODE_SHIFT);
+	if (ret < 0) {
+		dev_err(&client->dev, "Error in setting power-down mode\n");
+		return ret;
+	}
+
 /*
  * Precalculate scale factor (in Gauss units) for each axis and
  * store in the device data.
-- 
1.7.1

