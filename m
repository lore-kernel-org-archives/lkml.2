Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab1JQKxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 06:53:17 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:20241
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750850Ab1JQKxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 06:53:16 -0400
X-SpamScore: -2
X-BigFish: VS-2(z1039oz1432N98dKzz1202hzz8275dhz2dh87h2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
X-FB-DOMAIN-IP-MATCH: fail
Date: Mon, 17 Oct 2011 18:53:03 +0800
From: Richard Zhao <richard.zhao@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: <jeremy.kerr@canonical.com>, <paul@pwsan.com>,
        <linaro-dev@lists.linaro.org>, <linus.walleij@stericsson.com>,
        <patches@linaro.org>, <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, <magnus.damm@gmail.com>,
        <linux-kernel@vger.kernel.org>, <eric.miao@linaro.org>,
        <grant.likely@secretlab.ca>, <dsaxena@linaro.org>,
        <amit.kucheria@linaro.org>, <skannan@quicinc.com>,
        <linux@arm.linux.org.uk>, <arnd.bergmann@linaro.org>,
        <sboyd@quiinc.com>, <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH v2 1/7] clk: Add a generic clock infrastructure
Message-ID: <20111017105302.GC20184@b20223-02.ap.freescale.net>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-2-git-send-email-mturquette@ti.com>
 <20111014081024.GA9485@b20223-02.ap.freescale.net>
 <20111014100504.GC2966@opensource.wolfsonmicro.com>
 <20111014103233.GB9485@b20223-02.ap.freescale.net>
 <20111016175521.GA13565@pengutronix.de>
 <20111017084851.GB20184@b20223-02.ap.freescale.net>
 <20111017092028.GA3042@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111017092028.GA3042@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 10:20:28AM +0100, Mark Brown wrote:
> On Mon, Oct 17, 2011 at 04:48:52PM +0800, Richard Zhao wrote:
> 
> > For example, devices that possible access to on-chip RAM, depend on OCRAM clock. 
> > On imx53, VPU depends on OCRAM clock, even when VPU does not use OCRAM.
> 
> So if the VPU depends on OCRAM the VPU should be enabling the OCRAM
> clock.  The function of a given clock isn't terribly relevant, and
> certainly grouping clocks together doesn't seem to be the obvious
> solution from what you've said
VPU don't know OCRAM clk, it's SoC specific. I know it's clock function
replationship. But it's the only better place to refect the dependency 
in clock tree. Another dependency example, from SoC bus topology, some bus
clk always depends on bus switch/hub.
> - if the driver doesn't know about the
> clock it seems like the core ought to be enabling it transparently
> rather than gluing it together with some other random clock.
If you mean clk core here, then we need things like below:
struct clk_hw {
	struct clk *clk;
	struct dependency {
		struct clk_hw *clks;
		int count;
	};
};
Though Mike does not like to add things in clk_hw, but it's the only place
to put common things of clk drivers.

Thanks
Richard
> 
> Either way the point here is that individual drivers shouldn't be hand
> coding this stuff, it should be being handled by core code.
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

