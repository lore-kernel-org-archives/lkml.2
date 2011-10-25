Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab1JYG5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 02:57:41 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:58791
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353Ab1JYG5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 02:57:40 -0400
X-SpamScore: -12
X-BigFish: VS-12(zz9371K1432N98dKzz1202hzzz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 0,
Date: Tue, 25 Oct 2011 15:08:39 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rajendra Nayak <rnayak@ti.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>, <patches@linaro.org>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <lrg@ti.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111025070837.GE2119@S2100-06.ap.freescale.net>
References: <20111021082309.GA337@S2100-06.ap.freescale.net>
 <20111024092411.GE8708@ponder.secretlab.ca>
 <20111024130429.GD1755@S2100-06.ap.freescale.net>
 <20111024130636.GB26033@opensource.wolfsonmicro.com>
 <20111024134025.GE1755@S2100-06.ap.freescale.net>
 <20111024135950.GV8708@ponder.secretlab.ca>
 <20111024145139.GH1755@S2100-06.ap.freescale.net>
 <20111024145631.GB8708@ponder.secretlab.ca>
 <20111024155132.GI1755@S2100-06.ap.freescale.net>
 <4EA652DA.5050901@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EA652DA.5050901@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 11:40:34AM +0530, Rajendra Nayak wrote:
> On Monday 24 October 2011 09:21 PM, Shawn Guo wrote:
> >On Mon, Oct 24, 2011 at 04:56:31PM +0200, Grant Likely wrote:
[...]
> >>It is always better to attach the of_node at struct device
> >>registration time instead of searching the tree in common code.  The
> >>of_node should already be assigned by the time regulator_register() is
> >>called.
> >
> >That's the problem we have.  There is no 'struct dev' to attach of_node
> >for each regulator by the time regulator_register() is called, because
> >the 'struct dev' for each regulator is created inside
> >regulator_register() as wrapped by 'struct regulator_dev'.
> 
> The root of your problem seems to be that your pmic driver isn't
> registering regulator devices from DT, and if it did, you wouldn't
> need to do a search in dev->parent->of_node and instead the driver
> would have the right dev->of_node populated.
> 
No, it's not the root of my problem.  Again, we are talking about
'Case 2', where multiple regulator devices are registered to
regulator core with regulator driver being probed once, where each
regulator node is taken as the child of 'regulators' node.  Having
device_node of 'regulators' attached to dev->of_node does not help
at all.  What we need is to have each child node attached to
regulator_dev->dev.of_node.

-- 
Regards,
Shawn

