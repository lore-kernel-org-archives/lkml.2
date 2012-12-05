Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab2LEA7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 19:59:13 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:13401 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2LEA7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 19:59:10 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-b6-50be9c5c473e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Marko Katic'" <dromede@gmail.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        linux-arm-kernel@lists.infradead.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v4] backlight: corgi_lcd: Use gpio_set_value_cansleep() to
 avoid WARN_ON
Date: Wed, 05 Dec 2012 09:59:07 +0900
Message-id: <000201cdd283$baf50160$30df0420$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3Sg7qDkEV3VJbdT9OePeZe/2bfkw==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zY92YOfsCDI4s07S4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZm+/qFWxVrmi//46tgXGtfBcjJ4eEgInEgmVPGSFsMYkL99az
	dTFycQgJLGOUOHX4HSNM0bxJXYwQiemMEuuffoFyZjNJrPpygxmkik1ATeLLl8PsILaIQIRE
	84xZzCBFzAKNTBKvF8xjBUkIC0RJvHp4AWwsi4CqxKqjh8BsXgFbiefz7zFB2IISPybfYwGx
	mQW0JDZva2KFsOUlNq95CzSUA+gkdYlHf3UhdulJHL32kA2iRERi34t3UOMFJL5NPsQCUS4r
	sekA2DkSAu3sEhPPLoH6TFLi4IobLBMYxWYh2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9FxD
	veLE3OLSvHS95PzcTYyQWJHawbiyweIQowAHoxIPb5bevgAh1sSy4srcQ4wSHMxKIrz/7IBC
	vCmJlVWpRfnxRaU5qcWHGH2ALp/ILCWanA+M47ySeENjYxMzE1MTc0tTc1McwkrivM0eKQFC
	AumJJanZqakFqUUw45g4OKUaGINVYvWdrCuUzsy7ubpI4njfqwCVG2LrWPqL/v78srf5YmmK
	UtqusHWCAb09SdN/pbW45TG0xTyYZtibIvVkgtiVmFdrtCbXlgrqJcz6tm/SyhvbcxqnCVhs
	Xb7B37dS5UxR8tFWpU/yqq5PxeN4XLNSvJ0OqzT3sG2ftSSzcsqpzmOS/63XKbEUZyQaajEX
	FScCAMcoqpfCAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jQd2YOfsCDHa1K1lc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjM139Qq2Kle033/H1sC4
	Vr6LkZNDQsBEYt6kLkYIW0ziwr31bF2MXBxCAtMZJdY//cII4cxmklj15QYzSBWbgJrEly+H
	2UFsEYEIieYZs5hBipgFGpkkXi+YxwqSEBaIknj18ALYWBYBVYlVRw+B2bwCthLP599jgrAF
	JX5MvscCYjMLaEls3tbECmHLS2xe8xZoKAfQSeoSj/7qQuzSkzh67SEbRImIxL4X7xgnMArM
	QjJpFpJJs5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Eh8JrWDcWWDxSFG
	AQ5GJR7eLL19AUKsiWXFlbmHGCU4mJVEeP/ZAYV4UxIrq1KL8uOLSnNSiw8x+gA9OpFZSjQ5
	H5gk8kriDY1NzIwsjcwsjEzMzXEIK4nzNnukBAgJpCeWpGanphakFsGMY+LglGpgjN304tmN
	g6zc6S/r1uvsqewRKPLY3jq52EpiV9Kx+jOb6sUmZ7eZ7LXfVis2WWtt5m77qaGiMSWX1Tma
	FppI3w7ncuReyiezRKDITP2Dx6ZU67ttE/fXyVZkFi20X/q1ZTpD2jTfc2bn7DVeF6l5q23R
	OnqbvfDGIZs/3Da6xeyeptd9LjgpsRRnJBpqMRcVJwIApbSchPECAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marko Katic <dromede@gmail.com>

Changing backlight intensity on an Akita (Sharp Zaurus C-1000)
triggers WARN_ON message:

WARNING: at drivers/gpio/gpiolib.c:1672 __gpio_set_value+0x38/0xa4()
Modules linked in:
Backtrace:
[<c000c0ac>] (dump_backtrace+0x0/0x110) from [<c02c8278>] (dump_stack+0x18/0x1c)
 r6:c0158fc8 r5:00000009 r4:00000000 r3:c03d4f70
[<c02c8260>] (dump_stack+0x0/0x1c) from [<c0019194>] (warn_slowpath_common+0x54/0x6c)
[<c0019140>] (warn_slowpath_common+0x0/0x6c) from [<c00191d0>] (warn_slowpath_null+0x24/0x2c)
 r8:c38d5c00 r7:c03f82c0 r6:00000000 r5:000000d0 r4:c384e4fc
r3:00000009
[<c00191ac>] (warn_slowpath_null+0x0/0x2c) from [<c0158fc8>] (__gpio_set_value+0x38/0xa4)
[<c0158f90>] (__gpio_set_value+0x0/0xa4) from [<c0169b4c>] (corgi_bl_set_intensity+0x44/0x74)
 r7:c3933418 r6:c3933400 r5:c392cdf0 r4:0000002f
