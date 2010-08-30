Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab0H3MK3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:10:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39017 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab0H3MK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:10:28 -0400
Date: Mon, 30 Aug 2010 21:10:39 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 2/3] ARM: Samsung S5P: Use the Samsung S5P series common
	IRQ type
In-reply-to: <20100830114723.GA13144@july>
To: "'Kyungmin Park'" <kmpark@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: jy0922.shim@samsung.com, m.szyprowski@samsung.com, ben-linux@fluff.org
Message-id: <006401cb483c$5ec41ee0$1c4c5ca0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: ActIOSFYTA2y5k3zR/SL9E/8QjUsPgAAfmbQ
References: <20100830114723.GA13144@july>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park wrote:
> 
> From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Remove the local definitions and use the common IRQ type for S5P series
> 
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/mach-s5pc100/include/mach/regs-gpio.h |    7 -------
>  arch/arm/mach-s5pc100/irq-gpio.c               |   16 +++++-----------
>  arch/arm/mach-s5pv210/include/mach/regs-gpio.h |    7 -------
>  arch/arm/plat-s5p/irq-eint.c                   |   11 ++++++-----
>  4 files changed, 11 insertions(+), 30 deletions(-)
> 
> diff --git a/arch/arm/mach-s5pc100/include/mach/regs-gpio.h
b/arch/arm/mach-
> s5pc100/include/mach/regs-gpio.h
> index dd6295e..cc8d674 100644
> --- a/arch/arm/mach-s5pc100/include/mach/regs-gpio.h
> +++ b/arch/arm/mach-s5pc100/include/mach/regs-gpio.h
> @@ -64,12 +64,5 @@
> 
>  #define eint_irq_to_bit(irq)		(1 << (EINT_OFFSET(irq) & 0x7))
> 
> -/* values for S5P_EXTINT0 */
> -#define S5P_EXTINT_LOWLEV		(0x00)
> -#define S5P_EXTINT_HILEV		(0x01)
> -#define S5P_EXTINT_FALLEDGE		(0x02)
> -#define S5P_EXTINT_RISEEDGE		(0x03)
> -#define S5P_EXTINT_BOTHEDGE		(0x04)
> -
>  #endif /* __ASM_MACH_S5PC100_REGS_GPIO_H */
> 
> diff --git a/arch/arm/mach-s5pc100/irq-gpio.c
b/arch/arm/mach-s5pc100/irq-gpio.c
> index 2bf86c1..a75073c 100644
> --- a/arch/arm/mach-s5pc100/irq-gpio.c
> +++ b/arch/arm/mach-s5pc100/irq-gpio.c
> @@ -28,12 +28,6 @@
>  #define MASK_OFFSET_2			0xF00
>  #define PEND_OFFSET_2			0xF40
> 
> -#define GPIOINT_LEVEL_LOW		0x0
> -#define GPIOINT_LEVEL_HIGH		0x1
> -#define GPIOINT_EDGE_FALLING		0x2
> -#define GPIOINT_EDGE_RISING		0x3
> -#define GPIOINT_EDGE_BOTH		0x4
> -
>  static int group_to_con_offset(int group)
>  {
>  	return group << 2;
> @@ -202,19 +196,19 @@ static int s5pc100_gpioint_set_type(unsigned int
irq,
> unsigned int type)
>  		printk(KERN_WARNING "No irq type\n");
>  		return -EINVAL;
>  	case IRQ_TYPE_EDGE_RISING:
> -		type = GPIOINT_EDGE_RISING;
> +		type = S5P_GPIO_EDGE_RISING;
>  		break;
>  	case IRQ_TYPE_EDGE_FALLING:
> -		type = GPIOINT_EDGE_FALLING;
> +		type = S5P_GPIO_EDGE_FALLING;
>  		break;
>  	case IRQ_TYPE_EDGE_BOTH:
> -		type = GPIOINT_EDGE_BOTH;
> +		type = S5P_GPIO_EDGE_BOTH;
>  		break;
>  	case IRQ_TYPE_LEVEL_HIGH:
> -		type = GPIOINT_LEVEL_HIGH;
> +		type = S5P_GPIO_LEVEL_HIGH;
>  		break;
>  	case IRQ_TYPE_LEVEL_LOW:
> -		type = GPIOINT_LEVEL_LOW;
> +		type = S5P_GPIO_LEVEL_LOW;
>  		break;
>  	default:
>  		BUG();
> diff --git a/arch/arm/mach-s5pv210/include/mach/regs-gpio.h
b/arch/arm/mach-
> s5pv210/include/mach/regs-gpio.h
> index 49e029b..de0c899 100644
> --- a/arch/arm/mach-s5pv210/include/mach/regs-gpio.h
> +++ b/arch/arm/mach-s5pv210/include/mach/regs-gpio.h
> @@ -31,13 +31,6 @@
> 
>  #define eint_irq_to_bit(irq)		(1 << (EINT_OFFSET(irq) & 0x7))
> 
> -/* values for S5P_EXTINT0 */
> -#define S5P_EXTINT_LOWLEV		(0x00)
> -#define S5P_EXTINT_HILEV		(0x01)
> -#define S5P_EXTINT_FALLEDGE		(0x02)
> -#define S5P_EXTINT_RISEEDGE		(0x03)
> -#define S5P_EXTINT_BOTHEDGE		(0x04)
> -
>  #define EINT_MODE		S3C_GPIO_SFN(0xf)
> 
>  #define EINT_GPIO_0(x)		S5PV210_GPH0(x)
> diff --git a/arch/arm/plat-s5p/irq-eint.c b/arch/arm/plat-s5p/irq-eint.c
> index f36cd33..4e0d94b 100644
> --- a/arch/arm/plat-s5p/irq-eint.c
> +++ b/arch/arm/plat-s5p/irq-eint.c
> @@ -25,6 +25,7 @@
>  #include <plat/cpu.h>
>  #include <plat/pm.h>
> 
> +#include <plat/gpio-core.h>
>  #include <plat/gpio-cfg.h>
>  #include <mach/regs-gpio.h>
> 
> @@ -67,23 +68,23 @@ static int s5p_irq_eint_set_type(unsigned int irq,
unsigned
> int type)
> 
>  	switch (type) {
>  	case IRQ_TYPE_EDGE_RISING:
> -		newvalue = S5P_EXTINT_RISEEDGE;
> +		newvalue = S5P_GPIO_EDGE_RISING;
>  		break;
> 
>  	case IRQ_TYPE_EDGE_FALLING:
> -		newvalue = S5P_EXTINT_FALLEDGE;
> +		newvalue = S5P_GPIO_EDGE_FALLING;
>  		break;
> 
>  	case IRQ_TYPE_EDGE_BOTH:
> -		newvalue = S5P_EXTINT_BOTHEDGE;
> +		newvalue = S5P_GPIO_EDGE_BOTH;
>  		break;
> 
>  	case IRQ_TYPE_LEVEL_LOW:
> -		newvalue = S5P_EXTINT_LOWLEV;
> +		newvalue = S5P_GPIO_LEVEL_LOW;
>  		break;
> 
>  	case IRQ_TYPE_LEVEL_HIGH:
> -		newvalue = S5P_EXTINT_HILEV;
> +		newvalue = S5P_GPIO_LEVEL_HIGH;
>  		break;
> 
>  	default:
> --

Please refer to other comments of your patches.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

