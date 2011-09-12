Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab1ILCFi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 22:05:38 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:59380 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab1ILCFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 22:05:17 -0400
Date: Mon, 12 Sep 2011 12:05:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20110912120513.abf3f655edfe645868cbd48c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/plat-mxc/include/mach/gpio.h between commits 22fe67837614 ("ARM:
gpio: consolidate trivial gpiolib implementations") and 8f3c4537bb08
("ARM: gpio: make trivial GPIOLIB implementation the default") from the
arm tree and commits df1bac2e2f18 ("arm/mxc: use gpiolib helper for
gpio_to_irq"), a4395612290c ("gpio/mxc: move irq_to_gpio() into gpio-mxc
driver") and 1dfa86bb9d3f ("arm/mxc: move IMX_GPIO_NR into
mach/hardware.h")  from the arm-soc tree.

I fixed it up (which leaves this file essentially empty - see below) anc
can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/plat-mxc/include/mach/gpio.h
index 3e1ffc8,44af006..0000000
--- a/arch/arm/plat-mxc/include/mach/gpio.h
+++ b/arch/arm/plat-mxc/include/mach/gpio.h
@@@ -21,13 -21,12 +21,5 @@@
  
  #include <linux/spinlock.h>
  #include <mach/hardware.h>
 -#include <asm-generic/gpio.h>
 -
 -/* use gpiolib dispatchers */
 -#define gpio_get_value		__gpio_get_value
 -#define gpio_set_value		__gpio_set_value
 -#define gpio_cansleep		__gpio_cansleep
 -#define gpio_to_irq		__gpio_to_irq
  
- 
- /* There's a off-by-one betweem the gpio bank number and the gpiochip */
- /* range e.g. GPIO_1_5 is gpio 5 under linux */
- #define IMX_GPIO_NR(bank, nr)		(((bank) - 1) * 32 + (nr))
- 
- #define gpio_to_irq(gpio)	(MXC_GPIO_IRQ_START + (gpio))
- #define irq_to_gpio(irq)	((irq) - MXC_GPIO_IRQ_START)
- 
  #endif
