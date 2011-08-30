Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1H3W0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 18:26:34 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:53267 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752269Ab1H3W0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 18:26:33 -0400
From: Kevin Hilman <khilman@ti.com>
To: Abhilash K V <abhilash.kv@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        sameo@linux.intel.com, santosh.shilimkar@ti.com, premi@ti.com,
        david.woodhouse@intel.com
Subject: Re: [PATCH 1/3] AM35x: voltage: Basic initialization
Organization: Texas Instruments, Inc.
References: <1313754573-11498-1-git-send-email-abhilash.kv@ti.com>
	<1313754573-11498-2-git-send-email-abhilash.kv@ti.com>
Date: Tue, 30 Aug 2011 15:26:28 -0700
In-Reply-To: <1313754573-11498-2-git-send-email-abhilash.kv@ti.com> (Abhilash
	K. V.'s message of "Fri, 19 Aug 2011 17:19:31 +0530")
Message-ID: <87aaaqmt7v.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Abhilash K V <abhilash.kv@ti.com> writes:

> From: Sanjeev Premi <premi@ti.com>
>
> This patch adds the basic initialization of voltage layer
> for AM35x. Since AM35x doesn't support voltage scaling,
> Many functions have been defined to plug into existing
> voltage layer.
>
> Signed-off-by: Sanjeev Premi <premi@ti.com>
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>

[...]

> diff --git a/arch/arm/mach-omap2/voltagedomains3xxx_data.c b/arch/arm/mach-omap2/voltagedomains3xxx_data.c
> index def230f..b45d145 100644
> --- a/arch/arm/mach-omap2/voltagedomains3xxx_data.c
> +++ b/arch/arm/mach-omap2/voltagedomains3xxx_data.c
> @@ -67,6 +67,38 @@ static struct omap_vdd_info *omap3_vdd_info[] = {
>  	&omap3_vdd2_info,
>  };
>  
> +/*
> + * AM35x VDD structures
> + *
> + * In AM35x there neither scalable voltage domain nor any hook-up with
> + * voltage controller/processor. However, when trying to re-use the hwmod
> + * database for OMAP3, definition of "core" voltage domain is necessary.
> + * Else, changes in hwmod data structures grow spirally.
> + *
> + * As a workaround, "core" voltage domain is defined below. The definition
> + * doesn't lead to any side-effects.

Except the side-effect of a bunch of unused data, and nop functions that
just clutter things up in a not-very-maintainable way.

For SoCs without scalable voltage domains, we need to fix the underlying
problems in the core code for how to cleanly re-use hwmods.

Fortunately, this core code cleanup is now in progress, so it shouldn't
be long now where we can do this cleanly.

Kevin
