Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934047Ab1CXU1g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:27:36 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:40849 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757174Ab1CXU1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:27:34 -0400
Date: Thu, 24 Mar 2011 13:27:30 -0700
From: Andres Salomon <dilinger@queued.net>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Sascha Hauer <kernel@pengutronix.de>,
        Amit Kucheria <amit.kucheria@canonical.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] ARM: mx51_efika: update platform data for new mfd
 changes
Message-ID: <20110324132730.443e045b@queued.net>
In-Reply-To: <20110307085358.GM29521@pengutronix.de>
References: <20110304080653.3f2c3f19@debxo>
	<20110307085358.GM29521@pengutronix.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Mar 2011 09:53:58 +0100
Sascha Hauer <s.hauer@pengutronix.de> wrote:

> On Fri, Mar 04, 2011 at 08:06:53AM -0800, Andres Salomon wrote:
> > Note that this relies on stuff currently in mfd's next tree, but
> > this is also a newer driver.  I'm not sure which tree it should go
> > through, as it's a problem that shows up in next.
> 
> Please ping me again when the mfd tree is in Linus master. I see no
> other chance fixing this on my side other than removing regulator
> support for efika completely for now. So I guess you have to live with
> the compile breakage for some time.

FYI, the mfd changes are now in Linus master, so this patch should
probably be applied.


> 
> Sascha
> 
> > 
> > 
> > 
> > From: Andres Salomon <dilinger@queued.net>
> > 
> > MFD changes in c738892f cause the mc13xxx_platform_data struct
> > to change.  This changes one more (new) user of it, fixing a build
> > error.
> > 
> > Signed-off-by: Andres Salomon <dilinger@queued.net>
> > ---
> >  arch/arm/mach-mx5/mx51_efika.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm/mach-mx5/mx51_efika.c
> > b/arch/arm/mach-mx5/mx51_efika.c index 74991c9..6451fb4 100644
> > --- a/arch/arm/mach-mx5/mx51_efika.c
> > +++ b/arch/arm/mach-mx5/mx51_efika.c
> > @@ -572,8 +572,10 @@ static struct mc13xxx_regulator_init_data
> > mx51_efika_regulators[] = { 
> >  static struct mc13xxx_platform_data mx51_efika_mc13892_data = {
> >  	.flags = MC13XXX_USE_RTC | MC13XXX_USE_REGULATOR,
> > -	.num_regulators = ARRAY_SIZE(mx51_efika_regulators),
> > -	.regulators = mx51_efika_regulators,
> > +	.regulators = {
> > +		.num_regulators =
> > ARRAY_SIZE(mx51_efika_regulators),
> > +		.regulators = mx51_efika_regulators,
> > +	},
> >  };
> >  
> >  static struct spi_board_info mx51_efika_spi_board_info[]
> > __initdata = { -- 
> > 1.7.2.3
> > 
> > 
> 
