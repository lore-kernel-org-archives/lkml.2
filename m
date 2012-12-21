Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab2LUFZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:25:43 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57846 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2LUFZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:25:37 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-2e-50d3f2d04dac
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Thierry Reding'" <thierry.reding@avionic-design.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001001cddf3b$7bb2c3b0$73184b10$%han@samsung.com>
In-reply-to: <001001cddf3b$7bb2c3b0$73184b10$%han@samsung.com>
Subject: [PATCH 2/6] pwm_backlight: use bl_get_data instead of dev_get_drvdata
Date: Fri, 21 Dec 2012 14:25:36 +0900
Message-id: <001101cddf3b$9b0f2d20$d12d8760$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3fO3udRdsnHWRmS2i/6pBmiWTW1AAAAeCQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBIsWRmVeSWpSXmKPExsVy+t8zQ90Lny4HGPRNlbe4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZX15+ZiyYyl8xv+k9UwPjU54uRk4OCQETiRsnl7FB2GISF+6t
	B7K5OIQEljFKLN+xlA2maMq5D4wQiUWMEgue/mWGcGYzSXzZcJYJpIpNQE3iy5fD7CC2iECE
	RPOMWWBFzAKtjBJHn7xgAUkICdhKXJj0hRnE5hSwk+jc/YgRxBYW8JM43P0SrJlFQFVi+Z1X
	rCA2L0j953PMELagxI/J98DmMAtoSazfeZwJwpaX2LzmLVANB9Cp6hKP/upC3GAk0XTwLiNE
	iYjEvhfvGCHGC0h8m3yIBaJcVmLTAbAzJQQWsUvMet3PCPGxpMTBFTdYJjBKzEKyeRaSzbOQ
	bJ6FZMUCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGCHRJbWDcWWDxSFGAQ5GJR5eRrPL
	AUKsiWXFlbmHGCU4mJVEeP0/AIV4UxIrq1KL8uOLSnNSiw8x+gBdPpFZSjQ5Hxj5eSXxhsbG
	JmYmpibmlqbmpjiElcR5mz1SAoQE0hNLUrNTUwtSi2DGMXFwSjUwyjC5acm/lD37594eh2Dt
	O9d2t8oqnIuI19l5rftYMVvSZy+jLas7w5/wXJ3/5MbxlpXzpe33dP81uHOx5fS+zzP9trf2
	yR57PvO6+fTDeiYWk70urOjda27JrXo46J+y+M5IDs3zbpNvcRYoN2ty/Kye9d1792/Txe5q
	mfzie/d7SIut87nXr8RSnJFoqMVcVJwIAIwgCZLbAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsVy+t9jAd0Lny4HGJybJGVxedccNgdGj8+b
	5AIYoxoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
	pioplCXmlAKFAhKLi5X07TBNCA1x07WAaYzQ9Q0JgusxMkADCesYM768/MxYMJW/Yn7Te6YG
	xqc8XYycHBICJhJTzn1ghLDFJC7cW8/WxcjFISSwiFFiwdO/zBDObCaJLxvOMoFUsQmoSXz5
	cpgdxBYRiJBonjELrIhZoJVR4uiTFywgCSEBW4kLk74wg9icAnYSnbsfga0QFvCTONz9EqyZ
	RUBVYvmdV6wgNi9I/edzzBC2oMSPyffA5jALaEms33mcCcKWl9i85i1QDQfQqeoSj/7qQtxg
	JNF08C4jRImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0
	veT83E2M4Nh9JrWDcWWDxSFGAQ5GJR5eRrPLAUKsiWXFlbmHGCU4mJVEeP0/AIV4UxIrq1KL
	8uOLSnNSiw8x+gA9OpFZSjQ5H5hW8kriDY1NzIwsjcwsjEzMzXEIK4nzNnukBAgJpCeWpGan
	phakFsGMY+LglGpgFBW9fGvCJskWW+dcfm6fxA9NCq1x3q29HcISJ9Kq43g5/zdGlxcpHv7t
	cWHX9vPBEdHTNOflyKTXil6tnBW2c58PS/YjnfR3C33W7nZYO9dHOFCnPdT0UnF1plzh23Xf
	ftStyXnAe65tQ29AV2yWu+HMRx1bZ4S/tlDSeTn9h0zBjXtnvuYqsRRnJBpqMRcVJwIAycEZ
	RgoDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for getting the driver data using
backlight_device instead of using dev_get_drvdata with &bd->dev,
so we can directly pass a struct backlight_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Cc: Thierry Reding <thierry.reding@avionic-design.de>
---
 drivers/video/backlight/pwm_bl.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index 069983c..f2f4c43 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -37,7 +37,7 @@ struct pwm_bl_data {
 
 static int pwm_backlight_update_status(struct backlight_device *bl)
 {
-	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+	struct pwm_bl_data *pb = bl_get_data(bl);
 	int brightness = bl->props.brightness;
 	int max = bl->props.max_brightness;
 
@@ -83,7 +83,7 @@ static int pwm_backlight_get_brightness(struct backlight_device *bl)
 static int pwm_backlight_check_fb(struct backlight_device *bl,
 				  struct fb_info *info)
 {
-	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+	struct pwm_bl_data *pb = bl_get_data(bl);
 
 	return !pb->check_fb || pb->check_fb(pb->dev, info);
 }
@@ -264,7 +264,7 @@ err_alloc:
 static int pwm_backlight_remove(struct platform_device *pdev)
 {
 	struct backlight_device *bl = platform_get_drvdata(pdev);
-	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+	struct pwm_bl_data *pb = bl_get_data(bl);
 
 	backlight_device_unregister(bl);
 	pwm_config(pb->pwm, 0, pb->period);
@@ -278,7 +278,7 @@ static int pwm_backlight_remove(struct platform_device *pdev)
 static int pwm_backlight_suspend(struct device *dev)
 {
 	struct backlight_device *bl = dev_get_drvdata(dev);
-	struct pwm_bl_data *pb = dev_get_drvdata(&bl->dev);
+	struct pwm_bl_data *pb = bl_get_data(bl);
 
 	if (pb->notify)
 		pb->notify(pb->dev, 0);
-- 
1.7.2.5


