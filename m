Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835Ab2ARLGM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 06:06:12 -0500
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:36509
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141Ab2ARLGK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 06:06:10 -0500
X-SpamScore: -14
X-BigFish: VS-14(zz9371I168aJ542M1432N98dKzz1202hzz8275dhz2dhc1ahc1bh2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Stephen Warren <swarren@nvidia.com>, Shawn Guo <shawn.guo@linaro.org>
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
Subject: RE: Pinmux bindings proposal
Thread-Topic: Pinmux bindings proposal
Thread-Index: AczSMvpNTKYWSKFeSLCZTyHqrIN5SAB+76JwAD04RoAACvoLgAAAhMwAABzEW6A=
Date: Wed, 18 Jan 2012 11:06:05 +0000
Message-ID: <7FE21149F4667147B645348EC6057885095125@039-SN2MPN1-013.039d.mgd.msft.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885091DEA@039-SN2MPN1-013.039d.mgd.msft.net>
 <20120117082334.GA31295@S2101-09.ap.freescale.net>
 <7FE21149F4667147B645348EC6057885092D56@039-SN2MPN1-013.039d.mgd.msft.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17801D22F5@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17801D22F5@HQMAIL01.nvidia.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.198]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Warren [mailto:swarren@nvidia.com]
> Sent: Wednesday, January 18, 2012 3:29 AM
> To: Dong Aisheng-B29396; Shawn Guo
> Cc: linus.walleij@stericsson.com; s.hauer@pengutronix.de;
> rob.herring@calxeda.com; kernel@pengutronix.de; cjb@laptop.org; Simon Glass
> (sjg@chromium.org); Dong Aisheng; linux-kernel@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; devicetree-discuss@lists.ozlabs.org
> Subject: RE: Pinmux bindings proposal
> Importance: High
> 
> Dong Aisheng wrote at Tuesday, January 17, 2012 2:47 AM:
> > Shawn Guo wrote at Tuesday, January 17, 2012 4:24 PM:
> > > On Mon, Jan 16, 2012 at 12:50:02PM +0000, Dong Aisheng-B29396 wrote:
> > > > Stephen Warren wrote:
> > > ...
> > > > >                         mux =
> > > > >                                 <&tegra_pmx TEGRA_PMX_PG_DTA
> TEGRA_PMX_MUX_1>
> > > > >                                 <&tegra_pmx TEGRA_PMX_PG_DTD
> TEGRA_PMX_MUX_1>
> > > > >                                 /* Syntax example */
> > > > >                                 <&foo_pmx FOO_PMX_PG_X
> > > > > FOO_PMX_MUX_0>;
> > > >
> > > > I'm still think how do we construct the pinmux map for such binding.
> > > > The format you're using is:
> > > > <&pmx_controller_phandle muxable_entity_id selected_function> For
> > > > contruct pinmux map, we need to know at least 3 things for a device:
> > > > a) pinctrl device b) function name c) group name.
> > > > For a, we can get it from this binding.
> > > > But for b and c, since they are constants, how to convert to name string?
> > >
> > > I guess, for function name, it should be retrieved from the client
> > > device node, and for the group name, it should be retrieved from the node
> here.
> >
> > I guess Stephen's idea is to retrieving the function name and group
> > name From the pinctrl driver since Tagre prefers to define those
> > things in driver Rather than in board file or soc.dts file.
> > But it does not fit for IMX since we define it in soc.dts.
> 
> You can still get the data from the driver, even if the driver got the data from
> the DT instead of static tables.
> 
The problem is that the pinmux map parsing is earlier than parsing the pinmux data,
And the driver still have no chance to run.
This is using bus notifier case.
For scanning case, the pinmux map parsing could be later than driver running.

