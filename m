Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964785Ab2CISfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 13:35:33 -0500
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:57901 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758549Ab2CISfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 13:35:32 -0500
MIME-Version: 1.0
In-Reply-To: <20120309023418.GF3261@b20223-02.ap.freescale.net>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org> <20120309023418.GF3261@b20223-02.ap.freescale.net>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Fri, 9 Mar 2012 10:35:07 -0800
Message-ID: <CAJOA=zOPTG-pZcQvpSPuNVduxN-3SyBGoygdALeAZFU01Bi4oQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] common clk framework
To: Richard Zhao <richard.zhao@freescale.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Paul Walmsley <paul@pwsan.com>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>, Andrew Lunn <andrew@lunn.ch>,
        Shawn Guo <shawn.guo@freescale.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        "Cousson, Benoit" <b-cousson@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 6:34 PM, Richard Zhao <richard.zhao@freescale.com> wrote:
> Hello Mike,
>
> The main interface for clk implementer is to register clocks dynamically.
> I think it highly depends on clk DT bindings. From the patch Grant sent
> out, it looks like he doesn't like one node per clk. So how do we
> register clocks dynamically? You have any sample code?

I can only speak for my own platform, but after talks with Paul W. and
Benoit C. I believe that OMAP will not push ALL of it's on-SoC clocks
into DT.  DT is meant to solve board-level integration problems and
the majority of OMAP clocks are SoC-level, not board level.  Some
clocks will migrate out to DT such as the primary oscillator (which
varies per board) as well as some leaf clocks and modules clocks that
depend on board-specific peripherals.

Otherwise the answer to your question is 'no'.  I don't have any
sample code for DT bindings.  It should not be hard to map some sample
clock bindings onto the existing registration functions... but it will
still be one clock per node.  I'm not really a fan of making clock
black-boxes where the details of the tree are hidden from the
framework anyways... that's something that clkdev already achieves to
some degree (by not exposing the entire tree to drivers, but only the
clocks that we want exposed).

Regards,
Mike

>
> Thanks
> Richard
>
