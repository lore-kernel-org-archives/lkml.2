Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048Ab2ARTYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 14:24:42 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15378 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab2ARTYl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 14:24:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 18 Jan 2012 11:24:18 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng-B29396 <B29396@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>
CC: "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Date: Wed, 18 Jan 2012 11:24:16 -0800
Subject: RE: Pinmux bindings proposal
Thread-Topic: Pinmux bindings proposal
Thread-Index: AczSMvpNTKYWSKFeSLCZTyHqrIN5SAB+76JwAD04RoAACvoLgAABPUMAAA81xtAAIJSrwA==
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1780DAAE97@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885091DEA@039-SN2MPN1-013.039d.mgd.msft.net>
 <20120117082334.GA31295@S2101-09.ap.freescale.net>
 <7FE21149F4667147B645348EC6057885092D56@039-SN2MPN1-013.039d.mgd.msft.net>
 <20120117141322.GA31687@S2101-09.ap.freescale.net>
 <7FE21149F4667147B645348EC6057885093AD9@039-SN2MPN1-013.039d.mgd.msft.net>
In-Reply-To: <7FE21149F4667147B645348EC6057885093AD9@039-SN2MPN1-013.039d.mgd.msft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dong Aisheng wrote at Tuesday, January 17, 2012 8:45 PM:
....
> > > > It may worth introducing
> > > > another level phandle reference.  Something like the following:
> > > >
> > > > 	pinmux_sdhci: pinmux-sdhci {
> > > > 		mux =
> > > > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
> > > > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>;
> > > > 	};
> > > >
> > > > 	pinconf_sdhci_active: pinconf-sdhci-active {
> > > > 		config =
> > > > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > > > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > > > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
> > > > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
> > > > 	};
> > > >
> > > > 	pinconf_sdhci_suspend: pinconf-sdhci-suspend {
> > > > 		config =
> > > > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 1>
> > > > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 1>
> > > > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > > > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > > > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
> > > > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
> > > > 	};
> > >
> > > The config makes sense to me.
> > > The only question is how to get group name to match with the predefined groups.
> >
> > I still incline to say there should not be any predefined groups for DT case, if
> > we choose to find the group in use only when pinmux_get() gets called.
>
> Then we have too issue I said before:
> 1) Inconsistent issue
> sysfs pinmux map entry has different meaning

Ah.

When you talked about the pinmux map table being inconsistent between
the board and device tree case, I thought your main/only concern was
the enumeration timing issue; that with a board file, the entire map
was available at boot yet with DT it might not be complete if we didn't
explicitly search the whole DT for pinmux configuration nodes.

However, I think you're also concerned that if we force the DT to use
only pure HW groups (or none at all if the HW doesn't use groups), then
that would be different from a board file which did use "virtual groups".

So I'm sure you can predict what my answer is! Don't use "virtual groups"
in the board case /either/; if the HW doesn't do groups, don't have the
pinctrl driver pretend that it does.

As a response, you'll say that this makes life harder for authors of the
pinmux mapping table, because then they have to list out every single
pin's mux state instead of picking between various pre-defined configur-
ations that would have been provided by "virtual groups". I believe you
can solve this by providing these pre-defined configurations using macros
instead of "virtual groups". Each macro would simply contain a bunch of
pinmux mapping table initialization entries, and the board file author
could simply use the relevant macros when writing their mapping table:

Some SoC header:

#define PMX_MAP_SDIO4_ATB_GMA_GME \
        PINMUX_MAP("default", "pinctrl-foo", "atb", "sdio4"), \
        PINMUX_MAP("default", "pinctrl-foo", "gma", "sdio4"), \
        PINMUX_MAP("default", "pinctrl-foo", "gme", "sdio4")

Board file:

static struct pinmux_map pmx_map[] = {
    /* Using a pre-defined configuration */
    PMX_MAP_SDIO4_ATB_GMA_GME,
    /* Custom stuff if needed */
    PINMUX_MAP("default", "pinctrl-foo", "xyz", "pqrs")
};

(This kind of thing is exactly why I pushed to allow the pinmux mapping
table to contain multiple entries for the same "name"+device combination)

> 2) need to change the pinmux_maps from arrays to list for better to dynamically
> Insert the new created pinmux map detected.
> But this does affect the non-dt case a lot.

I believe the pinctrl subsystem already supports multiple map tables to
be registered. I do recall some discussion that there was work left to
do here. Either way, this is purely an implementation detail that's
almost entirely hidden with the pinctrl subsystem, and I don't think
influences the device tree binding design at all.

...
> > so you should know how the name comes from device tree, and you
> > should be able to recreate the name when you are trying to matching the name in
> > the table you created before.
> >
> > > Besides per pin group configuration support, we may also want per pin
> > > configuration Support as the latest patch sent by Linus.
> > > http://www.spinics.net/lists/arm-kernel/msg155712.html
> >
> > This binding proposal has covered both pin and group configuration, as the
> > second parameter of 'config' property could be either a pin or group which
> > depends the on whether the configurable entity at HW level is a pin or group.
>
> The pinctrl driver does not know if it's group or pin.
> We may find a way to identify it.

The common binding simply states that the entities identified in the
mux and config properties are "muxable entities". It's up to the
individual pin controller's binding to define what a "muxable entity"
is. For HW that muxes pins, this should be a pin. For HW that muxes
groups, this should be a group.

Now, the pinctrl subsystem only knows about muxing whole groups. If
the HW muxes per pin rather than per group, its pinctrl driver must
currently define a group for each pin, containing just that pin, and
use those groups in the mapping table. I'd originally hoped that the
mapping table entries could refer to either pins or groups, but that's
not what is implemented now. So, we could change that in pinctrl, or
just create these single-pin groups within the relevant pinctrl drivers.
That's certainly what I did for Tegra30 (which muxes per pin unlike
Tegra20 which muxes per group).

When parsing the device tree, something is going to need to convert the
integer values in device tree to the names that the pinctrl core uses.
This should be a function in the individual pinctrl driver. Hence, it
can easily handle the two difference cases I mention above.

(Re: the last paragraph, I notice you raised some issues re: the order
of pinctrl driver probe v.s. when the pinmux map can be created. I'll
address those issues elsewhere where you raise them)

-- 
nvpublic

