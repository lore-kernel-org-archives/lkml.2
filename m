Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663Ab1ESRTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 13:19:39 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1690 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933605Ab1ESRTi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 13:19:38 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 19 May 2011 10:19:37 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Joe Perches <joe@perches.com>, Lee Jones <lee.jones@linaro.org>,
        Russell King <linux@arm.linux.org.uk>
Date: Thu, 19 May 2011 10:19:35 -0700
Subject: RE: [PATCH] drivers: create a pinmux subsystem v2
Thread-Topic: [PATCH] drivers: create a pinmux subsystem v2
Thread-Index: AcwVIGewPofm9nUcRoCMDpPVybuDegBKAnPA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF0498A47BF9@HQMAIL01.nvidia.com>
References: <1305070783-23193-1-git-send-email-linus.walleij@linaro.org>
	<74CDBE0F657A3D45AFBB94109FB122FF0498A478E6@HQMAIL01.nvidia.com>
 <BANLkTimMHjUFN8NqAxoF5h_eXgmJP+znSg@mail.gmail.com>
In-Reply-To: <BANLkTimMHjUFN8NqAxoF5h_eXgmJP+znSg@mail.gmail.com>
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

Linus Walleij wrote at Tuesday, May 17, 2011 11:57 PM:
> 2011/5/18 Stephen Warren <swarren@nvidia.com>:
> 
> >> +static struct foo_pmx_func myfuncs[] = {
> >> +     {
> >> +             .name = "spi0-0",
> >> +             .pins = spi0_0_pins,
> >> +             .num_pins = ARRAY_SIZE(spi0_1_pins),
> >> +     },
> >> ...
> >
> > Rather than defining a custom type (foo_pmx_func) for this array inside
> > each driver, and then having to implement _list, _get_fname, _get_pins
> > below, how about:
> >
> > * pinmux core defines a basic structure containing all the information
> >  that the core needs from the specific implementation.
> >
> > ...
> > static struct foo_pmx_func spi0_0_func = {
> >        FOO_REG_PMX_A,
> >        0x30,
> >        0x10,
> > };
> > ...
> > static struct pinmux_function myfuncs[] = {
> >        {
> >                .name = "spi0-0",
> >                .pins = spi0_0_pins,
> >                .num_pins = ARRAY_SIZE(spi0_1_pins),
> >                .driver_data = &spi0_0_func,
> >        },
> > ...
> >
> > This would remove some boiler-plate code from the SoC drivers,
> > although it might be considered a bad breaking of abstraction barriers?
> 
> Yes it does, however I didn't want to make the initial submission
> feature creepy. So I would like this to go in as is, then refactor
> drivers to get help from the framework later on, if we see that
> it is needed. (So the solution would evolve gradually rather
> than being too much designed-in from the beginning.)
> 
> Do you think the driver support functions are needed from start?
> I could do it I think...

Sorry for the slow responses.

I think this suggestion of mine isn't a big deal, so I'd basically be
OK going either way initially.

Still, if I was writing the patches, and I agreed with the above change,
I think I'd want to put it into the first patchset (or at least before
other people started implementing their pinmux drivers on top of the code)
since it'd avoid everyone else (or me) having to refactor all their
drivers almost immediately after writing them, plus it looks like a very
simple change to the current pinmux patchset.

-- 
nvpublic

