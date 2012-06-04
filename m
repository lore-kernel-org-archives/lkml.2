Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab2FDJl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 05:41:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54268 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756738Ab2FDJlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 05:41:17 -0400
From: Shubhrajyoti D <shubhrajyoti@ti.com>
To: <linux-iio@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        Shubhrajyoti D <shubhrajyoti@ti.com>
Subject: [PATCH 2/2] iio: ak8975: Make it behave better as modules
Date: Mon, 4 Jun 2012 15:11:05 +0530
Message-ID: <1338802865-31160-2-git-send-email-shubhrajyoti@ti.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1338802865-31160-1-git-send-email-shubhrajyoti@ti.com>
References: <1338802865-31160-1-git-send-email-shubhrajyoti@ti.com>
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

 drivers/staging/iio/magnetometer/ak8975.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/iio/magnetometer/ak8975.c b/drivers/staging/iio/magnetometer/ak8975.c
index 5834e4a..7562caf 100644
--- a/drivers/staging/iio/magnetometer/ak8975.c
+++ b/drivers/staging/iio/magnetometer/ak8975.c
@@ -471,7 +471,7 @@ static const struct iio_info ak8975_info = {
 	.driver_module = THIS_MODULE,
 };
 
-static int ak8975_probe(struct i2c_client *client,
+static int __devinit ak8975_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct ak8975_data *data;
@@ -545,7 +545,7 @@ exit:
 	return err;
 }
 
-static int ak8975_remove(struct i2c_client *client)
+static int __devexit ak8975_remove(struct i2c_client *client)
 {
 	struct iio_dev *indio_dev = i2c_get_clientdata(client);
 	struct ak8975_data *data = iio_priv(indio_dev);
-- 
1.7.5.4

