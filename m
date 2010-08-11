Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0HKSy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 14:54:29 -0400
Received: from mail.logicpd.com ([66.162.60.3]:2278 "EHLO smtp.logicpd.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752617Ab0HKSy2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 14:54:28 -0400
Content-class: urn:content-classes:message
Subject: RE: [PATCH 1/4] initial support for LogicPD's OMAP3 SOM and TORPEDO development kits
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Date: Wed, 11 Aug 2010 13:53:52 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Message-ID: <77A0A4DB5BF2A44283E5522C27234AC6021C82D7@EDPRSRV011.logicpd.com>
In-Reply-To: <87r5i52fgb.fsf@deeprootsystems.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/4] initial support for LogicPD's OMAP3 SOM and TORPEDO development kits
Thread-Index: Acs5f83GtGYtkIWzTy+xczJ4pKMzXgABqxWQ
From: "Jacob Tanenbaum" <Jacob.Tanenbaum@logicpd.com>
To: "Kevin Hilman" <khilman@deeprootsystems.com>
Cc: <linux@arm.linux.org.uk>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rmk@arm.linux.org.uk>,
        <tony@atomide.com>
X-OriginalArrivalTime: 11 Aug 2010 18:54:27.0826 (UTC) FILETIME=[9FB87D20:01CB3986]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Kevin Hilman [mailto:khilman@deeprootsystems.com] 
Sent: Wednesday, August 11, 2010 2:05 PM
To: Jacob Tanenbaum
Cc: linux@arm.linux.org.uk; linux-omap@vger.kernel.org;
linux-kernel@vger.kernel.org; rmk@arm.linux.org.uk; tony@atomide.com
Subject: Re: [PATCH 1/4] initial support for LogicPD's OMAP3 SOM and
TORPEDO development kits

Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com> writes:

> 	Adding LogicPD OMAP3 board support
>
>          Adding support for LogicPD's OMAP 3530 LV SOM and
>          OMAP 35x Torpedo board.
> 	 
> 	 Tested against: linux-next
81e09f50c93edff607259cbe374a3006c9c5fa74
>          Signed-off-by: Jacob Tanenbaum <Jacob.Tanenbaum@logicpd.com>

[...]

> +/* Micron MT46H32M32LF-6 */
> +/* FIXME: borrowed from sdram-micron-mt46h32m32lf-6.h because on
LogicPD
> + * boards we can't use the default values -- why? I suspect the
reason
> + * lies in the boot strap code. We correct this part if we have
ported
> + * U-Boot and X-Load. */

Another option here instead of re-defining the struct is to includ the
original header and just change the values you need to.  That way
you can describe the reasons behind the values that are changing.

Will fix

[...]

> +static struct omap_board_config_kernel omap3logic_config[] __initdata
= {
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

Will test and fix


Kevin
