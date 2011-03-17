Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab1CQKbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 06:31:40 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:51469 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191Ab1CQKbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 06:31:38 -0400
Message-ID: <19841.58100.335014.234927@ipc1.ka-ro>
Date: Thu, 17 Mar 2011 11:31:16 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: <Dinh.Nguyen@freescale.com>
Cc: <linux-kernel@vger.kernel.org>, linux@arm.linux.org.uk,
        s.hauer@pengutronix.de, ra5478@freescale.com,
        linux-arm-kernel@lists.infradead.org, u.kleine-koenig@pengutronix.de,
        xiao-lizhang@freescale.com, festevam@gmail.com,
        arnaud.patard@rtp-net.org
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 3/3] ARM: mx51: Add support for low power suspend on MX51
In-Reply-To: <1300305787-7970-3-git-send-email-Dinh.Nguyen@freescale.com>
References: <1300305787-7970-1-git-send-email-Dinh.Nguyen@freescale.com>
	<1300305787-7970-2-git-send-email-Dinh.Nguyen@freescale.com>
	<1300305787-7970-3-git-send-email-Dinh.Nguyen@freescale.com>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Dinh.Nguyen@freescale.com writes:
> From: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> 
> Adds initial low power suspend functionality to MX51.
> Supports "mem" and "standby" modes.
> 
> Tested on mx51-babbage.
> 
> Signed-off-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> ---
>  arch/arm/mach-mx5/Makefile   |    1 +
>  arch/arm/mach-mx5/pm-imx51.c |   69 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 70 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-mx5/pm-imx51.c
> 
> diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
> index 0b9338c..787cb80 100644
> --- a/arch/arm/mach-mx5/Makefile
> +++ b/arch/arm/mach-mx5/Makefile
> @@ -6,6 +6,7 @@
>  obj-y   := cpu.o mm.o clock-mx51-mx53.o devices.o ehci.o system.o
>  obj-$(CONFIG_SOC_IMX50) += mm-mx50.o
>  
> +obj-$(CONFIG_PM) += pm-imx51.o
>  obj-$(CONFIG_CPU_FREQ_IMX)    += cpu_op-mx51.o
>  obj-$(CONFIG_MACH_MX51_BABBAGE) += board-mx51_babbage.o
>  obj-$(CONFIG_MACH_MX51_3DS) += board-mx51_3ds.o
> diff --git a/arch/arm/mach-mx5/pm-imx51.c b/arch/arm/mach-mx5/pm-imx51.c
> new file mode 100644
> index 0000000..4a1d915
> --- /dev/null
> +++ b/arch/arm/mach-mx5/pm-imx51.c
> @@ -0,0 +1,69 @@
> +/*
> + *  Copyright (C) 2011 Freescale Semiconductor, Inc. All Rights Reserved.
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +#include <linux/suspend.h>
> +#include <linux/clk.h>
> +#include <asm/mach/map.h>
> +#include <asm/cacheflush.h>
> +#include <asm/tlb.h>
> +#include <mach/system.h>
> +#include "crm_regs.h"
> +
> +struct clk *gpc_dvfs_clk;
> +
static?

> +static int mx5_suspend_enter(suspend_state_t state)
> +{
> +	if (gpc_dvfs_clk == NULL)
> +		gpc_dvfs_clk = clk_get(NULL, "gpc_dvfs_clk");
> +
> +	clk_enable(gpc_dvfs_clk);
>
error check?


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
