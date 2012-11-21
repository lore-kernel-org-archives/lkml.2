Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857Ab2KUTUt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 14:20:49 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:26755 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755836Ab2KUTUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 14:20:47 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 67.169.73.11
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/oCFu6qeR9pBtuegHN9zzu
Date: Wed, 21 Nov 2012 11:20:43 -0800
From: Tony Lindgren <tony@atomide.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Joerg Reisenweber <joerg@openmoko.org>,
        Ivaylo Dimitrov <freemangordon@abv.bg>, linux-omap@vger.kernel.org
Subject: Re: [PATCH v2] New Nokia RX-51 power supply battery driver
Message-ID: <20121121192042.GG18567@atomide.com>
References: <19040462.WFXWijAIDd@pali>
 <2562836.SjVVyiPAk1@pali>
 <20121118231239.GC29066@lizard.sbx05977.paloaca.wayport.net>
 <5320319.2WmO5VDT8j@pali>
 <20121119182002.GA2670@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20121119182002.GA2670@lizard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anton Vorontsov <cbouatmailru@gmail.com> [121119 10:25]:
> On Mon, Nov 19, 2012 at 01:18:29PM +0100, Pali Rohár wrote:
> [...] 
> > Ok. Here is missing patch which register this driver in Nokia N900 board code. Without it driver is not loaded.
> 
> Cc'ing OMAP folks.

Looks OK to me queue with the other patches in the series:

Acked-by: Tony Lindgren <tony@atomide.com>
 
 > From 0b60efd06a71668439bcb761c6572dd7df91dc17 Mon Sep 17 00:00:00 2001
> > From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
> > Date: Mon, 19 Nov 2012 09:05:24 +0100
> > Subject: [PATCH 1/3] ARM: OMAP: rx51: Register platform device for
> >  rx51_battery driver
> > MIME-Version: 1.0
> > Content-Type: text/plain; charset=UTF-8
> > Content-Transfer-Encoding: 8bit
> > 
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > ---
> >  arch/arm/mach-omap2/board-rx51-peripherals.c |    6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/arch/arm/mach-omap2/board-rx51-peripherals.c b/arch/arm/mach-omap2/board-rx51-peripherals.c
> > index 020e03c..fe1ac7e 100644
> > --- a/arch/arm/mach-omap2/board-rx51-peripherals.c
> > +++ b/arch/arm/mach-omap2/board-rx51-peripherals.c
> > @@ -271,11 +271,17 @@ static struct platform_device rx51_charger_device = {
> >  	},
> >  };
> >  
> > +static struct platform_device rx51_battery_device = {
> > +	.name		= "rx51-battery",
> > +	.id		= -1,
> > +};
> > +
> >  static void __init rx51_charger_init(void)
> >  {
> >  	WARN_ON(gpio_request_one(RX51_USB_TRANSCEIVER_RST_GPIO,
> >  		GPIOF_OUT_INIT_HIGH, "isp1704_reset"));
> >  
> > +	platform_device_register(&rx51_battery_device);
> >  	platform_device_register(&rx51_charger_device);
> >  }
> >  
> > -- 
> > 1.7.10.4
> > 
> > -- 
> > Pali Rohár
> > pali.rohar@gmail.com
