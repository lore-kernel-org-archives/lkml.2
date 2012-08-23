Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933204Ab2HWGMH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 02:12:07 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:23698
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933135Ab2HWGMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 02:12:05 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1202hzz8275dhz2dh2a8h668h839h944hd25hf0ah107ah1155h)
Date: Thu, 23 Aug 2012 14:12:03 +0800
From: Richard Zhao <richard.zhao@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dong Aisheng <b29396@freescale.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linus.walleij@stericsson.com>,
        <s.hauer@pengutronix.de>, <shawn.guo@linaro.org>,
        <kernel@pengutronix.de>, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <sameo@linux.intel.com>, <lrg@ti.com>,
        <broonie@opensource.wolfsonmicro.com>,
        <devicetree-discuss@lists.ozlabs.org>, <paul.liu@linaro.org>
Subject: Re: [PATCH 4/7] regulator: anatop-regulator: convert to use
 imx-syscon to access anatop register
Message-ID: <20120823061202.GM4011@b20223-02.ap.freescale.net>
References: <1345619928-15446-1-git-send-email-b29396@freescale.com>
 <1345619928-15446-5-git-send-email-b29396@freescale.com>
 <5035BDBF.9020602@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5035BDBF.9020602@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 11:21:03PM -0600, Stephen Warren wrote:
> On 08/22/2012 01:18 AM, Dong Aisheng wrote:
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> 
> > diff --git a/drivers/regulator/anatop-regulator.c b/drivers/regulator/anatop-regulator.c
> 
> > @@ -109,7 +110,11 @@ static int __devinit anatop_regulator_probe(struct platform_device *pdev)
> >  	rdesc->ops = &anatop_rops;
> >  	rdesc->type = REGULATOR_VOLTAGE;
> >  	rdesc->owner = THIS_MODULE;
> > -	sreg->mfd = anatopmfd;
> > +
> > +	sreg->anatop = of_parse_phandle(np, "fsl,anatop", 0);
> > +	if (!sreg->anatop)
> > +		return -ENODEV;
> 
> In fact, that imx_syscon_lookup function I proposed could even do the
> of_parse_phandle() internally, so perhaps:
> 
> foo->syscon_dev = imx_syscon_lookup(np, "fsl,anatop", 0);
> if (IS_ERR(foo->syscon_dev))
>     return PTR_ERR(foo->syscon_dev);
> 
> with imx_syscon_lookup() internally knowing when to return EPROBE_DEFER
> rather than any other permanent error code (e.g. for missing property,
> bad phandle, etc.)
In some case that we access register in machine code, we don't have any
phandler. The node is got by find compatible or by path.

Thanks
Richard 

