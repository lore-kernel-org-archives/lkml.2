Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab2AZTeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 14:34:44 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5475 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305Ab2AZTen convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 14:34:43 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 26 Jan 2012 11:34:33 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Tony Lindgren <tony@atomide.com>
CC: "Shawn Guo (shawn.guo@linaro.org)" <shawn.guo@linaro.org>,
        Dong Aisheng <dongas86@gmail.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        "cjb@laptop.org" <cjb@laptop.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 26 Jan 2012 11:33:49 -0800
Subject: RE: Pinmux bindings proposal V2
Thread-Topic: Pinmux bindings proposal V2
Thread-Index: Acza9OAiOKvSXZVFQ+C6Rit1DhS6hQBZNY+Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF178CB82433@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <20120123210052.GS22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB81C0D@HQMAIL01.nvidia.com>
 <20120124012038.GT22818@atomide.com>
 <74CDBE0F657A3D45AFBB94109FB122FF178CB81EDB@HQMAIL01.nvidia.com>
 <20120125000407.GU22818@atomide.com>
In-Reply-To: <20120125000407.GU22818@atomide.com>
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

Tony Lindgren wrote at Tuesday, January 24, 2012 5:04 PM:
> * Stephen Warren <swarren@nvidia.com> [120124 14:02]:
> > Tony Lindgren wrote at Monday, January 23, 2012 6:21 PM:
> > > * Stephen Warren <swarren@nvidia.com> [120123 14:37]:
> > > > Tony Lindgren wrote at Monday, January 23, 2012 2:01 PM:
> > > > > This mostly looks pretty good to me, few more comments below.
> > ...
> > > > > >                 pmx_sdhci_active: pinconfig-sdhci-active {
> > > > > >                         /*
> > > > > >                          * In each of these nodes, both the mux and config
> > > > > >                          * properties are optional. This node represents the
> > > > > >                          * additions to pmx_sdhci that are specific to an
> > > > > >                          * active state. In this case, only pin configuration
> > > > > >                          * settings are different.
> > > > > >                          */
> > > > > >                         config =
> > > > > >                                 <TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 0>
> > > > > >                                 <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 0>;
> > > > > >                 };
> > > > > >                 pmx_sdhci_standby: pinconfig-sdhci-standby {
> > > > > >                         config =
> > > > > >                                 <TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 1>
> > > > > >                                 <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 1>;
> > > > > >                 };
> > > > >
> > > > > After thinking about this a bit more, I'm now thinking that we should
> > > > > probably only describe the active state in the device tree to keep things
> > > > > simple.
> > > > >
> > > > > Anything PM related could be initialized later on during the boot by the
> > > > > device driver, or even from userspace using /lib/firmware or /sys entries.
> > > > > This would cut down the device tree bloat quite a bit.
> > > >
> > > > I think it makes sense to describe everything in one place. It's much
> > > > easier to ensure everything is consistent and correct if you don't have
> > > > to cross-check two sources of data for the same thing.
> > >
> > > But we end up repeating the same bits over and over again making the device
> > > tree bloated.
> >
> > What exactly gets repeated; can you please show an example?
> 
> Well in your example, you have TEGRA_PMX_PG_DTA and TEGRA_PMX_PG_DTD
> repeated. It seems you're trying to list slightly different register
> values for the the pincontrol modes with pmx_sdhci_active and
> pmx_sdhci_standby.

Hmmm. I guess I was taking "repeated" a little too literally then...

There's an entry for each of DTA and DTD in each of the two nodes because
in this example, I want the value of parameter TEGRA_PMX_CONF_TRISTATE to
be different in each of those two nodes.

If the value wasn't different, there'd be no need to specify the value
of TEGRA_PMX_CONF_TRISTATE in each of the two nodes; you'd typically
specify it just once in the common node.

So, the binding itself isn't forcing you to repeat anything, it's just
in the example we actually want different values for this parameter in
different status. You need /some/ way to specify that.

If we don't do that in the common pinctrl binding, I see a couple choices:

a) Put it in static data in the pinctrl driver.

