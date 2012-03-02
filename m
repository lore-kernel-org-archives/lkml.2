Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756974Ab2CBRQw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:16:52 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:12712 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630Ab2CBRQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:16:49 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1856HTkcnfBhgzC/o3Z1SNg
Date: Fri, 2 Mar 2012 09:16:46 -0800
From: Tony Lindgren <tony@atomide.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] mmc: omap_hsmmc: Use GPIO offset for external GPIO
 chips
Message-ID: <20120302171646.GI18901@atomide.com>
References: <20120301185044.29210.44521.stgit@kaulin.local>
 <20120301185532.29210.32421.stgit@kaulin.local>
 <4F50628C.9080706@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F50628C.9080706@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rajendra Nayak <rnayak@ti.com> [120301 21:31]:
> On Friday 02 March 2012 12:25 AM, Tony Lindgren wrote:
> >--- a/arch/arm/mach-omap2/board-3430sdp.c
> >+++ b/arch/arm/mach-omap2/board-3430sdp.c
> >@@ -231,14 +231,16 @@ static struct omap2_hsmmc_info mmc[] = {
> >  		 * so the SIM card isn't used; else 4 bits.
> >  		 */
> >  		.caps		= MMC_CAP_4_BIT_DATA | MMC_CAP_8_BIT_DATA,
> >+		.gpiochip_cd	= "twl4030_gpio",
> >+		.gpio_cd	= 0,	/* mmc0_cd offset in twl4030 */
> >  		.gpio_wp	= 4,
> >-		.deferred	= true,
> 
> Shouldn't this patch completely get rid of all the 'deferred'
> infrastructure that was put in place, including the
> omap_hsmmc_late_init() function, since there is no need for it
> anymore?

Yes, that was needed as a fix so unfortunately there's a little
bit going back and forth. But now we can get rid of other stuff
too in addition to deferred omap_hsmmc_late_init(), we can remove
init and cleanup callbacks for hsmmc. I'll do another patch for
that.

> >--- a/arch/arm/mach-omap2/board-omap3pandora.c
> >+++ b/arch/arm/mach-omap2/board-omap3pandora.c
> >@@ -270,19 +270,19 @@ static struct omap2_hsmmc_info omap3pandora_mmc[] = {
> >  	{
> >  		.mmc		= 1,
> >  		.caps		= MMC_CAP_4_BIT_DATA,
> >-		.gpio_cd	= -EINVAL,
> >+		.gpiochip_cd	= "twl4030_gpio",
> >+		.gpio_cd	= 0,	/* mmc0_cd offset in twl4030 */
> >  		.gpio_wp	= 126,
> >  		.ext_clock	= 0,
> >-		.deferred	= true,
> >  	},
> >  	{
> >  		.mmc		= 2,
> >  		.caps		= MMC_CAP_4_BIT_DATA,
> >-		.gpio_cd	= -EINVAL,
> >+		.gpiochip_cd	= "twl4030_gpio",
> >+		.gpio_cd	= 0,	/* mmc0_cd offset in twl4030 */
> 
> This one should be gpio_cd = 1,

Thanks, will correct.

Regards,

Tony 
