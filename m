Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab1ILCF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 22:05:28 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:35129 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab1ILCFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 22:05:13 -0400
Date: Mon, 12 Sep 2011 12:05:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20110912120507.7aae1112267b60ef077a914a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-mxs/include/mach/gpio.h between commit 22fe67837614 ("ARM:
gpio: consolidate trivial gpiolib implementations") and later ones from
the arm tree and commit 7e6c53aac38e ("gpio/mxs: move irq_to_gpio() into
gpio-mxs driver") and a579cebd76d8 ("arm/mxs: move MXS_GPIO_NR into
mach/mxs.h") from the arm-soc tree.

I fixed it up (which leaves this file essentailly empty - see below) and
can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-mxs/include/mach/gpio.h
index bb11e63,56025aa..0000000
--- a/arch/arm/mach-mxs/include/mach/gpio.h
+++ b/arch/arm/mach-mxs/include/mach/gpio.h
@@@ -20,8 -20,12 +20,4 @@@
  #ifndef __MACH_MXS_GPIO_H__
  #define __MACH_MXS_GPIO_H__
  
- #define MXS_GPIO_NR(bank, nr)	((bank) * 32 + (nr))
- 
- #define irq_to_gpio(irq)	((irq) - MXS_GPIO_IRQ_START)
- 
 -#include <asm-generic/gpio.h>
 -
 -/* use gpiolib dispatchers */
 -#define gpio_get_value		__gpio_get_value
 -#define gpio_set_value		__gpio_set_value
 -#define gpio_cansleep		__gpio_cansleep
 -#define gpio_to_irq		__gpio_to_irq
 -
  #endif /* __MACH_MXS_GPIO_H__ */
