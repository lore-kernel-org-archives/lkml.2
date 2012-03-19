Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab2CSHlc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 03:41:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62054 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281Ab2CSHlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 03:41:31 -0400
Date: Mon, 19 Mar 2012 15:42:06 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Turquette, Mike" <mturquette@ti.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jeremy Kerr <jeremy.kerr@canonical.com>, Andrew Lunn <andrew@lunn.ch>,
        Paul Walmsley <paul@pwsan.com>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>
Subject: Re: [PATCH v5 3/4] clk: introduce the common clock framework
Message-ID: <20120319074202.GD31410@S2101-09.ap.freescale.net>
References: <1330763341-3437-4-git-send-email-mturquette@linaro.org>
 <20120303133158.GA26882@pengutronix.de>
 <CAJOA=zNFNEHxBDhRDdvm7DYR83R0LJjsp_AT3BoG+nL+iN5_tw@mail.gmail.com>
 <20120304115201.GB26882@pengutronix.de>
 <CAJOA=zP8d8wm==7=svOzh03Ft-1_LV71q0mA6Pncrh5vQSWGEA@mail.gmail.com>
 <20120305073836.GU3852@pengutronix.de>
 <CAJOA=zMs75ZQ24g5PXpSLV3AJzWEo12g86G8+4+ryQR_cTYpzA@mail.gmail.com>
 <20120306190039.GJ3852@pengutronix.de>
 <CAJOA=zOG_6eSWPEfFL6VKWeTpGKD9y11xeHoOwdS3b59tAZ45A@mail.gmail.com>
 <4F6403CD.8020509@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6403CD.8020509@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 08:23:57PM -0700, Saravana Kannan wrote:
> On 03/07/2012 01:20 PM, Turquette, Mike wrote:
...
> >Admittedly I think that the OMAP code could migrate some of these bits
> >to a lazy-registration model, specifically the hwmod object instances,
> >but that requires an awful lot of refactoring for a fairly large stack
> >of platform code.  This might be something to achieve in the future
> >but for now we *need* initialisation to be fully static.
> 
> When we work on moving clocks to device tree, wouldn't you face the
> same problem? You will have to dynamically create most of the clocks
> in that case too.
> 
>From what I heard from Mike[1], Omap will not have most of the clocks
encoded in device tree. 

Although my original preference was to have all the clocks represented
in device tree and dynamically registered to clk framework, I've heard
people including Grant incline to only have oscillator and leaf modules
clocks in device tree.  I somehow agree with that now, because having
all the clocks in there will bloat device tree dramatically, considering
there will be 3 clks, clk_gate, clk_divider and clk_mux backing one
clock in general.

Assuming we would agree to have most SoC internal clocks registered
from clock driver rather than device tree, I would like to hear about
how we should have these clock registered from clock driver, static
initialization or using register function?

-- 
Regards,
Shawn

[1] http://article.gmane.org/gmane.linux.linaro.devel/10554
