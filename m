Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab1CGPzP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:55:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54078 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750881Ab1CGPzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:55:12 -0500
Date: Mon, 7 Mar 2011 15:55:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: cliff.cai@analog.com, device-drivers-devel@blackfin.uclinux.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, lrg@slimlogic.co.uk
Subject: Re: [Device-drivers-devel] [PATCH] Add driver for Analog Devices
 ADAU1701 SigmaDSP
Message-ID: <20110307155508.GM13471@opensource.wolfsonmicro.com>
References: <1299460302-15392-1-git-send-email-cliff.cai@analog.com>
 <20110307114142.GB13471@opensource.wolfsonmicro.com>
 <AANLkTikynw7vCsqqyNZW-LFuGUKKQEtG3s4YCZjpOvko@mail.gmail.com>
 <20110307121502.GG13471@opensource.wolfsonmicro.com>
 <AANLkTinKpvgBokSHpsVf1KVX+m6sD0Xp_dFe8Y+HzY-7@mail.gmail.com>
 <20110307145931.GK13471@opensource.wolfsonmicro.com>
 <AANLkTi=e1xDz6fhBU7NL32DXL1J9Y1CDD2bHQVL6oASw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=e1xDz6fhBU7NL32DXL1J9Y1CDD2bHQVL6oASw@mail.gmail.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 10:33:25AM -0500, Mike Frysinger wrote:
> On Mon, Mar 7, 2011 at 09:59, Mark Brown wrote:

Please at the start of capitalise sentences, it makes your text much
more leigible.

> > It currently isn't and I'd encourage you to contribute to the discussion
> > that's been going on on this, or even better help out with code.  There
> > was some discussion on the list recently (in the past month IIRC).

> i'd be looking at Cliff/Michael for this.  the ADI linux team has been
> restructured and audio parts are handled by Michael's new group now.

Sure, "you" in the above is Analog (and indeed anyone else who's looking
at similar areas).

> > I'd expect that the driver would at least error out if the user tried to
> > do the wrong thing here, like I say currently the firmware code is just
> > not joined up with anything else at all.

> i dont see how the driver can detect a "wrong" thing.  the driver has
> no idea what arbitrary code the user is going to load and what that
> code is going to do, or validate the code in any way.  this is why the
> firmware has a small crc header on it -- we only make sure that what
> the user compiled at build time matches what is loaded into the
> hardware.

At a bare minimum suddenly stopping and starting the firmware while
audio is going through it is unlikely to work well (you'd most likely
get a hard stop of the audio followed by a sudden hard start which sound
very unpleasant to listeners) and so should be prevented.  There's a
bunch of options for doing this (including refusing to change, ensuring
the DSP output is muted during the change or routing around the DSP
while doing the change).

> > systems) there's no reason they shouldn't be able to rely on standard
> > tools for managing their audio configurations.

> if the standard tools existed today, i'd of course agree.  but as you
> indicated there's nothing right now for us to bug off of.  so how
> userspace "probes" for existing data would be however the end user
> chooses to manage things.  it's not like the standard tools could
> really provide anything other than a simple string that indicates
> "some blob exists with name xxx".  the meaning/metadata that surrounds
> xxx isnt really relevant from the kernel's pov.

The standard tools should also be able to manage the mechanics of
actually getting the new data into the kernel at appropriate moments.
This includes both offering control via UIs such as alsamixer and being
able to include configuration of the data in UCM configurations.

> > At present userspace can enumerate and change the runtime configuration
> > the system offers via the ALSA APIs (and this will get even better once
> > the media controller API starts being used).  This means that you can
> > fairly easily write a userspace that'll run on pretty much any Linux
> > audio hardware, adapting with pure configuration for which you can
> > provide point and click tuning (realistically by allowing the user to
> > configure via standard ALSA tools and offering a "save as use case" type
> > interface).  If we start adding backdoors to drivers we're taking a step
> > back from where we are currently by requiring that the application layer
> > know magic stuff about individual systems in order to work with them.

> from how we've seen people using these codecs, this scenario doesnt
> make much sense.  the different algorithms would be loaded on the fly
> by the application and its current operating needs, not a single
> algorithm selected by the ender user that wouldnt change for the life
> of the app.  not saying the scenario would never come up, just that it
> isnt the one we'd be focused on.

I'm not sure you're following what's being said here.  The above control
discussed above full system configuration of all the control offered by
the system, not tuning the parameters of an individual algorithm.  This
includes volume controls, routing controls, algorithms, coefficients and
anything else that can be changed.  A scenario where you want to change
the set of algorithms the hardware can support is certainly included in
that.
