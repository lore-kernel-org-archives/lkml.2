Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab0JESHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 14:07:15 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41517 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab0JESHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 14:07:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i/BRdajV1AYDgGcB10Xc9al5AUY9zwMYelypjXRAHRP2iBmZmrPZSlllV98r+fNRwY
         ZfcaI4DHX1r09b/veYP9M2HToTayNwWgsw2Gy7WF4qWGG5LJV7uEIPkGhdth9u4QzW4S
         S+vg3NGy8OwWAL/z2OkY8qH4/w9nWFlm5+V60=
Date: Tue, 5 Oct 2010 11:07:03 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Igor Grinberg <grinberg@compulab.co.il>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-arm-kernel@lists.infradead.org, vapier@gentoo.org,
        khilman@deeprootsystems.com, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2] Input: Make ADS7846 independent on regulator
Message-ID: <20101005180703.GD21399@core.coreip.homeip.net>
References: <1280560182-7071-1-git-send-email-marek.vasut@gmail.com>
 <4C862EB3.4080006@compulab.co.il>
 <20100907125335.GD25830@sirena.org.uk>
 <201009091027.18176.marek.vasut@gmail.com>
 <20100909094120.GB1988@rakim.wolfsonmicro.main>
 <4CAACA63.6090202@compulab.co.il>
 <20101005161608.GD19730@core.coreip.homeip.net>
 <20101005164037.GA20555@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101005164037.GA20555@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 09:40:38AM -0700, Mark Brown wrote:
> On Tue, Oct 05, 2010 at 09:16:08AM -0700, Dmitry Torokhov wrote:
> > On Tue, Oct 05, 2010 at 08:49:07AM +0200, Igor Grinberg wrote:
> 
> > > You want each platform, that does not have a special regulated power supply
> > > for the ads7846, to define a dummy regulator just to cope with that artificial
> > > dependency of the device driver?
> > > I think it is a waste and big code duplication in each platform
> > > that does not have that special regulator.
> 
> It's a pretty good fit for most current systems - with current hardware
> you will normally have some software control for the vast majority of
> the regulators on the board if you have regulator control at all since
> that's the way PMICs have gone.  Having a complete map of the regulator
> usage in the system is useful since it allows us to do optimisations
> like powering down idle regulators much more readily.
> 
> > I tend to agree, however I think that original patch that simply ignored
> > failures from regulator_get() is not the best option either. Can we have
> > a flag in platform data indicating that the board does not employ a
> > regulator? Then we could retain the hard failure in cases when we expect
> > regulator to be present while allowing to continue on boards that do not
> > have it.
> 
> I really don't think it's a good idea to add this code to every single
> regulator using driver - this seems like an enormous waste of time and
> code complexity cost.  I have suggested several times that we should
> extend the dummy regulator mode so that boards can enable it from code
> as well as users enable it from Kconfig, I'm not sure why everyone is so
> keen on bodging this in drivers.

It all depends on what instances you expect to encounted more often -
drivers or boards without regulators...

-- 
Dmitry
