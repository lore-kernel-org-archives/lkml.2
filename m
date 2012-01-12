Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534Ab2ALD3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 22:29:12 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60475 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab2ALD3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 22:29:04 -0500
Date: Thu, 12 Jan 2012 11:39:49 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
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
Subject: Re: [RFC PATCH v3 2/5] pinctrl: add dt binding support for pinmux
 mappings
Message-ID: <20120112033941.GH20968@S2101-09.ap.freescale.net>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF177EE3A6E5@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 10:17:40AM -0800, Stephen Warren wrote:
> Shawn Guo wrote at Saturday, January 07, 2012 6:55 AM:
> > On Fri, Jan 06, 2012 at 10:03:07AM -0800, Stephen Warren wrote:
> ...
> > > So, this does appear to be conflating the two things: The definition of
> > > what pins are in a pingroup, and the mux function for a particular
> > > setting of that pingroup. I think you need separate nodes for this.
> > >
> > At least for imx, we do not have mux function setting for pingroup.
> > Instead, it only applies to individual pin.
> 
> Ah. There's a slight disconnect between my understanding of your HW and
> how it really is then! I saw pingroup definitions on Dong's patch, and
> hence I assume that your HW was like Tegra, namely that pins were grouped
> together for mux control, i.e. muxing isn't a per-pin option. Given that,
> some of my responses may not entirely have made sense for your HW...
> 
> Just to confirm my understanding:
> 
> IMX:
> 
> * HW has a set of pins.
> * Each pin has a register/field that defines its mux function.
> 
Correct.

> And contrast this to Tegra for reference:
> 
> * HW has a set of pins.
> * Each pin is a member of a single mux group..
> * Each mux group has a register/field that defines its mux function.
>   This affects all the pins in the group at once, which are all set to
>   the same logical function (e.g. UART). For that logical function, each
>   pin has some specific signal muxed onto it. For example, a pin group
>   "X" may have pins P1 and P2, and when function "UART" is muxed onto "X",
>   P1 will be UART.RX and P2 UART.TX.

Understood.

> * Note that there also exist other properties that can be configured for
>   each of these mux groups (e.g. pullup/down, tristate). There also exist
>   other types of groups that don't align with the mux groups, and each of
>   those allows various other properties (e.g. drive strength) to be
>   configured. However, this bullet isn't relevant for the pin mux
>   discussion, just pin config.
> 
Same as pinmux, the pinconf applies to individual pin as well.

> So, my position is that:
> 
> * Something (either the pinctrl driver, or the SoC .dtsi file) should
> enumerate all available muxable entities that exist in the SoC (pins for
> IMX, groups for Tegra).
> 
Yes, we enumerate all available pins in pinctrl driver for imx.

> * Something (either the pinctrl driver, or the SoC .dtsi file) should
> enumerate all the available functions that can be assigned to a muxable
> entity.
> 
In theory, yes.  But I hope you would agree we do not need to
necessarily do this for case like imx.

For imx6q example, we have 193 pins as the muxable entities, and for
each of those pin, there are 8 alternative functions.  Let's see what
we will have if we enumerate all the available functions for each pin.

enum imx6q_pads {
        IMX6Q_SD2_DAT1 = 0,
        IMX6Q_SD2_DAT2 = 1,
        ...
        IMX6Q_NANDF_D7 = 192,
};

enum imx6q_pad_sd2_dat1 {
        IMX6Q_PAD_SD2_DAT1__USDHC2_DAT1			= 0,
        IMX6Q_PAD_SD2_DAT1__ECSPI5_SS0			= 1,
        IMX6Q_PAD_SD2_DAT1__WEIM_WEIM_CS_2		= 2,
        IMX6Q_PAD_SD2_DAT1__AUDMUX_AUD4_TXFS		= 3,
        IMX6Q_PAD_SD2_DAT1__KPP_COL_7			= 4,
        IMX6Q_PAD_SD2_DAT1__GPIO_1_14			= 5,
        IMX6Q_PAD_SD2_DAT1__CCM_WAIT			= 6,
        IMX6Q_PAD_SD2_DAT1__ANATOP_ANATOP_TESTO_0	= 7,
};

enum imx6q_pad_sd2_dat2 {
        IMX6Q_PAD_SD2_DAT2__USDHC2_DAT2,
        IMX6Q_PAD_SD2_DAT2__ECSPI5_SS1,
        IMX6Q_PAD_SD2_DAT2__WEIM_WEIM_CS_3,
        IMX6Q_PAD_SD2_DAT2__AUDMUX_AUD4_TXD,
        IMX6Q_PAD_SD2_DAT2__KPP_ROW_6,
        IMX6Q_PAD_SD2_DAT2__GPIO_1_13,
        IMX6Q_PAD_SD2_DAT2__CCM_STOP,
        IMX6Q_PAD_SD2_DAT2__ANATOP_ANATOP_TESTO_1,
};

