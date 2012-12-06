Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257Ab2LFDbp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 22:31:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:32898 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab2LFDbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 22:31:43 -0500
X-AuditID: cbfee61b-b7f616d00000319b-de-50c0119de011
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Marko Katic'" <dromede@gmail.com>,
        "'Russell King - ARM Linux'" <linux@arm.linux.org.uk>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        linux-arm-kernel@lists.infradead.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH v5] backlight: corgi_lcd: Use gpio_set_value_cansleep() to
 avoid WARN_ON
Date: Thu, 06 Dec 2012 12:31:40 +0900
Message-id: <000301cdd362$34d9d800$9e8d8800$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3TYjSPVpbuKR7XQU6xECQkiN7XgA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zA925ggcCDC4/lbG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZn17cZi84JV/xeOdulgbGfpkuRk4OCQETiRu7LjBB2GISF+6t
	Z+ti5OIQEljGKPHi9G0WmKJ9C/4yQSQWMUoc2vOeFcKZzSRxoW8FK0gVm4CaxJcvh9lBbBGB
	CInmGbOYQWxmgR1MEu8v5nQxcnAIC0RJXG8AK2cRUJXYcHA6mM0rYCuxceI8ZghbUOLH5Hss
	EK1aEut3HmeCsOUlNq95ywwyRkJAXeLRX12ITXoSc1v+s0GUiEjse/GOEWK8gMS3yYdYIMpl
	JTYdYAa5WEKgnV1i8vedbBB/SUocXHGDZQKj2Cwkm2ch2TwLyeZZSFYsYGRZxSiaWpBcUJyU
	nmukV5yYW1yal66XnJ+7iRESKdI7GFc1WBxiFOBgVOLhtajeHyDEmlhWXJl7iFGCg1lJhPfc
	Z6AQb0piZVVqUX58UWlOavEhRh+gyycyS4km5wOjOK8k3tDY2MTMxNTE3NLU3BSHsJI4b7NH
	SoCQQHpiSWp2ampBahHMOCYOTqkGxnXGJ3I9rLZfCW1+UXPO8Dfv+dcH1niqcju8Xu273G/b
	xxdn4wrLdrDr7Hh154dbb7D2ghj9drUjv/2s1vMETN7C+/Gbyl49KZvPJ417d2iWZ7VrPjBd
	F9fO7LBD8aO9Klvimaf7rDz57j5fUFhWcyRzVdVz6XsZloemn3rMonHuWe1envbmV0osxRmJ
	hlrMRcWJAKKD7ETBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t9jAd25ggcCDNruiVhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjE8vbrMXnJKveLxzN0sD
	Y79MFyMnh4SAicS+BX+ZIGwxiQv31rN1MXJxCAksYpQ4tOc9K4Qzm0niQt8KVpAqNgE1iS9f
	DrOD2CICERLNM2Yxg9jMAjuYJN5fzOli5OAQFoiSuN4AVs4ioCqx4eB0MJtXwFZi48R5zBC2
	oMSPyfdYIFq1JNbvPM4EYctLbF7zlhlkjISAusSjv7oQm/Qk5rb8Z4MoEZHY9+Id4wRGgVlI
	Js1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREch8+kdzCuarA4xCjA
	wajEw2tRvT9AiDWxrLgy9xCjBAezkgjvuc9AId6UxMqq1KL8+KLSnNTiQ4w+QI9OZJYSTc4H
	poi8knhDYxMzI0sjMwsjE3NzHMJK4rzNHikBQgLpiSWp2ampBalFMOOYODilGhjLd/+rLWyO
	4iuM3Z/x/f29sNmZHMn//ef/O3j4u3r51dqmTcdnX97lm54fonWvZMIX14B/n7+xzFo0d73+
	Ce3L6ukfg/+cmunDofXSufCnYFM4/2dzRUfhkxObHkzL59sRJ7c87veWvSZTtGo3/a9Q1r9a
	/D5uuzbH7O7l8Uw3WIV3pd3XsJiixFKckWioxVxUnAgAIFk/M/ACAAA=
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

Signed-off-by: Marko Katic <dromede@gmail.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Change since v4:
- use only gpio_set_value_cansleep()

 drivers/video/backlight/corgi_lcd.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/corgi_lcd.c b/drivers/video/backlight/corgi_lcd.c
index e2e1b62..e323fcb 100644
--- a/drivers/video/backlight/corgi_lcd.c
+++ b/drivers/video/backlight/corgi_lcd.c
@@ -409,10 +409,10 @@ static int corgi_bl_set_intensity(struct corgi_lcd *lcd, int intensity)
 	cont = !!(intensity & 0x20) ^ lcd->gpio_backlight_cont_inverted;
 
 	if (gpio_is_valid(lcd->gpio_backlight_cont))
-		gpio_set_value(lcd->gpio_backlight_cont, cont);
+		gpio_set_value_cansleep(lcd->gpio_backlight_cont, cont);
 
 	if (gpio_is_valid(lcd->gpio_backlight_on))
-		gpio_set_value(lcd->gpio_backlight_on, intensity);
+		gpio_set_value_cansleep(lcd->gpio_backlight_on, intensity);
 
 	if (lcd->kick_battery)
 		lcd->kick_battery();
-- 
1.7.2.5


