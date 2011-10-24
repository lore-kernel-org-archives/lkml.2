Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859Ab1JXPkw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 11:40:52 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:26557
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932390Ab1JXPkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 11:40:51 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,13,
Date: Mon, 24 Oct 2011 23:51:33 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rajendra Nayak <rnayak@ti.com>, <patches@linaro.org>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <lrg@ti.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111024155132.GI1755@S2100-06.ap.freescale.net>
References: <20111020061408.GE32007@S2100-06.ap.freescale.net>
 <4EA00F7C.1080005@ti.com>
 <20111021082309.GA337@S2100-06.ap.freescale.net>
 <20111024092411.GE8708@ponder.secretlab.ca>
 <20111024130429.GD1755@S2100-06.ap.freescale.net>
 <20111024130636.GB26033@opensource.wolfsonmicro.com>
 <20111024134025.GE1755@S2100-06.ap.freescale.net>
 <20111024135950.GV8708@ponder.secretlab.ca>
 <20111024145139.GH1755@S2100-06.ap.freescale.net>
 <20111024145631.GB8708@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111024145631.GB8708@ponder.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 04:56:31PM +0200, Grant Likely wrote:
> On Mon, Oct 24, 2011 at 10:51:40PM +0800, Shawn Guo wrote:
> > On Mon, Oct 24, 2011 at 03:59:50PM +0200, Grant Likely wrote:
> > > On Mon, Oct 24, 2011 at 09:40:26PM +0800, Shawn Guo wrote:
> > > > diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> > > > index 8fe132d..29dcf90 100644
> > > > --- a/drivers/regulator/core.c
> > > > +++ b/drivers/regulator/core.c
> > > > @@ -2673,7 +2673,8 @@ struct regulator_dev *regulator_register(struct regulator_desc *regulator_desc,
> > > >         BLOCKING_INIT_NOTIFIER_HEAD(&rdev->notifier);
> > > > 
> > > >         /* find device_node and attach it */
> > > > -       rdev->dev.of_node = of_find_node_by_name(NULL, regulator_desc->name);
> > > > +       rdev->dev.of_node = of_find_node_by_name(dev->parent->of_node,
> > > > +                                                regulator_desc->name);
> > > 
> > > of_find_node_by_name() doesn't work that way.  The first argument is a
> > > starting point, but it doesn't restrict the search to children of a
> > > node.
> > > 
> > > for_each_child_of_node() is what you want to use when iterating over
> > > the children which unfortunately changes the structure of this
> > > function.
> > > 
> > The dev->parent->of_node is meant to point to node 'pmic: mc13892@0'.
> > And the intention here is not to iterate over the children, but to
> > start a search from a reasonable point rather than the top root node.
> 
> It is always better to attach the of_node at struct device
> registration time instead of searching the tree in common code.  The
> of_node should already be assigned by the time regulator_register() is
> called.

That's the problem we have.  There is no 'struct dev' to attach of_node
for each regulator by the time regulator_register() is called, because
the 'struct dev' for each regulator is created inside
regulator_register() as wrapped by 'struct regulator_dev'.

-- 
Regards,
Shawn

