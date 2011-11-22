Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab1KVN70 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 08:59:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52430 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754636Ab1KVN7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 08:59:25 -0500
Date: Tue, 22 Nov 2011 13:59:22 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>
Subject: Re: [PATCH v2] pinctrl: add a generic pin config interface
Message-ID: <20111122135922.GA3837@opensource.wolfsonmicro.com>
References: <1321000263-20000-1-git-send-email-linus.walleij@stericsson.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1740805B30@HQMAIL01.nvidia.com>
 <CACRpkdYh7+kL-9iy7+VDC82OAkb+-vLiJcv02pappaTeDUriTg@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1740D74FD9@HQMAIL01.nvidia.com>
 <CACRpkdaDeK3A-o775LGR9qOSGKkiQtDBuLvadw1zL26E6BgOSQ@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF174F08C2A5@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF174F08C2A5@HQMAIL01.nvidia.com>
X-Cookie: You will triumph over your enemy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 03:22:59PM -0800, Stephen Warren wrote:

> Equally, I'm not sure the case you mention is what we should be optimizing
> for. The people who deal with these options most will be FAEs (Field
> Application Engineers), PCB designers, ... who intimately understand
> the details of the SoC they're working with. They'll be well-versed in
> the SoC-specific naming of all these properties. Forcing them to map all
> that knowledge into an all-encompassing abstraction is only going to make
> their life harder, and lead to mistakes.

I'd second this - in my experience detailed setup for these settings
usually comes from hardware engineers in the form of "set register X to
value Y".  Having to decode the sematics does make things that little
bit harder.

> > I would compare to how the regulator subsystem infers the
> > allowed voltage range for a certain regulator from the
> > regulator, rail and list of consumer supply limits. It has
> > understanding of the voltages it tries to set.

> That's true, but I think that a regulator outputs a voltage is a much
> better defined and consistent concept than some of the pin config values.

Yes, and we do have some other settings like the modes where the
definition is *much* more shaky and partly as a result the setting is
rarely used (though with a lot of these things the hardware is making
manual selection obsolete).

> > I'm a bit worried if we're writing drivers for hardware where the
> > documentation is so sparse that we don't really know what
> > we're doing... How do you know how to select between say the
> > 1/2 and 1/4 setting today? The subsystem will have a hard time
> > to compensate for lack of engineering documentation whatever
> > it comes to :-(

> I believe either simulations or practical measurement are used to
> determine which option to select (e.g. based on minimal ringing, timing
> spec conformance, etc.), and the SW engineers simply make sure they
> program the value they're told to. While I certainly do like to understand
> everything fully, there are some things that I just let go, and let
> someone decide for me. Almost all of the esoteric settings are the domain
> of HW engineers, and it's their responsibility to fix things if there is
> system instability; kernel engineers shouldn't be too overly concerned I
> think.

This is pretty much it - usually one has a fairly good idea where to go
by default but when actively tuning things usually it's due to some
board specifics where things like the PCB play a role and measurements
are needed to decide what's going on.  These systems are incredibly
complex and physical measurement is an ikportant part of the process.

> > > On Tegra, this isn't a kind of "turn off and consume less power" toggle,
> > > but rather a way of configuring the pin while it's active; it's a value
> > > 0..3 (on Tegra20 at least) that interacts with the other drive strength
> > > and slew rate properties and affects overall active pin performance.

> > Hm, I don't follow this quite... what is it then? How do you select
> > the apropriate value in your code?

> I don't; a HW engineer would tell me how to configure it (or I leave it at
> default).

Or that decision may happen as a result of a dialogue between the
engineers working on the project, trading off between software and
hardware behaviours.
