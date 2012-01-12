Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab2ALUrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:47:00 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2429 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378Ab2ALUq6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:46:58 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Jan 2012 12:46:53 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        Dong Aisheng <dongas86@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Richard Zhao <richard.zhao@linaro.org>
Date: Thu, 12 Jan 2012 12:46:52 -0800
Subject: RE: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Topic: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Thread-Index: AczQ2lam2hqddaL6RqmSWGKbU+6VvgAivNIQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17801D1DCC@HQMAIL01.nvidia.com>
References: <1324402840-32451-3-git-send-email-b29396@freescale.com>
 <74CDBE0F657A3D45AFBB94109FB122FF176BE92F00@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885075542@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF176CC743EF@HQMAIL01.nvidia.com>
 <CAA+hA=RBqpSmntS2h+6xMQuRvSRHenmDgrYSSzMXHtOCpU+HCQ@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17761F18F8@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC605788507F698@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE39E6B@HQMAIL01.nvidia.com>
 <20120107135445.GI4790@S2101-09.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF177EE3A6E5@HQMAIL01.nvidia.com>
 <20120112033941.GH20968@S2101-09.ap.freescale.net>
In-Reply-To: <20120112033941.GH20968@S2101-09.ap.freescale.net>
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

Shawn Guo wrote at Wednesday, January 11, 2012 8:40 PM:
> On Wed, Jan 11, 2012 at 10:17:40AM -0800, Stephen Warren wrote:
...
> > So, my position is that:
> >
> > * Something (either the pinctrl driver, or the SoC .dtsi file) should
> > enumerate all available muxable entities that exist in the SoC (pins for
> > IMX, groups for Tegra).
>
> Yes, we enumerate all available pins in pinctrl driver for imx.
>
> > * Something (either the pinctrl driver, or the SoC .dtsi file) should
> > enumerate all the available functions that can be assigned to a muxable
> > entity.
>
> In theory, yes.  But I hope you would agree we do not need to
> necessarily do this for case like imx.

Discussing just the Linux driver internals right now; ignoring device
tree:

Pinctrl won't let you use a function on a pin/group if that function
isn't enumerated and doesn't list that pin/group as a valid location
for that function. Given that, I'm not sure how you can avoid enumerating
all functions and their legal locations?

> For imx6q example, we have 193 pins as the muxable entities, and for
> each of those pin, there are 8 alternative functions.  Let's see what
> we will have if we enumerate all the available functions for each pin.
>
> enum imx6q_pads {
>         IMX6Q_SD2_DAT1 = 0,
>         IMX6Q_SD2_DAT2 = 1,
>         ...
>         IMX6Q_NANDF_D7 = 192,
> };
>
> enum imx6q_pad_sd2_dat1 {
>         IMX6Q_PAD_SD2_DAT1__USDHC2_DAT1                       = 0,
>         IMX6Q_PAD_SD2_DAT1__ECSPI5_SS0                        = 1,
>         IMX6Q_PAD_SD2_DAT1__WEIM_WEIM_CS_2            = 2,
>         IMX6Q_PAD_SD2_DAT1__AUDMUX_AUD4_TXFS          = 3,
>         IMX6Q_PAD_SD2_DAT1__KPP_COL_7                 = 4,
>         IMX6Q_PAD_SD2_DAT1__GPIO_1_14                 = 5,
>         IMX6Q_PAD_SD2_DAT1__CCM_WAIT                  = 6,
>         IMX6Q_PAD_SD2_DAT1__ANATOP_ANATOP_TESTO_0     = 7,
> };
>
> enum imx6q_pad_sd2_dat2 {
>         IMX6Q_PAD_SD2_DAT2__USDHC2_DAT2,
>         IMX6Q_PAD_SD2_DAT2__ECSPI5_SS1,
>         IMX6Q_PAD_SD2_DAT2__WEIM_WEIM_CS_3,
>         IMX6Q_PAD_SD2_DAT2__AUDMUX_AUD4_TXD,
>         IMX6Q_PAD_SD2_DAT2__KPP_ROW_6,
>         IMX6Q_PAD_SD2_DAT2__GPIO_1_13,
>         IMX6Q_PAD_SD2_DAT2__CCM_STOP,
>         IMX6Q_PAD_SD2_DAT2__ANATOP_ANATOP_TESTO_1,
> };
>
> ...
>
> enum imx6q_pad_nandf_d7 {
>         IMX6Q_PAD_NANDF_D7__RAWNAND_D7,
>         IMX6Q_PAD_NANDF_D7__USDHC2_DAT7,
>         IMX6Q_PAD_NANDF_D7__GPU3D_GPU_DEBUG_OUT_7,
>         IMX6Q_PAD_NANDF_D7__USBOH3_UH2_DFD_OUT_23,
>         IMX6Q_PAD_NANDF_D7__USBOH3_UH3_DFD_OUT_23,
>         IMX6Q_PAD_NANDF_D7__GPIO_2_7,
>         IMX6Q_PAD_NANDF_D7__IPU1_IPU_DIAG_BUS_7,
>         IMX6Q_PAD_NANDF_D7__IPU2_IPU_DIAG_BUS_7,
> };
>
> We simply do not want to over bloat imx6q pinctrl driver with such
> enumeration.

