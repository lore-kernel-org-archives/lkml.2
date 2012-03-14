Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031073Ab2CNV2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 17:28:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:37156 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031060Ab2CNV2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 17:28:31 -0400
Date: Wed, 14 Mar 2012 22:28:15 +0100 (CET)
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
In-Reply-To: <CAJOA=zMsCuZgmp1Hm0dq=EVoX6Zj62XQVqR=6GzDntSD5HnHzg@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1203142218320.2466@ionos>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org> <1330763341-3437-4-git-send-email-mturquette@linaro.org> <20120313112447.GA29317@pengutronix.de> <CAJOA=zMTY+4dU9VUa-TkEbdE-WJd7V4tCG-af6vgq0CPN6rWpg@mail.gmail.com> <20120314084857.GL3852@pengutronix.de>
 <CAJOA=zMsCuZgmp1Hm0dq=EVoX6Zj62XQVqR=6GzDntSD5HnHzg@mail.gmail.com>
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

Could you folks please trim your replies? It's annoying to page down a
gazillion of lines to find the gist.

> On Wed, Mar 14, 2012 at 1:48 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> >> Also, do you forsee needing hole in parent_names for any reason other
> >> than described above?
> >
> > I need it only for the case where a some values in the mux are marked as
> > reserved in the datasheet or we simply do not have the corresponding
> > clock in our tree (yet). We could also say that NULL pointers are not
> > allowed in parent arrays, but instead "orphan" or "dummy" should be
> > used. Then __clk_init should check for NULL pointers to make this clear.
> 
> I've added a WARN in __clk_init if any entries in .parent_names are
> NULL.  I think it best to populate it with "dummy", or maybe a
> platform-specific name if it helps you during development.

There is no guarantee that the selection of a parent can be mapped
linear to register values.

So the right way to deal with it is to have an array of valid names
with no holes and NULL pointers allowed and have a mapping from the
array index to the register value.

That makes the core code robust and allows to handle all corner cases
including reserved bits, not implemented clocks and weird register
layouts.

Thanks,

	tglx
