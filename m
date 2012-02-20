Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab2BTB1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 20:27:41 -0500
Received: from 11.mo5.mail-out.ovh.net ([46.105.47.167]:40701 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751713Ab2BTB1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 20:27:39 -0500
X-Greylist: delayed 52471 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Feb 2012 20:27:39 EST
Date: Mon, 20 Feb 2012 02:20:10 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH 13/18] ARM: at91/rtc-at91sam9: pass the GPBR to use via
 ressources
Message-ID: <20120220012010.GA29599@game.jcrosoft.org>
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
 <8187feb330895bf9e077ede21e68cc81a72438cc.1329500622.git.nicolas.ferre@atmel.com>
 <4F419742.70200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F419742.70200@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 11639271762573830925
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeguddrvdeiucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeguddrvdejucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11:43 Mon 20 Feb     , Ryan Mallon wrote:
> On 18/02/12 04:50, Nicolas Ferre wrote:
> 
> > From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > 
> > The GPBR registers are used for storing RTC values. The GPBR registers
> > to use are now provided using standard resource entry. The array is
> > filled in SoC specific code.
> > rtc-at91sam9 RTT as RTC driver is modified to retrieve this information.
> > 
> > Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > ---
> >  arch/arm/mach-at91/at91sam9260_devices.c      |   10 +++++++-
> >  arch/arm/mach-at91/at91sam9261_devices.c      |    8 ++++++-
> >  arch/arm/mach-at91/at91sam9263_devices.c      |   16 +++++++++++--
> >  arch/arm/mach-at91/at91sam9g45_devices.c      |    8 ++++++-
> >  arch/arm/mach-at91/at91sam9rl_devices.c       |    8 ++++++-
> >  arch/arm/mach-at91/include/mach/at91sam9260.h |    5 +--
> >  arch/arm/mach-at91/include/mach/at91sam9261.h |    5 +--
> >  arch/arm/mach-at91/include/mach/at91sam9263.h |    5 +--
> >  arch/arm/mach-at91/include/mach/at91sam9g45.h |    5 +--
> >  arch/arm/mach-at91/include/mach/at91sam9rl.h  |    2 +-
> >  drivers/rtc/rtc-at91sam9.c                    |   29 +++++++++++++++++++++---
> >  11 files changed, 76 insertions(+), 25 deletions(-)
> > 
> > diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
> > index 2071017..ae2b648 100644
> > --- a/arch/arm/mach-at91/at91sam9260_devices.c
> > +++ b/arch/arm/mach-at91/at91sam9260_devices.c
> > @@ -718,14 +718,16 @@ static struct resource rtt_resources[] = {
> >  		.start	= AT91SAM9260_BASE_RTT,
> >  		.end	= AT91SAM9260_BASE_RTT + SZ_16 - 1,
> >  		.flags	= IORESOURCE_MEM,
> > -	}
> > +	}, {
> > +		.flags	= IORESOURCE_MEM,
> > +	},
> >  };
> >  
> >  static struct platform_device at91sam9260_rtt_device = {
> >  	.name		= "at91_rtt",
> >  	.id		= 0,
> >  	.resource	= rtt_resources,
> > -	.num_resources	= ARRAY_SIZE(rtt_resources),
> > +	.num_resources	= 1,
> 
> 
> Why this change? The device has two resources, and the rtc driver
> request both of them, so why are you saying there is only one resource
> here. It either needs to be changed back to use ARRAY_SIZE, or needs a
> comment explaining what magic is in use.
because the number of resources depends on the user of rtt
we must not hardcode the GPBR reg as this resource will be present only if the
rtc-at91sam9 is enabled

> 
> <snip>
> 
> >  #if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
> >  static void __init at91_add_device_rtt_rtc(void)
> >  {
> >  	struct platform_device *pdev;
> > +	struct resource *r;
> >  
> >  	switch (CONFIG_RTC_DRV_AT91SAM9_RTT) {
> >  	case 0:
> >  		pdev = &at91sam9263_rtt0_device;
> > +		r = rtt0_resources;
> >  		break;
> >  	case 1:
> >  		pdev = &at91sam9263_rtt1_device;
> > +		r = rtt1_resources;
> >  		break;
> >  	default:
> >  		pr_err("at91sam9263: support only 2 RTT (%d)\n",
> > -			 CONFIG_RTC_DRV_AT91SAM9_RTT);
> > +		       CONFIG_RTC_DRV_AT91SAM9_RTT);
> >  		return;
> >  	}
> 
> >  
> > +	r[1].start = AT91SAM9263_BASE_GPBR + 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR;
> > +	r[1].end = r[1].start + 3;
> >  	pdev->name = "rtc-at91sam9";
> > +	pdev->num_resources++;
> 
> 
> Okay, makes a little more sense now. I really think it needs a comment
> explaining how the resources are being managed, since it is a bit
> non-obvious.
> 
> Also, can only one of the RTT's can be used as an RTC at a time?
it was always the case as nearly all soc have only one rtt and via Kconfig
doc in Kconfig

Best Regards,
J.

> 
> ~Ryan
