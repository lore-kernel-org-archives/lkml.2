Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab2LUF2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:28:11 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:41713 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2LUF2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:28:00 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-cf-50d3f34fda65
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] backlight: corgi_lcd: use lcd_get_data instead of
 dev_get_drvdata
Date: Fri, 21 Dec 2012 14:27:42 +0900
Message-id: <001601cddf3b$e6b4b740$b41e25c0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3fO+ahtD133zg8StW6d1VPeeP6Qg==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJIsWRmVeSWpSXmKPExsVy+t8zI13/z5cDDO5Ml7C4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZ2zbJF3zlrlh6oIutgfEPZxcjJ4eEgInE9H2n2SFsMYkL99az
	dTFycQgJLGOUeLTkJVMXIwdY0YGXVRDxRYwS05/sZgVpEBKYzSQxdz83iM0moCbx5cthsEEi
	AhESzTNmMYP0Mgv4SGyepQliCguESFxpdwWpYBFQlXj0eyYjSJhXwFZi1VcekDCvgKDEj8n3
	WEBsZgEtifU7jzNB2PISm9e8ZYY4Rl3i0V9diD16Eht/nGaGKBGR2PfiHSPEdAGJb5MPsUCU
	y0psOsAMcruEQDu7xPNzi1ghnpWUOLjiBssERrFZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4
	KT3XUK84Mbe4NC9dLzk/dxMjJD6kdjCubLA4xCjAwajEw8todjlAiDWxrLgy9xCjBAezkgiv
	/wegEG9KYmVValF+fFFpTmrxIUYfoMsnMkuJJucDYzevJN7Q2NjEzMTUxNzS1NwUh7CSOG+z
	R0qAkEB6YklqdmpqQWoRzDgmDk6pBkbPSwbRKhcKDHlPzpjG8U70df35Y90fRVxtPvcdP97e
	tPzMpb0VVUev7DGIcHWaEnTGLaFv9uNFzt+9tNlWH9RYslFwpd5vLrvFsWnb+Usz+Bsm1c97
	k6Qg2ssVZMW2W+Za7WfjX03vZk6P3Ds5wGCJ3j0zXt8clqdKs8vXPfhw/f5v050HjqopsRRn
	JBpqMRcVJwIAnHmT4LwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t9jAV3/z5cDDPbdFba4vGsOmwOjx+dN
	cgGMUQ2MNhmpiSmpRQqpecn5KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlA
	U5UUyhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGds2yRd85a5YeqCLrYHx
	D2cXIweHhICJxIGXVV2MnECmmMSFe+vZuhi5OIQEFjFKTH+ymxUkISQwm0li7n5uEJtNQE3i
	y5fD7CC2iECERPOMWcwgc5gFfCQ2z9IEMYUFQiSutLuCVLAIqEo8+j2TESTMK2ArseorD0iY
	V0BQ4sfkeywgNrOAlsT6nceZIGx5ic1r3jJDHKYu8eivLsQePYmNP04zQ5SISOx78Y5xAqPA
	LCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECI6+Z1I7GFc2WBxi
	FOBgVOLhZTS7HCDEmlhWXJl7iFGCg1lJhNf/A1CINyWxsiq1KD++qDQntfgQow/QnxOZpUST
	84GJIa8k3tDYxMzI0sjMwsjE3ByHsJI4b7NHSoCQQHpiSWp2ampBahHMOCYOTqkGRq2XV9gV
	P3Ad22rI4ctrmMxilT85KSnWt+VJhv9nw6lx73v8QtjElcq2Pon/9uhf5KYFpz50z2+xyI9Z
	kO51WXaKlPO5tRunbIoo2pJ8+Xnkcr+afXcaPRoCdE66FYVFqHk8SN57OFBoQ4lF0t9/3Uue
	X/J29Wx8Knq73djs5elbRo9XsD96p8RSnJFoqMVcVJwIAJERsdjrAgAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for getting the driver data using
lcd_device instead of using dev_get_drvdata with &ld->dev,
so we can directly pass a struct lcd_device.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/corgi_lcd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index 13ef511..aa782f3 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -337,7 +337,7 @@ static void corgi_lcd_power_off(struct corgi_lcd *lcd)
 
 static int corgi_lcd_set_mode(struct lcd_device *ld, struct fb_videomode *m)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&ld->dev);
+	struct corgi_lcd *lcd = lcd_get_data(ld);
 	int mode = CORGI_LCD_MODE_QVGA;
 
 	if (m->xres == 640 || m->xres == 480)
@@ -364,7 +364,7 @@ static int corgi_lcd_set_mode(struct lcd_device *ld, struct fb_videomode *m)
 
 static int corgi_lcd_set_power(struct lcd_device *ld, int power)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&ld->dev);
+	struct corgi_lcd *lcd = lcd_get_data(ld);
 
 	if (POWER_IS_ON(power) && !POWER_IS_ON(lcd->power))
 		corgi_lcd_power_on(lcd);
@@ -378,7 +378,7 @@ static int corgi_lcd_set_power(struct lcd_device *ld, int power)
 
 static int corgi_lcd_get_power(struct lcd_device *ld)
 {
-	struct corgi_lcd *lcd = dev_get_drvdata(&ld->dev);
+	struct corgi_lcd *lcd = lcd_get_data(ld);
 
 	return lcd->power;
 }
-- 
1.7.2.5


