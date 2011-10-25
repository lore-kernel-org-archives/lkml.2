Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931Ab1JYHcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:32:48 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:41305
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930Ab1JYHcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:32:46 -0400
X-SpamScore: -11
X-BigFish: VS-11(zz9371K1432N98dKzz1202hzz8275eha1495iz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Tue, 25 Oct 2011 15:42:46 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rajendra Nayak <rnayak@ti.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        <broonie@opensource.wolfsonmicro.com>, <patches@linaro.org>,
        <tony@atomide.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <lrg@ti.com>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract
 regulator_init_data
Message-ID: <20111025074245.GH2119@S2100-06.ap.freescale.net>
References: <20111024090228.GA1755@S2100-06.ap.freescale.net>
 <4EA52851.8000203@ti.com>
 <20111024091158.GB1755@S2100-06.ap.freescale.net>
 <4EA52C56.3080908@ti.com>
 <20111024134727.GF1755@S2100-06.ap.freescale.net>
 <4EA65073.7050205@ti.com>
 <20111025065216.GD2119@S2100-06.ap.freescale.net>
 <4EA65D81.6030109@ti.com>
 <20111025072003.GF2119@S2100-06.ap.freescale.net>
 <4EA661B3.6010006@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EA661B3.6010006@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 12:43:55PM +0530, Rajendra Nayak wrote:
> On Tuesday 25 October 2011 12:50 PM, Shawn Guo wrote:
> >On Tue, Oct 25, 2011 at 12:26:01PM +0530, Rajendra Nayak wrote:
> >>On Tuesday 25 October 2011 12:22 PM, Shawn Guo wrote:
> >>>On Tue, Oct 25, 2011 at 11:30:19AM +0530, Rajendra Nayak wrote:
> >[...]
> >>>>Thats what we did for OMAP, and hence we always have the of_node
> >>>>populated when the regulator devices are probed.
> >>>>See this patch from Benoit on how thats done for twl devices..
> >>>>http://marc.info/?l=linux-omap&m=131489864814428&w=2
> >>>>
> >>>OMAP is "Case 1", and we are talking about "Case 2".
> >>
> >>I don't see why it wouldn't work for "Case 2".
> >
> >I did not say it wouldn't work for "Case 2".  I meant they work in
> >different way.
> >
> >>The only difference
> >>is in case of "Case 1", the dev->of_node would already point to
> >>the right regulator node, like 'reg1', 'reg2' above.
> >>In case of "Case 2", the dev->of_node would point to the 'regulators'
> >>node instead, and the driver could then do a for_each_child_of_node()
> >>to iterate over all its children to get 'reg1', 'reg2' etc.
> >>
> >Yes, that's the difference.  So you will need to distinguish these
> >two cases in regulator_register()?  How?
> 
> You don't need to distinguish these cases in regulator_register().
> The driver knows if its handling "Case 1" devices or "Case 2" devices
> and it needs to handle things accordingly and pass the right of_node
> which regulator_register() can then attach to regulator_dev->dev.
> 
Ah, you are thinking about (for Case 2) calling for_each_child_of_node()
in regulator driver and passing the of_node found for each regulator to
regulator core as a new parameter of regulator_register().  Yes, that
would work, though my thought is to put the device_node discovery in
regulator core and hide it from regulator driver.

Okay, I'm good with this solution.  Grant, Mark, what about you?

-- 
Regards,
Shawn

