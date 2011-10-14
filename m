Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab1JNKFK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 06:05:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40614 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932152Ab1JNKFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 06:05:07 -0400
Date: Fri, 14 Oct 2011 11:05:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Richard Zhao <richard.zhao@linaro.org>
Cc: Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        paul@pwsan.com, linaro-dev@lists.linaro.org,
        linus.walleij@stericsson.com, patches@linaro.org, eric.miao@linaro.org,
        magnus.damm@gmail.com, amit.kucheria@linaro.org,
        grant.likely@secretlab.ca, dsaxena@linaro.org,
        arnd.bergmann@linaro.org, shawn.guo@freescale.com, skannan@quicinc.com,
        linux@arm.linux.org.uk, jeremy.kerr@canonical.com, tglx@linutronix.de,
        linux-arm-kernel@lists.infradead.org, sboyd@quiinc.com
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
Message-ID: <20111014100504.GC2966@opensource.wolfsonmicro.com>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-2-git-send-email-mturquette@ti.com>
 <20111014081024.GA9485@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014081024.GA9485@b20223-02.ap.freescale.net>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 04:10:26PM +0800, Richard Zhao wrote:
> On Thu, Sep 22, 2011 at 03:26:56PM -0700, Mike Turquette wrote:

snip essentially Mike's entire mail - *please* delete irrelevant quotes
from your replies, it makes it very much easier to find the new text in
your mail and is much more friendly to people reading mail on mobile
devices.

> > +static int __clk_enable(struct clk *clk)
> > +{

> Could you expose __clk_enable/__clk_disable? I find it hard to implement
> clk group. clk group means, when a major clk enable/disable, it want a set
> of other clks enable/disable accordingly.

Shouldn't this be something the core is implementing?  I'd strongly
expect that the clock drivers are relatively dumb and delegate all the
decision making to the core API.  Otherwise it's going to be hard for
the core to implement any logic that involves working with more than one
clock like rate change notification, or guarantee that driver requests
made through the API are satisfied, as the state of the clocks will be
changing underneath it.
