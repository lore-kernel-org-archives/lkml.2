Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1KGXQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 18:16:49 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52958 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1KGXQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 18:16:47 -0500
Date: Mon, 7 Nov 2011 23:16:32 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>, Felipe Balbi <balbi@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: omap2+: hwmod: fix breakage introduced by d6504acd
Message-ID: <20111107231632.GL15294@n2100.arm.linux.org.uk>
References: <1320688617-4543-1-git-send-email-balbi@ti.com> <20111107183208.GG15294@n2100.arm.linux.org.uk> <20111107193908.GA5059@legolas.emea.dhcp.ti.com> <20111107212707.GH15294@n2100.arm.linux.org.uk> <alpine.DEB.2.00.1111071428001.12394@utopia.booyaka.com> <20111107224129.GJ15294@n2100.arm.linux.org.uk> <20111107225157.GB31337@atomide.com> <20111107225529.GK15294@n2100.arm.linux.org.uk> <20111107230728.GC31337@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111107230728.GC31337@atomide.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 07, 2011 at 03:07:28PM -0800, Tony Lindgren wrote:
> * Russell King - ARM Linux <linux@arm.linux.org.uk> [111107 14:20]:
> > On Mon, Nov 07, 2011 at 02:51:57PM -0800, Tony Lindgren wrote:
> > > Here's what I got. Looks like the removal of the sr[12]_hwmod
> > > part is no longer needed, so only the r value check part is needed.
> > 
> > Err.  So do you have anything in your git tree which you're pushing out
> > this evening which removes the sr[12]_hwmod from the omap_3xxx_hwmod
> > list?
> > 
> > If not, how does that bug get fixed in mainline?
> 
> Ah sorry, there's also the following commit there that deals
> with other related issues:

Great, so it looks like everything that I've found over the last two days
should be solved completely by what you have queued for Arnd.

One last issue though...

We had this patch:

http://lists.arm.linux.org.uk/lurker/message/20111006.232441.227dfcf6.en.html

which is from Paul, post my complaint about IS_ERR_VALUE being used.
This removed sr1_hwmod and sr2_hwmod, and the commit message explicitly
talks about doing this.

There's also the patch below.  Somehow, this resulted in that bit of
Paul's patch being removed (possibly automatically by git) but the commit
comments are retained, which are now stale and no longer reflect what the
patch is doing...  That's rather unfortunate, but at this point its
probably too late to do something about it.

> From: Abhilash K V <abhilash.kv@ti.com>
> Date: Fri, 7 Oct 2011 03:08:56 -0600
> Subject: [PATCH] ARM: OMAP: AM35x: remove hwmods that aren't generic
> 
> Removing modules iva, sr1_hwmod, sr2_hwmod, mailbox from
> the base omap3xxx_hwmods list, so that they can be excluded
> for am35x.  This removes quite a few warnings on boot for AM35x.
> 
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
> [paul@pwsan.com: dropped 'mailbox class' comments; updated changelog]
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> 
> --- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> +++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
> @@ -3132,7 +3132,6 @@ static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
>  	&omap3xxx_mmc2_hwmod,
>  	&omap3xxx_mmc3_hwmod,
>  	&omap3xxx_mpu_hwmod,
> -	&omap3xxx_iva_hwmod,
>  
>  	&omap3xxx_timer1_hwmod,
>  	&omap3xxx_timer2_hwmod,
> @@ -3161,8 +3160,6 @@ static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
>  	&omap3xxx_i2c1_hwmod,
>  	&omap3xxx_i2c2_hwmod,
>  	&omap3xxx_i2c3_hwmod,
> -	&omap34xx_sr1_hwmod,
> -	&omap34xx_sr2_hwmod,
>  
>  	/* gpio class */
>  	&omap3xxx_gpio1_hwmod,
> @@ -3184,8 +3181,6 @@ static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
>  	&omap3xxx_mcbsp2_sidetone_hwmod,
>  	&omap3xxx_mcbsp3_sidetone_hwmod,
>  
> -	/* mailbox class */
> -	&omap3xxx_mailbox_hwmod,
>  
>  	/* mcspi class */
>  	&omap34xx_mcspi1,
> @@ -3198,31 +3193,39 @@ static __initdata struct omap_hwmod *omap3xxx_hwmods[] = {
>  
>  /* 3430ES1-only hwmods */
>  static __initdata struct omap_hwmod *omap3430es1_hwmods[] = {
> +	&omap3xxx_iva_hwmod,
>  	&omap3430es1_dss_core_hwmod,
> +	&omap3xxx_mailbox_hwmod,
>  	NULL
>  };
>  
>  /* 3430ES2+-only hwmods */
>  static __initdata struct omap_hwmod *omap3430es2plus_hwmods[] = {
> +	&omap3xxx_iva_hwmod,
>  	&omap3xxx_dss_core_hwmod,
>  	&omap3xxx_usbhsotg_hwmod,
> +	&omap3xxx_mailbox_hwmod,
>  	NULL
>  };
>  
>  /* 34xx-only hwmods (all ES revisions) */
>  static __initdata struct omap_hwmod *omap34xx_hwmods[] = {
> +	&omap3xxx_iva_hwmod,
>  	&omap34xx_sr1_hwmod,
>  	&omap34xx_sr2_hwmod,
> +	&omap3xxx_mailbox_hwmod,
>  	NULL
>  };
>  
>  /* 36xx-only hwmods (all ES revisions) */
>  static __initdata struct omap_hwmod *omap36xx_hwmods[] = {
> +	&omap3xxx_iva_hwmod,
>  	&omap3xxx_uart4_hwmod,
>  	&omap3xxx_dss_core_hwmod,
>  	&omap36xx_sr1_hwmod,
>  	&omap36xx_sr2_hwmod,
>  	&omap3xxx_usbhsotg_hwmod,
> +	&omap3xxx_mailbox_hwmod,
>  	NULL
>  };
>  
