Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab2KSILi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 03:11:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41622 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab2KSILh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 03:11:37 -0500
Subject: Re: [PATCH v6 3/4] media: coda: use genalloc API
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <50A66307.3080706@windriver.com>
References: <1353061817-3207-1-git-send-email-p.zabel@pengutronix.de>
	 <1353061817-3207-4-git-send-email-p.zabel@pengutronix.de>
	 <50A656E2.707@windriver.com>
	 <1353079273.2413.160.camel@pizza.hi.pengutronix.de>
	 <50A66307.3080706@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Nov 2012 17:51:07 +0100
Message-ID: <1353084667.2413.414.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 16.11.2012, 11:00 -0500 schrieb Paul Gortmaker:
> On 12-11-16 10:21 AM, Philipp Zabel wrote:
> > Am Freitag, den 16.11.2012, 10:08 -0500 schrieb Paul Gortmaker:
> >> On 12-11-16 05:30 AM, Philipp Zabel wrote:
> >>> This patch depends on "genalloc: add a global pool list,
> >>> allow to find pools by phys address", which provides the
> >>> of_get_named_gen_pool function.
> >>>
> >>> Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> >>> ---
> >>>  drivers/media/platform/Kconfig |    3 +--
> >>>  drivers/media/platform/coda.c  |   47 ++++++++++++++++++++++++++++------------
> >>>  2 files changed, 34 insertions(+), 16 deletions(-)
> >>>
> >>> diff --git a/drivers/media/platform/Kconfig b/drivers/media/platform/Kconfig
> >>> index 181c768..09d45c6 100644
> >>> --- a/drivers/media/platform/Kconfig
> >>> +++ b/drivers/media/platform/Kconfig
> >>> @@ -130,10 +130,9 @@ if V4L_MEM2MEM_DRIVERS
> >>>  
> >>>  config VIDEO_CODA
> >>>  	tristate "Chips&Media Coda multi-standard codec IP"
> >>> -	depends on VIDEO_DEV && VIDEO_V4L2 && ARCH_MXC
> >>> +	depends on VIDEO_DEV && VIDEO_V4L2
> >>
> >> What was the logic for reducing the dependency scope here?
> >> Your commit log doesn't mention that at all, and when I see
> >> things like that, I predict allyesconfig build failures,
> >> unless there is a similar dependency elsewhere that isn't
> >> visible in just the context of this patch alone.
> >>
> >> P.
> > 
> > iram_alloc and iram_free are i.MX specific wrappers around
> > gen_pool_alloc and gen_pool_free, located in <mach/iram.h>.
> > Those were responsible for the dependency in the first place.
> 
> So when I do an allyesconfig for sparc, or parisc or alpha,
> and VIDEO_CODA gets selected, it will build just fine then?

I don't know, as I don't have compilers for those available right now.
I'd like to know if it doesn't, though. It builds fine on x86 and mips,
for example.

> My point was that when you remove the ARCH_MXC dep, this
> probably gets opened up as a viable option to a _lot_ more
> platforms than you might want it exposed to.

I don't see the problem. Isn't this a good thing?

regards
Philipp

