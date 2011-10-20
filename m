Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab1JTVm3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:42:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48131 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140Ab1JTVm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:42:28 -0400
Date: Thu, 20 Oct 2011 22:42:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tony Lindgren <tony@atomide.com>
Cc: patches@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
	regulator_init_data
Message-ID: <20111020214225.GB22709@opensource.wolfsonmicro.com>
References: <20111019150448.GB32007@S2100-06.ap.freescale.net> <20111019151031.GA4275@opensource.wolfsonmicro.com> <4E9F9892.9070007@ti.com> <20111020094140.GK18713@sirena.org.uk> <20111020162743.GB31337@atomide.com> <20111020164006.GA10155@sirena.org.uk> <20111020170534.GC31337@atomide.com> <20111020172218.GE31337@atomide.com> <20111020195734.GB17384@opensource.wolfsonmicro.com> <20111020201054.GN3842@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020201054.GN3842@atomide.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 01:10:55PM -0700, Tony Lindgren wrote:
> * Mark Brown <broonie@opensource.wolfsonmicro.com> [111020 12:23]:

> > I don't understand what an "arch independent DT node" would be?

> Well that's the standard non-Linux specific parts. Basically what's
> in the $Subject patch minus what you commented on earlier:

Oh, you don't mean arch specific at all then.

> > +- regulator-change-voltage: boolean, Output voltage can be changed by software
> > +- regulator-change-current: boolean, Output current can be chnaged by software

These aren't really Linux specific, and you could probably just infer
them from having a voltage/current range anyway.

> > +- regulator-change-mode: boolean, Operating mode can be changed by software
> > +- regulator-change-status: boolean, Enable/Disable control for regulator exists
> > +- regulator-change-drms: boolean, Dynamic regulator mode switching is enabled
> > +- regulator-mode-fast: boolean, allow/set fast mode for the regulator
> > +- regulator-mode-normal: boolean, allow/set normal mode for the regulator
> > +- regulator-mode-idle: boolean, allow/set idle mode for the regulator
> > +- regulator-mode-standby: boolean, allow/set standby mode for the regulator
> > +- regulator-input-uV: Input voltage for regulator when supplied by another regulator
> > +- regulator-always-on: boolean, regulator should never be disabled

> We still need to figure out how to get the above board specific
> data to the device driver probe in a way where we can avoid having
> platform glue code. Any thoughts on that?

I think we should just not bother with most of the above and see if
anyone notices, with the exception of always on and status changes it's
vanishingly rare for anyone to actually do anything constructive with
them.  

Neither of the two I mentioned are Linux specific either, they mean
somehing useful for any OS it's just that the decision is policy which
is going to depend on the OS version.  Status changes we can probably
allow people to enable, it'll just mean that older device trees won't
get good power use out of newer kernels and if you move to an older
kernel things will start exploding as drivers loose regulator support.
Always on we can probably live without, it's a combination of
overspecification and interaction with _has_full_constraints() which
isn't represented in this binding anyway.
