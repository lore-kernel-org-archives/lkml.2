Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab1JQItH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 04:49:07 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:12519
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084Ab1JQItF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 04:49:05 -0400
X-SpamScore: -2
X-BigFish: VS-2(z1039oz1432N98dKzz1202hzz8275dhz2dh87h2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 17 Oct 2011 16:48:52 +0800
From: Richard Zhao <richard.zhao@linaro.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: <linux-arm-kernel@lists.infradead.org>, <paul@pwsan.com>,
        <linaro-dev@lists.linaro.org>, <linus.walleij@stericsson.com>,
        <patches@linaro.org>, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <magnus.damm@gmail.com>, <linux-kernel@vger.kernel.org>,
        <eric.miao@linaro.org>, <grant.likely@secretlab.ca>,
        <arnd.bergmann@linaro.org>, <dsaxena@linaro.org>, <tglx@linutronix.de>,
        <amit.kucheria@linaro.org>, <linux@arm.linux.org.uk>,
        <skannan@quicinc.com>, Mike Turquette <mturquette@ti.com>,
        <jeremy.kerr@canonical.com>, <shawn.guo@freescale.com>,
        <sboyd@quiinc.com>
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
Message-ID: <20111017084851.GB20184@b20223-02.ap.freescale.net>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-2-git-send-email-mturquette@ti.com>
 <20111014081024.GA9485@b20223-02.ap.freescale.net>
 <20111014100504.GC2966@opensource.wolfsonmicro.com>
 <20111014103233.GB9485@b20223-02.ap.freescale.net>
 <20111016175521.GA13565@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111016175521.GA13565@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 16, 2011 at 07:55:21PM +0200, Sascha Hauer wrote:
> On Fri, Oct 14, 2011 at 06:32:33PM +0800, Richard Zhao wrote:
> > On Fri, Oct 14, 2011 at 11:05:04AM +0100, Mark Brown wrote:
> > > On Fri, Oct 14, 2011 at 04:10:26PM +0800, Richard Zhao wrote:
> > > > On Thu, Sep 22, 2011 at 03:26:56PM -0700, Mike Turquette wrote:
> > > 
> > > snip essentially Mike's entire mail - *please* delete irrelevant quotes
> > > from your replies, it makes it very much easier to find the new text in
> > > your mail and is much more friendly to people reading mail on mobile
> > > devices.
> > I snip not enough? sorry for that. I'll be carefull.
> > > 
> > > > > +static int __clk_enable(struct clk *clk)
> > > > > +{
> > > 
> > > > Could you expose __clk_enable/__clk_disable? I find it hard to implement
> > > > clk group. clk group means, when a major clk enable/disable, it want a set
> > > > of other clks enable/disable accordingly.
> > > 
> > > Shouldn't this be something the core is implementing?  I'd strongly
> > > expect that the clock drivers are relatively dumb and delegate all the
> > > decision making to the core API.  Otherwise it's going to be hard for
> > > the core to implement any logic that involves working with more than one
> > > clock like rate change notification, or guarantee that driver requests
> > > made through the API are satisfied, as the state of the clocks will be
> > > changing underneath it.
> > From my point of view, the first step of generic clk can be, easy to adopt
> > features of clocks in current mainline git.
> > Back to the clk group, I have a patch based on Sascha's work. 
> > http://git.linaro.org/gitweb?p=people/riczhao/linux-2.6.git;a=shortlog;h=refs/heads/imx-clk
> 
> I thought further about this and a clock group is not something we want
> to have at all. Clocks are supposed to be arranged in a tree and
> grouping clocks together violates this which leads to problems.
> This grouping should be done at driver level, so when a driver needs
> more than one clock it should request them all, maybe with a clk_get_all
> helper function.
clock group is not limited to help driver get clock. It refects clock dependency.
For example, devices that possible access to on-chip RAM, depend on OCRAM clock. 
On imx53, VPU depends on OCRAM clock, even when VPU does not use OCRAM.

Thanks
Richard
> 
> Sascha
> 
> -- 
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