b) Put it in device tree in a binding that's specific to the individual
pinctrl driver, rather than a common binding.

Now in each case, if you want the value of some parameter on some pin to
be different in each of two states, you need /some/ way to represent that.
Perhaps in (a) above, the literal 32-bit value "DTA" could be implicit,
in that it's an array index into some table, but I don't see how to avoid
specifying the two different values that are desired...

> IMHO already that list of mux states seems limited as you may need to
> list other driver states too like pmx_sdhci_standby_wake_up_disabled and
> pmx_sdhci_standby_off. So it starts to sound a bit like PM policy instead
> of letting the driver know what hardware is on the system.

First off, the binding isn't enforcing any specific set of named states,
it's providing a mechanism to define a set of states with completely
arbitrary names. As such (as I think I gave an example elsewhere in this
thread), a dumb driver could require just one state e.g. "active", a
simple driver could require two states e.g. "active", "standby", and a
complex driver could require a whole bunch of different named states per
its needs. All this is allowed by the common binding which is just
providing a transport not policy. The pinctrl client drivers are what
are defining the required state names, in their individual binding.

Second, as I mentioned before, while some of the states are certainly
PM-related, I don't think all will be, e.g. the case of running an SD
controller at different clock rates to the SD card, and needing to
set different pin parameters based on the clock rate. Is runtime PM
intended cover that kind of thing? The idea here is that the common
pinctrl binding can allow the driver to require different named states
for those different clock rate cases.

> Having multiple config options also means that you end up setting
> #pinconfig-cell to something unnecessarily large for all mux nodes even
> if you only need the alternative values for one pin on the system.

I don't understand here.

In the example above, which I'll repeate:

config =
    <TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 1>
    <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 1>;

#pinconfig-cells would be 3:
cell 0 is pin/group ID
cell 1 is configuration parameter
cell 2 is value for that configuration parameter

The parsing of the config node involves splitting the whole cell list
into chunks of #pinconfig-cells each, and interpreting each one in turn,
in exactly the same way as #gpio-cells can be used to parse a DT property
containing a list of GPIOs.

> > Given that each named state can reference n nodes defining part of that
> > state's pinmux configuration, and some of those nodes can affect the same
> > pin controller, you can easily split the overall configuration into
> > "stuff that's common for all states for this device" and "stuff that's
> > common between these n states of the device but not these m others" and
> > "stuff that's unique to this 1 state", and hence avoid repeating any
> > identical information.
> >
> > > I'm suspecting that the initial state can be used to set the PM states for
> > > pins. Probably most pins can have the PM configuration set from the start.
> >
> > Can you please explain more?
> 
> For the cases I know the default values work for 95% - 100% of the pins in
> the system for PM also. Only few pins on some systems need to be dynamically
> remuxed during the runtime. The rest of the pins can be discarded after init.

So that's fine.

95% the same means that the nodes you use to describe the differences are
only 5% of the total; no repetition necessary in the DT nodes.

Now for the 95% of the programming that happens at device probe time:
Perhaps we could throw away all the data representing that after it was
performed.

However, that's not related to the DT binding; it's an implementation
detail of the pinctrl subsystem that it parses the pinmux mapping table
early in boot and keeps it around in memory (e.g. to display in sysfs).
I don't believe there's anything in the DT binding that forces the
implementation to do that.

Similarly, if you don't need any (or very little) of the dynamic per-
device stuff, you could probably just set up your base pinmux config
as a huge array of (in pinctrl subsystem terms) "system hog" entries,
or in terms of this DT binding, pin configuration nodes that are associated
with the pin controller itself rather than individual devices, and just
list the differences (if any) in the per-device nodes.


I need a bit more time to digest the rest of your email; the parts where
I think you're saying:

a) For stuff like active/suspend, have the pinctrl driver know what
   that means and implement it rather than explicitly representing
   those states in device tree (but where do we represent them?)

b) For other states, do everything through runtime PM. I need to
   familiarize myself with runtime PM in order to understand how that'd
   work I guess.

-- 
nvpbulic