...

enum imx6q_pad_nandf_d7 {
        IMX6Q_PAD_NANDF_D7__RAWNAND_D7,
        IMX6Q_PAD_NANDF_D7__USDHC2_DAT7,
        IMX6Q_PAD_NANDF_D7__GPU3D_GPU_DEBUG_OUT_7,
        IMX6Q_PAD_NANDF_D7__USBOH3_UH2_DFD_OUT_23,
        IMX6Q_PAD_NANDF_D7__USBOH3_UH3_DFD_OUT_23,
        IMX6Q_PAD_NANDF_D7__GPIO_2_7,
        IMX6Q_PAD_NANDF_D7__IPU1_IPU_DIAG_BUS_7,
        IMX6Q_PAD_NANDF_D7__IPU2_IPU_DIAG_BUS_7,
};

We simply do not want to over bloat imx6q pinctrl driver with such
enumeration.  You may want to suggest we put enumeration of both pins
and their functions into dts, so that the pinctrl driver can be clean.
I'm not sure how that will look like in your mind, but it's something
like below in mine.

        sd2_dat1: pin@0 {
                alt-functions = < "USDHC2_DAT1"
                                  "ECSPI5_SS0"
                                  "WEIM_WEIM_CS_2"
                                  "AUDMUX_AUD4_TXFS"
                                  "KPP_COL_7"
                                  "GPIO_1_14"
                                  "CCM_WAIT"
                                  "ANATOP_ANATOP_TESTO_0" >;
        };

        sd2_dat2: pin@1 {
                alt-functions = < "USDHC2_DAT2"
                                  "ECSPI5_SS1"
                                  "WEIM_WEIM_CS_3"
                                  "AUDMUX_AUD4_TXD"
                                  "KPP_ROW_6"
                                  "GPIO_1_13"
                                  "CCM_STOP"
                                  "ANATOP_ANATOP_TESTO_1" >;
        };

