Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764Ab2FDJlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 05:41:17 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46440 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199Ab2FDJlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 05:41:16 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-iio@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 1/2] iio: hmc5843: Make it behave better as modules
Date: Mon, 4 Jun 2012 15:11:04 +0530
Message-ID: <1338802865-31160-1-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory regions of the probe and remove are move
to __devinit and __devexit respectively.

Acked-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
---
 drivers/staging/iio/magnetometer/hmc5843.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/iio/magnetometer/hmc5843.c b/drivers/staging/iio/magnetometer/hmc5843.c
index c1fa09f..6c3e50f 100644
--- a/drivers/staging/iio/magnetometer/hmc5843.c
+++ b/drivers/staging/iio/magnetometer/hmc5843.c
@@ -665,7 +665,7 @@ static const struct iio_info hmc5843_info = {
 	.driver_module = THIS_MODULE,
 };
 
-static int hmc5843_probe(struct i2c_client *client,
+static int __devinit hmc5843_probe(struct i2c_client *client,
 			 const struct i2c_device_id *id)
 {
 	struct hmc5843_data *data;
@@ -704,7 +704,7 @@ exit:
 	return err;
 }
 
-static int hmc5843_remove(struct i2c_client *client)
+static int __devexit hmc5843_remove(struct i2c_client *client)
 {
 	struct iio_dev *indio_dev = i2c_get_clientdata(client);
 
@@ -755,7 +755,7 @@ static struct i2c_driver hmc5843_driver = {
 	},
 	.id_table	= hmc5843_id,
 	.probe		= hmc5843_probe,
-	.remove		= hmc5843_remove,
+	.remove		= __devexit_p(hmc5843_remove),
 	.detect		= hmc5843_detect,
 	.address_list	= normal_i2c,
 };
-- 
1.7.5.4

