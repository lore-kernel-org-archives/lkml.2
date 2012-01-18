Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab2ARJcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 04:32:47 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:9006 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2ARJco convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 04:32:44 -0500
X-SpamScore: -13
X-BigFish: VS-13(zz1521M542M1432Nzz1202hzzz2dhc1ahc1bh2a8h668h839h8e2h8e3h944hbe9k61h)
X-Spam-TCS-SCL: 0:0
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
Thread-Index: AczSMvpNTKYWSKFeSLCZTyHqrIN5SAB+76JwAD04RoAAFvnvAAARF20g
Date: Wed, 18 Jan 2012 09:32:40 +0000
Message-ID: <7FE21149F4667147B645348EC6057885094F47@039-SN2MPN1-013.039d.mgd.msft.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885091DEA@039-SN2MPN1-013.039d.mgd.msft.net>
 <20120117082334.GA31295@S2101-09.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17801D22EB@HQMAIL01.nvidia.com>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17801D22EB@HQMAIL01.nvidia.com>
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
....

> > Considering the different pinctrl configurations for the same client
> > device usually share the same pinmux and only pinconf varies.  It may
> > worth introducing another level phandle reference.  Something like the
> > following:
> 
> I don't think there's a need for another level of indirection. The 1:n model I
> was talking about already handles this, I believe. See below.
> 
> > 	pinmux_sdhci: pinmux-sdhci {
> > 		mux =
> > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_1>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_1>;
> > 	};
> >
> > 	pinconf_sdhci_active: pinconf-sdhci-active {
> > 		config =
> > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
> > 	};
> >
> > 	pinconf_sdhci_suspend: pinconf-sdhci-suspend {
> > 		config =
> > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_TRISTATE 1>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_TRISTATE 1>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
> > 			<&tegra_pmx TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
> > 	};
> 
> Those 3 nodes make sense to me.
> 
> > 	pinctrl_sdhci_active: pinctrl-sdhci-active {
> > 		pinmux = <&pinmux_sdhci>;
> > 		pinconf = <&pinconf_sdhci_active>;
> > 	};
> >
> > 	pinctrl_sdhci_suspend: pinctrl-sdhci-suspend {
> > 		pinmux = <&pinmux_sdhci>;
> > 		pinconf = <&pinconf_sdhci_suspend>;
> > 	};
> 
> I think we can avoid those 2 nodes.
> 
> > 	sdhci@c8000200 {
> > 		...
> > 		pinctrl = <&pinctrl_sdhci_active> <&pinctrl_sdhci_suspend>;
> > 		pinctrl-names = "active", "suspend";
> > 	};
> 
> And rewrite that node as:
> 
> sdhci@c8000200 {
>     ...
>     pinctrl = <&pinmux_sdhci> <&pinconf_sdhci_active>
>               <&pinmux_sdhci> <&pinconf_sdhci_suspend>;
>     pinctrl-names = "active", "active", "suspend", "suspend"; };
> 
> The only slight disadvantage here is that the person constructing the
> pinctrl/pinctrl-names properties needs to know to explicitly list both the
> separate mux/config phandles for each value in pinctrl-names. Still, this seems
> a reasonable compromise; the user is still picking from a bunch of pre-
> defined/canned nodes, they simply need to list 2 (or n in
> general) of them for each state.
> 
> > This will be pretty useful for imx6 usdhc case, which will have 3
> > pinctrl configuration for each usdhc device (imx6 has 4 usdhc
> > devices), pinctrl-50mhz, pinctrl-100mhz and pinctrl-200mhz.  All these
> > 3 states have the exactly same pinmux settings, and only varies on pinconf.
> 
> Yes, I definitely agree there's a need for this.
> 
> As an aside, I wonder if the following would be any better:
> 
> sdhci@c8000200 {
>     ...
>     pinctrl = <&pinmux_sdhci> <&pinconf_sdhci_active>
>               <&pinmux_sdhci> <&pinconf_sdhci_suspend>;
>     /* Number of entries in pinctrl for each in pinctrl-names */
>     pinctrl-entries = <2 2>;
>     pinctrl-names = "active", "suspend"; };
> 
> That seems more complex though.
> 
This makes sense to me.

Regards
Dong Aisheng


