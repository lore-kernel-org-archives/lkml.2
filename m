Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab2ARDts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 22:49:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46898 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab2ARDtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 22:49:47 -0500
Date: Wed, 18 Jan 2012 12:01:05 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Dong Aisheng-B29396 <B29396@freescale.com>,
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
Subject: Re: Pinmux bindings proposal
Message-ID: <20120118040103.GC563@S2101-09.ap.freescale.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF17801D202F@HQMAIL01.nvidia.com>
 <7FE21149F4667147B645348EC6057885091DEA@039-SN2MPN1-013.039d.mgd.msft.net>
 <20120117082334.GA31295@S2101-09.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17801D22EB@HQMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF17801D22EB@HQMAIL01.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 11:21:30AM -0800, Stephen Warren wrote:
> Shawn Guo wrote at Tuesday, January 17, 2012 1:24 AM:
...
> > Considering the different pinctrl configurations for the same client
> > device usually share the same pinmux and only pinconf varies.  It may
> > worth introducing another level phandle reference.  Something like
> > the following:
> 
> I don't think there's a need for another level of indirection. The 1:n
> model I was talking about already handles this, I believe. See below.
> 
Yes, agreed.

...

> > This will be pretty useful for imx6 usdhc case, which will have 3
> > pinctrl configuration for each usdhc device (imx6 has 4 usdhc devices),
> > pinctrl-50mhz, pinctrl-100mhz and pinctrl-200mhz.  All these 3 states
> > have the exactly same pinmux settings, and only varies on pinconf.
> 
> Yes, I definitely agree there's a need for this.
> 
> As an aside, I wonder if the following would be any better:
> 
It does look better to me.

Regards,
Shawn

> sdhci@c8000200 {
>     ...
>     pinctrl = <&pinmux_sdhci> <&pinconf_sdhci_active>
>               <&pinmux_sdhci> <&pinconf_sdhci_suspend>;
>     /* Number of entries in pinctrl for each in pinctrl-names */
>     pinctrl-entries = <2 2>;
>     pinctrl-names = "active", "suspend";
> };
> 
> That seems more complex though.
> 
