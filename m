Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533Ab2AKXpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 18:45:51 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63413 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab2AKXpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 18:45:49 -0500
Date: Thu, 12 Jan 2012 07:56:36 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Richard Zhao <richard.zhao@linaro.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Dong Aisheng <dongas86@gmail.com>
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Message-ID: <20120111235634.GG20968@S2101-09.ap.freescale.net>
References: <7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
 <CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com>
 <20120107135445.GI4790@S2101-09.ap.freescale.net>
 <20120108125156.GB2203@richard-laptop>
 <20120109015625.GE1835@S2101-09.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE3A6FB@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF177EE3A6FB@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 10:37:36AM -0800, Stephen Warren wrote:
> Shawn Guo wrote at Sunday, January 08, 2012 6:56 PM:
> > On Sun, Jan 08, 2012 at 08:51:59PM +0800, Richard Zhao wrote:
> > ...
> > > > > So, this does appear to be conflating the two things: The definition of
> > > > > what pins are in a pingroup, and the mux function for a particular
> > > > > setting of that pingroup. I think you need separate nodes for this.
> > > > >
> > > > At least for imx, we do not have mux function setting for pingroup.
> > > > Instead, it only applies to individual pin.
> > > I think it depends on function definition of pinmux driver. For the
> > > imx example patch, it's one-to-one.
> > 
> > It should depend on particular imx soc pinmux design rather than
> > pinmux driver.  If it's always one-to-one case, we do not need
> > pinmux at all.  Aisheng's patch just did not enumerate all the groups
> > for given function.  Instead, it puts a couple simple examples there
> > for demonstration.
> > 
> > ...
> > 
> > > > > 		uart4func: func@1 {
> > > > > 			func-name = "uart4";
> > > > > 			locations = <&bargrp &bazgrp>;
> > > > > 			mux-value = <6 3>;
> > > > > 		};
> > > >
> > > > I prefer to have function node defined in <board>.dtsi, since it's
> > > > all about defining phandle to the correct pingroup, which should be
> > > > decided by board design.
> > > group and function are one-to-one mapped for imx.
> > 
> > Again, it's not the case.
> > 
> > > So if you put function
> > > in board dts, why not put pin group there too?
> > 
> > If we put pingroup data in <board>.dts, the data will be likely get
> > duplicated a lot in different board dts files.  For example, if
> > imx6q-sabrelite chooses the same pingroup for usdhc3 and usdhc4 as
> > imx6q-arm2, the pingroup data will be duplicated between imx6q-arm2.dts
> > and imx6q-sabrelite.dts.
> > 
> > On the contrary, putting pingroup data in <soc>.dtsi and having function
> > node in <board>.dts with phandle pointing to the correct pingroup will
> > help avoid such data duplication.
> 
> Oh, when I wrote in my first mail today that I'd expand on one of my
> points when responding to Richard Zhao's email, I actually meant when
> responding to this email. Sorry for the confusion!
> 
> So, I don't agree with putting the "combinations" in the SoC .dtsi file,
> since that could grow it into a huge file that contains a lot of nodes
> that are used on some board somewhere, but typically not the "current"
> board that's including it.
> 
> However, I do see that there are probably lots of common combinations
> that get re-used across multiple boards, and you might want a common
> place to put those definitions so they don't need to be cut/paste
> everywhere.
> 
> So, why not create specific include files (.dtsi files) for each of those
> combinations? Each include could define one particular common combination
> of pin mux usage, or perhaps even a set of them if they're commonly used
> together. Each board file would include the SoC .dtsi file, the relevant
> set of "pinmux config" .dtsi files, and then include anything custom to
> that board.

This is somehow overkilled to me.  Doing this will create a big mount
of .dtsi files to bloat folder arch/arm/boot/dts.  Putting the
'combinations' in <soc>.dtsi seems perfect fine to me.

Regards,
Shawn

> Remember, that include files simply get merged into the device
> tree, so you can easily add based definitions (like) regs for e.g. an
> SDHCI controller in a SoC .dtsi file, the pinmux properties in a .dtsi
> file specific to SHDCI controller 3, and then e.g. CD/WP/power GPIOs in
> the final board .dts file.
> 
> Following this model, we can initially just put the pinmux config into
> each board file, then factor it out into new .dtsi files as/when we see
> duplication. We get to start off simple, then clean up by refactoring as
> we go.
