Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371Ab2A3DBp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 22:01:45 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39553 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab2A3DBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 22:01:44 -0500
Date: Mon, 30 Jan 2012 11:13:48 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Simon Glass <sjg@chromium.org>
Cc: Tony Lindgren <tony@atomide.com>, Stephen Warren <swarren@nvidia.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Linus Walleij (linus.walleij@linaro.org)" <linus.walleij@linaro.org>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>, Dong Aisheng <dongas86@gmail.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Pinmux bindings proposal V2
Message-ID: <20120130031346.GD10470@S2101-09.ap.freescale.net>
References: <74CDBE0F657A3D45AFBB94109FB122FF1780DAB4CE@HQMAIL01.nvidia.com>
 <CAPnjgZ3Xhebn1x1A-Vdy78DWbDd=cp0AK6tL-R1SRzS4GdF97g@mail.gmail.com>
 <20120127022111.GK29812@atomide.com>
 <CAPnjgZ2EkvTMsOkWyf4pfwRpvcvYs=WaKy5Gi8fdkAUQmvt=ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPnjgZ2EkvTMsOkWyf4pfwRpvcvYs=WaKy5Gi8fdkAUQmvt=ig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 07:43:36AM -0800, Simon Glass wrote:
...
> The cost of the pmx@dta node is about 12 bytes for the header (it
> depends on the length of the name), and each of the properties above
> is 16 bytes. So in total this node is 76 bytes. If we have 250 pins
> being muxed as Tegra3 then this is about 20KB (including a bit of
> slack for longer names). My point about being able to 'optimise out'
> some of these remains, though, but probably not for the kernel.
> 
> Stephen's 'mux' property uses 12 bytes plus 8 bytes per pin/group (I
> am removing the prefixes):
> 
>                        mux =
>                                <PG_DTA   MUX_SDIO1>
>                                <PG_DTD   MUX_SDIO1>;
> 
> so 28 bytes. What I proposed would use (12 + 2 * 16) per pin/group, or
> 44 bytes (60% bigger):
> 
It's not only about size but also run-time tree travelling efficiency.
Your proposal requires every single pin show as a node in device tree.
Looking at these for_each_node_by_*() APIs in include/linux/of.h, you
might agree we should avoid bloating device tree with so many nodes.

-- 
Regards,
Shawn
