Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab0IHFgV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 01:36:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47169 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab0IHFgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 01:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=WIQqJU50hr5XG2Dv3BzhkepdE/N2BeC8mZsdzq14T/WEwGzM6NvpVY34h33CKT0vFH
         GNTZz8lAHA2bRcx3WFw0TF9vpCW0JQDYNvYvwcbInmCGtMJSvo5MnyWgfbk12bSTvGcm
         hkFsbGXtvyNiIfC/5kF7EGiSnh3OPEo3c8rrc=
MIME-Version: 1.0
In-Reply-To: <1283914607-10570-2-git-send-email-mark.brown314@gmail.com>
References: <1283914607-10570-1-git-send-email-mark.brown314@gmail.com>
	<1283914607-10570-2-git-send-email-mark.brown314@gmail.com>
Date: Wed, 8 Sep 2010 13:36:17 +0800
Message-ID: <AANLkTikyXsjQadWfp4iZyWGygLtg+kNuuKxdtsoEK6cz@mail.gmail.com>
Subject: Re: [PATCH 1/3] ARM: pxa168: added support for Teton BGA platform
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: "Mark F. Brown" <mark.brown314@gmail.com>
Cc: Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 8, 2010 at 10:56 AM, Mark F. Brown <mark.brown314@gmail.com> wrote:
> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
> ---
>  arch/arm/mach-mmp/Kconfig     |    7 ++++++
>  arch/arm/mach-mmp/Makefile    |    1 +
>  arch/arm/mach-mmp/teton_bga.c |   47 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 55 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-mmp/teton_bga.c
>
> diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig
> index 6ab843e..0711d3b 100644
> --- a/arch/arm/mach-mmp/Kconfig
> +++ b/arch/arm/mach-mmp/Kconfig
> @@ -57,6 +57,13 @@ config MACH_MARVELL_JASPER
>          PXA910-based development board. Since MMP2 is compatible to
>          ARMv6 architecture.
>
> +config MACH_TETON_BGA
> +       bool "Marvell's PXA168 Teton BGA Development Board"
> +       select CPU_PXA168
> +       help
> +         Say 'Y' here if you want to support the Marvell PXA168-based
> +         Teton BGA Development Board.
> +
>  endmenu
>
>  config CPU_PXA168
> diff --git a/arch/arm/mach-mmp/Makefile b/arch/arm/mach-mmp/Makefile
> index 8b66d06..751cdbf 100644
> --- a/arch/arm/mach-mmp/Makefile
> +++ b/arch/arm/mach-mmp/Makefile
> @@ -17,3 +17,4 @@ obj-$(CONFIG_MACH_TAVOREVB)   += tavorevb.o
>  obj-$(CONFIG_MACH_TTC_DKB)     += ttc_dkb.o
>  obj-$(CONFIG_MACH_FLINT)       += flint.o
>  obj-$(CONFIG_MACH_MARVELL_JASPER) += jasper.o
> +obj-$(CONFIG_MACH_TETON_BGA)   += teton_bga.o
> diff --git a/arch/arm/mach-mmp/teton_bga.c b/arch/arm/mach-mmp/teton_bga.c
> new file mode 100644
> index 0000000..014cc37
> --- /dev/null
> +++ b/arch/arm/mach-mmp/teton_bga.c
> @@ -0,0 +1,47 @@
> +/*
> + *  linux/arch/arm/mach-mmp/teton_bga.c
> + *
> + *  Support for the Marvell PXA168 Teton BGA Development Platform.
> + *
> + *  This code is based on aspenite.c
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  publishhed by the Free Software Foundation.
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +
> +#include <asm/mach-types.h>
> +#include <asm/mach/arch.h>
> +#include <mach/addr-map.h>
> +#include <mach/mfp-pxa168.h>
> +#include <mach/pxa168.h>
> +#include <mach/gpio.h>
> +
> +#include "common.h"
> +
> +static unsigned long teton_bga_pin_config[] __initdata = {
> +       /* UART1 */
> +       GPIO107_UART1_TXD,
> +       GPIO108_UART1_RXD,
> +};
> +
> +static void __init teton_bga_init(void)
> +{
> +       mfp_config(ARRAY_AND_SIZE(teton_bga_pin_config));
> +
> +       /* on-chip devices */
> +       pxa168_add_uart(1);
> +}
> +
> +MACHINE_START(TETON_BGA, "PXA168-based Teton BGA Development Platform")
> +       .phys_io        = APB_PHYS_BASE,
> +       .io_pg_offst    = (APB_VIRT_BASE >> 18) & 0xfffc,
> +       .map_io         = mmp_map_io,
> +       .init_irq       = pxa168_init_irq,
> +       .timer          = &pxa168_timer,
> +       .init_machine   = teton_bga_init,
> +MACHINE_END
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Acked
