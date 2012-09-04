Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab2IDMIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 08:08:18 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:57262
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756818Ab2IDMIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 08:08:16 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI168aJ1432Izz1202h1082kzzz2dh2a8h668h839h944hd25hf0ah107ah1220h1155h)
Date: Tue, 4 Sep 2012 19:46:02 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Andi Shyti <andi@etezian.org>
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
	<devicetree-discuss@lists.ozlabs.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
Subject: Re: [PATCH v5 1/4] mfd: add syscon driver based on regmap
Message-ID: <20120904114601.GB13046@shlinux2.ap.freescale.net>
References: <1346728811-25788-1-git-send-email-b29396@freescale.com>
 <1346728811-25788-2-git-send-email-b29396@freescale.com>
 <20120904113545.GD4657@jack.whiskey>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120904113545.GD4657@jack.whiskey>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 07:35:45PM +0800, Andi Shyti wrote:
> Hi Dong,
> 
> On Tue, Sep 04, 2012 at 11:20:08AM +0800, Dong Aisheng wrote:
> > +static int __devinit syscon_probe(struct platform_device *pdev)
> > +{
> > +	struct device *dev = &pdev->dev;
> 
> Do we really need this variable? Anyway you are using it only
> once in the dev_info.
> 
Okay, i can remove it.

> > +	struct device_node *np = dev->of_node;
> > +	struct syscon *syscon;
> > +	struct resource res;
> > +	int ret;
> > +
> > +	if (!np)
> > +		return -ENOENT;
> > +
> > +	syscon = devm_kzalloc(&pdev->dev, sizeof(struct syscon),
> > +			    GFP_KERNEL);
> > +	if (!syscon)
> > +		return -ENOMEM;
> > +
> > +	syscon->base = of_iomap(np, 0);
> > +	if (!syscon->base)
> > +		return -EADDRNOTAVAIL;
> > +
> > +	ret = of_address_to_resource(np, 0, &res);
> > +	if (ret)
> > +		return ret;
> > +
> > +	syscon_regmap_config.max_register = res.end - res.start - 3;
> > +	syscon->regmap = devm_regmap_init_mmio(&pdev->dev, syscon->base,
> > +					&syscon_regmap_config);
> > +	if (IS_ERR(syscon->regmap)) {
> > +		dev_err(&pdev->dev, "regmap init failed\n");
> > +		return PTR_ERR(syscon->regmap);
> > +	}
> > +
> > +	syscon->dev = &pdev->dev;
> > +	platform_set_drvdata(pdev, syscon);
> > +
> > +	dev_info(dev, "syscon regmap start 0x%x end 0x%x registered\n",
> > +		res.start, res.end);
> > +
> > +	return 0;
> 
> in case of error you are not freeing syscon.
Do we need it for managed resource of syscon?

> Moreover, in my opinion, some dev_err more should not heart
> 
There's no much error cases here, most of them rarely fails and i don't feel
we really need add.
I don't know what dev_err you suggested to add?

Regards
Dong Aisheng