[<c0169b08>] (corgi_bl_set_intensity+0x0/0x74) from [<c0169c1c>] (corgi_bl_update_status+0x5c/0x64)
 r5:c03d31f0 r4:c3933400
[<c0169bc0>] (corgi_bl_update_status+0x0/0x64) from [<c02c3a68>] (corgi_lcd_probe+0x1a8/0x258)
 r4:c392cdf0 r3:c0169bc0
[<c02c38c0>] (corgi_lcd_probe+0x0/0x258) from [<c01da7a4>] (spi_drv_probe+0x20/0x24)
 r8:00000052 r7:c0192d9c r6:c03da6e8 r5:c38d5c34 r4:c38d5c00
[<c01da784>] (spi_drv_probe+0x0/0x24) from [<c0192c44>] (driver_probe_device+0xb0/0x208)
[<c0192b94>] (driver_probe_device+0x0/0x208) from [<c0192e0c>] (__driver_attach+0x70/0x94)
 r6:c03da6e8 r5:c38d5c34 r4:c38d5c00 r3:00000000
[<c0192d9c>] (__driver_attach+0x0/0x94) from [<c0191268>] (bus_for_each_dev+0x54/0x90)
 r6:c03da6e8 r5:c3827e80 r4:00000000 r3:00000000
[<c0191214>] (bus_for_each_dev+0x0/0x90) from [<c01927a4>] (driver_attach+0x20/0x28)
 r7:00000000 r6:c03e29ec r5:c3932980 r4:c03da6e8
[<c0192784>] (driver_attach+0x0/0x28) from [<c0192340>] (bus_add_driver+0xd4/0x22c)
[<c019226c>] (bus_add_driver+0x0/0x22c) from [<c019335c>] (driver_register+0xa4/0x134)
 r8:00000052 r7:c03ea900 r6:c03c32ac r5:c03bdfc8 r4:c03da6e8
[<c01932b8>] (driver_register+0x0/0x134) from [<c01db7ec>] (spi_register_driver+0x4c/0x60)
[<c01db7a0>] (spi_register_driver+0x0/0x60) from [<c03b3ce0>] (corgi_lcd_driver_init+0x14/0x1c)
[<c03b3ccc>] (corgi_lcd_driver_init+0x0/0x1c) from [<c000868c>] (do_one_initcall+0x9c/0x174)
[<c00085f0>] (do_one_initcall+0x0/0x174) from [<c02c1b94>] (kernel_init+0xf4/0x2a8)
[<c02c1aa0>] (kernel_init+0x0/0x2a8) from [<c0009270>] (ret_from_fork+0x14/0x24)
---[ end trace a863a63f242ee38c ]---

Akita machines have backlight controls hooked to a gpio expander chip,
max7310 using i2c transfers which can sleep.
In this case, pca953x_gpio_set_value() can be called to control
gpio, and pca953x_setup_gpio() sets can_sleep flag. Therefore,
gpio_set_value_cansleep() should be used in order to avoid WARN_ON on
akita machines.

Akita is the only exception in this case since other users of corgi_lcd
access backlight gpio controls through a different gpio expander
which does not set the can_sleep flag.

[jg1.han@samsung.com: used gpio_cansleep()]
Signed-off-by: Marko Katic <dromede@gmail.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Change since v3:
- remove redundant wording from commit message
Change since v2:
- use gpio_cansleep() 

 drivers/video/backlight/corgi_lcd.c |   17 +++++++++++++----
 1 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index e2e1b62..e5168f4 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -408,11 +408,20 @@ static int corgi_bl_set_intensity(struct corgi_lcd *lcd, int intensity)
 	/* Bit 5 via GPIO_BACKLIGHT_CONT */
 	cont = !!(intensity & 0x20) ^ lcd->gpio_backlight_cont_inverted;
 
-	if (gpio_is_valid(lcd->gpio_backlight_cont))
-		gpio_set_value(lcd->gpio_backlight_cont, cont);
+	if (gpio_is_valid(lcd->gpio_backlight_cont)) {
+		if (gpio_cansleep(lcd->gpio_backlight_cont))
+			gpio_set_value_cansleep(lcd->gpio_backlight_cont, cont);
+		else
+			gpio_set_value(lcd->gpio_backlight_cont, cont);
+	}
 
-	if (gpio_is_valid(lcd->gpio_backlight_on))
-		gpio_set_value(lcd->gpio_backlight_on, intensity);
+	if (gpio_is_valid(lcd->gpio_backlight_on)) {
+		if (gpio_cansleep(lcd->gpio_backlight_on))
+			gpio_set_value_cansleep(lcd->gpio_backlight_on,
+						intensity);
+		else
+			gpio_set_value(lcd->gpio_backlight_on, intensity);
+	}
 
 	if (lcd->kick_battery)
 		lcd->kick_battery();
-- 
1.7.2.5


