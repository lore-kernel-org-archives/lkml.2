Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab2HXCrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 22:47:39 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:46607
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751052Ab2HXCrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 22:47:35 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Izz1202h1082kzzz2dh2a8h668h839h944hd25hf0ah107ah1155h)
Date: Fri, 24 Aug 2012 10:28:09 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linus.walleij@stericsson.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lrg@ti.com" <lrg@ti.com>, Zhao Richard-B20223 <B20223@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
Subject: Re: [PATCH 1/7] mfd: add imx syscon driver based on regmap
Message-ID: <20120824022807.GA5822@shlinux2.ap.freescale.net>
References: <1345619928-15446-1-git-send-email-b29396@freescale.com>
 <1345619928-15446-2-git-send-email-b29396@freescale.com>
 <20120822160241.GR7995@opensource.wolfsonmicro.com>
 <20120823072629.GG10057@shlinux2.ap.freescale.net>
 <20120823110647.GU7995@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120823110647.GU7995@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 07:06:47PM +0800, Mark Brown wrote:
> On Thu, Aug 23, 2012 at 03:26:30PM +0800, Dong Aisheng wrote:
> > On Thu, Aug 23, 2012 at 12:02:41AM +0800, Mark Brown wrote:
> 
> > > It'd be good to provide a way of retrieving the regmap so that drivers
> > > for subsystems with generic regmap code could use the framework features
> > > (regulator is one example that I just mentioned in my other mail).
> 
> > Do you mean something like:
> > regmap = syscon_regmap_dev_lookup(np, "fsl,anatop");
> > regmap_write(regmap, reg, val);
> 
> > Then drivers can use generic regmap framework features rather than depend
> > on what imx-syscon implemented, is that correct?
> 
> Yes, this is mainly for cases where the subsystem has helper functions
> that can work with regmap.

Okay, then imx-syscon only implements regmap register mechanism and regmap
lookup mechanism, for accessors, client driver can directly use the generic
regmap API defined in include/linux/regmap.h.

Then it looks to me the driver is more like a generic feature which may also be
needed for other SoCs, IIRC, Tegra ahb and ux500 PRCMU,

Do you think if we should implement it in a more generic way at first?
e.g, drop 'imx-' prefix first.

Linus,
You're the first guy to raise the idea that we could implement a syscon
framework to generic register access, what's your comment on this?

Regards
Dong Aisheng

