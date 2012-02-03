Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932Ab2BCNuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 08:50:15 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60380 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab2BCNuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 08:50:12 -0500
Date: Fri, 3 Feb 2012 22:02:41 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Dong Aisheng <dongas86@gmail.com>
Cc: Stephen Warren <swarren@nvidia.com>,
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
Subject: Re: Pinmux bindings proposal V2
Message-ID: <20120203140238.GC12915@S2101-09.ap.freescale.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <20120201143530.GA2203@S2101-09.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF178E124AC5@HQMAIL01.nvidia.com>
 <CAA+hA=RpkP-FFAr8wqVPjSKEMvO_sRHmOK_9nUYfuW=ps0O_=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA+hA=RpkP-FFAr8wqVPjSKEMvO_sRHmOK_9nUYfuW=ps0O_=Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 04:07:23AM +0800, Dong Aisheng wrote:
...
> However If IMX uses the data model i described above, the binding is
> then a little different from tegra. that means we may need to change
> to  let each soc's pinctrl driver do real pinmux map parsing (maybe
> add a callback in pinctrl.ops) based on their soc specific pinctrl
> configuration node like pmx_usdhc4 above instread of let pinctrl core
> do a standard pinmux map parsing which is our target we discussed so
> long for.
> 
Yeah, this seems a reasonable alternative to me.  Pushing the pinmux_map
construction down to individual pinctrl driver, who can interpret 'mux'
property best, will relieve the pinctrl core from understanding the
property for different cases, so that we can even save the property
'mux-unit' I asked for.  And doing so somehow aligns with non-dt case,
where the pinmux_map is constructed by individual pinctrl driver too
(with help from PINMUX_MAP_* macros in board file).

-- 
Regards,
Shawn
