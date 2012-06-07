Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380Ab2FGEQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:16:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63306 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab2FGEQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:16:25 -0400
Message-Id: <20120607040338.852388740@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:03:53 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jonas Gorski <jonas.gorski@gmail.com>,
        Maxime Bizon <mbizon@freebox.fr>,
        Florian Fainelli <florian@openwrt.org>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: [ 17/82] MIPS: BCM63XX: Add missing include for bcm63xx_gpio.h
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

commit 442209f31dafef9fde852858e1ce566b675b720d upstream.

bcm63xx_gpio.h uses macros defined in bcm63xx_cpu.h without including it,
leading to the following build failure:

  CC [M]  drivers/mmc/core/cd-gpio.o
In file included from arch/mips/include/asm/mach-bcm63xx/gpio.h:4:0,
                 from arch/mips/include/asm/gpio.h:4,
                 from include/linux/gpio.h:30,
                 from drivers/mmc/core/cd-gpio.c:12:

arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h: In function 'bcm63xx_gpio_count':
arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:10:2: error: implicit declaration of function 'bcm63xx_get_cpu_id'
arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:11:7: error: 'BCM6358_CPU_ID' undeclared (first use in this function)
arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:11:7: note: each undeclared identifier is reported only once for each function it appears in
arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:13:7: error: 'BCM6338_CPU_ID' undeclared (first use in this function)
arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:15:7: error: 'BCM6345_CPU_ID' undeclared (first use in this function)
arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:17:7: error: 'BCM6368_CPU_ID' undeclared (first use in this function)
arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h:19:7: error: 'BCM6348_CPU_ID' undeclared (first use in this function)

make[7]: *** [drivers/mmc/core/cd-gpio.o] Error 1

Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Cc: linux-mips@linux-mips.org
Cc: Maxime Bizon <mbizon@freebox.fr>
Cc: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h
+++ b/arch/mips/include/asm/mach-bcm63xx/bcm63xx_gpio.h
@@ -2,6 +2,7 @@
 #define BCM63XX_GPIO_H
 
 #include <linux/init.h>
+#include <bcm63xx_cpu.h>
 
 int __init bcm63xx_gpio_init(void);
 


