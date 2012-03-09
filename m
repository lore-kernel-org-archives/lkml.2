Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363Ab2CIAwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 19:52:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:44625 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759315Ab2CIAvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 19:51:49 -0500
Date: Fri, 9 Mar 2012 01:51:36 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Turquette, Mike" <mturquette@ti.com>
cc: Sascha Hauer <s.hauer@pengutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Paul Walmsley <paul@pwsan.com>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 3/4] clk: introduce the common clock framework
In-Reply-To: <CAJOA=zOG_6eSWPEfFL6VKWeTpGKD9y11xeHoOwdS3b59tAZ45A@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1203090148270.2742@ionos>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org> <1330763341-3437-4-git-send-email-mturquette@linaro.org> <20120303133158.GA26882@pengutronix.de> <CAJOA=zNFNEHxBDhRDdvm7DYR83R0LJjsp_AT3BoG+nL+iN5_tw@mail.gmail.com> <20120304115201.GB26882@pengutronix.de>
 <CAJOA=zP8d8wm==7=svOzh03Ft-1_LV71q0mA6Pncrh5vQSWGEA@mail.gmail.com> <20120305073836.GU3852@pengutronix.de> <CAJOA=zMs75ZQ24g5PXpSLV3AJzWEo12g86G8+4+ryQR_cTYpzA@mail.gmail.com> <20120306190039.GJ3852@pengutronix.de>
 <CAJOA=zOG_6eSWPEfFL6VKWeTpGKD9y11xeHoOwdS3b59tAZ45A@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012, Turquette, Mike wrote:
> Assuming that some day OMAP code can be refactored to allow for lazy
> (or at least initcall-based) registration of clocks then perhaps your
> suggestion can take root.  Which leads me to this question: are there
> any other platforms out there that require the level of expose to
> struct clk present in this patchset?  OMAP does, for now, but if that
> changes then I need to know if others require this as well.

I can't see the problem, really. Other than existing code doing stuff
before the memory allocator is up and running.

We allocate interrupt data structures in the early boot process today
and I don't see a reason why you want clocks, which have not been
configured by the boot loader, accesible before that point.

Thanks,

	tglx
