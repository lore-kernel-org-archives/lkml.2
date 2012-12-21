Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751032Ab2LUFUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:20:12 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:54940 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab2LUFUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:20:06 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-06-50d3f185c539
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
In-reply-to: <000501cddf3a$9ba1ecb0$d2e5c610$%han@samsung.com>
Subject: [PATCH 04/11] backlight: ltv350qv: use spi_get_drvdata and
 spi_set_drvdata
Date: Fri, 21 Dec 2012 14:20:05 +0900
Message-id: <000801cddf3a$d5e82330$81b86990$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3fOptdKnZ1gkj6SBm7JPAbRHnX+QAACb3A
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zfd3Wj5cDDNa2altc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MK/c2sRVM4a/YcmYGSwPjVZ4uRk4OCQETiSsrvrFB2GISF+6t
	B7K5OIQEljFKnDjUyA5TtOvDVkaIxCJGiQdTNjJBOLOZJGas72MEqWITUJP48uUwWIeIQIRE
	84xZzF2MHBzMAj4Sm2dpgoSFBGwl2r/uACvnFLCTaJ7bxAJiCwuESuz/9gPsChYBVYk/7WfA
	aniB6g9d2cYOYQtK/Jh8D6yeWUBLYv3O40wQtrzE5jVvwVZJCKhLPPqrC3GBkcTGNYugSkQk
	9r14xwgxXkDi2+RDLBDlshKbDjCDfCIhMI9dov/DS6h/JSUOrrjBMoFRYhaSzbOQbJ6FZPMs
	JCsWMLKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAiJLKkdjCsbLA4xCnAwKvHwMppdDhBi
	TSwrrsw9xCjBwawkwuv/ASjEm5JYWZValB9fVJqTWnyI0Qfo8onMUqLJ+cCozyuJNzQ2NjEz
	MTUxtzQ1N8UhrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qB0ZB7W3piYE/m9BXzwmZX3tv8
	Nzz366xTSR4KjivfGYm/3Sf1S5L/UGz9+0xlFcnyOJ8L88/8Z3/1w8P+w/zjXUf27zt19I7M
	/4+NX2fdzt0iFi8xqWfllKBCa76dUz81Pv/lLXo/4OHPbe4ZOVES6XnRHb0XnkZ6ftOasI9p
	Pu+rpTJ5JQE1T5VYijMSDbWYi4oTAZ7CwaLZAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t9jAd3Wj5cDDBaeV7O4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGVfubWIrmMJfseXMDJYG
	xqs8XYycHBICJhK7PmxlhLDFJC7cW8/WxcjFISSwiFHiwZSNTBDObCaJGev7wKrYBNQkvnw5
	zA5iiwhESDTPmMXcxcjBwSzgI7F5liZIWEjAVqL96w6wck4BO4nmuU0sILawQKjE/m8/2EBs
	FgFViT/tZ8BqeIHqD13Zxg5hC0r8mHwPrJ5ZQEti/c7jTBC2vMTmNW/BVkkIqEs8+qsLcYGR
	xMY1i6BKRCT2vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl
	5+duYgTH7TOpHYwrGywOMQpwMCrx8DKaXQ4QYk0sK67MPcQowcGsJMLr/wEoxJuSWFmVWpQf
	X1Sak1p8iNEH6NGJzFKiyfnAlJJXEm9obGJmZGlkZmFkYm6OQ1hJnLfZIyVASCA9sSQ1OzW1
	ILUIZhwTB6dUA6OZjm3p3c0b+pnWynMu9ZL5Vjdn9+qDHHbLLZp8gtjfxjK4O6TYRj2/Js32
	iVl0tkjYry0nZb025R3O+nYuXb6EKVNc2f39f0crjsxio/OBF5/czJWe7GLaduj/woublgZd
	S2IufpZzr0Pkb/qk6s7fNToW/z2sbQ6rX7kr0LlYdMPVFQY75ZVYijMSDbWYi4oTAX6RCzUI	AwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper functions for getting and setting the driver data
using spi_device instead of using dev_{get|set}_drvdata with
&spi->dev, so we can directly pass a struct spi_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/ltv350qv.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/video/backlight/ltv350qv.c b/drivers/video/backlight/ltv350qv.c
index 226d813..c0b4b8f 100644
--- a/drivers/video/backlight/ltv350qv.c
+++ b/drivers/video/backlight/ltv350qv.c
@@ -252,7 +252,7 @@ static int ltv350qv_probe(struct spi_device *spi)
 	if (ret)
 		goto out_unregister;
 
-	dev_set_drvdata(&spi->dev, lcd);
+	spi_set_drvdata(spi, lcd);
 
 	return 0;
 
@@ -263,7 +263,7 @@ out_unregister:
 
 static int ltv350qv_remove(struct spi_device *spi)
 {
-	struct ltv350qv *lcd = dev_get_drvdata(&spi->dev);
+	struct ltv350qv *lcd = spi_get_drvdata(spi);
 
 	ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
 	lcd_device_unregister(lcd->ld);
@@ -274,14 +274,14 @@ static int ltv350qv_remove(struct spi_device *spi)
 #ifdef CONFIG_PM
 static int ltv350qv_suspend(struct spi_device *spi, pm_message_t state)
 {
-	struct ltv350qv *lcd = dev_get_drvdata(&spi->dev);
+	struct ltv350qv *lcd = spi_get_drvdata(spi);
 
 	return ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
 }
 
 static int ltv350qv_resume(struct spi_device *spi)
 {
-	struct ltv350qv *lcd = dev_get_drvdata(&spi->dev);
+	struct ltv350qv *lcd = spi_get_drvdata(spi);
 
 	return ltv350qv_power(lcd, FB_BLANK_UNBLANK);
 }
@@ -293,7 +293,7 @@ static int ltv350qv_resume(struct spi_device *spi)
 /* Power down all displays on reboot, poweroff or halt */
 static void ltv350qv_shutdown(struct spi_device *spi)
 {
-	struct ltv350qv *lcd = dev_get_drvdata(&spi->dev);
+	struct ltv350qv *lcd = spi_get_drvdata(spi);
 
 	ltv350qv_power(lcd, FB_BLANK_POWERDOWN);
 }
-- 
1.7.2.5


