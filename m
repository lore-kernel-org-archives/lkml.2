Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab2GBRs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 13:48:29 -0400
Received: from mail20.dotsterhost.com ([66.11.232.73]:55992 "EHLO
	mail20.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753781Ab2GBRs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 13:48:28 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jul 2012 13:48:28 EDT
Date: Mon, 2 Jul 2012 10:41:38 -0700
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "tony@atomide.com" <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "paul@pwsan.com" <paul@pwsan.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP AM35x: clockdomain data: fix resolving
 dependency problem
Message-ID: <20120702174138.GA9669@animalcreek.com>
References: <A874F61F95741C4A9BA573A70FE3998FCB33@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FCB33@DQHE02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 05:54:57AM +0000, Kim, Milo wrote:
> In am35x board , iva2 clock domain doesn't be used.
> So mpu_am35x_clkdm should be used rather than mpu_3xxx_clkdm.
> OMAP3430 : mpu_3xxx_clkdm (with iva2 clkdm)
> AM35x    : mpu_am35x_clkdm (without iva2 clkdm)
> 
> For the compatibility with omap3430, this patch has no conflict because mpu_3xxx_clkdm was already defined in clock domains for omap3430.
> So this can be removed from common clock domain.
> 
> Below error can be fixed with this patch.
> 
> [    0.000000] AM3517 ES1.1 (l2cache sgx neon )
> [    0.000000] ------------[ cut here ]------------
> [    0.000000] WARNING: at arch/arm/mach-omap2/clockdomain.c:237 _resolve_clkdm_deps+0x68/0x108()
> [    0.000000] clockdomain: mpu_clkdm: could not find clkdm iva2_clkdm while resolving dependencies - should never happen
> [    0.000000] Modules linked in:
> [    0.000000] [<c001bd3c>] (unwind_backtrace+0x0/0xf4) from [<c0040c2c>] (warn_slowpath_common+0x4c/0x64)
> [    0.000000] [<c0040c2c>] (warn_slowpath_common+0x4c/0x64) from [<c0040cd8>] (warn_slowpath_fmt+0x30/0x40)
> [    0.000000] [<c0040cd8>] (warn_slowpath_fmt+0x30/0x40) from [<c003256c>] (_resolve_clkdm_deps+0x68/0x108)
> [    0.000000] [<c003256c>] (_resolve_clkdm_deps+0x68/0x108) from [<c0032640>] (clkdm_complete_init+0x34/0x90)
> [    0.000000] [<c0032640>] (clkdm_complete_init+0x34/0x90) from [<c06d7600>] (omap3_init_early+0x20/0x30)
> [    0.000000] [<c06d7600>] (omap3_init_early+0x20/0x30) from [<c06d3230>] (setup_arch+0x834/0x94c)
> [    0.000000] [<c06d3230>] (setup_arch+0x834/0x94c) from [<c06cf6b0>] (start_kernel+0x88/0x2fc)
> [    0.000000] [<c06cf6b0>] (start_kernel+0x88/0x2fc) from [<80008044>] (0x80008044)
> 
> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  arch/arm/mach-omap2/clockdomains3xxx_data.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/clockdomains3xxx_data.c b/arch/arm/mach-omap2/clockdomains3xxx_data.c
> index d625844..56089c4 100644
> --- a/arch/arm/mach-omap2/clockdomains3xxx_data.c
> +++ b/arch/arm/mach-omap2/clockdomains3xxx_data.c
> @@ -454,7 +454,6 @@ static struct clkdm_autodep clkdm_am35x_autodeps[] = {
>  
>  static struct clockdomain *clockdomains_common[] __initdata = {
>  	&wkup_common_clkdm,
> -	&mpu_3xxx_clkdm,
>  	&neon_clkdm,
>  	&core_l3_3xxx_clkdm,
>  	&core_l4_3xxx_clkdm,
> -- 
> 1.7.2.5

Hi Milo.

Thanks for the patch but this issue should already be fixed in a patch
that Tony just made a pull request for
(http://www.spinics.net/lists/linux-omap/msg73080.html).

>From that email (and branch in the email), look for this patch:

> Mark A. Greer (4):

>      ARM: OMAP AM35x: clockdomain data: Fix clockdomain dependencies

Please take a look as another set of eyes never hurts. :)

Mark
--
