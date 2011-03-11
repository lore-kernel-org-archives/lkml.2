Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1CKJRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 04:17:16 -0500
Received: from lebrac.rtp-net.org ([88.191.135.105]:55882 "EHLO
	lebrac.rtp-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab1CKJRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 04:17:11 -0500
From: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
To: <Dinh.Nguyen@freescale.com>
Cc: <linux-kernel@vger.kernel.org>, Ranjani.Vaidyanathan@freescale.com,
        linux@arm.linux.org.uk, s.hauer@pengutronix.de,
        u.kleine-koenig@pengutronix.de, xiao-lizhang@freescale.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 2/2] ARM: mx51: Add support for low power suspend on MX51
Organization: RtpNet
References: <1299281399-32304-1-git-send-email-Dinh.Nguyen@freescale.com>
	<1299281399-32304-2-git-send-email-Dinh.Nguyen@freescale.com>
Date: Fri, 11 Mar 2011 10:16:44 +0100
In-Reply-To: <1299281399-32304-2-git-send-email-Dinh.Nguyen@freescale.com>
	(Dinh Nguyen's message of "Fri, 4 Mar 2011 17:29:59 -0600")
Message-ID: <871v2euidf.fsf@lebrac.rtp-net.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<Dinh.Nguyen@freescale.com> writes:

Hi,

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
>  arch/arm/mach-mx5/pm-imx51.c |   62 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 63 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-mx5/pm-imx51.c
>
> diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
> index 1106acd..2f6258e 100644
> --- a/arch/arm/mach-mx5/Makefile
> +++ b/arch/arm/mach-mx5/Makefile
> @@ -6,6 +6,7 @@
>  obj-y   := cpu.o mm.o clock-mx51-mx53.o devices.o system.o
>  obj-$(CONFIG_SOC_IMX50) += mm-mx50.o
>  
> +obj-$(CONFIG_PM) += pm-imx51.o
>  obj-$(CONFIG_CPU_FREQ_IMX)    += cpu_op-mx51.o
>  obj-$(CONFIG_MACH_MX51_BABBAGE) += board-mx51_babbage.o
>  obj-$(CONFIG_MACH_MX51_3DS) += board-mx51_3ds.o
> diff --git a/arch/arm/mach-mx5/pm-imx51.c b/arch/arm/mach-mx5/pm-imx51.c
> new file mode 100644
> index 0000000..6bb76e2
> --- /dev/null
> +++ b/arch/arm/mach-mx5/pm-imx51.c
> @@ -0,0 +1,62 @@
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
> +#include <asm/mach/map.h>
> +#include <asm/cacheflush.h>
> +#include <asm/tlb.h>
> +#include <mach/system.h>
> +#include "crm_regs.h"
> +
> +static int mx5_suspend_enter(suspend_state_t state)
> +{

In your tree, here the gpc clock is enabled with a comment saying:

/* gpc clock is needed for SRPG */

and someone choose to not handle that, I guess because your uboot or
someone else is already enabling it. Assuming that all boards will
behave like yours is not a good idea because enabling the clock here
allowed me to get suspend to mem work.

I'll do more tests over the week end to confirm this because I've done
some other changes in my tree (in this version, you removed the
tzic_enable_wake() call here so I added it back) and keep you
informed. At least, it really looks like enabling the gpc clock was the
missing piece.

Arnaud
