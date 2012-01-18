Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776Ab2ARDpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 22:45:07 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:9541
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754351Ab2ARDpF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 22:45:05 -0500
X-SpamScore: -5
X-BigFish: VS-5(zz168aJ1432Nzz1202hzz8275chz2dhc1ahc1bh2a8h668h839h8e2h8e3h944hbe9k)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Shawn Guo <shawn.guo@linaro.org>
CC: Stephen Warren <swarren@nvidia.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
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
Thread-Index: AczSMvpNTKYWSKFeSLCZTyHqrIN5SAB+76JwAD04RoAACvoLgAABPUMAAA81xtA=
Date: Wed, 18 Jan 2012 03:44:59 +0000
Message-ID: <7FE21149F4667147B645348EC6057885093AD9@039-SN2MPN1-013.039d.mgd.msft.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885091DEA@039-SN2MPN1-013.039d.mgd.msft.net>
 <20120117082334.GA31295@S2101-09.ap.freescale.net>
 <7FE21149F4667147B645348EC6057885092D56@039-SN2MPN1-013.039d.mgd.msft.net>
 <20120117141322.GA31687@S2101-09.ap.freescale.net>
In-Reply-To: <20120117141322.GA31687@S2101-09.ap.freescale.net>
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

....
> > > It may worth introducing
> > > another level phandle reference.  Something like the following:
> > >
> > > 	pinmux_sdhci: pinmux-sdhci {
> > > 		mux =
> > > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
> > > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>;
> > > 	};
> > >
> > > 	pinconf_sdhci_active: pinconf-sdhci-active {
> > > 		config =
> > > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
> > > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
> > > 	};
> > >
> > > 	pinconf_sdhci_suspend: pinconf-sdhci-suspend {
> > > 		config =
> > > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 1>
> > > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 1>
> > > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
> > > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
> > > 	};
> > >
> > The config makes sense to me.
> > The only question is how to get group name to match with the predefined groups.
> >
> I still incline to say there should not be any predefined groups for DT case, if
> we choose to find the group in use only when pinmux_get() gets called. 
Then we have too issue I said before:
1) Inconsistent issue
sysfs pinmux map entry has different meaning
2) need to change the pinmux_maps from arrays to list for better to dynamically
Insert the new created pinmux map detected.
But this does affect the non-dt case a lot.

> Even if
> you insist to have a global scanning on device tree for all groups to create the
> pinmux mapping table, those predefined groups can only be created by your
> scanning code, 
The predefined groups and functions are in soc.dts file and will be parsed
Independently with the pinmux map table creation.

> so you should know how the name comes from device tree, and you
> should be able to recreate the name when you are trying to matching the name in
> the table you created before.
> 
> > Besides per pin group configuration support, we may also want per pin
> > configuration Support as the latest patch sent by Linus.
> > http://www.spinics.net/lists/arm-kernel/msg155712.html
> >
> This binding proposal has covered both pin and group configuration, as the
> second parameter of 'config' property could be either a pin or group which
> depends the on whether the configurable entity at HW level is a pin or group.
> 
The pinctrl driver does not know if it's group or pin.
We may find a way to identify it.

> ...
> 
> > > > If "muxable entities" is pins on IMX, I'm wondering how we define
> > > > the predefined Functions and groups or if we still need to do that.
> > > >
> > > Let's put this in the example below.
> > >
> > > 	pinmux_usdhc1: pinmux-usdhc1 {
> > > 		mux = <IMX6Q_PAD_SD1_DAT1 0>
> > > 		      <IMX6Q_PAD_SD1_DAT2 0>
> > > 		      ...
> > > 	};
> > >
> > Yes, I agree.
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
> >
> You are right.  They are fundamentally same and just in different format.
> 
> > The real problem is do we need to support individual pin mux Or still
> > using virtual pin group?
> > For the way Stephen proposed, we can only support individual pin mux
> > Since IMX pins are not grouped together in HW.
> >
> I do not see any problem here.  If you look at the first column of 'mux'
> property of node pinmux-usdhc1, it is a group of pins for usdhc1.
> Isn't it one virtual pin group for usdhc1?
> 
If we treat the whole pins in 'mux' property as a group,
There may be potential inconsistent issue since Tegra will treat each
One in the list of 'mux' as a group.
And it would be a problem for pinctrl core to parse it in a standard way.

Regards
Dong Aisheng


