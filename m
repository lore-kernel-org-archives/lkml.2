Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628Ab0D1IZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 04:25:32 -0400
Received: from compulab.co.il ([67.18.134.219]:44620 "EHLO compulab.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab0D1IZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 04:25:27 -0400
Message-ID: <4BD7F0D9.4040105@compulab.co.il>
Date: Wed, 28 Apr 2010 11:24:57 +0300
From: Denis Turischev <denis@compulab.co.il>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: it8761e_gpio: Fixed bug in gpio numbering
References: <4B8A2F34.3020505@compulab.co.il> <20100302144027.bf6ea1c9.akpm@linux-foundation.org> <4BA0AA45.3070004@compulab.co.il>
In-Reply-To: <4BA0AA45.3070004@compulab.co.il>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-ACL-Warn: {
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - compulab.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SIO chip contains 16 possible gpio lines, not 14. Schematic just was not
read carefully.

Signed-off-by: Denis Turischev <denis@compulab.co.il>
---
 drivers/gpio/it8761e_gpio.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/gpio/it8761e_gpio.c b/drivers/gpio/it8761e_gpio.c
index 753219c..41a9388 100644
--- a/drivers/gpio/it8761e_gpio.c
+++ b/drivers/gpio/it8761e_gpio.c
@@ -80,8 +80,8 @@ static int it8761e_gpio_get(struct gpio_chip *gc, unsigned gpio_num)
 	u16 reg;
 	u8 bit;

-	bit = gpio_num % 7;
-	reg = (gpio_num >= 7) ? gpio_ba + 1 : gpio_ba;
+	bit = gpio_num % 8;
+	reg = (gpio_num >= 8) ? gpio_ba + 1 : gpio_ba;

 	return !!(inb(reg) & (1 << bit));
 }
@@ -91,8 +91,8 @@ static int it8761e_gpio_direction_in(struct gpio_chip *gc, unsigned gpio_num)
 	u8 curr_dirs;
 	u8 io_reg, bit;

-	bit = gpio_num % 7;
-	io_reg = (gpio_num >= 7) ? GPIO2X_IO : GPIO1X_IO;
+	bit = gpio_num % 8;
+	io_reg = (gpio_num >= 8) ? GPIO2X_IO : GPIO1X_IO;

 	spin_lock(&sio_lock);

@@ -116,8 +116,8 @@ static void it8761e_gpio_set(struct gpio_chip *gc,
 	u8 curr_vals, bit;
 	u16 reg;

-	bit = gpio_num % 7;
-	reg = (gpio_num >= 7) ? gpio_ba + 1 : gpio_ba;
+	bit = gpio_num % 8;
+	reg = (gpio_num >= 8) ? gpio_ba + 1 : gpio_ba;

 	spin_lock(&sio_lock);

@@ -135,8 +135,8 @@ static int it8761e_gpio_direction_out(struct gpio_chip *gc,
 {
 	u8 curr_dirs, io_reg, bit;

-	bit = gpio_num % 7;
-	io_reg = (gpio_num >= 7) ? GPIO2X_IO : GPIO1X_IO;
+	bit = gpio_num % 8;
+	io_reg = (gpio_num >= 8) ? GPIO2X_IO : GPIO1X_IO;

 	it8761e_gpio_set(gc, gpio_num, val);

@@ -200,7 +200,7 @@ static int __init it8761e_gpio_init(void)
 		return -EBUSY;

 	it8761e_gpio_chip.base = -1;
-	it8761e_gpio_chip.ngpio = 14;
+	it8761e_gpio_chip.ngpio = 16;

 	err = gpiochip_add(&it8761e_gpio_chip);
 	if (err < 0)
-- 1.6.3.3