> > > For above example, the function name can be picked from sdhci device
> > > node pinctr-names property I proposed,
> >
> > If I understand correctly, the pinctrl-names property you proposed
> > represents The pin group state.
> 
> Yes, that's my understanding.
> 
> ...
> > And in this way we're still using virtual groups.
> > It has no big difference as we did before like:
> > pinmux-groups {
> >         uart4grp: group@0 {
> >                 grp-name = "uart4grp";
> >                 grp-pins = <107 108>;
> >                 grp-mux = <4 4>;
> >         };
> >
> >         sd4grp: group@1 {
> >                 grp-name = "sd4grp";
> >                 grp-pins = <170 171 180 181 182 183 184 185 186 187>;
> >                 grp-mux = <0 0 1 1 1 1 1 1 1 1>;
> >         };
> > };
> 
> I'd prefer not to call these virtual groups, since "group" already has a meaning
> to the pinctrl subsystem that is somewhat different. As you've probably noticed,
> I've been using the term "pre-defined/canned pin configuration"!
> 
> > The real problem is do we need to support individual pin mux Or still
> > using virtual pin group?
> >
> > For the way Stephen proposed, we can only support individual pin mux
> > Since IMX pins are not grouped together in HW.
> 
> I think the "mux" and "config" properties I had in my proposal should deal
> purely with raw HW entities; nothing virtual/pre-defined/canned/...
> 
The question here is we defining a common model for pinctrl dt binding and
different SoC may have different characteristics like between Tegra and IMX.
So the proposal based on one SoC's raw HW entities should fit other SoCs.

> You can get what you're calling "virtual groups" simply by defining a bunch of
> pinmux configuration nodes in the pin controller's device node and exclusively
> referencing those in the per-device pinctrl properties.
>
Yes, for the pin config I think we have done some agreement.
Now i'm still thinking if the mux way we discussed here fits IMX.
For example:
> 	pinmux_sdhci: pinmux-sdhci {
> 		mux =
> 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
> 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>;
> 	};
It may work well for Tegra.
When pinctrl core parsing the mux proterty, it will creat each maps
For each entry in the list.
But for IMX like:
> > 	pinmux_usdhc1: pinmux-usdhc1 {
> > 		mux = <IMX6Q_PAD_SD1_DAT1 0>
> > 		      <IMX6Q_PAD_SD1_DAT2 0>
> > 		      ...
> > 	};
Each entry in the list is PIN rather than group.
So we cannot create each map for each entry in the list except we treat the PIN as
A group(this will cause a huge maps and predefined groups and functions).

A little different way I'm thinking now is cover the mux difference(pin or group)
between Tegra and IMX in Pinctrl driver, then we may not need the second mux value
(e.g: TEGRA_PMX_MUX_1)in the standard mux property:
The mux property can become:
pinmux_sdhci: pinmux-sdhci {
	mux =
		<&tegra_pmx TEGRA_PMX_PG_DTA_X>
		<&tegra_pmx TEGRA_PMX_PG_DTD_Y>;
};
The group TEGRA_PMX_PG_DTA_X should already know it's mux value(TEGRA_PMX_MUX_1) for a specific
Function.

For IMX, it could be like:
pinmux_sdhci: pinmux-sdhci {
	mux =
		<&imx_pmx &pinmux_sd1grp>;
};

For cover the difference whether the pingroups are defined in drive or soc.dts file.
The second param could be a name, like:
pinmux_sdhci: pinmux-sdhci {
	mux =
		<&imx_pmx "sd1grp">;
};

And the using is still like:
sdhci@c8000200 {
    ...
    pinctrl = <&pinmux_sdhci> <&pinconf_sdhci_active>
              <&pinmux_sdhci> <&pinconf_sdhci_suspend>;
    /* Number of entries in pinctrl for each in pinctrl-names */
    pinctrl-entries = <2 2>;
    pinctrl-names = "active", "suspend"; };

Another reason for this mode is that maybe some SoCs even does not have mux function for
Each pin or group. And current pinctrl subsystem design also does not have this conception.

Regards
Dong Aisheng


