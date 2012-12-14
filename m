Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab2LNHxC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 02:53:02 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57604 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab2LNHxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 02:53:00 -0500
Message-ID: <1355471573.11297.8.camel@phoenix>
Subject: [PATCH 4/6] iio: dac: ad5624r_spi: Don't set error code to
 voltage_uv
From: Axel Lin <axel.lin@ingics.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Barry Song <21cnbao@gmail.com>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 14 Dec 2012 15:52:53 +0800
In-Reply-To: <1355471245.11297.1.camel@phoenix>
References: <1355471245.11297.1.camel@phoenix>
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
 drivers/iio/dac/ad5624r_spi.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/dac/ad5624r_spi.c b/drivers/iio/dac/ad5624r_spi.c
index 6a7d6a4..ae7fb64 100644
--- a/drivers/iio/dac/ad5624r_spi.c
+++ b/drivers/iio/dac/ad5624r_spi.c
@@ -238,7 +238,11 @@ static int __devinit ad5624r_probe(struct spi_device *spi)
 		if (ret)
 			goto error_put_reg;
 
-		voltage_uv = regulator_get_voltage(st->reg);
+		ret = regulator_get_voltage(st->reg);
+		if (ret)
+			goto error_disable_reg;
+
+		voltage_uv = ret;
 	}
 
 	spi_set_drvdata(spi, indio_dev);
-- 
1.7.9.5



