Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab2LRBwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:52:46 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:45959 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab2LRBwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:52:45 -0500
Message-ID: <1355795109.5681.9.camel@phoenix>
Subject: [PATCH] iio: dac: ad5446: Don't set error code to voltage_uv
From: Axel Lin <axel.lin@ingics.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Michael Hennerich <hennerich@blackfin.uclinux.org>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 18 Dec 2012 09:45:09 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regulator_get_voltage() may return negative error code.
Add error checking to avoid setting error code to voltage_uv.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/iio/dac/ad5446.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad5446.c b/drivers/iio/dac/ad5446.c
index 3310cbb..607378f 100644
--- a/drivers/iio/dac/ad5446.c
+++ b/drivers/iio/dac/ad5446.c
@@ -226,7 +226,11 @@ static int __devinit ad5446_probe(struct device *dev, const char *name,
 		if (ret)
 			goto error_put_reg;
 
-		voltage_uv = regulator_get_voltage(reg);
+		ret = regulator_get_voltage(reg);
+		if (ret)
+			goto error_disable_reg;
+
+		voltage_uv = ret;
 	}
 
 	indio_dev = iio_device_alloc(sizeof(*st));
-- 
1.7.9.5