We will end up with having 193 such nodes in device tree.  I had one
patch trying to add pinmux support for imx5 with enumerating every
single pin in device tree (That's before pinctrl subsystem is born).
The patch concerned Grant a lot with that many nodes in device tree
and thus died.

Besides the above concern, what's the point of enumerating all
available functions for each pin at all?  The client device will still
choose desired function with index/number.  See example below ...

> * The enumerations above should be purely at the level the HW exposes,
> i.e. if a UART uses 4 signals (RX, TX, CTS, RTS), and the SoC configures
> muxing at a per-pin level, and 6 pins exist which can have various UART
> signals mux'd on to them, there should be a "muxable entity" enumeration
> for each of the 6 pins, not an enumeration for each possible combination
> of assignments of signals to pins, since in general that number could be
> extremely large as Richard Zao points out in his email that was sent right
> after yours.
> 
Speaking of the model, yes, it's true.  But coming to the practical
implementation, we may need compromise on whether we need to do a full
enumeration.

> * pinmux properties in device drivers should list the muxable entities
> that they use, and the mux function for each of them.
> 
Following on the example above, we will need something below in SD node
to specify each pin and corresponding function selection.

        usdhc@02194000 { /* uSDHC2 */
                #pinmux-cells = <2>;
                // The second cell specify the index of the desired function of given pin
                pinmux = < &sd2_dat1 0
                           &sd2_dat2 0
                           ...        >;
                status = "okay";
        };

IMO, it's not nice for pinctrl client devices.  Though it's true that
the muxable entity is pin, what the client device really cares is its
pingroup.  We should define the pingroup rather than pin for client
device to refer to with a phandle.  This is just like that pinctrl
subsystem api pinmux_get/enable operate on a pingroup as an interface
to client device driver, no matter the muxable entity at HW level is
a pin or a group.

> This is the minimal data model to represent the pure HW functionality,
> and is what the pinctrl subsystem uses too.
> 
I fully agree on this model in theory.  But again we may need compromise
on some particular implementation.

> > > Without separate nodes, there will eventually be a lot of duplication.
> > > A made-up example of the same uart4grp allowing either of two functions
> > > uart3, uart4 to be muxed out onto it:
> > >
> > > aips-bus@02000000 { /* AIPS1 */
> > >     iomuxc@020e0000 {
> > >             pinctrl_uart4_3: uart4@option_3 {
> > >                     func-name = "uart3";
> > >                     grp-name = "uart4grp";
> >
> > With phandle in dts reflecting the mapping, neither func-name nor
> > grp-name should be needed, and both can just be dropped, IMO.
> 
> I'd now argue that these nodes shouldn't even exist in the device tree;
> rather the "combination" of which muxable entities are used and their
> used mux function should be something in the board .dts files, since its
> board-specific.
> 
Again, it's a compromise.  Though the muxable entity at HW level is
individual pin, we are trying to provide a pingroup for client devices
to refer to, since that's what they are really interested in.

...

> > >             /* A node per group of pins. Each lists the group name, and
> > >              * the list of pins in the group */
> > >             foogrp: group@100 {
> > >                     grp-name = "foogrp";
> > >                     grp-pins = <100 101>;
> > >             };
> > >             bargrp: group@102 {
> > >                     grp-name = "bargrp";
> > >                     grp-pins = <102 103>;
> > >             };
> > >             bazgrp: group@104 {
> > >                     grp-name = "bargrp";
> > >                     grp-pins = <104 105>;
> > >             };
> >
> > I agree that we should define pingroups in <soc>.dtsi, but the mux
> > setting needs to be under the pingroup node too.  See comment below ...
> 
> As I mention above, I'd assert we shouldn't have any group nodes in
> the .dtsi file for SoCs that don't mux pins in groups at the raw HW level.
> 
I admit it's not a pingroup defined by raw HW.  We chose to create it
to ease users/client devices and avoid data duplication.

...

> > >             };
> > >             uart4func: func@1 {
> > >                     func-name = "uart4";
> > >                     locations = <&bargrp &bazgrp>;
> > >                     mux-value = <6 3>;
> > >             };
> >
> > I prefer to have function node defined in <board>.dtsi, since it's
> > all about defining phandle to the correct pingroup, which should be
> > decided by board design.
> 
> Just to explicitly re-iterate, if there are no groups in HW, I don't
> think the .dtsi file should attempt to represent any groups.
> 
Again, this is a compromise.  The groups represented here are meant to
helper users and save data duplication.

> (I think I'll talk a little more about this in a response to Richard
> Zhao's email later)

...

> > > * Should "pinmux" be a node, and the configuration of each group be a
> > > separate sub-node, so we can add more properties to each "table" entry
> > > in the future, e.g. pin config parameters?
> >
> > I do not think it's necessary. 'pinctrl' phandle works perfectly fine
> > to me at least for now.  How pinconf support should be added into
> > pinctrl subsystem is still up in the air to me.
> 
> Well, I think we definitely need to have a rough idea how to support pin
> config in the future; representing the current pin mux as a node rather
> than a property seems like a pretty easy way to allow this future
> flexibility.
> 
I guess, one benefit with representing pingroup anyway no matter the
muxable entity at HW level is pin or pingroup is we can always have
a pingroup node, thus the pinconf data can be represented there.  All
we need under client device node is a phandle to the correct pingroup
node.  Both pinmux and pinconf data can be found in that pingroup node.

> > > * For Tegra, I elected to put the definitions of pins, groups, and
> > > functions into the driver rather than in the device tree.
> >
> > IMO, we do not want to do this for imx, as I'm scared of the size
> > of Tegra pinctrl patches.  If we go this way for imx, we will have
> > even bigger patches.
> 
> Now you're confusing me! In one of your answers above, you said:
> 
>   > >           /* FIXME: Perhaps need pin nodes here to name them too */
>   > No, it's been listed in imx pinctrl driver.
> 
> So it sounds like the raw HW capabilities /are/ being enumerated by the
> pinctrl driver and not device tree, which is exactly what I was saying
> I'd chosen for Tegra. Well, with the exception that IMX's pinctrl driver
> doesn't define groups, since the HW doesn't mux in groups.
> 
> Perhaps you're talking about enumerating groups of pins, which don't
> really exist in HW. I wasn't.
> 
I meant we have the following defined in imx pinctrl driver.

enum imx6q_pads {
	IMX6Q_SD2_DAT1 = 0,
	IMX6Q_SD2_DAT2 = 1,
	...
};

#define IMX_PINCTRL_PIN(pin) PINCTRL_PIN(pin, #pin)

static const struct pinctrl_pin_desc imx6q_pinctrl_pads[] = {
	IMX_PINCTRL_PIN(MX6Q_SD2_DAT1),
	IMX_PINCTRL_PIN(MX6Q_SD2_DAT2),
	...
};

It's all about defining pin number and pin name.  All the HW
capabilities, pin mux, pin config, will be defined in device tree.

> > > This avoids
> > > parsing a heck of a lot of data from device tree. That means there isn't
> > > any per-function node that can be referred to by phandle. Does it make
> > > sense to refer to groups and functions by string name or integer ID
> > > instead of phandle? Perhaps:
> > >
> > > usdhc@0219c000 { /* uSDHC4 */
> > >     fsl,card-wired;
> > >     status = "okay";
> > >     pinmux = {
> > >             group@0 {
> > >                     group = "foo";
> > >                     function = "uart3";
> > >                     /* You could add pin config options here too */
> > >             };
> > >             group@1 {
> > >                     group = "baz";
> > >                     function = "uart4";
> > >             };
> > >     };
> > > };
> > >
> > > I guess referring to things by name isn't that idiomatic for device tree.
> > > Using integers here would be fine too, so long as dtc gets support for
> > > named constants:
> > >
> > > imx6q.dtsi:
> > >
> > > /define/ IMX_PINGRP_FOO 0
> > > /define/ IMX_PINGRP_BAR 1
> > > /define/ IMX_PINGRP_BAZ 2
> > > /define/ IMX_PINFUNC_UART3 0
> > > /define/ IMX_PINFUNC_UART4 1
> > > ...
> > >
> > > board .dts:
> > >
> > > usdhc@0219c000 { /* uSDHC4 */
> > >     fsl,card-wired;
> > >     status = "okay";
> > >     pinmux = {
> > >             group@0 {
> > >                     group = <IMX_PINGRP_FOO>;
> > >                     function = <IMX_PINFUNC_UART3>;
> > >                     /* You could add pin config options here too */
> > >             };
> > >             group@1 {
> > >                     group = <IMX_PINGRP_BAZ>;
> > >                     function = <IMX_PINFUNC_UART4>;
> > >             };
> > >     };
> > > };
> 
> So given that IMX muxes per pin not per group of pins, that "group"
> property above should really be named "pin", and the IMX_PINGRP_* values
> renamed IMX_PIN_* instead.
> 
> In general, it'd be nice to come up with a binding for the users of
> pinmux (i.e. the device nodes like usdhc above) that allowed them to
> refer to what I've been calling "muxable entity". perhaps instead of
> "pin" or "group" the property should be called "mux-point", and it's
> up to the pinctrl driver to interpret that as a pin or group ID based
> on what its muxable entities are.
> 
See, this can be easily standardised if we allow pingroup represented
in device tree even though the muxable entity at HW level is pin.
That said, we can always have 'pinctrl' property under client device
node as the phandle to the pingroup that the device uses.

> > Doing this does not change the fact that this is bound with Linux
> > driver details.  That said, if the indexing of either pingrp array
> > or pinfunc array changes in the driver, the binding is broken.
> 
> I don't agree here.
> 
> Having a driver state that it wants "pin P" or "group G" to be programmed
> to "mux function F" is very purely HW oriented.
> 
> The fact this so closely aligns with the data model that the pinctrl
> subsystem uses is simply because I pushed for the same pure HW oriented
> data model in the pinctrl subsystem; both models were derived from how
> the HW works, rather than the binding being derived from the driver.
> 
> Equally, the binding for the individual pin mux HW will define what the
> integer values for pin/group/function are. In practice, we will choose
> the values that the Linux pinctrl driver uses to remove the need for
> conversion when parsing the device tree. However, we should be very aware
> that the binding is what specifies the values, not the driver, so if the
> driver changes its internal representation, it must add conversion code
> when parsing the device tree, not require the device tree to change.
> 
> That said, I don't see why the pinctrl driver would change its pin, group,
> or mux function numbering scheme for a given SoC; the HW is fixed, right?

It's right for case like Tegra where the group is defined by HW, but
it's not for case like imx, where there is no group defined at HW
level.  For imx non-dt case, the pingroup is defined by pinctrl driver,
thus the indexing of pingroup array can really be random.

Regards,
Shawn

> (Well, for shipping HW, and designs-in-progress can presumably handle some
> churn in the device tree binding specification during RTL development
> or layout)
> 
> If there's a bug in the list of pins/groups/functions, that's probably
> also a bug in the device tree binding too, not an arbitrary change, so
> it seems fine to fix that, hopefully in as backwards-compatible way as
> possible though, i.e. adding missing entries to the end of the list so
> there's no renumbering etc. this is unlikely to happen late in the game.
