Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1GIVWN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 17:22:13 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13280 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab1GIVWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 17:22:11 -0400
Date: Sat, 9 Jul 2011 23:12:35 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: trivial@kernel.org, Ralf Baechle <ralf@linux-mips.org>,
        Lars-Peter Clausen <lars@metafoo.de>, linux-mips@linux-mips.org
Subject: [PATCH 2/7] MIPS: static should be at beginning of declaration
In-Reply-To: <alpine.LNX.2.00.1107092304160.25516@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1107092311190.25516@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107092304160.25516@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-244283129-1310245955=:25516"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-244283129-1310245955=:25516
Content-Type: TEXT/PLAIN; charset=ISO-8859-7
Content-Transfer-Encoding: 8BIT

Make sure that the 'static' keywork is at the beginning of declaration
for arch/mips/include/asm/mach-jz4740/gpio.h

This gets rid of warnings like
  warning: ¡static¢ is not at beginning of declaration
when building with -Wold-style-declaration (and/or -Wextra which also
enables it).
Also a few tiny whitespace changes.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 arch/mips/include/asm/mach-jz4740/gpio.h |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/mips/include/asm/mach-jz4740/gpio.h b/arch/mips/include/asm/mach-jz4740/gpio.h
index 7b74703..1a6482e 100644
--- a/arch/mips/include/asm/mach-jz4740/gpio.h
+++ b/arch/mips/include/asm/mach-jz4740/gpio.h
@@ -25,14 +25,13 @@ enum jz_gpio_function {
     JZ_GPIO_FUNC3,
 };
 
-
 /*
  Usually a driver for a SoC component has to request several gpio pins and
  configure them as funcion pins.
  jz_gpio_bulk_request can be used to ease this process.
  Usually one would do something like:
 
- const static struct jz_gpio_bulk_request i2c_pins[] = {
+ static const struct jz_gpio_bulk_request i2c_pins[] = {
 	JZ_GPIO_BULK_PIN(I2C_SDA),
 	JZ_GPIO_BULK_PIN(I2C_SCK),
  };
@@ -47,8 +46,8 @@ enum jz_gpio_function {
 
     jz_gpio_bulk_free(i2c_pins, ARRAY_SIZE(i2c_pins));
 
-
 */
+
 struct jz_gpio_bulk_request {
 	int gpio;
 	const char *name;
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

--8323328-244283129-1310245955=:25516--
