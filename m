Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab0HKSE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 14:04:57 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:56518 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803Ab0HKSE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 14:04:56 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>
Cc: linux@arm.linux.org.uk, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk, tony@atomide.com
Subject: Re: [PATCH 1/4] initial support for LogicPD's OMAP3 SOM and TORPEDO development kits
Organization: Deep Root Systems, LLC
References: <1281544297-18015-1-git-send-email-Jacob.Tanenbaum@logicpd.com>
Date: Wed, 11 Aug 2010 11:04:52 -0700
In-Reply-To: <1281544297-18015-1-git-send-email-Jacob.Tanenbaum@logicpd.com>
	(Jacob Tanenbaum's message of "Wed, 11 Aug 2010 12:31:34 -0400")
Message-ID: <87r5i52fgb.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com> writes:

> 	Adding LogicPD OMAP3 board support
>
>          Adding support for LogicPD's OMAP 3530 LV SOM and
>          OMAP 35x Torpedo board.
> 	 
> 	 Tested against: linux-next 81e09f50c93edff607259cbe374a3006c9c5fa74
>          Signed-off-by: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>

[...]

> +/* Micron MT46H32M32LF-6 */
> +/* FIXME: borrowed from sdram-micron-mt46h32m32lf-6.h because on LogicPD
> + * boards we can't use the default values -- why? I suspect the reason
> + * lies in the boot strap code. We correct this part if we have ported
> + * U-Boot and X-Load. */

Another option here instead of re-defining the struct is to includ the
original header and just change the values you need to.  That way
you can describe the reasons behind the values that are changing.

[...]

> +static struct omap_board_config_kernel omap3logic_config[] __initdata = {
> +};
> +
> +static void __init omap3logic_init_irq(void)
> +{
> +	omap_board_config = omap3logic_config;
> +	omap_board_config_size = ARRAY_SIZE(omap3logic_config);
> +	omap2_init_common_hw(mt46h32m32lf6_sdrc_params,
> +				mt46h32m32lf6_sdrc_params);
> +	omap_init_irq();
> +#ifdef CONFIG_OMAP_32K_TIMER
> +	omap2_gp_clockevent_set_gptimer(12);
> +#endif

Why do you need GPT12?

Was this a copy-paste from Beagle?  Certain revs of beagle had this
limitation due to a board design problem, so unless you've inherited the
same board-design problem, you should be find with the default.


Kevin
