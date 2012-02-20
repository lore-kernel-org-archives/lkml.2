Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2BTBcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 20:32:48 -0500
Received: from 9.mo5.mail-out.ovh.net ([178.32.96.204]:60984 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752215Ab2BTBcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 20:32:47 -0500
X-Greylist: delayed 65380 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Feb 2012 20:32:47 EST
Date: Mon, 20 Feb 2012 02:25:20 +0100
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH 11/18] ARM: at91/rtc-at91sam9: each SoC can select the
 RTT device to use
Message-ID: <20120220012520.GB29599@game.jcrosoft.org>
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
 <9d1120bd8f1cf0615ff5044745b00fd3988397a7.1329500622.git.nicolas.ferre@atmel.com>
 <4F4194AB.40403@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F4194AB.40403@gmail.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 11726529005655599885
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

On 11:32 Mon 20 Feb     , Ryan Mallon wrote:
> On 18/02/12 04:50, Nicolas Ferre wrote:
> 
> > From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > 
> > For the RTT as RTC driver rtc-at91sam9, the platform_device structure
> > is filled during SoC initialization. This will allow to convert this
> > RTC driver as a standard platform driver.
> > 
> > Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> > Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > ---
> >  arch/arm/mach-at91/at91sam9260_devices.c |   11 +++++
> >  arch/arm/mach-at91/at91sam9261_devices.c |   10 +++++
> >  arch/arm/mach-at91/at91sam9263_devices.c |   25 ++++++++++++
> >  arch/arm/mach-at91/at91sam9g45_devices.c |   10 +++++
> >  arch/arm/mach-at91/at91sam9rl_devices.c  |   10 +++++
> >  drivers/rtc/rtc-at91sam9.c               |   61 ++++-------------------------
> >  6 files changed, 75 insertions(+), 52 deletions(-)
> > 
> > diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
> > index b93a337..2071017 100644
> > --- a/arch/arm/mach-at91/at91sam9260_devices.c
> > +++ b/arch/arm/mach-at91/at91sam9260_devices.c
> > @@ -728,8 +728,19 @@ static struct platform_device at91sam9260_rtt_device = {
> >  	.num_resources	= ARRAY_SIZE(rtt_resources),
> >  };
> >  
> > +
> > +#if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
> > +static void __init at91_add_device_rtt_rtc(void)
> > +{
> > +	at91sam9260_rtt_device.name = "rtc-at91sam9";
> > +}
> 
> 
> Nitpickish: This function doesn't _add_ anything. It would probably be
> better called at91_init_device_rtt_rtc. Same goes for the other "add"
> functions in this patch.
yes but an other patch update it to add gpbr resource

> 
> > +#else
> > +static void __init at91_add_device_rtt_rtc(void) {}
> > +#endif
> > +
> >  static void __init at91_add_device_rtt(void)
> >  {
> > +	at91_add_device_rtt_rtc();
> >  	platform_device_register(&at91sam9260_rtt_device);
> >  }
> 
> 
> Does this work by setting the rtt device name iff
> CONFIG_RTC_DRV_AT91SAM9 is set? If so, it seems a bit ugly. Why bother
> doing the platform_device_register at all if you know it isn't going to
> do anything? Shouldn't the at91sam9260_rrt_device struct declaration and
> the platform_device_register all be conditional on CONFIG_RTC_DRV_AT91SAM9?
no people use rtt for other purpose
RTT is a timer and the rtc use it

anyway this will be dropped via DT
and the resource will be optional

Best Regards,
J.
