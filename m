Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2AQT3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 14:29:13 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17899 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab2AQT3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 14:29:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 17 Jan 2012 11:28:50 -0800
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
Date: Tue, 17 Jan 2012 11:28:50 -0800
Subject: RE: Pinmux bindings proposal
Thread-Topic: Pinmux bindings proposal
Thread-Index: AczSMvpNTKYWSKFeSLCZTyHqrIN5SAB+76JwAD04RoAACvoLgAAAhMwA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17801D22F5@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885091DEA@039-SN2MPN1-013.039d.mgd.msft.net>
 <20120117082334.GA31295@S2101-09.ap.freescale.net>
 <7FE21149F4667147B645348EC6057885092D56@039-SN2MPN1-013.039d.mgd.msft.net>
In-Reply-To: <7FE21149F4667147B645348EC6057885092D56@039-SN2MPN1-013.039d.mgd.msft.net>
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

Dong Aisheng wrote at Tuesday, January 17, 2012 2:47 AM:
> Shawn Guo wrote at Tuesday, January 17, 2012 4:24 PM:
> > On Mon, Jan 16, 2012 at 12:50:02PM +0000, Dong Aisheng-B29396 wrote:
> > > Stephen Warren wrote:
> > ...
> > > >                         mux =
> > > >                                 <&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
> > > >                                 <&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>
> > > >                                 /* Syntax example */
> > > >                                 <&foo_pmx FOO_PMX_PG_X FOO_PMX_MUX_0>;
> > >
> > > I'm still think how do we construct the pinmux map for such binding.
> > > The format you're using is:
> > > <&pmx_controller_phandle muxable_entity_id selected_function> For
> > > contruct pinmux map, we need to know at least 3 things for a device:
> > > a) pinctrl device b) function name c) group name.
> > > For a, we can get it from this binding.
> > > But for b and c, since they are constants, how to convert to name string?
> >
> > I guess, for function name, it should be retrieved from the client device node,
> > and for the group name, it should be retrieved from the node here.
>
> I guess Stephen's idea is to retrieving the function name and group name
> From the pinctrl driver since Tagre prefers to define those things in driver
> Rather than in board file or soc.dts file.
> But it does not fit for IMX since we define it in soc.dts.

You can still get the data from the driver, even if the driver got the
data from the DT instead of static tables.

> > For above example, the function name can be picked from sdhci device node
> > pinctr-names property I proposed,
>
> If I understand correctly, the pinctrl-names property you proposed represents
> The pin group state.

Yes, that's my understanding.

...
> And in this way we're still using virtual groups.
> It has no big difference as we did before like:
> pinmux-groups {
>         uart4grp: group@0 {
>                 grp-name = "uart4grp";
>                 grp-pins = <107 108>;
>                 grp-mux = <4 4>;
>         };
> 
>         sd4grp: group@1 {
>                 grp-name = "sd4grp";
>                 grp-pins = <170 171 180 181 182 183 184 185 186 187>;
>                 grp-mux = <0 0 1 1 1 1 1 1 1 1>;
>         };
> };

I'd prefer not to call these virtual groups, since "group" already has
a meaning to the pinctrl subsystem that is somewhat different. As you've
probably noticed, I've been using the term "pre-defined/canned pin
configuration"!

> The real problem is do we need to support individual pin mux
> Or still using virtual pin group?
>
> For the way Stephen proposed, we can only support individual pin mux
> Since IMX pins are not grouped together in HW.

I think the "mux" and "config" properties I had in my proposal should
deal purely with raw HW entities; nothing virtual/pre-defined/canned/...

You can get what you're calling "virtual groups" simply by defining a
bunch of pinmux configuration nodes in the pin controller's device node
and exclusively referencing those in the per-device pinctrl properties.

-- 
nvpublic