Yes, I see you'd end up with a huge number of function definitions here.

You may be able to avoid this by changing the way you name/number the
functions though.

The example above has a unique function name for every individual signal.
instead, can you name functions based on the controller they connect to?

So, instead of having:

IMX6Q_PAD_SD2_DAT1__USDHC2_DAT1
IMX6Q_PAD_SD2_DAT2__USDHC2_DAT2
IMX6Q_PAD_SD2_DAT3__USDHC2_DAT3
IMX6Q_PAD_SD2_DAT4__USDHC2_DAT4

Can you replace this with a single:

IMX_FUNC_USDHC2

Where the precise meaning of that function would vary slightly from pad
to pad; it'd mean "whatever signal from the USDHC2 controller can be
routed to this pad".

If a given pad could be mux'd to either of 2 (or n) signals from the same
controller, you may need both IMX_FUNC_USDHC2 and IMX_FUNC_USDHC2_ALT to
represent this.

Now, you'd also need a table that mapped from (pad, function) to
mux register value, but at least this would avoid avoid having so many
function names.

Does this help?

In the Tegra pinctrl patches I posted, I did exactly this.

I guess there is irony here, since I'm arguing elsewhere to make the
data model as close to the HW as possible, whereas here I'm arguing to
use a slightly abstract representation for function number rather than
the raw register mux values.

> You may want to suggest we put enumeration of both pins
> and their functions into dts, so that the pinctrl driver can be clean.

Personally, I'd actually tend to shy away from that; I see little point
putting this basic essentially static data into the .dts file just to
parse it back out at boot time into what'll end up being the same tables.

