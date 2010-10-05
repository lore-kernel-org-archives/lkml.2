Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab0JEQkb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:40:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53462 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754586Ab0JEQk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:40:28 -0400
Date: Tue, 5 Oct 2010 09:40:38 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Igor Grinberg <grinberg@compulab.co.il>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-arm-kernel@lists.infradead.org, vapier@gentoo.org,
        khilman@deeprootsystems.com, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2] Input: Make ADS7846 independent on regulator
Message-ID: <20101005164037.GA20555@opensource.wolfsonmicro.com>
References: <1280560182-7071-1-git-send-email-marek.vasut@gmail.com>
 <4C862EB3.4080006@compulab.co.il>
 <20100907125335.GD25830@sirena.org.uk>
 <201009091027.18176.marek.vasut@gmail.com>
 <20100909094120.GB1988@rakim.wolfsonmicro.main>
 <4CAACA63.6090202@compulab.co.il>
 <20101005161608.GD19730@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005161608.GD19730@core.coreip.homeip.net>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 09:16:08AM -0700, Dmitry Torokhov wrote:
> On Tue, Oct 05, 2010 at 08:49:07AM +0200, Igor Grinberg wrote:

> > You want each platform, that does not have a special regulated power supply
> > for the ads7846, to define a dummy regulator just to cope with that artificial
> > dependency of the device driver?
> > I think it is a waste and big code duplication in each platform
> > that does not have that special regulator.

It's a pretty good fit for most current systems - with current hardware
you will normally have some software control for the vast majority of
the regulators on the board if you have regulator control at all since
that's the way PMICs have gone.  Having a complete map of the regulator
usage in the system is useful since it allows us to do optimisations
like powering down idle regulators much more readily.

> I tend to agree, however I think that original patch that simply ignored
> failures from regulator_get() is not the best option either. Can we have
> a flag in platform data indicating that the board does not employ a
> regulator? Then we could retain the hard failure in cases when we expect
> regulator to be present while allowing to continue on boards that do not
> have it.

I really don't think it's a good idea to add this code to every single
regulator using driver - this seems like an enormous waste of time and
code complexity cost.  I have suggested several times that we should
extend the dummy regulator mode so that boards can enable it from code
as well as users enable it from Kconfig, I'm not sure why everyone is so
keen on bodging this in drivers.
