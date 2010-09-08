Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898Ab0IHPvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:51:31 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42227 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab0IHPv2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=C5OgvW96ev+79OkchcqV3dCoy5JTvoWqC1IDo9dcZrBtLG957pND9Le9is/cAqJZ2g
         KKoe24MHwxuaSaJyDSux6DkRVqlLuD4ysir8SpVxtcqj/EoPK4eh5fVn49YamVzdf/Q+
         gOal+Fnu6gJnqnnm+QEpuQeY9m4alLbdaFfq4=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: pxa168: added support for Teton BGA platform
Date: Wed, 8 Sep 2010 17:51:22 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-1-amd64; KDE/4.4.5; x86_64; ; )
Cc: "Mark F. Brown" <mark.brown314@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-kernel@vger.kernel.org
References: <1283914607-10570-1-git-send-email-mark.brown314@gmail.com> <1283914607-10570-2-git-send-email-mark.brown314@gmail.com>
In-Reply-To: <1283914607-10570-2-git-send-email-mark.brown314@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009081751.22841.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne St 8. září 2010 04:56:45 Mark F. Brown napsal(a):

---------------------------
Description is missing here
---------------------------

> Signed-off-by: Mark F. Brown <mark.brown314@gmail.com>
> ---
>  arch/arm/mach-mmp/Kconfig     |    7 ++++++
>  arch/arm/mach-mmp/Makefile    |    1 +
>  arch/arm/mach-mmp/teton_bga.c |   47
> +++++++++++++++++++++++++++++++++++++++++ 3 files changed, 55
> insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-mmp/teton_bga.c
> 
> diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig
> index 6ab843e..0711d3b 100644
> --- a/arch/arm/mach-mmp/Kconfig
> +++ b/arch/arm/mach-mmp/Kconfig
> @@ -57,6 +57,13 @@ config MACH_MARVELL_JASPER
>  	  PXA910-based development board. Since MMP2 is compatible to
>  	  ARMv6 architecture.
> 
> +config MACH_TETON_BGA
> +	bool "Marvell's PXA168 Teton BGA Development Board"
> +	select CPU_PXA168
> +	help
> +	  Say 'Y' here if you want to support the Marvell PXA168-based
> +	  Teton BGA Development Board.
> +
>  endmenu
> 
>  config CPU_PXA168
> diff --git a/arch/arm/mach-mmp/Makefile b/arch/arm/mach-mmp/Makefile
> index 8b66d06..751cdbf 100644
> --- a/arch/arm/mach-mmp/Makefile
> +++ b/arch/arm/mach-mmp/Makefile
> @@ -17,3 +17,4 @@ obj-$(CONFIG_MACH_TAVOREVB)	+= tavorevb.o
>  obj-$(CONFIG_MACH_TTC_DKB)	+= ttc_dkb.o
>  obj-$(CONFIG_MACH_FLINT)	+= flint.o
>  obj-$(CONFIG_MACH_MARVELL_JASPER) += jasper.o
> +obj-$(CONFIG_MACH_TETON_BGA)	+= teton_bga.o
> diff --git a/arch/arm/mach-mmp/teton_bga.c b/arch/arm/mach-mmp/teton_bga.c
> new file mode 100644
> index 0000000..014cc37
> --- /dev/null
> +++ b/arch/arm/mach-mmp/teton_bga.c
> @@ -0,0 +1,47 @@
> +/*
> + *  linux/arch/arm/mach-mmp/teton_bga.c
> + *
> + *  Support for the Marvell PXA168 Teton BGA Development Platform.

Authoring information of this file are missing. Also, MAINTAINERS entry is 
missing.
> + *
> + *  This code is based on aspenite.c
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License version 2 as
> + *  publishhed by the Free Software Foundation.
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

use ... #include <linux/gpio.h>

> +
> +#include "common.h"
> +
> +static unsigned long teton_bga_pin_config[] __initdata = {
> +	/* UART1 */
> +	GPIO107_UART1_TXD,
> +	GPIO108_UART1_RXD,
> +};
> +
> +static void __init teton_bga_init(void)
> +{
> +	mfp_config(ARRAY_AND_SIZE(teton_bga_pin_config));
> +
> +	/* on-chip devices */
> +	pxa168_add_uart(1);

Don't we have enum for these magic numbers on pxa168 ?
> +}
> +
> +MACHINE_START(TETON_BGA, "PXA168-based Teton BGA Development Platform")
> +	.phys_io        = APB_PHYS_BASE,
> +	.io_pg_offst    = (APB_VIRT_BASE >> 18) & 0xfffc,
> +	.map_io		= mmp_map_io,
> +	.init_irq       = pxa168_init_irq,
> +	.timer          = &pxa168_timer,
> +	.init_machine   = teton_bga_init,
> +MACHINE_END

Cheers
