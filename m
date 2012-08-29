Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2H2CVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 22:21:37 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:16419
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752853Ab2H2CVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 22:21:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zzbb2dI98dI9371I1432I1447Izz1202h1082kzz8275dhz2dh2a8h668h839h944hd25hf0ah107ah1220h1155h)
Date: Wed, 29 Aug 2012 10:00:50 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
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
        "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        Zhao Richard-B20223 <B20223@freescale.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v3 1/7] mfd: add syscon driver based on regmap
Message-ID: <20120829020049.GA29464@shlinux2.ap.freescale.net>
References: <1346145005-17961-1-git-send-email-b29396@freescale.com>
 <1346145005-17961-2-git-send-email-b29396@freescale.com>
 <503D4C08.8040605@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <503D4C08.8040605@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 06:54:00AM +0800, Stephen Warren wrote:
> On 08/28/2012 02:09 AM, Dong Aisheng wrote:
> > From: Dong Aisheng <dong.aisheng@linaro.org>
> > 
> > Add regmap based syscon driver.
> > This is usually used for access misc bits in registers which does not belong
> > to a specific module, for example, IMX IOMUXC GPR and ANATOP.
> > With this driver, client can use generic regmap API to access registers
> > which are registered into syscon.
> 
> > diff --git a/Documentation/devicetree/bindings/mfd/syscon.txt b/Documentation/devicetree/bindings/mfd/syscon.txt
> 
> > +* System Controller Registers R/W driver
> 
> I think the binding document could use some information about what a
> "syscon" actually is, especially since the compatible value is something
> generic like "syscon" rather than something with a vendor-specific
> prefix.
Yes, we'd better have it.

> How about:
> 
> A system controller node represents a register region containing a set
> of miscellaneous registers. The registers are not cohesive enough to
> represent as any specific type of device. The typical use-case is for
> some other node's driver, or platform-specific code, to acquire a
> reference to the syscon node (e.g. by phandle, node path, or search
> using a specific compatible value), interrogate the node (or associated
> OS driver) to determine the location of the registers, and access the
> registers directly.
> 
It looks very good to me.
Thanks for the help.

> > +Required properties:
> > +- compatible: Should contain "syscon".
> > +- reg: the register range can be access from syscon
> > +
> > +Examples:
> > +gpr: iomuxc-gpr@020e0000 {
> > +	compatible = "fsl,imx6q-iomuxc-gpr", "syscon";
> > +	reg = <0x020e0000 0x38>;
> > +};
> 
> > diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> 
> > +config MFD_SYSCON
> > +        bool "System Controller Register R/W Based on Regmap"
> > +        select REGMAP_MMIO
> > +        help
> > +          Select this option to enable accessing system control registers
> > +	  via regmap.
> 
> I think the indentation is off there.
> 
You're right.
Will fix it.

> > +static int __devinit syscon_probe(struct platform_device *pdev)
> ...
> > +	regcache_cache_only(syscon->regmap, false);
> 
> Isn't that the default?
> 
Correct, will remove.

> Aside from that, I don't have any particular comments on this series, so
> please consider it,
> 
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> 
Thanks a lot.

Regards
Dong Aisheng

