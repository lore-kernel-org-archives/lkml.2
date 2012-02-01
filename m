Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab2BAOXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 09:23:17 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50639 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab2BAOXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 09:23:16 -0500
Date: Wed, 1 Feb 2012 22:35:34 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Dong Aisheng <dongas86@gmail.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Pinmux bindings proposal V2
Message-ID: <20120201143530.GA2203@S2101-09.ap.freescale.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

I had a talk with Dong about this binding, and we think that it should
work well for imx if we have a couple of small pieces added.

On Fri, Jan 20, 2012 at 02:22:20PM -0800, Stephen Warren wrote:
...
>                 pmx_sdhci: pinconfig-sdhci {
>                         /*
>                          * The mux property is a list of muxable entities
>                          * and the mux function to select for it. The number
>                          * of cells in each entry is the pin controller's
>                          * #pinmux-cells property. The pin controller's
>                          * binding defines what the cells mean. The pinctrl
>                          * driver is responsible for mapping this data to
>                          * the (group, function) pair required to fill in
>                          * the pinctrl subsystem's pinmux mapping table.
>                          */
>                         mux =
>                                 <TEGRA_PMX_PG_DTA TEGRA_PMX_MUX_SDIO1>
>                                 <TEGRA_PMX_PG_DTD TEGRA_PMX_MUX_SDIO1>;

We need a property like 'mux-unit' whose value can be either 'pin' or
'pingroup' to reflect something you mentioned as muxable entity.

The reason behind this is the DT logic inside pinctrl core needs to
know how the pinmux_map should be constructed from device tree.  In
tegra case, the 'mux-unit' is 'pingroup', the core should construct
pinmux_map entry for each row/element of 'mux'.  In imx case, the
'mux-unit' will be 'pin', and we would expect core construct only
one pinmux_map entry there, with all the pins listed in 'mux' composing
the group that pinmux_map needs.

And in case of 'mux-unit' is 'pin', we would need one more property
'mux-name' to present the group name.  Then we have all the pieces to
construct pinmux_map for cases like imx, where we do not define all
those functions, groups in pinctrl driver at all.

Regards,
Shawn

>                         /*
>                          * The config property is a list of muxable entities
>                          * and individual configuration setting. The number
>                          * of cells in each entry is the pin controller's
>                          * #pinconfig-cells property. The pin controller's
>                          * binding defines what the cells mean. The pinctrl
>                          * driver is responsible for mapping this data to
>                          * the (group, config) pair required to fill in
>                          * the pinctrl subsystem's pin configuration table.
>                          */
>                         config =
>                                 <TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
>                                 <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_DRIVE_STRENGTH 5>
>                                 <TEGRA_PMX_PG_DTA TEGRA_PMX_CONF_SLEW_RATE 4>
>                                 <TEGRA_PMX_PG_DTD TEGRA_PMX_CONF_SLEW_RATE 8>;
>                 };