> I'm not sure how that will look like in your mind, but it's something
> like below in mine.
>
>         sd2_dat1: pin@0 {
>                 alt-functions = < "USDHC2_DAT1"
>                                   "ECSPI5_SS0"
>                                   "WEIM_WEIM_CS_2"
>                                   "AUDMUX_AUD4_TXFS"
>                                   "KPP_COL_7"
>                                   "GPIO_1_14"
>                                   "CCM_WAIT"
>                                   "ANATOP_ANATOP_TESTO_0" >;
>         };
>
>         sd2_dat2: pin@1 {
>                 alt-functions = < "USDHC2_DAT2"
>                                   "ECSPI5_SS1"
>                                   "WEIM_WEIM_CS_3"
>                                   "AUDMUX_AUD4_TXD"
>                                   "KPP_ROW_6"
>                                   "GPIO_1_13"
>                                   "CCM_STOP"
>                                   "ANATOP_ANATOP_TESTO_1" >;
>         };
>
> We will end up with having 193 such nodes in device tree.  I had one
> patch trying to add pinmux support for imx5 with enumerating every
> single pin in device tree (That's before pinctrl subsystem is born).
> The patch concerned Grant a lot with that many nodes in device tree
> and thus died.

Indeed.

> Besides the above concern, what's the point of enumerating all
> available functions for each pin at all?  The client device will still
> choose desired function with index/number.  See example below ...

As I mentioned above, the pinctrl subsystem currently requires it, since
the mapping table contains the function name, which it must then convert
to a function number, and then pass to the pinctrl driver.

As you point out though, this is just error-checking, and if the DT
were to contain the function number directly (rather than the name),
the pinctrl subsystem wouldn't have to convert name to number, but
could just pass the number through to the pinctrl driver. So, in that
scenario, the complete enumeration is only required for error-checking
(did someone put something bogus in the DT?). As such, it would be
technically possible to remove it. What does Linusw think about that?
Personally, it seems like a bad idea to remove the error checking.

Removing the error-checking would also require that the DT use the
raw register mux values, rather than the abstraction I mentioned above.
Doing anything else would require the table to map from function+pin to
mux value, i.e. require enumerating all functions.

> > * pinmux properties in device drivers should list the muxable entities
> > that they use, and the mux function for each of them.

(sorry, s/device drivers/device DT nodes/)

> Following on the example above, we will need something below in SD node
> to specify each pin and corresponding function selection.
>
>         usdhc@02194000 { /* uSDHC2 */
>                 #pinmux-cells = <2>;
>                 // The second cell specify the index of the desired function of given pin
>                 pinmux = < &sd2_dat1 0
>                            &sd2_dat2 0
>                            ...        >;
>                 status = "okay";
>         };
>
> IMO, it's not nice for pinctrl client devices.

What exactly is it not convenient for?

That DT example seems convenient enough for the person writing the DT
node for the device; it's a pretty direct representation of how to set
up the HW. If we allow "virtual" pin groups to be defined by the SoC
.dtsi file, and have the device DT nodes refer to those by phandle, then
the content of the referenced DT nodes is going to be roughly exactly
that same pinmux property, so there's no difference in DT content, just
the extra complexity of having to look something up by phandle.

That said, as you pointed out, the referenced DT node could be written
by a SoC vendor, hence perhaps simplifying life for the OEM writing the
usdhc DT node.

Perhaps what we need is to run cpp on the DT before dtc, so that the
SoC .dtsi file can define these "predefined" pinmux configurations, and
device DT nodes can reference them simply, but we don't bloat the .dtb
with unused "predefined" pinmux nodes, or require phandle parsing:

soc.dtsi:

#define IMX_PMX_USDHC2_A pinmux = < SD2_DAT1 SD2_DAT2 0>;
#define IMX_PMX_USDHC2_B pinmux = < PINX 4 PINY 7>;

board.dts:

usdhc@02194000 { /* uSDHC2 */
    IMX_PMX_USDHC2_A
};

That seems to solve all the problems except that we'd need to work out
how to integrate cpp into dtc.

As far as the device driver goes, I think it's irrelevant. Do note how
I assume this would work:

The pinctrl subsystem handles all aspects of parsing the pinmux DT value,
Including converting it to the internal mapping table representation if
applicable, iterating over the N groups in the value (just like it may
iterate over n mapping table entries when not using DT) etc.

Drivers call pinmux_get()/pinmux_enable() a single time, just as if the
pinctrl mapping table were provided through a board file instead of DT.
Given this, the DT binding doesn't have any impact on how a driver uses
the pinctrl APIs.



> > > > This avoids
> > > > parsing a heck of a lot of data from device tree. That means there isn't
> > > > any per-function node that can be referred to by phandle. Does it make
> > > > sense to refer to groups and functions by string name or integer ID
> > > > instead of phandle? Perhaps:
> > > >
> > > > usdhc@0219c000 { /* uSDHC4 */
> > > >     fsl,card-wired;
> > > >     status = "okay";
> > > >     pinmux = {
> > > >             group@0 {
> > > >                     group = "foo";
> > > >                     function = "uart3";
> > > >                     /* You could add pin config options here too */
> > > >             };
> > > >             group@1 {
> > > >                     group = "baz";
> > > >                     function = "uart4";
> > > >             };
> > > >     };
> > > > };
> > > >
> > > > I guess referring to things by name isn't that idiomatic for device tree.
> > > > Using integers here would be fine too, so long as dtc gets support for
> > > > named constants:
> > > >
> > > > imx6q.dtsi:
> > > >
> > > > /define/ IMX_PINGRP_FOO 0
> > > > /define/ IMX_PINGRP_BAR 1
> > > > /define/ IMX_PINGRP_BAZ 2
> > > > /define/ IMX_PINFUNC_UART3 0
> > > > /define/ IMX_PINFUNC_UART4 1
> > > > ...
> > > >
> > > > board .dts:
> > > >
> > > > usdhc@0219c000 { /* uSDHC4 */
> > > >     fsl,card-wired;
> > > >     status = "okay";
> > > >     pinmux = {
> > > >             group@0 {
> > > >                     group = <IMX_PINGRP_FOO>;
> > > >                     function = <IMX_PINFUNC_UART3>;
> > > >                     /* You could add pin config options here too */
> > > >             };
> > > >             group@1 {
> > > >                     group = <IMX_PINGRP_BAZ>;
> > > >                     function = <IMX_PINFUNC_UART4>;
> > > >             };
> > > >     };
> > > > };
> >
> > So given that IMX muxes per pin not per group of pins, that "group"
> > property above should really be named "pin", and the IMX_PINGRP_* values
> > renamed IMX_PIN_* instead.
> >
> > In general, it'd be nice to come up with a binding for the users of
> > pinmux (i.e. the device nodes like usdhc above) that allowed them to
> > refer to what I've been calling "muxable entity". perhaps instead of
> > "pin" or "group" the property should be called "mux-point", and it's
> > up to the pinctrl driver to interpret that as a pin or group ID based
> > on what its muxable entities are.
>
> See, this can be easily standardised if we allow pingroup represented
> in device tree even though the muxable entity at HW level is pin.
> That said, we can always have 'pinctrl' property under client device
> node as the phandle to the pingroup that the device uses.

That just moves the issue.

If the pin/group/location/muxable-entity property in the device's node
is replaced with a phandle to some other "group" node, that just moves
the problem that that referenced "group" node. It still has to list the
set of pins/groups/locations/muxable-entities it uses, and you have the
same issue.

Ignoring any other arguments for reference stuff using phandles in the
device DT nodes, it seems simples to say that the pin/group/... values
use in the device DT nodes refer to either pins or groups, as determined
by the pinmux HW. That's pretty easy if the pinctrl core calls into a
function in the pinctrl driver to process each individual pin/group
value, just like the IRQ/GPIO/... subsystems defer flag parsing (and
even allow IRQ/GPIO ID mapping to be overridden, IIRC) to the individual
drivers.

> > > Doing this does not change the fact that this is bound with Linux
> > > driver details.  That said, if the indexing of either pingrp array
> > > or pinfunc array changes in the driver, the binding is broken.
> >
> > I don't agree here.
> >
> > Having a driver state that it wants "pin P" or "group G" to be programmed
> > to "mux function F" is very purely HW oriented.
> >
> > The fact this so closely aligns with the data model that the pinctrl
> > subsystem uses is simply because I pushed for the same pure HW oriented
> > data model in the pinctrl subsystem; both models were derived from how
> > the HW works, rather than the binding being derived from the driver.
> >
> > Equally, the binding for the individual pin mux HW will define what the
> > integer values for pin/group/function are. In practice, we will choose
> > the values that the Linux pinctrl driver uses to remove the need for
> > conversion when parsing the device tree. However, we should be very aware
> > that the binding is what specifies the values, not the driver, so if the
> > driver changes its internal representation, it must add conversion code
> > when parsing the device tree, not require the device tree to change.
> >
> > That said, I don't see why the pinctrl driver would change its pin, group,
> > or mux function numbering scheme for a given SoC; the HW is fixed, right?
>
> It's right for case like Tegra where the group is defined by HW, but
> it's not for case like imx, where there is no group defined at HW
> level.  For imx non-dt case, the pingroup is defined by pinctrl driver,
> thus the indexing of pingroup array can really be random.

Yes, for virtual pin groups, sure. I was talking about real HW pin numbers
or group numbers.

If you're talking about virtual groups, then they need to be referenced
by phandle rather than ID, so the issue doesn't arise.

--
nvpublic

