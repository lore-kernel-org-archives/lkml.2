Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab2CSFhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 01:37:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36901 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab2CSFha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 01:37:30 -0400
Date: Mon, 19 Mar 2012 13:38:04 +0800
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
Message-ID: <20120319053801.GB31410@S2101-09.ap.freescale.net>
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
...
> Hi Mike,
> 
> I already took a quick look at the v7 series, but I thought this
> thread has more relevant context for my response. So, responding
> here.
> 
> I'm with Sascha on creating a clk_internal/clk_initializer and
> removing clk_hw. You had asked about the benefits of his suggestion
> in one of the earlier threads. I'm sure I have told some of these
> reasons I don't like clk_hw, but repeating my points here for others
> to chime in.
> 
> I used to be a huge proponent for using macros for clocks in our
> internal tree. All the clocks were constructed using macros (you
> will see it in the history of tree we publish in CAF). They quickly
> became unreadable when you have several hundreds of clocks. The
> biggest problem is that you can't quickly look at a clock's macro
> and figure out what the register offset or bit mask or shift value
> is. Our eyes/brains aren't meant for quickly parsing the commas and
> finding the n-th field or even remembering what the n-th field of
> each macro corresponds to. If it's actually broken out as fields in
> a struct, it's much easier to read. So, long story short, I think
> the well-intentioned helper macros will make code quite unreadable.
> 
While I second the idea of clk_initializer, using macros is not really
the thing to complain.  You can save using those macro helpers by
calling APIs clk_register_*().  But that does not solve the problem,
because those APIs also have a long argument list to fill.

-- 
Regards,
Shawn
