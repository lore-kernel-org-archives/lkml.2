Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1HKVJX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 17:09:23 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7641 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab1HKVJW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 17:09:22 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 11 Aug 2011 14:09:05 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Colin Cross <ccross@google.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Ben Dooks <ben-linux@fluff.org>, Dilan Lee <dilee@nvidia.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 11 Aug 2011 14:09:03 -0700
Subject: RE: [PATCH] i2c/tegra: I2C driver uses the
 suspend_noirq/resume_noirq
Thread-Topic: [PATCH] i2c/tegra: I2C driver uses the
 suspend_noirq/resume_noirq
Thread-Index: AcxYaGf31Xhs02Y7RAyx5WneVj0d3AAAeSoA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04AEA24D09@HQMAIL01.nvidia.com>
References: <1312586102-27907-1-git-send-email-swarren@nvidia.com>
	<CAMbhsRScgMaTZ2e3a__OgOrrA6HN9_dkGuuNGaEfP+iqRdjyNQ@mail.gmail.com>
	<20110806084805.GA18098@sirena.org.uk>
	<74CDBE0F657A3D45AFBB94109FB122FF04AEA24CC8@HQMAIL01.nvidia.com>
 <CAMbhsRR2+bhpjhGfUSt9M5tDk1EW2d70yC-tZy27zEgVqtkfSg@mail.gmail.com>
In-Reply-To: <CAMbhsRR2+bhpjhGfUSt9M5tDk1EW2d70yC-tZy27zEgVqtkfSg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin Cross wrote at Thursday, August 11, 2011 2:51 PM:
> Cc: Mark Brown; Ben Dooks; Dilan Lee; linux-i2c@vger.kernel.org; linux-tegra@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: Re: [PATCH] i2c/tegra: I2C driver uses the suspend_noirq/resume_noirq
> 
> On Thu, Aug 11, 2011 at 12:35 PM, Stephen Warren <swarren@nvidia.com> wrote:
> > Mark Brown wrote at Saturday, August 06, 2011 2:48 AM:
> >> On Fri, Aug 05, 2011 at 09:33:31PM -0700, Colin Cross wrote:
> > ...
> >> > NAK - moving the suspend order around is not the correct way to solve
> >> > this.  If wm8903 needs to talk to the i2c bus in its suspend handler,
> >> > it needs to be child device on the i2c bus.  suspend_noirq is for
> >>
> >> WM8903 is an I2C device.  The problem is that it's suspended as part of
> >> the ASoC suspend since the audio subsystem is composed of multiple
> >> devices that all need to work together coherently.  I did start doing
> >> some stuff to bodge around this like we do on probe but there are enough
> >> system wide problems with this that it didn't seem worth the complexity
> >> when the existing workarounds are so straightforward.
> >
> > Colin, given Mark's explanation, are you OK with the patch now?
> 
> It's still not the right way to handle this, are you going to mark
> every I2C controller as suspend_noirq?  What happens when you find an
> I2C controller that needs its irq on to suspend?  These are the kinds
> of hacks we've been asked not to do in ARM, so I'd like to see a
> response from the I2C maintainers.

Well, while that's true, the thing is the right way to handle it doesn't
appear to exist at present.

I did briefly try to move the entire ASoC suspend to early suspend (or
something like that), but ran into a whole slew of issues, that I
unfortunately don't recall right now. That would also impact every user
of ASoC, not just Tegra...

So, in other words, how do you suggest I proceed with this?

Mark Brown wrote:
> Unfortunately it's the only tool Linux has for dealing with this sort of
> issue right now.  We were supposed to be getting support for telling the
> PM core about dependencies but Linus didn't like that,

Mark, can you fill in a little more detail; did Linus not like the concept
of drivers registering dependencies on each-other, or was there a problem
with the specific implementation that was proposed? I assume we're still a
long way away from anything like that working. You also mentioned Grant's
device registration retry stuff, but doesn't that only solve the initial
probing, not shutdown/suspend dependencies, or do devices take locks on
each-other to handle that too?

Thanks.

-- 
nvpubilc

