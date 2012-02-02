Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab2BBUHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:07:25 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54773 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab2BBUHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:07:24 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF178E124AC5@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
	<20120201143530.GA2203@S2101-09.ap.freescale.net>
	<74CDBE0F657A3D45AFBB94109FB122FF178E124AC5@HQMAIL01.nvidia.com>
Date: Fri, 3 Feb 2012 04:07:23 +0800
Message-ID: <CAA+hA=RpkP-FFAr8wqVPjSKEMvO_sRHmOK_9nUYfuW=ps0O_=Q@mail.gmail.com>
Subject: Re: Pinmux bindings proposal V2
From: Dong Aisheng <dongas86@gmail.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 3, 2012 at 2:36 AM, Stephen Warren <swarren@nvidia.com> wrote:
> Shawn Guo wrote at Wednesday, February 01, 2012 7:36 AM:
> ...
>> I had a talk with Dong about this binding, and we think that it should
>> work well for imx if we have a couple of small pieces added.
>>
>> On Fri, Jan 20, 2012 at 02:22:20PM -0800, Stephen Warren wrote:
>> ...
>> >                 pmx_sdhci: pinconfig-sdhci {
>> >                         /*
>> >                          * The mux property is a list of muxable entities
>> >                          * and the mux function to select for it. The number
>> >                          * of cells in each entry is the pin controller's
>> >                          * #pinmux-cells property. The pin controller's
>> >                          * binding defines what the cells mean. The pinctrl
>> >                          * driver is responsible for mapping this data to
>> >                          * the (group, function) pair required to fill in
>> >                          * the pinctrl subsystem's pinmux mapping table.
>> >                          */
>> >                         mux =
>> >                                 <TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_SDIO1>
>> >                                 <TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_SDIO1>;
>>
>> We need a property like 'mux-unit' whose value can be either 'pin' or
>> 'pingroup' to reflect something you mentioned as muxable entity.
>
First i'd explain more about this way for better discussion.

It could be:
pinctrl_usdhc4: pinconfig-usdhc4 {
        /* 0: pin 1: group */
        mux-entity = <0>;
        func-name = "usdhc4func";
        grp-name = "usdhc4grp";
        mux =
                <MX6Q_SD4_CMD  0>
                <MX6Q_SD4_CLK  0>
                <MX6Q_SD4_DAT0 1>
                <MX6Q_SD4_DAT1 1>
                <MX6Q_SD4_DAT2 1>
                <MX6Q_SD4_DAT3 1>
                <MX6Q_SD4_DAT4 1>
                <MX6Q_SD4_DAT5 1>
                <MX6Q_SD4_DAT6 1>
                <MX6Q_SD4_DAT7 1>;
        config =
                <MX6Q_SD4_CMD  MX6Q_USDHC_PAD_CTRL>
                <MX6Q_SD4_CLK  MX6Q_USDHC_PAD_CTRL>
                <MX6Q_SD4_DAT0 MX6Q_USDHC_PAD_CTRL>
                <MX6Q_SD4_DAT1 MX6Q_USDHC_PAD_CTRL>
                <MX6Q_SD4_DAT2 MX6Q_USDHC_PAD_CTRL>
                <MX6Q_SD4_DAT3 MX6Q_USDHC_PAD_CTRL>
                <MX6Q_SD4_DAT4 MX6Q_USDHC_PAD_CTRL>
                <MX6Q_SD4_DAT5 MX6Q_USDHC_PAD_CTRL>
                <MX6Q_SD4_DAT6 MX6Q_USDHC_PAD_CTRL>
                <MX6Q_SD4_DAT7 MX6Q_USDHC_PAD_CTRL>;
};

Actually i think i'd rather do not use config property, then i could
be more compact:
(anyway it's another issue and is flexible to be controlled by #pinmux-cells)
pinctrl_usdhc4: pinconfig-usdhc4 {
        /* 0: pin 1: group */
        mux-entity = <0>;
        func-name = "usdhc4func";
        grp-name = "usdhc4grp";
        mux =
                <MX6Q_SD4_CMD  0 MX6Q_USDHC_PAD_CTRL>
                <MX6Q_SD4_CLK  0 MX6Q_USDHC_PAD_CTRL>
                <MX6Q_SD4_DAT0 1 MX6Q_USDHC_PAD_CTRL>
                <MX6Q_SD4_DAT1 1 MX6Q_USDHC_PAD_CTRL>
                <MX6Q_SD4_DAT2 1 MX6Q_USDHC_PAD_CTRL>
                <MX6Q_SD4_DAT3 1 MX6Q_USDHC_PAD_CTRL>
                <MX6Q_SD4_DAT4 1 MX6Q_USDHC_PAD_CTRL>
                <MX6Q_SD4_DAT5 1 MX6Q_USDHC_PAD_CTRL>
                <MX6Q_SD4_DAT6 1 MX6Q_USDHC_PAD_CTRL>
                <MX6Q_SD4_DAT7 1 MX6Q_USDHC_PAD_CTRL>;
};

The idea is that pinctrl-imx driver will parse all pinmux nodes like
pinctrl_usdhc4 to create the pinctrl functions and groups during
system boot up. For IMX, the mux entity is PIN
then we will treat all PINS in mux property is only on group. The
group name is grp-name##grp and the function name is mux-name##func.
Then we have predefined functions and groups.

When do pinmux map parsing during pinmux_get calling, the pinctrl core
will handle the two different cases for different muxable entity by
checking the mux-entity value.
If entity is PIN, all pins are a group and only one pinmux map
created, if entity is group,
each entry is a group and one map per group.

> I'm not sure I agree; see below.
>
>> The reason behind this is the DT logic inside pinctrl core needs to
>> know how the pinmux_map should be constructed from device tree.
>
> As a general statement, yes.
>
>> In tegra case, the 'mux-unit' is 'pingroup', the core should construct
>> pinmux_map entry for each row/element of 'mux'.
>
> Yes.
>
>> In imx case, the 'mux-unit' will be 'pin',
>
> OK.
>
> Just a note: Tegra30 also has per-pin muxability. Only Tegra20 muxes pins
> in groups. (although Tegra30 does some if its pin configuration in groups)
>
>> and we would expect core construct only
>> one pinmux_map entry there, with all the pins listed in 'mux' composing
>> the group that pinmux_map needs.
>
> This is where I disagree.
>
> If the pinmux_map should only contain a single entry, wouldn't the DT
> mux property only contain a single entry?
>
The reason is that the single entry of IMX is a PIN rather than a
group as tegra.

> The reason being that if there's a single entry in the pinmux_map, the
> group name used in that entry must be a group that's supported directly
> by the pinctrl driver (that's just the way pinctrl works). As such, why
> not just write the device tree in terms of those groups?
>
Because with the format:
<muxable_entity  muxed_function>
The muxed_function applies for the whole muxable_entity.
If we use virtual group for muxable_entity here, for imx, we can not
use one muxed_function for whole pins in that group.
That means we need a more complicated data for muxed_function to represent
all function for each pin in that virtual group.

> The only way I can see this not being true is if your pinctrl driver is
> also parsing these mux properties, and dynamically creating the groups
> that it exposes based on the list of pins in the mux property.
Yes.

>  However,
> that seems like the wrong approach; If you're dynamically defining groups
> in DT, I'd expect separate explicit driver-specific properties/nodes to
> define those groups, such that the pinctrl core's processing of the mux
> property to be identical in all cases.
>
> i.e. instead of what your "mux-unit" proposal:
>
>    pmx_sdhci: pinconfig-sdhci {
>        mux =
>            <TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_SDIO1>
>            <TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_SDIO1>;
>        mux-unit = "pingroup";
>        mux-name = "sdio-config-1";
>    };
>
> I'd expect something more like:
>
>    /* Standardized pinctrl properties */
>    pmx_sdhci: pinconfig-sdhci {
>        mux = <IMX_PG_SDIO_CFG_1 IMX_MUX_SDIO1>;
>    };
>
>    /*
>     * Driver-specific properties which tell the driver which potentially
>     * board-specific pin-groups to implement.
>     */
>    imx-pingroup-sdio-cfg-1 {
>        id = <IMX_PG_SDIO_CFG_1>;
>        pins = <IMX_PIN_SDIO1_CLK IMX_PIN_SDIO1_CMD IMX_PIN_SDIO1_DAT0...>;
>    };
>
> Does that make sense?
>
As i explained above, we can not represent a function with one single
data IMX_MUX_SDIO1 for all pins in the group IMX_PG_SDIO_CFG_1.

A similar way i did before is:
imx-pingroup-sdio-cfg-1 {
     id = <IMX_PG_SDIO_CFG_1>;
    pins = <IMX_PIN_SDIO1_CLK mux_1>
              <IMX_PIN_SDIO1_CMD mux_2...>;
};

pmx_sdhci: pinconfig-sdhci {
   mux = <IMX_PG_SDIO_CFG_1>;
};

And i prefered IMX_PG_SDIO_CFG_1 to be a phandle to imx-pingroup-sdio-cfg-1.

The real case i have done before is that:
soc.dtsi:

iomuxc@020e0000 {
        compatible = "fsl,imx6q-iomuxc";
        reg = <0x020e0000 0x4000>;
        pinmux-groups {
                uart4grp: group@0 {
                        grp-name = "uart4grp";
                        grp-pins = <107 108>;
                        grp-mux = <4 4>;
                };

                sd4grp: group@1 {
                        grp-name = "sd4grp";
                        grp-pins = <170 171 180 181 182 183 184 185 186 187>;
                        grp-mux = <0 0 1 1 1 1 1 1 1 1>;
                };
        };

        pinmux-functions {
                uart4func: func@0 {
                        func-name = "uart4";
                        groups = <&uart4grp>;
                };

                sd4func: func@1 {
                        func-name = "sd4";
                        groups = <&sd4grp>;
                };
        };
};

board.dts:

uart3: uart@021f0000 { /* UART4 */
        status = "okay";
        pinmux = <&sd4grp>;
};

To be more like the way you proposed, it could be:
board.dts:
pmx_usdhc4: pinconfig-usdhc4 {
        mux = <&sd4grp>
        /* we can add a similar config node for each pin*/
        config = <&sd4config>
};

uart3: uart@021f0000 { /* UART4 */
        status = "okay";
        pinmux = <&pmx_usdhc4>;
};

This is a working way and i have discussed it with Shawn before.
However, since these things are a little pinctrl core specific,
so more or less we're a little more like the data model you proposed
for Tegra since it represents hw better.
And the pinmux map parsing is done in pinctrl core, we also want to
align the binding as tegra.
That why we consider keep using your proposed data model and find a
new way(introduce mux_entity and create pinmux map differently) to use
virtual group for IMX.

However If IMX uses the data model i described above, the binding is
then a little different from tegra. that means we may need to change
to  let each soc's pinctrl driver do real pinmux map parsing (maybe
add a callback in pinctrl.ops) based on their soc specific pinctrl
configuration node like pmx_usdhc4 above instread of let pinctrl core
do a standard pinmux map parsing which is our target we discussed so
long for.

Regards
Dong Aisheng
