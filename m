Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab1JTRFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 13:05:40 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:41389 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751903Ab1JTRFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 13:05:39 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/cC3/+RCiUwumLBnVIoSVX
Date: Thu, 20 Oct 2011 10:05:34 -0700
From: Tony Lindgren <tony@atomide.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: patches@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111020170534.GC31337@atomide.com>
References: <20111018115836.GC30703@S2100-06.ap.freescale.net>
 <20111018160046.GD28501@opensource.wolfsonmicro.com>
 <20111019053354.GB31162@S2100-06.ap.freescale.net>
 <20111019144734.GI18713@sirena.org.uk>
 <20111019150448.GB32007@S2100-06.ap.freescale.net>
 <20111019151031.GA4275@opensource.wolfsonmicro.com>
 <4E9F9892.9070007@ti.com>
 <20111020094140.GK18713@sirena.org.uk>
 <20111020162743.GB31337@atomide.com>
 <20111020164006.GA10155@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020164006.GA10155@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mark Brown <broonie@opensource.wolfsonmicro.com> [111020 09:05]:
> On Thu, Oct 20, 2011 at 09:27:43AM -0700, Tony Lindgren wrote:
> > * Mark Brown <broonie@opensource.wolfsonmicro.com> [111020 02:07]:
> 
> > > We can always start off just completely omitting the data and then see
> > > how we go from there.  If we only cover 50% of users that's still 50%
> > > more than are currently covered with device tree right now and it means
> > > we can then spin round and look at the bits that are hard again without
> > > review fatigue on the bits that are easy.
> 
> > We still need to pass the board configuration somehow, otherwise we can
> > never remove all the platform data glue layers. And if we can't do that,
> > we'll forever have all the nasty merge conflicts when adding new drivers.
> > And there's an unnecessary dependency between adding drivers and the
> > core SoC code.
> 
> The current patches cover the overwhelming majority of the existing
> board configuration - the stuff that's Linux specific is also relatively
> rarely used in actual systems.  For example all the board I work with
> regularly would be perfectly happy with the generic stuff - the Linux
> specific stuff is relatively rarely used.

Right, but in addition the board specific integration variables still
need to be passed somehow to the driver.

That's where a DT entry specific configuration string might be the best
option as it still allows describing the hardware using DT standards,
while also allowing board specific configuration too.

The issue there is then how do we keep these options from getting out
of control..

BTW, of course this issue is generic to all drivers, not specific to
this patchset. With this patchset leaving out the non-standard entries
is the right way to go to so we can merge it.

Cheers,

Tony
