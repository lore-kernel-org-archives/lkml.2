Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919Ab1HJOii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 10:38:38 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:57534 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1HJOih convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 10:38:37 -0400
MIME-Version: 1.0
In-Reply-To: <1312978697-18572-1-git-send-email-linus.walleij@stericsson.com>
References: <1312978697-18572-1-git-send-email-linus.walleij@stericsson.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 10 Aug 2011 22:38:16 +0800
Message-ID: <CAMPhdO9eL_Sdq-=TCami=CkwWeYR3XeF0K=n9L0uzjS88YTsRA@mail.gmail.com>
Subject: Re: [PATCH 15/19] plat-pxa: break out GPIO driver specifics
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 8:18 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
>
> The <mach/gpio.h> file is included from upper directories
> and deal with generic GPIO and gpiolib stuff. Break out the
> platform and driver specific defines and functions into its own
> header file.
>
> Cc: Eric Miao <eric.y.miao@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

I think there is better way around this, am working on it with several
patches already, will release soon.

> ---
>  arch/arm/mach-mmp/aspenite.c               |    1 +
>  arch/arm/mach-mmp/brownstone.c             |    1 -
>  arch/arm/mach-mmp/gplugd.c                 |    2 +-
>  arch/arm/mach-mmp/include/mach/gpio-pxa.h  |   30 ++++++
>  arch/arm/mach-mmp/include/mach/gpio.h      |   23 -----
>  arch/arm/mach-mmp/jasper.c                 |    1 -
>  arch/arm/mach-mmp/mmp2.c                   |    2 +-
>  arch/arm/mach-mmp/pxa168.c                 |    2 +-
>  arch/arm/mach-mmp/pxa910.c                 |    2 +-
>  arch/arm/mach-mmp/tavorevb.c               |    1 +
>  arch/arm/mach-pxa/cm-x255.c                |    1 -
>  arch/arm/mach-pxa/include/mach/gpio-pxa.h  |  133 ++++++++++++++++++++++++++++
>  arch/arm/mach-pxa/include/mach/gpio.h      |  110 +----------------------
>  arch/arm/mach-pxa/include/mach/littleton.h |    2 +-
>  arch/arm/mach-pxa/irq.c                    |    2 +-
>  arch/arm/mach-pxa/mfp-pxa2xx.c             |    1 +
>  arch/arm/mach-pxa/pxa25x.c                 |    1 +
>  arch/arm/mach-pxa/pxa27x.c                 |    1 +
>  arch/arm/mach-pxa/pxa3xx.c                 |    2 +-
>  arch/arm/mach-pxa/pxa95x.c                 |    2 +-
>  arch/arm/mach-pxa/saarb.c                  |    1 +
>  arch/arm/plat-pxa/include/plat/gpio-pxa.h  |   44 +++++++++
>  arch/arm/plat-pxa/include/plat/gpio.h      |   40 +--------
>  drivers/gpio/gpio-pxa.c                    |    2 +
>  24 files changed, 227 insertions(+), 180 deletions(-)
>  create mode 100644 arch/arm/mach-mmp/include/mach/gpio-pxa.h
>  create mode 100644 arch/arm/mach-pxa/include/mach/gpio-pxa.h
>  create mode 100644 arch/arm/plat-pxa/include/plat/gpio-pxa.h
>
> diff --git a/arch/arm/mach-mmp/aspenite.c b/arch/arm/mach-mmp/aspenite.c
> index cf87518..833c3a2 100644
> --- a/arch/arm/mach-mmp/aspenite.c
> +++ b/arch/arm/mach-mmp/aspenite.c
> @@ -17,6 +17,7 @@
>  #include <linux/mtd/partitions.h>
>  #include <linux/mtd/nand.h>
>  #include <linux/interrupt.h>
> +#include <linux/gpio.h>
>
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
> diff --git a/arch/arm/mach-mmp/brownstone.c b/arch/arm/mach-mmp/brownstone.c
> index c79162a..e411252 100644
> --- a/arch/arm/mach-mmp/brownstone.c
> +++ b/arch/arm/mach-mmp/brownstone.c
> @@ -14,7 +14,6 @@
>  #include <linux/kernel.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
> -#include <linux/gpio.h>
>  #include <linux/regulator/machine.h>
>  #include <linux/regulator/max8649.h>
>  #include <linux/regulator/fixed.h>
> diff --git a/arch/arm/mach-mmp/gplugd.c b/arch/arm/mach-mmp/gplugd.c
> index c070c24..ef738de 100644
> --- a/arch/arm/mach-mmp/gplugd.c
> +++ b/arch/arm/mach-mmp/gplugd.c
> @@ -9,11 +9,11 @@
>  */
>
>  #include <linux/init.h>
> +#include <linux/gpio.h>
>
>  #include <asm/mach/arch.h>
>  #include <asm/mach-types.h>
>
> -#include <mach/gpio.h>
>  #include <mach/pxa168.h>
>  #include <mach/mfp-pxa168.h>
>  #include <mach/mfp-gplugd.h>
> diff --git a/arch/arm/mach-mmp/include/mach/gpio-pxa.h b/arch/arm/mach-mmp/include/mach/gpio-pxa.h
> new file mode 100644
> index 0000000..c017a98
> --- /dev/null
> +++ b/arch/arm/mach-mmp/include/mach/gpio-pxa.h
> @@ -0,0 +1,30 @@
> +#ifndef __ASM_MACH_GPIO_PXA_H
> +#define __ASM_MACH_GPIO_PXA_H
> +
> +#include <mach/addr-map.h>
> +#include <mach/irqs.h>
> +
> +#define GPIO_REGS_VIRT (APB_VIRT_BASE + 0x19000)
> +
> +#define BANK_OFF(n)    (((n) < 3) ? (n) << 2 : 0x100 + (((n) - 3) << 2))
> +#define GPIO_REG(x)    (*((volatile u32 *)(GPIO_REGS_VIRT + (x))))
> +
> +#define NR_BUILTIN_GPIO                IRQ_GPIO_NUM
> +
> +#define gpio_to_bank(gpio)     ((gpio) >> 5)
> +
> +/* NOTE: these macros are defined here to make optimization of
> + * gpio_{get,set}_value() to work when 'gpio' is a constant.
> + * Usage of these macros otherwise is no longer recommended,
> + * use generic GPIO API whenever possible.
> + */
> +#define GPIO_bit(gpio) (1 << ((gpio) & 0x1f))
> +
> +#define GPLR(x)                GPIO_REG(BANK_OFF(gpio_to_bank(x)) + 0x00)
> +#define GPDR(x)                GPIO_REG(BANK_OFF(gpio_to_bank(x)) + 0x0c)
> +#define GPSR(x)                GPIO_REG(BANK_OFF(gpio_to_bank(x)) + 0x18)
> +#define GPCR(x)                GPIO_REG(BANK_OFF(gpio_to_bank(x)) + 0x24)
> +
> +#include <plat/gpio-pxa.h>
> +
> +#endif /* __ASM_MACH_GPIO_PXA_H */
> diff --git a/arch/arm/mach-mmp/include/mach/gpio.h b/arch/arm/mach-mmp/include/mach/gpio.h
> index 7bfb827..6812623 100644
> --- a/arch/arm/mach-mmp/include/mach/gpio.h
> +++ b/arch/arm/mach-mmp/include/mach/gpio.h
> @@ -1,36 +1,13 @@
>  #ifndef __ASM_MACH_GPIO_H
>  #define __ASM_MACH_GPIO_H
>
> -#include <mach/addr-map.h>
> -#include <mach/irqs.h>
>  #include <asm-generic/gpio.h>
>
> -#define GPIO_REGS_VIRT (APB_VIRT_BASE + 0x19000)
> -
> -#define BANK_OFF(n)    (((n) < 3) ? (n) << 2 : 0x100 + (((n) - 3) << 2))
> -#define GPIO_REG(x)    (*((volatile u32 *)(GPIO_REGS_VIRT + (x))))
> -
> -#define NR_BUILTIN_GPIO                IRQ_GPIO_NUM
> -
> -#define gpio_to_bank(gpio)     ((gpio) >> 5)
>  #define gpio_to_irq(gpio)      (IRQ_GPIO_START + (gpio))
>  #define irq_to_gpio(irq)       ((irq) - IRQ_GPIO_START)
>
> -
>  #define __gpio_is_inverted(gpio)       (0)
>  #define __gpio_is_occupied(gpio)       (0)
>
> -/* NOTE: these macros are defined here to make optimization of
> - * gpio_{get,set}_value() to work when 'gpio' is a constant.
> - * Usage of these macros otherwise is no longer recommended,
> - * use generic GPIO API whenever possible.
> - */
> -#define GPIO_bit(gpio) (1 << ((gpio) & 0x1f))
> -
> -#define GPLR(x)                GPIO_REG(BANK_OFF(gpio_to_bank(x)) + 0x00)
> -#define GPDR(x)                GPIO_REG(BANK_OFF(gpio_to_bank(x)) + 0x0c)
> -#define GPSR(x)                GPIO_REG(BANK_OFF(gpio_to_bank(x)) + 0x18)
> -#define GPCR(x)                GPIO_REG(BANK_OFF(gpio_to_bank(x)) + 0x24)
> -
>  #include <plat/gpio.h>
>  #endif /* __ASM_MACH_GPIO_H */
> diff --git a/arch/arm/mach-mmp/jasper.c b/arch/arm/mach-mmp/jasper.c
> index 5d6421d..8bfac66 100644
> --- a/arch/arm/mach-mmp/jasper.c
> +++ b/arch/arm/mach-mmp/jasper.c
> @@ -14,7 +14,6 @@
>  #include <linux/kernel.h>
>  #include <linux/platform_device.h>
>  #include <linux/io.h>
> -#include <linux/gpio.h>
>  #include <linux/regulator/machine.h>
>  #include <linux/regulator/max8649.h>
>  #include <linux/mfd/max8925.h>
> diff --git a/arch/arm/mach-mmp/mmp2.c b/arch/arm/mach-mmp/mmp2.c
> index 1935834..65d8689e 100644
> --- a/arch/arm/mach-mmp/mmp2.c
> +++ b/arch/arm/mach-mmp/mmp2.c
> @@ -9,7 +9,6 @@
>  * it under the terms of the GNU General Public License version 2 as
>  * published by the Free Software Foundation.
>  */
> -#include <linux/gpio.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/init.h>
> @@ -25,6 +24,7 @@
>  #include <mach/irqs.h>
>  #include <mach/dma.h>
>  #include <mach/mfp.h>
> +#include <mach/gpio-pxa.h>
>  #include <mach/devices.h>
>  #include <mach/mmp2.h>
>
> diff --git a/arch/arm/mach-mmp/pxa168.c b/arch/arm/mach-mmp/pxa168.c
> index 9581551..50c1763 100644
> --- a/arch/arm/mach-mmp/pxa168.c
> +++ b/arch/arm/mach-mmp/pxa168.c
> @@ -7,7 +7,6 @@
>  * it under the terms of the GNU General Public License version 2 as
>  * published by the Free Software Foundation.
>  */
> -#include <linux/gpio.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/init.h>
> @@ -21,6 +20,7 @@
>  #include <mach/regs-apbc.h>
>  #include <mach/regs-apmu.h>
>  #include <mach/irqs.h>
> +#include <mach/gpio-pxa.h>
>  #include <mach/dma.h>
>  #include <mach/devices.h>
>  #include <mach/mfp.h>
> diff --git a/arch/arm/mach-mmp/pxa910.c b/arch/arm/mach-mmp/pxa910.c
> index c70b4dd..4ebbfbb 100644
> --- a/arch/arm/mach-mmp/pxa910.c
> +++ b/arch/arm/mach-mmp/pxa910.c
> @@ -7,7 +7,6 @@
>  * it under the terms of the GNU General Public License version 2 as
>  * published by the Free Software Foundation.
>  */
> -#include <linux/gpio.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/init.h>
> @@ -20,6 +19,7 @@
>  #include <mach/regs-apmu.h>
>  #include <mach/cputype.h>
>  #include <mach/irqs.h>
> +#include <mach/gpio-pxa.h>
>  #include <mach/dma.h>
>  #include <mach/mfp.h>
>  #include <mach/devices.h>
> diff --git a/arch/arm/mach-mmp/tavorevb.c b/arch/arm/mach-mmp/tavorevb.c
> index 143e52e..eb5be87 100644
> --- a/arch/arm/mach-mmp/tavorevb.c
> +++ b/arch/arm/mach-mmp/tavorevb.c
> @@ -12,6 +12,7 @@
>  #include <linux/kernel.h>
>  #include <linux/platform_device.h>
>  #include <linux/smc91x.h>
> +#include <linux/gpio.h>
>
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
> diff --git a/arch/arm/mach-pxa/cm-x255.c b/arch/arm/mach-pxa/cm-x255.c
> index 93f59f8..be75147 100644
> --- a/arch/arm/mach-pxa/cm-x255.c
> +++ b/arch/arm/mach-pxa/cm-x255.c
> @@ -11,7 +11,6 @@
>
>  #include <linux/platform_device.h>
>  #include <linux/irq.h>
> -#include <linux/gpio.h>
>  #include <linux/mtd/partitions.h>
>  #include <linux/mtd/physmap.h>
>  #include <linux/mtd/nand-gpio.h>
> diff --git a/arch/arm/mach-pxa/include/mach/gpio-pxa.h b/arch/arm/mach-pxa/include/mach/gpio-pxa.h
> new file mode 100644
> index 0000000..41b4c93
> --- /dev/null
> +++ b/arch/arm/mach-pxa/include/mach/gpio-pxa.h
> @@ -0,0 +1,133 @@
> +/*
> + * Written by Philipp Zabel <philipp.zabel@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
> + *
> + */
> +#ifndef __MACH_PXA_GPIO_PXA_H
> +#define __MACH_PXA_GPIO_PXA_H
> +
> +#include <mach/irqs.h>
> +#include <mach/hardware.h>
> +
> +#define GPIO_REGS_VIRT io_p2v(0x40E00000)
> +
> +#define BANK_OFF(n)    (((n) < 3) ? (n) << 2 : 0x100 + (((n) - 3) << 2))
> +#define GPIO_REG(x)    (*(volatile u32 *)(GPIO_REGS_VIRT + (x)))
> +
> +/* GPIO Pin Level Registers */
> +#define GPLR0          GPIO_REG(BANK_OFF(0) + 0x00)
> +#define GPLR1          GPIO_REG(BANK_OFF(1) + 0x00)
> +#define GPLR2          GPIO_REG(BANK_OFF(2) + 0x00)
> +#define GPLR3          GPIO_REG(BANK_OFF(3) + 0x00)
> +
> +/* GPIO Pin Direction Registers */
> +#define GPDR0          GPIO_REG(BANK_OFF(0) + 0x0c)
> +#define GPDR1          GPIO_REG(BANK_OFF(1) + 0x0c)
> +#define GPDR2          GPIO_REG(BANK_OFF(2) + 0x0c)
> +#define GPDR3          GPIO_REG(BANK_OFF(3) + 0x0c)
> +
> +/* GPIO Pin Output Set Registers */
> +#define GPSR0          GPIO_REG(BANK_OFF(0) + 0x18)
> +#define GPSR1          GPIO_REG(BANK_OFF(1) + 0x18)
> +#define GPSR2          GPIO_REG(BANK_OFF(2) + 0x18)
> +#define GPSR3          GPIO_REG(BANK_OFF(3) + 0x18)
> +
> +/* GPIO Pin Output Clear Registers */
> +#define GPCR0          GPIO_REG(BANK_OFF(0) + 0x24)
> +#define GPCR1          GPIO_REG(BANK_OFF(1) + 0x24)
> +#define GPCR2          GPIO_REG(BANK_OFF(2) + 0x24)
> +#define GPCR3          GPIO_REG(BANK_OFF(3) + 0x24)
> +
> +/* GPIO Rising Edge Detect Registers */
> +#define GRER0          GPIO_REG(BANK_OFF(0) + 0x30)
> +#define GRER1          GPIO_REG(BANK_OFF(1) + 0x30)
> +#define GRER2          GPIO_REG(BANK_OFF(2) + 0x30)
> +#define GRER3          GPIO_REG(BANK_OFF(3) + 0x30)
> +
> +/* GPIO Falling Edge Detect Registers */
> +#define GFER0          GPIO_REG(BANK_OFF(0) + 0x3c)
> +#define GFER1          GPIO_REG(BANK_OFF(1) + 0x3c)
> +#define GFER2          GPIO_REG(BANK_OFF(2) + 0x3c)
> +#define GFER3          GPIO_REG(BANK_OFF(3) + 0x3c)
> +
> +/* GPIO Edge Detect Status Registers */
> +#define GEDR0          GPIO_REG(BANK_OFF(0) + 0x48)
> +#define GEDR1          GPIO_REG(BANK_OFF(1) + 0x48)
> +#define GEDR2          GPIO_REG(BANK_OFF(2) + 0x48)
> +#define GEDR3          GPIO_REG(BANK_OFF(3) + 0x48)
> +
> +/* GPIO Alternate Function Select Registers */
> +#define GAFR0_L                GPIO_REG(0x0054)
> +#define GAFR0_U                GPIO_REG(0x0058)
> +#define GAFR1_L                GPIO_REG(0x005C)
> +#define GAFR1_U                GPIO_REG(0x0060)
> +#define GAFR2_L                GPIO_REG(0x0064)
> +#define GAFR2_U                GPIO_REG(0x0068)
> +#define GAFR3_L                GPIO_REG(0x006C)
> +#define GAFR3_U                GPIO_REG(0x0070)
> +
> +/* More handy macros.  The argument is a literal GPIO number. */
> +
> +#define GPIO_bit(x)    (1 << ((x) & 0x1f))
> +
> +#define GPLR(x)                GPIO_REG(BANK_OFF((x) >> 5) + 0x00)
> +#define GPDR(x)                GPIO_REG(BANK_OFF((x) >> 5) + 0x0c)
> +#define GPSR(x)                GPIO_REG(BANK_OFF((x) >> 5) + 0x18)
> +#define GPCR(x)                GPIO_REG(BANK_OFF((x) >> 5) + 0x24)
> +#define GRER(x)                GPIO_REG(BANK_OFF((x) >> 5) + 0x30)
> +#define GFER(x)                GPIO_REG(BANK_OFF((x) >> 5) + 0x3c)
> +#define GEDR(x)                GPIO_REG(BANK_OFF((x) >> 5) + 0x48)
> +#define GAFR(x)                GPIO_REG(0x54 + (((x) & 0x70) >> 2))
> +
> +
> +#define NR_BUILTIN_GPIO                PXA_GPIO_IRQ_NUM
> +
> +#define gpio_to_bank(gpio)     ((gpio) >> 5)
> +
> +#ifdef CONFIG_CPU_PXA26x
> +/* GPIO86/87/88/89 on PXA26x have their direction bits in GPDR2 inverted,
> + * as well as their Alternate Function value being '1' for GPIO in GAFRx.
> + */
> +static inline int __gpio_is_inverted(unsigned gpio)
> +{
> +       return cpu_is_pxa25x() && gpio > 85;
> +}
> +#else
> +static inline int __gpio_is_inverted(unsigned gpio) { return 0; }
> +#endif
> +
> +/*
> + * On PXA25x and PXA27x, GAFRx and GPDRx together decide the alternate
> + * function of a GPIO, and GPDRx cannot be altered once configured. It
> + * is attributed as "occupied" here (I know this terminology isn't
> + * accurate, you are welcome to propose a better one :-)
> + */
> +static inline int __gpio_is_occupied(unsigned gpio)
> +{
> +       if (cpu_is_pxa27x() || cpu_is_pxa25x()) {
> +               int af = (GAFR(gpio) >> ((gpio & 0xf) * 2)) & 0x3;
> +               int dir = GPDR(gpio) & GPIO_bit(gpio);
> +
> +               if (__gpio_is_inverted(gpio))
> +                       return af != 1 || dir == 0;
> +               else
> +                       return af != 0 || dir != 0;
> +       } else
> +               return GPDR(gpio) & GPIO_bit(gpio);
> +}
> +
> +#include <plat/gpio-pxa.h>
> +#endif /* __MACH_PXA_GPIO_PXA_H */
> diff --git a/arch/arm/mach-pxa/include/mach/gpio.h b/arch/arm/mach-pxa/include/mach/gpio.h
> index c463950..004cade 100644
> --- a/arch/arm/mach-pxa/include/mach/gpio.h
> +++ b/arch/arm/mach-pxa/include/mach/gpio.h
> @@ -24,84 +24,10 @@
>  #ifndef __ASM_ARCH_PXA_GPIO_H
>  #define __ASM_ARCH_PXA_GPIO_H
>
> -#include <mach/irqs.h>
> -#include <mach/hardware.h>
>  #include <asm-generic/gpio.h>
> +/* The defines for the driver are needed for the accelerated accessors */
> +#include "gpio-pxa.h"
>
> -#define GPIO_REGS_VIRT io_p2v(0x40E00000)
> -
> -#define BANK_OFF(n)    (((n) < 3) ? (n) << 2 : 0x100 + (((n) - 3) << 2))
> -#define GPIO_REG(x)    (*(volatile u32 *)(GPIO_REGS_VIRT + (x)))
> -
> -/* GPIO Pin Level Registers */
> -#define GPLR0          GPIO_REG(BANK_OFF(0) + 0x00)
> -#define GPLR1          GPIO_REG(BANK_OFF(1) + 0x00)
> -#define GPLR2          GPIO_REG(BANK_OFF(2) + 0x00)
> -#define GPLR3          GPIO_REG(BANK_OFF(3) + 0x00)
> -
> -/* GPIO Pin Direction Registers */
> -#define GPDR0          GPIO_REG(BANK_OFF(0) + 0x0c)
> -#define GPDR1          GPIO_REG(BANK_OFF(1) + 0x0c)
> -#define GPDR2          GPIO_REG(BANK_OFF(2) + 0x0c)
> -#define GPDR3          GPIO_REG(BANK_OFF(3) + 0x0c)
> -
> -/* GPIO Pin Output Set Registers */
> -#define GPSR0          GPIO_REG(BANK_OFF(0) + 0x18)
> -#define GPSR1          GPIO_REG(BANK_OFF(1) + 0x18)
> -#define GPSR2          GPIO_REG(BANK_OFF(2) + 0x18)
> -#define GPSR3          GPIO_REG(BANK_OFF(3) + 0x18)
> -
> -/* GPIO Pin Output Clear Registers */
> -#define GPCR0          GPIO_REG(BANK_OFF(0) + 0x24)
> -#define GPCR1          GPIO_REG(BANK_OFF(1) + 0x24)
> -#define GPCR2          GPIO_REG(BANK_OFF(2) + 0x24)
> -#define GPCR3          GPIO_REG(BANK_OFF(3) + 0x24)
> -
> -/* GPIO Rising Edge Detect Registers */
> -#define GRER0          GPIO_REG(BANK_OFF(0) + 0x30)
> -#define GRER1          GPIO_REG(BANK_OFF(1) + 0x30)
> -#define GRER2          GPIO_REG(BANK_OFF(2) + 0x30)
> -#define GRER3          GPIO_REG(BANK_OFF(3) + 0x30)
> -
> -/* GPIO Falling Edge Detect Registers */
> -#define GFER0          GPIO_REG(BANK_OFF(0) + 0x3c)
> -#define GFER1          GPIO_REG(BANK_OFF(1) + 0x3c)
> -#define GFER2          GPIO_REG(BANK_OFF(2) + 0x3c)
> -#define GFER3          GPIO_REG(BANK_OFF(3) + 0x3c)
> -
> -/* GPIO Edge Detect Status Registers */
> -#define GEDR0          GPIO_REG(BANK_OFF(0) + 0x48)
> -#define GEDR1          GPIO_REG(BANK_OFF(1) + 0x48)
> -#define GEDR2          GPIO_REG(BANK_OFF(2) + 0x48)
> -#define GEDR3          GPIO_REG(BANK_OFF(3) + 0x48)
> -
> -/* GPIO Alternate Function Select Registers */
> -#define GAFR0_L                GPIO_REG(0x0054)
> -#define GAFR0_U                GPIO_REG(0x0058)
> -#define GAFR1_L                GPIO_REG(0x005C)
> -#define GAFR1_U                GPIO_REG(0x0060)
> -#define GAFR2_L                GPIO_REG(0x0064)
> -#define GAFR2_U                GPIO_REG(0x0068)
> -#define GAFR3_L                GPIO_REG(0x006C)
> -#define GAFR3_U                GPIO_REG(0x0070)
> -
> -/* More handy macros.  The argument is a literal GPIO number. */
> -
> -#define GPIO_bit(x)    (1 << ((x) & 0x1f))
> -
> -#define GPLR(x)                GPIO_REG(BANK_OFF((x) >> 5) + 0x00)
> -#define GPDR(x)                GPIO_REG(BANK_OFF((x) >> 5) + 0x0c)
> -#define GPSR(x)                GPIO_REG(BANK_OFF((x) >> 5) + 0x18)
> -#define GPCR(x)                GPIO_REG(BANK_OFF((x) >> 5) + 0x24)
> -#define GRER(x)                GPIO_REG(BANK_OFF((x) >> 5) + 0x30)
> -#define GFER(x)                GPIO_REG(BANK_OFF((x) >> 5) + 0x3c)
> -#define GEDR(x)                GPIO_REG(BANK_OFF((x) >> 5) + 0x48)
> -#define GAFR(x)                GPIO_REG(0x54 + (((x) & 0x70) >> 2))
> -
> -
> -#define NR_BUILTIN_GPIO                PXA_GPIO_IRQ_NUM
> -
> -#define gpio_to_bank(gpio)     ((gpio) >> 5)
>  #define gpio_to_irq(gpio)      IRQ_GPIO(gpio)
>
>  static inline int irq_to_gpio(unsigned int irq)
> @@ -118,37 +44,5 @@ static inline int irq_to_gpio(unsigned int irq)
>        return -1;
>  }
>
> -#ifdef CONFIG_CPU_PXA26x
> -/* GPIO86/87/88/89 on PXA26x have their direction bits in GPDR2 inverted,
> - * as well as their Alternate Function value being '1' for GPIO in GAFRx.
> - */
> -static inline int __gpio_is_inverted(unsigned gpio)
> -{
> -       return cpu_is_pxa25x() && gpio > 85;
> -}
> -#else
> -static inline int __gpio_is_inverted(unsigned gpio) { return 0; }
> -#endif
> -
> -/*
> - * On PXA25x and PXA27x, GAFRx and GPDRx together decide the alternate
> - * function of a GPIO, and GPDRx cannot be altered once configured. It
> - * is attributed as "occupied" here (I know this terminology isn't
> - * accurate, you are welcome to propose a better one :-)
> - */
> -static inline int __gpio_is_occupied(unsigned gpio)
> -{
> -       if (cpu_is_pxa27x() || cpu_is_pxa25x()) {
> -               int af = (GAFR(gpio) >> ((gpio & 0xf) * 2)) & 0x3;
> -               int dir = GPDR(gpio) & GPIO_bit(gpio);
> -
> -               if (__gpio_is_inverted(gpio))
> -                       return af != 1 || dir == 0;
> -               else
> -                       return af != 0 || dir != 0;
> -       } else
> -               return GPDR(gpio) & GPIO_bit(gpio);
> -}
> -
>  #include <plat/gpio.h>
>  #endif
> diff --git a/arch/arm/mach-pxa/include/mach/littleton.h b/arch/arm/mach-pxa/include/mach/littleton.h
> index 1c585a7..b6238cb 100644
> --- a/arch/arm/mach-pxa/include/mach/littleton.h
> +++ b/arch/arm/mach-pxa/include/mach/littleton.h
> @@ -1,7 +1,7 @@
>  #ifndef __ASM_ARCH_LITTLETON_H
>  #define __ASM_ARCH_LITTLETON_H
>
> -#include <asm/gpio.h>
> +#include <mach/gpio-pxa.h>
>
>  #define LITTLETON_ETH_PHYS     0x30000000
>
> diff --git a/arch/arm/mach-pxa/irq.c b/arch/arm/mach-pxa/irq.c
> index dafb4bf..d493a23 100644
> --- a/arch/arm/mach-pxa/irq.c
> +++ b/arch/arm/mach-pxa/irq.c
> @@ -11,7 +11,6 @@
>  *  it under the terms of the GNU General Public License version 2 as
>  *  published by the Free Software Foundation.
>  */
> -#include <linux/gpio.h>
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/interrupt.h>
> @@ -21,6 +20,7 @@
>
>  #include <mach/hardware.h>
>  #include <mach/irqs.h>
> +#include <mach/gpio-pxa.h>
>
>  #include "generic.h"
>
> diff --git a/arch/arm/mach-pxa/mfp-pxa2xx.c b/arch/arm/mach-pxa/mfp-pxa2xx.c
> index b129527..43a5f68 100644
> --- a/arch/arm/mach-pxa/mfp-pxa2xx.c
> +++ b/arch/arm/mach-pxa/mfp-pxa2xx.c
> @@ -20,6 +20,7 @@
>
>  #include <mach/pxa2xx-regs.h>
>  #include <mach/mfp-pxa2xx.h>
> +#include <mach/gpio-pxa.h>
>
>  #include "generic.h"
>
> diff --git a/arch/arm/mach-pxa/pxa25x.c b/arch/arm/mach-pxa/pxa25x.c
> index 6bb3fa5..8746e10 100644
> --- a/arch/arm/mach-pxa/pxa25x.c
> +++ b/arch/arm/mach-pxa/pxa25x.c
> @@ -24,6 +24,7 @@
>  #include <linux/suspend.h>
>  #include <linux/syscore_ops.h>
>  #include <linux/irq.h>
> +#include <linux/gpio.h>
>
>  #include <asm/mach/map.h>
>  #include <asm/suspend.h>
> diff --git a/arch/arm/mach-pxa/pxa27x.c b/arch/arm/mach-pxa/pxa27x.c
> index d2cdcd6..2bb5cf8 100644
> --- a/arch/arm/mach-pxa/pxa27x.c
> +++ b/arch/arm/mach-pxa/pxa27x.c
> @@ -21,6 +21,7 @@
>  #include <linux/io.h>
>  #include <linux/irq.h>
>  #include <linux/i2c/pxa-i2c.h>
> +#include <linux/gpio.h>
>
>  #include <asm/mach/map.h>
>  #include <mach/hardware.h>
> diff --git a/arch/arm/mach-pxa/pxa3xx.c b/arch/arm/mach-pxa/pxa3xx.c
> index 3ab9e84..f940a13 100644
> --- a/arch/arm/mach-pxa/pxa3xx.c
> +++ b/arch/arm/mach-pxa/pxa3xx.c
> @@ -12,7 +12,6 @@
>  * it under the terms of the GNU General Public License version 2 as
>  * published by the Free Software Foundation.
>  */
> -#include <linux/gpio.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/init.h>
> @@ -26,6 +25,7 @@
>  #include <asm/mach/map.h>
>  #include <asm/suspend.h>
>  #include <mach/hardware.h>
> +#include <mach/gpio-pxa.h>
>  #include <mach/pxa3xx-regs.h>
>  #include <mach/reset.h>
>  #include <mach/ohci.h>
> diff --git a/arch/arm/mach-pxa/pxa95x.c b/arch/arm/mach-pxa/pxa95x.c
> index de25ceb..51371b3 100644
> --- a/arch/arm/mach-pxa/pxa95x.c
> +++ b/arch/arm/mach-pxa/pxa95x.c
> @@ -9,7 +9,6 @@
>  * it under the terms of the GNU General Public License version 2 as
>  * published by the Free Software Foundation.
>  */
> -#include <linux/gpio.h>
>  #include <linux/module.h>
>  #include <linux/kernel.h>
>  #include <linux/init.h>
> @@ -21,6 +20,7 @@
>  #include <linux/syscore_ops.h>
>
>  #include <mach/hardware.h>
> +#include <mach/gpio-pxa.h>
>  #include <mach/pxa3xx-regs.h>
>  #include <mach/pxa930.h>
>  #include <mach/reset.h>
> diff --git a/arch/arm/mach-pxa/saarb.c b/arch/arm/mach-pxa/saarb.c
> index 87e9b75..eb6a10d 100644
> --- a/arch/arm/mach-pxa/saarb.c
> +++ b/arch/arm/mach-pxa/saarb.c
> @@ -15,6 +15,7 @@
>  #include <linux/i2c.h>
>  #include <linux/i2c/pxa-i2c.h>
>  #include <linux/mfd/88pm860x.h>
> +#include <linux/gpio.h>
>
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
> diff --git a/arch/arm/plat-pxa/include/plat/gpio-pxa.h b/arch/arm/plat-pxa/include/plat/gpio-pxa.h
> new file mode 100644
> index 0000000..b6390be
> --- /dev/null
> +++ b/arch/arm/plat-pxa/include/plat/gpio-pxa.h
> @@ -0,0 +1,44 @@
> +#ifndef __PLAT_PXA_GPIO_H
> +#define __PLAT_PXA_GPIO_H
> +
> +struct irq_data;
> +
> +/*
> + * We handle the GPIOs by banks, each bank covers up to 32 GPIOs with
> + * one set of registers. The register offsets are organized below:
> + *
> + *           GPLR    GPDR    GPSR    GPCR    GRER    GFER    GEDR
> + * BANK 0 - 0x0000  0x000C  0x0018  0x0024  0x0030  0x003C  0x0048
> + * BANK 1 - 0x0004  0x0010  0x001C  0x0028  0x0034  0x0040  0x004C
> + * BANK 2 - 0x0008  0x0014  0x0020  0x002C  0x0038  0x0044  0x0050
> + *
> + * BANK 3 - 0x0100  0x010C  0x0118  0x0124  0x0130  0x013C  0x0148
> + * BANK 4 - 0x0104  0x0110  0x011C  0x0128  0x0134  0x0140  0x014C
> + * BANK 5 - 0x0108  0x0114  0x0120  0x012C  0x0138  0x0144  0x0150
> + *
> + * NOTE:
> + *   BANK 3 is only available on PXA27x and later processors.
> + *   BANK 4 and 5 are only available on PXA935
> + */
> +
> +#define GPIO_BANK(n)   (GPIO_REGS_VIRT + BANK_OFF(n))
> +
> +#define GPLR_OFFSET    0x00
> +#define GPDR_OFFSET    0x0C
> +#define GPSR_OFFSET    0x18
> +#define GPCR_OFFSET    0x24
> +#define GRER_OFFSET    0x30
> +#define GFER_OFFSET    0x3C
> +#define GEDR_OFFSET    0x48
> +
> +/* NOTE: some PXAs have fewer on-chip GPIOs (like PXA255, with 85).
> + * Those cases currently cause holes in the GPIO number space, the
> + * actual number of the last GPIO is recorded by 'pxa_last_gpio'.
> + */
> +extern int pxa_last_gpio;
> +
> +typedef int (*set_wake_t)(struct irq_data *d, unsigned int on);
> +
> +extern void pxa_init_gpio(int mux_irq, int start, int end, set_wake_t fn);
> +
> +#endif /* __PLAT_PXA_GPIO_H */
> diff --git a/arch/arm/plat-pxa/include/plat/gpio.h b/arch/arm/plat-pxa/include/plat/gpio.h
> index 6fc41db..258f772 100644
> --- a/arch/arm/plat-pxa/include/plat/gpio.h
> +++ b/arch/arm/plat-pxa/include/plat/gpio.h
> @@ -3,35 +3,8 @@
>
>  #define __ARM_GPIOLIB_COMPLEX
>
> -struct irq_data;
> -
> -/*
> - * We handle the GPIOs by banks, each bank covers up to 32 GPIOs with
> - * one set of registers. The register offsets are organized below:
> - *
> - *           GPLR    GPDR    GPSR    GPCR    GRER    GFER    GEDR
> - * BANK 0 - 0x0000  0x000C  0x0018  0x0024  0x0030  0x003C  0x0048
> - * BANK 1 - 0x0004  0x0010  0x001C  0x0028  0x0034  0x0040  0x004C
> - * BANK 2 - 0x0008  0x0014  0x0020  0x002C  0x0038  0x0044  0x0050
> - *
> - * BANK 3 - 0x0100  0x010C  0x0118  0x0124  0x0130  0x013C  0x0148
> - * BANK 4 - 0x0104  0x0110  0x011C  0x0128  0x0134  0x0140  0x014C
> - * BANK 5 - 0x0108  0x0114  0x0120  0x012C  0x0138  0x0144  0x0150
> - *
> - * NOTE:
> - *   BANK 3 is only available on PXA27x and later processors.
> - *   BANK 4 and 5 are only available on PXA935
> - */
> -
> -#define GPIO_BANK(n)   (GPIO_REGS_VIRT + BANK_OFF(n))
> -
> -#define GPLR_OFFSET    0x00
> -#define GPDR_OFFSET    0x0C
> -#define GPSR_OFFSET    0x18
> -#define GPCR_OFFSET    0x24
> -#define GRER_OFFSET    0x30
> -#define GFER_OFFSET    0x3C
> -#define GEDR_OFFSET    0x48
> +/* The individual machine provides register offsets and NR_BUILTIN_GPIO */
> +#include <mach/gpio-pxa.h>
>
>  static inline int gpio_get_value(unsigned gpio)
>  {
> @@ -54,13 +27,4 @@ static inline void gpio_set_value(unsigned gpio, int value)
>
>  #define gpio_cansleep          __gpio_cansleep
>
> -/* NOTE: some PXAs have fewer on-chip GPIOs (like PXA255, with 85).
> - * Those cases currently cause holes in the GPIO number space, the
> - * actual number of the last GPIO is recorded by 'pxa_last_gpio'.
> - */
> -extern int pxa_last_gpio;
> -
> -typedef int (*set_wake_t)(struct irq_data *d, unsigned int on);
> -
> -extern void pxa_init_gpio(int mux_irq, int start, int end, set_wake_t fn);
>  #endif /* __PLAT_GPIO_H */
> diff --git a/drivers/gpio/gpio-pxa.c b/drivers/gpio/gpio-pxa.c
> index 5d6a86b..9052925 100644
> --- a/drivers/gpio/gpio-pxa.c
> +++ b/drivers/gpio/gpio-pxa.c
> @@ -18,6 +18,8 @@
>  #include <linux/syscore_ops.h>
>  #include <linux/slab.h>
>
> +#include <mach/gpio-pxa.h>
> +
>  int pxa_last_gpio;
>
>  struct pxa_gpio_chip {
> --
> 1.7.3.2
>
>
