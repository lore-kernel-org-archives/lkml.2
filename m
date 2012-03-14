Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622Ab2CNWTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:19:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:37460 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761165Ab2CNWS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:18:59 -0400
Date: Wed, 14 Mar 2012 23:18:44 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Turquette, Mike" <mturquette@ti.com>
cc: Sascha Hauer <s.hauer@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        linaro-dev@lists.linaro.org, Grant Likely <grant.likely@secretlab.ca>,
        Saravana Kannan <skannan@codeaurora.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergman <arnd.bergmann@linaro.org>, patches@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>
Subject: Re: [PATCH v5 3/4] clk: introduce the common clock framework
In-Reply-To: <CAJOA=zNj8eC+h-S9KqwuAEiGFZMAn2h0TNTR6nund4qM7Z97ug@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1203142317280.2466@ionos>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org> <1330763341-3437-4-git-send-email-mturquette@linaro.org> <20120313112447.GA29317@pengutronix.de> <CAJOA=zMTY+4dU9VUa-TkEbdE-WJd7V4tCG-af6vgq0CPN6rWpg@mail.gmail.com> <20120314084857.GL3852@pengutronix.de>
 <CAJOA=zMsCuZgmp1Hm0dq=EVoX6Zj62XQVqR=6GzDntSD5HnHzg@mail.gmail.com> <alpine.LFD.2.02.1203142218320.2466@ionos> <CAJOA=zNj8eC+h-S9KqwuAEiGFZMAn2h0TNTR6nund4qM7Z97ug@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012, Turquette, Mike wrote:
> On Wed, Mar 14, 2012 at 2:28 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > So the right way to deal with it is to have an array of valid names
> > with no holes and NULL pointers allowed and have a mapping from the
> > array index to the register value.
> 
> This is essentially what the .set_rate callback does.  It takes as
> input "u8 index" and peforms the hardware specific magic to select the
> correct parent clock.  This might be a register write using that exact
> same index, or it might be a single-bit register write using that
> index as the shift value, or it might translate that index into the
> data sent to an i2c device (where the address would be stored in
> struct clk_foo), etc etc.
> 
> We both agree that .parent_names must contain valid names and should
> not have holes.  What I don't understand is if you are saying that we
> should allow NULL ptrs as names; that seems contradictory but I want
> to make sure I'm reading you correctly.

I should have said: no holes and no NULL pointers, just an array of
valid names.

Thanks,

	tglx
