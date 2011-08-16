Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317Ab1HPLDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 07:03:39 -0400
Received: from trinity.fluff.org ([89.16.178.74]:55837 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab1HPLDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 07:03:35 -0400
Date: Tue, 16 Aug 2011 12:03:30 +0100
From: Ben Dooks <ben@trinity.fluff.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: linux-arm-kernel@lists.infradead.org, Axel Lin <axel.lin@gmail.com>,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH] ARM: S3C2443: Remove redundant s3c_register_clocks
	call for init_clocks
Message-ID: <20110816110330.GB27653@trinity.fluff.org>
References: <1313463881.16359.2.camel@phoenix> <201108160848.25088.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201108160848.25088.heiko@sntech.de>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 08:48:22AM +0200, Heiko Stübner wrote:
> Am Dienstag, 16. August 2011, 05:04:41 schrieb Axel Lin:
> > Since commit af337f3e633a198034a99450416257ddf2307497
> > "ARM: S3C2443: Move parts of the clock code to common clock file",
> > the init_clocks array is moved to arch/arm/plat-s3c24xx/s3c2443-clock.c.
> > Now we call s3c_register_clocks for init_clocks in
> > s3c2443_common_init_clocks.
> > 
> > Thus we can remove the empty init_clocks array here and remove the
> > redundant s3c_register_clocks call for init_clocks in s3c2443_init_clocks.
> I'm not 100% sure, but you might want to include Kukjin Kim 
> <kgene.kim@samsung.com> who seems to be handling the Samsung-stuff most of the 
> time.
> 
> Heiko

I'll pick this up, as there's plans to turn all the mach-s3c24xxs into
one big directory.
 
> > 
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > ---
> >  arch/arm/mach-s3c2443/clock.c |    7 -------
> >  1 files changed, 0 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/arm/mach-s3c2443/clock.c b/arch/arm/mach-s3c2443/clock.c
> > index a1a7176..4018dbe 100644
> > --- a/arch/arm/mach-s3c2443/clock.c
> > +++ b/arch/arm/mach-s3c2443/clock.c
> > @@ -305,9 +305,6 @@ static struct clk init_clocks_off[] = {
> >  	}
> >  };
> > 
> > -static struct clk init_clocks[] = {
> > -};
> > -
> >  /* clocks to add straight away */
> > 
> >  static struct clksrc_clk *clksrcs[] __initdata = {
> > @@ -345,10 +342,6 @@ void __init s3c2443_init_clocks(int xtal)
> >  	for (ptr = 0; ptr < ARRAY_SIZE(clksrcs); ptr++)
> >  		s3c_register_clksrc(clksrcs[ptr], 1);
> > 
> > -	/* register clocks from clock array */
> > -
> > -	s3c_register_clocks(init_clocks, ARRAY_SIZE(init_clocks));
> > -
> >  	/* We must be careful disabling the clocks we are not intending to
> >  	 * be using at boot time, as subsystems such as the LCD which do
> >  	 * their own DMA requests to the bus can cause the system to lockup
> 

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

